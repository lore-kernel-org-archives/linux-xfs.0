Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28A033D6E4
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764952147; cv=none; b=XaW4qUHToAO5/E+5xEr6B7ilQ8bGmdX8hs5b+erjGmLGQQyyxLNKwduYazjF99l0H6adSFbjiQXlACaYrqjOz+evTl3SPswak/F5QwHwot8xkIRocrR0tc+jzWi1UHvDVAFdzYpEtp4zQ+5ORV/UqGcof4LLHCNjUVaXHTfJDX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764952147; c=relaxed/simple;
	bh=3XkLeOqyB+On3paMVhMkZI9FQXHLgJvjFod++UiMpOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cOX4L/PTH+oPhMkwRbIKTEYCJqzrhp/r+GIRmu1FRZSA3zZE/OZbG7sV4zoOFfwgx/NZLFsd2Ib3hcdtWpS1x+Pz+Phoyl6Ltc5OqxI75cZmVdNVIkHA2xP+CduMbfYXZVPXFtXC/fMRvC+HAXy4LYCEfcmxvaJhFIAahKh3Y+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OeaHjmhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OeaHjmhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59448C116B1;
	Fri,  5 Dec 2025 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764952146;
	bh=3XkLeOqyB+On3paMVhMkZI9FQXHLgJvjFod++UiMpOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OeaHjmhmhkXTmyZ4mSfWSApHzgvRLNyExfEPFh/cJxmzGlEidXnxksZEakNi4TRIz
	 lUUYKtrmgsXGnDYTQzv4KiMYNsnqofcslHol69o7DPUg9rTCjkh+0rXHDtkI2xkWq4
	 KJ77YHEcxcpcg4bBbkcAQHGMrZgoy9G0PB+pqF3kT7++Pfragz1RvrhzDRU3LzIDba
	 NJ86OzfkxihDgqGORKWBOKQeFWwc/xDA9SJ3m/zL2SPrFKr6mbkTRz6mTkJAwH9D1m
	 Hs2M7l++Y4OmZOHhs8B/KghEa0JjXx+1ox2Fh6I2BG0kkbEfZPV+MvZSgaHpoIAS92
	 4fDyZP8tuzRzg==
Date: Fri, 5 Dec 2025 08:29:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Message-ID: <20251205162905.GP89472@frogsfrogsfrogs>
References: <20251128063719.1495736-1-hch@lst.de>
 <20251128063719.1495736-3-hch@lst.de>
 <20251201224716.GC89472@frogsfrogsfrogs>
 <20251202073307.GE18046@lst.de>
 <20251202175919.GH89472@frogsfrogsfrogs>
 <20251203060942.GA16509@lst.de>
 <20251204171811.GE89492@frogsfrogsfrogs>
 <20251205081337.GA21400@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205081337.GA21400@lst.de>

On Fri, Dec 05, 2025 at 09:13:37AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 04, 2025 at 09:18:11AM -0800, Darrick J. Wong wrote:
> > > And that's what I'd expect.  But there are no direct gettext calls
> > > anywhere in xfsprogs, despite quite a bit of N_() usage.  What am I
> > > missing?
> > 
> > #define _(x)		gettext(x)
> > 
> > in platform_defs.h.
> > 
> > (and no, I don't get anything meaningful out of "N_()" for magic
> > tagging and "_()" to mean lookup, but according to Debian codesearch
> > it's a common practice in things like binutils and git and vim)
> 
> Yeah, the caller has the _() anyway for the format string, even in the
> current version of the patch.  No idea how that leads to inserting the
> translations passed in through %s, but I'll just stick to what we do
> for other such cases in xfsprogs (e.g. the .oneline field in xfs_io).

<nod> It took me a while to wrap my head around what's really happening
with gettext.  Would an example help?  Start with:

static const char foostrings[] = {
	[0]	= N_("foo"),
	[1]	= N_("bar"),
};

int main(int argc, char *argv[])
{
	int i = argc > 2 ? 1 : 0;

	printf("%s\n", _("Hello world!"));
	printf("%s\n", _(foostrings[i]));
}

First, make runs the gettext catalog generator, which sees two N_()
expression with a constant string inside of it ("foo" and "bar"), and
one _() expression with a constant string inside of it ("Hello world!").
These three strings are added to the catalog.  It ignores the _()
expression with a variable reference in it because that's not a string.

gcc then runs the source through the preprocessor:

static const char foostrings[] = {
	[0]	= "foo",
	[1]	= "bar",
};

int main(int argc, char *argv[])
{
	int i = argc > 2 ? 1 : 0;

	printf("%s\n", gettext("Hello world!"));
	printf("%s\n", gettext(foostrings[i]));
}

So foostrings is an array of pointers to const strings, as expected.
The actual message catalogue lookups happen in the printfs at the end of
main.

(Also note that we're not supposed to put format specifiers in message
catalog strings because malicious translation files can screw over the
program by replacing %d with %s, etc.  But most programs are super
guilty of violating that, xfsprogs included...)

--D
