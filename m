Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C85B3B5DED;
	Mon, 17 Aug 2026 07:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786950663; cv=none; b=hcgjKmA++PneyxCs9ixUI32IDilrSV7h/F6dijA8mY+P6Nh6qrHQ5+qozJu7qK+Jqtr598Dr4l2YHoYB3EDxKDRZfZSXaHPKKI8hC4lW0Pl61cvXuAY3uStOZdim2V3KtUg7vAGIpDOkfahBXH2Wgp1Fh61e0vc2x2edoytfAkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786950663; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRA1pGNRiCqgOawGMoXNXxiMhB4wjLUr2dOW+DdDiZsNiC7QMay4A1MrioxLdBnEXfSI+VWFYpyphVpmwRsR2nQrKZWAxoOE/TgN4+G1tIbISuZAJkxuEe1t20iPtxWW+v9GokIzrNdtBtnF/chFH9/5v0RTq2R5VdzXxygmW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2E11868CFE; Mon, 17 Aug 2026 09:10:56 +0200 (CEST)
Date: Mon, 17 Aug 2026 09:10:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org, ebiggers@kernel.org, hch@lst.de,
	Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	david@fromorbit.com, Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v15 16/25] xfs: handle fsverity I/O in write/read path
Message-ID: <20260817071055.GC17371@lst.de>
References: <20260814092448.1818082-1-aalbersh@kernel.org> <20260814092448.1818082-17-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814092448.1818082-17-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

