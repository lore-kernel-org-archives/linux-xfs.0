Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5065F3019C3;
	Fri, 24 Jul 2026 13:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784898839; cv=none; b=obwFB8165eSGMev58NeZE1Z1fdUhYL38hQblA24oOHtB4Tl6gL9uoAeGPcKESGMZ9wVbL6YQDISBklcQnN9GuIwuSWBYoI0bbDFdCymFVxqUTNV9vsslsDVscSa84ijJPFKeAJXNOasLJdH1HLfvEoW95OR+VWssw8tWoUcofvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784898839; c=relaxed/simple;
	bh=ulYgcPH4KCD1Nt9v5XEq1cRiuB72GnC/7rI9njxX6xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5lCs1L6nuPvnKCV3itHcN9I2huPOAvse6QVqHoSWgiQlajnd7whTvt3WDr+AW3BpbkjK2wk9ywSkOGXThmelUvVFKE/VUBHEYWmM1yevzMh3IIklvQaptoxQlFb20qU/AruaYCIDCEUH3vI1QmP/SKaXnNh8++l8XUC99FT0vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9823968BEB; Fri, 24 Jul 2026 15:13:53 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:13:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 06/23] fsverity: don't allow setting DAX file
 attribute on fsverity files
Message-ID: <20260724131353.GB27878@lst.de>
References: <20260721184346.416657-1-aalbersh@kernel.org> <20260721184346.416657-7-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721184346.416657-7-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Shouldn't this have a fixes tag and go into -stable as well as it already
affects ext4?

