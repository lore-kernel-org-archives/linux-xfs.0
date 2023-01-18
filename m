Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1605C46467
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 16:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjARQNv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 11:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjARQNY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 11:13:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EF0577D3;
        Wed, 18 Jan 2023 08:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JEUOAZ78kJr603e3fslTqPJIm0KVjgSmMPI95SNsLdQ=; b=jk2OX/GHKt+KDBvU+2AWIJn5ry
        QSvBl+h/HCaJiHuccrL+v6bRIufcwCTd0eMLPw1XCRpUNlJt2/bfbsfInmdxoeLrYYKHi7OGjLgOO
        wuAzMNrhOaicl2w+hFj8r+3l6ge4M+Y7Tf9d/yyASO6QxFfm7hHBD4IMTbGeulZC5l3g/Vb+9it3D
        94gz2e1P9UT/wh+6QM64zP7CvRhYB7E/w6Ny0qhYYjx+6RUCXFzz5UR2L+8sEsUYqeHN6WfD88L64
        9qubXFGDeITGtJyWPF50S62gtex3EBM7lI7TX9PRim5NbcZlyBfkHtyPAoWpa/UQ6WykrPInUoJ3z
        QYRfXUVg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIAzh-0007zm-8H; Wed, 18 Jan 2023 16:08:57 +0000
Date:   Wed, 18 Jan 2023 16:08:57 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-afs@lists.infradead.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 8/9] btrfs: handle a NULL folio in
 extent_range_redirty_for_io
Message-ID: <Y8gZmTFB6vCivxsY@casper.infradead.org>
References: <20230118094329.9553-1-hch@lst.de>
 <20230118094329.9553-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118094329.9553-9-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 10:43:28AM +0100, Christoph Hellwig wrote:
> filemap_get_folio can return NULL, skip those cases.

Hmm, I'm not sure that's true.  We have one place that calls
extent_range_redirty_for_io(), and it previously calls
extent_range_clear_dirty_for_io() which has an explicit

                BUG_ON(!page); /* Pages should be in the extent_io_tree */

so I'm going to say this one can't happen either.  I haven't delved far
enough into btrfs to figure out why it can't happen.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/extent_io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d55e4531ffd212..a54d2cf74ba020 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -230,6 +230,8 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
>  
>  	while (index <= end_index) {
>  		folio = filemap_get_folio(mapping, index);
> +		if (!folio)
> +			continue;
>  		filemap_dirty_folio(mapping, folio);
>  		folio_account_redirty(folio);
>  		index += folio_nr_pages(folio);
> -- 
> 2.39.0
> 
