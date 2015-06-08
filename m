Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 34BFB7F4E
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 06:29:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6412AC004
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 04:29:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7S4V82s9ElWxJQwG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2015 04:29:26 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 9C8B5A0E6F
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 11:29:25 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t58BTPlW027125
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2015 07:29:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] xfsprogs/repair: sparse inode chunks cleanups
Date: Mon,  8 Jun 2015 07:29:20 -0400
Message-Id: <1433762964-11502-1-git-send-email-bfoster@redhat.com>
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

This is a small cleanup series for some of the repair code touched by
the sparse inode chunks feature, in response to review comments in the
following thread:

	http://oss.sgi.com/archives/xfs/2015-06/msg00053.html

It primarily creates a few helper functions for hunks of code executed
multiple times or code that is common between the increasingly similar
but separate inobt and finobt record scanning code. For much of the
latter code, the only difference between the separate functions is the
error message output to indicate which tree is affected by a problem.
Therefore, I abstracted out the inobt name and factored out some helpers
that can perform the appropriate checks regardless of the tree type.

This series is purely cleanup and should not alter functionality in any
way. Thoughts?

Brian

Brian Foster (4):
  repair: access helpers for on-disk inobt record freecount
  repair: helper for inode chunk alignment and start/end ino number
    verification
  repair: helper to import on-disk inobt records to in-core trees
  repair: helper to transition inode blocks to inode state

 repair/dino_chunks.c |  91 ++++++-------
 repair/incore.h      |  28 ++++
 repair/phase5.c      |  12 +-
 repair/scan.c        | 377 +++++++++++++++++++++++++--------------------------
 4 files changed, 259 insertions(+), 249 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
