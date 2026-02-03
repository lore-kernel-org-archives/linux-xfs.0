Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D384838E5FA
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 07:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770102690; cv=none; b=m7AbgpPjTIADYq9CALyspObuHpb/EeSsfQ0uAfbcGqVwa6ZSQznPJjlarJUAnlwVM+FgHUpextNPWnVIdWtuhXdm/jirnnufKYEq/HULKhwKY83kP0aB20iT77ICgxp+jZgZFeiui2SuBTV8zIgXT+d/wXgDYg9J+qWuqjTudj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770102690; c=relaxed/simple;
	bh=lNm7QYkJlYrqSvTOfDxqxOvSlKvFX6DvWmtHd2+xHZ0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=C6m0m7jzDMsuDDB0mSa0dk1E8z0XPWX2B9ArMBwWZSFXp4334fhIU4b+V1UuyT3iGOpb8r6XXMtEcSIqFQuPfgoLimItZx+5Y5Aw/at6Ru0TupkTQpoQR7mGSxxsUa2y3bOjnba4WeVoFINFL6mthhBOqLX8STZxmpVwOOarIIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nfRI/Yp0; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nfRI/Yp0"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34be2be4b7cso2765433a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 02 Feb 2026 23:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770102688; x=1770707488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VkLbFu+SRlAilSxwEYO5ljV/Li6YVR0434qh3EoDVxQ=;
        b=nfRI/Yp0tEusAmylvaE8EwJvKPx9AhH+ml2tDrXn9j/ocLd1+w25ecnebZPbGw90Vx
         sWFcVdCObnJxRv0AYDXkiInqbgtm6NNVJsnatqRpML8ZuFHIpx1/xR2yATZYhVGrJcDj
         XXya/BJ3ClKNdNvv4f9BYwRnDvFrKr6Y62VLMkJ+G5I+lfTPgsPDNBNCV4YXzbK+dZCE
         usVEmUpuqz3yUk8tV+OsKAyJPoVLbrAw369T9sXggzz39bpNQY8AX/SxrQMVXh8J9VAP
         QvDB+f1Ps9QmYAS5zkKOa3JOnQ5At2DW/zZukQ68oXZPfGOYAm/S8xpDt7xnxkkSrRq8
         Da0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770102688; x=1770707488;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VkLbFu+SRlAilSxwEYO5ljV/Li6YVR0434qh3EoDVxQ=;
        b=tu1UkcovqHdf4UHAnjdCi/0VXB/5iCLiyxoK01XkDiNG33B/qG5sjOLA5fg9FJhFoj
         uQ6rBo/vd7ncBnQ1c83TSnZ4s1kOxlaSh80FByBwjHPAU8ihZwqP2eD3kqhNEBcu9+0o
         UldhrHs70kxn5Yq2hyw+MaTf/ZyxUi030by7W03+wWC5PFRvm8MvlbA0wtWAWtWftVTu
         Rlw1CkiZFeW7z3SOAhtIukw3GhfumZWp6C6H7S/e5PlN3VSxJNrCX6CRopPNmmvgxf91
         uoVtfsK6Tegk8kzOk9uCazQLjeiln0p/V7JaE52r+OyyAsAvFi/m+y8r8aVJLZaknkBo
         gkbA==
X-Forwarded-Encrypted: i=1; AJvYcCV+af/93IwF3HKKVBa7SbuZacNLA5q7DI8nC+eiRaqXJ6NdYTWXI5xSGWjGYvX/yQZf5NExh6Vt6hM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi/z1G+9xTGPmSBSSh7RMQPuXhYbH1fFeZ4RACiVoscYZE0o0S
	+YvC6lTE/yJ6PEQIAm/3vYPBR6F8dIYJXmtxIgJ1rIG6jQgTDlgR8KWl
X-Gm-Gg: AZuq6aJQ46BTVJP8G38ORaBYH6z8c/Ocxb70p35AX39szr4dXBKuCNRFP8Oy85QBpS4
	aWSc/lSMujB4jx6GjXCKCScoctq+MlBEkpjtZabVr3oyGm+aGwpt5DYM2HF30ssVKWTqNWVtIx8
	4NpN/dDoDcq8yGPrMwhujdSlSlgRk8Wu/LmsRjbpQTxpc9GQpNEV3QyJWpG9fKxQRraMHBRw0In
	tutk3DchedYD6tu9fOwlKak2wKiihU6KsEqNKv3evaOi8MDUxtr4YdwsWnuo4Jz8zs5AL7Eax8/
	0Gs2oZrQNgaDErvHbLXcP3LNhG2YyRMLLcxZAvZ1tQHpPw88pX3kgmBZIIhrdJ7QhEoSXj86N3o
	7/HoB/zq6cTeNnKyAgc2rsaBMKti3zfSqIPdVjkqUBxfwHNwVcnHsfTNnD9ceovo6YCuXRe1/Nz
	s3wxFN49LVL1TdTBC6epTcm+loT3+AgdScmBUyVcyBqK6+YibELVu4m/POLX6NgOef
X-Received: by 2002:a17:90b:5705:b0:343:7714:4cab with SMTP id 98e67ed59e1d1-3543b3b22e8mr13271149a91.22.1770102687943;
        Mon, 02 Feb 2026 23:11:27 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35477763b81sm1668653a91.10.2026.02.02.23.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 23:11:27 -0800 (PST)
