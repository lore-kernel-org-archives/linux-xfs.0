Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2903DD537
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389126; cv=none; b=Rgb8ZfEsFOe6nhXlzMet4NIB1pFQ+ksUZOvcIKtbQvC+MmvsdIx+G4hT6XxnLPEAFHIfWoEL3K/QppZ2HadOEIRAULyzH2bFu2wocu2qhrKzQ2qznHcqCRsDDainM6AEZ/ivv+dLB8rgMW1FaJb9rvk6xJwB+c9MFCYvNj5xRPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389126; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHLvu/ne6Qen5RfTJqx73fUentcTno2TRGpTaxVRgGH/e9L5a5QqO8shlxZHbLyH2RBGPutJEqF14OyEo6UmmNF2hHLlhH2h5E5iibp2mQDYERPfJzvhS6o0tWnmDx1QaUp27apESaF0q86YvltcKhlNsNKNwfEMwHnO9gSc6qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 33FBE68B05; Thu, 25 Jun 2026 14:05:23 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:05:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs_scrub: report external log space usage in
 phase 7
Message-ID: <20260625120523.GH18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484568.915780.126389403172696544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484568.915780.126389403172696544.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

