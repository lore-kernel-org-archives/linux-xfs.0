Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230FE17A300;
	Mon, 13 Jul 2026 06:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783925182; cv=none; b=RaPBZ5Ph0gEXeOdt9GCJj4SJZhzUVlgk/kUbWrYDXwKOphmg5ZL56PjYyOidxoZxeOruazMTp1sI2iYADPo598WnSnFlhNYLQpRJMCK9NYvyzSflnM/gn0bXeu4+ZK4DSHhP7hClkkhLn6RpgvWeQwqMePW86YiEVfkaS3Snvk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783925182; c=relaxed/simple;
	bh=dFj4PXIWzhbmUJOFmzQNt1qgtQ8syeC3KliuYY5z/vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVMCenNngCeskcPYjlHrKpkPsoYNJFkzanCDnU8OSqOU7p8x62O6xWdQI+ciedHX+D10biLgwVQdOhcz9tpenqZgKLAyb+M8lcCCdRIyErPcn/rY2dTIcIHwnZopsDfJLrtlwmYBUdOT/lU6zXjsGObGMVv6yrLbR/bXeYQwYFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 92FDB68BFE; Mon, 13 Jul 2026 08:46:18 +0200 (CEST)
Date: Mon, 13 Jul 2026 08:46:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Guanghui Yang <3497809730@qq.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: propagate errors from xfs_rtginode_load
Message-ID: <20260713064618.GG29416@lst.de>
References: <tencent_542687AA9C474951C4132E84DAED17622105@qq.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_542687AA9C474951C4132E84DAED17622105@qq.com>
User-Agent: Mutt/1.5.17 (2007-11-01)


Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

