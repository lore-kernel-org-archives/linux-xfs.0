Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5120B446822
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647430; cv=none; b=SyIwUQTW+C5+uF6nwhDHaXi/2hB0EYHVTsuo5qCdQPM2VYK7uSGRuK4XvNc5acMMlX1N1Ugv/GrbJtcmqQ2SedXUgKGWHVJgl76hZ526HV+wPausakmXm9PbPBZ3G7UKeyVy8CRHV244jwQNfs/3Bvd+lmlpGPlBBQcjZ/+KHLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647430; c=relaxed/simple;
	bh=FJl7p5kBn+csQ3hgHCE3R7u0NjyOTPe+PlCoREt6fW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQQMn/cmA/lzUH38nMC71HtPgYdlW/RTikBI227VIH5k/OrFcEgJHKuvVsHv31GBFcNbE/XJJUc1fUCe19r4c6ZQ/wbD4J3LE06yRQRZKgpgz6zWLliuRIwhLcNKNpQrWkD4ltzlDCOwuxCm+kpstalEWOo51WF4BKioBjYsX80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FL5v+8Q0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FL5v+8Q0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC6281F000E9;
	Tue, 21 Jul 2026 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784647428;
	bh=aBnVDPaZxUjX/aFDookiOziiwVxHn48/cT18M+DXqXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FL5v+8Q0ZKFKejLQaspYt+MwROFrHhRKSglxJItIMblZ/Sma7a0AyknCHFWePG4EE
	 CDdQ4VM//tps+m7dN3JU6dqxgCpc2Yxlk5n58DvAkpaCSAe8Mvzbjteg+u9YWU1+Dm
	 Htr/DEqvzp6yeB60H8EDiRCU3xmWB4NbdekzBp7s+se8YuhNM44MA2Rvvlfo7Io7Cg
	 WW7fd6otLkqc4aluFZw5q+FARsK+nT7S7nUhFUO5EQ0iwZbE0zeijy19/Y+9XRfOMu
	 sreKuZ6X/WdKELZfGsWJrL9eG0Wcl0YJag+VgscPsASznSnm7e6vFWBrXcNFGi9cIA
	 aTYsVNOLD8Nyg==
Date: Tue, 21 Jul 2026 08:23:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	dgc@kernel.org
Subject: Re: improve log context annotations
Message-ID: <20260721152348.GY7380@frogsfrogsfrogs>
References: <20260720094609.2191633-1-hch@lst.de>
 <al84nDC0BvHr33Kz@nidhogg.toxiclabs.cc>
 <20260721150142.GA14984@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721150142.GA14984@lst.de>

On Tue, Jul 21, 2026 at 05:01:42PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 21, 2026 at 11:16:40AM +0200, Carlos Maiolino wrote:
> > Thanks. Those all look good for me. But I'm adding Dave to the thread as
> > he has much more expertise with lockdep than me and I'd appreciate his
> > input.
> 
> More review is always good.  But as a reminder for the audience:
> lockdep and the lock context annotations are two totally seaprate
> things.  The former verifies the locking state at runtime, while
> the latter is about compile-time enforcement for the cases where
> that is possible.

<shrug> The new annotations are consistent with my understanding of the
annotated functions, but as I don't build with clang I can't say I've
actually dug into its auto-verifier features, let alone run it.

--D
