Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238831283E;
	Thu, 15 Oct 2026 06:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792044163; cv=none; b=K11oUVdc0z/FRq4/D4l+U3/oNWXJsiNH3sAXt1WgOHw2e5fs9ed8r1ZO/EIKAp5DFW6I7zXOtuIjBNL7BzbiCdLz8Fc1QUi812gf1LBdSNE2ytkxdyru07p0af6XCkNLf0oNEXCr67Wn/xtqW4yqJzU0y9EPGKCTmlSlStKRwjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792044163; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=awOqcwV25DjOAyZN7xPJD942nuKMT8wFzpt8wjnGWMxs5HldkdFCY5FnjfAuDHv3gtc01w8KaLUhZnos8MlQq6OPFsN+2tW2hlvc+Rn/sBhYPdDTO/MZ/IsgW+rZAqDNg2Yq6tTIAifXCXwLLvhrq349xGbj0MqeNuxeEl4tx+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A57D8227A8E; Thu, 15 Oct 2026 08:02:33 +0200 (CEST)
Date: Thu, 15 Oct 2026 08:02:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/9] xfs: mark the inode preallocated for pNFS write
 layouts past EOF
Message-ID: <20261015060232.GA14035@lst.de>
References: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com> <20261015-xfs-pnfs-batch-v3-1-54fc7b2e467d@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-xfs-pnfs-batch-v3-1-54fc7b2e467d@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

