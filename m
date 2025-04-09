Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3931927C14D
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 19:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744225201; cv=none; b=WaK5XbYafKQLl0mOCgEbpWlsH7BAxKuz05Uk/udZTo/wXrI/ILcpNR1xeqP3rQZTV2jSn3iF76bA0prd1vS1HfRh+IBG1i9Z0pNfmIy09T+E/H/PiYjrzxGmjOHqL0IJ8JSN8nhRSNihop46RIM/f6DIfzXQAqoYZsgLTuW3hss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744225201; c=relaxed/simple;
	bh=eTC+MS9qtfiUpgrdBllpYkLbTyzLDK9cCcKhiEifSZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3nX8BoDrdh1l3Zc40y2/7GyrwjVjE/RhPUUPJdov+sby0RXbuvUkNXhvF6SEHpeDcTIWBHdcDT6srKMoAFpd6U5HYLr99wKc/tHbcKLafcWcRmZ9D0jXqvW6QBFoKno+5SyMVp5SZoVOOySVfGLTfLKASrlusOEMqvRj98eRtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tzEaG0YV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tzEaG0YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A786EC4CEE2;
	Wed,  9 Apr 2025 19:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744225200;
	bh=eTC+MS9qtfiUpgrdBllpYkLbTyzLDK9cCcKhiEifSZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tzEaG0YVUgHjbt7W1K5b5550DcOCTfoxUYljIq37lsCPaYZsnNhfdoOve9AQ2mLcB
	 xe07+c4QG5t4UhZ1OYwo9olLUstQFva8koiP0DeafjdmiASmsfJPnekcKZzHQukfcT
	 XZucI3wVpkQnx5C9+nBVWNDbsQFpLWGW7lPF2IMfvGCSUdpa4aaMaJgqlcPZFWuQ52
	 X9o3KKUgJXpgCt+QSBhTD3Bev2a5YKwxzurlNT0avbeMdEYr3UF2BADW07yyozWOfB
	 zuYsOCtBBOx1tIOJK4gyzjNjut8DPj6NLg5GttnJLKRi5o4r+axLN6r0sYjhnRCLW2
	 g/To8KA5haUdg==
Date: Wed, 9 Apr 2025 12:00:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/45] xfs_mkfs: reflink conflicts with zoned file
 systems for now
Message-ID: <20250409190000.GH6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-34-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-34-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:36AM +0200, Christoph Hellwig wrote:
> Until GC is enhanced to not unshared reflinked blocks we better prohibit
> this combination.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...or gc figures out how to do reflinked moves.  Either way,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 7d4114e8a2ea..0e351f9efc32 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2957,6 +2957,14 @@ _("rt extent size not supported on realtime devices with zoned mode\n"));
>  			}
>  			cli->rtextsize = 0;
>  		}
> +		if (cli->sb_feat.reflink) {
> +			if (cli_opt_set(&mopts, M_REFLINK)) {
> +				fprintf(stderr,
> +_("reflink not supported on realtime devices with zoned mode specified\n"));
> +				usage();
> +			}
> +			cli->sb_feat.reflink = false;
> +		}
>  
>  		/*
>  		 * Force the rtinherit flag on the root inode for zoned file
> -- 
> 2.47.2
> 
> 
