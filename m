Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E423126CD
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 12:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776082222; cv=none; b=ZTJZrejbEj1zXhe6Ny+fXFW4Vcpk3/MIRp/aKEnwf+4I0SO0BZE6Px/QO6sMVa6Vd9LE0A1yeKLHr+4VzvlGcRGaF/p+UZ6XQEAGppi5rGt6iY2VrG0CaNZv5S7Urf0BgDJOu9Bw2BJDAB7/anok6wNVr6FL956+9CtCw+wldWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776082222; c=relaxed/simple;
	bh=wXWuf5FiL4rkgKnAsoxowgSGi5L37Ydx5yBO05l0oPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3godKBJdqC15/I3BTNhusF+g5FD8a+211s1eHctqbqoui4LyXQ3JzUSSjLRFd5I6d+rugcPf09xx6rEWb67IDD4SYJTdLMpztJI6QndjBw+SXCNttIUq0i8JQcVKjAz/RFEdSMU4gmxc3sYuA7qiWsd5GIkPK7sb/93OWiYI6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4ckIa9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4ckIa9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51ACC2BCAF;
	Mon, 13 Apr 2026 12:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776082221;
	bh=wXWuf5FiL4rkgKnAsoxowgSGi5L37Ydx5yBO05l0oPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J4ckIa9oBru0VSKzDy05/OiQ2jWfAVnOc9ZZ4KhgbfRNU7X+jfv2Nz9msKaO18i57
	 mqSlD4+mdS+HWOOAhfQ8qSZeVYffRNfqHaGfH4bcb4eCVAVuobC1wSlrkzAKsR8YnY
	 hG62Z5UTsQL3e9xPVwgUURCpKZrROjYPvZ1+OefUsZSG1bSQiISwcsuYnQAQFl869V
	 9qbUflP1K79nrNeFzVy8bGJNwFPceVrjJUIK8iIbpDomPyIbr07v1GEyowBsp+0BR8
	 b1cMUP3vrhK4iVUz37AO7pQvhrBZG/8usDgXJquV9LdZR6+6UKbPztIOef4k/8bz1G
	 xD4YBOrQwer1A==
Date: Mon, 13 Apr 2026 14:10:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andreas Tille <tille@debian.org>
Cc: XFS Development Team <linux-xfs@vger.kernel.org>, 
	Anibal Monsalve Salazar <anibal@debian.org>, Nathan Scott <nathans@debian.org>
Subject: Re: Please migrate xfsdump and xfsprogs Debian packaging to Salsa
Message-ID: <adzdGhc8Hu28Vqia@nidhogg.toxiclabs.cc>
References: <ads96yii8bij-UQQ@an3as.eu>
 <20260413035534.GF1048989@frogsfrogsfrogs>
 <adzH8Xwc_Qz6hwgH@nidhogg.toxiclabs.cc>
 <adzVzC0mZ8b8lUO-@an3as.eu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adzVzC0mZ8b8lUO-@an3as.eu>

On Mon, Apr 13, 2026 at 01:38:52PM +0200, Andreas Tille wrote:
> Hi Carlos,
> 
> Am Mon, Apr 13, 2026 at 12:41:08PM +0200 schrieb Carlos Maiolino:
> > > > I'd be happy if these packages could be maintained in a publicly visible
> > > > Git repository on Salsa, with appropriate Vcs fields set.
> > > 
> > > That's more or less a matter of setting a couple of fields in
> > > debian/control, right?
> > > 
> > > Vcs-Browser: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > > Vcs-Git: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git -b master
> > 
> > ohh.. debian-specific fields for which VCS it uses seems like.
> 
> Yes, Debian specific ... and https://salsa.debian.org is Gitlab instance
> Debian is using for the vast majority of packages.  In general there are
> good reasons to do the packaging there (for instance to not disturb
> upstream maintainers like you with the communication ;-) ) but there are
> exceptions from this rule.  I'd be happy to hear from the persons
> (Anibal and Nathan are listed) who usually care for the Debian packaging
> whether such an exception are these xfs related packages.
> 
> If not I'd happily lend a helping hand to migrate the Debian packaging
> to Salsa.

Ah.. Thanks! this helps a lot!

>  
> Kind regards
>    Andreas.
> 
> -- 
> https://fam-tille.de
> 
