Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51F02B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898795; cv=none; b=fiOsoy3mtKH1u40cCBOZlMHh8328OY6ZP964r8f5Zcni7obtopnJ6Mr/fIkFUGDcZRwbVfeR4kRr2EbA2Bjk+hiKmHBEXiwOjMpN3ZXUOio3hAVpGf+QXBxXV4asTMML6qgEJ5bMxq+1ad8PQGLHP058gXw422grwRCx7TwLLnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898795; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZZ/uzibknoOyhBaQ/284P7YZRgjXxkRlz8WRNbi/tZ+Cy3e6SLO1PE+Ht3Q4c4hsOafh+K0goweKIWrQNa38OW9hl08S2m4Tw8SX1RGcTFW4PAJt5MGuoK0a4UFNmQsOOCmPAa82FAYryIBIn05lVTAqEN7dJ13Bk5cxdjNqfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 298BE68B05; Tue,  2 Jul 2024 07:39:51 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:39:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/6] xfs_scrub_all: failure reporting for the
 xfs_scrub_all job
Message-ID: <20240702053950.GI23155@lst.de>
References: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs> <171988119500.2008463.4413433891113523167.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119500.2008463.4413433891113523167.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

