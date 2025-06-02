Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B972C3251
	for <linux-xfs@vger.kernel.org>; Mon,  2 Jun 2025 23:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748906356; cv=none; b=MMy1RfeTy/fOldYVhSu9FU62aETEt4AiHwJB6qOxcdMgZR1eac9+TVqqoBbZGhbUKk6lAf0acvxSIbTmCWDqKPY8MgmAZ1T3tmpGC89iLwTDd9Ba6ofBk3ZQYDNJIvf6ylLpldMmaNIenwI+Xfjk2gx5WmRJK+CotT9p9c2S8yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748906356; c=relaxed/simple;
	bh=GMoP0FkBjlH8Avgc4RGDMn0OjMa+Ks5JgJ/N5Vif9dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElFwbwj0kWZMEm4jn74R6I3f78RhpBKlg9LPMJ7yucHedAz26o+bmeMy54b2eEfoBVhxCxHqvl4KLOPzxuw0B44i4WXlzTyXgmtTs/8928UcISp8/ZYsenZ49GCu53L2yCSYYjDcrVK4DAgqxB+o5zX4rt2VneeGQ9CiErYKfNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=WNLyG6EL; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="WNLyG6EL"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-73972a54919so4341151b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 02 Jun 2025 16:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1748906354; x=1749511154; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P60tv1Mhdn0cRxhg423psLABfS93iCsU5/zymXr2pXE=;
        b=WNLyG6ELb9DqpxG46UWnZglZ5ZnM38pY6dDtKxGaAKj3/96O3bt84hzueE+bJejQV4
         E3JZiy9wGmXRDlU2xSpRtoPFVrtMXvVlmmalvYLv/Zh4rLn/E4+qp7ugO9/Eg40J0yLg
         Vg9kkOepTR4WDJ459ApQNGDAF2H4aYD1gQqiX3NieK5+4Vu1m+KUv0RcXr57ToQLqDKT
         fNNpsF3WZDwYb9v+n3pXmmi9MU8iaUz6hnV5kvFg8U3UBhnU6Y1NhVJn6//fxY0fPPHC
         j83s84LJOwB4hsHho3iduanoSpzhFQNZ/tMb2AJjwZfKbXyzGxl09G/yY1f9y1umWJzi
         zcRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748906354; x=1749511154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P60tv1Mhdn0cRxhg423psLABfS93iCsU5/zymXr2pXE=;
        b=GbgC1LiVXOF+b+WL6PXwfZxTunVlFhR8pQteNszt7cWbtFLbiIZckc0FHq3lOxL7VF
         5c+WwIuCaCyLjmjrHVhaLhAVZSPctnJopNp8hu5HSq5BW92hLwZWQxNZGgsNRj91J4Co
         KETRmKbRlICNVq+yC9+0OzcBMPm+obrtIIHc0XCMDpL3/XYxa7kyyl06m/bBUnGvcrO6
         Nc7zWM7Cm432gC61mKl4LWjXl2iTq8ujsy1+JApPY12iQjX4BM0wkZ3mCa2spUngeOwp
         U0FD4Sspux6c4h7m6xHfYV42Ri09aw4PvROaodfIgeCmWYeRZOLxpPgTTC0p5Q+e5nk2
         WN9A==
X-Forwarded-Encrypted: i=1; AJvYcCVuiDJVx08GkciaCNm5JIZQ2sV0xbD+nATM9ic3db9eLdL/6XxpY1NT7tmqDdF5GeUs0CM8v+CmXzA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl22TfaiMBQGJMSzBrOOHt/nifHASaL/jbyncu2/axpByDKoKX
	Oa2DgqnHCA1Aaa3uY3rl/dWypx5Mp27vVYNtbLNwX7baCOkYBWdvh0sfzVw3VM329Jk=
