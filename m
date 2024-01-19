Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251B66FA9
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2024 07:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705648649; cv=none; b=a6yvJpjCKPqtuAvCTwukMD+PVm9wjMlkzhvkBghy2yEj9RagonuoU/+aM5LO7yfUR63XkKcDxVjt6WIkBe2yOjPnz1j3Cwg2TRz2pWhFCQLQcWtlOWl8jRrr47oAxr5C2AVXfksfmENIui4+34rWSC1IA0FF3a3NWMDVXuXqouE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705648649; c=relaxed/simple;
	bh=c1/lUlqe4sa6j2y1IwBB5UHo5mJdQ40j0NDNkXH1Jj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSmu9LPNgwmxBoECgH5zCa/lAxfm9+2L30Q0QlsDcSCr4p7OvYsgaU/m4UH8ycLOP7XVoP2MZz4FLMbi/vKBTsRtjslvaYn8Wj0C3MEvaMXdtNp+DClmJnto0YtHoBZH/v/B9/7n5Ii4qzadzugTjNqibsvtry7mE/mOe49DEkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=D8IZQeKL; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="D8IZQeKL"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6db0fdd2b8fso347300b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 23:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705648647; x=1706253447; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NNLjBDSzu/w2ZvwniH/Vm+WheOK2zApEID4VQXAzd0I=;
        b=D8IZQeKLLEPdJq5uceq7de9/+FlllBXfUw08TvGc/cyX5JwEnslzDRxF3j8FQwMJHO
         9ytsbHp7IiFQCfddB7agQAWZgeKq8VwDIJrhjytE1yrLBQwsInjB1eYiAhkOiYeFfIX3
         1cF8olgJ2GRJFBnviym41O0STkflElhQgAfgifxsv0KprO/JQkfAWTmeRwpnEgkF6YvD
         XVJIWwqiemhy7moaB6KdbC6AuX5FvuJKGrz4ttMNGNeNh0EF5s7KdSGNdoDZXDKxu0+B
         zpbvz3gdWea6OVXAJLR/hJaQ41y8AuH7IuZm5FODH6ID+u4MQSToov+Ke+AljfjAB7ji
         998g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705648647; x=1706253447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NNLjBDSzu/w2ZvwniH/Vm+WheOK2zApEID4VQXAzd0I=;
        b=PX96S0gXrbHFLiOdWfjdtfZaqIbMKJ74Jp8hgW7kfnIuLoBZlGc39FCclk4SfQPCkq
         HmfGZiFIrZ5LewOc1MthW3U8ppmVowREajD7H3iYnOPbBuIlopUyR7t/iqo+vXA0+O3M
         RgdioCcSWQ7mjX6VPtzoce7RaQg+SaSHKSEqmtBja4bgbaYxktRlEPYli+tOpZ3dF42D
         lY+8tM+xRQNlw2GC2YV9yNz6lozEkDmVWo52NM1Xm1JiHk7oo8TJky3Y3c575TgDPD4Z
         z+M+WkAKm6Fd7qHUEIoJJLzejXraV8sPEqLJBXI1e4846gAde9SNFyxNPg9E91MWw1oi
         eu1w==
X-Gm-Message-State: AOJu0YwNspu3amQQ7HSLT+e5hWHJCLDjgLAt27S+S7m8YdyqftJBThVp
	cnhy1IHIdq5lJWBJrAJ4p8q0jhCZWLO/co9R3V2dELwD5bTE4xdPsZo3zfnETYQ=
X-Google-Smtp-Source: AGHT+IFFjM1+JZYieqOVS1WTqo0ehgRj/ucxZh+gtgio1p+I93k/TI6UcWW6CaniqQQbY1de0Y/Pyg==
X-Received: by 2002:a05:6a00:4647:b0:6d9:e9ea:cfc8 with SMTP id kp7-20020a056a00464700b006d9e9eacfc8mr2672108pfb.16.1705648647446;
        Thu, 18 Jan 2024 23:17:27 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id g22-20020a056a0023d600b006da14f68ac1sm4407964pfc.198.2024.01.18.23.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 23:17:27 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rQj80-00CMLy-1n;
	Fri, 19 Jan 2024 18:17:24 +1100
