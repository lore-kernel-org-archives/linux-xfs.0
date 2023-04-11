Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B79FC76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 05:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjDKFLr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 01:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjDKFLq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 01:11:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC74E50
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 22:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/ApgHsG1i97epkziy/AuvhlegiUalonZ5jzy4oNRjBg=; b=hDZsRvPv/Jwoe6vaJmYTNvFRp0
        6iDnyYhFFxloQwKGuNV9rgRjXXi/n62zKc/A9iCbST7oXFYPxL0y7dHfeeyZXzrq9Z9VbQDXYxN29
        R9CGWjSBDZwPQEMTh+090ynQJ9rv3m+wW6UyXRaLmfRAOS6vnhMTClfQp7GyUDWnVeK/Er82YXIMK
        FTH4FeRQ5zYurHIUa+VcRmOXcsccrBaxI31MStaqh8oCJW4ms/X8f54GKcFskQiwt8tUq+Cs14zvX
        hUxHp6Cu9NoE6U88aGQxzEUmmhiBCIPhemTJsFzbX++Mo3Pa7NwPw4M627ep92syqoEXStHBiC/2o
        95dquFfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm6I9-00GR4L-27;
        Tue, 11 Apr 2023 05:11:41 +0000
Date:   Mon, 10 Apr 2023 22:11:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: _{attr,data}_map_shared should take ILOCK_EXCL
 until iread_extents is completely done
Message-ID: <ZDTsDUVX7c/7ReiL@infradead.org>
References: <20230411010638.GF360889@frogsfrogsfrogs>
 <20230411032035.GZ3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411032035.GZ3223426@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 01:20:35PM +1000, Dave Chinner wrote:
> >  	ASSERT(ir.loaded == xfs_iext_count(ifp));
> > +	smp_mb();
> > +	ifp->if_needextents = 0;
> 
> Hmmm - if this is to ensure that everything above is completed
> before the clearing of this flag is visible everywhere else, then we
> should be able to use load_acquire/store_release semantics? i.e. the
> above is
> 
> 	smp_store_release(ifp->if_needextents, 0);
> 
> and we use
> 
> 	smp_load_acquire(ifp->if_needextents)

Yeah, that's probably better than my READ_ONCE/WRITE_ONCE suggestions
as it also orders vs the previous assignments.

> >  	ifp = xfs_ifork_ptr(ip, whichfork);
> > +	ifp->if_needextents = 1;
> 
> Hmmm - what's the guarantee that the reader will see ifp->if_format
> set correctly if they if_needextents = 1?
> 
> Wouldn't it be better to set this at the same time we set the
> ifp->if_format value? We clear it unconditionally above in
> xfs_iread_extents(), so why not set it unconditionally there, too,
> before we start. i.e.
> 
> 	/*
> 	 * Set the format before we set needsextents with release
> 	 * semantics. This ensures that we can use acquire semantics
> 	 * on needextents in xfs_need_iread_extents() and be
> 	 * guaranteed to see a valid format value after that load.
> 	 */
> 	ifp->if_format = dip->di_format;
> 	smp_store_release(ifp->if_needextents, 1);
> 
> That then means xfs_need_iread_extents() is guaranteed to see a
> valid ifp->if_format if ifp->if_needextents is set if we do:

I'd just drop the if_format check in xfs_need_iread_extents,
which together with the memory barriers should fix all this.
