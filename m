Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039EF318EDB
	for <linux-xfs@vger.kernel.org>; Wed, 11 Feb 2026 09:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770802781; cv=none; b=it6vvXiURUnJSp1EMrltNy3bzLnpgE+4dsNVeDhXDoSWcm6Jcb5ro341pzemMZKr1bpVtrDTkxZtqZm5hguy/nPv7xZxLY0KVXZIsaWrWIlvg83k1SThDfjsGXlw6RRrY2u8LEHFe52+St+ry90C5F1KFxDnJdoemYxd8DHw7+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770802781; c=relaxed/simple;
	bh=O6gpU1IXzsMGv/H1tv+fqNzVpbMKe9TsMPFFLeOAFvE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=YcZ8UlAqB+pslFYBF2rNB+kcTLnAEAPbefSPvmSHkFgeXBcreui/bm/m2leCd5tYBdp/lTWFXW2KdFenjSEZIErJSsqBqw0bCZaiTHieLUaNS1vCHuAHwRVGWuiA34wS+KXgGAyn0sfra6KoEwlSO/td82b52VEV5rKz627NPv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UMWet0U4; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UMWet0U4"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82361bcbd8fso2683831b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Feb 2026 01:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770802779; x=1771407579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CsUDYOX+di7Z7Ep7ACxPObG+oLUZUZhESUJGxSBNSQc=;
        b=UMWet0U4dlH96gyh9LfR2UJ3AqBFepEr+u4OBBW/HNlEJIPNnH9nhP04SIh+M3eedX
         oPOIm0dOzrRMiSkD4BmhH6Oy5hnMAfezh/QR6MQ5cJQHBj9rmjtzifXtDSYTJsLVWrVX
         iR9XLsOZYWDihi5SC/KTqXqcdmI3aMmutcWN2r3Sc7xDntJsJG/BzEBLAjGY/05XlOj7
         T2aiKyocV1R6rfiE81A0k4pz2T8st7772so5JmeGqr16cpup4LGYyDNaj7QNC0a69lrv
         1IvhE7tqVDir6VtbywK2F44L0W2rFRCrWMZS2R7Z+8+NLbEabaPYTKIorzm7EiCu0uhK
         DqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770802779; x=1771407579;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CsUDYOX+di7Z7Ep7ACxPObG+oLUZUZhESUJGxSBNSQc=;
        b=MLytiCulK141LEka6FeMIzfqRj6NqkBS5hDNOMr3/5ZkjyW9tdF95cxEJfYH+xeJX5
         SfoXOMathYMx3gCx0ixf/WEgHPWizzAygLRkIF/FxubiDNoMYhsgHawYDzPhWXpH8Bi0
         SMt3170uHatEoGSBz2PawA5Dx4UI57xGRnP76VfYF2l/07XwjzfoNEDqXAzm8eVLsFnT
         oxkJqcbuFm6OHECXUU+eUEFsnRPk9iTR5vhPDCObB7e0JU6sJGAzGPw6aKwTBItq70Ol
         wkSb8UkODFjVojSuryB6zIiXSAZ7N3238yVkmr4HaqqT/Bm7FXyENqjE3kJXqbpjIoY0
         sF7w==
X-Forwarded-Encrypted: i=1; AJvYcCUYFuNj/CAnW5RZYsJztYEqOzEPMUJvoT0PucaggLuVS80ns7ZMdbqggm7Tc+ANMxsv561sCpUKBhg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4IOAtRiG1hpcLu6iLiWstkOLS6WlUJDgd2EUakWR4l7V6aZbj
	QefWx3PH0UqmBAmdzu46GW3BTCpzW43Hef3FkefYWRVFtlmrWXmdIWJY
X-Gm-Gg: AZuq6aIM7bu+lC2npFv3mzAubxdCQJpCV219EdVW2KjOfX6pWeCXibEHJjRZ3zKrg3x
	KVdJOU39D/UnR9BaC3B9zFphvSI9JwSDXnZUogVmHb3WHbNjLlpkGM7BcO/16B02zxqx+DmSeOm
	0+dMsNWWBASWswO62bR3UNRX276qghODhStN1oyej4msl5RA8qrtVabt643ldiFu0HQDgR6Va8k
	78vyMTQigH8PPtgvBlcJcK4g4DMe3hOzZWiy4CFMIcJdnYlWjtqxVfFtUktZ8xf3k5OPrkyS2Fk
	YGzTlBgJ2f8B6BjS+lOHxbhSX1YS7BpfSffIhUVnFC1CSuYg4RBz/sLyjBnsMwwRYD9W+zDmYai
	fxJCMbhEsSP1iwbLJ9Q7gMsAa+z8r9NIkdZ9ia5LViTTMJDubJpUG04zO5w7MSE0mmvGEezdFmM
	uCW693W0JjDM83qGhRWtI1lXP41srIcxUELCrJEkOfn3R/9EEHxgyU3LhfQhxDECpdJdQHQTRjD
	asK
