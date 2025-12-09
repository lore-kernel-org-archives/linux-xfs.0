Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCE82DF3EA
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 15:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765295948; cv=none; b=iMTWlm9dSgFWM/YzUJygwBtzVyeK1Gcn2lx2dlZv7V9yLVt/bNaR5hVC3MD2DHgtSu75HeraW6W2P45S0f3Yx3aAh6O1DfrfaNzdYIzabGOpkT7mAY10lm61KL70I+piYBL22PUqSWWV6PFLEIOUzJxbMoX0a0gbQ9goV819UwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765295948; c=relaxed/simple;
	bh=8Ta+9nYE5z3YJtgDgjlnN5vKTDV45/QQSRYshCAmwjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NmhoeOAvGVNozNbpIoEBhUtMxHJJHY/lSSdVve0iZhsQoPZ9Ikdij4PDVTNsBXBvZCYo5Q4zb3c5nt+uOk80jHnilzsnika8kLOfk6zOVMSRHwS2WdghMPEmPRaHwNzIZHeqQCvvmKi2dM1yONHrCimjpYHE9zZMV/GBtCi8bvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRaqAfn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRaqAfn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD412C4CEF5;
	Tue,  9 Dec 2025 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765295947;
	bh=8Ta+9nYE5z3YJtgDgjlnN5vKTDV45/QQSRYshCAmwjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QRaqAfn6A62McZWqyHw69t1E3GxzuCTaakoDpkmBppWj67vSwiap+rgbxjT9nC26q
	 giERZUWUjlqKAnuwz+ejpkCoK6PM7pKQdRlOE56YGcV4a56f+RyTJGg1PPtz+/uOET
	 7WlQcmM0K7Q1nYvxYbyTc1Jj9C2ewcQ250NQEqWSn8VYH2iAfO/9tf9gufKZ+/9Qse
	 lU4ZFm7mQCl1MICN6pth4kFCbnYSoqcIxEFBjtdBNDHbR/nm7maL2DQkUZfixiso4b
	 oJimrKt/aq4xh+07pe2rHZrfVDbo+nGqsylGdpIlB3ZSr9jWlQcin/cViGJek8KG/0
	 HZUYJcBlq8tDg==
Date: Tue, 9 Dec 2025 07:59:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Message-ID: <20251209155907.GU89472@frogsfrogsfrogs>
References: <20251208071128.3137486-1-hch@lst.de>
 <20251208071128.3137486-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208071128.3137486-3-hch@lst.de>

On Mon, Dec 08, 2025 at 08:11:05AM +0100, Christoph Hellwig wrote:
> Add an array with the canonical name for each inode type so that code
> doesn't have to implement switch statements for that, and remove the now
> trivial process_misc_ino_types and process_misc_ino_types_blocks
> functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  repair/dinode.c | 159 +++++++++++++++---------------------------------
>  1 file changed, 50 insertions(+), 109 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index b824dfc0a59f..bf2739a6eae5 100644

<snip>

> @@ -2261,16 +2182,20 @@ _("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
>  	case XR_INO_BLKDEV:
>  	case XR_INO_SOCK:
>  	case XR_INO_FIFO:
> -		if (process_misc_ino_types(mp, dino, lino, type))
> -			return 1;
> -		break;
> -
>  	case XR_INO_UQUOTA:
>  	case XR_INO_GQUOTA:
>  	case XR_INO_PQUOTA:
> -		/* Quota inodes have same restrictions as above types */
> -		if (process_misc_ino_types(mp, dino, lino, type))
> +		/*
> +		 * Misc inode types that have no associated data storage (fifos,
> +		 * pipes, devices, etc.) and thus must also have a zero size.
> +		 */
> +		if (dino->di_size != 0)  {
> +			do_warn(
> +_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
> +				xr_ino_type_name[type], lino,

The %s parameter still needs to call _() (aka gettext()) to perform the
actual message catalog lookup:

				_(xr_ino_type_name[type]), lino,

With this and the printf below fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +				(int64_t)be64_to_cpu(dino->di_size));
>  			return 1;
> +		}
>  		break;
>  
>  	case XR_INO_RTDATA:
> @@ -3704,10 +3629,26 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  	dino = *dinop;
>  
>  	/*
> -	 * enforce totblocks is 0 for misc types
> +	 * Enforce totblocks is 0 for misc types.
> +	 *
> +	 * Note that di_nblocks includes attribute fork blocks, so we can only
> +	 * do this here instead of when reading the inode.
>  	 */
> -	if (process_misc_ino_types_blocks(totblocks, lino, type))
> -		goto clear_bad_out;
> +	switch (type)  {
> +	case XR_INO_CHRDEV:
> +	case XR_INO_BLKDEV:
> +	case XR_INO_SOCK:
> +	case XR_INO_FIFO:
> +		if (totblocks != 0)  {
> +			do_warn(
> +_("size of %s inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
> +				xr_ino_type_name[type], lino, totblocks);
> +			goto clear_bad_out;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
>  
>  	/*
>  	 * correct space counters if required
> -- 
> 2.47.3
> 
> 
