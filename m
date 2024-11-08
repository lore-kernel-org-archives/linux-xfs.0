Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EDF1E1312
	for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2024 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731075438; cv=none; b=FOc9q4SnfOnfvE3ZE3W/t/ykAWJzamkyQBrKKVm1ASaW5CRGMuWsYWMdruq+0xlMLIPjdP4GwKq2sNi6TGBmMziQ0YtIJQD2KkvqLGFxMGJdCc1AN8HkBacejSww6TLWaeqkFWc3dPWnzUa6C4WsaqPyv6hhwIAkq/COwtcERcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731075438; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGjUsrlxjg4Y2Au9MBBaXmhQL58LIXe7ZAZBWvBVb5PHqWu8gxpnmrRsD9W7/usdTXksNl3qfkzcZQnZqVd3trf93qS8ytTp/Msb1mgqvNIbtfCs7OTWRwIUF2LRAC/O1yoTSCbsXh8P4XHNElnhbf07u2mslMH28GAEFS3kd30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B364468AA6; Fri,  8 Nov 2024 15:17:13 +0100 (CET)
Date: Fri, 8 Nov 2024 15:17:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] design: document realtime groups
Message-ID: <20241108141713.GC6392@lst.de>
References: <173102187871.4143993.7808162081973053540.stgit@frogsfrogsfrogs> <173102187904.4143993.12297769468086669521.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173102187904.4143993.12297769468086669521.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

