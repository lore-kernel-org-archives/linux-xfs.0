Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711A219A281;
	Wed,  9 Oct 2024 12:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728477801; cv=none; b=BHTDh6+/Zos5lvOtXOoW2JzZNdTqfxvK9M8tKo9bCCZTZfACvkDXh7QYkkQmF32lrHdqMHsCbd44RGBzj3VYR5P1DFAbyHhSLpdF+z8doRWvOMyc4OKbs8ks3DecTUmnkTxd27D9jBztKK5q5sGZ+IvWbhM09R2TXOBCPWNL5J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728477801; c=relaxed/simple;
	bh=eMRXjPsz8XzwTaVo9nRgYPhHgFEuEXmk2EkxSa/XP7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHS+ZGTNgGJlmKvR38fNczsTDrDZbUaQiEfKnb6x3BnNwEU4QdiY0QqO2/VL/j07OiXUTpPnlbLYVe3CHnAMp4Qu3lxH7JMAuszLRe3ldalHq34YAkA6Gf1pLV47aHsGMdL0zRirBKLt6dzXhr1vW2ENDGHMyUGVqyYajdwMslw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 591F7227A8E; Wed,  9 Oct 2024 14:43:16 +0200 (CEST)
Date: Wed, 9 Oct 2024 14:43:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <20241009124316.GB21408@lst.de>
References: <20240910043127.3480554-1-hch@lst.de> <ZuBVhszqs-fKmc9X@bfoster> <20240910151053.GA22643@lst.de> <ZuBwKQBMsuV-dp18@bfoster> <ZwVdtXUSwEXRpcuQ@bfoster> <20241009080451.GA16822@lst.de> <ZwZ4oviaUHI4Ed6Z@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwZ4oviaUHI4Ed6Z@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 09, 2024 at 08:35:46AM -0400, Brian Foster wrote:
> Ok, so then what happened? :) Are there outstanding patches somewhere to
> fix this problem? If so, I can give it a test with this.

Yes, "fix recovery of allocator ops after a growfs" from Sep 30.

