Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B4E3A4513;
	Thu, 15 Oct 2026 06:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792044582; cv=none; b=C9uQI3wjuJuzAUOxq9Cqu3mpV6UmPDuluSsPtAmROyOhZCmcBi0POIa6chZXKn0WBKZIA7KWh+egjxtZLzMbRlFqZrc3xc3Ki/hMBzGl+L7oe6ocWPxqFN54Jrio+eP0XNgesybsKkZLsLCfth6IOi71SYwylIzq641eKKH+eE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792044582; c=relaxed/simple;
	bh=iFxYOsXvW77pqyUzak4MnsQ2iHvnUsk9OX1dWkg+TNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJIb34H4wVHdYw7AyxQZPLLqYPo6YhaJLm6dhfKccU8RtLnGXtNKc+QrvGeBnEnfQo3gKvMAi5gAQFRKyDaweDZPfyrwGBlksii9tVD7WT5TV6H6ryOUD/gSIavb13WOZM5p1LUB8gBZFzk6Hk+v6ma0XJqjEqz6lpMy2ZJyjK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A5D8768B05; Thu, 15 Oct 2026 08:09:33 +0200 (CEST)
Date: Thu, 15 Oct 2026 08:09:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 5/9] xfs: refuse a direct allocation whose block
 reservation would wrap
Message-ID: <20261015060932.GD14035@lst.de>
References: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com> <20261015-xfs-pnfs-batch-v3-5-54fc7b2e467d@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-xfs-pnfs-batch-v3-5-54fc7b2e467d@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 15, 2026 at 01:08:04PM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs_iomap_write_direct() maps one extent, but it reserves blocks for the
> whole count it is given, in an unsigned int. A count of about 2^32
> blocks or more wraps the reservation. If it wraps to a few blocks, the
> allocation uses more blocks than the transaction reserved, and
> xfs_trans_mod_sb() shuts the filesystem down. If it wraps to nearly 2^32
> blocks, the allocation fails with -ENOSPC.
> 
> Direct I/O, DAX and buffered writes with an extent size hint never ask
> for that much, as xfs_direct_write_iomap_begin() limits them to
> 1024 pages to keep the count below 32 bits. xfs_fs_map_blocks() has no
> such limit: it asks for everything from the start of a hole to the end
> of the range of a pNFS layout, which a client chooses, and an RW
> LAYOUTGET at offset 0 of an empty file for 16 TiB does it.
> 
> Fail such a count with -ENOSPC before anything is reserved, also on a
> filesystem with that much free space, as the transaction cannot take it.
> A count that fits is reserved in full, as before, so a request for more
> blocks than are free still fails before anything is allocated.

I think the limit needs to be lower, as xfs_bmapi_write can't hand
out such large limits.  We'll also need to make sure pnfs can
request multiple maps.
