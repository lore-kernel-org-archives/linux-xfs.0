Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AACA3054EC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770724582; cv=none; b=VpWK8OFGnANQNYhA1Y6l+gwNwn9QnY/kEBUjstqyOaMhtNoySfPAoKbmoJToO12l5Id1NFlVentx84ep2c3tpjTxU60klbs8wpouF0i9rzvLbExkSS7kFazGRcVYhgbHl0hQJwdafJ0IDQkNknfjTzbOX57NW4HXd8+DrMpeXXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770724582; c=relaxed/simple;
	bh=xb0H8f0zij+2Lo5cSIubhLbaPZ+hPhQo2RxGO9SlgfA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=HezIKeVs8F/SLOIg5I+kG4cORGEvrTUUu6oKFYvY1EWdTzRu8tfKnwWthixEKoygGbWWU8aIyIrQURpnrgCtEkXeGaIYffSIbwBO/lDIuSy2rIeo45wyaRbYPRR40Zb6uZEFNOso2xHbxWBGUxbEujWXhOdIZ7xN/MkOnj68mfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kRzcrZSc; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRzcrZSc"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82491fbf02cso55290b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 03:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770724580; x=1771329380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nh7yAl8rufONh7m/CgHms/EgFK1saZrvUpQU2nWdB00=;
        b=kRzcrZScGlMtVthGaxPh63kFFnIA2UUpZfQUAE1thEmSak1Dksxz984APw42CB09YV
         LVYNmHJvF3HwSq1tuPKcV66UyS5E5t5f5oJ0I+tGvBGLOZSqe5sMIwWzwogPXCFKTGGp
         i9I4G0wHhY+b78NxcC0qRJniib47Xz1uZTioXRZGm8wD3uQYNZaAZLjR2ClQD6toQ/op
         Qwjn0alu9OkTABxXKr7kLSnTkEiwJs98xLWHQ88BfjXcue14sCRDjrhlbJVebL/NeHPb
         wDSSwYF5PKmqIRYLsMADjOv9ykmQOa4vL+W09CdZAV05CcAIoTzfjgVE9iP2fpLiNHrV
         Nt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770724580; x=1771329380;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nh7yAl8rufONh7m/CgHms/EgFK1saZrvUpQU2nWdB00=;
        b=w/kPwxPiNt6XrPbto4/nWnoNMNlelEt5YshJptBwLZur/MdAXwzVTcU4ynBQdHBUDy
         jYfuepR4gZQj0Vw4N46VhmJT5lj7dxnuvP7pQ5EsO7Rd52+QM3yIIkdnFAVUSSL07Nlr
         c3hfKCtp8YyNzM0N2UMjd9MCeav4BN91aNbz5dIKjUYZhGjton2BdcbAqEl+Og7/NwLp
         kaBc/edkhCmYsq7bFT1azp6sl9XqaLgbNpSBVxMlsA8STAYeyWBemIuaQOecTCF7Ku/C
         0ElcUkVn5YgLpdjnsjq6dsnC7pAxfQXcAFuQE5R/csE+LPUpWBAEwLnsMRIYvbhdHGw/
         8geg==
X-Forwarded-Encrypted: i=1; AJvYcCWy27UZC53MMXUB+E0YiGR4WX3su/jxl9oY5p9NeOytL1F0Kw18MgTRP/Cwx1ywLri0sqV/1ZynWQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmjbJ8puRjpHHvsdMo2NKyR4hNFKrLnIi/20/Txs/E7F9MzsYc
	mMqvPSokTt9/zd3aPjnK7G4BYvNXT46/1yH1waNhEtD4/iPPJuzQFQe5
