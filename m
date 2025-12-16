Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60D328DB52;
	Tue, 16 Dec 2025 05:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765862029; cv=none; b=JMxzdhQuzLlWKiZHwkQ2O+sQ8ODLz0sCLZ8ZKXxK4uG9agzZjLc1333OXS6+LhCEcdgkJTbn8DhEnedLIFB4PjwbHwdmMGOohO3Dd1oePmtJcwkveUEO34KnfSNAoN9h6iVMSa7hEwxwdVLdN/2XnUwoNXLqj+9QjBd1UcWEOeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765862029; c=relaxed/simple;
	bh=h54qrPqKsrlyFXzqvRM4PJXFknKWw+3Kar/Cr7Y7P3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFXDL2G8oEGxsobwQTkf2ayC+akHWJmVGxijLo8ljyHv2KYEv0cyCZD/0n+TBd9JqzHtxJBamlN8q08D0Ls7z3PW+OZn8us29wZCK+njPQy9amiKcxvdNTKoOMgkuCQdZqv5lNe7XbZv9AatYZM9MNOY4F2nReTEYWLcDiE14ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3A244227A87; Tue, 16 Dec 2025 06:13:29 +0100 (CET)
Date: Tue, 16 Dec 2025 06:13:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: add a test that mkfs round up realtime
 subvolume sizes to the zone size
Message-ID: <20251216051328.GD26237@lst.de>
References: <20251215095036.537938-1-hch@lst.de> <20251215095036.537938-4-hch@lst.de> <20251215192552.GK7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215192552.GK7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 15, 2025 at 11:25:52AM -0800, Darrick J. Wong wrote:
> > +# the zone size to create mountable file systems.
> 
> What size rt volume does this create?  It looks like you're specifying
> an rt zone size of ... (1GB + 52K)?

Yes.

> And testing that mkfs rounds the
> rt volume size down to some multiple of that?  Or is it rounding the
> *zone* size down to 1G?

That's it is rounding the RT device sizse down to a multiple of the
zone size, for which we default to 256MiB if not specified.

