Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1DKB0Zc204909 for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 14:11:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51E9A1933DE9
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 12:10:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HYXZZwVD7gg9xTRk for
	<xfs@oss.sgi.com>; Fri, 13 Feb 2009 12:10:25 -0800 (PST)
Date: Fri, 13 Feb 2009 15:10:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/13] xfs: add CRC checks for quota blocks
Message-ID: <20090213201024.GA7218@infradead.org>
References: <20090210202241.546501000@bombadil.infradead.org>
	<20090210202941.616680000@bombadil.infradead.org>
	<20090212064128.GC824@josefsipek.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090212064128.GC824@josefsipek.net>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Feb 12, 2009 at 01:41:28AM -0500, Josef 'Jeff' Sipek wrote:
> >  	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
> > -	char		  dd_fill[32];	/* filling for posterity */
> > +	char		  dd_fill[12];	/* filling for posterity */
> > +
> > +	/*
> > +	 * These two are only present one filesystems with the CRC bits set.
> > +	 */
> > +	__be32		  dd_crc;	/* checksum */
> > +	uuid_t		  dd_uuid;	/* location information */
> >  } xfs_dqblk_t;
> 
> Again, why put the crc/uuid at the end?

So that we can add additional infos either to xfs_disk_dquot_t
(preserved in-core) or xfs_dqblk_t (purly on-disk).

> > +		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
> > +				 offsetof(struct xfs_dqblk, dd_crc))) {
> > +//		    !uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_uuid) ||
> 
> Dead code?

Sorry, sent out a too early version.  The final patch actually verifies
the uuid and the correct location in the quota file.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
