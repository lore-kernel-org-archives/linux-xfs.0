Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0404919CD14
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719244290; cv=none; b=EwzuDvtxmfDd0KH/Mxf6ElHyANjXU8qkA27m8eQ7mJbSnfBQ6D50OCC3nNai2W8RDv6eNGWZcDGUvHf6/eP8b7XVPY4Zuvq2ckzTeBe9SbA4qnyxA776xfRV81v/6OjVbYsC9+ARSDF1sS5I6mVoT7QckZPIR2EWwTOPVNsTLAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719244290; c=relaxed/simple;
	bh=c8kl6bA63AB/N8UeMpwWv2vnwxHHHQo6kVU2leCUuRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uvg9NL6TW2hWWQ3yn5l2ZW8DFr8H7S9ZapWh49F/jeCGljhzelRK9Gl4tqXTXqUcENPu5XACSNVI5Vy5VYEPbxCNUqb3W5NvXbJ+Ic4+f90/+7ULEw9UUP8XRs15JZ/RB6+X7kT7FsMDpeXZyubjEcZExz8FkprFDCR8m4aGf88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0A25068D05; Mon, 24 Jun 2024 17:51:25 +0200 (CEST)
Date: Mon, 24 Jun 2024 17:51:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: don't bother returning errors from
 xfs_file_release
Message-ID: <20240624155124.GB14874@lst.de>
References: <20240623053532.857496-1-hch@lst.de> <20240623053532.857496-5-hch@lst.de> <20240624153951.GH3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624153951.GH3058325@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 24, 2024 at 08:39:51AM -0700, Darrick J. Wong wrote:
> > +/*
> > + * Don't bother propagating errors.  We're just doing cleanup, and the caller
> > + * ignores the return value anyway.
> 
> Shouldn't we drop the int return from the function declaration, then?
> 
> (Is that also a cleanup that's you're working on?)

We can't drop it without changing the f_ops->release signature and
updates to the many instance of it.  That would still be worthwhile
project, but it's something for someone who is better at scripting
than me.

