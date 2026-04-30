Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757903BA25C;
	Thu, 30 Apr 2026 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777560815; cv=none; b=K/peMDoFb/H2aoRM+YBWnXK2L5xw3IEeAdvX9VD6TVdd/jeYHg+olOQobeuxOIa2OzpPqXsPfuS3R+MfKuD1wBYKRDW1mxwALH3jHj+N0W0se0ppGBCbiiC8nWBu82Q9KvpGzLq2rRswwIBDvzcezxIRgVHlJBJsAL3YMmdOrEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777560815; c=relaxed/simple;
	bh=qkb80/mDCIcXFxIRkDb+ApDFzlmtDSCkOvoUPXlQlvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyU4AS2ohz14EeqNJ+0UqNQswSfg5ODCLW9+jFBCHgBayifrRsSbDdePkMdmF3TETWYv4X9nrsSOuOJ8DsnplKie4o3q1O0IjUldaLISsQ4aaV9hKT08m61Ay4sU7Lo8DIQjcggFzSAuuXfmodTCyqdVtVpAmBzE/0wfJHrvU8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B8BC668AFE; Thu, 30 Apr 2026 16:53:29 +0200 (CEST)
Date: Thu, 30 Apr 2026 16:53:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: pass a minsize argument to
 bio_iov_iter_bounce
Message-ID: <20260430145329.GA30990@lst.de>
References: <20260430132019.312405-1-hch@lst.de> <20260430132019.312405-2-hch@lst.de> <afNZi5HRDWtK9Wdx@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afNZi5HRDWtK9Wdx@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 30, 2026 at 02:30:51PM +0100, Matthew Wilcox wrote:
> Seems a bit inefficient.  How about something like this:

Works maybe a bit more efficiently, but also is more code and harder
to read.  So unless it actualy makes a difference in a relevant way,
why bother?

