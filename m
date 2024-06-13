Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59DD134406
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 04:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718254636; cv=none; b=qfSSm3D7e15XTZLHooy5kXzscXpql8H8WZ5lEXQlt1Fi4ZKGDlsg/pveGdqzH/q2nKM/dRsK17x40vymiUQi68Rw2iSoGhpDP0Rj2bjEb0F3sQaGYTILYPlBhu4ehrHFLm737QIhFvUQWVRQzSiN4nJYCT41Qezr7MMh7agzsx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718254636; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CU5hFK9rb67YNDPbqxu7sareYcCoZWPvgNstzLCSNeqqQq0DdRASKojYFBmzmyQGewty62n5XTDDcdcCDWMISdgc6WKVXozN1KkW69ANSHUBnpCPpSWtdCZ5tfPSbY21gKXmn1bj0x6UCR5znlX+DwjPznJmgY7GY/gVGnjpxQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8713768AFE; Thu, 13 Jun 2024 06:57:04 +0200 (CEST)
Date: Thu, 13 Jun 2024 06:57:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: allow unlinked symlinks and dirs with zero
 size
Message-ID: <20240613045704.GB17048@lst.de>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs> <171821431829.3202459.12883328416929434536.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171821431829.3202459.12883328416929434536.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
