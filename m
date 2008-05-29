Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 10:36:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4THajng030116
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:36:46 -0700
Received: from server.dwo.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5DFE11A00C6
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:37:37 -0700 (PDT)
Received: from server.dwo.hu (server.dwo.hu [87.229.110.63]) by cuda.sgi.com with ESMTP id nLp8HUyjv63L7muY for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:37:37 -0700 (PDT)
From: =?iso-8859-2?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Subject: RE: free space problem
Date: Thu, 29 May 2008 19:37:06 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
In-Reply-To: <20080529145759.GA5134@disturbed>
Message-Id: <20080529173737.E5DFE11A00C6@cuda.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Dave Chinner' <david@fromorbit.com>
Cc: 'Emmanuel Florac' <eflorac@intellique.com>, xfs@oss.sgi.com

Thank you, now I found it as well. I cant believe I missed this! Emmanuel :)
we solved the problem temporarily by increasing the free space to 100 GB,
however, we had no idea it has anything to do with the number of icount or
ifree.

Dave, thanks as well.

Vic

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Thursday, May 29, 2008 4:58 PM
To: Huszár Viktor Dénes
Cc: 'Emmanuel Florac'; xfs@oss.sgi.com
Subject: Re: free space problem

On Thu, May 29, 2008 at 03:26:16PM +0200, Huszár Viktor Dénes wrote:
> YES! Finally the problem is solved! Thank you Emmanuel and everyone else!
> After adding inode64 to the mount option [only umount and mount worked,
with
> remount it didn't] it works. Although the icount and ifree numbers have
not
> changed, we can write to the disk. 
> 
> Hope this will help anyone who encounters this problem. In the xfs man and
> debian docs we could not find anything about this inode64, so thank you
once
> again for the help!!!! 

I can think of two places off the top of my head where it is
documented:

Documentation/filesystems/xfs.txt in your local kernel source tree:

  inode64
        Indicates that XFS is allowed to create inodes at any location
        in the filesystem, including those which will result in inode
        numbers occupying more than 32 bits of significance.  This is
        provided for backwards compatibility, but causes problems for
        backup applications that cannot handle large inode numbers.

$ man 8 mount

  inode64

	Indicates that XFS is allowed to create inodes at any location in
the
	filesystem,  including  those which will result in inode numbers
occupying more
	than 32 bits of significance.  This is provided for backwards
compatibility,
	but causes problems for backup applications that cannot handle large
inode
	numbers.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


__________ Information from ESET NOD32 Antivirus, version of virus signature
database 3145 (20080529) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com

 

__________ Information from ESET NOD32 Antivirus, version of virus signature
database 3145 (20080529) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com
 
