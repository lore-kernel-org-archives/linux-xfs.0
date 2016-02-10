Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BB247CA3
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 02:47:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E268B304039
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 00:47:56 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	81QD4SpjCd3MDx7R for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 00:47:55 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aTQQo-0005Bf-7L
	for xfs@oss.sgi.com; Wed, 10 Feb 2016 19:47:26 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aTQQo-0002aI-6Y
	for xfs@oss.sgi.com; Wed, 10 Feb 2016 19:47:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8 v4] xfs: get rid of xfs_cluster_write
Date: Wed, 10 Feb 2016 19:47:15 +1100
Message-Id: <1455094043-9694-1-git-send-email-david@fromorbit.com>
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


Hi folks,

This is the 4th version of this series to followup on review
comments from Brian and Christoph. There are three new patches in
this series. Patch 2/8 is split out from patch 3/8 to document the
removal of the ioend cancelling code, spearate from the introduction
of the writepage context. Patches 7 and 8 are new patches (as in the
first time I've posted them) to demonstrate how to remove the IO
completion dependency on recording the bufferehads attached to the
ioend. This is the first step in removing bufferheads from the
writepage IO path - these are FYI patches, not patches I want to
have committed immediately.

The changes all run through xfstests on 4k and 1k block size
filesystems fine, and I think i addressed all the review comments.
Patch 6/8 changed enough that I removed Brian's reviewed-by from it
and so it will need to be looked at completely again.

-Dave.

Version 4:
- split xfs_ioend_cancel removal into it's own patch (patch 2)
- cleaned up submission of ioends to be consistent w.r.t. success
  and error paths (patch 3)
- made variables names less verbose (patch 6)
- got rid of xfs_writepage_submit() (patch 6)
- use a struct list_head for ioend chaining (patch 6)
- consolidated ioend submission paths to use common code (patch 6)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
