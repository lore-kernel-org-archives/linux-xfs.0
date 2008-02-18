Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 15:50:57 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1INokND006530
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:50:50 -0800
Date: Tue, 19 Feb 2008 10:51:03 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: tuning, many small files, small blocksize
Message-ID: <20080218235103.GW155407@sgi.com>
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com> <47BA10EC.3090004@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BA10EC.3090004@tlinx.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <xfs@tlinx.org>
Cc: Jeff Breidenbach <jeff@jab.org>, xfs@oss.sgi.com

On Mon, Feb 18, 2008 at 03:12:44PM -0800, Linda Walsh wrote:
> 
> Might also play with the inode size.  I *usually* go with 1K-inode+4k block,
> but with a 2k block, I'm slightly torn between 512-byte inodes and 1K
> inodes, but I can't think of a _great_ reason to ever go with the default
> 256-byte inode size, since that size seems like it will always cause
> the inode to be shared with another, possibly unrelated file.

That makes no sense. Inodes are *unique* - they are not shared with
any other inode at all. Could you explain why you think that 256
byte inodes are any different to larger inodes in this respect?

> Remember, in xfs, if the last bit of left-over data in an inode will fit
> into the inode, it can save a block-allocation, though I don't know
> how this will affect speed.

No, that's wrong. We never put data in inodes.

> Space-wise, a 2k block size and 1k-inode size might be good, but don't
> know how that would affect performance.

Inode size vs block size is pretty much irrelevant w.r.t performance,
except for the fact inode size can't be larger than the block size.

> I'm sure you are familiar with mount options noatime,nodiratime -- same
> concepts, but dir's are split out.

noatime implies nodiratime.

> Also, it depends on the situation, but sometimes flattening out the
> directory structure can speed up lookup time.

Like using large directory block sizes to make large directory
btrees wider and flatter and therefore use less seeks for any given
random directory lookup? ;)

> Sometime back someone did some benchmarks involving log size and it seemed
> that 32768b(4k) or ~128Meg seemed optimal if memory serves me correctly.

128MB is the maximum size currently.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
