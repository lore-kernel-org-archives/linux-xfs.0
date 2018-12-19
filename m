Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48831 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbeLSTjZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Dec 2018 14:39:25 -0500
Date: Wed, 19 Dec 2018 20:39:23 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/11] xfs: report IOMAP_F_SHARED from
 xfs_file_iomap_begin_delay
Message-ID: <20181219193923.GF28624@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181203222503.30649-10-hch@lst.de> <20181218233828.GU27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218233828.GU27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 03:38:28PM -0800, Darrick J. Wong wrote:
> > @@ -541,7 +541,7 @@ xfs_file_iomap_begin_delay(
> >  	struct xfs_bmbt_irec	imap, cmap;
> >  	struct xfs_iext_cursor	icur, ccur;
> >  	xfs_fsblock_t		prealloc_blocks = 0;
> > -	bool			eof = false, cow_eof = false, shared;
> > +	bool			eof = false, cow_eof = false, shared = false;
> >  	int			whichfork = XFS_DATA_FORK;
> >  	int			error = 0;
> >  
> > @@ -709,13 +709,14 @@ xfs_file_iomap_begin_delay(
> >  		if (imap.br_startoff > offset_fsb) {
> >  			xfs_trim_extent(&cmap, offset_fsb,
> >  					imap.br_startoff - offset_fsb);
> > -			error = xfs_bmbt_to_iomap(ip, iomap, &cmap, false);
> > +			error = xfs_bmbt_to_iomap(ip, iomap, &cmap, true);
> 
> Does this belong in the previous patch?  (Maybe all of it?)

Not really, as it is just a nice to have thing that is a change of
behavior to what we did before.  So I'd rather have it in a single
patch that documents what exactly we did here and why.
