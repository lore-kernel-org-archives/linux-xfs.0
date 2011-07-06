Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p668ScFK093208 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:28:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1778D15EB182
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 01:28:37 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uZB3WHmYEjsLwYNC for <xfs@oss.sgi.com>;
	Wed, 06 Jul 2011 01:28:37 -0700 (PDT)
Date: Wed, 6 Jul 2011 04:28:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/27] xfs: kill struct xfs_dir2_sf
Message-ID: <20110706082835.GA19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.197942925@bombadil.infradead.org>
	<20110706015705.GI1026@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110706015705.GI1026@dastard>
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

On Wed, Jul 06, 2011 at 11:57:05AM +1000, Dave Chinner wrote:
> > - * fit into the literal area of the inode.
> > + * Small directories are packed as tightly as possible so as to fit into the
> > + * literal area of the inode.  They consist of a single xfs_dir2_sf_hdr header
> > + * followed by zero or more xfs_dir2_sf_entry structures.  Due the different
> > + * inode number storage sized and the variable length name filed in
>                            size                               field
> > + * the xfs_dir2_sf_entry all these structure are variable length, and the
>                                       structures
> > + * accessors in this file need to be used to iterate over them.
>                              should be

Thanks!

> > -static inline xfs_dir2_sf_entry_t *xfs_dir2_sf_firstentry(xfs_dir2_sf_t *sfp)
> > +static inline xfs_dir2_sf_entry_t *xfs_dir2_sf_firstentry(xfs_dir2_sf_hdr_t *sfp)
> 
> Probably should split this onto two lines.

I'll make sure it'll be fine in the end, not sure which patch it'll get
folded into.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
