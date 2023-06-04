Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E65C7EE29
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 18:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjFDSBp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 14:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjFDSBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 14:01:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EC3DE;
        Sun,  4 Jun 2023 11:01:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E88D8616D7;
        Sun,  4 Jun 2023 18:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F356C433EF;
        Sun,  4 Jun 2023 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685901702;
        bh=ipa5uFdfOgrZ7IHxpyTgm3WGYatfpqgmkX9MWiIY23g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d9ZuUEwLAlPwn0CRFpqVNmiDuErNWmv92oTM49RiTO4ELgah9k1Y1F0liABhpefcS
         wz3GnMJQJcDNncCkBr04uYVDxG7DcF4wcmgYMUldak7vc6q17AdTJEWjNFKgbTeAgP
         zKJpw7iivkva3JN0IeVgasgfcDyDsCxoYg0OerRnFm9hN7MJNgwIwV2jpaTnmVkUPn
         4CP92370xLvGI1+qsBGOHIXVJbdAer4PZVX0L2WVxPlEnYBR392h3zLyO7muA3SDt6
         4pIa52gPJCpXqehB+sraEUfCLX3h34cmUQ8p+nVBsjvFKvsPJ0V2MJwDYp9ifCNR1k
         ndmASpVwDdEQw==
Date:   Sun, 4 Jun 2023 11:01:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/7] iomap: Remove unnecessary test from
 iomap_release_folio()
Message-ID: <20230604180141.GD72241@frogsfrogsfrogs>
References: <20230602222445.2284892-1-willy@infradead.org>
 <20230602222445.2284892-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602222445.2284892-4-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2023 at 11:24:40PM +0100, Matthew Wilcox (Oracle) wrote:
> The check for the folio being under writeback is unnecessary; the caller
> has checked this and the folio is locked, so the folio cannot be under
> writeback at this point.

Do we need a debug assertion here to validate that filemap_release_folio
has already filtered out folios unergoing writeback?  The documentation
change in the next patch might be fine since you're the pagecache
maintainer.

> The comment is somewhat misleading in that it talks about one specific
> situation in which we can see a dirty folio.  There are others, so change
> the comment to explain why we can't release the iomap_page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/iomap/buffered-io.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 08ee293c4117..2054b85c9d9b 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -483,12 +483,10 @@ bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags)
>  			folio_size(folio));
>  
>  	/*
> -	 * mm accommodates an old ext3 case where clean folios might
> -	 * not have had the dirty bit cleared.  Thus, it can send actual
> -	 * dirty folios to ->release_folio() via shrink_active_list();
> -	 * skip those here.
> +	 * If the folio is dirty, we refuse to release our metadata because
> +	 * it may be partially dirty (FIXME, add a test for that).

Er... is this FIXME reflective of incomplete code?

--D

>  	 */
> -	if (folio_test_dirty(folio) || folio_test_writeback(folio))
> +	if (folio_test_dirty(folio))
>  		return false;
>  	iomap_page_release(folio);
>  	return true;
> -- 
> 2.39.2
> 
