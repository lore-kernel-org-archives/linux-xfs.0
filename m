Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9849CDB47E
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Oct 2023 17:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjJMRLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 13:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjJMRLo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 13:11:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E60AD
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2023 10:11:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E006C433C8;
        Fri, 13 Oct 2023 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697217103;
        bh=hYAnpioScyYFOwTjnpB2DiSXrXCrAJhk2mgWYz96iGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xmtb4ZzFQzW08ksfqRqOB+pL/XBJmegLn9eCDoAXKAvEf8If2KeGKhwZ1zrdJPGz8
         2nlBWUh2wg+ceBQZp4RTQvPkNBkwNQ29xJs3N5CUsLwyK74ZIrWHcgVIojfcGb2wIp
         rq6VGmi2GWwFr/faK4dDcQ4aUCVZs+pVK9IyJmV323yWuerhlWQc9hQgJeBM/XcwOv
         GefPnpLOhwB4vZp++TnGqHC8+ZW8sMmuVmd9VuJJQw6xFe/xmyCn8IQ0PtUuPLxx1k
         XA/cAlX0VX96oi+Zi+7l8ZbnrOAjwfZoEVwsDAF9RA7DHm8fufztnqa5VfyF67YvLX
         y1xC+1Bkh8wNg==
Date:   Fri, 13 Oct 2023 10:11:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 7/8] xfs: create helpers for rtsummary block/wordcount
 computations
Message-ID: <20231013171142.GB11402@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
 <169704721736.1773834.4052037252966105617.stgit@frogsfrogsfrogs>
 <20231012062551.GB3667@lst.de>
 <20231012221836.GP21298@frogsfrogsfrogs>
 <20231013042947.GF5562@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013042947.GF5562@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 13, 2023 at 06:29:47AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 12, 2023 at 03:18:36PM -0700, Darrick J. Wong wrote:
> > > > @@ -54,8 +55,10 @@ xchk_setup_rtsummary(
> > > >  	 * Create an xfile to construct a new rtsummary file.  The xfile allows
> > > >  	 * us to avoid pinning kernel memory for this purpose.
> > > >  	 */
> > > > +	wordcnt = xfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
> > > > +			mp->m_sb.sb_rbmblocks);
> > > >  	descr = xchk_xfile_descr(sc, "realtime summary file");
> > > > -	error = xfile_create(descr, mp->m_rsumsize, &sc->xfile);
> > > > +	error = xfile_create(descr, wordcnt << XFS_WORDLOG, &sc->xfile);
> > > >  	kfree(descr);
> > > 
> > > But this confuses me.  What problem does it solve over just using
> > > m_rsumsize?
> > 
> > The rtbitmap and rtsummary repair code should be computing rbmblocks and
> > rsumsize from sb_rextents.
> > 
> > rbmblocks = xfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
> > rsumsize = xfs_rtsummary_wordcount(mp, mp->m_rsumlevels, rbmblocks);
> > 
> > >From that, it should be checking isize and the data fork mappings of
> > the file and the superblock values.  Repair ought to map (or unmap)
> > blocks as necessary, update isize if needed, and update the superblock
> > if the values there are incorrect.
> 
> So this is really a feature path that should be documented as such
> and not just be about adding a helper?

Yeah.  If these rt cleanups land before online repair, then that whole
hunk won't be in the patch that we merge anyway.  In that case, I'll
want the helpers simply to reduce the number of things I have to keep
track of.

(meanwhile I think the pre-rtgroups rtbitmap and rtsummary code need
some fixing...)

--D
