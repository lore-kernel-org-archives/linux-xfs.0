Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9232EDD40;
	Tue, 10 Feb 2026 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737763; cv=none; b=KANMBp1QPKAo7I2TF9wNgswjBY5o5Mwp8vWS/AuaasQnNonpRDceaoz/VGpup3HJxz8F93B9OD+qUO2q7cXMC/VV5JDp4qhRubq/BsOagt4O9goTVrTiOMpb2WljaolBKumcmw5H4stG1XM/DxAGINypPOXMMBRl0USrkyTu8yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737763; c=relaxed/simple;
	bh=OXHeSid7E2DAuRdT6tbqff8RT3oU8mNyQUhvtWYyDKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RfAqYpdcVcIzMB2K2zYi1Shk468F9azayMt9dc+nLsVW5a3JaJUEOxvlEsTQqWOIhCj9ocEmZJb0JQAyJXiI5KWbnyiyMuq55Juu8/evhFhtCbMG5Ah61rx3h019tSPznN55vfeK7VirAdSPTG8Jf5fRDikLt3BcaM0R7n5DxAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3607968CFE; Tue, 10 Feb 2026 16:36:00 +0100 (CET)
Date: Tue, 10 Feb 2026 16:35:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH v2 2/2] xfs: add static size checks for ioctl UABI
Message-ID: <20260210153559.GB31245@lst.de>
References: <20260210055942.2844783-2-wilfred.opensource@gmail.com> <20260210055942.2844783-5-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210055942.2844783-5-wilfred.opensource@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 10, 2026 at 03:59:44PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> The ioctl structures in libxfs/xfs_fs.h are missing static size checks.
> It is useful to have static size checks for these structures as adding
> new fields to them could cause issues (e.g. extra padding that may be
> inserted by the compiler). So add these checks to xfs/xfs_ondisk.h.
> 
> Due to different padding/alignment requirements across different
> architectures, to avoid build failures, some structures are ommited from
> the size checks. For example, structures with "compat_" definitions in
> xfs/xfs_ioctl32.h are ommited.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I couldn't spot any whitespace issues either, although I'd personally
drop the last empty line if I had to nitpick.

