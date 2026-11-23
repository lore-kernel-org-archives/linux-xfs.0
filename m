Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795455491;
	b=n770EQV1o8Y8CFjjgkXvzUWlwY/XgV4u9QUNrRWzN36YUOTe4eEfKdFdXbU9i34IFYSw
	 f2kn7SOXdKY4TRdHJsPlPUEI48RALGVj5QZgCMpAnrh0QlbuBopVlqBFt/2UMukce3f/Z
	 +I4hVrFt+K3Fh36lE47u22D+DI9h2QzkeeSQrp9BZYmh4lUQIowmt8npZx76zwmsbBj0w
	 PDQRuRxQpLkTAk6dzW8cagbK02r0gWl5g6pTIFXGBdufmwRQCYw2NBry/7mh9FTsYBvyr
	 j/pJJx2Xc+89DzaOcgR7tpaFvXQ8R/1tGVnUxBzDmACQBlK677TfCq/X/lc834gkDSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795455491;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=94ekcRJsUgWpy81sPHWeKTgB95XqS37ea/xGDrOA6kI=;
	b=mG8yffbId1CtxHjZmCTxv4UbGL0tuk9IqBjIAurSabhHwvBbeygS6X9EMZgi2NzPpzpJ
	 T7yx4AlOEDbCcFHIdNeSc4pZOwbKeXZIRZevDu1LBq9pVq0pV6acBBuTHgWqHbaTdM7RP
	 5YgLuCxjz7oHq4UJDn/xiUjqcD53Xcq+tpXPpOS3VMUiksOAc//jVPov69WKvLQb9efsw
	 Dul6V41n+nehi88XJ0w0gcrScRqR6MWeskrXxqUQWL/Z0nR/sCdBEIlM8ZeYYkMrjzfzy
	 SPkI39NHLVo75by+/VJ45GOQBCZrpp2CfkINvLGKR7j+LrTZzSCFit5GonfFy6jswSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WtX6KOvh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE92606A31A;
	Mon, 23 Nov 2026 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WtX6KOvh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E0B1F000F0;
	Mon, 23 Nov 2026 17:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795455490;
	bh=94ekcRJsUgWpy81sPHWeKTgB95XqS37ea/xGDrOA6kI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WtX6KOvh8tad3FIjQbAWuqVJCzjsepOvwwK9FNzDvVkwme9waafd2NDNQk7pASgj2
	 da7i7XEha4TLvCyymLfEbIENrh6ZsgAJZc1wwcuMMjkcEvImxrteol2niRVQyQtxki
	 dWfqhPUA5R8t0CJWn+bu/0j0+aZknjziJlP8kGycjC64Tojh8hubahlSCyrhzZyMOC
	 /VreT1Rj97LeqKSUDcjAjXm1sLbsAQDHVHjCVU4BwoJLKPpQ32rM0g+mnLtweYLUJp
	 VUWzdXjbQsp16yQILv1OrKc3rsn0StMeg/pUihKLi7Pu4Cx3Eh6Davyhsfs6Q1BhaN
	 5CvXPfSOliqMg==
Date: Tue, 24 Nov 2026 01:38:00 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/21] fstests: add _clone_mount_options() helper
Message-ID: <awR56zlPFGBFLnyw@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <ff8994fe7511fb1ed3b08bf7830c53168c813713.1791272793.git.asj@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff8994fe7511fb1ed3b08bf7830c53168c813713.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:29PM +0800, Anand Jain wrote:
> Adds _clone_mount_options() helper function to handle filesystem-specific
> requirements for mounting cloned devices. Abstract the need for -o nouuid
> on XFS.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/rc | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index f2ab4bc491af..b9481ba8ab55 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -428,6 +428,19 @@ _scratch_mount_options()
>  					$SCRATCH_DEV $SCRATCH_MNT
>  }
>  
> +# Return filesystem-specific mount options required for mounting clone/snapshot
> +# devices.
> +_clone_mount_options()
> +{
> +	case "$FSTYP" in
> +	xfs)
> +		# Allow mounting a duplicate filesystem on the same host
> +		echo "-o nouuid"
> +		;;
> +	*)
> +	esac
> +}
> +
>  _supports_filetype()
>  {
>  	local dir=$1
> -- 
> 2.43.0
> 
