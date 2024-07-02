Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4323F6BB33
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897335; cv=none; b=BOU275AZWjmgZVI8VZmvI2aeAfS7yMy103FS9JvmUpbhUIN8V48CS3V2hMzOWAByu5TxfXJ1hzZY/8Bvc9bvwAkVT/wNd/MTEPUIXiOoqQ6VkrmdIL+vioVpvd+54JlZdZNzlediNZ2kuojDgeuAErYPvOJX8thn5riG1kxNj/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897335; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRsdjVSZLFuZt98TSClzcJd1Tgal8W2JW9ONNWFIQX01WUVN9DsnoW7oxgOoR7pNs1VCfRA9yZuJ+54ehjVYmmEOS6hxanGw76hxDuAzQ+aJBijWbHCymHE+VaqoYigxDoklLaLfZyCaFaoUS0AKOVWt/6WGFJO6BI9Z6qAAGGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 61D6B68B05; Tue,  2 Jul 2024 07:15:31 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:15:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/12] libfrog: advertise exchange-range support
Message-ID: <20240702051531.GJ22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116862.2006519.2459746611478539000.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116862.2006519.2459746611478539000.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
