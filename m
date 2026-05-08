Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9093603F8;
	Fri,  8 May 2026 07:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778224045; cv=none; b=CdAHBOH+ZsfhffxNxeuLXZ7wI/YqfSkKU33clepu0JGny3ed636JxeGgxW+ktopLKIVH2wMgc5IFFsffr8TJXpKZq7uWadux1JvZ4DM/TaxYSEzTdr1++8PMvLrUMhK9P2hTR+svEQ8q+xUK4nVQBk2glqzLHDLgAdR1K292QWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778224045; c=relaxed/simple;
	bh=NM+OMcC9oXzlVRHaWncCZ0ne4D8Yh+T5P0Z7avQXlO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BezsRCufSs0oYGPLU3GYi/4G9PtXCUlmNAo8U4gA0V0Qm7MPoR00W9vKlS1OylVT47tr8BcgAkbp/aZLRwHgAGFLcf/aLqygMasRAphiS0NME0evT7LhI4YRjTZkcr8UTXAec+juHdZR/sA34uOFGva3CKiTH7NwiPRV3r5jpo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6YO+PvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6YO+PvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E8CC2BCB0;
	Fri,  8 May 2026 07:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778224044;
	bh=NM+OMcC9oXzlVRHaWncCZ0ne4D8Yh+T5P0Z7avQXlO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F6YO+PvPyaB0QCSqM4ehijd4qSWYYwrgXFpCYAXLIjeegVjohKvE+kcpzwz362oIE
	 nVYE24u8rckgiXYkQesiBFF3yOykKx19cdRUkCZeT2D8F4owcQt8WY56KJlBJlZip3
	 Mx84990IszfrknMe1pwRGKOguU7bk1AB06piJCTRPrvvW6Ht0XIuCfB4eomDF+KNkA
	 khKF7fJr+N5iiJuSnGf7XF19ECct72xFTeXtWKwP02iWhJShizR0N/5drx9AYdd9gx
	 3wxdeV/0H06CEzoNPdIP9f8377TQJLX4OXcO373doLpWKj30s8+U2mQtZ4uIBHp4t2
	 mf9BIXrFyE+pw==
Date: Fri, 8 May 2026 15:07:13 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/45[34]: add detection of confusable
 variation sequences
Message-ID: <af2J30oIlwumD7wV@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <177819254750.3505531.13966651630640194090.stgit@frogsfrogsfrogs>
 <177819254775.3505531.17842420789857268686.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177819254775.3505531.17842420789857268686.stgit@frogsfrogsfrogs>

On Thu, May 07, 2026 at 03:23:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> ArsTechnica recently wrote about a GitHub supply chain attack wherein
> non-rendering unicode sequences were embedded in javascript files to
> hide payloads that could be decrypted trivially later.  While these are
> unlikely to appear in file and attribute names, xfs_scrub will warn about
> this sort of steganography, so let's make sure it works.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Make sense to me, I saw your patch:

  commit 95329f9fa13040962c5a2a5e91a29ba215eb341f
  Author: Darrick J. Wong <djwong@kernel.org>
  Date:   Mon Apr 13 07:57:00 2026 -0700

      xfs_scrub: warn about unicode variation selectors in names

