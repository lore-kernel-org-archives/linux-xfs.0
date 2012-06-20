Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K7fLnn261628 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 02:41:21 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jCCksiMmHUsJwcWU for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 00:41:19 -0700 (PDT)
Date: Wed, 20 Jun 2012 17:41:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] xfs: factor buffer reading from xfs_dir2_leaf_getdents
Message-ID: <20120620074117.GJ30705@dastard>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-10-git-send-email-david@fromorbit.com>
	<20120620072709.GA27358@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620072709.GA27358@infradead.org>
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

On Wed, Jun 20, 2012 at 03:27:10AM -0400, Christoph Hellwig wrote:
> > +struct _map_info {
> > +	xfs_bmbt_irec_t	*map;		/* map vector for blocks */
> > +	xfs_extlen_t	map_blocks;	/* number of fsbs in map */
> > +	xfs_dablk_t	map_off;	/* last mapped file offset */
> > +	int		map_size;	/* total entries in *map */
> > +	int		map_valid;	/* valid entries in *map */
> > +	int		nmap;		/* mappings to ask xfs_bmapi */
> > +	xfs_dir2_db_t	curdb;		/* db for current block */
> > +};
> > +
> > +struct _ra_info {
> 
> Can you give these structure names xfs_dir2_leaf prefixes, please?

Sure.

> Also any reason the ra_info structure is kept entirely separate?

Logical grouping, easy to validate.

> While
> I see a bit of a point to have a logical grouping, it still semes more
> useful to just embedd it into the map_info.

Ok, I can do that.

> > +	map_info.map_size = howmany(bufsize + mp->m_dirblksize,
> > +				     mp->m_sb.sb_blocksize);
> > +	map_info.map = kmem_zalloc(map_info.map_size *
> > +					sizeof(struct xfs_bmbt_irec), KM_SLEEP);
> 
> I'd be tempted to say that the map field in the map_info should be a
> variable sized array the end, and the whole structure should be
> dynamically allocated to get a couple more variables off the stack.

Makes sense, even though we aren't usually under stack pressure
here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
