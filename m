Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5AD387358
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 11:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776080337; cv=none; b=acZNpWzpSIn5fZCTetd6a+Gjnyzs69pl8RISkRvLZ0vzZuGL2y9rhEBUWIB/hoAWWdEkkXC4icrkFMYa25dGyjEwjFpuo9N+qcBN8BEX8RHWnNPBC/M1ewMK9yYqVmtQ2dz78VB/t5hJsAtGnqAx3DYATNT0Okmg2iX8PCBfLI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776080337; c=relaxed/simple;
	bh=k3x7vzxPlWZ3HYep0Y+p8NdDB/nK8wSnOmQjrGCVwy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXUL5tZhHsp0fXNwbrCEL2ufabGObMbnbw2wFkzKeU3meAMAH7v7FEgQtrmklCdnHHdCFIMv0wgr7A0YDjnXDkR9lbbnMdU5H168PUKlw7wibtc65Z+zE8X1i+ro+ovLBrqVnMtOMLCtpGZMqqZPmroydxFn3tBUNP2kJaFs4gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=RSBlrRFk; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="RSBlrRFk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bXkTQyny8t+GDe/Jx6hB0ypVa/sOKHHYfNkA0SCkp/Y=; b=RSBlrRFko66FvECsf7/a5qoGwr
	+Ihm1ECr1V0cT2fT2JlismJHTuQp2AjRcH8SXQuipodvCjONMI4Vll+4ATHTO/cTafWtzRj5Gzk9o
	AJ4ZBbKLy9YGY0LpK3XiWipR37A3D5eFkKGEvx8PH23NEV2v/12hnUavAWlmhKBZ8vQwK++EXoFhJ
	79sCbrrgDIvOdGrGkzuKg8AmlUW5YAk9MZXIOBLM7um6Mdqh7eUk+IFqEfUWNyha8MN+Z52hTFFHT
	1uabFvrsc42643oJK/10gYXGmUh9AA1CRW0jzLKrBAfyzrH5aUR0lX1FPjRCxZVr1QOLKy3tQY4qh
	im0Aq94Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <tille@debian.org>)
	id 1wCFcz-00CGQO-1q
	for linux-xfs@vger.kernel.org;
	Mon, 13 Apr 2026 11:38:54 +0000
Received: from andreas by mail.an3as.eu with local (Exim 4.96)
	(envelope-from <tille@debian.org>)
	id 1wCFcy-009aOo-2Q;
	Mon, 13 Apr 2026 13:38:52 +0200
Date: Mon, 13 Apr 2026 13:38:52 +0200
From: Andreas Tille <tille@debian.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: XFS Development Team <linux-xfs@vger.kernel.org>,
	Anibal Monsalve Salazar <anibal@debian.org>,
	Nathan Scott <nathans@debian.org>
Subject: Re: Please migrate xfsdump and xfsprogs Debian packaging to Salsa
Message-ID: <adzVzC0mZ8b8lUO-@an3as.eu>
References: <ads96yii8bij-UQQ@an3as.eu>
 <20260413035534.GF1048989@frogsfrogsfrogs>
 <adzH8Xwc_Qz6hwgH@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adzH8Xwc_Qz6hwgH@nidhogg.toxiclabs.cc>
X-Debian-User: tille

Hi Carlos,

Am Mon, Apr 13, 2026 at 12:41:08PM +0200 schrieb Carlos Maiolino:
> > > I'd be happy if these packages could be maintained in a publicly visible
> > > Git repository on Salsa, with appropriate Vcs fields set.
> > 
> > That's more or less a matter of setting a couple of fields in
> > debian/control, right?
> > 
> > Vcs-Browser: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > Vcs-Git: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git -b master
> 
> ohh.. debian-specific fields for which VCS it uses seems like.

Yes, Debian specific ... and https://salsa.debian.org is Gitlab instance
Debian is using for the vast majority of packages.  In general there are
good reasons to do the packaging there (for instance to not disturb
upstream maintainers like you with the communication ;-) ) but there are
exceptions from this rule.  I'd be happy to hear from the persons
(Anibal and Nathan are listed) who usually care for the Debian packaging
whether such an exception are these xfs related packages.

If not I'd happily lend a helping hand to migrate the Debian packaging
to Salsa.
 
Kind regards
   Andreas.

-- 
https://fam-tille.de
