Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E844823D1
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 11:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733571287; cv=none; b=YOojscH1UUFNp37v6UyruCWDDYKtaDYafo20EvhoEWhfS/KoCRdMKwAxHOY1I7Q/lUP0Hw01vayFzfKsnGrCAbT/IrsAhhM2O+aTrWeghu6ior9k4yMjYlzYcQPeMrszQaPyxmgJ1TrMy7HrL73XdplyOSQLS1pM9FXvuKaKbtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733571287; c=relaxed/simple;
	bh=mS3QB18w+q/0yrQCrqUyOJjrC4SaB6VGQzGXMeo11vI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWig/yRV9ZEK1DjQc+zLuUwElxYK2WlGo39fUHVQMpJeEgcvgdpju2gwfBzb6FUrP4DnktQNVP/T1uao7lorQ1a4KbxQ2/xhqN7G0fl3FQDBhX+20H2FLURWSzrEjdUJLWUXl75nzehI6bPaapiURmpw6+xF2SptZqT64ecBhds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcuyZtBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcuyZtBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551EFC4CECD;
	Sat,  7 Dec 2024 11:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733571287;
	bh=mS3QB18w+q/0yrQCrqUyOJjrC4SaB6VGQzGXMeo11vI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YcuyZtBxyY10oPxnvgt6W+7WPbblsGMhGdLSWJXcl8jpw3K/6A8qImRlSUf4RCp6I
	 YEpoRO7t6tVwI64pe2E3A4om/xV7d8ePN7jIKJspetXegmXXX/xZP+vCa7dahq61aK
	 foML6wTZZ2rgDLGtB2pc+YNsZMrxf7h+bWJKLb+YUiVj9XXdpn+UpDaYlbFF1fK5nC
	 vTTKoeV29gXIPswiDK7Hr9v6MY8x6jj+4wG2nBANITuB2Mz6hp+qa1f2YMbzLbkDYU
	 9hKRDV3+bz1yUjIKgGL8Tlh70uie1HINHkKlqntOejuMM3xHPmPYG0Imzer8oabgkd
	 a25fiSLwLn/GA==
Date: Sat, 7 Dec 2024 12:34:40 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Brian Foster <bfoster@redhat.com>, 
	Pankaj Raghav <p.raghav@samsung.com>, Daniel Gomez <da.gomez@samsung.com>, 
	Kundan Kumar <kundan.kumar@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH 3/3] xfs: sb_spino_align is not verified
Message-ID: <hk53mameom3g3mjma37mnxfatngdg7gxcr7e6ezzkodwwqsvu7@26inqict47de>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-4-david@fromorbit.com>
 <Z1OV8leVvOAmqBY3@bombadil.infradead.org>
 <20241207003204.GQ7837@frogsfrogsfrogs>
 <Z1OYnXbOyK_Elfm8@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1OYnXbOyK_Elfm8@bombadil.infradead.org>

On Fri, Dec 06, 2024 at 04:36:45PM -0800, Luis Chamberlain wrote:
> On Fri, Dec 06, 2024 at 04:32:04PM -0800, Darrick J. Wong wrote:
> > On Fri, Dec 06, 2024 at 04:25:22PM -0800, Luis Chamberlain wrote:
> > > On Thu, Oct 24, 2024 at 01:51:05PM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > It's just read in from the superblock and used without doing any
> > > > validity checks at all on the value.
> > > > 
> > > > Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > This is 59e43f5479cce106d71c0b91a297c7ad1913176c on v6.13-r1 now.
> > > 
> > > This commit broke mounting 32k and 64k bs filesystems on 4k page size systems.
> > > Oddly, it does not break 16k or 8k bs. I took a quick glance and I can't
> > > easily identify a fix.
> > > 
> > > I haven't had a chance yet to find a large page size system to see if
> > > 32k page size and 64k page size systems are affected as well.
> > > 
> > > CIs in place did not pick up on this given fstests check script just
> > > bails out right away, we don't annotate this as a failure on fstests and
> > > the tests don't even get listed as failures on xunit. You'd have to have
> > > a trained curious eye to just monitor CIs and verify that all hosts
> > > actually were chugging along. I suppose we can enhance this by just
> > > assuming hosts which don't have results are assumed to be a failure.
> > > 
> > > However if we want to enahnce this on fstests so that in the future we
> > > pick up on these failures more easily it would be good time to evaluate
> > > that now too.
> > 
> > Known bug, already patched here:
> > https://lore.kernel.org/linux-xfs/20241126202619.GO9438@frogsfrogsfrogs/
> > 
> > and PR to the release manager here:
> > https://lore.kernel.org/linux-xfs/173328206660.1159971.4540485910402305562.stg-ugh@frogsfrogsfrogs/
> 
> Woot, thanks!
> 
>   Luis
> 

FWIW, I didn't pull these to -rc2, as I wouldn't have enough time to test them
before sending them to Linus.

I'm picking them up first thing for -rc3.
