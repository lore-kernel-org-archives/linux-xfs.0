Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6F2EB64D9
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jun 2023 14:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjFSO00 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 10:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjFSO00 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2023 10:26:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CD2E7;
        Mon, 19 Jun 2023 07:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PGke1o7SJJYJg7mh7bo7HBv4qqYeX/5Bm/JlwCFjPtc=; b=f5wgmZgWdZ/eXaVG6JqXIh+iry
        LGxYzMaV2TiTNGyo8A9eJrxxXCIh/7kYmUyDahGjW+fGPVpLe7SoDdJM19x0ECUlZ9N57ybIn789N
        XJ3qAzCNaOMLl8HXcCr2FCP9q6mFTqoZ+0ekv1OmE/6VGnxiDvJZA3QBaeocqPk3J1evn/MdLoTII
        d4BVBZolLcSqclZtMvmIsp6vUAxuooYQukmo26PjLhgaNnWiABAhaFh39nLPnT/lrzxMBhEvW1R5I
        Vs/7J2dpP2x1vDPcxb8pT3ByONlQrUnQ/TpXS+Wn5v49MHs2imx4Obt10LaKWjCPmEBBzSAugxnh6
        xSxq0fug==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qBFpj-00Bx1S-DF; Mon, 19 Jun 2023 14:26:19 +0000
Date:   Mon, 19 Jun 2023 15:26:19 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>,
        Aravinda Herle <araherle@in.ibm.com>
Subject: Re: [PATCHv10 8/8] iomap: Add per-block dirty state tracking to
 improve performance
Message-ID: <ZJBli4JznbJkyF0U@casper.infradead.org>
References: <cover.1687140389.git.ritesh.list@gmail.com>
 <6db62a08dda3a348303e2262454837149c2afe2a.1687140389.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6db62a08dda3a348303e2262454837149c2afe2a.1687140389.git.ritesh.list@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 19, 2023 at 07:58:51AM +0530, Ritesh Harjani (IBM) wrote:
> +static void ifs_calc_range(struct folio *folio, size_t off, size_t len,
> +		enum iomap_block_state state, unsigned int *first_blkp,
> +		unsigned int *nr_blksp)
> +{
> +	struct inode *inode = folio->mapping->host;
> +	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> +	unsigned int first = off >> inode->i_blkbits;
> +	unsigned int last = (off + len - 1) >> inode->i_blkbits;
> +
> +	*first_blkp = first + (state * blks_per_folio);
> +	*nr_blksp = last - first + 1;
> +}

As I said, this is not 'first_blkp'.  It's first_bitp.  I think this
misunderstanding is related to Andreas' complaint, but it's not quite
the same.

>  static inline bool ifs_is_fully_uptodate(struct folio *folio,
>  					       struct iomap_folio_state *ifs)
>  {
>  	struct inode *inode = folio->mapping->host;
> +	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> +	unsigned int nr_blks = (IOMAP_ST_UPTODATE + 1) * blks_per_folio;
>  
> -	return bitmap_full(ifs->state, i_blocks_per_folio(inode, folio));
> +	return bitmap_full(ifs->state, nr_blks);

I think we have a gap in our bitmap APIs.  We don't have a
'bitmap_range_full(src, pos, nbits)'.  We could use find_next_zero_bit(),
but that's going to do more work than necessary.

Given this lack, perhaps it's time to say that you're making all of
this too hard by using an enum, and pretending that we can switch the
positions of 'uptodate' and 'dirty' in the bitmap just by changing
the enum.  Define the uptodate bits to be the first ones in the bitmap,
document it (and why), and leave it at that.

