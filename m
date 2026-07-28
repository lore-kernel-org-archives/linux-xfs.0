Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CCC30C366;
	Tue, 28 Jul 2026 03:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208220; cv=none; b=i/Fmf0vPQTpHP6Y5g986TfzDGJqykjQzlP404q6zIjrEaqAb+r03jLha6X+vk4pByAd1JdFiDLIZB1X4mpZJbB9hRUBCYSltOLvwsr4jjCAUql6u0lDXGPLkEgee5TJ/XNFXsiJQ8xzlOG/IFVJSyXnl8PITOPpFUCAd5rB+zlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208220; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlXSAthMZRiB6srJab8G4VMbJXAZJDvC/nmaZ8BF3+njXaF7Vzl/HGaCknjFVe5jlGE7X2Vcp/RY0fH7e9ucOoPUrWAAX35/lhlGGBO8JvZkydSeBV5hDeqstUJBqnCAkW/Irx2pD6PAIctCzDFWIYsi9vFyJOC/ReecnOB8cd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD65968AFE; Tue, 28 Jul 2026 05:10:15 +0200 (CEST)
Date: Tue, 28 Jul 2026 05:10:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] generic/563: limit loop device size
Message-ID: <20260728031015.GB18364@lst.de>
References: <20260725070412.1636557-1-shinichiro.kawasaki@wdc.com> <20260725070412.1636557-3-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725070412.1636557-3-shinichiro.kawasaki@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

