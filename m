Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9F61B87F3
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 22:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737497124; cv=none; b=UEiktEuI/AQ3vkUiNjwMo5Q+hbLxmN3loGihgdGLiMe9opVLuc/mxzz1drkhyExols665ESCvYJuOJcHsAAKBKxKlVDlWVWvRTG1GmtbgpR4qFg//DrY5Q+O8DeIY75SumS7vp5Y3xUoVXLqNhP9v1fLUOwdGDNzmQ4ZdiuG7tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737497124; c=relaxed/simple;
	bh=JxkSA1+o9o9ouuhpNx9UTa7SOc8NvrSPsLX/KynJQdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGzXymjFX2fUjCJ01a0M9jtCOUawY1aLeG2HmAgLrZx0xM5/3Pak54atldm1qljkpBvNJuj5DMkEiwDxVOBwNfDw274TQDsI8gGxCub6qjnlU9BqbKBwwaXg/leJK4/1+mUxxTT4Pkxf0gK7nLmv5yo0nDrRVRT7wfale8sYU/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=RFCzPo8+; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="RFCzPo8+"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ef6c56032eso8015085a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 14:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737497122; x=1738101922; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4e8+Mj3cRgobogPNAclKWWgs48AdKLwKCVXRuVShalY=;
        b=RFCzPo8+BFs4rCpDEPOR7ZJlmknbkuoM3HIqdyGfL5lnMhhpqI2VtwUk8R66YdcJCc
         dicOq9TWV19NNO9Eq/JWfs79OImjbyDmr95wIZu6DWKDd2lOI/eLe69pq36B5xtTFKac
         LY9hdocdWePwLQpcRqAsrkmn91tyk4byQnYypHrx7Z7AH4IwBDkvC9WVK18huS5Hx36K
         7tZOusUc7WKU2AHUXUq1B7wJb7e0qf+M7d37zYHgxaOQFSaoC2uKYyQXRW3nFCxIpwao
         RCNBgqsatEud7ChK/ZA8+EnA8sHQ2ItLU7wCJ68/rGwx27igb5e/30jRRbRU21Gs39Lc
         gv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737497122; x=1738101922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4e8+Mj3cRgobogPNAclKWWgs48AdKLwKCVXRuVShalY=;
        b=DtjjSEMTAibzK+ZJEQdYVtUoo4AjQ71ff4fobdnr8bC49ttcrdAEdRLByXnEcERQpE
         fRNCv1bkIzZlMj5Ym5HiryL1XVyj6aGLaQiDJ9bAeUlDFlMeM2pz8inovqN87Ktr4euR
         egWOYHo22nSzrSF+vUT4NFmQmNcCGmIWttOZDLB3xfCpQBDH5FY+Ihgm2tsVCnsa/5us
         w+qyX+iBlmULWmhh0HSU4473uPc7YeJgjDOFZ0WGssd1QMNdUuGnfGf3gmuVyFLULtLz
         HirpquWSYFHaWUFa50375iIISirss5rFyuxo0ImCTenhxT6ny+y2bxaj+6FEVZF/iZel
         7u9g==
X-Forwarded-Encrypted: i=1; AJvYcCU20ti7MlnN7QpBgwZ8bJ1FUPwud68JPALpj75fovYIP7Yay1+JhRERfKen7KMYsc3w6FyjIf6tSeU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0ibb+xOkYJXLesw1qwDOGYQU0hUgRsagMbzwHbXmLtZK9D20E
	3iv0dT6iZfpDOF5MRw3IVPRy15aknmldDYyfOOxMJCaOxQMs6buDvAgeJThuVtA=
X-Gm-Gg: ASbGnctBZZLcd+U+44xZhjnzIUvTGGaeL7nm3RdWWOayPweDsmHvDJhOAqPSq2ELVKB
	r8AbE1NU3jsntDQixxDZ5I3+Q4k55d2aSEtxj/7qaQvkTK9diiE+tDgYd4Ur+NAZX5Fi47NKcww
	hCYX1cxRuOCv4YtS4w73M7Rc7j2juKD9ZH2MqjCSUqqpEww0USB49WaJfe/o68t2VGomPyP3QNp
	rgbKagQpKHYvluzBacLXlcjSfWarghtwoyzcqIgwlP+++ATgtO+ThqRtUaxqbpuq3wFpX3OmTob
	dIcm2cdzwxcBohypxJjdVCcvqrqA20WQVB5durBLG86oRA==
X-Google-Smtp-Source: AGHT+IGdmW5oc8V4toK1cTqRN4u+7FrMe8moGwAsy1AeGmD6BVgcsyMf6IFWMbfklN0hSdOv9CDeRg==
X-Received: by 2002:a05:6a00:2444:b0:727:d55e:4bee with SMTP id d2e1a72fcca58-72daf92b010mr26192289b3a.1.1737497121988;
        Tue, 21 Jan 2025 14:05:21 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72daba48cd0sm9724753b3a.131.2025.01.21.14.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 14:05:21 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1taMN4-00000008pb2-2u1Q;
	Wed, 22 Jan 2025 09:05:18 +1100
