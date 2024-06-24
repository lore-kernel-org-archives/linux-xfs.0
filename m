Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0611E19B3E2
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719241956; cv=none; b=UQWc2bJ/uZ97umrNYAoA10pkVdKcJEgLvtJMEy/Rif18PCHsxM5/W1c+DTuI5tEDOkC1nBGunhvcOMVBKyQvBbPTq28x7lPUgW5TT23yTnQA0Cg/PFTFQe9xPWz9/mzajh8Op1ORg5ZRgry3qwVuFbNU+sGB+ftY43BeJzntdnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719241956; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NlQZKp1ILq/y8/f2exoYkACGIPwG3vfZlV7Y+2P2O5hvS5/TcGnIHxGSvVR6c7ZLPAoOzzvavUuh+RF8jPMyhE+BLBoThU/vN3NG+x9t85ZhC7FfceJWHaC0R9ONcqZyRnjCB/Yu9PA6VlpL2aSv4dGi1JQI6QNHpvPS/fzCKho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D49FC68D05; Mon, 24 Jun 2024 17:12:28 +0200 (CEST)
Date: Mon, 24 Jun 2024 17:12:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Konst Mayer <cdlscpmv@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v2 1/1] xfs: enable FITRIM on the realtime device
Message-ID: <20240624151228.GA11782@lst.de>
References: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs> <171892420308.3185132.6252829732531290655.stgit@frogsfrogsfrogs> <20240624150421.GC3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624150421.GC3058325@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
