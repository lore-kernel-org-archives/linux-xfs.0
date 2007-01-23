Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 08:09:22 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NG9Bqw028914
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 08:09:12 -0800
Message-ID: <45B632F6.50705@sandeen.net>
Date: Tue, 23 Jan 2007 10:08:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: how to sync / commit data to disk?
References: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
In-Reply-To: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Gervai <grinapo@gmail.com>
Cc: xfs@oss.sgi.com

Peter Gervai wrote:
> Hello,
> 
> [Tried to search archieves, found nothing, probably my keywords are bad. :-)]
> 
> What is the recommended way to make sure that a file is written
> physically to the disk? (apart from the cache of the disk.)
> 
> This problem seem to have arisen in grub bootloader under Debian linux
> (and most probably everywhere else): it must be sure that the copied
> files are there, and can be addressed by C/H/S and modified there, at
> the given sector address.
> 
> My educated guess would be
> xfs_freeze -f
> sync
> xfs_freeze -u

That's one hack that has been proposed, and may help.

Another issue that I've seen with grub is that it seems to like to write
directly to the block device WHILE THE FILESYSTEM IS MOUNTED.

This is very bad, and causes ext3 grief too.

grub seems to think that it can just call "sync" and have everything be
happy, but esp. when it's doing reads & writes via both block dev &
filesystem, stuff is so out of whack syncs won't save you.

I'm not sure how you're invoking grub, but we found that manually
specifying --stage2, i.e.

	install --stage2=/boot/grub/stage2 ...

at least caused it to leave the block device alone while the fs is
mounted, rather than trying to write the underlying bdev... that was
obvious, no?  ;-)  You could verify this by stracing your grub command,
and see what it is doing with the block device.

-Eric
