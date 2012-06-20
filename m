Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K7RBQx258996 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 02:27:11 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XBDnQIFdEjBezYCi (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 00:27:10 -0700 (PDT)
Date: Wed, 20 Jun 2012 03:27:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: factor buffer reading from xfs_dir2_leaf_getdents
Message-ID: <20120620072709.GA27358@infradead.org>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339133914-11148-10-git-send-email-david@fromorbit.com>
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

> +struct _map_info {
> +	xfs_bmbt_irec_t	*map;		/* map vector for blocks */
> +	xfs_extlen_t	map_blocks;	/* number of fsbs in map */
> +	xfs_dablk_t	map_off;	/* last mapped file offset */
> +	int		map_size;	/* total entries in *map */
> +	int		map_valid;	/* valid entries in *map */
> +	int		nmap;		/* mappings to ask xfs_bmapi */
> +	xfs_dir2_db_t	curdb;		/* db for current block */
> +};
> +
> +struct _ra_info {

Can you give these structure names xfs_dir2_leaf prefixes, please?

Also any reason the ra_info structure is kept entirely separate?  While
I see a bit of a point to have a logical grouping, it still semes more
useful to just embedd it into the map_info.

> +	map_info.map_size = howmany(bufsize + mp->m_dirblksize,
> +				     mp->m_sb.sb_blocksize);
> +	map_info.map = kmem_zalloc(map_info.map_size *
> +					sizeof(struct xfs_bmbt_irec), KM_SLEEP);

I'd be tempted to say that the map field in the map_info should be a
variable sized array the end, and the whole structure should be
dynamically allocated to get a couple more variables off the stack.


Except for these nitpicks this looks like a great cleanup to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
