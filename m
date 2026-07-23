Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83DD3A4F3B;
	Thu, 23 Jul 2026 20:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840138; cv=none; b=mMSjUFMUQFirSjMIJzfR+nC91NrqtarwssGUy/VdVWYJTeZkpWzLMJP7zw82myE7gj2cKosdXBXNvfZ/eBy+jv5B/mNNZ/za9FlCSQ9oTvk7WA24jscF5y0C8HJOsBWog+6UdXrUCrQP6jlfXthcujqsVLlzlYLv8AvoovOE6JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840138; c=relaxed/simple;
	bh=EcUmBO7DY3kTQS4F/3tZjklGpRLV8bLnB7KLlcezClI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZsE5fBSS8aorPbTTUD0JGcKxnf6ZLfw8IitZPxwQRYJ7HQKRmLzuHJLaGjUA0TN04vyVTuu/+AiYaNtMrVHznyZGUy6RG8PP5QmUTe2xrrb7IBbAOdfEcy6cngt1BJPxAZMEu0z+loiCLxbBgFhy6Ye65KCnj7Kuxv8aa3F3zTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdY3vsp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdY3vsp+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 122D21F000E9;
	Thu, 23 Jul 2026 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840136;
	bh=P4tZnY1zuP0Kjc4Nss3Y3MuCvPmbAhmWNT3IAy6h88I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WdY3vsp+bnkGVRMWXvei8zev6q3Jlw2PHSvSTZxT+gGss0zFNULlHZGFgvoUP5E4a
	 ZzSdWxKpW1M6KPyiXn8eW1YlvvlYG96lwSP1BfjFxCEFQW82WoNlE+guPnY3RvP5qf
	 1C/QyQJi7FV1VBo4d597gS9MmYHRfvWfSDQvCnTBgRJhT+kWJUT4thcG/TkKLh0mry
	 G4/X9IrvMOKYh+5nujqvlRXQV0rSxv0m5PdSysUdNEk3dyyRid56JmpHLEDj83E3Wf
	 IcZ8cRnDrzcjgVi6TBfnwcEVbqENEL1vkcY41MOIupdc/8RfoPdvidVqfzE5Z8eaEh
	 IA+7ZFDs45ZdQ==
Date: Thu, 23 Jul 2026 13:55:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/22] xfs: move PI generation into
 xfs_zone_alloc_and_submit
Message-ID: <20260723205535.GF2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-17-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:41PM +0200, Christoph Hellwig wrote:
> Keep it in one place for all the zoned write bio submissions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c       | 3 ---
>  fs/xfs/xfs_file.c       | 2 --
>  fs/xfs/xfs_zone_alloc.c | 4 ++++
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index b95d74e40b06..0b757b7f35c0 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -22,7 +22,6 @@
>  #include "xfs_icache.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_rtgroup.h"
> -#include <linux/bio-integrity.h>
>  
>  struct xfs_writepage_ctx {
>  	struct iomap_writepage_ctx ctx;
> @@ -673,8 +672,6 @@ xfs_zoned_writeback_submit(
>  		bio_endio(&ioend->io_bio);
>  		return error;
>  	}
> -	if (wpc->iomap.flags & IOMAP_F_INTEGRITY)
> -		fs_bio_integrity_generate(&ioend->io_bio);
>  	xfs_zone_alloc_and_submit(ioend, &XFS_ZWPC(wpc)->open_zone);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 80dd278e023f..2c19e69b93cd 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -731,8 +731,6 @@ xfs_dio_zoned_submit_io(
>  	bio->bi_end_io = xfs_end_bio;
>  	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
>  			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
> -	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> -		fs_bio_integrity_generate(bio);
>  	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
>  }
>  
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 7d13fa7ab30a..3fd1069beea0 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -26,6 +26,7 @@
>  #include "xfs_zones.h"
>  #include "xfs_trace.h"
>  #include "xfs_mru_cache.h"
> +#include <linux/bio-integrity.h>
>  
>  static void
>  xfs_open_zone_free_rcu(
> @@ -868,6 +869,9 @@ xfs_zone_alloc_and_submit(
>  	if (xfs_is_shutdown(mp))
>  		goto out_error;
>  
> +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_generate(&ioend->io_bio);
> +
>  	/*
>  	 * If we don't have a locally cached zone in this write context, see if
>  	 * the inode is still associated with a zone and use that if so.
> -- 
> 2.53.0
> 
> 
