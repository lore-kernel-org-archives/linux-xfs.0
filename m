Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6B51DC9AB
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 22:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957367; cv=none; b=jbCiS7kAIgbiIitHZtT+f6kMzmd8IwtTz014pbHVNMSs/DpJ8VjstmCZMvKRwsZ0o8KSF9D2n2xo7sx7VN2kNu0o2nN4Z2dZiQtzaouotX38ltNRCLuhnfpWZ2jkVSYOyX6dQQfCPVyXRrH7hMDEapbH4hp6+QxZJfY1f7j2ovk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957367; c=relaxed/simple;
	bh=hLgx/GHctPvBC5gT81L8mMes6QkXxyioquqWpo1tpa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/TeY+EEuwl1nHI0LMODu7TtSz9+MpaK3mIjHp1Zsx1B0dzhjK6Ji1JpM5CTH1L5xgEma58Sof7xw80rpet4USbMIwDGh9oE/ek2q1vgj6OlhtBtiY8BBydZDIbW/9fP7sSfCk/0oQXRTRFwyw+nKPPGNNXlJoxmFSwV35cPOEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=XeDbUT9s; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XeDbUT9s"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-725ce7b82cbso3450b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 14:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733957365; x=1734562165; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fXmXLf7sd5V5uMi56Lp8HUf5AZDRP/3EUrkbHYOtNjY=;
        b=XeDbUT9sdZ7eJ5rTmaeTF82gnhBES+/JmhGjayz9pSRDDsOB/PH4iXE2Xv2LJB/uct
         YMIJpFd1vA7OwAMjCLa+Tde36WIAk6voUpgozqajYguR5ksxzX5BpR47AZj3IlViIWql
         XA17TbS0MC35dieelHwfpl35pIJs3pDkQsJTU7Y9B1r1SW6zSDZWj3hdyeHB+/P23tb4
         yWqCGSoYTLjzzo4FM+o0C7K89Y5K+JCb3piR/ZPWGZwqXug8R423G5dtLPiWtjWd/Cye
         uDYV0H2Kbym1Xk1UJ6GzGTp7s4EGRc4ZKITXBaq/bszsetK2liHMu9p9dPRW/IGdPdZr
         3BGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957365; x=1734562165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXmXLf7sd5V5uMi56Lp8HUf5AZDRP/3EUrkbHYOtNjY=;
        b=Y90H5vNl5MtNu2+L23KzbpasOL2dOMpR2Ynyaq9302AnapoXfDBNUnKQjyM8xJKDZg
         rrtGHG8j5QmzAwJSD7I/iLyqsiJAI4FgfjnV/b14LcdnEaSireTFFcBp9kt5OcWykKjR
         fTLh6LskLVGZlZ/+8lRFUBHKhWE1YQEahFUvIpLkodH8jy7cIAmyYBcGYPNzrV49bsfB
         AX1f05WOBLRHki6E/rvVUImaaEdvV9cyUCbTEU331zd6QhtVVp5QQq8H+qfqzBxQsVQW
         bVAuzfPc6630hbnuVyzCrLFyKnIwz8zgHAVOI8nSCL+BKie/a7Cx01ob/j6GZZ4v+iJ9
         +z8w==
X-Forwarded-Encrypted: i=1; AJvYcCWMzraabtQT6SU9MYRNVJVjl+nU3urFqdfmwCnbaKr7BYU97A1hZsLt3i1iJaBT2GjNcOnA/KFVRBg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5MNN/8NNbO9q8erXl9a6lgwlzJ1hfMakhQsi058cYWm4NKKuF
	lX/OmZ+rWEraZGMfBjR03hoGzOwm0vKbUmrDoymZrVywAuUBNWD5OSTQWAnMbmg=
X-Gm-Gg: ASbGncurOKqd9eg0Ufk/vBDWdXC0uKVYQZgsZXhx1SbQ345WOh9zDEhXbLb+zU3fTpF
	yoAhEkYu8/fC1cQX9X9x0ANIFc1rOAIGmzez+Rrd4ZFQOiyRAqb1vZ3g1wp4hy4QeaftB+cF2yO
	SuPEqwr+R0vMWEtewnU9/9WWjA+jiMgqgPOSIK9FlZZELryh+GkLr4X74c7yshOl1kurSkBeotp
	G6SuxB+i9XTH+OXWLWLmvSYSxSZquPKe31lf0TLYA+KVHiGgjsP6a4iNCaPS/HMWBiP6noATKSn
	Gr4wydCik/AaDzoFokwm5Zcxsz29IA==
X-Google-Smtp-Source: AGHT+IHOEVAuUDLvH3fqF5/aEiPkx8MMVDQvX2O7ilQPH0RNIkQt4BmREe417EpJ8+GJSNy3blDmcg==
X-Received: by 2002:a05:6a00:1790:b0:725:cfd0:dffa with SMTP id d2e1a72fcca58-728fa9c9addmr1645480b3a.5.1733957365450;
        Wed, 11 Dec 2024 14:49:25 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725e3369c62sm7010447b3a.167.2024.12.11.14.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 14:49:24 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tLVWD-00000009ZUb-378O;
	Thu, 12 Dec 2024 09:49:21 +1100
Date: Thu, 12 Dec 2024 09:49:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Filipe Manana <fdmanana@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Bug when attempting to active swap file that used to be
 cloned/shared
Message-ID: <Z1oW8SiW3sq2dVps@dread.disaster.area>
References: <CAL3q7H7cURmnkJfUUx44HM3q=xKmqHb80eRdisErD_x8rU4+0Q@mail.gmail.com>
 <20241211182456.GF6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211182456.GF6678@frogsfrogsfrogs>

On Wed, Dec 11, 2024 at 10:24:56AM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 02:49:08PM +0000, Filipe Manana wrote:
> > Hello,
> > 
> > While looking at a btrfs bug where we fail to active a swap file that
> > used to have shared extents, I noticed xfs has the same bug, however
> > the test fails intermittently, suggesting some sort of race.
> 
> I bet swapon is racing with inodegc unmapping the extents from the
> previously rm'd files.

Almost certainly the case.  All sync does is stabilise the unlinked
lists so recovery will see the unlinked inodes; it has no effect on
expediting background inodegc, nor should it.

> The fix for this is (probably?) to call
> xfs_inodegc_flush from xfs_iomap_swapfile_activate... though that might
> be involved, since iirc at that point we hold the swapfile's IOLOCK.

For this sort of artificial test, freeze and unfreeze to ensure that
the background inodegc is drained before the swapon command is run.
It's not clear to me that there is a real world use case where this
is actually a problem, so for testing purposes a freeze before
swapon seems like the right way to go here...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
