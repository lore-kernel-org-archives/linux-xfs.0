Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FDD347514
	for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 12:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776773056; cv=none; b=fY4LbJbypXR9IiKVPKMp3KtKfyNwhGDv3iJ9Fm4eIkTSBfNNFaUM+kmkZE7pYMkmfRg/g0n2KyHvspr26v1DstqysS1hQDUM0Btvy7YBmGngJz5PYw+dZ3a5GBfNf90+ico2CkcH7Ikt5euREA1WRk5GEw8tyK9wqD5aG0G0Duw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776773056; c=relaxed/simple;
	bh=PhciIxgiiA5ddt051NDOgiae67LGOLqltKK8xM/6Sp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OzAw5BNzqylC3wKlxvMhVsMDAwOO/+f7ll0FfVmmLJs3BCNCazdHMAbzx+0QxplYdXrht8pTSqsS2+9i1pBkQbUu3o7SryCfp7/tAbcyc+OK2Z+8OBx1iPEWEiNabJn1O+CihfmZgr/Tj7k2rnRNMl/+alX2Fl0mSYJHtPzoB54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dKIfn5Jo; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dKIfn5Jo"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2b4520f6b32so5297290eec.0
        for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 05:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776773054; x=1777377854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WC25I4L4LKQAZMVUaJZY4pHqgCaxsSTXVf3rLxAH518=;
        b=dKIfn5JoS61n/Q2jj3FVEUY5XgMi9zW4HW7PF377tBdx/qlUStvCMObfjizyXCfXst
         U1PPzIdwxfdG9IamUVFaXrD6UwLMCPBMplFdcezD+cU77ZUlQqyO4xUoGVSQAcZ92PG2
         nwY74MHfnN82EmGFlsKrGOscan+BZy+LGarlGqkFOe3iLcb5bdvtv3Nh4nUUUcwa6gOy
         E3beyOK2jl8/oJupUxjcqrGJTENrVyZtJ3iw0oIuS8tW0BGvoC/N4yUulJQHfRir2Ft5
         ZXOSgTF3wkD4Mf/RYl/+f1xh0JUnVKvDgA9F+QZZG7V7e8xP3aWLhYob/RJfPhhfxJB2
         X9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776773054; x=1777377854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WC25I4L4LKQAZMVUaJZY4pHqgCaxsSTXVf3rLxAH518=;
        b=TqYLe566pttJmU9UNt38epgWPAKEKLOe9ZZTW8II6j/dibTYHjfKvqcGYn5XI0QlBZ
         r7R2NeV8xpUNX7ub0OwfsMv1XaWPdrJZA3QcDWGaBk0Wu1OLi68KMp43vZQJdG8sJFpt
         txDz+jpyd0FhNwghluPm7zOB1OmMR5dYrleM/Lr/ABz9dPOUsWykUulPJAr2eYYq6H+i
         5vRNFKrGYnoA2OMZyKfxteeW96bv0Vhe05BLArSxqyMBuFLJ8o9ip4s8x91i6af8iO41
         3qHD5TrNsGwKgAt/4Ndsz6Q0QDUUb4TCf0ZTakwCyQlArWkv4ArdSDL8x7DxLZOyFxyS
         uv4A==
X-Forwarded-Encrypted: i=1; AFNElJ+/86GdB7Of2c+PlfGz5ZotRWoGtixxOEduDHFRj1E7V3InGOk2O4tfIwex9entRbeooNlFGJ5Sx5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSN6zKPU8vQwCY1MAO+O9B1ZijcjJGNtpD2s6LVckIoBDEJbaO
	hUsidWiLNv+y74fPLWfG9Mn2kgJNKf7bDpj9tqAV8LaMO7t0LPsP6Xz7
X-Gm-Gg: AeBDietkoyKVvG59nFhXCnK57PTlKGGBicAwtR0/RGFXN3sCySabGJ7MFuzlnQX0R4D
	NMpiCz//QAzUPSQrjNzacRorfCDsYdWC3uZk6w3ID55sxWb+o6KmObylSMhszgNU7vno1HAh4Ti
	ZPCUjY3q7ULNN8xiAUUhYMEbLbOUNX5qjR0ycg7tfqDs4CdPwBjoLEso7ElPYQiFlUxRfV2pLJt
	D/Jo8GTCHgae/kemy9OTlUHfEWeqF9Rm6ez1XdiKa22D2teL2QYaA0VxBDpJ+RswsFL9CQ4YVig
	cxaUL85LXynB1Xy7n7yVQb4O1QzHnNsW9db5avoAMrvNqwuO+Mw+Vk2o6dJ+RawijSxSPp4bv9h
	cjqwNfRw1oOLSNiadvGtNd4J3S0RJEWGI3DUMQlu8OfshyLUtsflDdOfszLyZPCWomNPpEl4UDl
	7BqtGck7RK5pNh58rQq3GyGA6HlfgdCpFYDx5DbA5seI1KCg==
