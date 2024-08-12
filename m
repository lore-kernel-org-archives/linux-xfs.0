Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A595D14C5A4;
	Mon, 12 Aug 2024 14:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723473616; cv=none; b=AkC9yCmr+4VwXOjXT+ooYdc5hVB7rFwioWIcbEB22cuP4qvTS4rGTerbIisn18qJtSDqUd0+0KJ1Uji0+O3kGPu2p1WJzNOeky4wmb22uGi27YDMMvA52ZynveDWBb4twpLbJPbZgWRMxaYaJrB3LXB1KaHnbMElbl5qT1MbwOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723473616; c=relaxed/simple;
	bh=WsXKvHOFF9lMM9NY1WrmXM2J8dm0GrqnAg/049yrL4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XpPPJTwGSOWzfzTqccM8/rF9Pdy3yDgLTys7wwJZHwEZWL+tTz/OOzRkcHJOQimQo9oVZ6aarseSPhCucNaK2NSmWsqLLqBtgKWv7JQgsEEundILElhl2rAUXH9cEj3RoRabEqyuqcNEIb0/Cd1hWp9C9clfjoL8P9g+RkA2q9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmdmMk68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmdmMk68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5246C32782;
	Mon, 12 Aug 2024 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723473616;
	bh=WsXKvHOFF9lMM9NY1WrmXM2J8dm0GrqnAg/049yrL4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zmdmMk68l8jPq4BIXddoL80/+F1Nzq+IG0ybaJ2XFKcpgkF84ChoNu1UvU/8uHiQX
	 fXSdEY7jEmPnLGYI9XAQOHmTwB3kuNX+sLyJs5zd5bwUNS5fLFPQZWxT4lNGkYEop1
	 hHmHsCbHqPV1xEbZJ5Q6FgRssW1F0FkvEdijOZUg=
Date: Mon, 12 Aug 2024 16:40:13 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Abhinav Jain <jain.abhinav177@gmail.com>
Cc: leah.rumancik@gmail.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	syzbot+55fb1b7d909494fd520d@syzkaller.appspotmail.com
Subject: Re: [PATCH 6.1.y] xfs: remove WARN when dquot cache insertion fails
Message-ID: <2024081244-emit-starlit-dd23@gregkh>
References: <20240809015640.590433-1-jain.abhinav177@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809015640.590433-1-jain.abhinav177@gmail.com>

On Fri, Aug 09, 2024 at 07:26:40AM +0530, Abhinav Jain wrote:
> commit 4b827b3f305d ("xfs: remove WARN when dquot cache insertion fails")
> 
> Disk quota cache insertion failure doesn't require this warning as
> the system can still manage and track disk quotas without caching the
> dquot object into memory. The failure doesn't imply any data loss or
> corruption.
> 
> Therefore, the WARN_ON in xfs_qm_dqget_cache_insert function is aggressive
> and causes bot noise. I have confirmed there are no conflicts and also
> tested the using the C repro from syzkaller:
> https://syzkaller.appspot.com/text?tag=ReproC&x=15406772280000
> 
> Please do let me know if I missed out on anything as it's my first
> backport patch.

You lost all of the ownership and original signed-off-by attributes for
the commit :(

Please work with the xfs developers if they wish to see this backported
or not, that's up to them.

thanks,

greg k-h
