Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973D32EAE6
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 06:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737525713; cv=none; b=g+HsLJjoqrbYUUOsSx2JcLg96mw0aK0COpRIFWPsO2Cmqmh8FuFsYpR16dfk3hdi214dc4aWW4JW3IWJZsA4QmK3aTFDeF7j2PkKnxGC3zb1VHgpYGE3QK5/RUhC/FjEqOPjBuAdm/j9DvU5quKK+vGemV99JUacftLYsUUPWbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737525713; c=relaxed/simple;
	bh=0RjHZ4t/PHYR0tptcFGYcpDfn88fYToZPWru5bDIDew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2D3YEz0fhqqRZidPLP82St7XdYQfOtNIn6FJgoJvndGt3EfCZefLRr8EPoIsnyyNGrKY6nXK2eB6KarRi63bYY2umbaFImgenHcZRYP4f6PKFysolVEosYms7xtyTOrjc2yz/pAPH/gTUWI9riiXkC1MNmaAzBGGgCq7CgfQpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FOGwZLZz; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FOGwZLZz"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2161eb94cceso81267575ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 22:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737525711; x=1738130511; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqQC5hj+jnYRV6YRnsTRti7ufZmru3OTilR9kB8mbaI=;
        b=FOGwZLZzxjtPJHv/3m5SNVjLso/F2vrYP4aowC9QnWLgJtpWpN7dT7Wt4CmXCtzctw
         zTwmY+KfPUf9nk2mMHGb0frCbPC0/nZr0bKsvLYOm/IQqLOvoExC60wL735a/36W/7ZQ
         EqceT1+/MVN1kzL6/c4AjiqCFzK3W9XLV12fITxy3gCjZtAGM0wZroajkh92HDBmEg+Z
         +49UlUEj3EYQMCepQ8rkwbmBu1t6kycM7Vrs72bHiGIj5xWKKVxwNq/4G5K/m0A5bkGI
         8CV0V09JzLCjwFXfkOEG6iVHri1asw9halo+PJX9/n1djE/n1AGsSWCj/BI15TRzcdRF
         cjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737525711; x=1738130511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqQC5hj+jnYRV6YRnsTRti7ufZmru3OTilR9kB8mbaI=;
        b=HgROv7lZG4mEIHwO+4Yf18ky32me62roHWm/OzpQda4Gx4yaVKYS4O23XCPjo5nRMj
         7iE7ZVBeVe6DvTz9t1VhdwUvbFccvJc1iWJG3LbKlG+iKsTzNnAIkdVgrGbNmijpmOJ7
         aRiwVfgTThOzo7dlYu8MNaujLVb8DFyKiXORnd+AEOUDDSCroxHCk0TsUh/ZBa5zJJ8M
         h4gwPgjaWxVTtIqv50jTWHhHf14Ee5cLFr5c6/2BYeavwctyoLVCjyanZwkpEnktzGYE
         4SUYstqLdIzk5YgojOKwRLp+4qPrzpXdU2b7baK/m6eVxbGVQra10pi6F5ssL8tc/ooS
         ZynQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5dBLIPGUCdvSrwkW3FBYHjGIDV+fCF8NOXX2zW9qEIDXSsRvXfWb8w+IO3RLEM498GJyjZl+iqac=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz63JPrnQqqEvNf7lGwPsx92vTz93l4d8RypQDeFFPEcYK6P8X
	t5+DLWei7QnouEuuUTQ1YGunqHdgxZN2SO13iINPp01Ij+OyxbhODEg9QQ+5UqA=
X-Gm-Gg: ASbGncvk0F5Y87uzI5QnQHswubfgmkuM+t9Nf+xpwxbnt7EMdpCY8rMr2DD7MttNTZQ
	/JJStNb8JyqreoeKkDK+5mELjxB+/4RkMG+JppycRKb+/RAdSr65sy4ol8kmKRVqG6d9u5/l4qJ
	62wj664dgrNOD18s1T/hvbrZDeJR8uGlFkqYSCMFsRrEMtjlt0Gfnn/KFO2bYMhVysndwmT/PWN
	ZNABYcm/4gY/DoTMXOO+wa7LottrcXa0bDjUVor5Vg/9U95y5Mz6k3WMNQTrBYrzXk45+CCKlxG
	ttIkgowliZimfj/gY4dbyDjeUoe3pzQuNsI=
