Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B969E54CF4D;
	Wed, 23 Sep 2026 16:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182191; cv=none; b=IUL2epD5dLCoq1wVAwIZKbyJv6x/8+95jwnAcmR4t0/jQ3nKWEC9ylI7lDn2ICcACTyZj3sF6PiH4xaIG6pcyKNOtveqsZFy/iqfllGlOVWCNhrPFKUFe8ygnWimj1a35cG4kbfDWGtPEglByS2taPlp0sOQ1dC2SzpK60T3q64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182191; c=relaxed/simple;
	bh=7ArV0HkcHCd1O9OfbmYD2AfKHhGKpHwULmDX5btc3gM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8N6ZQAAoAgp/3D5VKM4pVi03jHVWQItGjAnvV1cSwuIyW/x5vrqw27epHUJW6oxUy3RdakUPHv0Esq/CrGebq2ZoezH1lp4iq/33BW0+5TnlWbr93CiikvdYL7Q14/umhC9DbyRhaSJlj7VAgFRMi6TQuw/UX5hc6ArBjvyjFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtacBVpL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtacBVpL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0ACD21F000FF;
	Wed, 23 Sep 2026 16:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790182187;
	bh=CZHeNtyTHdgJlPWlcuOhs2bZ9MlhkfqKnSs+bd3pa+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dtacBVpLmvszOhCDuz7HOZpClJ2WD2LvzM/McGsBDXL7p7eqIFWHZZ7Ep5v/Ca2ik
	 mmnawfVjqFQwCh3crN3JuPR8EqHJR173pJM2fDfexMmE6efVk5zyxwSM7bkHj2bEV+
	 nRHC7lxfVuoTxSawmpODSiITgt/Y7w7q3Gs35qdULiPQPrO5DxZ8qBSTx9RVqw4s8o
	 +9+jFFNU5UVCaihA3egA6zbAwd6Mcgezl6MsQcjVGIrHdGiVTwdWgL19ItimzEwBpB
	 bLJHUIXddnAPrf+phR/teTiL/rFjcFA5+8TK5Mc+lbdbIOFPCQDGq1NksWv36dMTJJ
	 THPChAFt/OXhg==
Date: Wed, 23 Sep 2026 09:49:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] xfs: bound da-node entry count against the
 correct geometry
Message-ID: <20260923164946.GC2705364@frogsfrogsfrogs>
References: <20260923115754.3196232-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923115754.3196232-1-qwe.aldo@gmail.com>

On Wed, Sep 23, 2026 at 08:57:54AM -0300, Aldo Ariel Panzardo wrote:
> xfs_da3_node_verify() bounds the node entry count against the larger of
> the directory and attribute geometries because, as a buffer verifier, it
> cannot tell whether the block belongs to the directory or the attribute
> tree. When the directory block size exceeds the fs block size (e.g.
> mkfs.xfs -n size=64k -b size=4k), an attribute node buffer is a single fs
> block that holds only m_attr_geo->node_ents entries, yet a crafted attr
> node may claim a count up to m_dir_geo->node_ents and still pass the
> verifier.
> 
> xfs_da3_node_lookup_int() then indexes btree[] up to that count during
> its binary search -- an out-of-bounds read via getxattr/listxattr on a
> mounted crafted image.
> 
> The buffer verifier is the wrong place to tighten this: it has no fork
> context, and the transaction-less read path used by getxattr does not run
> xfs_da3_node_set_type() either. xfs_da3_node_lookup_int(), on the other
> hand, always runs on that path and holds args->geo, the geometry of the
> fork actually being searched. Bound the entry count against
> args->geo->node_ents there, before walking the entries.
> 
> Fixes: 7ab610f9e0f1 ("xfs: move node entry counts to xfs_da_geometry")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

I must've missed this, so thanks for reposting :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> v2: reworked per Darrick's review.  Do not infer dir-vs-attr from the
>     buffer size in the verifier; instead bound the entry count in
>     xfs_da3_node_lookup_int() against args->geo->node_ents, the
>     geometry of the fork being searched.  cc stable.
> 
>  fs/xfs/libxfs/xfs_da_btree.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 9debb95d86fa..95ea3737eb33 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1787,6 +1787,20 @@ xfs_da3_node_lookup_int(
>  		} else
>  			expected_level--;
>  
> +		/*
> +		 * The node verifier cannot tell whether this block belongs to
> +		 * the directory or the attribute tree, so it only bounds the
> +		 * entry count against the larger of the two geometries.  Here
> +		 * args->geo is the geometry of the fork we are actually
> +		 * searching, so reject a count that would walk btree[] off the
> +		 * end of this node buffer.
> +		 */
> +		if (nodehdr.count > args->geo->node_ents) {
> +			xfs_buf_mark_corrupt(blk->bp);
> +			xfs_da_mark_sick(args);
> +			return -EFSCORRUPTED;
> +		}
> +
>  		max = nodehdr.count;
>  		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
>  
> -- 
> 2.53.0
> 
> 
