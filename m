Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D226F2594B2
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736229914; cv=none; b=DQ6JCK6lvUFYdzyFv3v71eMG+Ls+ePiK+9s1qk3UVdJna7ihKTqmBWutJHdZYTkZ20lfca9Q5A7WJTfHsaDYeQFQqiQ4DGuJkqtc5kQUnHfeK3lFNsRxb4UW2WCMEwXpOcPCGfpaU/k6TrodGaBbsM2N7OfWXxeec0OmQEsvr0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736229914; c=relaxed/simple;
	bh=V6fS08LtznbcNOZsjl04CgtvwA6NfS0TXxx5dV8BPpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kd8P66junilg19LQQz9RI8vrQxGDF+4IUWc8M3MUWjF2NBlgqkInnP1P7bA3kvebkZ5K9PX1NABmlNAi9zP3Yw3Cj0ZHrkspyuow0hx3v1bL5C2x8Ht20UUUdN/mlfgiYn0CCFRGErgFt5NKnTx/RrlFbR/Tz2sgKlWTM/BXaZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 505A167373; Tue,  7 Jan 2025 07:05:08 +0100 (CET)
Date: Tue, 7 Jan 2025 07:05:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/15] xfs: fix a double completion for buffers on
 in-memory targets
Message-ID: <20250107060507.GB13669@lst.de>
References: <20250106095613.847700-1-hch@lst.de> <20250106095613.847700-2-hch@lst.de> <20250107020035.GS6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107020035.GS6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 06:00:35PM -0800, Darrick J. Wong wrote:
> Cc: <stable@vger.kernel.org> # v6.9
> 
> though I think backporting isn't strictly necessary because in-memory
> buffers don't have log items, right?  If so, then we don't need to cc
> stable.

The stable CC is fine with me.  But as I tried to explain I think
it's nor really causing problems right now, just a double call
to read_verify.  It is a bit of a landmine, though.

