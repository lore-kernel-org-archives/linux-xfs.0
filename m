Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C77213B58C
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 22:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737066148; cv=none; b=Ex2Mlhl2pgCd+H1rJpws9f2C0zSyP6cjDKJBmi5boqEFuX4ha1hG5xGC8ZoGtwizvYnKHa+M3XHN5ODovPlTZCxm8G9a7g3yJ9ag0WT3xzsCmWAa9vKrOSLO14HsWge7JsVyToCRXir+UlLutnq/lM0Vj/Gbfzj36wZp17/c84M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737066148; c=relaxed/simple;
	bh=bOS7wl7VoJsK0mZa1IDlyxaZ8LfF+4BH9W6PCPuc6NU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JUI7zsG3QFWawhA7/EPb/hAMCoN89nq/KnC09Q4tlBM9g0QDLUJFqVlATAcCa1BP0LSq1mc83i8CrLaaysxElySM6L7N+dKWXhd7GoAmFl/YzW4m4Vasl6edq85iOXD42/gSUv2453WsM3kh2eGHY3OtbTnKGe/28VhF9GEj7Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUjoh/kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUjoh/kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D35C4CED6;
	Thu, 16 Jan 2025 22:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737066147;
	bh=bOS7wl7VoJsK0mZa1IDlyxaZ8LfF+4BH9W6PCPuc6NU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kUjoh/kbqHina3FQouYmRtj7E8vA5Ce3n9yXh2D5qcZtzjnPm5arewSJw150iZiqP
	 QFcULm/gPjgB5XGEESpM33HK0DE/BMGOi8qs9rKugeLiwRmQOc5SZC/q2CdXuXq67W
	 bgeet4EQU0j0Kuxp2hsQKYJulfutV4nH7pss1Nkkp/KvOntEbnrMrmR3qXLQFm8rj+
	 w7LoWeNQR1H69cB6RJNpmIO9PzQ9AI1S7P6rw+Gc2mhQ0D+eydiT5hfA7MzHwLm9QD
	 soE1meP11GQK/0oSIwWIVQ5IUixjWAYVCV+ce87PT/7TcWSKlb80D4MmflU7pZxr6F
	 /4j3UlqHjX8wg==
Date: Thu, 16 Jan 2025 14:22:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 2/4] release.sh: add --kup to upload release tarball to
 kernel.org
Message-ID: <20250116222227.GD1611770@frogsfrogsfrogs>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
 <20250110-update-release-v1-2-61e40b8ffbac@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110-update-release-v1-2-61e40b8ffbac@kernel.org>

On Fri, Jan 10, 2025 at 12:05:07PM +0100, Andrey Albershteyn wrote:
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  release.sh | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/release.sh b/release.sh
> index b15ed610082f34928827ab0547db944cf559cef4..a23adc47efa5163b4e0082050c266481e4051bfb 100755
> --- a/release.sh
> +++ b/release.sh
> @@ -16,6 +16,30 @@ set -e
>  version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
>  date=`date +"%-d %B %Y"`
>  
> +KUP=0
> +
> +help() {
> +	echo "$(basename) - create xfsprogs release"
> +	printf "\t[--kup|-k] upload final tarball with KUP\n"
> +}
> +
> +while [ $# -gt 0 ]; do
> +	case "$1" in
> +		--kup|-k)
> +			KUP=1
> +			;;
> +		--help|-h)
> +			help
> +			exit 0
> +			;;
> +		*)
> +			>&2 printf "Error: Invalid argument\n"
> +			exit 1
> +			;;
> +		esac
> +	shift
> +done
> +
>  echo "Cleaning up"
>  make realclean
>  rm -rf "xfsprogs-${version}.tar" \
> @@ -52,4 +76,11 @@ gpg \
>  
>  mv "xfsprogs-${version}.tar.asc" "xfsprogs-${version}.tar.sign"
>  
> +if [ $KUP -eq 1 ]; then
> +	kup put \
> +		xfsprogs-${version}.tar.gz \
> +		xfsprogs-${version}.tar.sign \
> +		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz

Shouldn't this last argument be "pub/linux/utils/fs/xfs/xfsprogs/" ?

also you might want to put a sentence in the commit log for why you
want this, e.g. "Add kup support so that the maintainer can push the
newly formed release taballs to kernel.org."

--D

> +fi;
> +
>  echo "Done. Please remember to push out tags using \"git push origin v${version}\""
> 
> -- 
> 2.47.0
> 
> 
