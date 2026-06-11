Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DD0347BA9;
	Thu, 11 Jun 2026 15:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781192836; cv=none; b=nKp4h7FMj9LjhocPepyj0CPzwl0PXc74tSsoMVRnTJmPw1fypEKawUsPF4gp816Y+evYwlzBzR/1gajWjqB9sgsCARPoFveQjI6JK3N/Tlhy8Qz4KGvEyYhkRp0YvVzH/xrjJtkHjXTpc8EwbJQfII7PtSOxqcWa6LwWEk8A6lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781192836; c=relaxed/simple;
	bh=8n+BI3OKNYyEQzhY7WJaQAuqUJR8cz2phN56WMbMPjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTVeO7wqv48vW2YV50f5uPSTysp8DxFvRwFk2Otf9jdqv4bpwKsQXzqHD+HjOZlbrRWrqlwSSCclKK76bsujHb2Qxn9jIlIFyFIopMDLEFaJc/9uA3HoKqyMrBshcPhhOUh80ddnH9G5eEm3Ky0r+xrXM8k2xJ3CPY1VKr3m1bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxUMj8Wg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxUMj8Wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8191F00893;
	Thu, 11 Jun 2026 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781192833;
	bh=BQkY18XefNqHuldFMe2cnw1QPjj3SW+tXUJsMH5FJnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OxUMj8Wg/0kU/3/9D/M0S0dPwarM5mvjI3beqGNVZsqtn0EejhgLsRfEIvz19hT8X
	 Io6XXY/3XOj1TJ3oQuozk9TC4DZ989nWw95qo9BKgmnqrcpgbPHmz9FSDSZvfbUvqt
	 qusYoSXSq6cfQqeQIznV8U7/1natL2ILShgNXozAmOY05XdiLTSrpmykluw6rkm85p
	 67QYDpaNT8NpKKw3ktT7WRedmG54dtU9VUsF5iDo+kOR+o/zhtTh5SYaKTlY+KH+y3
	 VGLLLQp/mStYtDSVMP2ewOvFrHTFPMIuGn048dK70NXD2k7HOWIHYJclYPsIJbGGuD
	 x8uCGuZ5HeiDw==
Date: Thu, 11 Jun 2026 17:47:07 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, brauner@kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Hannes Reinecke <hare@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] iomap: enforce DIO alignment check in iomap
Message-ID: <airX6BmMQ14Rvjcb@nidhogg.toxiclabs.cc>
References: <20260610145218.141369-1-cem@kernel.org>
 <20260611055744.GA18538@lst.de>
 <aiqBvF93P4NjfaDR@nidhogg.toxiclabs.cc>
 <aiqwy5DfHI79KXuZ@kbusch-mbp>
 <20260611133833.GA14645@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611133833.GA14645@lst.de>

On Thu, Jun 11, 2026 at 03:38:33PM +0200, Christoph Hellwig wrote:
> On Thu, Jun 11, 2026 at 06:57:47AM -0600, Keith Busch wrote:
> > It's entirely possible a device supports byte aligned addresses. The
> > block layer just doesn't let a driver report that. So either it really
> > was successful because you found a bug that skips the alignment checks,
> > or your device silently corrupted your payload.

I tried this on different hardware, I find it hard to say all those
devices were corrupting the payload.

> > 
> > Anyway, my earlier suggestion should work. Ming thinks it may go to far,
> > though, in not taking the optimization when it was possible. So here's
> > an alternative suggestion that should get things working as expected:
> 
> The fix below looks like it is addressing a real bug.  I'm not sure if
> Carlos is hitting it, but we were missing the alignment checks for
> single-bvec fast path bios so far indeed.

You left context out so I'm assuming by the fix you meant Keith's patch.
I can give it a spin and see if it fixes the behavior I'm talking
about. Give me some time as I have a bunch of stuff to do tonight so
likely I will only manage to try this tomorrow.
