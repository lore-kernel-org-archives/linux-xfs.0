Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F6729B0
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 04:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728966433; cv=none; b=ZCZI5iXf9LXfnFaSol2IAKbM6tzuqq/EjXGaqrDwcRBJHMhUvRssYv3pxY+GSxtQ6q7uHy/RTzzzhmC9CQey0tH2vvcfKtLu3Flx+6n+OaqFmwSLMYZUWQSlvTjUEaslmowYHXoXK4fJ1uhpzjWYWiCiZUlAKxcOT9RkbRoWD78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728966433; c=relaxed/simple;
	bh=jjrDunnrYcToF4dwSn84Z4FNcsDjxBHic6Gnb9S/T6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITEDYR37/gmvAvS7qKqyNhpO6RS6SvF4lJcR3AbehnlMmcV9q7GBhdKKD6l9RRDcivisfcElkgPdW5Nbwx690HPrMupHOyrSg2bYvHCl/tz3PwPbu1C+pdxu6lnqeeJEystPH+QjAh2YOY5KIHsJqP6uW9Cx0BWh027Z3ymEWNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ULLB1dKS; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ULLB1dKS"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2e2ed59a35eso3502572a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 21:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728966431; x=1729571231; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QSr9sD/fhysut0XxpOXgihRKHZ/bFKylspXgt9gS3y0=;
        b=ULLB1dKSYWNVSiQ46kb78OD8+M3Gfma2xuACOLYo0ba0Cgqf44jh023zSGea5JZOmH
         XGiNMLplo+VxQTumqhP9jFX6U2TyfSIxuojtMdCebZXi6sgdQuchPVuPKmwTH3I9abSv
         48FDjFqXKPL184vvseqCp78vHWwosldraFwxk/lBF3yPejgkFejnp9CSyO67iArzvttV
         IHToydRUVwqqX7wxNska98pqpK2lZiF7BycuXgrWbzGVzh1QRrLhZhYtEzGhfZTGh0e+
         zO7+SZyERiRNRdJ94/t2OpvXqkxEUZA/FNyzna6FTg6iX+Q5HxgBSBDDaPtAqyQ3zRIE
         7f5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728966431; x=1729571231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSr9sD/fhysut0XxpOXgihRKHZ/bFKylspXgt9gS3y0=;
        b=o7PGQA8LPEbADcDSpSomBncnlWbLss0ADKI1us4Yjv7qH+YSnZWa196FJClqI5OQbR
         DjnZmnmDnJYpifjmV1823RpI0ZL242kf+7EkFO2FuDhZt47wi957Cdo45Wx9+AFQ3HSm
         R3f8s1niH/61qdiaVLMyVgMa287tSp4+3ocQ0zlzUyjdqll1ch8UgfJ6fYfI22FJjV5X
         vk85H+sxw9BWAWre1BRI/XR+KoGg/jq56N871NDyWz1YqZ2/sUqE1zC2e9Ca3MIxIlFB
         zyb7N1qRPe8g2xRTXZddHu5V5gP6d1it2UnOKJ7VEu+Kv23EfG1PIHrrs0PzRNGEpLU7
         4OIw==
X-Gm-Message-State: AOJu0YwBqW7AqHByI3nFUb1oFc90ZABQ5QboptmghG3d1IEi2k/VSXkq
	6AwN8vt5F8csUL71LTHoPD5RPbXsNyGlhT+O4OMAjLXtTmXZ0thrKiFOBjzbTTg=
X-Google-Smtp-Source: AGHT+IHmhBjRKJ0RAd68Pm3IUOM3T7Z83TsPLgqnuIE1NoxYjPx8bOfifES4cULkTPqi8Fw3/fpJ7g==
X-Received: by 2002:a17:90b:38c:b0:2e2:bb32:73eb with SMTP id 98e67ed59e1d1-2e2f0c550f7mr18044301a91.31.1728966430918;
        Mon, 14 Oct 2024 21:27:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e392e8cf1csm470519a91.6.2024.10.14.21.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 21:27:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0Z9I-000z6u-09;
	Tue, 15 Oct 2024 15:27:08 +1100
Date: Tue, 15 Oct 2024 15:27:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/28] xfs: undefine the sb_bad_features2 when metadir is
 enabled
Message-ID: <Zw3vHOiOBG28/vgv@dread.disaster.area>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642083.4176876.2034736773059229041.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860642083.4176876.2034736773059229041.stgit@frogsfrogsfrogs>

On Thu, Oct 10, 2024 at 05:49:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The metadir feature is a good opportunity to break from the past where
> we had to do this strange dance with sb_bad_features2 due to a past bug
> where the superblock was not kept aligned to a multiple of 8 bytes.
> 
> Therefore, stop this pretense when metadir is enabled.  We'll just set
> the incore and ondisk fields to zero, thereby freeing up 4 bytes of
> space in the superblock.  We'll reuse those 4 bytes later.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_format.h |   73 ++++++++++++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_sb.c     |   27 +++++++++++++---
>  fs/xfs/scrub/agheader.c    |    9 ++++-
>  3 files changed, 75 insertions(+), 34 deletions(-)

This is all pretty nasty. We are not short on space in the
superblock, so I'm not sure why we want to add all this complexity
just to save 4 bytes of space in the sueprblock.

In reality, the V5 superblock version has never had the
bad-features2 problem at all - it was something that happened and
was fixed long before V5 came along. Hence, IMO .....

> @@ -437,6 +446,18 @@ static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
>  	       (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
>  }
>  
> +/*
> + * Detect a mismatched features2 field.  Older kernels read/wrote
> + * this into the wrong slot, so to be safe we keep them in sync.
> + * Newer metadir filesystems have never had this bug, so the field is always
> + * zero.
> + */
> +static inline bool xfs_sb_has_mismatched_features2(const struct xfs_sb *sbp)
> +{
> +	return !xfs_sb_version_hasmetadir(sbp) &&
> +		sbp->sb_bad_features2 != sbp->sb_features2;
> +}

This could be:

static inline bool xfs_sb_has_mismatched_features2(const struct xfs_sb *sbp)
{
	return !xfs_sb_is_v5(sbp) &&
		sbp->sb_bad_features2 != sbp->sb_features2;
}

and nobody should notice anything changes. If we then check that
sbp->sb_bad_features2 == sbp->sb_features2 in the v5 section of
xfs_validate_sb_common(), all we'll catch is syzbot trying to do
stupid things to the feature fields on v5 filesystems....

Then we can add whatever new fields metadir needs at the end of
the superblock. That seems much cleaer than adding this
conditional handling of the field in when reading, writing and
verifying the superblock and when mounting the filesystem....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
