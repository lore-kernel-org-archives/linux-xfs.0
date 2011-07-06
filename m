Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p668Xl8k093757 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:33:48 -0500
Date: Wed, 6 Jul 2011 04:33:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/27] xfs: kill struct xfs_dir2_sf
Message-ID: <20110706083345.GB19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.197942925@bombadil.infradead.org>
	<1309922658.3381.22.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309922658.3381.22.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 05, 2011 at 10:24:18PM -0500, Alex Elder wrote:
> On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> > The list field of it is never cactually used, so all uses can simply be
> > replaced with the xfs_dir2_sf_hdr_t type that it has as first member.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks like a lot of places could be converted to use
> "struct xfs_dir2_sf_hdr" rather than the typedef, but
> it's not worth re-posting for that.  (Plus I suspect
> such changes may be in forthcoming patches...)

In general they should, but I try to avoid that where it means
massive formatting changes, as that just clutters up the patch.

> > +	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> > +
> >  	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
> >  	ASSERT(dp->i_df.if_u1.if_data != NULL);
> 
> 	ASSERT(oldsfp != NULL);

What for?  We'll just dereference it later anyway.

> >  static xfs_ino_t
> >  xfs_dir2_sf_get_ino(
> > -	struct xfs_dir2_sf	*sfp,
> > +	struct xfs_dir2_sf_hdr	*hdr,
> 
> I think I like the name "hdr" better than "sfp";
> was it just too widespread a change to do a
> similar rename elsewhere?  (xfs_dir2_block_to_sf()
> uses "sfhp" already, though I like just "hdr".)

Yeah, I tried to keep the change small in general.  If people like it
I can do a big sweep to convert stuff to struct types and common names
as a follow-on.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
