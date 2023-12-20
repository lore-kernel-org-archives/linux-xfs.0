Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8216C2FE
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 02:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rhy2gQQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F90C433C9;
	Wed, 20 Dec 2023 02:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703040194;
	bh=Mhyo7qjD71WFVNVzrYWeposkXUMnMJEePmra9LAazuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rhy2gQQBhSEkKYTnPW/uvkHt4/V3KPmlP6na3q7nYVBi8Kp6wVJtVhTRo5r1WDckP
	 xBRgcCNGTNJoBDBYKawmoUEDc80Cxd12KhB3XjVVVArFSdyXT8vpLyOInrb6N1xYOw
	 t4SbMcGcG6tPF4/1ckE8YROwckavsg5QLNtNK8Ar7iXvE7v8aB8fdZAHtGY0kdWc/O
	 SrunmVU+tyUiIptIReYDlsDBzunlL7zkG6LWQvFX7J/aJ1SS8tc8ezV/10YW0YMLuG
	 G3UsB7b0J4JEr8MAvT/1aGz7TdX9OzNKLrNZEcfhd7N7f5TOQaI6cbgl2ubq3l3A7t
	 ubZS97oCvba/Q==
Date: Tue, 19 Dec 2023 18:43:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wu Guanghao <wuguanghao3@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, shikemeng@huawei.com,
	louhongxiang@huawei.com
Subject: Re: [PATCH]: mkfs.xfs: correct the error prompt in usage()
Message-ID: <20231220024313.GN361584@frogsfrogsfrogs>
References: <2a51a8b8-a993-7b15-d86f-8244d1bfce44@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a51a8b8-a993-7b15-d86f-8244d1bfce44@huawei.com>

On Wed, Dec 20, 2023 at 09:59:04AM +0800, Wu Guanghao wrote:
> According to the man page description, su=value and sunit=value are both
> used to specify the unit for a RAID device/logical volume. And swidth and
> sw are both used to specify the stripe width.
> 
> So in the prompt we need to associate su with sunit and sw with swidth.
> 
> Signed-by-off: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index dd3360dc..c667b904 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -993,7 +993,7 @@ usage( void )
>  /* metadata */         [-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
>                             inobtcount=0|1,bigtime=0|1]\n\
>  /* data subvol */      [-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
> -                           (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
> +                           (sunit=value|su=num,swidth=value|sw=num,noalign),\n\

Doesn't mkfs require sunit/swidth or su/sw to be used together, but not
intermixed?

--D

>                             sectsize=num\n\
>  /* force overwrite */  [-f]\n\
>  /* inode size */       [-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
> --
> 2.27.0
> 
