Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C2934CFDA;
	Fri,  8 May 2026 07:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778224973; cv=none; b=nw1B7AWjBVeX8LaC28Uc+Jh/NFQBW9B1KjOXqoxMFhaRoBzGHQuVaf32EsQz3b5OuPklBFcdVlNYH6J4nnyfRvUtlNjGO3rsK4UXnFUgyap2JhRLOTEy1StPHHf4nlxELy7THHHOl4uIAZb4spMU/RViG3XVK1Rr0m14tqvz9rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778224973; c=relaxed/simple;
	bh=R39Eqwamdo+7D/VtL0CBfsZ02ZberhwSk3wzhGllT+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGwCL2fqFeg0z8HF4Ep7/x9mrL9Gnri0RFd0xg37JJ6AnW6x2hNy84CgMomDPJYhbbJXppu+nORadd/K7F+mVNAUCt7phnf0lB+U+7ZOxpxw0M/4vpa9Lxz93dU0DENuxKKYlDYbg0usP/wDV779gZzizkBYwyA4xkqQOeTil28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XlHxs/lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XlHxs/lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823B9C2BCB0;
	Fri,  8 May 2026 07:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778224972;
	bh=R39Eqwamdo+7D/VtL0CBfsZ02ZberhwSk3wzhGllT+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XlHxs/ltEQQkpamemaMNw2dTlqfEadRkg01KsUMP/otyhhFtqgHobxoHEhU7UycQC
	 FAx3b23bA9SbVLsqRrZZJaeVvEFi4KvGUSjrGS9oJ+BZ9tThuy5ffiKwLb9IWbvq6F
	 mRnZrlzU0PSjAdtNn4Abui69GHfTH15nd+KnrJbowNAAUYF8tUUYTCyC0mIRVaBa2r
	 P/EkGfH4c2NUjlM5Zbvec7SFTDgHcj8fFFhfZ8+WI3h5MuGHJM6thXGpBTdHDCpSRY
	 MWur24JPy+Jf3AvrVB+gqoC61ftKiVILoYAP1K8mlFrK8tYPHge1chd0grSg7njls2
	 oZtCoc4RwyAlQ==
Date: Fri, 8 May 2026 15:22:42 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: gedalya@gedalya.net, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] generic/45[34]: don't warn on mixed bidirectional
 characters
Message-ID: <af2Mdd3vl61NTnUI@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	gedalya@gedalya.net, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <177819254750.3505531.13966651630640194090.stgit@frogsfrogsfrogs>
 <177819254793.3505531.13029436500533639982.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177819254793.3505531.13029436500533639982.stgit@frogsfrogsfrogs>

On Thu, May 07, 2026 at 03:23:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We're dropping this warning from xfs_scrub because the warning is
> incorrect, so let's make sure the QA system checks that it's gone.
> 
> Cc: gedalya@gedalya.net
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

/me is just back from a paper about BIDI (Bidirectional Text), so the
"\xd7...\xaa" is RTL part, then ".pdf" is LTR part. OK, this test makes
sense to me. Darrick is going to become a word/char processing master now :)

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/generic/453 |   10 ++++++++++
>  tests/generic/454 |   10 ++++++++++
>  2 files changed, 20 insertions(+)
> 
> 
> diff --git a/tests/generic/453 b/tests/generic/453
> index 0193b010306c48..9b121d995ad1ab 100755
> --- a/tests/generic/453
> +++ b/tests/generic/453
> @@ -247,6 +247,10 @@ setf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
>  # totally hidden name? "(Hi)" is the file name
>  setf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
>  
> +# Gedalya complained about being flagged for mixing Hebrew (RTL) and Latin
> +# (LTR) codepoints in the same name.  This is a common practice.
> +setf "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" "mixed rtl and ltr chars?"
> +
>  ls -laR $testdir >> $seqres.full
>  
>  echo "Test files"
> @@ -359,6 +363,10 @@ testf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
>  # totally hidden name? "(Hi)" is the file name
>  testf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
>  
> +# Gedalya complained about being flagged for mixing Hebrew (RTL) and Latin
> +# (LTR) codepoints in the same name.  This is a common practice.
> +testf "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" "mixed rtl and ltr chars?"
> +
>  echo "Uniqueness of inodes?"
>  stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
>  	if [ "${nr}" -gt 1 ]; then
> @@ -403,6 +411,8 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
>  		grep -q 'tags_m.xf3.xa0.x81' $tmp.scrub || echo "No complaints about deprecated unicode tags in a name?"
>  	fi
>  
> +	grep -q 'mixes bidirectional characters' $tmp.scrub && echo "Unnecessary complaints about mixed bidi characters in a name?"
> +
>  	echo "Actual xfs_scrub output:" >> $seqres.full
>  	cat $tmp.scrub >> $seqres.full
>  fi
> diff --git a/tests/generic/454 b/tests/generic/454
> index 3454cae5d5ea6c..81c9a721561cf8 100755
> --- a/tests/generic/454
> +++ b/tests/generic/454
> @@ -168,6 +168,10 @@ setf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
>  # totally hidden name? "(Hi)" is the file name
>  setf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
>  
> +# Gedalya complained about being flagged for mixing Hebrew (RTL) and Latin
> +# (LTR) codepoints in the same name.  This is a common practice.
> +setf "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" "mixed rtl and ltr chars?"
> +
>  _getfattr --absolute-names -d "${testfile}" >> $seqres.full
>  
>  echo "Test files"
> @@ -256,6 +260,10 @@ testf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
>  
>  # totally hidden name? "(Hi)" is the file name
>  testf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
> +#
> +# Gedalya complained about being flagged for mixing Hebrew (RTL) and Latin
> +# (LTR) codepoints in the same name.  This is a common practice.
> +testf "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" "mixed rtl and ltr chars?"
>  
>  echo "Uniqueness of keys?"
>  crazy_keys="$(_getfattr --absolute-names -d "${testfile}" | grep -E -c '(french_|chinese_|greek_|arabic_|urk)')"
> @@ -285,6 +293,8 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
>  		grep -q 'tags_m.xf3.xa0.x81' $tmp.scrub || echo "No complaints about deprecated unicode tags in a name?"
>  	fi
>  
> +	grep -q 'mixes bidirectional characters' $tmp.scrub && echo "Unnecessary complaints about mixed bidi characters in a name?"
> +
>  	echo "Actual xfs_scrub output:" >> $seqres.full
>  	echo "${output}" >> $seqres.full
>  fi
> 
