Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E1ACDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 07:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbjJLH1u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 03:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbjJLH1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 03:27:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B969D
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 00:27:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95052C433C8;
        Thu, 12 Oct 2023 07:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697095667;
        bh=uFOVsO0iA7aERTg561QtZIyfEN81ZReHUhYxtMi3rEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uvWFNVfFW7OtxSkeY822KLUGNK0/bFrW0/i73sSIrS7DPfp+ATEQGOEy+D0Hm9ngf
         CFHDGH2okbPQT4cu1sstJ+7w8Nqvzh1lwraH7kdqkghfyGMxYSaeosg8c70+sU3E3Z
         u/yfR5lpSao+952TLbTPLEEUu8YlyUOP8UV24hnj6RT/qm5SjMm2kmbU6g66UtXH5M
         E44Ma8qReRsi7UZBhO62Ts/yEq/Ln0HlOj9+sFo1kG+uZBmuqdr2lKc6+5Ccuyfv7t
         D/Sxr5EBT4kGs6NCT0OK9+zRW+JcObRaxJYbHPJ8flpg379R2VKtTWZHU3a7KNJhl2
         tuhRlcyIe+tVA==
Date:   Thu, 12 Oct 2023 00:27:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 07/28] fsverity: always use bitmap to track verified
 status
Message-ID: <20231012072746.GA2100@sol.localdomain>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-8-aalbersh@redhat.com>
 <20231011031543.GB1185@sol.localdomain>
 <q75t2etmyq2zjskkquikatp4yg7k2yoyt4oab4grhlg7yu4wyi@6eax4ysvavyk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q75t2etmyq2zjskkquikatp4yg7k2yoyt4oab4grhlg7yu4wyi@6eax4ysvavyk>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 03:03:55PM +0200, Andrey Albershteyn wrote:
> > How complicated would it be to keep supporting using the page bit when
> > merkle_tree_block_size == page_size and the filesystem supports it?  It's an
> > efficient solution, so it would be a shame to lose it.  Also it doesn't have the
> > max file size limit that the bitmap has.
> 
> Well, I think it's possible but my motivation was to step away from
> page manipulation as much as possible with intent to not affect other
> filesystems too much. I can probably add handling of this case to
> fsverity_read_merkle_tree_block() but fs/verity still will create
> bitmap and have a limit. The other way is basically revert changes
> done in patch 09, then, it probably will be quite a mix of page/block
> handling in fs/verity/verify.c

The page-based caching still has to be supported anyway, since that's what the
other filesystems that support fsverity use, and it seems you don't plan to
change that.  The question is where the "block verified" flags should be stored.
Currently there are two options: PG_checked and the separate bitmap.  I'm not
yet convinced that removing the support for the PG_checked method is a good
change.  PG_checked is a nice solution for the cases where it can be used; it
requires no extra memory, no locking, and has no max file size.  Also, this
change seems mostly orthogonal to what you're actually trying to accomplish.

> > > Also, this patch removes spinlock. The lock was used to reset bits
> > > in bitmap belonging to one page. This patch works only with one
> > > Merkle tree block and won't reset other blocks status.
> > 
> > The spinlock is needed when there are multiple Merkle tree blocks per page and
> > the filesystem is using the page-based caching.  So I don't think you can remove
> > it.  Can you elaborate on why you feel it can be removed?
> 
> With this patch is_hash_block_verified() doesn't reset bits for
> blocks belonging to the same page. Even if page is re-instantiated
> only one block is checked in this case. So, when other blocks are
> checked they are reset.
> 
> 	if (block_cached)
> 		return test_bit(hblock_idx, vi->hash_block_verified);

When part of the Merkle tree cache is evicted and re-instantiated, whether that
part is a "page" or something else, the verified status of all the blocks
contained in that part need to be invalidated so that they get re-verified.  The
existing code does that.  I don't see how your proposed code does that.

- Eric
