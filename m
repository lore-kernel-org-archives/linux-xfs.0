Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88585258CE7
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769609476; cv=none; b=PLdZxDGUa691wUC+7afM/mZTkdC8P2dhxrWLpjSKAcmOexMSS0IaQb79xNxHuWlTSSmvsDylKnmAE1OIR7HV+yN7aEFlCIbJcbj99XB4lgl0s0ms/V7FIKtjsaSQOn52eceUxqzSn3dO4VKG7lSxp2gjCJVXK6TmJgG3M0DxH0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769609476; c=relaxed/simple;
	bh=WsNlbnD+oYY6wTNYxbFE/t3esfSGGD3e2SujOQJOgXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jiu60jOJA/jq/PUiTvsr7yHrLK9FhY6YtY00m6rYzHJlpRZC48Pc25Hcu3pqs+a/BuS5l5GFBfP2EtsdX+XAQvNeH+HMsY4FXFlhbZTL6yCexmvvMNbt7yxy9xPReN7e+pFVAd6H6NqSkCRGOQrdOs4skadFRIwgJFOJij8FGco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 78105227AAE; Wed, 28 Jan 2026 15:11:12 +0100 (CET)
Date: Wed, 28 Jan 2026 15:11:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: allow setting errortags at mount time
Message-ID: <20260128141111.GB2054@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-7-hch@lst.de> <aXnyfoEDhdHTIf-E@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXnyfoEDhdHTIf-E@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 28, 2026 at 12:30:05PM +0100, Carlos Maiolino wrote:
> I think this should include the fact it is only supported with DEBUG
> enabled.
> I'm sure we'll get user complains about why 'errortag=foo' is not working?
> And, in some unfortunate case somebody has DEBUG enabled when they
> shouldn't have, at least the documentation says so this shouldn't be
> used...

Yeah, there should be blurb about that.  Right now for !DEBUG it
will return an error, but even that needs an explanation.

> 
