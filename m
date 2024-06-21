Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D8A23A6;
	Fri, 21 Jun 2024 05:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718946264; cv=none; b=hHbyNTn6AlRXYMlf8NFOt3fn3A55uPXpuac5UuLht+cNh5mGVrspCesvHYHmz4WD7zEGVe7/hemLeqVIWQDYWSQ0aFFca3mJuZOYybna/dTRytQRZG9veAlE1tx5tgfke0bXNoljLM/s6Y9BV/6TcRXHt0bFDt8Z1j9y5RGWftw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718946264; c=relaxed/simple;
	bh=37QLXp6c5jPmZedf93VT/zOJSFLVh3VXENAd1qxjaH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIGjPdARFxhlBOCJBntVo7hohWeJSoxmZEmYo0XfBu5qurGcldnp4T7ZLDpingLJs1hjXFTZ6m6nyi5+drNXJWS/3T0FJo6V2JKzdxPuiKw+eAobtJBa6h92g6Rf3xuK9caQMkiyoNY1+1wxbHdiIMhZc4nrBuJqVHdbP/O4r/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BDAAE68AFE; Fri, 21 Jun 2024 07:04:16 +0200 (CEST)
Date: Fri, 21 Jun 2024 07:04:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/073: avoid large recurise diff
Message-ID: <20240621050416.GA15463@lst.de>
References: <20240620124844.558637-1-hch@lst.de> <20240620152306.GV103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620152306.GV103034@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looking at the reply I noticed I misspelled recursive in the subject,
so maybe this can get fixed up when applying the patch?

