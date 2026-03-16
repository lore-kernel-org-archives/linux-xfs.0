Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4293B7B65
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 15:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676565; cv=none; b=FDVh+ncL2Sk6ctJehqULk5a6wF7WBv+2tdETCr1zyx+UXUuDdQQavHbzQ/ZHd2DCxhg6o9Kv5/XVbcA5EBpp/3DSx7uiop9BCQUy9VntQAtmPwz9/+3gQB12hmOZYEURdn/TZ25F6kFds8gJbbJAYA5XDYRsXr4S5hbF2ExpArY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676565; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fge5xisU8XMAFt49QCCcpXmNb0clmNCSmJX3MF0Cfkgx2EfPE8lDnqukDjTn3iCyTSQ918/DPMA6HeaUsABfy0pAD8hHySeHiLB7gtCh94ygwu8a/EaULXFJ310MdnnAZr6LTP/cLpYg6h0oBXWVyb2I9B8Frl6553GBxvv02fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0D66868BEB; Mon, 16 Mar 2026 16:55:59 +0100 (CET)
Date: Mon, 16 Mar 2026 16:55:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH v2 1/4] xfs: avoid unnecessary open zone check in
 xfs_select_zone_nowait()
Message-ID: <20260316155558.GA18936@lst.de>
References: <20260316114020.753228-1-dlemoal@kernel.org> <20260316114020.753228-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316114020.753228-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

