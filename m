Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C9A20FA86
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 21:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740518988; cv=none; b=Eqi6dleKH57/Fz3mZeAehgMAYOc/OPTpdu9ofPg8hjowS7JhyfHDdXFtUdwHKICBNkk/FIMRTKTZwm9IEdvg9RDAPEehhpaI7E2w1kcfa6VLVXgLw/GZqza6ixjJEUTl2vP5LIMVCheHh+t2VkMGERjSotkH6OA94QS5/5hEgPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740518988; c=relaxed/simple;
	bh=RJ8nxryWmRATg+xZ+c4o3lqDz9k+9vc0aHo0iecmLPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iA9wXrZQvgIfBzqMMtZ5lSY4kWOmW91cz6KfU7b2aRE8DaquXZtEESBXn1zWdzy4WamyeuqsM6m+ph4ypd0A69UTJR8lfxO9+bic3Z2QIwHddRKJ2KFIUkhJIvH/aOPHDqgbhhxgsJZCtzNcpeT14cpqLhEJ8drYotP7+yvRNfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=s0WXWW1l; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="s0WXWW1l"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-220f4dd756eso129735405ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 13:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1740518985; x=1741123785; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9hUhTeanJZvN3uegtxUy2CeWK0FuL5VvS0GK9DS5Gi4=;
        b=s0WXWW1lkDutdvpSyFRQWWrVsUJKcW6+c+XU4hBnZmMioIfaGXbAho7fyEZHPFAm5n
         ui/FVwehv2bD7SPMSHr/v1oo+8W9COp596ITV/p4sdAFOAcp7tmCz27bQQ1CiHtyBLzW
         2YOat1ab2WTpDoM5VZEanJ2SO7ytW1Wd3rB07wwpQ+Bv6g3lrzw3ljBKfuShFN6Ssn1M
         tv3QVCrkpTRgKObjczM1c2Fro48WKa++iITQcvoyCLQFAKZq/4MpxMgnECQNNknT6QcK
         rlM7vu8BNSPdQ8DdG8zkbBwP+IddfV+tbooIxrAMmp86hwQ5R4P96IEN4o/z4ESyOm72
         21ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740518985; x=1741123785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hUhTeanJZvN3uegtxUy2CeWK0FuL5VvS0GK9DS5Gi4=;
        b=jNS+wym7oZj/1ju93IIa5B4lKmKV2SSJcGFzX2vCQj8j+vxsJrSadf/HhVbGF7u0EA
         u+ROwx+ppe5IAdeJV9VRPy6ACvHLDFWzNfXvsLmv1vpeGVZ2F0HMwfwMacudhsTqz1Dg
         gNWsJMsoFz3ZlJKPEqIJV55TDDku34vzYm2JaCr6fARI29KvOdmHqL3DjziesP9vjB82
         N8d6VoXtGbFHJyWqWp8n3NTQsrLdT8iFKGosEzjYrayjsXCDTTEsYeq2hfC8kqYzy9HC
         /XHgT9A3qKpgttP1YLsXL9W+u0hHdd1p3D6RgAMRo+kZaQ4aqaiLY1SsQBkDzGIjisO3
         f/cw==
X-Forwarded-Encrypted: i=1; AJvYcCW2o5XETk9uNmPOyWfh2Jz7HJ6eeReP/d4q+Pbc8i0ubEsF3tShVacOsODNjwvnTcCy01HqVLeWZ4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOaFvI8vAa6O4NNAC0E77xwmKA2qoeLYUevD0Fbe0uwjFS4+FO
	9GZyq6+/R/ahtKgA7hhvoYgAA34rr0jV9Ypukc8U/B99GnAXPUgJ+X3rE5TaNKs=
X-Gm-Gg: ASbGncvWcFFkGDkjfs9khT1igY07rSFzoMD+JYr4Qnxexx4RGA059Bbd0oW7/OP/LWL
	FypZWsrvBWu5eKTQ679oxLDkFKYsoPrw9iFDqshk6Q63U5nHa6W7wr1EBHQ66RF2n7b1w0eipAj
	WrUuT9sE+fv+EIbSiS+dcRZF9TiGe53cwDpWfU6jc6gsezrZtfW43hjoutECypWMlTJkfxU/WYl
	IcWjLROU5ojKOnOZY780FDlC0M/r0mW7EwE2mPGPZYnzuZLB690FIv5+WFp8gl0KFVRaNi0ZRw2
	d7Nm9hFYNX245wuvYwYI9OO2IAdNkics0hTHlN2xXHEWkyQUo+1l1JNO4XOxrx2BCu8=
X-Google-Smtp-Source: AGHT+IEjBdT7FNIXo8o1Js6XdokQgzHHkUXcoV+AxlIX1Slmd+eqWVyefVbK7pAY2Jb3elkwOEKM4A==
X-Received: by 2002:a05:6a00:3d48:b0:730:75b1:7218 with SMTP id d2e1a72fcca58-7347918de02mr8472227b3a.16.1740518985571;
        Tue, 25 Feb 2025 13:29:45 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a81b91csm2003941b3a.123.2025.02.25.13.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 13:29:44 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tn2Uo-00000005vsl-0TBI;
	Wed, 26 Feb 2025 08:29:42 +1100
