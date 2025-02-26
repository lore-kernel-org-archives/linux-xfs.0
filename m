Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0909256D;
	Wed, 26 Feb 2025 02:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740536297; cv=none; b=Y9gwZcx0/xVHVehg9w7yr2oxri9L0wD1Qtkm0f2uYIi+ajqNZyG7zMzrajyU3kWWleQjGvPHdhCvIYA9/y5GYpWoR48OLMBQwzg8KkwN1+9j84uWJkOU4JJR7u61ZOPJgS3KIeThW4R7fuGnscHrM3SacfpQVMsj5zeJwEWXF8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740536297; c=relaxed/simple;
	bh=rRBp26MDjUq8ESdodX9P7wAClhB3V4Pzla2ZCUHvBes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2kfV2l0Bi2NtpAFrTI9a6Tsaqh15kvLQKEEGCFU3LNbBmIOEmrS9WVLP1j5l3QCfNTrexzUQQb2uLK4wUETAtUeeX0bW4lNL7wkRMOVPalvzpJ9HPR9Fvh0ZSVtADVkOOlEJvHw9rHgiVQ7jSO+atAJRHGfTM/czHsIec83V/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsN6CLUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsN6CLUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC0DC4CEDD;
	Wed, 26 Feb 2025 02:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740536297;
	bh=rRBp26MDjUq8ESdodX9P7wAClhB3V4Pzla2ZCUHvBes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UsN6CLUKXtKR+5MAiWmV5lafh6PoR23bXRizv3gjG02lf1Bah3jPU32XIZ63Rne9p
	 Un+kccDy4GuBM1Ca8Rc5lYq0L4NjJVvloJnbOC8wr4hV/dc8e6DpCfjhfr2IGClmlG
	 Q60e7jZ+CnSTNJbFINzb92yqK6XFAuBaUCFEVHCpGf05+eoua3dWoknJK7pcLvgS7Z
	 cku0r4QcRRkjF8ww8F/Bc2J8moNdVZsIYI836XL4X8+0m5yJcSwUTjYym78dmLQbJy
	 Otucki+MFLRcRai1G/7GyhyaViulw03C4tQ+WIRouSl5vW6yzjSqSTcZV1GgW5njlo
	 TBn8c2q4PbOpg==
Date: Tue, 25 Feb 2025 18:18:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>,
	"zlang@redhat.com" <zlang@redhat.com>,
	"dchinner@redhat.com" <dchinner@redhat.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v3.1 15/34] check: run tests in a private pid/mount
 namespace
Message-ID: <20250226021816.GG6265@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094584.1758477.17381421804809266222.stgit@frogsfrogsfrogs>
 <20250214211341.GG21799@frogsfrogsfrogs>
 <6azplgcrw6czwucfm5cr7kh4xorkpwt7zmxoks5m5ptegnyme3@ldg2d6hmmdty>
 <20250225154910.GB6265@frogsfrogsfrogs>
 <Z742RnudifADoj01@dread.disaster.area>
 <qjjk4spah52oyautabncgjfluaixy4rbfpuecydm5izauhuqki@lkcw62dpij3o>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qjjk4spah52oyautabncgjfluaixy4rbfpuecydm5izauhuqki@lkcw62dpij3o>

