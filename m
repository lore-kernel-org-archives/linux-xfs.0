Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 40DA47CA1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 11:52:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AFC62AC001
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 09:52:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4p6bqeRtaMOQtVO2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2016 09:52:44 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 03BBBB5398
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 16:52:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-179.bos.redhat.com [10.18.41.179])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u5KGqh2U023008
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 12:52:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfsprogs/db: fix up broken multi-record inode chunk
	support
Date: Mon, 20 Jun 2016 12:52:40 -0400
Message-Id: <1466441562-12317-1-git-send-email-bfoster@redhat.com>
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

xfs_db/xfs_check doesn't currently handle filesystems with multi-record
inode chunks correctly. For example, do the following on a 64k page size
arch such as ppc64:

# mkfs.xfs -f -b size=64k <dev>
# xfs_db -c check <dev>
bad magic number 0 for inode 1152
bad magic number 0 for inode 1153
bad magic number 0 for inode 1154
bad magic number 0 for inode 1155
bad magic number 0 for inode 1156
bad magic number 0 for inode 1157
...

This boils down to a regression in the inode record processing code
(scanfunc_ino()) in db/check.c. Specifically, the cblocks value can end
up being zero after it is shifted by mp->m_sb.sb_inopblog (i.e., 64 >> 7
== 0 for an -isize=512 -bsize=64k fs).

The xfs_check sparse inode processing code takes a unique approach from
similar code in other areas such as metadump and repair. This was
sufficiently confusing for me that I decided to start with a revert of
the patch that introduced the regression and follow up with a patch that
updates the inode record processing code to take a similar approach as
used in metadump, for example. This approach processes inode chunks a
cluster at a time on sparse inode enabled filesystems and skips the
regions that are sparse according to the record holemask. The two
patches could probably be squashed into one if that is desired, but I'm
posting separately as it describes my workflow.

This survives my testing thus far on sparse inode filesystems as well as
multi-record chunk configurations. These multi-rec configurations don't
exactly have a high test pass rate ;P but I haven't hit any regressions.
BTW, I have noticed that xfs_check seems to also have memory issues with
quotas on multi-inode-rec fs', but that seems to go much farther back
and may just be a limitation of check.

Brian

Brian Foster (2):
  Revert "xfs_db: make check work for sparse inodes"
  xfs_check: process sparse inode chunks correctly

 db/check.c | 274 +++++++++++++++++++++----------------------------------------
 1 file changed, 92 insertions(+), 182 deletions(-)

-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
