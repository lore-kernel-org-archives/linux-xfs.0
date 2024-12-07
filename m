Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9C817FE
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531807; cv=none; b=qw5Q+9f7GUjyuZprCvT++E1quZhS5INW7ScupyyqOsnJFjLSLcFwLSMcP8pVp+Z6l3VR1R63DzwZQQ4E8mXRc11n1O/fgV67NRMN+VAOZKewPNIw+HVvBywJ4XFJRacET0T/yWTvFTPnmRXgcF+0GHUQqvs8/x7u7RQScggo+vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531807; c=relaxed/simple;
	bh=mDJ4u2sWNM4Wc2C4iu8wZDrRG+u3RVs9876gX556cMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xx8XzJsBHf0DNHzVt3TDXT7PZfLhMpi15FYslXK6qi97meAf6ogGgYz0ih7YqwcNBI9G6lEHf7h4QmM7dz/xZHdepHCdVhauo/dhoLHdi2FBGSEnk5PdaVLajZXWo1gtg4uTQq25VYh/9HA1/LWdX2fYkYuVbCOmKi2TGlg4Bdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbZmkQNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbZmkQNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743E7C4CED1;
	Sat,  7 Dec 2024 00:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531806;
	bh=mDJ4u2sWNM4Wc2C4iu8wZDrRG+u3RVs9876gX556cMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bbZmkQNz8zwS6SRt1ZgRTOAGphess8VYXdowz3R/0xgwUZzAhTq4oNKXRwn5NOEyt
	 ZR0sNINII0GNeOrSSKvTh6bOFGOgPAIopikamfxLHunfmhQcAFbTBBfrb3naOyT0rA
	 oWVhxvlge686sql8gCucq0I1druEV1PvW6h/b+PGjuXw9NUqxMUd+gpiDt4FpxdOAy
	 M+Ia5k9yY6lnJsUiiuXoMZNaNLin718YAFNAI5jfwi7KaDAl04bWPo2IlLMVOGtYr+
	 jNr6dghxy+V9Io4i28jBjW/ZKsGX/KadiaSbCB7k3kEFybNknc6gmF2MfcCnAbRzsg
	 IfPaaIns+BGbg==
Date: Fri, 6 Dec 2024 16:36:45 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	Eric Sandeen <sandeen@sandeen.net>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Kundan Kumar <kundan.kumar@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH 3/3] xfs: sb_spino_align is not verified
Message-ID: <Z1OYnXbOyK_Elfm8@bombadil.infradead.org>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-4-david@fromorbit.com>
 <Z1OV8leVvOAmqBY3@bombadil.infradead.org>
 <20241207003204.GQ7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241207003204.GQ7837@frogsfrogsfrogs>

On Fri, Dec 06, 2024 at 04:32:04PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 06, 2024 at 04:25:22PM -0800, Luis Chamberlain wrote:
> > On Thu, Oct 24, 2024 at 01:51:05PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > It's just read in from the superblock and used without doing any
> > > validity checks at all on the value.
> > > 
> > > Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > This is 59e43f5479cce106d71c0b91a297c7ad1913176c on v6.13-r1 now.
> > 
> > This commit broke mounting 32k and 64k bs filesystems on 4k page size systems.
> > Oddly, it does not break 16k or 8k bs. I took a quick glance and I can't
> > easily identify a fix.
> > 
> > I haven't had a chance yet to find a large page size system to see if
> > 32k page size and 64k page size systems are affected as well.
> > 
> > CIs in place did not pick up on this given fstests check script just
> > bails out right away, we don't annotate this as a failure on fstests and
> > the tests don't even get listed as failures on xunit. You'd have to have
> > a trained curious eye to just monitor CIs and verify that all hosts
> > actually were chugging along. I suppose we can enhance this by just
> > assuming hosts which don't have results are assumed to be a failure.
> > 
> > However if we want to enahnce this on fstests so that in the future we
> > pick up on these failures more easily it would be good time to evaluate
> > that now too.
> 
> Known bug, already patched here:
> https://lore.kernel.org/linux-xfs/20241126202619.GO9438@frogsfrogsfrogs/
> 
> and PR to the release manager here:
> https://lore.kernel.org/linux-xfs/173328206660.1159971.4540485910402305562.stg-ugh@frogsfrogsfrogs/

Woot, thanks!

  Luis
