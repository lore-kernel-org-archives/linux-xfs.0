Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q19I1e1Z187297 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 12:01:44 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Q990RraeTIkDh9Db (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Feb 2012 10:01:39 -0800 (PST)
Date: Thu, 9 Feb 2012 13:01:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: stop caching inode structures
Message-ID: <20120209180136.GA7167@infradead.org>
References: <20120207182228.GA18801@infradead.org>
	<20120208051126.GF20305@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120208051126.GF20305@dastard>
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

On Wed, Feb 08, 2012 at 04:11:26PM +1100, Dave Chinner wrote:
> Ok, so what does it do to the speed of phase6 and phase7 of repair?
> How much CPU overhead does this add to every inode lookup done in
> these phases?

I'm away from my test system, but on the tons of inodes filesystems it
actually slightly improved their speed, probably because the box
was swapping less, or we spent less time in inode cache doing cache
misses as we'd never actually have the inode we care about cached.

The reason why the individual inode cache here doesn't work is because
we only every touched inodes in phase7 if we are going to modify them
and write them out, so we absolutely need the backing buffer anyway.

I can't see how phase6 benefits from the logical inode cache either,
given it's structure:

 - in phase 6a we iterate over each inode in the incore inode tree,
   and if it's a directory check/rebuild it
 - phase6b then updates the "." and ".." entries for directories
   that need, which means we require the backing buffers.
 - phase6c moves disconnected inodes to lost_found, which again needs
   the backing buffer to actually do anything.

In short there is no code in repair that benefits from doing logical
inode caching.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
