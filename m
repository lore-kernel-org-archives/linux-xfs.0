Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q177U7ch205345 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 01:30:07 -0600
Date: Tue, 7 Feb 2012 01:30:09 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/7] better dquot caching
Message-ID: <20120207073009.GM13095@sgi.com>
References: <20120201135719.202171828@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120201135719.202171828@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

Hey Christoph,

On Wed, Feb 01, 2012 at 08:57:19AM -0500, Christoph Hellwig wrote:
> This series improves handling of large number of dquots.  It replaced
> the direct recycling of dquots from the freelist with a shrinker, removes
> the upper bound of dquots, and uses per-filesystem structures for all
> quota state, including switching from a hash to a radix-tree for lookups.
> 
> For repeated lookups of dquots out of a large pool I see improvements
> betwen 50% and 500% compared to the previous code.  All these tests
> have been performed with Q_XQUOTASYNC already disabled as it would
> change the result to much for both the old and new code.
> 
> Note that the first patch probably is a candidate for Linux 3.3, as
> the previous quota updates caused a lock order reversal in the old
> quota reclaim code.  See the actual patch for more details.

These conflict with Chandra's project quota patches.  I've started
looking at them again, but I am a little uncomfortable with the change
to the superblock...  could I get your opinion of that while I take a
look at these?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
