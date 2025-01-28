Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12DE383A5;
	Tue, 28 Jan 2025 07:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738049034; cv=none; b=QtU4V8AD0fv6XAxhnKgov81nHDMDzYqax6i7j2uSoevfwoK3DZDu7AJZ/lQEGxgCfCQu+TRF5CagI76DcLYyWzrmBHvFTvmmDn2uwLjpIlJAAswPNhsMx1dUDqU6eE8x3U/xWPqJJxL6o3dE07/o4lQwvvhtoqBSetZCRbIKoU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738049034; c=relaxed/simple;
	bh=0CvK85U1j+4ZdkrE+sPsY+vA4woSxZeFsHjs7jjy8uA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L69CuitfPE0aIWpGiyxdlSqbJGHzM5poeLYr8c/6BQq6m0K7VwLvRNLVWCoPVo9qwmW7geSGMuvalTdILkCR+15Nf5ER10EqVH++IlB/o1RJj68K32Um2neO9D+TrXH87D6XNY1JLWFTq2ufTujqh3sGSLIEyTcJ/YZVxi90Zjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGW+xinL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGW+xinL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDD4C4CED3;
	Tue, 28 Jan 2025 07:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738049033;
	bh=0CvK85U1j+4ZdkrE+sPsY+vA4woSxZeFsHjs7jjy8uA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kGW+xinLLwveJGSl0UgthQrRZkNmAhRzx+oAdL4vZQapMe11R5Ln8kl0fcjKgQkRC
	 OjHuBHrvK6uNxY2i//kP13Yk6gwuaGY4jcF6nhQ08I1nBqz9AZDMR4fW5b0v7bXWco
	 5whjEsHuWoRHNhaXWTwpUnE9pSXGP5EH7BJQQNhGryhfjAXN2Z0HQbZUCuchBOucF9
	 R2o67TZr3MNBOiuH30fzvk0Azy3s8V/jmAp/vtb/FwDDNkN3uGEHeTV+E+EfdpRYN5
	 mmJewHNI4nigWTDQbkQY91AIk+GMJB6vhumTN9CnxkoWSrGIIRLSJARfwdH8nyd6or
	 IZmbEeCKZYZHw==
Date: Mon, 27 Jan 2025 23:23:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <20250128072352.GP3557553@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
 <Z48UWiVlRmaBe3cY@dread.disaster.area>
 <20250122042400.GX1611770@frogsfrogsfrogs>
 <Z5CLUbj4qbXCBGAD@dread.disaster.area>
 <20250122070520.GD1611770@frogsfrogsfrogs>
 <Z5C9mf2yCgmZhAXi@dread.disaster.area>
 <20250122214609.GE1611770@frogsfrogsfrogs>
 <Z5GYgjYL_9LecSb9@dread.disaster.area>
 <Z5heaj-ZsL_rBF--@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z5heaj-ZsL_rBF--@dread.disaster.area>

