Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE2832F747;
	Tue,  2 Sep 2025 06:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756794350; cv=none; b=nxDPESvae21bs+SCi2GeF4uMC4OK2GAyCEeiqS+aNh3+xIeX1AGOttu3F02EVPAVz8di4BY5Utz1voSc2KahkFqoci2g1lCQPgEgNMx9Bm04hAt4abvUkRrDbglwze/GbLEiAfjTfRcItHRC3cIDobR3uqZp2TG5sTjfiWEfXUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756794350; c=relaxed/simple;
	bh=XT0Esfr6DLhDs6arlvV6UcdyzGZvwvv/DwtSq3S9Jjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sLbucYjKqtg6PHpkeFfOtK3WYWFnaBMFLp1PI0G1k2FbeV4wafWC5TQ75qucalmsU7ATGb8WX/tZT4QzVhVVLdfVee5vfzacIWQLkIhLsHd6ViVOvEeXA7wkfiWQ88WPA3bKpmjAaGHwZAXN56SM9yK/ohBiKQDnJHWX+62F2nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4412B68AA6; Tue,  2 Sep 2025 08:25:45 +0200 (CEST)
Date: Tue, 2 Sep 2025 08:25:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: use deferred intent items for reaping
 crosslinked blocks
Message-ID: <20250902062545.GC12229@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126502.761138.11864019415667592045.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175639126502.761138.11864019415667592045.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 28, 2025 at 07:28:38AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're removing rmap records for crosslinked blocks, use deferred
> intent items so that we can try to free/unmap as many of the old data
> structure's blocks as we can in the same transaction as the commit.

Shouldn't this be at the start of the series?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

