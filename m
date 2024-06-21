Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4488364AB;
	Fri, 21 Jun 2024 16:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718986856; cv=none; b=HH9D+M3ClDWgHcTB8EQxWsYQ6ZmIP6AtaqMG6wbRyn7qz9bzoFVmKUc+nPo+sGlnggQIv/1xTt+6MhIvc5X319puVM8HSRUX1x+Pqn669MsDI2Mhm2SG1EhS4dlHncNWLdO7640hhJIeSMzgTdA55e0Z3Pj7LoOo+r82/JUdc4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718986856; c=relaxed/simple;
	bh=RpD2VZrSv7AsfIRL7CEr6zvYm/zKg6S2eqMZiqHiSrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bvvvv9oODY4Q9bSTR/IecRvNnK1PDuQe+WVG4W+X7+AO7lsgvirwYF39TJb2NOnB/9glDyIflJ2KFIaHNtyAYo6ZrkW+IGBtCOeYRK0VeSeaTfMwytYPR8Urs07NAFwg9IC27Y+vAGyb2VaAealwsldyR5W3F2+Efrk0OwR3wLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=au+5m4nH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="au+5m4nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3ACC2BBFC;
	Fri, 21 Jun 2024 16:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718986856;
	bh=RpD2VZrSv7AsfIRL7CEr6zvYm/zKg6S2eqMZiqHiSrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=au+5m4nHUSRR9xgWgH+A3NLe+ykat69i4tkQuv12bcEbO9Y6a56WrsuvJYuJjA9Gh
	 yxu2x1LSnta62svKL9t2/18eh6Rr0daeQvFsAxXuF4/OdhszdYi/2B9kkt4lGerLMh
	 k1RwNH4fA3Sk1reFjwrwCEhLtN5WDSSpsYHWv1puU++PfimDcQ+ZzsRyD+hBb7o/Mi
	 /Z8Zqp2vR5glEaQXauIRTYkqKNLQSC0PVBry7+dJdi1JI5r9gBxUqSttW+Vuirpapa
	 zDMwJn5KO2zbSFIzlG0fs4f7OuMoQhKcrqcbzTKawYy+F9v+ntk9bCCKfwAfGWprcW
	 eWJ2Jr3x46YkQ==
Date: Fri, 21 Jun 2024 09:20:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/011: support byte-based grant heads are stored in
 bytes now
Message-ID: <20240621162055.GC3058325@frogsfrogsfrogs>
References: <20240620072309.533010-1-hch@lst.de>
 <20240620195606.GH103034@frogsfrogsfrogs>
 <20240621062903.GA16866@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621062903.GA16866@lst.de>

On Fri, Jun 21, 2024 at 08:29:03AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 20, 2024 at 12:56:06PM -0700, Darrick J. Wong wrote:
> > > +	# The grant heads record reservations in bytes.  For complex reasons
> > > +	# beyond the scope fo this test, these aren't going to be exactly zero
> > 
> >                            of
> > 
> > Why aren't they going to be exactly zero?
> 
> Given that frozen file systems always have a dirty log to force
> recovery after a crash we also have space granted to it.

Might as well say that in the comment, then.

"The grant heads record log reservations in bytes.  Frozen filesystems
always have a dirty log to force recovery, so the grant heads won't be
exactly zero..."

With something like that
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
