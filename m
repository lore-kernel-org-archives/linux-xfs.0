Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3E12F385
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903566; cv=none; b=hOu7ap6vFE8mlUv6jhzPygH8jp19SsglEn+Y9is+szUZKHftiS6yh3WljdodS6h3+GEsD/31BPXyjEbjet+EPpMbTMBFDAWadgSoosA3+KOTkrP6vZToDDWfkhAMLYnjRuPkj3pKxsPv+OrWFboiOE4KjSEHzNnUOQRMH/NJurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903566; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BI4y9QozOV8YRq8zLR/3FWzkRXh5n5JbvZBwzG2+F2FyA1recgErCet3fs1+ufZqVInXRMOUJaPKoKJhWAothAJ2MQRO5H6XbnIgd4DCSlsZ2AxnazqzBCFRDEUnzNMKu54INYVp86ql4ws6fRIdReP5tNKhqe4kX49q/2QkI1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A721F68B05; Tue,  2 Jul 2024 08:59:22 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:59:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/10] xfs_scrub: try spot repairs of metadata items to
 make scrub progress
Message-ID: <20240702065922.GA26672@lst.de>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs> <171988123288.2012546.14926301961874768937.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123288.2012546.14926301961874768937.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
