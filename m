Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE26CD6E64
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 13:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjJKNEz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 09:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjJKNEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 09:04:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF85EA7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 06:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697029449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vcjxFApevYb82qtuqxNQX9mHDiHm2BlEhPt3ZccGP80=;
        b=SwB8C4AEqvJDJg0oRtV/mzDnyXA70+bU+l4vvPIW+oH3qUlTmziYG/4B+AnCCb6n28c5Xe
        h1uXYU6cnzLF4b/QY30fWjCQzPvdNDsSLQ0iSsrI1g0IPhuUHmcXtCIY95/3ezwomKxLDd
        bMkWdLPqOInwBKPL1LTO9Jwz9zlJ0rA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-nNnc68KOOB6jfT3oic2MOA-1; Wed, 11 Oct 2023 09:03:57 -0400
X-MC-Unique: nNnc68KOOB6jfT3oic2MOA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-53a7cb6ee43so1113382a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 06:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697029437; x=1697634237;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vcjxFApevYb82qtuqxNQX9mHDiHm2BlEhPt3ZccGP80=;
        b=UoLAKLv9VE5A0HjZLckJ+0+gQiKkV/YLBlO8CdV0yVIv7l2q53UBoLyLjNaZxN6cz8
         8YlmuTJQ1dGrPGpEoBota8jxKrDQe0a4hvSpcQRycUePt0cRRz0HZF6qHSP1QjwGG2PN
         CJoNtsmctI2Y2+hUKWem9ZseBbLvwvJWJTwcaMymdDdQ2wNMWvs7tLJmq6D3lGtf73TB
         pIO6rbl8yk1xE1r8+KIfKIgaZzJQBmTebm1sNGSuoar7k/9lcMn1fyaOfO75IE3noQBh
         KFhXvi4j55y6GVh11E8S2BpSCrH7yRhn7N3I2dndAPTt0MRuYqyV+qUNh9W1tf6F4wY+
         U6LQ==
X-Gm-Message-State: AOJu0YwFfSdVA2FBb8LPm81HCsXGuNoNAQJbaK75Z5IZ/wZZf5OLIMF0
        g5O3JKr/vSIHE4AtDOnsqM30JabL0feNPCy+3VjMoONWkRmcXW+BjhPsyMxRlXox5dZPI5J9LN6
        97bEoAw5YFTBCM/C/YJI=
X-Received: by 2002:a05:6402:22a2:b0:52f:86a1:3861 with SMTP id cx2-20020a05640222a200b0052f86a13861mr16163326edb.7.1697029436841;
        Wed, 11 Oct 2023 06:03:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZEvueQYrwAAq5x464YyQHDNKA6a56GKCk88BLyTHffcIh2aUnXX9p1BjNOaOf1lgPTbG4wg==
X-Received: by 2002:a05:6402:22a2:b0:52f:86a1:3861 with SMTP id cx2-20020a05640222a200b0052f86a13861mr16163315edb.7.1697029436539;
        Wed, 11 Oct 2023 06:03:56 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id cw2-20020a056402228200b0053dea07b669sm467377edb.87.2023.10.11.06.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 06:03:56 -0700 (PDT)
Date:   Wed, 11 Oct 2023 15:03:55 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 07/28] fsverity: always use bitmap to track verified
 status
Message-ID: <q75t2etmyq2zjskkquikatp4yg7k2yoyt4oab4grhlg7yu4wyi@6eax4ysvavyk>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-8-aalbersh@redhat.com>
 <20231011031543.GB1185@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011031543.GB1185@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-10 20:15:43, Eric Biggers wrote:
> On Fri, Oct 06, 2023 at 08:49:01PM +0200, Andrey Albershteyn wrote:
> > The bitmap is used to track verified status of the Merkle tree
> > blocks which are smaller than a PAGE. Blocks which fits exactly in a
> > page - use PageChecked() for tracking "verified" status.
> > 
> > This patch switches to always use bitmap to track verified status.
> > This is needed to move fs-verity away from page management and work
> > only with Merkle tree blocks.
> 
> How complicated would it be to keep supporting using the page bit when
> merkle_tree_block_size == page_size and the filesystem supports it?  It's an
> efficient solution, so it would be a shame to lose it.  Also it doesn't have the
> max file size limit that the bitmap has.

Well, I think it's possible but my motivation was to step away from
page manipulation as much as possible with intent to not affect other
filesystems too much. I can probably add handling of this case to
fsverity_read_merkle_tree_block() but fs/verity still will create
bitmap and have a limit. The other way is basically revert changes
done in patch 09, then, it probably will be quite a mix of page/block
handling in fs/verity/verify.c

> > Also, this patch removes spinlock. The lock was used to reset bits
> > in bitmap belonging to one page. This patch works only with one
> > Merkle tree block and won't reset other blocks status.
> 
> The spinlock is needed when there are multiple Merkle tree blocks per page and
> the filesystem is using the page-based caching.  So I don't think you can remove
> it.  Can you elaborate on why you feel it can be removed?

With this patch is_hash_block_verified() doesn't reset bits for
blocks belonging to the same page. Even if page is re-instantiated
only one block is checked in this case. So, when other blocks are
checked they are reset.

	if (block_cached)
		return test_bit(hblock_idx, vi->hash_block_verified);

> > -	if (PageChecked(hpage)) {
> > -		/*
> > -		 * A read memory barrier is needed here to give ACQUIRE
> > -		 * semantics to the above PageChecked() test.
> > -		 */
> > -		smp_rmb();
> > +	if (block_cached)
> >  		return test_bit(hblock_idx, vi->hash_block_verified);
> 
> It's not clear what block_cached is supposed to mean here.

If block was re-instantiated or was in cache. I can try to come up
with better name.

-- 
- Andrey

