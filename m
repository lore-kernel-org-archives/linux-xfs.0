Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF10367283
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2026 05:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661859; cv=none; b=iCTwk12n/rfdJIDRzL1BoFwNiqHWWIjx+gmgGBrM3Wck2q9igmcK6FJjuJfWPsVxH45Vr7nDtkX9CLgce5/ZAU6PlbMh9thHAM+Gqh2mtHAISwIOSzZQykgeKcoqe68HSF/cALPP/Yr/LFG421L3r8hZCfAUkWOIYJJQnMMp5XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661859; c=relaxed/simple;
	bh=jts3AIPUJSCQm+kswYL4YmOwpKfNgKRge5nJ7WvV+kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AeaC0KynY7il+On+95IWbkY+Odlyjnr5wA8ShqSP9YNYiIWFUWtYUiPmz71lnrI8H+iIyLYxR3SVUIM7wou1iiekk4LsEW2PS6yJMFyqSywj5ZeI0EydkNvd9EYV1FblXR7WwJtvaaN6JX1aYS8w9B8vbv0HO3pbrlVmJlnKYRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2C83468B05; Fri, 10 Jul 2026 07:37:35 +0200 (CEST)
Date: Fri, 10 Jul 2026 07:37:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: make cow repair somewhat flaky when debugging
 knob enabled
Message-ID: <20260710053735.GB7392@lst.de>
References: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs> <178366081035.1173468.11677090109948628757.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178366081035.1173468.11677090109948628757.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 09, 2026 at 10:22:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Introduce a new behavior for the cow fork repair code: if the debugging
> knob is enabled, we'll pick a random subrange of each cow fork mapping
> to mark as bad.  This will exercise the xrep_cow_replace_mapping more
> thoroughly.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

