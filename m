Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47D1149C6F
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 04:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449923; cv=none; b=Aq/JuHIMe4vuPB3+TqJ0wHbHDkyxDijxWc6acIMhmCEi6Z0/f4K4yEVPKlWy5LtTE95//+tH6ahfz+DsknI2WAc/J4+I0IA8xLCErcTWwV8+gp3s/Hc3Ct7YkOqsRr4U4MJq71t70xPGnSBAjfDzHLnMFpkMwDY7ApzRcHfh2ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449923; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBdyjYN+m6E7PcjIFx2qh9k/zXQjOwW7aO6815+1Y66hqFkLGz7BeFTRqnEESElBe02bGXpKicffM34grNAFySUNt5LQvZDjPNZSIauZQVBEyjk+icS7Ol9TErVxBa5dLMaRqtwoSbpne/hB38FVFhOqGO1fHlz4T6tkk9fYqq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 54A6B68B05; Fri, 26 Jun 2026 06:58:40 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:58:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/8] xfs_scrub: don't flatten error numbers in
 read_verify_schedule_now
Message-ID: <20260626045840.GB8786@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801341.1981574.8647123518966483952.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178242801341.1981574.8647123518966483952.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

