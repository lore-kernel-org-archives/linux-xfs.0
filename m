Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BB0148FFA
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 00:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969182; cv=none; b=OSER9yDh60RP33Anl9+7LArYdNJ+2GJxGyYdhSp+7gAbFcTzqJt1KFhtfqxJpFapK2bHGGQhGuXSGQLJP4x1dcOYygkPmwngApdaCXITYT+LG8CJtO9tZR4ctS1T5igNAMItY7tukkjyV0VqDP6LHGy+iP9KifVRtdOkEcYIDf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969182; c=relaxed/simple;
	bh=C+boFHnlU3bHNMu8LdhUVGE5pgl/xGAMq6veemTC6q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIzqRkfzwWxMcI49r7t4XKqN1TqWEqdbIUXdy++KbhrtlDaIMrmS+cqT/cBHbjDY2nvQqzXSryRW1ke/w9b/t1g7ZpNfr446feVK36v+YTkFQ+UTKB9uJR38br8HH+90kntKAvgWZ/VTHf44QfsQuu/q7P0itTUGuVs7WpX5ypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KZCPFvar; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KZCPFvar"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5ce10b5ee01so2591357a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 16:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705969180; x=1706573980; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsOlioRUwX2+o9Aa9cmeJB8MooioNCbAfG+kck/RrK8=;
        b=KZCPFvar7j8dyVS/9C9Fiw5s6msHUPioWB1NfFOH90CMXa8QtmIbwFik/3IYtlmbuC
         lBvowRyfMNq6tbd0Q8pVMNmPW0vwjJkcpxIsEie9m+Sa3osYqUJz0SjkElNv1mV+Ve2W
         xZ83NLvj1pCH/4K71O3LBVyIgEeaFX0pg1AJ8urHMdDlaKOa4zHyAYucV11BdpngzvjW
         E7RIGUtvDQ4/EGsufY1RSHnrl7MhxVmu2HglBZIBQfq1bcswllvJvogu0Xk1VyTOhw0z
         KgUKykrqfcfhNi17APyMbrQqHJGZoHD+JVwMRvfkb89k5m9FORF3CmVilx5A4wYmQWWO
         ilLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705969180; x=1706573980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PsOlioRUwX2+o9Aa9cmeJB8MooioNCbAfG+kck/RrK8=;
        b=AsKGRXfUtE+5DVpD5vYUgpvkBrnTIJycMc3U8kD9KSAyzkkOlz2c+UkHKfMwWBfS2k
         Z40MIQEPGuRLTQqbWG+HkE0JfWMgYVYGuoxBJtT0aj/iE8cK0n5t5MB+IvUItxfSUGgI
         ao2gk5wkSR/l4y7QusC200JE/kmWvgn/giHNoZkQchnolMqQWCvyD8sF+Vm1uR5E+uWc
         ZVL4zdDSthFW3vTqsCA7UDl+GudWLHW0TwmILc20oQgMjsVlTBD2cXc9v5D7hplDWIgW
         RWiyQFa4AO2ZDAnYnfulX1y5nl2+PLnO/IN6+sB07DRTcgTriBW1pTm0qOkCVW4KUjaW
         jK3g==
X-Gm-Message-State: AOJu0YxvNq8jVjAItw+9mQSJQcabQl9vlST7KaBStgkCgqyFPE1oBFI4
	TgjSPraeRe7LmpQZbuqJgpClXZTrdbutm+B4Gup/bPkX3xySzONL/RW5voRglZ82EhGWvTerR/e
	x
X-Google-Smtp-Source: AGHT+IEvFm+Z3WvzsHcg59KKuaKzk5Uy7Oxu+IH0G4qXIMvJNfDJIdC1QznUZsez4BoQckuOwdkuRA==
X-Received: by 2002:a05:6a20:c858:b0:19a:9f65:a971 with SMTP id ha24-20020a056a20c85800b0019a9f65a971mr4497920pzb.59.1705969180488;
        Mon, 22 Jan 2024 16:19:40 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id ls30-20020a056a00741e00b006dbe42b8f75sm1995534pfb.220.2024.01.22.16.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 16:19:39 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rS4Vt-00DzKd-1W;
	Tue, 23 Jan 2024 11:19:37 +1100
