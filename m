Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5F5406802;
	Mon, 15 Jun 2026 15:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781538050; cv=none; b=DMGLt1onEab3yn0/W+Wm7irP1GrJTDvyNH0js5PV1EZ2bOxCZslfREPPx/s70GJUmAoztTSIjmEZ0nr5c5LM5DMd/2f488zm0/Qka0YFiBA7K+N9YYb7nc2ExNlwbL+m5rkoy0IqkXI3tXWB73fUEJu8uNZMx3Oik6k+mvH7Oow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781538050; c=relaxed/simple;
	bh=wTudfb/lgP1SNCOGON4wVwZAaXmddF4M7JcGKgGZpgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGghKLMsVhYD38WvJNPnDBmOUZfN+D1b6KAq45JpKcRaeUavaXXPz1rJPlueUlxYAB6BD6+DiM/WMQaDAt4pDLvOSRehKss7cOkgHGBVF6waG1Deyl3N/lahKofWPrNORBYZ/tXc/PSNdqbDSueVCkzcHKQjdaub9Gvaeu54x/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8UJCcqY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8UJCcqY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 725AC1F00A3A;
	Mon, 15 Jun 2026 15:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781538049;
	bh=D0rfnJ+PevS9N2+tSchV8XhMn/AQ46GnVGBbvgDMDqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f8UJCcqYlL5F5phmqOKscoPO8dz8wwwq9+SqDy2G9qcX6q5ouYJJgPir+XX6Ct7ln
	 B2HaJZ6dyjIZ+BKapq/QX6H+tgUZMJzy5Slk9l2o/8HT1f2tFr2uVnheRrvoSeFfPp
	 U4PB44Dc5BXVvFCD6v7LD0cIv4BXBHO90SF5xAc0FgIU7hTRvYTYWwzf1+uWRo6LOX
	 FCCc8pri9sNcfQBq7YjYmzok1FfWsW/UyeX1W2HWB/srx6tO7kqbiNrP2n4qvj1Xc9
	 xfLBpM9h8wXsiVvuVZDhu7w+dT2vV3dx+DZrdDMifvzdcdcYuUBOYgB147VMs1l7ed
	 UsNiqtt63zs1g==
Date: Mon, 15 Jun 2026 08:40:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <20260615154048.GW6095@frogsfrogsfrogs>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <ajAJ6lXJWcko4epj@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajAJ6lXJWcko4epj@infradead.org>

On Mon, Jun 15, 2026 at 07:19:22AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 09, 2025 at 03:13:47PM -0500, Eric Sandeen wrote:
> > Hey all -
> > 
> > this got long, so tl;dr:
> > 
> > 1) concurrency geometry breaks some xfstests for me
> > 2) concurrency behavior is not consistent w/ loopback vs. imagefile
> > 3) concurrency defaults to the mkfs machine not the mount machine
> > 
> > In detail:
> > 
> > So, I realize I'm late to the game here and didn't review the patches
> > before they went in, but it looks like the "concurrency" mkfs.xfs
> > arguments and defaults are breaking several xfstests.
> > 
> > 4738ff0 mkfs: allow sizing realtime allocation groups for concurrency
> > c02a1873 mkfs: allow sizing internal logs for concurrency
> > 9338bc8b mkfs: allow sizing allocation groups for concurrency
> > 
> > Specifically, xfs/078, xfs/216, and xfs/217 are failing for us
> > on various machines with between 8 and 128 CPUS, due to the
> > fundamental change in geometry that results from the new
> > concurrency behavior, which makes any consistent golden
> > output that involves geometry details quite difficult.
> 
> Did anything ever come out of this?  We're hitting errors in exactly
> those tests in the zoned XFS CI (which also tests regular XFS).
> Shin'ichiro recently spent some time tracking these down, which
> finally made me remember this thread.

Lukas Herbolt posted some fixes for a few of the fstests to inject
concurrency=0 into mkfs.  IIRC there weren't any changes for 078, but
you might ask him if he has more bugs to address.

--D
