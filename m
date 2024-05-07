Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0C271B4B
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 21:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715115895; cv=none; b=q3UJjXx0Ph0/z9672pMXsUPpzxaissZlUXAGwmGp3WohLXyJUP2/ti4KMUKny3nj5sHUwXn717vLDffw4lMAAta54LXdW+1FN5am/KEKvCeYeKrHprE0R4VZHUIODKQRgLEU4i9RpsMoQJ5PY/qgPu29nbT7l7TApttJ9cJI3JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715115895; c=relaxed/simple;
	bh=7PmgZ5Y6LdFOpVzxLyRiU1Cif9j3BOfVPD/SebOx3ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnpQOuOeyyV0qJ7O1DQJ7uQUMyQEEaDkOVxN135pEcjcjO6zM5NS8mw+7tOkXL/OtcD8oNJlwXathWT0ByMG5YBs691Stxt/pEC+i9GtiyHcJgKjfmcyvX5Ha3eeaiS+1jjpkvPvzD2WmyvZgp2oKkgldYLixYtTLfb6sdW9IO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFXJ9UtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFXJ9UtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D79C2BBFC;
	Tue,  7 May 2024 21:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715115894;
	bh=7PmgZ5Y6LdFOpVzxLyRiU1Cif9j3BOfVPD/SebOx3ec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rFXJ9UtMBHtjD9szeDedWCorJHb2yyQ/xjrHkwdHN2cu+idrf5DafcKJ8fTbvZJLd
	 Jced2bWrQuwBxFJIppDJ0YPPwKP4c64zHOek/HouVTLiWKaeBfqiS3CiCh/eonZALz
	 lIJLXeUkhRAa40HAOLziw4ppS0R5Q1/Cky+ekxP2BBy2wfPBIBaHrQ4KJ2z4/0LvB7
	 lsU5Jut14268hZe4Dy1sdKpx4cr3NO7oZhfkwk6KNmAe4BxgbbvzTKfFLRBY9QTLyI
	 zi4Ac2XC7u9OuGr4Uy3iNkmMt0r6RNITKqlGBvh18g5Lvgx0iMnNjBrp1vBKOcQ98p
	 easHXVdMDlK4A==
Date: Tue, 7 May 2024 14:04:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Leah Rumancik <leah.rumancik@gmail.com>
Cc: linux-xfs@vger.kernel.org, amir73il@gmail.com, chandan.babu@oracle.com
Subject: Re: [PATCH 6.1] MAINTAINERS: add leah to MAINTAINERS file
Message-ID: <20240507210454.GT360919@frogsfrogsfrogs>
References: <20240506180426.692441-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506180426.692441-1-leah.rumancik@gmail.com>

On Mon, May 06, 2024 at 11:04:26AM -0700, Leah Rumancik wrote:
> I've been trying to get backports rolling to 6.1.y. Update MAINTAINERS
> file so backports requests / questions can get routed appropriately.
> 
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ecf4d0c8f446..4b19dfb5d2fd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22557,6 +22557,7 @@ F:	include/xen/swiotlb-xen.h
>  
>  XFS FILESYSTEM
>  C:	irc://irc.oftc.net/xfs
> +M:	Leah Rumancik <leah.rumancik@gmail.com>
>  M:	Darrick J. Wong <djwong@kernel.org>
>  L:	linux-xfs@vger.kernel.org
>  S:	Supported
> -- 
> 2.45.0.rc1.225.g2a3ae87e7f-goog
> 
> 
