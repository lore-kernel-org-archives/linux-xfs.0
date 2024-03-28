Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E864440842
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 21:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711661106; cv=none; b=eobSC9Ay47A2N6+lhQ8xjOacRBSOlwogh7s1Pos8Hx7WaXY5l1Hm/Ne4AxGnwDePb44KyoSF75c8wra2bNd/Xq+wXQBQpRc9lEho+GsGAX96wRimQkqtR3JEK9cY4RXhSY+53rTB8Uf7YpxC8KRFksuJo4Hpwig29DTV5bs+otQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711661106; c=relaxed/simple;
	bh=cGXIxRqy3EEcRnhZqTezUOEWnIGRvMT1wdNPVJNtiPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PKZk6Ea1zWmk9DP63uZCfTVL6SiDY0LuNUK58cQXaVMaflTmabEYK0e4TDDvNhBvJO/cyAMQ+KdlBgkyd+uHfCZiYebU6TTsUBqxV5p4yayzjvj3CZzc2qDFvCrFZmpabB/zQLz1pu18EH9VWgWIjNaVny6iwPzXp39VyqPSu0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wwLPNMGA; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wwLPNMGA"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ead4093f85so1402052b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 14:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711661104; x=1712265904; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H/0EyouVP65gK6t0HBZJCkdFlpKHPEyQGXYDKfB91kc=;
        b=wwLPNMGArrQ2D3wm2j64pt64BFP9wpzjj4FwynJIalFSRDbaQPcFFXKPQOwdvEpiwE
         sLZv6X4rdi8tPtv1AISoj0S8ImhIXdFHUMgl0E0/Fb+lAu5VhefY/kzVoN4F0xyPyAwQ
         tZgDh8mdvQAkmovqm3PK9bE02qxQlz6HBAsq5cJfb15zASI3EqXCrcTL9AEr9hXswvDJ
         /YFW7s+pcHvl/O7dKvThKFJN/4cy7pvtjJcFmfTrFV9e0HTnaQl1h9tiIE3a6JTNlrvN
         HN0x9Fa+Q9NrazXwA/+R0YJ+NcnhhkjmTmxMb/DLC/JYXK1O5tmnrt/zIO346avFybfM
         yK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711661104; x=1712265904;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/0EyouVP65gK6t0HBZJCkdFlpKHPEyQGXYDKfB91kc=;
        b=RMcUFPxADWOkXtflXKkLaePi7/88QjJs571HiviXPiJy9BQppNEixUYQGiCzTjAFge
         MMmM0izz0Ym6H2NNV7LOFCmo8+k6fNT/gEP31zyhy8c36l+uBldyh8L2ce7jXd8vv40U
         MtWLMJBB7lEm56qsbcaC03jCqvkfyo/Gt1ztmal3dpb23u2ZBeb52FkJoUSkjz1zr946
         zQQcVmpVpaLggioysDxLqsuOXZJXcBOXSntyRk8Aa5N6eUX30iQRt4wv2xpntC5N9zas
         Zb7+wemJYF1dnEeXe71itV7p3neQQGhlHxRIqDrA7jbvVl1dKyIv352bukDLlBaJqrRT
         isNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGgqklMAl/QXWr4oiLIHd2zjtopkL2A5I3ioNMHS9zEXOJLrPBFwqv7iF0lgMZhpzAHUdMssi9pXAUwD7eGgKbM1y0zHOzPc9Z
X-Gm-Message-State: AOJu0YzxWksruyKlTAMKmBes7tG57ULdnHS3/SkAUeUCdiDie4z6m4Z3
	aZGzCGwazbSSFWcvkgbeDA66ubKQHiHk+7rrzZYVbLUeXB3cWzVKRW8diyOlB2A=
X-Google-Smtp-Source: AGHT+IHEZGAX3bivqmqrLxGrU6dMrVA2rBVpQC8UB4NOLcrCLo62NGmF1AJoxcwzVLuuC1GwNPfOtQ==
X-Received: by 2002:a05:6a21:9212:b0:1a3:e4fe:f6f1 with SMTP id tl18-20020a056a21921200b001a3e4fef6f1mr339902pzb.58.1711661104075;
        Thu, 28 Mar 2024 14:25:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id w3-20020aa79a03000000b006e24991dd5bsm1877809pfj.98.2024.03.28.14.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 14:25:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rpxF6-00DWAu-2E;
	Fri, 29 Mar 2024 08:25:00 +1100
Date: Fri, 29 Mar 2024 08:25:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <ZgXgLDnM62oJH0q2@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-10-hch@lst.de>
 <ZgTxuNgPIy6/PujI@dread.disaster.area>
 <20240328043411.GA13860@lst.de>
 <ZgT1K2OH/ojXqcu2@dread.disaster.area>
 <20240328082516.GA19416@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328082516.GA19416@lst.de>

On Thu, Mar 28, 2024 at 09:25:16AM +0100, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 03:42:19PM +1100, Dave Chinner wrote:
> > > Unfortunately there are different.  For data device blocks we use the
> > > lazy sb counters and thus never updated the sb version for any file
> > > system new enough to support scrub.  For RT extents lazy sb counters
> > > only appear half way down Darrick's giant stack and aren't even
> > > upstream yet.
> > 
> > Can you add a comment to either the code or commit message to that
> > effect? Otherwise I'm going to forget about that and not be able to
> > discover it from looking at the code and/or commit messages...
> 
> Does this look good?
> 
> http://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=91bbe4c2d5518a1f991d7f19aad350d636e42d32

Spot on. Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
