Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D402040A7
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 07:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747206306; cv=none; b=lDBCCCjj9kQNMsP/GwR2GGJr3DVbshcUPi8WbGDvai/46lLjBSqllxDdOc7LU5Mj1G9QuOZ+GOK1evgNj8lhQ6ff7tP3cKG3o3Js7Jx66lt8+3LQ9ICVa/XAx4z5Lu4Mu9h2xywBw42SavqRN+r5O9ct35ftjVJHBZcNT34FypU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747206306; c=relaxed/simple;
	bh=SJs8QI7hQoh4Blo4o+UvxSj6AHFhU1cQGX01MjWE/Hc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=niFHvRvAV3EfGtc48WjXe144XNOAPNxHCFNDOya4L2TGE1R2e8LfGkUM7/pH743arSfo9IDpAfSuAxAG7AcI+CSwsEgFo7FBA3JdUwQH4e1n4p9Ra4vQIxL+xp+HsPncfZyA3IfemCfqDNzkZtEabtHziCfcrtYDST46MEoY+Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Woo7X10N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Woo7X10N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F81C4CEE9;
	Wed, 14 May 2025 07:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747206306;
	bh=SJs8QI7hQoh4Blo4o+UvxSj6AHFhU1cQGX01MjWE/Hc=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=Woo7X10NrGKHGCbm73A5ycqm51/JI6in6sJiJvQk2Jf1ABZUhbiuVcwcb6heHsLMY
	 eQatyDls5q4oyaIUKChC+v7hoQFkjt2rSn5WMa8XeMOfzIuU7nSgvFvNRRdUthrSkx
	 XOFswATaWf4r6Q9Oy2NZxX3iFUYEIKx4d/PyYDBONEn9r8XI/s3V1WlKqHJAnGjjpx
	 wNJl9d1kI+5d0t43BKfX9+qnZmYp0DDaBeW9sZ9D+W2O3sb12fGuheWHvGtH0Ex3P6
	 X5EULN722v7zsv+JJ+g8lhBbtQNuP47SdN8mMreWwI2H/oF+ypN4TAL25ECvbX3YoQ
	 p56LuBF91pEDg==
Date: Wed, 14 May 2025 09:05:02 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove some EXPERIMENTAL warnings
Message-ID: <pxv7txag5wcawp7plx4xx2bsk4zbnwqlunwxh3iibmqqyzrmup@h57svji66bfp>
References: <20250510155301.GC2701446@frogsfrogsfrogs>
 <zo1vUdywCBc0xbggXW25t2SqwgxCk5PunFNw8srIeOHPBBfYX7T9oKD-KoiRn-xvIz4IFuPM7SCreFZMlmOgKA==@protonmail.internalid>
 <174715788805.709704.13710865404538859491.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174715788805.709704.13710865404538859491.b4-ty@kernel.org>

On Tue, May 13, 2025 at 07:38:08PM +0200, Carlos Maiolino wrote:
> On Sat, 10 May 2025 08:53:01 -0700, Darrick J. Wong wrote:
> > Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
> > syscall and parent pointers were merged in the same cycle.  None of
> > these have encountered any serious errors in the year that they've been
> > in the kernel (or the many many years they've been under development) so
> > let's drop the shouty warnings.
> >
> >
> > [...]
> 
> Applied to for-next, thanks!
> 
> [1/1] xfs: remove some EXPERIMENTAL warnings
>       (no commit info)
> 

My apologies Darrick, this message was triggered by accident. I didn't
merge it yet. You'll see this patch is not in the ANNOUNCE email.


> Best regards,
> --
> Carlos Maiolino <cem@kernel.org>
> 
> 
