Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DC91E1A3D;
	Fri, 23 Jan 2026 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769177786; cv=none; b=CB53jG3n5JfwAtmlLKOI4jYsJvX/lTTc6A0ovQCSqVbutSdlL0Ich308rdrFUaLIpTuIincU56KFQ3cxxured1Az7nV81fzCA6/91tj8l7EsUZiyu//hw9Y6NVAlKg5A4qJgygUuMj8DHizc7nlDqcpRDaOyQLOrwt44Ci+G3gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769177786; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3vWOZt4HXOysJ8FZf7JVBYfBfQRlZZs+RQPV//Blzq7vqREV7Fdme17SXmBkBDYbs7/EWxedjlwY4PMgO1ZBvA0JFX6WGMxCzVSobnz1c//6CiOOggO7uxk5yxRIEA3DTfCasxn6c6QWSm44iyTqjtH3JYblmCBWiLM5Ppdpbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AC8A4227AAE; Fri, 23 Jan 2026 15:16:22 +0100 (CET)
Date: Fri, 23 Jan 2026 15:16:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, r772577952@gmail.com, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/5] xfs: check for deleted cursors when revalidating
 two btrees
Message-ID: <20260123141622.GA26012@lst.de>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153803.1677852.3768821466518761768.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176915153803.1677852.3768821466518761768.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

