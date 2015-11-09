Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5584A7F60
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 14:21:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A4AE8F8033
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 12:21:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oJ6hs9g6Gt7QnLYD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 12:21:17 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 96F55A3816
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 20:21:17 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-67.bos.redhat.com [10.18.41.67])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tA9KLHWn017082
	for <xfs@oss.sgi.com>; Mon, 9 Nov 2015 15:21:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/8] xfs: log recovery torn write detection
Date: Mon,  9 Nov 2015 15:21:07 -0500
Message-Id: <1447100475-33465-1-git-send-email-bfoster@redhat.com>
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

Here's a first real pass at XFS log recovery torn write detection. This
series has been tested via xfstests and via repetitive fsstress/shutdown
sequences followed by simulated CRC errors on log recovery. The latter
testing has proven useful in shaking out a few bugs, but I have still
reproduced fs inconsistency after a couple hundred iterations or so.
That said, I suspect the problems at this point are either actual
logging problems (e.g., all of the EFI/EFD logging patches and whatnot
originated from this kind of testing) or due to the nature of the error
simulation.

In short, it simulates log corruption moreso than torn writes because it
injects errors at recovery time. The log buffers are written
successfully at shutdown time and therefore I believe it's still
possible for the filesystem to have modifications that depend on
committed transactions (which are ultimately skipped if a crc error is
simulated). I've marked this patch RFC for the time being because I'd
like to try and come up with something a bit more deterministic, if
possible (so long as it can be done reasonably simply). For example,
perhaps we can replace it with a similar debug mode that intentionally
corrupts a crc at write time and shuts down the fs on write completion
such that the AIL is not updated and there is less risk of inconsistency
due to writing back metadata items in the "corrupted" log buffer(s).
Anyways, the current patch is included so the current test procedure is
documented, reviewable and repeatable.

Patch 1 is a bug fix for a problem exposed by this mechanism. Patches
2-6 are primarily refactoring and introduce the CRC-check-only log
recovery pass. Patch 7 enables log head/tail torn write detection. Patch
8 implements the DEBUG mode error injection mechanism described above.
Thoughts, reviews, flames appreciated.

Brian

v1:
- Added bug fix for mkfs log record header inconsistency.
- Refactored log recovery code to support a CRC-check-only recovery
  pass.
- CRC verify the last 8 records behind the head to account for
  concurrent log writes.
- Verify the tail of the log as well when the head is torn.
- Added (rfc) crc error injection patch for testing purposes.
rfc: http://oss.sgi.com/pipermail/xfs/2015-July/042415.html

Brian Foster (8):
  xfs: detect and handle invalid iclog size set by mkfs
  xfs: refactor log record unpack and data processing
  xfs: refactor and open code log record crc check
  xfs: return start block of first bad log record during recovery
  xfs: support a crc verification only log record pass
  xfs: refactor log record start detection into a new helper
  xfs: detect and trim torn writes during log recovery
  xfs: debug mode log recovery crc error injection

 fs/xfs/libxfs/xfs_log_recover.h |   1 +
 fs/xfs/xfs_globals.c            |   1 +
 fs/xfs/xfs_log_recover.c        | 646 +++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_sysctl.h             |   1 +
 fs/xfs/xfs_sysfs.c              |  31 ++
 5 files changed, 574 insertions(+), 106 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