On Wed, Feb 26, 2025 at 02:13:00AM +0000, Shinichiro Kawasaki wrote:
> On Feb 26, 2025 / 08:29, Dave Chinner wrote:
> > On Tue, Feb 25, 2025 at 07:49:10AM -0800, Darrick J. Wong wrote:
> > > On Tue, Feb 25, 2025 at 11:27:19AM +0000, Shinichiro Kawasaki wrote:
> > > > On Feb 14, 2025 / 13:13, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > As mentioned in the previous patch, trying to isolate processes from
> > > > > separate test instances through the use of distinct Unix process
> > > > > sessions is annoying due to the many complications with signal handling.
> > > > > 
> > > > > Instead, we could just use nsexec to run the test program with a private
> > > > > pid namespace so that each test instance can only see its own processes;
> > > > > and private mount namespace so that tests writing to /tmp cannot clobber
> > > > > other tests or the stuff running on the main system.  Further, the
> > > > > process created by the clone(CLONE_NEWPID) call is considered the init
> > > > > process of that pid namespace, so all processes will be SIGKILL'd when
> > > > > the init process terminates, so we no longer need systemd scopes for
> > > > > externally enforced cleanup.
> > > > > 
> > > > > However, it's not guaranteed that a particular kernel has pid and mount
> > > > > namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces have
> > > > > been around for a long time, but there's no hard requirement for the
> > > > > latter to be enabled in the kernel.  Therefore, this bugfix slips
> > > > > namespace support in alongside the session id thing.
> > > > > 
> > > > > Declaring CONFIG_PID_NS=n a deprecated configuration and removing
> > > > > support should be a separate conversation, not something that I have to
> > > > > do in a bug fix to get mainline QA back up.
> > > > > 
> > > > > Note that the new helper cannot unmount the /proc it inherits before
> > > > > mounting a pidns-specific /proc because generic/504 relies on being able
> > > > > to read the init_pid_ns (aka systemwide) version of /proc/locks to find
> > > > > a file lock that was taken and leaked by a process.
> > > > 
> > > > Hello Darrick,
> > > > 
> > > > I ran fstests for zoned btrfs using the latest fstests tag v2025.02.23, and
> > > > observed all test cases failed with my set up. I bisected and found that this
> > > > commit is the trigger. Let me share my observations.
> > > > 
> > > > For example, btrfs/001.out.bad contents are as follows:
> > > > 
> > > >   QA output created by 001
> > > >   mount: bad usage
> > > >   Try 'mount --help' for more information.
> > > >   common/rc: retrying test device mount with external set
> > > >   mount: bad usage
> > > >   Try 'mount --help' for more information.
> > > >   common/rc: could not mount /dev/sda on common/config: TEST_DIR (/tmp/test) is not a directory
> > > > 
> > > > As the last line above shows, fstests failed to find out TEST_DIR, /tmp/test.
> > > > 
> > > > My set up uses mount point directories in tmpfs, /tmp/*:
> > > > 
> > > >   export TEST_DIR=/tmp/test
> > > >   export SCRATCH_MNT=/tmp/scratch
> > > > 
> > > > I guessed that tmpfs might be a cause. As a trial, I modified these to,
> > > > 
> > > >   export TEST_DIR=/var/test
> > > >   export SCRATCH_MNT=/var/scratch
> > > > 
> > > > then I observed the failures disappeared. I guess this implies that the commit
> > > > for the private pid/mount namespace makes tmpfs unique to each namespace. Then,
> > > > the the mount points in tmpfs were not found in the private namespaces context,
> > > > probably.
> > > 
> > > Yes, /tmp is now private to the test program (e.g. tests/btrfs/001) so
> > > that tests run in parallel cannot interfere with each other.
> > > 
> > > > If this guess is correct, in indicates that tmpfs can no longer be used for
> > > > fstests mount points. Is this expected?
> > > 
> > > Expected, yes.  But still broken for you. :(
> 
> Darrick, thanks for the clarifications.
> 
> > > 
> > > I can think of a few solutions:
> > > 
> > > 1. Perhaps run_privatens could detect that TEST_DIR/SCRATCH_MNT start
> > > with "/tmp" and bind mount them into the private /tmp before it starts
> > > the test.
> > 
> > Which then makes it specific to test running, and that makes it
> > less suited to use from check-parallel (or any other generic test
> > context).
> > 
> > > 2. fstests could take care of defining and mkdir'ing the
> > > TEST_DIR/SCRATCH_MNT directories and users no longer have to create
> > > them.  It might, however, be useful to have them accessible to someone
> > > who has ssh'd in to look around after a failure.
> > 
> > check-parallel already does this, and it leaves them around after
> > the test, so....
> > 
> > 4. use check-parallel.
> 
> I took a quick look in check-parallel. IIUC, it creates loop devices then it can
> not run with real storage devices. I run fstests with real zoned storage
> devices regularly, so I'm afraid that this solution does not fit my use case.
> 
> > 
> > > 3. Everyone rewrites their fstests configs to choose something outside
> > > of /tmp (e.g. /var/tmp/{test,scratch})?
> 
> I'm okay with this, since it is not a big deal to change the mount points in my
> test environments.
> 
> If this solution is chosen, I suggest to document the restriction and/or have
> the test script to check the restriction, to avoid the confusion.

I would certainly do that if everyone else agrees to the additional
restriction + adding the necessary checks to ./check?

--D

> > 
> > How many people actually use /tmp for fstests mount points?
> > 
> > IMO, it's better for ongoing maintenance to drop support for /tmp
> > based mount points (less complexity in infrastructure setup). If
> > there are relatively few ppl who do this, perhaps it would be best
> > to treat this setup the same as the setsid encapsulation. i.e. works
> > for now, but is deprecated and is going to be removed in a years
> > time....
> > 
> > Then we can simply add a /tmp test to the HAVE_PRIVATENS setting and
> > avoid using a private ns for these setups for now. This gives
> > everyone who does use these setups time to migrate to a different
> > setup that will work with private namespaces correctly, whilst
> > keeping the long term maintenance burden of running tests in private
> > namespaces down to a minimum.
> > 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
