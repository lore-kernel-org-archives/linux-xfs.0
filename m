Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29CE3C9EEF;
	Fri, 14 Aug 2026 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786720427; cv=none; b=mH6c2OeoI5CaRouGJNqnMuxdseIHQ/iwwLqhSQUq0TTyOL8jS+AjH25zUxgNug+P06JXuVMnwzAAQH8ShhivLhdA2n3orACPVuZzIhaDZTg5Pc+IdGGRIX5gfQDyaa5w2Pm+mtyBYns1inCZnkyR9w0UhH6wdWTTmTrvazPobrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786720427; c=relaxed/simple;
	bh=qSYxeWnvIPw1FX9I9xs3aYxdKA3PzrvMo2ghmEhfBDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LyYaVsnLXrm7cA50w9teHc7mvg7t1OVOk+N1td9qOnob8geBWgu4pTPsQ4LFVqi2PWpnrqDxQ5P84ANFTtMKmwHbX40nJTfWOIhZh9xcjfOAk8fdSRO+drSRY/NzgInNtmFpSLyi9nafmnm5ZxdJkMkSjCOThwHjMXGoygWdu2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUMYZfCl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUMYZfCl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5A5701F00A3D;
	Fri, 14 Aug 2026 15:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786720426;
	bh=/KgPiqew/xPu1U7F+Angxp7pjTC09MZg7T4BSyNrCSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HUMYZfClAIgTKe5Kt88p0xj6wI82y+f7yTwwOfpIWVsa+jQ8KPZZtwWbnBwjPYfQh
	 EmoIC5bhNxmpvsSuK7M5ZhbnfnT8xRLXe7Wn32dtpOoNGMi7aKHYmHImNc1/RCvaxU
	 mw9bNEAHIYjlmCesaLrXSAdY4oWlgfMTk/Kh31/G/Jcj2e8KLW1DYOz8aI0ryId/Ny
	 1Dk7dT9cw/d1E01tBWqRxTTsKDruu3wXbzu/Al0tpGQ0uRWdC6z4lEg+z45dTTSHj2
	 0YbNgBDrxF8pzhd5QpFNJrfv+8Nd8x48SGZaMN3OMUNNEG6DIa8jqHa5EWFtHHxZx+
	 U87rPOuPqinxQ==
Date: Fri, 14 Aug 2026 08:13:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v15 15/25] xfs: don't report dio_mem_align and
 dio_offset_align for fsverity files
Message-ID: <20260814151345.GF3556460@frogsfrogsfrogs>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
 <20260814092448.1818082-16-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814092448.1818082-16-aalbersh@kernel.org>

On Fri, Aug 14, 2026 at 11:24:32AM +0200, Andrey Albershteyn wrote:
> Sashiko.dev reported that while fsverity files falls back to the
> buffered IO for Direct I/O, they should not report non-zero values in
> dio_mem_align and dio_offset_align, meaning it's not supported.
> 
> The STATX_DIOALIGN | STATX_DIO_READ_ALIGN flags are used to explicitly
> report if DIO is supported or not. They can not indicate that fallback
> to the buffered IO is used in this case. The zero alignment values also
> mean that DIO is not supported on this file, see statx(2).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Acked-by: Eric Biggers <ebiggers@kernel.org>

This is consistent with what I saw in the manpage, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iops.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 55667cc762f8..70637cdcc299 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -35,6 +35,7 @@
>  #include <linux/security.h>
>  #include <linux/iversion.h>
>  #include <linux/fiemap.h>
> +#include <linux/fsverity.h>
>  
>  /*
>   * Directories have different lock order w.r.t. mmap_lock compared to regular
> @@ -580,6 +581,10 @@ xfs_report_dioalign(
>  	struct block_device	*bdev = target->bt_bdev;
>  
>  	stat->result_mask |= STATX_DIOALIGN | STATX_DIO_READ_ALIGN;
> +
> +	if (fsverity_active(VFS_I(ip)))
> +		return;
> +
>  	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
>  
>  	/*
> -- 
> 2.54.0
> 
> 
