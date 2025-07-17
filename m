Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0871F19A
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 05:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752729385; cv=none; b=SZrtJVNH61/wPrYNqm9cUxgZ2S6F+/JWG8rH0Uag86GY5f5pK90R/3NQIBY6PTejLGgJGFJAWzQFpnpz400SGTwr4eEPKuuhnb+C6AeXMWZHLnkvKPh9yHMSpvraOsuZLWTNHjRQT8UAT2FxFvST0nR5PtFFQVfZXnX3pxFmTkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752729385; c=relaxed/simple;
	bh=LfX6P5Ko+iRlqRI6YIzXv/K0nvIaIi2tEd++JjHkwl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jw3Qp4WliDwV5Sm0YMDL6yhp2IwleYwSfy0lKMv1V33N18kRxNKVpHbSeVkaOja6LTPaDqJUjs3Gp+1HTTObJU+EFfBGWq3ZgOL4FH+BX17+Z0MUhbg9AoNECPJlROdqKC1oQC5c20bilmFLSDFwXZ4lGXGfW9Ox7sJTTT4RnpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DE46D227A87; Thu, 17 Jul 2025 07:16:19 +0200 (CEST)
Date: Thu, 17 Jul 2025 07:16:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alan Huang <mmpgouride@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org,
	George Hu <integral@archlinux.org>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 5/7] xfs: replace min & max with clamp() in
 xfs_max_open_zones()
Message-ID: <20250717051619.GC27362@lst.de>
References: <20250716125413.2148420-1-hch@lst.de> <20250716125413.2148420-6-hch@lst.de> <20250716160206.GL2672049@frogsfrogsfrogs> <3B511F05-E1FB-4396-B91F-769678B8E776@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3B511F05-E1FB-4396-B91F-769678B8E776@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 17, 2025 at 12:52:14AM +0800, Alan Huang wrote:
> > Does clamp() handle the case where @max < @min properly?
> 
> No, it only has BUILD_BUG_ON_MSG(statically_true(ulo > uhi), “xxx")

Well, I guess we'll just need to drop this patch then, right?

