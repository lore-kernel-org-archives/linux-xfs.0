Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0AE5C82;
	Wed,  5 Jun 2024 00:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717548997; cv=none; b=gb/M79v1BXnzXtLOXPCxHRhr3zqD/7FUcHFE0ycucHS9rOQngphrdRindAnFrSsqk3gT9l6wuH2SL1Rp5+dtMb/BdfLEGXG8XdbGcds+ffM1ToIqsUgSbvq6imCDMKuVM3ms0Ta5gaxa4PDWLukk3RMd6zQICQZMqGoRXUPy1kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717548997; c=relaxed/simple;
	bh=EkcGDI/d9g2ErPQ1MFV2GRCO179w2cJcVv2BfY9mjDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXPMgmOmImuCBpPMAXHjgFJat4ZY2GmTHkEphd8y7aun0mqo+IIrWalYBoqkaf3N63VvmriDwp2iEZxUg36jskmOkLzChhHD+qL9+E1EdAcQfMoXTdwelt2MMTQJy8+F+MEyVAUHC4l/GmiXiV3R1/UwwyLJKB6NKoXbqRC+pdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2GQcK1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2GQcK1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1585CC2BBFC;
	Wed,  5 Jun 2024 00:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717548997;
	bh=EkcGDI/d9g2ErPQ1MFV2GRCO179w2cJcVv2BfY9mjDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M2GQcK1Ce+djp1Ucswz9kl2tARZVwRy//9xLfDi9XP3c/CSdyvpC6jtBc4yyVlyFP
	 7beDyRA0/g4nI7QwWQIAt9fFBlaFn4IbrpLz/lM3qrRfXJ9VG5JsGr6glCC2xNcGqW
	 yP0ecn5b5QgSqVuEDV1so6fHfJ4m9RamKioksmiNUtwQzRCQrdnle+6PfdoJM87jTK
	 fh1t2xCXZj7qkwlt4ZTV3rx/mcJVHGQLUX7G9M1CaEdvYzqAbFs6GqhUvLgyoRtuMm
	 7/miDz5j/j4N+xz1mmhGwvcwt3YCtXDg+LXMT0MX3aDDsa3hfB+TF1orN29wRrx2ET
	 E1n4sxCgeeoNA==
Date: Tue, 4 Jun 2024 17:56:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCHSET 3/3] xfsprogs: scale shards on ssds
Message-ID: <20240605005636.GI52987@frogsfrogsfrogs>
References: <171744525781.1532193.10780995744079593607.stgit@frogsfrogsfrogs>
 <Zl6hdo1ZXQwg2aM0@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl6hdo1ZXQwg2aM0@infradead.org>

On Mon, Jun 03, 2024 at 10:09:10PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 03, 2024 at 01:12:05PM -0700, Darrick J. Wong wrote:
> > This patchset adds a different computation for AG count and log size
> > that is based entirely on a desired level of concurrency.  If we detect
> > storage that is non-rotational (or the sysadmin provides a CLI option),
> > then we will try to match the AG count to the CPU count to minimize AGF
> > contention and make the log large enough to minimize grant head
> > contention.
> 
> Do you have any performance numbers for this?
> 
> Because SSDs still have a limited number of write streams, and doing
> more parallel writes just increases the work that the 'blender' has
> to do for them.  Typical number of internal write streams for not
> crazy expensive SSDs would be at most 8.

Not much other than the AG[IF] and log grant heads becoming less hot.
That pushes the bottlenecks to the storage device, which indeed is about
8 per device.  More if you can raid0 them.

*Fortunately* for metadata workloads the logging code is decent about
deduplicating repeated updates, so unless you're doing something truly
nasty like synchronous direct writes to a directory tree with parent
pointers that is being modified heavily, it takes some effort to
overload the ssd.

(Or a crappy ssd, I guess.  Maybe I'll pull out the 860 QVO and see how
it does.)

--D
