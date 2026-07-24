Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1462EBBB9;
	Fri, 24 Jul 2026 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784898988; cv=none; b=KHQkKRpAB8caZ3zxR/FlE3tlyIcPZnMgz8iV/59wMuYalZuN4VRqEJZJefJib1QastC/iDd+uzkeTpkDZstC2BZDKc6sBLAmp3cmiGx85aFfh0KTzkdHKxI1rSqpBmoMNoqqKHT5r/1m6NTGXtGVpgbo96JwTwAgm2+sujePPLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784898988; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnqYqS5taXnBJkq2D16CTXB+e0YfDZSq6tz0JCbSgFX5dIgMRyU6Lz935uxYQ86zSOAIxG2t2dMIe1GDLaCKmhSyOKccxs7psDKSfmP+7FKebl8rQsryq43b8DyY3Of+YK7LrtL/Yj+xup7xmGVcB28ldEz7fYm/mxhiBePTIPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1CB7568C4E; Fri, 24 Jul 2026 15:16:23 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:16:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 11/23] xfs: disable direct read path for fs-verity
 files
Message-ID: <20260724131622.GD27878@lst.de>
References: <20260721184346.416657-1-aalbersh@kernel.org> <20260721184346.416657-12-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721184346.416657-12-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

