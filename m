Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FB313D897;
	Wed,  5 Feb 2025 18:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778796; cv=none; b=HI/++LDS4f1hbLxLAoMtr9nd30kmi7U/5IumrM4BfQtuOGq3Z8AHR9Z+ugRugehgyi8mqssSOEzwihOwuO7YjHqu86XyQuU5zZnQqGbBBBeC/UHnt1nHvVQJDySEVBfQcCeOeuAdo2PTFtjcjkLB51gpddI+w/CcCTyvsrTP+u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778796; c=relaxed/simple;
	bh=mWm09MBVEL/aoADzSbmIDIRIIbbCwMO2G9fxGowlWl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rLoNFJSjD/IQdhyOR2mB9qPIB+CyyBLdybfr9Yl0JiR+AepJv6xUUScbxLo1JGFYgqgxjsYxug1ma2x38OQHbE1n5gZVaL7iO0pyjE5A/xgjXRk3KtROagBUB8Xm1hGwH6B5+8jjnowwqreu/RNHN92euk+Q8H0iB0/BivxOviU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4/rxfhC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4/rxfhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803CAC4CED1;
	Wed,  5 Feb 2025 18:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738778795;
	bh=mWm09MBVEL/aoADzSbmIDIRIIbbCwMO2G9fxGowlWl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P4/rxfhCVZheX9rXyDDQCz75d7PBIrjia5CzuCGH9CkqS5kT61+eTf/N+o9e7h/E0
	 tsgGZgZqT+n8sioWRtpj+ihPND3A9epE3vbSgTKyw3gqh0NXAshayw08Rv5y63M5qm
	 wyULzF4NaD4/4coR74Gk8M2XJ5K1n5Mk5SNB4WlDTcSN738RqF9+GWiwImO0leZSii
	 QblCv31R99w/bDAQN3nAkZl9mvCoCdMuLXe0ewzDLwrldplqjezJLuNOE7Z1BAIguE
	 jE8/sA1gsVj1+Jk5LGy2OY5PK7QLassla1QN6ixTFcqu0hW0gvtLlGtYWP3J6rBPax
	 4WvyajgUILjPA==
Date: Wed, 5 Feb 2025 10:06:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: joannelkoong@gmail.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/34] generic/759,760: skip test if we can't set up a
 hugepage for IO
