Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8774430;
	Tue, 25 Feb 2025 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740498551; cv=none; b=jLBv/KX5m1W24TpdbC3guvtk1Ann8eM2IIcq71EaDeCh7pzsg1hMH/PKAAq88wG7c5dZT73cuZRuLKW3hl/+p4Zy2yLY5c3GaY2vdMrqXGw8JU0mxogRiYV9P3xInMBdm8AHX4U4jNI4jEPCKspdnvuWGBMdB79W1JbFmTYtVDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740498551; c=relaxed/simple;
	bh=5Cfm58+X84U5hcJGQyY+f+r+SS1LkqFV9Ih6DQznbKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+KEK652Z7i7kMPFGtQfvratwE2pqryoZHPDcjOIWPLfjXpgT3Lg5QE4iHG7F7XYr4oj3jO2rmPLVy9vh2/5YJapKUrsEAtPP/j+3E0nqwi+02D5bcMZXSeQnb3gLCxF7TyWEdlmDkuMUq1mjjrRnYIFBdszdMQjs69CzsGtYMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPqcENSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPqcENSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CFCC4CEDD;
	Tue, 25 Feb 2025 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740498551;
	bh=5Cfm58+X84U5hcJGQyY+f+r+SS1LkqFV9Ih6DQznbKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OPqcENSPKroUQelPaqiTg3xpks1uOJ8WBkEssCxz1U9LbKPae290iCYAlqLnMKkzo
	 TWGMHWZyjtspc///QWaqOewt9sGoJrTsFThu2dU7O9iabvCulGhl4cD59fLpu6ubXh
	 9uQukRQB6ubTQrZmmngjH3yXj5Ufmv5gsRKafJXWPiklmvnFPNUkeAfRHEzbvUiLlw
	 j/CjDXOd6ti1eDfu6Kcaob0hejywxDyCHuIRVxDH0gqhLff/3p4uXlZzrHMtsipEoY
	 3nX+bIPJ5eyw8wpmzXkPoq7QTnmYfb2xTkPbI+/rekRwM8CGfb26kcSxNqCexPHyNj
	 UUnmRgxI0Vt6g==
Date: Tue, 25 Feb 2025 07:49:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "zlang@redhat.com" <zlang@redhat.com>,
	"dchinner@redhat.com" <dchinner@redhat.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v3.1 15/34] check: run tests in a private pid/mount
 namespace
Message-ID: <20250225154910.GB6265@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094584.1758477.17381421804809266222.stgit@frogsfrogsfrogs>
 <20250214211341.GG21799@frogsfrogsfrogs>
 <6azplgcrw6czwucfm5cr7kh4xorkpwt7zmxoks5m5ptegnyme3@ldg2d6hmmdty>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6azplgcrw6czwucfm5cr7kh4xorkpwt7zmxoks5m5ptegnyme3@ldg2d6hmmdty>

On Tue, Feb 25, 2025 at 11:27:19AM +0000, Shinichiro Kawasaki wrote:
> On Feb 14, 2025 / 13:13, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > As mentioned in the previous patch, trying to isolate processes from
> > separate test instances through the use of distinct Unix process
> > sessions is annoying due to the many complications with signal handling.
> > 
> > Instead, we could just use nsexec to run the test program with a private
> > pid namespace so that each test instance can only see its own processes;
> > and private mount namespace so that tests writing to /tmp cannot clobber
> > other tests or the stuff running on the main system.  Further, the
> > process created by the clone(CLONE_NEWPID) call is considered the init
> > process of that pid namespace, so all processes will be SIGKILL'd when
> > the init process terminates, so we no longer need systemd scopes for
> > externally enforced cleanup.
> > 
> > However, it's not guaranteed that a particular kernel has pid and mount
> > namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces have
> > been around for a long time, but there's no hard requirement for the
> > latter to be enabled in the kernel.  Therefore, this bugfix slips
> > namespace support in alongside the session id thing.
> > 
> > Declaring CONFIG_PID_NS=n a deprecated configuration and removing
> > support should be a separate conversation, not something that I have to
> > do in a bug fix to get mainline QA back up.
> > 
> > Note that the new helper cannot unmount the /proc it inherits before
> > mounting a pidns-specific /proc because generic/504 relies on being able
> > to read the init_pid_ns (aka systemwide) version of /proc/locks to find
> > a file lock that was taken and leaked by a process.
> 
> Hello Darrick,
> 
> I ran fstests for zoned btrfs using the latest fstests tag v2025.02.23, and
> observed all test cases failed with my set up. I bisected and found that this
> commit is the trigger. Let me share my observations.
> 
> For example, btrfs/001.out.bad contents are as follows:
> 
>   QA output created by 001
>   mount: bad usage
>   Try 'mount --help' for more information.
>   common/rc: retrying test device mount with external set
>   mount: bad usage
>   Try 'mount --help' for more information.
>   common/rc: could not mount /dev/sda on common/config: TEST_DIR (/tmp/test) is not a directory
> 
> As the last line above shows, fstests failed to find out TEST_DIR, /tmp/test.
> 
> My set up uses mount point directories in tmpfs, /tmp/*:
> 
>   export TEST_DIR=/tmp/test
>   export SCRATCH_MNT=/tmp/scratch
> 
> I guessed that tmpfs might be a cause. As a trial, I modified these to,
> 
>   export TEST_DIR=/var/test
>   export SCRATCH_MNT=/var/scratch
> 
> then I observed the failures disappeared. I guess this implies that the commit
> for the private pid/mount namespace makes tmpfs unique to each namespace. Then,
> the the mount points in tmpfs were not found in the private namespaces context,
> probably.

Yes, /tmp is now private to the test program (e.g. tests/btrfs/001) so
that tests run in parallel cannot interfere with each other.

> If this guess is correct, in indicates that tmpfs can no longer be used for
> fstests mount points. Is this expected?

Expected, yes.  But still broken for you. :(

I can think of a few solutions:

1. Perhaps run_privatens could detect that TEST_DIR/SCRATCH_MNT start
with "/tmp" and bind mount them into the private /tmp before it starts
the test.

2. fstests could take care of defining and mkdir'ing the
TEST_DIR/SCRATCH_MNT directories and users no longer have to create
them.  It might, however, be useful to have them accessible to someone
who has ssh'd in to look around after a failure.

3. Everyone rewrites their fstests configs to choose something outside
of /tmp (e.g. /var/tmp/{test,scratch})?

Any thoughts?  #3 is the least thinking for me, but #1 is the least
thinking for everyone /else/ :)

--D
