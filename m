Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCE319DF55
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 03:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776052535; cv=none; b=hXJ6GGEROlXwB4ZYfXggwqm7GMcVRWMPKcfT+CMhjpfHLmpKxl37n1//DF01ed0qoj8qcDy0WcGJQFYDp1P9U300WWPzY2wiwVF+W4xwm/wlnxPElhF6zXs3nE3LuPdQ8fzhyGhT7tgpXhTz8YSociRUDr2GUH6kq6cp0W5wTsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776052535; c=relaxed/simple;
	bh=sFQexgK1diFloQsxNvro+PRQh2W0q7MDnIAMgBzcfcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ug1gtDfHJK1hntTPK/FFxEM8OM7VzrBJqAPNR8zQa4emutj+GEl/QIupmBtRzSBOruEUdGFDTFf5ChaLNM+QGKsDtROE4xwZCDUUaoNUxIwMfwHiQotM356mbj0ZIVb9SAP46Eb3kgIWQslflJ9ms4vawio6mCg55luCB75ffUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNoCvzDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNoCvzDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0C7C116C6;
	Mon, 13 Apr 2026 03:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776052535;
	bh=sFQexgK1diFloQsxNvro+PRQh2W0q7MDnIAMgBzcfcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FNoCvzDtVhoEvqix2TjuZwBUp6tcf3yl9jMivXJPWDLEYHpMBCzwgLTVzy7moMh/L
	 6wQJ69QOEOL3S5ADVeVEpLVgiKtLDGPxLDoAwoEm4oUQTpj+1cqqIk3PCLE3iZTAvZ
	 OVB5yHDhexvRhwjieKxHt5zRqMHz4lajUIUHbQEkO6LjOTKpvmvvS30TUQAxDZrhuP
	 TikDfpvGaOCewlORW2mZvppP6qS77GGH/CrQ6/UjarHyNDL9yr1hEksCbAUnzJHXQw
	 RVm9kUs10iQhik2RMmuxgVpF1Eqh37zX3CELG0LeeoPXDOujeHsKmPaR36Ct1qAbxo
	 hg9Rm/qxIqtVw==
Date: Sun, 12 Apr 2026 20:55:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andreas Tille <tille@debian.org>
Cc: XFS Development Team <linux-xfs@vger.kernel.org>,
	Anibal Monsalve Salazar <anibal@debian.org>,
	Nathan Scott <nathans@debian.org>
Subject: Re: Please migrate xfsdump and xfsprogs Debian packaging to Salsa
Message-ID: <20260413035534.GF1048989@frogsfrogsfrogs>
References: <ads96yii8bij-UQQ@an3as.eu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ads96yii8bij-UQQ@an3as.eu>

On Sun, Apr 12, 2026 at 08:38:35AM +0200, Andreas Tille wrote:
> Hi XFS Development Team,
> 
> I'm currently reviewing team-maintained packages that are not exposing
> Vcs fields.  I assume for some efficient team work you are maintaining
> 
>   xfsdump
>   xfsprogs 
> 
> in some Git repository, but the Vcs fields are not set and I could not
> find corresponding repositories on Salsa.  I'm not even sure whether you
> might have some team space there or whether the Debian team might
> sufficiently fulfill your needs.
> 
> I'd be happy if these packages could be maintained in a publicly visible
> Git repository on Salsa, with appropriate Vcs fields set.

That's more or less a matter of setting a couple of fields in
debian/control, right?

Vcs-Browser: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
Vcs-Git: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git -b master

--D

> If there are specific reasons why this is currently not the case, I
> would be interested to understand them as well.
> 
> If you need any help with creating some Git repository I can happily
> do so since I have developed some training in doing this.
> 
> Thanks for your work on XFS in Debian, and best regards,
>    Andreas.
> 
> -- 
> https://fam-tille.de
> 
