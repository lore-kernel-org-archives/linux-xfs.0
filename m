Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460301;
	b=UI1pMHwFmUTusCCPuO4wYsLKlFG21eb+YgpXKAvpQi7XoP36SEYUzFj8l+kaXEZ0m5A3
	 SkyeZ4EHUiJ3MPZc2kjjVj4by4Qp2X9CIoc850UJ6mFohRnBXAYODypJId9lv2VQnkYK8
	 kHTu4SQju/SxqVUx7CJacCabE8tMmGYudQFDmx5A89gXXUjGUqUUSeZErsDXrmGxckjyh
	 3zMbtsj16cuTnsRs1ZxsuBjt2oFezvIJEELeOf4AQFfCcxoBrT0S0f9KQCJwwbMmBVLSq
	 QwZ/AyEP1zA0SkPDQfpXG8JOs/FNfPtn/sAzVN9ybNQnHTH1UFxlhUwlSB4IDv6hxVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460301;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=UCWAc74X2Sila0MeqKGLJ6slVwlYxSmjvDKNYU79/Ys=;
	b=NlPkWhkuzpfOObnuR2R1hDPsT8Gm0FTzEjGiA3eTTRhOYK+To+R/ttz+/xgtZee0N45A
	 1jQiFx7YTfBspb7eZ9Sh6P/+TJx3pHqc+HjLpA26MrUQYrqcD2APRaxJeeQEXk8o/Zkgq
	 H96Uu3ag9OEBQ4lVB5mZdqy4B+FwiAbsTVBRvgfyhfvuW37VojJ7Njl925iM9TIxUt78f
	 pfvB5o7pc7m32U9YHaf2+PN4tTaeaw4KfRm4H2myU+5zVX2NUTUBRCUML7Sduzi9nzLgP
	 xkMhCT1GKxdjFGDsvOZAayhD2l5bMYWiauzClk/WZ4BggoQu/beYMZISBo+S1Ceg8Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bGeVa/yA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7581606A31A;
	Mon, 23 Nov 2026 18:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bGeVa/yA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CA61F000C0;
	Mon, 23 Nov 2026 18:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460300;
	bh=UCWAc74X2Sila0MeqKGLJ6slVwlYxSmjvDKNYU79/Ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bGeVa/yAZZ4BgUJl1s+v6B1kSZtstNuWk/KD/ClOL+f1n9/Vk7ykUhxwqGqJnHLdw
	 TZNz+k4Zcpt5eoA5grLrXxYL50NVS18VhYJEP0zbMmDtgo1GE0CGkTJl+Adrsp7o2U
	 jNPiFHgxsAofoQmee2lnc7AO8RJjzEi+pOu1NvTs9Cq8JoP3mtxC0SyyPFRtFz6UGR
	 MWxeJcO4HDlrZ1QhBMLFVKPXVrK4aJIcoAADOBBWly+R9vqtAS9M3UynloeJuzbPGB
	 /m1X2iUGFnzHxozKIxjSRBQdmg5EvBYirlu/JEXrGoocs4L4N2r05R+0l0+ERUU8y2
	 KxV/oeQNVMPbA==
Date: Tue, 24 Nov 2026 02:58:11 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 16/21] fstests: introduce _require_metadata_uuid() helper
Message-ID: <awSMoVcHT6CvbXdw@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <2d4f4228bd376e234425fd2b23692820593486a4.1791272793.git.asj@kernel.org>
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
In-Reply-To: <2d4f4228bd376e234425fd2b23692820593486a4.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:42PM +0800, Anand Jain wrote:
> Add _require_metadata_uuid() to common/rc to check for the required
> userspace tools (xfs_admin and btrfstune) on XFS and Btrfs, and verify
> kernel metadata_uuid feature support on Btrfs before testing filesystem
> UUID changes.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/rc | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 4ae3c74a52cf..bc0522dbcdd3 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6527,6 +6527,24 @@ _require_unique_f_fsid()
>  	esac
>  }
>  
> +_require_metadata_uuid()
> +{
> +	case $FSTYP in
> +	xfs)
> +		# The xfs_admin utility is required to modify the filesystem UUID.
> +		# Kernel support for metadata_uuid has been present since 4.16, so
> +		# it is assumed to be available.
> +		_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +		;;
> +	btrfs)
> +		_require_btrfs_fs_feature "metadata_uuid"
> +		_require_command "$BTRFS_TUNE_PROG" "btrfstune"
> +		;;
> +	*)
> +		_notrun "Require filesystem with metadata_uuid feature"
> +		;;
> +	esac
> +}
>  
>  # Computes a percentage of the available space in a filesystem and
>  # returns that quantity in MB. The percentage must not contain a percent
> -- 
> 2.43.0
> 
