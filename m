Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236E319644B;
	Sun, 20 Jul 2025 13:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753018556; cv=none; b=I3+iGJhxaNiv10r4zauv0qURkqLJ10dHV2puopq7eHk1X990dyKrP37s0LLaD+fMEOXWO9RIMFoIUuDuQXvGtaU9WqPh2+IxHjCW4hcsc1Yasn8e/NszcZSWDOw2POy0U+uYpO6Bf/G9LpddeNJkWSqi6P6ratiYDIZSe4z/NfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753018556; c=relaxed/simple;
	bh=j/e8+rtNdccrGcHxCK1KM8g0kQ7PgJe6mnaf+/nIyJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=no3zxjbKHXP5sE1FsNcKQQAYhDcBszKuZI0MyGfK/lcCGC74nso0Vte46f/ODtYb4CZIE0di+eY8EbBkc6C1IAGiBBJ+uNZQwx+O9T9rAUJwFw9rhIaSYjGVdrmIKZ5vLZXifp5oJcKIUHK4o7ZLFDsbzC8cTWqoIqKWT4SE5LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iwYeYZ+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iwYeYZ+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94D2C4CEE7;
	Sun, 20 Jul 2025 13:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753018555;
	bh=j/e8+rtNdccrGcHxCK1KM8g0kQ7PgJe6mnaf+/nIyJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iwYeYZ+zzJ3ibw4rviTl2t2JHuMiJsf7xz9vZmrvXAAMBd37unvEpPwHhrPAs5pGz
	 Gd3k5F3zfNZBB2fra7HGe6i/OvVrog5PITalMjaOnx91PpBhm56wUVtXNaJyZAxLWm
	 nH6GNeuKVGwFRD6DQzpxJr8//kA8ty6OGxavaf8FZYyIrDkNo++Z0BMoRryqAI1PZt
	 38rR7Hb4jrHiIoGOVue6o5GQUEJAMYtBIJkB8Z6ylSqxHX//CAlAmwp7hvQGZQW6Z/
	 sy+L1Zk7aJY9+0IUZRSLLvgKEYYXYqaB5RM+ElBeTXQkRBtumqlMJ2i5t99nfCYT4B
	 nmzfC64rQst3A==
Date: Sun, 20 Jul 2025 15:35:50 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Marcelo Moreira <marcelomoreira1905@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] xfs: Replace strncpy with strscpy
Message-ID: <w5zac6jzwncscbhnihlfonbp7ac4jsf7d4ge7uo4fpsqcloeil@ylxill2zypfn>
References: <20250716182220.203631-1-marcelomoreira1905@gmail.com>
 <aHg7JOY5UrOck9ck@dread.disaster.area>
 <CAPZ3m_gL-K1d2r1YSZhFXmy4v3xHs5uigGOmC2TdsAAoZx+Tyg@mail.gmail.com>
 <aHos-A3d0T6qcL0o@dread.disaster.area>
 <trCbtX-saKueJEbdl8AzWARJReyojMKsRC0LGW1Wb72CJsztLYdHNDFrGndVe0KMtU82iSTw2zcsZi4OZhZOlA==@protonmail.internalid>
 <CAPZ3m_iwS6EOogN0gN51JcweYH0zuHmrgVvD7yTXTi1AoDA7hQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPZ3m_iwS6EOogN0gN51JcweYH0zuHmrgVvD7yTXTi1AoDA7hQ@mail.gmail.com>

On Fri, Jul 18, 2025 at 04:10:39PM -0300, Marcelo Moreira wrote:
> Em sex., 18 de jul. de 2025 às 08:16, Dave Chinner
> <david@fromorbit.com> escreveu:
> >
> > On Thu, Jul 17, 2025 at 02:34:25PM -0300, Marcelo Moreira wrote:
> > > Given that the original `strncpy()` is safe and correctly implemented
> > > for this context, and understanding that `memcpy()` would be the
> > > correct replacement if a change were deemed necessary for
> > > non-NUL-terminated raw data, I have a question:
> > >
> > > Do you still think a replacement is necessary here, or would you
> > > prefer to keep the existing `strncpy()` given its correct and safe
> > > usage in this context? If a replacement is preferred, I will resubmit
> > > a V2 using `memcpy()` instead.
> >
> > IMO: if it isn't broken, don't try to fix it. Hence I -personally-
> > wouldn't change it.
> >
> > However, modernisation and cleaning up of the code base to be
> > consistent is a useful endeavour. So from this perspective replacing
> > strncpy with memcpy() would be something I'd consider an acceptible
> > change.
> >
> > Largely it is up to the maintainer to decide.....
> 
> Hmm ok, thanks for the teaching :)
> 
> So, I'll prepare v2 replacing `strncpy` with `memcpy` aiming for that
> modernization and cleanup you mentioned, but it's clear that the
> intention is to focus on changes that cause real bugs.
> Thanks!
> 

I'm ok with cleanups, code refactoring, etc, when they are
aiming to improve something.

I'm not against the strncpy -> memcpy change itself, but my biggest
concern is that I'm almost sure you are not testing it. I really do
wish to be wrong here though, so...
Did you test this patch before sending?

I'm not talking about build and boot. Even for a 'small' change like
this, you should at least be running xfstests and ensure no tests are
failing because of this change, otherwise you are essentially sending
to the list an untested patch.

Even experienced developers falls into the "I'm sure this patch is
correct", just to get caught by some testing system - just to emphasize
how important it's to test the patches you craft.

Carlos.


> --
> Cheers,
> Marcelo Moreira
> 
