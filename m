Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109B919E97B;
	Wed, 15 Apr 2026 05:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776232121; cv=none; b=O5GODJBscWH6yaDGyHnlLgFSpgI5QjK9qA/PJqGCc2FwnnslcWl+OeqGpIltTA9A0mRxYF3DZZLe4War150SDbiQWI4rvxZ2+Agw7aoWuW8DgV3bFwgoUPmSve2xYWvjcQIWW9+m8mlz0wxaPbFehX8jy2m296nETVxxFYV44js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776232121; c=relaxed/simple;
	bh=+KHUHZyzR3XN259Ry1p+AAhF1X4eGcETqILKfuLsv0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iyompai4pVSeoPyO2DuqNvqVWfYSEJSKVs5kpTEI5i9HEUx8xUmx40LS+29MFJAjrqd/gL7h6tVO0BI0ol7sWtyoMFKbaNV8HuqJIJzOaXbL1D1Ns3VFus5ZngcEwmTg0tpsf3ZSb5fb5KWEd9FtNOEOqAnLEBQ0kDOjyqtQLhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2195F68BFE; Wed, 15 Apr 2026 07:48:36 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:48:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
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
Message-ID: <20260415054835.GB26893@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adl1iqhldFvJwSw-@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Apr 11, 2026 at 08:11:22AM +1000, Dave Chinner wrote:
> Can we please not go back to the (bad) old days of individual
> subsystems needing their own set of per-cpu kernel tasks just
> sitting around idle most of of the time?  The whole point of the
> workqueue infrastructure was to get rid of this widely repeated
> anti-pattern.
> 
> If there's a latency problem with workqueue scheduling, then we
> should be fixing that problem rather than working around it in every
> subsystem that thinkgs it has a workqueue scheduling latency
> issue...

Fixing the workqueue scheduling would be nice, but the attempts so far
failed.

In addition to that for a lot of theses cases workqueues are actually a
surprisingly bad fit - we have items we want to queue up an one single
function to call on all of them.  So the overhead should be a list item
(which often can be singly linked) in the object, while the workqueue
also adds flags and a function pointer, bloating the size. We often work
around this by having a single work_struct work on multiple objects, but
that just increases the amount of work that needs to be done, including
atomics and scheduling.

Last but not least bio completion isn't really any random subsystem.
Block I/O completion is important enough that we have an even more
epensive softirq allocated to it.  I agree that the dynamic
workqueue-style workers are a much better choise for most use cases,
though.
