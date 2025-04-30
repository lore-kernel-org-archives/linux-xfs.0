Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15E51E4110;
	Wed, 30 Apr 2025 09:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746005808; cv=none; b=ATiAgztOtSZ8fugBGAut6M9DnlJ27D4z6HOgmYqWJptYDvQ0j3VVHEnxtA6HolvZRxJ2QxCjT6JupUHK04DPSp5R79H5qDLzfnv8FcMc2VY/xabM28ikmA/+GpEeBYAyGuJ6eNBJ/C16peDvhEo9oI8ndtjRMGtRtPdZEdqcHQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746005808; c=relaxed/simple;
	bh=ncOt9Y9sd3++aRr8Xund9S3QMXKgNMJZ5vGF6v/PCB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l6vPcOfOgHf34hAad8ywHAlmVuPSBYwlkNNY47b3NvuHh5KoFfjF7b7ivtsUjkaOYOjcbGFjfJZuNop6uM6t4BfE3Zqz9V+I+6rXb1ZiHhA3Grg1jXhHrm1iUB5fOHzX5l7hNuq7V+dd+2SxuH78dxG6lPmvNtDnRuRGXTD1Svg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0YO5Umu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0YO5Umu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B2C4CEE9;
	Wed, 30 Apr 2025 09:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746005807;
	bh=ncOt9Y9sd3++aRr8Xund9S3QMXKgNMJZ5vGF6v/PCB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e0YO5UmuI74/p7C492cGUJYUwOmq0oBotji2akZzR01cPH1LoO763zTX7vSU+/t+D
	 Q6CMujPhfbPgzMy1CsPqlPwvpPaA2JK0vo4b3nW2I82WyQASXQfdZdhQZFrRigynbi
	 feUGEFmel6rCoHA1MYAZZFBXrR16rSW4CkP2RRq726EZIg5UEenvTkVfVO2EBm247w
	 OYjPSn7bHMV4aCY+2wG1fe4jyOwDT2jw4yK/SIiOrslQ42mt0z98hEPCukt0aLHKsl
	 v+7Q8ongYI51cp1pjTGTcXED11277nolQmj6oIClfsPp81kjUbIUg/63O3yInt/6BL
	 Hp057+R3Sa7UQ==
Date: Wed, 30 Apr 2025 11:36:42 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: allow ro mounts if rtdev or logdev are read-only
Message-ID: <veeiqwim6lrjh7wqtnhcguh5ukxcl74lkzloqxthbh5e6rjie7@euq7b7ksqdqr>
References: <8exDmubwngY9v0_33lv5_EEDd8axqY8n_ZWu7-yEeEh_3YL_C0gcZAYXy-9vkbG2Kvwg0JtfuILWx0YfP1wTZw==@protonmail.internalid>
 <20250430083438.9426-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430083438.9426-1-hans.holmberg@wdc.com>

On Wed, Apr 30, 2025 at 08:35:34AM +0000, Hans Holmberg wrote:
> Allow read-only mounts on rtdevs and logdevs that are marked as
> read-only and make sure those mounts can't be remounted read-write.
> 
> Use the sb_open_mode helper to make sure that we don't try to open
> devices with write access enabled for read-only mounts.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

This looks good, thanks Hans!

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> 
> Changes since v1:
>  - Switched to using the sb_open_mode helper that does exactly
>    what we want.
> 
>  fs/xfs/xfs_super.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b2dd0c0bf509..5e456a6073ca 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -380,10 +380,11 @@ xfs_blkdev_get(
>  	struct file		**bdev_filep)
>  {
>  	int			error = 0;
> +	blk_mode_t		mode;
> 
> -	*bdev_filep = bdev_file_open_by_path(name,
> -		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
> -		mp->m_super, &fs_holder_ops);
> +	mode = sb_open_mode(mp->m_super->s_flags);
> +	*bdev_filep = bdev_file_open_by_path(name, mode,
> +			mp->m_super, &fs_holder_ops);
>  	if (IS_ERR(*bdev_filep)) {
>  		error = PTR_ERR(*bdev_filep);
>  		*bdev_filep = NULL;
> @@ -1969,6 +1970,20 @@ xfs_remount_rw(
>  	struct xfs_sb		*sbp = &mp->m_sb;
>  	int error;
> 
> +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp &&
> +	    bdev_read_only(mp->m_logdev_targp->bt_bdev)) {
> +		xfs_warn(mp,
> +			"ro->rw transition prohibited by read-only logdev");
> +		return -EACCES;
> +	}
> +
> +	if (mp->m_rtdev_targp &&
> +	    bdev_read_only(mp->m_rtdev_targp->bt_bdev)) {
> +		xfs_warn(mp,
> +			"ro->rw transition prohibited by read-only rtdev");
> +		return -EACCES;
> +	}
> +
>  	if (xfs_has_norecovery(mp)) {
>  		xfs_warn(mp,
>  			"ro->rw transition prohibited on norecovery mount");
> --
> 2.34.1
> 
