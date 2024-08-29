Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8188F38DE4
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 03:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724900618; cv=none; b=cUO3YbYAro5kpa77odNE5+Z0Y64e9giTyd9z+ytpwaUZxgRBASrfgpe9Ye93SoMWR21+BAi9RRIMfFIapu0UU10Vyw92ycgsE2oNouvQ77hN4kX9gHTepU3mSipjzv6CRtoTWahgyH9T4UHwJ8UrC61YLSleHpTX8aOIeQYHjws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724900618; c=relaxed/simple;
	bh=Y5TFWF6UZ5bQXyp+AvYM1eMv+pzyDjlsxCBBIQxDZRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hV7EepvJ4JgYvux/AJG6bhQC0GVanxYJiDtOEJEsQA47yjkSF4gWO6AQfBnI3fiVail6zsb5E4ji0/42+8bC6JrbLuVyGY8pm8PN4vwzew1whiBSfb04v6y9HcZSVLUn2G9ZIxQAkmuph7+nvJRSHxK9srB91PNm15xoUS2SKs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zV8Q8Kv0; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zV8Q8Kv0"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7ae3d7222d4so96619a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 20:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724900615; x=1725505415; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9/z6toI6voQ0IKlbU4L2/8KMYJeJaGPdDqgqk9fjkIQ=;
        b=zV8Q8Kv0tREVC0ieTlWeVUwMPIx0Jj6eJlilhSO2ALZjaw7oDA2tJfsWPGudI1y4DB
         WVWF6mEal/8hog63XImi5GyT9c6nXbOd//00lRGA+jJVyZZbuZjNy4y9GnQrf0L4Dnc/
         hce6YvhGkVm/D9tCqB1R9AUvH6irJMDi6gvJAM500CjcONe4t03oo0OlY00nwqkGN3OB
         BpBb+VB1/dB3Rmf7O+kITD9xPRO5vnGddjYtPkNc1QxM1tvzHAZM8L/ZKDdNTJ1ZREPD
         Ajq2oxokP+SuyTC2nTBq70/1RalT3h9RV051mPOswWX6iSUUbkB+nQcuXBpnCSY3mB3E
         MvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724900615; x=1725505415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9/z6toI6voQ0IKlbU4L2/8KMYJeJaGPdDqgqk9fjkIQ=;
        b=ru5H43HFqAKCeO0IXAWL4joQMvz9GvfjHbrclGPdsFYjyUTHV3tsFHYp9NPTuJ8xX2
         m4a2AU3IV1AMlBeJ/wnJkiuUPuCFqFVVV5Kfdexr6QmBXI+oaK1gmRL94N3zdym2EpFR
         cpzHxAtf5tc14EZ+/FX5trpq3iPHWyXZGCAu1UlJG8EfuvcG/o8nc1krfTZoNp9A8Ade
         IN0wqkxqfcr6yYpHYh6HdBgbjrhcx6bhX3n+33rOrL1u7IXI3tS9TWciYhLStEDj/xtK
         ArIPiJbQAuojSZtJ84GLKuWGeYyw6XMTvOhIMlguvsIs2jM1yLvo7qhri3F5N+0Vo7g4
         2Slw==
X-Forwarded-Encrypted: i=1; AJvYcCW+96o5C5duagmsnQiiQOZ90vbuKAdSrZpkwk7DLUNb6EB5MjuRrF8M2kDf/mceSdZnAdD1iCzRtrk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkVXFCFVeDLUXOmjbFsr83IZgvAg7GYzWfR6WUVYHpBq6hs1Ss
	OUDYKj6c3y3gdmlcaSLDWHj3tFI6Rr6p9x1w5pIv2RQCo2jdSWSpkJM2DXY9Fvo=
X-Google-Smtp-Source: AGHT+IGsjijU+KkW6jFzBT/TWTjdXr9y3F1MJJ71ZQJHmm+Lxp/ogvEjvW4gS5LrA1D6exxUROszQg==
X-Received: by 2002:a05:6a21:10a:b0:1c3:b143:303b with SMTP id adf61e73a8af0-1cce111d93emr1276501637.54.1724900614723;
        Wed, 28 Aug 2024 20:03:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-205152cd8d6sm1780325ad.71.2024.08.28.20.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 20:03:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjVRb-00GS83-3A;
	Thu, 29 Aug 2024 13:03:32 +1000
Date: Thu, 29 Aug 2024 13:03:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Brian Foster <bfoster@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: call xfs_flush_unmap_range from
 xfs_free_file_space
Message-ID: <Zs/lA5FJoF0Zd9Ip@dread.disaster.area>
References: <20240827065123.1762168-1-hch@lst.de>
 <20240827065123.1762168-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827065123.1762168-5-hch@lst.de>

On Tue, Aug 27, 2024 at 08:50:48AM +0200, Christoph Hellwig wrote:
> Call xfs_flush_unmap_range from xfs_free_file_space so that
> xfs_file_fallocate doesn't have to predict which mode will call it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_util.c |  8 ++++++++
>  fs/xfs/xfs_file.c      | 21 ---------------------
>  2 files changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index fe2e2c93097550..187a0dbda24fc4 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -848,6 +848,14 @@ xfs_free_file_space(
>  	if (len <= 0)	/* if nothing being freed */
>  		return 0;
>  
> +	/*
> +	 * Now AIO and DIO has drained we flush and (if necessary) invalidate
> +	 * the cached range over the first operation we are about to run.
> +	 */
> +	error = xfs_flush_unmap_range(ip, offset, len);
> +	if (error)
> +		return error;
> +
>  	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
>  	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);

Ok, so if we ever change the zeroing implementation to not punch a
hole first, we're going to have to make sure we add this to whatever
new zeroing implementation we have.

Can you leave a comment in the FALLOC_FL_ZERO_RANGE implementation
code that notes it currently relies on the xfs_flush_unmap_range()
in xfs_free_file_space() for correct operation?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
