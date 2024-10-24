Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B101F81B9
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729788946; cv=none; b=FM+yTZ+ZMK1Q7xuXQkOmNaH59qeU9xBJLOHUJ0te9wdGsco+jGXn5sN5K4J5MvdCtJcHFn10L8PuNhllw8jqUvQeZner00V9vJPs5YmudjPMSelAZBzwLoWwWrwEyWupcK2umZybJFZJiFRF/M9TSj1chpXzV+NJ3dPUxepHXd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729788946; c=relaxed/simple;
	bh=i9w1dQg5V6bI2ZPQtHodi3O5MaHKOZe3Wfb3Ozsl77k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZGZAS5WzV4skDf81GOunVsXcPw+e5sAWPlHbuWmRM+rZYI+wVwrOLjXRUQQbFpIKT2CSHzSCL8Fkgai53My6r9/Hr+1LhT2AsB1o9MvX1461qM5ReYA6sQ9bsV91GQCLqr4YDdsW5oM5t85XrOeS51Jf02KROPPiSJnVaubsZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gzcO5uOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gzcO5uOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2ABC4CEC7;
	Thu, 24 Oct 2024 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729788945;
	bh=i9w1dQg5V6bI2ZPQtHodi3O5MaHKOZe3Wfb3Ozsl77k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gzcO5uOc/BW0mGHhRXXOoYDMEcQ0H6fJaazKNFwmf8kdVaAYmwZSACaZtHx4HhjGF
	 EdUw4auAN+wALdNM9qDs/yvB9pZW1uZL/Eh8aHKqd9HFWM8i+0nrNoUVaeYXI5flj5
	 Ueon/d7MxGRO7J5maYg9tlHj59BDWK5W2Vow3cb2WpstgzA4JZvUzWQETKtGyYyKWk
	 8FyMcl1q2Ro7UntGJGtFstHkO5BznxmASw4WxfTwUIueh8RPxZ5htRHimbg0u8K/Bp
	 gd1Ix0Wlvuz4JYCSRSQJcTdMURMPf/vOnFU4TQ7JXH7zJA1asTTKfSQfqw4rcbe/9Z
	 kbYDBAU1RTs2Q==
Date: Thu, 24 Oct 2024 09:55:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: sb_spino_align is not verified
Message-ID: <20241024165544.GI21853@frogsfrogsfrogs>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024025142.4082218-4-david@fromorbit.com>

On Thu, Oct 24, 2024 at 01:51:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's just read in from the superblock and used without doing any
> validity checks at all on the value.
> 
> Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Cc: <stable@vger.kernel.org> # v4.2

Oof yeah that's quite a gap!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index d95409f3cba6..0d181bc140f0 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -398,6 +398,20 @@ xfs_validate_sb_common(
>  					 sbp->sb_inoalignmt, align);
>  				return -EINVAL;
>  			}
> +
> +			if (!sbp->sb_spino_align ||
> +			    sbp->sb_spino_align > sbp->sb_inoalignmt ||
> +			    (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0) {
> +				xfs_warn(mp,
> +				"Sparse inode alignment (%u) is invalid.",
> +					sbp->sb_spino_align);
> +				return -EINVAL;
> +			}
> +		} else if (sbp->sb_spino_align) {
> +			xfs_warn(mp,
> +				"Sparse inode alignment (%u) should be zero.",
> +				sbp->sb_spino_align);
> +			return -EINVAL;
>  		}
>  	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
>  				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
> -- 
> 2.45.2
> 
> 
