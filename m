Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAAD2DA76B;
	Mon,  5 Jan 2026 09:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606665; cv=none; b=WyYuFpeOMlWSHF7+YyKiwLBFuHCQ8Y8smG8N1ExR6tXuMB97+L8hAyTiaFTrgWrdVjTkBKECtn3J3A9/TIrNt5r1bCb9AwH+qIP1rC5c3dsE+ntJzgUsXms0v2R3/Lo4f/GsuX3Dr/e5JmamX4dtQEs6qrvqyorr5ZbInGthMMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606665; c=relaxed/simple;
	bh=YUgdM2RFi2QA2jIp9ShxWu4u/fKr13xcKUH3o2pZGjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsTevMHx8q7lvH+n76ZIjPVNiaOeC0DrYj61Bvsj5iRlpXcczoJ/q1xuAPzu0TI99blObeBL6naRgtr/zoU299ZsEdB0jYOfehKrNO9vNei/1p7TNRAQAczLry8Fm3+8SQio7DpNmm/21fnNlfD+D/oSejJvQ7PdE/Go7WASS18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJXYb0uk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJXYb0uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD095C116D0;
	Mon,  5 Jan 2026 09:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767606665;
	bh=YUgdM2RFi2QA2jIp9ShxWu4u/fKr13xcKUH3o2pZGjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CJXYb0uk0B/U9OZ8JxlxJbRyM+6nGu0nLBVd/MvL3eGsYHYrTSsZiekFqjYrQyd9r
	 tizudX+hit58Sqd1efm5rgNG8keJzCDQCqUZJlyNb1GcQtK6lZyo2DqHlCenO7W/Wl
	 gh6Qva8BVyfN5qvl8NFyWJdI2+qhmygtZbfKyCeSTF9K0BuhD7dsi9vuudFHfsMxTV
	 qbTIdEY1ydObiuxbz3rpAVllB+k1FoNAMbjntrEudN3s3M62lerLlzc0CXrOckB9LF
	 /PnBQoplkCfjTy6o9SMCi3k6xjgvfW9+0LNcBB9rkyHcP1jDhX/mLFfRsBl0Ci389N
	 5/0JYpOpZjhOQ==
Date: Mon, 5 Jan 2026 10:51:00 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org, 
	fstests@vger.kernel.org
Subject: Re: [PATCH] punch-alternating: prevent punching all extents
Message-ID: <aVuJbarCAECGc_9M@nidhogg.toxiclabs.cc>
References: <20251221102500.37388-1-cem@kernel.org>
 <20251231184618.qpl2d32gth4ajcsp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <aVfHvxvMVbS7phq_@nidhogg.toxiclabs.cc>
 <20260102154315.nfh5kdiz7b5cuswq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260102154315.nfh5kdiz7b5cuswq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Jan 02, 2026 at 11:43:15PM +0800, Zorro Lang wrote:
> On Fri, Jan 02, 2026 at 02:36:01PM +0100, Carlos Maiolino wrote:
> > On Thu, Jan 01, 2026 at 02:46:18AM +0800, Zorro Lang wrote:
> > > On Sun, Dec 21, 2025 at 11:24:50AM +0100, cem@kernel.org wrote:
> > > > From: Carlos Maiolino <cem@kernel.org>
> > > > 
> > > > If by any chance the punch size is >= the interval, we end up punching
> > > > everything, zeroing out the file.
> > > > 
> > > > As this is not a tool to dealloc the whole file, so force the user to
> > > > pass a configuration that won't cause it to happen.
> > > > 
> > > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > > > ---
> > > >  src/punch-alternating.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > > 
> > > > diff --git a/src/punch-alternating.c b/src/punch-alternating.c
> > > > index d2bb4b6a2276..c555b48d8591 100644
> > > > --- a/src/punch-alternating.c
> > > > +++ b/src/punch-alternating.c
> > > > @@ -88,6 +88,11 @@ int main(int argc, char *argv[])
> > > >  		usage(argv[0]);
> > > >  	}
> > > >  
> > > > +	if (size >= interval) {
> > > > +		printf("Interval must be > size\n");
> > > > +		usage(argv[0]);
> > > > +	}
> > > 
> > > OK, I don't mind adding this checking. May I ask which test case hit this
> > > "size >= interval" issue when you ran your test?
> > 
> > None. I was just using the program to test some other stuff without any
> > specific test.
> 
> Sure, good to know there's not other issues :) This program is a good tool to
> do some other tests, especially creates lots of data extents effectively :)
> I've pushed this patch to patches-in-queue branch, will merge it in next
> release after testing, feel free to check it.

Indeed, and took me a while to understand why I was ending up with an
empty file instead of a bunch of extents :)


> 
> Thanks,
> Zorro
> 
> > 
> > > 
> > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > 
> > > > +
> > > >  	if (optind != argc - 1)
> > > >  		usage(argv[0]);
> > > >  
> > > > -- 
> > > > 2.52.0
> > > > 
> > > 
> > 
> 
> 
