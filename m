Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742BB19B3ED
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 22:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732143241; cv=none; b=T5tPFqofzM+Zm71Lx3WBebH6nVqyzgQV+/vTI94t4CwVGKGiYj1zZSlh/r4x1FsiWwWP5K68v1AB5P5XzRZHVu1vWuNDFisxNGvmpzSQWPbvSGo+1TDJkVoTgxJyTHN4D6yX5+9WjC2alnCmxzcE/eVhPIf3uh9ZkQxDh+voyDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732143241; c=relaxed/simple;
	bh=Yn+AMrJhxvDyr5NFRzcaVYH0arIbMuSBjcaU2Cu0rBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sKRFAdYGkcTVyWZEf6Ny0oBUZ13RcAfXQ0O9DStcp1BK0wG43BNj6HSxI+VVsjboSg9F7ytJuxMEu9MKfjdlVz1qP8wsZIu5mx4Z2ZpjX2oaIpAszekqwsCA/VUe5pAbRZgyv0YOf5rhWnhc9HwJNmoWJvDp7g7/Fs481/g381E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YhPT+kKo; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YhPT+kKo"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2eacc4c9164so286943a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 14:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1732143239; x=1732748039; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OpIlqMn/s0feZOT3HHhuTTXA4GdVd8VK4Ygvn8WOph0=;
        b=YhPT+kKoq9UTFPIBpmttUfIdQsX9CUGjQn6hpWnqecsGpOH9pk+x1ZGGStmGhCfCrz
         bXJfo7kpAyUdFIYAQNCQjn0Aggd0Jt0637DSYrXXpMGDzCgdw1rs/5FwOqh1VKfeTCdF
         niD4Ai3ADsVGrcD7kMfV0WnqHPvVpZtMnwI7FU9oRtJFBoKdP0LKP1lhIo7FOQdj0gUs
         5CyHdqBBjuYsHcQvEDdzxt8VQJF45t0XjFbTUyxEzowHeXRO0xGnUOjWqtvCvcrq0bn0
         rqwH2Q9mBzkTtmCdZhUp5aaOeGJ7UfARDBcbGrBqvq3s6R4Mn1pRTBP2OwMFk1KCIIrH
         3dnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732143239; x=1732748039;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OpIlqMn/s0feZOT3HHhuTTXA4GdVd8VK4Ygvn8WOph0=;
        b=vdVJ0f5I4Q4QwZ2einSzriRV+Lm2x43M2iqeKpVgTdGpzAxr+iaXqyg3GzX6sp5l2+
         LEYxUeupeMVbwbqmm7wbDhvgjIFYbpuEGOzbI3wB8RC0pBU9gqxURUm//g/wJW3EedNj
         Sh/c4I55DZq40vIRn15aLWqjAxz00vwMORR1X/gCBTnJ/pZ+HtUGVnAcxxJpDr6S4wJq
         FFlXWv6hIojamrpJYsI/7bSPbsvOMycX9aiX4UpV2wZimmUbLKMPL3FmBf9/QV2gYo+P
         kb2WKnEsTHFWXrLi/MJzO0qY3NmpT7xDObXHHHLkE8l8dzOGdvjZqb8x5Q0XeE0vTk4T
         b6GA==
X-Forwarded-Encrypted: i=1; AJvYcCUfHWZz+woMvD4j2K5dYavOxtVRMBTsWGz0S2keGKIPz2OU6IeZRRMDF3YkTRRYmcqpkVXQrQkX7y0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyffJNSNWEF5TNybhpL4yG8LCumsP8y+DjLIxkEey5KDgK760Qb
	9s+kbkPks1qrMJaI23eP5wn1ZEBpBI2rlqMZkJSfZe5972pY2nPmhisbyEfNHbg=
X-Gm-Gg: ASbGncuzL9YG3HgaeEx5cG2fUEXhJzYK7CCtzXZMQmpva0d1mn0TlZCgiR9/cTfbeqt
	FEJqVxkMKb7stf4v0y35viiQToj4cOYVzlNtTQsCoVN6ffBxEkfgv2fEfwmqMhPPqziVygldUKn
	N0uvZG53eAv16jmZyBxnD2XE6euyum24xNcfXcsBRf7L38o5yUtm100erivQD86GO1y4/7KAaOQ
	SgukhvO+CyEnqd8295ZLemVLwe1mJhfJjZlc1+25qW15Ik9BlhMVCTtlsfo6k57AuWfLCTHZTUA
	KpeXBrbeRxolyDtADoIwTbSl4w==
