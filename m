Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C782EAF9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287223; cv=none; b=Jk1nmeCdsipswpyIgpVVk+lbFo6VXWLK5JhKsiBdXRacY+iI4UVRaOxdpLaUuEUWkX8NTkr2ZkeZsPXuUdgTeyQOdheyKktm/d52rntjYxDXSA1yV/MNlqYl/QbIzmElIE8nD2dbfResrybW4NmAM+Nub5jhUAqdOg/ISk9O1f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287223; c=relaxed/simple;
	bh=OTEKQgaCmihN4Y6E9nltYEPBA9J9cwAxQ28MnbcOvCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWyixOSlDyqj+sgnesKSFDhSKcVGWeDHYxtrFqeaSFdbqliRHk8jWKAwuASPF9yyBdIklRySRjJ28xjHPSTSxcPSVNY/yWKlx+dBgG6YWiSHC0drmzPv4R3+1XS2qijAi0kdPRND7O0zI5WguMfeXxPwiXcvIomKsX9cL9b7kb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THBr1d72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THBr1d72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A39C113CE;
	Tue, 16 Apr 2024 17:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713287222;
	bh=OTEKQgaCmihN4Y6E9nltYEPBA9J9cwAxQ28MnbcOvCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=THBr1d725mPDxpsu6wzpL/rT/9r7VQDcaKcI6SHEqE9ldzmlB8i1leZfN93Bn+SQL
	 aS7Z+kA9YLtGFGZVCYj7hg85WIB8lScTI6Yz9pxClTcH85ooW4tyqJhrS6BdhqR6Fp
	 LsA0IglJOBkBdFa1EOd+BXRYO2DQ/PgV43SfoyyBvNyBDo0hW1QNjc2sDyWNvWzUrN
	 fkWf6mWLqZlO1rG0VDZvN0a7+5ZRLoF3nkxKyLwt0ky6MaJ8rqdxDGt1MzQvyAdVfs
	 1ETQ0JuppsuJe6fUs7LsVdnL5ZLLNy/YsoE4t+b1Y67mLl6nYUwafnBBUzexUSX13e
	 yh6DFFor8/tLg==
Date: Tue, 16 Apr 2024 10:07:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_fsr: convert fsrallfs to use time_t instead of
 int
Message-ID: <20240416170701.GQ11948@frogsfrogsfrogs>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-6-aalbersh@redhat.com>
 <20240416162125.GN11948@frogsfrogsfrogs>
 <ay75niholqd2z7tlcgygzoyzc7qyt2zgkh76utoyvk3vayytq4@57qbfxilszhk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ay75niholqd2z7tlcgygzoyzc7qyt2zgkh76utoyvk3vayytq4@57qbfxilszhk>

On Tue, Apr 16, 2024 at 06:31:57PM +0200, Andrey Albershteyn wrote:
> On 2024-04-16 09:21:25, Darrick J. Wong wrote:
> > On Tue, Apr 16, 2024 at 02:34:27PM +0200, Andrey Albershteyn wrote:
> > > Convert howlong argument to a time_t as it's truncated to int, but in
> > > practice this is not an issue as duration will never be this big.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > > ---
> > >  fsr/xfs_fsr.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > > index 3077d8f4ef46..07f3c8e23deb 100644
> > > --- a/fsr/xfs_fsr.c
> > > +++ b/fsr/xfs_fsr.c
> > > @@ -72,7 +72,7 @@ static int  packfile(char *fname, char *tname, int fd,
> > >  static void fsrdir(char *dirname);
> > >  static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
> > >  static void initallfs(char *mtab);
> > > -static void fsrallfs(char *mtab, int howlong, char *leftofffile);
> > > +static void fsrallfs(char *mtab, time_t howlong, char *leftofffile);
> > >  static void fsrall_cleanup(int timeout);
> > >  static int  getnextents(int);
> > >  int xfsrtextsize(int fd);
> > > @@ -387,7 +387,7 @@ initallfs(char *mtab)
> > >  }
> > >  
> > >  static void
> > > -fsrallfs(char *mtab, int howlong, char *leftofffile)
> > > +fsrallfs(char *mtab, time_t howlong, char *leftofffile)
> > 
> > Do you have to convert the printf format specifier too?
> 
> is time_t always long?

There don't seem to be any guarantees at all.

The most portable strategy is to cast the value to an unsigned long long
and use %ll[ux].  Awkwardly, time_t seems to get used both for actual
timestamps and time deltas.

> > 
> > Also what happens if there's a parsing error and atoi() fails?  Right
> > now it looks like -t garbage gets you a zero run-time instead of a cli
> > parsing complaint?
> 
> I suppose it the same as atoi() returns 0 on garbage

<nod> All those cli integer parsing things need better checking, though
that's its own cleanup series and not related to this patch.

--D

> > 
> > --D
> > 
> > >  {
> > >  	int fd;
> > >  	int error;
> > > -- 
> > > 2.42.0
> > > 
> > > 
> > 
> 
> -- 
> - Andrey
> 
> 
