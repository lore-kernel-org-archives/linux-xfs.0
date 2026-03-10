Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B705E397E98
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147205; cv=none; b=hS8r2Tmg4o6pxVEM13Bw7osFvHgA2B/eZc1/ypgAA10z85PKju5QBhuOh4QnE6ElFxc6BlX60ANulTY57NeDnZLIz2lHWLFAPq27p6qZwPHPt92Vxn+/AfwjXCnK9jC9ZEz51/qvtC63DFHqNIaxlRuoMaz+TanYXNK6UYChCqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147205; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ph/g1aNYrQ15gFTQOYciGlfOCnysrDCrVvwFCfPIz2UH0Mof2gTCqIa9T8CGdsgDKf960dGzzFp5Est3e5PD3iJFHUGhANWYgxnJfGtrqRoWXv+LWTrH9guJw3vhzH1C8Hx8FIuPIMzq4+Wi2Xvf9PwOV8EgkUV4uPAR0+yUGVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5924468C4E; Tue, 10 Mar 2026 13:53:21 +0100 (CET)
Date: Tue, 10 Mar 2026 13:53:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dlemoal@kernel.org
Subject: Re: [PATCH 2/4] xfs: move zoned dio ioend to its own function
Message-ID: <20260310125321.GB3323@lst.de>
References: <20260310115555.114197-1-cem@kernel.org> <20260310115555.114197-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310115555.114197-3-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

