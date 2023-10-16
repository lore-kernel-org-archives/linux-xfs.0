Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EEECDB482
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Oct 2023 11:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbjJPLxc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 07:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbjJPLxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 07:53:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD76EF2
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 04:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697457152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EpjjjpI+CcetBm4Yz9ltGQfVIhFEPGa0DNis6Y4vXbs=;
        b=DoGvX7z2ESN6SXHseBJx184Zm2SIwe5fpATrULsjgoztSAZLLg96qoHex7rkm3n8cfL2A/
        ld9TmxVTi8lGlZOuk6uLbzJ8ba2z088/VFKZadAwrw2QJfzBQBCN3i0V2H+cPPIsakTXGt
        pRJkzRPrZRHkOAeh6RQyke8Vm2jjBdg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-sq4WOehNO0eNrObCI0aJJQ-1; Mon, 16 Oct 2023 07:52:31 -0400
X-MC-Unique: sq4WOehNO0eNrObCI0aJJQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9b99b6b8315so324782366b.2
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 04:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697457150; x=1698061950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpjjjpI+CcetBm4Yz9ltGQfVIhFEPGa0DNis6Y4vXbs=;
        b=hHHLkf28INJxP4MbRWu2rNQeKCtRGuaJT6J7y5327+KtBobcqeGfRxuivK680gCdXX
         afZBdh+oaNc68QuHWgvtcOLpq6qz1twCFIX0SsNqO96+GbHQUctH8zeDKEeLubHncGdA
         1ViRWO7nTdgkdwqWAGNzo0C2kPP3IYcKEeUAvtXyD1eaNp4JpeecqgWCdiTcFrZGi0pR
         it22pa5z1jnW6QG1BxmdRC8SnkTloNHRdT/1laxrm7sUSZ+sRRr//IAMu8K/vFa8LxB1
         zukjbVED9qsxjYDGOLw+secpT847qwoolZ/BPU0PdFQxZr8WEYMbH1PKXyegqDId2v+k
         Vn5Q==
X-Gm-Message-State: AOJu0YyGaUV0e5bMNal88ZlGF6w93j5oITojhvZbVo9HSXi+bCvM5DXs
        2aOxZD5TkFiF6dP4EsMuAuuWYdKPKUqkmDOI7A4XRKHPKWufCoxW+kzFkjNgDxPzoRH1EPTxkxi
        sEu21tr6bkKPiEFhGWWU=
X-Received: by 2002:a17:906:c5:b0:9ad:c763:bc7a with SMTP id 5-20020a17090600c500b009adc763bc7amr27669202eji.23.1697457149983;
        Mon, 16 Oct 2023 04:52:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFSCUVmEo1L8d3XJ7xkQ6joZaZ2X6LocBmhuntEO3d2GoDh6Vxeex/0uU/r0D/hWnuhOSsQg==
X-Received: by 2002:a17:906:c5:b0:9ad:c763:bc7a with SMTP id 5-20020a17090600c500b009adc763bc7amr27669185eji.23.1697457149610;
        Mon, 16 Oct 2023 04:52:29 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id n25-20020a17090673d900b0099297782aa9sm3834603ejl.49.2023.10.16.04.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 04:52:29 -0700 (PDT)
Date:   Mon, 16 Oct 2023 13:52:28 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 07/28] fsverity: always use bitmap to track verified
 status
Message-ID: <256y7jz5u6yj6d7gxoy7oo26eltcpcy43ugc2plog6fpcyz3tq@visdz2fzs7yc>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-8-aalbersh@redhat.com>
 <20231011031543.GB1185@sol.localdomain>
 <q75t2etmyq2zjskkquikatp4yg7k2yoyt4oab4grhlg7yu4wyi@6eax4ysvavyk>
 <20231012072746.GA2100@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012072746.GA2100@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-12 00:27:46, Eric Biggers wrote:
> On Wed, Oct 11, 2023 at 03:03:55PM +0200, Andrey Albershteyn wrote:
> > > How complicated would it be to keep supporting using the page bit when
> > > merkle_tree_block_size == page_size and the filesystem supports it?  It's an
> > > efficient solution, so it would be a shame to lose it.  Also it doesn't have the
> > > max file size limit that the bitmap has.
> > 
> > Well, I think it's possible but my motivation was to step away from
> > page manipulation as much as possible with intent to not affect other
> > filesystems too much. I can probably add handling of this case to
> > fsverity_read_merkle_tree_block() but fs/verity still will create
> > bitmap and have a limit. The other way is basically revert changes
> > done in patch 09, then, it probably will be quite a mix of page/block
> > handling in fs/verity/verify.c
> 
> The page-based caching still has to be supported anyway, since that's what the
> other filesystems that support fsverity use, and it seems you don't plan to
> change that.  The question is where the "block verified" flags should be stored.
> Currently there are two options: PG_checked and the separate bitmap.  I'm not
> yet convinced that removing the support for the PG_checked method is a good
> change.  PG_checked is a nice solution for the cases where it can be used; it
> requires no extra memory, no locking, and has no max file size.  Also, this
> change seems mostly orthogonal to what you're actually trying to accomplish.

Yes, I was trying to combine PG_checked and bitmap in the way it can
be also used by XFS. I will try change this patch to not drop
merkle_tree_block_size == page_size case.

> > > > Also, this patch removes spinlock. The lock was used to reset bits
> > > > in bitmap belonging to one page. This patch works only with one
> > > > Merkle tree block and won't reset other blocks status.
> > > 
> > > The spinlock is needed when there are multiple Merkle tree blocks per page and
> > > the filesystem is using the page-based caching.  So I don't think you can remove
> > > it.  Can you elaborate on why you feel it can be removed?
> > 
> > With this patch is_hash_block_verified() doesn't reset bits for
> > blocks belonging to the same page. Even if page is re-instantiated
> > only one block is checked in this case. So, when other blocks are
> > checked they are reset.
> > 
> > 	if (block_cached)
> > 		return test_bit(hblock_idx, vi->hash_block_verified);
> 
> When part of the Merkle tree cache is evicted and re-instantiated, whether that
> part is a "page" or something else, the verified status of all the blocks
> contained in that part need to be invalidated so that they get re-verified.  The
> existing code does that.  I don't see how your proposed code does that.

Oh, I see the problem now, I will revert it back.

-- 
- Andrey

