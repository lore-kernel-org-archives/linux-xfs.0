Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E212BD11;
	Tue, 10 Mar 2026 00:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773103588; cv=none; b=sKXZ99XaDpG+XPvY5zINMAUqLfTr6yhKZ6gckXk9jjhnZI43YGc8UrnyMe55YapWQajZml4Pxys0oeIYlEy+PdmVR+BbCAHceDuVGDr7sGqhcAH/EBIBZXF11/Fp78LlZqYfMrKZYK8LS8Lqr2LOpsms5qr05aW5kOCiMwxo+aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773103588; c=relaxed/simple;
	bh=ZaMPY2YfyWjkT+Gcpp9C9C2PHVwVCnyFNVGI6g8OFNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNtKXq1NhnntoN+BLVnApECH8703emMLPNCpL3GFMTtNgK/B+/BLuZTRBE2nctxlWREgwLo5/bLrwNxOlcSxNgNsT2FFJoANTq8AVAp35fJnmlYpsaiAKspuEvC1bODEEJl6AAknmSqT23pJEJYzlFWwfXgIv2gPblv8r9/ca5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/1xWpRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/1xWpRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E013FC4CEF7;
	Tue, 10 Mar 2026 00:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773103587;
	bh=ZaMPY2YfyWjkT+Gcpp9C9C2PHVwVCnyFNVGI6g8OFNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I/1xWpRDysmce3EvyVnDKvplZQdEjjKRvgmy5LdtujsGRPRt+90/Q3oZadWhrczVK
	 QFiZeRzNsuWYvCxautmeR8y1HvInv0nUBr8eDiMG5CyoOxwt0uP6yFUEpBhcT3VUQJ
	 gMdFl/kQlUlFa2g3AMebTXjVzwpx2ZWc3d2T1p4U1TYIVd0Z/itnEwFscfBAqLygge
	 MlGZcPhQK0uZXzFaqTE9HHOWiAGdE7OBwwozTyPcX+DFc0SCWzprSOvi78r5WEd93o
	 oHayMDAiNInQrV71Axr7SjTy7EQ5xiL/QGV9y821SwUAnzbhgLkEBuolUmmhX1TnL7
	 NcNDqlOSGKhHQ==
Date: Mon, 9 Mar 2026 17:46:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 01/25] fsverity: report validation errors through
 fserror to fsnotify
Message-ID: <20260310004627.GV6033@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-2-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:16PM +0100, Andrey Albershteyn wrote:
> Reported verification errors to fsnotify through recently added fserror
> interface.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/verity/verify.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/verity/verify.c b/fs/verity/verify.c
> index 4004a1d42875..99276053d3bb 100644
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
> @@ -312,6 +313,7 @@ static bool verify_data_block(struct fsverity_info *vi,
>  		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
>  		params->hash_alg->name, hsize,
>  		level == 0 ? dblock->real_hash : real_hash);
> +	fserror_report_data_lost(inode, data_pos, params->block_size, GFP_NOFS);

Don't we also need to cover the "if (unlikely(data_pos >= inode->i_size))"
around line 199 in verify_data_block?

--D

>  error:
>  	for (; level > 0; level--) {
>  		kunmap_local(hblocks[level - 1].addr);
> -- 
> 2.51.2
> 
> 
