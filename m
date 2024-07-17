Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7A76116
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jul 2024 04:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721189482; cv=none; b=NqOFUt/wTdxM94hDxmGOvrwwKY6a5Xuo/J/6LvVQ7GdVlRKa+YeVXTrsOoa6QLt5aubbSv8Ef6gBKQNP99xh2pmQblKX663G1TFKUbhxmwwPFISHnn2Ko2YNz1PnhpT04E99vcQqtaEisTjP2/Wf5iQ/TjwldzeUxHDnK++KW+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721189482; c=relaxed/simple;
	bh=K81kGTlDdvziLarZQ3bGQLdwSMhVYjSSAZ0zEepXhQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDVAX+f4alC7VObsLUg+OKlemOdjXsiao6AbREV7SIe1XB4B+r6VzJLxVSpVFqgX6IOpWNfcV3dj1wIKyymXfNZLcvrngPRUc8tvSsRelJRIYDPFzZtRLB67L16KfGOwPzU/3PetESGG3qXmBlvYLoKrDFfcsD5azBg/Nv7zamA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=S2AxiUOs; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="S2AxiUOs"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70b0013cf33so4661923b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2024 21:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721189480; x=1721794280; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C4BaVmQSB2jH8wxipgqcSawkmWdK3Y8uMHgAA9jglbA=;
        b=S2AxiUOs9w5uE1MRbgnHX8Y6zbLyD2FPEwJuU4n/j06QwvuenooXGMZSrS4HuIF4qj
         xmEQM8p6ha2jbBUCI2wLdFgfBvMihNvKtLHRAnLhnTyQUEgy5fMQ+WA20cyijmrpSlLk
         MS2BQrgU1FNevra32B0hpwqzS0DVNjkB88ByR+iGcB5J+hz+WghJmSrbXd2c0YV4KVJq
         BpnPdQAQWtYLIsDsTT0VTx4hMPfJNYTm1esGEIcOCJXmsGLUyPJVruAygjE8mqGpZ1rJ
         BXe4AvpC+/JOOrEXt9zS/DC9SFCcwnRyNJRA9t9Evlb7hYqd4pRuGY1VJpcsLPCIdm4q
         uroQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721189480; x=1721794280;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C4BaVmQSB2jH8wxipgqcSawkmWdK3Y8uMHgAA9jglbA=;
        b=cgruOh1AavJOjiwaQlCqR1SgmjXSljO82yWubNDG6yhWKAX02+6vWOhixndFuvvEqG
         g+Vjwpt2fLO0/otbrdXZ1Gp09LRbK7PmGWobyZPExCpDt6IJ5Ftj1lmQ4YidhquBDuOL
         IWQXL7vj34O2QtlSjfnN6pB4GBZLiOPi/F8qkV3Vmp5EsuvgbCkAJO5pyIG35CErf/JN
         +fhWxQ6cWlyiyvXeAgJOWZ64AOO7DJeEoLSF9Aqz/7XQLHFv/+JGZrN4wc2ZT2x/FKH7
         1gJR9EWzacnRM+0RuBNtfpbPVlcJr/OZnDUuLzOLN/Iz+9c0rrv9v0ETEAkRZVX6+ETi
         dxyw==
X-Gm-Message-State: AOJu0Yydwr4gjIjJwENzqfm0+BSwMKCeViFeY7UD3W8PemZa+kRVdqEM
	ilVeYf9YqmQ8X1dk/unpZG6KJzjjho1eI7Ie82rmFtsZaQAYkMgKJd4SGX0s0d4=
X-Google-Smtp-Source: AGHT+IHG1IlSuNx+HD44V05u/eBOWPQMlDmX3UuQo6VhpLEDFzFAVu9whZi4Klnznediy4tdggRo3w==
X-Received: by 2002:a05:6a00:2450:b0:705:c0a1:61c5 with SMTP id d2e1a72fcca58-70ce507dd02mr525962b3a.20.1721189479821;
        Tue, 16 Jul 2024 21:11:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7eca6a00sm7449423b3a.142.2024.07.16.21.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 21:11:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sTw0a-0013eI-2u;
	Wed, 17 Jul 2024 14:11:16 +1000
