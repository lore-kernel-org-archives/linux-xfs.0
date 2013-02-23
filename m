Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 852637F50
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2013 17:55:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 709BC304039
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2013 15:55:52 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RayepjBEOepI5CQK for <xfs@oss.sgi.com>;
	Sat, 23 Feb 2013 15:55:50 -0800 (PST)
Date: Sun, 24 Feb 2013 10:55:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Message-ID: <20130223235546.GA5551@dastard>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
	<20130223000802.GB26081@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
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
To: Tony Lu <zlu@tilera.com>
Cc: Alex Elder <elder@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Sat, Feb 23, 2013 at 07:06:10AM +0000, Tony Lu wrote:
> >From: Dave Chinner [mailto:david@fromorbit.com]
> >On Fri, Feb 22, 2013 at 08:12:52AM +0000, Tony Lu wrote:
> >> I encountered the following panic when using xfs partitions as rootfs, which
> >> is due to the truncated log data read by xlog_bread_noalign(). We should
> >> extend the buffer by one extra log sector to ensure there's enough space to
> >> accommodate requested log data, which we indeed did in xlog_get_bp(), but we
> >> forgot to do in xlog_bread_noalign().
> >
> >We've never done that round up in xlog_bread_noalign(). It shouldn't
> >be necessary as xlog_get_bp() and xlog_bread_noalign() are doing
> >fundamentally different things. That is, xlog_get_bp() is ensuring
> >the buffer is large enough for the upcoming IO that will be
> >requested, while xlog_bread_noalign() is simply ensuring what it is
> >passed is correctly aligned to device sector boundaries.
> 
> I set the sector size as 4096 when making the xfs filesystem.
> -sh-4.1# mkfs.xfs -s size=4096 -f /dev/sda3

.....

> In this case, xlog_bread_noalign() needs to do such round up and
> round down frequently. And it is used to ensure what it is passed
> is aligned to the log sector size, but not the device sector
> boundaries.

If you have a 4k sector device, then the log sector size is the same
as the physical device. Hence the log code assumes that if you have
a specific log sector size, it is operating on a device that has the
physical IO constraints of that sector size.

> >So, if you have to fudge an extra block for xlog_bread_noalign(),
> >that implies that what xlog_bread_noalign() was passed was
> >probably not correct. It also implies that you are using sector
> >sizes larger than 512 bytes, because that's the only time this
> >might matter. Put simply, this:
> 
> While debugging, I found when it crashed, the blk_no was not align
> to the log sector size and nnblks was aligned to the log sector
> size, which makes sense.

Actually, it doesn't. The log writes done by the kernel are supposed
to be aligned and padded to sector size, which means that we should
never see an unaligned block numbers when reading log buffer headers
back off disk. i.e. when you run mkfs.xfs -s size=4096, you end up
with a a log stripe unit of 4096 bytes, which means it pads
every write to 4096 byte boundaries rather than 512 byte boundaries.

> Starting XFS recovery on filesystem: ram0 (logdev: internal)

Ok, you're using a ramdisk and not a real 4k sector device. Hence it
won't fail if we do 512 byte aligned IO rather than 4k aligned IO.

> xlog_bread_noalign--before round down/up: blk_no=0xf4d,nbblks=0x1
> xlog_bread_noalign--after round down/up: blk_no=0xf4c,nbblks=0x4
> xlog_bread_noalign--before round down/up: blk_no=0xf4d,nbblks=0x1
> xlog_bread_noalign--after round down/up: blk_no=0xf4c,nbblks=0x4
> xlog_bread_noalign--before round down/up: blk_no=0xf4e,nbblks=0x3f
> xlog_bread_noalign--after round down/up: blk_no=0xf4c,nbblks=0x40
> XFS: xlog_recover_process_data: bad clientid
>
> For example, if xlog_bread_noalign() wants to read blocks from #1
> to # 9, in which case the passed parameter blk_no is 1, and nbblks
> is 8, sectBBsize is 8, after the round down and round up
> operations, we get blk_no as 0, and nbblks as still 8. We
> definitely lose the last block of the log data.

Yes, I fully understand that. But I also understand how the log
works and that this behaviour *should not happen*. That's why
I'm asking questions about what the problem you are trying to fix.

The issue here is that the log buffer write was not aligned to the
underlying sector size. That is, what we see here is a header block
read, followed by the log buffer data read. The header size is
determined by the iclogbuf size - a 512 byte block implies default
32k iclogbuf size - and the following data region read of 63 blocks
also indicates a 32k iclogbuf size.

IOWs, what we have here is a 32k log buffer write apparently at a
sector-unaligned block address (0xf4d = 3917 which is not a multiple
of 8). This is why log recovery went wrong: a fundamental
architectural assumption the log is built around has somehow been
violated.

That is, the log recovery failure does not appear to be a problem
with the sector alignment done by xlog_bread_noalign() - it appears
to be a failure with the alignment of log buffer IO written to the
log. That's a far more serious problem than a log recovery problem,
but I can't see how that could occur and so I need a test case that
reproduces the recovery failure for deeper analysis....

> I was using the 2.6.38.6 kernel, and using xfs as a rootfs
> partition. After untaring the rootfs files on the xfs partition,
> and tried to reboot from the xfs, then the panic occasionally
> occurred.

Ramdisks don't persist over a reboot, so you must have had some
other way of reproducing the problem. Can you tell me how you
reproduced it on a ramdisk? Better yet, send me a script that
reproduces the problem?

> I hope I can provide the corrupted log for you, but probably I
> could not find it, since I fixed this bug a year ago. Recently
> when I do some clean-up on my code, I find this one, so I think I
> should return it back to the community.

Great to hear, but I'd really like it if you pushed fixes for XFS
bugs upstream the moment you find them. You'll get help triaging the
problem, determining that the fix is correct, etc, and that will
benefit your customers by providing them with a more robust product.
The community also benefits from getting bug fixes much faster....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