X-Gm-Gg: AZuq6aJ0r2olwEWnR47M5Y7KpbB1hSKmcIS/TczpGAEY5Q1UWV1FTR375sq84dsTpV8
	hKoPGPvQ1zk/WY2VN6qDeh8aVhZ776fWlUtxo4JVbI/owmLfuBpKEdbkPScvj1UAPKBGO6T7K17
	HlTrjXf2+MZM2lL7qJAwBvRAIhJLeVO4jtQgFJ+XRNk0mn0e4xN5q+WBNZh50cbj+flq2CoIwQA
	Jv2eDJYiWKicEZvHDlw9vWqusOjfC46tg9N5cRzSJnOGGSifNkBA1yZU1yJJF4WU+cAhhhLu3yr
	L/UAk0y+pGeZLBuqs/kvAsNGkUTQw2+H/kXWfT20QyfzER7ZJJ8Wyji9mMzIWqdh4xwSA3yzBQx
	S1Xak/MxDVGoFMpkdmTHsU43yHY4cubeVhvytwv/Oljy3/CUCsAHz0W69kEX5mmNCRAiOEZ5h4H
	R2QSBoG454ROu5PBEj8GXPXHJtGoQU2umHH6KVHmA+C4UptvlItQxJZUe4+j/8zcBgNk70nIHbt
	Dbl
X-Received: by 2002:a05:6a00:4fd6:b0:81e:96c9:1325 with SMTP id d2e1a72fcca58-824417f97cbmr13212298b3a.70.1770724580368;
        Tue, 10 Feb 2026 03:56:20 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418a70fesm12972619b3a.45.2026.02.10.03.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 03:56:19 -0800 (PST)
Message-ID: <46a56cbf1ead927d0bc109b8106ae3b5237ec721.camel@gmail.com>
Subject: Re: [PATCH v3 5/6] xfs: add per-AG writeback workqueue
 infrastructure
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
 cem@kernel.org,  wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Date: Tue, 10 Feb 2026 17:26:11 +0530
In-Reply-To: <20260116100818.7576-6-kundan.kumar@samsung.com>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0@epcas5p1.samsung.com>
	 <20260116100818.7576-6-kundan.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
> Introduce per-AG writeback worker infrastructure at mount time.
> This patch adds initialization and teardown only, without changing
> writeback behavior.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_aops.c  | 79 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_aops.h  |  3 ++
>  fs/xfs/xfs_mount.c |  2 ++
>  fs/xfs/xfs_mount.h | 10 ++++++
>  fs/xfs/xfs_super.c |  2 ++
>  5 files changed, 96 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a26f79815533..9d5b65922cd2 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -23,6 +23,23 @@
>  #include "xfs_zone_alloc.h"
>  #include "xfs_rtgroup.h"
>  
> +#define XFS_AG_TASK_POOL_MIN 1024
> +
> +struct xfs_ag_wb_task {
> +	struct list_head list;
> +	struct xfs_inode *ip;
> +	struct writeback_control wbc;
> +	xfs_agnumber_t agno;

agno where the ip resides or the agno of any one the blocks which belongs to this ip?
> +};

Nit: Coding style - tab between data type and the indentifier
> +
> +struct xfs_ag_wb {
> +	struct delayed_work ag_work;
> +	spinlock_t lock;
> +	struct list_head task_list;
> +	xfs_agnumber_t agno;
> +	struct xfs_mount *mp;
> +};
> +
>  struct xfs_writepage_ctx {
>  	struct iomap_writepage_ctx ctx;
>  	unsigned int		data_seq;
> @@ -666,6 +683,68 @@ static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
>  	.writeback_submit	= xfs_zoned_writeback_submit,
>  };
>  
> +void
> +xfs_init_ag_writeback(struct xfs_mount *mp)
> +{
> +	xfs_agnumber_t agno;
> +
> +	mp->m_ag_wq = alloc_workqueue("xfs-ag-wb", WQ_UNBOUND | WQ_MEM_RECLAIM,
> +				      0);

Nit: I think we follow 2 tabs indentation of the parameter list length exceeds per line limit count.
Similar comments for such changes in the below function call sites.
> +	if (!mp->m_ag_wq)
> +		return;
> +
> +	mp->m_ag_wb = kcalloc(mp->m_sb.sb_agcount,
> +				sizeof(struct xfs_ag_wb),
> +				GFP_KERNEL);
> +
> +	if (!mp->m_ag_wb) {
> +		destroy_workqueue(mp->m_ag_wq);
> +		mp->m_ag_wq = NULL;
> +		return;
> +	}
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
> +
> +		spin_lock_init(&awb->lock);
> +		INIT_LIST_HEAD(&awb->task_list);
> +		awb->agno = agno;
> +		awb->mp = mp;
> +	}
> +
> +	mp->m_ag_task_cachep = kmem_cache_create("xfs_ag_wb_task",
> +						sizeof(struct xfs_ag_wb_task),
> +						0,
> +						SLAB_RECLAIM_ACCOUNT,
> +						NULL);
> +
> +	mp->m_ag_task_pool = mempool_create_slab_pool(XFS_AG_TASK_POOL_MIN,
> +	mp->m_ag_task_cachep);

