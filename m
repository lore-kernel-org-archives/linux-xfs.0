Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918FA1A8F98
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 23:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734131568; cv=none; b=WUZ/af1VR7pqtr1vn50Ri6ksrHmuu6awpWAWuaN7Y7MPrMf5CGCx6EoZPjcsTDnHxiuQmBA1LJUO+uqYD3IYuwwZPKeKf8julDvbUgJ+IsFHSrqhhsak2L1rjnuKu0WLWiF0a/k9iBVx88qeYLCWJG2Cb3aaurTPVC4LbhuMdW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734131568; c=relaxed/simple;
	bh=eQkqt2ZsHknXuZowyDAb2O8A3un380YyC9U77U5qTmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SmXgAIKD/Q0y4KwWmlkjWIWWvvADf7Q+q6wIcy6QR6ypXkFlyw3vvjnmnZ+ij9GJNDNteGJqGdynz7s2ve/Q5xWesqyIa/uJC9sHn5amf5mcauhIl4Mi9HhMhrlFkuxMw1sAJUzcO5rOBP/IDWPARIz4fu4iy4/PTFN9r5Q0lDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZRz01p7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZRz01p7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A066C4CED0;
	Fri, 13 Dec 2024 23:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734131568;
	bh=eQkqt2ZsHknXuZowyDAb2O8A3un380YyC9U77U5qTmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MZRz01p79WRS9n220X/mpDnVyRJNHWpreWmglQfnltlKt7qQqRhUJcbaA9BzOgcfy
	 MxAOHGKDOeDiRIUIPJKdqtXs108ensGFJd2i+5JRsbjObbRn2740Stfa9XCIXJzjPv
	 vp8QJczKSoTzf5WbIyPYANKtqw4299CtQsXVLPK7SUwH2tc1+mr9derPgj7WmyKYNb
	 bWwMcYIOBbyFr4x7XZV7mr+O/PP7dRp8GYiprokv3+JPfkY20S98qUpIExHljoQ2Ku
	 xdKMbuS1ra+sJb5cVYuYfDq1GbzncGwwhSm1r5gyK/ds6h7E/J5qMyxy4em1Dht2ou
	 9WEf6c8w+lgiQ==
Date: Fri, 13 Dec 2024 15:12:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/43] xfs: disable reflink for zoned file systems
Message-ID: <20241213231247.GG6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-37-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-37-hch@lst.de>

On Wed, Dec 11, 2024 at 09:55:01AM +0100, Christoph Hellwig wrote:
> While the zoned on-disk format supports reflinks, the GC code currently
> always unshares reflinks when moving blocks to new zones, thus making the
> feature unusuable.  Disable reflinks until the GC code is refcount aware.

This goes back to the question I had in the gc patch -- can we let
userspace do its own reflink-aware freespace copygc, and only use the
in-kernel gc if userspace doesn't respond fast enough?  I imagine
someone will want to share used blocks on zoned storage at some point.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 59998aac7ed7..690bb068a23a 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1818,6 +1818,13 @@ xfs_fs_fill_super(
>  			goto out_filestream_unmount;
>  		}
>  
> +		if (xfs_has_zoned(mp)) {
> +			xfs_alert(mp,
> +	"reflink not compatible with zoned RT device!");
> +			error = -EINVAL;
> +			goto out_filestream_unmount;
> +		}
> +
>  		/*
>  		 * always-cow mode is not supported on filesystems with rt
>  		 * extent sizes larger than a single block because we'd have
> -- 
> 2.45.2
> 
> 
