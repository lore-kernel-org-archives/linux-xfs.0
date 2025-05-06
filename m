Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8532927FD6F;
	Tue,  6 May 2025 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746547692; cv=none; b=BOKJqEtRHVgJ49iVY8Efje9/gLCRQmGZ6oKbKu7aB+3nTlrpWgIfttdkNUFwKH2qR2vBiwszfaxvvDe8IcJc40v5dLQu0GXSgxgJNlN3jv2Yi8U6TKTYv72xidE2HgT0zczdMD6bh3zWXiHWAGuUDGhBRqCyIPXho3qWOMebbS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746547692; c=relaxed/simple;
	bh=Mh7dLpqJK4CFjNzesvWJoUTNq1lFiN3QQ70XOGszy+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ePkSjfOfCDzc85NQ8tAfeGR9iELSlKS4Dl1klSkzAlz5vR5g5rPSrsgSMLucBP8h26Y81ufJXA3GWFmqaNmBcnBhhIotGoUdPJ4/i3UrojxP8LsX2njK6OZjd2JbtP+lQj3uHN1BmIIQrqLIQrJehrGmbik1tPJl5DydqQZeUwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOnp7SeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOnp7SeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3C8C4CEE4;
	Tue,  6 May 2025 16:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746547692;
	bh=Mh7dLpqJK4CFjNzesvWJoUTNq1lFiN3QQ70XOGszy+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UOnp7SeLNSLSPwte4ptEik/pOxVtlUottoXn3f5Dv5bAMzLisH5yXg0NVCGzG6WRi
	 Iqnec2X0z0jtMdQAD7RARzpjQqANTh4lM4WB8hjQD58aH21F+J2SIqX2cF9D/MP6uY
	 gU3Rq58YvftFdDwvv16agRlgJlnfoeNZ6Sc54KNP+V6ljUX4/ROqO+oyZj+fcQQMZK
	 dO2QgvC5VoNhWF0gKOLj5dePPYaRw4X7WCO6WYT/vdUrd5IGZ5udxZLXOoLkxS4Ohy
	 rIfijpZxWwEp5jK21aMx+JGsP0M/Dhe+xvBRMJSKRoD60/+Dd8kD9zg3wWxV6e61Fl
	 ANyiT9Lf4+lSg==
Date: Tue, 6 May 2025 09:08:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, wozizhi@huawei.com,
	yangerkun@huawei.com, leo.lilong@huawei.com
Subject: Re: [PATCH] xfs: Remove deprecated xfs_bufd sysctl parameters
Message-ID: <20250506160811.GE25675@frogsfrogsfrogs>
References: <20250506011540.285147-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506011540.285147-1-wozizhi@huaweicloud.com>

On Tue, May 06, 2025 at 09:15:40AM +0800, Zizhi Wo wrote:
> From: Zizhi Wo <wozizhi@huawei.com>
> 
> Commit 64af7a6ea5a4 ("xfs: remove deprecated sysctls") removed the
> deprecated xfsbufd-related sysctl interface, but forgot to delete the
> corresponding parameters: "xfs_buf_timer" and "xfs_buf_age".
> 
> This patch removes those parameters and makes no other changes.
> 
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>

Heh, yep, those aren't in use anywhere.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_globals.c | 2 --
>  fs/xfs/xfs_sysctl.h  | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index f18fec0adf66..f6f628c01feb 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -23,8 +23,6 @@ xfs_param_t xfs_params = {
>  	.inherit_sync	= {	0,		1,		1	},
>  	.inherit_nodump	= {	0,		1,		1	},
>  	.inherit_noatim = {	0,		1,		1	},
> -	.xfs_buf_timer	= {	100/2,		1*100,		30*100	},
> -	.xfs_buf_age	= {	1*100,		15*100,		7200*100},
>  	.inherit_nosym	= {	0,		0,		1	},
>  	.rotorstep	= {	1,		1,		255	},
>  	.inherit_nodfrg	= {	0,		1,		1	},
> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> index 276696a07040..51646f066c4f 100644
> --- a/fs/xfs/xfs_sysctl.h
> +++ b/fs/xfs/xfs_sysctl.h
> @@ -29,8 +29,6 @@ typedef struct xfs_param {
>  	xfs_sysctl_val_t inherit_sync;	/* Inherit the "sync" inode flag. */
>  	xfs_sysctl_val_t inherit_nodump;/* Inherit the "nodump" inode flag. */
>  	xfs_sysctl_val_t inherit_noatim;/* Inherit the "noatime" inode flag. */
> -	xfs_sysctl_val_t xfs_buf_timer;	/* Interval between xfsbufd wakeups. */
> -	xfs_sysctl_val_t xfs_buf_age;	/* Metadata buffer age before flush. */
>  	xfs_sysctl_val_t inherit_nosym;	/* Inherit the "nosymlinks" flag. */
>  	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
>  	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
> -- 
> 2.39.2
> 
> 
