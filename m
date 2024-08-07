Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BDE84037;
	Wed,  7 Aug 2024 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047160; cv=none; b=EbfBfDkjD+iivbLRQ1U5JMcdC8MKqz6C7TNhPuyxSxzyx5U+jqVUFxOpz/nrvLXn8+YSOxduhjvtB7I+pDEhFhA07kXg7pPKuVOPM5mdPSbB71xSUB+bOgma3L4BitPkuPKW5ITFlzacrPh+qcS1tOlbFWT5eZdCdX+kq/JxFHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047160; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/bb9TW5fSBsKx2yhLOm3eobGldrRLXpis02haUq5iqMiShWX+/Hb8ir8QeaL04DLC7Wkvi/bk3E3sFA9j+ONH+5kkOh2QTvAXiM99RNXK9x9PvvkSwhlMs5rsYm1Gtup/ijirWPd9BoSq1aVZftivm168qn6LYdVYlhfcoIt+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C913768BFE; Wed,  7 Aug 2024 18:12:36 +0200 (CEST)
Date: Wed, 7 Aug 2024 18:12:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, dchinner@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_scrub: use the autofsck fsproperty to select
 mode
Message-ID: <20240807161236.GF9745@lst.de>
References: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs> <172296825643.3193344.4511195350690630042.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172296825643.3193344.4511195350690630042.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

