Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F2730FC17
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616805; cv=none; b=NcGzgv3whTab5eyyK+AAZdXSzj3RIu3qbqEtaehrQ8DOHKGMB3ILNCuQmO8zgHYCRPu3n1W6w5UpPgZBvlcU9mC7wYdUnCD8EKLScLWzrg2o3cZ6Sb5+vjyPBC5vsv0bj3XIje+w68S9gGOLbNA59xPxVUla6mVDzWtMcdRNaxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616805; c=relaxed/simple;
	bh=LM1ZxV7VVyZZENcqyAhXNXW4pu8C4s92Qt94K1OpQQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TImV6HWRWZ1LKZ3UHMgM75dnUDw0a3qkI6pIQaPZHYV6uLaGithj/MrcJoFeJcB7VA4+n3dOK3rxQDVKhZivCP58zBwpWDg3y45D3xwDyQf8j8MwwGblB/uxp6ccMPZC0+/9yFjXBP+HUDQntkeOYwUzjVRypUOuxDLbimfdGtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LspP23wu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LspP23wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E26C4CEF1;
	Wed, 28 Jan 2026 16:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769616805;
	bh=LM1ZxV7VVyZZENcqyAhXNXW4pu8C4s92Qt94K1OpQQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LspP23wuHu62mQ7+jMbRmEUlTMRB3DaAWmOP5+aao1j57lvVUkOoJbsG8uIawq4qI
	 Fsm8j9G7rZ/tg0KKyLL394hc9ceUakklZ8zemUH0apN7p+cvDwsVkdH0tgN6aCwxQT
	 TSK8srdl1cn+FdbU3DXteZ2/5vIg5tjRCeiehYKmQxqryu4jXeYP3tvBALYJAx6AZa
	 1vrG+INl/AsqpZqNrjsHw0/QrNe9zv0lYjrIIglr9OkL1HpZiwKvGcRaZLfS4XzBcn
	 6pAewAY1shaMr7VxhyHA9SmY/w4tFpvc4YvV/jvNj3dqg39lzNp89wESRmoVaFlb0U
	 qwnTMEcFZ1K5w==
Date: Wed, 28 Jan 2026 08:13:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	hch@infradead.org
Subject: Re: [PATCH v1 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Message-ID: <20260128161324.GU5945@frogsfrogsfrogs>
References: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
 <a904c5bcb5b4fc2c7c2429646251a7f429a67d5a.1769613182.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a904c5bcb5b4fc2c7c2429646251a7f429a67d5a.1769613182.git.nirjhar.roy.lists@gmail.com>

On Wed, Jan 28, 2026 at 08:44:34PM +0530, Nirjhar Roy (IBM) wrote:
> We should ASSERT on a variable before using it, so that we
> don't end up using an illegal value.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index a12ffed12391..9fb975171bf8 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
>  			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>  			if (error)
>  				goto out;
> +			if (sum < 0) {
> +				ASSERT(sum >= 0);
> +				error = -EFSCORRUPTED;
> +				goto out;

Thanks for making this a bailout case,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +			}
>  			if (sum == 0)
>  				continue;
>  			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
> @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
>  			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
>  			if (error)
>  				goto out;
> -			ASSERT(sum > 0);
>  		}
>  	}
>  	error = 0;
> -- 
> 2.43.5
> 
> 
