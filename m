Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FD41AA1D2
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 20:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738096768; cv=none; b=shcOQ7m1Mxg7c/9phA59Z/hg9CL1nRQmrqgupfSASaeAWDVEY2M/fE9jU3ivYxwmjI8Of0l4nBjBiZGvv/wdcKJaf9itBqSJCsHZMpW5u9Dxw6BtQR3Gyx4miyGQ5kweUVVomrh7GUBsVnbyHMLJpmvstsEm9GkG/8G9gQE/HU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738096768; c=relaxed/simple;
	bh=CrFQoQlIvOWGHaPeEtEQ/TqX2b3wRfialeu4sQisTu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n0WelLAlFv0vngICqnKUBCA2amiMbHkZoGY4uWLXrloc72gBCNrzgqqfob5b4jE0yzR3RsO8AqmfiwAVjb2zRO1VkK5qE9+mbZbdylGUQ5hk5bUfyAAcuLkxb6ho+kr0CuSnPgXay88cO1H2lFJG6osj3IvQGIV5JwU/ZCFolaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wa2nnMh+; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wa2nnMh+"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21680814d42so100338925ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 12:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738096766; x=1738701566; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HyI/V8FPf+ZW7guJPvMVwxURIQxmcui2EoggpUbVTow=;
        b=wa2nnMh+zuHulPniAaqIewITrfFH1GdQoGXaNeQtOwYsuCBUd1utBdtsuWoyah1ZEA
         P4+CXZyheUaKDsiIDUzIIqhZxOmqQNTd69jZe3LgosVcVKKlis2ZZdkkpeZT/QtC0hN9
         I/E1F3NCM7cxWs1LhiI4InLsyr/vHWJRhKpOc60CZK3lySAL99Oet4DtmWhoO5djh+0l
         XG2so7n9xwvPI+7tzgOz15etMw9x1KUJ8gapJ4AdT9dtcHpFq7ksogIZVFu/HvZsgXp4
         2QHq+5oN6FQ4lCbwX3YFS0lEg01CA6XOSLnoUFHMfP1CS0zjC3pJEDdFC2SR0KN5iUHH
         bU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738096766; x=1738701566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HyI/V8FPf+ZW7guJPvMVwxURIQxmcui2EoggpUbVTow=;
        b=xLDpxKeEcINU8ufNkntAY6x7x1FljRXCKeTUPf86YRYmBeK5XP0bTXCxVwoBkMq+2a
         68ZGjshhEDSRzOJheKAocDgnE4SdDDqz8+zOpdj4J9jyu4QkXSv1VA6L1EU6tHxvfOpl
         Lu3oQNLRjLt9+o+Gyf2L8u2m/tUgRlT09L2xJbXDZ40tmze2oSuCgB6Ao9HPNcA72OQE
         GRGMx9YcpKlTZWcg2IFDhZikGEh6tUiYP6i8EvgI3F2P0cPdadX9GtH/DpXZ7gnJMufa
         Jyaw8EffVAhg8nGHI1Hi6suRRTe8U3hUfxBGD0fd5GrsnDyqak6H6E2PfSSKhbdOIdi9
         bl7g==
X-Forwarded-Encrypted: i=1; AJvYcCVmTpSKFc2sBHw9cvDekLtuY1C7uRxoFK1z9fGizVyViHnAU94EmktontbM3lELnvfaLBxwM9NvI1g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4/PSeVLO+WuTWpvJc2mA6PMF6412ljRW2K6XTNAauQApC9b7W
	XIkvoaRkoVUO4PjlExV9XzHPUz+1rfqHZq+cZwgNxsf+eKY+yvuNC/EHH5t/RIzgf/b3igTQv8a
	f
