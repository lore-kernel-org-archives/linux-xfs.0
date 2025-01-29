Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EC014F6C
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jan 2025 06:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738130819; cv=none; b=BXBIrd7gFyXG5I6dTSocciKaIQ5knYO7mDDj2oStmB/P0x/Z8Kaeu07DXiWdY33FzEEy6UP3eFp1lBH+UbwgtNSw9Z93Lj70d/V4Y5VKhJuGw6C/ImTly/6YmGhzTUIf8q8Eq+0HrcZqzVcM7M7GA0LYUbec9l8ru+3lrVcK4WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738130819; c=relaxed/simple;
	bh=Taa73zJhSXOuB2KmDli7srsvGbZ70bw+kofesNjGJR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pH5SsPMqvMUw3nt8u3xuCIHLoonmg2nWhUN5jNQy54sVTKt+gBYkmVfES/czaiOVPaFScAStrlExEdtgla3q8ZZ/XPVAicULar5SHpfBXpdx7E8hZHo08YhdHVbNK4ADJgNQAeeXDZIz/2pl7Q+diggMMiKvKS5qa/dquiwQGFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=RD3gJcgr; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="RD3gJcgr"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21661be2c2dso110447255ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 22:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738130816; x=1738735616; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=05h+/zAx3Q++Rgdg0SMjBS/g37mGzexiku0BsuXqWMM=;
        b=RD3gJcgrFCTGCS73LZeUc7tuVRa6EFNRrJCanIunuA+KnPiw8VqRmTDInAS76lgtal
         mde3yTnRzIp/caerIj/Q/IlakG4U1ksYbQDq5/jTg1bSfwnh/rpzCjCehZEdb1VhIZ7C
         ar2DCPF6Vzl+4tVi96+Bo0khWhFVtj+MMkoEndHu0X9WpsTcaYXR/Lppa88Tuej3Swue
         9yQPYo6j9hMXgXIKrgjIagTecvpeCVtllsPn5fuwdxkjq+gsjgaFGdT/76tYXpAlA607
         2Ag3G6+d+Rxwoh9VDSL2Kh5s16/AUEQFjmlhpHzW6hPrSi2YMSNYy2+295rIRb+s63Yv
         ecEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738130816; x=1738735616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05h+/zAx3Q++Rgdg0SMjBS/g37mGzexiku0BsuXqWMM=;
        b=D+DqixWngycaL8mLwW3OVW+2izSdh7G/GoQ1giqfLuaYAVs+qOYYVSTO7bgnyTp0ns
         IfJq6MLGSYbvBaYvwNBLZmauTV1eWE7fFPVMH3b2v2QJYSekfRmUpLwv4dpZ5Xm9RccO
         y2t7YJO5+5CmTN9GPJ0ufWD1g1dbIXQ3cUGrIIm733uFYTAGlMeyrSeT6j7lPuN7eZc9
         3O3AImONXe4ZKDO2dueBu4/JuvP/Ggn0P1x7o+BabPjywEY4OI3ZPFGWsQ5PrSiPw9Br
         OOZ7f4BGoyMc3p5m5/M2I5cY2Cu9Fd9wVgfCq60cKmEqt/qYkVCWyYUYoSaxfvICsvpB
         2pvQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2AaAsAw3Prz2J3UVyICI2OYqN/HUA/0S/UI2AhGxqNfbgI9nwr/w99u9fq8yHrns+iEobGplHeU0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeAN2qLOnUH6IMWAeXAnWOck6fkEEvnyeHpEpjRUMX3Q6LEVVT
	/uHT5X3728ZxiqRbzCfLs/TMHZ5NMXilgUpiSAuQ/z5sgeEdKUBPFkDN0+Hmrts=
X-Gm-Gg: ASbGnctuk72/70N1eQTWlTjGAsLfBs+11TJaSmFtW8Cvp7znUB+8KxoF2huKYhzGZtm
	DziWl93GFJtszunZcIFMsrNd/HKISnR3NO6x7u3FAJb/nffnteSSr+5gSoUSiFSaBpYpO3yC+vU
	1OtdBvBNSmWVfg5zXphpVrTpOGynuhx9yE60Khe2XyOqAtiskrNL8QUA6OJ+36IC03m2+9DL7MI
	Gq7OiTkVd8YbgbBqnrRwBp85Kz2OSyhw9/bqwmYeHsiKUTSXmNLK6NtFgo57FgBN+qchOjFQwmr
	JSWuxs2NTVBm8TBSlwdJauJyp6FQ8VLuaUA4VfHWek2VimEsk6r5pEnglVG/5p38/WY=
X-Google-Smtp-Source: AGHT+IHo44f8AuO3eN0dp/9kstSL1hVKmS3/23zY92XcOH3JBc0ajEZU6Kd37qLBxjnslfuTEnRnrg==
X-Received: by 2002:a17:902:da86:b0:215:6b4c:89fa with SMTP id d9443c01a7336-21dd7c4e3aamr21414375ad.8.1738130816607;
        Tue, 28 Jan 2025 22:06:56 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da4141e2dsm92284865ad.124.2025.01.28.22.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 22:06:56 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1td1Dw-0000000BtEr-381K;
	Wed, 29 Jan 2025 17:06:52 +1100
