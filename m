Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D539F15B99E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738880839; cv=none; b=qe6ZZQDIgIiaTw3i1Ve4U9CLh6c+00v8T8a1i8PHAeYqKHNT+xAdsJQw461DQN4QNArfEsmw33Ijtggz6NNz/yLh/ksp1m7sfEoTqZRq1cvuYN0BmLJH0JiOaeEwPAOu2tsR3bJYy3OkIa51xsCVlxcrD9OWbyhN2NN/dbHGD74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738880839; c=relaxed/simple;
	bh=2aV2HxT8COqVY9dJC9eADf1PsQ6HCiH7mG9uzBUH7mQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G04cB2G7QOGTagIGb1wwCvds4EunOs/8mAcN7CWoaFPmw5xyypK89z+/RlE8ZKuCq3Fg3L0K7lhX01GTWFc4F0OBsW7/oOMC3rPRVaJc+rBl9UqPxtApZ6ecfn+AJgFqkn9/zrsAHspY+DBoFf6SHV9v+KECuOI+ofAOMyn/Eug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFAdWWQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFAdWWQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880A9C4CEDD;
	Thu,  6 Feb 2025 22:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738880837;
	bh=2aV2HxT8COqVY9dJC9eADf1PsQ6HCiH7mG9uzBUH7mQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YFAdWWQJLdnCHhI8yNQT1J/0EZBSponmNaoVfb0DpakKfyrs37CXwpo17RKJ3mMAm
	 JsUURw6Zfv+lGQhfk3l7AR3cNi+8VjpX+TXbXE/SJ/bhdWUMCQYDcvLKr1MZMXwrqh
	 H6tTRAwZMbfkqEKO9cSonRXVH9zSaBK9Mqm0JZ5KJiR/zp5rDVtxa44FRXCiKEWtSc
	 si7NAayLHHoyJP38rFEXY0hTZZR6Qm4ddTQRaEjcdru7VIMyDBCfaV2GiIOvVKop8g
	 WrCHjoFpOzQtWbo+TlmWcBLiWK+te4yEux3M6ByERA9iG5251na1EfcvGU/+W/lPoh
	 BpdmNygJBSMOQ==
Date: Thu, 6 Feb 2025 14:27:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: da.gomez@kernel.org
Cc: linux-xfs@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <20250206222716.GB21808@frogsfrogsfrogs>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>

On Thu, Feb 06, 2025 at 07:00:55PM +0000, da.gomez@kernel.org wrote:
> From: Daniel Gomez <da.gomez@samsung.com>
> 
> In patch [1] ("bdev: use bdev_io_min() for statx block size"), block
> devices will now report their preferred minimum I/O size for optimal
> performance in the stx_blksize field of the statx data structure. This
> change updates the current default 4 KiB block size for all devices
> reporting a minimum I/O larger than 4 KiB, opting instead to query for
> its advertised minimum I/O value in the statx data struct.
> 
> [1]:
> https://lore.kernel.org/all/20250204231209.429356-9-mcgrof@kernel.org/

This isn't even upstream yet...

> Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> ---
> Set MIN-IO from statx as the default filesystem fundamental block size.
> This ensures that, for devices reporting values within the supported
> XFS block size range, we do not incur in RMW. If the MIN-IO reported
> value is lower than the current default of 4 KiB, then 4 KiB will be
> used instead.

I don't think this is a good idea -- assuming you mean the same MIN-IO
as what lsblk puts out:

NAME                     MIN-IO
sda                         512
├─sda1                      512
├─sda2                      512
│ └─node0.boot              512
├─sda3                      512
│ └─node0.swap              512
└─sda4                      512
  └─node0.lvm               512
    └─node0-root            512
sdb                        4096
└─sdb1                     4096
nvme1n1                     512
└─md0                    524288
  └─node0.raid           524288
    └─node0_raid-storage 524288
nvme0n1                     512
└─md0                    524288
  └─node0.raid           524288
    └─node0_raid-storage 524288
nvme2n1                     512
└─md0                    524288
  └─node0.raid           524288
    └─node0_raid-storage 524288
nvme3n1                     512
└─md0                    524288
  └─node0.raid           524288
    └─node0_raid-storage 524288

Now you've decreased the default blocksize to 512 on sda, and md0 gets
an impossible 512k blocksize.  Also, disrupting the default 4k blocksize
will introduce portability problems with distros that aren't yet
shipping 6.12.

--D

> ---
>  mkfs/xfs_mkfs.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index bbd0dbb6c80ab63ebf9edbe0a9a304149770f89d..e17389622682bc23f9b20c207db7e22181e2fe6f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2178,6 +2178,26 @@ _("block size %d cannot be smaller than sector size %d\n"),
>  	}
>  }
>  
> +void
> +get_dev_blocksize(
> +	struct cli_params	*cli,
> +	struct mkfs_default_params *dft)
> +{
> +	struct statx stx;
> +	int ret;
> +
> +	if (!cli->xi->data.name)
> +		return;
> +
> +	ret = statx(AT_FDCWD, cli->xi->data.name,
> +		    AT_STATX_DONT_SYNC | AT_NO_AUTOMOUNT,
> +		    STATX_DIOALIGN | STATX_TYPE | STATX_MODE | STATX_INO, &stx);
> +	if (!ret)
> +		dft->blocksize =
> +			min(max(1 << XFS_DFL_BLOCKSIZE_LOG, stx.stx_blksize),
> +			    XFS_MAX_BLOCKSIZE);
> +}
> +
>  static void
>  validate_blocksize(
>  	struct mkfs_params	*cfg,
> @@ -2189,6 +2209,7 @@ validate_blocksize(
>  	 * For RAID4/5/6 we want to align sector size and block size,
>  	 * so we need to start with the device geometry extraction too.
>  	 */
> +	get_dev_blocksize(cli, dft);
>  	if (!cli->blocksize)
>  		cfg->blocksize = dft->blocksize;
>  	else
> 
> ---
> base-commit: 90d6da68ee54e6d4ef99eca4a82cac6036a34b00
> change-id: 20250206-min-io-default-blocksize-13334f54899e
> 
> Best regards,
> -- 
> Daniel Gomez <da.gomez@samsung.com>
> 
> 
