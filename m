Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ED8C433E5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 17:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 764BE206F5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 17:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595437549;
	bh=3fUGIZwFHgL3WIRMkHlvThy1u8nPZ1YArv5tmMPYnzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MCVt9guCtLLLxfOqq+RuJojjSh85ZSCph+BQ7ieb8NNXg75yOAx2Plm/eq16whLPo
	 Zv4gn7d3ClcuY+oNsWUWMSgYl0NHeECbuXou4DanWcusg2Usbx9dMVhS0d7oZ+WqCq
	 wvrp0RcNCdVCEVe0zvIRd9qy7YdghSAoc/Dgeo3E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgGVRFs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 13:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgGVRFs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Jul 2020 13:05:48 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F96207BB;
        Wed, 22 Jul 2020 17:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595437547;
        bh=3fUGIZwFHgL3WIRMkHlvThy1u8nPZ1YArv5tmMPYnzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rV6AgUYiCmyyMfmJoulKmtFScwMM12pb4dqlXP/dAfs8dbcrRV/MDQdzc2fEMrbuO
         ncwnYHF55bXGOToPc9wZE4q83ITqQDjG//F9Ru3k5ki61aCjARm8qd31ZpBlYDP7Av
         kDtmVI9wWF4NIvSyZxbve1PyBPUL/swTSL1zRG2c=
Date:   Wed, 22 Jul 2020 10:05:47 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v4 2/7] direct-io: add support for fscrypt using
 blk-crypto
Message-ID: <20200722170547.GE3912099@google.com>
References: <20200720233739.824943-1-satyat@google.com>
 <20200720233739.824943-3-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720233739.824943-3-satyat@google.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07/20, Satya Tangirala wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Set bio crypt contexts on bios by calling into fscrypt when required,
> and explicitly check for DUN continuity when adding pages to the bio.
> (While DUN continuity is usually implied by logical block contiguity,
> this is not the case when using certain fscrypt IV generation methods
> like IV_INO_LBLK_32).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Co-developed-by: Satya Tangirala <satyat@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>

Reviwed-by: Jaegeuk Kim <jaegeuk@kernel.org>

> ---
>  fs/direct-io.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 6d5370eac2a8..f27f7e3780ee 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -24,6 +24,7 @@
>  #include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/fs.h>
> +#include <linux/fscrypt.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/highmem.h>
> @@ -411,6 +412,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
>  	      sector_t first_sector, int nr_vecs)
>  {
>  	struct bio *bio;
> +	struct inode *inode = dio->inode;
>  
>  	/*
>  	 * bio_alloc() is guaranteed to return a bio when allowed to sleep and
> @@ -418,6 +420,9 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
>  	 */
>  	bio = bio_alloc(GFP_KERNEL, nr_vecs);
>  
> +	fscrypt_set_bio_crypt_ctx(bio, inode,
> +				  sdio->cur_page_fs_offset >> inode->i_blkbits,
> +				  GFP_KERNEL);
>  	bio_set_dev(bio, bdev);
>  	bio->bi_iter.bi_sector = first_sector;
>  	bio_set_op_attrs(bio, dio->op, dio->op_flags);
> @@ -782,9 +787,17 @@ static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
>  		 * current logical offset in the file does not equal what would
>  		 * be the next logical offset in the bio, submit the bio we
>  		 * have.
> +		 *
> +		 * When fscrypt inline encryption is used, data unit number
> +		 * (DUN) contiguity is also required.  Normally that's implied
> +		 * by logical contiguity.  However, certain IV generation
> +		 * methods (e.g. IV_INO_LBLK_32) don't guarantee it.  So, we
> +		 * must explicitly check fscrypt_mergeable_bio() too.
>  		 */
>  		if (sdio->final_block_in_bio != sdio->cur_page_block ||
> -		    cur_offset != bio_next_offset)
> +		    cur_offset != bio_next_offset ||
> +		    !fscrypt_mergeable_bio(sdio->bio, dio->inode,
> +					   cur_offset >> dio->inode->i_blkbits))
>  			dio_bio_submit(dio, sdio);
>  	}
>  
> -- 
> 2.28.0.rc0.105.gf9edc3c819-goog