Date: Fri, 19 Jan 2024 18:17:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <ZaoiBF9KqyMt3URQ@dread.disaster.area>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZainBd2Jz6I0Pgm1@dread.disaster.area>
 <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Jan 19, 2024 at 09:38:07AM +0800, Zorro Lang wrote:
> On Thu, Jan 18, 2024 at 03:20:21PM +1100, Dave Chinner wrote:
> > On Mon, Dec 18, 2023 at 10:01:34PM +0800, Zorro Lang wrote:
> > > Hi,
> > > 
> > > Recently I hit a crash [1] on s390x with 64k directory block size xfs
> > > (-n size=65536 -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1),
> > > even not panic, a assertion failure will happen.
> > > 
> > > I found it from an old downstream kernel at first, then reproduced it
> > > on latest upstream mainline linux (v6.7-rc6). Can't be sure how long
> > > time this issue be there, just reported it at first.
> > >  [  978.591588] XFS (loop3): Mounting V5 Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
> > >  [  979.216565] XFS (loop3): Starting recovery (logdev: internal)
> > >  [  979.225078] XFS (loop3): Bad dir block magic!
> > >  [  979.225081] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
> > 
> > Ok, so we got a XFS_BLFT_DIR_BLOCK_BUF buf log item, but the object
> > that we recovered into the buffer did not have a
> > XFS_DIR3_BLOCK_MAGIC type.
> > 
> > Perhaps the buf log item didn't contain the first 128 bytes of the
> > buffer (or maybe any of it), and so didn't recovery the magic number?
> > 
> > Can you reproduce this with CONFIG_XFS_ASSERT_FATAL=y so the failure
> > preserves the journal contents when the issue triggers, then get a
> > metadump of the filesystem so I can dig into the contents of the
> > journal?  I really want to see what is in the buf log item we fail
> > to recover.
> > 
> > We don't want recovery to continue here because that will result in
> > the journal being fully recovered and updated and so we won't be
> > able to replay the recovery failure from it. 
> > 
> > i.e. if we leave the buffer we recovered in memory without failure
> > because the ASSERT is just a warn, we continue onwards and likely
> > then recover newer changes over the top of it. This may or may
> > not result in a correctly recovered buffer, depending on what parts
> > of the buffer got relogged.
> > 
> > IOWs, we should be expecting corruption to be detected somewhere
> > further down the track once we've seen this warning, and really we
> > should be aborting journal recovery if we see a mismatch like this.
> > 
> > .....
> > 
> > >  [  979.227613] XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check+0x372/0x6c0 [xfs], xfs_dir3_block block 0x1020 
> > >  [  979.227732] XFS (loop3): Unmount and run xfs_repair
> > >  [  979.227733] XFS (loop3): First 128 bytes of corrupted metadata buffer:
> > >  [  979.227736] 00000000: 58 44 42 33 00 00 00 00 00 00 00 00 00 00 10 20  XDB3........... 
> > 
> > XDB3 is XFS_DIR3_BLOCK_MAGIC, so it's the right type, but given it's
> > the tail pointer (btp->count) that is bad, this indicates that maybe
> > the tail didn't get written correctly by subsequent checkpoint
> > recoveries. We don't know, because that isn't in the output below.
> > 
> > It likely doesn't matter, because I think the problem is either a
> > runtime problem writing bad stuff into the journal, or a recovery
> > problem failing to handle the contents correctly. Hence the need for
> > a metadump.
> 
> Hi Dave,
> 
> Thanks for your reply. It's been a month passed, since I reported this
> bug last time. Now I can't reproduce this issue on latest upstream
> mainline linux and xfs-linux for-next branch. I've tried to do the
> same testing ~1000 times, still can't reproduce it...
> 
> If you think it might not be fixed but be hided, I can try it on older
> kernel which can reproduce this bug last time, to get a metadump. What
> do you think?

Perhaps a bisect from 6.7 to 6.7+linux-xfs/for-next to identify what
fixed it? Nothing in the for-next branch really looks relevant to
the problem to me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
