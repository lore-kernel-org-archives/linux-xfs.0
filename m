Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 862D47F6A
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 18:40:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 213A7AC004
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 16:40:51 -0700 (PDT)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id ZGATGyN2BUt8prJW for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 16:40:50 -0700 (PDT)
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3B15020630
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 23:40:49 +0000 (UTC)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
	[209.85.218.49])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id C49682061D
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 23:40:47 +0000 (UTC)
Received: by oihr66 with SMTP id r66so121875355oih.2
	for <xfs@oss.sgi.com>; Wed, 08 Jul 2015 16:40:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436363862.15921.0.camel@hasee>
References: <1436338913.13729.11.camel@hasee> <20150708085341.GA23332@lst.de>
	<1436363862.15921.0.camel@hasee>
Date: Wed, 8 Jul 2015 16:40:47 -0700
Message-ID: <CAF1ivSYJEraUn_jEOEZg06D36yOYsZNrLz2Vzv=_Umpkao7Otw@mail.gmail.com>
Subject: Re: xfs_io bmap confused
From: Ming Lin <mlin@kernel.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, 2015-07-08 at 06:57 -0700, Ming Lin wrote:
> On Wed, 2015-07-08 at 10:53 +0200, Christoph Hellwig wrote:
> > On Wed, Jul 08, 2015 at 12:01:53AM -0700, Ming Lin wrote:
> > > Hi list,
> > >
> > > I am testing some direct-io patches.
> > > xfs_tests/xfs/080 failed.
> > >
> > > It's strange.
> > > There is no hole in "rwtest.file",
> > > but when read it at some offset it returns zero because of hole.
> > >
> > > root@block:~# xfs_io -c bmap /mnt/test/rwtest.file
> > > /mnt/test/rwtest.file:
> > >              0: [0..125671]: 160..125831
> >
> > Sounds like you see an unwritten extent.  What does xfs_bmap -pv show on
> > the file?
>
> root@block:~# xfs_bmap -pv /mnt/test/rwtest.file
> /mnt/test/rwtest.file:
>  EXT: FILE-OFFSET       BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>    0: [0..743]:         160..903          0 (160..903)         744 00000
>    1: [744..783]:       904..943          0 (904..943)          40 10000
>    2: [784..951]:       944..1111         0 (944..1111)        168 00000
>    3: [952..1023]:      1112..1183        0 (1112..1183)        72 10000
>    4: [1024..1287]:     1184..1447        0 (1184..1447)       264 00000
>    5: [1288..1383]:     1448..1543        0 (1448..1543)        96 10000

file offset 659456 is in EXT 5.
I guess FLAGS 1 means it's an unwritten extent, right?

xfs_tests/xfs/080 basically does:
1. direct io write
2. then buffered read to check the previous dio write

Here is an example of error logs.

doio ( 3626) 16:13:23
---------------------
*** DATA COMPARISON ERROR ***
check_file(/mnt/test/rwtest.file, 239616, 81408, H:3626:block:doio*,
18, 0) failed

Comparison fd is 5, with open flags 0
Corrupt regions follow - unprintable chars are represented as '.'
-----------------------------------------------------------------
corrupt bytes starting at file offset 241664
    1st 32 expected bytes:  oio*H:3626:block:doio*H:3626:blo
    1st 32 actual bytes:    ................................

Request number 981
          fd 4 is file /mnt/test/rwtest.file - open flags are 040001
O_WRONLY,O_DIRECT,
          write done at file offset 239616 - pattern is H (0110)
          number of requests is 1, strides per request is 1
          i/o byte count = 81408
          memory alignment is aligned
          DIRECT I/O: offset % 512 = 0 length % 81408 = 0
          mem alignment 0x200 xfer size: small: 512 large: 2147483136

syscall:  writev(4, (iov on stack), 1)


The "expected bytes" was actually written to the disk successfully,
but for some bug the xfs extent flag was not set correctly.
The flag should be "XFS_EXT_NORM", but now it's "XFS_EXT_UNWRITTEN".

Could you share the code path the extent flag was updated?
Is it also updated through direct io?

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
