Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474241D6BB;
	Fri,  2 Jan 2026 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767360966; cv=none; b=jcl7KqWjZAVxYxIEAHuTGMP9LBiLatEa68dl8et8QxrU0yGNo1OIEdKovOqfIZbCQmkiFRoa3tUM3oHnRlj0Qfn25V5czrOumZmxogpi5ckmy7fu+BxJz7oMjJv/S+xoUEIUj7RxqrrnwL66EXzQ3nJVKtrdlT/7EK9ZxT9Fsus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767360966; c=relaxed/simple;
	bh=wAgHeSaceGHSsoM624HCXgGjM8DWWd6hk9SXI96dOE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWwz+IyPmhwctx8BynnT3li5Q8C7BIQgkgCQ52oiuAtFxQqTtgOLgSoWoq7m/HfzzDV56qr4Yoq+eyFJVThiPPyuh2hEQ/VB3z6XwVV9OCQfmIcJ62PuvCtIS7oQJ9Fl4jmVkLa/eQS6SceeaUIiXh7Od/tdmpMgRSkZQPTNlUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGAm07U/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGAm07U/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7140C116B1;
	Fri,  2 Jan 2026 13:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767360966;
	bh=wAgHeSaceGHSsoM624HCXgGjM8DWWd6hk9SXI96dOE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VGAm07U/SzzEMyiqY74RxbEbVOIVaDygP3Ej1ywVKrMqxcca4Y0QyzbIkZJQ8vhHg
	 9fszoXhRYDwDqnj2W97wx6G8K37be0oZETYnPer5KJu0ciCiI0blyFh+mV1a90UGZM
	 VZed6zllL/vW0XgV7GJH4fbnjr7PMfZJ1MZCj/j08vmdnC+Kf1ZdBmEDs4G7OTEed6
	 uo7YaIIl8RjTc1siPw1aG9o4V8QEFLn2RWRO+1ZrFh1aARd0IAZk8iLaSYV4ezSbpR
	 QgDZOabNNazboiHxl/WmzPJVuyoebhdeKhzBisXhcYt14fUmxXmVLXrAXlLcnAis6D
	 +VgpENgjJjCTw==
Date: Fri, 2 Jan 2026 14:36:01 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org, 
	fstests@vger.kernel.org
Subject: Re: [PATCH] punch-alternating: prevent punching all extents
Message-ID: <aVfHvxvMVbS7phq_@nidhogg.toxiclabs.cc>
References: <20251221102500.37388-1-cem@kernel.org>
 <20251231184618.qpl2d32gth4ajcsp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231184618.qpl2d32gth4ajcsp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Thu, Jan 01, 2026 at 02:46:18AM +0800, Zorro Lang wrote:
> On Sun, Dec 21, 2025 at 11:24:50AM +0100, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > If by any chance the punch size is >= the interval, we end up punching
> > everything, zeroing out the file.
> > 
> > As this is not a tool to dealloc the whole file, so force the user to
> > pass a configuration that won't cause it to happen.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > ---
> >  src/punch-alternating.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/src/punch-alternating.c b/src/punch-alternating.c
> > index d2bb4b6a2276..c555b48d8591 100644
> > --- a/src/punch-alternating.c
> > +++ b/src/punch-alternating.c
> > @@ -88,6 +88,11 @@ int main(int argc, char *argv[])
> >  		usage(argv[0]);
> >  	}
> >  
> > +	if (size >= interval) {
> > +		printf("Interval must be > size\n");
> > +		usage(argv[0]);
> > +	}
> 
> OK, I don't mind adding this checking. May I ask which test case hit this
> "size >= interval" issue when you ran your test?

None. I was just using the program to test some other stuff without any
specific test.

> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> > +
> >  	if (optind != argc - 1)
> >  		usage(argv[0]);
> >  
> > -- 
> > 2.52.0
> > 
> 
