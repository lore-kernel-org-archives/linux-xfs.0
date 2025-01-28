Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9FF176AB5
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 04:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738038896; cv=none; b=kByWxY6JXo3FVNrHTNbThnf7wr9y2EDA9yDlhzqEPMILff3C0n4TdxnET4r8H7Tjo+ILD9p1pYi8imXxiK/LbalEYhxsuedZ+woC7iDf3DcwjNHvTy+sl2s0e8Epp4ljjeFTzFJH1tKqlDSlG3PLCONKrIlgERaF069hirdRZ0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738038896; c=relaxed/simple;
	bh=61G0VNR82yJNDTtRFO1uiPLdVmmKQPXq3XE6P+Z6DLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFMxg7soGF8F/UBxgHWVXtwJEo7MEmdKiTYctjGVsIQ0uMKuuhNH3GEOyln+jahBHqwuHaxhwRQCnnBbJWmvsZ4fnJpszyCjkfIV6WwmNezzVSPV4f19whTUqaHjl2UlHdkoBuzCb7gF5l0rFAPZ3KBHx2q7jt9iya2OLZL1IkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LKW/AzMW; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LKW/AzMW"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ee9a780de4so6921315a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 20:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738038894; x=1738643694; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dgHF3g8mGgNAoMiqxYE9hBzTup3uaDI1x+LREjvvw+I=;
        b=LKW/AzMW1XvYsGZE8qvZTTD7ybQiKJjPyp+jazi6IM4jbME61l6I4yz4djWF4zm2Nr
         FN33txJgJZiC938E1/6MocSA3ZYm/0SLqxDSz7hbWetVUbEmCRK4cTGKeljWHogZUBh6
         oj3ZTKk2rN/Wpj+EkZz7PJ79bGMMLO1Dr2xnS3gpquvhSaLCSGFa/W9jlE+V88BehBm9
         9Lf1C1Qq6MdB2k0tru6njLLVOLq25wWbeTuH+uv6P1FbeVgBkbHozWg6z+92r0DpGeZy
         L+3GDVTuSSpTEw7QV5DAPqnSvNrzS+lhEG4zq+etlb5LyxkG9uHOr5N/Bmb4dn10+v8D
         na4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738038894; x=1738643694;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dgHF3g8mGgNAoMiqxYE9hBzTup3uaDI1x+LREjvvw+I=;
        b=Y0MmNAkPhuTlKMf5PmjkdS1bmtBY8Xgkkr0zdLWhdqfM5hMFYwHWoN52M9cPGjmXmT
         GW0hqLcu7DZ8pVfxGigWYeb3bFoLCp9DgATbqNslItFhn3Fg0do9rqXXLWWrh7gAn1tb
         jzpyLGw9XPfkGQpmC0EY3khP4pbBEaGhMEQMlhNPSJOgGLItZlQhveAYrg1W2SETwcy1
         CyOV7sEMMAQAdQ4i47EyhAz+5PkNcUGXow5khmOYufz8jIs+tHZSuch/dvMlByaY0oE4
         3fBCi38iImNk0O9Cl+hMtYLVRsOwtNLTzYam2xrDAuwLX4zaPTKH2H1qVeDh52rJKWWJ
         YeAA==
X-Forwarded-Encrypted: i=1; AJvYcCU3r/uyTdbIubyVlSDItAH6laLz6u98klEAxXw0JijXrKESBWyVQQBcThJz0PgzOGOgN0ye2qUPL74=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx94DJzes7XAF4XtNceIeYj4VXeEsUT+DX/A8G3H85YMIevpWL
	jzhb604IHQ1Nh25DqmbdiKATHZwH3mRslXXJo6947RuS+OSdU0o+vLXjTEATuHM=
