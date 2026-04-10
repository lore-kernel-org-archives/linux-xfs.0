Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217CF238C23;
	Fri, 10 Apr 2026 22:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775859096; cv=none; b=HfdhCcN5Z3YS/FvSJLEfLxuDuJVflNRnIsQ+gIAh8qfPawwua9G3NJZLB7+iuQaBxayZUq2L6eERR55XLwWoDDdmpzjUOfFRylrLug4oY+pjdnuCVB1eChe8cUclOR+681FqI4ShsDG9lhQb5whSIYN1Dxu7deb+7ZC7mO6zDi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775859096; c=relaxed/simple;
	bh=TD1pp2xHcOkkxrulkbwy4Mz16Cdc52MMGL5vPeTdYro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTZsZaDqC25psT5IGIML0GDsvgfXzVinXsuvQPq2KJk+HAMNgvJx7c4bFeQvd5xm7vJE4MVHUViErz0/MU1Yc9LsDHfIngwX6PUYr0icq9qQwWcLVecnlyYcsTbykoiNGjbu4eZ2xcTiJkXPplyoEJ34ACWSTkHs8WzlGEPs1eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0UosEhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0UosEhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95A7C19421;
	Fri, 10 Apr 2026 22:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775859096;
	bh=TD1pp2xHcOkkxrulkbwy4Mz16Cdc52MMGL5vPeTdYro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O0UosEhbQqlCe7BDoVNDV3AAplB6buy82yLtBbVNnnDFVUUmLlktsZGxSpAoXukfp
	 wg1EIi9X11ZYxQzJt+naoFnVDbC8YqcVZc5uyk6Lg4jGRboGTOl0xyYiBcfKSiXrSX
	 i8INWnE/Lr/xlyPLe4tg9PR00Z6MKMbbRAguYJEgxGJMFQDd8umIhR7xsUkrC/ckqI
	 4kCoTEqkNhYcllyJ7ox0GBi8C17YtPK56RfylOTPVuWtaipiKEoorhZeOTt4dHuWi0
	 6QF5oGJStzdnDSv6MuqFkn3Evysc8l/uOygH1vfAc8tuVOPFHMm/bhALTHFkYrjjvC
	 tYHcWc5zFAfGQ==
Date: Sat, 11 Apr 2026 08:11:22 +1000
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <adl1iqhldFvJwSw-@dread>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409160243.1008358-9-hch@lst.de>

On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
> Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
> option") explains why workqueue aren't great for low-latency completion
> handling.  Switch to a per-cpu kthread to handle it instead.  This code
> is based on the erofs code in the above commit, but further simplified
> by directly using a kthread instead of a kthread_work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Can we please not go back to the (bad) old days of individual
subsystems needing their own set of per-cpu kernel tasks just
sitting around idle most of of the time?  The whole point of the
workqueue infrastructure was to get rid of this widely repeated
anti-pattern.

If there's a latency problem with workqueue scheduling, then we
should be fixing that problem rather than working around it in every
subsystem that thinkgs it has a workqueue scheduling latency
issue...

-Dave.

-- 
Dave Chinner
dgc@kernel.org
