Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5373747F765;
	Thu,  6 Aug 2026 21:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050671; cv=none; b=ifRumqgCAVIJ51TPKk8R85FA6tvntUGVVrOL/RXq3tGAxfsZPLEhgy8a9st/tr5kxv2JwdfAkmU46bItSUUv/TEZQKZQVia0QNxsr2PLl0OOiQ8vfHXq4Hch8mmnGFsvOMoyMg+Vli63aHGlx1qujSeHwhuNHVcukdvSGYFMeZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050671; c=relaxed/simple;
	bh=k7tYCoFr0/+2M2Blf/RfeEHaRmDRC0fnubhKAObXGEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ArG/tfrN7epeJcRMZsRGgIZpSYHWMJm1JyPddmRQCTwdWxFlvLjLJhLUAMzSfFx9ZY2JAW2qLama1C34J1uwljWoxLFTwGmn//L4Cdmymb62nP3H983uPGgGJioJC+TDzhsvkzJrUlbhBSJGOcPZddh80iBrOcRJoZ0MqWYmrhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CASMggfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CASMggfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0EF1F000E9;
	Thu,  6 Aug 2026 21:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786050669;
	bh=JUm6688QFTtc1Gc0APbJ7gvP3unb6A1gAqnUq8HURyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CASMggfBKWOaq1fVWL8xQmzgqZSZnoVD4qovIE/uIHLqsAwVIYMy8xQwIP/7NSv9M
	 wBXs56gnLsu6QeraryR3JbtM+bxoTphGaEU8X9KibGbSb5rFibyCTvyqBUgLSlAUio
	 T4yXvjHi9XRciFHD6e/GwR3RzZ2e0LC4Fh4L1LSR4i0tHf6nGJk6ZjjtZH0N8g+kIJ
	 qVcCMbPssHvMpEVxBqwCSs1wkMVqm0TlZb23T1aACO5nKuVDhhLBR33KYpVk27kopi
	 4Z1XMlSr2kcm9TB1aQdJON6XwKbW35Su2ERoZ+PciDyFvYk8oR0n2IV0gLfpM7m3p0
	 fF5XQx/11irSA==
Date: Thu, 6 Aug 2026 16:11:07 -0500
From: sergeh@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/5] xfs: replace ns_capable_noaudit
Message-ID: <anT4a9F1izXTl5TG@AUS2MQ6190Y76.amd.com>
References: <20260804094602.84766-1-cem@kernel.org>
 <20260804094602.84766-5-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804094602.84766-5-cem@kernel.org>

On Tue, Aug 04, 2026 at 11:45:54AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Now that capable_noaudit() is available, we don't need to keep
> using ns_capable_noaudit() and specifying the usernaspace every single

(typo - usernaspace)

> time.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> V4: Fix indentation on xfs_ioctl_setattr_get_trans() changes
> 
>  fs/xfs/xfs_fsmap.c | 3 +--
>  fs/xfs/xfs_ioctl.c | 2 +-
>  fs/xfs/xfs_iops.c  | 2 +-
>  3 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 7c79fbe0a74c..041bb2105ec6 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -1174,8 +1174,7 @@ xfs_getfsmap(
>  	if (!xfs_getfsmap_check_keys(&head->fmh_keys[0], &head->fmh_keys[1]))
>  		return -EINVAL;
>  
> -	use_rmap = xfs_has_rmapbt(mp) &&
> -		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
> +	use_rmap = xfs_has_rmapbt(mp) && capable_noaudit(CAP_SYS_ADMIN);
>  	head->fmh_entries = 0;
>  
>  	/* Set up our device handlers. */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 1a8af827dde1..96ca3e480cb9 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
>  		goto out_error;
>  
>  	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> -			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> +			capable_noaudit(CAP_FOWNER), &tp);
>  	if (error)
>  		goto out_error;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 7a8c77fdcf68..3f36d6e7b917 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -835,7 +835,7 @@ xfs_setattr_nonsize(
>  	}
>  
>  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> -			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> +			capable_noaudit(CAP_FOWNER), &tp);
>  	if (error)
>  		goto out_dqrele;
>  
> -- 
> 2.55.0
> 
