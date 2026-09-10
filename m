Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA32C35F8C9;
	Thu, 10 Sep 2026 09:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033516; cv=none; b=nPrlKhzoXAv3hw0mV835hTREvvXNnouLz9rLXkkRrtD0SXe4U07OCD+SEWzx8DvrH5WJFtCtGTfgUwIk62jK2rTg4NuEIL2E8rtcfr1VY32hoe9ViSDReT9w4HyYTu+mmlBRMPjlEW2h/EKKnrk7sew2cMo+SU94g+R2M44+C4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033516; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lITFPuGPFx2jJBSO9s5EcvJaXwrF8wPIjlUdEn0OPcXTaykOiJNWiit9COufsITxWoAABdOOX4aL+y4q3aGIjLaXInujFL1ig7dRTQJDWp6q6JsmvcYT7B/9FJeGJdj1WNDMz9w+BnNG37QRF0CeNyE9QfCjJQDTIklAD8jhH/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C4C2168BEB; Thu, 10 Sep 2026 11:45:10 +0200 (CEST)
Date: Thu, 10 Sep 2026 11:45:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: fix attr fork block count checks in
 xrep_inode_blockcounts
Message-ID: <20260910094510.GD5330@lst.de>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs> <178901989892.361651.4678916214576712344.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178901989892.361651.4678916214576712344.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

