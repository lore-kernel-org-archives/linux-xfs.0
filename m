Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C85368962;
	Thu, 19 Mar 2026 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773940527; cv=none; b=XS/fnVy2AsnjI4YFakLlI0MWMjgJU2vMTUCtJGhHSPP0S3XLiaFMbK185ks6DCOZ+1McCVe1s0IHxDCzVla4iEjPj9KZV0iay9+j6fyAh6SHqhgvAtNpfDFbHFygL5uSPNfiehp/gFlS13LCP613BYIHWaOQlKwDBVaDgQIop7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773940527; c=relaxed/simple;
	bh=y3tfLHt4FkM8Rc8A9/9O0J5W/OSgTH4F1qTyhxe9Kvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJZnvZdZAKt/LftZ2Kolaad7HpmmCkdUUV02X9KJ9rre8JiAz02w85TKU6wvp7U3sRdMz8p81d1kxp79m7qKmAGkcCa6D7ZShG2w+x+GQTJGvjKMP6+mSsqN+cC3mk8VEVRZabEPgPNDGJkQfA65pJjwIdUSj5MOv8rY2+CkRWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hoQi3FLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hoQi3FLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95627C19424;
	Thu, 19 Mar 2026 17:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773940526;
	bh=y3tfLHt4FkM8Rc8A9/9O0J5W/OSgTH4F1qTyhxe9Kvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hoQi3FLCyoVzcUPQ/3B9RE7UEMgK+uanJHlGkehCgs+vrPA+D/M6rnwyw8RbquWbh
	 /ZwOrLkRz2GI21qRz99n4mJQMJdLx1ld8VgvHRpjECV7u4f+Yzm8JLQWHmnPApOn2r
	 GiSF5C1KeBNYKLh+R+fe8ciJl0wcgbyhvHAKe38MTWxLqzIC2yGlromOrEJfes9xXM
	 d9tG/YLERYZCLJ+HS7WhZPgUFvmion/2wwOCnYcPuU4Gg6BrDxFswVBDKvs/A7HsRc
	 krMBW6/8hXO5HsIH7D8CJPs1EM9fo+vOwDx/I/ggz++5K4JKjJpuAHXsV7jg3og3K0
	 exS45bQSrpDdg==
Date: Thu, 19 Mar 2026 10:15:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 01/25] fsverity: report validation errors through
 fserror to fsnotify
Message-ID: <20260319171526.GU1770774@frogsfrogsfrogs>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
 <20260319170231.1455553-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-2-aalbersh@kernel.org>

On Thu, Mar 19, 2026 at 06:01:48PM +0100, Andrey Albershteyn wrote:
> Reported verification errors to fsnotify through recently added fserror
> interface.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/verity/verify.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/verity/verify.c b/fs/verity/verify.c
> index 4004a1d42875..4ea494da694f 100644
> --- a/fs/verity/verify.c
> +++ b/fs/verity/verify.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/bio.h>
>  #include <linux/export.h>
> +#include <linux/fserror.h>
>  
>  #define FS_VERITY_MAX_PENDING_BLOCKS 2
>  
> @@ -203,6 +204,8 @@ static bool verify_data_block(struct fsverity_info *vi,
>  		 * to verify that any data blocks fully past EOF are all zeroes.
>  		 */
>  		if (memchr_inv(dblock->data, 0, params->block_size)) {
> +			fserror_report_data_lost(inode, data_pos,
> +						 params->block_size, GFP_NOFS);
>  			fsverity_err(inode,
>  				     "FILE CORRUPTED!  Data past EOF is not zeroed");
>  			return false;
> @@ -312,6 +315,7 @@ static bool verify_data_block(struct fsverity_info *vi,
>  		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
>  		params->hash_alg->name, hsize,
>  		level == 0 ? dblock->real_hash : real_hash);
> +	fserror_report_data_lost(inode, data_pos, params->block_size, GFP_NOFS);
>  error:
>  	for (; level > 0; level--) {
>  		kunmap_local(hblocks[level - 1].addr);
> -- 
> 2.51.2
> 
> 
