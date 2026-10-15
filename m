Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EC2411FA8;
	Thu, 15 Oct 2026 06:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792044622; cv=none; b=HrbyleVTzF8Zsu9ZoSuf5KFGWGEc6GW+fTxxJSltfqlDJhAoe1xy00u7FbEXfSajQshkTO+gOdQuwyh0bJL6xneIvygyjifnAqCV3EU0gGcUcb812xqywAyee1S+naahTafvF5gsxsi9Cq01l0rwv06Lp1bqHz/ix5d+dlS8HlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792044622; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Juyy6wKzeNCZ3h5KWEs+raOeK1Ka761z0e+ePpA/JSUimq12Ct5FCUT9OCMiHlVKkXHIjJTRYtGlY4TjGR5MJb2A80b/ItGGnfgFWoeDyelmdcdeE3DMxz0ohJtw8tf5dCj83CbcDkSbKDE3OiVQmR7pByQh3GuN79JmxA3+6KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DCF6868BFE; Thu, 15 Oct 2026 08:10:14 +0200 (CEST)
Date: Thu, 15 Oct 2026 08:10:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] xfs: take the invalidate lock while mapping a
 pNFS layout
Message-ID: <20261015061014.GE14035@lst.de>
References: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com> <20261015-xfs-pnfs-batch-v3-7-54fc7b2e467d@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-xfs-pnfs-batch-v3-7-54fc7b2e467d@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

