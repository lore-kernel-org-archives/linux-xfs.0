Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F5C411A06
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339179; cv=none; b=pISPBz5rK5tpttc9gn4eI9V+WsolbjSnV4ASI/xFoaagpfQ19FtS/laZHwEwtpUnfJC1ubsl+J/pzi4mawv1DMvq36j9BpTrr3+h/vWW8ercgFXN4Zv0drLnw01GLRraEX4KARCPrenOWX98fgjh5x/oAdGvH2E/poUvQ0fswZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339179; c=relaxed/simple;
	bh=xDswP6JyhynXaINQq7Vuw7X6UxAzBvkGKSvsKI5MHqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGzVj+R7x0fKneDHIxwMI0O1rxfc8lsTeP2kgeyflhA7QFQEWwsw4pEL24sNO0rD/OmaF7QS5Ml3ungncvWoc8NHVu/5bWmTkTRjq+nE3dx8GVBB/z2BhRdWq5cBjyXKvTdbI3YdhYhBr6zU8IRVpOpHAmX+uOGHzsI/vF42FR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgLqUrXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgLqUrXk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 046591F000E9;
	Wed, 29 Jul 2026 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785339176;
	bh=UEe1STNxqpDb0h9KZZda/H4YIN9/Z4tQpCD6zxRqca4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RgLqUrXkBUBP1UIjtZrBG70RuiJqHddTSlEJsJ7Ck2RSzXe5pB/nBx23CAqn3S8Ik
	 Riw9ZwiyN4h1uE15sJC0dud7eHnPIdyUUtkxecqTWMRze1yz/rKDNV4zQWAHnx8M6O
	 ECvz90ZWNH4Bw5k2oOdyKmB4KArjoZFH1HlD6K9TJqLVOPTq+mUIKoSURCKU0BqUy3
	 evZQL5reYLGeNyrnZ5+bHG0pdux4BhsFbjebFoodD9RGEkXFWgQq26rCwho2VfcXiK
	 GriNdgoycmB2HIh3wpV54ilMkibJ5ZJo7zfmC0x636544laTwi5ZEE+7xAC7Ye/ZCt
	 mUvwYS9Y/+loQ==
Date: Wed, 29 Jul 2026 08:32:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: check v5 superblock features early
Message-ID: <20260729153255.GY2901224@frogsfrogsfrogs>
References: <20260728080435.1777362-1-hch@lst.de>
 <20260728152628.GN2901224@frogsfrogsfrogs>
 <20260728154207.GA10775@lst.de>
 <20260728154730.GS2901224@frogsfrogsfrogs>
 <20260729063506.GB8833@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729063506.GB8833@lst.de>

On Wed, Jul 29, 2026 at 08:35:06AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 28, 2026 at 08:47:30AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 28, 2026 at 05:42:07PM +0200, Christoph Hellwig wrote:
> > > On Tue, Jul 28, 2026 at 08:26:28AM -0700, Darrick J. Wong wrote:
> > > > On Tue, Jul 28, 2026 at 10:04:35AM +0200, Christoph Hellwig wrote:
> > > > > When working on a new features that reuses the existing pad in the
> > > > > superblock, I noticed that mounting such a file system on an old kernel
> > > > > logs a rather confusing warning:
> > > > > 
> > > > >     XFS (vdc): Metadir superblock padding fields must be zero.
> > > > > 
> > > > > This is because we only validate the various feature fields in v5
> > > > > superblocks after the common superblock validation helper is called.
> > > > > 
> > > > > Fix this by calling the feature validation first.  To make this more
> > > > > obvious, rename xfs_validate_sb_read to xfs_validate_sb_features and only
> > > > > call it for v5 file systems.
> > > > 
> > > > Shouldn't it be called xfs_validate_v5_sb_features then?
> > > > 
> > > > Oh.  There's already a xfs_sb_validate_v5_features function that checks
> > > > that the v4 feature bits are set correctly for a v5 filesystem, and it
> > > > would be confusing to have both.
> > > 
> > > Or just stick to the old name :)
> > > 
> > > > Could we move the code in
> > > > xfs_validate_sb_read into xfs_sb_validate_v5_features instead?
> > > 
> > > But yes, that does look sensible as well.
> > > 
> > > > If you do that, then xfs_sb_good_version will validate the feature bit
> > > > recognition, which it doesn't do now.  I'm not sure what weird side
> > > > effects might result from that though.
> > > 
> > > None in the kernel, but userspace has a lot more callers that need a
> > > careful look.
> > 
> > I /think/ the only visible change to userspace is that the code in
> > repair that checks v5 feature flag recognition now becomes defunct
> > because libxfs_sb_good_version will catch it first.  But the
> > xfs_validate_sb_read code will already log (more or less) the same
> > complaint so I don't think it will have any real effect.
> 
> Yeah.  OTOH we now also add it to writes.

<shrug> xfs_validate_sb_write already checks the feature bits, so adding
it to the common function is no big deal.

> I think I'll reduce scope for this patch and drop the renaming
> and just do the check earlier for a trivial backportable fix.
> 
> Then I'll add your above idea to my started work of refactoring the
> sb verifier for reuse in xfs_repair for the next merge window or
> whenver I get to it.

OK.

--D
