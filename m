Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1B7tFbr117126 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 01:55:16 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 410A81918381
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 23:54:38 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	FQBdfQkSbLhK0wqU for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2009 23:54:38 -0800 (PST)
Date: Wed, 11 Feb 2009 18:54:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/13] xfs: add CRC checks to the AGFL
Message-ID: <20090211075433.GQ8830@disturbed>
References: <20090210202241.546501000@bombadil.infradead.org>
	<20090210202941.150266000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090210202941.150266000@bombadil.infradead.org>
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

On Tue, Feb 10, 2009 at 03:22:51PM -0500, Christoph Hellwig wrote:
> Add CRC checks, location information and a magic number to the AGFL.
> Previously the AGFL was just a block containing nothing but the
> free block pointers.  The new AGFL has a real header with the usual
> boilerplate instead, so that we can verify it's not corrupted and
> written into the right place.

I haven't had a chance to look over any of this series in detail - just
a quick glance really - but this popped out as looking wrong:

> +/*
> + * Size of the AGFL.  For CRC-enabled filesystes we steal the last two slots
> + * for location information (agno) and the crc.
> + */
> +#define XFS_AGFL_SIZE(mp) \
> +	((mp)->m_sb.sb_sectsize / sizeof(xfs_agblock_t) - \
> +	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ? sizeof(struct xfs_agfl) : 0))

sb_sectsize is in bytes, sizeof(xfs_agblock_t) is in bytes, which
means that the numerator is a count of the number of agblocks that
will fit in the AGFL. sizeof(struct xfs_agfl) is also in bytes,
so your subtracting a number of bytes from a count of agblocks....

I think you mean:

#define XFS_AGFL_SIZE(mp) \
	(((mp)->m_sb.sb_sectsize - (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
						sizeof(struct xfs_agfl) : 0)) \
	  / sizeof(xfs_agblock_t))

>  typedef struct xfs_agfl {
> -	__be32		agfl_bno[1];	/* actually XFS_AGFL_SIZE(mp) */
> +	__be32		agfl_magicnum;
> +	__be32		agfl_seqno;
> +	uuid_t		agfl_uuid;
> +	__be32		agfl_crc;
> +	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
>  } xfs_agfl_t;

And judging by that you are stealing more than 2 slots - more like
8 slots.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
