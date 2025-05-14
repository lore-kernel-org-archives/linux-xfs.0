Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E6F224890;
	Wed, 14 May 2025 13:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747227623; cv=none; b=TyFWNTXoHbpEPlnS51dgH976kH6DOyLHJt/+Cyx61h4nFigQJHkVdWfFkeTJknVJhMSo/rmYi7jnETtsJyrHsXdwBv/jovCJRhJhqiG3Yu6B1wV635InDWpcxvah8xIUvVEKDkRErZDwTC4mqv0b8PeOB3NJs03BSGvm1TB96mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747227623; c=relaxed/simple;
	bh=K0myQi2wR00umb63XKtM5FR1RLDuJ04Ib2WH988G1cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckNwcK/dJnam1IL2MWE0Gd7OYgs+Zex04vfVD9kkDxAFjVCde2yj2n5I2+UvoS9Q35W+SdDVbiVLPdIud4mDwtAYp4gPyNj0/GmsN+N/++UYNxTeXlrM4twb9tB4mimxD0wS7WX5F07BmTWPdXb6xfAbfDZs6wnsNsV2fJROiq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2C2D68BEB; Wed, 14 May 2025 15:00:14 +0200 (CEST)
Date: Wed, 14 May 2025 15:00:14 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add mru cache for inode to zone allocation mapping
Message-ID: <20250514130014.GA20738@lst.de>
References: <20250514104937.15380-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514104937.15380-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 14, 2025 at 10:50:36AM +0000, Hans Holmberg wrote:
> While I was initially concerned by adding overhead to the allocation
> path, the cache actually reduces it as as we avoid going through the
> zone allocation algorithm for every random write.
> 
> When I run a fio workload with 16 writers to different files in
> parallel, bs=8k, iodepth=4, size=1G, I get these throughputs:
> 
> baseline	with_cache
> 774 MB/s	858 MB/s (+11%)
> 
> (averaged over three runs ech on a nullblk device)
> 
> I see similar, figures when benchmarking on a zns nvme drive (+17%).

Very nice!

These should probably go into the commit message for patch 2 so they
are recorded.  Carlos, is that something you can do when applying?

