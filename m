Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6142DB78C
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 23:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784072186; cv=none; b=N1d+vdw8ScDFsnBlx+A6emmExOi0batuBFcshpreM1KqPIu/7nMMQi0COBG+nuFcHM0Rts38kApOJ39kaYWZbuCIFr70I0TrwEF1ZtCKIy0PLwtwjM64vsntZinpsyGNZFkbgZ62L5OC+YvcgEFBb6MUTQslC1j4Wm3HW9uJzPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784072186; c=relaxed/simple;
	bh=oF7dfm1Ype1U3qeh5f/R3v38/5lkq0S9bVryHonwM7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RvQ/VJDme5xCPxgq3/j5Jd5Zp2YGSediCHTitd05dfY0uuHqexiwOo/vzXYKq4pAzrr2SAJfjZZuwNnE/psp7qs3rFaF8NCK5A2iTvJUrxopSexbkpUmsY2s67fL2ILx7Vltcpx+Ste2iCntw3MAKcKNz8a1ZboFAi5y9YodnWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U7D8+WDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U7D8+WDd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8C21B1F000E9;
	Tue, 14 Jul 2026 23:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784072184;
	bh=33eAswiGmzFwd7mIEuXWJ76ELoO1T5IHEtjk7Bsb2XE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U7D8+WDdu9EcoqIZTpum4w8bm4Nx1vJTzVfZ65WkFxk3AX7uhXylSbnyG7h3q0X5Z
	 tqy5jT5J07csCZLyJu61hbjOUh68CFOx5hnyjQMoba28kUbjww/B2aE7YDYCnoOwUV
	 jqHWWevr6R/WioTefu13oEdShnzy5sRt/Hgcv34vRw/t//2WWctCTapemjKsF8UQ9d
	 q11AH+t+0OUsVf06fFEPrYeeTuHfHAIFAAlCZGkuixbyMvV8G/NrQYrg4hlKtIXxhi
	 k5IM02qHZCUKCrS5BY19y0jpIiAgrsoPqOE8XAEcvrdttrm3OMuKIWZFPGxnpCnxpr
	 r2S5qrXLhYv3Q==
Date: Tue, 14 Jul 2026 16:36:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Allen Hewes <rallenh@hotmail.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfsprogs 7.1.0 LTINSTALL fix
Message-ID: <20260714233624.GM7380@frogsfrogsfrogs>
References: <465ea336301aafed0e392d668a23e34cca2e4324.camel@hotmail.com>
 <20260714204554.GK7380@frogsfrogsfrogs>
 <7685a0ccf2bc08ec8abe2c89161d666c7c35c6b5.camel@hotmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7685a0ccf2bc08ec8abe2c89161d666c7c35c6b5.camel@hotmail.com>

On Tue, Jul 14, 2026 at 11:32:12PM +0000, Allen Hewes wrote:
> On Tue, 2026-07-14 at 13:45 -0700, Darrick J. Wong wrote:
> > On Tue, Jul 14, 2026 at 05:18:37PM +0000, Allen Hewes wrote:
> > > Hi!
> > >
> > > I am not a member of the list.
> > >
> > > I got local mock build error with xfsprogs 7.1.0:
> > > Installing healer-install
> > > ../install-sh -o root -g mock -m 755 -d /usr/libexec/xfsprogs
> > > /bin/sh ../libtool --quiet --mode=install ../install-sh -o root -g
> > > mock
> > > -m 755 xfs_healer xfs_healer_start /usr/libexec/xfsprogs
> > > Usage: /builddir/build/BUILD/xfsprogs-7.1.0-build/xfsprogs-
> > > 7.1.0/libtool [OPTION]... [MODE-ARG]...
> > > Try 'libtool --help' for more information.
> > > libtool:   error: '/usr/libexec/xfsprogs' is not a directory
> > > gmake[1]: *** [Makefile:72: install-healer] Error 1
> > > make: *** [Makefile:135: healer-install] Error 2
> > > error: Bad exit status from /var/tmp/rpm-tmp.YMwAaj (%install)
> > >     Bad exit status from /var/tmp/rpm-tmp.YMwAaj (%install)
> > >
> > > RPM build errors:
> > >
> > > I tracked this down to a recent change
> > > https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?id=79551362141a051faf9c3d504fe18ee34ca800f8
> > > and then worked from there.
> > >
> > > It appears that LTINSTALL need a single target and not multiple
> > > targets. Here's a patch that let me mock build xfsprogs 7.1.0:
> >
> > I guess that means libtool no longer just calls ../install-sh with
> > whatever parameters it's given?  Or perhaps just yours?  On my
> > system:
> >
> > $ libtool --version
> > libtool (GNU libtool) 2.5.4 Debian-2.5.4-4
> >
> > It would be good to know if this is the result of gnu libtool
> > changing
> > their CLI in a newer version; or some other libtool clone is in use;
> > or
> > something else.
> >
> 
> I am using the Fedora family. The specific mock lock was from fedora-
> 43-x86_64 on a Fedora 43 Workstation install.
> 
> I did check current Fedoras (43/44/rawhide) they are using the same
> libtool version:
> > libtool (GNU libtool) 2.5.4
> 
> There are different build bumps for Fedora 44 and Rawhide, but they are
> the same libtool 2.5.4 version.
> 
> In my case, I think the BUILD_TARGETS got appended because configure
> found HAVE_HEALER_START_DEPS = yes to cause the addition of
> xfs_healer_start
> (https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/healer/Makefile#n44)
> 
> If HAVE_HEALER_START_DEPS = no, then BUILD_TARGETS would contain a
> single target, xfs_healer? Right?

Correct.  It's surprising to me (but not really...) that it works on
Debian but apparently not Fedora.  But as your v2 patch shows, I think
your build root doesn't contain /usr/libexec/xfsprogs and apparently
mine does.

(Mine are /very/ sloppy)

--D

> > > diff -Nuarp xfsprogs-7.1.0.a/healer/Makefile xfsprogs-
> > > 7.1.0.b/healer/Makefile
> > > --- xfsprogs-7.1.0.a/healer/Makefile    2026-07-10
> > > 07:06:28.000000000 -
> > > 0400
> > > +++ xfsprogs-7.1.0.b/healer/Makefile    2026-07-14
> > > 13:08:18.106217736 -
> > > 0400
> > > @@ -69,7 +69,9 @@ install: $(INSTALL_HEALER)
> > >
> > >  install-healer: default
> > >         $(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
> > > -       $(LTINSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)
> > > +       for f in $(BUILD_TARGETS); do \
> > > +               $(LTINSTALL) -m 755 $$f $(PKG_LIBEXEC_DIR); \
> > > +       done
> > >
> > >  install-systemd: default
> > >         $(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
> > >
> > > I will send as an attachment.
> > >
> > > Thanks!
> >
> > Thank you for sending a patch, but it needs a proper Signed-off-by:
> > tag
> > before anyone can look at it.
> >
> > https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1
> >
> > --D
> 
> Thanks for the tip. I sent a new patch in w/subject: [PATCH] xfsprogs:
> healer: install targets one at a time
> 
> /allen
