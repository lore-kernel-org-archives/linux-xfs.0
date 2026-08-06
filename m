Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334284854E0;
	Thu,  6 Aug 2026 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786036974; cv=none; b=Q2Wn6Hh8QJMzxA7gvZjs6cffEzhyd4OA23i6BCkwZAYZ/J3MmLzRy4P6eipj5w6cHRHRbpJaQK3Hgf7y7PMU81lIx3zOmMMosO/MhL7prd73G3i6eJ0JjdqiuGs/p7q1ZIv84vUmMnjKwqyQz+m930gmomAanDDPB49W6lfjUpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786036974; c=relaxed/simple;
	bh=OupSiS8rdEeFUUbSoiZuH4UzrsV1SdndjGpPF+Hwi2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIE7u3Io23JAkMjBzs+PQzGNQc8trdE+LDvVb7wDWyD31wr63KlDg5ylx1ish5lXeEjqlKTsIHn4KsueJwVdqQGrrI7clCbqA+AOIw2nGIzMy6G6KelcLATpmqRE4YYPzSSigSEAETyO0uvwC+sN2dCwbnMN8o5lsVRikFVGevA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dqu+D666; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dqu+D666"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C329C1F000E9;
	Thu,  6 Aug 2026 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786036969;
	bh=xAXgtQKqxTESAHA1i+eQyq2LIn+PRu1BkngXMlCIG6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dqu+D666rdK+lSHPWAhm/hkGE2wN6H0zntbTQYqaxa5y3lX422aLubf1NM9pamEZu
	 lhMAUGoXXwc6h9Ul1V8IOFMswugoP2PQIKfo+hcgORIXfgwc44AJM5E77BFRKt8i8d
	 i3USh/ATUIeifli/nPRg3nFbkcMmeym0hnKUT5sCOBWrK/fXKl/IEiXwTG8mCg2S+o
	 Fbu00q+LAI9a8ZRbE8hp8GyeXIxqh+hQaQB4g+GG6Pt2BZe4knsDY0Zogkr/VSMgMq
	 0NmA5Qcck080DaNfRKlrQu6ANhw0KvnhyzpGiwZNs13ubc8LVAuiGMaSJuvD+nXm+O
	 DLv+izOslgSvg==
Date: Thu, 6 Aug 2026 12:22:29 -0500
From: sergeh@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: Re: [PATCH v4 1/5] xfs: fix capability check in xfs
Message-ID: <anTC1e_zAhKedcpH@AUS2MQ6190Y76.amd.com>
References: <20260804094602.84766-1-cem@kernel.org>
 <20260804094602.84766-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804094602.84766-2-cem@kernel.org>

On Tue, Aug 04, 2026 at 11:45:51AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> An user reported a bug where he managed to evade group's quota
> by changing a file's gid to a different group id the same user
> belonged to, even though quotas were enforced on both gids and the
> file's size was big enough to exceed the quota's hardlimit.
> 
> Commit eba0549bc7d1 replaced a capable() call by a
> has_capability_noaudit() to prevent unnecessary selinux audit messages.
> Turns out that both calls have slightly different semantics even though
> their documentation seems similar. Where in a nutshell:
> 
> capable() - Tests the task's effective credentials
> has_ns_capability_noaudit() - Tests the task's real credentials
> 
> This most of the time has no practical difference but in some cases like
> changing attrs (specifically group id in this case) through a NFS client
> this will allow the quota code to use XFS_QMOPT_FORCE_RES, effectively
> bypassing quota accounting checks.
> 
> Using instead ns_capable_noaudit() should fix this issue and prevent
> selinux audit messages.

Hi,

this makes perfect sense, but since you say "should fix this issue",
did you have a chance to set up a reproducer, and verify?

> This also fix the remaining calls to has_capability_noaudit()
> 
> Fixes: eba0549bc7d1 ("xfs: don't generate selinux audit messages for capability testing")
> Cc: <stable@vger.kernel.org> # v5.18
> Reported-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Serge Hallyn <sergeh@kernel.org>

thanks,
-serge

> ---
>  fs/xfs/xfs_fsmap.c | 2 +-
>  fs/xfs/xfs_ioctl.c | 2 +-
>  fs/xfs/xfs_iops.c  | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index b6a3bc9f143c..7c79fbe0a74c 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -1175,7 +1175,7 @@ xfs_getfsmap(
>  		return -EINVAL;
>  
>  	use_rmap = xfs_has_rmapbt(mp) &&
> -		   has_capability_noaudit(current, CAP_SYS_ADMIN);
> +		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
>  	head->fmh_entries = 0;
>  
>  	/* Set up our device handlers. */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 1b53701bebea..1a8af827dde1 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
>  		goto out_error;
>  
>  	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> -			has_capability_noaudit(current, CAP_FOWNER), &tp);
> +			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
>  	if (error)
>  		goto out_error;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 6339f4956ecb..7a8c77fdcf68 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -835,7 +835,7 @@ xfs_setattr_nonsize(
>  	}
>  
>  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> -			has_capability_noaudit(current, CAP_FOWNER), &tp);
> +			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
>  	if (error)
>  		goto out_dqrele;
>  
> -- 
> 2.55.0
> 
