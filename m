Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D5C202F8D
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 20:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730235299; cv=none; b=Lyt3/oQy7y0rZreKJqfBkwlwsbut9/P1DOncqcmglwHY5R54zOm3gONqsZcMs1UdQXi2fIPQrQW1dVE2MWlyKQCP57ViAKOJdMzuuqfBNpqI3m0+oVnubzsVfO+CbB2dTl6diK1PX7A2KxNm2l34zaRKpS9QwHDNzYdNLOB1s2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730235299; c=relaxed/simple;
	bh=tEFsgg0WbA5wsbwUTObpEL2xlIVzTXGxExe1VoC8omo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQDmntsE5QtrtcFxMtQo7i0AdcuKxm2mNr8hwvJWoHrKzuV30wxIws77etvoGy0cgfN45/yQmWiuQ3i7O91yBxHL7NmqVlm7TGf5gSLxuIod0FZp2VIPJkBfI4JRvDAq9Q+B4X3heQIm9qiFVyKK7oPVDfyA9AL06/M0gdQV9aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=gNv/3muf; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gNv/3muf"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7ee11ff7210so1249314a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 13:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730235296; x=1730840096; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hgvfv4KMjPqGu5RsMXNUp8cKF2CFokczBlPhgy1p7RU=;
        b=gNv/3mufzk6sKqCg6ztpP7FGYGXJ1bOhGSX7BwwtwN34MJ4in+YMEAp2wZpC2owE4T
         Y4Pw2vMgqHuNCZryRqE6Di/mJeGWbWFUKlNvVxBfwjIPGkMVol8l0UkUaG538OmGwtEr
         eG8ANZj9aMKEeXHja1rn05Gd4rlWLjw+ODJuL6jARvpHTbs6qwmJR776SgzyEGCQUbWS
         XjRXeo87njvwq4Qw0cdlS7IwAR+LKH5HnE84X1p0/LnrWBApM7IbYtmBmLrseh2qCFMe
         WDvEOQsDQNeP9CWitxNv0sBi7sN5t4r4OUoigFfh26hsQMMpEssP8pB0+tPNpsjR1Da0
         kC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730235296; x=1730840096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hgvfv4KMjPqGu5RsMXNUp8cKF2CFokczBlPhgy1p7RU=;
        b=PT+xBrIc9CZEVz/SdTykqrx3rOeaXget2hFlxtuTiqlAGEawOeoVQUCpYw29ODERMd
         p3Zjq76JEUylqTnnfsWnMDV2wQq4rJNVM4hdLbMDIJBu8azxnqxa5Jwp8nlhm03sILAX
         XrdHkpp+UeWdLlU0p5k356azatjaSLlA+ZudORyry5klJrZVfekQ45ReP12arX6nCiBL
         K4bHPetVZx1/LFb1SWXp0dPYplcH5OlbZufY2p6IIarsMCJCNHsSz2K8aFC8agU2vbNZ
         VUQmtmL8iHRd9A6q07rHiX6cHvxPyTrXbA68Na463kzzRMeSCvc6wLTQ5FGMRn4pjQaY
         PvAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDC+eOvqqKMRfjXz/rRK8+KBClXD3KiLhSNbw4/7iytNwyuIu1Ht9ZGS19r4LMQCBqFiOGF6TczgY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/YjL8jlnJFstDtA41ssTwMikD/aKxWE8qgwQg3OXOOYJTZ/fF
	G3zCZcB3qnfWms+iMkKy0G03q1qadN7PXTF42+d3PmiQBPJ3qkFYrVmFM/CZv3T0sz7fObg4/wg
	F
X-Google-Smtp-Source: AGHT+IEcS1ymha0Q+4ugqNzePMpBu//ibYzWnv2gD57NGK2hRigYyiY0cbFqHKZX9SAwBFMGPi3UmA==
X-Received: by 2002:a05:6a21:118e:b0:1d2:e889:1513 with SMTP id adf61e73a8af0-1d9a83d5a65mr18931343637.17.1730235296560;
        Tue, 29 Oct 2024 13:54:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa0f6edsm37917a91.1.2024.10.29.13.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 13:54:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t5tEr-007W82-1V;
	Wed, 30 Oct 2024 07:54:53 +1100
Date: Wed, 30 Oct 2024 07:54:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: misc page fault handler cleanups
Message-ID: <ZyFLnc88MFKnoL/X@dread.disaster.area>
References: <20241029151214.255015-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029151214.255015-1-hch@lst.de>

On Tue, Oct 29, 2024 at 04:11:56PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> I recently started looking at the page fault handlers, and noticed
> that our code is still a convoluted mess even after my previous
> round of cleanups.
> 
> No bug fixes or speedups in this series, just pure cleanups.

Whole series looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
