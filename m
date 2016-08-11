Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 052057CA6
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 12:11:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC138304043
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AjKxIAqLuXHneOBd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:10 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 9216246203
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 17:11:09 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-69.bos.redhat.com [10.18.41.69])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7BHB9a7008725
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 13:11:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/5] fix log recovery for v5 superblocks
Date: Thu, 11 Aug 2016 13:11:02 -0400
Message-Id: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

This series addresses a problem with log recovery on v5 superblocks
where log recovery doesn't update the metadata LSN of buffers it writes
out. The v5 superblock metadata LSN recovery ordering logic helps
prevent transient corruption states and works fine in most cases. Since
recovery doesn't update the metadata LSN of buffers it writes out,
however, it introduces the possibility of ordering problems if the
recovery happens to repeat from the beginning (e.g., system crash after
recovery I/O has completed but before the log tail is pushed forward).

This tends to manifest as reports of directory corruption during log
recovery and commonly reproduces in situations where a system is
restarted frequently (e.g., constant/frequent reboot tests). It can be
reproduced fairly easily on demand by running fsstress in a simple
(non-log forcing) shutdown loop, e.g.:

	while [ true ]; do 
		fsstress -d <dir> -p 4 &
		sleep $((RANDOM % 5))
		xfs_io -xc shutdown <dir>
		umount <dir>
		mount <dev> <dir> || break
	done

The problem is that the log attempts to replay a buffer update that is
no longer valid due to subsequent, already replayed updates. This
results in a corruption error when, in fact, the filesystem is perfectly
fine. The problem is addressed by updating the metadata LSN of buffers
submitted for I/O by log recovery. This bit is implemented in patch 4.

Updating metadata LSNs in this manner uncovered another issue in which
log recovery would incorrectly skip modifications from independent
transactions if they happen to share an LSN with a previous transaction
that modified the same buffer (which had already updated the LSN). This
particular problem is addressed in patch 2, which modifies log recovery
to submit buffers on current LSN boundaries rather than transaction
boundaries. The remaining patches fix up some minor issues, refactor a
bit and add some tracepoints.

This has survived a single xfstests run so far but still requires more
regression testing. It has also survived several thousand iterations of
a shutdown test similar to the above that normally reproduces problems
within tens of iterations (xfstests test tbd).

Brian

Brian Foster (5):
  xfs: rework log recovery to submit buffers on LSN boundaries
  xfs: pass current lsn to log recovery buffer validation
  xfs: don't warn on buffers not being recovered due to LSN
  xfs: update metadata LSN in buffers during log recovery
  xfs: log recovery tracepoints to track current lsn and buffer
    submission

 fs/xfs/xfs_log_priv.h    |   3 +-
 fs/xfs/xfs_log_recover.c | 188 +++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_trace.h       |  31 +++++++-
 3 files changed, 163 insertions(+), 59 deletions(-)

-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