X-Google-Smtp-Source: AGHT+IEo1QuTwU82hD/MIwaVhIynIO5wBU9St642b/kl/3xFbT6jtUcqMQWk7Nd7qyhS8/1VVJyvZQ==
X-Received: by 2002:a17:90b:17cf:b0:2e2:a6ef:d7a6 with SMTP id 98e67ed59e1d1-2eaca7e1b9bmr4743792a91.36.1732143238826;
        Wed, 20 Nov 2024 14:53:58 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ead02ea415sm1903177a91.2.2024.11.20.14.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 14:53:58 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tDta6-000000012l2-4032;
	Thu, 21 Nov 2024 09:53:54 +1100
Date: Thu, 21 Nov 2024 09:53:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com,
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
Message-ID: <Zz5ogh1-52n35lZk@dread.disaster.area>
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
 <ZyhAOEkrjZzOQ4kJ@dread.disaster.area>
 <CANubcdVbimowVMdoH+Tzk6AZuU7miwf4PrvTv2Dh0R+eSuJ1CQ@mail.gmail.com>
 <Zyi683yYTcnKz+Y7@dread.disaster.area>
 <CANubcdX3zJ_uVk3rJM5t0ivzCgWacSj6ZHX+pDvzf3XOeonFQw@mail.gmail.com>
 <ZzFmOzld1P9ReIiA@dread.disaster.area>
 <CANubcdXv8rmRGERFDQUELes3W2s_LdvfCSrOuWK8ge=cdEhFYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdXv8rmRGERFDQUELes3W2s_LdvfCSrOuWK8ge=cdEhFYA@mail.gmail.com>