Message-ID: <20250205180634.GJ21799@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406261.546134.13417439080603539599.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406261.546134.13417439080603539599.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:24:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On an arm64 VM with 64k base pages and a paltry 8G of RAM, this test
> will frequently fail like this:
> 
> >  QA output created by 759
> >  fsx -N 10000 -l 500000 -h
> > -fsx -N 10000 -o 8192 -l 500000 -h
> > -fsx -N 10000 -o 128000 -l 500000 -h
> > +Seed set to 1
> > +madvise collapse for buf: Cannot allocate memory
> > +init_hugepages_buf failed for good_buf: Cannot allocate memory
> 
> This system has a 512MB hugepage size, which means that there's a good
> chance that memory is so fragmented that we won't be able to create a
> huge page (in 1/16th the available DRAM).  Create a _run_hugepage_fsx
> helper that will detect this situation at the start of the test and skip
> it, having refactored run_fsx into a properly namespaced version that
> won't exit the test on failure.
> 
> Cc: <fstests@vger.kernel.org> # v2025.02.02
> Cc: joannelkoong@gmail.com
> Fixes: 627289232371e3 ("generic: add tests for read/writes from hugepages-backed buffers")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/rc         |   34 ++++++++++++++++++++++++++++++----
>  ltp/fsx.c         |    6 ++++--
>  tests/generic/759 |    6 +++---
>  tests/generic/760 |    6 +++---
>  4 files changed, 40 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index b7736173e6e839..4005db776309f3 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4982,20 +4982,46 @@ _require_hugepage_fsx()
>  		_notrun "fsx binary does not support MADV_COLLAPSE"
>  }
>  
> -run_fsx()
> +_run_fsx()
>  {
> -	echo fsx $@
> +	echo "fsx $*"
>  	local args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
>  	set -- $here/ltp/fsx $args $FSX_AVOID $TEST_DIR/junk
>  	echo "$@" >>$seqres.full
>  	rm -f $TEST_DIR/junk
>  	"$@" 2>&1 | tee -a $seqres.full >$tmp.fsx
> -	if [ ${PIPESTATUS[0]} -ne 0 ]; then
> +	local res=${PIPESTATUS[0]}
> +	if [ $res -ne 0 ]; then
>  		cat $tmp.fsx
>  		rm -f $tmp.fsx
> -		exit 1
> +		return $res
>  	fi
>  	rm -f $tmp.fsx
> +	return 0
> +}
> +
> +# Run fsx with -h(ugepage buffers).  If we can't set up a hugepage then skip
> +# the test, but if any other error occurs then exit the test.
> +_run_hugepage_fsx() {
> +	_run_fsx "$@" -h &> $tmp.hugepage_fsx
> +	local res=$?
> +	if [ $res -eq 103 ]; then
> +		# According to the MADV_COLLAPSE manpage, these three errors
> +		# can happen if the kernel could not collapse a collection of
> +		# pages into a single huge page.
> +		grep -q -E ' for hugebuf: (Cannot allocate memory|Device or resource busy|Resource temporarily unavailable)' $tmp.hugepage_fsx && \
> +			_notrun "Could not set up huge page for test"
> +	fi
> +	cat $tmp.hugepage_fsx
> +	rm -f $tmp.hugepage_fsx
> +	test $res -ne 0 && exit 1
> +	return 0
> +}
> +
> +# run fsx or exit the test
> +run_fsx()
> +{
> +	_run_fsx || exit 1

This of course should read:

	_run_fsx "$@" || exit 1

and will be corrected in the next published draft.

--D

>  }
>  
>  _require_statx()
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index cf9502a74c17a7..d1b0f245582b31 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -2974,13 +2974,15 @@ init_hugepages_buf(unsigned len, int hugepage_size, int alignment, long *buf_siz
>  
>  	ret = posix_memalign(&buf, hugepage_size, size);
>  	if (ret) {
> -		prterr("posix_memalign for buf");
> +		/* common/rc greps this error message */
> +		prterr("posix_memalign for hugebuf");
>  		return NULL;
>  	}
>  	memset(buf, '\0', size);
>  	ret = madvise(buf, size, MADV_COLLAPSE);
>  	if (ret) {
> -		prterr("madvise collapse for buf");
> +		/* common/rc greps this error message */
> +		prterr("madvise collapse for hugebuf");
>  		free(buf);
>  		return NULL;
>  	}
> diff --git a/tests/generic/759 b/tests/generic/759
> index a7dec155056abc..49c02214559a55 100755
> --- a/tests/generic/759
> +++ b/tests/generic/759
> @@ -15,9 +15,9 @@ _require_test
>  _require_thp
>  _require_hugepage_fsx
>  
> -run_fsx -N 10000            -l 500000 -h
> -run_fsx -N 10000  -o 8192   -l 500000 -h
> -run_fsx -N 10000  -o 128000 -l 500000 -h
> +_run_hugepage_fsx -N 10000            -l 500000
> +_run_hugepage_fsx -N 10000  -o 8192   -l 500000
> +_run_hugepage_fsx -N 10000  -o 128000 -l 500000
>  
>  status=0
>  exit
> diff --git a/tests/generic/760 b/tests/generic/760
> index 4781a8d1eec4ec..f270636e56a377 100755
> --- a/tests/generic/760
> +++ b/tests/generic/760
> @@ -19,9 +19,9 @@ _require_hugepage_fsx
>  psize=`$here/src/feature -s`
>  bsize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
>  
> -run_fsx -N 10000            -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
> -run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
> -run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
> +_run_hugepage_fsx -N 10000            -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
> +_run_hugepage_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
> +_run_hugepage_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>  
>  status=0
>  exit
> 
> 
