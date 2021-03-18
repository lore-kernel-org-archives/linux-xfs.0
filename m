Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D328EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 04:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9364E64F10
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 04:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhCREd6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 00:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhCREda (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 00:33:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D76C64F10;
        Thu, 18 Mar 2021 04:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616042010;
        bh=pCNRdUEaS30g4b5CNCA/Gpe0d+onpxPjWvDNP6WAuN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cjdnYhiO8rhFRefjAlh7B47/5e+vj2ubxt/IZ2KsfY8n+BfARHQpBtagXdybOjkDv
         SKMl9vNXZVxbzZMi+CRQoDUxRF7Srw+8Bs4vevGR9BoCqQCmIQicpfs3l+UZP3tJvI
         9hJ2x1gqjfKhFwkTT2HZ8wJnjHxFIGes5lJJ2SCb8FP7Tx9B9yfERjG8HDKA2EoVHd
         y+SVCYSOIvh/P1/7nUGG5tu9n2zyJbK4vwZAI+lvb6um+pKPSdzvl4CVerUspeTWhZ
         wIgp0SipG4gOmODvOF5Gxwh9vQQ+bGXZzHRNFM3aSqKl2EAAGoxBycYlFMZHvMuyua
         n4m/LHKVJ0TOQ==
Date:   Wed, 17 Mar 2021 21:33:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: refactor the predicate part of
 xfs_free_eofblocks
Message-ID: <20210318043329.GJ22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543195167.1947934.16237799936089844524.stgit@magnolia>
 <20210315184615.GB140421@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315184615.GB140421@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 06:46:15PM +0000, Christoph Hellwig wrote:
> Going further through the series actually made me go back to this one,
> so a few more comments:
> 
> >  /*
> > + * Decide if this inode have post-EOF blocks.  The caller is responsible
> > + * for knowing / caring about the PREALLOC/APPEND flags.
> 
> Please spell out the XFS_DIFLAG_ here, as this really confused me.  In
> fact even with that it still confuses me, as "caller is responsible"
> here really means: only call this if you previously called
> xfs_can_free_eofblocks and it return true.

Sorry about that; I'll spell them out in the future.

> Which brings me to the structure of this:  I think without much pain
> we can ensure xfs_can_free_eofblocks is always called with the iolock,
> in which case we really should merge xfs_can_free_eofblocks and this
> new helper to avoid the rather confusing fact that we have two similarly
> named helper doing similiar but not the same thing.

I'll have a look into that tomorrow morning. :)

> >  int
> > +xfs_has_eofblocks(
> > +	struct xfs_inode	*ip,
> > +	bool			*has)
> 
> I also think the calling convention can be simplified here.  If an
> error occurs we obviously do not want to free the eofblocks.  So
> instead of returning two calues we can just return a single bool.

Yeah, this area needs some simplification.  Will do.

--D
