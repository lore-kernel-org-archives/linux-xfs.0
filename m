Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A8E3C345D;
	Thu, 21 May 2026 11:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779363770; cv=none; b=Jz6L0+7w02sePrgbVFvrI3niJn7zpIlzbFcdSfAqyaqXLBhKX1tfkBm9cVtP+yly2fTQHvEPmjlWoPYMG8PTjc4gWvb9TqbwqM2rsW2Fs9rKYYhjAT7eP0pxgThxhZ1TxFFZPRm81cFn/mWKnaxCtc4a8WaYIjenQ4ts4gCPmSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779363770; c=relaxed/simple;
	bh=mkNZSyquEIKW55bo7Jdm5RqxuJHzffMKJWkXd7n3wWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rg4v9v64zkeOID7H1Cd098sIKs63Lcm0yJVMSTJUvRz4R8scAgOwEbxp3WIu9tZhzctNt298aP6zGfjMtEdjosNuBHY8yb4RXq4rlhF9ivOEz1sTDS0cBdag3fjgu4JUWyjsAeVh7wIK+HeLSKOaVf5QVrr8qmUuXCpMVBrmQIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+LbjXw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+LbjXw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DCE1F000E9;
	Thu, 21 May 2026 11:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779363768;
	bh=iK6mSPxFy0vjCsfCJjKbkldG7pEzGcI6Ck24cYLrRvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G+LbjXw3KMFPy0dZ12ugOG3OxxUcZkxosWmAiv+a8VO/2LYci1ZkxRc5cNowYRJJj
	 cTdINxJrieb28GABNIJpefYFhMcgjKcsabqZjefLHtue6AJOU1Nt4UoGe2OQRQ+nmt
	 ooJFboYCCrhPHK0tVqkquc2R+F8JZDIMMBMAzyf5/aGm3N7DV8fH/dn/sck/U/S9nI
	 1uLV/Dwle42LLC46V2Sy5AnYvFn6PidVJ71ndkKYrcL8kHB3T4/sCzDRpWBhy5Qbu7
	 KDQP2T1aZgTxpBepvsHkOeT1jlHTzsWAsBujAZp2PkS3XBN00eeR+veVlIbVP46zxU
	 fXLp2YMtOaAmw==
Date: Thu, 21 May 2026 13:42:42 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com, brauner@kernel.org, amir73il@gmail.com, 
	miklos@szeredi.hu
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <ag7vc9gaHo3XtsBJ@nidhogg.toxiclabs.cc>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>

On Thu, May 21, 2026 at 01:38:45PM +0200, Carlos Maiolino wrote:
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
> FWIW I'm adding Christian to the Cc

Woops... Also Adding Amir and Miklos to the Cc list due the overlayfs
patch:
> 
> > 
> > -- 
> > - Andrey
> > 
> > 
