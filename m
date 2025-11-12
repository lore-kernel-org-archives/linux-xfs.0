Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA32C0F71
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 16:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762965513; cv=none; b=eT9wR8xcckmEC0f3dyKeylzmX1Z/JsQgsOPBisUMGKc8nQssc5L4KaAp4d2RBYiiJKZ6xL6U+Rwv8m901kII49eLBp1fw8DedLczqZVeLftSo08/DMqiwWVK1+dVvw2DKki1bMno/xD2e0jel3KkrIqaF11wqq2Ws2lV4QmFd1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762965513; c=relaxed/simple;
	bh=QU99hbzU3gefzxFTiK4mp2RBU/Aw0TE1QyjCsJ45yRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeZDFrVtrTP8B4IAVFZKAabNYW/VJi912i7yx7gXWo8tSz2UcJeJYyoItz0vZyPU9A9zntDSz0Lz1w44Ab9zUbQgCn+CBN0ToIkayUEDjGxpHCw/1rpNkK0AMnRFcNDMrOSidXGdyvcTAYUfS3wjG7AAkOVw2ZxvoCj1WZQHqP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 870EC6732A; Wed, 12 Nov 2025 17:38:27 +0100 (CET)
Date: Wed, 12 Nov 2025 17:38:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out of bounds memory read error in symlink
 repair
Message-ID: <20251112163827.GA12284@lst.de>
References: <20251112163518.GY196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112163518.GY196370@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 12, 2025 at 08:35:18AM -0800, Darrick J. Wong wrote:
> On further analysis, I realized that the second parameter to min() is
> not correct.  xfs_ifork::if_bytes is the size of the xfs_ifork::if_data
> buffer.  if_bytes can be smaller than the data fork size because:
> 
> (a) the forkoff code tries to keep the data area as large as possible
> (b) for symbolic links, if_bytes is the ondisk file size + 1
> (c) forkoff is always a multiple of 8.
> 
> Case in point: for a single-byte symlink target, forkoff will be
> 8 but the buffer will only be 2 bytes long.
> 
> In other words, the logic here is wrong and we walk off the end of the
> incore buffer.  Fix that.

Yeah.  Probably only saved by kmalloc usually aligning sizes up.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
