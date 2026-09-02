Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2643247ECC2
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 16:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365256; cv=none; b=RkCwFaqP9RwOk/2QsIZ9R5du3prrLkKdqWhjrIvyOJIyQMSB5SfEYjZ0Mr6Huiige9V/6E5dAHOt4NN8RSt5CNdcy+cdDcyydVUiSSc/aZ38E3Cq7t8LdpOrjp09p7qI33oyfNSYySYUaOKcHcg4hkAaBmMdFegKf7OwEGTuSNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365256; c=relaxed/simple;
	bh=ox9p0P+WqhYVmULuUD6z7hGhvP48OH13DwdFkh+a8rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KbatNLdN50Y4sqsg0wXmZBxggoAb/mKyBBEAMPrXza+GRMsp9kRQQH+J6LmdJvn9/KUoEkyC9bToBX8aVm9xXfl12M5nnXlX2VZTE4bxwqJuk6TuVWneb3WS880CzInEqtD9GuIECFNmLIeBHrp7giU9Vbk+UlJqq33KTFlBoFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SISOCbF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SISOCbF3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 980F91F000E9;
	Wed,  2 Sep 2026 16:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788365254;
	bh=HfVe+Y+BxNThSXiherOm+uO9tBqGEJEUi0iPlNCM1pM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SISOCbF3AmaWKPvAoGsWj4jrSc71QRtIiy1xuwCW2sSmRJDYd519HSXOydg7JT6jW
	 TKBZhnay32pJN+2oh8kzyeceCc4G/uOJciF3L/pPjdTOTLy5oH2MaEXAmte+gH/7i2
	 7OPAt02B8DSJ6gKUmjnyxhDkCBjgPpDC0AaSGnGvS1mm66i4KNqHl9uZpAJ45J7ulQ
	 5LLYS9m5suoCa9yAjk9PPhzjSDD+/lUAG57mqTPUUWjitvcAs8oZJQDZyvL4txY8i9
	 2UjCW5xaUSCI2pnYtxx1v8Vt/dJWJYCGptrVGy1nfj54X1ITgIMSeLnoPPyOc1ct1o
	 26D4ywDg6h6Rw==
Date: Wed, 2 Sep 2026 09:07:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: clean up xfs_fsync_flush_log a bit
Message-ID: <20260902160734.GQ1933798@frogsfrogsfrogs>
References: <20260902054942.111988-1-hch@lst.de>
 <20260902054942.111988-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902054942.111988-4-hch@lst.de>

On Wed, Sep 02, 2026 at 08:49:17AM +0300, Christoph Hellwig wrote:
> The log_flushed parameter still fits on the previous line, so move it up.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 0d31fea67a2c..cce324321b4c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -117,8 +117,7 @@ xfs_fsync_flush_log(
>  	if (!seq)
>  		return 0;
>  
> -	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
> -					  log_flushed);
> +	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);
>  }
>  
>  STATIC int
> -- 
> 2.53.0
> 
> 
