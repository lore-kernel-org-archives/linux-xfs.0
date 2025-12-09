Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D80D2FE582
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765297214; cv=none; b=Y9OL5n/gILh0CKNch0eW1z20MUd8SJsmn9Ofekk6hj5krDrXK8vTyXXtGwuSVa0EtPvFQxGGE9b/95d22cW4mhmccd0p/o83g5F3UCPpSmbvSs4FMCFeTo9/ZkWGFFbHF7Dnml/64Xxr0VuBNOJLT79wk14XqrV9nI/scgIcaQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765297214; c=relaxed/simple;
	bh=RfpJWnq6lKb5NeLA3Dvvzu+ewfpZ7td7sbkjVZ6FBwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lR6JMbmT5llBM0/Ua6QoA6v6Enoxvq2xJ4lk3xYWFOq2flI1Xolb9an+kbDmZVSz6AtnA8t1pD7Jln0G1RO1zrZTcpjE2rkGrYdLtSM+clB9k0gBC7t+xGrtDBxvL1fgq5oFhL7mahoSD0Lhfu30WxGR54hyRdSMolpv4gj1nTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ADEBD67373; Tue,  9 Dec 2025 17:20:08 +0100 (CET)
Date: Tue, 9 Dec 2025 17:20:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_
 constants
Message-ID: <20251209162008.GA8744@lst.de>
References: <20251208071128.3137486-1-hch@lst.de> <20251208071128.3137486-3-hch@lst.de> <20251209155907.GU89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209155907.GU89472@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 09, 2025 at 07:59:07AM -0800, Darrick J. Wong wrote:
> > +_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
> > +				xr_ino_type_name[type], lino,
> 
> The %s parameter still needs to call _() (aka gettext()) to perform the
> actual message catalog lookup:

Ah, right.

> 
> 				_(xr_ino_type_name[type]), lino,
> 
> With this and the printf below fixed,

Where the printf below is the other one printing the array?