X-Gm-Gg: ASbGncvX1mv/KLe2ielL2bQ4DUk8CHgEJDoMtb1VjJLfVHzjxNQc8HrJBCbCbskhU2N
	EMzcWjI6GCE1gw1YfKQpTAb+sxIe7CiExQAlGBYfCkgoSjQvKc5XjFxTCc0b64Xo3zF4xyLGjli
	Ur5wo1WAsQghE7GT+tKmNO+52f0Ft6q8tM5spb12DmrKC+tZPCBb8nISN/k1EKCtxGA0xtAsH26
	EK7mg72Lc/gGW7Ywz2phMpbC8ONk52bmLu6/sVudV/FmJbNo8rw41IF0nhzJAD2STyoDYOLp/FU
	E7MnN3lIb4eNtMJf84NAL595p9FalKke64/zfUNq14JWGk3fHz6OHvYJsbRJMJQuVP4=
X-Google-Smtp-Source: AGHT+IHGUr/6qb136krSxXQVy8DncxY+Fb+eFJiAdmZ96Y5pbNirozZhC0Xff3HAHo/WqusUhjP3Uw==
X-Received: by 2002:a05:6a00:2294:b0:728:e745:23cd with SMTP id d2e1a72fcca58-72daf92bbd7mr66902904b3a.3.1738038893810;
        Mon, 27 Jan 2025 20:34:53 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b2ed8sm8047302b3a.41.2025.01.27.20.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 20:34:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tcdJK-0000000BRhd-0Hgn;
	Tue, 28 Jan 2025 15:34:50 +1100
Date: Tue, 28 Jan 2025 15:34:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <Z5heaj-ZsL_rBF--@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
 <Z48UWiVlRmaBe3cY@dread.disaster.area>
 <20250122042400.GX1611770@frogsfrogsfrogs>
 <Z5CLUbj4qbXCBGAD@dread.disaster.area>
 <20250122070520.GD1611770@frogsfrogsfrogs>
 <Z5C9mf2yCgmZhAXi@dread.disaster.area>
 <20250122214609.GE1611770@frogsfrogsfrogs>
 <Z5GYgjYL_9LecSb9@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z5GYgjYL_9LecSb9@dread.disaster.area>

On Thu, Jan 23, 2025 at 12:16:50PM +1100, Dave Chinner wrote:
> On Wed, Jan 22, 2025 at 01:46:09PM -0800, Darrick J. Wong wrote:
> > > > Agreed, though at some point after these bugfixes are merged I'll see if
> > > > I can build on the existing "if you have systemd then ___ else here's
> > > > your shabby opencoded version" logic in fstests to isolate the ./checks
> > > > from each other a little better.  It'd be kinda nice if we could
> > > > actually just put them in something resembling a modernish container,
> > > > albeit with the same underlying fs.
> > > 
> > > Agreed, but I don't think we need to depend on systemd for that,
> > > either.
> > > 
> > > > <shrug> Anyone else interested in that?
> > > 
> > > check-parallel has already started down that road with the
> > > mount namespace isolation it uses for the runner tasks via
> > > src/nsexec.c.
.....
> > > Hmmm - looks like src/nsexec.c can create new PID namespaces via
> > > the "-p" option. I haven't used that before - I wonder if that's a
> > > better solution that using per-test session IDs to solve the pkill
> > > --parent problem? Something to look into in the morning....

.....

