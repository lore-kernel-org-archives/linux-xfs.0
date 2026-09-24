Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4640847A88C;
	Thu, 24 Sep 2026 18:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275810; cv=none; b=E3akZFs3vWSOZlfoVqj6lm6i7G77N2eXOU1oxVfZBQkqQg/pHrwPgLJpgAILE6OBdlfuzAZwhJE0BwixZP+RIoouFBCvGZQFY2RY0dhIAiR3uSuk/G0EN7XvkcLjuMjXVKOgb2ds/VomqSW7A03TuuLVVScfBent4bt8zr1sWy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275810; c=relaxed/simple;
	bh=lE9NVZQMT43pAiZTnCnaTVCmjyci07GRFcesdkOJ5Jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYGMBrJBK2uuc07leJIm1fICFrLsyPtV0lzeL89VudT7P5iAizV9VBrl9W7omnYULZ1o5eCrr1YsEfW01/7sNppgIEFAlCekcWpLnkhIDuvleY7W9wzj+IBUO1hqcrpMYJFk8mp7XQ6MXyAWlPu1JmyAmx+xO/xfZGqVEFUGkdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmdQ7Xhk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmdQ7Xhk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 84F741F000FF;
	Thu, 24 Sep 2026 18:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790275799;
	bh=DDKStqDwEdNaBSzhb9QDaPf4LfZUE1byKNh6SoLi3uU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WmdQ7XhkACpaPC2Vy6yaf8VhPrUm2+ug3skHw35s/Xp4Cy7x8DCt9LOMfCc8OmHmo
	 nZq7sdWWsdkKIFCuOalUtG+/9eB2iSQH5g3+G7ZrRhmE84zHPttNVXVTGM0Wf2f3uO
	 h4M3k8topafW5Zx53ZweKmjgqSmoLJUk8/foDQluGQPuazJZgiGfjwIAz2EK3HTK+5
	 Z365Yb/nhm5JWjDIcVOFHKKAN7vO13VHlNjTFmn0R+kpNYkYW2PCwBVgRONl/jTA37
	 kkPTWBEQIbtdca6YJWqgEYb7LYxHIEDJMCI+2uKaAXTHT1NQ+o0TqZy2XwgQ8JV9th
	 AuPYQV0lF/fbQ==
Date: Thu, 24 Sep 2026 11:49:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] xfs: add an error tag to inject a
 ->writeback_submit() failure
Message-ID: <20260924184959.GJ2705364@frogsfrogsfrogs>
References: <20260924091203.198225-1-parri.andrea@gmail.com>
 <20260924091203.198225-3-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924091203.198225-3-parri.andrea@gmail.com>

On Thu, Sep 24, 2026 at 11:11:52AM +0200, Andrea Parri wrote:
> The only in-tree way for xfs_writeback_submit() to fail is a failing
> xfs_reflink_convert_cow(), which requires a shared (reflinked) CoW
> extent.  There was previously no way to exercise that failure path
> from userspace, which made it hard to write an xfstest for it, e.g.
> for "iomap: don't resubmit an ioend after ->writeback_submit()
> failed".
> 
> Add XFS_ERRTAG_WB_COW_CONVERT_ERROR to force xfs_reflink_convert_cow()
> to fail with -EIO, so that ->writeback_submit() failure and its
> callers' error handling can be exercised with error injection alone,
> without needing a corrupted or racy COW fork.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Assisted-by: LLM
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_errortag.h | 6 ++++--
>  fs/xfs/xfs_reflink.c         | 5 +++++
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 6de207fed2d89..e6b0864051b0a 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -75,7 +75,8 @@
>  #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
>  #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
>  #define XFS_ERRTAG_ZONE_RESET				47
> -#define XFS_ERRTAG_MAX					48
> +#define XFS_ERRTAG_WB_COW_CONVERT_ERROR		48
> +#define XFS_ERRTAG_MAX					49
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -137,7 +138,8 @@ XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
>  XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
>  XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
>  XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
> -XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
> +XFS_ERRTAG(ZONE_RESET,		zone_reset,		1) \
> +XFS_ERRTAG(WB_COW_CONVERT_ERROR, wb_cow_convert_error,	1)
>  #endif /* XFS_ERRTAG */
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 4801361366359..104542b10d9e0 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -34,6 +34,8 @@
>  #include "xfs_rtalloc.h"
>  #include "xfs_rtgroup.h"
>  #include "xfs_metafile.h"
> +#include "xfs_errortag.h"
> +#include "xfs_error.h"
>  
>  /*
>   * Copy on Write of Shared Blocks
> @@ -346,6 +348,9 @@ xfs_reflink_convert_cow(
>  
>  	ASSERT(count != 0);
>  
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_WB_COW_CONVERT_ERROR))
> +		return -EIO;
> +
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -- 
> 2.53.0
> 
> 