Nit: 2 tabs indentation
> +
> +	if (!mp->m_ag_task_pool) {
> +		kmem_cache_destroy(mp->m_ag_task_cachep);
> +		mp->m_ag_task_cachep = NULL;

Shouldn't we be also freeing mp->m_ag_wq and the array mp->m_ag_wb[] array ?
> +	}
> +}
> +
> +void
> +xfs_destroy_ag_writeback(struct xfs_mount *mp)
> +{
> +	if (mp->m_ag_wq) {
> +		flush_workqueue(mp->m_ag_wq);
> +		destroy_workqueue(mp->m_ag_wq);
> +		mp->m_ag_wq = NULL;
> +	}
> +	kfree(mp->m_ag_wb);
> +	mp->m_ag_wb = NULL;
> +
> +	mempool_destroy(mp->m_ag_task_pool);
> +	mp->m_ag_task_pool = NULL;
> +
> +	kmem_cache_destroy(mp->m_ag_task_cachep);
> +	mp->m_ag_task_cachep = NULL;
> +}
> +
>  STATIC int
>  xfs_vm_writepages(
>  	struct address_space	*mapping,
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 5a7a0f1a0b49..e84acb7e8ca8 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -12,4 +12,7 @@ extern const struct address_space_operations xfs_dax_aops;
>  int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
>  void xfs_end_bio(struct bio *bio);
>  
> +void xfs_init_ag_writeback(struct xfs_mount *mp);
> +void xfs_destroy_ag_writeback(struct xfs_mount *mp);
> +
>  #endif /* __XFS_AOPS_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 0953f6ae94ab..26224503c4bf 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1323,6 +1323,8 @@ xfs_unmountfs(
>  
>  	xfs_qm_unmount(mp);
>  
> +	xfs_destroy_ag_writeback(mp);
> +
>  	/*
>  	 * Unreserve any blocks we have so that when we unmount we don't account
>  	 * the reserved free space as used. This is really only necessary for
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index b871dfde372b..c44155de2883 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -342,6 +342,16 @@ typedef struct xfs_mount {
>  
>  	/* Hook to feed dirent updates to an active online repair. */
>  	struct xfs_hooks	m_dir_update_hooks;
> +
> +
> +	/* global XFS AG writeback wq */
> +	struct workqueue_struct *m_ag_wq;
> +	/* array of [sb_agcount] */
> +	struct xfs_ag_wb        *m_ag_wb;
> +
> +	/* task cache and pool */
> +	struct kmem_cache *m_ag_task_cachep;
> +	mempool_t *m_ag_task_pool;

Again Nit: - Coding style - tab between data type and the identifier


>  } xfs_mount_t;
>  
>  #define M_IGEO(mp)		(&(mp)->m_ino_geo)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bc71aa9dcee8..73f8d2942df4 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1765,6 +1765,8 @@ xfs_fs_fill_super(
>  	if (error)
>  		goto out_free_sb;
>  
> +	xfs_init_ag_writeback(mp);

So if we are not able to init the write back workqueue infra, we are still okay to mount the fs
except that the AG aware write back facility won't be available i.e, we aren't treating it as a
fatal error, correct?
--NR
> +
>  	/*
>  	 * V4 support is undergoing deprecation.
>  	 *

