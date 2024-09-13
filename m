Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDA21D52B
	for <linux-xfs@vger.kernel.org>; Fri, 13 Sep 2024 05:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726206146; cv=none; b=jz1capaILGgqOzlVJ1fTRIOcm0shny5GIwqMf9ovPwN6vVvyI+D7Yrox0IGMJRf2OwqX/s7nsyGsOtjRk+FKy5dv9Y2x6HeEIMEagOosm2EfQ3wu2GIUTX1kXrY3VNW7gzUJewfgQYOH25Ct2VIZ8uAJSFVtfOi4D7947cMod5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726206146; c=relaxed/simple;
	bh=+dhDShFAjFIYABi7dc5CRIEuod1vpFBt4Z5M5e6Da3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIF9D+vh2uVbK9JCUAc/naBlWQUbgO2hkAejwinZhrFoMyPtyMrnC8/PwKykWH74645LYaXphyLBle9plDCC65GTSZJilqTOY+reyAUseC5b089SMygk6FiwXX+JwFaTK07kL3wYYd0hZyyPxHpbWrLNvONBSCC1rmtn4X9elTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjU9PHCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjU9PHCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BF4C4CEC0;
	Fri, 13 Sep 2024 05:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726206146;
	bh=+dhDShFAjFIYABi7dc5CRIEuod1vpFBt4Z5M5e6Da3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjU9PHCUYT9N2E03KPDx+GBcT5MRu4j22FSh6KBTL+H5lfuRvSZZpp7SvlOvpthHm
	 cIb0PMJoH+x55wqZ0+qWeDiiA66JI2aE+nGYQpl0ZxJX6GKAvUJeo7JD/xMDuKLJzV
	 rhehNzor19H1K7RePG+2RHQ5dCEJuxDIlOLGCuduNzYd61EmtuVpj0j8WNmrGZOYQf
	 wvEIUt1WdweVZYlW2+6Gl5PA/Hmf8jrknajcCpIjjNtl4sPCUzbuWohAsQQKajwzt/
	 KdTemnvzYC1TsLP3nmmV4o4en+B0Mqlm3rUfmIOrmiNIf/pgJerqHmYAb0FSB2DpcK
	 4kJhNa2ffd2RQ==
Date: Fri, 13 Sep 2024 07:42:22 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Bastian Germann <bage@debian.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6] debian: Debian and Ubuntu archive changes
Message-ID: <slyvt2rz27lnawl6k22ozv2mevul6zrv3j5pzmobrxao5ilsmh@qz4l27bmlqd7>
References: <20240912072059.913-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912072059.913-1-bage@debian.org>

On Thu, Sep 12, 2024 at 09:20:47AM GMT, Bastian Germann wrote:
> Hi,
> 
> I am forwarding all the changes that are in the Debian and Ubuntu
> archives with a major structural change in the debian/rules file,
> which gets the package to a more modern dh-based build flavor.
> 
> Bastian Germann (6):
>   debian: Update debhelper-compat level
>   debian: Update public release key
>   debian: Prevent recreating the orig tarball
>   debian: Add Build-Depends: systemd-dev
>   debian: Modernize build script
>   debian: Correct the day-of-week on 2024-09-04
> 
>  debian/changelog                |   2 +-
>  debian/compat                   |   2 +-
>  debian/control                  |   2 +-
>  debian/rules                    |  81 ++++++++----------------
>  debian/upstream/signing-key.asc | 106 ++++++++++++++------------------
>  5 files changed, 75 insertions(+), 118 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Those changes look fine for me, but I'll wait Darrick's review too as he's more
familiar with Debian than I am.

Carlos

> 
> -- 
> 2.45.2
> 
> 
