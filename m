Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF49374E54
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 22:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773700762; cv=none; b=AzU5qg8AmK7aswd1+Tx09n3GsGTs/JNU+TdsV5IQG1pXrsZ5/3Nkq81fDkwoJ4oCVIwvqFPAawdFcuayVSixsSZLhZxyA9C/dBa7tJ4YjuVNDnBCMHO8rDORWHUlTUdNcE2mW+K5mhlDwbJVpfSrEnSNDlPHZkytPJiYaSNUFCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773700762; c=relaxed/simple;
	bh=9zXe0+fPHXhLZu2BdXYuYB+qmevM7NjoFc4Q2TKSex8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m5DZgGUwhmtFqkmnZ/oarR5U4Cj6Su3jXW4ODEcl7pSvgJX8SBbxaCwHWN7vfomPHLl38AhYGEG93JtzULy3qiGVYqx6ycNjbN6DxAAFfrpggr0LMWN61+RIrA4h3E7PZfvgMx2law0guhQBsm4dl3tz7Y0fucjBCdmwqUAV0KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJYANP17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJYANP17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC118C19421;
	Mon, 16 Mar 2026 22:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773700761;
	bh=9zXe0+fPHXhLZu2BdXYuYB+qmevM7NjoFc4Q2TKSex8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BJYANP17y39MaEOU5iuHVRw8Fi//xNlDqbfQG3u+7wBCWhP2OQKXXNtYqQg8z1bUN
	 b7bqmuWsUtkVxU/xrQBwRXAydg29QF+5ySQLeSlTddZ5nefHTFzAHHRyQGpfNCMS0P
	 1r240Objuak0vNPFzmOoMLPBf+0DgzoKmaYpCZvdyNKrJbgL/z+RcGv3hYmsl+MsQ0
	 bovy/sIS5mVyWGjtUzMiDabd+kH81y/EEN8ApoBow7nPjRJbOeJSd8wAB2bM0Pu0wD
	 F7W4U+N4DijKwg1/thL7HxuZ9FWSWFrAzimXoBn/7sEGJqRg1TdyaYkRSbbS8qc/rg
	 sE0hLr364y9Qg==
Date: Mon, 16 Mar 2026 15:39:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 2/3] xfs: fix ri_total validation in
 xlog_recover_attri_commit_pass2
Message-ID: <20260316223921.GD1770774@frogsfrogsfrogs>
References: <20260316012416.2413909-1-leo.lilong@huawei.com>
 <20260316012416.2413909-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316012416.2413909-3-leo.lilong@huawei.com>

On Mon, Mar 16, 2026 at 09:24:15AM +0800, Long Li wrote:
> The ri_total checks for SET/REPLACE operations are hardcoded to 3,
> but xfs_attri_item_size() only emits a value iovec when value_len > 0,
> so ri_total is 2 when value_len == 0.

When can you have a set/replace operation with no value?  Is this the
weird case where you're trying to set an attr to zero-length buffer?

--D

> For PPTR_SET/PPTR_REMOVE/PPTR_REPLACE, value_len is validated by
> xfs_attri_validate() to be exactly sizeof(struct xfs_parent_rec) and
> is never zero, so their hardcoded checks remain correct.
> 
> Fix this by deriving the expected count dynamically as "2 + !!value_len"
> for SET/REPLACE operations.
> 
> Cc: <stable@vger.kernel.org> # v6.9
> Fixes: ad206ae50eca ("xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_attr_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 3d3ac8dad519..21da995ba4e7 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -1049,7 +1049,7 @@ xlog_recover_attri_commit_pass2(
>  	case XFS_ATTRI_OP_FLAGS_SET:
>  	case XFS_ATTRI_OP_FLAGS_REPLACE:
>  		/* Log item, attr name, attr value */
> -		if (item->ri_total != 3) {
> +		if (item->ri_total != 2 + !!attri_formatp->alfi_value_len) {
>  			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  					     attri_formatp, len);
>  			return -EFSCORRUPTED;
> -- 
> 2.39.2
> 
> 
