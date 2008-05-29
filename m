Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 07:57:15 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TEvBNI015041
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 07:57:12 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 804DC17533DD
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 07:58:02 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id rC8A0cyraTyZjEyG for <xfs@oss.sgi.com>; Thu, 29 May 2008 07:58:02 -0700 (PDT)
Date: Fri, 30 May 2008 00:57:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: free space problem
Message-ID: <20080529145759.GA5134@disturbed>
References: <20080529125509.136aa653@harpe.intellique.com> <20080529132624.E3CDCC0D418@cuda.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080529132624.E3CDCC0D418@cuda.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Cc: 'Emmanuel Florac' <eflorac@intellique.com>, xfs@oss.sgi.com

On Thu, May 29, 2008 at 03:26:16PM +0200, Huszár Viktor Dénes wrote:
> YES! Finally the problem is solved! Thank you Emmanuel and everyone else!
> After adding inode64 to the mount option [only umount and mount worked, with
> remount it didn't] it works. Although the icount and ifree numbers have not
> changed, we can write to the disk. 
> 
> Hope this will help anyone who encounters this problem. In the xfs man and
> debian docs we could not find anything about this inode64, so thank you once
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

	Indicates that XFS is allowed to create inodes at any location in the
	filesystem,  including  those which will result in inode numbers occupying more
	than 32 bits of significance.  This is provided for backwards compatibility,
	but causes problems for backup applications that cannot handle large inode
	numbers.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
