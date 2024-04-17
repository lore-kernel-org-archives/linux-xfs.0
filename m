Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260FE84FDF
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713364530; cv=none; b=Hmv8z/JiLmoPKPOT7WNt9hKu0xcgUhFsU8+qj1iwZryjf3Z081tIY6ceVI1ra43VoNK6LoxnQ+XRJ1uXMUMA6M4D4ZT3UrncaOZUHtBY6pGSEGT7ywtZvUm2ltrTAHSktZSPyrNB0MZQdKq+jdupsCfRnef25/oA2RoUr0kpw0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713364530; c=relaxed/simple;
	bh=2KVFFAp5qbVMxuxzS5DtwIqV6na5EHaYON0Sb5QKZA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwxdU+f3KN5HmPGQHswX0Y4M1hK2WPtoOyvih4bRv1BHaA6jaQpvoCeyLX8XYy9s4bI2RM4/KGPdYMH7fLDkBi2UZNsIGkRfYysPbX1GOFui2QLe5Dpy6L6bYlBBpd0EYq0XLFZukgLpuy7DbFs+RUZu6+OyOEIoXcyiWCyz2zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=v6adRhdk; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="v6adRhdk"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4VKNjg0B5mz9smh;
	Wed, 17 Apr 2024 16:35:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1713364519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dam89vm9YUE3bUwzA6z9BOfQlHgn8Hsthodqm55cmBM=;
	b=v6adRhdkKJjdanq1hk1mJWIXcAXLhpOZNY8qguUECSKnhbVAieaQNf0W3UKbhvQzyC64/Z
	+k/bNtcevY1G87Kl8PFk8QfPgl99lbX9UmcIB208eftDXxJkGbXNBvzKuyv6kr4ZHFtstF
	jO0/PtvSbTU63x9qyZ5HfVEnjoaGLqHTS20mf/TGssjtB/ITkaSlJxwALSUyn6BtsLm+Pc
	I4Em8MGbnHCqWBXx88SjQk32RHDFbwE2UUDh/H+QKiOzJC7nzLnGoQVt6PzujbsXXVixPv
	Xa7eV6d21n+jCdBUGvi2NWBfprGVXjgJUF059kPPPPOBqTLtQRzhkf9E4FCIow==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: david@fromorbit.com
Cc: chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org,
	mcgrof@kernel.org,
	p.raghav@samsung.com
Subject: Re: [PATCH 1/4] xfs: use kvmalloc for xattr buffers
Date: Wed, 17 Apr 2024 16:35:02 +0200
Message-ID: <20240417143502.1888116-1-kernel@pankajraghav.com>
In-Reply-To: <20240402221127.1200501-2-david@fromorbit.com>
References: <20240402221127.1200501-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Pankaj Raghav reported that when filesystem block size is larger
> than page size, the xattr code can use kmalloc() for high order
> allocations. This triggers a useless warning in the allocator as it
> is a __GFP_NOFAIL allocation here:
> 
> static inline
> struct page *rmqueue(struct zone *preferred_zone,
>                         struct zone *zone, unsigned int order,
>                         gfp_t gfp_flags, unsigned int alloc_flags,
>                         int migratetype)
> {
>         struct page *page;
> 
>         /*
>          * We most definitely don't want callers attempting to
>          * allocate greater than order-1 page units with __GFP_NOFAIL.
>          */
> >>>>    WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
> ...
> 
> Fix this by changing all these call sites to use kvmalloc(), which
> will strip the NOFAIL from the kmalloc attempt and if that fails
> will do a __GFP_NOFAIL vmalloc().
> 
> This is not an issue that productions systems will see as
> filesystems with block size > page size cannot be mounted by the
> kernel; Pankaj is developing this functionality right now.
> 
> Reported-by: Pankaj Raghav <kernel@pankajraghav.com>
> Fixes: f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
> Signed-off-be: Dave Chinner <dchinner@redhat.com>

Thanks. I tested this patch in my LBS branch and it fixes the warning.

Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

For now, I will add it to my LBS branch as I don't see it yet land on
6.9-rcs.

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)

--
Pankaj
