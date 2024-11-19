Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD761C68BE
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 16:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732032536; cv=none; b=cM3ZX4mNQDQ3gjXzL8uqAB+HgkA2Hy3Xp21khsTIzaE+0l5UyPsVOYGJMnyDofRCDzJcNhcvoxObCAyM0DLRtEUMaAN0sq1A/ibKHFSERZmI3XLxvKNehWtxMygh2FPhFH4myOi9rb4BkVmd6XaMB2xfmrMiqDMJIw0xoGdRwvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732032536; c=relaxed/simple;
	bh=6VKOylrqYG3/gmHFCZqhajrX7DZ5hJ74J3JnrXnI7vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sd9qh9jKp1C1cRRHqJW1mv+X7rNK2yW1qEFStQZVcP8a7EuUE/xEfWZt/upF+lgv8P2Oi0kLUWpYJ1KBY74edjjvqykuAsrt9jNU4OmtaLPrHrmWNYvNXDBBT9FBKArOupVniOdhPxdZZhUNGXbQLLok+nmkHtJTuqaUeoe/beE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSIOGIE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSIOGIE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D04C4CECF;
	Tue, 19 Nov 2024 16:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732032536;
	bh=6VKOylrqYG3/gmHFCZqhajrX7DZ5hJ74J3JnrXnI7vc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WSIOGIE5xWTXtEHUZMx5cYxikeVb9KZRJNKiAbk/R7R98CcgpuqsaQsMFEynuzVgp
	 pdvDWnB5oVfjs0sQ/yrhsckmVVq+KAlTKTn9ZUTiHhTph77Ke9L/K/pyYhXoBRsvnN
	 TyAfG9qWD9BOJ5WtpdfUXI+hAfyePmm0Z5mV4tauomKi1491bHoD0wzVxkZxgBNU+s
	 U78RD9S+PXv3un9vDR46lUpNdwUBRUJoplhTRz3NGapHmjsf05b9LNCDEWKWe0LlBh
	 e3HHm4lCKQQDhoEGGwiJvJ5cS8y53qjxV9qgS0BpchXgG2W9wBxwD0ArhbSFTg3HVW
	 BBCcdfH661N6A==
Date: Tue, 19 Nov 2024 08:08:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_io: add support for atomic write statx fields
Message-ID: <20241119160855.GV9438@frogsfrogsfrogs>
References: <20241118235255.23133-1-catherine.hoang@oracle.com>
 <6657d426-d227-4679-b4ca-db64d39140fb@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6657d426-d227-4679-b4ca-db64d39140fb@oracle.com>

On Tue, Nov 19, 2024 at 02:10:59PM +0000, John Garry wrote:
> On 18/11/2024 23:52, Catherine Hoang wrote:
> >   #include "init.h"
> > @@ -347,6 +351,9 @@ dump_raw_statx(struct statx *stx)
> >   	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
> >   	printf("stat.dev_major = %u\n", stx->stx_dev_major);
> >   	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
> > +	printf("stat.atomic_write_unit_min = %lld\n", (long long)stx->stx_atomic_write_unit_min);
> > +	printf("stat.atomic_write_unit_max = %lld\n", (long long)stx->stx_atomic_write_unit_max);
> > +	printf("stat.atomic_write_segments_max = %lld\n", (long long)stx->stx_atomic_write_segments_max);
> 
> Is there a special reason to do this casting to long long? We only do that
> for u64 values, I think.

Yeah, I don't think it's necessary here because the stx_atomic values
are __u32.  xfsprogs has a tendency to cast to explicit C types to avoid
lint warnings, particularly because 64-bit values are grossly typedef'd
depending on how long long is.

Now that I see it -- those should be %u and casts to unsigned int.

--D

> Thanks,
> John
> 
