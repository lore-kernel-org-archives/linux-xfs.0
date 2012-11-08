Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8LRvsE024057 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 15:27:57 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rBdsMhbCQG1ve761 for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 13:29:55 -0800 (PST)
Date: Fri, 9 Nov 2012 08:29:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: better perf and memory uage for xfs_fsr? Trivial patch against
	xfstools-3.16 included...
Message-ID: <20121108212952.GR6434@dastard>
References: <509BAABF.3030608@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <509BAABF.3030608@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 08, 2012 at 04:51:11AM -0800, Linda Walsh wrote:
> I was looking at output of xosview and watched a daily run of xfs_fsr take
> off as normal, and do it's normal thing of allocating remaining buffer
> memory during it's run -- and, as seems normal, it would go up to the
> machine's limit, then the kernel's memory reclaiming would kick in for a few
> hundred ms, and take memory usage down from 48G to maybe 30+G.
> 
> During this time, I'd see xfs_fsr stop or pause for a bit, then resume and
> I'd see a used-buffer memory look like slow ramps followed by sharp drops
> with xfs_fsr showing i/o gaps as the ramps peaked.

It's not xfs_fsr that is causing this problem. It's other
applications, I think, generating memory pressure and xfs_fsr is the
unfortunate victim...

> I wondered why it lumped all this memory reclaiming and thought to try using
> the posix_fadvise calls in xfs_fsr to tell the kernel what data was unneeded
> and such...

posix_fadvise won't affect fsr at all, because:

int             openopts = O_CREAT|O_EXCL|O_RDWR|O_DIRECT;

it uses direct IO, and hence bypasses the page cache. posix_fadvise
only affects buffered IO behaviour (i.e. via the page cache), and
hence will have no effect on IO issued by xfs_fsr.

> It doesn't increase or decrease the memory usage, just makes alloc'ing and
> freeing it in the kernel a bit smoother...

I'd say that's a subjective observation rather than an empirical one
- you're expecting it to improve, so you think it did. ;)

> Maybe other utils might benefit as well, dunno, ...but fsr was the most
> obvious to see the changes with.

Most of the XFS tools that do significant IO use direct IO, so it's
unlikely to make much measurable difference to tool behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
