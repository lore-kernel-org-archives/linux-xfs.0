Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B275F25A624
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 04:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738644830; cv=none; b=QQMWSVJYF63McZ5x6AUFWR4ILrqG4fwy1yvRwiIx1zvRVOwCFm0Ir6gG2zrkd3uUVqjeb2+BZoEFxXotibTEJGwD9srcQMmg0+ULvE+BQ10YhzCGLP7zGBJpRt3YKBkDpl7ppj9nArkmla/sNfu50V7II32StVgmWEJE6dtU/9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738644830; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AD8k/+ghg5plOM/aC86lGvO0O5HFcfiME5X6cHzXyUeZIEivmj+73Dzv85TO6cmVFx27fVV17lOXS3M6a2YW94Yi/bbLN0MIv8rOFPCjEIVn1cLgvlTjuYWNQ68HhXaUtwFp+Fxv6uJfXOU/LYB3F721q5o75UXZ1IGIRfeLlPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A050068AFE; Tue,  4 Feb 2025 05:53:44 +0100 (CET)
Date: Tue, 4 Feb 2025 05:53:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_protofile: fix mode formatting error
Message-ID: <20250204045344.GB28103@lst.de>
References: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs> <173862239063.2460098.16773056715229696499.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173862239063.2460098.16773056715229696499.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

