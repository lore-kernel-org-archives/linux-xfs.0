Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A25C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 02:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C12A6113A
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 02:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhKFCKp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 22:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhKFCKp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Nov 2021 22:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00CB161074;
        Sat,  6 Nov 2021 02:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636164485;
        bh=9pstBxCueFjzWV/EeSMXfOYfcaHmbcqF63s3xUhZOTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vi+YRLYsEM2UpVRiT+BwhH9PqLS+zqXNIt7wZuAiDZqjwTK8CubC+mj/kry79Q+QK
         1g5u/tWiNtkO+0SwlSBK5duOGLMbA/bADr5korbp0aqetx/DE0VAhTqVUsFopyEqaE
         4i0HZ+HUkkZAei9RSuY+BJQLnwQwozR8GX5RImogedBLwQbB9Eq4wsTELReLOATcuc
         vILUF6AwsM+awO9KR+5C649vIEilegsbe+2R/rdcMKpXsPfELfUJ+U3KmAy+OuvO2y
         JWep4PmxMbtiGhg3EsG+euVY+//vo+L542w1qmLqDLjT9VLw3r302eE0Ke9P5gcatD
         5WGb9YAa7AEFA==
Date:   Fri, 5 Nov 2021 19:08:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        leah.rumancik@gmail.com
Subject: Re: xfs/076 takes a long long time testing with a realtime volume
Message-ID: <20211106020804.GU24307@magnolia>
References: <YYVo8ZyKpy4Di0pK@mit.edu>
 <YYXhNip3PctJAaDY@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYXhNip3PctJAaDY@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 05, 2021 at 09:58:14PM -0400, Theodore Ts'o wrote:
> After committing some exclusions into my test runner framework (see
> below), I tested a potential fix to xfs/076 which disables the
> real-time volume when creating the scratch volume.  Should I send it
> as a formal patch to fstests?

Does adding:

_xfs_force_bdev data $SCRATCH_MNT

right after _scratch_mount make the performance problem go away?  Sparse
inodes and realtime are a supported configuration.

--D

> diff --git a/tests/xfs/076 b/tests/xfs/076
> index eac7410e..5628c08f 100755
> --- a/tests/xfs/076
> +++ b/tests/xfs/076
> @@ -60,6 +60,7 @@ _require_xfs_io_command "falloc"
>  _require_xfs_io_command "fpunch"
>  _require_xfs_sparse_inodes
>  
> +unset SCRATCH_RTDEV
>  _scratch_mkfs "-d size=50m -m crc=1 -i sparse" |
>  	_filter_mkfs > /dev/null 2> $tmp.mkfs
>  . $tmp.mkfs	# for isize
> 
> 						- Ted
> 
> For why this is needed, see the commit description below:
> 
> commit c41ae1cc0b21eafd2858541c0bc195f951c0726c
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Fri Nov 5 20:46:19 2021 -0400
> 
>     test-appliance: exclude xfs/076 from the realtime configs
>     
>     The xfs/076 test takes two minutes on a normal xfs file system (e.g.,
>     a normal 4k block size file system).  However, when there is a
>     real-time volume attached, this test takes over 80 minutes.  The
>     reason for this seems to be because the test is spending a lot more
>     time failing to create files due to missing directories.  Compare:
>     
>     root@xfstests-2:~# ls -sh /results/xfs/results-4k/xfs/076.full
>     48K /results/xfs/results-4k/xfs/076.full
>     root@xfstests-2:~# ls -sh /tmp/realtime-076.full
>     25M /tmp/realtime-076.full
>     
>     and:
>     
>     root@xfstests-2:~# grep "cannot touch" /results/xfs/results-4k/xfs/076.full | wc -l
>     656
>     root@xfstests-2:~# grep "cannot touch" /tmp/realtime-076.full | wc -l
>     327664
>     
>     The failures from 076.full look like this:
>     
>     touch: cannot touch '/xt-vdc/offset.21473722368/25659': No space left on device
>     touch: cannot touch '/xt-vdc/offset.21473656832/0': No such file or directory
>     touch: cannot touch '/xt-vdc/offset.21473591296/0': No such file or directory
>     ...
>     touch: cannot touch '/xt-vdc/offset.196608/0': No such file or directory
>     touch: cannot touch '/xt-vdc/offset.131072/0': No such file or directory
>     touch: cannot touch '/xt-vdc/offset.65536/0': No such file or directory
>     touch: cannot touch '/xt-vdc/offset.0/0': No such file or directory
>     
>     What seems to be going on is that xfs/076 tries to create a small
>     scratch file system --- but when we attach a real-time volume this
>     balloons the available size of the file system.  Of course, that space
>     can't be used for normal files.  As a result, xfs/076 is incorrectly
>     estimating how many files it needs to create to fill the file system.
>     
>     I'm not sure what's the best way to fix this in the test; perhaps the
>     test should forcibly unset SCRATCH_RTDEV environment variable before
>     running _scratch_mkfs?  Anyway, for now, we'll just skip running
>     xfs/076 for the xfs/realtime* configs.
>     
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> diff --git a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime.exclude b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime.exclude
> index a9acba9c..bafce552 100644
> --- a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime.exclude
> +++ b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime.exclude
> @@ -1,2 +1,7 @@
>  # Normal configurations don't support dax
>  -g dax
> +
> +# The xfs/076 test takes well over an hour (80 minutes using 100GB GCE
> +# PD/SSD) when run with an external realtime device, which triggers
> +# the ltm "test is stalled" failsafe which aborts the VM.
> +xfs/076
> diff --git a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_28k_logdev.exclude b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_28k_logdev.exclude
> index a9acba9c..bafce552 100644
> --- a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_28k_logdev.exclude
> +++ b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_28k_logdev.exclude
> @@ -1,2 +1,7 @@
>  # Normal configurations don't support dax
>  -g dax
> +
> +# The xfs/076 test takes well over an hour (80 minutes using 100GB GCE
> +# PD/SSD) when run with an external realtime device, which triggers
> +# the ltm "test is stalled" failsafe which aborts the VM.
> +xfs/076
> diff --git a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_logdev.exclude b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_logdev.exclude
> index a9acba9c..bafce552 100644
> --- a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_logdev.exclude
> +++ b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_logdev.exclude
> @@ -1,2 +1,7 @@
>  # Normal configurations don't support dax
>  -g dax
> +
> +# The xfs/076 test takes well over an hour (80 minutes using 100GB GCE
> +# PD/SSD) when run with an external realtime device, which triggers
> +# the ltm "test is stalled" failsafe which aborts the VM.
> +xfs/076
