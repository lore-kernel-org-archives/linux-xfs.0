Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U7ddm2190591 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 02:39:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C68F4C2E5B
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:39:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7qbJwfNRm9mGEse2 for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2011 00:39:38 -0700 (PDT)
Date: Thu, 30 Jun 2011 03:39:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/27] xfs: cleanup shortform directory inode number
	handling
Message-ID: <20110630073937.GB31334@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140339.266356959@bombadil.infradead.org>
	<20110630063508.GH561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110630063508.GH561@dastard>
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

> > +static xfs_ino_t
> 
> Extra line there...

Fixed.

> > +}
> > +static void
> 
> And none there.

Fixed.

> > +xfs_dir2_sf_put_inumber(
> > +	struct xfs_dir2_sf	*sfp,
> > +	xfs_dir2_inou_t		*to,
> > +	xfs_ino_t		ino)
> > +{
> > +	if (sfp->hdr.i8count)
> > +		XFS_PUT_DIR_INO8(ino, to->i8);
> > +	else
> > +		XFS_PUT_DIR_INO4(ino, to->i4);
> > +}
> 
> Also, xfs_dir2_sf_get_ino() vs xfs_dir2_sf_put_inumber() - either
> use _ino or _inumber as the suffix for both. _ino is probably more
> consistent with the other functions...

xfs_dir2_sf_put_inumber already exists in the current code and I just
moved it blindly.  I've renamed it to xfs_dir2_sf_put_ino for the
next version.

> > +
> > +xfs_ino_t
> > +xfs_dir2_sf_get_parent_ino(
> > +	struct xfs_dir2_sf	*sfp)
> > +{
> > +	return xfs_dir2_sf_get_ino(sfp, &sfp->hdr.parent);
> > +}
> > +
> > +
> 
> Extra whitespace.

Fixed.

> > +static void
> > +xfs_dir2_sf_put_parent_ino(
> > +	struct xfs_dir2_sf	*sfp,
> > +	xfs_ino_t		ino)
> > +{
> > +	xfs_dir2_sf_put_inumber(sfp, &sfp->hdr.parent, ino);
> > +}
> > +
> > +
> 
> Extra whitespace.
> 

Fixed.

> > +/*
> > + * In short-form directory entries the inode numbers are stored at variable
> > + * offset behind the entry name.  The inode numbers may only be accessed
> > + * through the helpers below.
> > + */
> > +
> 
> Extra whitespace.
> 

Fixed.

> > +static xfs_dir2_inou_t *
> > +xfs_dir2_sf_inop(
> > +	struct xfs_dir2_sf_entry *sfep)
> > +{
> > +	return (xfs_dir2_inou_t *)&sfep->name[sfep->namelen];
> > +}
> 
> Probably should be called xfs_dir2_sfe_inop()  because it takes a
> xfs_dir2_sf_entry, similar to the following functions use "sfe".

Ok.

> 
> > +
> > +xfs_ino_t
> > +xfs_dir2_sfe_get_ino(
> > +	struct xfs_dir2_sf	*sfp,
> > +	struct xfs_dir2_sf_entry *sfep)
> > +{
> > +	return xfs_dir2_sf_get_ino(sfp, xfs_dir2_sf_inop(sfep));
> > +}
> > +
> > +static void
> > +xfs_dir2_sfe_put_ino(
> > +	struct xfs_dir2_sf	*sfp,
> > +	struct xfs_dir2_sf_entry *sfep,
> > +	xfs_ino_t		ino)
> > +{
> > +	xfs_dir2_sf_put_inumber(sfp, xfs_dir2_sf_inop(sfep), ino);
> > +}
> > +
> > +
> 
> Extra whitespace.

Fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
