Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354DA27EC7C
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751410514; cv=none; b=fYt/cNxaHhgOsryEp8ix61vlpdnYs2yjexsYGPbsOBZw2WsMwY5fLBP3RPlr7DpVk3zsFbFXwdATzXska1OfM75tcCcZ55Da1ycWMZzszFdRjXcNWGQ/Dd4MCIGJinaQGyVzo5SnH8/tKXJvMJf1tdc9G+CyvAKI3/GU17Ds5SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751410514; c=relaxed/simple;
	bh=FIN7X7J4wT6BrFxjJhwlBaCkTWTkK3Uj+qdWMn4DQ/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfPwyGG9glUTrA+3PnX8CtC9n2bcPGFiq0dGL6Juzggq/CRUXfOboGarMsu0oSNHDl9fHXU0MZyghf1zN7OQ4XqQDJ0QlZU8CcB/iaL4d0qCihibj6GRoBpZgeI0DH91X7V/j18Ar21zn/3ODNsdCxqbx974G88x7110/pFh5hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=MMR/8Qli; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="MMR/8Qli"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-235e1d710d8so73143775ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jul 2025 15:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1751410510; x=1752015310; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PZqhisyY0grSyd3DB0PY+kkM/dQgY+39MyYh+LITEWc=;
        b=MMR/8QliKlHkhpaOh710NKpsuPMuRY3CQqGPRT1g2dekicS6e5iokdZs2fHsHm/mIK
         /QM/mhquUvYaq9kJ56CF30/WdAu56hvTAgbAhQflTZozZgRuuUOpedpraO1Or6BU66ps
         Ltt8FobGGZ90c4Z0g/2+vt+hJKAb0b084BRTHOJ8rm6lzEx1KJ6IT/0ni1JaZ3Yqy+a6
         my2Pp/meozSqxkE75Wgcu71eBnRaf+OQJ6gwnwXPDFqXLG9B2DOdyDyybWjaADiWqdVw
         aMKGhZfzWs2AWhE/wVeXJMoCUdo6AeBYh+eI+CINJ59yl7R5mfE6Hz6/0nZXkkm9HvuK
         m9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751410510; x=1752015310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZqhisyY0grSyd3DB0PY+kkM/dQgY+39MyYh+LITEWc=;
        b=I6LF8++5vzZs/ATadGLGMkBvvRrBiAwFIRiZOm70Gnb5O/URMy0IUzvRfTl2BBTwVY
         9GKBJZ+db/drZABkEnAOpBBS1Vsv9HQLxGkhljUScxCBdsi22OUQwB5OzkiW2K4/Ym4y
         QivO/hRV8SUS7n09yfx7oBbca9OBBc+UPqtU5X+itcZAZ5loRcY96XAZa5liuNyloIDG
         PUPQ8d7h48ICD2YP1BRxtRUIZ4nZTs87xiqAxhlCpJFa/lGiUlz7bG71B3nGTlMFQrz8
         vnzNl+H7yxW5A0GMV/8FePINQVjCTGhWF7+TmNak0mfGiswo+saJUJu/MI01Vaub+F2T
         bHtg==
X-Forwarded-Encrypted: i=1; AJvYcCXPwr3fTq/2xn3CH43Q4zJjsSKE/48l+Eib6e3yoUTJ28zwhmsZ99PtN7Xy3abMDQl2an7Kt9edQuw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7J8XG1UIdUWfrfqfl/7xAmwvjHper0pl5xhdX5aWo3bbxndCS
	dCZsEorPSV67DCG9vwNeQUJIR3MFLyboew+SJofPthvHinwNo1J6GO+qgrGD/Ed4dto=