X-Gm-Gg: ASbGnctY6S+et+jmVHD3DXaYeQgsZWdrfPjoIzhclzv6u/NrSn9cq/MmEkjI4ZcDKKp
	neLm+vx4Yk/wOJrQtyL+iYvnvC2y7z5qBHAVUTjhAtdBVKutFtfDC9p7+9Gd3catfCArfLggmPK
	+ZGRMJqXo1BxGlbsHEx38ceZoL7aNwGDJ5hYTdYBVxylWs0QmgExtjQQa6Skb8/ABa6i76LX1kr
	yD/pscbBpHPCp9jIMkHD+/yNRfjFwYp7IOohZ0d/WJPfbYP9mQDZyZzHPyGuqgqDIXZc84T5GbY
	PHCdrWA/0cylbvIqYJZXE4a55YKDoGlJ6KeyRxmFUmSppkV/BboBAise8cNUNBcI5oGd2ygNvxX
	wj6I5OCGPHmnNTwM2QLwxXXeOkwF+9DRmDzZ/4AYln+J4e73k
X-Google-Smtp-Source: AGHT+IEPsj1aDtH+W+3C0GTQBgloNbEI/WG1fIIMbgSnmWG3+I0yRkIDwC5qhR5WE73QWSMS157YUw==
X-Received: by 2002:a05:6a00:4b13:b0:73f:ff25:90b3 with SMTP id d2e1a72fcca58-747d1ae2c64mr15727604b3a.24.1748906354262;
        Mon, 02 Jun 2025 16:19:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747bd44eb1asm6896252b3a.61.2025.06.02.16.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 16:19:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uMEQw-0000000BU94-3kKv;
	Tue, 03 Jun 2025 09:19:10 +1000
Date: Tue, 3 Jun 2025 09:19:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yafang Shao <laoar.shao@gmail.com>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [QUESTION] xfs, iomap: Handle writeback errors to prevent silent
 data corruption
Message-ID: <aD4xboH2mM1ONhB-@dread.disaster.area>
References: <CALOAHbDm7-byF8DCg1JH5rb4Yi8FBtrsicojrPvYq8AND=e6hQ@mail.gmail.com>
 <aDfkTiTNH1UPKvC7@dread.disaster.area>
 <aD04v9dczhgGxS3K@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aD04v9dczhgGxS3K@infradead.org>

On Sun, Jun 01, 2025 at 10:38:07PM -0700, Christoph Hellwig wrote:
> On Thu, May 29, 2025 at 02:36:30PM +1000, Dave Chinner wrote:
> > In these situations writeback could fail for several attempts before
> > the storage timed out and came back online. Then the next write
> > retry would succeed, and everything would be good. Linux never gave
> > us a specific IO error for this case, so we just had to retry on EIO
> > and hope that the storage came back eventually.
> 
> Linux has had differenciated I/O error codes for quite a while.  But
> more importantly dm-multipath doesn't just return errors to the upper
> layer during failover, but is instead expected to queue the I/O up
> until it either has a working path or an internal timeout passed.
> 
> In other words, write errors in Linux are in general expected to be
> persistent, modulo explicit failfast requests like REQ_NOWAIT.

Say what? the blk_errors array defines multiple block layer errors
that are transient in nature - stuff like ENOSPC, ETIMEDOUT, EILSEQ,
ENOLINK, EBUSY - all indicate a transient, retryable error occurred
somewhere in the block/storage layers.

What is permanent about dm-thinp returning ENOSPC to a write
request? Once the pool has been GC'd to free up space or expanded,
the ENOSPC error goes away.

What is permanent about an IO failing with EILSEQ because a t10
checksum failed due to a random bit error detected between the HBA
and the storage device? Retry the IO, and it goes through just fine
without any failures.

These transient error types typically only need a write retry after
some time period to resolve, and that's what XFS does by default.
What makes these sorts of errors persistent in the linux block layer
and hence requiring an immediate filesystem shutdown and complete
denial of service to the storage?

I ask this seriously, because you are effectively saying the linux
storage stack now doesn't behave the same as the model we've been
using for decades. What has changed, and when did it change?

> Which also leaves me a bit puzzled what the XFS metadata retries are
> actually trying to solve, especially without even having a corresponding
> data I/O version.

It's always been for preventing immediate filesystem shutdown when
spurious transient IO errors occur below XFS. Data IO errors don't
cause filesystem shutdowns - errors get propagated to the
application - so there isn't a full system DOS potential for
incorrect classification of data IO errors...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
