Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA91425634;
	Wed, 14 May 2025 13:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747228638; cv=none; b=SPvGVKVIq3BZzjlDOnlr61WYlcJ7p8MYeiANjrFlnMBDp4GLgF+lo7+cf5YNLTIxWvtOq6m07c1whEwt7PH0Lg7dQrQifJ9a9ncm0Jtm4Lk7VJ2tkCqyY/tvw85xmTbF3fjBDc/AjWgZzYePLdS5QUU+XRROElmaWjzaZjTsCFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747228638; c=relaxed/simple;
	bh=TlV+NKH67PGf9gxkDHI2sLOV5qFf6K/4NX+8/e79RL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+Jr56NuvHLPBDFrXvC/JWcBWjqlKLDiYvlsS79IMJFi7h50l8zkNc+PozZexbcrWvarPeRvRAis5qCKw+dQbuGFsBm2KfTDfWv/3Ocyx/IxYnzXitO+Y32TtqYRYcEwOQcOkqL03ELP5lBdmzruaWVFgQNHNtCfXTm4kfn4CPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pr30kmrt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pr30kmrt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1X9ftCU+PH7F6iWrji7vxb358Qokcjh6t1gidjnRqv8=; b=Pr30kmrtj3Dgtra0ObIAv9jxuF
	ZDWB+z1qP9VNx15DgybA6MtjzDCuttfPpGjRHJz7xl9qAr756fUasai2/csGHNZogci2pXN6iypBG
	Za9TUc0onEPBhr/7ThmHNdemcTTq5jvCtSzVz7UzYg5ikrEpinbJ8KRk3KEVIHFI7q/mOUyOK4u5N
	emg14u1Wncfd1Or0LFh1acIX9EHjnyfZPKP3zwBceznD9ooDDqniIOBvjbG3q73MLokTrPawTist5
	Tt7PAOtsJ4fSQMl2yfi9jVarrWXa7krxpithpgZPVBUssBlowBxESUuFODPdx7ThaKGuJJVQhyCDQ
	Kgko7fdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uFBz1-0000000FBNw-0VVi;
	Wed, 14 May 2025 13:17:15 +0000
Date: Wed, 14 May 2025 06:17:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cen zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, zhenghaoran154@gmail.com
Subject: Re: Subject: [BUG] Five data races in in XFS Filesystem,one
 potentially harmful
Message-ID: <aCSX29o_xGAUWtIl@infradead.org>
References: <CAFRLqsVtQ0CY-6gGCafMBJ1ORyrZtRiPUzsfwA2uNjOdfLHPLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRLqsVtQ0CY-6gGCafMBJ1ORyrZtRiPUzsfwA2uNjOdfLHPLw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> 1. Race in `xfs_bmapi_reserve_delalloc()` and  `xfs_vn_getattr()`
> ----------------------------------------------------------------
> 
> A data race on `ip->i_delayed_blks`.

This is indeed a case for data_race as getattr is just reporting without any
locks.  Can you send a patch?

> 2. Race on `xfs_trans_ail_update_bulk` in `xfs_inode_item_format`
> -------------------------------------.
> 
> We observed unsynchronized access to `lip->li_lsn`, which may exhibit
> store/load tearing. However, we did not observe any symptoms
> indicating harmful behavior.

I think we'll need READ_ONCE/WRITE_ONCE here to be safe on 64-bit
systems to avoid tearing/reordering.  But that still won't help
with 32-bit systems.  Other lsn fields use an atomic64_t for, which
is pretty heavy-handed.

> Function: xfs_alloc_longest_free_extent+0x164/0x580

> Function: xfs_alloc_update_counters+0x238/0x720 fs/xfs/libxfs/xfs_alloc.c:908

Both of these should be called with b_sema held.  Does your tool
treat a semaphore with an initial count of 1 as a lock?  That is still
a pattern in Linux as mutexes don't allow non-owner unlocks.

> 4. Race on `pag->pagf_longest`
> ------------------------------
> 
> Similar to the previous race, this field appears to be safely used
> under current access patterns.

Same here I think.
> 
> Possibly Harmful Race
> ======================
> 
> 1. Race on `bp->b_addr` between `xfs_buf_map_pages()` and `xfs_buf_offset()`
> ----------------------------------------------------------------------------

And I think this is another case of b_sema synchronization unless I'm
missing something.

