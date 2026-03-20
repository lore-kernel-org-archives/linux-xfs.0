Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276F23A7831
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774017567; cv=none; b=u/GRdihvh5mCPMcz4EDi9h/Cgg0llqvx3fDGg3qH/Eaxk5QzR7iTmxi4yTRUmNYWK3S2aoCrzRK9q3436c27ya4ZhAasiHTrMbN2x6lkkB7oDhdU4+OAhsX7obUCizEZ/GcRFnbVoqJtmioXRVDjdzoOhwte3A4srIi6Pwpi6VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774017567; c=relaxed/simple;
	bh=YiDYGMy23srP71Dm+T8mWJGV1WwvzTLQIaNZmNCvHEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9w/yWYmCTTyfTB+EgEPFNLWJjrzrP2vHsxYn3CDq1HAcoGt9IHkkRt0iwYFlmkGvJZgv+gDPEEhkEhI+tsrjujGFK9WwqpWV4E0jWaNC2axGamXg/w/hibhx15u7wAQ1SlPyp4mLp2gW3xiXxAHBtoZUMbCc+FpITrp9/0CAIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+9XZ9Ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+9XZ9Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63C9C4CEF7;
	Fri, 20 Mar 2026 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774017566;
	bh=YiDYGMy23srP71Dm+T8mWJGV1WwvzTLQIaNZmNCvHEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P+9XZ9OlS8+1NvDbnMX/62WzU+6p2xIGPLfqKPdhj9DFb0cgLD5MpjLui4df2w/Pi
	 pW1Pn6BmToTFfsY7E1LH3YAfYLIcFJ3igB82DKuZm1k6exK3Sohg6akv7Goqk2nEyK
	 ToeFCJa+Ky2Nh+J+dwgs7mvMVhg2mcN08TSDAIi6oreGdvGRkGeUFsbnQ4DtNgp104
	 eFpaQk6/NAeRZpF+XZm2pnP2UopkteCfgl6uP+vLIoC6Ch72VAD1tqUTcL1zxMhD7F
	 lRSDTM1f6t0zj0Fs3YJR1FkiDHVRBVuHHtpqm2QYhhGi+sOIpLI2PVSC4PVI5Nj5n+
	 wPkXCJ6YocYTQ==
Date: Fri, 20 Mar 2026 07:39:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: start gc on zonegc_low_space attribute updates
Message-ID: <20260320143926.GB6223@frogsfrogsfrogs>
References: <20260320130256.35225-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320130256.35225-1-hans.holmberg@wdc.com>

On Fri, Mar 20, 2026 at 02:02:56PM +0100, Hans Holmberg wrote:
> Start gc if the agressiveness of zone garbage collection is changed
> by the user (if the file system is not read only).
> 
> Without this change, the new setting will not be taken into account
> until the gc thread is woken up by e.g. a write.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

This sounds like a bug fix, so

Cc: <stable@vger.kernel.org> # v6.15
Fixes: 845abeb1f06a8a ("xfs: add tunable threshold parameter for triggering zone GC")

The zonegc start makes sense to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> 
>  fs/xfs/xfs_sysfs.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 6c7909838234..ac1329944049 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -14,6 +14,7 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_mount.h"
>  #include "xfs_zones.h"
> +#include "xfs_zone_alloc.h"
>  
>  struct xfs_sysfs_attr {
>  	struct attribute attr;
> @@ -724,6 +725,7 @@ zonegc_low_space_store(
>  	const char		*buf,
>  	size_t			count)
>  {
> +	struct xfs_mount	*mp = zoned_to_mp(kobj);
>  	int			ret;
>  	unsigned int		val;
>  
> @@ -734,7 +736,11 @@ zonegc_low_space_store(
>  	if (val > 100)
>  		return -EINVAL;
>  
> -	zoned_to_mp(kobj)->m_zonegc_low_space = val;
> +	if (mp->m_zonegc_low_space != val) {
> +		mp->m_zonegc_low_space = val;
> +		if (!xfs_is_readonly(mp))
> +			xfs_zone_gc_start(mp);
> +	}
>  
>  	return count;
>  }
> -- 
> 2.34.1
> 
> 
