Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52993198E69
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 13:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729517909; cv=none; b=NpfYAb8aWOVh6r1DcV9I3jsxL1hsULi5MyizaIwfuZHrNtXX+SC7xZr4AzxfOcQiZkLq4J4gqcdCjPe01vCmIbVrRqgULatfiDvFp3Z9TxLUUr9wh5INbOqmczFsnFOVOu/9sgNYiKgFof1UASuTbPoNNeAHrNELP1NeM4dsr7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729517909; c=relaxed/simple;
	bh=hBtldOqD5y7+GEf2dMKwQy9HrMh4L7vHtm20CR/QEgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYI0x63VHmkCbXVGqT02KBoAQF++L4Jg4XwDMwqpTXDHsKRQFBwc7ge56a3NCrQt4p5wLw2bVATbDt6HyDOam94fYZUoUPWs0sEL6V7RJjvbtXuSjWl81clzD+ra/4KaYil/h3W0Nf1arsLnoqD1XGnOX8nIt2A1j9HZTGf1l04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wRjhvAmJ; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wRjhvAmJ"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2e56750bb0dso1927265a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 06:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729517906; x=1730122706; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SJ1IZSVCxSaCKmddSG5e6jyPsoinCJbOGE3b4ynb4mo=;
        b=wRjhvAmJmAhX7hAL9C30DhILnDiHxyjgyOO4L6gJrUxxh7TcWxBt8/R0ghIwQct28I
         OyUNpaDuOHTsCUWEuWK43R1aHcJ1OoH76FeFXpkYKwdq5HHCg8XfOBfpDLdHsPiBh807
         u6BHSVw8vo7fL+LT+GgKHenGklf2DUXTPZqp403Tcb4Oe4HYcwSxB0kxOan6r6vynJtv
         EeHcIIVL2c0NFv0G2Xmazoi7iOf4yFnlFvcNGjK0h92LWpQsf5AZBd1Dzc/4L1Mt7VCL
         8VFnvd0ROpWJUjdNXTue0bbqFhq5QGDGTXcu6fdxTNK1T7h4TCtP5qtEaywDnTKRHEl9
         WoGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729517906; x=1730122706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJ1IZSVCxSaCKmddSG5e6jyPsoinCJbOGE3b4ynb4mo=;
        b=SXDCepeTDbRECRdNSAnUDsXSb+LjvOeneMm1yyc69pnRRtVTYYw316GVIVEdtlZ/jE
         oiEkGIz6N9qZ9B1NoCaAR82VRzqQL7HRTCM9Vo5WA98XLypp+z2vcIhYPZvcupA4cT+8
         cN3cyms14Sz4PP9/ZjFkLBNhEBoYdtcw5Wqi6RMUCLBpRogplu58ifJ7VY6ymfZSRqpt
         uqgRAR/5Waru3qZAdVk2d7xrlDemcLRcEoEmKsbxaK19WKyGh+/PFDxxi2M6eEV90jtD
         utvdM8rjMoQqGXEZd3Z1yEfEVJDPkOGmnpAnnyJCG7dEWXUvYHCCnU3ZlbLtgqzL+SQa
         i1tw==
X-Forwarded-Encrypted: i=1; AJvYcCU0WQaQfCFER9o5pW4bJo9SPtpTK2dOjFKmYQCj5R5I0JZZBCSJM9E3xuzNx96L4IJNL0z08KaUqkc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy84xV2XnC6q6z9cRjQc2984nzK2W4jRiRPBRNjJAdF96apC8Yw
	0NLEWEcA09YSZWHpCaZWPaXrG5H1xJ+XbQkqHIrPMJWbUcCifokRpBwOuPWS3aY=
X-Google-Smtp-Source: AGHT+IFy4QDzquWLETlpiOQqDWi+DgBmBsIwiD4hqrRAX0F7x8ic6bL74xqPkzZLkK1gqQOowDb+Tg==
X-Received: by 2002:a17:90a:7147:b0:2e5:5e95:b389 with SMTP id 98e67ed59e1d1-2e5619021f0mr12525055a91.35.1729517906486;
        Mon, 21 Oct 2024 06:38:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad510744sm3729024a91.48.2024.10.21.06.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 06:38:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t2sc3-003pHb-1e;
	Tue, 22 Oct 2024 00:38:23 +1100
Date: Tue, 22 Oct 2024 00:38:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <ZxZZT0LpkINDmJOe@dread.disaster.area>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <ZwffQQuVx_CyVgLc@bfoster>
 <20241011075709.GC2749@lst.de>
 <Zwkv6G1ZMIdE5vs2@bfoster>
 <20241011171303.GB21853@frogsfrogsfrogs>
 <ZwlxTVpgeVGRfuUb@bfoster>
 <20241011231241.GD21853@frogsfrogsfrogs>
 <Zw1n_bkugSs6oEI6@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw1n_bkugSs6oEI6@bfoster>

On Mon, Oct 14, 2024 at 02:50:37PM -0400, Brian Foster wrote:
> So for a hacky thought/example, suppose we defined a transaction mode
> that basically implemented an exclusive checkpoint requirement (i.e.
> this transaction owns an entire checkpoint, nothing else is allowed in
> the CIL concurrently).

Transactions know nothing about the CIL, nor should they. The CIL
also has no place in ordering transactions - it's purely an
aggregation mechanism that flushes committed transactions to stable
storage when it is told to. i.e. when a log force is issued.

A globally serialised transaction requires ordering at the
transaction allocation/reservation level, not at the CIL. i.e. it is
essentially the same ordering problem as serialising against
untracked DIO on the inode before we can run a truncate (lock,
drain, do operation, unlock).

> Presumably that would ensure everything before
> the grow would flush out to disk in one checkpoint, everything
> concurrent would block on synchronous commit of the grow trans (before
> new geometry is exposed), and then after that point everything pending
> would drain into another checkpoint.

Yup, that's high level transaction level ordering and really has
nothing to do with the CIL. The CIL is mostly a FIFO aggregator; the
only ordering it does is to preserve transaction commit ordering
down to the journal.

> It kind of sounds like overkill, but really if it could be implemented
> simply enough then we wouldn't have to think too hard about auditing all
> other relog scenarios. I'd probably want to see at least some reproducer
> for this sort of problem to prove the theory though too, even if it
> required debug instrumentation or something. Hm?

It's relatively straight forward to do, but it seems like total
overkill for growfs, as growfs only requires ordering
between the change of size and new allocations. We can do that by
not exposing the new space until after then superblock has been
modifed on stable storage in the case of grow.

In the case of shrink, globally serialising the growfs
transaction for shrink won't actually do any thing useful because we
have to deny access to the free space we are removing before we
even start the shrink transaction. Hence we need allocation vs
shrink co-ordination before we shrink the superblock space, not a
globally serialised size modification transaction...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
