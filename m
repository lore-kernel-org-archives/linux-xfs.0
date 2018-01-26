Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49575 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751881AbeAZMRQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 07:17:16 -0500
Date: Fri, 26 Jan 2018 04:17:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/11] xfs: refactor quota code in xfs_bmap_btalloc
Message-ID: <20180126121716.GC15859@infradead.org>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <20180125052647.GF9068@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180125052647.GF9068@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 24, 2018 at 09:26:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since we now have a dedicated function for dealing with CoW allocation
> related quota updates in xfs_bmap_btalloc, we might as well refactor the
> data/attr fork quota update into its own function too.

Any good reason not to have this merged with the cow fork side helper?

> +	/*
> +	 * Adjust the disk quota also. This was reserved
> +	 * earlier.
> +	 */

Please use the full available line length for comments.

> +	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> +		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
> +		(long) args.len);

I don't think we need this cast.
