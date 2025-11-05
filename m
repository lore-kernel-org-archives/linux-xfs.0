Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632C229AB07;
	Wed,  5 Nov 2025 19:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762370289; cv=none; b=d3TaoSIrRpemGcFs2xMrSzAlqZRsCIjD8UWBWQ7EwlYRNmRaWsB4a+NLtBYrouLVSZEtxPJNEi3lrEdo4SzwToeXNHig7upRrU1gBMb3TDsa9ic2E5tRoF77NwxUcxfuMraWTn7PF/eZUtWFm7fZCHrj7yOWG0dQjqdVEiz23ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762370289; c=relaxed/simple;
	bh=1+78QoswS4tWs2fyiqtyl1HNyIo4mYia2EXKBRVDsy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Un0r+r7GyvlhlcNpfjdP36f0B8WkCwg+xSKHPeWIJL6UOuZU9hh+gnqoNsWEVSc48Lov2Zx6S8OFxLqlSUZnhJ0ImCJDcZbZrdd2AFtcAJaE06nA9fRacXYi3xhhCsKf5o8swbpNd5lgnNuohf6xg3gEcn8ycL7arDjC+1R+SuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eO+ZQr65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eO+ZQr65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8CCC4CEF5;
	Wed,  5 Nov 2025 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762370288;
	bh=1+78QoswS4tWs2fyiqtyl1HNyIo4mYia2EXKBRVDsy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eO+ZQr65hUF5ZprZm/0lkOHgQIrwWmyYy6UxaSz7moO4VkYXEwsp1g8mwap5B61M8
	 8wVMZVubrr7J1FLmIVOoIGhmgkxMKp5+TFwNYH+yTS0ct+FgACAWeS79zu2ye0q6RR
	 XCdIoyZ+L78BGmmYLVSGKT97MwFBLW8ByAYkUtpIvHro7dSQ8wcBue3ltMDnuwzGL5
	 2zv/aCAhxhaEzLyFy2C77tWmnVueYWjYD9xSJDA81a9O3B73/vvcL9Jy3UZSErBvyE
	 a2oF6ARgCCDhabDzK9+1ZMtMwrZZOPMrjngRYaY9f+te4qWd0BHVS6aLbKDlSPfcdh
	 ixn08kz17oZdQ==
Date: Wed, 5 Nov 2025 11:18:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix various problems in
 xfs_atomic_write_cow_iomap_begin
Message-ID: <20251105191806.GE196370@frogsfrogsfrogs>
References: <20251103174024.GB196370@frogsfrogsfrogs>
 <20251103174400.GC196370@frogsfrogsfrogs>
 <02174386-c930-419e-9ad2-2ae265235d6d@oracle.com>
 <20251104171801.GL196370@frogsfrogsfrogs>
 <e5fa77c8-5293-47be-9f66-addcf458529d@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5fa77c8-5293-47be-9f66-addcf458529d@oracle.com>

On Wed, Nov 05, 2025 at 12:21:15PM +0000, John Garry wrote:
> On 04/11/2025 17:18, Darrick J. Wong wrote:
> > > Can you point out that code? I wonder if we should be rejecting anything
> > > which goes over s_maxbytes for RWF_ATOMIC.
> > generic_write_check_limits:
> > https://urldefense.com/v3/__https://elixir.bootlin.com/linux/v6.17.7/
> > source/fs/read_write.c*L1709__;Iw!!ACWV5N9M2RV99hQ!M- J1QmUWrGHUBb6gf9LHN33HxhBfk3rHcNR5z_glUHClffIPQ5UFQ1zmHpsetFGz3_3lHzUrwyAASD_90A$
> > 
> > xfs_file_dio_write_atomic -> xfs_file_write_checks ->
> > generic_write_checks -> generic_write_checks_count ->
> > generic_write_check_limits
> 
> ok, thanks for the pointer.
> 
> So should we stop any possible truncation for RWF_ATOMIC, like:
> 
> +++ b/fs/xfs/xfs_file.c
> @@ -440,6 +440,9 @@ xfs_file_write_checks(
>        if (error <= 0)
>                return error;
> 
> +       if (error != count && iocb->ki_flags & IOCB_ATOMIC)
> +               return -EINVAL;
> +
>        if (iocb->ki_flags & IOCB_NOWAIT) {
>                error = break_layout(inode, false);
>                if (error == -EWOULDBLOCK)
> 
> 
> Note that I do realize that this may be better in generic fs code.

Yeah, I think that'd be better placed in generic_write_checks_count if
_limit() changes &count.

--D

> Thanks,
> John
> 
