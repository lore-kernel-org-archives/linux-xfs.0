Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7VIEFsl115055 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 13:14:25 -0500
Received: from mail-fx0-f216.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85F991B23A3A
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 11:15:02 -0700 (PDT)
Received: from mail-fx0-f216.google.com (mail-fx0-f216.google.com
	[209.85.220.216]) by cuda.sgi.com with ESMTP id
	3FTp8Vuy0F8hvEJR for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2009 11:15:02 -0700 (PDT)
Received: by fxm12 with SMTP id 12so2903220fxm.20
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 11:14:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090831123010.GA2368@infradead.org>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	<20090831123010.GA2368@infradead.org>
Date: Mon, 31 Aug 2009 20:14:58 +0200
Message-ID: <64bb37e0908311114t4a3cefc3v8ea5092e1558c578@mail.gmail.com>
Subject: Re: xfs compat_ioctl?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Michael Tokarev <mjt@tls.msk.ru>, Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Aug 31, 2009 at 2:30 PM, Christoph Hellwig<hch@infradead.org> wrote:
> On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
>> Hello!
>>
>> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
>> using 32bit userland, and that does not work, in dmesg I see:
>>
>> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ffa56df4) on /mnt
>> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ff991254) on /mnt
>>
>> so apparently there's no compat_ioctl layer for these ioctls.
>>
>> Are there any plans to add these? :)
>
> Are you sure you're testing 2.6.30?  The copat ioctls were added in
> 2.6.28.

On a slightly related note: I also have a system with a 32bit userland
and a 64bit kernel.
After switching to the 64bit kernel, xfs_fsr was no longer working,
but that was caused by the then still missing compat ioctls.

Today I retried it, but it still fails:
XFS_IOC_SWAPEXT failed: ino=<number>: Invalid argument

Looking at the compat code SWAPEXT looks somewhat suspicious:

fs/xfs/linux-2.6/xfs_ioctl32.h defines XFS_IOC_SWAPEXT_32, but I can't
find a single place where this is used.
And in the big switch of xfs_compat_ioctl() the value XFS_IOC_SWAPEXT
is surrounded by contants that all end in 32.

I don't have any experience with the linux ioctl code, I only read
fs/xfs/linux-2.6/xfs_ioctl32.c, but for my untrained eye it looks like
there is a _32 missing.

Or am I misreading this completely?

Torsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