On Tue, Jan 28, 2025 at 03:34:50PM +1100, Dave Chinner wrote:
> On Thu, Jan 23, 2025 at 12:16:50PM +1100, Dave Chinner wrote:
> > On Wed, Jan 22, 2025 at 01:46:09PM -0800, Darrick J. Wong wrote:
> > > > > Agreed, though at some point after these bugfixes are merged I'll see if
> > > > > I can build on the existing "if you have systemd then ___ else here's
> > > > > your shabby opencoded version" logic in fstests to isolate the ./checks
> > > > > from each other a little better.  It'd be kinda nice if we could
> > > > > actually just put them in something resembling a modernish container,
> > > > > albeit with the same underlying fs.
> > > > 
> > > > Agreed, but I don't think we need to depend on systemd for that,
> > > > either.
> > > > 
> > > > > <shrug> Anyone else interested in that?
> > > > 
> > > > check-parallel has already started down that road with the
> > > > mount namespace isolation it uses for the runner tasks via
> > > > src/nsexec.c.
> .....
> > > > Hmmm - looks like src/nsexec.c can create new PID namespaces via
> > > > the "-p" option. I haven't used that before - I wonder if that's a
> > > > better solution that using per-test session IDs to solve the pkill
> > > > --parent problem? Something to look into in the morning....
> 
> .....
> 
> > Note, however, that ps will show all processes in both the parent
> > and the child namespace the shell is running on because the contents
> > of /proc are the same for both.
> > 
> > However, because we are also using private mount namespaces for the
> > check process, pid_namespaces(7) tells us:
> > 
> > /proc and PID namespaces
> > 
> >        A /proc filesystem shows (in the /proc/pid directories) only
> >        processes visible in the PID namespace of the process that
> >        performed the mount, even if the /proc filesystem is viewed
> >        from processes in other namespaces.
> > 
> >        After creating a new PID namespace, it is useful for the
> >        child to change its root directory and mount a new procfs
> >        instance at /proc so that tools  such  as  ps(1) work
> > >>>    correctly.  If a new mount namespace is simultaneously
> > >>>    created by including CLONE_NEWNS in the flags argument of
> > >>>    clone(2) or unshare(2), then it isn't necessary to change the
> > >>>    root directory: a new procfs instance can be mounted directly
> > >>>    over /proc.
> > 
> >        From a shell, the command to mount /proc is:
> > 
> >            $ mount -t proc proc /proc
> > 
> >        Calling readlink(2) on the path /proc/self yields the process
> >        ID of the caller in the PID namespace of the procfs mount
> >        (i.e., the PID name‐ space of the process that mounted the
> >        procfs).  This can be useful for introspection purposes, when
> >        a process wants to discover its  PID  in other namespaces.
> > 
> > This appears to give us an environment that only shows the processes
> > within the current PID namespace:
> > 
> > $ sudo src/nsexec -p -m bash
> > # mount -t proc proc /proc
> > # ps waux
> > USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> > root           1  0.0  0.0   7384  3744 pts/1    S    11:55   0:00 bash
> > root          72  0.0  0.0   8300  3736 pts/1    R+   12:04   0:00 ps waux
> > # pstree -N pid
> > [4026538173]
> > bash───pstree
> > #
> > 
> > Yup, there we go - we have full PID isolation for this shell.
> 
> Ok, it took me some time to get this to work reliably - the way was
> full of landmines with little documentation to guide around them.
> 
> 1. If multiple commands are needed to be run from nsexec, a helper
>    script is needed (I called it check-helper).
> 
> 2. You have to `mount --make-private /proc` before doing anything to
>    make the mounts of /proc inside the pid namespace work correctly.
>    If you don't do this, every other mount namespace will also see
>    only the newest mount, and that means every runner but the last
>    one to start with the wrong mount and PID namespace view in /proc.
> 
> 3. if you get the system into the state described by 1), unmounting
>    /proc in each runner then races to remove the top /proc mount.
>    Many threads get -EBUSY failures from unmount, leaving many stale
>    mounts of /proc behind.
> 
> 4. the top level shell where check-parallel was invoked is left with
>    the view where /proc has been unmounted from a PID/mount
>    namespace that has gone away. Hence /proc now has no processes or
>    mounts being reported and nothing works until you mount a new
>    instance /proc in that namespace.
> 
> 5. After mounting proc again there are lots of mounts of stale /proc
>    mounts still reported. They cannot be unmounted as the mount
>    namespaces that created them have gone away and unmounting /proc
>    in the current shell simply removes the last mounted one and we
>    goto 4).
> 
> 4. /tmp is still shared across all runner instances so all the
> 
>    concurrent runners dump all their tmp files in /tmp. However, the
>    runners no longer have unique PIDs (i.e. check runs as PID 3 in
>    all runner instaces). This means using /tmp/tmp.$$ as the
>    check/test temp file definition results is instant tmp file name
>    collisions and random things in check and tests fail.  check and
>    common/preamble have to be converted to use `mktemp` to provide
>    unique tempfile name prefixes again.
> 
> 5. Don't forget to revert the parent /proc mount back to shared
>    after check has finished running (or was aborted).
> 
> I think with this (current prototype patch below), we can use PID
> namespaces rather than process session IDs for check-parallel safe
> process management.
> 
> Thoughts?

