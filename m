Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC6B194C93
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 23:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714520125; cv=none; b=h58b7ePaIJ39HRt4Lx9/1d7ciS27P9BDPkfedU1/cWBrOPF+HUc6H1iKwKdb0CBDDc3JsosQV1rYU4evuHAzML4wxXV2ltIcZI37rTLb7rQwat6DGdaeVds0igtb8IGD8ORVN1sXMJg/KejhydoupIXd9zM0aqzJxnnJ/kR5XZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714520125; c=relaxed/simple;
	bh=zPLAG6BC9oqdmiJPIVvNKy2SbltyL+Qt1bdLKj01Us8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EpFSipJdFgWjymViSP8KZdAc4muIllFXjPsZs7lm1B3hdD/yxrE/ynGN2g2rGNZP8cijDWPUJ16df9OwAyvCXpmjS9MBEzGwrl2q2HtdPmm8GwbDX46DXFDfR0S1YwYvFXIaji/r0+ywrQIaPuzf/mls6Nnm21BjqyoSF5iJRbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=OB8Lb87u; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OB8Lb87u"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e4bf0b3e06so62813615ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 16:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714520122; x=1715124922; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ebJ+P7E3aPLzGdXLYVSI2foIXw8t4rGULdg+JhpGfGw=;
        b=OB8Lb87u/3QqijEVkcv43sf0DSe4BNdNBWcFn2i8Y8hMd4lHZY+sRMdDhkukp1CTZz
         bed9P3Hy6+rW4/hjOg7Uvp20Po4sBx/1vYyeDfXMG5q1TJk8RsuWUSLIcMSbp0a+GorD
         7jP2TknkPKtpd5J0E67wp+JCFFWh91KQI+Vv9WG5qPIqCzfIa+RXwwzZiBF0PIzs8lyf
         qJBJ22SUyol+9NBZYCWryewVVjv0LhYx+MjTj7CirvD+Dcpmy538+JFMk2kI2Z2J9/27
         xGJOI2HJsGC/lxRbdBqS9HLNqnwI+/wOzDpy8jJH/NK97f6pJ9RgDHa6dY9iXNLFE41H
         KX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714520122; x=1715124922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ebJ+P7E3aPLzGdXLYVSI2foIXw8t4rGULdg+JhpGfGw=;
        b=NrDLoyA4P8TlvjlrYUplwguKiUqGvqaUYM4x0OuOOn7xKCRIasIfUqEZPUlpMlfMZZ
         2UDoAGkO7LQwQ/dAxVA8Gty0STny5NmzyK95CpxzE7NsM8Saipk3X7XG8u342yoeh1ND
         /RlToic4xpoJtABZQjfjOS5OvC9EfbhjikWd2ei9AD4BopAEuwRllviQee/ao5knZtbp
         cXDxkpY27g2gpxiVuzJD9zb14NVGu6U2s362vdgCJVdyq+C+rjqd0TvSMAHA7bo17S3e
         RYbpvPLtqkptnzgv7auOqM4OCEeXegnB+pLX3krsPPBRC8I5guslP9jY6T7uPLW/5Bgt
         OV9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUaH0PfqJxF+KWUe+NW5+6grb6dtNTEu+8SQ0BDJxh/gzCBV+lep9WqM4kkyw+WXaWUciSGFl2ctJL9cHFqdtLS1NnjcGEFRZxl
X-Gm-Message-State: AOJu0YyYeQ4goAdsvT8uRX5LzyhPwelEPlkk+YHCMVS3nPoBTdDuLijz
	qxvPxs7V3r+WoM56h/DkJHsa0j5rOFrj9AYGJEDWfDt7quYjxRpzPUj5+AWe+cc=
X-Google-Smtp-Source: AGHT+IE3t6+966YIcpEKzQ8cccfZ2BAKj6uBcJiHH6Y92YMU+lJ5oaeNPKZc5ddIgEnzUQ298y/KoQ==
X-Received: by 2002:a17:902:bb17:b0:1ec:6b87:e125 with SMTP id im23-20020a170902bb1700b001ec6b87e125mr867641plb.50.1714520122398;
        Tue, 30 Apr 2024 16:35:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902c78900b001ea699b79cbsm1603839pla.213.2024.04.30.16.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 16:35:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s1x0J-00GjfX-18;
	Wed, 01 May 2024 09:35:19 +1000
Date: Wed, 1 May 2024 09:35:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: djwong@kernel.org, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, chandan.babu@oracle.com,
	willy@infradead.org, axboe@kernel.dk, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, jbongio@google.com, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, mcgrof@kernel.org, p.raghav@samsung.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH v3 10/21] xfs: Update xfs_is_falloc_aligned() mask for
 forcealign
Message-ID: <ZjGAN8g3yqH01g1w@dread.disaster.area>
References: <20240429174746.2132161-1-john.g.garry@oracle.com>
 <20240429174746.2132161-11-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429174746.2132161-11-john.g.garry@oracle.com>

On Mon, Apr 29, 2024 at 05:47:35PM +0000, John Garry wrote:
> For when forcealign is enabled, we want the alignment mask to cover an
> aligned extent, similar to rtvol.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/xfs/xfs_file.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 632653e00906..e81e01e6b22b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -61,7 +61,10 @@ xfs_is_falloc_aligned(
>  		}
>  		mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;
>  	} else {
> -		mask = mp->m_sb.sb_blocksize - 1;
> +		if (xfs_inode_has_forcealign(ip) && ip->i_extsize > 1)
> +			mask = (mp->m_sb.sb_blocksize * ip->i_extsize) - 1;
> +		else
> +			mask = mp->m_sb.sb_blocksize - 1;
>  	}
>  
>  	return !((pos | len) & mask);

I think this whole function needs to be rewritten so that
non-power-of-2 extent sizes are supported on both devices properly.

	xfs_extlen_t	fsbs = 1;
	u64		bytes;
	u32		mod;

	if (xfs_inode_has_forcealign(ip))
		fsbs = ip->i_extsize;
	else if (XFS_IS_REALTIME_INODE(ip))
		fsbs = mp->m_sb.sb_rextsize;

	bytes = XFS_FSB_TO_B(mp, fsbs);
	if (is_power_of_2(fsbs))
		return !((pos | len) & (bytes - 1));

	div_u64_rem(pos, bytes, &mod);
	if (mod)
		return false;
	div_u64_rem(len, bytes, &mod);
	return mod == 0;

-Dave.
-- 
Dave Chinner
david@fromorbit.com
