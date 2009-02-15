Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1FIOUv9087673 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 12:24:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ABC019405C2
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 10:23:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IT8VA0dNHyUn28a7 for
	<xfs@oss.sgi.com>; Sun, 15 Feb 2009 10:23:57 -0800 (PST)
Date: Sun, 15 Feb 2009 13:23:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/13] xfs: add CRC checks to the AGFL
Message-ID: <20090215182325.GB31179@infradead.org>
References: <20090210202241.546501000@bombadil.infradead.org>
	<20090210202941.150266000@bombadil.infradead.org>
	<20090211075433.GQ8830@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090211075433.GQ8830@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 11, 2009 at 06:54:33PM +1100, Dave Chinner wrote:
> I haven't had a chance to look over any of this series in detail - just
> a quick glance really - but this popped out as looking wrong:
> 
> > +/*
> > + * Size of the AGFL.  For CRC-enabled filesystes we steal the last two slots
> > + * for location information (agno) and the crc.
> > + */
> > +#define XFS_AGFL_SIZE(mp) \
> > +	((mp)->m_sb.sb_sectsize / sizeof(xfs_agblock_t) - \
> > +	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ? sizeof(struct xfs_agfl) : 0))
> 
> sb_sectsize is in bytes, sizeof(xfs_agblock_t) is in bytes, which
> means that the numerator is a count of the number of agblocks that
> will fit in the AGFL. sizeof(struct xfs_agfl) is also in bytes,
> so your subtracting a number of bytes from a count of agblocks....
> 
> I think you mean:
> 
> #define XFS_AGFL_SIZE(mp) \
> 	(((mp)->m_sb.sb_sectsize - (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
> 						sizeof(struct xfs_agfl) : 0)) \
> 	  / sizeof(xfs_agblock_t))

Yeah.  Either that, or dividing the sizeof by four.

> >  typedef struct xfs_agfl {
> > -	__be32		agfl_bno[1];	/* actually XFS_AGFL_SIZE(mp) */
> > +	__be32		agfl_magicnum;
> > +	__be32		agfl_seqno;
> > +	uuid_t		agfl_uuid;
> > +	__be32		agfl_crc;
> > +	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
> >  } xfs_agfl_t;
> 
> And judging by that you are stealing more than 2 slots - more like
> 8 slots.

Yeah, two slots was the very first implementation, I'll fix up the
comment too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
