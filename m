Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3B0214A73
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 21:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738790024; cv=none; b=m7Mx6sGaPrZi4p+ORnT8Bwx/GqfKDChh2aTUdkxXyLT/QGgxE/KjPMWpHxOf2kRLXQcmtFbJMFD4qHk0JT4bHDSxd74lKtoMB1EMyAM5pifWjwH5BQ/Cf4Br3FNZu0eisRa0MMd1XmvqOZMLnCuG2RlVwKmDyx4OifRlCc7BI+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738790024; c=relaxed/simple;
	bh=ho8HADNRzF9kUQpnLLOZO5Qgx0/gFmGprNXyMnSU+rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmKunFsAHwqVbELnqFFfEdBeY3J0WB23viLEU6HZ+ajclC4S5lTO4+U5/B0pSNYc1sC2RhdyGVGycD1tSVkB2pF17HMs2ebKFvJjuEDBkZw2O4+CfnuRea9gzoXNsml8pHp2GrWPDimBxAHXvuEDK77Me8++L9DVf8HepLQ/bH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HOGvImEA; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HOGvImEA"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-216728b1836so5081315ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 05 Feb 2025 13:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738790020; x=1739394820; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=57335S6mpHTrZHgMlox7oo8dpO4CvdNzpGIpMwj9RE0=;
        b=HOGvImEAijwBsMqzY0yZogwuCa1dcT5ftwywMU5H8lxh69ckBitMHmUuoCW6iskhSr
         PEZ8YObgotUfTeDAkB3Fxtw0A6yQ8tjYYtJ2ieZJi0WyQwyNtVFzDmsvW7hyY3ab5MhK
         G6svkcjIIF2rIZ7Vd96/5a9voW0X1VsatA8iJBdI5HKIlDQa+u58BRkq4eUCKkvlxduf
         Cy8o9QdLLBOS4g/L21NutVSZjzsX63C4HDmZ9LforgyKUA+LzSqTdsYe52vsdtJhs6+g
         m1S8JIIZzRahTRNJXAfw0aekimkwFFZtNM3wbZJr6Bw77xyPnOesjVJzyG2w1zHqha3t
         dWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738790020; x=1739394820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=57335S6mpHTrZHgMlox7oo8dpO4CvdNzpGIpMwj9RE0=;
        b=EzZFVRvHNqpg7aL2B/G0jfv5/vUB3VA4JQUK0cACOdCydFyrYMTLLU65GRwnOnOqzM
         4B7GtiQh2wB2xzEXDS6P+jfe0pgoyIf8dmYSSj2AcWEd5hhO5VD/ERFW6jcW42iJnJb8
         J0vhsGHDQtxb9rTAX8SaV/bfJ1nbyRTLcpkNbig2tV8V8jHyCI9NkJ4rRPkGxEHmv1fm
         2AqzFKz9SfyVxeC97mJhHRjrEDqBDyZKU2kGBoKJYEF63pkDFCU8ZdYosJJYENAWEq1x
         6IQezz5V2VkE/o33huWck5PVKFEDA4MuLEWNf8eJFyfF13hii9G2AF6d0Wiz2IUBJR+r
         anQg==
X-Forwarded-Encrypted: i=1; AJvYcCWn5XUHCZlGWT7WwJFEpF93B2NuAnctaSCZFuLY3FIb2hUio4qpMxgg/EkGFTPtHoodQNyib2sgO1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJlZqj7fzvxovvnzjaTLAisd7LRGOhQ9/LNKPH3307phsg8/3o
	2WzJbTtVpWqmf87Ost8GMsWTZLexwt7IsHjeld/H1Er5XkPWleXlmP1awU97LaentesnNzrvknb
	v
