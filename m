Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B4D7484
	for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2024 06:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719470144; cv=none; b=ki2GNKQ5EUvx7GmQIPD0/ZlwwrYnusxnEHH+Kjrqg4QJ1rXzmR7CS61lIlga74Kmea15e5nd5i4+Rzvd0NRwjgbdPeWLSN7si+c4U0jfS8uy+tF2MH//s7rqJYwOsXrLPn+gQana5FOd6NXVS7mh7hVZkOpso0ZlxGaOoNAs9b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719470144; c=relaxed/simple;
	bh=5TviLVH3wVwogDSwuFM3SHAWWJffFO0jKGNMJ0aYCRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWJwbcOO6fchEsJhMtGmUvD5yz1tSGQVN8F8oh9prn6+2+wY0ZzQRG9LYGpBLRv6ku0fbdtjfYlzMz35VkZEf6R3BapDS3mnpX5b5l43zHl2i7rK39GsMx0kuItoVwoNtbjr+G5+D+g6H+U6u3pVPcAS8RqreHq0lqLmnsNa/R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 79C5268CFE; Thu, 27 Jun 2024 08:35:39 +0200 (CEST)
Date: Thu, 27 Jun 2024 08:35:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Konst Mayer <cdlscpmv@gmail.com>,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v2 1/1] xfs: enable FITRIM on the realtime device
Message-ID: <20240627063538.GA16531@lst.de>
References: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs> <171892420308.3185132.6252829732531290655.stgit@frogsfrogsfrogs> <20240624150421.GC3058325@frogsfrogsfrogs> <87y16qhp4a.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y16qhp4a.fsf@debian-BULLSEYE-live-builder-AMD64>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 27, 2024 at 11:43:42AM +0530, Chandan Babu R wrote:
> Darrick, This patch causes generic/260 to fail in configuration using a
> realtime device as shown below,

It'll need "generic/{251,260}: compute maximum fitrim offset" from
Darrick's xfstests stack.

