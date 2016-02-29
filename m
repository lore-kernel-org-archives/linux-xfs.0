Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B97E529E12
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 08:29:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8AF9830404E
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:29:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7DInGj3TSQhwxaeE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:29:32 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id B6CA3C0B78A0
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 14:29:31 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-22.bos.redhat.com [10.18.41.22])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u1TETVG9005216
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 09:29:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/3] fix up indlen reservations on extent split
Date: Mon, 29 Feb 2016 09:29:27 -0500
Message-Id: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
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

This is a resurrection of an old fix for the indirect delalloc
reservation split problem. The last version apparently fell through the
cracks. The core problem and fix is the same and is described in patch
3.

The original problem is not as reproducible as it was since the last
version of this patch. The original zero range reproducer doesn't work
because zero range has since been updated to flush and invalidate the
affected range rather than kill any delayed allocation blocks in the in
core extent tree. The side effect of this is that the problem does not
currently have a clear reproducer, but the indirect reservation
management code is still incorrect nonetheless.

As a result, I've prepended an RFC test instrumentation patch that can
help induce the problem[1]. I've marked the patch RFC simply because it
is hacky and probably up in the air as to whether it is merge worthy. I
wanted to have _something_ to help reproduce the problem and verify the
fix, however, hence it is included here. I'm fine with either merging it
or using it as a one-off verification and dropping it. Also, any other
ideas for a more simple/elegant reproducer are welcome.

Thoughts, reviews, flames appreciated.

Brian

[1] An update to the original xfstests test is also required. I'll send
that update in a reply to this cover letter shortly.

v2:
- Rebase to latest for-next branch.
- Include RFC test instrumentation patch.
v1: http://oss.sgi.com/archives/xfs/2014-10/msg00294.html
- xfs_bunmapi() code into independent patch.
- Refactor fix into separate helper function.
rfc: http://oss.sgi.com/archives/xfs/2014-09/msg00337.html

Brian Foster (3):
  xfs: debug mode forced buffered write failure
  xfs: update icsb freeblocks counter after extent deletion
  xfs: borrow indirect blocks from freed extent when available

 fs/xfs/libxfs/xfs_bmap.c | 158 ++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_aops.c        |   9 ++-
 fs/xfs/xfs_mount.h       |   9 +++
 fs/xfs/xfs_sysfs.c       |  78 ++++++++++++++++++++---
 4 files changed, 200 insertions(+), 54 deletions(-)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
