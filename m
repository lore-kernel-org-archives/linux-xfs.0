Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701868F61;
	Wed, 13 Mar 2024 01:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710292944; cv=none; b=QsXzh76Vcb1Y8bJmUEJynLcQijwzVwDnjmrk39A9ti/cak/OjFsGLwuvJvopzD4/QS4vlsFxzc7w6/ymufIVhm28y06ZyPuexiqmZAk0xV8Xjr+LEx1bCclgtud5mhPWvjIcSl32WnmgreyOas7V0rOmzrkdPMMVvJrYLkFP9rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710292944; c=relaxed/simple;
	bh=JlmuhNeUDrHfxxJ1OWk+7v8iRRq4ZgLmMbMW8wQDwGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPlAuURn9Dc6C+uXKGtNb0ykrmXLt8xa/OwMUhIo0CdYn0yo7JPK+1F3RWPQj81ogGQQ+tYZ4yGt5w563O4OX1yd5rLSgE6dajb5HTWBQApfaS5oMvvh3szwhYShoxpc4nl0x9th2r2OkqjDsBK/pnVZuskCzZxc8Hv0l9t4tuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgjPCThQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgjPCThQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AAFC433F1;
	Wed, 13 Mar 2024 01:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710292944;
	bh=JlmuhNeUDrHfxxJ1OWk+7v8iRRq4ZgLmMbMW8wQDwGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RgjPCThQBRw8D1yCqIGRLyzTEY0qtxOVaN23a52vZpgnpW9cQgYp+02mKnNcV94zO
	 InJNw3M4fZL688D0Y1Em0+it2SU0Ky+kUayWvy/XYLVW6EIL9ZNL9GKiOLdYAVItHe
	 orztd9HGwO0U5c95EeEC5Wm+gq1hl4d6nqOjEkOTfyZ+11+yi1Sqp6uexNPcyRwoyY
	 Yuo2AAEubMIxeyjSWrsqNiLp9EEBLJCWnKxjgYtjsWbUbUW0znRvuN9kz56xwLWfAM
	 /mDdkwos+OZbRHBvmHLU9ELNNvfD/DfwZFRrs1qcPEURJWxT+a4OaFY2rfVH2iLeCP
	 uOM2dUqiyCgjg==
Date: Tue, 12 Mar 2024 19:22:21 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] block: move discard checks into the ioctl handler
Message-ID: <ZfD_zdhQpctxbGeg@kbusch-mbp>
References: <20240312144532.1044427-1-hch@lst.de>
 <20240312144532.1044427-2-hch@lst.de>
 <ZfDTZpuumZSn6oPp@kbusch-mbp.mynextlight.net>
 <20240312223131.GA8115@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312223131.GA8115@lst.de>

On Tue, Mar 12, 2024 at 11:31:31PM +0100, Christoph Hellwig wrote:
> On Tue, Mar 12, 2024 at 04:12:54PM -0600, Keith Busch wrote:
> > > +	if (!nr_sects)
> > >  		return -EINVAL;
> > > +	if ((sector | nr_sects) & bs_mask)
> > >  		return -EINVAL;
> > > -
> > >  	if (start + len > bdev_nr_bytes(bdev))
> > >  		return -EINVAL;
> > 
> > Maybe you want to shift lower bytes out of consideration, but it is
> > different, right? For example, if I call this ioctl with start=5 and
> > len=555, it would return EINVAL, but your change would let it succeed
> > the same as if start=0, len=512.
> 
> We did the same before, just down in __blkdev_issue_discard instead of
> in the ioctl handler.

Here's an example program demonstrating the difference:

discard-test.c:
---
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <linux/fs.h>
#include <sys/ioctl.h>

int main(int argc, char **argv)
{
	uint64_t range[2];
	int fd;

	if (argc < 2)
	        return -1;

	fd = open(argv[1], O_RDWR);
	if (fd < 0)
	        return fd;

	range[0] = 5;
	range[1] = 555;
	ioctl(fd, BLKDISCARD, &range);
	perror("BLKDISCARD");

	return 0;
}
--

Before:

 # ./discard-test /dev/nvme0n1
 BLKDISCARD: Invalid argument

After:

 # ./discard-test /dev/nvme0n1
 BLKDISCARD: Success
