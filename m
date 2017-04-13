Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23327 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752689AbdDMPwi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 11:52:38 -0400
Date: Thu, 13 Apr 2017 08:52:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: reserve enough blocks to handle btree splits when
 remapping
Message-ID: <20170413155210.GW8502@birch.djwong.org>
References: <20170412214852.GR8502@birch.djwong.org>
 <20170413095311.GA21980@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413095311.GA21980@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Apr 13, 2017 at 02:53:11AM -0700, Christoph Hellwig wrote:
> > +static inline unsigned int
> > +XFS_RMAPADD_SPACE_RES(
> > +	struct xfs_mount	*mp)
> > +{
> > +	return xfs_sb_version_hasrmapbt(&mp->m_sb) ? mp->m_rmap_maxlevels : 0;
> > +}
> 
> All the other helpers are macros.  While I much prefer inlines it might
> be a good idea to do it in one go and also convert them to lower case
> instead of screaming..
> 
> > +#define XFS_NRMAPADD_SPACE_RES(mp,b,w)\
> > +	(((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \
> > +	  XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) * \
> > +	  XFS_RMAPADD_SPACE_RES(mp))
> 
> But then again the above is so much more readable than this, so maybe
> it's a good idea after all and this one should be an inline as well.
> 
> Also I think future developers will really appreciate comments
> explaining what we add up here.

Yeah, I was going to clean this up too but then I distracted myself with
that other bunmapi max_len thing, and by the time I sent it, it was late
evening already.  I'll try to squeeze it in today.

--D

> 
> Otherwise this looks fine and test fine for me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
