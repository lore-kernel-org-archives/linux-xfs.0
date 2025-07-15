Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3D82566
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 15:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752593708; cv=none; b=h+cNaz+q7Ai/+QE6q86NfVuIqDLl5TopDLWzE254zbJ4lGtODECxF4I2ZskY9JRxltMMMs3G8CsEeI8sjBeCzr/mQ2SvZWholhvi+up318PZu6wwC0CyHsEm8J7SsDjLbsv1T6Dw4IX7Mzs+eLK9wbCBSTSlNszJFlpLLY9X+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752593708; c=relaxed/simple;
	bh=9ZdKNg5pUO+ygsNnOlVyTOlPOqXkIR/np0c+GSc7Yo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dv06idEdNASbrvPGlx6b0gj1YUy/QSpCFy+3DYY6mVtwkbQ/jjOC/2WpyuQPqbNv0mt4sm66cNKwb8fDKmTDDId78bivmNrbPonWW+qYIlhh3HjqT3qlK2i7m8VbgYwXe5+P2NvYpJkDPbKRMJVlYVh7EdqDGy0o5/INNexBlug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1B636227AB5; Tue, 15 Jul 2025 17:35:01 +0200 (CEST)
Date: Tue, 15 Jul 2025 17:35:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: don't use xfs_trans_reserve in
 xfs_trans_reserve_more
Message-ID: <20250715153500.GA29642@lst.de>
References: <20250715122544.1943403-1-hch@lst.de> <20250715122544.1943403-3-hch@lst.de> <20250715144944.GU2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715144944.GU2672049@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 15, 2025 at 07:49:44AM -0700, Darrick J. Wong wrote:
> > +	if (blocks && xfs_dec_fdblocks(tp->t_mountp, blocks, rsvd))
> > +		return -ENOSPC;
> > +	if (rtextents && xfs_dec_frextents(tp->t_mountp, rtextents) < 0) {
> 
> xfs_dec_frextents is checked for a negative return value, then why isn't
> xfs_dec_fdblocks given the same treatment?  Or, since IIRC both return 0
> or -ENOSPC you could omit the "< 0" ?

No good reason, I'll make sure they use the same scheme.  I don't care
which one, so if you prefer the shorter one I'll go for that.