X-Gm-Gg: ASbGncuxiZbWZzqeQONysCUcjiDL/qYcp5Bw1RvwMEch1V8IhALUZ7WFznXwQVzaE+m
	ALAxFYhJZyKj8GfA2WqtIcXQV6KvTkLdsfncrrcf0SQejaplPIxSMMXaeV4wuIRt6r8Bc9l9gVh
	/KbqlxPVTlosZ3PcszC94iKaW0xRNchgQbNRaWb9mNQG7/pVGR3E0oyW8elAbAywdyee3Q6qOxd
	/F4OCZ+1UjR2L82iO+rdz4L9xCqb+fm8gPuvYQvzaNEdS0jnz2UL/lCuIQssL19ICDHCE8iILBW
	fpKQafFqgsMh0g4nPT8URq2nGaRmeA/F/YV4xvsAvOI8UzyZQh5s5NyC
X-Google-Smtp-Source: AGHT+IF2BsThX+mdEviygmn+ZP39V0wH6HsDdie/ol0M/7CJS8zgFcPiDfpf5OwpuP5tH1o0RlSHVQ==
X-Received: by 2002:a17:902:d4c7:b0:216:779a:d5f3 with SMTP id d9443c01a7336-21f17e45b8amr65935985ad.14.1738790020624;
        Wed, 05 Feb 2025 13:13:40 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f9e1e40ab8sm2059259a91.42.2025.02.05.13.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 13:13:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfmiG-0000000F5rF-2SVA;
	Thu, 06 Feb 2025 08:13:36 +1100
Date: Thu, 6 Feb 2025 08:13:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/34] check: run tests in a private pid/mount namespace
Message-ID: <Z6PUgAIQ6qYM3Zgt@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406337.546134.5825194290554919668.stgit@frogsfrogsfrogs>
 <Z6KyrG6jatCgmUiD@dread.disaster.area>
 <20250205180048.GH21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205180048.GH21799@frogsfrogsfrogs>

On Wed, Feb 05, 2025 at 10:00:48AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 05, 2025 at 11:37:00AM +1100, Dave Chinner wrote:
> > On Tue, Feb 04, 2025 at 01:26:13PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > As mentioned in the previous patch, trying to isolate processes from
> > > separate test instances through the use of distinct Unix process
> > > sessions is annoying due to the many complications with signal handling.
> > > 
> > > Instead, we could just use nsexec to run the test program with a private
> > > pid namespace so that each test instance can only see its own processes;
> > > and private mount namespace so that tests writing to /tmp cannot clobber
> > > other tests or the stuff running on the main system.
> > > 
> > > However, it's not guaranteed that a particular kernel has pid and mount
> > > namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces have
> > > been around for a long time, but there's no hard requirement for the
> > > latter to be enabled in the kernel.  Therefore, this bugfix slips
> > > namespace support in alongside the session id thing.
> > > 
> > > Declaring CONFIG_PID_NS=n a deprecated configuration and removing
> > > support should be a separate conversation, not something that I have to
> > > do in a bug fix to get mainline QA back up.
> > > 
> > > Cc: <fstests@vger.kernel.org> # v2024.12.08
> > > Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > >  check               |   34 +++++++++++++++++++++++-----------
> > >  common/rc           |   12 ++++++++++--
> > >  src/nsexec.c        |   18 +++++++++++++++---
> > >  tests/generic/504   |   15 +++++++++++++--
> > >  tools/run_seq_pidns |   28 ++++++++++++++++++++++++++++
> > >  5 files changed, 89 insertions(+), 18 deletions(-)
> > >  create mode 100755 tools/run_seq_pidns
> > 
> > Same question as for session ids - is this all really necessary (or
> > desired) if check-parallel executes check in it's own private PID
> > namespace?
> > 
> > If so, then the code is fine apart from the same nit about
> > tools/run_seq_pidns - call it run_pidns because this helper will
> > also be used by check-parallel to run check in it's own private
> > mount and PID namespaces...
> 
> I prefer to name it tools/run_privatens since it creates more than just
> a pid namespace.

I'm fine with that. It was only the "seq" part of the name that
triggered me.

> At some point we might even decide to privatize more
> namespaces (e.g. do we want a private network namespace for nfs?) and I
> don't want this to become lsfmmbpfbbq'd, as it were.

*nod*

-Dave.

-- 
Dave Chinner
david@fromorbit.com
