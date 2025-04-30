Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78446248F4F;
	Wed, 30 Apr 2025 12:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746017034; cv=none; b=gLikDsdlpY+QSBtl3rsqT/2BkOj7ChPQ0hYeTIs5KB8Rsq7p50+cIAKtnF/jycHxMxvklHDxYKzqYvrOpB2VIxZWOW2st6n2jdSF29jL3kXCz23uNo27XDOacslaDDcQwImehn/47FyIHiLxElFGt8kHTPnz7uIeyEhBoYzx5lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746017034; c=relaxed/simple;
	bh=w2wpG+UPaQjk1mJZ5agF9WBayXQaGEVor2gQCJR6dUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A29L/ZMhnT/GVLcPp5wn/8AVpvP+0kjEWP2MkQzyWdWYxDWKE5wp4xUx7vkGAvLKVq2kOxHtkj7bSYBm/AUoeUh9Za3GknERok0HCP+sIA2nbpN5aq8iipNL6shbsIfzkbP3eNfaPGo3QNtAwEO6KBCBXzxuEY4R2d2LGjHodIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4136667373; Wed, 30 Apr 2025 14:43:46 +0200 (CEST)
Date: Wed, 30 Apr 2025 14:43:46 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: allow ro mounts if rtdev or logdev are
 read-only
Message-ID: <20250430124345.GA32269@lst.de>
References: <20250430083438.9426-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430083438.9426-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 30, 2025 at 08:35:34AM +0000, Hans Holmberg wrote:
> +	blk_mode_t		mode;
>  
> -	*bdev_filep = bdev_file_open_by_path(name,
> -		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
> -		mp->m_super, &fs_holder_ops);
> +	mode = sb_open_mode(mp->m_super->s_flags);
> +	*bdev_filep = bdev_file_open_by_path(name, mode,
> +			mp->m_super, &fs_holder_ops);

We don't really need the local variable for mode now.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
