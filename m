Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F363F1AC3
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 10:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902033; cv=none; b=vAKB/atlpv5aBx8NnAz0fFg28mSXpNcHKOLaz4klmE5PTSdMiS9eZE1YMOnjuE4ZL4khf/sTmu4WGCgkkdkfd1345u7OIg6eva3gbKTfLi9l0Gn6AX7dOsjxnBMBkqk4gcEU0lJm9pY1/1tsi2pFGObnHdZbJSYsJsCM38gNLl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902033; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HHgehQlloy4XfBMqFly0caYHPqtN4PzQK6tTgb5kRippOtLQNGjWc/PX5Cpsen91PI52xyQdNUQRPJbaQbMIL4bos7/BpSLPBgFw4hJ/TEPIdQmp2ehkIrNmsX/XQLOM3k616k01sXcgPq2U8/9eiunRwcKLlwSGXrEV1fyCBQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 881D068BFE; Wed,  1 Jul 2026 12:33:47 +0200 (CEST)
Date: Wed, 1 Jul 2026 12:33:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] mkfs: fix hardlink detection in directory import
 code
Message-ID: <20260701103346.GB12719@lst.de>
References: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs> <178288493220.702844.3296067461182118456.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178288493220.702844.3296067461182118456.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

