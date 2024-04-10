Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FDFC127;
	Wed, 10 Apr 2024 04:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712722291; cv=none; b=axKAXJ+aw1CCKu2nXyg4Hz5mphdcju6C/FEbh6sO/gISYHVxfYzBFVvsUjO2C4bKbtSTCKpjbF/UjHt7eY8WHZJFkqt9Gd8rOBcTQnnrWXnG1RY6sahUB5dLdOWuDVXG76Oy2MnY4erkYv5mchBNzQIYgzdIy/kWeumB2PcpYqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712722291; c=relaxed/simple;
	bh=NrSCDxw2qMjrH5auRKV3dXR6gi+OIhDfOVn3hdt/VCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxG8EQ2lc+W2uzOW/5zB7tgvNbzKVBml+hiXesH5NLldKVFDO4BeSNVO5gfcp5y4bbJpuEWGHWCguy1F772BYscO6TBgS8H9BjDp35ldHwW+SCfIEJKs8AjfxOTbt/WNz5sEwfN8UrD6vr5sCnERajoROvdKtstUgUfL5lzCodU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AAAEA68B05; Wed, 10 Apr 2024 06:11:26 +0200 (CEST)
Date: Wed, 10 Apr 2024 06:11:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs/263: remove the nocrc sub-test
Message-ID: <20240410041126.GA2208@lst.de>
References: <20240408133243.694134-1-hch@lst.de> <20240408133243.694134-5-hch@lst.de> <20240409155728.GG634366@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409155728.GG634366@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 09, 2024 at 08:57:28AM -0700, Darrick J. Wong wrote:
> I think we should continue testing V4 quota options all the way to the
> end of support (~2030) by splitting these into two tests, one of which
> can use the _require_xfs_nocrc predicate introduced in the next patch.
> Thoughts?

Sure.

