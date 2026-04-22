Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A392D77E9
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 06:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776837862; cv=none; b=a9dap39/GUJBtHBw8q1LHqYqQHkW5h+vD2fL54ENj8nBNNGu7aNf/0pUT1HRvuqpCC6TyZQPSI1CoOn0J7lapP/1hgBBJwjQ9MoRICMzp2EEkBfFOi5Fcpc7DJbzMNrxTsFUCt89HCNrW5WnpAkovtvuLbFPCqrQkpwuloGq6gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776837862; c=relaxed/simple;
	bh=ihKMtHmgfCp9Ysfrqrg1nHMB4IDRj1QbZJ0O/pOx9rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3WTHZqPYjAK6ItUIOcX3CoC026I3rd70QrViB+fd0z80F1zlAmhVtNmd/ei+J0qNcVwwzQBHWCpHBaLjNlHMfB61zs3ShoJsaV0uQJhCRgnuMpww2IG2smv2cIBY0yBNWHIYvleMkdUmjU/r1o72iFct3AmgsPW2DBqCDRTWnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD1C868D09; Wed, 22 Apr 2026 08:04:18 +0200 (CEST)
Date: Wed, 22 Apr 2026 08:04:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: expose the current zonegc required status in
 sysfs
Message-ID: <20260422060417.GD5391@lst.de>
References: <20260420135011.624587-4-cassel@kernel.org> <20260420135011.624587-6-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420135011.624587-6-cassel@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 20, 2026 at 03:50:14PM +0200, Niklas Cassel wrote:
> The current zonegc required status is currently available in
> /proc/<pid>/mountstats (which contains stats for all mounted zoned XFS
> filesystems), under "RT GC required:".
> 
> Add a sysfs attribute /sys/fs/xfs/<dev>/zoned/zonegc_required for the same.
> This makes it trivial for monitoring software to read the value, for a
> specific filesystem, without any complex parsing.

GC needed is a very complex internal condition, and I don't think
exposing the current value as a stable ABI is a good idea.

What are you trying to do with this information?

