Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794344994;
	b=CBU+nT6mUCAU9QYh+GCwrj6/3x1+9sPrOdHgpbheeVWp9WgnBc1P0bs3Jw1+UZDeeMLE
	 CM/Q6l0OqIfHNZIgAuNw2u7V0cvPZnFWrQJiq1VgadBHadin3+Q2v+K1H/rqXAc8MatLZ
	 vHfd7pZV8HJrmVBXZSdPk8LtDSz16JZsFAPb5hPKDWLFaqqrSseGvFMRX/fuj92bvUeM5
	 i4U8t3UiWzsXsawdi5bNfcK/qX2Jvgg+1UUpPi/nnaeIQKHbwATEkY3GpuOJvLSk11hNF
	 k7XuugieBXWTQ8QcwGyhu3kApZb3XJ2p8fMWl5mTXM7M17DFrmaYtlbydfpHgwyuAmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794344994;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=7cECixYNr0OovLH4QYoKXkxOvB4WVLsH4r6Oh+9diE0=;
	b=aF5E95jzhwsI6apMbq5WZBkSCI0VgG+56cfe1NNVFoYTRED8qQJibaEg1+Zvwci57A8K
	 A7MWqJ8y+b0SdNbubXnPBCQ+N1qpQuQiFGkq9w7JIthkh0VlYRRZHkpZjkwiU+sWzP70x
	 rn9TbcTtp0oSfRxdT3Eo85spAjniYcpLK7Ip0+tlEGEmPb9CZ8m2/8iTSAJuQyl50VMry
	 SWScJkWanAOFW3Ebrfco5WV94g6RqAO3Ul80Bv5IZGbqyGqKXhxkODGcoiyT7YIVLsn6V
	 8r62n+WWUKF2cUhPTg3AFQZ1NoGB6hwOpMq/1Zff3jTr5UukmADgI3Pktxr85JfX3bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JD7sJLCz;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F205606A325
	for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2026 21:09:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F205606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JD7sJLCz
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4918c2d727fso1398479f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2026 13:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794344991; x=1794949791; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7cECixYNr0OovLH4QYoKXkxOvB4WVLsH4r6Oh+9diE0=;
        b=JD7sJLCzFe6dDR6grClfiQYXK7ZmLbR1MW9kwSTkhxEUiW21oOEd4LxucDBC5mdI1O
         j6pwJ5xhvGYkHYTR5NZa56V8djk6ACX1uPxbJz5Ps+jsHBMstWLAnu0YdA6WnV42zDWS
         YKgW/eSMnxjQi7nym2drzrIw9/Ga6PmpNOrvpxwGChkTkLEnMJ651nCoO4gq1N78ovge
         Xfz1r+TCcJNbdQhvR1Eg5XeFj878zzFlF0DUU1Gx+lMZTdpI1QhM3zAMbID3hlxatRJm
         15R+0gsdxf7z53S/a68kcPkfZxVVsr+8aGN6eyFZNThWhHjk2rPYPRIREaAyGibzYV3L
         AoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794344991; x=1794949791;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7cECixYNr0OovLH4QYoKXkxOvB4WVLsH4r6Oh+9diE0=;
        b=ikDmGpdgO84qvA09vTfK71R2+xfknZs5kfqA9bKbLaL+gGMpqhUY1T0MaFK5Xs+z5Q
         l0t8fPTsCBC/X+rv/8rwe7oE5YoPXcChiPuTbJzxNcxiykWe+1jwTTFI0IDEB8vtue8X
         NQSLebd4gRm7UrnOl2P3bbceqK2ux1g+tx1nFMgkauUJr1jueTO+dcpHRfVo/7iw47N0
         jMjZOGjgForFmrjfaOtG3GUSRtXTB2qxJAApBAtzKL5GZQpFlgm+9S/9/UJ0W9UMkOpT
         fTDKPUXiFzKxnJ57nY9OXQ1rOsLVOTjB1Nm1lCmUPl4a7BGjICStqmA43DsJcVRFNAOK
         A9sQ==
