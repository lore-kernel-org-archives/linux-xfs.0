Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBB3Pe3V143038 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 21:25:42 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A74AFDFD1B5
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 19:26:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	7HNRlolDgRRZDoVb for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2009 19:26:14 -0800 (PST)
Date: Fri, 11 Dec 2009 14:26:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Message-ID: <20091211032610.GH30608@discord.disaster>
References: <4B204334.1000605@shiftmail.org> <4B207620.3060605@sandeen.net>
	<4B21A34C.9090100@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B21A34C.9090100@shiftmail.org>
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
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kristleifur =?iso-8859-1?Q?Da=F0ason?= <kristleifur@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, Gabor Gombas <gombasg@sztaki.hu>, xfs@oss.sgi.com

On Fri, Dec 11, 2009 at 02:41:32AM +0100, Asdo wrote:
> I have checked the other problem I had which I was mentioning, that I  
> couldn't go more than 150MB/sec even with large files and multiple  
> simultaneous transfers.
> I confirm this one and I have narrowed the problem: two XFS defaults  
> (optimizations) actually damage the performances.
>
> The first and most important is the aligned writes: cat /proc/mounts  
> lists this (autodetected) stripe size: "sunit=2048,swidth=28672" . My  
> chunks are is 1MB and I have 16 disks in raid-6 so 14 data disks. Do you  
> think it's correct?

Yes. The units that mkfs/xfs_info use are not consistent - in this
case sunit/switch are in 512 byte sectors, so the values are
effectively { sunit = 1MB, swidth = 14MB } which matches to your
raid6 configuration correctly.

> xfs_info lists blocks as 4k and sunit and swidth are  
> in 4k blocks and have a very different value. Please do not use the same  
> name "sunit"/"swidth" to mean 2 different things in 2 different places,  
> it can confuse the user (me!)

I know, and agree that it is less than optimal. It's been like this
forever, and unfortunately while changing it is relatively easy, the
knock-on effect of breaking most QA tests we have (scripts parse the
output of mkfs) it makes it a much larger amount of effort to
change than it otherwise looks. Still, we should consider doing
it....

> Anyway that's not the problem: I have tried to specify other values in  
> my mount (in particular I tried the values sunit and swidth should have  
> had if blocks were 4k), but ANY xfs aligned mount kills the performances  
> for me. I have to specify "noalign" in my mount to go fast. (Also note  
> this option cannot be changed on mount -o remount. I have to unmount.)

That sounds like the filesystem is not aligned to the underlying
RAID correctly. Allocation for a filesystem with sunit/swidth set
aligns to the the start of stripe units so allocation between large
files is sparse. noalign turns off the allocation alignment, so it
will have much fewer holes in the writeback pattern, and that
reduces the impact of an unaligned filesystem....

Soory if you've already asked and answered this question - Is your
filesystem straight on the md raid volume, or is there
partitions/lvm/dm configuration in between them?

> The other default feature that kills performances for me is the  
> rotorstep. I have to max it out at 255 in order to have good  
> performances.

So you are not using inode64, then? If you have 64 bit systems, then
you probably should use inode64....

> Actually it is reasonable that a higher rotorstep should  
> be faster... why is 1 the default? Why it even exists? With low values  
> the await (iostat -x 1) increases, I guess because of the seeks, and  
> stripe_cache_active stays higher, because there are less filled stripes.

Rotorstep is used to determine how far to spread files apart in the
inode32 allocation. Basically every new file created has the AG it
will be place in selected by:

	new_ag = (last_ag + rotorstep) % num_ags_in_filesystem;

By default it just picks the next AG (linear progression). If you
have only a few AGs, then a value of 255 will effectively randomise
the AG being selected. For your workload, that must result in the
best distribution of IO for your storage subsystem. In general,
though, no matter how much you tweak inode32 w/ rotorstep, the
inode64 allocator usually performs better.

> If I use noalign and rotorstep at 255 I am able to go at 325 MB/sec on  
> average (16 parallel transfers of 7MB files) while with defaults I go at  
> about 90 MB/sec.
>
> Also with noalign and rotorstep at 255 the stripe_cache_size stays  
> usually in the lower half (below 16000 out of 32000) while with defaults  
> it's stuck for most of the time at the maximum and processes are stuck  
> sleeping in MD locks for this reason.

That really does sound like a misaligned filesystem - the stripe
cache will grow larger the more RMW cycles that need to be
performed...

> Regarding my previous post I still would like to know what are those  
> stack traces I posted in my previous post: what are the functions
> xlog_state_get_iclog_space+0xed/0x2d0 [xfs]  and

Waiting on IO completion on the log buffers so that
the current transaction can be written into the next log buffer
(there are 8 log buffers). Basically a sign of being IO bound during
metadata operations.

> xfs_buf_lock+0x1e/0x60 [xfs]

Generally you see this while waiting on IO completion to unlock the
buffer so that it can be locked into in the current transaction for
further modification. Usually a result of the log tail being pushed
to make room for new transactions.

> And then a few questions on inode64:
> - if I start using inode64, do I have to remember to use inode64 on  
> every subsequent mount for the life for that filesystem?

No, you are not forced to, but if you forget it will revert to
inode32 allocator behaviour.

> Or does it  
> write it in some filesystem info region that the option has been used  
> once, so it applies the inode64 by itself on subsequent mounts?

No, it does not do this, but probably should.

> - if I use a 64bit linux distro, will ALL userland programs  
> automatically support 64bit inodes or do I have to continuously pay  
> attention and risk to damage my data?

If you use 64 bit applications, then they should all support 64 bit
inodes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
