Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213C136167E
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 05:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776921168; cv=none; b=jde/511lzCEUjvtsBL7oeFqppQ5+Hq0eq0NQFWjgRFIHATb6UqeQAac9eP6//4hAunVY5UIy3J/CwTEadoiH6yWSxjPGz4C4paTBKE3jrWL2G0XJyE5Pi+bpcJgFVl+gpClehI+0mv3pYiwyQIYVhiM7P/N/V91J6amhckNUbbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776921168; c=relaxed/simple;
	bh=KqUptZicW/Gnhuxpi9c/ZASwoO/VZvk5mdr2pLPw3qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhMbfBclUEdL7uGHxDRfsLg8Z7RjTfEu2yTSYVUNu+O3Yyyj0RpGlOL4+WYnu5rw34Ufso47ZoWHUO0uqSiuG0zDQg5OJMsxR3J0xcTnaIt5AMJCqbH3mnn/VEAGyWb7KQqvqeFimH9nEUExIZS3/Ma7iC12yCKffhROup6hR60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AB14D68C4E; Thu, 23 Apr 2026 07:12:44 +0200 (CEST)
Date: Thu, 23 Apr 2026 07:12:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: expose the current zonegc required status in
 sysfs
Message-ID: <20260423051244.GB27929@lst.de>
References: <20260420135011.624587-4-cassel@kernel.org> <20260420135011.624587-6-cassel@kernel.org> <20260422060417.GD5391@lst.de> <aeijmOd6zHDQeA7x@ryzen>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeijmOd6zHDQeA7x@ryzen>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 22, 2026 at 12:31:52PM +0200, Niklas Cassel wrote:
> Or perhaps I am missing something here, and for some reason, unlike a sysfs
> attribute, the information exposed in /proc/<pid>/mountstats is not considered
> a stable ABI ?
> 
> 
> That said, if you prefer 2) or 3) over 1) for exposing zonegc_required,
> please tell me which you prefer, and I can send a V2 with that.

I'd prefer not adding another API for querying this detail.  Especially
no a fairly heavy weight one.
