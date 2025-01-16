Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728D51DAC81
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 22:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737067309; cv=none; b=aHcZR0qebCAIbXFGnpC4QHP1Hzy59VD/l/u9cP12tyhocdQnjwhlEOevCX05AXZ9bt45flEONvm5ormQx+YmmA+Pt3G3JFAf1UgAaoSrr96+FjsXKil51xBc+vm70KLfqwQUnz7E7t9WD3stnzoxyYsJSTJbrckamWpUV4GqS9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737067309; c=relaxed/simple;
	bh=FdnvuMTLsE4bNGSDU+L5DcouIs8fqLZW2TmYTQhrrV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVonf3nxnrxp80o1FqboB4A/Y3BXY8XDB9tIeWrMiRlE+7TGneSa2Nu3u1iBqg8Tx07RuwlPa4x4e9ZxALjGO+0M2TE7KzuiqoF23cXzqZ99+UNqpdsW1zD+FgC5kqfmYEXexhf1604hj7tENY72Jl9WLpRLkC2pDPltOrPfZtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IT/LpDMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IT/LpDMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3AEC4CED6;
	Thu, 16 Jan 2025 22:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737067308;
	bh=FdnvuMTLsE4bNGSDU+L5DcouIs8fqLZW2TmYTQhrrV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IT/LpDMXFl2m6XGCAdNZnyEkV1+Lreebp/y+djRT7SnMcaA7abPLzuwtxBIp9L+Be
	 H54Vna0EwsMSOgug0BOxXb/1FOj618dSJ7J6ycM0rPSBcGFNxAxsjD/+i2z0XlS23j
	 +xSDZyEiP+37JVlvIkc9skJCtoim/voIJ24hZ4UcvCJXmnyYt7gE5L3swQM8/9nBCH
	 I+3eoLFRRcsTz+7TBUq2HfXUJSvCRbazmmH6fufPjbvXltucyzVpBWRS1ZJ0NVWfqF
	 ZhVjuPSgCWe2WlJhUaaHasE2WfZRbF9Gp7bOR+Laz9xWaso+iaHfjoEZI1K+QW7qJB
	 TY+VIvJxyGTUg==
Date: Thu, 16 Jan 2025 14:41:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 4/4] release.sh: generate ANNOUNCE email
Message-ID: <20250116224148.GF1611770@frogsfrogsfrogs>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
 <20250110-update-release-v1-4-61e40b8ffbac@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110-update-release-v1-4-61e40b8ffbac@kernel.org>

On Fri, Jan 10, 2025 at 12:05:09PM +0100, Andrey Albershteyn wrote:
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  release.sh | 46 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/release.sh b/release.sh
> index c34efcbcdfcaf50a08853e65542e8f16214cfb4e..40ecfaff66c3e9f8d794e7543750bd9579b7c6c9 100755
> --- a/release.sh
> +++ b/release.sh
> @@ -13,11 +13,13 @@ set -e
>  
>  KUP=0
>  COMMIT=1
> +LAST_HEAD=""
>  
>  help() {
>  	echo "$(basename) - create xfsprogs release"
>  	printf "\t[--kup|-k] upload final tarball with KUP\n"
>  	printf "\t[--no-commit|-n] don't create release commit\n"
> +	printf "\t[--last-head|-h] commit of the last release\n"
>  }
>  
>  update_version() {
> @@ -48,6 +50,10 @@ while [ $# -gt 0 ]; do
>  		--no-commit|-n)
>  			COMMIT=0
>  			;;
> +		--last-head|-h)
> +			LAST_HEAD=$2
> +			shift
> +			;;
>  		--help|-h)
>  			help
>  			exit 0
> @@ -122,7 +128,45 @@ if [ $KUP -eq 1 ]; then
>  		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz
>  fi;
>  
> +mail_file=$(mktemp)
> +subject=""
> +if [ -n "$LAST_HEAD" ]; then
> +	subject="[ANNOUNCE] xfsprogs $(git describe --abbrev=0) released"
> +
> +	cat << EOF > $mail_file
> +Hi folks,
> +
> +The xfsprogs repository at:
> +
> +	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> +
> +has just been updated.
> +
> +Patches often get missed, so if your outstanding patches are properly reviewed
> +on the list and not included in this update, please let me know.
> +
> +The for-next branch has also been updated to match the state of master.
> +
> +The new head of the master branch is commit:
> +
> +$(git log --oneline --format="%H" -1)
> +
> +New commits:
> +
> +$(git shortlog --format="[%h] %s" $LAST_HEAD..HEAD)
> +
> +Code Diffstat:
> +
> +$(git diff --stat --summary -C -M $LAST_HEAD..HEAD)
> +EOF
> +fi

Looks pretty similar to my git-announce tool. ;)

> +
>  echo ""
> -echo "Done. Please remember to push out tags and the branch."
> +echo "Done."
> +echo "Please remember to push out tags and the branch."
>  printf "\tgit push origin v${version}\n"
>  printf "\tgit push origin master\n"
> +if [ -n "$LAST_HEAD" ]; then
> +	echo "Command to send ANNOUNCE email"
> +	printf "\tneomutt linux-xfs@vger.kernel.org -s \"$subject\" -i $mail_file\n"

Note: if you put the headers in $mail_file, like this:

cat << EOF > $mail_file
To: linux-xfs@vger.kernel.org
Subject: $subject

Hi folks,
...
ENDL

then you can do:

	neomutt -H $mail_file

to edit the message and send it out.  I also wonder if you'd like a copy
of my git-contributors script that spits out a list of emails to cc
based on the git diff?

--D

> +fi
> 
> -- 
> 2.47.0
> 
> 
