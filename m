Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECB5CDB47E
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Oct 2023 04:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjJME3w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 00:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJME3w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 00:29:52 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BDBB7
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 21:29:50 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D322167373; Fri, 13 Oct 2023 06:29:47 +0200 (CEST)
Date:   Fri, 13 Oct 2023 06:29:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@osandov.com
Subject: Re: [PATCH 7/8] xfs: create helpers for rtsummary block/wordcount
 computations
Message-ID: <20231013042947.GF5562@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721736.1773834.4052037252966105617.stgit@frogsfrogsfrogs> <20231012062551.GB3667@lst.de> <20231012221836.GP21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012221836.GP21298@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 03:18:36PM -0700, Darrick J. Wong wrote:
> > > @@ -54,8 +55,10 @@ xchk_setup_rtsummary(
> > >  	 * Create an xfile to construct a new rtsummary file.  The xfile allows
> > >  	 * us to avoid pinning kernel memory for this purpose.
> > >  	 */
> > > +	wordcnt = xfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
> > > +			mp->m_sb.sb_rbmblocks);
> > >  	descr = xchk_xfile_descr(sc, "realtime summary file");
> > > -	error = xfile_create(descr, mp->m_rsumsize, &sc->xfile);
> > > +	error = xfile_create(descr, wordcnt << XFS_WORDLOG, &sc->xfile);
> > >  	kfree(descr);
> > 
> > But this confuses me.  What problem does it solve over just using
> > m_rsumsize?
> 
> The rtbitmap and rtsummary repair code should be computing rbmblocks and
> rsumsize from sb_rextents.
> 
> rbmblocks = xfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
> rsumsize = xfs_rtsummary_wordcount(mp, mp->m_rsumlevels, rbmblocks);
> 
> >From that, it should be checking isize and the data fork mappings of
> the file and the superblock values.  Repair ought to map (or unmap)
> blocks as necessary, update isize if needed, and update the superblock
> if the values there are incorrect.

So this is really a feature path that should be documented as such
and not just be about adding a helper?

