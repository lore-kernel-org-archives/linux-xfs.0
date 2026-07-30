Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C323382F0C;
	Thu, 30 Jul 2026 08:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399982; cv=none; b=STXZM2x0+Nxv7e/Gp5DWIvOhIRedZ0Cow78fmH5CBXhiGg1kVzmqy0kKFFRuhmalXqNYML3NzAdCKUgG7fiJc6oAcVyYuacqPPF1nHbhdaJw8Vl23m0CjEEScffEM8P4PCwMVjY+AEWL1r05kAsKpGwEkrSC8UyAayhelBlF9vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399982; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ch7ST/GkMgTOuqdJyoGBsKq2Jzpu6JBIv8x9GUOStbTyJ7EizHFKUaXQwVEVEvoHuO4Q3aKdY/Kq/cxd17nbdZP/FADtkOAEX7d5BXBG0KhJ/660viVRtxy1rldmzg1/bDFav64AtLuxmu2pGSNwDmsZ4XYx3EcgrSOKjQ2JST4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93D0168BFE; Thu, 30 Jul 2026 10:26:17 +0200 (CEST)
Date: Thu, 30 Jul 2026 10:26:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: fix the rtrmap and rtrefcount
 _maxlevels_ondisk functions
Message-ID: <20260730082617.GF10558@lst.de>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs> <178538913008.4070956.1052714188976376785.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178538913008.4070956.1052714188976376785.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

