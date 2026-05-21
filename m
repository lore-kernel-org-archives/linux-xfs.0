Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278A037DEBB;
	Thu, 21 May 2026 11:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779363526; cv=none; b=cvcs1F1BuAKcRVL8Rs+SJVsd4i/ozPmNBG2nPi+2jkQBg0JUdSr+XnmC8+KczanswH6EaUu0l8r7aBehMQdWs9nJvBQ92q4CmiteiUTLL4p9M+gPte0kbxEw/mJi53emRYqWBKu1UyLaGQhavGP+/uLSaKpY+3c+WsjfEgjKlLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779363526; c=relaxed/simple;
	bh=gCOgvP0dnSppEKZpVpJvxR/Lroe4e5A/Ys0p7XR8/h0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVT0hKB8GO9yaolpykuCdT/oEpZ3/CzHTieiyKowLQzLC8msLTP4eaSXf31W2OF3pmSG3+tXQ5z+4y+hxxv/Hqn/JatCJGa3P4PrYBxD4V003vO7WyvJdmIY0pxrkfvA32tyOenyG1PfXLdb+p97dzAhWIFfPMgzStTe9BhAVQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBV8PG4V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBV8PG4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41BA1F000E9;
	Thu, 21 May 2026 11:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779363525;
	bh=rTwZ36g4KGNrjmP2zhYmYAfW/FKKRnhts60EBcPJrhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DBV8PG4VrYTDqdN9t/cCQWnjSSYEiRIyWE6hcxudD8ZlgGK+7cSwHRHQLbCS9ZvNX
	 249JW+NoKSWCXJ5+lO7HxMUDojyhtM8K+Ed5gC9qS4Y82fH/JwrYkDHfy9v04Yh23K
	 3Q9M9ZnQHSiVs3u/g6gQ/EmahcO92BEQWC/BpNj7m7GPdu8V2Iz6s7eyZetIm06DdU
	 AEPie4YNg7zKA0tizxBtdO3xTjCyt1ZPqapck9FBsTvnbgIs6jSyxArjshxxmOjkVr
	 3Y3BIbRQxuFR0Vb7Yi2i/vYJCOjJFWEDFhWiZk8VHhE5smjMDKxishmH5E1PAQ6sIE
	 QyjsJwtDSAIeQ==
Date: Thu, 21 May 2026 13:38:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com, brauner@kernel.org
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>

On Thu, May 21, 2026 at 11:42:13AM +0200, Andrey Albershteyn wrote:
> On 2026-05-21 11:07:05, Christoph Hellwig wrote:
> > On Wed, May 20, 2026 at 02:36:58PM +0200, Andrey Albershteyn wrote:
> > > This series based on v7.1-rc4.
> > 
> > How are we going to merge this?  It touches at three subsystem trees
> > (fsverity, vfs/iomap, xfs) so some coordination will be needed.
> 
> As most of the patches are xfs, it's probably make sense to go
> through xfs tree
> 
> Carlos, what do you think?

I was expecting this to come through xfs tree too if Eric and Christian
agree.
FWIW I'm adding Christian to the Cc

> 
> -- 
> - Andrey
> 
> 
