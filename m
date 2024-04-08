Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487CF127B54;
	Mon,  8 Apr 2024 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588652; cv=none; b=qgdOvlfYwMiKvzXjCSmzku1LSGk6NseS0tTo/o7qoBKgffeZOY2e5XfaG9dC+G2goCHVpiBpDv458nC1+G9F6s/g3v7rTXKSmQV4O4wej74ubtVSPVkdK3Go1f3Rxmho/a0at6G0fBy+EvPWnsau3oaOiMdMSY21cTLgGNsHuTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588652; c=relaxed/simple;
	bh=l6DM9/DAUlhupCVQQJGEIStlmK3io7z79xYDKSwk9Ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHfmu3JyKCeGFw4AKylI8MULgfvnG6NwCbrOowOmSOAurMotQXkcH6awxIGzNgWFL3GdL1AaPmeRLtdXrwGHVWuuHn9crx6IQ6E2ycxt21U/JK+5Bzq7YL7+8fsAzFHXtcPDNkCqyMMKd7dJgWDEC4FhYx4cqwkLkLMg1A+tYEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 855AC68C4E; Mon,  8 Apr 2024 17:04:07 +0200 (CEST)
Date: Mon, 8 Apr 2024 17:04:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: remove support for tools and kernels with v5
 support
Message-ID: <20240408150407.GA27473@lst.de>
References: <20240408133243.694134-1-hch@lst.de> <20240408133243.694134-2-hch@lst.de> <20240408150303.GD732@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408150303.GD732@quark.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 08, 2024 at 11:03:03AM -0400, Eric Biggers wrote:
> On Mon, Apr 08, 2024 at 03:32:38PM +0200, Christoph Hellwig wrote:
> > xfs: remove support for tools and kernels with v5 support
> 
> I think you mean tools and kernels *without* v5 support.

Yes.