X-Received: by 2002:a05:7300:4313:b0:2d2:96e8:1bf5 with SMTP id 5a478bee46e88-2e464eaa3ecmr8603231eec.3.1776773054151;
        Tue, 21 Apr 2026 05:04:14 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53a4a7ff1sm18679807eec.9.2026.04.21.05.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 05:04:13 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: dgc@kernel.org
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [XFS] Question: can xfs_agfl_free_finish_item exhaust AGFL during bnobt/cntbt split?
Date: Tue, 21 Apr 2026 20:04:11 +0800
Message-ID: <20260421120412.2161716-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <ad1r1fm8LjFVxi9_@dread>
References: <ad1r1fm8LjFVxi9_@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 14 Apr 2026 08:19:01 +1000， dgc@kernel.org wrote:
> On Mon, Apr 14, 2026 at 10:48:51AM +0800, Jinliang Zheng wrote:
> > On Mon, 13 Apr 2026 10:14:45 +1000, dgc@kernel.org wrote:
> > > On Mon, Apr 13, 2026 at 12:32:50AM +0800, Jinliang Zheng wrote:
> > > > But before `xfs_agfl_free_finish_item` executes, `xfs_defer_finish_noroll`
> > > > rolls the transaction. Other deferred operations that execute in between—for
> > > > example, regular extent frees (`XFS_DEFER_OPS_TYPE_FREE`) that themselves call
> > > > fix_freelist and may re-shrink the AGFL, or rmapbt operations—could consume
> > > > AGFL blocks and leave the count below `need` by the time our deferred AGFL free
> > > > runs.
> > > 
> > > Even if we run RUIs, CUIs or other EFIs before the AGFL deferred
> > > free, they fix up the freelist for their operations first, and that
> > > reserves space for a deferred AGFL free from the free list.
> > > 
> > > If any other extent allocation/free on that AG is run between the
> > > two transactions (e.g. high level transactions racing on AGF buffer
> > > access) they will also reserve space in the AGFL for a split during
> > > a deferred free.
> > 
> > Thank you for the detailed explanation. I have a follow-up question about
> > the case where fix_freelist shrinks the AGFL by more than one block.
> > 
> > When `xfs_alloc_fix_freelist` shrinks an oversized AGFL, it may call
> > `xfs_defer_agfl_block` multiple times in a loop, adding N deferred AGFL
> > free items into the same `xfs_defer_pending` (up to max_items=16 per
> > pending entry).
> > 
> > In `xfs_defer_finish_noroll`, all N items within that single
> > `xfs_defer_pending` are processed consecutively in the same rolled
> > transaction via `list_for_each_safe`, with no intervening fix_freelist
> > call between them. Each call to `xfs_agfl_free_finish_item` invokes
> > `xfs_free_ag_extent`, which may trigger a full-height split of both bnobt
> > and cntbt, consuming up to `(bnobt_levels + 1) + (cntbt_levels + 1)`
> > AGFL blocks.
> >
> > The initial fix_freelist leaves the AGFL at exactly `need` blocks. If
> > the first deferred free triggers a full-height bnobt+cntbt split and
> > consumes those blocks, the AGFL may already be below `need` — or even
> > exhausted — by the time the second deferred free runs and needs to split.
> > 
> > Is this scenario considered?
> 
> I have considered it, yes.
> 
> Remember what I said about considering the probability of something
> occurring before adding complexity to guarantee it will never
> happen.
> 
> The above scenario requires both allocbts and the AGFL to be set up
> in such a way that it has multiple full subtrees ready to split in
> both trees, and that the same block frees (from the AGFL) will
> trigger those subtree splits with the same free space record insert.
> 
> And the AGFL has to have exactly the right blocks on it *in excess
> of what is required* in to get them deferred in the right order to
> then trigger these subtree splits.
> 
> And this has to happen multiple times in consecutive operations.
> 
> Can the above happen? Yes.
> 
> Will it happen by chance before the heat death of the universe? Probably.
> 
> Will it happen in production workloads?  Not very likely at all.
> 
> That's the difference between providing theoretical guarantees vs
> practical guarantees.

Thank you for your reply.

And, I have a follow-up question again.

Will xfs_allocbt_free_block()/xfs_rmapbt_free_block() -> xfs_alloc_put_freelist()
cause AGFL to become full and then overflow?

thanks,
Jinliang Zheng.

> 
> We can keep playing "but what if we had N+1" type theoretical
> scenarios endlessly here, but reality has to step in at some point.
> We set reservation sizes for "unbound excursions" at a size that is
> large enough for normal operation and largely ignore the cases with
> 10^(large negative N) probabilites.
> 
> If, in practice, we find the reservation pools are getting exhausted
> in normal production workloads, then we'll either change the
> behaviour that is causing the exhaustion or increase the reservation
> pool size to handle that case.
> 
> -Dave.
> 
> -- 
> Dave Chinner
> dgc@kernel.org
