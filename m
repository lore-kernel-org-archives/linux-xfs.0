Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B329BD91;
	Thu, 10 Sep 2026 14:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789052242; cv=none; b=kV4SaFa5XuKKyjBgHrMRsiGkQm3kN/WWRKsg6xP9QJB6/UeGULRpGV0k1n6U3xIvu/GP/XOMufy4HFpfFhSu+q4/bN/FrycC/xfI7HKq0v5xRfOUyxHVPmyls4UvNYEhpoQCDZDjSHz5XO1CPZrmAo1XU2RyyoULn02guSwQdKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789052242; c=relaxed/simple;
	bh=OkKB7XcMcj8Cr6VWih3v7a8i/XzJXDsUqlIeBneOloo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OIJcHc7y3ohBfv1m3rDGgBsnwVe59Fc4wgeoYi9XOFgAE0ZwJShs3nke70U8Epkx6uDd1t6OhraS64Q0mv41CtOLx/PHbO8tkr/ikdVDwKEfaEpkwBPC2INsOuaR/HObe5bsyEwF3BCNWIV7CJobYNU+YSGRsQx/o4tl+Wc2xqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VpcXBbme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VpcXBbme"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 107801F000FF;
	Thu, 10 Sep 2026 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789052241;
	bh=BdLegtGVaf+JW8AlcE9C4kdkOOmDrH5Fv6ZDMyOYrJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VpcXBbme7WyttsiE0tm3Mim1bHQD91VQrgz6p7Ao9ETExt2+Tw8gORcg83TypQHig
	 dB3hBpkdgdpaFibF5THJBWk7+Z8oYMn9EbN56e27pRVSSo0sX+AtZNdPVF2lues2Di
	 rmqcsP/tfooSFopUlw325VWHaK1vD6NXaojmgHF+AZVJMx2eNz/hOQ0Svbk6cUnIVZ
	 bOrbiRqZUQrBXLkKi7KuQ5NubIl+7I2+3WFN3W3sffcSzJNIcZiFMnGBgGKyOzBu2u
	 Y9mHqZ3amizfzwlQ/WbvdtEpYe+W3fLW5XUPbzW01BywXoHWTK76g3kHGU7M6g6wYt
	 8BePW1EFPz9MA==
Date: Thu, 10 Sep 2026 07:57:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shigeru Yoshida <syoshida@redhat.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix double mutex_lock() call in
 xfs_ioc_health_monitor()
Message-ID: <20260910145720.GB6238@frogsfrogsfrogs>
References: <20260910132956.538828-1-syoshida@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910132956.538828-1-syoshida@redhat.com>

On Thu, Sep 10, 2026 at 10:29:55PM +0900, Shigeru Yoshida wrote:
> Commit 4870da4f49ae ("xfs: take hm->lock in xfs_ioc_health_monitor()
> before insert") intended to protect the __xfs_healthmon_insert() call
> with hm->lock, but the second mutex operation was accidentally left as
> mutex_lock() instead of mutex_unlock(), causing self-deadlock. Change
> the second call to mutex_unlock() as originally intended.
> 
> Fixes: 4870da4f49ae ("xfs: take hm->lock in xfs_ioc_health_monitor() before insert")
> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>

The original patch I reviewed unlocked hm->lock correctly, not sure how
it got corrupted by the tooling such that we need this.  I think cem
fixed it already(?) but in case anyone needs it,

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_healthmon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> index 6dc3f69d6798..c3749675ef19 100644
> --- a/fs/xfs/xfs_healthmon.c
> +++ b/fs/xfs/xfs_healthmon.c
> @@ -1225,7 +1225,7 @@ xfs_ioc_health_monitor(
>  	running_event->domain = XFS_HEALTHMON_MOUNT;
>  	mutex_lock(&hm->lock);
>  	__xfs_healthmon_insert(hm, INSERT_HEAD, running_event);
> -	mutex_lock(&hm->lock);
> +	mutex_unlock(&hm->lock);
>  
>  	/*
>  	 * Preallocate the unmount event so that we can't fail to notify the
> -- 
> 2.55.0
> 
> 
