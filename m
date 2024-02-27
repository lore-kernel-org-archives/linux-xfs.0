Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB5DF9CF
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000640; cv=none; b=HFBNNeqQpl2NrklMghkMfg5QYxWB6xxovm2Ho5qbzD46SI/rqz7MwReL9w88iuYMmBNf8Qa2QQmUAGKM9C2mWVcDc5rnKloVSyG1RMfwY/WSeYXRNGjLABgp/feKzg7Ar9E0FoQgXGhSiUm1AbEfwaJDVLRXuRP92WMXQs0QqsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000640; c=relaxed/simple;
	bh=zHPzLlR03ptHKfdwhCF/gAQfjR2EJbg9Vn0r0ZQb9EA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t77EEyXA11Dt6kMKAYXAIDEpjwoteEwkAlBa3+aNWGzpn6QQWq/EIOHQ/rowbV1WDwKmBIdWo5cFAq3ZGPzeZ6vqWX2elqSlgJSppRvY+xNiFpm745TfltcSxIKkxj7zO0geP7aWt+fk9VN0w8vlS6E/+EsJ4OEVDM3bjXOQIIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csfeb5Rs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csfeb5Rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6FFC433F1
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000639;
	bh=zHPzLlR03ptHKfdwhCF/gAQfjR2EJbg9Vn0r0ZQb9EA=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=csfeb5RsczGlHww54wdKmEBjf349XW8F7VGVtAzH2sDudMXpx5vEiDv8di683djE4
	 6WtSnMk/v2mq/fjoOs+Gm1yfv/9jDv+rIXct+1S7c538yOODDLV3ahHA6vjuVl4/II
	 n17tgcXgXjMGOKDnog3r215X3gbx6fk+cHOcsRH2C81kWByx6wsY2zaAoOKczQYrEc
	 oWcJQEiDa3FVzLAsv6+rqEPlzKyZYgHW5G5OPeZmg28BWDcEt/yYJKb1rLm5lk7P4L
	 cXIhuVmdOyWMjSPqIUwe6iL1wdWqgUWP0XTRx7h3sqFD9IsVuEWD3WxPJW2VS0Cn3i
	 dLOafmakyXueg==
Date: Mon, 26 Feb 2024 18:23:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v29.['hch@lst.de'] 11/13] xfs: online repair of
 symbolic links
Message-ID: <20240227022359.GP616564@frogsfrogsfrogs>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 06:18:45PM -0800, Darrick J. Wong wrote:
> Subject: Re: [PATCHSET v29.['hch@lst.de'] 11/13] xfs: online repair of
> symbolic links

Have I ever ranted about how ^^^^^^^^^^^^^^ much I hate duck typing?
And our shitty patchset management tools?

That of course is supposed to be "v29.4".

--D

> Hi all,
> 
> The sole patch in this set adds the ability to repair the target buffer
> of a symbolic link, using the same salvage, rebuild, and swap strategy
> used everywhere else.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-symlink
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-symlink
> ---
> Commits in this patchset:
>  * xfs: online repair of symbolic links
> ---
>  fs/xfs/Makefile                    |    1 
>  fs/xfs/libxfs/xfs_bmap.c           |   11 -
>  fs/xfs/libxfs/xfs_bmap.h           |    6 
>  fs/xfs/libxfs/xfs_symlink_remote.c |    9 -
>  fs/xfs/libxfs/xfs_symlink_remote.h |   22 +-
>  fs/xfs/scrub/repair.h              |    8 +
>  fs/xfs/scrub/scrub.c               |    2 
>  fs/xfs/scrub/symlink.c             |   13 +
>  fs/xfs/scrub/symlink_repair.c      |  491 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/tempfile.c            |    5 
>  fs/xfs/scrub/trace.h               |   46 +++
>  11 files changed, 599 insertions(+), 15 deletions(-)
>  create mode 100644 fs/xfs/scrub/symlink_repair.c
> 
> 