> Note, however, that ps will show all processes in both the parent
> and the child namespace the shell is running on because the contents
> of /proc are the same for both.
> 
> However, because we are also using private mount namespaces for the
> check process, pid_namespaces(7) tells us:
> 
> /proc and PID namespaces
> 
>        A /proc filesystem shows (in the /proc/pid directories) only
>        processes visible in the PID namespace of the process that
>        performed the mount, even if the /proc filesystem is viewed
>        from processes in other namespaces.
> 
>        After creating a new PID namespace, it is useful for the
>        child to change its root directory and mount a new procfs
>        instance at /proc so that tools  such  as  ps(1) work
> >>>    correctly.  If a new mount namespace is simultaneously
> >>>    created by including CLONE_NEWNS in the flags argument of
> >>>    clone(2) or unshare(2), then it isn't necessary to change the
> >>>    root directory: a new procfs instance can be mounted directly
> >>>    over /proc.
> 
>        From a shell, the command to mount /proc is:
> 
>            $ mount -t proc proc /proc
> 
>        Calling readlink(2) on the path /proc/self yields the process
>        ID of the caller in the PID namespace of the procfs mount
>        (i.e., the PID name‐ space of the process that mounted the
>        procfs).  This can be useful for introspection purposes, when
>        a process wants to discover its  PID  in other namespaces.
> 
> This appears to give us an environment that only shows the processes
> within the current PID namespace:
> 
> $ sudo src/nsexec -p -m bash
> # mount -t proc proc /proc
> # ps waux
> USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root           1  0.0  0.0   7384  3744 pts/1    S    11:55   0:00 bash
> root          72  0.0  0.0   8300  3736 pts/1    R+   12:04   0:00 ps waux
> # pstree -N pid
> [4026538173]
> bash───pstree
> #
> 
> Yup, there we go - we have full PID isolation for this shell.

Ok, it took me some time to get this to work reliably - the way was
full of landmines with little documentation to guide around them.

1. If multiple commands are needed to be run from nsexec, a helper
   script is needed (I called it check-helper).

2. You have to `mount --make-private /proc` before doing anything to
   make the mounts of /proc inside the pid namespace work correctly.
   If you don't do this, every other mount namespace will also see
   only the newest mount, and that means every runner but the last
   one to start with the wrong mount and PID namespace view in /proc.

3. if you get the system into the state described by 1), unmounting
   /proc in each runner then races to remove the top /proc mount.
   Many threads get -EBUSY failures from unmount, leaving many stale
   mounts of /proc behind.

4. the top level shell where check-parallel was invoked is left with
   the view where /proc has been unmounted from a PID/mount
   namespace that has gone away. Hence /proc now has no processes or
   mounts being reported and nothing works until you mount a new
   instance /proc in that namespace.

5. After mounting proc again there are lots of mounts of stale /proc
   mounts still reported. They cannot be unmounted as the mount
   namespaces that created them have gone away and unmounting /proc
   in the current shell simply removes the last mounted one and we
   goto 4).

4. /tmp is still shared across all runner instances so all the

   concurrent runners dump all their tmp files in /tmp. However, the
   runners no longer have unique PIDs (i.e. check runs as PID 3 in
   all runner instaces). This means using /tmp/tmp.$$ as the
   check/test temp file definition results is instant tmp file name
   collisions and random things in check and tests fail.  check and
   common/preamble have to be converted to use `mktemp` to provide
   unique tempfile name prefixes again.

5. Don't forget to revert the parent /proc mount back to shared
   after check has finished running (or was aborted).

I think with this (current prototype patch below), we can use PID
namespaces rather than process session IDs for check-parallel safe
process management.

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com


check-parallel: use PID namespaces for runner process isolation

From: Dave Chinner <dchinner@redhat.com>

This provides isolation between individual runners so that they
cannot see the processes that other test runners have created.
This means tools like pkill will only find processes run by the test
that is calling it, hence there is no danger taht it might kill
processes owned by a different test in a different runner context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check           |  6 +++++-
 check-helper    | 23 +++++++++++++++++++++++
 check-parallel  | 25 +++++++++++++++++++------
 common/preamble |  5 ++++-
 4 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/check b/check
index 4dc266dcf..314436667 100755
--- a/check
+++ b/check
@@ -4,7 +4,11 @@
 #
 # Control script for QA
 #
-tmp=/tmp/$$
+
+# When run from a pid namespace, /tmp/tmp.$$ is not a unique identifier.
+# Use mktemp instead.
+tmp=`mktemp`
+
 status=0
 needwrap=true
 needsum=true
