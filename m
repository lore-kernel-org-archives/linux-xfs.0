Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FA51BDA91
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 17:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738085883; cv=none; b=o1aAVHC4RRAwIIzHyb0DUpzIyOsqX6rlLlFXkUFaw08GMoKJfnG0WyKjkhrzgrVt/lOzNGBgrBGoaqJJlSVSyX7zYInhaPGuvmiaMoNkHkXQKVu0BFpW8dn65GIuX/InusNbOAAOcz1khmHbWR4dGyE1WccjQPDVbQkJlnyX0dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738085883; c=relaxed/simple;
	bh=IxudnWFSpPipTv2CHGDJnB7RYYofcuBHOc+tIIjnzYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QjpimoUAn7zAiG3rUBTERcGj/MHbWPnaOWM7esTDYhzvEQTDIUVxq8RAGWItwOFC5ClUDcxSXM+cnsZCEprghmzjapbXFNN4/7qcwiuAPREn72W5apd7bYADd78pFwGWW3oTI/Civ/o7hGAgLKY5PVXO9RNnazpEthFgC+Y3d9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdFcYFhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdFcYFhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA79C4CED3;
	Tue, 28 Jan 2025 17:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738085883;
	bh=IxudnWFSpPipTv2CHGDJnB7RYYofcuBHOc+tIIjnzYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cdFcYFhswVe+GSQMvt7ddS2EEF9YdF7X8PxlkCuZ4vlpxNmqlIPA+GuPlwSloS6q0
	 bEUN2V/7mWmBG5Y86FR5uX8oIYa0tMFa2UlOTCnNoPsvkzI0AVFgzNODsuZ4rYiIo4
	 9yABxO5C9Z/LaWrTYSVlTWM1zwJGn7rGS2hXVt8HyjS3BCIXe0yVcABJQ1mp18q/MO
	 wRELH1IhdVLY37dQJiQ0G/lTUMQw4VkiFoAnyA4SAVUp9LuLdWhGUctt9UOmtrOJSD
	 NtY2xC+v32HiBrNfHudsaDDmDKq1WZyI3JHyfEfncRL5Tjb17mAylQFx+ALvZA8M8f
	 UF5wBN+LnpWZg==
Date: Tue, 28 Jan 2025 09:38:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v2 3/7] release.sh: update version files make commit
 optional
Message-ID: <20250128173802.GM1611770@frogsfrogsfrogs>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
 <20250122-update-release-v2-3-d01529db3aa5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122-update-release-v2-3-d01529db3aa5@kernel.org>

On Wed, Jan 22, 2025 at 04:01:29PM +0100, Andrey Albershteyn wrote:
> Based on ./VERSION script updates all other files. For
> ./doc/changelog script asks maintainer to fill it manually as not
> all changes goes into changelog.
> 
> --no-commit|-n flag is handy when something got into the version commit
> and need to be changed manually. Then ./release.sh -c will use fixed
> history
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  release.sh | 75 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 58 insertions(+), 17 deletions(-)
> 
> diff --git a/release.sh b/release.sh
> index b036c3241b3f67bfb2435398e6a17ea4c6a6eebe..57ff217b9b6bf62873a149029957fdd9f01b8c38 100755
> --- a/release.sh
> +++ b/release.sh
> @@ -11,16 +11,33 @@
>  
>  set -e
>  
> -. ./VERSION
> -
> -version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
> -date=`date +"%-d %B %Y"`
> -
>  KUP=0
> +COMMIT=1
>  
>  help() {
>  	echo "$(basename) - create xfsprogs release"
>  	printf "\t[--kup|-k] upload final tarball with KUP\n"
> +	printf "\t[--no-commit|-n] don't create release commit\n"
> +}
> +
> +update_version() {
> +	echo "Updating version files"
> +	# doc/CHANGES
> +	header="xfsprogs-${version} ($(date +'%d %b %Y'))"
> +	sed -i "1s/^/$header\n\t<TODO list user affecting changes>\n\n/" doc/CHANGES
> +	$EDITOR doc/CHANGES
> +
> +	# ./configure.ac
> +	CONF_AC="AC_INIT([xfsprogs],[${version}],[linux-xfs@vger.kernel.org])"
> +	sed -i "s/^AC_INIT.*/$CONF_AC/" ./configure.ac
> +
> +	# ./debian/changelog
> +	sed -i "1s/^/\n/" ./debian/changelog
> +	sed -i "1s/^/ -- Nathan Scott <nathans@debian.org>  `date -R`\n/" ./debian/changelog
> +	sed -i "1s/^/\n/" ./debian/changelog
> +	sed -i "1s/^/  * New upstream release\n/" ./debian/changelog
> +	sed -i "1s/^/\n/" ./debian/changelog
> +	sed -i "1s/^/xfsprogs (${version}-1) unstable; urgency=low\n/" ./debian/changelog
>  }
>  
>  while [ $# -gt 0 ]; do
> @@ -28,6 +45,9 @@ while [ $# -gt 0 ]; do
>  		--kup|-k)
>  			KUP=1
>  			;;
> +		--no-commit|-n)
> +			COMMIT=0
> +			;;
>  		--help|-h)
>  			help
>  			exit 0
> @@ -40,6 +60,36 @@ while [ $# -gt 0 ]; do
>  	shift
>  done
>  
> +if [ -z "$EDITOR" ]; then
> +	EDITOR=$(command -v vi)
> +fi
> +
> +if [ $COMMIT -eq 1 ]; then
> +	if git diff --exit-code ./VERSION > /dev/null; then
> +		$EDITOR ./VERSION
> +	fi
> +fi
> +
> +. ./VERSION
> +
> +version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
> +date=`date +"%-d %B %Y"`
> +
> +if [ $COMMIT -eq 1 ]; then
> +	update_version
> +
> +	git diff --color=always | less -r
> +	[[ "$(read -e -p 'All good? [Y/n]> '; echo $REPLY)" == [Nn]* ]] && exit 0
> +
> +	echo "Commiting new version update to git"
> +	git commit --all --signoff --message="xfsprogs: Release v${version}
> +
> +Update all the necessary files for a v${version} release."
> +
> +	echo "Tagging git repository"
> +	git tag --annotate --sign --message="Release v${version}" v${version}
> +fi
> +
>  echo "Cleaning up"
>  make realclean
>  rm -rf "xfsprogs-${version}.tar" \
> @@ -47,17 +97,6 @@ rm -rf "xfsprogs-${version}.tar" \
>  	"xfsprogs-${version}.tar.asc" \
>  	"xfsprogs-${version}.tar.sign"
>  
> -echo "Updating CHANGES"
> -sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/CHANGES.tmp && \
> -	mv doc/CHANGES.tmp doc/CHANGES
> -
> -echo "Commiting CHANGES update to git"
> -git commit --all --signoff --message="xfsprogs: Release v${version}
> -
> -Update all the necessary files for a v${version} release."
> -
> -echo "Tagging git repository"
> -git tag --annotate --sign --message="Release v${version}" v${version}
>  
>  echo "Making source tarball"
>  make dist
> @@ -83,4 +122,6 @@ if [ $KUP -eq 1 ]; then
>  		pub/linux/utils/fs/xfs/xfsprogs/
>  fi;
>  
> -echo "Done. Please remember to push out tags using \"git push origin v${version}\""
> +echo ""
> +echo "Done. Please remember to push out tags and the branch."
> +printf "\tgit push origin v${version} master\n"

	git push origin v${version} master:master master:for-next

per this morning's office hours discussion ;)

With that changed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> -- 
> 2.47.0
> 
> 
