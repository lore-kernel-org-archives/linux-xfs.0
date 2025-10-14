Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50CB2C032E;
	Tue, 14 Oct 2025 21:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760475925; cv=none; b=J8i+xDhAiJ2Rjk9lfRuhHvU3x6zpTRyTxhS9i8u212x48Sx25U5mOzhyBieKNQ1AVPVVXjw+XJ8SohwhTcKVfxbMzB3Lew4CpUX5hhVXweyKtoYGharu3oIbFhxm6MhXZ4Fzvh+TncUROm0W8e9J1baUQ5RudTNN8Dh4bxwFHDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760475925; c=relaxed/simple;
	bh=8+KxBOQ8xuRqgM2zKfjlIAyWuuEvuXK+qO4NiFdJHYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/X/+r/tlE33NH+g+sjEZ6nkBEpzBsnw8xrkf3VDSI3ULQvr8uit2EKu5WyrJnTK7brWV6t9hiXFjElOn9ZVBD9hJbHQ5hyUTuOtIVJqgFAzZ2HfzomqUZFeXEB0mdvl5WfxU+vH2eHxaJdW9f7B10F5cMGt+qZLDK9WzlGufzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gP/7VGQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gP/7VGQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A951C4CEE7;
	Tue, 14 Oct 2025 21:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760475925;
	bh=8+KxBOQ8xuRqgM2zKfjlIAyWuuEvuXK+qO4NiFdJHYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gP/7VGQLK+HC67poyGXCfjxEFHUjaAp/R8egRkknS+UJwJ1PctTMqqKI3VMPQCF3j
	 3g0rQHYdRZXysWYwzk8ySoutn6sLhP3Yvo3O24CZHu7AmRAvnTdJYtBdXVMPz1+jHp
	 i5EiDfENIIFVlLHMJEROdlXSf7kz7MIQT9TrcPNB/1nkpjo9ztuffAQEr91PdXQOa1
	 dSjAFKLDz2HN4lKfOJA3IlJ8hdhmTW9lnUNIFpSFpZ44Ndx4XyBnvXG018IP1jXJNj
	 3n4Qs56UAJBtVSXeOUQOBeheVIcpeUPModGwTTMbxxEowiJvhtAlgq3cLXFADsatlk
	 9xxAeArg3iJlQ==
Date: Tue, 14 Oct 2025 14:05:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: XFS_ONLINE_SCRUB_STATS should depend on DEBUG_FS
Message-ID: <20251014210524.GE6188@frogsfrogsfrogs>
References: <69104b397a62ea3149c932bd3a9ed6fc7e4e91a0.1760345180.git.geert@linux-m68k.org>
 <20251013163211.GL6188@frogsfrogsfrogs>
 <CAMuHMdURm_mpK3Pnr=XtUqe2RsqJY_hVR-R797hRSSc0U_0DKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdURm_mpK3Pnr=XtUqe2RsqJY_hVR-R797hRSSc0U_0DKg@mail.gmail.com>

On Tue, Oct 14, 2025 at 09:10:03AM +0200, Geert Uytterhoeven wrote:
> Hi Darrick,
> 
> On Mon, 13 Oct 2025 at 18:32, Darrick J. Wong <djwong@kernel.org> wrote:
> > On Mon, Oct 13, 2025 at 10:48:46AM +0200, Geert Uytterhoeven wrote:
> > > Currently, XFS_ONLINE_SCRUB_STATS selects DEBUG_FS.  However, DEBUG_FS
> > > is meant for debugging, and people may want to disable it on production
> > > systems.  Since commit 0ff51a1fd786f47b ("xfs: enable online fsck by
> > > default in Kconfig")), XFS_ONLINE_SCRUB_STATS is enabled by default,
> > > forcing DEBUG_FS enabled too.
> > >
> > > Fix this by replacing the selection of DEBUG_FS by a dependency on
> > > DEBUG_FS, which is what most other options controlling the gathering and
> > > exposing of statistics do.
> > >
> > > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > ---
> > >  fs/xfs/Kconfig | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> > > index 8930d5254e1da61d..402cf7aad5ca93ab 100644
> > > --- a/fs/xfs/Kconfig
> > > +++ b/fs/xfs/Kconfig
> > > @@ -156,7 +156,7 @@ config XFS_ONLINE_SCRUB_STATS
> > >       bool "XFS online metadata check usage data collection"
> > >       default y
> > >       depends on XFS_ONLINE_SCRUB
> > > -     select DEBUG_FS
> > > +     depends on DEBUG_FS
> >
> > Looks ok to me, though I wonder why there are so many "select DEBUG_FS"
> > in the kernel?
> 
> I think select is OK for pure debug functionality, which is not enabled
> unless really wanted; depends on is better for optional features like
> statistics, especially if they default to y.
> 
> Alternatively, the "default y" could be dropped from
> XFS_ONLINE_SCRUB_STATS?

Well it /would/ be helpful for support to be able to gather usage stats
on this still rather n{ew,ovel} feature. :)

--D

> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Thanks!
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
