Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423FB3A8F4
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 11:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705924422; cv=none; b=jlsAO0gRkRexTMZTQZlD406FDot9F4S8bjArftTinIj1IkXAtkJFdan6nvlhxac7xErB7ns5HRRF6TY1AEXS6yV2UvxOHNQq4I1OGBYG29U0wVUSmUNW2QwXIzHpcBS6XAwYDLpsQzYg9V6JNtDrq52ankY9+zvzg/tw219Vut8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705924422; c=relaxed/simple;
	bh=W2Avw8wb1Qrnsv2XZFDHMC+q0rUEdrC/wi4fdjtI8Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9QhKYHcOBxLOeLs96UyL5A5kwxLfnixaPzX+BXJeHHWAncJP00wrGwX7e0oLJ9LoEfmIeymPXOlmbCOuM9Ad7TWaj11GpCVcefPSUCe7uocW5UP1rfh3deS4fVwmC9/9w8V4TIk68UETLeuFd0Kt26ZnlkfxRxDqoA/UHxFh0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tylJPfR3; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tylJPfR3"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6dd8cba736aso2215368a34.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 03:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705924420; x=1706529220; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4lvDGi3XtCFwulPhjEFTJBsNK4AKTWo6BAFDZ+Ol/6E=;
        b=tylJPfR3MPxuRahY5wzYM1CnGirQOxU2xv2/LSu4ql8FYPxeO1Sj3zq8WVjQYv3pkf
         CPzvrzrUoAD8EunFxH3enM0rMdf1XuNumza88I7tSDjhjAEGJgy23WG+YOWUt+Frer5S
         //mme92md+TMs+aScwWmGA+XB07YZ1A8PdUpUbtRkG5mx3X4izM2CHv3mRKXjpqP7wmw
         9Xuc8JU2rNAudv7buel6yyxBG7L3iwgDjfmL97/0EmudnR0LoKDSmtqIqCHVdyoTt5Un
         o9OO0ddmq2t2ZqYuuuEC+XhtZarbnft9uZ5X0Ex0fpCIy7qEjqDw3mCZKGOVG4ZfVTqs
         xqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705924420; x=1706529220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4lvDGi3XtCFwulPhjEFTJBsNK4AKTWo6BAFDZ+Ol/6E=;
        b=CzTrSYkT2x4XBBdsOU1lrf4KbA6teJidC9/P0D7wJtOvSz6uEDHwouGwBU6rVOOnK0
         rT9XhwKxc45h0yOSKk6aQxnGnMURRst8vmdD6gc4V6VWcEWfgX6LqiIq0md7KSqeX7Cd
         bkL94nKMac+e3Uk295AWdNBFelnFKEKbxzopYOQCZbs3a28kjJMSzasb2ibCrha+e3cF
         fIrO4Yw2KMgUvn6froisXk1rwbGSDuprPYgNGrlhL2B1g0QVqdCK4q5ihyDqLr0HLrWL
         bb4jxDitj8kbfi18PUOrLGDCy5tFeBLy1C75EPKBRwFeNLlyCV7AM4VULeknC2v1Ryv2
         g80w==
X-Gm-Message-State: AOJu0YwWOf3IcZgxQczhvLrk3CgLQaNHVNfR3x/RORBmD+CW3Y3rgWI1
	9kcebsso3LuJHMT/mzFnxgPz+eBduCbvuxXnOKHU4Tv3DA/lUm93eokVcSBJaOc=
X-Google-Smtp-Source: AGHT+IGScjgt6UBLLx+2xQYb5zDJnwz9kSx2S8tAvCRRK2WxYQ3E4GLNCu1B9AyKuLtV1W5tVHAhJQ==
X-Received: by 2002:a05:6830:3a83:b0:6dd:e0d5:80f6 with SMTP id dj3-20020a0568303a8300b006dde0d580f6mr4543051otb.12.1705924420181;
        Mon, 22 Jan 2024 03:53:40 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id s16-20020a639250000000b005c200b11b77sm8314062pgn.86.2024.01.22.03.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 03:53:39 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rRsrw-00Dkyv-2w;
	Mon, 22 Jan 2024 22:53:36 +1100
Date: Mon, 22 Jan 2024 22:53:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re:
Message-ID: <Za5XQDOutk93L5w1@dread.disaster.area>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <87zfwxk75o.fsf@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zfwxk75o.fsf@linux.intel.com>

On Mon, Jan 22, 2024 at 02:13:23AM -0800, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > Thoughts, comments, etc?
> 
> The interesting part is if it will cause additional tail latencies
> allocating under fragmentation with direct reclaim, compaction
> etc. being triggered before it falls back to the base page path.

It's not like I don't know these problems exist with memory
allocation. Go have a look at xlog_kvmalloc() which is an open coded
kvmalloc() that allows the high order kmalloc allocations to
fail-fast without triggering all the expensive and unnecessary
direct reclaim overhead (e.g. compaction!) because we can fall back
to vmalloc without huge concerns. When high order allocations start
to fail, then we fall back to vmalloc and then we hit the long
standing vmalloc scalability problems before anything else in XFS or
the IO path becomes a bottleneck.

IOWs, we already know that fail-fast high-order allocation is a more
efficient and effective fast path than using vmalloc/vmap_ram() all
the time. As this is an RFC, I haven't implemented stuff like this
yet - I haven't seen anything in the profiles indicating that high
order folio allocation is failing and causing lots of reclaim
overhead, so I simply haven't added fail-fast behaviour yet...

> In fact it is highly likely it will, the question is just how bad it is.
> 
> Unfortunately benchmarking for that isn't that easy, it needs artificial
> memory fragmentation and then some high stress workload, and then
> instrumenting the transactions for individual latencies. 

I stress test and measure XFS metadata performance under sustained
memory pressure all the time. This change has not caused any
obvious regressions in the short time I've been testing it.

I still need to do perf testing on large directory block sizes. That
is where high-order allocations will get stressed - that's where
xlog_kvmalloc() starts dominating the profiles as it trips over
vmalloc scalability issues...

> I would in any case add a tunable for it in case people run into this.

No tunables. It either works or it doesn't. If we can't make
it work reliably by default, we throw it in the dumpster, light it
on fire and walk away.

> Tail latencies are a common concern on many IO workloads.

Yes, for user data operations it's a common concern. For metadata,
not so much - there's so many far worse long tail latencies in
metadata operations (like waiting for journal space) that memory
allocation latencies in the metadata IO path are largely noise....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