Message-ID: <00fa6edc7f0c324ceb95f7181682d04ce3f53839.camel@gmail.com>
Subject: Re: [PATCH 2/2] xfs: remove metafile inodes from the active inode
 stat
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Date: Tue, 03 Feb 2026 12:41:23 +0530
In-Reply-To: <20260202141502.378973-3-hch@lst.de>
References: <20260202141502.378973-1-hch@lst.de>
	 <20260202141502.378973-3-hch@lst.de>
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
> The active inode (or active vnode until recently) stat can get much larger
> than expected on file systems with a lot of metafile inodes like zoned
> file systems on SMR hard disks with 10.000s of rtg rmap inodes.
And this was causing (or could have caused) some sort of counter overflows or something?  
> 
> Remove all metafile inodes from the active counter to make it more useful
> to track actual workloads and add a separate counter for active metafile
> inodes.
> 
> This fixes xfs/177 on SMR hard drives.
I can see that xfs/177 has a couple of sub-test cases (like Round 1,2, ...) - do you remember if 1
particular round was causing problems or were there issues with all/most of them?
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  4 ++++
>  fs/xfs/libxfs/xfs_metafile.c  |  5 +++++
>  fs/xfs/xfs_icache.c           |  5 ++++-
>  fs/xfs/xfs_stats.c            | 11 ++++++++---
>  fs/xfs/xfs_stats.h            |  3 ++-
>  5 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index dcc9566ef5fe..91a499ced4e8 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -268,6 +268,10 @@ xfs_inode_from_disk(
>  	}
>  	if (xfs_is_reflink_inode(ip))
>  		xfs_ifork_init_cow(ip);
> +	if (xfs_is_metadir_inode(ip)) {
> +		XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
> +		XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
So is it like then there is a state(or at some function) where xs_inodes_active counter was bumped
up even though "ip" was a metadir inode and here in the above line it is corrected(i.e, decremented
by 1) and xs_inodes_meta is incremented - shouldn't the appropriate counter have been directly
bumped up whenever it was created? Something similar to what is being done in __xfs_inode_free()?
For example, in xfs_inode_alloc() I can see a XFS_STATS_INC(mp, vn_active) - shouldn't we bump the
appropriate counter(xs_inode_{active or meta} there directly? Can you please let me know if my
understanding is correct or am I missing something?
> +	}
>  	return 0;
>  
>  out_destroy_data_fork:
> diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
> index cf239f862212..71f004e9dc64 100644
> --- a/fs/xfs/libxfs/xfs_metafile.c
> +++ b/fs/xfs/libxfs/xfs_metafile.c
> @@ -61,6 +61,9 @@ xfs_metafile_set_iflag(
>  	ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
>  	ip->i_metatype = metafile_type;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
> +	XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
>  }
>  
>  /* Clear the metadata directory inode flag. */
> @@ -74,6 +77,8 @@ xfs_metafile_clear_iflag(
>  
>  	ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	XFS_STATS_INC(ip->i_mount, xs_inodes_active);
> +	XFS_STATS_DEC(ip->i_mount, xs_inodes_meta);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index f76c6decdaa3..f2d4294efd37 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -172,7 +172,10 @@ __xfs_inode_free(
>  	/* asserts to verify all state is correct here */
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
>  	ASSERT(!ip->i_itemp || list_empty(&ip->i_itemp->ili_item.li_bio_list));
> -	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
> +	if (xfs_is_metadir_inode(ip))
> +		XFS_STATS_DEC(ip->i_mount, xs_inodes_meta);
> +	else
> +		XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
>  
>  	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
>  }
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index bc4a5d6dc795..c13d600732c9 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -59,7 +59,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		{ "rtrefcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
>  		/* we print both series of quota information together */
>  		{ "qm",			xfsstats_offset(xs_gc_read_calls)},
> -		{ "zoned",		xfsstats_offset(__pad1)},
> +		{ "zoned",		xfsstats_offset(xs_inodes_meta)},
> +		{ "metafile",		xfsstats_offset(xs_xstrat_bytes)},
>  	};
>  
>  	/* Loop over all stats groups */
> @@ -99,16 +100,20 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  
>  void xfs_stats_clearall(struct xfsstats __percpu *stats)
>  {
> +	uint32_t	xs_inodes_active, xs_inodes_meta;
>  	int		c;
> -	uint32_t	xs_inodes_active;
>  
>  	xfs_notice(NULL, "Clearing xfsstats");
>  	for_each_possible_cpu(c) {
>  		preempt_disable();
> -		/* save xs_inodes_active, it's a universal truth! */
> +		/*
> +		 * Save the active / meta inode counters, as they are stateful.
> +		 */
>  		xs_inodes_active = per_cpu_ptr(stats, c)->s.xs_inodes_active;
> +		xs_inodes_meta = per_cpu_ptr(stats, c)->s.xs_inodes_meta;
>  		memset(per_cpu_ptr(stats, c), 0, sizeof(*stats));
>  		per_cpu_ptr(stats, c)->s.xs_inodes_active = xs_inodes_active;
> +		per_cpu_ptr(stats, c)->s.xs_inodes_meta = xs_inodes_meta;
>  		preempt_enable();
>  	}
>  }
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 64bc0cc18126..57c32b86c358 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -142,7 +142,8 @@ struct __xfsstats {
>  	uint32_t		xs_gc_read_calls;
>  	uint32_t		xs_gc_write_calls;
>  	uint32_t		xs_gc_zone_reset_calls;
> -	uint32_t		__pad1;
> +/* Metafile counters */
> +	uint32_t		xs_inodes_meta;
uint64_t would be an overkill, isn't it?

This patch looks okay to me - I have some questions posted above. I have mostly looked into whether
the appropriate checks for meta/normal inodes have been made, whether the counter updations are done
correctly etc and from those perspectives - this intent of this patch looks okay to me.
--NR
>  /* Extra precision counters */
>  	uint64_t		xs_xstrat_bytes;
>  	uint64_t		xs_write_bytes;

