Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115963C4B92;
	Fri, 22 May 2026 10:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779444207; cv=none; b=VaIhXF+H2hxP2y+/T53QnyNFukLexT5EjI0/J2s0sP7NRceQz77v0IJbhWa7FNmcPYNILi/mkA7ZySi7TWqKjfwzUtCIGu0TOXz+oP2bYQyz1HSmT6/sXnm3IaTRohmqWiBEn0f1XBxutaTiq5TtLKxhvWiA4N2FL0nEfEAve/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779444207; c=relaxed/simple;
	bh=Ew3wynC+4lQS88L8QM5VENAs5LeiSwNwOnhVs98s4U4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3T0tQT98r46OfDN5XRQsAlqbX9vkGdIYhOcC2mVwbHx8cZPhaUKiY1ffq89ds/vipZwRrNTFwAMGKJEbx7WA2/MaN5rl47dbLZFSSttb/NoTxhSwGbZjQBpoqHknaJR3I+kQK89x8G5Yhta9HKxVYoLVzyzn8a+mUqv1deQj4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXc8/bqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXc8/bqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1E01F000E9;
	Fri, 22 May 2026 10:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779444205;
	bh=EE7jglkWc5b02EajD9Hq94MBW3TL9+QMd/i5HrD5hLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fXc8/bqE5m2G9NEvKfhSpZy/CbTM6but4CMy/iSqgF60B3nrQyz8f0utXEFOxdil+
	 P9+L7Vg7+dL5oU8/pe9hR00UqggP/TKnh7bcf8hQ8CElz45jdgnQOF+MSkRupA7pqw
	 hAGDNvrzV1oUbeupPtwVTRgRtRqanW5BnOcvIHbDFddqfJIP3Uelyv+1ZK+4vo9PU2
	 aVUAeDPJCBGQmlexODZiwr7nRZVfBGPaTuWdp+0wT2xRA8ggKinrOyEtXZ/Ntdii+l
	 r5zKxDnskkUwp2l9kiezcdJjtq6/xnqDFIbp2onQkt0qvdZQy/1IjZ5C9PQDFGaBh/
	 1UHtSubvYuffQ==
Date: Fri, 22 May 2026 12:03:20 +0200
From: Christian Brauner <brauner@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, Andrey Albershteyn <aalbersh@kernel.org>, 
	linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>

On Thu, May 21, 2026 at 01:38:38PM +0200, Carlos Maiolino wrote:
> On Thu, May 21, 2026 at 11:42:13AM +0200, Andrey Albershteyn wrote:
> > On 2026-05-21 11:07:05, Christoph Hellwig wrote:
> > > On Wed, May 20, 2026 at 02:36:58PM +0200, Andrey Albershteyn wrote:
> > > > This series based on v7.1-rc4.
> > > 
> > > How are we going to merge this?  It touches at three subsystem trees
> > > (fsverity, vfs/iomap, xfs) so some coordination will be needed.
> > 
> > As most of the patches are xfs, it's probably make sense to go
> > through xfs tree
> > 
> > Carlos, what do you think?
> 
> I was expecting this to come through xfs tree too if Eric and Christian
> agree.

You may take it through the xfs tree if there are no conflicts with
vfs-7.2.iomap. If there are I want to add the iomap changes into
vfs-7.2.iomap that you can pull in.
