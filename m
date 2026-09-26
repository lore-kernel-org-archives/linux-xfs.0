Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4CC329E5A;
	Sat, 26 Sep 2026 06:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403207; cv=none; b=PZx7Sk4/1qg30rX5cVJkUmXsxZke76DfV3+FPMTp2ZFVOd0oL0UjM8l7TpK10tadu1XPckW63LxZnpJYIzvhy8aB2ZTdft6aPKmkqNesBvRFPTcXfuF9hbkyyxrZ1XrhLfX2mdrKIzPvYEiw0lMwfDkWA3uiBircazA4FI0JkKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403207; c=relaxed/simple;
	bh=09deJmOdiIhecIF4gCGg9CbomMPJGpR/OeqFf2lI1NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWptnBsh1WJV05uY2b/qnNXOxCrowQrjm0viH5XIw8XHY9O6Pxt18ZPUFMoE+THsqyt9HO+HAYolpzfNVg2fxLgkHvqNqvwXOf3lzEIVRIwi1FyLMDsA0Kq+UZvbjPESLhLqG+mNifOjC+93UbUiOZErMzwLvfZvwGsEtOxgKy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EFCB968C4E; Sat, 26 Sep 2026 08:13:21 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:13:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/21] xfs: core RT data checksum support
Message-ID: <20260926061321.GE20636@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-12-hch@lst.de> <20260925232020.GF2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925232020.GF2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 04:20:20PM -0700, Darrick J. Wong wrote:
> > +/*
> > + * Read the checksum buffer for @rtg/@csum_off and return it unlocked.
> 
>       Read the checksum buffer for @fsbno?

Yeah.  This went forth and back a few times during development, and it
looks like the comment didn't keep up..

> > +out_error:
> > +	while (--i >= 0)
> > +		xfs_buf_rele(oz->oz_csum_bufs[i]);
> 
> /me wonders if this should null out oz_csum_bufs to avoid the
> possibility of dangling pointers?  Though I think the only caller will
> free the oz if this function returns error so it might not matter much.

Sure, that sounds like an easy enough safe guard.