Date: Tue, 23 Jan 2024 11:19:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Using Folios for XFS metadata
Message-ID: <Za8GGYaK+3rQfiGo@dread.disaster.area>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <87zfwxk75o.fsf@linux.intel.com>
 <Za5XQDOutk93L5w1@dread.disaster.area>
 <Za5u1CsKnrWflMOR@tassilo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za5u1CsKnrWflMOR@tassilo>

On Mon, Jan 22, 2024 at 05:34:12AM -0800, Andi Kleen wrote:
> [fixed the subject, not sure what happened there]
> 
> FWIW I'm not sure fail-fail is always the right strategy here,
> in many cases even with some reclaim, compaction may win. Just not if you're
> on a tight budget for the latencies.
> 
> > I stress test and measure XFS metadata performance under sustained
> > memory pressure all the time. This change has not caused any
> > obvious regressions in the short time I've been testing it.
> 
> Did you test for tail latencies?

No, it's an RFC, and I mostly don't care about memory allocation
tail latencies because it is highly unlikely to be a *new issue* we
need to care about.

The fact is taht we already do so much memory allocation and high
order memory allocation (e.g. through slub, xlog_kvmalloc(), user
data IO through the page cache, etc) that if there's a long tail
latency problem with high order memory allocation then it will
already be noticably affecting the XFS data and metadata IO
latencies.

Nobody is reporting problems about excessive long tail latencies
when using XFS, so my care factor about long tail latencies in this
specific memory allocation case is close to zero.

> There are some relatively simple ways to trigger memory fragmentation,
> the standard way is to allocate a very large THP backed file and then
> punch a lot of holes.

Or just run a filesystem with lots of variable sized high order
allocations and varying cached object life times under sustained
memory pressure for a significant period of time....

> > > I would in any case add a tunable for it in case people run into this.
> > 
> > No tunables. It either works or it doesn't. If we can't make
> > it work reliably by default, we throw it in the dumpster, light it
> > on fire and walk away.
> 
> I'm not sure there is a single definition of "reliably" here -- for
> many workloads tail latencies don't matter, so it's always reliable,
> as long as you have good aggregate throughput.
> 
> Others have very high expectations for them.
> 
> Forcing the high expectations on everyone is probably not a good
> general strategy though, as there are general trade offs.

Yup, and we have to make those tradeoffs because filesystems need to
be good at "general purpose" workloads as their primary focus.
Minimising long tail latencies is really just "best effort only"
because we intimately aware of the fact that there are global
resource limitations that cause long tail latencies in filesystem
implementations that simply cannot be worked around.

> I could see that having lots of small tunables for every use might not be a
> good idea. Perhaps there would be a case for a single general tunable
> that controls higher order folios for everyone.

You're not listening: no tunables. Code that has tunables because
you think it *may not work* is code that is not ready to be merged.

> > > Tail latencies are a common concern on many IO workloads.
> > 
> > Yes, for user data operations it's a common concern. For metadata,
> > not so much - there's so many far worse long tail latencies in
> > metadata operations (like waiting for journal space) that memory
> > allocation latencies in the metadata IO path are largely noise....
> 
> I've seen pretty long stalls in the past.
> 
> The difference to the journal is also that it is local the file system, while
> the memory is normally shared with everyone on the node or system. So the
> scope of noisy neighbour impact can be quite different, especially on a large
> machine. 

Most systems run everything on a single filesystem. That makes them
just as global as memory allocation.  If the journal bottlenecks,
everyone on the system suffers the performance degradation, not just
the user who caused it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