Date: Wed, 29 Jan 2025 17:06:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <Z5nFfCD8Km_A3AnA@dread.disaster.area>
References: <20250122042400.GX1611770@frogsfrogsfrogs>
 <Z5CLUbj4qbXCBGAD@dread.disaster.area>
 <20250122070520.GD1611770@frogsfrogsfrogs>
 <Z5C9mf2yCgmZhAXi@dread.disaster.area>
 <20250122214609.GE1611770@frogsfrogsfrogs>
 <Z5GYgjYL_9LecSb9@dread.disaster.area>
 <Z5heaj-ZsL_rBF--@dread.disaster.area>
 <20250128072352.GP3557553@frogsfrogsfrogs>
 <Z5lAek54UK8mdFs-@dread.disaster.area>
 <20250129031313.GV3557695@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250129031313.GV3557695@frogsfrogsfrogs>

On Tue, Jan 28, 2025 at 07:13:13PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 29, 2025 at 07:39:22AM +1100, Dave Chinner wrote:
> > On Mon, Jan 27, 2025 at 11:23:52PM -0800, Darrick J. Wong wrote:
> > > On Tue, Jan 28, 2025 at 03:34:50PM +1100, Dave Chinner wrote:
> > > > On Thu, Jan 23, 2025 at 12:16:50PM +1100, Dave Chinner wrote:
> > > > 4. /tmp is still shared across all runner instances so all the
> > > > 
> > > >    concurrent runners dump all their tmp files in /tmp. However, the
> > > >    runners no longer have unique PIDs (i.e. check runs as PID 3 in
> > > >    all runner instaces). This means using /tmp/tmp.$$ as the
> > > >    check/test temp file definition results is instant tmp file name
> > > >    collisions and random things in check and tests fail.  check and
> > > >    common/preamble have to be converted to use `mktemp` to provide
> > > >    unique tempfile name prefixes again.
> > > > 
> > > > 5. Don't forget to revert the parent /proc mount back to shared
> > > >    after check has finished running (or was aborted).
> > > > 
> > > > I think with this (current prototype patch below), we can use PID
> > > > namespaces rather than process session IDs for check-parallel safe
> > > > process management.
> > > > 
> > > > Thoughts?
> > > 
> > > Was about to go to bed, but can we also start a new mount namespace,
> > > create a private (or at least non-global) /tmp to put files into, and
> > > then each test instance is isolated from clobbering the /tmpfiles of
> > > other ./check instances *and* the rest of the system?
> > 
> > We probably can. I didn't want to go down that rat hole straight
> > away, because then I'd have to make a decision about what to mount
> > there. One thing at a time....
> > 
> > I suspect that I can just use a tmpfs filesystem for it - there's
> > heaps of memory available on my test machines and we don't use /tmp
> > to hold large files, so that should work fine for me.  However, I'm
> > a little concerned about what will happen when testing under memory
> > pressure situations if /tmp needs memory to operate correctly.
> > 
> > I'll have a look at what is needed for private tmpfs /tmp instances
> > to work - it should work just fine.
> > 
> > However, if check-parallel has taught me anything, it is that trying
> > to use "should work" features on a modern system tends to mean "this
> > is a poorly documented rat-hole that with many dead-ends that will
> > be explored before a working solution is found"...
> 
> <nod> I'm running an experiment overnight with the following patch to
> get rid of the session id grossness.  AFAICT it can also be used by
> check-parallel to start its subprocesses in separate pid namespaces,
> though I didn't investigate thoroughly.

I don't think check-parallel needs to start each check instance in
it's own PID namespace - it's the tests themselves that need the
isolation from each other.

However, the check instances require a private mount namespace, as
they mount and unmount test/scratch devices themselves and we do not
want other check instances seeing those mounts.

Hence I think the current check-parallel code doing mount namespace
isolation as it already does should work with this patch enabling
per-test process isolation inside check itself.

> I'm also not sure it's required for check-helper to unmount the /proc
> that it creates; merely exiting seems to clean everything up? <shrug>

Yeah, I think tearing down the mount namespace (i.e. exiting the
process that nsexec created) drops the last active reference to the
mounts inside the private namespace and so it gets torn down that
way.

So from my perspective, I think your check-helper namespace patch is
a good improvement and I'll build/fix anything I come across on top
of it. Once your series of fixes goes in, I'll rebase all the stuff
I've got on top it and go from there...

> I also tried using systemd-nspawn to run fstests inside a "container"
> but very quickly discovered that you can't pass block devices to the
> container which makes fstests pretty useless for testing real scsi
> devices. :/

Yet another dead-end in the poorly sign-posted rat-hole, eh?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