Maybe we can metion the fix in the test case or in the commit log?

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/generic/453 |   35 +++++++++++++++++++++++++++++++++++
>  tests/generic/454 |   36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 71 insertions(+)
> 
> 
> diff --git a/tests/generic/453 b/tests/generic/453
> index bd5ce8b2bb11d9..0193b010306c48 100755
> --- a/tests/generic/453
> +++ b/tests/generic/453
> @@ -233,6 +233,20 @@ setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
>  setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
>  setf "\xf0\x9f\xab\xb6" "neutral"
>  
> +# confusion with variation selectors
> +setf "variations.txt" v0
> +setf "varia\xef\xb8\x80tions.txt" v1
> +setf "\xef\xb8\x80variations.txt" v2
> +setf "vari\xef\xb8\x80\xef\xb8\x81ations.txt" v3
> +setf "varia\xf3\xa0\x87\xa4tions.txt" v4
> +
> +# deprecated tags are considered control characters
> +setf "tags_moocow.txt" u0
> +setf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
> +
> +# totally hidden name? "(Hi)" is the file name
> +setf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
> +
>  ls -laR $testdir >> $seqres.full
>  
>  echo "Test files"
> @@ -331,6 +345,20 @@ testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
>  testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
>  testf "\xf0\x9f\xab\xb6" "neutral"
>  
> +# confusion with variation selectors
> +testf "variations.txt" v0
> +testf "varia\xef\xb8\x80tions.txt" v1
> +testf "\xef\xb8\x80variations.txt" v2
> +testf "vari\xef\xb8\x80\xef\xb8\x81ations.txt" v3
> +testf "varia\xf3\xa0\x87\xa4tions.txt" v4
> +
> +# deprecated tags are considered control characters
> +testf "tags_moocow.txt" u0
> +testf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
> +
> +# totally hidden name? "(Hi)" is the file name
> +testf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
> +
>  echo "Uniqueness of inodes?"
>  stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
>  	if [ "${nr}" -gt 1 ]; then
> @@ -368,6 +396,13 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
>  		grep -q "llamapirate" $tmp.scrub || echo "No complaints about hidden llm instructions in filenames?"
>  	fi
>  
> +	if grep -q "variations" $tmp.scrub; then
> +		grep -q 'varia.xef.xb8' $tmp.scrub || echo "No complaints about variation sequence confusion?"
> +		grep -q 'varia.xf3.xa0' $tmp.scrub || echo "No complaints about extended variation sequence confusion?"
> +		grep -q 'x80variations' $tmp.scrub || echo "No complaints about variations starting a name?"
> +		grep -q 'tags_m.xf3.xa0.x81' $tmp.scrub || echo "No complaints about deprecated unicode tags in a name?"
> +	fi
> +
>  	echo "Actual xfs_scrub output:" >> $seqres.full
>  	cat $tmp.scrub >> $seqres.full
>  fi
> diff --git a/tests/generic/454 b/tests/generic/454
> index 9f6ddb4a0e48b2..3454cae5d5ea6c 100755
> --- a/tests/generic/454
> +++ b/tests/generic/454
> @@ -154,6 +154,20 @@ setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
>  setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
>  setf "\xf0\x9f\xab\xb6" "neutral"
>  
> +# confusion with variation selectors
> +setf "variations.txt" v0
> +setf "varia\xef\xb8\x80tions.txt" v1
> +setf "\xef\xb8\x80variations.txt" v2
> +setf "vari\xef\xb8\x80\xef\xb8\x81ations.txt" v3
> +setf "varia\xf3\xa0\x87\xa4tions.txt" v4
> +
> +# deprecated tags are considered control characters
> +setf "tags_moocow.txt" u0
> +setf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
> +
> +# totally hidden name? "(Hi)" is the file name
> +setf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
> +
>  _getfattr --absolute-names -d "${testfile}" >> $seqres.full
>  
>  echo "Test files"
> @@ -229,6 +243,20 @@ testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
>  testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
>  testf "\xf0\x9f\xab\xb6" "neutral"
>  
> +# confusion with variation selectors
> +testf "variations.txt" v0
> +testf "varia\xef\xb8\x80tions.txt" v1
> +testf "\xef\xb8\x80variations.txt" v2
> +testf "vari\xef\xb8\x80\xef\xb8\x81ations.txt" v3
> +testf "varia\xf3\xa0\x87\xa4tions.txt" v4
> +
> +# deprecated tags are considered control characters
> +testf "tags_moocow.txt" u0
> +testf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
> +
> +# totally hidden name? "(Hi)" is the file name
> +testf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
> +
>  echo "Uniqueness of keys?"
>  crazy_keys="$(_getfattr --absolute-names -d "${testfile}" | grep -E -c '(french_|chinese_|greek_|arabic_|urk)')"
>  expected_keys=11
> @@ -249,6 +277,14 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
>  	grep -q "prohibition_" $tmp.scrub || echo "No complaints about prohibited sequence confusables?"
>  	grep -q "zerojoin_" $tmp.scrub || echo "No complaints about zero-width join confusables?"
>  	grep -q "llamapirate" $tmp.scrub || echo "No complaints about hidden llm instructions in filenames?"
> +
> +	if grep -q "variations" $tmp.scrub; then
> +		grep -q 'varia.xef.xb8' $tmp.scrub || echo "No complaints about variation sequence confusion?"
> +		grep -q 'varia.xf3.xa0' $tmp.scrub || echo "No complaints about extended variation sequence confusion?"
> +		grep -q 'x80variations' $tmp.scrub || echo "No complaints about variations starting a name?"
> +		grep -q 'tags_m.xf3.xa0.x81' $tmp.scrub || echo "No complaints about deprecated unicode tags in a name?"
> +	fi
> +
>  	echo "Actual xfs_scrub output:" >> $seqres.full
>  	echo "${output}" >> $seqres.full
>  fi
> 
