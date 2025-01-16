Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A5219343E
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063804; cv=none; b=NhCaZli+nFNVoUD2Xwf72rb0dmcpgZ2CzhkGf4+J1o1siSOdyLMaWbS9/YMgpZsCBLxQTzgSAAG/ISc8DB+0Lh4uDAtyphCD672oQPrf3LJeTUPFNyLVNbvT7Phyx7KScR9i5Wm9jdUedFt0bAjV02aw5OEHRa2pv3eG30Sa/+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063804; c=relaxed/simple;
	bh=V+W/hUUCEx1KKbgNXdFS51huHOtR+59geCrOdW5A/x0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rrgk2UvRn/OEeQj4enaM2OuwhQXuS+/hOlQx8S2dz4R3l7lG139itoC2K1XqzXW7DHG89uhqu2GyuQWYnNLKHn4pRgRIpCtMB31C10SIwtl8kTwKCMbYZ6t5eqcz/iCHtPucL743dwRwrsP/SEGHJdmW14pLSYbXQDK8ykHfLg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQBPE3ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQBPE3ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92425C4CED6;
	Thu, 16 Jan 2025 21:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063803;
	bh=V+W/hUUCEx1KKbgNXdFS51huHOtR+59geCrOdW5A/x0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uQBPE3ec9O0CYUY5wkaIZJm8GmmxwWdCTKArtIwI5SSqlaSVCOjlRBMQ/HjBebIAz
	 gT0I+E/zjtUNG78qVq4tRtzKHVoS+OHKIOa1jAa/hyAtBLF8JsTbUun+PuKS1b0oG9
	 JenbjSeMUGXhouZ2g3epmLfecz3Yr2AUfv+7VoQUZTiHrEzxzS3jJ8wXVJP080wflU
	 Ht/7r3Zdk3hsf/Tj1MHGbyfLubmxGFqgV+mmHdO3F3mOLErk7hObCTMsQat6kxo1FF
	 8xs3oj/ygTmG/xCI7bTx2EMwBoGQogidzPOeH3OIkjhdE+pqL8FmLX5NgPhfDSorpm
	 keTBlUxCvf8zw==
Date: Thu, 16 Jan 2025 13:43:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 1/4] release.sh: add signing and fix outdated commands
Message-ID: <20250116214323.GC1611770@frogsfrogsfrogs>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
 <20250110-update-release-v1-1-61e40b8ffbac@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110-update-release-v1-1-61e40b8ffbac@kernel.org>

On Fri, Jan 10, 2025 at 12:05:06PM +0100, Andrey Albershteyn wrote:
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks reasonable to me!  (I like the conversion to long opts, btw)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  release.sh | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/release.sh b/release.sh
> index 577257a354d442e1cc0a2b9381b11ffbe2f64a71..b15ed610082f34928827ab0547db944cf559cef4 100755
> --- a/release.sh
> +++ b/release.sh
> @@ -9,6 +9,8 @@
>  # configure.ac (with new version string)
>  # debian/changelog (with new release entry, only for release version)
>  
> +set -e
> +
>  . ./VERSION
>  
>  version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
> @@ -16,21 +18,38 @@ date=`date +"%-d %B %Y"`
>  
>  echo "Cleaning up"
>  make realclean
> +rm -rf "xfsprogs-${version}.tar" \
> +	"xfsprogs-${version}.tar.gz" \
> +	"xfsprogs-${version}.tar.asc" \
> +	"xfsprogs-${version}.tar.sign"
>  
>  echo "Updating CHANGES"
>  sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/CHANGES.tmp && \
>  	mv doc/CHANGES.tmp doc/CHANGES
>  
>  echo "Commiting CHANGES update to git"
> -git commit -a -m "${version} release"
> +git commit --all --signoff --message="xfsprogs: Release v${version}
> +
> +Update all the necessary files for a v${version} release."
>  
>  echo "Tagging git repository"
> -git tag -a -m "${version} release" v${version}
> +git tag --annotate --sign --message="Release v${version}" v${version}
>  
>  echo "Making source tarball"
>  make dist
> +gunzip -k "xfsprogs-${version}.tar.gz"
>  
> -#echo "Sign the source tarball"
> -#gpg --detach-sign xfsprogs-${version}.tar.gz
> +echo "Sign the source tarball"
> +gpg \
> +	--detach-sign \
> +	--armor \
> +	"xfsprogs-${version}.tar"
>  
> -echo "Done.  Please remember to push out tags using \"git push --tags\""
> +echo "Verify signature"
> +gpg \
> +	--verify \
> +	"xfsprogs-${version}.tar.asc"
> +
> +mv "xfsprogs-${version}.tar.asc" "xfsprogs-${version}.tar.sign"
> +
> +echo "Done. Please remember to push out tags using \"git push origin v${version}\""
> 
> -- 
> 2.47.0
> 
> 