X-Forwarded-Encrypted: i=1; AL+hErEIn90UEnU9A3Rzos1O2bqfc3iRtVKN0ixD4mPkrMxKeWR070CwXnXRSwn07y5Fa4jTGNG65M/zs0E=@vger.kernel.org
X-Gm-Message-State: APuU4Z+0qmERfmkO2HsA/64mFXWh0mMPtGEjKVCr+y/7J5lyBpfTr2Ch
	JdWYIdE31L6eKF9U5Jwb2GCT4Yv3CO6RdlywRpksUjo5SF7UTK997Ts5II4gz1M67MA=
X-Gm-Gg: AYBFou08OVLJXkViDzkDQkkeHHsUd7MHnPEuPb6uS4wIUPPmGSr1e1c6AhhXZsCoZGq
	cO3u6puYdExforx0NQwg8IKMdC47/4nNyYRYAd9t8kmV+Ogbwza94LVP14HWpwK4ZWxh4NLTinO
	tVEXwMQOiVDqAhOn64ElElgtZqHlHkitQimlrJCHxbMPp0v6GW0eMtCqAlpsQU6VgdKbR9IkoLQ
	0eKsyOd4IJ8gL6R9xNQ4bC8zrOIXkXuFCpzGokxHtfLJqV+LIh2hws8Ga3wTHo+Cu/R05OLsshV
	57K5F1pYrNtyjsd/0PKhMFgHJyk7VZYVv2vJTSCE8Hw9sYz7gZ5czcD4+M9cLtnRnqqgUIeI7VN
	4csOFlKVXtEie0n8Vsm6w5Et4zL9kNR2WjB+dcMcq0CKnZeCQayApmyTavq4VDHKu5N3JTv1Rh8
	LRcvJS7ssmpKEJEuty5+1xM3++L0gzylYptgjMuRMqmSU/jZ9nuHB492+lyKurNlhej4lkTjypg
	j7TSGmfQiyZWL/pmneWhba0DR/rhGaP5jHUJ37bSK3rbGARzvlG5ApAtlMkPlKJcJikeiz4Njch
	DehrMELJL327Pbtsdj751Yc7FOcuzeVTwlwyrGcnKpI=
X-Received: by 2002:a05:6000:3103:b0:493:e0db:b520 with SMTP id ffacd0b85a97d-499c38baf87mr327184f8f.8.1794344991489;
        Tue, 10 Nov 2026 13:09:51 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4984e26f8e3sm6223895f8f.1.2026.11.10.13.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 13:09:51 -0800 (PST)
Date: Tue, 10 Nov 2026 22:09:49 +0100
From: Michal Hocko <mhocko@suse.com>
To: Fang Xieyan <fangxy@xiaopeng.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>, Carlos Maiolino <cem@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Liu Chao <liuc63@xiaopeng.com>
Subject: Re: [RFC PATCH 3/3] mm: enable filesystem page-cache large folios
 without THP
Message-ID: <avOIHeOpjryn5DVd@tiehlicka>
References: <20261110035205.3036-1-fangxy@xiaopeng.com>
 <20261110035205.3036-4-fangxy@xiaopeng.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110035205.3036-4-fangxy@xiaopeng.com>

On Tue 10-11-26 11:52:05, Fang Xieyan wrote:
> Ten filesystems already opt in to file-backed large folios by calling
> mapping_set_large_folios() or mapping_set_folio_order_range() from their
> inode setup, unconditionally.  Every accessor that reports those orders
> is nevertheless compiled out when CONFIG_TRANSPARENT_HUGEPAGE is
> disabled, so the opt-in silently has no effect today.

The reason for disabling THP on RT configs (as introduced by
554b0f3ca6f4) was:
:  There are potential non-deterministic delays to an RT thread if a
:  critical memory region is not THP-aligned and a non-RT buffer is
:  located in the same hugepage-aligned region. It's also possible for an
:  unrelated thread to migrate pages belonging to an RT task incurring
:  unexpected page faults due to memory defragmentation even if
:  khugepaged is disabled.

