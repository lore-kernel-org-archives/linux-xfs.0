Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F159741B34E;
	Thu,  4 Jun 2026 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780574413; cv=none; b=OTptTgqJioCtbrw36xf0cW3ZmxABH47nCgE7irR/gvYiBpf6Vij4VNNpCJt+iJyQOcRG2jTiXh2/IXM7h71q6G5xnDw9SssPr/WdfvISeTZz3ez+zn/wCAi+J06777j3NESASNr+cropoRs7oGjiBaL4hT3W2hjnhm+Y5HHdK20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780574413; c=relaxed/simple;
	bh=yTiLymGix0Xy4q03aIU8uxZlq237YZY33OmzdOyx3ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/XYeK54/TcqgXE5MiUxalI6eZKrcuf3KNQK+NT616yaAv+Ba/Zc7MM+JwWO8Wx/sb8+cYLytSeCinu1Y+pniNOeCSKuucpUXWFr23qF0IpXYu2eQv9wbZxEDyx8jPZhazutofcZOsZW4Rqpbikitzxui9mWjRhqpCypD8vPdXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWlMIyVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWlMIyVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CC21F00893;
	Thu,  4 Jun 2026 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780574412;
	bh=eUGKeM7sI2oL66NeOVj98HdQqnjDqpuEH+7R/CzDGX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bWlMIyVAfft41ZQCGzhI+SyhA9T/HLftfr8rJJGYdx5Uaqre8IIqdBMzPHBJBhrpV
	 v/fE9puQ+K/giOQZ9M2RFrSBhcMOgGztSfJcwe2y4/6Eb8oun9fL01b0HCnkU7+SNm
	 gSS1xffYq9sOdePq6pcGFGR1u0LOmjqTSJ5tNJePAOFySwP85TjKpV09ntzTwTYhC+
	 ptUfdeSrDKTbcwsjQ5cWX0issdDT0V8jWDPnxMRlnRe8mOABWSYpvMzxr231lgKtxz
	 zRPn9mAgi9NO7O6DZbP+SbH8o7I2pqJ3mQmiKSXYhSF/yk+c5+vaklddgJMcuBtjiK
	 6jEpkLP8hKKig==
Date: Thu, 4 Jun 2026 14:00:07 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <20260604-holen-rundum-ausfechten-2193b39da363@brauner>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
 <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
 <20260522120757.GA21041@lst.de>
 <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>
 <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>
 <fjdfwhwi4aogyiaoijwvw6w4npuu5mbt6ua6fkhwcp5ajlm543@ume2fkxg36cb>
 <aiE_YQc6SGSdWlcE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aiE_YQc6SGSdWlcE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Thu, Jun 04, 2026 at 11:04:32AM +0200, Andrey Albershteyn wrote:
> On 2026-05-28 16:50:45, Andrey Albershteyn wrote:
> > On 2026-05-28 14:20:08, Christian Brauner wrote:
> > > On Tue, May 26, 2026 at 12:19:43PM +0200, Carlos Maiolino wrote:
> > > > On Fri, May 22, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > > > > On Fri, May 22, 2026 at 12:03:20PM +0200, Christian Brauner wrote:
> > > > > > > I was expecting this to come through xfs tree too if Eric and Christian
> > > > > > > agree.
> > > > > > 
> > > > > > You may take it through the xfs tree if there are no conflicts with
> > > > > > vfs-7.2.iomap. If there are I want to add the iomap changes into
> > > > > > vfs-7.2.iomap that you can pull in.
> > > > > 
> > > > > Merging the iomap bits through the iomap branch might make sense, given
> > > > > that iomap usually tends to see quite a bit of activity.
> > > > > 
> > > > 
> > > > That sounds good to me. If you want to go ahead and pull in the iomap
> > > > bits, do so, and give me a heads up when you do it so I'll pull your
> > > > branch locally.
> > > 
> > > Great, can the series please be resent based on current vfs-7.2.iomap
> > > then please? Because the iomap changes in this series don't apply
> > > cleanly on vfs-7.2.iomap so we already have merge conflicts...
> > > 
> > 
> > hmm do you mean this branch?
> > https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.2.iomap
> > 
> > patches 07..09 seems to apply cleanly. The only conflict I see is in
> > the overlayfs patch 03. This is because [1] (is in -rc5) is missing
> > in vfs-7.2.iomap.
> > 
> > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/overlayfs/util.c?h=v7.1-rc5&id=0c8c88b8eb82a2a41bec5f17c076d6312dc40316
> 
> Christian, ping
> 
> Would be nice to have iomap in vfs, so Carlos can pull and test the
> rest

Applied but note IOMAP_F_FSVERITY
changed from (1U << 10) to (1U << 11) since we have another flag
addition this cycle.

