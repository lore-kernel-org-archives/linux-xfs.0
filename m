Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8333838B13C
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389144; cv=none; b=NhMC+wIoZ42rQLN4S8PfZPp7pDyerGoDOZ6aEQhagxLkTo8KoYhfHWkoBwA5228Bp5mZMSqKuMh7cqUw2bmLkP1xF6J9261NWTuECW4KrvWwDn91f7HbWhl1MZgpYPIatWkowyW+3K2tITl0Lccs3JXfTBK75DKDoA0EH4IO5LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389144; c=relaxed/simple;
	bh=Qraz235fcuTdkRuGhAM3R+V8dZn7hyM/tc9MsR8wlIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6YLYXb1rruVFYqFXrSN/JXNO5gH+aZtMkS8xv3M4ccIQ52WW+JI4uDFJLm81SOM0WnoW+/qoK9KPzk+CJku9wlirUKf9M5nY70tDQCn/Ix1PeAIPvZFWXW0xCc0RnohuyaQFVWXM32wMtTe02NUJwXxfFoUufETS87mg6X2FGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 108F568B05; Thu, 25 Jun 2026 14:05:41 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:05:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/11] xfs_scrub: account only data extent tail after
 an overlap
Message-ID: <20260625120540.GI18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484586.915780.6556520830869742008.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484586.915780.6556520830869742008.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 11:16:35AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out that the fsmap overlap handling in phase7 isn't quite
> right -- if we already saw part of the current fsmapping, we should
> *subtract* the overlap, not set the length to it!  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

