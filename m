Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p661v9MS060141 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 20:57:09 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 789AAE7DF3F
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 18:57:07 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5yaWRgaEuIvnJ3DC for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 18:57:07 -0700 (PDT)
Date: Wed, 6 Jul 2011 11:57:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/27] xfs: kill struct xfs_dir2_sf
Message-ID: <20110706015705.GI1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.197942925@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094605.197942925@bombadil.infradead.org>
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

On Fri, Jul 01, 2011 at 05:43:35AM -0400, Christoph Hellwig wrote:
> The list field of it is never cactually used, so all uses can simply be
> replaced with the xfs_dir2_sf_hdr_t type that it has as first member.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> - * fit into the literal area of the inode.
> + * Small directories are packed as tightly as possible so as to fit into the
> + * literal area of the inode.  They consist of a single xfs_dir2_sf_hdr header
> + * followed by zero or more xfs_dir2_sf_entry structures.  Due the different
> + * inode number storage sized and the variable length name filed in
                           size                               field
> + * the xfs_dir2_sf_entry all these structure are variable length, and the
                                      structures
> + * accessors in this file need to be used to iterate over them.
                             should be

>  static inline int
> -xfs_dir2_sf_entsize_byentry(xfs_dir2_sf_t *sfp, xfs_dir2_sf_entry_t *sfep)
> +xfs_dir2_sf_entsize_byentry(xfs_dir2_sf_hdr_t *sfp, xfs_dir2_sf_entry_t *sfep)
>  {
>  	return ((uint)sizeof(xfs_dir2_sf_entry_t) - 1 + (sfep)->namelen - \
> -		((sfp)->hdr.i8count == 0) * \
> +		((sfp)->i8count == 0) * \
>  		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
>  }
>  
> -static inline xfs_dir2_sf_entry_t *xfs_dir2_sf_firstentry(xfs_dir2_sf_t *sfp)
> +static inline xfs_dir2_sf_entry_t *xfs_dir2_sf_firstentry(xfs_dir2_sf_hdr_t *sfp)

Probably should split this onto two lines.

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
