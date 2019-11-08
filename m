Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02427C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAC86214DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbfKHF0X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 00:26:23 -0500
Received: from verein.lst.de ([213.95.11.211]:32927 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfKHF0X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 00:26:23 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4151768BE1; Fri,  8 Nov 2019 06:26:21 +0100 (CET)
Date:   Fri, 8 Nov 2019 06:26:21 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/46] xfs: cleanup xfs_dir2_leaf_getdents
Message-ID: <20191108052621.GA29783@lst.de>
References: <20191107182410.12660-1-hch@lst.de> <20191107182410.12660-31-hch@lst.de> <20191107224157.GL6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107224157.GL6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 02:41:57PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 07, 2019 at 07:23:54PM +0100, Christoph Hellwig wrote:
> > Use an offset as the main means for iteration, and only do pointer
> > arithmetics to find the data/unused entries.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_dir2_readdir.c | 34 +++++++++++++++++-----------------
> >  1 file changed, 17 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > index 0d234b649d65..c4314e9e3dd8 100644
> > --- a/fs/xfs/xfs_dir2_readdir.c
> > +++ b/fs/xfs/xfs_dir2_readdir.c
> > @@ -351,13 +351,13 @@ xfs_dir2_leaf_getdents(
> >  	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
> 
> gcc complained about this variable being set but not used.

Your gcc is obviously smarted than mine, because it is unused.

> 
> >  	xfs_dir2_data_entry_t	*dep;		/* data entry */
> >  	xfs_dir2_data_unused_t	*dup;		/* unused entry */
> > -	char			*ptr = NULL;	/* pointer to current data */
> >  	struct xfs_da_geometry	*geo = args->geo;
> >  	xfs_dablk_t		rablk = 0;	/* current readahead block */
> >  	xfs_dir2_off_t		curoff;		/* current overall offset */
> >  	int			length;		/* temporary length value */
> >  	int			byteoff;	/* offset in current block */
> >  	int			lock_mode;
> > +	unsigned int		offset = 0;
> 
> This is the offset within the block, right?

Yes.

> 
> >  	int			error = 0;	/* error return value */
> >  
> >  	/*
> > @@ -384,7 +384,7 @@ xfs_dir2_leaf_getdents(
> >  		 * If we have no buffer, or we're off the end of the
> >  		 * current buffer, need to get another one.
> >  		 */
> > -		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
> > +		if (!bp || offset + geo->blksize) {
> 
>                            ^^^^^^^^^^^^^^^^^^^^^
> 
> In which case, isn't this always true?  Was this supposed to be
> offset >= geo->blksize?

Yes, fixed up now.
