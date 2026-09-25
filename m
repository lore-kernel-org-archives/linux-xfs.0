Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1473375F83
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 06:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790318663; cv=none; b=gTxso/UM0yW2KDv1dciyZmoSLS+gFybwTFSEuV/LvJVjhYKsDeCiOOatWv7uoC3fqA1DqAERdKuLzf2b09tsTpDvD2ckVmRGVnC+DMHPWhap6NlGHvqtZxq8eT9sMrqxlQ97WjlP/HxC9LOZIZpD4hb4BTbegww9PeJnSOvrm4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790318663; c=relaxed/simple;
	bh=ZDL1HfNVxbiMqbti4og9R59qDW9u+w06j5ax8qGIoTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjg1YybLZ1QRjsSUQTcfGS2wb8Yn1u0oLUNVhvUtE35ghLHGuhgDUjG1PfcuotYUZQ1Y1C1eAlnKwro5r3+IdYEeH7NO/uiv+CtfVPdM2b4tT+HsFvo9EFlCrIEvPEYLwIr/YMVzkLd7yv84oT0zw4hqDfP5uGrerVZ6SOMt3d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y+Xd5nJP; arc=none smtp.client-ip=91.218.175.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y+Xd5nJP"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZDL1HfNVxbiMqbti4og9R59qDW9u+w06j5ax8qGIoTM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790318657; v=1; x=1790923457;
 b=Y+Xd5nJPJjC/6mfKgFS9pYX0nj+OHPUNS7GxT1zorKQD85UwVZ5rOvaIQeFVdyBhDjX838CU
 rWPTqnqwyYu3cp7STIoxcCSjla9fwM7NFfeneJ/FyyEeDHXty7W4Ufnr++c3XTutOl5XKHicznP
 arlGnfG54UZlnlAeiDTtPJyI=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f84654a804b26889;
	Fri, 25 Sep 2026 06:44:07 +0000
X-Mizu-Trace-ID: f84654a804b26889
X-Migadu-Flow: FLOW_OUT
Date: Fri, 25 Sep 2026 08:43:53 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Joanne Koong <joannelkoong@gmail.com>, Brian Foster <bfoster@redhat.com>, 
	Christoph Hellwig <hch@infradead.org>, Damien Le Moal <dlemoal@kernel.org>, 
	Hannes Reinecke <hare@suse.de>, Daniel Gomez <da.gomez@samsung.com>, 
	Pankaj Raghav <p.raghav@samsung.com>, Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <arYXUaQCgdch5P4s@quentin>
References: <20260924091203.198225-1-parri.andrea@gmail.com>
 <20260924091203.198225-5-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924091203.198225-5-parri.andrea@gmail.com>

On Thu, Sep 24, 2026 at 11:11:54AM +0200, Andrea Parri wrote:
> iomap_dio_bio_iter() falls through to the sub-block tail zeroing when
> the data bio submission fails, so that the rest of the block is still
> zeroed and stale data is not exposed.  The zeroing result was assigned
> to ret, which overwrote the submission error with the successful
> zeroing result (zero) and the failed write was reported as success.
> 
> iomap_dio_zero() can only return an error from a can't-happen
> WARN_ON_ONCE() (nr_vecs exceeding BIO_MAX_VECS, which the existing
> comment there says "shall never be reached" for any in-tree
> filesystem), so it isn't a real runtime failure worth reporting to
> userspace, let alone one worth losing the actual submission error for.

I initially did not have a return value for this function but later I
had to add it based on comments. But I missed the return value being
overwritten.

> Make iomap_dio_zero() return void and drop the error handling at both
> call sites instead of threading the result through a separate
> variable.
> 
> Fixes: 10553a91652d ("iomap: fix iomap_dio_zero() for fs bs > system page size")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---

Looks good except the comment from Christoph regarding the reformatting.

Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

--
Pankaj
