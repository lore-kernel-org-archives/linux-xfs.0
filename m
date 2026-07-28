Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFCB24CEEA;
	Tue, 28 Jul 2026 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251582; cv=none; b=S8rjsRuazkcSpwBVKYAlhDkeyEN2SboMfgfYZjrExBX5YHZE4E54CZC3FQnHMQ+mXBh+TYf07wb7TN7OhkEtF0iferVfxRKw3/N4M0FtQnuRxjixIt/LlqDPj2Xtk44ibK9NrpYVHDZtaCjEXoa7rO3Q2NiD5cbeTCp9KxuQAqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251582; c=relaxed/simple;
	bh=zwjIYYcTirhwra8L75lHSY7XleN1z2x2mYlJTbtPXIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cO8S+h94eQ4Q2hBGIAAfz5HtarEA615m9X3vM5zlurTTDCevQckwySJJPNnTOINE3G5Jh8+fUwOgz10SpPx2FxQXAXTvUwk87MHiTM+XqyDrTQDVzhCUPN0FX/auz/TY52lty7xWGXQVWX1HUzoJakjwcwnjcWT95HN3nzcLBAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KCi2MNjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCi2MNjU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9BBBE1F00A3D;
	Tue, 28 Jul 2026 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785251580;
	bh=CjzIUeyydDp1FNeB9HEnq1lerUJdpQlmkJB/qONU/pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KCi2MNjUwsjIOzXnonjvbR2c6l0ZB9/pll7XQ+KD7B81A/FiIMSsK8iH7NTBik94r
	 Ic64bYv8nfjiV0p0rdkkV5dl15VS9S6CTmL71w7mj1Edesr3L7NfkYIRx1l5YYEaAS
	 1XbXlL/qRYzb1XVdJvU13mMMw7MpbPYamQVqh1h63zh5NlCtSp5TIHtmdo+oibT45u
	 jmyrEGJB5TyLYii9O/JwgYrtGP3Gz4qn0V4yNflll7KQWLoXnPLaw9MZztH5jd4qeX
	 Tap6uxX3SaF3lqtLrKSMxoRi0ElA+nd6jXM+z/G5QDPPNrIJlbN53bQzmLNTnaB8+A
	 oYOZ6juyliI8A==
Date: Tue, 28 Jul 2026 08:12:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: cem@kernel.org, leo.lilong@huawei.com, bfoster@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhongling0719@126.com, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: validate attr entry pointer before field access
Message-ID: <20260728151259.GM2901224@frogsfrogsfrogs>
References: <20260728074340.84166-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728074340.84166-1-zenghongling@kylinos.cn>

On Tue, Jul 28, 2026 at 03:43:40PM +0800, Hongling Zeng wrote:
> xfs_attr3_leaf_verify_entry() accesses lentry/rentry fields (namelen,
> valuelen) before checking if the entry pointer itself is within bounds.
> If nameidx is crafted to point near the end of the buffer, these field
> accesses can read out-of-bounds before the bounds check at
> name_end > buf_end is performed.
> 
> Add explicit bounds checks for entry pointers before accessing their
> fields. Use offsetof() to check that the start of the flexible array
> member (nameval/name) is within bounds, which ensures all preceding
> fields are safe to access.
> 
> Fixes: c84760659dcf2 ("xfs: check attribute leaf block structure")
> Cc: <stable@vger.kernel.org>

Cc: <stable@vger.kernel.org> # v5.5

(for automatic backport)

> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

Looks correct to me;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 86c5c09a5db4..b6288395f853 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -325,6 +325,13 @@ xfs_attr3_leaf_verify_entry(
>  	 */
>  	if (ent->flags & XFS_ATTR_LOCAL) {
>  		lentry = xfs_attr3_leaf_name_local(leaf, idx);
> +
> +		/* Validate lentry pointer is within bounds before field access */
> +		if ((char *)lentry >= buf_end)
> +			return __this_address;
> +		if ((char *)lentry + offsetof(struct xfs_attr_leaf_name_local, nameval) > buf_end)
> +			return __this_address;
> +
>  		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
>  				be16_to_cpu(lentry->valuelen));
>  		name_end = (char *)lentry + namesize;
> @@ -332,6 +339,13 @@ xfs_attr3_leaf_verify_entry(
>  			return __this_address;
>  	} else {
>  		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
> +
> +		/* Validate rentry pointer is within bounds before field access */
> +		if ((char *)rentry >= buf_end)
> +			return __this_address;
> +		if ((char *)rentry + offsetof(struct xfs_attr_leaf_name_remote, name) > buf_end)
> +			return __this_address;
> +
>  		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
>  		name_end = (char *)rentry + namesize;
>  		if (rentry->namelen == 0)
> -- 
> 2.25.1
> 
> 
