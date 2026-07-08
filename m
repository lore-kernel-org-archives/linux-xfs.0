Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288953E63B7;
	Wed,  8 Jul 2026 09:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501945; cv=none; b=SzWDlJ0Cv3+ZAfqlHKV17tz1uN636iCLKMOpBePWSYFVLH/7zU9rcor3sS4UAKjTh5QSJmxtRrSKsKx5zdIQyhz1RX4G8ioiqLEdbXErsSYVZqwvcQcrITyCZEpLJt34n3ygkOA/ar0cPev3st/+rd3AClg38NoBygf0nVxbekY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501945; c=relaxed/simple;
	bh=OKAaBJrj9JlN3J0HAHjm/Uk+OhRtzp6hsbcvy+EVN1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msHyS5UMALnWpQqupDhhUBHE9ZRv0PvSVwlKIZ/EiKs2wwLmrjLt0aUD5XkKBEieUXtpBBXuqADXdzQscM8DePfBOGsFLQdupHqHics83GNxeZQXyZjN/moFCph6rSIMDSEIqtaPzC++GeFQ7gE1/GCUyltYOcjviCfP4QP6b/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A5B1A68B05; Wed,  8 Jul 2026 11:12:20 +0200 (CEST)
Date: Wed, 8 Jul 2026 11:12:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: don't replace the wrong part of the cow fork
Message-ID: <20260708091220.GA5902@lst.de>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs> <178346726108.1271589.7681324440256265003.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178346726108.1271589.7681324440256265003.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 10:03:24PM -0700, Darrick J. Wong wrote:
>  static inline void
>  xrep_cow_replace_mapping(
> +	struct xfs_inode	*ip,
> +	struct xfs_iext_cursor	*icur,
> +	struct xfs_bmbt_irec	*got,
> +	struct xfs_bmbt_irec	*rep)

This looks like something that should sit in xfs_bmap.c (or at
least xfs_bmap_util.c) and not in random scrub code.

And I really wonder how we can get good test coverage for this, including
for the original bug that this tries to address.

