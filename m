Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBE71E532
	for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 02:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717036737; cv=none; b=j0s4cTl2g8a02Balm/fwLKhSeD7eoHHz09ZvVdmY+QEiZ2kLZKBEm0+GPkdprOM/rc8pd0uUvPbiOXQrSM6PMBPyWk1bLlbPJxf93e8NxhxoFBiJGfUuBo56J8wIA8GOfWg7kKo5FpwkpHEw6grvvyuF40YLm7rinNulsS9WqSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717036737; c=relaxed/simple;
	bh=Q/31yCirymVBI2YViEr4qdTdSf8JedHH1i1ZJk2y9ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAdhirJAh2iHwzUBej5jezIzpjV9RV81KsPyCDIOgXXCWApP4uNFXI9xmVXVS7lMCdmGVG2bZl6HlcjSTC7LgdOAD7C/Tm9Hi5vKB2uN6DHOca4ifkqVYcevM8QezEFJKHfsFOo+Qe8PR0DOCPCSBPnlesZzrgY7EQL18FoWJe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=lqdeddqX; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="lqdeddqX"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f449f09476so4235275ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2024 19:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717036734; x=1717641534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ppBBu5LaZz4wo7FnSHN66dsSof8Rs64ULcNB2HlY5dI=;
        b=lqdeddqXXxqy7Qe1SIdQ1qEl6kLAituNMsZFewgjiK8Dwj6+CY2N406FJTYYeLBPm7
         fawMdv4urOm3RwTkwyazfbL0rvAUFDhAGmMZAE18bI9Nm/LND07Wntt2CTeA+3t0dm0y
         A7qPWp5zBIYL4EeZfO6cZSfH+pjWGD45L8kf6k8A016JNAvT+Np9ay6MSbnCJUVBSo0/
         zRYS2YzRemANrLTQCHMHA9jcd2uArgyWjvM+hvMFLxkUWKLiAzKejGXm65umq83dZ3mU
         PhAtfee2FJynDMWB0wswK4TXNeB200TKDmLwB1K4dP9I3h27Snje9UsaqjDrgY6c1sZ1
         ZfEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717036734; x=1717641534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppBBu5LaZz4wo7FnSHN66dsSof8Rs64ULcNB2HlY5dI=;
        b=v8bQTEsoeUuQifBbDU8Cvxs8enFncXxwlCXgL8TF+SkP7HUIhg3M5CxcMBN9E90dce
         k2I5HeMsXhAAnvLrM/xFIWKgkGkSAgkfUUciVhDS6eOLN/6i3No+AupG2EtlIR/QN0vq
         T0e4mqrxUzeWA5AhcofmyTNLTBmJlLIQ3JHLx6yfvq6XFUjUWJOHFC251XR3yZcAhTem
         PFTCLuCH7BhJF1gxIA3GapuNm+zhXzJhPMtRQyR6ELCOmb1XZ+fdCZreVnl036YQMPJX
         AnmgNTqDd/Bel9qijq1esBUBiCVIJk3f/ru+Pd6vL70mjC+QF/HkbXX1Pael81Ef7V4P
         WGog==
X-Forwarded-Encrypted: i=1; AJvYcCUS3I7VsPsMbSZCB57+FujtE7Ky5RNNTe70foVFdCc2NpM0G8CRYNGhw6mzmc/5I14QPEwMWDaD5o573t30wnCyf+WQGqR32YNL
X-Gm-Message-State: AOJu0YxKcx3CkAwJpAxxefGXkvkINlm713LAxRdMaxCcZlkZT7nRAUR5
	QcIVHTmn5ThllZpDaMZmY7g3b4tUjejN+7MXunT5shlfgnUqVuIhP2Q3j9TiqHw=
X-Google-Smtp-Source: AGHT+IGecJkb1XKYQ/t4NHjIXM8DqZAOjsPmEgsxzymaAnYX0uwXmGoCKg6ApPwZf7uczSkXKBxEnw==
X-Received: by 2002:a17:902:680e:b0:1f4:af80:7a3a with SMTP id d9443c01a7336-1f61bf8fa40mr9053485ad.25.1717036734366;
        Wed, 29 May 2024 19:38:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c75ffc6sm107067105ad.9.2024.05.29.19.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 19:38:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sCVgp-00FJcb-19;
	Thu, 30 May 2024 12:38:51 +1000
Date: Thu, 30 May 2024 12:38:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: lei lu <llfamsec@gmail.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: don't walk off the end of a directory data block
Message-ID: <Zlfmu4/kVJxZ/J7B@dread.disaster.area>
References: <20240529225736.21028-1-llfamsec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529225736.21028-1-llfamsec@gmail.com>

On Thu, May 30, 2024 at 06:57:36AM +0800, lei lu wrote:
> This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
> to make sure don't stray beyond valid memory region. It just checks start
> offset < end without checking end offset < end.

Well, it does do this checking, but it assumes that the dup/dep
headers fit in the buffer because of entry size and alignment
constraints.

> So if last entry is
> xfs_dir2_data_unused, and is located at the end of ag.

Not sure what this means.

> We can change
> dup->length to dup->length-1 and leave 1 byte of space.

Ah, so not a real-world issue in any way.

Regardless, this is the corruption we are failing to catch.  All the
structures in the directory name area should be 8 byte aligned, and
we should be catching dup->length % XFS_DIR2_DATA_ALIGN != 0 and
reporting that as corruption.

This also means that the smallest valid length for dup->length is
xfs_dir2_data_entsize(mp, 1), except if it is the last entry in the
block (i.e. at end - offset == XFS_DIR2_DATA_ALIGN), in which case
it may be XFS_DIR2_DATA_ALIGN bytes in length.

IOWs, we're failing to check for both the alignment and the size
constraints on the dup->length field, and that's the problem we need
to fix to address the out of bounds read error being reported.

Can you please rework the patch to catch the corruption you induced
at the exact point we are processing the corrupt object, rather than
try to catch an overrun that might happen several iterations after
the corrupt object itself was processed?

> In the next
> traversal, this space will be considered as dup or dep. We may encounter
> an out-of-bound read when accessing the fixed members.

Verifiers are supposed to validate each object in the structure is
within specification, not be coded simply to prevent out of bounds
accesses. i.e. if the next traversal trips over an out of bounds
access, then one of the previous iobject verifications failed to
detect an out of bounds value that it should not have missed.

> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index dbcf58979a59..08c18e0c1baa 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -178,6 +178,9 @@ __xfs_dir3_data_check(
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
>  
> +		if (offset + sizeof(*dup) > end)
> +			return __this_address;
> +
>  		/*
>  		 * If it's unused, look for the space in the bestfree table.
>  		 * If we find it, account for that, else make sure it
> @@ -210,6 +213,10 @@ __xfs_dir3_data_check(
>  			lastfree = 1;
>  			continue;
>  		}
> +
> +		if (offset + sizeof(*dep) > end)
> +			return __this_address;

That doesn't look correct - dep has a variable sized array and tail
packed information in it that sizeof(*dep) doesn't take into
account. The actual size of the dep structure we need to consider
here is going to be a minimum sized entry -
xfs_dir2_data_entsize(mp, 1) - as anything smaller than this size is
definitely invalid and we shouldn't attempt to decode any of it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
