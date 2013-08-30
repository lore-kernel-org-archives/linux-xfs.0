Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 86F757F4E
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 19:24:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7717F304048
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 17:24:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	luVz2RcX1v10MAMG for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 17:24:12 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VFCVA-0000wU-Vt
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 10:23:49 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VFCVA-0004bD-VG
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 10:23:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: defrag support for v5 filesystems
Date: Fri, 30 Aug 2013 10:23:43 +1000
Message-Id: <1377822225-17621-1-git-send-email-david@fromorbit.com>
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

The following 2 patches implement the BMBT owner change transaction
that is necessary to enable the XFS_IOC_SWAPEXT ioctl to operate on
v5 filesystems correctly. The first patch implements the
transactional runtime change, and the second patch implements the
recovery of that change.

Both the run time and recovery code use the same mechanism for
changing the owner field in all the blocks in the BMBT on an inode,
and even though XFS_IOC_SWAPEXT only swaps the data fork, the code
has been written to be fork neutral so if we even need to swap
attribute forks it should just work for that, too.

Further, because the BMBT code uses the generic btree
infrastructure, the btree modification is done as a generic function
as well and so should work for all types of btrees supported by the
generic code. Hence if the need arises we can easily change the
owner of any btree that uses the generic code.

The testing carried out is documented in the description of the
second patch.

AFAIA, this is the only remaining feature that the kernel v5
filesystem implementation didn't support. Hence, with this patchset,
there are no more feature checkboxes that need to be ticked that
would prevent us from removing the experimental tag from it. Testing
is the only remaining gate to removing the tag from the kernel
code...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
