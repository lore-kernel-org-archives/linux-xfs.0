Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED50C7EE23
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 17:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjFDR6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 13:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjFDR6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 13:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806C0BD;
        Sun,  4 Jun 2023 10:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1461860B2F;
        Sun,  4 Jun 2023 17:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E5FC433EF;
        Sun,  4 Jun 2023 17:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685901492;
        bh=dLDXF1XgacBVFEQEKeT2uVfRRN9gBZ9P2YcvSsngpE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oijjlbC6vAyW7Chvu8CilrlkOdldBm7SMPOv/dc5m4D5eyItKYY5oAxDp3DFG7Nwr
         r0YbPRoFm8Dz6Cz/6Ia26f9qg9+PbRmIDUclmezdm6Ovzsal2NLeVm1L6JgOicPh91
         gSCu+yXbVUbzGIB0b8xv1L4eS96H8fnkvrcQfixOHsps96JrLLMmUV+Zi0Wskvng6c
         NHvIytztWhG2/0ofb0upBPKHZkXWRUPcWVBat6VSl6CprrdeSb7h7i69zeGXZU2/mz
         /D9Wu2nuFx/6cegXWnfufqfemm4uvEWgSMX/DQawpagYBN6FkCuOmW8bCY3F9Hfzqg
         WqnacgYj534zw==
Date:   Sun, 4 Jun 2023 10:58:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/7] iomap: Remove large folio handling in
 iomap_invalidate_folio()
Message-ID: <20230604175811.GC72241@frogsfrogsfrogs>
References: <20230602222445.2284892-1-willy@infradead.org>
 <20230602222445.2284892-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602222445.2284892-2-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2023 at 11:24:38PM +0100, Matthew Wilcox (Oracle) wrote:
> We do not need to release the iomap_page in iomap_invalidate_folio()
> to allow the folio to be split.  The splitting code will call
> ->release_folio() if there is still per-fs private data attached to
> the folio.  At that point, we will check if the folio is still dirty
> and decline to release the iomap_page.  It is possible to trigger the
> warning in perfectly legitimate circumstances (eg if a disk read fails,
> we do a partial write to the folio, then we truncate the folio), which
> will cause those writes to be lost.
> 
> Fixes: 60d8231089f0 ("iomap: Support large folios in invalidatepage")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Sounds reasonable to me...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 063133ec77f4..08ee293c4117 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -508,11 +508,6 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len)
>  		WARN_ON_ONCE(folio_test_writeback(folio));
>  		folio_cancel_dirty(folio);
>  		iomap_page_release(folio);
> -	} else if (folio_test_large(folio)) {
> -		/* Must release the iop so the page can be split */
> -		WARN_ON_ONCE(!folio_test_uptodate(folio) &&
> -			     folio_test_dirty(folio));
> -		iomap_page_release(folio);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
> -- 
> 2.39.2
> 
