Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A5E54F88
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 23:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708386437; cv=none; b=TIBSmeiLArMcpjHdzlmCPeOWIBOMvaT18Fm44zOzVtWvvYzxzJBCQ9Hm9JcSb5Ls8QE3qDHw+anAAiV/vXvlcVImTJ82Nc549hjx2ToQNhTq9c5aEgPdKrJ5ZiUA/h2owpfSjo2WWw/uounbO0PGq1fOCrzhqfygPSTkRSV8/bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708386437; c=relaxed/simple;
	bh=EZFenuCmehn+h8iAPfFMsIFmzTGVJIklUadB2hqv61A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XzlOkqP7n5ZpRUtDWZ17VekMSibNy57CrlVlFIRPjGkmUxt/FZ9EqhwEeg7fRtllk80ywrFj+eYViuDnqDf/YbKOAc1TKLF+iGMWKFeCaGacvBZNUPblJzAzpA7oAcer/Z7eL3sK2ef0Ixnd1NMlwTxjApG7SNW+hVZhdKmo2DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=yzj7X0Wl; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="yzj7X0Wl"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e09143c7bdso2436979b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 15:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708386435; x=1708991235; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KPt2+GfeUoRj5gn9EjwOlPKG0sN6+AkzNBgIiHSjiTc=;
        b=yzj7X0WlBVWwP+7szBIxamGqFddGyg3n8xBtOKW0Lvgl3wNdsP5kAuM28pS7yBq8u4
         WdzpZIJb3jClG75G3Hv9Wm98flgqSQyBKcbUZex+l24cZ4Ze5eTuN0tt4FzghhkX7n6B
         tHq18QSFtXNQ15Y8ldOOPTTkuBkNyKNt9A6zDid3tBb3VlUVIt7MJqQjE3EoKSK8ip73
         GYHotMgwpbuzwKdqKgy5Igwud5Gyq2tf+tdFTWIvXwkyYI6KjQ7bXJUbyqGqZwUUbvWH
         DyRAR7jiluQ9Psr/3hvNHH3zprEK1HpAR2Ar8s5Cj5o1C8E80EaGeBSD5SQ/KYUt7BRJ
         Aszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708386435; x=1708991235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPt2+GfeUoRj5gn9EjwOlPKG0sN6+AkzNBgIiHSjiTc=;
        b=cO0fPeq/6Tam3qvU4jbFkINVdK0M4daYv1QS7BdfGXYwnHSFMw4M5wlcxFdADZ2FAb
         4VMD0i2vgXqmS8yRHZ9Zss+p19lKWxE5EGNtt7DTYj2ZJpq7kqu91cAUHrjeUECQKnOA
         q17gj858ofp8EJYN4AKcMukwKqdjTIVih/PyzoCeeWkWfxlzFf/eaU204ZUhI9tXAXUc
         Lzu1GA3CLfAJ5TvEgRyBq0BRCWWZvAQRBXn6gHWk0h2yK3f2fNEi780mZJwLO5Dapc5N
         sCsVgsCi2TF12eTzFFAy36cv3dHlbiOJdxoapLJLRD4kYw6URlhjyTUlvrz5ljRFZAD+
         IG9g==
X-Forwarded-Encrypted: i=1; AJvYcCUskXqJza4KXkP9FbcpVjPXq5Nr8xzTch1e/CWwHqJYDGsNguk1YhkgurNbCd6ng2IMqDZi3KkPZvJ7FGNixk6M/H/3OAY1fo8a
X-Gm-Message-State: AOJu0YwJVJUoRTZT/eol6oSRgbezhgHFF/MxUi9J9SKmSZMiH/qWckA/
	0n+g+Jw1iEE1NXW3zzsDdbOqkXzbF3x8XuT3qzOEQ2qAMJ9VCEkke9JmnUnyOGU=
X-Google-Smtp-Source: AGHT+IEEKUwyX/h/oYgZQAjibTFHmcCLlX24M6h0CLLzE7yTQh4xkXrRFn8/UQML8yo4FQC3AYm9yQ==
X-Received: by 2002:a05:6a20:f386:b0:19e:9cc9:1bef with SMTP id qr6-20020a056a20f38600b0019e9cc91befmr10349510pzb.22.1708386435564;
        Mon, 19 Feb 2024 15:47:15 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id u21-20020aa78395000000b006e0ad616be3sm5454917pfm.110.2024.02.19.15.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 15:47:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rcDLs-008pQy-1g;
	Tue, 20 Feb 2024 10:47:12 +1100
Date: Tue, 20 Feb 2024 10:47:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: stop the steal (of data blocks for RT indirect
 blocks)
Message-ID: <ZdPogLjdypKDgm0D@dread.disaster.area>
References: <20240219063450.3032254-1-hch@lst.de>
 <20240219063450.3032254-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219063450.3032254-9-hch@lst.de>

On Mon, Feb 19, 2024 at 07:34:49AM +0100, Christoph Hellwig wrote:
> When xfs_bmap_del_extent_delay has to split an indirect block it tries
> to steal blocks from the the part that gets unmapped to increase the
> indirect block reservation that now needs to cover for two extents
> instead of one.
> 
> This works perfectly fine on the data device, where the data and
> indirect blocks come from the same pool.  It has no chance of working
> when the inode sits on the RT device.  To support re-enabling delalloc
> for inodes on the RT device, make this behavior conditional on not
> beeing for rt extents.  For an RT extent try allocate new blocks or
> otherwise just give up.
> 
> Note that split of delalloc extents should only happen on writeback
> failure, as for other kinds of hole punching we first write back all
> data and thus convert the delalloc reservations covering the hole to
> a real allocation.
> 
> Note that restoring a quota reservation is always a bit problematic,
> but the force flag should take care of it.  That is, if we actually
> supported quota with the RT volume, which seems to not be the case
> at the moment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 8a84b7f0b55f38..a137abf435eeba 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4912,6 +4912,30 @@ xfs_bmap_del_extent_delay(
>  		WARN_ON_ONCE(!got_indlen || !new_indlen);
>  		stolen = xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen,
>  						       del->br_blockcount);
> +		if (isrt && stolen) {
> +			/*
> +			 * Ugg, we can't just steal reservations from the data
> +			 * blocks as the data blocks come from a different pool.
> +			 *
> +			 * So we have to try to increase out reservations here,
> +			 * and if that fails we have to fail the unmap.  To
> +			 * avoid that as much as possible dip into the reserve
> +			 * pool.
> +			 *
> +			 * Note that in theory the user/group/project could
> +			 * be over the quota limit in the meantime, thus we
> +			 * force the quota accounting even if it was over the
> +			 * limit.
> +			 */
> +			error = xfs_dec_fdblocks(mp, stolen, true);
> +			if (error) {
> +				ip->i_delayed_blks += del->br_blockcount;
> +				xfs_trans_reserve_quota_nblks(NULL, ip, 0,
> +						del->br_blockcount, true);
> +				return error;
> +			}
> +			xfs_mod_delalloc(ip, 0, stolen);
> +		}

Ok. If you delay the ip->i_delayed_blks and quota accounting until
after the incore extent tree updates are done, this code doesn't
need to undo anything and can just return an error. We should also
keep in mind that an error here will likely cause a filesystem
shutdown when the transaction is canceled....

FWIW, if we are going to do this for rt, we should probably also
consider do it for normal delalloc conversion when the indlen
reservation runs out due to excessive fragmentation of large
extents. Separate patch and all that, but it doesn't really make
sense to me to only do this for RT when we know it is also needed in
reare cases on non-rt workloads...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
