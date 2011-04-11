Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3BHZgbJ103218
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 12:35:42 -0500
Received: from mail.1-click.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id EEDB03C4276
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 10:39:01 -0700 (PDT)
Received: from mail.1-click.hu (ns2.netcenter.hu [195.228.155.139]) by
	cuda.sgi.com with SMTP id gKFWNf6ENKJpW2AL for
	<linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 10:39:01 -0700 (PDT)
Received: from myXP (unknown [195.228.155.202])
	by mail.1-click.hu (Postfix) with ESMTP id EE4B71FCD3D
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 19:34:37 +0200 (CEST)
Message-ID: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: 2 question about XFS fragmentation and _fsr
Date: Mon, 11 Apr 2011 19:39:07 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hello list,

First, please CC me because i am not on the list.

Question 1:
I am working in a data recovery company, and we are using one 3TB RAID 
storage with XFS to store the recovery cases in image files.
For spare a lot of space, usually we are imaging only the used spaces of the 
filesystems. (for example 1TB system drive wich have only 80GB data inside 
but needs to be bootable, the image is similar like Ghost images)
But this makes a lot of sparse files, wich right should be this way.
Some cases are done and we are closed (image can be deleted), and some needs 
to store for long time.
In the result, actually we have >6TB images on the 3TB disk, wich is 97.9% 
fragmented.
Basically the sparse RAW disk images should be more faster accessible than 
the original drive, because this is 4disk raid, instead of one, AND the head 
don't need to travel through the empty space of the drive...
But actually we are proud if we can read or write in 8-10MB/s! :-D
I have started to read about xfs_fsr but there is almost none information, 
how it is _really_ working, and i am doubt about this will try to fill up 
all of my images, and therefore fail to do any improvement, or this will do 
the right job and will re-organize the sparse files again.
The XFS_FSR can be good for me or not?
If not, i suggest to implement an option to do sparse fles on the result or 
not in the next releases...
I will say a huge thanks in the end. :-)

Question 2:
One of our customers have one storage wich is exactly the same like the one 
wich is described on the Q1, but only used for samba storage for storing 
media files (big files.)
I am sure, there is no torrent or similar, and i have told to the customers 
on the beginning "don't write more files parallel, to avoid fragmentation", 
but today the storage is >95% fragmented.
The customer sad, he only does file write one by one, and nothing more.
How can this be?

Thanks for your attention,

Best regards,
Janos Haar 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
