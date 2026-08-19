Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020932253EE;
	Wed, 19 Aug 2026 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787177130; cv=none; b=DABf+rb4EOWpFBuqYVVtiHNsnpYub6gk5i7MEikLEStFVseb6cKk/FOKnaAUNzDHLXGTEJRxObTF+nj/S5DQM0U1VnypyJYMiw5vC1P9XxZmn8tSMuD00e/AJf/k5poZ7eYQ5qlgQgtv3mqDNDszkJAroHkoKBJXIHRXxru9jCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787177130; c=relaxed/simple;
	bh=amlO3pZxDveDsBMyjyke3jbIvSD16eZRY2UnPUqYt+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=USQaJr46KsH0cKOSyqWlhgwD2gufT7hNl4sl2HeAzkZjiB5kC/8S4qKhAaRYLJaXZE3bB/F4BddmWQmA5JDLKrDOsq2wy3eH2tzTjSOoU7wIeVj7jpmLMDps6P9D4s6E1wou/bEXQASe/qEggpemLIaP2YuRd15IQGgmhU+EbKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFkMJNmL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFkMJNmL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7BFA61F000E9;
	Wed, 19 Aug 2026 22:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787177128;
	bh=fge+ShvnwiYT1Doh0GK03BMgG9R/LqtD7hQ0xgGzmzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nFkMJNmLnBT0sjuF8f6Md38Z4k8eTjUYqrHply4/KBJRRtmcjz7ZeWGzjjqhQgnwp
	 +nn399loO9YCgtkpEece5q6CTDBw4lawtjIwnnO6HitR1Z09WLWcbf9MlLGEuaJINu
	 8sIt2kuWi105bzQEpy5b02YxIkFug3MNIaSKYGmj6VjYM4RwvLQUpAL2uJFBXuaf8J
	 NBCd+NjWfw3fivg84HcuddK69Fz9mvqp6vF+WUALzUkH3Rxflzs4atVObGNUR86iPq
	 K6WWLFTdRPmhS9rTbCbhckyIAugE0VRkQ8HUWwH2k+WOu61LbkoPRaXCsI9EWXYonG
	 CxoUGh365lt6g==
Date: Wed, 19 Aug 2026 15:05:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, brauner@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
Message-ID: <20260819220526.GA6072@frogsfrogsfrogs>
References: <20260717125538.508925-1-joshi.k@samsung.com>
 <CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com>
 <20260717125538.508925-2-joshi.k@samsung.com>
 <20260721030338.GU7380@frogsfrogsfrogs>
 <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com>
 <20260730172211.GF3556460@frogsfrogsfrogs>
 <20260819070459.GA1541@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819070459.GA1541@lst.de>

On Wed, Aug 19, 2026 at 09:04:59AM +0200, Christoph Hellwig wrote:
> On Thu, Jul 30, 2026 at 10:22:11AM -0700, Darrick J. Wong wrote:
> > "The third argument is an untyped pointer to memory.  It's traditionally
> > char  *argp (from the days before void * was valid C), and will be so
> > named for this discussion."
> 
> That documentation is wrong or at least very incomplete.  A pointer
> is the typical use, but there are plenty of ioctls passing scalar
> values <= sizeof(long), going all the way back to early UNIX days.
> 
> > You can also see this reflected in the discussion of the R/W/WR variants
> > of _IO:
> > https://docs.kernel.org/driver-api/ioctl.html
> 
> _IO* are optional helpers, and plenty especially older ioctls are
> defined without using them.

Well, yeah, we don't force anyone to use the _IOR/_IOW/_IOWR helpers.
But since they were used here, I thought it worth pointing out.

> > Granted your kernel code can treat that argp as an integer and not a
> > __user pointer if it wants to, but that goes against most ioctl
> > implementations.  Further, subsystems that marshal ioctl information for
> > passing through to another layer (e.g. fuse) assume that the third
> > argument is a pointer and that it can copy sizeof(data_type) bytes at
> > that address in and out of the kernel as part of marshalling.
> 
> That is not a good assumption and things will break.

I know; fuse is a total mess w.r.t. ioctl handling because it assumes
that it can just go ahead and do the userspace accesses.

--D
