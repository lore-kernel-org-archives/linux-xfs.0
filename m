Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708DC17FE
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531525; cv=none; b=O/M4WBXxRz41kDpppSpEM/ekwJnGSQfNuIeZEterKLoypZr6cVDAljpaIEj02gGMvMlr8grG+LDwDoenho4+dBSNU+l3TAWxqncTV/kok8g5Ap21fDNjYp7hypUK5v6n+fZvsGVsH+bV2aw5hWSVIEfdidlhg86rynvJ46HBV0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531525; c=relaxed/simple;
	bh=6fr6pUeBQVXqwLZLFalOW2qp0OxXkjHfdjfrOAYntzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGcfqp8CM4ho9o9UofiaxMXiXRxhmnCSDKKhlhXoFnsntNQ/DIMBvBhWkVU6q1iLKYK2nQJMvSOMqrH4DIAPZok+E6EfN7N62FXiyC75DNn2UvsB40RKWVWm28qBdtAx7Bx82jlyCTmr68m7gpRyNjo20mrUe+m5MgAIvppcND8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGwVj8h+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGwVj8h+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7C7C4CED1;
	Sat,  7 Dec 2024 00:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531525;
	bh=6fr6pUeBQVXqwLZLFalOW2qp0OxXkjHfdjfrOAYntzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sGwVj8h+ip5WP9ezumfikDhcSnxd+4DcnG/0sXcqy7aJlOxTD4TFDztYX/o+jzUyn
	 2Y3jVgYOdkz1BKccIAPnyNMpGks8DudCBPcNMs7xftwIRZB4lGfJUn5cCjUyYvZXhm
	 8/YCOYiXOORBrZYdOHg8+DV9mR53KJYemDIR2fxRYL3Oe/JOTHtIcQr8ACsy4y32qL
	 LZcswUdIjzqFnTBOhcc7L3O5hAx6IF6uyEnAdEJBwOHl8VXtotSSyV4IxKrqSoNpvC
	 StXsHEy1cCsbczuUXX8Q6Smxx7j3VaiGCqTuBf41WC3MsO00fdYE4OCUkXJDfsowDD
	 u9iWVys6ZlVxQ==
Date: Fri, 6 Dec 2024 16:32:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	Eric Sandeen <sandeen@sandeen.net>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Kundan Kumar <kundan.kumar@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH 3/3] xfs: sb_spino_align is not verified
Message-ID: <20241207003204.GQ7837@frogsfrogsfrogs>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-4-david@fromorbit.com>
 <Z1OV8leVvOAmqBY3@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1OV8leVvOAmqBY3@bombadil.infradead.org>

On Fri, Dec 06, 2024 at 04:25:22PM -0800, Luis Chamberlain wrote:
> On Thu, Oct 24, 2024 at 01:51:05PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It's just read in from the superblock and used without doing any
> > validity checks at all on the value.
> > 
> > Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This is 59e43f5479cce106d71c0b91a297c7ad1913176c on v6.13-r1 now.
> 
> This commit broke mounting 32k and 64k bs filesystems on 4k page size systems.
> Oddly, it does not break 16k or 8k bs. I took a quick glance and I can't
> easily identify a fix.
> 
> I haven't had a chance yet to find a large page size system to see if
> 32k page size and 64k page size systems are affected as well.
> 
> CIs in place did not pick up on this given fstests check script just
> bails out right away, we don't annotate this as a failure on fstests and
> the tests don't even get listed as failures on xunit. You'd have to have
> a trained curious eye to just monitor CIs and verify that all hosts
> actually were chugging along. I suppose we can enhance this by just
> assuming hosts which don't have results are assumed to be a failure.
> 
> However if we want to enahnce this on fstests so that in the future we
> pick up on these failures more easily it would be good time to evaluate
> that now too.

Known bug, already patched here:
https://lore.kernel.org/linux-xfs/20241126202619.GO9438@frogsfrogsfrogs/

and PR to the release manager here:
https://lore.kernel.org/linux-xfs/173328206660.1159971.4540485910402305562.stg-ugh@frogsfrogsfrogs/

--D

>   Luis
> 
