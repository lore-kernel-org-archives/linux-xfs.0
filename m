Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35176 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbeAZVrL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 16:47:11 -0500
Date: Fri, 26 Jan 2018 13:46:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/11] xfs: refactor quota code in xfs_bmap_btalloc
Message-ID: <20180126214653.GF9068@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <20180125052647.GF9068@magnolia>
 <20180126121716.GC15859@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126121716.GC15859@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 26, 2018 at 04:17:16AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 24, 2018 at 09:26:47PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since we now have a dedicated function for dealing with CoW allocation
> > related quota updates in xfs_bmap_btalloc, we might as well refactor the
> > data/attr fork quota update into its own function too.
> 
> Any good reason not to have this merged with the cow fork side helper?
> 
> > +	/*
> > +	 * Adjust the disk quota also. This was reserved
> > +	 * earlier.
> > +	 */
> 
> Please use the full available line length for comments.
> 
> > +	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> > +		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
> > +		(long) args.len);
> 
> I don't think we need this cast.

I fixed all of these; will have a new series out soon.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
