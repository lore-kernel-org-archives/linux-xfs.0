Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p668hwmJ095181 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:43:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70F914E40F5
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 01:43:58 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ANQp4boofJYPox1n for <xfs@oss.sgi.com>;
	Wed, 06 Jul 2011 01:43:58 -0700 (PDT)
Date: Wed, 6 Jul 2011 04:43:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/27] xfs: avoid usage of struct xfs_dir2_data
Message-ID: <20110706084357.GF19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.003170984@bombadil.infradead.org>
	<20110706030228.GM1026@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110706030228.GM1026@dastard>
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

On Wed, Jul 06, 2011 at 01:02:28PM +1000, Dave Chinner wrote:
> > @@ -251,12 +258,13 @@ xfs_dir2_data_freeinsert(
> >  	xfs_dir2_data_free_t	new;		/* new bestfree entry */
> >  
> >  #ifdef __KERNEL__
> > -	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
> > -	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
> > +	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
> > +	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
> >  #endif
> 
> You kill the ifdef __KERNEL__ there.

If I do it I'd rather do it as a sepaarate patch, and after actually
testing it with xfsprogs.

> >  			if (!needscan) {
> > -				xfs_dir2_data_freeremove(d, dfp, needlogp);
> > -				(void)xfs_dir2_data_freeinsert(d, newdup,
> > +				xfs_dir2_data_freeremove(hdr, dfp, needlogp);
> > +				(void)xfs_dir2_data_freeinsert(hdr, newdup,
> >  					needlogp);
> > -				(void)xfs_dir2_data_freeinsert(d, newdup2,
> > +				(void)xfs_dir2_data_freeinsert(hdr, newdup2,
> >  					needlogp);
> >  			}
> >  		}
> 
> Kill the (void) casts?
> 

Sounds fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
