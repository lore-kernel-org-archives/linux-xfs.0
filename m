Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFDCD527
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 01:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715390264; cv=none; b=EXnh5bNQia1gHtql2aYWgEoj3SGPcMfLDUPwAEn3Qx6cfBJ33P09+bcupvXMzH2+y+2EYWC2YwNJDfnKY+/30sWoP3zVcvhtGmiOWKi4kF7WshhybVE5upQHN8g+8uK+EWvCZNET+1Tft4waGr8tGTDqSfGhzP0tIjTpVLDMfBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715390264; c=relaxed/simple;
	bh=kt4heYCllf1PlwhBamDh5k7QXjaclippDRceqQmndHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PYtXF4IpFT1rcxtijJ7wT4UFqunADTyJWG32Z28g6S88EPksdwALbqFy/K7gE5M4Ye49X1qgMrSrAlzM3OCwfGY10zmfiESJJkeNG0ft4lxaQULCV15bARs3UNGwmx1OD01Tqyaf6Dw8sBigwrGytxLDptSaFxVMtPd/ERnVY4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=hmp7in1t; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="hmp7in1t"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5b2761611e8so1310090eaf.2
        for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 18:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1715390261; x=1715995061; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PkL5/fF9wylHziOl6jbXQLl72UMrGsveMDh9hjhc+MM=;
        b=hmp7in1tPlABb/LxDsPqkkTE5CU2KXPukHYSxhsjRnKYA9OLsmK9zIeGyR/NXlt8at
         bMPhPkeDKqZ7j5ClG9YKMrdTy1OIsFKA6rno/Faqr9K8yVfZNYojVd6Xg0Y1l3orFu3d
         hIaohADwm4FPyyp/FPdJM5v8y7Erj/MJZ7K4L4PX1/uzyyBb19RhVgAEnJqTMSQN6baj
         WV9wGqahc9HL8MX7bogYcRvvYfSt+zNks9blMo/E3+ChSCfldDwyiVHVmbULCPyq0oB/
         C+tKKZy0MvoczS4Urebj3ch5F9lgPWs72Bb/V2K6wfSJOZYZNHNTR+2skFbL56D4G1dp
         LGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715390261; x=1715995061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkL5/fF9wylHziOl6jbXQLl72UMrGsveMDh9hjhc+MM=;
        b=JI7vILca4X4r2AcIciOKtjHt4TBH6jU0R+xrK9X0JfHH6huEmSX4LjXKP/WWLZsx2X
         aUOh26LMCK/zdzxvz8Sw6R2eihKd9OOW9vgJMKJkD0S36PegZ2cSiZ3FWwDMSpskK4J8
         DY1JA3VHmNEdAUpKEDgtDL2/nWXcv7HtdlJP2zfSXQq4rjLUbBnfyjA7xuuyHXR/vuVY
         Sq0Or1C/FkusVgriaj12taqQ9t9ZpnBjSM/HGgtsw+hz2yLBdB/yUhxp1hGOFhEsH1eH
         5Hs1uUZEDFXouJdrmYx8JzE+oKQa38psf755Uc1Ru/tcpzsYD+yO+ESJ5bgsC7bl2Kp0
         5hAw==
X-Gm-Message-State: AOJu0YxBhUsDB8uuldUowPUi6xiuuiebHd5dzOHfDMiS4kg5yX8CSMC9
	uX2hNqWJUkA+GVwNsAcCl6uJXUOdrIB7ZwTkd/K/Q6/YHPMjSLFfzBKXKnpUCT6XseegOsFMUB/
	x
X-Google-Smtp-Source: AGHT+IEwbpibPgfCitKULiHA+OIp8LEQgZidkyGugT/R8cbOh/DbCBaE4LjkoEndbp8eougl+401Nw==
X-Received: by 2002:a05:6871:891:b0:23b:1dd5:3df3 with SMTP id 586e51a60fabf-24172e41d40mr5469360fac.37.1715390260866;
        Fri, 10 May 2024 18:17:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2ade270sm3542668b3a.119.2024.05.10.18.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 18:17:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s5bMj-00AoAK-1S;
	Sat, 11 May 2024 11:17:33 +1000
Date: Sat, 11 May 2024 11:17:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: make sure sb_fdblocks is non-negative
Message-ID: <Zj7HLZ5Mp5SjhvrH@dread.disaster.area>
References: <20240511003426.13858-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240511003426.13858-1-wen.gang.wang@oracle.com>

On Fri, May 10, 2024 at 05:34:26PM -0700, Wengang Wang wrote:
> when writting super block to disk (in xfs_log_sb), sb_fdblocks is fetched from
> m_fdblocks without any lock. As m_fdblocks can experience a positive -> negativ
>  -> positive changing when the FS reaches fullness (see xfs_mod_fdblocks)
> So there is a chance that sb_fdblocks is negative, and because sb_fdblocks is
> type of unsigned long long, it reads super big. And sb_fdblocks being bigger
> than sb_dblocks is a problem during log recovery, xfs_validate_sb_write()
> complains.
> 
> Fix:
> As sb_fdblocks will be re-calculated during mount when lazysbcount is enabled,
> We just need to make xfs_validate_sb_write() happy -- make sure sb_fdblocks is
> not genative.

Ok, I have no problems with the change being made, but I'm unclear
on why we care if these values get logged as large positive numbers?

The comment above this code explains that these counts are known to
be inaccurate and so are not trusted. i.e. they will be corrected
post-log recovery if they are recovered from the log:

	 * Lazy sb counters don't update the in-core superblock so do that now.
         * If this is at unmount, the counters will be exactly correct, but at
         * any other time they will only be ballpark correct because of
         * reservations that have been taken out percpu counters. If we have an
         * unclean shutdown, this will be corrected by log recovery rebuilding
         * the counters from the AGF block counts.

IOWs journal recovery doesn't actually care what these values are,
so what actually goes wrong if this sum returns a negative value?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
