Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2642633A71A;
	Wed, 21 Jan 2026 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769017562; cv=none; b=mHFwdcdSFTSlfHyH7IwpjOqDQmUI751h6ybZXg3V10w9BvvjBQQ13cZkMZWedysIeey9hJf5Q2RyWD0p0XhxlG/SdEghwByLPxAUOuoDaZR+d/GuA2VdecHhHfS0fZhMZIg3yDmwPqi8S5g436MYb5ouZ8WRc576PSHGw2sYlwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769017562; c=relaxed/simple;
	bh=Et9YqHBwaee9vvZTB5IBwg0x9iewIh5Y44GdK8LleJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OcuXbOFQCt2sFociJmQTS4QXatU6dzv4hcpTsbeVNzL01uxd8PoKJLVpE6LEtubkBXJ9Ml/Jqf9wqazKkflUiXoaMXIPk/KYiYCkcyZtNtDhVvjUDzB2QkmLv5i4OXxkeAVSUeKjI3c5VGbOGXhbfKIUmsUXjKP/5xVVWSBz8To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R9PWToMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9PWToMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A9BC4CEF1;
	Wed, 21 Jan 2026 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769017561;
	bh=Et9YqHBwaee9vvZTB5IBwg0x9iewIh5Y44GdK8LleJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R9PWToMblqTuTSeoiy4t2vqPcWJdoAosIzEim1fscYv5L6fOEEbJMOC9lnpLi3OhV
	 gBtMzqGcGR9XaBUvVGoe+lk0nMZgEW9+a1PG3fibeRgbIAEAekbpdiDiqXlTP3p2ZY
	 HfsYt2NfnayDjlgKikKbxMB1bMtcXt2927Kd/zQD9tw0ORR1esLEg6CISG8IEk0Xhg
	 uBcPw73oRjPcZGQHzwBFbEmFQmzDS8a/lzyIhT9kfQnHX3WuwiNhSacBEHzFaUPsBP
	 CVJLQ5P5UDkFdtPE+N9tXY+cilM0+HzJAADy+khjQrt6GKxbfX4h0FPzH4RB+IuQDG
	 /g3hyrGsm3Ehg==
Date: Wed, 21 Jan 2026 09:46:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] misc: allow zero duration for fsstress and fsx
Message-ID: <20260121174601.GE5945@frogsfrogsfrogs>
References: <20260121012621.GE15541@frogsfrogsfrogs>
 <20260121155456.pf6jeprhzua3rdl3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121155456.pf6jeprhzua3rdl3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Wed, Jan 21, 2026 at 11:54:56PM +0800, Zorro Lang wrote:
> On Tue, Jan 20, 2026 at 05:26:21PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Occasionally the common/fuzzy fuzz test helpers manage to time
> > something just right such that fsx or fsstress get invoked with a zero
> > second duration.  It's harmless to exit immediately without doing
> > anything, so allow this corner case.
> 
> Sure, duration=0 is harmless, I'm good with this patch.
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> Please excuse my nitpicking. I'm curious about the semantics of "--duration=0".
> Looking at the output of `fsstress -v --duration=0`, it doesn't actually
> 'do nothing.' Instead, it behaves similarly to duration=1, where fsstress
> attempts to execute operations before timing out and exiting :-D

Yeah, I suppose it's possible to do a very small amount of work.

Would you mind changing that last sentence to read "It's harmless to
exit almost immediately having done very little work, so allow this
corner case." prior to commit?

--D

> Thanks,
> Zorro
> 
> > 
> > Cc: <fstests@vger.kernel.org> # v2023.05.01
> > Fixes: 3e85dd4fe4236d ("misc: add duration for long soak tests")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  ltp/fsstress.c |    2 +-
> >  ltp/fsx.c      |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index c17ac440414325..b51bd8ada2a3be 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -645,7 +645,7 @@ int main(int argc, char **argv)
> >  				exit(87);
> >  			}
> >  			duration = strtoll(optarg, NULL, 0);
> > -			if (duration < 1) {
> > +			if (duration < 0) {
> >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> >  				exit(88);
> >  			}
> > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > index 626976dd4f9f27..4f8a2d5ab1fc08 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> > @@ -3375,7 +3375,7 @@ main(int argc, char **argv)
> >  				exit(87);
> >  			}
> >  			duration = strtoll(optarg, NULL, 0);
> > -			if (duration < 1) {
> > +			if (duration < 0) {
> >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> >  				exit(88);
> >  			}
> > 
> 
> 