X-Gm-Gg: ASbGncu8SjOLW9HiYEGTrLllOzELMAvebH8ZpeSRfoG7ywbU9RUPPhUjNaDJpsOHUY5
	GdkF22BEjbqj+TazFvj6EzbpB3r0EteUxaP1puQC1J/RpVHSATHi70mE+KTPfZ4hQRkm29DD6Dw
	9pH5zWT222K3MjrNYVhE5v1wOo+xs+UlhQopzX1d4XzIeAIBAmMWq9r2JmrMYS++ZDrzZKGk9Xj
	CBOJQ8BT0LqoydbUF0STA6DYiNX/Yi9aBARdSRY5aJnEhcmRPVsG7SsRrcaA8dBbNGgmsjLS3G2
	2gmgKVWJiM8FFMnutLamXl5YtLUzqSAhl3Nu3qz6Dts9+85t8MYsMAevAtfL97GVE3g=
X-Google-Smtp-Source: AGHT+IEmtEE0aixXyOPneav2GH/mQKkXuXN3wjQrG1+ELMkkfeoTrxIol2KmQpVmcWUuXVEwQFbBNQ==
X-Received: by 2002:a05:6a21:4c12:b0:1e8:becc:5771 with SMTP id adf61e73a8af0-1ed7a6e0e76mr1318322637.30.1738096765917;
        Tue, 28 Jan 2025 12:39:25 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a69fde0sm10049134b3a.18.2025.01.28.12.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:39:25 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tcsMk-0000000Bj6K-0jjM;
	Wed, 29 Jan 2025 07:39:22 +1100
Date: Wed, 29 Jan 2025 07:39:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <Z5lAek54UK8mdFs-@dread.disaster.area>
References: <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
 <Z48UWiVlRmaBe3cY@dread.disaster.area>
 <20250122042400.GX1611770@frogsfrogsfrogs>
 <Z5CLUbj4qbXCBGAD@dread.disaster.area>
 <20250122070520.GD1611770@frogsfrogsfrogs>
 <Z5C9mf2yCgmZhAXi@dread.disaster.area>
 <20250122214609.GE1611770@frogsfrogsfrogs>
 <Z5GYgjYL_9LecSb9@dread.disaster.area>
 <Z5heaj-ZsL_rBF--@dread.disaster.area>
 <20250128072352.GP3557553@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128072352.GP3557553@frogsfrogsfrogs>

On Mon, Jan 27, 2025 at 11:23:52PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 28, 2025 at 03:34:50PM +1100, Dave Chinner wrote:
> > On Thu, Jan 23, 2025 at 12:16:50PM +1100, Dave Chinner wrote:
> > 4. /tmp is still shared across all runner instances so all the
> > 
> >    concurrent runners dump all their tmp files in /tmp. However, the
> >    runners no longer have unique PIDs (i.e. check runs as PID 3 in
> >    all runner instaces). This means using /tmp/tmp.$$ as the
> >    check/test temp file definition results is instant tmp file name
> >    collisions and random things in check and tests fail.  check and
> >    common/preamble have to be converted to use `mktemp` to provide
> >    unique tempfile name prefixes again.
> > 
> > 5. Don't forget to revert the parent /proc mount back to shared
> >    after check has finished running (or was aborted).
> > 
> > I think with this (current prototype patch below), we can use PID
> > namespaces rather than process session IDs for check-parallel safe
> > process management.
> > 
> > Thoughts?
> 
> Was about to go to bed, but can we also start a new mount namespace,
> create a private (or at least non-global) /tmp to put files into, and
> then each test instance is isolated from clobbering the /tmpfiles of
> other ./check instances *and* the rest of the system?

We probably can. I didn't want to go down that rat hole straight
away, because then I'd have to make a decision about what to mount
there. One thing at a time....

I suspect that I can just use a tmpfs filesystem for it - there's
heaps of memory available on my test machines and we don't use /tmp
to hold large files, so that should work fine for me.  However, I'm
a little concerned about what will happen when testing under memory
pressure situations if /tmp needs memory to operate correctly.

I'll have a look at what is needed for private tmpfs /tmp instances
to work - it should work just fine.

However, if check-parallel has taught me anything, it is that trying
to use "should work" features on a modern system tends to mean "this
is a poorly documented rat-hole that with many dead-ends that will
be explored before a working solution is found"...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
