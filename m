Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5431DA21;
	Thu,  8 Aug 2024 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723132662; cv=none; b=oyElMhyr2mIXyEGYwZNcueMiqQztNtzLUjRiNW0Fgpz6X2oTbcQ6f5tcU0upc0WYo05Tc1eZBaNl7oS3EKAMmzh3jVVtYMQdwtLSR/iqcrzwwiZpd8glXr8ysZJ9OcExYtPlHWNnbhnr9Znl0rKU0HPkGgdhOubT4UdHnU3AxKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723132662; c=relaxed/simple;
	bh=dENPFtvYpI9KEX73fXHEvciE5I+O/EGmaiSv4XCtJTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q9urUZHWKggh1yK2q2gCmoy1+i9dzrLCaMmnCMxMXxFTd1qPB0E20U1OZhne/5am6Nrrs5GujrWCiIn16dcR60J6pE7BVnNOpVqA+xFCxiaUWUe6w1+FJWh9KaR++h/h2pROuSQtlAWgaWKCphK3lQH/N0rwu3DIlJxA6Uhl3vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FaO6E5lJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FaO6E5lJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81E7C32782;
	Thu,  8 Aug 2024 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723132662;
	bh=dENPFtvYpI9KEX73fXHEvciE5I+O/EGmaiSv4XCtJTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FaO6E5lJV+Y8xlAV3tEmT6rpJ1RT2Xr+A9QCQ12O533HjXVU9FWgRiBcjh8WAk3qX
	 DicBPsOlA5CBHoYRwmMwtwpjPxCpgMc5ZlT0DHf9ZCj9dK4axGB+k9Uo6yWQDlLrSr
	 hSeKmArJ0ZAtTNVtEp39fCazGT+SfFPRGsqyc+cJJU/cArmdAp9umSxbNByBwBtfhU
	 uuschmZxqqG1a0EG18TTgsv1NvibkGPhP8wdcgWu1OebVO8POQJy8K/bR+UnbypQVA
	 F57Uo/7aUaw5E1VcsF57llCBhxhvp3dVHS8wuO74f2ChKlEoisJDvDwE1jF5lktayS
	 vG2h+0kMkzFnA==
Date: Thu, 8 Aug 2024 08:57:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Xinjian Ma (Fujitsu)" <maxj.fnst@fujitsu.com>
Cc: Zorro Lang <zlang@redhat.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Message-ID: <20240808155741.GA6047@frogsfrogsfrogs>
References: <20240730075653.3473323-1-maxj.fnst@fujitsu.com>
 <20240730144751.GB6337@frogsfrogsfrogs>
 <20240806131903.h7ym2ktrzqjcqlzj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240806161430.GA623922@frogsfrogsfrogs>
 <TY3PR01MB12071F457962A3AD2B50C878BE8B92@TY3PR01MB12071.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TY3PR01MB12071F457962A3AD2B50C878BE8B92@TY3PR01MB12071.jpnprd01.prod.outlook.com>

On Thu, Aug 08, 2024 at 08:39:10AM +0000, Xinjian Ma (Fujitsu) wrote:
> > On Tue, Aug 06, 2024 at 09:19:03PM +0800, Zorro Lang wrote:
> > > On Tue, Jul 30, 2024 at 07:47:51AM -0700, Darrick J. Wong wrote:
> > > > On Tue, Jul 30, 2024 at 03:56:53PM +0800, Ma Xinjian wrote:
> > > > > This test requires a kernel patch since 3bf963a6c6 ("xfs/348:
> > > > > partially revert dbcc549317"), so note that in the test.
> > > > >
> > > > > Signed-off-by: Ma Xinjian <maxj.fnst@fujitsu.com>
> > > > > ---
> > > > >  tests/xfs/348 | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/tests/xfs/348 b/tests/xfs/348 index
> > > > > 3502605c..e4bc1328 100755
> > > > > --- a/tests/xfs/348
> > > > > +++ b/tests/xfs/348
> > > > > @@ -12,6 +12,9 @@
> > > > >  . ./common/preamble
> > > > >  _begin_fstest auto quick fuzzers repair
> > > > >
> > > > > +_fixed_by_git_commit kernel 38de567906d95 \
> > > > > +	"xfs: allow symlinks with short remote targets"
> > > >
> > > > Considering that 38de567906d95 is itself a fix for 1eb70f54c445f, do
> > > > we want a _broken_by_git_commit to warn people not to apply 1eb70
> > > > without also applying 38de5?
> > >
> > > We already have _wants_xxxx_commit and _fixed_by_xxxx_commit, for now,
> > > I don't think we need a new one. Maybe:
> > >
> > >   _fixed_by_kernel_commit 38de567906d95 ..............
> > >   _wants_kernel_commit 1eb70f54c445f .............
> > >
> > > make sense? And use some comments to explain why 1eb70 is wanted?
> > 
> > Oh!  I didn't realize we had _wants_kernel_commit.  Yeah, that's fine.
> 
> 
> Hi Darrick
> 
> Sorry, I still don't quite understand your intention.
> Considering that 38de567906d95 is a fix for 1eb70f54c445f, I think the current xfs/348 test should have the following 3 situations:
> 1. Neither 1eb70f54c445f nor 38de567906d95 are applied in the kernel: xfs/348 passes
> 2. Only 1eb70f54c445f is applied in the kernel without 38de567906d95: xfs/348 fails
> 3. Both 1eb70f54c445f and 1eb70f54c445f are applied in the kernel: xfs/348 passes
> The situation of " Only 38de567906d95 is applied in the kernel without 1eb70f54c445f " should not exist.
> 
> Since only the second case fails, I think it's sufficient to just point out that 38de567906d95 might be missing using "_fixed_by_kernel_commit ".
> If my understanding is wrong, feel free to correct me, thank you very much.

1eb70f54c445f was a bugfix for a null pointer dereference due to
insufficient validation, so we really /do/ want to nudge kernel
distributors to add it (and 38de567906d95) to their kernels if they
don't have either.

But I see your point that xfs/348 will pass without either applied, so
that's not much of a nudge.  In the end, I'd rather this went in with
annotations for both commits, but if Zorro decides that only noting
38de567906d95 is ok, then I'll go along with that too.

--D

> Best regards
> Ma
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > >
> > > >
> > > > --D
> > > >
> > > > > +
> > > > >  # Import common functions.
> > > > >  . ./common/filter
> > > > >  . ./common/repair
> > > > > --
> > > > > 2.42.0
> > > > >
> > > > >
> > > >
> > >
> > >
