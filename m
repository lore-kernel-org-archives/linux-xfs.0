Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CCE12FF7B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902259; cv=none; b=ML5AfdQZtwUax5guseBnMddLbrvVQygKgBQ1qh+0yALhRpG5Uivlq4W7ckZC0JkRcTq++CXN/Ok218icQvgJDqHtWHvc9pTdFoClSQ3Dv3MYF8X7i25w2e9xpkE4tU0mBUbryINy0PRpSPPFAGcHu7uimTRp1OUDChXxXLu2QzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902259; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Io4vHhe6JnZgYHpmbGij6LmIMGT1rgROltbnJxGrVxl1UhsNccPNiHPSMY752+YRo0IBCEpYpA6lPiAK05CZwvUOT1Y86ZF64LeFfVR3Snr516Q5oRQYumT8JBBacYfwMd+coaQR56/bINn5rWlJIJ4Ixpt0JdjzdXynQh+4EOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA6B168B05; Tue,  2 Jul 2024 08:37:35 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:37:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 22/24] libxfs: create new files with attr forks if
 necessary
Message-ID: <20240702063735.GF24549@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121402.2009260.4605471859392366056.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121402.2009260.4605471859392366056.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
