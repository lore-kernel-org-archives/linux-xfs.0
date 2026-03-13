Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC4632143D
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 03:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773372481; cv=none; b=DtEtPrVf4rGcQ7kdcjV8InixN4Amt9Y88HQWyt06o55gh/fZdyiMkeKZrNLVbaLZVBoYi43gdRBOyBNxGgkvwyVhSMtNu7RHaaM/DWtqeT5RgLAqb5/KgC9hdX8ioYfQZzyIQwJf7u2Ht/QaejHYN4CnwpvrBgZYqvvD7NxHKa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773372481; c=relaxed/simple;
	bh=yJnnUlGVRMm8NDwE++vWZ59V8VcZQPf0tzE17iV5xzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLOFxunH4jHyYuHkVv+UJ83ggNXM3Igy6ZGMppDqUJcR4NRMlkmzHiAoucDSSkltyM9vyvrtnNLEH+uj3eMI9TuEmWgyEOCYz26Kx+lz+JguyU3F77MR8LsgPV4PC0Ug4zhzNGtJHGbZslvdAVJChxd0zraD7biw+HFLnu/BFEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cy7ADjbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cy7ADjbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D48C19421;
	Fri, 13 Mar 2026 03:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773372480;
	bh=yJnnUlGVRMm8NDwE++vWZ59V8VcZQPf0tzE17iV5xzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cy7ADjbx0Jv3qZfM/M7Jsmnly9FVnWVBDdXjBFL1kOkkDuBEbK30YuT3HGXjA6DnM
	 AjTPXzXDNBAYpEeZ7nmaR0pDEuGIjPvRftTC6LZJxZPVxIw51KOo5smrVj+5fFAhy3
	 xLlLayOzla9pItsUWIKEQc3INib9griqJpJBudSa0OimXW3YMTRxkzRWiV6CqaUJq1
	 FrOGmaiMh84gSzczYbHPq5GzbXnxS0S0CNEiy5DG2kJTupBe5G/Y92jb8KpVH4KAST
	 VaJ9gTtzyY2BwZ/3/J/cJamJFYalYuF0TJTknYIeh3LtrKJLeBaBaVRR9Gyk/3yyLG
	 ArO51yoRyLRVQ==
Date: Thu, 12 Mar 2026 20:27:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Alistair Francis <alistair.francis@wdc.com>,
	Damien Le'Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH 2/3] man/xfs_rtgroup_geometry: add rg_writepointer field
 description
Message-ID: <20260313032759.GK1770774@frogsfrogsfrogs>
References: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
 <20260313002456.3823811-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260313002456.3823811-2-wilfred.opensource@gmail.com>

On Fri, Mar 13, 2026 at 10:24:55AM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> Update the man/man2/ioctl_xfs_rtgroup_geometry.2 to add a description
> for the new rg_writepointer field.
> 
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> ---
>  man/man2/ioctl_xfs_rtgroup_geometry.2 | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man2/ioctl_xfs_rtgroup_geometry.2 b/man/man2/ioctl_xfs_rtgroup_geometry.2
> index 37e229b43..5d264acac 100644
> --- a/man/man2/ioctl_xfs_rtgroup_geometry.2
> +++ b/man/man2/ioctl_xfs_rtgroup_geometry.2
> @@ -23,7 +23,8 @@ struct xfs_rtgroup_geometry {
>  	__u32  rg_sick;
>  	__u32  rg_checked;
>  	__u32  rg_flags;
> -	__u32  rg_reserved[27];
> +	__u32  rg_writepointer;
> +	__u32  rg_reserved[26];
>  };
>  .fi
>  .in
> @@ -39,6 +40,11 @@ filesystem blocks.
>  The caller can set this field to change the operational behavior of the ioctl.
>  Currently no flags are defined, so this field must be zero.
>  .TP
> +.I rg_writepointer
> +For zoned devices, return the writepointer block offset into the respective
> +realtime group. This field is valid only if the XFS_RTGROUP_GEOM_WRITEPOINTER
> +flag is set in rg_flags.
> +.TP

Oooh a docs update ❤️
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  .IR rg_reserved " and " rg_pad
>  All reserved fields will be set to zero on return.
>  .PP
> -- 
> 2.53.0
> 
> 
