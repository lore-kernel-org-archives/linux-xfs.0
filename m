Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0F4akXA159735 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 22:36:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B2C910007D5
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 20:38:59 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	p3F4Hh3niBaPSfRP for <xfs@oss.sgi.com>;
	Fri, 14 Jan 2011 20:38:59 -0800 (PST)
Date: Sat, 15 Jan 2011 15:38:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fallocate everywhere?
Message-ID: <20110115043856.GJ16267@dastard>
References: <4D309390.4060009@philkarn.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D309390.4060009@philkarn.net>
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
To: karn@ka9q.net
Cc: xfs@oss.sgi.com

On Fri, Jan 14, 2011 at 10:18:56AM -0800, Phil Karn wrote:
> Can anyone think of a good reason *not* to sprinkle fallocate() calls
> through as many Linux utilities as possible? E.g., programs like rsync,
> tar, cpio, pax, ftp, mv, cp -- anything and everything that creates a
> file with a size known in advance.

Yes. It defeats one of the principle optimisations delayed
allocation provides: allocation of contiguous ranges of disk across
multiple files at writeout time.

If you fallocate, you might allocate like this:

	+----------+---------+---------+----------+----------+
	  file A     file B     file C     file D    file E

But if writeback order is different and the block device queues are
congested, you might end up with IO patterns like:


Time
    |   +----------+
    |	                     +---------+
    |	                                          +----------+
    |	           +---------+
    V	                               +----------+
	  file A     file B     file C     file D    file E

That is, there's the potential for 5 separate IOs to write back the
data because they may not have an adjacent IO to merge with. If the
queue is congested, this this will simply make things worse.

If the same situation occurs with delayed allocation, you end up
with:

	+----------+---------+---------+----------+----------+
	  file A     file C     file E     file B    file D

as the allocation pattern, and the block layer would merge the
IOs into one large IO....

> As far as I can tell, calling fallocate() when it's not supported
> quickly returns an error and does no harm. So I can't even think of a
> reason to only make it optional.

I can. It fails the "optimise allocation for optimal writeback
patterns" test. In most cases preallocation is not necessary because
filesystems do a good job of this. The filesystems that don't do a
good job of this don't implement fallocate() anyway, so adding
fallocate to the userspace tools doesn't really help the filesystems
that need help to begin with...

> If it's implemented as an
> off-by-default option, most people would probably not know about it so
> it would rarely get used. Those who do know about it would frequently
> forget to use it, and choosing and learning a separate option for every
> command would be painful.
> 
> Besides xfs, ext4 supports fallocate so I expect that most Linux systems
> will be able to benefit from it fairly soon.

Proper fallocate support requires a method for recording on disk
whether the block/extent is initialised or not. Most filesystems
don't have this, nor will they implement it, so they won't grow
fallocate support. And like I said, filesytems like ext4, xfs and
btrfs don't need fallocate help for stuff like tar/rsync etc.

If you really want to make stuff like cp/tar/ftp/find better, maybe
addressing the bigger problems that limit their throughput - they
are single threaded and aren't very smart.  Updating them to be
multithreaded, use async IO, large buffers, use sparse file/hole
detection by default, use sendfile/splice tricks for zero-copy IO,
etc would be, IMO, more useful for the long term.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
