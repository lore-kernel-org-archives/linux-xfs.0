Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D56372EEC
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327180; cv=none; b=uaFN9TDYIFHbygkTkiNLtVzuAdqKDPT5DewoWuBDEeHOf7id9bc/mUzlXEgZfdRZdIaqQlwxD552ytx7luM9d+5AIVivr/2f6peYY9c0bSHPk1nMJoFdKSZCw/bwaKF8ZnVeijdp3tWoE8QBGGZ6Ln8t/I33kjZbBRN0ctkgrAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327180; c=relaxed/simple;
	bh=eK2/nD0cipE7ctdExFcuzqKayHljOgBQrh/6KU+N2P8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PxCntQXdI+gn0ESWkhTR+Urp1UYtm9ZLmoYX+ZjR9n2s0FA/8YbdWXJUa3c5UFKvpcyRQNeZK0u7/A8mJRByg4eAxlBEyMIsum0ZQ2uDrb5AZCTbjhd9ZnQulZRt/iOVDYXBZlh6cOmNLUthIIwnxC+jLVNbUpzT0KSJ0GwEVvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qOtELc/r; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qOtELc/r"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d71ae3455aso9956255ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2026 22:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788327178; x=1788931978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7ljdS7b68I6CSMzxXA6J/mAbLSjxMVryYz7zy2OGKE8=;
        b=qOtELc/ryddoFYFU9d2YIZpDg132Ge3km1FyDMh52YaO974mvqe82kwWCQu86ePzBa
         9XoLYHbqpI4LmyZObUvFXZuYyJNnO+lU+HRDcmFcV6kckG+uaLPNrAcphbax7WATHI6Q
         BIP6ui6QfvMNGcnIZSvbA2g1stzccN/uPoOAuTXNQziR/CkGWdL4aoSLXnlKegQzioYz
         Ddiol6jshIm+Uy8vet2NhK8dBk72mqYl3bSldzaGLNHs7Px7SKaXsLQG3e0jlzO9Xiji
         cZTushoOWeMiztVRWhEPBM3jis2xu1OCy4MWF9AFgZ3T1SJnXuVswpVZhB8Yuf3unyrC
         WrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788327178; x=1788931978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7ljdS7b68I6CSMzxXA6J/mAbLSjxMVryYz7zy2OGKE8=;
        b=EFEnxibC18c18Q9vOeahRwNFWBIHN1aOn7eu/LAdzpQzbPi0o4GoRShxGZEWjjTBZH
         dUZXTFbHrC9VNwjYGPApt6Qohm4/h1/3YbEIZd7+JK5utOBp/Axw2Nakwf1FLWarD4tK
         nKvzXbiLemaLNH3m7CBwndzWlkwph+qQ2Xq8rffNd1l+iyNc589zGbtI48mgSMBHmRXL
         9fEU6tOSB1rGw4ekAEgfKKZddzhRpB3VTafddztkg74IXob41Sxx4Z/vKLgIBYHgKxs2
         FjVH9h6Wyb4gELq9zC3YbhP8KxH/TKUIupJQjXuxcExnZ5qYVFGTqxTEqFzEGSSzW8h9
         UrRw==
X-Forwarded-Encrypted: i=1; AHgh+Rrg6t+Lgq4i9x59qXXtoZzwOW1NO/0wUZtjGQ/y3HTZRFCGj4+UKTdByGwofnqdDZ8qm5Nj+axvKXI=@vger.kernel.org
X-Gm-Message-State: AFuF++kCGa5owt1VpGm31MLTOKDAmtKxyIoTEXSnPasGe90BJU06+tTM
	mz1XIlP9IAJEm28jG1KGDfR76YRqswGZURZz1cSSkRVtJ9I2qtDDcsT36A3kE54/
