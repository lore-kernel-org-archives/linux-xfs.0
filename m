Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD02DCC0E
	for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 05:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747979026; cv=none; b=O25kSRSWbZkDxFOYFqdeModdiQjIcEBWnjGEoNAgApmVPqGBk7etFbggOs/up63TYEX0FwB0PZ6uq3B0MPfCNqJ8SPT+ESd5Y17c6LEvBrx7LabHpbtY6rQg7h+KSjrTy728zc4BD70TFHAojpGjYxYcfF+bCSRMw+jcTWFuSo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747979026; c=relaxed/simple;
	bh=kzTunbBSyxeMkMtZNtOuBaccehVz3kTna0dMg0X/jUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLSY0GFWmld5ht3H2Oqpy6M31A3bqzfJSsB1bKDBl2dVqh2XoGmvRHAOdf03FCsKqG2HoxCbEtDj7iiJIagZa1NCDugII53rTLJdjhWfeF1nmN/N2+ir3TfXMScraCF/1cMt8auUhUTLzOnQxpz308xeKSHA3Q5D/uMfB7mlN+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=iRjWGkjz; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="iRjWGkjz"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3081f72c271so7103116a91.0
        for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 22:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747979023; x=1748583823; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OCWpA/elf9cp/t9/ZJga/sACzr7NREB2M01hN9VaQTU=;
        b=iRjWGkjz8zCJ43+5ivpNgGTABOeQ6aoxRI+pMoBdndrhbwcP2zBHNfHQaVdl6420AF
         orfe6w7wv2wRl2FllFtMZdr3BYdqBG5t/YzDeWaDzDB5w3JPfjTLJ85jF3Eor2qnw/eM
         7UsGz6ecfpEqGVd4pbo5kiQQhW5l/42km779roNBb7uRgzvx+3GCppaldVeG4cY7QDS2
         g6oj84qE5vwCfq0lFz6j8MVg6LsEMRDd+LgodMH2kWhyi0LHbR/Bbdc4bqb/oWXkEb48
         6ZEevj9KtIk+V2RRU9j0+JNmxxp1XZmM87667SvJoi8qRHNjldkIeC2ylGIeDX2dv5Vp
         RmEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747979023; x=1748583823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCWpA/elf9cp/t9/ZJga/sACzr7NREB2M01hN9VaQTU=;
        b=A2Nnj+NWPPLM+IaPd5d6whYXhy/ePN6Axe5lWxb3lj3i05Wle98L4GAOYYSWX/hmch
         2KrJr79C/lGTb82FhhIJmsEXnrBUC6NLzuGTNCsrpmjtkEkBOTo2sZ/WFHOr7HJCYW0a
         QpG9Zzx2tXrniob8IyOdiXvWAGqft6NTAzXe15Bu6yyPn0FNYSii3y2gf01QkbBG/iyN
         fMvHu43DapMt6SUOOEP++ztkguM4IHSTz/cygpgWYytDqi0nbHGbXivXQmJ14YhxRTUc
         DniL2zvz1S0fcBC4S/1Dm9ITo//wx54uDCp86mTwpCxq6hlYsJfOa4RBPA1k/Z+N1cJs
         cbPw==
X-Gm-Message-State: AOJu0YyD3yiqJin7mH2jIDBkZaj4EPJdntfi/a7mjyqJ25IA0LMRwJ0p
	2BsZlKStb23GMUOxtRaW52N+1YNVt4rpOWa4d2ErkegXqntSVSv1vRh775d3Gtdlh3RdBnpH952
	3wbT7
