Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4384023F42D
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 14:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762958226; cv=none; b=Xbx+0jcr2xPswXcIFtdgPLPdXU9umgWsjlMWzScdovX/vgRmzWtplY7wyhlDZeNi7qAftdNQVQgoh3m7ftez1Nwhl2MTNZlp/dalpa1gu4HlDPefbAefCxN3VoRWpT7ZC0bbOpzywZLRRgV3kGmAWUVtMKdNGYHboGxkzb94zzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762958226; c=relaxed/simple;
	bh=PJvfuqGQt1mVMo+1+4PgPgx/pa2DXoaXyGTzm8HMejQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ttar5SoORdlk+2/JwNEDor5rnQICJ19KBmTVGYWEJ9OfJCrFziAEyN/1f22+JpaiykBZOmoot4Kt00e73T+lFuDavEp1RaQcUi+omvWOjoKYiJMToT2h+/7IszRKSkprqRkFSkQCPUqwTGjFPJSkdgnhf2HE4+Fc2g5xzBiq9Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 80665227A87; Wed, 12 Nov 2025 15:36:59 +0100 (CET)
Date: Wed, 12 Nov 2025 15:36:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, aalbersh@redhat.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: fix zone capacity check for sequential zones
Message-ID: <20251112143659.GA2831@lst.de>
References: <20251112123356.701593-1-cem@kernel.org> <uUmqo8OzhTSa5OB27aq49lemNQh91fH_TCYzB5kvOcruOsQHbBfzrdozvkQ3xIWvFb_iB9od-8CjKaC8vQGP2Q==@protonmail.internalid> <20251112125056.GA27028@lst.de> <na5s5f2afoc3w5sijoq4xqni3oex7ivxqkrqfz5pt7dtf5aivr@3xvsap3qzpcw>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <na5s5f2afoc3w5sijoq4xqni3oex7ivxqkrqfz5pt7dtf5aivr@3xvsap3qzpcw>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 12, 2025 at 02:25:11PM +0100, Carlos Maiolino wrote:
> Your call. I can add it to the V2, giving I'll rewrite the above to
> remove the unneeded braces.

Nah, let's do one thing at a time.

