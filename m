Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AE6DDC1
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818252; cv=none; b=bcw0oAqSFVfkg5wA4c2b6nbBNeHUMgf2fiQQxhtGKTylGICg+/45vMIZaYK0vZxNqqPgEYYK3BRQcB3IyeBGGnDI9Xj3kpLmve0PTbmYhIr/p2McGvWJLEuTjv0xWCy9ZtSBPXEUOzxwWifLCSp5XcVp92qrtwBoECPHTiZk0Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818252; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AsrTNvYqa9qwOjFwD3qhBNJsESgzt/YXxzDpWDDmd5SUfscNWwkjjLZ6deQRsfGgrH7ha/iFu8tsxeDrlVIizl+EPtDKbWV24jsHlmgoMZFqqe48Eb5qtQ3uzHTFaD7ucwcjrbe0v0A2kjLROOU5Gfn+ybQyYWZROJB8VMN/Wvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ACF87227A88; Wed, 28 Aug 2024 06:10:47 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:10:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/10] xfs: fix a sloppy memory handling bug in
 xfs_iroot_realloc
Message-ID: <20240828041047.GC30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131555.2291268.18437550031190966427.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131555.2291268.18437550031190966427.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

