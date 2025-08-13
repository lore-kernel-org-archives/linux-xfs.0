Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3F3293C71
	for <linux-xfs@vger.kernel.org>; Wed, 13 Aug 2025 05:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755061701; cv=none; b=kngSrKIKSw0tHF/iMKtb/aU+JwLYyPQiD0uolbKSqWupnofcV9w1BvAIa0WXcpGYUdjpPhnrNhhXfbj+ztovIVDhiAz7D+fWuPW12dQZLSP4IHAEFRduvpNoC9oG94qgwUBcQr06cnbqoet8ySqpnhibCiso/CpyBl6qmoBsxXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755061701; c=relaxed/simple;
	bh=J7QsV0ixdjzA7u45/ehXjoyzv0HuP7FnElAO2DA1K7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpXI5lFbFrSRTly8BvTBQ7kNTQFS0KLjTXdMza0NSU6jEhXA9DfVzME+3O3AluxZNDyfBDLDgFnTz8NFPn1ZYdCzY+BW/2888eZp+Fd8my0VgKtq5ADieMcUU1nXbcxukxnHvgMSVDVlyAgEixRjVKBPYai6MrAo8MPhMoKxezc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DE6AF227A87; Wed, 13 Aug 2025 07:08:12 +0200 (CEST)
Date: Wed, 13 Aug 2025 07:08:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: sync xfs_log_recover.h with the kernel
Message-ID: <20250813050812.GA10169@lst.de>
References: <20250812090557.399423-1-hch@lst.de> <20250813022021.GR7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813022021.GR7965@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 12, 2025 at 07:20:21PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 12, 2025 at 11:05:36AM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > syncing changes to xfs_log_recover.h has been a bit of a pain.
> > 
> > Fix this my moving it to libxfs/ and updating it to the full kernel
> > version.
> 
> Looks ok, but what's your motivation?  Just making libxfs-apply happy?

Yes, or rather to make the user running it happy :)

The current trigger is the log iovec cleanups, but I ran into it a few
times before.

