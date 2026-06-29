Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3CC3FF882;
	Mon, 29 Jun 2026 12:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736314; cv=none; b=OOScHJEUwP9RgZ/5fB/OWG6gQj/HkQ+fLWBQOcJrpD8TNC2XysEPXSSlnIg4+SJwEiBuTrJTnshYWFii5X7j9/z8pOD6frEeMo2bDRrp4qTBsI2w1m6u7J8qzJYwS6GHOTX0uvxob6Mumb/3LjbEnnWH2tzO0YIQQHNKbw5nsLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736314; c=relaxed/simple;
	bh=2hbpIe7AHDa0DTrvX6F91N3Qe/fVCk2WZdTigay+9tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dw/cWeE2Xl6NoQ75AyMgjbQ3ubDzz7yubZKZGJNoczw7hVaO5ApnhQW2fqybOlVwtiMy07+k9bH2uFQeHUZVSm6LjdxhFyabfJR/RJBKh0c009lEgH0FQz4KE3eoneo6Of8O0UXAwcMgxeXU/Kq1+lbHjRAr1bOzlP4l1UzS/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2FEC468B05; Mon, 29 Jun 2026 14:31:51 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:31:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-fsdevel@vger.kernel.org, jack@suze.cz, hch@lst.de,
	serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] capability: unexport has_capability_noaudit
Message-ID: <20260629123150.GF21958@lst.de>
References: <20260626114533.102138-1-cem@kernel.org> <20260626114533.102138-5-cem@kernel.org> <20260626152008.GW6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626152008.GW6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 08:20:08AM -0700, Darrick J. Wong wrote:
> Please update the kerneldoc for this function to mention that it only
> checks real capability, not effective capability.  I'd like to prevent
> someone else from making the same mistakes I did with these functions
> that sound the same in documentation but have very different behaviors.

Yes, that would be useful.  But make it a separate patch please, it's
not related to the unexporting in any way.