Date: Wed, 22 Jan 2025 09:05:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com, hch@lst.de,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/23] mkfs: don't hardcode log size
Message-ID: <Z5AaHkvdwqHKpPyO@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974228.1927324.17714311358227511791.stgit@frogsfrogsfrogs>
 <Z48bYVRvWt-wPmUz@dread.disaster.area>
 <20250121124430.GA3809348@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121124430.GA3809348@mit.edu>

On Tue, Jan 21, 2025 at 07:44:30AM -0500, Theodore Ts'o wrote:
> On Tue, Jan 21, 2025 at 02:58:25PM +1100, Dave Chinner wrote:
> > > +# Are there mkfs options to try to improve concurrency?
> > > +_scratch_mkfs_concurrency_options()
> > > +{
> > > +	local nr_cpus="$(( $1 * LOAD_FACTOR ))"
> > 
> > caller does not need to pass a number of CPUs. This function can
> > simply do:
> > 
> > 	local nr_cpus=$(getconf _NPROCESSORS_CONF)
> > 
> > And that will set concurrency to be "optimal" for the number of CPUs
> > in the machine the test is going to run on. That way tests don't
> > need to hard code some number that is going to be too large for
> > small systems and to small for large systems...
> 
> Hmm, but is this the right thing if you are using check-parallel?

Yes. The whole point of check-parallel is to run the tests in such a
way as to max out the resources of the test machine for the entire
test run. Everything that can be run concurrently should be run
concurrently, and we should not be cutting down on the concurrency
just because we are running check-parallel.

> If
> you are running multiple tests that are all running some kind of load
> or stress-testing antagonist at the same time, then having 3x to 5x
> the number of necessary antagonist threads is going to unnecessarily
> slow down the test run, which goes against the original goal of what
> we were hoping to achieve with check-parallel.

There are tests that run a thousand concurrent fsstress processes -
check-parallel still runs all those thousand fsstress processes.

> How many tests are you currently able to run in parallel today,

All of them if I wanted. Default is to run one test per CPU at a
time, but also to allow tests that use concurrency to maximise it.

> and
> what's the ultimate goal?

My initial goal was to maximise the utilisation of the machine when
testing XFS. If I can't max out a 64p server with 1.5 million
IOPS/7GB/s IO and 64GB RAM with check-parallel, then check-parallel
is not running enough tests in parallel.

Right now with 64 runner threads (one per CPU), I'm seeing an
average utilisation across the whole auto group XFS test run of:

-50 CPUs
- 2.5GB/s IO @ 30k IOPS
- 40GB RAM

The utilisation on ext4 is much lower and runtimes are much longer
for (as yet) unknown reasons. Concurrent fsstress loads, in
particular, appear to run much slower on ext4 than XFS...

> We could have some kind of antagonist load
> which is shared across multiple tests, but it's not clear to me that
> it's worth the complexity.

Yes, that's the plan further down the track - stuff like background
CPU hotplug (instead of a test that specifically runs hotplug with
fsstress that takes about 5 minutes to run), cache dropping to add
memory reclaim during tests, etc

> (And note that it's not just fs and cpu
> load antagonistsw; there could also be memory stress antagonists, where
> having multiple antagonists could lead to OOM kills...)

Yes, I eventually plan to use the src/usemem.c memory locker to
create changing levels of background memory stress to the test
runs...

Right now "perturbations" are exercised as a side effect of random
tests performing these actions. I want to make them controllable by
check-parallel so we can exercise the system functionality across
the entire range of correctness tests we have, not just an isolated
test case.

IOWs, the whole point of check-parallel is to make use of large
machines to stress the whole OS at the same time as we are testing
for filesystem behavioural correctness.

I also want to do it in as short a time period as possible - outside
of dedicated QE environments, I don't beleive that long running
stress tests actually provide value for the machine time they
consume. i.e. returns rapidly diminish because stress tests
cover 99.99% of the code paths they are going to exercise in the
first few minutes of running.

Yes, letting them run for longer will -eventually- cover rarely
travelled code paths, but for developers, CI systems and
first/second level QE verification of bug fixes we don't need
extended stress tests.

Further, when we run fstests in the normal way, we never cover
things like memory reclaim racing against unmount, freeze, sync,
etc. And we never cover them when the system is under extremely
heavy load running multiple GB/s of IO whilst CPU hotplug is running
whilst the scheduler is running at nearly a million context
switches/s, etc.

That's exactly the sort of loads that check-parallel is generating
on a machine just running the correctness tests in parallel. It
combines correctness testing with a dynamic, stressful environment,
and it runs the tests -fast-. The coverage I get in a single 10
minute auto-group run of check-parallel is -much higher- than I get
in a single auto-group run of check that takes 4 hours on the same
hardware to complete....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
