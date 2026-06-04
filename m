Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAB942EEDD;
	Thu,  4 Jun 2026 12:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780574906; cv=none; b=eTWJxCU2Uyt7COpIhFqnrzS0lymxEGjg19AJ1WJym/GpbhYgviViIM0kHwFr66e+TWNXw29rCVurI36Zp65Act5WGRLfEFA8MkJwLM2ioXdTTGYoqRmS9JKqVLZP16aXZ5xP6+P1kwZc+gtvWvAPjFkqtvEfQygi/nYuZBeH3dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780574906; c=relaxed/simple;
	bh=LfaFUmMQyjZHO3KS4+iNpnsCVjTMyIBIVLpR3PnSU+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bDRahZc9m72/LxZDOB6ozrYtkpIaOlvAGmDf6Erc7Ku4XA7D6/SPH3Rykm5dObRZbPKlHUyxn2BOFTFeHWB5vMDsehJc/X9YAnfca9/kIOlgXG1h9TEI1zKzD35OqSzMfDmKiBxL4hKQadlHI4ZE6u7vfoVDf0+VT3XMvYC9OOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hviMYelb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hviMYelb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0591F00893;
	Thu,  4 Jun 2026 12:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780574904;
	bh=dqjWETgw2fdknLUk3DwFQ4twFF3wQf7ZwlKX+xqjr7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hviMYelbCq1FD1zUQhO+fHm5JXTR/dphxJCOG961fCE36/10DX6upgx+CDnxsr5FX
	 E7MQVJW6QmbLnI4404ldzJhbz07IxXLVrtKFK1UfQs37p2h5nMYbL9uvFe+0lXC9zM
	 /vSYlIo+hzLFJHw5bjRN9Qeb+00uVswiUz9YmLM5wDKhovt9TToPv3JYsZ4fuW0Amc
	 ToaJ3qV8OdYyBWByuFT+ELyEYx8lgP+Ra0oTsmTgYQCW0/pEi3v8y6HbDUpJUfzbOq
	 MI1Rxx2X/JgEK8gcgHC3OQ50l4LmIzfEAumH4sEFYuy8J1CBGjjQQucDd6JVnnfWZv
	 9Vtsb4RtWox3w==
Date: Thu, 4 Jun 2026 14:08:19 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <aiFqn8uEq_iR2ae7@nidhogg.toxiclabs.cc>
References: <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
 <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
 <20260522120757.GA21041@lst.de>
 <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>
 <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>
 <fjdfwhwi4aogyiaoijwvw6w4npuu5mbt6ua6fkhwcp5ajlm543@ume2fkxg36cb>
 <aiE_YQc6SGSdWlcE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260604-holen-rundum-ausfechten-2193b39da363@brauner>
 <yezqqgowgmbn2z42zvha7cfcprym5vnurb33brdmooab6csdks@a76a7v6rtywn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yezqqgowgmbn2z42zvha7cfcprym5vnurb33brdmooab6csdks@a76a7v6rtywn>

On Thu, Jun 04, 2026 at 02:07:05PM +0200, Andrey Albershteyn wrote:
> On 2026-06-04 14:00:07, Christian Brauner wrote:
> > On Thu, Jun 04, 2026 at 11:04:32AM +0200, Andrey Albershteyn wrote:
> > > On 2026-05-28 16:50:45, Andrey Albershteyn wrote:
> > > > On 2026-05-28 14:20:08, Christian Brauner wrote:
> > > > > On Tue, May 26, 2026 at 12:19:43PM +0200, Carlos Maiolino wrote:
> > > > > > On Fri, May 22, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > > > > > > On Fri, May 22, 2026 at 12:03:20PM +0200, Christian Brauner wrote:
> > > > > > > > > I was expecting this to come through xfs tree too if Eric and Christian
> > > > > > > > > agree.
> > > > > > > > 
> > > > > > > > You may take it through the xfs tree if there are no conflicts with
> > > > > > > > vfs-7.2.iomap. If there are I want to add the iomap changes into
> > > > > > > > vfs-7.2.iomap that you can pull in.
> > > > > > > 
> > > > > > > Merging the iomap bits through the iomap branch might make sense, given
> > > > > > > that iomap usually tends to see quite a bit of activity.
> > > > > > > 
> > > > > > 
> > > > > > That sounds good to me. If you want to go ahead and pull in the iomap
> > > > > > bits, do so, and give me a heads up when you do it so I'll pull your
> > > > > > branch locally.
> > > > > 
> > > > > Great, can the series please be resent based on current vfs-7.2.iomap
> > > > > then please? Because the iomap changes in this series don't apply
> > > > > cleanly on vfs-7.2.iomap so we already have merge conflicts...
> > > > > 
> > > > 
> > > > hmm do you mean this branch?
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.2.iomap
> > > > 
> > > > patches 07..09 seems to apply cleanly. The only conflict I see is in
> > > > the overlayfs patch 03. This is because [1] (is in -rc5) is missing
> > > > in vfs-7.2.iomap.
> > > > 
> > > > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/overlayfs/util.c?h=v7.1-rc5&id=0c8c88b8eb82a2a41bec5f17c076d6312dc40316
> > > 
> > > Christian, ping
> > > 
> > > Would be nice to have iomap in vfs, so Carlos can pull and test the
> > > rest
> > 
> > Applied but note IOMAP_F_FSVERITY
> > changed from (1U << 10) to (1U << 11) since we have another flag
> > addition this cycle.
> 
> Oh I haven't noticed that, thanks!

Thanks Christian. I'll deal with the rest of the series next week!

> 
> -- 
> - Andrey
> 
