Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DAxjJ1050471 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 05:59:46 -0500
Received: from isrv.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1508A4B3541
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 04:00:10 -0700 (PDT)
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231]) by cuda.sgi.com
	with ESMTP id BuGh8xClhg6b745C for <xfs@oss.sgi.com>;
	Fri, 13 Aug 2010 04:00:10 -0700 (PDT)
Message-ID: <4C6525B9.4040406@msgid.tls.msk.ru>
Date: Fri, 13 Aug 2010 15:00:09 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: Alignment size?
References: <4C64715F.8060000@msgid.tls.msk.ru>	<20100812234911.GC10429@dastard>	<4C64E52E.2060806@msgid.tls.msk.ru>
	<4C651E2B.9010100@hardwarefreak.com>
In-Reply-To: <4C651E2B.9010100@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

13.08.2010 14:27, Stan Hoeppner wrote:
> Michael Tokarev put forth on 8/13/2010 1:24 AM:
> 
>> So the question that remains is: why?
> 
> 4096 is the default block size and has been since at least 2.6.26 when I
> started using XFS.  From "man mkfs.xfs":
> 
> OPTIONS
> -b block_size_options

This is block size.  But XFS_IOC_DIOINFO returns
_sector_ size.  All other XFS filesystems we have
are made with the same 4096 _block_ size.

> [..]  The default value is 4096 bytes (4 KiB)
> 
>> So why xfs decided the block size is 4K??

That was the wrong question.  The right one is
about _sector_ size, not _block_ size.
The filesystem in question has _sector_ size =4096,
all the rest has it =512.

>> And a related question, -- is there a way to create
>> xfs fs with the right sector size?
> 
> Yes.
> 
> -s sector_size
> This option specifies the fundamental sector size of the filesystem.  The
> sector_size is specified  either as a value in  bytes  with size=value or as a
> base two logarithm value with log=value.  The default sector_size is 512

Yeah, the default is 512, my manpage agrees.  But yet
I've a filesystem that has it =4096...

But maybe it were specified during filesystem creation.
I re-read the mkfs.xfs manpage yesterday, but somehow
missed the sector size option (!), which you quoted
above.  Maybe we used it year ago when creating the
filesystem, for yet to be determined reason... ;)

I just tried to create an xfs filesystem on this
machine (on a small reserved partition) - it uses
sector size = 512 as expected.

>> By the way, how one can check the "sector size" of a
>> block device nowadays?
> 
> cat /sys/block/[device]/queue/hw_sector_size

And it shows 512 even for the md array in question.

> That will give you the hardware sector size.  As mentioned above, the XFS
> sector size can be manually specified during FS creation.  Thus they may not
> match, which is likely the case with the 600GB FS you're having the problems with.

Yup!

Thank you all for the information, and please excuse
me for the noize - just too many stuff at once... ;)

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
