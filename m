Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554F3CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 22:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442993AbjJLWSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 18:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443009AbjJLWSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 18:18:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6874CE3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 15:18:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE130C433C8;
        Thu, 12 Oct 2023 22:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697149116;
        bh=gQLoLlD/psHlSgoJcfUBJ7dv9HskNTI1vs0jLgTezF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DTRBOggiIw0G39fBkMA0gHuVjR7GRvMzGxdcNdyq2hKC7zxW0mKPXKgzZnrxxNQCn
         I1FOMLxEXfRDCyChgnvQ+jUc7qvaBnsoEwhl+8BRmKWvRGlT9djQlLVoGyz57psiff
         a0DRiSUYEEQW6JpJN7mYJhGHaf6HQYUc/Is4vrz0YYcoPEecDY/0HBO2FaVh/OzViB
         BcL2JcDdCPPqOtgfoakBlSSTKVZ5mhEzIeOZ2jZuNZdoxS0XAGyVTCqBtMNJZfSyVE
         hiqmJRVmrxDvzOjRIkbGZdzzSNScm2PVPSYxLHada5S4u1RFamfg74GPyFql9gAYF1
         OJlZgPwP28HMg==
Date:   Thu, 12 Oct 2023 15:18:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 7/8] xfs: create helpers for rtsummary block/wordcount
 computations
Message-ID: <20231012221836.GP21298@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
 <169704721736.1773834.4052037252966105617.stgit@frogsfrogsfrogs>
 <20231012062551.GB3667@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012062551.GB3667@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 08:25:51AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:08:03AM -0700, Darrick J. Wong wrote:
> > +/* Compute the number of rtsummary blocks needed to track the given rt space. */
> > +xfs_filblks_t
> > +xfs_rtsummary_blockcount(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		rsumlevels,
> > +	xfs_extlen_t		rbmblocks)
> > +{
> > +	unsigned long long	rsumwords;
> > +
> > +	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
> > +	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
> > +}
> 
> This helper and its users make complete sense to me and looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > +/*
> > + * Compute the number of rtsummary info words needed to populate every block of
> > + * a summary file that is large enough to track the given rt space.
> > + */
> > +unsigned long long
> > +xfs_rtsummary_wordcount(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		rsumlevels,
> > +	xfs_extlen_t		rbmblocks)
> > +{
> > +	xfs_filblks_t		blocks;
> > +
> > +	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
> > +	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
> > +}
> 
> > @@ -54,8 +55,10 @@ xchk_setup_rtsummary(
> >  	 * Create an xfile to construct a new rtsummary file.  The xfile allows
> >  	 * us to avoid pinning kernel memory for this purpose.
> >  	 */
> > +	wordcnt = xfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
> > +			mp->m_sb.sb_rbmblocks);
> >  	descr = xchk_xfile_descr(sc, "realtime summary file");
> > -	error = xfile_create(descr, mp->m_rsumsize, &sc->xfile);
> > +	error = xfile_create(descr, wordcnt << XFS_WORDLOG, &sc->xfile);
> >  	kfree(descr);
> 
> But this confuses me.  What problem does it solve over just using
> m_rsumsize?

The rtbitmap and rtsummary repair code should be computing rbmblocks and
rsumsize from sb_rextents.

rbmblocks = xfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
rsumsize = xfs_rtsummary_wordcount(mp, mp->m_rsumlevels, rbmblocks);

From that, it should be checking isize and the data fork mappings of
the file and the superblock values.  Repair ought to map (or unmap)
blocks as necessary, update isize if needed, and update the superblock
if the values there are incorrect.

--D
