Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A702F48422F;
	Tue,  4 Aug 2026 17:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785864954; cv=none; b=RWWFivlrLiPvrO+mM4zQTIq0+70WkwE8vNjGkySP+ZwNnCZMBHd6uQ48xlrWYmTBzvx8eixw/4pTzPYp3CB1qzCrmB9y4V2JLD9SjGrDNCeM/lviAVj7RC2USoFp2iq6VaN6YtGo7B7VkOATGfYg9YlkxrI4Czmdce4Z4MLPBRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785864954; c=relaxed/simple;
	bh=P+zDGpQ2t0ew+2t6bT+zu6TIQwRQG6c7Ze8Hcw7HWho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmsCjsWb1Wi9n/153M/ytAf9U4z2IhL/JqW4LlXixyJK3SipeOqWmlp2onI542hsUFDrfwFT/k8aLz9SUOyS6w7by2tbSDQLpNrQrYTCDEswiZkQrUhKek81cw/kFu4UVR2Ntmxt0MGxKnaKVteOZ724iyJQc4eOQww26bzCldo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6A09E6732A; Tue,  4 Aug 2026 19:35:48 +0200 (CEST)
Date: Tue, 4 Aug 2026 19:35:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org,
	linux-unionfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v14 00/21] fs-verity support for XFS with post EOF
 merkle tree
Message-ID: <20260804173548.GA13900@lst.de>
References: <20260803200820.393203-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 03, 2026 at 10:07:50PM +0200, Andrey Albershteyn wrote:
> This series based on v7.2-rc4 + lazy-bounce@hch-misc

Oh, I gave up my hopes to get this into 7.3 and was waiting for
your series to land first.  Right now there is one outstanding issue
I know of with the series, which is that we need to clear REQ_POLL
for bounce buffer I/O, and of course the somewhat complex cross-tree
depenencies.

I can try to get it rposted, although this week I'm travelling for
two conferences, which doesn't help.

If you only need a few patches from that series and they are kinda
localized to xfs, maybe you should just cherry pick those from
my series and include them?
