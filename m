Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319AB2753EF
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 23:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739489354; cv=none; b=q6D54h9QwaES1iyW7gvCGCKbgsL8NOLF3p+/B/ry44LcX3SnJcYdFL5sm+qiZSKl2P8Cd1pOKsQBXc41tDTGWsO3nsopxdx4lCv2XMBvfo9/5P9FbJuOJ7lEYYhST68o5Pm/WMezjCPsr+6ks1AxaPL1TMhRIwqsnlFRWBOSSyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739489354; c=relaxed/simple;
	bh=uyo4yaZcLJDEClZ/dym4caTm9LDorEkUkiL/HjnqTlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KKdHeiVNWuNKxCYlsHt95CpdJ7DP8zXykL8GmjErmYxm4XqaLP1BZW4EgAZvYytzuZM7D0ofqYHdM5/ghTxswhAAW/AOQBSTZ9BTvPdKLY6ObnPZ3CZbmGxjUx5uRFZUBjPhqQWXx2WFoobBJRscgEWZIS7JO6XdCs8vZ92mJRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/OzffTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/OzffTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A132AC4CED1;
	Thu, 13 Feb 2025 23:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739489353;
	bh=uyo4yaZcLJDEClZ/dym4caTm9LDorEkUkiL/HjnqTlw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r/OzffTNjKvebnioVo2F0QwAbgr2uj/aQlWuUDx37ewUleXlQ9Oy4F5z3JVAtYZDA
	 tpdAx4b91m3PgE9mCYxHSSvsDPOwjkzw5sHZWVgVIy9NxtHQlW6dBzFO1UFa76DkUL
	 Y7gjibz4FXJ3sueMZF65f9wjU6YkA/g9Z/3ZnYE+G7Qbq/Pu7zhVfGJ0QOK5xbFRHs
	 IpXK5eUDkMwRIs9c4eZTa3gbHE4s3q7NegqePzFGAunTlQAF6Iz4nn7i37BbPhOD3X
	 GWlnbgxA7fsOA0/A52egQpVWqG6VmZL6roCoyFRKlMsFLPJBz1mVAxnB9BgBn8dlnu
	 yS6Op3iUHXPtw==
Date: Thu, 13 Feb 2025 15:29:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alyssa Ross <hi@alyssa.is>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH xfsprogs] configure: additionally get icu-uc from
 pkg-config
Message-ID: <20250213232913.GJ3028674@frogsfrogsfrogs>
References: <20250212081649.3502717-1-hi@alyssa.is>
 <20250212212017.GK21808@frogsfrogsfrogs>
 <877c5u6vdu.fsf@alyssa.is>
 <8734gi6v5a.fsf@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8734gi6v5a.fsf@alyssa.is>

On Thu, Feb 13, 2025 at 10:39:29AM +0100, Alyssa Ross wrote:
> Alyssa Ross <hi@alyssa.is> writes:
> 
> > "Darrick J. Wong" <djwong@kernel.org> writes:
> >
> >> On Wed, Feb 12, 2025 at 09:16:49AM +0100, Alyssa Ross wrote:
> >>> This fixes the following build error with icu 76, also seen by
> >>> Fedora[1]:
> >>> 
> >>> 	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: unicrash.o: undefined reference to symbol 'uiter_setString_76'
> >>> 	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: /nix/store/jbnm36wq89c7iws6xx6xvv75h0drv48x-icu4c-76.1/lib/libicuuc.so.76: error adding symbols: DSO missing from command line
> >>> 	collect2: error: ld returned 1 exit status
> >>> 	make[2]: *** [../include/buildrules:65: xfs_scrub] Error 1
> >>> 	make[1]: *** [include/buildrules:35: scrub] Error 2
> >>> 
> >>> Link: https://src.fedoraproject.org/rpms/xfsprogs/c/624b0fdf7b2a31c1a34787b04e791eee47c97340 [1]
> >>> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> >>
> >> Interesting that this pulls in libicuuc just fine without including
> >> icu-uc.pc, at least on Debian 12:
> >>
> >> $ grep LIBICU_LIBS build-x86_64/
> >> build-x86_64/include/builddefs:222:LIBICU_LIBS = -licui18n -licuuc -licudata
> >>
> >> Debian sid has the same icu 76 and (AFAICT) it still pulls in the
> >> dependency:
> >>
> >> Name: icu-i18n
> >> Requires: icu-uc
> >
> > I don't know too much about Debian, so I might be doing something wrong,
> > but when I looked in a fresh Debian Sid container I see a libicu-dev
> > package that's still on 72.1-6, a libicu76 package, but no libicu76
> > package.  I'm not sure there's currently a package that installs the
> > icu-i18n.pc from ICU 76?
> 
> Here I meant "no libicu75-dev package".

<nod> The development headers don't always have the version number
encoded in them; in this case it's libicu-dev that contains icu-i18n.pc
and icu-uc.pc.

> I suspect it's the following change:
> 
> https://github.com/unicode-org/icu/commit/199bc827021ffdb43b6579d68e5eecf54c7f6f56
> 
> I don't think there's anything special about Fedora here — I first saw
> this when the icu package was upgraded in Nixpkgs.

Hrmmm, this only seems to trigger if the libicu is configured with
--enable-shared.  Though, that seems to be the default...

*OH*.

libicu 76 exists only in Debian experimental, and there's not an
xfsprogs build for experimental.  Everything older than that (unstable
to bookworm) has libicu 72, which means that nobody in Debian land have
actually built xfsprogs against libicu 76.

Now that I've figured that out, can the commit message be changed to
reference the 199bc827021ffdb4 commit in upstream libicu (and provide
that link to the PR) as a motivation for changing the PKG_CHECK_MODULES
call?

"Upstream libicu changed its pkgconfig files[0] in version 76 to require
callers to call out to each .pc file they need for the libraries they
want to link against.  This apparently reduces overlinking, at a cost of
needing the world to fix themselves up.

"This patch fixes the following build error with icu 76, also seen by
Fedora[1]:

	/bin/ld: unicrash.o: undefined reference to symbol 'uiter_setString_76'
	/bin/ld: /lib/libicuuc.so.76: error adding symbols: DSO missing from command line
	collect2: error: ld returned 1 exit status
	make[2]: *** [../include/buildrules:65: xfs_scrub] Error 1
	make[1]: *** [include/buildrules:35: scrub] Error 2

"Link: https://github.com/unicode-org/icu/commit/199bc827021ffdb43b6579d68e5eecf54c7f6f56 [0]
"Link: https://src.fedoraproject.org/rpms/xfsprogs/c/624b0fdf7b2a31c1a34787b04e791eee47c97340 [1]"

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
