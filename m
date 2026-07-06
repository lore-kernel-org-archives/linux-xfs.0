Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6DE3D3492
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2026 06:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320646; cv=none; b=ZybqbA79RNiUqsRCnqmiEadRFLe+DFFoaF9cJyz587brC3KFwUo0xoXigFibbPfosDRUTw6QL0js/daYsU5cPdvBloZuEPdi76p8R5HmgE0IaeuMejA8wkhv9RgeOM04x/2CpezJ+roFz2fGYqpX8npGwPkB82ysLOeFO3rRKLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320646; c=relaxed/simple;
	bh=dD87FaseQpkQRam5291MVYJmm4mtQvpNtMByKQxJq+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GpKzR27+UydHahGQba5804eMmUW7510bexIOnODO+KqkHF022rxg0ZPeQYzx9szLuLZwthsyr7Y2nqDbD2uqljnlNlMI4y53HxOypZI+NMMJZO/y3tcclEJ3+1S9EaCPNT1JJy+OrZ+bYFjlVMPwWunPthgvZMjtPT5xVn92FK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 85D5068B05; Mon,  6 Jul 2026 08:50:35 +0200 (CEST)
Date: Mon, 6 Jul 2026 08:50:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub: fix spacemap scan for internal rt devices
Message-ID: <20260706065035.GA25419@lst.de>
References: <20260701145124.GE6526@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701145124.GE6526@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Btw, the current xfsprogs for-next fails a lot of xfstests without
this.  So it would be great to get it in ASAP.

