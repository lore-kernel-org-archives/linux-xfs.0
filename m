Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CCE1DE898
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 19:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193141; cv=none; b=k+r4bJqZV+Ep5ypJXNrKRj/mUWzKK2xYkoV/TdpO2FNtIrn0BJ637QRV55yZ1xms06xienOLS1bPBIlf3j69d9tVGLsAepbfRC81wXcxeLYHvPcg9p1MJDmVJQIVJVTgpNNb1V6aP6ehha31kZgd27f1H2aFqTP1wmWN1YuD1CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193141; c=relaxed/simple;
	bh=n/x0Iz0U1XgBp/BCCgoBAGBCpk7ygigw5XI8MJ6KCTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZsRPaDI0WzRlylaFbxeBG8fbIK6shCOybV9Uhz26X+e9FNK/i31pCJ3iC5G/U392rVG9+78ElaPrPAtJ8cVe3/8bYj6LZoTlKzCJU/JDIFqJjpYhFv7MB9nWD/R1xmKgI5RITY5R+sQfw0AqjdJeKw7Wd6y4WKKLOmS3lyMg7Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/fTsMvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/fTsMvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC3DC4CED2;
	Mon,  6 Jan 2025 19:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736193140;
	bh=n/x0Iz0U1XgBp/BCCgoBAGBCpk7ygigw5XI8MJ6KCTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P/fTsMvMBA6YBSVuwQE4emUpxNuB8p2CllV2Sfbky1nVScOt23yav+Zrjn9N+vpYA
	 MotC12eI8gARrzc/HZlBEUWHZLkDZnpak3EGdNMisl8AOo3cAs57eK+X5XUOsLuiUj
	 pz9wCCZzcM4bh19TD6cyxDmorJHriPOcX72jCOiI+0jQTvc666wBypttuDAF99w2DW
	 8xQMEAUhXZWQh95T6i+zlGmscegAPKnqP8/8fYVADwNON3QBrHuqlOs/8yrC2T0MYd
	 YyoIBZCh4VAME72S2SbA7qFsBjj7KKVOx+erCvwCDN+ULbACm1jo1ICnF9XM/66nrh
	 cEv64XQL7netw==
Date: Mon, 6 Jan 2025 11:52:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: correct the sb_rgcount when the disk not
 support rt volume
Message-ID: <20250106195220.GK6174@frogsfrogsfrogs>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241231023423.656128-2-leo.lilong@huawei.com>

On Tue, Dec 31, 2024 at 10:34:22AM +0800, Long Li wrote:
> When mounting an xfs disk that incompat with metadir and has no realtime
> subvolume, if CONFIG_XFS_RT is not enabled in the kernel, the mount will
> fail. During superblock log recovery, since mp->m_sb.sb_rgcount is greater
> than 0, updating the last rtag in-core is required, however, without
> CONFIG_XFS_RT enabled, xfs_update_last_rtgroup_size() always returns
> -EOPNOTSUPP, leading to mount failure.

Didn't we fix the xfs_update_last_rtgroup_size stub to return 0?

--D

> Initializing sb_rgcount as 1 is incorrect in this scenario. If no
> realtime subvolume exists, the value of sb_rgcount should be set
> to zero. Fix it by initializing sb_rgcount based on the actual number
> of realtime blocks.
> 
> Fixes: 87fe4c34a383 ("xfs: create incore realtime group structures")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 3b5623611eba..1ea28f04b75a 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -830,7 +830,7 @@ __xfs_sb_from_disk(
>  		to->sb_rsumino = NULLFSINO;
>  	} else {
>  		to->sb_metadirino = NULLFSINO;
> -		to->sb_rgcount = 1;
> +		to->sb_rgcount = to->sb_rblocks > 0 ? 1 : 0;
>  		to->sb_rgextents = 0;
>  	}
>  }
> -- 
> 2.39.2
> 
> 
