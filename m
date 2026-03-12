Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC2F2820C6;
	Thu, 12 Mar 2026 14:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773325562; cv=none; b=t9e5R3YsPGISnEXbBa25GxfIkqqfinLliK8BACsjBnx70yon6Uf6LtHC88sJ3GyhvHYXoLf+XIe6a8LcllLMox7rA0VzIhLn9qO9qQABjwnlYoscc+9pJUer0ngrGzjhiQNFwMGs8DYekDvE9VBklPc9yOQXdwHCQumlP9f/614=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773325562; c=relaxed/simple;
	bh=k848j60HvtH7MWbaLc7OPs4xO69RUnxKM8wgJQuKl9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3CydElANcGPZS7HVXYT/KKxnUwhddXMysO6jTlFqYxeNtxjNzRYPcayaCB5TuACvNjVvG4++Lof37Y1wEb7jfE6yKiyXgSVkiXA10Jyr1FWNroxPR/51UB1zd2xgvpjNUxotVNhDerkIFZ04b6sLznW2f79CYFACr+12tWhBqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t+v8ijL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+v8ijL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB3EC4CEF7;
	Thu, 12 Mar 2026 14:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773325562;
	bh=k848j60HvtH7MWbaLc7OPs4xO69RUnxKM8wgJQuKl9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t+v8ijL5aHDzAUcL+zxOuQLK424XDV2CDX6NRNBw6lBL1oMOVjm7sKhlrxOGGTCZz
	 721Hk7bOmLNGi9f7TPxeL31EteUoXyLL4p8mMb2TLOEUfxuM29qPHJFsdtIn4Kwgzk
	 3KTArbMGwgL/iAyD/ahnVvxepbdSvqSB9CdQOJCnOO2X7/jnhyuwVISnktBcpOjBxv
	 8eyTu1tPwc3dXA72s7p4RuB+a94p4bIYdSlWSOXNOjcBInPNsFwvxAjra+mxSSS9y5
	 UBydC7c+TbKsjwYoKPHC7hmoVDlNQlwodsGg3Mpdk+vfrQ4DVkDsyM/iz3qELXfzG6
	 ZQMtpWn4Hr+pQ==
Date: Thu, 12 Mar 2026 07:26:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Morduan Zang <zhangdandan@uniontech.com>
Cc: cem@kernel.org, zhanjun@uniontech.com, hch@lst.de, dchinner@redhat.com,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: use GFP_NOFS in __xfs_trans_alloc
Message-ID: <20260312142601.GI1770774@frogsfrogsfrogs>
References: <24B50BB66059E3C8+20260312072214.475115-1-zhangdandan@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24B50BB66059E3C8+20260312072214.475115-1-zhangdandan@uniontech.com>

On Thu, Mar 12, 2026 at 03:22:14PM +0800, Morduan Zang wrote:
> __xfs_trans_alloc() allocates the transaction structure before
> xfs_trans_set_context() establishes the nofs context. If memory reclaim
> enters XFS through xfs_vn_sync_lazytime(), this GFP_KERNEL allocation can
> trigger a warning from the reclaim path.
> 
> Use GFP_NOFS for the transaction allocation to avoid filesystem reclaim
> recursion before the nofs context is set.

Why doesn't filesystem reclaim itself set PF_MEMALLOC_NOFS for us?

 xfs_vn_sync_lazytime+0xaf/0x150 fs/xfs/xfs_iops.c:1238
 sync_lazytime+0x12d/0x2d0 fs/fs-writeback.c:1721
 iput+0x230/0xe80 fs/inode.c:1997
 __dentry_kill+0x1a2/0x5e0 fs/dcache.c:670
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1147
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1174
 prune_dcache_sb+0x119/0x180 fs/dcache.c:1256
 super_cache_scan+0x369/0x4b0 fs/super.c:223
 do_shrink_slab+0x6df/0x1170 mm/shrinker.c:437`

--D

> Link: https://syzkaller.appspot.com/bug?extid=d78ace33ad4ee69329d5
> Fixes: 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc")
> Reported-by: syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com
> 
> Signed-off-by: Zhan Jun <zhanjun@uniontech.com>
> Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
> ---
>  fs/xfs/xfs_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index bcc470f56e46..0d347cff7317 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -217,7 +217,7 @@ __xfs_trans_alloc(
>  
>  	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp));
>  
> -	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
> +	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_NOFS | __GFP_NOFAIL);
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_start_intwrite(mp->m_super);
>  	xfs_trans_set_context(tp);
> -- 
> 2.50.1
> 
> 