Date: Wed, 17 Jul 2024 14:11:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Message-ID: <ZpdEZOWDbg5SKauo@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-3-wen.gang.wang@oracle.com>
 <ZpWzg9Jnko76tAx5@dread.disaster.area>
 <65CF7656-6B69-47A3-90E4-462E052D2543@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65CF7656-6B69-47A3-90E4-462E052D2543@oracle.com>

On Tue, Jul 16, 2024 at 08:23:35PM +0000, Wengang Wang wrote:
> > Ok, so this is a linear iteration of all extents in the file that
> > filters extents for the specific "segment" that is going to be
> > processed. I still have no idea why fixed length segments are
> > important, but "linear extent scan for filtering" seems somewhat
> > expensive.
> 
> Hm… fixed length segments — actually not fixed length segments, but segment
> size can’t exceed the limitation.  So segment.ds_length <=  LIMIT.

Which is effectively fixed length segments....

> Larger segment take longer time (with filed locked) to defrag. The
> segment size limit is a way to balance the defrag and the parallel
> IO latency.

Yes, I know why you've done it. These were the same arguments made a
while back for a new way of cloning files on XFS. We solved those
problems just with a small change to the locking, and didn't need
new ioctls or lots of new code just to solve the "clone blocks
concurrent IO" problem.

I'm looking at this from exactly the same POV. The code presented is
doing lots of complex, unusable stuff to work around the fact that
UNSHARE blocks concurrent IO. I don't see any difference between
CLONE and UNSHARE from the IO perspective - if anything UNSHARE can
have looser rules than CLONE, because a concurrent write will either
do the COW of a shared block itself, or hit the exclusive block that
has already been unshared.

So if we fix these locking issues in the kernel, then the whole need
for working around the IO concurrency problems with UNSHARE goes
away and the userspace code becomes much, much simpler.

> > Indeed, if you used FIEMAP, you can pass a minimum
> > segment length to filter out all the small extents. Iterating that
> > extent list means all the ranges you need to defrag are in the holes
> > of the returned mapping information. This would be much faster
> > than an entire linear mapping to find all the regions with small
> > extents that need defrag. The second step could then be doing a
> > fine grained mapping of each region that we now know either contains
> > fragmented data or holes....
> 
> Hm… just a question here:
> As your way, say you set the filter length to 2048, all extents with 2048 or less blocks are to defragmented.
> What if the extent layout is like this:
> 
> 1.    1
> 2.    2049
> 3.    2
> 4.    2050
> 5.    1
> 6.    2051
> 
> In above case, do you do defrag or not?

The filtering presenting in the patch above will not defrag any of
this with a 2048 block segment side, because the second extent in
each segment extend beyond the configured max segment length. IOWs,
it ends up with a single extent per "2048 block segment", and that
won't get defragged with the current algorithm.

As it is, this really isn't a common fragmentation pattern for a
file that does not contain shared extents, so I wouldn't expect to
ever need to decide if this needs to be defragged or not.

However, it is exactly the layout I would expect to see for cloned
and modified filesystem image files.  That is, the common layout for
such a "cloned from golden image" Vm images is this:

1.    1		written
2.    2049	shared
3.    2		written
4.    2050	shared
5.    1		written
6.    2051	shared

i.e. there are large chunks of contiguous shared extents between the
small individual COW block modifications that have been made to
customise the image for the deployed VM.

Either way, if the segment/filter length is 2048 blocks, then this
isn't a pattern that should be defragmented. If the segment/filter
length is 4096 or larger, then yes, this pattern should definitely
be defragmented.

> As I understand the situation, performance of defrag it’s self is
> not a critical concern here.

Sure, but implementing a low performing, high CPU consumption,
entirely single threaded defragmentation model that requires
specific tuning in every different environment it is run in doesn't
seem like the best idea to me.

I'm trying to work out if there is a faster, simpler way of
achieving the same goal....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
