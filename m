Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891AC3209;
	Tue,  7 May 2024 00:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715041864; cv=none; b=F+TMHyPEbVyRp5yHF7Y5TrDkUB98J8S9ojVbynj6kYo9yTFTdwxcgcSNIdR1kMh5Px3TtIcmD/ThG10adDAh5w3shjJnxWR/vvcNbMTCn8eaZIFoX0SEI8UCEWRutTLJBz0NFNlv8pt5qIAnrt9oRqrYnFem6CAk/GfZvJeqBKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715041864; c=relaxed/simple;
	bh=6K/qVLxvWM+JIRdXSYZ3gg4O0292aBjfYPKpsDaPkkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9IwFaWtj0XFW+QGM6xWmZ1NtJnwxzyeNdQPR7SltuMINtrzEV8cFOTKuWrgsTLHLKxn5qzFlX9g+DmLvHsU9F3AYP3cn4QpVGpMCR45i9MvlxcNB9t2VUtAgAWz57mQQHwsqXZvVR04aRTGagzSvwk9Dmms7qp2HBir+4PbUGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mWLcirb8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mWLcirb8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eVoHe7gki5cWDhouGnejYKP4ZymSrtyZjdYp0G0mgKs=; b=mWLcirb8e/jEqvmhJ5A9D8/csD
	GZZ6qmjoVb/dLSKXjivspzcuigXDctbMT0xjlSfuxYiNClIYJRz5tk4mOOh/tlTKRSoxpSCb10GEH
	qxpWb0wEa4LHrM62CK7RezooI1KocproXqycgvEfDhml8xak9raWOh7W36eU2O6VJcj9mqcL0TDt9
	Vk6AWv+cSLHqbslgSgK23PX2aNc9yf55LiY3DxSs+6pN9qIMmAiTgMdSeEnxF74MOgXfqXVywu7lm
	xulB4lhrD0MDVF5NTWxLh+Gxg0ExHXWZlXw0Dsa9sSee5/3frZ+/pvlVLFFTUjlemnyLWuIodKEEM
	rrcABVHw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s48jT-00000009A5v-15iX;
	Tue, 07 May 2024 00:30:59 +0000
Date: Mon, 6 May 2024 17:30:59 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ziy@nvidia.com, linux-mm@kvack.org, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	willy@infradead.org, hare@suse.de, john.g.garry@oracle.com,
	p.raghav@samsung.com, da.gomez@samsung.com
Subject: Re: [PATCH 1/2] mm/huge_memory: skip invalid debugfs file entry for
 folio split
Message-ID: <Zjl2Q5fjudt75uvk@bombadil.infradead.org>
References: <20240424225449.1498244-1-mcgrof@kernel.org>
 <20240424225449.1498244-2-mcgrof@kernel.org>
 <20240425140126.2a62a5ec686813ee7deea658@linux-foundation.org>
 <Zi8cYrtxyO7Uw-Mc@bombadil.infradead.org>
 <20240429092307.37bf51c79f70bad4922f6277@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429092307.37bf51c79f70bad4922f6277@linux-foundation.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Apr 29, 2024 at 09:23:07AM -0700, Andrew Morton wrote:
> On Sun, 28 Apr 2024 21:04:50 -0700 Luis Chamberlain <mcgrof@kernel.org> wrote:
> 
> > On Thu, Apr 25, 2024 at 02:01:26PM -0700, Andrew Morton wrote:
> > > On Wed, 24 Apr 2024 15:54:48 -0700 Luis Chamberlain <mcgrof@kernel.org> wrote:
> > > 
> > > > If the file entry is too long we may easily end up going out of bounds
> > > > and crash after strsep() on sscanf(). 
> > > > 
> > > 
> > > Can you explain why?  I'm not seeing it.
> > 
> > I couldn't see it either but I just looked at the crash below and
> > its the only thing I could think of. So I think its when userspace
> > somehow abuses MAX_INPUT_BUF_SZ a lot somehow.
> 
> This isn't a good basis for making kernel changes :(
> 
> Can you investigate a little further please?

Sure, this will require some more time, feel free to ignore these two
patches for now then.

  Luis
