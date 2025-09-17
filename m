Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99F3309EFD
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 21:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144407; cv=none; b=j8qIAfOcWWd/1IXBaa4ctOGybVTKzVPuhmdb+U24x/jp+hmkyDf4oOPolyLdi1A878RKr3d1hdMQL8eayufX31tnifpcYZLg+OkdA00faem09/UvQqkUyYcoDFZ7GdxW9IAK7O/h4bTDQjNWvdFfIfGsCrXjxSNsJ0jfV4kaZMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144407; c=relaxed/simple;
	bh=yk73yX/a7Y2h8MrObuSjXs15pvAKl+bQDqYK10y3drg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubHBI4OQ9nPbA+GuTvNRuI51Iw86Sgb4yEs3y9w8rmU1W5mlPH6v4TUdmNnGgCsyEBOexERfBy7Fol9adXnVx905rY3Qo6H3UY1PPI9vJ1s4x8nyvpkYp1bLwKiSzzRKwHgsD/Ef35cowPfo3HJU4pY8yBixEIDaF3OWjg3rpvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=OgAtEQO/; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OgAtEQO/"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b54fa17a9c0so158469a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 14:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758144405; x=1758749205; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kQq0gKzKzQdViY3BQEU/Fgvb3s2Z4O6ZhxzE9SPZUd0=;
        b=OgAtEQO/k41Y8o5dthjTIAQDwzm4qFp7q96BBMkVdYr3M7hMWXARugamKaGaWyI8Ll
         MM8lGK7/Olna61S9pTHtXN/t1g1Qhrj3LxZC1vrp3X7IJWlHMF8ORZ0XqhgmSYNATSXo
         cgC957ux4c3SIr7oRdua8YN0W82gTevfvf6/Uq6sTmZMh51garSLxqd5Ig70osqCTDoO
         lb/l3fg19V3hoiu12Ix9qKg/M1fJkC9aFzBCilTbhe2TTfRdCBbpX6XUAOlsTkPzTVLf
         lJpbR5hSWv4SXxfreXWfc1s/Er0L2exVSZvhF6GTJ/J19gSy/njLmiJ01ixHFE/e73ni
         dp2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758144405; x=1758749205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQq0gKzKzQdViY3BQEU/Fgvb3s2Z4O6ZhxzE9SPZUd0=;
        b=kMOO8XU3Lgxku5K6mh7UcK0pP5qf67k0igQiCs+SVUuBcC6X39vPBKjj39+SePKtZU
         vVD6sNIHM6cYh9LfBCDqhNMpBrbIzO080f2hBT5EemKf1ygMWEMN18FcU1AzjWP4aQ14
         3+M3tGP/3ASjllOxlIfVz4Al1wyod5yoWXt7Ub4c9egbQ9R2Q6/g9HfibjLbN1f0e100
         xphlZsEYInL0HmEtT9vwMduHWk2qXyp14cnoDDl2EERz5yS3AJDFSSDsgtDOSBg4FbWo
         yxdfvR/9MZa3982H26nAvxUzbbGpseTyZD3xvhXf6D8mWxWDzb/VmxldQuhSt34jQqiW
         llqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhrB8pqVdPTCTgcW0EfYCHjY/iz7AmtAn6S+OifAHpVVuMuns+WZ7XH2iddkFIDnEyk12+hkEjqmk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu9hdNxWH4UQXxu/gEdq4gfDn5qASHT3yH63aAMtzngdF5eUPS
	xlBLVwy+VRV2jYMeiwQhN9FwpEwyJ+huK7YsTpgczGGWM3jKScfTbQxSHOMFYmYAKEc=
X-Gm-Gg: ASbGncu/tnvzdClNdf4RjYFMFAc0sNRY4quJ4iRRx9stQR5xU7/RmD9R/rhBQA38Yqw
	W9nMqqFAXw/F9apMYE9zuv8Kub2tXfbC0lZZSt6JydFUV/mRiwutgBV/ezcFHsBfYyP8TSIylZt
	2lehJ71qxDvXkfBdHHljlZQeU9/1sodCmr4ipOkkLc2a6931Fz6aA0rgD6Fv0cBOvMcX5A70dyu
	p6mR9ZY/4wWqb0WlVIA6zfxxAxSjfEHgqk2axQ88iCDV2X2WA2lTQVjKi2X+r3eicp1jsV5LqLg
	PaS07cV0Kl7Cf/OxFMJxpyovdB+bYOcXB9F8rh66hSXJEn7naziS+N5HAtV9YSm3QdMoZnPVrX0
	u+ba/azhpzzr49EO4HPUyodHZSHiosHtEL8hvSdDWy9c4OqBKxMOdpdfz0PJja+wKBKG7bX/J+z
	J9Z//f2o8JsVxYhJKi
X-Google-Smtp-Source: AGHT+IERXS5smfi2R8HtQuK9X1h1drI0C18Dr6IjlWMi2WY3nBsE4xsSnAqq6yNtgVbiwenTdFm8Sw==
X-Received: by 2002:a17:902:e882:b0:269:7079:b56 with SMTP id d9443c01a7336-26970790d20mr25462325ad.38.1758144405199;
        Wed, 17 Sep 2025 14:26:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed26857a0sm3395408a91.2.2025.09.17.14.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 14:26:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uyzfl-00000003H9E-3EQo;
	Thu, 18 Sep 2025 07:26:41 +1000
Date: Thu, 18 Sep 2025 07:26:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: track the number of blocks in each buftarg
Message-ID: <aMsnkZwrMTDJdfEc@dread.disaster.area>
References: <20250916135235.218084-1-hch@lst.de>
 <20250916135235.218084-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916135235.218084-2-hch@lst.de>

On Tue, Sep 16, 2025 at 06:52:31AM -0700, Christoph Hellwig wrote:
> Add a bt_nr_blocks to track the number of blocks in each buftarg, and
> replace the check that hard codes sb_dblock in xfs_buf_map_verify with
> this new value so that it is correct for non-ddev buftargs.  The
> RT buftarg only has a superblock in the first block, so it is unlikely
> to trigger this, or are we likely to ever have enough blocks in the
> in-memory buftargs, but we might as well get the check right.
> 
> Fixes: 10616b806d1d ("xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c              | 38 +++++++++++++++++++----------------
>  fs/xfs/xfs_buf.h              |  4 +++-
>  fs/xfs/xfs_buf_item_recover.c |  7 +++++++
>  fs/xfs/xfs_super.c            |  7 ++++---
>  fs/xfs/xfs_trans.c            | 21 +++++++++----------
>  5 files changed, 45 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f9ef3b2a332a..b9b89f1243a0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -397,7 +397,7 @@ xfs_buf_map_verify(
>  	 * Corrupted block numbers can get through to here, unfortunately, so we
>  	 * have to check that the buffer falls within the filesystem bounds.
>  	 */
> -	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
> +	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_nr_blocks);

Why store the number of blocks in filesystem block units? The
buffer cache/buftarg uses daddr addressing, and this is the only
place in the whole buffer cache where we've needed to do filesystem
block to daddr unit conversion.

IMO it should be stored in daddr units to be consistent with all
other buffer cache addresses and length, with the conversion to
daddr units being done by the xfs_configure_buftarg() caller. This
gets rid of this unit conversion in the lookup fast path in addition
to removing to pointer chase through the mount to the superblock.

This means the only remaining fast path references to the xfs_mount
in the lookup path is the stats update code.  If the stats then got
moved to the buftarg, then we don't access the xfs_mount at all in
the buffer cache lookup path except when an error occurs...

Other than that, the code looks fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
