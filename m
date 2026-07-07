Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FAD3E556D;
	Tue,  7 Jul 2026 16:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783441780; cv=none; b=tZSgiPD+TIse5NVf1bp+/+tYl5SKPGByi8V1YzRT1l5ft32/mXNKons2xXkMN7YFFIexJyvE8CQ87Zp1hEPb10LvDX5pn+ulAbHNlPowWAfzhH+Lod5SUpGKQvhMF+s3YS8135Py0iMtw5h24gV7mD3VGWowVg+pgJe2k3WLuNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783441780; c=relaxed/simple;
	bh=oAZCKhC394772yLq9RvuLjXSF7xoOV3aVHcz6mztrs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXADKklVBMfXfC5PGebVl1BXKPaJTb3zZp9XTnoFj0+GMlChcitR1hEeS7j3pd3JHRE6dwnnybKAf2qMTU9IQwciu8SVe9VuTzUTa5ecmhw89sUn8Xc8MEVdM47j/T6NusVgx2PPcvXP7AEgcIyyyoK2Jm25daATgpp/hC0pBPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDasoq//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDasoq//"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0A58C1F00A3D;
	Tue,  7 Jul 2026 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783441779;
	bh=yBT+4HWzw6XJlBObQPp6jZiE4hFbK2bBtwsV7DKbCZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CDasoq//R6c/7/j5e4VWDf200UqWKUz0KZ53gM0ff/BDuYIqOLFTfwNJ9/6E4Nrsd
	 Cw5LGMoMTbytqfaA57Xor/5ardWb5vPBL7+CD3ld/CfFCmkM1AtBmBWNw6Vkngrt06
	 AQxu48VtAstkoZIfuqOoicsH6UcvG7GeE35UAY10dlbzurgEG1NDUhgccb1dZmUHBN
	 dgw2+76SSnoWB2wisVFOvaqoRTm+xucRpIIDgIx72jlka8ZJuDWXGMF0BesxeEDfQ/
	 u8bvuFSb9KNGgO5WTsVV7KggUQShCi7PJziYTdmWgE3UHdRcE+Nc8+59fycCqbf9uI
	 7g26J8t+eA7rg==
Date: Tue, 7 Jul 2026 09:29:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: bound da-node entry count against the correct
 geometry
Message-ID: <20260707162938.GZ9392@frogsfrogsfrogs>
References: <20260707135930.3214701-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707135930.3214701-1-qwe.aldo@gmail.com>

On Tue, Jul 07, 2026 at 10:59:30AM -0300, Aldo Ariel Panzardo wrote:
> xfs_da3_node_verify() bounds the node entry count against the larger of
> the directory and attribute geometries because it does not know which
> tree the block belongs to. When the directory block size exceeds the fs
> block size (e.g. mkfs.xfs -n size=64k -b size=4k), the attribute node
> buffer is a single fs block holding only m_attr_geo->node_ents entries,
> but a crafted attr node may claim a count up to m_dir_geo->node_ents.
> xfs_da3_node_lookup_int() then reads btree[] entries past the buffer
> during its binary search -- an out-of-bounds read via getxattr/listxattr
> on a mounted crafted image.
> 
> The node buffer size identifies its geometry, so bound the count against
> that geometry's node_ents rather than the maximum of the two.
> 
> Fixes: 7ab610f9e0f1 ("xfs: move node entry counts to xfs_da_geometry")
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 9debb95d86fa..897c31147a46 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -240,12 +240,18 @@ xfs_da3_node_verify(
>  		return __this_address;
>  
>  	/*
> -	 * we don't know if the node is for and attribute or directory tree,
> -	 * so only fail if the count is outside both bounds
> +	 * The block was read using either the attribute or the directory
> +	 * geometry; its buffer size tells us which one, so bound the entry
> +	 * count against that geometry's node_ents.  Only failing when the
> +	 * count exceeds max(dir, attr) let a crafted attr node claim a
> +	 * dir-sized count and overrun the smaller attr buffer.
>  	 */
> -	if (ichdr.count > mp->m_dir_geo->node_ents &&
> -	    ichdr.count > mp->m_attr_geo->node_ents)
> +	if (BBTOB(bp->b_length) == mp->m_attr_geo->blksize) {

No.  That's not how we determine if the caller is trying to read a
directory or an xattr block.

--D

> +		if (ichdr.count > mp->m_attr_geo->node_ents)
> +			return __this_address;
> +	} else if (ichdr.count > mp->m_dir_geo->node_ents) {
>  		return __this_address;
> +	}
>  
>  	/* XXX: hash order check? */
>  
> -- 
> 2.43.0
> 
> 
