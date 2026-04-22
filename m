Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CB62505AA
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 06:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776837808; cv=none; b=sKkhAIpcRbK4Hpr34RkixAUStnkCfpA7tyo4HMgDTSBd7hz/MpntvzqMlYh7eRG6sL9UYodTBPJyt3mmE+JazHrfZw6q/Dg6Km7E6rfbEyigVBH74kRXMUozmsaLrDD5A4FlkgO8fHlL4H80lfyV1deqCzDECm+tjbx7wyF6Ijg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776837808; c=relaxed/simple;
	bh=WtZjxfwqqCATfrQhBMI4Oe5HC9WRx1VhQV0uD6GCLMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Doqq/xkWMn+OwFZUPY733ehdxUnMkF56KMzhITwdmwXbGM6GHn/l6g4Co61qQyZ0i4DCmLUiqXUwMkoRIIENxR/k51p2ip4Rx3af+0PzxnMWUkH2nRbpsHuq4Ni2d/qHmewr773eU3O6ZLsdflOVV/Ks+zv18VXGNUsjboD+ds0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0A96768D0A; Wed, 22 Apr 2026 08:03:24 +0200 (CEST)
Date: Wed, 22 Apr 2026 08:03:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: expose the number of free zones in sysfs
Message-ID: <20260422060322.GC5391@lst.de>
References: <20260420135011.624587-4-cassel@kernel.org> <20260420135011.624587-5-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420135011.624587-5-cassel@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 20, 2026 at 03:50:13PM +0200, Niklas Cassel wrote:
> The number of free zones is currently available in /proc/<pid>/mountstats
> (which contains stats for all mounted zoned XFS filesystems), under
> "free zones:".
> 
> Add a sysfs attribute /sys/fs/xfs/<dev>/zoned/nr_free_zones for the same.
> This makes it trivial for monitoring software to read the value, for a
> specific filesystem, without any complex parsing.

The usual way to expose stats in xfs is through the stats sysfs file.
Which requires some parsing, but the usual monitoring tools already
have this.
