Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBEBCD98E6
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 03:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345171AbjJKDQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 23:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345052AbjJKDPr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 23:15:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A86691
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2023 20:15:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFB4C433C7;
        Wed, 11 Oct 2023 03:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696994145;
        bh=OVumWVhYu2Vxm/WDR3LSajdVVDZlhEjqAKCZQ8IVLSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QLrRj6K/Hh0sj5lkG3XJTdl/a82CkGfsYUyuIE0eeWbHi8TjzjNqOhcmbuBH6PZg/
         A1z6moEj83XL2cjoNCTgx4vLNGRabPn5mV58Q+bjPomXpnVwICoF7fjo8320tr6kxn
         VJViwkXoLTtG/75wc9YQql+XOs2e4K01Ib+lOc5yEFPxA3dM7REltoJgRz7gB4BVxI
         fFsjbCGAGsKFTVNdJzlWmNyc7o1qMgwwplRzB5Kawl3YyfdAW5es6zgHjKwbRQMf+f
         rfaAbfhAsltzbFn6HjS+5hx6aWqUXAN9hVjoOMbGx3NhcQdt6j0PHixFALTnsRw1pA
         iPtZv5Pfbbz6g==
Date:   Tue, 10 Oct 2023 20:15:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 07/28] fsverity: always use bitmap to track verified
 status
Message-ID: <20231011031543.GB1185@sol.localdomain>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-8-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-8-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:49:01PM +0200, Andrey Albershteyn wrote:
> The bitmap is used to track verified status of the Merkle tree
> blocks which are smaller than a PAGE. Blocks which fits exactly in a
> page - use PageChecked() for tracking "verified" status.
> 
> This patch switches to always use bitmap to track verified status.
> This is needed to move fs-verity away from page management and work
> only with Merkle tree blocks.

How complicated would it be to keep supporting using the page bit when
merkle_tree_block_size == page_size and the filesystem supports it?  It's an
efficient solution, so it would be a shame to lose it.  Also it doesn't have the
max file size limit that the bitmap has.

> Also, this patch removes spinlock. The lock was used to reset bits
> in bitmap belonging to one page. This patch works only with one
> Merkle tree block and won't reset other blocks status.

The spinlock is needed when there are multiple Merkle tree blocks per page and
the filesystem is using the page-based caching.  So I don't think you can remove
it.  Can you elaborate on why you feel it can be removed?

>  /*
> - * Returns true if the hash block with index @hblock_idx in the tree, located in
> - * @hpage, has already been verified.
> + * Returns true if the hash block with index @hblock_idx in the tree has
> + * already been verified.
>   */
> -static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
> -				   unsigned long hblock_idx)
> +static bool is_hash_block_verified(struct fsverity_info *vi,
> +				   unsigned long hblock_idx,
> +				   bool block_cached)
>  {
> -	bool verified;
> -	unsigned int blocks_per_page;
> -	unsigned int i;
> -
> -	/*
> -	 * When the Merkle tree block size and page size are the same, then the
> -	 * ->hash_block_verified bitmap isn't allocated, and we use PG_checked
> -	 * to directly indicate whether the page's block has been verified.
> -	 *
> -	 * Using PG_checked also guarantees that we re-verify hash pages that
> -	 * get evicted and re-instantiated from the backing storage, as new
> -	 * pages always start out with PG_checked cleared.
> -	 */
> -	if (!vi->hash_block_verified)
> -		return PageChecked(hpage);
> -
> -	/*
> -	 * When the Merkle tree block size and page size differ, we use a bitmap
> -	 * to indicate whether each hash block has been verified.
> -	 *
> -	 * However, we still need to ensure that hash pages that get evicted and
> -	 * re-instantiated from the backing storage are re-verified.  To do
> -	 * this, we use PG_checked again, but now it doesn't really mean
> -	 * "checked".  Instead, now it just serves as an indicator for whether
> -	 * the hash page is newly instantiated or not.
> -	 *
> -	 * The first thread that sees PG_checked=0 must clear the corresponding
> -	 * bitmap bits, then set PG_checked=1.  This requires a spinlock.  To
> -	 * avoid having to take this spinlock in the common case of
> -	 * PG_checked=1, we start with an opportunistic lockless read.
> -	 */

Note that the above comment explains why the spinlock is needed.

> -	if (PageChecked(hpage)) {
> -		/*
> -		 * A read memory barrier is needed here to give ACQUIRE
> -		 * semantics to the above PageChecked() test.
> -		 */
> -		smp_rmb();
> +	if (block_cached)
>  		return test_bit(hblock_idx, vi->hash_block_verified);

It's not clear what block_cached is supposed to mean here.

- Eric
