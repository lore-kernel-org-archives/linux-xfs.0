Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3674642BC50
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 23:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784072914; cv=none; b=IMnJ0ECvpNsNOIx/IWmeP8qAHpm4/CbZ2bM+FCjJ/1lGveku8rPac+koC6AQA55x+oClCs44v9U5mVMiG/UkskCXExey+E6ybrePct1jy9+iap1mv3+a6OKLAD07MrpOnxoblJAZJW09qMANJpBwous70vZ2U/4TkLPp3KOdrBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784072914; c=relaxed/simple;
	bh=FWmCxbTBSFa7h21vL/fPBw1D2OnZJoCxH9DfiiMJym4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESxQsK4rRHjDi+DSnFUOa1a+x2RRevN0VAIDyVWkGbXbnEMIZgP9utHRkxQjUX5ikJmHuNdFzOI4MzMjv7jwYtTBUXXGxChV9499GTMprTd8CHdfDkocw1MI5mM7/lDnwxWnTzN2L4M92kDbVzi0I5SlFEOeejIoDaY02JV1G48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xn2GKJyh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xn2GKJyh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C64821F000E9;
	Tue, 14 Jul 2026 23:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784072912;
	bh=fP405xjGDn1qOrUM8iQXhcM8e/BuZRCc/1oUkNAyrms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xn2GKJyhTuUJY/NO497tWBFqLMEz+dc2walQT4p0kDUKVyyh8nxEHXDU9CYjeLLbI
	 56FeM2PDS8X5iYtgzciccZ0iAmyYKGmh6mmPiZ2kMQESEZ+nlIfBKIi01/767NyVWB
	 PpCYnfX4FS5fbHvFtCLC2Ycf/Ca7em+FtPERrOX7CybU/RlqRPSJoXZBRcgUHuaAag
	 3Z+rH9G4LCtK+lUhuuDtau5B+MyCxgriA9tgvgutKiILRRZj3eEe5rqWDQ8HOVFfRN
	 ZvZPYTQsQorzRif7GXXan4Nb0ccveDoFZwmQGeEI4h1XOfaOmAPSfKCXeC+5WsdGju
	 0Yul7IPxx7qjg==
Date: Tue, 14 Jul 2026 16:48:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Allen Hewes <rallenh@hotmail.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: healer: install targets one at a time
Message-ID: <20260714234832.GN7380@frogsfrogsfrogs>
References: <3681cff200496f792a9f0dfdc117c268fc5803d5.camel@hotmail.com>
 <20260714233027.GL7380@frogsfrogsfrogs>
 <636d61649e316a2a8978bd13282a6dc33f82e5c4.camel@hotmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <636d61649e316a2a8978bd13282a6dc33f82e5c4.camel@hotmail.com>

On Tue, Jul 14, 2026 at 11:34:46PM +0000, Allen Hewes wrote:
> On Tue, 2026-07-14 at 16:30 -0700, Darrick J. Wong wrote:
> > On Tue, Jul 14, 2026 at 11:21:03PM +0000, Allen Hewes wrote:
> > > libtool's --mode=install requires the destination to already exist
> > > as a real directory whenever more than one source file is given
> > > (it emulates cp/install semantics, which have the same
> > > requirement).
> > > Installing xfs_healer and xfs_healer_start in a single LTINSTALL
> > > call trips this check on any build where
> > > HAVE_HEALER_START_DEPS=yes,
> > > since PKG_LIBEXEC_DIR isn't guaranteed to exist under the raw,
> > > un-DESTDIR'd path libtool checks. Install each target separately
> > > to avoid the multi-file directory check entirely.
> > 
> > Aha, so that's the bug then -- distro build scripts set DESTDIR=/xxx
> > and
> > run the build.  include/buildefs sets
> > PKG_LIBEXEC_DIR=/usr/libexec/xfsprogs and passes that to libtool.
> > libtool sees that /usr/libexec/xfsprogs doesn't exist and fails.
> > 
> > Or, if that path happens to exist already, then it starts our custom
> > ../install-sh script which copies the file to
> > $DESTDIR/$PKG_LIBEXEC_DIR
> > which is NOT the same path that libtool dies on.
> > 
> > > Assisted-by: Claude:claude-sonnet-5
> > > Signed-off-by: Allen Hewes <rallenh@hotmail.com>
> > > ---
> > >  healer/Makefile | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/healer/Makefile b/healer/Makefile
> > > index e3c41e66..4aa58757 100644
> > > --- a/healer/Makefile
> > > +++ b/healer/Makefile
> > > @@ -69,7 +69,9 @@ install: $(INSTALL_HEALER)
> > >  
> > >  install-healer: default
> > >  	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
> > > -	$(LTINSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)
> > > +	for f in $(BUILD_TARGETS); do \
> > > +		$(LTINSTALL) -m 755 $$f $(PKG_LIBEXEC_DIR); \
> > 
> > Let's hope nobody ever wants to build a binary with a space in it.
> > Thanks for digging into this.
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > --D
> > 
> 
> Quotes? I can add them if you think that's better defense.

RFC 5322 says that display-name has to be quoted if you want to use a
period inside of it, because elsewhere it defines '.' as a delimiter.
Most software doesn't care of course, but once you start writing
automation to wrangle patches you might as well get it right.

(As it took 20 years for me to start doing per-spec :P)

--D

> Thanks for helping,
> 
> /allen
> > > +	done
> > >  
> > >  install-systemd: default
> > >  	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
> > > -- 
> > > 2.55.0
> > > 
