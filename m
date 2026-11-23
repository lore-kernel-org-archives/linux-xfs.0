Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460344;
	b=HAiUzeVXk0lLBqg369zQ/eA8LEIyXTlKf/W/40uFEz8PesC3801qPWJs5Ppuh0KT3X9A
	 Xo9ME/DVj7kYuHRUoMoj8h5qR4bQFv5QrWxysPrXlz15kNNYgoVT//nmZP8IWYE7MQDjT
	 jF1y1AdaLgxs3dE5jopoQP515V1VUNvYVofNcYG7pTV1RpW9QDC5WqNccZKvmx8gc5Olv
	 ly5OOQxEudl/KlSqB5zhkwbim6QQ2wSbFwcf4T8KSDcpb9nPWkGhLlgIqi57EYX/oENw/
	 doJH0udMHqOyC1q32uku62l5O92LJTTSy8uCHgWIQSle6mSG4TrVqEu7OLtARiib3JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460344;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=9zxKMTvX0b8A/4ZVTHzDzbGbHP86KnIHQCF5pYs+z+o=;
	b=iCi7kaJQDPFWF0oH32qYTXb/lCZ93J+n1S5v9CO4Q3laKiB7uh6GylLd8gohDfWPMtMY
	 VsI8Dw+DUFXaR72/UBZd84/wemzl1cR+eWsLOG4ehWRTkzbvseC8sfekSMIxlQBABLcGU
	 3UioPviYkk748q2gw6kWS1/HpCAbhPc3/GtWjLI3g7elD1HKL9AJNnoYUfl8IdcjNQKyN
	 w/F+84vjf32HY3C9Rnk8pEfeKADnlWlbcwDAEXmrw1kQ9dXocRue6tcGyQx3uQpv0er6f
	 JayIOG+VNNcIFQU9OODbDa1Gv/moSdKOWIZSl1cQJ1my39RVq1kWm+G9h9kssmfygQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iCIU4yYG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BE6606A31A;
	Mon, 23 Nov 2026 18:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iCIU4yYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467C11F000C0;
	Mon, 23 Nov 2026 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460344;
	bh=9zxKMTvX0b8A/4ZVTHzDzbGbHP86KnIHQCF5pYs+z+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iCIU4yYG6SZr5RD7dnTGzlhBxWYA/lH+jAmMxQIJzVcOfOXFEA6YLbKdpxu+PjRD/
	 GviSSUmpBnwnZhPYS3rLBGmR+O32axGImc3wew0X/lumpaJTop/0t7v9cZeOWGF213
	 0/mgLIVkEHMiO4a5NRgv4RFVvA5lHX05tpFPWcCXpS5mDBCKBr5wFkbP38IfFV1Rhn
	 oyG0pDzmlriMEPEH70SAdOrSDlGz6YvfSLWNYf8EwXO4lEILrlYs1/P6CkCn+u8esd
	 KSiyNmJqtT6RNYRVKatWRLiyO8ZTahGVcGGRlJy7wFQ2g86cKgeS/wh8qbQrWegYST
	 THtD++irdznrQ==
Date: Tue, 24 Nov 2026 02:58:56 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 17/21] fstests: add _change_metadata_uuid helper
Message-ID: <awSM2FyEuUTBwZPH@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <8aebfe6024e971c967497284c702862f16cbe570.1791272793.git.asj@kernel.org>
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
In-Reply-To: <8aebfe6024e971c967497284c702862f16cbe570.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:43PM +0800, Anand Jain wrote:
> _change_metadata_uuid changes the UUID of the golden filesystem before it
> is cloned.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/rc | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index bc0522dbcdd3..7feeec04a500 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1577,6 +1577,23 @@ _scratch_resvblks()
>  	esac
>  }
>  
> +# Change the metadata UUID of the given device to a newly generated one.
> +# Args:
> +#   $1: Block device path to modify.
> +_change_metadata_uuid()
> +{
> +	local dev=$1
> +
> +	case $FSTYP in
> +	xfs)
> +		$XFS_ADMIN_PROG -U generate $dev >> $seqres.full
> +		;;
> +	btrfs)
> +		$BTRFS_TUNE_PROG -m $dev
> +		;;
> +	esac
> +}
> +
>  # Create a small loop image, run an optional tuning function ($2) on it,
>  # clone it, and attach both to loop devices, returned in ($1).
>  # Args:
> -- 
> 2.43.0
> 
