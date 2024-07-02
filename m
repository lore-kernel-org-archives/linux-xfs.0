Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062962B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898779; cv=none; b=XlPObPcpGkV9CnJ4dcO4DitzfKxFAtNhPFN2g/qrePJ+Ltv8k04lDFIO2McD5Tu+g2OLYnNLUZeabu7df8WVqb512D8I8tBgVQWbDThpWK4W5iIy7wcIkt8DNXGwJIj1xafVU9S/FAzem4YqvOrnZn/5Ex4SIioJ1xMsve405xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898779; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ji9Yu0J1o7M6xgpBIujHxCf5NQ3lfJfVlWcOP9Y2DCxidR1bgq6GAjHzsqoRCmFdsWC/MrdFWY+NSlZH108Xg0hW+qTO6xuBkXtdUQYZDFYxDmBv/7riVZOg7EWgbqnf0SDN1UHtXgZXVBgKpR6VDpbjINxMEh7DWPANiH2qmwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 55AD268B05; Tue,  2 Jul 2024 07:39:35 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:39:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/6] xfs_scrub_all: trigger automatic media scans once
 per month
Message-ID: <20240702053935.GH23155@lst.de>
References: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs> <171988119485.2008463.18281382305199915261.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119485.2008463.18281382305199915261.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

