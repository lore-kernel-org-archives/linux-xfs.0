Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBB3Jbd0142611 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 21:19:37 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5711AEAC2E
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 19:20:12 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 8cfZNP5Lvq5P4jxo for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 19:20:12 -0800 (PST)
Message-ID: <4B21BA68.4060205@sandeen.net>
Date: Thu, 10 Dec 2009 21:20:08 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Disappointing performance of copy (MD raid + XFS)
References: <4B204334.1000605@shiftmail.org> <4B207620.3060605@sandeen.net>
	<4B21A34C.9090100@shiftmail.org>
In-Reply-To: <4B21A34C.9090100@shiftmail.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>, xfs@oss.sgi.com

Asdo wrote:
> Eric Sandeen wrote:
> Gabor Gombas wrote:
> Kristleifur Da=F0ason wrote:
> [CUT]
> =

> Thank you guys for your help
> =

> I have done further investigation.
> =

> I still have not checked how performances are with very small files and
> multiple simultaneous rsyncs.
> =

> I have checked the other problem I had which I was mentioning, that I
> couldn't go more than 150MB/sec even with large files and multiple
> simultaneous transfers.
> I confirm this one and I have narrowed the problem: two XFS defaults
> (optimizations) actually damage the performances.
> =

> The first and most important is the aligned writes: cat /proc/mounts
> lists this (autodetected) stripe size: "sunit=3D2048,swidth=3D28672" . My
> chunks are is 1MB and I have 16 disks in raid-6 so 14 data disks. Do you
> think it's correct? xfs_info lists blocks as 4k and sunit and swidth are
> in 4k blocks and have a very different value. Please do not use the same
> name "sunit"/"swidth" to mean 2 different things in 2 different places,
> it can confuse the user (me!)

granted, this is confusing.

the /proc/mounts units are in 512-byte sectors.  So 2048 is 1M; 28672/2048
is 14, so that all looks right.

> Anyway that's not the problem: I have tried to specify other values in
> my mount (in particular I tried the values sunit and swidth should have
> had if blocks were 4k), but ANY xfs aligned mount kills the performances
> for me. =


certainly any wrong alignment would ;)

> I have to specify "noalign" in my mount to go fast. (Also note
> this option cannot be changed on mount -o remount. I have to unmount.)

so noalign is faster than the defaults?  hm.

> The other default feature that kills performances for me is the
> rotorstep. I have to max it out at 255 in order to have good
> performances. Actually it is reasonable that a higher rotorstep should
> be faster... why is 1 the default? Why it even exists? With low values
> the await (iostat -x 1) increases, I guess because of the seeks, and
> stripe_cache_active stays higher, because there are less filled stripes.

this is related to the inode64 mount option I mentioned, which I guess you
haven't tested?   rotorstep affects how often new AGs are chosen in
the 32-bit inode mode.  I'm not sure why 1 is the default, perhaps
this should be changed.

> If I use noalign and rotorstep at 255 I am able to go at 325 MB/sec on
> average (16 parallel transfers of 7MB files) while with defaults I go at
> about 90 MB/sec.

It might be nice to do some blktracing to see what's actually
hitting the disk.

Are you running on the entire md device, or is it partitioned?
If you have partitioned your device with something so that the partitions
are not stripe-aligned, maybe that throws everything off.

Maybe you can post your partition info if any, as well as the actual
raid geometry as reported by md.

> Also with noalign and rotorstep at 255 the stripe_cache_size stays
> usually in the lower half (below 16000 out of 32000) while with defaults
> it's stuck for most of the time at the maximum and processes are stuck
> sleeping in MD locks for this reason.
> =

> Do you have any knowledge of sunit/swidth alignment mechanism being
> broken on 2.6.31 or more specifically 2.6.31 ubuntu generic-14 ?

nope, don't use ubuntu, and AFAIK stripe alignment is just fine upstream.

> (Kristleifur thank you I have seen your mention of the Ubuntu vs vanilla
> kernel, I will try a vanilla one but right now I can't. However now I
> have narrowed the problem so XFS people might want to watch at the
> alignment problem more specifically)
> =

> Regarding my previous post I still would like to know what are those
> stack traces I posted in my previous post: what are the functions
> xlog_state_get_iclog_space+0xed/0x2d0 [xfs]  and
> xfs_buf_lock+0x1e/0x60 [xfs]
> and what are they waiting for...
> these are still the place where processes get stuck, even after having
> worked around the alignment/rotorstep problem...
> =

> And then a few questions on inode64:
> - if I start using inode64, do I have to remember to use inode64 on
> every subsequent mount for the life for that filesystem? Or does it
> write it in some filesystem info region that the option has been used
> once, so it applies the inode64 by itself on subsequent mounts?

Unfortunately it's not a superblock features, though IMHO it should
be; so yes, you need to mount with it always.  Leaving it out won't
harm your filesystem, it'll just put you back in 32-bit-inode mode.
Just put it in your fstab.

> - if I use a 64bit linux distro, will ALL userland programs
> automatically support 64bit inodes or do I have to continuously pay
> attention and risk to damage my data?

all 64-bit applications should be just fine.

-Eric

> Thanks for your help
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
