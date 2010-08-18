Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7I8m1TX102013 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 03:48:01 -0500
Received: from emh07.mail.saunalahti.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8885CD776A
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 01:57:45 -0700 (PDT)
Received: from emh07.mail.saunalahti.fi (emh07.mail.saunalahti.fi
	[62.142.5.117]) by cuda.sgi.com with ESMTP id kCSSK1WmhdyvO5rH
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 01:57:45 -0700 (PDT)
From: Arto Jantunen <viiru@debian.org>
Subject: Re: Kernel BUG when running xfs_fsr with 2.6.35.1
References: <878w47yn36.fsf@viiru.iki.fi> <20100816220941.GK10429@dastard>
	<87zkwlxj8g.fsf@viiru.iki.fi> <20100817230357.GG7362@dastard>
Date: Wed, 18 Aug 2010 11:48:22 +0300
In-Reply-To: <20100817230357.GG7362@dastard>
	(sfid-20100818_020413_194941_2A487A57) (Dave Chinner's message
	of "Wed\, 18 Aug 2010 09\:03\:57 +1000")
Message-ID: <87r5hwxq5l.fsf@viiru.iki.fi>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Aug 17, 2010 at 08:05:35PM +0300, Arto Jantunen wrote:
>> Dave Chinner <david@fromorbit.com> writes:
>> >> I had a kernel BUG yesterday when running xfs_fsr on my Debian Unstable
>> >> laptop. The kernel is upstream 2.6.35.1. I'm attaching the backtrace
>> >> below. I haven't tried reproducing the problem yet and don't know if it is
>> >> reproducible. I can try that, and test patches etc. if it is useful. Let me
>> >> know if there is any other information I can provide to help with debugging.
>> >
>> > It's not obvious what has gone wrong at all - I haven't seen
>> > anything like this in all my recent testing, so it's something new.
>> > The first oops implies the inode has not been joined to the
>> > transaction, but from code inspection I cannot see how that can
>> > happen.
>> 
>> I tried to reproduce the problem, and this time xfs_fsr finished without
>> reporting errors, but the kernel output the following two lines (one of which
>> is essentially empty):
>> 
>> [ 6372.878945] Filesystem "sda4": Access to block zero in inode 67203861
>> start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 2
>> [ 6372.878950]
>
> That's a corrupt extent record - it's all zeros, and judging by the
> fact that it's only got 2 extents, it's probaly inline in the inode
> (i.e. the inode fork has been zeroed.)
>
>> 
>> I decided to boot from a usb stick and try xfs_repair -n, I have attached the
>> output of that. There were errors reported. Is this simply a case of random
>> (possibly hardware related) fs corruption, or were the errors actually caused
>> by the xfs_fsr run that crashed the system? Is there a way to tell from this
>> data, is there anything else I can provide?
> ....
>
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - scan filesystem freespace and inode maps...
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan (but don't clear) agi unlinked lists...
>> error following ag 0 unlinked list
>> error following ag 2 unlinked list
>> error following ag 3 unlinked list
>
> Ok, so a corrupt set of inode unlinked lists
>
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>> b766fb90: Badness in key lookup (length)
>> bp=(bno 208, len 16384 bytes) key=(bno 208, len 8192 bytes)
>> b766fb90: Badness in key lookup (length)
>> bp=(bno 720, len 16384 bytes) key=(bno 720, len 8192 bytes)
>
> [snip]
>
>> Phase 6 - check inode connectivity...
>>         - traversing filesystem ...
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> disconnected inode 475, would move to lost+found
>> disconnected inode 1457, would move to lost+found
>
> [snip]
>
>> Phase 7 - verify link counts...
>> would have reset inode 475 nlinks from 0 to 1
>> would have reset inode 1457 nlinks from 0 to 1
>
> Ok, so inode #457 is in the inode chunk at block 208, likewise
> inode #1457 is in the chunk at bno 720. This all implies that
> at some point there's been a problem with the second phase of
> the unlink procedure and freeing the inode cluster. It looks like
> the inode cluster has been partially freed (by the "Badness in key
> lookup" errors) as half of the chunk is free space and half appears
> to be in use. The freespace btree is clearly confused about this.
>
> Along with the inodes bein removed from the directory structure and
> the link counts being zero, this really does indicate that something
> went wrong with an inode cluster freeing transaction at some point.
>
> I can't see how normal execution would do this, so it leads me to
> think that transaction recovery might be involved. It smells like
> partial transaction recovery failures so my next question is this:
> what is your hardware, have you had any power loss events and are
> you using barriers?

Could this corruption have been caused by having to reboot via sysrq after the
original crash (with sync, umount, sync, reboot)? Other than that one, I don't
remember having any power failures or such. The hardware is an Acer TravelMate
3040 laptop with a single SATA disk (120Gb IIRC). I haven't disabled barriers
manually and am not using any layers between the fs and disk (dm or md or
such), so as far as I understand barriers should be enabled (I'll check the
kernel log when I'm at the machine again and send another mail tonight if that
is not in fact the case).

Any ideas if the original crash during xfs_fsr was caused by existing problems
in the fs, or was the crash the cause of the problems seen now?

Should I allow xfs_repair to fix the fs, or will that lose data that could be
useful for debugging?

-- 
Arto Jantunen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
