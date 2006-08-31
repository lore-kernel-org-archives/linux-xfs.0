Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 12:38:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7VJc1DW026967
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 12:38:04 -0700
Message-ID: <44F73A65.8050105@sandeen.net>
Date: Thu, 31 Aug 2006 14:37:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS and 3.2TB Partition
References: <44F714F2.7050502@gmail.com>
In-Reply-To: <44F714F2.7050502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Hane <chrishane@gmail.com>
Cc: xfs@oss.sgi.com

Chris Hane wrote:
> 2. PARTED
> 
> I've tried to use parted without any success.  Here is what I've tried 
> and the errors I get.
> 
>  > parted
> parted> mklabel gpt
> parted> mkpart primary 0 3500GB
> parted> quit
> 
> ok  - the partition now exists.  If I use ext2 everything works ok.
> 
> however, when I run
> 
>  > mkfs.xfs /dev/sda1
> 
> the file system is formated but is truncated to to 2TB.

I'd think parted should be able to handle large devices...

mkfs.xfs uses the BLKGETSIZE64 and BLKGETSIZE ioctls to determine device 
size; you might either instrument xfsprogs/libxfs/linux.c and re-run, or 
strace your mkfs command looking for those ioctl calls, to see what size 
it's getting back from the kernel.

-Eric
