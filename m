Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC2926AC3
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 12:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774528337; cv=none; b=uDOxVT/tR47wqetIk6wOwNGrZwQ4e8VGa+exrBAn/b+LEj1XCx//6loZqYeXHg8Yhsy4yjr33C0qvWzPRqETYpmqVNthqsvnrf+f0U8Lw7+/6HaAeD2bvW0Bq/7DjCGZclolstM38E2GpDY4pX9ORDZ9NnHBUXMqWdtZh2atE1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774528337; c=relaxed/simple;
	bh=r4BleGRwv+uu8WK+zVS9b1C5FVRMREF15FGr4PUlMRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=umz1Hab/IuQDReDfe6PIhKRWmkhCks3uhtI3jW0Dp/Ymf4cLuwFbew/p6TVBoAQ+2POT5jW72KRJFvN2vpAOA7tZ53thXGG7N/v2/B12itaZnQlBMOMXLaH6Ybh9HmNaB4rBZp4H0+lrg323rSKJJ7bolHjE+M1lbrzJJcvgLWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOEKH12n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOEKH12n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AA6C116C6;
	Thu, 26 Mar 2026 12:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774528337;
	bh=r4BleGRwv+uu8WK+zVS9b1C5FVRMREF15FGr4PUlMRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cOEKH12nI68ZSHRTiZlU+7iZADn8XrzMDfL/MQ+Bccj6Y8mtg6XpFgUb63eF0Mi38
	 BsyKv2a6atzXNq1u6jwfH0/YzZKpHkPV0RQqlqF2Ba1eykpNRl9sQ3TFhsWIZ7K5H9
	 s+JBDn44msYJfr6lovPqks6yxtvzCTf8CIBLK0O7mP4FVwleU6EbiOcTpQfZP7Y3Jp
	 NBLriHHLR1u9IawArD7LGXPX/eQVoCylCGPBzhw1CGnjdNKN/kcKK+luzhMVVgzrcn
	 SShIJatXJMAAFcVHqWwskouSFJsOp8bzHcQSnsszvpe4XYEt9PhGdhzEl9jwbo+SVC
	 1g06uXgVKgGRg==
Date: Thu, 26 Mar 2026 13:32:13 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] xfs: don't irele after failing to iget in
 xfs_attri_recover_work
Message-ID: <acUnQLQ-fmvDaoW_@nidhogg.toxiclabs.cc>
References: <20260323210157.GM6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323210157.GM6223@frogsfrogsfrogs>

On Mon, Mar 23, 2026 at 02:01:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xlog_recovery_iget* never set @ip to a valid pointer if they return
> zero, so this irele will walk off a dangling pointer.  Fix that.

Oh, yeah, and with that fixed...

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: ae673f534a3097 ("xfs: record inode generation in xattr update log intent items")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Long Li <leo.lilong@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_attr_item.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 354472bf45f145..fe909bc44c3a79 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -653,7 +653,6 @@ xfs_attri_recover_work(
>  		break;
>  	}
>  	if (error) {
> -		xfs_irele(ip);
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
>  				sizeof(*attrp));
>  		return ERR_PTR(-EFSCORRUPTED);
> 
