Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B1D440C
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 02:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640974; cv=none; b=Br8Q+m42ZvL4j+OLhRzdKzBPh0dT1oQ30ygkFda010uzA6tdmyIoGz4mUhHQwAEY+vi3tr7SYiYtAOZ7hhGZO5auWbWUPYFGBqTXxVQ4l3DwPbgJNwqXnZhO1lxntNggK7/v6ByIj/43+G9KpG9NrV6lem3tCAi3F+gy4PV1Y9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640974; c=relaxed/simple;
	bh=YNvnjhxBf75UfjaQuC/jNUTZBPhRsaLZ6Ocj7GatYEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKs5SRmklPzNy1CJsKiyvEWYwscfD9rhEVnSejnCdM2XS1GZ+tnIRUyHvplkzX0roZpfUW+V24bazxeV+3mI2QRxhaX5Ba8tXDziDjGU7lE+xttRW7wLj3L37QN6DXc+nQll+zvcrKTlmTb2aay/5OvXw0DU/XnNJ/g7cQwGhM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Auzoogrk; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Auzoogrk"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f4603237e0so281173b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2024 19:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717640973; x=1718245773; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RpQFP/a+FTMVBNnPNFatowzkXCbgSh3HErqXYcmvBTM=;
        b=AuzoogrkYN2qOnFTJe1z+1n0ydPaKm6a3HDFkkC/CR1o6O2RQ3LAChuVVzru76owvI
         Qc4s/7LXnct2PCFdDLiUIST3Cdqxiyz93QJ6lOdFEXcM35pfh6atHJdrlFMw4+iA81Vy
         fA/Oomozj8I4KNvCi/uHdTtUt3w5e8261lWAOJX3A0ddgN4a7gCkxEYwzYM6t0TEe8Zb
         hrDdyazBFr8tLJjkG/e9a14XVuxyqUeHkzFeNam4pgKHhrUUhMPRY6Nn5l4nEHhHNkmX
         BMwfF21SwWCrsk+M5+jjM6lasjK4ypu3mhVYCRsynB6oo0mUYgRMmp+R11FYK4ROJeUF
         yPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717640973; x=1718245773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpQFP/a+FTMVBNnPNFatowzkXCbgSh3HErqXYcmvBTM=;
        b=i0bjTYLaq+kjGeuMMl31k94wnUIJ4Tf+IiJ7IV8MjkMpQzSDuwh6IygoEQbNY8OhLS
         /NQejcxGWkihtLITMn8njydPzbnt5n64iRbkxa2KXrXSBxuE4yjW9GrpjPd0b38t7z1g
         wVoKLTOgVgyaej/9WR/ZUTx8w8CIRRePQMf7je1k55pNB1tYGPWtDmDTi68FQ2kdmvKN
         qcEAfKu0DbDeMp3ryQURKhWMhUwEkdGTtf+DO4BM84oFc2Z130cAeUGajgwKIfpAxuJj
         /12YJEbSwDwS/JtNV/zzDV7hh6CVNCST/JMnRraIwsdPxp4hl0ewlKaWZug4KJejd7FE
         iXAg==
X-Gm-Message-State: AOJu0YyDK3ZaXMLuzOpGmEcoEyWDq6pbdOxepA09jCJCndAa5Ic88eES
	LdUL6amnEQHG5dSDagmvqEcOnKUUk8hvFvb7dbEE/AuLnt6iKQnuGtGnIZ6T8d0=
X-Google-Smtp-Source: AGHT+IGt4pSEY7aKtiMSiToHz2NsWVMGxR/W8o9EWbPzGvURszPQghlxqxIamV1Oe767zM3A2KuLrw==
X-Received: by 2002:a05:6a20:1595:b0:1b0:194a:82f5 with SMTP id adf61e73a8af0-1b2c5687b1bmr1856372637.21.1717640972519;
        Wed, 05 Jun 2024 19:29:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6de22ebe179sm194224a12.53.2024.06.05.19.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 19:29:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sF2sa-005rnZ-2Z;
	Thu, 06 Jun 2024 12:29:28 +1000
Date: Thu, 6 Jun 2024 12:29:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: lei lu <llfamsec@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: don't walk off the end of a directory data block
Message-ID: <ZmEfCMOgTRn7yTMs@dread.disaster.area>
References: <20240603080146.81563-1-llfamsec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603080146.81563-1-llfamsec@gmail.com>

On Mon, Jun 03, 2024 at 04:01:46PM +0800, lei lu wrote:
> This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
> to make sure don'y stray beyond valid memory region. Before patching, the
> loop simply checks that the start offset of the dup and dep is within the
> range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
> can change dup->length to dup->length-1 and leave 1 byte of space. In the
> next traversal, this space will be considered as dup or dep. We may
> encounter an out of bound read when accessing the fixed members.
> 
> In the patch, we check dup->length % XFS_DIR2_DATA_ALIGN != 0 to make
> sure that dup is 8 byte aligned. And we also check the size of each entry
> is greater than xfs_dir2_data_entsize(mp, 1) which ensures that there is
> sufficient space to access fixed members. It should be noted that if the
> last object in the buffer is less than xfs_dir2_data_entsize(mp, 1) bytes
> in size it must be a dup entry of exactly XFS_DIR2_DATA_ALIGN bytes in
> length.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index dbcf58979a59..dd6d43cdf0c5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -178,6 +178,11 @@ __xfs_dir3_data_check(
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
>  
> +		if (offset > end - xfs_dir2_data_entsize(mp, 1))
> +			if (end - offset != XFS_DIR2_DATA_ALIGN ||
> +			    be16_to_cpu(dup->freetag) != XFS_DIR2_DATA_FREE_TAG)
> +				return __this_address;
> +

Needs {} around the if. With that fixed:

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
