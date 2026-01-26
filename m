Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DAF23A9B0;
	Mon, 26 Jan 2026 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769456646; cv=none; b=fsh3v7Lb7Y7lCFgzaAWntWO3vCjiwUFLTNKAWYyiWkr+0l9ZLCr5SlKbMRjNW7de/cf33MMkMvhNDifEjkoq4q9F2rw9YygDD3ytmjEjK3SRbrzXm/JVvhAg8XyTooVQgvnUZh4Fl72rjDpSP/XPwTDDJgB4kLgWt1LbsWRZwQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769456646; c=relaxed/simple;
	bh=ZJ/UdBnJ9+yQhlizIaIK0KPoFhrOURHRZyFfM0bw2u0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HI1M9fOVjUdPa6IwCb60rHLBX/QWAqzzeDVyA5ChiEEkxOSsJlxcMkbWFhaLWb4vGj2cSkiKpxSOL5jxgqxVHw9Yd19HGj6CUBJPS5sXkHRE50D4v/GepXXj+/s6W6e5r362v/vnjm9NH6EnTNoTlpxqbSALAR9x4IbOoJQG9+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6oaaP+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6oaaP+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B481C116C6;
	Mon, 26 Jan 2026 19:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769456645;
	bh=ZJ/UdBnJ9+yQhlizIaIK0KPoFhrOURHRZyFfM0bw2u0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s6oaaP+p0iyceThyCgyu2k6eW18vdbN68cE7OXjuQ8kcQ6VxdpE8tyvKKHefPaNpD
	 EU9O9qeQT7RZZ/bTy8WrxUCWroRQcVVopS0e1ww6zWvm7x6dDmEJ/bM84EVBGW6bVg
	 7x7iDZZ5tzSwzBjpAwjmEco7jaYTtVG+H+P5yCC6e7Eb9YT463gn6bRilAQSzQ5rGT
	 LhAt4WNqdumozIqzmWzC2tmhgOB819Mt3VWJidLiciJ1ISwRTeiZyM02TjL5VxyXdG
	 6uIJnA0Nl1zmdldG/iCeAa06DV5myKE6kAIJe2HYwbgtY5s8SirJfClsF0DuW8x5mQ
	 g6XBdqwAXEelA==
Date: Mon, 26 Jan 2026 11:44:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org,
	fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/841: fix the fsstress invocation
Message-ID: <20260126194404.GY5945@frogsfrogsfrogs>
References: <20260126130816.11494-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126130816.11494-1-hch@lst.de>

[cc fstests]

On Mon, Jan 26, 2026 at 02:08:16PM +0100, Christoph Hellwig wrote:
> xfs/841 fails for me with:
> 
> +/root/xfstests-dev/tests/xfs/841: line 79: -f: command not found
> 
> Looks like the recent edits missed a \ escape.  Fix that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Doh!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/841 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/841 b/tests/xfs/841
> index b4bf538f1526..ee2368d4a746 100755
> --- a/tests/xfs/841
> +++ b/tests/xfs/841
> @@ -64,7 +64,7 @@ _create_proto_dir()
>  	rm -rf "$PROTO_DIR"
>  	mkdir -p "$PROTO_DIR"
>  
> -	FSSTRESS_ARGS=`_scale_fsstress_args -d $PROTO_DIR -s 1 -n 2000 -p 2 -z
> +	FSSTRESS_ARGS=`_scale_fsstress_args -d $PROTO_DIR -s 1 -n 2000 -p 2 -z \
>  		-f creat=15 \
>  		-f mkdir=8 \
>  		-f write=15 \
> -- 
> 2.47.3
> 
> 
