Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C74397E85;
	Thu, 23 Jul 2026 21:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840785; cv=none; b=r8OUTrykTwmtX3jkxqEh/xG9KBGtc8W9ozfhoSCzgs6o4zRPhGLTZtQ0/kcXIzk0SfMvcxo9EBlGaWN+0YkhK+pnWleuvMzTMNNEC5ZlzCxg9NPfrtxCka+PRDEHT3vRXFSr/iCvza0bosGtYEfN3+h2Fb7BEORkkDHcghtLjk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840785; c=relaxed/simple;
	bh=mI+zdc+b402vd2y6lCpWIuQAA6Bg5oBr889qlluxiuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IavpUrDzpgJEQoN7ZKiQRoGPkvs6WHfl7VNVeSXytroJAcbsqjIIsdmiPGTT0Y5viOD8JLXBd0syRGZvWZ47MM30RdlsGDvemav9F0ARO/E9glUBh0BfjT6dPhPWZdUe/sswu1v1/DKfyfFMyKV2Rr1Avh0mzLhQ7RaLhFWce2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ujkw7Q+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ujkw7Q+z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4684F1F000E9;
	Thu, 23 Jul 2026 21:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840783;
	bh=v+MgZ/LWv32WX/KO68TDmJpFCAXLWEnYB/nQFV+JvVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ujkw7Q+zx2/1BafecRhauNPGSFAdhEHoajbiys28Nl6HxU1LWaRtuATrisKW3eDyL
	 /e8UGVj5KzpmnX6ukfMrTgBkI5hI91uIQraMOy6P8zMI736YqVXmym3nBnZ7MdTyZn
	 aeBvv4aVJBm7ZqC+RC+Uypcv//tiYzLPgKlvvyd1ScX2LOTOE/oOlAu1w0nP2Ce74A
	 iJACRpdM3e72hlHv/kWgZDIGmfSdEvvRRL78CvYPBcvi9aLnaJ1LZvfl4kLh5PGFg4
	 qGmgcNp0HQgDWuZFz/wpbv0QVdP0aKI1O0tIPERxpnmWdjXkXcL0LxqFceUb4hxZW4
	 FLX5f3+xs+Hsg==
Date: Thu, 23 Jul 2026 14:06:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/22] xfs: add error injection for lazy bounce buffering
Message-ID: <20260723210621.GK2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-22-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-22-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:46PM +0200, Christoph Hellwig wrote:
> Add an error injection know to exercise the lazy bounce buffering
> code path, i.e. to inject direct I/O re-read using the bounce buffer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_errortag.h | 6 ++++--
>  fs/xfs/xfs_ioend.c           | 5 ++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 6de207fed2d8..2dc441da0333 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -75,7 +75,8 @@
>  #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
>  #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
>  #define XFS_ERRTAG_ZONE_RESET				47
> -#define XFS_ERRTAG_MAX					48
> +#define XFS_ERRTAG_BOUNCE_REREAD			48
> +#define XFS_ERRTAG_MAX					49
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -137,7 +138,8 @@ XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
>  XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
>  XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
>  XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
> -XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
> +XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)  \
> +XFS_ERRTAG(BOUNCE_REREAD,	bounce_reread,		XFS_RANDOM_DEFAULT)
>  #endif /* XFS_ERRTAG */
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index 94a81fb679ed..641f0d881b07 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -16,6 +16,8 @@
>  #include "xfs_reflink.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_ioend.h"
> +#include "xfs_error.h"
> +#include "xfs_errortag.h"
>  #include <linux/bio-integrity.h>
>  
>  static void
> @@ -103,7 +105,8 @@ xfs_end_io_read(
>  			 * but right now we can't distinguish them from other
>  			 * (i.e, reftag) errors.
>  			 */
> -			if (error) {
> +			if (error ||
> +			    XFS_TEST_ERROR(mp, XFS_ERRTAG_BOUNCE_REREAD)) {
>  				xfs_read_bounce_and_resubmit(ioend);
>  				return;
>  			}
> -- 
> 2.53.0
> 
> 
