Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71D429BDB5;
	Tue, 29 Sep 2026 01:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645560; cv=none; b=Du9Uhrarnkl2OxBKR5/oBLs7AeNUtPgC1nk3CP8YpGKr8lwyTNpH4M1m4k9sOIPdtVPpCa7pW0uyTcDNjUIxvUv8wFWriS9SKe2gl2wHgnNyVQ8f9x5blAtUMmAa1XBwWOgd6ku0M+Ky2+oNJDJPaBnUOVU6DUkPZJUijrvV/0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645560; c=relaxed/simple;
	bh=N4BnDq9LyfG2Iw2iCUVVeHXe2q9y6LnNtAzqjtjb/xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJH+IwN97nW8wC7vdFL2Rm1eKCUYwJ8XSn7G2HFYMByATVc3lijckWxL0HM9EWWnhZEy77SZ1cfivszWpNZTmZwznM/K2mi0ggYz4GURZ+ExX0OCvYwZ9A4v+8WLa3CT9wdN5QOlNBfwutL7/YxNcOE2scWtKoVUWwkZlpRxH8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ibr4JFay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ibr4JFay"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3B7941F000FF;
	Tue, 29 Sep 2026 01:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790645559;
	bh=51PryqVQmuQDE0P3Ma8YEPU91aIGt7VX2fQ7IiAn5qM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ibr4JFayw/YpsYj+goTi8JeFtx2hPYuhdhFwKaR9GlpSs4jMmKTD+aW+GPgP+JtbI
	 e+ZN2feW0HdApN702RMG1axjBd8mYHT7T10Yl4GbGh9vb00D6gj8ddsYKr7qLyc1tK
	 MpDKz3WGickOi4OqJouH5U4YwPYFuV+KKpWkQcmCbQHKNo5t5wiFewYxiudQ4SIp3I
	 A59dJcXV8JBbfMZSOxka2VK6YQz8dW/gK31riqIUIrMgE9pNjUtXtow+dXJfDWCTys
	 +zGdbNa1sXyQGVXzR8I4rsBrhQd1F2xr9ZgWkkJOmdWhF81XZaA3f8Mon07SRdEdsT
	 JAIxaetj3STbw==
Date: Mon, 28 Sep 2026 18:32:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] common: add a SCRATCH_MKFS_OPTIONS variable
Message-ID: <20260929013238.GE2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-3-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:43PM +0200, Christoph Hellwig wrote:
> Add a new SCRATCH_MKFS_OPTIONS variable, which contains options that are
> only applied to the actualy scratch device, but not to various other
> devices like scsi_debug or loop devices created by various test.
> 
> This is important to support mkfs options that do not work on arbitrary
> devices, like the extended LBA based data checksum support.

Er... what is "extended LBA based data checskum support"?  T10PI?

The addition itself seems reasonable, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  README    | 2 ++
>  common/rc | 4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/README b/README
> index 8644f163b1ab..cc03f51e1ad3 100644
> --- a/README
> +++ b/README
> @@ -303,6 +303,8 @@ Extra SCRATCH device specifications:
>   - Set SCRATCH_LOGDEV to "device for scratch-fs external log"
>   - Set SCRATCH_RTDEV to "device for scratch-fs realtime data"
>   - If SCRATCH_LOGDEV and/or SCRATCH_RTDEV, the USE_EXTERNAL environment
> + - Set SCRARCH_MKFS_OPTIONS if you want to specify additional mkfs options
> +   to be used when creating file system on SCRATCH_DEV.
>  
>  Tape device specification for xfsdump testing:
>   - Set TAPE_DEV to "tape device for testing xfsdump".
> diff --git a/common/rc b/common/rc
> index 3958ac934980..7fc5ff956959 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -805,12 +805,14 @@ _scratch_do_mkfs()
>  	local mkfs_filter=$2
>  	shift 2
>  	local extra_mkfs_options=$*
> +	local mkfs_options
>  	local mkfs_status
>  	local tmp=`mktemp -u`
>  
>  	# save mkfs output in case conflict means we need to run again.
>  	# only the output for the mkfs that applies should be shown
> -	eval "$mkfs_cmd $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV" \
> +	mkfs_options="$MKFS_OPTIONS $SCRATCH_MKFS_OPTIONS $extra_mkfs_options"
> +	eval "$mkfs_cmd $mkfs_options $SCRATCH_DEV" \
>  		2>$tmp.mkfserr 1>$tmp.mkfsstd
>  	mkfs_status=$?
>  
> -- 
> 2.53.0
> 
> 
