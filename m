Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911322FFDCC
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 21:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761341712; cv=none; b=UbSJocGmK8FxNZFZtrTvWu7kMfl5E159qAA+StkEpIe5FIKuUu6rqW1aaUP+yURj4grjV4sCAFD4lLEzgxz51TKr8w1Nn6/M2O88aqqybaeXjZqbQLBl0syuD1poqlHB0k7RPJeQDvZcyVhSZZlNHpdYIhNKwJZcfr6G41d+sW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761341712; c=relaxed/simple;
	bh=FEJi37EnjVLtWJHbEVtb0wPyZ1YqdI7cykqHdGUf0Is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5cx6THmPJXjKo9AoCQz+nRJw6WPDRNSPoa3tsky7G+gLHrmOa59/Gvj+it6zti9bEV44LXK4Ijms07YRGhquItXSIohN4fjg06tv3dkhs873NWgwrHAWuz+IE2dvOXg58NgsIdfCtgWe8rfn5+bxrhOFMuaWKx4ZStISvW3iAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PaGNnvR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PaGNnvR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09834C4CEF1;
	Fri, 24 Oct 2025 21:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761341712;
	bh=FEJi37EnjVLtWJHbEVtb0wPyZ1YqdI7cykqHdGUf0Is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PaGNnvR4Zsy8wyvoFZJkuFjaNsnkyDTaP+RydutsOvagluytT+JI4n30IDOb3kJ1E
	 Q+dFQHtQCjyzNlma/DDg8rGKb7cX04lYi/ilM0Jvb6NpZ2yAIHscKwHKUAYL6xudn7
	 5UUhnw+td1UOYeELXKsXtoaZnake7hRTcUK6UALUu3aVRiq+6vgco/A1W95AVO+HSx
	 77Ng1RHuMo9oEfHDUH+equGrsLiXycZMoDmX9L1WzdpSikYxrTZVYiz6kXGGreuzrG
	 X27bYNRFYjYt+fm3lbRFAxHvV10CkESGsNi5fx+wjrUW8u2cl/njK/dXnH7Iizko1W
	 dYAOmJM0NIhLA==
Date: Fri, 24 Oct 2025 14:35:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v1] proto: fix file descriptor leak
Message-ID: <20251024213511.GK4015566@frogsfrogsfrogs>
References: <20251024193649.302984-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024193649.302984-1-luca.dimaio1@gmail.com>

On Fri, Oct 24, 2025 at 09:36:48PM +0200, Luca Di Maio wrote:
> fix leak of pathfd introduced in commit 8a4ea72724930cfe262ccda03028264e1a81b145
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>

A few points:

First, everyone makes mistakes, don't worry about it. :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Second, the canonical format for kernel-ish formats is most probably
something like:

Cc: <linux-xfs@vger.kernel.org> # v6.17.0
Fixes: 8a4ea72724930c ("proto: add ability to populate a filesystem from a directory")

but this is xfsprogs, so there isn't any formally established
convention aside from "Darrick copies the kernel style and the
complaining hasn't been harsh enough for him to stop".

Third, does anyone actually have a script to generate these git
trailers?  I set user.stableSubmissionTarget = linux-xfs@vger.kernel.org
in gitconfig and use this:

#!/bin/bash

# Cite a list of git hashes in Fixes: tag format.

if [ -z "$1" ] || [ "$1" = "--help" ]; then
	echo "Usage: $0 commit [commits...]"
	exit 1
fi

stable_email="$(git config user.stableSubmissionTarget)"

# Find the most recent version tag for this commit.  Assumes that version tags
# start with v and a digit.
tag_for_commit() {
	local arg="$1"
	local tag
	local release_tag
	local rc_suffix
	local version_prefix

	# Find the first tag created after this commit.
	version_prefix="$(git config versionsort.prefix)"
	test -z "${version_prefix}" && version_prefix="v"
	tag="$(git tag -l --contains "${arg}" --sort version:refname | \
		grep "^${version_prefix}[0-9]" | \
		head -n 1)"
	test -z "${tag}" && return 1

	# Strip off any version suffix (presumably "-rcX") to construct what
	# ought to be the tag name for the final release.
	rc_suffix="$(git config versionsort.suffix)"
	# shellcheck disable=SC2001
	release_tag="$(echo "${tag}" | sed -e "s/${rc_suffix}.*//g")"

	# If the release tag actually exists, print that instead of the first
	# tag.  Otherwise, print that first tag.  We'd rather print "v5.4" than
	# the more accurate "v5.4-rc1" because stable backports target
	# releases, not -rcX.
	if [ -n "$(git tag -l "${release_tag}" 2>/dev/null)" ]; then
		echo "${release_tag}"
	else
		echo "${tag}"
	fi
	return 0
}

gitlog=(git log --format='Fixes: %h ("%s")')
for arg in "$@"; do
	if [ -n "${stable_email}" ]; then
		fixed_in="$(tag_for_commit "${arg}")" && \
			echo "Cc: <${stable_email}> # ${fixed_in}"
	fi
	"${gitlog[@]}" "${arg}^1..${arg}"
done

--D

> ---
>  mkfs/proto.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 2b29240d..1a7b3586 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -1772,6 +1772,7 @@ handle_direntry(
>  	create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
>  			    rdev, fd, fname);
>  out:
> +	close(pathfd);
>  	/* Reset path_buf to original */
>  	path_buf[path_len] = '\0';
>  }
> --
> 2.51.0
