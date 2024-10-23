Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDB0146A79
	for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 21:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729719651; cv=none; b=L+2WcFZzHD1pdOSXDPzzltU2lyMtgSeLVz40mDPceIehu406jVc16bDzKfGABOpUqyUBv+dnGtDRcD6CQbguAW7qCTqy8Q2XjWYN5syJoBvZUJr8iX5dOeGa4NBuzzoZn5sLp893Ptln3u4Y6QaWns816BCufrQs6/0ogmNaoME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729719651; c=relaxed/simple;
	bh=u7qNqkZonnSvp7ClA0DeKMghlCwyitrvaOaNuB4FcbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Km9pCSBQkdC2VU3FEUHeR50/fVAaHFp0bq3frUvGKdkvetviTgKQeykeRx4jPTqCb9BbvPtcS7PFO1H17O0WCx+LL1JZWs7b5PkHDUpeq+ttbLdYTjE0pqrm5ssk7OgQNoGOf74PnTHrWIBrUQu/itdhtwAFe10jcrt0RoiXuqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xpJELMJG; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xpJELMJG"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-656d8b346d2so153062a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 14:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729719649; x=1730324449; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u2oLmoebaHd22qW9kE2Pu4y5QxkQQWqiWGihWrz8Dzc=;
        b=xpJELMJGynvvGp4wrN6KPtn9WXP9crzD8upxehWkeWe3eSKFaAwrOOTBKdLdgZ7UDv
         1dvdKjdebm/ueh4L+exYQL74PRjM2YNQIWGAL5o0Mxs7Dxc6gn5FejGBAiG7t6ohRTkT
         Q96gB6flKLhOKe4ZvPn5uW+TeBVzBznR+GX2oFsvEZSgzGkm1fE3mjDuDcGMLdBPgJCP
         LXRHWexQVnmE2SXno0cprZtoN+iqLnfu/XTKxpe/4nkmAUWoxgKhnqXK0lyB0mp1UUCV
         6PHGcJbcsSTfVS70jmDwhkWosz49dKJV0NJkoHkbeaWW8DDCfJMTea3xKVWZ08Hw4yXh
         mfOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729719649; x=1730324449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2oLmoebaHd22qW9kE2Pu4y5QxkQQWqiWGihWrz8Dzc=;
        b=L922ZdDrjfPyAjC5o9dOOmGkcDeGUke7E4CPb9dnB/xG0EzaQ1X3xWgF+m07EIROZw
         gP4nBvt14tPnYEjGMuDaYwsGSTxwavk/HHit9Ar8vdHNDhOtq2yKxLg/NgIHQ68gI/FP
         Vv6ivJH7/tXySbMAxuORzGlzBLmKaDlaISV/iFncV9jRyaht3SLcNjHWk9uV9exBs9S1
         phaBmHLIpMOsHnTN1oioIM8IAc3BZ758lodPc7rdHhb10Mwij/mIFi94ufs4aJUz2p+n
         L4xEw4rJ2mcHyx1QEn1yd2ORxw0lAucRyVFrZoOEw46BeTNqKnHDtyWr6HjmFGgdiuxS
         Yltg==
X-Forwarded-Encrypted: i=1; AJvYcCWwXOcdUJBvpBLUmAUUdq+VyBwRiYRUgam8uxuDHvnL3jqO6tLqZJPTeZgwHw6ReoSZWnndDL2Cpbc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+WDRl9+J3PcytWaqoxxkvRMezKnfiK7l7hXEaA98t7RnyfXFy
	qAWLT2SbW9ct2n3As/4HasqHJcXvhGyMYUxuQxGh398ZPH1uPVK3Bs2g/f5zfeU=
X-Google-Smtp-Source: AGHT+IHvN4QhykSh24DmNjd8Bg6qRKIapNxQgcZ238D2VrKJBVC56XITNzbgxUhxsOxRLXhVVlByOw==
X-Received: by 2002:a05:6a21:3942:b0:1d9:2bed:c7d8 with SMTP id adf61e73a8af0-1d978bd541cmr5002959637.43.1729719649330;
        Wed, 23 Oct 2024 14:40:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec13d73easm6778321b3a.111.2024.10.23.14.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 14:40:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t3j5u-004raK-1R;
	Thu, 24 Oct 2024 08:40:42 +1100
Date: Thu, 24 Oct 2024 08:40:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the post-EOF prealloc tests from the auto
 and quick groups
Message-ID: <ZxltWrUxkeuRq2I8@dread.disaster.area>
References: <20241023103930.432190-1-hch@lst.de>
 <20241023172351.GG21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023172351.GG21853@frogsfrogsfrogs>

On Wed, Oct 23, 2024 at 10:23:51AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 23, 2024 at 12:39:30PM +0200, Christoph Hellwig wrote:
> > These fail for various non-default configs like DAX, alwayscow and
> > small block sizes.
> 
> Shouldn't we selectively _notrun these tests for configurations where
> speculative/delayed allocations don't work?

Perhaps turning off speculative delalloc by adding the mount
option "-o allocsize=<1 fsb>" to these tests would result in them
always have the same behaviour?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
