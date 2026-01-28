Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1640619CD1B
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 01:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769563914; cv=none; b=ODkbWqFGZmNYF2ynk8ESW/rTymwSXXLvUjMDNGDoqoyVyT8Blrj9yZPmR53G0CAjKczElVkL8uAZM77hWYcoEHO85ObJyNw++rxrCTj+gAs7wY0lCLYpplUxU1TmBkYbVOFagV2lzv3xWqBCl3Jw/Jdxe/IVlu74v5wMroFfUQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769563914; c=relaxed/simple;
	bh=RqTe8CxBQPB4pV9MfgYLEm75CTa7e0Ap/xY/IRhoAKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhJkRPnZdy+QLXYMDiReGg2Itj9Ck57q62J49+xgAxCOn6Tr4tMWn1qgcyJ9K6FLrQ38EWNXSQkO9o/5tQDqjjYQYZtsIF8ZytTnbeOEctVMyTwq7fO93oLudREqwCdL8BiPnGwOtQ125QybD5Fu1isKbrv2cx6HEeLZdD0AySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t9KU4lYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9KU4lYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C19C116C6;
	Wed, 28 Jan 2026 01:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769563913;
	bh=RqTe8CxBQPB4pV9MfgYLEm75CTa7e0Ap/xY/IRhoAKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t9KU4lYOA4ItaTTNR9cVaRNPFfIPykGminwY3v3Z2eNLGx1yVl+TZz4XHDBZLyx9K
	 ecFgI/CfFzcbqpm052/NYJTMBxvVC9m5N6kPTK7YJFkjSxzCfzWVbmNuNNB6XlSBJ/
	 wDJekNgG1PP3rzuYDh7lixwaUyhPpc3RJCF+xlE+Fduz/9S0f+ovF/ZVBPrpg/X/F2
	 sX9tdqNWm/CXtJ6+1SclHRMm1Wb7q18JXPJ2bXkJp++DNj+5VAU8i9Z4BGolb+4qPd
	 jGflTcYQ3JHzfZC5CvHWtr2N22BkLe80bZK7NhG4+Gei8cwgOUwelYevOSUh1+VfDH
	 oWvlmwIKBpa8A==
Date: Tue, 27 Jan 2026 17:31:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: fix the errno sign for the
 xfs_errortag_{add,clearall} stubs
Message-ID: <20260128013153.GA5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-2-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:41PM +0100, Christoph Hellwig wrote:
> All errno values should be negative in the kernel.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, that always seemed like a logic bomb waiting to go off...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_error.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index fe6a71bbe9cd..3a78c8dfaec8 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -60,8 +60,8 @@ int xfs_errortag_clearall(struct xfs_mount *mp);
>  #define xfs_errortag_del(mp)
>  #define XFS_TEST_ERROR(mp, tag)			(false)
>  #define XFS_ERRORTAG_DELAY(mp, tag)		((void)0)
> -#define xfs_errortag_add(mp, tag)		(ENOSYS)
> -#define xfs_errortag_clearall(mp)		(ENOSYS)
> +#define xfs_errortag_add(mp, tag)		(-ENOSYS)
> +#define xfs_errortag_clearall(mp)		(-ENOSYS)
>  #endif /* DEBUG */
>  
>  /*
> -- 
> 2.47.3
> 
> 
