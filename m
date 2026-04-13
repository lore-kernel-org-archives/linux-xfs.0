Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A241D6DB5
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 16:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096319; cv=none; b=WOwS6llL5h8zszPjcpAZBFjivku+YWDOmIN74K2docmep+jt4JXJo/Z2evi4kzf2lzRA6A08jg8puB2d0xXeqrkY+wtPOOqgm8TuOJ/rsEGNFOvCeDNv1DZuJe74SXkkIGGQF6zgv/WtY9I/5mGBnK2fuT6zZTSEXlDo6IKEqu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096319; c=relaxed/simple;
	bh=zm2zD/MSKmCt0H36NCXBxsY6mAbogIvrJw+IeGdFFdA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5NBKyS9lE9vay9uu1S92J4z45lkPYAVR2dp6oFQYoYZ/tT5Vu0fQwQVSTHJ3s4zAehicPx41xTOXL25xPoBpXPyCwGQl8iHq+1+C8h72/LXM5wMg8iSbczkqDj4Z5v+B/1owjTzg5S4vuoJcJnzabywJtEkkI+mOFCVd8VvAMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q/h/Zd8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q/h/Zd8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE304C2BCB0;
	Mon, 13 Apr 2026 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776096318;
	bh=zm2zD/MSKmCt0H36NCXBxsY6mAbogIvrJw+IeGdFFdA=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=q/h/Zd8bs2S4fsIbordUznNvnbf1MPNTjPewKNq8cy3wsb/9O0ODskRloF3/X4nbU
	 T99WkNMmK+9DfucDQH9NI6wCHKKpdKZObAQp3rV7KPLoecLKD7E/CofwZ6vkvO30NO
	 xrew30vRZotKbD4yAQ+/AE6t6MFpuvPdDOLjyc5Wpa9V/eQniG5X549IeKNTHLIcH0
	 +n9rKXdGJvAFumkgLFQqr0DoGdR1iL3r8e0fXb78LHckUBBI0q9TwU3I0R5ssOfUui
	 lf52hh9SEbzxoYXe9gGhETE0OsFWUGVaMOingd/YfgyRw63/jVgs8Ka+YcKh42cCF7
	 M22KbUf5XCqbw==
Date: Mon, 13 Apr 2026 09:05:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] mkfs: fix assertion failure on empty data file
Message-ID: <20260413160518.GK1048989@frogsfrogsfrogs>
References: <20260404163640.1013997-1-zlang@kernel.org>
 <20260404163640.1013997-2-zlang@kernel.org>
 <20260406152628.GC1048989@frogsfrogsfrogs>
 <advyLsWynjlIF40m@zlang-laptop>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <advyLsWynjlIF40m@zlang-laptop>

On Mon, Apr 13, 2026 at 03:52:59AM +0800, Zorro Lang wrote:
> On Mon, Apr 06, 2026 at 08:26:28AM -0700, Darrick J. Wong wrote:
> > On Sun, Apr 05, 2026 at 12:36:39AM +0800, Zorro Lang wrote:
> > > mkfs.xfs triggers an assertion failure, when it trys to make a xfs
> > > on an empty file:
> > >   # echo > emptyfile
> > >   # mkfs.xfs emptyfile
> > >   mkfs.xfs: xfs_mkfs.c:3852: validate_datadev: Assertion `cfg->dblocks' failed.
> > >   Aborted                    (core dumped) mkfs.xfs emptyfile
> > > 
> > > This shouldn't be an assertion, but a warning.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > ---
> > >  mkfs/xfs_mkfs.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > index 527a662f..9a93330f 100644
> > > --- a/mkfs/xfs_mkfs.c
> > > +++ b/mkfs/xfs_mkfs.c
> > > @@ -3848,8 +3848,13 @@ validate_datadev(
> > >  		if (!xi->data.isfile) {
> > >  			fprintf(stderr, _("can't get size of data subvolume\n"));
> > >  			usage();
> > > +		} else {
> > > +			if (!cli->dsize) {
> > > +				fprintf(stderr,
> > > +_("Warning: Empty file needs a data subvolume size by -d size=<value> option\n"));
> > 
> > I'm not sure why "Warning" is appropriate here -- this error is fatal to
> > the program, and most fatal mkfs error messages don't have a prefix.
> 
> Oh, you're right, the mkfs.xfs command failing here is a total failure, not
> just a warning.
> 
> How about:
> _(Bad empty file, needs a data subvolume size by -d size=<value> option)
> 
> or any other you feel good.

"Please specify desired data subvolume file size by -d size=<value> option\n" ?

--D

> Thanks,
> Zorro
> 
> > 
> > Other than that, the logic is sound that we need a softer landing for
> > this scenario.
> > 
> > --D
> > 
> > > +				usage();
> > > +			}
> > >  		}
> > > -		ASSERT(cfg->dblocks);
> > >  	} else if (cfg->dblocks) {
> > >  		/* check the size fits into the underlying device */
> > >  		if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
> > > -- 
> > > 2.52.0
> > > 
> > > 
> > 
> 
