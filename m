Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD4F28507C;
	Mon, 25 Aug 2025 07:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108097; cv=none; b=nLvI1M5c1Nbq5MxeHzZZaFRWCon5R0zUM0Qw850bQ1DrrSrV092qEUNy7mXbbFTOu55hEsAoszCz/7Oem3KrXFgOiCvoGgrBG7awg5HWq6ssWt6qnnC0CkJD60t36/yc4Iom9e4tXR9HgaNjHMtpGbKr8ALsqG7lgz6IG5Ia48Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108097; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BV3LpMwWb4y1kF+BIdqsO8Mym8SzZa6GdyRiyIIZfybunWwrrG2VXMjtHHMO4VLXZwe4H+wUibr6GdWo2GQSMw07WyzjP7kBRVgAbJQb4yG6bJ0yYJK2Dpcb6sfPoXieqeHLoAmkUzr2gSb5WlvKJCwGGeDxvajqWcAR/VhJQWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EDD4568AFE; Mon, 25 Aug 2025 09:48:11 +0200 (CEST)
Date: Mon, 25 Aug 2025 09:48:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, snitzer@kernel.org, axboe@kernel.dk,
	dw@davidwei.uk, brauner@kernel.org, hch@lst.de,
	martin.petersen@oracle.com, djwong@kernel.org,
	linux-xfs@vger.kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 4/8] block: simplify direct io validity check
Message-ID: <20250825074811.GG20853@lst.de>
References: <20250819164922.640964-1-kbusch@meta.com> <20250819164922.640964-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819164922.640964-5-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
