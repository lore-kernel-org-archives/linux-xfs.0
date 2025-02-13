Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE7020B80F
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 08:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739435747; cv=none; b=POKcDNXNeqYHMKUrVIadGWLAf+b57zo3IZZu8AxPWOPHLlYoNGKBHjatlfuVIju+QPOG64dBNCHicJO9DiJp3ZN1Yf9iGWaasBfhTQJ1Oz1Hm12boyLrGMFWywSRCHZw7SURg1+G3RbXzYvRaGfV5gdYq7lhI1ce9yHsi/ohim4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739435747; c=relaxed/simple;
	bh=RVIlVmxySQC8ehBzl3NFUV0LYo3/yZVS5Vuywsda/WI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=akeStLKIJ4tE8KvNbfcf26JQRjDavq2BcdU7fExTKQLrqSZmNr78Pv5qD0AyS2Fv+GowsLkW8TFY278z66Q9Rzg59nNKEaSBwgVCOVPHFhwdniekaoln16DFQoHXbVUgAUq0LgyxpID6hOaKqFhm/kOkon0cM8Fs+ORb2d7UOY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA8A768AFE; Thu, 13 Feb 2025 09:35:40 +0100 (CET)
Date: Thu, 13 Feb 2025 09:35:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/43] xfs: add the zoned space allocator
Message-ID: <20250213083540.GA26831@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-23-hch@lst.de> <20250207173942.GZ21808@frogsfrogsfrogs> <20250213051448.GC17582@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213051448.GC17582@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 13, 2025 at 06:14:48AM +0100, Christoph Hellwig wrote:
> > > +	if (!*oz && ioend->io_offset)
> > > +		*oz = xfs_last_used_zone(ioend);
> > 
> > Also, why not return oz instead of passing it out via double pointer?
> 
> I remember going back and forth a few times.  Let me give it a try to
> see how it works out this time.

Looking into this, the callers treat the open_zone structure as a
context, an passing in the address makes this much nicer.  If you don't
like all the double pointer dereference operators we could add a new
context structure that just has a pointer to the open zone as syntactic
sugar.  And writing this down I think I like the idea, that makes it much
more clear what is done here, even if it generates the same code.

