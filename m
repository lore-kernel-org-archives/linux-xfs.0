Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518741E9919
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 15:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776093677; cv=none; b=a5cfHGtNbmZRJe0EwBBeM7Uo1+HtfznbuS9F3mNVH1Qjx6kvZ5y09aURQIZX0f58fzXbeMkOtTDk+Sexf31UbZASt6h0Cli5XZE0ScAd9I6TP5D6zOQbinhRWstOA8T0GcG7Oqqqgi+nwRVGTngkUVZXd0Cfomc0pggSp0lIv+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776093677; c=relaxed/simple;
	bh=RqWV2rYPiQc9W0RopAs10UWiKi9uH3Fw9e4RDyfIOnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6ReR7ZqDIGDHTkmEh4o19Ji9GwziA4ROT0iSbpshghKPeOgKSwJ2AFlbZyysk2DABqmDL1VTvMWplItV4RbdnAMJx6hG4nYT0ML1iyhAoWdz0VA2Yg96LKTYl2APz3UbZEi4H9dlsoJqMrSIcnJ42i3VyPZyxwspFA5fdMauhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TzI3RY7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TzI3RY7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C94C2BCB0;
	Mon, 13 Apr 2026 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776093677;
	bh=RqWV2rYPiQc9W0RopAs10UWiKi9uH3Fw9e4RDyfIOnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TzI3RY7/xPfJHi9mmdRJHXce3aDTnnvV7l+hyP9hC2ZsfVQ4+8yw4GjPepiiPcAGJ
	 zkN5uCFp86P7zFP0Zi0vrywe6dGZi8QYmVPtjlQ7rmlGvl6ZtVfq7TbdY3UvXsfkR8
	 wzyP4YwMQOqovnasdc8P3o4ehOvhH/tCE0Y5yoabCSp3VJePFgaoAn+Ayag0FWzda5
	 qYY7x1qv70e88SCTmYq7le6Bq0Hz6ZSY+cGeFyecXs9t5ZoEEOo9hbpiDsciDbUOzG
	 YfO+ICH//xk9/t+zczj94RMbcLHOyVqXV2KRl/qVJ45TxTNiD88gcr3Fai4RjCxQx2
	 cLtGWEPeiaZ/A==
Date: Mon, 13 Apr 2026 17:21:12 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
	Andreas Tille <tille@debian.org>, XFS Development Team <linux-xfs@vger.kernel.org>, 
	Anibal Monsalve Salazar <anibal@debian.org>, Nathan Scott <nathans@debian.org>
Subject: Re: [PATCH] debian: add version control tags to control
Message-ID: <ad0J2tUfGHvzaecT@nidhogg.toxiclabs.cc>
References: <20260413143800.GI1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413143800.GI1048989@frogsfrogsfrogs>

On Mon, Apr 13, 2026 at 07:38:00AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some vcs fields to point to the official sources for the debian
> package (which is to say, upstream xfsprogs).
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  debian/control |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/debian/control b/debian/control
> index d50960fba205bb..738f3a15fefe79 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -18,6 +18,8 @@ Build-Depends: debhelper (>= 12),
>   uuid-dev
>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
> +Vcs-Browser: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> +Vcs-Git: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git -b master
>  
>  Package: xfsprogs
>  Depends: ${shlibs:Depends}, ${misc:Depends}, python3-dbus, python3:any
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