Was about to go to bed, but can we also start a new mount namespace,
create a private (or at least non-global) /tmp to put files into, and
then each test instance is isolated from clobbering the /tmpfiles of
other ./check instances *and* the rest of the system?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> 
> check-parallel: use PID namespaces for runner process isolation
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> This provides isolation between individual runners so that they
> cannot see the processes that other test runners have created.
> This means tools like pkill will only find processes run by the test
> that is calling it, hence there is no danger taht it might kill
> processes owned by a different test in a different runner context.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check           |  6 +++++-
>  check-helper    | 23 +++++++++++++++++++++++
>  check-parallel  | 25 +++++++++++++++++++------
>  common/preamble |  5 ++++-
>  4 files changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/check b/check
> index 4dc266dcf..314436667 100755
> --- a/check
> +++ b/check
> @@ -4,7 +4,11 @@
>  #
>  # Control script for QA
>  #
> -tmp=/tmp/$$
> +
> +# When run from a pid namespace, /tmp/tmp.$$ is not a unique identifier.
> +# Use mktemp instead.
> +tmp=`mktemp`
> +
>  status=0
>  needwrap=true
>  needsum=true
> diff --git a/check-helper b/check-helper
> new file mode 100755
> index 000000000..47a92de8b
> --- /dev/null
> +++ b/check-helper
> @@ -0,0 +1,23 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Red Hat, Inc.  All Rights Reserved.
> +#
> +
> +# When check is run from check-parallel, it is run in private mount and PID
> +# namespaces. We need to set up /proc to only show processes in this PID
> +# namespace, so we mount a new instance of /proc over the top of the existing
> +# version. Because we are in a private mount namespace, the does not propagate
> +# outside this context and hence does not conflict with the other test runners
> +# that are performing the same setup actions.
> +
> +args="$@"
> +
> +#echo $args
> +mount -t proc proc /proc
> +ret=$?
> +if [ $ret -eq 0 ]; then
> +	./check $args
> +	umount -l /proc
> +else
> +	echo failed to mount /proc, ret $ret!
> +fi
> diff --git a/check-parallel b/check-parallel
> index 2fbf0fdbe..6082baf5e 100755
> --- a/check-parallel
> +++ b/check-parallel
> @@ -259,14 +259,14 @@ runner_go()
>  	rm -f $RESULT_BASE/check.*
>  
>  	# Only supports default mkfs parameters right now
> -	wipefs -a $TEST_DEV > /dev/null 2>&1
> -	yes | mkfs -t $FSTYP $TEST_MKFS_OPTS $TEST_DEV > /dev/null 2>&1
> +	wipefs -a $TEST_DEV > $me/log 2>&1
> +	yes | mkfs -t $FSTYP $TEST_MKFS_OPTS $TEST_DEV >> $me/log 2>&1
>  
>  #	export DUMP_CORRUPT_FS=1
>  
> -	# Run the tests in it's own mount namespace, as per the comment below
> -	# that precedes making the basedir a private mount.
> -	./src/nsexec -m ./check $run_section -x unreliable_in_parallel --exact-order ${runner_list[$id]} > $me/log 2>&1
> +	# Run the tests in it's own mount and PID namespace, as per the comment
> +	# below that precedes making the basedir a private mount.
> +	./src/nsexec -m -p ./check-helper $run_section -x unreliable_in_parallel --exact-order ${runner_list[$id]} >> $me/log 2>&1
>  
>  	wait
>  	sleep 1
> @@ -291,6 +291,8 @@ cleanup()
>  	umount -R $basedir/*/test 2> /dev/null
>  	umount -R $basedir/*/scratch 2> /dev/null
>  	losetup --detach-all
> +	mount --make-shared /proc
> +	mount --make-shared $basedir
>  }
>  
>  trap "cleanup; exit" HUP INT QUIT TERM
> @@ -311,10 +313,17 @@ fi
>  # controls the mount to succeed without actually unmounting the filesytsem
>  # because a mount namespace still holds a reference to it. This causes other
>  # operations on the block device to fail as it is still busy (e.g. fsck, mkfs,
> -# etc). Hence we make the basedir private here and then run each check instance
> +# etc).
> +#
> +# Hence we make the basedir private here and then run each check instance
>  # in it's own mount namespace so that they cannot see mounts that other tests
>  # are performing.
> +#
> +# We also need to make /proc private so that the runners can be run cleanly in
> +# a PID namespace. This requires an new mount of /proc inside the PID namespace,
> +# and this requires a private mount namespace to work correctly.
>  mount --make-private $basedir
> +mount --make-private /proc
>  
>  now=`date +%Y-%m-%d-%H:%M:%S`
>  for ((i = 0; i < $runners; i++)); do
> @@ -328,6 +337,10 @@ for ((i = 0; i < $runners; i++)); do
>  done;
>  wait
>  
> +# Restore the parents back to shared mount namespace behaviour.
> +mount --make-shared /proc
> +mount --make-shared $basedir
> +
>  if [ -n "$show_test_list" ]; then
>  	exit 0
>  fi
> diff --git a/common/preamble b/common/preamble
> index 78e45d522..8f47b172a 100644
> --- a/common/preamble
> +++ b/common/preamble
> @@ -43,8 +43,11 @@ _begin_fstest()
>  	seqres=$RESULT_DIR/$seq
>  	echo "QA output created by $seq"
>  
> +	# When run from a pid namespace, /tmp/tmp.$$ is not a unique identifier.
> +	# Use mktemp instead.
> +	tmp=`mktemp`
> +
>  	here=`pwd`
> -	tmp=/tmp/$$
>  	status=1	# failure is the default!
>  
>  	_register_cleanup _cleanup
