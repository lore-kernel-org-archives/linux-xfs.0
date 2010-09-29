Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TBiMfA044784 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 06:44:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 217EAE93D12
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 04:58:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wlzduhqVQoptLvWh for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 04:58:27 -0700 (PDT)
Date: Wed, 29 Sep 2010 07:45:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] [PATCH 2/3] xfs: do not use xfs_mod_incore_sb for
	per-cpu counters
Message-ID: <20100929114520.GA14048@infradead.org>
References: <20100929072221.583672974@bombadil.infradead.org>
	<20100929072238.162539532@bombadil.infradead.org>
	<20100929113914.GP5665@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100929113914.GP5665@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Sep 29, 2010 at 09:39:14PM +1000, Dave Chinner wrote:
> Not sure I like the indenting of the second line. I'd prefer the
> parameters to have a little more indent or use three lines...

That whole area needs some larger refactoring / reformatting work.
I'll see if I can ad danother patch for that.

> > +	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);
> 
> That assert will cause issues with:
> 
> > @@ -97,6 +99,8 @@ extern void	xfs_icsb_sync_counters_locke
> >  #define xfs_icsb_reinit_counters(mp)		do { } while (0)
> >  #define xfs_icsb_sync_counters(mp, flags)	do { } while (0)
> >  #define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
> > +#define xfs_icsb_modify_counters(mp, field, delta, rsvd) \
> > +	xfs_mod_incore_sb(mp, field, delta, rsvd)
> >  #endif
> 
> UP builds. Perhaps a CONFIG_SMP only assert? Given that the per-cpu
> counter rework I'm doing doesn't have a different code path for
> UP vs SMP, it'd only be a temporary concern....

Indeed, it should be conditional.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
