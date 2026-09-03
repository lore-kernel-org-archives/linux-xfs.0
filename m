Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B51391849;
	Thu,  3 Sep 2026 06:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415665; cv=none; b=S4b/PTs6PC+2uNYA/B5BTcSv1ufEk3ZSk0arNGQhjw81Xk45OE4Qr5ml3tLJjHaYH2PbA5s74PfXhoTeIyYpO8/KQx+jdYfbLxwDXY4hQqjm18CUMVlpsbTjP3+XgZm9K/Y3zCiBbvddRj/tEqJ6trUECLqZP61YI+EILo95oiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415665; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MI2kpzFYOXrNYoQP0QdiAHlJWWWot8RoTXo1rkda8i5ufdGavB1Zqh9DP0ONKKrPLdH1R+H5b8sXMW1Y10qj4JY01oqtfv2o3FIr/eQIgACx0BN7dt7d6OFtMs5UC/B49UI6y9qhJBS5QyDymvi24xfjeOCM2a2PvzVjfraRrPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1156868C4E; Thu,  3 Sep 2026 08:07:40 +0200 (CEST)
Date: Thu, 3 Sep 2026 08:07:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: use the rtgroup extent count to find
 rtrefcount gaps
Message-ID: <20260903060739.GB17233@lst.de>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs> <178840969871.484660.14165734512664639226.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178840969871.484660.14165734512664639226.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

