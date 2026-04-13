Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD674A0C
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 10:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776076872; cv=none; b=Kf9lumz/cnYHrDCGW7eXlMG7J4Bw/E7OjFAZLawE0kG0UALdRROlJaE1pdWAVO70zsccNEKlNGSw5AznNTq8A2Y/fKtMSw4m0YhH71QKEbSc06U0c0yLgUukM0qyt5+egU6BLRgSsEvgWKXnkpLAd2dV81q1PjzSPi3PDLfi7l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776076872; c=relaxed/simple;
	bh=wOUo9ZmAugD+M87X9Z50YAJk4w/3yOoYUYkI7CIceoI=;
	h=Date:From:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gGf/xNTarNjombtABhOwORfxXqNJBgkklNuqt9zxs+f5Fck5Xc74i0DAMSets6PAFsJL2TTBkzQHbDfCD64sTLIdk5IIeIbMLIj5YHGudWYefpZPqf3Xo9mL01vBM4gamJXdM1LdVHFEF0yVocG2FExMfdFQUUksTlF98o0Oy1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQSpT+S+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQSpT+S+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E71C116C6;
	Mon, 13 Apr 2026 10:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776076871;
	bh=wOUo9ZmAugD+M87X9Z50YAJk4w/3yOoYUYkI7CIceoI=;
	h=Date:From:Cc:Subject:References:In-Reply-To:From;
	b=DQSpT+S+sAGife36UF5c7ef3c1361r2sIhhsSKX0LINaecmwg3jher2CYZwaYx0E0
	 fkaX5MaSv+2pW4RRnlGz42vBMXhdH6gFPovYAKPIM7J/0IC/N6xZmb7DkNTF3VrUxr
	 Tu/HuYz1dLeN+lCbW2OoZZFk7V4Ge2OnkSkdIc2mOP2PL+C4E0vDFmkL4uG7MwmsVQ
	 e26O/mRsLec/3PV/KXt499mZIJgtSlkURPQrgTfAILlal8TrALBex01pLtYbv3YFXZ
	 Wb3Z+kqdZkErt7bohLCQrqz5A+fckRQWxBRmDQpOvOrLAsq+cgT6r35N8oHo3OrlK5
	 9twMeJBSFUSOw==
Date: Mon, 13 Apr 2026 12:41:08 +0200
From: Carlos Maiolino <cem@kernel.org>
Cc: Andreas Tille <tille@debian.org>, 
	XFS Development Team <linux-xfs@vger.kernel.org>, Anibal Monsalve Salazar <anibal@debian.org>, 
	Nathan Scott <nathans@debian.org>
Subject: Re: Please migrate xfsdump and xfsprogs Debian packaging to Salsa
Message-ID: <adzH8Xwc_Qz6hwgH@nidhogg.toxiclabs.cc>
References: <ads96yii8bij-UQQ@an3as.eu>
 <20260413035534.GF1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413035534.GF1048989@frogsfrogsfrogs>

On Sun, Apr 12, 2026 at 08:55:34PM -0700, Darrick J. Wong wrote:
> On Sun, Apr 12, 2026 at 08:38:35AM +0200, Andreas Tille wrote:
> > Hi XFS Development Team,
> > 
> > I'm currently reviewing team-maintained packages that are not exposing
> > Vcs fields.  I assume for some efficient team work you are maintaining
> > 
> >   xfsdump
> >   xfsprogs 
> > 
> > in some Git repository, but the Vcs fields are not set and I could not
> > find corresponding repositories on Salsa.  I'm not even sure whether you
> > might have some team space there or whether the Debian team might
> > sufficiently fulfill your needs.
> > 
> > I'd be happy if these packages could be maintained in a publicly visible
> > Git repository on Salsa, with appropriate Vcs fields set.
> 
> That's more or less a matter of setting a couple of fields in
> debian/control, right?
> 
> Vcs-Browser: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> Vcs-Git: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git -b master

ohh.. debian-specific fields for which VCS it uses seems like.


> 
> --D
> 
> > If there are specific reasons why this is currently not the case, I
> > would be interested to understand them as well.
> > 
> > If you need any help with creating some Git repository I can happily
> > do so since I have developed some training in doing this.
> > 
> > Thanks for your work on XFS in Debian, and best regards,
> >    Andreas.
> > 
> > -- 
> > https://fam-tille.de
> > 
> 