X-Google-Smtp-Source: AGHT+IGrHNJZ0d3oMfymu7odQjyBCijM88SSYfORRP1XboGnp4b2s7Wyw3twPdrNlrftEiws9QTnFA==
X-Received: by 2002:a05:6a21:6d87:b0:1e6:5323:58cb with SMTP id adf61e73a8af0-1eb214afd38mr30571125637.23.1737525710873;
        Tue, 21 Jan 2025 22:01:50 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dababebacsm10428217b3a.179.2025.01.21.22.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 22:01:50 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1taToB-00000008yI0-39Ji;
	Wed, 22 Jan 2025 17:01:47 +1100
Date: Wed, 22 Jan 2025 17:01:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com, hch@lst.de,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/23] generic/650: revert SOAK DURATION changes
Message-ID: <Z5CJy195Fh36NNHN@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974273.1927324.11899201065662863518.stgit@frogsfrogsfrogs>
 <Z48pM9GEhp9P_VLX@dread.disaster.area>
 <20250121130027.GB3809348@mit.edu>
 <Z5AclEe71PIikAnH@dread.disaster.area>
 <20250122040839.GD3761769@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122040839.GD3761769@mit.edu>

On Tue, Jan 21, 2025 at 11:08:39PM -0500, Theodore Ts'o wrote:
> On Wed, Jan 22, 2025 at 09:15:48AM +1100, Dave Chinner wrote:
> > check-parallel on my 64p machine runs the full auto group test in
> > under 10 minutes.
> > 
> > i.e. if you have a typical modern server (64-128p, 256GB RAM and a
> > couple of NVMe SSDs), then check-parallel allows a full test run in
> > the same time that './check -g smoketest' will run....
> 
> Interesting.  I would have thought that even with NVMe SSD's, you'd be
> I/O speed constrained, especially given that some of the tests
> (especially the ENOSPC hitters) can take quite a lot of time to fill
> the storage device, even if they are using fallocate.

You haven't looked at how check-parallel works, have you? :/

> How do you have your test and scratch devices configured?

Please go and read the check-parallel script. It does all the
per-runner process test and scratch device configuration itself
using loop devices.

> > Yes, and I've previously made the point about how check-parallel
> > changes the way we should be looking at dev-test cycles. We no
> > longer have to care that auto group testing takes 4 hours to run and
> > have to work around that with things like smoketest groups. If you
> > can run the whole auto test group in 10-15 minutes, then we don't
> > need "quick", "smoketest", etc to reduce dev-test cycle time
> > anymore...
> 
> Well, yes, if the only consideration is test run time latency.

Sure.

> I can think of two off-setting considerations.  The first is if you
> care about cost.

Which I really don't care about.

That's something for a QE organisation to worry about, and it's up
to them to make the best use of the tools they have within the
budget they have.

> The second concern is that for certain class of failures (UBSAN,
> KCSAN, Lockdep, RCU soft lockups, WARN_ON, BUG_ON, and other
> panics/OOPS), if you are runnig 64 tests in parllel it might not be
> obvious which test caused the failure.

Then multiple tests will fail with the same dmesg error, but it's
generally pretty clear which of the tests caused it. Yes, it's a bit
more work to isolate the specific test, but it's not hard or any
different to how a test failure is debugged now.

If you want to automate such failures, then my process is to grep
the log files for all the tests that failed with a dmesg error then
run them again using check instead of check-parallel.  Then I get
exactly which test generated the dmesg output without having to put
time into trying to work out which test triggered the failure.

> Today, even if the test VM
> crashes or hangs, I can have test manager (which runs on a e2-small VM
> costing $0.021913 USD/hour and can manage dozens of test VM's all at the
> same time), can restart the test VM, and we know which test is at at
> fault, and we mark that a particular test with the Junit XML status of
> "error" (as distinct from "success" or "failure").  If there are 64
> test runs in parallel, if I wanted to have automated recovery if the
> test appliance hangs or crashes, life gets a lot more complicated.....

Not really. Both dmesg and the results files will have tracked all
the tests inflight when the system crashes, so it's just an extra
step to extract all those tests and run them again using check
and/or check-parallel to further isolate which test caused the
failure....

I'm sure this could be automated eventually, but that's way down my
priority list right now.

> I suppose we could have the human (or test automation) try run each
> individual test that had been running at the time of the crash but
> that's a lot more complicated, and what if the tests pass when run
> once at a time?  I guess we should happen that check-parallel found a
> bug that plain check didn't find, but the human being still has to
> root cause the failure.

Yes. This is no different to a test that is flakey or compeltely
fails when run serially by check multiple times. You still need a
human to find the root cause of the failure.

Nobody is being forced to change their tooling or processes to use
check-parallel if they don't want or need to. It is an alternative
method for running the tests within the fstests suite - if using
check meets your needs, there is no reason to use check-parallel or
even care that it exists...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
