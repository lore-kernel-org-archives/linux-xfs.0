Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4903C7E18
	for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 07:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779174960; cv=none; b=agq6g2EoylCDuFUyGdq0hwL96urqqdBMiTIhUgM7Ap9NbDegyaKwhnyLBhThEZ9WZLEI6Ge4cIqV33I/JPV4jt8a3KI7ioXFiRjP22YwETNzNUvgSY5kx/Uq1z28j+tzkNHbfFCLDSyLkYuhvp66tmVTbSQ14W4uxnbG2p3Aq6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779174960; c=relaxed/simple;
	bh=mTcRILPj80qvwC63Z3V7uOVbK6rzjdqecDtD9c/uZfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iI6FRtbnYQ8DmoUHltO/XveHUsGBnyGkft5XuiUlzvXGDUbjYa91ixO3hLcXrbj12NeENHh1astQuTZN93ZTxbELPl3H8PzrhOuGUBdMlp4zqQI5IgN+hJSORJIXBS9DhKaP0YHQes0nCn9wtKG4WdVWRHBajh//wYjhparXlr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C1AF568C4E; Tue, 19 May 2026 09:15:56 +0200 (CEST)
Date: Tue, 19 May 2026 09:15:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: handle racing deletions in
 xfs_zone_gc_iter_irec
Message-ID: <20260519071556.GA10037@lst.de>
References: <20260518065224.9066-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518065224.9066-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 18, 2026 at 08:52:24AM +0200, Hans Holmberg wrote:
> Under heavy garbage collection pressure from RocksDB workloads,
> filesystem shutdowns can occur in xfs_zone_gc_iter_irec when
> xfs_iget() returns -EINVAL for deleted files.
> 
> Fix this by handling -EINVAL just like we handle -ENOENT, allowing
> zone GC to safely ignore stale mappings.

While I'd prefer -ENOENT returns for not malformed but potentially
out of data inodes, this works as well with a small loss in error
checking:

Reviewed-by: Christoph Hellwig <hch@lst.de>

