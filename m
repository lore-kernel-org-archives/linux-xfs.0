Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8824A32;
	Wed, 10 Jun 2026 05:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781067633; cv=none; b=rAnBRNxBptUoPZaQ71ZA1l4tB4Yhrlj0018o5D0pvJF9yVb69eYEAouEULJdr9vKSDOg5Nbr2Nzm0Kf7nc9C4b1XR3eOwpvu9DBJc0ANwxtxqLuLoUvTD/OkPDQAIC4GpLIwFlHq8mEGpZkNm+zRjKuo9ZvZNX63yxuoiK8MBKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781067633; c=relaxed/simple;
	bh=KV3Gn+8cf7Pp+/wunO8+5tk/xzn9Na27+sBpnfgr03s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mh6DvzlxewueVMtSwGTIr8yvFiBmQy+j6y9Iihs9kMF4X5OunpGQ/jUJDzCvTf6NEMp4w/S9N/3XG7WQF0cXAFnyR+P+PKUZiFcDK2lD3Ac0mxUGiwFyPiz4soSTpEM0h9Ij6vRisJMWN4xzD1Vn19S22tDoBaR4b3jZsC/eZq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVDe2QeV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVDe2QeV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6CA031F00893;
	Wed, 10 Jun 2026 05:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781067632;
	bh=lUAvqflCpaW5B6Ldgvps0KJCZIBpBLVyYKw02shUYxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dVDe2QeVb+X2CsahXRI5DQjnvRyBjzTy4RId4J5RSE2QO2ZCl45Jw6sCN4+SAp1Th
	 q2eW4E/69XzZlIVfwLADu1Mek5CTDXfkeSpAtm58A6OHdyNnwg9FN1z+ZM4qGCclCO
	 IGSAc3uRVA/43dC5fDqfdaMXal+KSzy7xhQHeuVg67YCZV6WKLdBqUa7a/Dj4DgrWa
	 vjPS6WQC/rhrVfU1PKv4Dy0uwSw1n7a2A1CldEHF74JLw4ZwytmPdMV1UNdvb/7jDw
	 yQyvFF66XX1pfrkRQC6Qyj/DSqGSJBzcGMshPxLmnQS31dqE6Ph1gSVffGvxIIzm6I
	 VbIa+FUX1AW7w==
Date: Tue, 9 Jun 2026 22:00:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: fix inode ref leak in attr intent recovery
Message-ID: <20260610050032.GD6078@frogsfrogsfrogs>
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
 <20260610022028.79846-1-gaoyingjie@uniontech.com>
 <20260610022028.79846-2-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610022028.79846-2-gaoyingjie@uniontech.com>

On Wed, Jun 10, 2026 at 10:20:27AM +0800, Yingjie Gao wrote:
> xfs_attri_recover_work() grabs the target inode, attaches it to the
> reconstructed attr work item, and adds that work item to the defer
> pending list.
> 
> If xfs_attr_recover_work() fails to allocate the recovery transaction,
> it returns immediately without dropping the inode reference.  The later
> cancel path only frees the attr work item state, so the inode reference
> leaks.
> 
> Send the failure through the existing cleanup path so the inode
> reference is dropped before the function returns the error.
> 
> Fixes: e70fb328d527 ("xfs: recreate work items when recovering intent items")
> Cc: <stable@vger.kernel.org> # v6.8
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_attr_item.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index deab14f31b38..841838bc1d0f 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -774,7 +774,7 @@ xfs_attr_recover_work(
>  	resv = xlog_recover_resv(&resv);
>  	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
>  	if (error)
> -		return error;
> +		goto out_rele;
>  	args->trans = tp;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> @@ -791,6 +791,7 @@ xfs_attr_recover_work(
>  	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +out_rele:
>  	xfs_irele(ip);
>  	return error;
>  out_cancel:
> -- 
> 2.20.1
> 
> 
