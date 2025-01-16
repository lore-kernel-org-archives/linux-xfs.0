Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1248E4A01
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 04:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737002249; cv=none; b=EUAfC9PQz9qU2QfNUnLMsHEjxonE/pEfyDo3qoEPEJaw24ZgFXSO3qb03eAsyPmyHthhK0B3htlFrW7KrcSTxeLnG3CY2NqWfatxTQz3hunkkTYm7pyrAQf++lI7FU/oGGR8Ld2FF32ir06Gz/8Yas0gpuhEbdwgFOChqU55P5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737002249; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7byG2nzFJMYV9N/pXiqyoCN//FeGg6WNvGzCR36RKtN3WoGpMH9GUBDxFY7UKmFLVl8Ko7gRJ6QS70J2TASiwDBmRACuHfBetkw8cJmTLOC9rb82NlYCudVVw4Z3J0zl8ikwl5cxKRS1KtxnfWs/r0dk0cGVr9pdHCRqK3YZ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A40C468BFE; Thu, 16 Jan 2025 05:37:23 +0100 (CET)
Date: Thu, 16 Jan 2025 05:37:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] xfs: fix data fork format filtering during inode repair
Message-ID: <20250116043723.GA23210@lst.de>
References: <20250116003637.GF3566461@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116003637.GF3566461@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

