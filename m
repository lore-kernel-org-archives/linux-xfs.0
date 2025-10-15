Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47C43126AE
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 06:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760509830; cv=none; b=OcDkANJul4yZv/PPgfvGa8Z8NzlmtsbNeON6UZnE9qT2eQwLZx/kL1rzhm3JWXpwa2SE8ZJ2WWpPEWqmLUjWszboDFaBvEnbtaUwYdRRj91UO2C2WuyRc+Oa4lBUNUgtyopTkEGi+Hr3UPXRj3RuYLm7Z8zVrFWddO0cgD8Bj6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760509830; c=relaxed/simple;
	bh=Ce75dv2WbFeRp0x7dnVAI0UYwPW80Wzw3VBIDlJpoYo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=pZmV2tMDOKAbKQqmZdIIW/QQzqQckDd/v6GAou7LE4ma2Olrg3QLLnRrnhYE6dl6gfvMjZwznr8+XTKSRjaNTgr7A1LZN8HfQM3XsTwR+/VBfSYpdc2Hvn5sTSuMBx6HCR8udFOsT2K7J0TIHgUOqFCbuGJH7pX6txseW7/EHak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X6+hSQTq; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X6+hSQTq"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-32ec291a325so4499667a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 23:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760509828; x=1761114628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+kZ1QG0DCIbDMCSZkw2tQN/7doTML3C1OTtYQSZ3vI=;
        b=X6+hSQTqFZL8xieXUwM5YPUyAZRGIQHk/FIN8eqdGgwFDibQyJ/QB0QF/QJwhEiWiu
         +MtzdqZ3i/TP+w2RqyqsBeHYaHcxmALUx29RUXboUjVPHu9f5er6kcW3zTazI56SFzNz
         GvosZvPbLWfNdqll3TDI42YkuvALHc/TP6W20IN0lUodFv4Ss2H7ji4FiTqkDAIRKoMB
         1FSsLkzUD6UxBN1tHsbnlPiD3HkQYX6vJOyR2rUScDSWHvQXY2yLETaDsprr7rGIEORT
         atkwA1PjCRfP1PCAzswWvecrF+Nxdrn4XCsLR/kHhq5TGghJ1+GjQM6y1v+kR4dQOTON
         h4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760509828; x=1761114628;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f+kZ1QG0DCIbDMCSZkw2tQN/7doTML3C1OTtYQSZ3vI=;
        b=th/z8v2QQUNPxdTUbj82+S6Rgvk3pjwitpLjjDbkd1bWv922EkEKfi8fP/IHMfF2TH
         ByNeuQda/Z3Z5H/XRHP9K37SjWVArCbG0nFRDJxOblzWgS9CxX4VVZAbQ59FwcQPBiJo
         JQId9ZSOB+ZwlTkIze2tcPPYJxgDBauKDeRwZrNZvLFM3wt32qNATlq41Aic63XCeNq5
         iqJ8n/FmH7VFKIhaHD+EBV2G8KGeFzuVzBWSgyNfoo5o0s6U980NMrvFO9baHDa2Ut10
         YDzHVpoCBFFikS9mOODehtwIbPnDOn9mqnbqH3UKOtBg36C528lfdZUrUA2hstyUtIUm
         XY8g==
X-Forwarded-Encrypted: i=1; AJvYcCX2ruh0ZzFzrLhj07SgLP7EXdM5Tz9+k7xpRk0cA6YmlZ6sCheVMXsvJYghrrXLg1nKWyVHjvuUhj4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzqrbwwmduig3FaWD04zycATbvHVyoaVCScIAl4rUF9Kul7TXQq
	a61LyhQp4j9XEe8GtjqRQYPsZ7WeqSPf7LOeqMvYcLcnbHMXBag07D+ouAYp7Q==
X-Gm-Gg: ASbGncvM5WFWtijMYELkb1HWzVphGLiEuf5JjWEoKf8ycjxGGugejjrJqBkz0bt/1tQ
	YRMeb43I2LhCfKswrekv0d8xadQYgbeOE9HPvCNJGHKRg2Ku7j+twbs82x9DmAi7WO2pu45XUhk
	6LJIi4yNOECVcLBj9DIxZJNKlbn4mpPT2R/1kYXOhu2IQ+up2YxqvEFG4qa9T7680xUswJ/fwC0
	kPYPzxrM732unSl6aT2IPv0u7plR+HORtUOi1XRMIJ4AXG25cFi/KLsLtRtri4gE6cEHBN8l/s5
	EAqe7HHVzbq6FClg2F7YxhrFHqVaA7G5H+qpXLh9mq342WTOzs5DgiCbN33GTv5Ib1cmR2tsCV9
	dOJCjuYtrw/jcXI9tJK0B61I4Co5y4PR4stUgM8Be0fWn8wsm1EcyU1sMD3/KD60zMUFUrxUFK4
	b5h49WFHO4Cr6zkl7Dj6UBIpNgww==