X-Received: by 2002:a05:6a00:2192:b0:81f:3f8a:4c37 with SMTP id d2e1a72fcca58-8249b0c69ebmr1868834b3a.38.1770802779201;
        Wed, 11 Feb 2026 01:39:39 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.226.188])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e3bd3bdsm1597023b3a.18.2026.02.11.01.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 01:39:38 -0800 (PST)
Message-ID: <e9b10221c42b77050120332b6d3cb3c131e551fe.camel@gmail.com>
Subject: Re: [PATCH v3 6/6] xfs: offload writeback by AG using per-inode
 dirty bitmap and per-AG workers
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
 cem@kernel.org,  wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Date: Wed, 11 Feb 2026 15:09:29 +0530
In-Reply-To: <20260116100818.7576-7-kundan.kumar@samsung.com>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101305epcas5p497cd6d9027301853669f1c1aaffbf128@epcas5p4.samsung.com>
	 <20260116100818.7576-7-kundan.kumar@samsung.com>
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
> Offload XFS writeback to per-AG workers based on the inode dirty-AG
> bitmap. Each worker scans and submits writeback only for folios
> belonging to its AG.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_aops.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 178 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9d5b65922cd2..55c3154fb2b5 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -678,6 +678,180 @@ xfs_zoned_writeback_submit(
>  	return 0;
>  }
>  
> +static bool xfs_agp_match(struct xfs_inode *ip, pgoff_t index,
> +			  xfs_agnumber_t agno)
> +{
> +	void *ent;
> +	u32 v;
> +	bool match = false;

Similar coding style comments as mentioned in the previous patches in this series - variable
declaration and function prototype style
> +
> +	ent = xa_load(&ip->i_ag_pmap, index);
> +	if (ent && xa_is_value(ent)) {
> +		v = xa_to_value(ent);
> +		if (xfs_agp_valid(v))
> +			match = (xfs_agp_agno(v) == (u32)agno);
> +	}
> +
> +	return match;
> +}
> +
> +static bool xfs_folio_matches_ag(struct folio *folio, xfs_agnumber_t agno)
> +{
> +	struct xfs_inode *ip = XFS_I(folio_mapping(folio)->host);
> +
> +	return xfs_agp_match(ip, folio->index, agno);
> +}
> +
> +static int xfs_writepages_ag(struct xfs_inode *ip,
> +			     struct writeback_control *wbc,
> +			     xfs_agnumber_t agno)
> +{
> +	struct inode *inode = VFS_I(ip);
> +	struct address_space *mapping = inode->i_mapping;
> +	struct folio_batch *fbatch = &wbc->fbatch;
> +	int ret = 0;
> +	pgoff_t index, end;
> +

Coding style ^^
> +	wbc->range_cyclic = 0;
> +
> +	folio_batch_init(fbatch);
> +	index = wbc->range_start >> PAGE_SHIFT;
> +	end = wbc->range_end >> PAGE_SHIFT;
> +
> +	struct xfs_writepage_ctx wpc = {
> +		.ctx = {
> +			.inode = inode,
> +			.wbc = wbc,
> +			.ops = &xfs_writeback_ops,
> +		},
> +	};

Nit: Maybe group all the declarations together? I did get a comment like this in one of my patches.
> +
> +	while (index <= end) {
> +		int i, nr;

Coding style
> +
> +		/* get a batch of DIRTY folios starting at index */
> +		nr = filemap_get_folios_tag(mapping, &index, end,
> +					    PAGECACHE_TAG_DIRTY, fbatch);
2 tabs indentation
> +		if (!nr)
> +			break;
> +
> +		for (i = 0; i < nr; i++) {
> +			struct folio *folio = fbatch->folios[i];
> +
> +			/* Filter BEFORE locking */
> +			if (!xfs_folio_matches_ag(folio, agno))
> +				continue;
> +
> +			folio_lock(folio);
> +
> +			/*
> +			 * Now it's ours: clear dirty and submit.
> +			 * This prevents *this AG worker* from seeing it again
> +			 * next time.
> +			 */
> +			if (!folio_clear_dirty_for_io(folio)) {
> +				folio_unlock(folio);
> +				continue;
> +			}
> +			xa_erase(&ip->i_ag_pmap, folio->index);
> +
> +			ret = iomap_writeback_folio(&wpc.ctx, folio);
> +			folio_unlock(folio);
> +
> +			if (ret) {
> +				folio_batch_release(fbatch);
> +				goto out;
> +			}
> +		}
> +
> +		folio_batch_release(fbatch);
> +		cond_resched();
> +	}
> +
> +out:
> +	if (wpc.ctx.wb_ctx && wpc.ctx.ops && wpc.ctx.ops->writeback_submit)
> +		wpc.ctx.ops->writeback_submit(&wpc.ctx, ret);
> +
> +	return ret;
> +}
> +
> +static void xfs_ag_writeback_work(struct work_struct *work)
> +{
> +	struct xfs_ag_wb *awb = container_of(to_delayed_work(work),
> +					     struct xfs_ag_wb, ag_work);
> +	struct xfs_ag_wb_task *task;
> +	struct xfs_mount *mp;
> +	struct inode *inode;
> +	struct xfs_inode *ip;
> +	int ret;

Coding style issues for variable declarations
> +
> +	for (;;) {
Nit: I am not sure if this is a common practice in XFS to use such infinite for loops. Maybe have
some conditional flag variable or something? Darrick, thoughts? 
> +		spin_lock(&awb->lock);
> +		task = list_first_entry_or_null(&awb->task_list,
> +						struct xfs_ag_wb_task, list);
2 tabs indentation                              ^^
> +		if (task)
> +			list_del_init(&task->list);
> +		spin_unlock(&awb->lock);
> +
> +		if (!task)
> +			break;
> +
> +		ip = task->ip;
> +		mp = ip->i_mount;
> +		inode = VFS_I(ip);
> +
> +		ret = xfs_writepages_ag(ip, &task->wbc, task->agno);
> +
> +		/* If didn't submit everything for this AG, set its bit */
> +		if (ret)
> +			set_bit(task->agno, ip->i_ag_dirty_bitmap);
> +
> +		iput(inode); /* drop igrab */
> +		mempool_free(task, mp->m_ag_task_pool);
> +	}
> +}
> +
> +static int xfs_vm_writepages_offload(struct address_space *mapping,
> +				     struct writeback_control *wbc)
2 tabs indentation                   ^^		 
> +{
> +	struct inode *inode = mapping->host;
> +	struct xfs_inode *ip = XFS_I(inode);
> +	struct xfs_mount *mp = ip->i_mount;
> +	struct xfs_ag_wb *awb;
> +	struct xfs_ag_wb_task *task;
> +	xfs_agnumber_t agno;
> +

Coding style for variable declaration ^^
> +	if (!ip->i_ag_dirty_bits)
> +		return 0;
> +
> +	for_each_set_bit(agno, ip->i_ag_dirty_bitmap, ip->i_ag_dirty_bits) {
> +		if (!test_and_clear_bit(agno, ip->i_ag_dirty_bitmap))
> +			continue;
> +
> +		task =  mempool_alloc(mp->m_ag_task_pool, GFP_NOFS);
> +		if (!task) {
> +			set_bit(agno, ip->i_ag_dirty_bitmap);
> +			continue;
> +		}
> +
> +		INIT_LIST_HEAD(&task->list);
> +		task->ip = ip;
> +		task->agno = agno;
> +		task->wbc = *wbc;
> +		igrab(inode); /* worker owns inode ref */
> +
> +		awb = &mp->m_ag_wb[agno];
> +
> +		spin_lock(&awb->lock);
> +		list_add_tail(&task->list, &awb->task_list);
> +		spin_unlock(&awb->lock);
> +
> +		mod_delayed_work(mp->m_ag_wq, &awb->ag_work, 0);
> +	}
> +
> +	return 0;

It seems that this function always returns zero - maybe in that case use void?
> +}
> +
>  static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
>  	.writeback_range	= xfs_zoned_writeback_range,
>  	.writeback_submit	= xfs_zoned_writeback_submit,
> @@ -706,6 +880,7 @@ xfs_init_ag_writeback(struct xfs_mount *mp)
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>  		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
>  
> +		INIT_DELAYED_WORK(&awb->ag_work, xfs_ag_writeback_work);
>  		spin_lock_init(&awb->lock);
>  		INIT_LIST_HEAD(&awb->task_list);
>  		awb->agno = agno;
> @@ -769,6 +944,9 @@ xfs_vm_writepages(
>  			xfs_open_zone_put(xc.open_zone);
>  		return error;
>  	} else {
> +		if (wbc->sync_mode != WB_SYNC_ALL)
> +			return xfs_vm_writepages_offload(mapping, wbc);
> +

Since this patch (and the overall patch series) introduces a couple of new data structures and a lot
of new functions, can we please have some concise comments at the beginning of the functions or at
least the functions introduced in this patch - just for a quicker understanding?
--NR
>  		struct xfs_writepage_ctx	wpc = {
>  			.ctx = {
>  				.inode	= mapping->host,

