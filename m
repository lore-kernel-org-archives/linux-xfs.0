Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FAC2A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898040; cv=none; b=gsy8NSFjMWBDpTclk9S3trCYKkwAC+rnnLPSW2rmyTeabZFbnCfJutShK0xV9+JY8O8x+BRHQojIf5Ci2AK1FLim2x16j29M6h+P9HCUn+Pvsz4KzSaPzC5nyJnOPNIhbhwQXK3wyWfFlJj3zS3GibSGEtNUUPaXXZ4GoXq8ot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898040; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ijle+foZOdWgbX+wfNFlZDb6Jh1XUsvwwyk+Y05Or+1atdc2W9H+4BW3ouVYW+mcCXNluroCKNvtzQh3KDuHDBo5cQQj/p8gGi7SkGh5S/3hjshZv5xyPeNffiKmJd5nPXDJptdhAMAJsVr/cAmtXfH2PZkeGXUzWgs4yACNnqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7472C68B05; Tue,  2 Jul 2024 07:27:16 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:27:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/8] xfs_scrub: move FITRIM to phase 8
Message-ID: <20240702052716.GA22804@lst.de>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs> <171988118144.2007602.9357076180672124914.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118144.2007602.9357076180672124914.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

