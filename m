Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1365374748
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 06:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770099409; cv=none; b=N/uDgtFqMrPU2eQNg56T278HbLSsPnq0KhIG5Z3eROl4yoEHCcdsb4NYQJc9SrDKnSFwwZt/TBKyC8lklfhOXtorQM4G08afU+7iXHahlBH/4FmQNYt3ikQPWgVr+p48TiNss919zD3wB2plKc2IJWr13yjNs2exMhYvNy4O1lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770099409; c=relaxed/simple;
	bh=yNP/4scU6b0PBqY3C07K+gmD0xNHq3mn1+KIp55zENU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=FdWb32gKh9T1Ir9xWFC5u1hZgaOH2Fq7DivER8eTf4NgO4kuwm1XYtjYcrSsHuhy1DC3LXQ9zObCYNiNEtW53Ftxbey5ONhqGApYs948haouMx3ktbmlqvXMFM0ntQ4ie2lTgTJ3DOhf/SSwh0pH34tmBC+TZwL/2ULntd/1aCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BX7E4IAf; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BX7E4IAf"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82361bcbd8fso3058100b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Feb 2026 22:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770099407; x=1770704207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aMzLJou9IRW51ThWxJjNpohqmw5T2tuW1LdVblfaY40=;
        b=BX7E4IAfGJjActss/K995uICVJV4T+LP5cGJ2InDIliF/gtwoomQgKWVWfyWGGVpc/
         vaijf5jaDrBM2zChRnUPRCXmvr+hdYlF2JT1HcsTQqPviUThGq3p6xyQXmXDDRdnlTCh
         +CFHGlTg7L0OwhLRqZl8NGj5SHZdUit84i/D7DAE1jh0vpFCTk7Brdml5XT0ww8iCE44
         yS9DgYEC4S7BNvMgIMmCm1hDTBAfT2BncprIWJ99GhZSP5iUfgkL6GFlcKLhvp/qHPyE
         tIbGfJ64ODgCyEG+NsyVbU4E4uO8KJ61Sj7E3aDXLe8LzyDo3uk6sOOT7GAOEdIg5l/0
         RDOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770099407; x=1770704207;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMzLJou9IRW51ThWxJjNpohqmw5T2tuW1LdVblfaY40=;
        b=RELxW0aK/xJkNNNjSOWFtbrMRy/8HDkgBwZn7LxFhreD3b3FWaG95LmTqcL6ct+WN6
         eEhsVyKfv6JqUmErZxsg/2jqfFbJ+N1isLkPtCXKhhEgVOREHJbMDqJBlPNHghumkK6C
         lZ2zp/GXwRawMkFWggloiPllZg/p6/gkZwGHXeh2bjLf2WCDUSKB7X2nW5HbpAma3UPG
         FsraEZlfSwR8N7XeBmHphAd4HF0G0KIVsIECHbLKZ2Qf/pJ4jLO5lO1SArJU63cIdULL
         GiW9AcIRoArz9eYtz3SejppRG/d6je60XG2bXos7uIzpSEEAVqoqBldMyj7/ET3XhXn8
         Odpg==
X-Forwarded-Encrypted: i=1; AJvYcCXAe+i+Wk9oKhLbh9OBdZ4rCn5D8GCXFXduVXW3l8JK7vE4axvHRcbWbvTCuWmEVZ3mg6gGGENczJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE/JK2ny6BeCfowZ7gZxb+/A4c8DDoCf+VR018fyafk7TXfeAD
	V9DqIqeS38BLIr70BuOFkUzLpFMNS5d1hDaBTzHXvk2+NlpJnecv0nDHPMU4xw==
X-Gm-Gg: AZuq6aKpfYTwWmGuea+X3g1nN22H7k1cLlZyRQxLOLcjbxONR96XMqRJqV6PzboJxk4
	c1uwbuv/wpb/KGx40s9zxKAoBxzKhdSFDtVrqcdPypfyEXfBUywaCPr+mhbLDZnrFFKWSadG3KC
	oDvqt84foO/rZApGzGedmEs8nf7K9AuhBQdvl9ObfVkSBQ7EzoIXMmEiLyMJhpKY0U1/GJ0fDvp
	JO+ZhfSJBKQVPs+78JDjCGrzMFfJiz7IPgRM/nyG2st/NxW0Y5Yp37eQUluy5ayRrVQtYbK3L2w
	WD+ltludg+QcN49KyDinDkWZNeQEa8pQKH72dKeTQta3KohhJcMeY5Wn+i44qaU3dAdUPikAae3
	Z82ZyBaj2WX6JPw3PpHiBseMozDW3TmepgClTGXCoOnNl9KA9wfkj3MKIo8ceBkBK8dLwRXnk7c
	JiwS/O6lJ+6NWlPh7HNfUYRTyc54X+Qh57fRwFiqNVfxFUc6svswBB/QY2QNcoZkTc
X-Received: by 2002:a05:6a00:21d2:b0:7e8:4471:8db with SMTP id d2e1a72fcca58-823ab97570dmr13825473b3a.60.1770099406849;
        Mon, 02 Feb 2026 22:16:46 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379bfd8d3sm17456114b3a.38.2026.02.02.22.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 22:16:46 -0800 (PST)
Message-ID: <cd435a8cf4f29d2b979b025c56de898f439c649a.camel@gmail.com>
Subject: Re: [PATCH 1/2] xfs: cleanup inode counter stats
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Date: Tue, 03 Feb 2026 11:46:41 +0530
In-Reply-To: <20260202141502.378973-2-hch@lst.de>
References: <20260202141502.378973-1-hch@lst.de>
	 <20260202141502.378973-2-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2026-02-02 at 15:14 +0100, Christoph Hellwig wrote:
