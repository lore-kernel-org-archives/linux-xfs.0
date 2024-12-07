Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E5822C6CF
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531124; cv=none; b=u1j3z2a5u4L9n7cdT36/vgYzI0pBCgYC/ckDlJA7JXZUHfrsUkpVEfMV282VsBw9xbHkmrguHSoBnMAJIO32Vy6yU0FPdKN9+aja9tihimAPRNijioFqAJS+LeWYX7OLO7/mTRlaEVRsdo4kqWAXKO8dYy5MIH/ceGK1j2UDl8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531124; c=relaxed/simple;
	bh=y5Nnqfhj/jeFMaIkdwd+/OB2LUfPkqKPnx3s/IQd1Bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIi+fXOXGMvB0vjGevrFlVyTybA9XthLCVci/Xtz/O2gW4WCJ5ZBp2AWTbL08GXkNbqb5fv7GJhTANEKFrwVnNRvFXQ05qseEAI6OdABVy9Gyj09bGUHzcoDPqTF5I+rONVZfq+BAstaWqECNynu2utukdRX6sElHsroVZRhxx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1qLvmS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1qLvmS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EC4C4CED2;
	Sat,  7 Dec 2024 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531124;
	bh=y5Nnqfhj/jeFMaIkdwd+/OB2LUfPkqKPnx3s/IQd1Bk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A1qLvmS7NoufrwToIRkRT9NqApUqCjJAOIob9xLNdJVtr9CVN7BbYnQYnJLTh+J0h
	 Br4FBnBuwlrvdP59+4E1FPdnLo9uArwrGEXToYtCoTaRYYD/Za/Tpaano1FTeuJMwg
	 ndeQVym6mzD40ROYLcNqmbwF9ql+4BYrU75SA6lLY1MkJkXC2YeNQh2YXCrSN80wrT
	 IeUUXhFtWllCZe4J/vAGYQ3TAEdh7DwMTO7Eik60C9MPJAtyoyVq65lQ0pUWZ3pkcU
	 CfoI2ujTK3Gvw4lULw0G23/LCEHTqAFFlJLtb0UeoixJoe0zV5MQmdYdl6hqVSIDK5
	 s9u6nNrb3V19g==
Date: Fri, 6 Dec 2024 16:25:22 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@sandeen.net>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Kundan Kumar <kundan.kumar@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH 3/3] xfs: sb_spino_align is not verified
Message-ID: <Z1OV8leVvOAmqBY3@bombadil.infradead.org>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024025142.4082218-4-david@fromorbit.com>

On Thu, Oct 24, 2024 at 01:51:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's just read in from the superblock and used without doing any
> validity checks at all on the value.
> 
> Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This is 59e43f5479cce106d71c0b91a297c7ad1913176c on v6.13-r1 now.

This commit broke mounting 32k and 64k bs filesystems on 4k page size systems.
Oddly, it does not break 16k or 8k bs. I took a quick glance and I can't
easily identify a fix.

I haven't had a chance yet to find a large page size system to see if
32k page size and 64k page size systems are affected as well.

CIs in place did not pick up on this given fstests check script just
bails out right away, we don't annotate this as a failure on fstests and
the tests don't even get listed as failures on xunit. You'd have to have
a trained curious eye to just monitor CIs and verify that all hosts
actually were chugging along. I suppose we can enhance this by just
assuming hosts which don't have results are assumed to be a failure.

However if we want to enahnce this on fstests so that in the future we
pick up on these failures more easily it would be good time to evaluate
that now too.

  Luis
