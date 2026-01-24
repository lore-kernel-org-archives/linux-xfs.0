Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0B61AB6F1;
	Sat, 24 Jan 2026 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769273712; cv=none; b=fnGiT+4JGs4DlY/a+bB0F0YuhfPy6/CwGFEZkubzRhnkKsR+rooFWaEoVVebxl9ouOI+62r2LVFo6cypzGe28Gc8jGlDdSRPegolGMOfsyttFRqPoKK+VToWSAIelis6CSdzdFtpg5XCLrBKEVDThzkPc85lturWM83cPsqBGAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769273712; c=relaxed/simple;
	bh=z7hC5xoAI+pxco8AhJHgxhwW4XJkMjjz83uvX6jfzfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vpi7loxbYhhu6qNG/830XOPJDxxMaWcAeHnu3kowblu33N+leGZgCMYvkH8y6JJ/3m75oG7DzejzomW6XcfGrXMRszu9H1cdJJDUSF1J5RkGDz44BkNMNtcTWV4u7+XPRsgoU/8tSVKIKXj4iTCh3aTRnB3pnHBzgBHO83y6vtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n022RqYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n022RqYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A55C116D0;
	Sat, 24 Jan 2026 16:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769273712;
	bh=z7hC5xoAI+pxco8AhJHgxhwW4XJkMjjz83uvX6jfzfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n022RqYLLFQkKS5BbGwp2qu6SiytB5FfAnQ5/8hG1pnL23AuO91atG6k3xvJm1GkA
	 a3o/r17hzso54pbtAnD9Pg/OiLYI9Raq4KWorVTs9mT9O8lJRFT5mEvuFP/5oMI3Rt
	 R5PcwdeBzUYhm5MJNMKmHpR+C6SDlLdobz7LYgOpYjuqpUgOakSBItSs5muy1y+yaj
	 +dvzPPcxxiUd3JlU+6S/V+HKWQ1KDXUpss0BHhcayRyLBk/gS9VmXjQjPLsB88ft3k
	 injJZUYaBqsPqJWSUXSF7MMlr6d0KnS7yUsdo64EAOTI5qn11AKXg+NFhysVRVn77r
	 uyKfXXWbzgPbQ==
Date: Sat, 24 Jan 2026 08:55:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] misc: allow zero duration for fsstress and fsx
Message-ID: <20260124165511.GU5966@frogsfrogsfrogs>
References: <20260121012621.GE15541@frogsfrogsfrogs>
 <20260121155456.pf6jeprhzua3rdl3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20260121174601.GE5945@frogsfrogsfrogs>
 <20260122072100.2aynewdegsdz7stz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20260122161351.GA5916@frogsfrogsfrogs>
 <20260124054711.3psxdefyfx6z5ps5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124054711.3psxdefyfx6z5ps5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Jan 24, 2026 at 01:47:11PM +0800, Zorro Lang wrote:
> On Thu, Jan 22, 2026 at 08:13:51AM -0800, Darrick J. Wong wrote:
> > On Thu, Jan 22, 2026 at 03:21:00PM +0800, Zorro Lang wrote:
> > > On Wed, Jan 21, 2026 at 09:46:01AM -0800, Darrick J. Wong wrote:
> > > > On Wed, Jan 21, 2026 at 11:54:56PM +0800, Zorro Lang wrote:
> > > > > On Tue, Jan 20, 2026 at 05:26:21PM -0800, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > > 
> > > > > > Occasionally the common/fuzzy fuzz test helpers manage to time
> > > > > > something just right such that fsx or fsstress get invoked with a zero
> > > > > > second duration.  It's harmless to exit immediately without doing
> > > > > > anything, so allow this corner case.
> > > > > 
> > > > > Sure, duration=0 is harmless, I'm good with this patch.
> > > > > 
> > > > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > > > 
> > > > > Please excuse my nitpicking. I'm curious about the semantics of "--duration=0".
> > > > > Looking at the output of `fsstress -v --duration=0`, it doesn't actually
> > > > > 'do nothing.' Instead, it behaves similarly to duration=1, where fsstress
> > > > > attempts to execute operations before timing out and exiting :-D
> > > > 
> > > > Yeah, I suppose it's possible to do a very small amount of work.
> > > > 
> > > > Would you mind changing that last sentence to read "It's harmless to
> > > > exit almost immediately having done very little work, so allow this
> > > > corner case." prior to commit?
> > > 
> > > Sure Darick, I can make that change prior to commit :) But I was just
> > > curious to hear your thoughts on:
> > > 
> > >   if (duration == 0) {
> > >           /* No action is taken if duration is 0 */
> > >           exit(0);
> > >   } else if (duration < 0) {
> > >           fprintf(stderr, "%lld: invalid duration\n", duration);
> > > 	  exit(88);
> > >   }
> > > 
> > > do you feel that makes more sense semantically :)
> > 
> > That would also work. Would you rather have the exits-immediately
> > version?  
> 
> If both versions are good to you, I perfer the "exits-immediately" one, at least
> it fits the semantics of 0 better :)
> 
> To save your time I can make this change when I merge it if you agree with that
> too. Let me know if there's anything else you'd like to add.

Your way is fine with me.  I don't think I have anything to add, and if
I do I can always send a patch. :)

--D


> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > 
> > > > --D
> > > > 
> > > > > Thanks,
> > > > > Zorro
> > > > > 
> > > > > > 
> > > > > > Cc: <fstests@vger.kernel.org> # v2023.05.01
> > > > > > Fixes: 3e85dd4fe4236d ("misc: add duration for long soak tests")
> > > > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > > > ---
> > > > > >  ltp/fsstress.c |    2 +-
> > > > > >  ltp/fsx.c      |    2 +-
> > > > > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > > > > > index c17ac440414325..b51bd8ada2a3be 100644
> > > > > > --- a/ltp/fsstress.c
> > > > > > +++ b/ltp/fsstress.c
> > > > > > @@ -645,7 +645,7 @@ int main(int argc, char **argv)
> > > > > >  				exit(87);
> > > > > >  			}
> > > > > >  			duration = strtoll(optarg, NULL, 0);
> > > > > > -			if (duration < 1) {
> > > > > > +			if (duration < 0) {
> > > > > >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> > > > > >  				exit(88);
> > > > > >  			}
> > > > > > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > > > > > index 626976dd4f9f27..4f8a2d5ab1fc08 100644
> > > > > > --- a/ltp/fsx.c
> > > > > > +++ b/ltp/fsx.c
> > > > > > @@ -3375,7 +3375,7 @@ main(int argc, char **argv)
> > > > > >  				exit(87);
> > > > > >  			}
> > > > > >  			duration = strtoll(optarg, NULL, 0);
> > > > > > -			if (duration < 1) {
> > > > > > +			if (duration < 0) {
> > > > > >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> > > > > >  				exit(88);
> > > > > >  			}
> > > > > > 
> > > > > 
> > > > > 
> > > > 
> > > 
> > > 
> > 
> 
