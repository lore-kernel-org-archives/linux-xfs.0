Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DAC2741AC
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 08:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744704565; cv=none; b=CMbw3twQCQLm8FzsppijreYX6oRvE+5RwWsov81ddKoYBe4klV5YXqNxMoHbDWPaY/MnKLe9phAR3BpTPRZeyn/cV3Rn/PzW66EY53h5fwnWzzPHhY+7WlPlXyd67hEnU61uJnYUu/DhN+PR8iha75bkl/iG/692MPVq0TZMCc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744704565; c=relaxed/simple;
	bh=RcTYdYRgSuAG6N0KlLsXeAeadpswvZAkWA2V68M+9ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJPTgiX51nf67jOa+Vbma1N4xh2BBoVpKI2+196w+M9oEi48ZJRXuMDQMwkkseu1fTkTV1V0NFsonp04NGWYOU89I5E6AJ75MsxOmkrqowC1o0THBWrOCZEDJSfqES4q8pcqoSVfkk30fo7Z/5JEnNCclfh49+tAP98SMxEx2wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9443C68C4E; Tue, 15 Apr 2025 10:09:12 +0200 (CEST)
Date: Tue, 15 Apr 2025 10:09:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/43] xfs_mkfs: default to rtinherit=1 for zoned file
 systems
Message-ID: <20250415080912.GA7717@lst.de>
References: <20250414053629.360672-1-hch@lst.de> <20250414053629.360672-34-hch@lst.de> <20250415003705.GJ25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415003705.GJ25675@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 14, 2025 at 05:37:05PM -0700, Darrick J. Wong wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > inherit
> 
>   ^^ Not sure what this is, but assuming that's just paste-fingering,
> the patch looks ok so

This was me squashing rather then folding in my local fixup for
your suggestion.