> Most of the are unused, so mark them as such.  Give the remaining ones

Nit -  Typo - "Most of the are <...>" -> "Most of them are <...>"
> names that match their use instead of the historic IRIX ones based on
> vnodes.  Note that the names are purely internal to the XFS code, the
> user interface is based on section names and arrays of counters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c |  6 +++---
>  fs/xfs/xfs_stats.c  | 10 +++++-----
>  fs/xfs/xfs_stats.h  | 16 ++++++++--------
>  fs/xfs/xfs_super.c  |  4 ++--
>  4 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index dbaab4ae709f..f76c6decdaa3 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -106,7 +106,7 @@ xfs_inode_alloc(
>  	mapping_set_folio_min_order(VFS_I(ip)->i_mapping,
>  				    M_IGEO(mp)->min_folio_order);
>  
> -	XFS_STATS_INC(mp, vn_active);
> +	XFS_STATS_INC(mp, xs_inodes_active);
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
>  	ASSERT(ip->i_ino == 0);
>  
> @@ -172,7 +172,7 @@ __xfs_inode_free(
>  	/* asserts to verify all state is correct here */
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
>  	ASSERT(!ip->i_itemp || list_empty(&ip->i_itemp->ili_item.li_bio_list));
> -	XFS_STATS_DEC(ip->i_mount, vn_active);
> +	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
>  
>  	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
>  }
> @@ -2234,7 +2234,7 @@ xfs_inode_mark_reclaimable(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	bool			need_inactive;
>  
> -	XFS_STATS_INC(mp, vn_reclaim);
> +	XFS_STATS_INC(mp, xs_inode_mark_reclaimable);
>  
>  	/*
>  	 * We should never get here with any of the reclaim flags already set.
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 017db0361cd8..bc4a5d6dc795 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -42,7 +42,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		{ "xstrat",		xfsstats_offset(xs_write_calls)	},
>  		{ "rw",			xfsstats_offset(xs_attr_get)	},
>  		{ "attr",		xfsstats_offset(xs_iflush_count)},
> -		{ "icluster",		xfsstats_offset(vn_active)	},
> +		{ "icluster",		xfsstats_offset(xs_inodes_active) },
>  		{ "vnodes",		xfsstats_offset(xb_get)		},
>  		{ "buf",		xfsstats_offset(xs_abtb_2)	},
>  		{ "abtb2",		xfsstats_offset(xs_abtc_2)	},
> @@ -100,15 +100,15 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  void xfs_stats_clearall(struct xfsstats __percpu *stats)
>  {
>  	int		c;
> -	uint32_t	vn_active;
> +	uint32_t	xs_inodes_active;
>  
>  	xfs_notice(NULL, "Clearing xfsstats");
>  	for_each_possible_cpu(c) {
>  		preempt_disable();
> -		/* save vn_active, it's a universal truth! */
> -		vn_active = per_cpu_ptr(stats, c)->s.vn_active;
> +		/* save xs_inodes_active, it's a universal truth! */
> +		xs_inodes_active = per_cpu_ptr(stats, c)->s.xs_inodes_active;
>  		memset(per_cpu_ptr(stats, c), 0, sizeof(*stats));
> -		per_cpu_ptr(stats, c)->s.vn_active = vn_active;
> +		per_cpu_ptr(stats, c)->s.xs_inodes_active = xs_inodes_active;
>  		preempt_enable();
>  	}
>  }
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 153d2381d0a8..64bc0cc18126 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -100,14 +100,14 @@ struct __xfsstats {
>  	uint32_t		xs_iflush_count;
>  	uint32_t		xs_icluster_flushcnt;
>  	uint32_t		xs_icluster_flushinode;
> -	uint32_t		vn_active;	/* # vnodes not on free lists */
> -	uint32_t		vn_alloc;	/* # times vn_alloc called */
> -	uint32_t		vn_get;		/* # times vn_get called */
> -	uint32_t		vn_hold;	/* # times vn_hold called */
> -	uint32_t		vn_rele;	/* # times vn_rele called */
> -	uint32_t		vn_reclaim;	/* # times vn_reclaim called */
> -	uint32_t		vn_remove;	/* # times vn_remove called */
> -	uint32_t		vn_free;	/* # times vn_free called */
> +	uint32_t		xs_inodes_active;
> +	uint32_t		__unused_vn_alloc;
> +	uint32_t		__unused_vn_get;
> +	uint32_t		__unused_vn_hold;
Any reason to keep the unused field?
> +	uint32_t		xs_inode_destroy;
> +	uint32_t		xs_inode_destroy2; /* same as xs_inode_destroy */
> +	uint32_t		xs_inode_mark_reclaimable;
> +	uint32_t		__unused_vn_free;
>  	uint32_t		xb_get;
>  	uint32_t		xb_create;
>  	uint32_t		xb_get_locked;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 149b659e1692..3f25a0001a61 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -725,8 +725,8 @@ xfs_fs_destroy_inode(
>  	trace_xfs_destroy_inode(ip);
>  
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> -	XFS_STATS_INC(ip->i_mount, vn_rele);
> -	XFS_STATS_INC(ip->i_mount, vn_remove);
> +	XFS_STATS_INC(ip->i_mount, xs_inode_destroy);
> +	XFS_STATS_INC(ip->i_mount, xs_inode_destroy2);
So this patch basically renames some of the fields from the older legacy conventions (concept of
vn/virtual-inodes) to new linux-XFS conventions. Based on this understanding, this change looks okay
to me.
>  	xfs_inode_mark_reclaimable(ip);
>  }
>  

