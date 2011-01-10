Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0A0Wx0H175095 for <xfs@oss.sgi.com>; Sun, 9 Jan 2011 18:32:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1727B24D635
	for <xfs@oss.sgi.com>; Sun,  9 Jan 2011 16:35:09 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	t42sYbdfDYRskoFj for <xfs@oss.sgi.com>;
	Sun, 09 Jan 2011 16:35:09 -0800 (PST)
Date: Mon, 10 Jan 2011 11:35:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: realtime partition support?
Message-ID: <20110110003506.GE28803@dastard>
References: <4D2724E0.9020801@philkarn.net> <20110108021728.GA28803@dastard>
	<4D27E11F.4030607@philkarn.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D27E11F.4030607@philkarn.net>
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

On Fri, Jan 07, 2011 at 07:59:27PM -0800, Phil Karn wrote:
> On 1/7/11 6:17 PM, Dave Chinner wrote:
> >> Throughput on large files would be almost as fast as if everything were
> >> on the SSD.
> > 
> > Not at all. The data is still written to the rotating disk, so
> > the presence of the SSD won't change throughput rates at all.
> 
> My point is that the big win of the SSD comes from its lack of
> rotational and seek latency. They really shine on random small reads. On
> large sequential reads and writes, modern rotating disks can shovel data
> almost as quickly as an SSD once the head is in the right place and the
> data has started flowing. But it can't get there until it has walked the
> directory tree, read the inode for the file in question and finally
> seeked to the file's first extent.

Which often does not require IO because the path and inodes are
cached in memory.

> If all that meta information resided
> on SSD, the conventional drive could get to that first extent that much
> more quickly.

Not that much more quickly, because XFS uses readahead to hide a lot
of the directory traversal IO latency when it is not cached....

> > I'd also expect it to be be much, much slower than just using the
> > rotating disk for the standard data device - the SSD will make no
> > difference as metadata IO is not the limiting factor.
> 
> No? I'm having a very hard time getting XFS on rotating SATA drives to
> come close to Reiser or ext4 when extracting a large tarball (e.g., the
> Linux source tree) or when doing rm -rf. I've improved it by playing
> with logbsize and logbufs but Reiser is still much faster, especially at
> rm -rf. The only way I've managed to get XFS close is by essentially
> disabling journaling altogether, which I don't want to do. I've tried
> building XFS with an external journal and giving it a loopback device
> connected to a file in /tmp. Then it's plenty fast. But unsafe.

As has already been suggested, "-o delaylog" is the solution to that
problem.

> Turning off the write barrier also speeds things up considerably, but
> that also makes me nervous. My system doesn't have a RAID controller
> with a nonvolatile cache but it is plugged into a UPS (actually a large
> solar power system with a battery bank) so unexpected loss of power is
> unlikely. Can I safely turn off the barrier?

Should be safe.  In 2.6.37 the overhead of barriers is greatly
reduced. IIRC, on most modern hardware they will most likely be
unnoticable, so disabling them is probably not necessary...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
