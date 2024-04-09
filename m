Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E1A13D619;
	Tue,  9 Apr 2024 15:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712677176; cv=none; b=PFFZebIThCd6g09obhlJwiyEju9Eyn3kk9ZvbzBnbUkeGWb1s0LCdTTrvup+cE5ABMJQfKQPCPxttdTdnwOriiSPe7CxwzfaxwRHL4M9DlBgk1Sl9nJrOxVLEVyjRhj/0W8GT5kACYLYo2RGWSouasEYQdtQ7rAmLmW7OfWrKXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712677176; c=relaxed/simple;
	bh=bsRN3AtWbfvqR9hJIydf8/2Cb4umn1L/b7O+B+9hUHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7XjL9pA7doEFE9rF0usmhOzVOLHfSzPUiObtVlHRdi7IpBCBeoL++kUx0FUVZYa03eR9HOEYl1NzyhXYXF7qTHK+wZzogzcmOpKfFpzkjljqDbU5SvDSn3YjXIgX9opG7vUOh/QOt3nACVRgqG8TyD0sOaqZi1gHHPEM+tTk5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7BE1IBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7BE1IBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A46C433F1;
	Tue,  9 Apr 2024 15:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712677176;
	bh=bsRN3AtWbfvqR9hJIydf8/2Cb4umn1L/b7O+B+9hUHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B7BE1IBPIrIfUIyeb3v6hQhMWQb1Ux9iqnE5gVUoJoAEM7UvNJDuKTconybyTX0vU
	 jLUXSUKu4zCRU9Q1UBmaRlHzxKFt+J6iI6z3j+mkibbsKdiLLZ99qBC6gdF/4eUTfn
	 oPh5e066ygJFW6Czxp3CCgBkIq4tk4JX+ItR565Mhzadllc/wRF5Gid4E5CGUZSLfX
	 laemX4v+oNvR3xhESkYkhGmS/CTEnviDohn/RWoKTdpWRFZV5aQ39G1dSBml69qN+T
	 dY9+b1BO8tA3tZQ9jIG3UWyiIwBGqi3hCWI2xwhJJErgYS0ZGr6XI9ot1M9En3Pk+5
	 6Hncj7Hj15cdw==
Date: Tue, 9 Apr 2024 08:39:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs/522: use reflink instead of crc as test feature
Message-ID: <20240409153935.GE634366@frogsfrogsfrogs>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408133243.694134-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408133243.694134-6-hch@lst.de>

On Mon, Apr 08, 2024 at 03:32:42PM +0200, Christoph Hellwig wrote:
> Replace crc as the main test feature with reflink so that this test
> do not require v4 file system support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty straight conversion, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/522 | 58 +++++++++++++++++++++++++--------------------------
>  1 file changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/tests/xfs/522 b/tests/xfs/522
> index 2475d5844..05251b0e2 100755
> --- a/tests/xfs/522
> +++ b/tests/xfs/522
> @@ -46,58 +46,58 @@ test_mkfs_config() {
>  echo Simplest config file
>  cat > $def_cfgfile << ENDL
>  [metadata]
> -crc = 0
> +reflink = 0
>  ENDL
>  test_mkfs_config $def_cfgfile
>  
>  echo Piped-in config file
>  test_mkfs_config << ENDL
>  [metadata]
> -crc = 0
> +reflink = 0
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> -crc = 1
> +reflink = 1
>  ENDL
>  
>  echo Full line comment
>  test_mkfs_config << ENDL
>  # This is a full line comment.
>  [metadata]
> -crc = 0
> +reflink = 0
>  ENDL
>  test_mkfs_config << ENDL
>   # This is a full line comment.
>  [metadata]
> -crc = 0
> +reflink = 0
>  ENDL
>  test_mkfs_config << ENDL
>  #This is a full line comment.
>  [metadata]
> -crc = 0
> +reflink = 0
>  ENDL
>  
>  echo End of line comment
>  test_mkfs_config << ENDL
>  [metadata]
> -crc = 0 ; This is an eol comment.
> +reflink = 0 ; This is an eol comment.
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> -crc = 0 ;This is an eol comment.
> +reflink = 0 ;This is an eol comment.
>  ENDL
>  
>  echo Multiple directives
>  test_mkfs_config << ENDL
>  [metadata]
> -crc = 0
> +reflink = 0
>  finobt = 0
>  ENDL
>  
>  echo Multiple sections
>  test_mkfs_config << ENDL
>  [metadata]
> -crc = 0
> +reflink = 0
>  
>  [inode]
>  sparse = 0
> @@ -111,92 +111,92 @@ ENDL
>  echo Space around the section name
>  test_mkfs_config << ENDL
>   [metadata]
> -crc = 0
> +reflink = 0
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata] 
> -crc = 0
> +reflink = 0
>  ENDL
>  test_mkfs_config << ENDL
>   [metadata] 
> -crc = 0
> +reflink = 0
>  ENDL
>  
>  echo Single space around the key/value directive
>  test_mkfs_config << ENDL
>  [metadata]
> - crc=0
> + reflink=0
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> -crc =0
> +reflink =0
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> -crc= 0
> +reflink= 0
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> -crc=0 
> +reflink=0 
>  ENDL
>  
>  echo Two spaces around the key/value directive
>  test_mkfs_config << ENDL
>  [metadata]
> - crc =0
> + reflink =0
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> - crc= 0
> + reflink= 0
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> - crc=0 
> + reflink=0 
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> -crc = 0
> +reflink = 0
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> -crc =0 
> +reflink =0 
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> -crc= 0 
> +reflink= 0 
>  ENDL
>  
>  echo Three spaces around the key/value directive
>  test_mkfs_config << ENDL
>  [metadata]
> - crc = 0
> + reflink = 0
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> - crc= 0 
> + reflink= 0 
>  ENDL
>  test_mkfs_config << ENDL
>  [metadata]
> -crc = 0 
> +reflink = 0 
>  ENDL
>  
>  echo Four spaces around the key/value directive
>  test_mkfs_config << ENDL
>  [metadata]
> - crc = 0 
> + reflink = 0 
>  ENDL
>  
>  echo Arbitrary spaces and tabs
>  test_mkfs_config << ENDL
>  [metadata]
> -	  crc 	  	=   	  	 0	  	 	  
> +	  reflink 	  	=   	  	 0	  	 	  
>  ENDL
>  
>  echo ambiguous comment/section names
>  test_mkfs_config << ENDL
>  [metadata]
>  #[data]
> -crc = 0
> +reflink = 0
>  ENDL
>  
>  echo ambiguous comment/variable names
> -- 
> 2.39.2
> 
> 
