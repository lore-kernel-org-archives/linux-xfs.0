Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95D93A0EB3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 06:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780382053; cv=none; b=sKBYyeSuhAuLAmo26nQh8VvKV2YmVASOXFmJ2Do6cVe/+DpEi5Pu1jkrSl3yL/7eP2mA/BgA2BjH+OTzyT4gw960jDmKmNGzYd518iRepjbIWP+VKelh9iBNaUvL+Va/ydn7SoI4ifWXpe4sOyRNFUrp3h1aVABPgRkUDsEbG5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780382053; c=relaxed/simple;
	bh=/UxuRMgBrioRB9BwSRTSIOPWKrspG0ZGJXaWpQZAtjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WobAjgFDRTVJkEbXsumD99WZMAy9pltCm6hVE63pq6N0Yfgk6qI3iGqp9BS/QibI9IYvSemdiyS1MjhVRlahOwNtiKQIOmZSNbCxhplT7+MP6wWA5J+2gHsNrbzvFXRSDoJeRew/GCg6tsLo+0PFwEiy74GxH79xc1oYew6WdnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A787168B05; Tue,  2 Jun 2026 08:34:09 +0200 (CEST)
Date: Tue, 2 Jun 2026 08:34:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 7/7] xfs_healer: coordinate access to
 weakhandle::mntpoint correctly
Message-ID: <20260602063409.GG2185@lst.de>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs> <178037627172.588879.10288701801654311276.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178037627172.588879.10288701801654311276.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 01, 2026 at 09:59:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex complained about a potential UAF in the weakhandle code if one
> thread is walking weakhandle::mntpoint at exactly the same instant that

The :: notion here looks kinda weird.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

