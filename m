Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A256F125AC;
	Tue, 13 Aug 2024 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560212; cv=none; b=ENAXA+DBW2gCP1OzFb/wtyUBsJh3+1GmolNM27HCYFdFH0AWFMUmqNXjgyBJaqUrFVqGbI4THpjp/BUUJ0Js+BxSRV1SjvXOI3v9La95tmMPlNIwM5e/RKKDMmNTgsg5XiQcDcsm7qbExzcN6xkgltvTX6YAr8VFb+8I6ak+Iy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560212; c=relaxed/simple;
	bh=6a/Br9Ne9hWU7U5UL8rs5FCK8KcllVzCnNIIoMqt7Ok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1p2IqIeplg+JSbvSa/nKd6BRKHmMKmM3idngfflmtIE2zIAxjoZWM/BIGuG39qppBODEIT4H+iqLPQHR70HXvSPyjHe09XKM8dEJiK85OcBIqTI1mvSzhlLINFS9OPD7WgLpxtc0eoPvHJ5emr++ok/a8hkWOdLtIzzFi8EHaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPzBRiIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPzBRiIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F33AC4AF09;
	Tue, 13 Aug 2024 14:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560212;
	bh=6a/Br9Ne9hWU7U5UL8rs5FCK8KcllVzCnNIIoMqt7Ok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aPzBRiIEyzHtu0azK00L+itYH+yQudy/j0TKxSRVkuPpNIZOLBb1cxqqN+Dbopf6g
	 W1D8Pv+XAVLkaIANqxo5hq9i61pZX4mQl+cLVK60Y4j1zMkeM6HbqZv67iNohv1JHG
	 C9KUfUibpbvFvbBi00qaE20TuCk2btfgRwREsQMMMV15OxNfHdQJHVCZZIluoocwha
	 krpGs0VXyddlZ/BeEQ+jRKiyhPpieQMT++VTVsCBn4E1l/GZDLe1qg8cZ++qgeGwtt
	 UgLJ//1aKY5jAddYV7uLeaFP31yiZoCI+5+tM1nyFJyRy/yoV7pJlHqp/Vu/1yYXsm
	 TU//L/wUhCZhA==
Date: Tue, 13 Aug 2024 07:43:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] generic: don't use _min_dio_alignment without a
 device argument
Message-ID: <20240813144331.GF6047@frogsfrogsfrogs>
References: <20240813073527.81072-1-hch@lst.de>
 <20240813073527.81072-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813073527.81072-5-hch@lst.de>

On Tue, Aug 13, 2024 at 09:35:03AM +0200, Christoph Hellwig wrote:
> Replace calls to _min_dio_alignment that do not provide a device to
> check with calls to the feature utility to query the page size, as that
> is what these calls actually do.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/521 | 2 +-
>  tests/generic/617 | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/521 b/tests/generic/521
> index 24eab8342..5f3aac570 100755
> --- a/tests/generic/521
> +++ b/tests/generic/521
> @@ -22,7 +22,7 @@ nr_ops=$((1000000 * TIME_FACTOR))
>  op_sz=$((128000 * LOAD_FACTOR))
>  file_sz=$((600000 * LOAD_FACTOR))
>  fsx_file=$TEST_DIR/fsx.$seq
> -min_dio_sz=$(_min_dio_alignment)
> +min_dio_sz=$($here/src/feature -s)

Or maybe _get_page_size() ?

Don't really care either way so:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  fsx_args=(-q)
>  fsx_args+=(-N $nr_ops)
> diff --git a/tests/generic/617 b/tests/generic/617
> index eb50a2da3..297d75538 100755
> --- a/tests/generic/617
> +++ b/tests/generic/617
> @@ -24,7 +24,7 @@ nr_ops=$((20000 * TIME_FACTOR))
>  op_sz=$((128000 * LOAD_FACTOR))
>  file_sz=$((600000 * LOAD_FACTOR))
>  fsx_file=$TEST_DIR/fsx.$seq
> -min_dio_sz=$(_min_dio_alignment)
> +min_dio_sz=$($here/src/feature -s)
>  
>  fsx_args=(-S 0)
>  fsx_args+=(-U)
> -- 
> 2.43.0
> 
> 
