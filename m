Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D26517BB7;
	Thu, 29 Aug 2024 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894837; cv=none; b=faEiMK19bQdRyG9em8hQ2RNoVbcFJdjp9sLJxntYowEKm4WfiSy+k/DYiO+ebpa30k/ZULSicDgBcZ7w1GGmJQFWiMqpvrJImfOYL+phap5g/oHQWMq+L+iuXcLkFBih9l4wRonC7EJTfsLfUmtme6sM58y+PAlucEn714lTz7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894837; c=relaxed/simple;
	bh=VJ81GCv0eYYgIPl/KlfNTzkK18iPjceWv8sbrBfwtP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxGGKHFTtF8UvealNIplkHv7S5/3jBo7ru+8hvOpMTXesL6eoSdkUgj+jGGI7fnHhApSMZbltrvhpXkmLYGGqERq/at4xu0c64Xokx1+BBkuPGb5QIiSL0SVvI8fsiAw/ooKbyTYM8A3AnAmA8OsfWS0VUDFRonAx9BriN6lu+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VY7cUL+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VY7cUL+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C15CC4CEC0;
	Thu, 29 Aug 2024 01:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724894837;
	bh=VJ81GCv0eYYgIPl/KlfNTzkK18iPjceWv8sbrBfwtP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VY7cUL+FQWSVTwUTn3x4gV/CYpsSV4Fv3neqok8M59uLuTKuZTn52N6w8VXQH9F+R
	 HmsP0aJ2TrVe65urEPVxKmaQkzvMNPSTfNkigR61pZIPX304VJeTvrzGIp5hwAGmN7
	 YJNy5IKVzZbQYCCi7qR10cuU+sfpkThGt3TFXZvL0fSlt9vFpJRvq/Nc9q+gsUXH6Q
	 kjzcelPXbchU1RBeDwFhZZxEh994+ZckrzM2ig1XJxuxDSygJm7SK0v9o+hVNiFnvR
	 2ybO4/4ioBqxTqz9QakYMHPs1EZ8GjN5NZoSP1E4jIV0t8ozwP/Wu3JVezgiesFC5x
	 buCZn6Kj7wvLg==
Date: Wed, 28 Aug 2024 18:27:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH v2 1/4] fsx: don't skip file size and buf updates on
 simulated ops
Message-ID: <20240829012716.GF6224@frogsfrogsfrogs>
References: <20240828181534.41054-1-bfoster@redhat.com>
 <20240828181534.41054-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828181534.41054-2-bfoster@redhat.com>

On Wed, Aug 28, 2024 at 02:15:31PM -0400, Brian Foster wrote:
> fsx supports the ability to skip through a certain number of
> operations of a given command sequence before beginning full
> operation. The way this works is by tracking the operation count,
> simulating minimal side effects of skipped operations in-memory, and
> then finally writing out the in-memory state to the target file when
> full operation begins.
> 
> Several fallocate() related operations don't correctly track
> in-memory state when simulated, however. For example, consider an
> ops file with the following two operations:
> 
>   zero_range 0x0 0x1000 0x0
>   read 0x0 0x1000 0x0
> 
> ... and an fsx run like so:
> 
>   fsx -d -b 2 --replay-ops=<opsfile> <file>
> 
> This simulates the zero_range operation, but fails to track the file
> extension that occurs as a side effect such that the subsequent read
> doesn't occur as expected:
> 
>   Will begin at operation 2
>   skipping zero size read
> 
> The read is skipped in this case because the file size is zero.  The
> proper behavior, and what is consistent with other size changing
> operations, is to make the appropriate in-core changes before
> checking whether an operation is simulated so the end result of
> those changes can be reflected on-disk for eventual non-simulated
> operations. This results in expected behavior with the same ops file
> and test command:
> 
>   Will begin at operation 2
>   2 read  0x0 thru        0xfff   (0x1000 bytes)
> 
> Update zero, copy and clone range to do the file size and EOF change
> related zeroing before checking against the simulated ops count.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Oh wow, I really got that wrong. :(

Well, thank you for uncovering that error;
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> ---
>  ltp/fsx.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 2dc59b06..c5727cff 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -1247,6 +1247,17 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
>  	log4(OP_ZERO_RANGE, offset, length,
>  	     keep_size ? FL_KEEP_SIZE : FL_NONE);
>  
> +	if (!keep_size && end_offset > file_size) {
> +		/*
> +		 * If there's a gap between the old file size and the offset of
> +		 * the zero range operation, fill the gap with zeroes.
> +		 */
> +		if (offset > file_size)
> +			memset(good_buf + file_size, '\0', offset - file_size);
> +
> +		file_size = end_offset;
> +	}
> +
>  	if (testcalls <= simulatedopcount)
>  		return;
>  
> @@ -1263,17 +1274,6 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
>  	}
>  
>  	memset(good_buf + offset, '\0', length);
> -
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
>  }
>  
>  #else
> @@ -1538,6 +1538,11 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
>  
>  	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
>  
> +	if (dest > file_size)
> +		memset(good_buf + file_size, '\0', dest - file_size);
> +	if (dest + length > file_size)
> +		file_size = dest + length;
> +
>  	if (testcalls <= simulatedopcount)
>  		return;
>  
> @@ -1556,10 +1561,6 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
>  	}
>  
>  	memcpy(good_buf + dest, good_buf + offset, length);
> -	if (dest > file_size)
> -		memset(good_buf + file_size, '\0', dest - file_size);
> -	if (dest + length > file_size)
> -		file_size = dest + length;
>  }
>  
>  #else
> @@ -1756,6 +1757,11 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
>  
>  	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
>  
> +	if (dest > file_size)
> +		memset(good_buf + file_size, '\0', dest - file_size);
> +	if (dest + length > file_size)
> +		file_size = dest + length;
> +
>  	if (testcalls <= simulatedopcount)
>  		return;
>  
> @@ -1792,10 +1798,6 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
>  	}
>  
>  	memcpy(good_buf + dest, good_buf + offset, length);
> -	if (dest > file_size)
> -		memset(good_buf + file_size, '\0', dest - file_size);
> -	if (dest + length > file_size)
> -		file_size = dest + length;
>  }
>  
>  #else
> -- 
> 2.45.0
> 
> 
