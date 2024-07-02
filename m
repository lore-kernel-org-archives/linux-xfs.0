Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41340BA37
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902911; cv=none; b=hruX0VR99n7L1Hhn8nr1dnmEMeffcK89hE5pkDWVWpXZFC+xc7jQfpA4yeHIjUwFtwm4NHZN7yj1baUgh1FDkPGO6HqZqTYjBaTKVIfFb83nyz27ucwp/ls5/LFRYSknOSxBr2KWhbb/pxj32+BV8N3GFMC0C7NuCuLuNc4Qotg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902911; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3S550Hws0TsjHM5uaFxpeszfx5AG6iS8Ut9FSAd5YJr2pDTkBKQdvbU34XWdeK7aAOIbWDPjbkkfoN5KVihh+/P/lNZTAuuaGTeyM4M7TYhKoazL/7NBiDD0rYzCr/tM5sQqYjsW8nX/TPpeIOfanUPBME3M5YkQv+RSNPkYgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 96B9168B05; Tue,  2 Jul 2024 08:48:27 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:48:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/5] libfrog: add directory tree structure scrubber to
 scrub library
Message-ID: <20240702064827.GA25817@lst.de>
References: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs> <171988122711.2012320.2904107384951874903.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122711.2012320.2904107384951874903.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
