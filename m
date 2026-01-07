Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033F3185B48
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 06:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767766598; cv=none; b=rypjYScZy1FuhdLSXuXzr8jxR5cK3QsGMlqWdojnAJgHJwDW+gLxF6o4zHebg4vPUFfPHWpSWs2KcQzjvOE8c1hTGczAR7kzq1bWE30hOa2+1E3es1nMaOGM5XWOsxX4/oLlTxvR+yMHypnM1dNJhByY94tT+I05Ii9Ro36sUnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767766598; c=relaxed/simple;
	bh=zy8M2AlRiYZpE01k7dOFF5VliN1Tcy8SZsc2ePr/kNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpxENw3U5s1WSQGGgqjnlHD4FKOm7FRTQEVeWRoJhI4Qx5ygrRnCiy1XitkbczCRFckLVav4zivRz3IRiwAIIi+etPZj/lELZVMAHXC03D0Kr6g99wzYDeB+nsMinz+2Al7UXboJAdI1nboxqFKBaeHDE5oAllkdx5KMYw8FX8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aFNUQjbH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aFNUQjbH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3ssmoakX/J2h3RceKMvGHDUKfa/9prwSdrcSuXA9GKc=; b=aFNUQjbHTsfyaE/ylBiBRYkLv+
	JWwtV5FQtz53yHVMnHwkGNICFurE8Yi0N4Pyh/PnoaKdkTqtV7FfxawpxBzQ7bvPzMQxX9mFUOrsD
	EI14pEX9nluR/rhw2cdnLZsCiBaHwA3qYqHyxzXonKk0cdoSfEBstOYtpgDMgT6z3+SjJhwtWxqI/
	uFEEwndyngytsB5pADY5hzkHqwL9h5XGdFfR+yHgW1DdCfnAMUSbpxW5oXTvwo0nla82yfEg65Ttw
	JCyyOqFgUqMKjjcsNH1sh2Ups+pwwn6QOlDSV4UnbS5ekHAK4+qL9a8DcXgDMfiS/hCSl+5HBqvxx
	OYCzoNIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdMqS-0000000ECk9-1raW;
	Wed, 07 Jan 2026 06:16:36 +0000
Date: Tue, 6 Jan 2026 22:16:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: set rtstart from user-specified dblocks
Message-ID: <aV36RCNPxZxl5nZx@infradead.org>
References: <20260106185314.GJ191501@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106185314.GJ191501@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 06, 2026 at 10:53:14AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> generic/211 fails to format the disk on a system with an internal zoned
> device.  Poking through the shell scripts, it's apparently doing this:

On some anyway.  We've had this on our CI machines as well, and it's
been on my todo list why it doesn't happen everywhere, so thanks for
digging into this and getting it off my todo list :)

> # mkfs.xfs -d size=629145600 -r size=629145600 -b size=4096 -m metadir=1,autofsck=1,uquota,gquota,pquota, -r zoned=1 -d rtinherit=1 /dev/sdd
> size 629145600 specified for data subvolume is too large, maximum is 131072 blocks
> 
> Strange -- we asked for 629M data and rt sections, the device is 20GB in
> size, but it claims insufficient space in the data subvolume.
> 
> Further analysis shows that open_devices is setting rtstart to 1% of the
> size of the data volume (or no less than 300M) and rounding that up to
> the nearest power of two (512M).  Hence the 131072 number.
> 
> But wait, we said that we wanted a 629M data section.  Let's set rtstart
> to the same value if the user didn't already provide one, instead of
> using the default value.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.15.0
> Fixes: 2e5a737a61d34e ("xfs_mkfs: support creating file system with zoned RT devices")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |   31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b34407725f76df..ab3d74790bbcb8 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3720,17 +3720,28 @@ open_devices(
>  		zt->rt.zone_capacity = zt->data.zone_capacity;
>  		zt->rt.nr_zones = zt->data.nr_zones - zt->data.nr_conv_zones;
>  	} else if (cfg->sb_feat.zoned && !cfg->rtstart && !xi->rt.dev) {
> -		/*
> -		 * By default reserve at 1% of the total capacity (rounded up to
> -		 * the next power of two) for metadata, but match the minimum we
> -		 * enforce elsewhere. This matches what SMR HDDs provide.
> -		 */
> -		uint64_t rt_target_size = max((xi->data.size + 99) / 100,
> -					      BTOBB(300 * 1024 * 1024));
> +		if (cfg->dblocks) {
> +			/*
> +			 * If the user specified the size of the data device
> +			 * but not the start of the internal rt device, set
> +			 * the internal rt volume to start at the end of the
> +			 * data device.
> +			 */
> +			cfg->rtstart = cfg->dblocks << (cfg->blocklog - BBSHIFT);

Overly long line here.

> +		} else {
> +			/*
> +			 * By default reserve at 1% of the total capacity
> +			 * (rounded up to the next power of two) for metadata,
> +			 * but match the minimum we enforce elsewhere. This
> +			 * matches what SMR HDDs provide.
> +			 */
> +			uint64_t rt_target_size = max((xi->data.size + 99) / 100,
> +						      BTOBB(300 * 1024 * 1024));

And here as well.  Maybe split the sizse calculation into a helper
to make these a bit more readable?

Otherwise this looks good.
