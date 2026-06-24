Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A783911B6
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 07:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782286930; cv=none; b=jkqC8hPFamdYVEoTWIWnfGRk31vO0hKcyrLtngT2xkbexiMI3sZdL1MSNOgcK55WcI/bmjOzq+fLHlJ1/mAexlNy1huqnYGd/sVF6CGJCdIjTX23cyhsa5knh7SU1ykFz3/tA/I3D8JM8cl9QG4k4VVp+eqrfJAtANp/51ZrIzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782286930; c=relaxed/simple;
	bh=FS5hT+eeEOeb7tYj7ZbUtYmtV0YDN/WBOnfqzd4j/Is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgK9hmSsifFwtTQ9OmibJChoo+w6vDEv0hOh51P6wgfXEZNNeJVA9ha1EZWxMgAyrNOpz5EpBPwtdN0jOMf9QqgPIj98KxXng1dqPt8EvKUzHJf54VAtLsHD+YWqzBiLRaW4y/SQ/0fqqkPMB/jxB6oIaitT3eRAO3P4Oqgeqxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 58B5368BEB; Wed, 24 Jun 2026 09:42:06 +0200 (CEST)
Date: Wed, 24 Jun 2026 09:42:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: improve the xfs_buf_ioend_fail calling
 convention
Message-ID: <20260624074206.GA12969@lst.de>
References: <20260622073035.1370904-1-hch@lst.de> <20260622073035.1370904-4-hch@lst.de> <ajkxAU-VxjRrHVS0@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajkxAU-VxjRrHVS0@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 02:59:05PM +0200, Carlos Maiolino wrote:
> On Mon, Jun 22, 2026 at 09:30:02AM +0200, Christoph Hellwig wrote:
> > Move setting the ASYNC flag into xfs_buf_ioend_fail_async, assert that
> 				  Is this a typo? I can't find this
> 				  definition anywhere and the code also
> 				  moves this into xfs_buf_ioend_fail(),
> 				  not into a _async variation.

Yeah, this could use a little update.

