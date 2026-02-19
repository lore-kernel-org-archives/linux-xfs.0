Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DBE2EA480;
	Thu, 19 Feb 2026 06:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481703; cv=none; b=ihdQLdGmvnFtqj2BseykvXmLl17IxEBYYlVG1N8n8oWe0L5A79NEfTTWmVZGcwKu4TfZxsUYoui9TWR/adGnr2jwu2R13Hj5SIj38I/FyMhiERH6ymjUZgoCIehIyoNBmYnBVit2nvTlp85gGLfTXZ3fxdvcB5B9P17rvnHh60w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481703; c=relaxed/simple;
	bh=YHOM66lzoRUwmE4qMaRR3bRGMxJJ74seep+VqmXIRF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kqo5mLf+P+OyHMDcdOwAsXwt33UEEuCTqJGkdZddnDuX6+gMMWEd6m6QBjywaVI65iskctpf8nRNBqUJb4OH/7pVQWXAkLRvuBPN/5HVvIm52VGd0ICJst8esOZvo8JwJ8LSWqSsTRnUe7gEdPKzMb1dgzfOXC9zBvVIHRT5YYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kEBkUbZ1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kEBkUbZ1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kjEUyrIdtoSVK8/ToumRhv0Uezf2o1ihI+CRhD6nx/4=; b=kEBkUbZ1sa/DlTE2krJ0fBQEES
	+PBADcrAuFuIlklPPwf7ITh6R6re6hhKMsdRpjMjD97eIvJjACmyfIQY+GkBLZh0Bpf/buqCw38SC
	YtnhQLO4aSwNK9oxzQPjTtT6kFb1fNGxv3R0kOkdOrON+2Kb3gHTW1SVpgquD1hV9bTwpCHmGI/V6
	yamiKGnfy8RkyWfYpXPtwoXzGZsMwWecuXld/G3gbP0mMQni3RKc9S5asGiDM0uAyMXtituYRYotZ
	b0mgBugwVCTjmLvE4532hLuoJ10C34JC1ZGcJG4cFLavxbyMp3Xm3lHE5yHsjihwCVJQkZQhkmjnR
	A6sTKJNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxJV-0000000AwtX-43a7;
	Thu, 19 Feb 2026 06:15:01 +0000
Date: Wed, 18 Feb 2026 22:15:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	david@fromorbit.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, nirjhar.roy.lists@gmail.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC v1 2/4] xfs: Introduce xfs_rtginodes_ensure_all()
Message-ID: <aZaqZSUKUJDpuVQK@infradead.org>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
 <38947e4ca2d01828e7e7033f115770efe6ac9651.1771418537.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38947e4ca2d01828e7e7033f115770efe6ac9651.1771418537.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +int
> +xfs_rtginodes_ensure_all(struct xfs_rtgroup *rtg)

Please use the usual XFS function definition style.

> +{
> +	int	i = 0;

The for loop already does this.

> +	int	error = 0;
> +
> +	ASSERT(rtg);

The assert isn't needed.

> +
> +	for (i = 0; i < XFS_RTGI_MAX; i++) {
> +		error = xfs_rtginode_ensure(rtg, i);
> +		if (error)
> +			break;
> +	}
> +	return error;

Just return the error directly from the loop and 0 if you make it
through, then there is no need for the error initialization at the
top either.