X-Gm-Gg: ASbGncsH0T4/cffgy+BYsJ1+Ag10cfnCMPb5T4XgFjubNV2+CdNjnZOy5U2HYri2dFE
	eknS1soQj/qwbIO4l+5r1EYUtOAZSvmR06neL2JeNRYV2yVSZFaWzF/1hd80ZyjhVGOd4LkdH0a
	G757FbuA2RLb2vmKTrA+rRYIAahYLg1K+QmLWRBUVHp3pzkmbBaX1QGVl5Acg+9BznlFpZW6t2F
	OmT1Q5/v01ZI+V25PjuMtxf4w+SkhUv0o5QE8QT1DhkYAZeJMTNZtTG8kOAOY74K6M77MYk3Lld
	pA8Lwvgb9pTmHbY7UOW+Ik8yR9z48lMZYeXQhKsGiRoWUpx1jGM0qGcqcHiwRxrRb5L5jP3hS0/
	v3DmoiYMgZVlbAhdD8gcZ8OHeF3U=
X-Google-Smtp-Source: AGHT+IGodDXy6rVxnZjPICeS3flXZkLBXBiMseu5I+TJcpcbL03vqrmnokPMt140vV44dpSt5FJ/jg==
X-Received: by 2002:a17:90b:2c85:b0:30a:2196:e654 with SMTP id 98e67ed59e1d1-30e8312bb11mr41566968a91.15.1747979023398;
        Thu, 22 May 2025 22:43:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365f7a43sm6456380a91.47.2025.05.22.22.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 22:43:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uILC0-000000071NH-0XGs;
	Fri, 23 May 2025 15:43:40 +1000
Date: Fri, 23 May 2025 15:43:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC] xfs: fix unmount hang with unflushable inodes
 stuck in the AIL
Message-ID: <aDALDNZGgHzxb25X@dread.disaster.area>
References: <20250515025628.3425734-1-david@fromorbit.com>
 <20250515025628.3425734-3-david@fromorbit.com>
 <aDACgQ8j42TFeRA-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDACgQ8j42TFeRA-@infradead.org>

On Thu, May 22, 2025 at 10:07:13PM -0700, Christoph Hellwig wrote:
> First a note:  I gave up on my previous rushed attempt to review this
> because the patch was just too big for my limited mental capacity.
> 
> Today I instead split out the relatively trivial prep parts to focus
> on the changes.  I've pushed my split to:
> 
>     git://git.infradead.org/users/hch/xfsprogs.git shutdown-deadlock-split

I'll look at it next week - after a week of solid rain here (lots of
severe flooding in the local area) I've got a lot of work to do over
the next couple of days to do. And I've still got a dozen trees on
the ground from the last severe rain event that happened 3 weeks ago
to finish making safe...

> it would be great to pick that up or do something similar for the next
> round.  After your patch I've also added two cosmetic patches.

I did mention that I needed to split it :)

> With that the change does look good to me, and the bli reference
> count scheme looks almost sane to me.  Although it makes me wonder
> if we should just keep a BLI reference for any BLI in the AIL to
> further simplify it eventually?

I've looked at that in the past - the first time I tried to fix this years
ago I ran away to retain my sanity. There are some nasty gotchas...

They start with several pieces of code that assumed that a BLI with no
references but is dirty must be in the AIL and so is safe to access
and modify.

Similarly, the buffer unpin code (and now the transaction release
code) assume that the AIL doesn't hold a reference so the last
reference on stale BLIs will trigger at journal commit complete/trans commit
completion time, allowing the BLI to be removed from the AIL, torn
down, and the buffer cleaned up left in a state where it can be
reused safely from the next lookup.

However, if the BLI has an AIL reference, neither of these things will
trigger cleanup if the buffer is already in the AIL. At this point,
we end up with stale buffers over freed space
in the AIL that only AIL pushing can remove. It does no such thing
right now.

If we then have reallocation of the freed metadata block extent and
lookup of the buffer, the stale flag will then be cleared on it. At
this point, we have a stale BLI and a non-stale buffer, and stuff
just gets worse from there. We even risk writing buffer contents
from the AIL whilst it is free in the journal but only allocated in
memory....

IOWs, it is not that simple, nor is it risk free to give the BLI
in the AIL an active reference....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
