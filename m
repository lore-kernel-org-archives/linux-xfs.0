Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523773A89AB;
	Thu, 22 Jan 2026 05:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061474; cv=none; b=DfZ3ReKG0KiLYnIi6hT5nWRcoxUvH16SI2pWmseKUH+GVTEihCQ4SlPQo9Z9JzB0vyO6Ga/R3fpHnEbjTdwrwOysOOMCR29SNC5oUOC9JBBGB4KBI2ALM6D5GVWVLEL3DL+icCr/S8NjtOIgCBQqE79L7rmdEN6bY9KQYYXYx+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061474; c=relaxed/simple;
	bh=I9oJCAJSbUnAlEpypxu7wF7MP7jyvo3WrHt00nK97Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuKCQz/uloKjVjH1rj2sOWsZe0duL6agp2iYV2ggQ9Q9Hxf5EgZ3e701NBMPowBmElVIN0BMRhxRVcT4CzJE+oK/g8wQU9a/xO+xZjeiOdYMVqCt1N2RBcOTBRVY4SaNZkeDWnopVYcopB95SYNwVjDa5PxDVKmbcuj8r7XjZ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 60E38227AA8; Thu, 22 Jan 2026 06:57:48 +0100 (CET)
Date: Thu, 22 Jan 2026 06:57:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, r772577952@gmail.com,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: check the return value of xchk_xfile_*_descr
 calls
Message-ID: <20260122055748.GA23964@lst.de>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs> <176897723563.207608.1472219452580720216.stgit@frogsfrogsfrogs> <20260121070323.GA11640@lst.de> <20260121182208.GH5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121182208.GH5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 21, 2026 at 10:22:08AM -0800, Darrick J. Wong wrote:
> > xchk_xfile_*_descr is used to pass the name to xfarray_create or
> > xfblob_create.  I still think it would make this a lot more robust if
> > those took a format string and varags, and then we'd have wrappers for
> > the common types.  Even if that still ends up doing kasprintf underneath,
> > that would be isolated to the low-level functions that only need to
> > implement error handling and freeing once.
> 
> Alternately we just drop all the helpers and kasprintf crap in favor of
> feeding the raw string ("iunlinked next pointers") all the way through
> to shmem_kernel_file_setup.

But wouldn't we get duplicate names for different inodes?

Anyway, I did a quick take at format string / varags version of the
helpers, and that works out nicely, but that _descr macros still confuse
me a bit.  Maybe I'll have something until the start of your Thursday.

