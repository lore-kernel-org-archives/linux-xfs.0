Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 06:25:37 -0700 (PDT)
Received: from zebday.corky.net (corky.net [212.150.53.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SDPStL022169
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 06:25:29 -0700
Received: from [127.0.0.1] (zebday [127.0.0.1])
	by zebday.corky.net (Postfix) with ESMTP id 26C1FEE2C1
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 15:54:57 +0300 (IDT)
Message-ID: <4683ADEB.3010106@corky.net>
Date: Thu, 28 Jun 2007 13:47:39 +0100
From: Just Marc <marc@corky.net>
MIME-Version: 1.0
Subject: xfs_fsr, performance related tweaks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I'm using fsr extensively.

I noticed two things:

1. in xfs_fsr.c:
   if (fsx.fsx_xflags & XFS_XFLAG_NODEFRAG) {
       if (vflag)
           fsrprintf(_("%s: marked as don't defrag, ignoring\n"),
               fname);
       return(0);
   }

This check should be moved above the code that performs a stat on the 
file, to become the first check, this will help reduce redundant stat 
calls for heavily defragged fileystems.   A simple patch is attached for 
that.

2. Files for which 'No improvement will be made' should also be marked 
as no-defrag, this will avoid a ton of extra work in the future.   In my 
particular use case I have many hundreds of thousands of files on each 
volume (xfs_fsr runs in a never ending-loop as new files are constantly 
being added) and once the file is written to disk it is never changed 
again until deletion.   Optionally do this only when a special parameter 
is passed to fsr at command line? (that is, if you think this is not 
appropriate for all scenarios).  

I tried to accomplish this but it proved more difficult than I thought.  
While digging around in the fsr code, I didn't find out how fsr marks 
the file as no-defrag, I'm guessing this is done in kernel code via the 
ioctl that swaps the extents (xfs_swapext) ... Is that correct?

I looked at how the 'io' utility marks files as no-defrag; it calls 
xfsctl(path, fd, XFS_IOC_FSSETXATTR, &attr); -- this requires a path, 
which is not available to me when fsr is run in its default mode which 
traverses all xfs filesystems rather than gets to run on a single file.

Is there a way to extract the path in this case? Or possibly use another 
way to mark the inode as no-defrag without having to need the path -- 
just fd?  Of course this can be done by an external script which parses 
the output of xfs_fsr for these inodes, looks them up and marks them as 
such, but that's pretty messy and very inefficient.  I'd really like to 
do this as cleanly and efficiently as possible.

I would appreciate any feedback you have on this.    Please CC me as I'm 
not on this list.

Thanks!
