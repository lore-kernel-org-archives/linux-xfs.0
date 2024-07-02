Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC45C2555B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897253; cv=none; b=Fjz9Rul8sW6ySnULhnm0tkgCrmyOG5WtYADHaauoH1M5hC9jSFSQ2cjsCpqt/+ph1phG0tFkA4idHjOGHR2eVT6t+x7/pUsYUwhpv6ymDupH20XOFnl9tui3rxTdqvTReU7gq2goYiL7fx2luKZ2BzPPTce+Pyoe3nZtJG1bj3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897253; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YPhC5yMar02hXJYKfLWw0xAGlnU/AKwUrHiZ7DPim0akYJ3QhociNjaNcQ5+X82FI7+hhnhgpEkx/iWrGBHij2CxzEWephdespr2MwZ1d4qzT44Tse1RRgDFkN5QlvcKFApzagVpmhU5fwl4c7Ns/GiiJRRb7scWbfr0Ta0YlOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4A46568BEB; Tue,  2 Jul 2024 07:14:09 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:14:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/12] xfs_fsr: skip the xattr/forkoff levering with
 the newer swapext implementations
Message-ID: <20240702051408.GH22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116831.2006519.7545128226159019978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116831.2006519.7545128226159019978.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
