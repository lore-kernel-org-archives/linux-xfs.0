Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C1531F9BE;
	Mon, 11 May 2026 11:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778497759; cv=none; b=QX7RzwkLnDfIi3FIi6z8WnemP7Gaf9feHVVkmtXrslPSi24mrLqhDANbKP94A/KDSTp+y5Gptf0imL8YeHt6M4sQPEnXcG7sWzqBkmPB2gPTbXK1Oy4Y9dKyschtcoXCacB6uADlCO0T85E4YDWoqZa68aoixuX1Lih8ddpoEbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778497759; c=relaxed/simple;
	bh=9v6/kp9KWGqV5f4tFLJXh6fW/9KSpBMJObwCjw/qewQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJJ6xXmDAsujiiZ5PzjXbF99SjeUxMfaK/Vjh646d82xRfelhU241suWOxAw90yPnKh8skyDN7SgTmaBxVicaEl4BqZQaWVELmHvVwPOLnUwrkTLCJJyeHhmca8yL0Y3w1QpIn4vff/CjBpPvCUlI4NWkomF8S56D8P20g3c3DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=my9YrLq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="my9YrLq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B530C2BCB0;
	Mon, 11 May 2026 11:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778497758;
	bh=9v6/kp9KWGqV5f4tFLJXh6fW/9KSpBMJObwCjw/qewQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=my9YrLq8PHAj2cxfg6nWAnoOc76mGf1WcNcT1KVP5kaSvUkCq+1AqIkqAYJCR0/rz
	 baXZzdiVH/ykJtut6Vf3GCSBEhu8hk0882Fl+M7nohC8kse3QV9KYRXQ8w/WjRKL8/
	 8sAQdnkGZs3ZysGOHomxXqKGB5ozUnc2uzmKCRbfTH63msOm1MnBQL6BOhdoeRHSZz
	 RBOUMwRGSM97rCzsE7wE8cIhto8Ot4nrf+Sh1l6bTjbYcsxUNCgM62wrg9VyP0QBP5
	 cJcAffbHOMBeY3ujReF1HhLE26YA9RnOEvz9XxLhpBBGdAL49RqTdjk0YM+WDX5KK5
	 eQBbdozj1BjzQ==
Date: Mon, 11 May 2026 13:09:14 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: sanitize da node pad field on write
Message-ID: <agG4yFFqJhE_Evhp@nidhogg.toxiclabs.cc>
References: <20260423081843.32405-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423081843.32405-2-ytohnuki@amazon.com>

On Thu, Apr 23, 2026 at 09:18:44AM +0100, Yuto Ohnuki wrote:
> The DA node block header (xfs_da3_node_hdr) contains a __pad32 field
> that should always be zero. Prior to commit a45086e27dfa21 ("xfs:
> validate metadata LSNs against log on v5 superblocks"),
> xfs_da3_node_create() did not zero the full header, so __pad32 could
> contain stale data on older filesystems.
> 
> Clear this field in the write verifier to ensure it is corrected
> whenever the block is next written to disk.
> 
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
> Changes in v2:
> - Added comments explaining why __pad32 is cleared unconditionally.
> - Link to v1: https://lore.kernel.org/all/20260421054311.25301-2-ytohnuki@amazon.com/
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index ad801b7bd2dd..4edbf4bb5c7f 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -318,6 +318,12 @@ xfs_da3_node_write_verify(
>  	if (bip)
>  		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
>  
> +	/*
> +	 * Old kernels may not have zeroed the padding field in the header,
> +	 * so clear it unconditionally to sanitize stale data on disk.
> +	 */
> +	hdr3->__pad32 = 0;
> +
>  	xfs_buf_update_cksum(bp, XFS_DA3_NODE_CRC_OFF);
>  }
>  

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