X-Gm-Gg: ASbGncvEDMQSmD6/pPR40hOsw46DvqOmcqrl6UptyZq0/v2I6/GnTV9pRRWETzEy0YB
	du5UKKrwzK9JLobaOZcpFPhRgXnpsiC1zcgOnjmA3xgSJmtS2ii67QndNtTqNes6fqk2DJehXR2
	hIf6wvY9XYAU2NTxa3TLhdMUGtjfcqxvRUm6hXuJp1TUZO9+UctFbIcYVXYhuxUJwdZYY67sMO2
	1i8p2rEuhcqT516I1Q6Ge0dD/21Z6lMRnd490Z+r9VM8ZGXiZDk9vLEqDDCWJVp7Bh4CPY0jJPx
	UD5rXyO22ZU8x7SauSBfPTw7+WSZFrCOvl9C23H68rpc+xcIMwnuyWqwkszRLaCondjkJxSLQn0
	6LAPUjlGspBwn3OjoHDT3OrS26ApH13J+FA/BLg==
X-Google-Smtp-Source: AGHT+IGM5cvaEkzGJnkJeG2GL/ZUD/JKTPykXQ7jLLqkIAhqAo2fZ3s0mck8iN3H0+kZ0sKFuONOpQ==
X-Received: by 2002:a17:903:2443:b0:235:c9ef:c9e1 with SMTP id d9443c01a7336-23c6e4e35a7mr6714835ad.5.1751410510380;
        Tue, 01 Jul 2025 15:55:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb39bfb3sm118719315ad.113.2025.07.01.15.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 15:55:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uWjsY-00000005io0-3Ofg;
	Wed, 02 Jul 2025 08:55:06 +1000
Date: Wed, 2 Jul 2025 08:55:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <aGRnSpmkl-C7iMXp@dread.disaster.area>
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701104125.1681798-8-hch@lst.de>

On Tue, Jul 01, 2025 at 12:40:41PM +0200, Christoph Hellwig wrote:
> The file system only has a single file system sector size.  Read that

This is still an incorrect assertion.

We still have the exact same notion of two different sector sizes
for the data device - one for metadata alignment (from the sb) and
a different one for data (direct IO) alignment (from the bdev).

Removing the abstraction and the comment that explains this does not
make this fundamental data vs metadata sector size difference
within the data device buftarg and betweeen different buftargs
go away.

All you are doing is changing the way this differentiation is
implemented - it's making the data device metadata sector size an
implicit property of *all* buftargs, rather than an explicit
property defined at buftarg instantiation.

IOWs, you are removing an explicit abstraction that exists for
correctness and replacing it with a fixed value that isn't correct
for all buftargs in the filesystem.

> Read that
> from the in-core super block to avoid confusion about the two different
> "sector sizes" stored in the buftarg.  Note that this loosens the
> alignment asserts for memory backed buftargs that set the page size here.

I think you got that wrong, because ....


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c     | 20 +++++---------------
>  fs/xfs/xfs_buf.h     | 15 ---------------
>  fs/xfs/xfs_buf_mem.c |  2 --
>  3 files changed, 5 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b73da43f489c..0f20d9514d0d 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -387,17 +387,18 @@ xfs_buf_map_verify(
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map)
>  {
> +	struct xfs_mount	*mp = btp->bt_mount;
>  	xfs_daddr_t		eofs;
>  
>  	/* Check for IOs smaller than the sector size / not sector aligned */
> -	ASSERT(!(BBTOB(map->bm_len) < btp->bt_meta_sectorsize));
> -	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
> +	ASSERT(!(BBTOB(map->bm_len) < mp->m_sb.sb_sectsize));
> +	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)(mp->m_sb.sb_sectsize - 1)));

.... these asserts will fire for single block XMBUF buffers because
PAGE_SIZE < mp->m_sb.sb_sectsize when the metadata sector size is
larger than PAGE_SIZE....

Fundamentally, using mp->m_sb.sb_sectsize for all buftargs is simply
wrong. Buftargs have different sector sizes, and we should continue
to encapsulate this in the buftarg.

Also, I can see no obvious reason for getting rid of this
abstraction and none has been given. It doesn't make the code any
cleaner, and it introduces an incorrect implicit assumption in the
buffer cache code (i.e. that every buftarg has the same sector
size). Hence I don't think we actually should be "cleaning up" this
code like this...

Now, if there's some other functional reason for doing this change
that hasn't been stated, let's talk about the change in that
context. Can you explain why this is necessary?

But as a straight cleanup it makes no sense...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
