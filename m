Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793227802;
	b=5GOwE+wpB34Mnco47Ex1sJKP5w2QpDBN6X7/qrachmjgjiGp23t2dNYaA852uWW8koW+
	 VRyWJ9kbs+6bqs+N2G4GZpq5O8p1fPblr27H5io8xc0UlRfJ6dsFw7ob6Px/e2Xf5XIQd
	 PQgCYAvkCWmlUX9+UFoAqeXI+2yAKY0aQ9GvtVTiDoD2zrjcVoDs+3hPYBlDd/XOAmqvU
	 cJEoRnHeqUSCKb0tAxI8QOuDtVlTvFmFC6b8Rwnfo8NMAsjmmLAWyOpwhLowq6CeR275h
	 SmCz/O5vad+qbLeAXoaLajG9H6ddnmtky1eJIf1jl6cGoMV2ZZbFllxiwQ+WcX7sdew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793227802;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BmDoHj1MHvhUgXHU+vuqR0K+Yg8Yy1nujE/6Kcj5G6o=;
	b=fJ+YblrVhOzh+00V7Vs9ontWP4+0QzvWVRNLV3Gza++v+beBZFV4ahsuxKu5vwJQl+z8
	 Mgy08GvfN6xiXBtVIYZu52t6HqjtjWSDy1qvag5j7fhDxY0J/f2oP0EUBjif5b57ectil
	 nbjLn3D/SATUGPvhsKtcUv2CGQjiQ405u8pT2QusQZWDBNkzm5VRwcU+FzhVJ9wGcsNTE
	 o48mFjcVn6gKLV8j0chzpBVFNGG4ot6EF28nknAWFHn4CQ+wJ8BQQZJmGavGtUjtVYF3m
	 141L1+9rBlXRPMPA6kf4vhwxf6QfeXYQ4ctV3UW9+KYVi3/pVlBrXX0IycNKftZWZmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g1saRV9X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAE3606A31D;
	Wed, 28 Oct 2026 22:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g1saRV9X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888C51F01828;
	Wed, 28 Oct 2026 22:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793227801;
	bh=BmDoHj1MHvhUgXHU+vuqR0K+Yg8Yy1nujE/6Kcj5G6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g1saRV9X7QPtVna/jYxkbnibt2GJ+fCet0oodd5v1JZ7xwjfCA2odV+hgJnH8Y0bN
	 yU96xzJP6yGLyBxz78/F7uCk6eEn5KF8xVCnFWZJ+rWMONBA5bnBWwVDKQcYBHZ2W7
	 CLkeL9qB2hsPQf/O4OlYdNZ5io4gsvMM6iyQwqVS/g9aD+DNIIGuP4+Y5Sfl72+h9l
	 aPtDUTDyIjdk0mzIn1lzgnsinVmXWX1gwdF58k4k/Rc49mgeldejjqDIEMwPbBFEOu
	 IIFP3vSfVCTpn9VCmFelDdu1o3ubdc3DGfyC5LlGWoxg0M98y4T17kgkUfg/79L6+I
	 3jEbpTNKHFpnA==
Date: Thu, 29 Oct 2026 09:49:50 +1100
From: Dave Chinner <dgc@kernel.org>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	James Clark <james.clark@linaro.org>,
	Long Li <leo.lilong@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Javier Tia <javier@peridio.com>, SJ Park <sj@kernel.org>,
	Rafal Ostrowski <rafal.ostrowski@amd.com>,
	Myeonghun Pak <mhun512@gmail.com>, Likun Gao <Likun.Gao@amd.com>,
	hongao <hongao@uniontech.com>, Kees Cook <kees+treewide@kernel.org>,
	Cihan Karadag <cihan.cihan@gmail.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out-of-bounds da node read with a crafted
 record count
Message-ID: <auJ8Dv304AnzETMy@dread>
References: <20261027151754.975492-1-bsdhenrymartin@gmail.com>
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
In-Reply-To: <20261027151754.975492-1-bsdhenrymartin@gmail.com>

On Tue, Oct 27, 2026 at 11:17:54PM +0800, Henry Martin wrote:
> xfs_da3_node_verify() bounds the on-disk record count with:
> 
> 	/* we don't know if the node is for and attribute or directory
> 	 * tree, so only fail if the count is outside both bounds
> 	 */
> 	if (ichdr.count > mp->m_dir_geo->node_ents &&
> 	    ichdr.count > mp->m_attr_geo->node_ents)
> 		return __this_address;
> 
> The "fail only outside both bounds" conjunction is forced weak
> because the verify pass cannot tell directory from attribute nodes.
> On filesystems with a multi-fsb directory block size (mkfs.xfs -n
> size=64k, sb_dirblklog > 0), m_dir_geo->node_ents is much larger than
> m_attr_geo->node_ents (~8184 vs ~504 for 64k/4k), so an attribute
> tree node with a count in (attr_ents, dir_ents] passes verification.
> Consumers then index the in-block btree array with that count and
> read out of bounds:
> 
>   xfs_da3_node_lookup_int()   btree[max - 1].hashval  (max = count)
>   xfs_da3_path_shift()        btree[nodehdr.count - 1].hashval / .before
> 
> with count=8184 the read lands ~61KB past the 4K buffer, and the
> out-of-bounds "before" value is then used as a child block number.
> The read path is reachable by an unprivileged user via
> getxattr/listxattr once the malicious image is mounted.
> 
> Tightening the verify conjunction would falsely reject legitimate
> large directory nodes whose counts live in the same interval, so
> enforce the per-fork bound instead where the geometry is known: at
> the two consumers that index the array with the on-disk count.
> 
> This issue was discovered by Tencent CodeBuddy Security.

No, it's pretty obvious that we knew about it a long, long time ago.
The bounds check we currently have catches gross corruptions, and
for the types of corruption we see in the real world (i.e. media
errors trashing entire sectors) this has been sufficient to avoid
issues. Hence there's been no priority/urgency to fix stuff like
this, because malicious images are not a threat model we are able to
defend against.

> Fixes: f5ea110044fa ("xfs: add CRCs to dir2/da node blocks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 3d02a0d7ba44a..ab3deff11111e 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1787,6 +1787,18 @@ xfs_da3_node_lookup_int(
>  		} else
>  			expected_level--;
>  
> +		/* The verify pass cannot tell directory from attribute
> +		 * nodes, so its count bound has to allow both geometries.
> +		 * Here we know the fork; enforce its geometry so crafted
> +		 * counts cannot make the array indexing run out of the
> +		 * block.
> +		 */
> +		if (nodehdr.count > args->geo->node_ents) {
> +			xfs_buf_mark_corrupt(blk->bp);
> +			xfs_da_mark_sick(args);
> +			return -EFSCORRUPTED;
> +		}

Again, look at the code. The node header is verified a few lines
above via xfs_da3_node_header_check(). We know that the read
verifier cannot verify everything in IO context, so we have checks
that are always done immediately after the buffer has been read
before we start using the node header.

If the new check is added there, then no other code needs to be
touched. i.e. every place we first read a da-node can be correctly
bounds checked because args->geo is available at all those call
sites...

-Dave.

-- 
Dave Chinner
dgc@kernel.org