Date: Wed, 26 Feb 2025 08:29:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"zlang@redhat.com" <zlang@redhat.com>,
	"dchinner@redhat.com" <dchinner@redhat.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v3.1 15/34] check: run tests in a private pid/mount
 namespace
Message-ID: <Z742RnudifADoj01@dread.disaster.area>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094584.1758477.17381421804809266222.stgit@frogsfrogsfrogs>
 <20250214211341.GG21799@frogsfrogsfrogs>
 <6azplgcrw6czwucfm5cr7kh4xorkpwt7zmxoks5m5ptegnyme3@ldg2d6hmmdty>
 <20250225154910.GB6265@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225154910.GB6265@frogsfrogsfrogs>

On Tue, Feb 25, 2025 at 07:49:10AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 25, 2025 at 11:27:19AM +0000, Shinichiro Kawasaki wrote:
> > On Feb 14, 2025 / 13:13, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > As mentioned in the previous patch, trying to isolate processes from
> > > separate test instances through the use of distinct Unix process
> > > sessions is annoying due to the many complications with signal handling.
> > > 
> > > Instead, we could just use nsexec to run the test program with a private
> > > pid namespace so that each test instance can only see its own processes;
> > > and private mount namespace so that tests writing to /tmp cannot clobber
> > > other tests or the stuff running on the main system.  Further, the
> > > process created by the clone(CLONE_NEWPID) call is considered the init
> > > process of that pid namespace, so all processes will be SIGKILL'd when
> > > the init process terminates, so we no longer need systemd scopes for
> > > externally enforced cleanup.
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
> > > Note that the new helper cannot unmount the /proc it inherits before
> > > mounting a pidns-specific /proc because generic/504 relies on being able
> > > to read the init_pid_ns (aka systemwide) version of /proc/locks to find
> > > a file lock that was taken and leaked by a process.
> > 
> > Hello Darrick,
> > 
> > I ran fstests for zoned btrfs using the latest fstests tag v2025.02.23, and
> > observed all test cases failed with my set up. I bisected and found that this
> > commit is the trigger. Let me share my observations.
> > 
> > For example, btrfs/001.out.bad contents are as follows:
> > 
> >   QA output created by 001
> >   mount: bad usage
> >   Try 'mount --help' for more information.
> >   common/rc: retrying test device mount with external set
> >   mount: bad usage
> >   Try 'mount --help' for more information.
> >   common/rc: could not mount /dev/sda on common/config: TEST_DIR (/tmp/test) is not a directory
> > 
> > As the last line above shows, fstests failed to find out TEST_DIR, /tmp/test.
> > 
> > My set up uses mount point directories in tmpfs, /tmp/*:
> > 
> >   export TEST_DIR=/tmp/test
> >   export SCRATCH_MNT=/tmp/scratch
> > 
> > I guessed that tmpfs might be a cause. As a trial, I modified these to,
> > 
> >   export TEST_DIR=/var/test
> >   export SCRATCH_MNT=/var/scratch
> > 
> > then I observed the failures disappeared. I guess this implies that the commit
> > for the private pid/mount namespace makes tmpfs unique to each namespace. Then,
> > the the mount points in tmpfs were not found in the private namespaces context,
> > probably.
> 
> Yes, /tmp is now private to the test program (e.g. tests/btrfs/001) so
> that tests run in parallel cannot interfere with each other.
> 
> > If this guess is correct, in indicates that tmpfs can no longer be used for
> > fstests mount points. Is this expected?
> 
> Expected, yes.  But still broken for you. :(
> 
> I can think of a few solutions:
> 
> 1. Perhaps run_privatens could detect that TEST_DIR/SCRATCH_MNT start
> with "/tmp" and bind mount them into the private /tmp before it starts
> the test.

Which then makes it specific to test running, and that makes it
less suited to use from check-parallel (or any other generic test
context).

> 2. fstests could take care of defining and mkdir'ing the
> TEST_DIR/SCRATCH_MNT directories and users no longer have to create
> them.  It might, however, be useful to have them accessible to someone
> who has ssh'd in to look around after a failure.

check-parallel already does this, and it leaves them around after
the test, so....

4. use check-parallel.

> 3. Everyone rewrites their fstests configs to choose something outside
> of /tmp (e.g. /var/tmp/{test,scratch})?

How many people actually use /tmp for fstests mount points?

IMO, it's better for ongoing maintenance to drop support for /tmp
based mount points (less complexity in infrastructure setup). If
there are relatively few ppl who do this, perhaps it would be best
to treat this setup the same as the setsid encapsulation. i.e. works
for now, but is deprecated and is going to be removed in a years
time....

Then we can simply add a /tmp test to the HAVE_PRIVATENS setting and
avoid using a private ns for these setups for now. This gives
everyone who does use these setups time to migrate to a different
setup that will work with private namespaces correctly, whilst
keeping the long term maintenance burden of running tests in private
namespaces down to a minimum.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
