Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C276CF9EF
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717431287; cv=none; b=Jpg/S4au27yBzL/JVDQ/YkcAPnlOfz1nO9h26fYC5p/ULgGLxD8YY62reQDadk/lz6P3rWGvJJe4XF4P1igiln38ifuGZQm4sSaIwihtt2GTSY1PncCGQkJMUPSfKAUQXeDG54BYeNn2faUnZuoU3bSYXUFj0kckAdGr14iGF5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717431287; c=relaxed/simple;
	bh=c9TJ/5TpzzzDOawnOMUos0uxYKgGPHWUZ4WltaWovoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SoVhh06zLR7Anbg8g+WtqMkXdwzF2tAfIOG5NeD0wr0MSlCZWBnBmgVNZzlPsDX1WxQyjOsbyFwql7J9D+J7nklHRQl5fjqm9UbPNG0rgUapGHEsd61+VazvyjCnXj+JS4hhFKtCaNlA8SqUgYatHIPzOrJwHKuwQpewbX2djq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bO+RIAbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bO+RIAbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE52C2BD10;
	Mon,  3 Jun 2024 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717431287;
	bh=c9TJ/5TpzzzDOawnOMUos0uxYKgGPHWUZ4WltaWovoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bO+RIAbvgcEy6Mw1pyFnJejvEcEBNjzCNEPKZuDxwSurxX9xzL+V2z/itBAPp7w1l
	 H/lf3+iWl3I2KRy6yJsdtPnAv30uaO9IRjAAMxyl5bYU2I05bYuMSwBjtOHjT7oK/w
	 gbXdeVCyE/Mh4tjUa6Rk78fZCgrjLjvj7+l16mhrdErQMyLiCi8cuZjjCSVwFSj11/
	 yrnl81HxQmMlSA4noOAqY2YcoFoInGQfvOBM4xJi8l7tSglMEJSSGb5cyoo+CIzZIJ
	 h4SmTTuFVIMx9qeRcuJStzwncGh+0deL5TwxjabB/2QvdxjYSzBGYB3H9ajigYdm7j
	 87H7jO5lk+9jQ==
Date: Mon, 3 Jun 2024 09:14:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_repair: detect null buf passed to duration
Message-ID: <20240603161446.GA52987@frogsfrogsfrogs>
References: <20240531201039.GR52987@frogsfrogsfrogs>
 <WgLbGibmOXGXNXCoy90SomamGGdmPDxkXmpXjSQ5RZF1JSNK9--cUD0gjslOvqF14KG5inSv81x6OIcWI3j_gQ==@protonmail.internalid>
 <20240601175853.GY52987@frogsfrogsfrogs>
 <myn5kmvijvegbg5k2i2rvt3ioawnm4bzyls6fn42bvufr4x664@ovy7iysu7pjk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <myn5kmvijvegbg5k2i2rvt3ioawnm4bzyls6fn42bvufr4x664@ovy7iysu7pjk>

On Mon, Jun 03, 2024 at 02:42:20PM +0200, Carlos Maiolino wrote:
> 
> > diff --git a/repair/progress.h b/repair/progress.h
> > index 0b06b2c4f43f..c09aa69413ac 100644
> > --- a/repair/progress.h
> > +++ b/repair/progress.h
> > @@ -38,7 +38,7 @@ extern void summary_report(void);
> >  extern int  set_progress_msg(int report, uint64_t total);
> >  extern uint64_t print_final_rpt(void);
> >  extern char *timestamp(struct xfs_mount *mp, int end, int phase, char *buf);
> > -extern char *duration(time_t val, char *buf);
> > +char *duration(time_t val, char *buf) __attribute__((nonnull(2)));
> 
> Once nonnull() is used here, shouldn't we also set -Wnonnull to CFLAGS?

Already set via -Wall, at least if you're using gcc 12.2:

       -Wnonnull
           Warn about passing a null pointer for arguments marked as
           requiring a non-null value by the "nonnull" function
           attribute.

           -Wnonnull is included in -Wall and -Wformat.  It can be
           disabled with the -Wno-nonnull option.

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/include/builddefs.in?h=for-next#n113

> Please don't take it as a review, it's just a question that came to my mind as I don't fully
> understand the implications of using nonnull here.

<nod>

--D

> Carlos
> 