diff --git a/check-helper b/check-helper
new file mode 100755
index 000000000..47a92de8b
--- /dev/null
+++ b/check-helper
@@ -0,0 +1,23 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Red Hat, Inc.  All Rights Reserved.
+#
+
+# When check is run from check-parallel, it is run in private mount and PID
+# namespaces. We need to set up /proc to only show processes in this PID
+# namespace, so we mount a new instance of /proc over the top of the existing
+# version. Because we are in a private mount namespace, the does not propagate
+# outside this context and hence does not conflict with the other test runners
+# that are performing the same setup actions.
+
+args="$@"
+
+#echo $args
+mount -t proc proc /proc
+ret=$?
+if [ $ret -eq 0 ]; then
+	./check $args
+	umount -l /proc
+else
+	echo failed to mount /proc, ret $ret!
+fi
diff --git a/check-parallel b/check-parallel
index 2fbf0fdbe..6082baf5e 100755
--- a/check-parallel
+++ b/check-parallel
@@ -259,14 +259,14 @@ runner_go()
 	rm -f $RESULT_BASE/check.*
 
 	# Only supports default mkfs parameters right now
-	wipefs -a $TEST_DEV > /dev/null 2>&1
-	yes | mkfs -t $FSTYP $TEST_MKFS_OPTS $TEST_DEV > /dev/null 2>&1
+	wipefs -a $TEST_DEV > $me/log 2>&1
+	yes | mkfs -t $FSTYP $TEST_MKFS_OPTS $TEST_DEV >> $me/log 2>&1
 
 #	export DUMP_CORRUPT_FS=1
 
-	# Run the tests in it's own mount namespace, as per the comment below
-	# that precedes making the basedir a private mount.
-	./src/nsexec -m ./check $run_section -x unreliable_in_parallel --exact-order ${runner_list[$id]} > $me/log 2>&1
+	# Run the tests in it's own mount and PID namespace, as per the comment
+	# below that precedes making the basedir a private mount.
+	./src/nsexec -m -p ./check-helper $run_section -x unreliable_in_parallel --exact-order ${runner_list[$id]} >> $me/log 2>&1
 
 	wait
 	sleep 1
@@ -291,6 +291,8 @@ cleanup()
 	umount -R $basedir/*/test 2> /dev/null
 	umount -R $basedir/*/scratch 2> /dev/null
 	losetup --detach-all
+	mount --make-shared /proc
+	mount --make-shared $basedir
 }
 
 trap "cleanup; exit" HUP INT QUIT TERM
@@ -311,10 +313,17 @@ fi
 # controls the mount to succeed without actually unmounting the filesytsem
 # because a mount namespace still holds a reference to it. This causes other
 # operations on the block device to fail as it is still busy (e.g. fsck, mkfs,
-# etc). Hence we make the basedir private here and then run each check instance
+# etc).
+#
+# Hence we make the basedir private here and then run each check instance
 # in it's own mount namespace so that they cannot see mounts that other tests
 # are performing.
+#
+# We also need to make /proc private so that the runners can be run cleanly in
+# a PID namespace. This requires an new mount of /proc inside the PID namespace,
+# and this requires a private mount namespace to work correctly.
 mount --make-private $basedir
+mount --make-private /proc
 
 now=`date +%Y-%m-%d-%H:%M:%S`
 for ((i = 0; i < $runners; i++)); do
@@ -328,6 +337,10 @@ for ((i = 0; i < $runners; i++)); do
 done;
 wait
 
+# Restore the parents back to shared mount namespace behaviour.
+mount --make-shared /proc
+mount --make-shared $basedir
+
 if [ -n "$show_test_list" ]; then
 	exit 0
 fi
diff --git a/common/preamble b/common/preamble
index 78e45d522..8f47b172a 100644
--- a/common/preamble
+++ b/common/preamble
@@ -43,8 +43,11 @@ _begin_fstest()
 	seqres=$RESULT_DIR/$seq
 	echo "QA output created by $seq"
 
+	# When run from a pid namespace, /tmp/tmp.$$ is not a unique identifier.
+	# Use mktemp instead.
+	tmp=`mktemp`
+
 	here=`pwd`
-	tmp=/tmp/$$
 	status=1	# failure is the default!
 
 	_register_cleanup _cleanup