X-Google-Smtp-Source: AGHT+IFU1HLeTniJo16WKQLSIckSiz4BXj556bmP/nAaPk/UZ4j5G7VELO51Y4DWWfNB2cTpXIIe0A==
X-Received: by 2002:a17:90b:3ec1:b0:335:2823:3683 with SMTP id 98e67ed59e1d1-33b5111491amr39370551a91.9.1760509827762;
        Tue, 14 Oct 2025 23:30:27 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b9786062dsm1121315a91.7.2025.10.14.23.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 23:30:27 -0700 (PDT)
Message-ID: <551877bad6b15e4e51e90a14f8311b36bef00d78.camel@gmail.com>
Subject: Re: [PATCH RFC] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org
Date: Wed, 15 Oct 2025 12:00:23 +0530
In-Reply-To: <20251002122823.1875398-2-lukas@herbolt.com>
References: <20251002122823.1875398-2-lukas@herbolt.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2025-10-02 at 14:28 +0200, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> Inspired by the Ext4 implementation of the FALLOC_FL_WRITE_ZEROES. It
> can speed up some patterns on specific hardware.
> 
> time ( ./fallocate -l 360M /mnt/test.file; dd if=/dev/zero of=/mnt/test.file \
> bs=1M count=360 conv=notrunc,nocreat oflag=direct,dsync)
> 
> 360+0 records in
> 360+0 records out
> 377487360 bytes (377 MB, 360 MiB) copied, 22.0027 s, 17.2 MB/s
> 
> real	0m22.114s
> user	0m0.006s
> sys		0m3.085s
> 
> time (./fallocate -wl 360M /mnt/test.file; dd if=/dev/zero of=/mnt/test.file \
> bs=1M count=360 conv=notrunc,nocreat oflag=direct,dsync );
> 360+0 records in
> 360+0 records out
> 377487360 bytes (377 MB, 360 MiB) copied, 2.02512 s, 186 MB/s
> 
> real	0m6.384s
> user	0m0.002s
> sys		0m5.823s
> 
> 
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_bmap_util.c |  5 +++--
>  fs/xfs/xfs_bmap_util.h |  4 ++--
>  fs/xfs/xfs_file.c      | 23 ++++++++++++++++++-----
>  3 files changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 06ca11731e430..a91596a280ba5 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -645,6 +645,7 @@ xfs_free_eofblocks(
>  int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
> +    uint32_t        flags,      /* XFS_BMAPI_... */
Spacing issue
>  	xfs_off_t		offset,
>  	xfs_off_t		len)
>  {
> @@ -748,8 +749,8 @@ xfs_alloc_file_space(
>  		 * will eventually reach the requested range.
>  		 */
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> -				&nimaps);
> +				allocatesize_fsb, flags, 0, imapp, &nimaps);
> +
>  		if (error) {
>  			if (error != -ENOSR)
>  				goto error;
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b33616304..67770830eb245 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -55,8 +55,8 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  			     int *is_empty);
>  
>  /* preallocation and hole punch interface */
> -int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -		xfs_off_t len);
> +int	xfs_alloc_file_space(struct xfs_inode *ip, uint32_t flags,
> +		xfs_off_t offset, xfs_off_t len);
>  int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f96fbf5c54c99..48559a011e9b4 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1255,7 +1255,7 @@ xfs_falloc_insert_range(
>  static int
>  xfs_falloc_zero_range(
>  	struct file		*file,
> -	int			mode,
> +	int				mode,
>  	loff_t			offset,
>  	loff_t			len,
>  	struct xfs_zone_alloc_ctx *ac)
> @@ -1277,7 +1277,16 @@ xfs_falloc_zero_range(
>  
>  	len = round_up(offset + len, blksize) - round_down(offset, blksize);
>  	offset = round_down(offset, blksize);
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (!bdev_write_zeroes_unmap_sectors(inode->i_sb->s_bdev))
> +	        return -EOPNOTSUPP;
indentation issue above.
You can use ./scripts/checkpatch.pl --max-line-length=80 <path to patch files>. This should catch
most of the common styling issues. Yes, there are XFS specific styles which the above script will
not be able to catch. 
--NR
> +		error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_ZERO,
> +				offset, len);
> +	}
> +	else
> +		error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
> +				offset, len);
> +
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1302,7 +1311,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
> +			offset, len);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1330,7 +1340,9 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
> +			offset, len);
> +
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1340,7 +1352,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES )
>  
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1383,6 +1395,7 @@ __xfs_file_fallocate(
>  	case FALLOC_FL_INSERT_RANGE:
>  		error = xfs_falloc_insert_range(file, offset, len);
>  		break;
> +	case FALLOC_FL_WRITE_ZEROES:
>  	case FALLOC_FL_ZERO_RANGE:
>  		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
>  		break;

