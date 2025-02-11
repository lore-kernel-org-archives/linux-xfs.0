Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45597261594
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 19:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739300990; cv=none; b=m/aWXcrEiYuTTpTqy1qkVlhK0Ro1Qjk6pGFLipVgwRLOa4eToMC4TdnZn5zIQuTrnD6CWtIvym7RMbBCk1AjPxlHBmmtxzxDkloMN7s6O+44MCEfHJrk6VYIonFSxV23R2l6tnn4RKMLtynEWUTA9qRsqGtYAZjgT4Vl+KVxhyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739300990; c=relaxed/simple;
	bh=kHlk44ejz4nHFwJsq3U5wG5Ojuaemd2J59hk0t6eKCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjaOf4NOk03WKrfE8ahItqJzzKfuu7Ux8J6bHzdyKvoClPcvqgKP3kvfh5tfqGPLgkahN5g9eQ2SbvSz45L1Z3qwbmJXdRBPZE1ACk9x6DmZRlrUvSJ06yXqv7ABn8B0F5Hzkj1+W5BPqYiWaZvQdCmWFlk6tJ2zJVpe2zk/j08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+GetweM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+GetweM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A792AC4CEDD;
	Tue, 11 Feb 2025 19:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739300989;
	bh=kHlk44ejz4nHFwJsq3U5wG5Ojuaemd2J59hk0t6eKCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y+GetweMOT/kIslteun/W4N4BL9kMkx99Y2PgJhI8gyabkMdpPE1YxMVYgt1XoJhb
	 /ZtDEl9pKNuk3IDU2CQkt4RTiWe/XD7luVH5uAQDrhjII83IDkAo0fNiL7JKvQNc3e
	 PB7abcJds5PeivVzFHHfQSznwoEr5W6GyuZuV2x8Mpo7In8XgTh1oE+F5eS4cdNwRA
	 5xBNFc7UZP8ICarUIso6Him8KRgBBCM4BeTN+msdo+sm4PN5nDkoC3Afy5tJhEmy3T
	 9vHjJ+6inVQnxZ6LJEOVH1fcOdJAMORal7RE2pDbXBGNYJLpUXPR7q4JUStBLcEKYd
	 9I4ngXhiy8nSw==
Date: Tue, 11 Feb 2025 11:09:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v3 8/8] release.sh: add -f to generate for-next update
 email
Message-ID: <20250211190949.GF21808@frogsfrogsfrogs>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
 <20250211-update-release-v3-8-7b80ae52c61f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211-update-release-v3-8-7b80ae52c61f@kernel.org>

On Tue, Feb 11, 2025 at 06:27:00PM +0100, Andrey Albershteyn wrote:
> Add --for-next/-f to generate ANNOUNCE email for for-next branch
> update. This doesn't require new commit/tarball/tags, so skip it.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  release.sh | 92 ++++++++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 59 insertions(+), 33 deletions(-)
> 
> diff --git a/release.sh b/release.sh
> index 3d272aebdb1fe7a3b47689b9dc129a26d6a9eb20..863c2c5e061b73e232c0bb01e879a115b6dd55bb 100755
> --- a/release.sh
> +++ b/release.sh
> @@ -14,12 +14,14 @@ set -e
>  KUP=0
>  COMMIT=1
>  LAST_HEAD=""
> +FOR_NEXT=0
>  
>  help() {
>  	echo "$(basename) - create xfsprogs release"
>  	printf "\t[--kup|-k] upload final tarball with KUP\n"
>  	printf "\t[--no-commit|-n] don't create release commit\n"
>  	printf "\t[--last-head|-l] commit of the last release\n"
> +	printf "\t[--for-next|-f] generate announce email for for-next update\n"
>  }
>  
>  update_version() {
> @@ -42,6 +44,48 @@ update_version() {
>  	sed -i "1s/^/xfsprogs (${version}-1) unstable; urgency=low\n/" ./debian/changelog
>  }
>  
> +prepare_mail() {

Hoisting this to a function probably ought to be done in the patch that
adds the email message body creation in the first place, so that the
changes for --for-next are more obvious.

The end result looks ok at least, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	branch="$1"
> +	mail_file=$(mktemp)
> +	if [ -n "$LAST_HEAD" ]; then
> +		if [ $branch == "master" ]; then
> +			reason="$(git describe --abbrev=0 $branch) released"
> +		else
> +			reason="for-next updated to $(git log --oneline --format="%h" -1 $branch)"
> +		fi;
> +		cat << EOF > $mail_file
> +To: linux-xfs@vger.kernel.org
> +Cc: $(./tools/git-contributors.py $LAST_HEAD..$branch --delimiter ' ')
> +Subject: [ANNOUNCE] xfsprogs: $reason
> +
> +Hi folks,
> +
> +The xfsprogs $branch branch in repository at:
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
> +The new head of the $branch branch is commit:
> +
> +$(git log --oneline --format="%H" -1 $branch)
> +
> +New commits:
> +
> +$(git shortlog --format="[%h] %s" $LAST_HEAD..$branch)
> +
> +Code Diffstat:
> +
> +$(git diff --stat --summary -C -M $LAST_HEAD..$branch)
> +EOF
> +	fi
> +}
> +
>  while [ $# -gt 0 ]; do
>  	case "$1" in
>  		--kup|-k)
> @@ -54,6 +98,9 @@ while [ $# -gt 0 ]; do
>  			LAST_HEAD=$2
>  			shift
>  			;;
> +		--for-next|-f)
> +			FOR_NEXT=1
> +			;;
>  		--help|-h)
>  			help
>  			exit 0
> @@ -66,6 +113,17 @@ while [ $# -gt 0 ]; do
>  	shift
>  done
>  
> +if [ $FOR_NEXT -eq 1 ]; then
> +	echo "Push your for-next branch:"
> +	printf "\tgit push origin for-next:for-next\n"
> +	prepare_mail "for-next"
> +	if [ -n "$LAST_HEAD" ]; then
> +		echo "Command to send ANNOUNCE email"
> +		printf "\tneomutt -H $mail_file\n"
> +	fi
> +	exit 0
> +fi
> +
>  if [ -z "$EDITOR" ]; then
>  	EDITOR=$(command -v vi)
>  fi
> @@ -128,39 +186,7 @@ if [ $KUP -eq 1 ]; then
>  		pub/linux/utils/fs/xfs/xfsprogs/
>  fi;
>  
> -mail_file=$(mktemp)
> -if [ -n "$LAST_HEAD" ]; then
> -	cat << EOF > $mail_file
> -To: linux-xfs@vger.kernel.org
> -Cc: $(./tools/git-contributors.py $LAST_HEAD.. --delimiter ' ')
> -Subject: [ANNOUNCE] xfsprogs $(git describe --abbrev=0) released
> -
> -Hi folks,
> -
> -The xfsprogs repository at:
> -
> -	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> -
> -has just been updated.
> -
> -Patches often get missed, so if your outstanding patches are properly reviewed
> -on the list and not included in this update, please let me know.
> -
> -The for-next branch has also been updated to match the state of master.
> -
> -The new head of the master branch is commit:
> -
> -$(git log --oneline --format="%H" -1)
> -
> -New commits:
> -
> -$(git shortlog --format="[%h] %s" $LAST_HEAD..HEAD)
> -
> -Code Diffstat:
> -
> -$(git diff --stat --summary -C -M $LAST_HEAD..HEAD)
> -EOF
> -fi
> +prepare_mail "master"
>  
>  echo ""
>  echo "Done. Please remember to push out tags and the branch."
> 
> -- 
> 2.47.2
> 
> 
