Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D34155C87
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 17:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738085937; cv=none; b=UVY+EQ7cO+7vdjCIxsunvWsL4sqFVAp0IvbprSDka3XfzDxSWS3wK6sfd2k/vVgtybudj29q0/gNypPqN4jZCUyOqY3xWg8bWkhWP7HVZdEH39mGfAnjBro/mEM6Wvcz8eNujVRNMEaHEI6uh947c/6Udl6bnBTfDYujJ/9Dl14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738085937; c=relaxed/simple;
	bh=peX7BIRklHnsjfbsXV3p9neNBma108nov6uyTVmZbjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOeOUbBrlvMQDtJWJjC491mvEEkjhu6EOMQFiQs1VmrnQNqFa1O8wGbEHUtYY8MGlbbWEAU+SAc958LCPQiBwQALSFDBVjaMDtmSLb4T71HqoaUCHeca/uvPnMA2J4T3jYaVWqKHqdTYMDgaIj4JdOp4UfrBAUcSr0O5wwx1ydE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHYfzs+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHYfzs+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DA8C4CED3;
	Tue, 28 Jan 2025 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738085937;
	bh=peX7BIRklHnsjfbsXV3p9neNBma108nov6uyTVmZbjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OHYfzs+JILzl3KkJMWNeSr9xgg7REJD80XjOm7Ypa+iLUx6YeaqF6OhjUuDNgQcOB
	 umT7H0lf0MC/OUHowY8r2SH42Wx0wQxvNSfftN2U8ZoA0ny7HtTzXTkz7XJrcvJukd
	 Q+BiX71WksFQjKMFgCb/m4wujkguYWN8TM8q1JCADL7lkwTIKyoPteWtE/Qp0+MLVI
	 51R6Li1UxUyqJHvOxFCiYldxoIMqEgyZt4vVqcudwn8V2l77zRXn809G8wycLKBHzR
	 9CeGLzPBjGDZJkhGwQWZ/HDR4mjIC2/95T9kq4Q76takXGw4b+Z30c012lhKXYV0sr
	 8CQMUY0sFb/cw==
Date: Tue, 28 Jan 2025 09:38:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v2 4/7] release.sh: generate ANNOUNCE email
Message-ID: <20250128173856.GN1611770@frogsfrogsfrogs>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
 <20250122-update-release-v2-4-d01529db3aa5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122-update-release-v2-4-d01529db3aa5@kernel.org>

On Wed, Jan 22, 2025 at 04:01:30PM +0100, Andrey Albershteyn wrote:
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  release.sh | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/release.sh b/release.sh
> index 57ff217b9b6bf62873a149029957fdd9f01b8c38..723806beb05761da06d971460ee15c97d2d0d5b1 100755
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
> @@ -122,6 +128,43 @@ if [ $KUP -eq 1 ]; then
>  		pub/linux/utils/fs/xfs/xfsprogs/
>  fi;
>  
> +mail_file=$(mktemp)
> +if [ -n "$LAST_HEAD" ]; then
> +	cat << EOF > $mail_file
> +To: linux-xfs@vger.kernel.org
> +Subject: [ANNOUNCE] xfsprogs $(git describe --abbrev=0) released
> +
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
> +
>  echo ""
>  echo "Done. Please remember to push out tags and the branch."
>  printf "\tgit push origin v${version} master\n"
> +if [ -n "$LAST_HEAD" ]; then
> +	echo "Command to send ANNOUNCE email"
> +	printf "\tneomutt -H $mail_file\n"
> +fi
> 
> -- 
> 2.47.0
> 
> 
