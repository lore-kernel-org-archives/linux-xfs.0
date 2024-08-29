Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E9E200CB;
	Thu, 29 Aug 2024 01:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894909; cv=none; b=jP0SXIsB+qbIHTukoR9G21jyPUmcybNKxUOHer0et/4RSgqW+1emHbB3wUZQIiYJf09ZSc7eqFslyuiFngty9R+vL9sZn85Rpdzy+EwgSVTQUT54ayjnI4wBGuPpZbNU0lAJ0hZYw+XV9ZyA6U6tL2gFO0d1L74Va5DHmIqc/Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894909; c=relaxed/simple;
	bh=Wwrx16h43MXsDIho3z5TqiAaAfY7Y3GZXEfYOgVQyeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gCuxWoD8rHfKYkb53fPbhA20zMXqzJ+5yOKyDuYqe6pfXjmIG8gLdoZu6QkIPSeaRRXXNVGWLcgmCgTozNW4HZFcNfCHaWSN1gx0uaPMMx4b54RH9Cq94izhO4X2JkpNo+huqzJcwkq9gVeEUZKzHwnGDZIpDCNPsEKlzFL6MYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ta65Zd9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ta65Zd9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A69EC4CEC0;
	Thu, 29 Aug 2024 01:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724894909;
	bh=Wwrx16h43MXsDIho3z5TqiAaAfY7Y3GZXEfYOgVQyeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ta65Zd9pt+eySdspd7SK1P8YNxhCVGy07hwYoNd+6VOhMw9ppPSNXgv4YHtAMdKLj
	 Jjl+JGdtPMBOgEUnuethWq3Sn/i5JAbDUNQGE8Dlx6rWoFFpzUNdXTCqQ7DzpUOJIl
	 bDhKRlO0BnEOFJ7bN7fdy//K+wGP665tyvsA1rUgTX3EGRf3Ubv1WBkqH/MOE35mKx
	 S3hTZ/LdqEwxcI3Fpji0lZ7qfZlL0e9sTrlSK+Lw4J63N6jpqocyVC6aY/TJy7Nni3
	 V7gBsdRx6TfEU3gXg5uAa8xss0iXt5f1+K80WoeHttoy+s3IyUjz4BSD3KT+x+Puvc
	 xQ/y6ka9uf7sg==
Date: Wed, 28 Aug 2024 18:28:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH v2 2/4] fsx: factor out a file size update helper
Message-ID: <20240829012828.GG6224@frogsfrogsfrogs>
References: <20240828181534.41054-1-bfoster@redhat.com>
 <20240828181534.41054-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828181534.41054-3-bfoster@redhat.com>

On Wed, Aug 28, 2024 at 02:15:32PM -0400, Brian Foster wrote:
> In preparation for support for eof page pollution, factor out a file
> size update helper. This updates the internally tracked file size
> based on the upcoming operation and zeroes the appropriate range in
> the good buffer for extending operations.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks like a straightforward hoist now.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  ltp/fsx.c | 49 +++++++++++++++++++++----------------------------
>  1 file changed, 21 insertions(+), 28 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index c5727cff..4a9be0e1 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -983,6 +983,17 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
>  	}
>  }
>  
> +/*
> + * Helper to update the tracked file size. If the offset begins beyond current
> + * EOF, zero the range from EOF to offset in the good buffer.
> + */
> +void
> +update_file_size(unsigned offset, unsigned size)
> +{
> +	if (offset > file_size)
> +		memset(good_buf + file_size, '\0', offset - file_size);
> +	file_size = offset + size;
> +}
>  
>  void
>  dowrite(unsigned offset, unsigned size)
> @@ -1003,10 +1014,8 @@ dowrite(unsigned offset, unsigned size)
>  	log4(OP_WRITE, offset, size, FL_NONE);
>  
>  	gendata(original_buf, good_buf, offset, size);
> -	if (file_size < offset + size) {
> -		if (file_size < offset)
> -			memset(good_buf + file_size, '\0', offset - file_size);
> -		file_size = offset + size;
> +	if (offset + size > file_size) {
> +		update_file_size(offset, size);
>  		if (lite) {
>  			warn("Lite file size bug in fsx!");
>  			report_failure(149);
> @@ -1070,10 +1079,8 @@ domapwrite(unsigned offset, unsigned size)
>  	log4(OP_MAPWRITE, offset, size, FL_NONE);
>  
>  	gendata(original_buf, good_buf, offset, size);
> -	if (file_size < offset + size) {
> -		if (file_size < offset)
> -			memset(good_buf + file_size, '\0', offset - file_size);
> -		file_size = offset + size;
> +	if (offset + size > file_size) {
> +		update_file_size(offset, size);
>  		if (lite) {
>  			warn("Lite file size bug in fsx!");
>  			report_failure(200);
> @@ -1136,9 +1143,7 @@ dotruncate(unsigned size)
>  
>  	log4(OP_TRUNCATE, 0, size, FL_NONE);
>  
> -	if (size > file_size)
> -		memset(good_buf + file_size, '\0', size - file_size);
> -	file_size = size;
> +	update_file_size(size, 0);
>  
>  	if (testcalls <= simulatedopcount)
>  		return;
> @@ -1247,16 +1252,8 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
>  	log4(OP_ZERO_RANGE, offset, length,
>  	     keep_size ? FL_KEEP_SIZE : FL_NONE);
>  
> -	if (!keep_size && end_offset > file_size) {
> -		/*
> -		 * If there's a gap between the old file size and the offset of
> -		 * the zero range operation, fill the gap with zeroes.
> -		 */
> -		if (offset > file_size)
> -			memset(good_buf + file_size, '\0', offset - file_size);
> -
> -		file_size = end_offset;
> -	}
> +	if (!keep_size && end_offset > file_size)
> +		update_file_size(offset, length);
>  
>  	if (testcalls <= simulatedopcount)
>  		return;
> @@ -1538,10 +1535,8 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
>  
>  	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
>  
> -	if (dest > file_size)
> -		memset(good_buf + file_size, '\0', dest - file_size);
>  	if (dest + length > file_size)
> -		file_size = dest + length;
> +		update_file_size(dest, length);
>  
>  	if (testcalls <= simulatedopcount)
>  		return;
> @@ -1757,10 +1752,8 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
>  
>  	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
>  
> -	if (dest > file_size)
> -		memset(good_buf + file_size, '\0', dest - file_size);
>  	if (dest + length > file_size)
> -		file_size = dest + length;
> +		update_file_size(dest, length);
>  
>  	if (testcalls <= simulatedopcount)
>  		return;
> @@ -1848,7 +1841,7 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
>  
>  	if (end_offset > file_size) {
>  		memset(good_buf + file_size, '\0', end_offset - file_size);
> -		file_size = end_offset;
> +		update_file_size(offset, length);
>  	}
>  
>  	if (testcalls <= simulatedopcount)
> -- 
> 2.45.0
> 
> 
