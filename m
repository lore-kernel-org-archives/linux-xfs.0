Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A4816D9B0;
	Wed, 10 Apr 2024 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712761523; cv=none; b=JHTLmumjQqxNgDZbyPTqRBPferJ+ydWNg4egXrCcqLHGRyZxHTViPvn+ViAahPdiGBmFI5jAyFfwNoef2i5PKPPAASGLFc3LvMI/JFdffL+0ZghSm0jO9o8H3qzWGJ52UXaGMqH0jDDPofDszzNKS07N7uQMzFpZBvuhq84193w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712761523; c=relaxed/simple;
	bh=tjuI6dO27kRilxRkFeKZsSI4SFgbM+T4R+64oul27Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eCHHGeFquUA0s5Z6ZiEWzam9BTVYQwMla3iCpkR/miKAHIx4+z43YwheYQrvMjvnKBpPbiBpceHvj5B0K1yIu1vLFCWTeUNbVs06D+izsYKhNYGqHKThn1XwmoiF0U9a8TUa0jU1bMO5l/DdN/LdMihocdQmBmWG2r8/e1rsME4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t9TMaVXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9TMaVXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECF3C433F1;
	Wed, 10 Apr 2024 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712761522;
	bh=tjuI6dO27kRilxRkFeKZsSI4SFgbM+T4R+64oul27Fg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t9TMaVXQd7kd+YJHRsDhBHFSqgbBh5Ym3G2tnEMSZOdCa0LWbyG5otWJU5Kv2nm7R
	 QzfeXLLivFVYlg9GNO3amacV5uumUL7Pc9/AWY4UFVO5e1mmUY8u8NMsVO492x1Suj
	 RaxQZd3RUDB2S1yiTl0yInhRSHNNzsT38RzGJTqqNG11ouEFDWrHndEdAyIo/6ZNcf
	 qU+aSKMW1P49DBKXQGZ6jBwHpF+2Ver8BwdLsf81mhY6yecqIaF3dPL4ZARJYKvSF4
	 fHQ2LQFc5ahsTHmtZagHOVDH+RdqZFuhrGUGhfIf0Rgibg3+Jf61jUH8DxWbXi9M3G
	 n33WwXc7tzGbg==
Date: Wed, 10 Apr 2024 08:05:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Sandeen <sandeen@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: don't run tests that require v4 file systems
 when not supported
Message-ID: <20240410150521.GU6390@frogsfrogsfrogs>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408133243.694134-7-hch@lst.de>
 <20240409155612.GF634366@frogsfrogsfrogs>
 <20240410041402.GB2208@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410041402.GB2208@lst.de>

On Wed, Apr 10, 2024 at 06:14:02AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 08:56:12AM -0700, Darrick J. Wong wrote:
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  common/xfs    | 10 ++++++++++
> > >  tests/xfs/002 |  1 +
> > 
> > Looks fine to me.
> > 
> > >  tests/xfs/045 |  1 +
> > 
> > xfs_db can change uuids on v5 filesystems now, so we don't nee the
> > -mcrc=0 in this test.
> 
> Ok, I'll look into that.
> 
> > Looks fine to me.
> > 
> > >  tests/xfs/148 |  2 ++
> > 
> > I wonder if we could rewrite this test to use either the xfs_db write -d
> > command on dirents or attrs directly; or the link/attrset commands,
> > since AFAICT the dir/attr code doesn't itself run namecheck when
> > creating entries/attrs.
> 
> Can I leave that to you? :)

Yes.

> > >  tests/xfs/158 |  1 +
> > >  tests/xfs/160 |  1 +
> > 
> > inobtcount and bigtime are new features, maybe these two tests should
> > lose the clause that checks that we can't upgrade a V4 filesystem?
> 
> I'll take a look.
> 
> > >  tests/xfs/194 |  2 ++
> > 
> > Not sure why this one is fixated on $pagesize/8.  Was that a requirement
> > to induce an error?  Or would this work just as well on a 1k fsblock fs?
> > 
> > (Eric?)
> 
> I can check if it could be made to work on $pagesize/4, but I'll
> need to defer to Eric if that even makes sense.
> 
> > >  tests/xfs/513 |  1 +
> > 
> > I think we should split this into separate tests for V4/V5 options and
> > only _require_xfs_nocrc the one with V4 options, because I wouldn't want
> > to stop testing V5 codepaths simply because someone turned off V4
> > support in the kernle.
> 
> Ok.
> 
> > >  tests/xfs/526 |  1 +
> > 
> > I'm at a loss on this one -- what it does is useful, but there aren't
> > any V5 mkfs options that conflict as nicely as crc=0 does.
> 
> Yes, I tried to look for conflicting options, but I couldn't find
> anything.  Maybe we'll grow some before the v4 support is retired
> for real :)

Well hilariously just yesterday djwong-wtf just grew one now that you
can't format rtgroups=1 without exchange=1 so I guess there's some hope.

--D

--D
