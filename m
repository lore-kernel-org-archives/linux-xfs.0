Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D79E1EDA11
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 15:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747062761; cv=none; b=XqRCUnlhnp2ECc/hFZzT6ZqBq5hTj24iCOd7mDRRMkGKA+nyBSU5e5kznL8oPt530iuPW72UvmNiLgTee7C5lCeScoHQ4qhISsweqiNzx/ZYId1CkbCdzf9tZMlOeilSzSiG2bOhsXTzBSz1NRCVEfbigyO6vc70e57laycEiGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747062761; c=relaxed/simple;
	bh=9YWTKNoXhQgmTKP2q7/bI+y+xr10qd76xzAsAAmoKeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0wMc346s1Cf3z6FGdT/yz61nWTLIPkoaJvh0cEEtrCIeWZlNQeQCuVhdsJX0bYYN7I6rFJr2diUYliCHFfnSmgvQSs4tZYQG6pGV1lvsYCWXReha82+e3AYaagc3FSZQWiKwN/ZK1MqMSmjl9B5HFfCaf3r3aC6AfWogChS3Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YXpLihh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YXpLihh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF63BC4CEE7;
	Mon, 12 May 2025 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747062760;
	bh=9YWTKNoXhQgmTKP2q7/bI+y+xr10qd76xzAsAAmoKeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YXpLihh/9HjePCtnY8Ac3Pdfqw4FBmI/p8lp/m0H4HLdeJiniEyKdcFWxL42rqhwY
	 0GW2DabwQxO0iG813gmOB1ljP+rhNW84GtsvbQQ1Y1YJEFQP6OCGgtv+hn9j6sHciw
	 amxeOv/d1XeVjtIZesr+wch2ssJ8pRWvvA1x1r/IPgoJObjft2sVO/5I88lM6eHrdP
	 MsyRwat5Ry22Mf8kK9ztieM3hEdBZfpdV8DNTnlphQk+6ZfGEzUQEdZ06Dh6RP6h2b
	 UnHUP0ijsXhgFGoMGG1lNB0RbFG14eAaW85eEOcAI0rbnOfUsYI7ZL60KPHaShWxg7
	 LQCnKVmjJ2O4Q==
Date: Mon, 12 May 2025 08:12:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_mdrestore: don't allow restoring onto zoned block
 devices
Message-ID: <20250512151240.GE2701446@frogsfrogsfrogs>
References: <20250512131737.629337-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512131737.629337-1-hch@lst.de>

On Mon, May 12, 2025 at 03:17:37PM +0200, Christoph Hellwig wrote:
> The way mdrestore works is not very amendable to zone devices.  The code
> that checks the device size tries to write to the highest offset, which
> doesn't match the write pointer of a clean zone device.  And while that
> is relatively easily fixable, the metadata for each RTG records the
> highest written offset, and the mount code compares that to the hardware
> write pointer, which will mismatch.  This could be fixed by using write
> zeroes to pad the RTG until the expected write pointer, but this turns
> the quick metadata operation that mdrestore is supposed to be into
> something that could take hours on HDD.
> 
> So instead error out when someone tries to mdrestore onto a zoned device
> to clearly document that this won't work.  Doing a mdrestore into a file
> still works perfectly fine, and we might look into a new mdrestore option
> to restore into a set of files suitable for the zoned loop device driver
> to make mdrestore fully usable for debugging.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mdrestore/xfs_mdrestore.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 95b01a99a154..f10c4befb2fc 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -8,6 +8,7 @@
>  #include "xfs_metadump.h"
>  #include <libfrog/platform.h>
>  #include "libfrog/div64.h"
> +#include <linux/blkzoned.h>

I wonder if there ought to be guards around blkzoned.h, but OTOH that
seems to have been introduced in 4.9 around 8 years ago so maybe it's
fine?

/me is willing to go along with that if the maintainer is.  Meanwhile
the code changes make sense so as long as there isn't some "set the
write pointer to an arbitrary LBA" command that I missed,

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

since we wouldn't be mdrestoring user file data to the zoned section,
right?

--D

>  
>  union mdrestore_headers {
>  	__be32				magic;
> @@ -148,6 +149,13 @@ open_device(
>  	dev->fd = open(path, open_flags, 0644);
>  	if (dev->fd < 0)
>  		fatal("couldn't open \"%s\"\n", path);
> +
> +	if (!dev->is_file) {
> +		uint32_t zone_size;
> +
> +		if (ioctl(dev->fd, BLKGETZONESZ, &zone_size) == 0 && zone_size)
> +			fatal("can't restore to zoned device \"%s\"\n", path);
> +	}
>  }
>  
>  static void
> -- 
> 2.47.2
> 
> 
