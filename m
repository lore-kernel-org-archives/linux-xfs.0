Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DAMkD1047638 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 05:22:46 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1A8E4B32B9
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 03:23:12 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id oX3mRMXO7NLGte7T
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 03:23:12 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 078D96C3E2
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 05:23:11 -0500 (CDT)
Message-ID: <4C651E2B.9010100@hardwarefreak.com>
Date: Fri, 13 Aug 2010 05:27:55 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Alignment size?
References: <4C64715F.8060000@msgid.tls.msk.ru>	<20100812234911.GC10429@dastard>
	<4C64E52E.2060806@msgid.tls.msk.ru>
In-Reply-To: <4C64E52E.2060806@msgid.tls.msk.ru>
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
To: xfs@oss.sgi.com

Michael Tokarev put forth on 8/13/2010 1:24 AM:

> So the question that remains is: why?

4096 is the default block size and has been since at least 2.6.26 when I
started using XFS.  From "man mkfs.xfs":

OPTIONS
-b block_size_options
This  option  specifies the fundamental block size of the filesystem.  The
valid block_size_options are: log=value or size=value and only one can be
supplied.  The block size is specified either as a base two logarithm value
with log=, or in  bytes  with size=.  The default value is 4096 bytes (4 KiB),
the minimum is 512, and the maximum is 65536 (64 KiB).  XFS on Linux currently
only supports pagesize or smaller blocks.

> So why xfs decided the block size is 4K??

See above.  It's the default.  Dave, Eric, Alex and others may be able to
explain why 4096 was chosen as the default.  I'm guessing it has to do with
the best all around performance across a wide variety of storage systems.

> And a related question, -- is there a way to create
> xfs fs with the right sector size?

Yes.

-s sector_size
This option specifies the fundamental sector size of the filesystem.  The
sector_size is specified  either as a value in  bytes  with size=value or as a
base two logarithm value with log=value.  The default sector_size is 512
bytes. The minimum value for sector size is 512; the maximum is 32768 (32
KiB). The sector_size must be a power of 2 size and cannot be made larger than
the filesystem block size.

Note that the default is 512.  This would lead me to believe that whoever
created this 600GB XFS filesystem manually specified "-s 4096" on the command
line when creating it.

> The filesystem
> were ok in years, not only on this machine, and I'm
> quite afraid to replace it with something else (e.g.
> ext4) in a hurry without good prior testing.
> 
> By the way, how one can check the "sector size" of a
> block device nowadays?

cat /sys/block/[device]/queue/hw_sector_size

That will give you the hardware sector size.  As mentioned above, the XFS
sector size can be manually specified during FS creation.  Thus they may not
match, which is likely the case with the 600GB FS you're having the problems with.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
