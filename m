Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 23:31:43 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5P6Vddo002382
	for <linux-xfs@oss.sgi.com>; Sun, 24 Jun 2007 23:31:40 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1I1cYR-0001SC-5R
	for linux-xfs@oss.sgi.com; Thu, 21 Jun 2007 23:23:35 -0700
Message-ID: <11246839.post@talk.nabble.com>
Date: Thu, 21 Jun 2007 23:23:35 -0700 (PDT)
From: Sandy1 <sundeep.saini@rediffmail.com>
Subject: Wrong Data Pointer-XFS File system
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi,
I am Using SuSe 10.0 with Xfs file system. I am working on a File system
based project. During the initial research in On disk layout of File system
, i found data pointer problem. I was not able to get the data location as
per pointed by "absolute block no." in "xfs_bmbt_rec" extent pointers.

When i create any file in 0th (zero`th) AG in that case i am able to reach
on proper location by using "absolute block no." pointer.

But when i create any file in 1st or in 2nd AG and so on. I never got the
file data at the location pointed by "absolute block no.". I always found
the file data before the the pointed address.

I am not getting any value in Superblock that tells me about difference in
pointer location with actual data.

This value always becomes multiple of the AG number.

Please help to get out from this problem.

Is there any other calculation for finding the data locations.

I am right now consulting the Doument issued by SGI caleed "XFS file system
Structure" 2nd Edition.

Regards

Sandy

-- 
View this message in context: http://www.nabble.com/Wrong-Data-Pointer-XFS-File-system-tf3963002.html#a11246839
Sent from the linux-xfs mailing list archive at Nabble.com.
