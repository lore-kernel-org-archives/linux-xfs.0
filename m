Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17A8333442;
	Thu, 16 Jul 2026 08:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189961; cv=none; b=Coulexu7eUb9HcT1/90xuRLMc4gW+6dSnlJlGXYq7iMw0viSXhKn+LYytvIFk6+mjWGaaHWZi5G4XfiHpGbEStxMhz0LeYMqZOtp3MRz5iO6k02u1GWEGUThYpJsgCrETX0XXuWBEc6bZpaikADJqHQuOwQOMGrFDcvb/SK5aFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189961; c=relaxed/simple;
	bh=98E4alRzTlKuUkjEIjHKVA4L4/sZJSCJDfUbUMOeUDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AiPmUw50td8HxLSzugzEvcMLQBktHDNVPlm5f4OFkJY7JTPcryBMSSdf8ZrZfThHItrUsHNdprXFKS7IkG+TixUUAvFs6CmlTZ06Kk8nx4mb/aTyP1c7RXbsAJOzY0s9M7TV5G4aY4vpuKN+ORvo+7DNhcSNcbyaf5cyTrXgUtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2C4DE6732A; Thu, 16 Jul 2026 10:19:17 +0200 (CEST)
Date: Thu, 16 Jul 2026 10:19:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: rtsummary scrub should treat rtbitmap
 corruption errors as an xref error
Message-ID: <20260716081916.GE12330@lst.de>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs> <178416797424.2008054.49983972584839221.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178416797424.2008054.49983972584839221.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 15, 2026 at 11:06:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notes the discrepancy between the comment saying that this is an
> xref error and the code, which marks a (non-xref) corruption error.
> This appears to be a regression.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