X-Gm-Gg: AR+sD10/azP6YoRe0JdxcJSNrnrPYq59XpEDNpJcUeM0E2AQFn/XrwktaP/IDz7ULw9
	g+BqdaSJbVZOb4+4rUY1EqS8y7GGP3ByPQL0gKzwVLfowOufa7rAGvcb2OOXJBgwhleYVFzQBmb
	v02kvJlfFd2GUyu5UzjQwjtLQ9/fhi7zMvBwrmq8kdSVMG46BCPQu6g1mALq1sRhd1iqt3jRn/Z
	dAXEcC/cIGTKBALOCUHYbg1Sb+yi0eZvnOtP92oQnxQuSQ07RHGuc/ygEbACPsxCYO25vCKTmlP
	4Xdj2KnI8QHwiC/DY2jEZgapE5oXji9giSQxjnaOHq8tCcMQLcIVOr5Woljbm1m2ICB9KxFKSBp
	08QFjGGnwU+Bc1wTHDeNLavjAJti8vFEQDiD/k/awXczWuRIrqLyavNFIHDNN6W9q7g7GydGBlj
	/etddTS0Q8Q65bFF0j8YJtPri5PIhjAh/mRe8j+qRZIz0QEeLxdJ6P5y+Q+0bbPqUvWT/o/vqki
	k22WcD0l4zLfBqmLop6+nUzQFpApa1qySmcR7urfxWQOY7t/8d3L30=
X-Received: by 2002:a17:903:b06:b0:2d9:383a:30f1 with SMTP id d9443c01a7336-2daec5dfde6mr38882195ad.4.1788327178433;
        Tue, 01 Sep 2026 22:32:58 -0700 (PDT)
Received: from lima-xfs.. (174-126-236-85.cpe.sparklight.net. [174.126.236.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd4a999asm7113905ad.60.2026.09.01.22.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 22:32:58 -0700 (PDT)
From: Eric Peterson <linuxinstalled@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	eric.peterson@hpe.com,
	Eric Peterson <linuxinstalled@gmail.com>
Subject: Re: [PATCH] xfs: add per-mount read/write I/O completion counters
Date: Tue,  1 Sep 2026 23:32:30 -0600
Message-Id: <20260902053230.4073608-1-linuxinstalled@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <apSgHPl4er6Jy9xi@dread>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com> <apSgHPl4er6Jy9xi@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 31, 2026 at 09:38 UTC, Dave Chinner wrote:
> Hence I'm asking how this new metric is supposed to be used and
> correlated to observed/measured application behaviour. i.e. what
> insight does it give you into application performance that can only
> be derived from this point in time snapshot?

My apologies - it wasn't my intention to come across as patronizing.
I was unsure what background was or wasn't common ground, so I erred on
the side of more detail.

You're right about the sampling limitation: a slowly-sampled
point-in-time queue depth value cannot characterize bursty,
sub-interval concurrency. If the goal is to resolve what happens inside
a 10ms burst, this is the wrong tool - per-op tooling (tracepoints,
histograms) is the right one, and this is not meant to replace it.

The important part is that this is a property of the sampling rate, not
of the counters. Nyquist-Shannon says that to observe a phenomenon at
timescale T you have to sample at >= 2/T; if you sample slower than the
behavior you care about, it will be missed. This is true of any sampled
counter, including the existing submission counter - in your 10Hz pmval
example, xfs.read has exactly the same property. The sampling rate is a
policy choice for the user to match to what they're trying to observe.

Answering your question, it lets userspace characterize filesystem
queue depth over time. The places where this is useful are the ones
where the desired signal persists across multiple sample periods,
leading to a representative measurement:

 - Sustained/steady-state load.
   Database, NFS server, VM image store, etc. Outstanding I/O is stable
   across many sample periods. Most capacity and health monitoring
   lives here.

 - Long-horizon trends.
   Can show if queue depth is creeping up over hours or days as load
   grows or cache becomes insufficient. Leaving per-op tracing running
   for this kind of timescale is the wrong tool for the job; persistent,
   low-cost sampling is the better choice.

 - Sustained-backlog alerting.
   Consistent elevated depth can indicate saturation, a stuck consumer,
   or cache thrash. Filtering out small transients avoids adding noise.

 - Coarse steady-state latency.
   When load is steady, sustained depth over sustained completion rate
   gives an average latency - enough precision to tell 0.5ms from 5ms,
   but not tail latency. Histograms would be the correct tool if higher
   resolution is required.

For higher precision you'd want a time-weighted queue depth, but that
requires two clock reads on every I/O in the hot path, and the cost
grows with I/O load. This trade-off is the core motivation: the counter
is a near-free, always-on aggregate for the common steady-state and
trend cases. It does not replace per-op tooling where higher precision
is required.

-Eric
