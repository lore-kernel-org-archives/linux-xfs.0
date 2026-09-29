Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252752BEFEB;
	Tue, 29 Sep 2026 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645663; cv=none; b=FcOdKBqTSxP9iwwzYz/DaJs5o9C/SC0RvG5hsNiO92vtPpkcIgE669p2if3j6bfek1jICSWOIi7W+steAuIjT90hntKk3gpmy/GMGyKEJfLzeb3dBbUZrO5dcz5YSG42tl0sEjer2y71rNsTYrXVu0nRwiCIwrlhOFJHA+xc/FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645663; c=relaxed/simple;
	bh=mpYQ48TAYxLSGmY7bqb5KNDS9lKUKrkeowffIUNkdUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDzEMubSCG3aMFwK4cgAjhpDSv4y7R1MnZe6ax/gI7Wxy9INAGMvPiBjGgtyLYHPj8D6TrpKGj6gNLckViFenv68KJgq7LT5whSn06jrUbnwVzdhLLq/GlCf7/YqXHJeS2oq5m8SAs5OHic6vcVx6eAANfVLtfLcqraPiycFBts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUnybuSJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUnybuSJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D6FE1F000FF;
	Tue, 29 Sep 2026 01:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790645661;
	bh=kRnK76W51H6N94gTBFtBnGKnMJ5QZdh9RaRMs6u3Baw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gUnybuSJ/aJ43Sk/qti9pmXJdxVXtHIN8M4kr8MpcvWd+tVn+pbLMdauW+HccM1tS
	 1mGTMuIgH1KjUVuQsqMV/2n5FlhXVRtTNBZKV+V/oB/JZDkErPfqoTP6hO/4Gte+NG
	 j2YVGI1A0nk+beb/wHtP4qedb6zdim2indogjIHzqiQvW6ORRYc+v8e6IHdw6ZeEe7
	 ZTtodPCXNzdgZRr8+hWzEk7HVeWGikQFRcPgTGXyAUzi05dpdPsqqAlAcXzuWruPUl
	 bSAYQFB1iOvoHMbCUkr6a2s2Eo+442xRpEUVAvPTwCJ8inSmlMzX4aLjnPhgJVT/7Z
	 whc30C2wmUDRQ==
Date: Mon, 28 Sep 2026 18:34:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: add a XFS_VERIFY_FILE_DATA variable
Message-ID: <20260929013421.GF2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-4-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:44PM +0200, Christoph Hellwig wrote:
> Add an option to run the end of testt xfs_scrub call using the -x

                                  test

> option to also check file data validity.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  README     | 3 +++
>  common/xfs | 8 +++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/README b/README
> index cc03f51e1ad3..0ce7d4463354 100644
> --- a/README
> +++ b/README
> @@ -326,6 +326,9 @@ Extra XFS specification:
>   - xfs_scrub, if present, will always check the test and scratch
>     filesystems if they are still online at the end of the test. It is no
>     longer necessary to set TEST_XFS_SCRUB.
> + - Set XFS_VERIFY_FILE_DATA option to also check file data integrity using the
> +   -x option to xfs_scrub.  This makes the xfs_scrub based checks a lot slower,
> +   but verifies the data checksum support in XFS.
>  
>  Tools specification:
>   - dump:
> diff --git a/common/xfs b/common/xfs
> index 98981e624dda..8254e48603af 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -875,6 +875,12 @@ _check_xfs_filesystem()
>  	# Run online scrub if we can.
>  	mntpt="$(_is_dev_mounted $device)"
>  	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
> +		local xfs_scrub_opts="-v -d -n"
> +
> +		if [ -n "$XFS_VERIFY_FILE_DATA" ]; then
> +			xfs_scrub_opts="$xfs_scrub_opts -x"
> +		fi

/me wonders if you should use bash arrays here but seeing as we just got
burned by that I'll defer to Zorro if he prefers that or not.

With the typo fixed, this looks ok to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
>  		can_scrub=1
>  
>  		# Tests can create a scenario in which a call to syncfs() issued
> @@ -888,7 +894,7 @@ _check_xfs_filesystem()
>  		# before executing a scrub operation.
>  		$XFS_IO_PROG -c syncfs $mntpt >> $seqres.full 2>&1
>  
> -		"$XFS_SCRUB_PROG" -v -d -n $mntpt > $tmp.scrub 2>&1
> +		"$XFS_SCRUB_PROG" $xfs_scrub_opts $mntpt > $tmp.scrub 2>&1
>  		if [ $? -ne 0 ]; then
>  			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
>  			echo "*** xfs_scrub -v -d -n output ***" >> $seqres.full
> -- 
> 2.53.0
> 
> 
