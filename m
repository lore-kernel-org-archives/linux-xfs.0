Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0DBF87F3F
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 22:27:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBF51304032
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 20:27:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	al3woGWJerQnuGqp for <xfs@oss.sgi.com>;
	Sun, 18 Oct 2015 20:27:34 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6 V2] xfs: upfront block zeroing for DAX
Date: Mon, 19 Oct 2015 14:27:12 +1100
Message-Id: <1445225238-30413-1-git-send-email-david@fromorbit.com>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

Hi folks,

This is an updated patch set that was first posted here:

http://oss.sgi.com/archives/xfs/2015-10/msg00006.html

I've dropped the DAX locking revert patch from it; that's on it's
way to Linus via other channels and is essentially independent to
this set of XFS changes.

The only real change in the XFS code between the two versions is the
addition of XFS_TRANS_RESERVE in the DAX path in
xfs_iomap_write_direct() to allow it to dip into the reserve block
pool for unwritten extent conversion rather than reporting ENOSPC.

Patches are against 4.3-rc5 + XFS for-next branch.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
