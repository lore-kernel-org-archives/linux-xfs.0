Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357ECC0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 13:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbjGMNq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 09:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjGMNqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 09:46:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB07C1;
        Thu, 13 Jul 2023 06:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5zMPdHgcCQorMIXCRQ+kpqVbFgN25dPBxYj3SWeYA9I=; b=mBGHrVdo0Zv0kpsyXPtTbcfgEa
        ISUHoXCuXP2rspQ2hVvTR3PXV1iUkV0SnTsyt4U2umU5TVU5XtNh8XugRgTtyjfolWVP8js7NSqIw
        LoedGe4KZMwtWJRuEvGWcUPyPhZM23eekUOYzA9XNbfNc0glodGFLP5WARA8tAfQjn11g/NuWth46
        Ed34Jf84oetFQRjzKlkaq81cqLv4eAQOIph/MBAPR3DK87Ml56D1K3psW/5rDOAGAgXtu6F8ucJ0/
        liFc6wL95d7QhvGMLS9/Z8nDcE38ZklMzw3SKjGK2pUnb7VCZ3DgFZV/zvjPEXt2FF/HNrGDpKELO
        rgfkWE6A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJwe9-000C9S-R6; Thu, 13 Jul 2023 13:46:17 +0000
Date:   Thu, 13 Jul 2023 14:46:17 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH v4 1/9] iov_iter: Handle compound highmem pages in
 copy_page_from_iter_atomic()
Message-ID: <ZLAAKSZ0wXP54AfF@casper.infradead.org>
References: <20230710130253.3484695-1-willy@infradead.org>
 <20230710130253.3484695-2-willy@infradead.org>
 <20230713044207.GH108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713044207.GH108251@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 09:42:07PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 10, 2023 at 02:02:45PM +0100, Matthew Wilcox (Oracle) wrote:
> > copy_page_from_iter_atomic() already handles !highmem compound
> > pages correctly, but if we are passed a highmem compound page,
> > each base page needs to be mapped & unmapped individually.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Yikes.  Does this want a fixes tag?

I was wondering the same thing.  I think the bug is merely latent,
and all existing users limit themselves to being within the page
that they're passing in.