On Sun, Nov 17, 2024 at 09:34:53AM +0800, Stephen Zhang wrote:
> Dave Chinner <david@fromorbit.com> 于2024年11月11日周一 10:04写道：
> >
> > On Fri, Nov 08, 2024 at 09:34:17AM +0800, Stephen Zhang wrote:
> > > Dave Chinner <david@fromorbit.com> 于2024年11月4日周一 20:15写道：
> > > > On Mon, Nov 04, 2024 at 05:25:38PM +0800, Stephen Zhang wrote:
> > > > > Dave Chinner <david@fromorbit.com> 于2024年11月4日周一 11:32写道：
> > > > > > On Mon, Nov 04, 2024 at 09:44:34AM +0800, zhangshida wrote:
> >
> > [snip unnecessary stereotyping, accusations and repeated information]
> >
> > > > AFAICT, this "reserve AG space for inodes" behaviour that you are
> > > > trying to acheive is effectively what the inode32 allocator already
> > > > implements. By forcing inode allocation into the AGs below 1TB and
> > > > preventing data from being allocated in those AGs until allocation
> > > > in all the AGs above start failing, it effectively provides the same
> > > > functionality but without the constraints of a global first fit
> > > > allocation policy.
> > > >
> > > > We can do this with any AG by setting it up to prefer metadata,
> > > > but given we already have the inode32 allocator we can run some
> > > > tests to see if setting the metadata-preferred flag makes the
> > > > existing allocation policies do what is needed.
> > > >
> > > > That is, mkfs a new 2TB filesystem with the same 344AG geometry as
> > > > above, mount it with -o inode32 and run the workload that fragments
> > > > all the free space. What we should see is that AGs in the upper TB
> > > > of the filesystem should fill almost to full before any significant
> > > > amount of allocation occurs in the AGs in the first TB of space.
> >
> > Have you performed this experiment yet?
> >
> > I did not ask it idly, and I certainly did not ask it with the intent
> > that we might implement inode32 with AFs. It is fundamentally
> > impossible to implement inode32 with the proposed AF feature.
> >
> > The inode32 policy -requires- top down data fill so that AG 0 is the
> > *last to fill* with user data. The AF first-fit proposal guarantees
> > bottom up fill where AG 0 is the *first to fill* with user data.
> >
> > For example:
> >
> > > So for the inode32 logarithm:
> > > 1. I need to specify a preferred ag, like ag 0:
> > > |----------------------------
> > > | ag 0 | ag 1 | ag 2 | ag 3 |
> > > +----------------------------
> > > 2. Someday space will be used up to 100%, Then we have to growfs to ag 7:
> > > +------+------+------+------+------+------+------+------+
> > > | full | full | full | full | ag 4 | ag 5 | ag 6 | ag 7 |
> > > +------+------+------+------+------+------+------+------+
> > > 3. specify another ag for inodes again.
> > > 4. repeat 1-3.
> >
> > Lets's assume that AGs are 512GB each and so AGs 0 and 1 fill the
> > entire lower 1TB of the filesystem. Hence if we get to all AGs full
> > the entire inode32 inode allocation space is full.
> >
> > Even if we grow the filesystem at this point, we still *cannot*
> > allocate more inodes in the inode32 space. That space (AGs 0-1) is
> > full even after the growfs.  Hence we will still give ENOSPC, and
> > that is -correct behaviour- because the inode32 policy requires this
> > behaviour.
> >
> > IOWs, growfs and changing the AF bounds cannot fix ENOSPC on inode32
> > when the inode space is exhausted. Only physically moving data out
> > of the lower AGs can fix that problem...
> >
> > > for the AF logarithm:
> > >     mount -o af1=1 $dev $mnt
> > > and we are done.
> > > |<-----+ af 0 +----->|<af 1>|
> > > |----------------------------
> > > | ag 0 | ag 1 | ag 2 | ag 3 |
> > > +----------------------------
> > > because the af is a relative number to ag_count, so when growfs, it will
> > > become:
> > > |<-----+ af 0 +--------------------------------->|<af 1>|
> > > +------+------+------+------+------+------+------+------+
> > > | full | full | full | full | ag 4 | ag 5 | ag 6 | ag 7 |
> > > +------+------+------+------+------+------+------+------+
> > > So just set it once, and run forever.
> >
> > That is actually the general solution to the original problem being
> > reported. I realised this about half way through reading your
> > original proposal. This is why I pointed out inode32 and the
> > preferred metadata mechanism in the AG allocator policies.
> >
> > That is, a general solution should only require the highest AG
> > to be marked as metadata preferred. Then -all- data allocation will
> > then skip over the highest AG until there is no space left in any of
> > the lower AGs. This behaviour will be enforced by the existing AG
> > iteration allocation algorithms without any change being needed.
> >
> > Then when we grow the fs, we set the new highest AG to be metadata
> > preferred, and that space will now be reserved for inodes until all
> > other space is consumed.
> >
> > Do you now understand why I asked you to test whether the inode32
> > mount option kept the data out of the lower AGs until the higher AGs
> > were completely filled? It's because I wanted confirmation that the
> > metadata preferred flag would do what we need to implement a
> > general solution for the problematic workload.
> >
> 
> Hi, I have tested the inode32 mount option. To my suprise, the inode32
> or the metadata preferred structure (will be referred to as inode32 for the
> rest reply) doesn't implement the desired behavior as the AF rule[1] does:
>         Lower AFs/AGs will do anything they can for allocation before going
> to HIGHER/RESERVED AFs/AGS. [1]

This isn't important or relevant to the experiment I asked you to
perform and report the results of.

I asked you to observe and report the filesystem fill pattern in
your environment when metadata preferred AGs are enabled. It isn't
important whether inode32 exactly solves your problem, what I want
to know is whether the underlying mechanism has sufficient control
to provide a general solution that is always enabled.

This is foundational engineering process: check your hypothesis work
as you expect before building more stuff on top of them. i.e.
perform experiments to confirm your ideas will work before doing
anything else.

If you answer a request for an experiment to be run with "theory
tells me it won't work" then you haven't understood why you were
asked to run an experiment in the first place.

If you can't run requested experiments or don't understand why an
expert might be asking for that experiment to be run, then say so.
I can explain in more detail, but I don't like to waste time on
ideas that I can't confirm have a solid basis in reality...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