How is the same prevented for the page cache? If the reasoning above is
not generally applicable then would it make more sense to make the
conflict less strict?
 
> Gate the page cache order accessors on CONFIG_LARGE_FOLIO in addition to
> CONFIG_TRANSPARENT_HUGEPAGE.  Both conditions are still spelled out even
> though CONFIG_LARGE_FOLIO defaults to y when TRANSPARENT_HUGEPAGE is
> enabled, so that file-backed large folios do not silently disappear if
> that default is ever relaxed.
> 
> PREFERRED_MAX_PAGECACHE_ORDER is left as it is.  Deriving it from
> CONFIG_PGTABLE_HAS_HUGE_LEAVES would let HUGETLB_PAGE raise the ceiling
> on its own, to HPAGE_PMD_ORDER capped by MAX_XAS_ORDER.  On arm64 with
> 64K base pages that works out to order 11, a 128M folio, eight times
> what an LF-only build advertises today; the figure is arithmetic, not a
> measurement.  Without THP such folios cannot be PMD-mapped, so keeping
> the existing order-8 limit avoids substantially increasing the maximum
> page-cache allocation size without an established use case.
> 
> CONFIG_LARGE_FOLIO no longer only builds the split machinery, so its
> Kconfig help text is updated to match.  The default also carries a
> comment recording why THP must keep pulling this option in:
> mm/folio_split.o is built from CONFIG_LARGE_FOLIO, while huge_memory.o,
> built for THP, calls into it.  XFS also gates mounting
> block sizes larger than the page size on
> mapping_max_folio_size_supported(), which means large-block-size XFS
> cannot be mounted at all when CONFIG_LARGE_FOLIO is disabled; the
> rejection now points at the missing option instead of only reporting the
> block size as unsupported.
> 
> shmem keeps its THP dependency.  shmem_alloc_and_add_folio() forces
> orders to zero without THP, so the mapping is only opened large-folio
> capable when CONFIG_TRANSPARENT_HUGEPAGE is enabled.  Advertising the
> larger order while allocating order 0 would not be cosmetic:
> generic_perform_write() sizes its write chunk from
> mapping_max_folio_size() and passes that length to ->write_begin()
> before clamping it to folio_size(), while shmem_write_begin() rejects
> pos + len > i_size outright for F_SEAL_GROW.  A cross-EOF write would
> then fail as a whole instead of being partially satisfied up to i_size.
> THP=y kernels already behave that way; the point is not to spread that
> behaviour to a configuration which gains no large folios from it.
> Enabling shmem's large folios -- allocation, swap and split alike -- is
> left to a separate series.
> 
> The stale comment on mapping_large_folio_support() is updated to match:
> large folios are now gated on CONFIG_LARGE_FOLIO rather than on THP, and
> CONFIG_LARGE_FOLIO is a default rather than a select from THP.
> 
> With CONFIG_TRANSPARENT_HUGEPAGE enabled the generated code is unchanged.
> Without it, file-backed large folios become reachable for the first time.
> 
> Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
> Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
> ---
>  fs/xfs/xfs_super.c      |  2 ++
>  include/linux/pagemap.h | 17 +++++++++++------
>  mm/Kconfig              | 15 +++++++++++----
>  mm/shmem.c              | 11 ++++++++++-
>  4 files changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5a06132aa..29548faec 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1864,6 +1864,8 @@ xfs_fs_fill_super(
>  			xfs_warn(mp,
>  "block size (%u bytes) not supported; Only block size (%zu) or less is supported",
>  				mp->m_sb.sb_blocksize, max_folio_size);
> +			if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
> +				xfs_warn(mp, "CONFIG_LARGE_FOLIO is not set");
>  			error = -ENOSYS;
>  			goto out_free_sb;
>  		}
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 73af18a37..2102733c1 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -393,7 +393,8 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
>   */
>  static inline size_t mapping_max_folio_size_supported(void)
>  {
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
> +	    IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return 1U << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
>  	return PAGE_SIZE;
>  }
> @@ -418,7 +419,8 @@ static inline void mapping_set_folio_order_range(struct address_space *mapping,
>  						 unsigned int min,
>  						 unsigned int max)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return;
>  
>  	if (min > MAX_PAGECACHE_ORDER)
> @@ -459,7 +461,8 @@ static inline void mapping_set_large_folios(struct address_space *mapping)
>  static inline unsigned int
>  mapping_max_folio_order(const struct address_space *mapping)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return 0;
>  	return (mapping->flags & AS_FOLIO_ORDER_MAX_MASK) >> AS_FOLIO_ORDER_MAX;
>  }
> @@ -467,7 +470,8 @@ mapping_max_folio_order(const struct address_space *mapping)
>  static inline unsigned int
>  mapping_min_folio_order(const struct address_space *mapping)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return 0;
>  	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
>  }
> @@ -500,8 +504,9 @@ static inline pgoff_t mapping_align_index(const struct address_space *mapping,
>  }
>  
>  /*
> - * Large folio support currently depends on THP.  These dependencies are
> - * being worked on but are not yet fixed.
> + * Large folio support is opt-in per mapping and requires CONFIG_LARGE_FOLIO.
> + * It does not depend on THP; CONFIG_LARGE_FOLIO defaults to y when
> + * CONFIG_TRANSPARENT_HUGEPAGE is enabled.
>   */
>  static inline bool mapping_large_folio_support(const struct address_space *mapping)
>  {
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 9f97ad698..7bbed71af 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -831,13 +831,20 @@ config LARGE_FOLIO
>  	bool "Large folio support for the page cache (without THP)" if !TRANSPARENT_HUGEPAGE
>  	depends on MMU
>  	select XARRAY_MULTI
> +	# Keep LARGE_FOLIO enabled whenever THP is enabled:
> +	# huge_memory.o is built for TRANSPARENT_HUGEPAGE and calls into
> +	# folio_split.o, which is built for LARGE_FOLIO.
>  	default y if TRANSPARENT_HUGEPAGE
>  	default n
>  	help
> -	  Build the folio split implementation for page-cache large folios
> -	  even when transparent hugepages are disabled.  Transparent
> -	  hugepages imply this option; this option alone does not enable
> -	  large folio allocation, it only makes splitting them possible.
> +	  Enable page-cache large folios even when transparent hugepages
> +	  are disabled.  This option defaults to y when transparent
> +	  hugepages are enabled.
> +
> +	  With this option enabled, filesystems that opt in per mapping get
> +	  large folios in the page cache, and those folios can be split.
> +	  Without it, page-cache folios stay order-0 even when a filesystem
> +	  asks for a larger order.
>  
>  menuconfig TRANSPARENT_HUGEPAGE
>  	bool "Transparent Hugepage Support"
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 4686875a3..399c8c9f1 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3327,7 +3327,16 @@ static struct inode *__shmem_get_inode(const struct mnt_idmap *idmap,
>  	cache_no_acl(inode);
>  	if (sbinfo->noswap)
>  		mapping_set_unevictable(inode->i_mapping);
> -	mapping_set_large_folios(inode->i_mapping);
> +	/*
> +	 * shmem large folios currently depend on THP:
> +	 * shmem_alloc_and_add_folio() forces order 0 without it, and
> +	 * advertising a larger mapping size makes
> +	 * generic_perform_write() pass a length that shmem_write_begin()
> +	 * rejects wholesale for F_SEAL_GROW before the folio size is
> +	 * known.
> +	 */
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		mapping_set_large_folios(inode->i_mapping);
>  
>  	switch (mode & S_IFMT) {
>  	default:
> -- 
> 2.50.1

-- 
Michal Hocko
SUSE Labs
