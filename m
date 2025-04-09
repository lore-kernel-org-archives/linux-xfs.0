Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE3D1DFFD
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 18:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744225162; cv=none; b=pow4/mZsqyDoMKNC89Ftqg6A1SGVrOEUmO+RJv6qqMm9IZEavCLrs0h86OvK/Efjk/ALCp7cPEP8Hjk3W3AEZ7VHMsoIVourZK5YBTjmXApvh6SmImnaj/jhHGJtybHnBv4L/wTO40j/mCIQPxoyzPARrUddcmwoXaxlaxxdKW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744225162; c=relaxed/simple;
	bh=GykXIwzo0nDHv6SWyWsEpY6faDPwxYK2yGvITIYnuIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8ms7RQRRxLHvvNFWfTomuc2aH4BL7myfT+wDA4ZR7TN/RL7NaZqvkOnDo8li25JGGSo4pPx6MvG+j5U0fwqJti64IO5ulVqQ11hB7sri/csNKBcuamrRitlyvqcvvtmOCp6KAoS+j+rVoqd++4i6TV3XyX1QMiHv8SRHhTlxd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLzMn2KB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLzMn2KB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9BDC4CEE2;
	Wed,  9 Apr 2025 18:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744225161;
	bh=GykXIwzo0nDHv6SWyWsEpY6faDPwxYK2yGvITIYnuIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLzMn2KBR2RnnFaNTsksgRC/vS1+ug5U6X8HKq5ZytCY5PjOUpwIg9iPZxR0Qs9b9
	 eptaMXFHcxvI2C51yH14o1WuPahgpgjq9+MItRiXhWm+eGNjklSuXSAKvBFJTTaNh+
	 qqsgalxmE7aDhdDqT3M7ErWneJDP30VhY5FO6J4kDaYD71Bq9anWUUFphHzVDxk4xg
	 JYhHPOfZWPJq/QzEn+ejd9CMXWPXfukWR6iNbKalyRu+hOYEzteIHnkrSBuLzuhcS7
	 mBxqE+wtqJUpiuFtu1sEGUhnnqFvNOBfVPdgmNNPUOv4y/AovBEdNkge2a8hAtnoRD
	 L8wqpcBKJKovA==
Date: Wed, 9 Apr 2025 11:59:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/45] xfs_mkfs: default to rtinherit=1 for zoned file
 systems
Message-ID: <20250409185921.GG6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-33-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-33-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:35AM +0200, Christoph Hellwig wrote:
> Zone file systems are intended to use sequential write required zones
> (or areas treated as such) for data, and the main data device only for
> metadata.  rtinherit=1 is the way to achieve that, so enabled it by
> default.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mkfs/xfs_mkfs.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 6b5eb9eb140a..7d4114e8a2ea 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2957,6 +2957,13 @@ _("rt extent size not supported on realtime devices with zoned mode\n"));
>  			}
>  			cli->rtextsize = 0;
>  		}
> +
> +		/*
> +		 * Force the rtinherit flag on the root inode for zoned file
> +		 * systems as they use the data device only as a metadata
> +		 * container.
> +		 */
> +		cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;

If the caller specified -d rtinherit=0, this will override their choice.
Perhaps only do this if !cli_opt_set(&dopts, D_RTINHERIT) ?  I can
imagine people trying to combine a large SSD and a large SMR drive and
wanting to be able to store files on both devices.

--D

>  	} else {
>  		if (cli->rtstart) {
>  			fprintf(stderr,
> -- 
> 2.47.2
> 
> 
