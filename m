Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDEE376
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 00:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068938; cv=none; b=kQj9Usv4BumxDPt+q/kjPXsAEmaZsFehFAAZ9vmnL8b1y5BxJiPZgQ5A6tukoblWlerPAL8ol5EVxmWJGCjnCElLwNUMznMhbDcGv5Z+X1/RRH9ZyCqChi0kOh9DnBbLNPZ86WfFSRXwBIydgSmTsYbTWZkkfsIQ53G8+H3e9j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068938; c=relaxed/simple;
	bh=xQxNJ8kCfHsspZRGjTsPfFSY9/ylcF3uSoL/Qrvc1Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D+cPJ//oreUUe3R5sw0W7waJZZPF+FXJAU1tWlVIloNmtgoDW6sIlbFBGkekcYvzDDOfCJy7BIQjMMU0zXdHXPCrscpfKFSu3GLaYZgsb4jlQLeMw5BXFLn/+qjoWjucfyRW5XCcFyZF9QT1pPdS0jd2iGzWVDtqJPd/a0bSaFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=PVTzpqZe; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="PVTzpqZe"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e74aa08d15so1102034b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 17:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711068937; x=1711673737; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=LKaT0mpcrx+UomlG3LljN5ozk489Jua0qlNeNCr81oY=;
        b=PVTzpqZetF+XoXNJDtnHSF4FSL4dR5MYlDG4k+6GVtraOJjvq8dpQD6viQ91drykhr
         kKMokbc+pObplRdY6hxP9z/bq4evA9ovOM0Q4yMU/CfZU9TnfI3a5S9k5SLfQTpotuFw
         +5ZhTYd8qQZEUdGxxNDCsAfqpu/EFy1VlGliMuPWYdK6eBWM66tzvOp6+EHXCRL9JeFI
         h67wNvFT0eCLdP3ORzWwYOK3OyhKHV8h2rBHA/heOEKeF9EUySMHr+MLuaOqQvVGB84S
         K3VM9aJ/x55gbdy/8lqZfyoF87mFVIflFaOPwn46H2KGXwK9Oglkq2smsbHPCvYYCkl4
         xgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711068937; x=1711673737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LKaT0mpcrx+UomlG3LljN5ozk489Jua0qlNeNCr81oY=;
        b=b9SP0XXJDyBOISrjr5pqK3ZHANaGWduHFq3Xj5xhqAjJB9bdw4A/rfatQIB82hs5Mz
         zT08WyvTPlvQ/JtMzm8dnnriB/jcSPswBqemk2oyqYYo3plrhz0n0GdYgthqCso+Tl/a
         3bOaz+QZU/yy+zuZGlv+Bs8cksxwCv6/rbctY3+cg6vxLpZAkoZaY0i3magQ5tgyl1TM
         3SjK+oLeRVQzdg/n5dEc0of54JBdjFiGrJ04KGK34R+8l/uMKP3RQ8j4VusgZvHIc+TW
         29KNgBM8tvmNVBwYFgLrURq16rp++p8YBzEFKAnpu8b0moDspPC4KfJLTTYKY2kAxvj0
         JQVw==
X-Forwarded-Encrypted: i=1; AJvYcCVC2Xn7z87NBgLQd1/5reI3jSwj1Sf4U5USXJ+bjaQNrETf0YD9abofhApx/cbBdC5aA9pVAiXbkVO93ZRHwhgK6BK5aHgMS0Iz
X-Gm-Message-State: AOJu0YyaTlJHEirj/t4FWojuDBQSdPb2HJoDdyRVJgG5FH5ih30n18Bc
	gHWHwMpaVBZ9m4pEa3mPz+dH9YMK6ussIzKPeFkfE2pEoKNBZFR7/nzvOYd3lbtS5mMthsKRuF+
	X
X-Google-Smtp-Source: AGHT+IHvHATkEeYQxUXiIjlxXj1Q4ib++fwVHVNEFbH9eAwvkcTnZijiSz0fbzn1bG7LZd+JvjVpLA==
X-Received: by 2002:a17:90b:1bcf:b0:29c:7769:419b with SMTP id oa15-20020a17090b1bcf00b0029c7769419bmr1065584pjb.9.1711068936677;
        Thu, 21 Mar 2024 17:55:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id p10-20020a17090a930a00b0029c61521eb5sm4245357pjo.43.2024.03.21.17.55.36
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 17:55:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnTC1-005TnO-2r
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 11:55:33 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 11:55:33 +1100
Resent-Message-ID: <ZfzXBe+0fT/VHbK6@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 08:05:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: compile out v4 support if disabled
Message-ID: <Zfn+CTA88U78hiQw@dread.disaster.area>
References: <20240319071952.682266-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319071952.682266-1-hch@lst.de>

On Tue, Mar 19, 2024 at 05:19:51PM +1000, Christoph Hellwig wrote:
> Add a strategic IS_ENABLED to let the compiler eliminate the unused
> non-crc code is CONFIG_XFS_SUPPORT_V4 is disabled.
> 
> This saves almost 20k worth of .text for my .config:
> 
> $ size xfs.o.*
>    text	   data	    bss	    dec	    hex	filename
> 1351126	 294836	    592	1646554	 191fda	xfs.o.new
> 1371453	 294868	    592	1666913	 196f61	xfs.o.old
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_mount.h |  7 ++++++-
>  fs/xfs/xfs_super.c | 22 +++++++++++++---------
>  2 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index e880aa48de68bb..24fe6e7913c49f 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -327,6 +327,12 @@ static inline void xfs_add_ ## name (struct xfs_mount *mp) \
>  	xfs_sb_version_add ## name(&mp->m_sb); \
>  }
>  
> +static inline bool xfs_has_crc(struct xfs_mount *mp)
> +{
> +	return IS_ENABLED(CONFIG_XFS_SUPPORT_V4) &&
> +		(mp->m_features & XFS_FEAT_CRC);
> +}

Is that right? This can only return true if V4 support is compiled
in, but it should be the other way around - always return true if
V4 support is not compiled in. i.e:

	if (!IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
		return true;
	return mp->m_features & XFS_FEAT_CRC;

-Dave.
-- 
Dave Chinner
david@fromorbit.com
