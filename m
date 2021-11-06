Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA513C433FE
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 01:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADE3261056
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 01:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhKFCBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 22:01:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:51367 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230270AbhKFCBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Nov 2021 22:01:00 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1A61wEDt006670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 5 Nov 2021 21:58:15 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 7BBDA15C00B9; Fri,  5 Nov 2021 21:58:14 -0400 (EDT)
Date:   Fri, 5 Nov 2021 21:58:14 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        leah.rumancik@gmail.com
Subject: xfs/076 takes a long long time testing with a realtime volume
Message-ID: <YYXhNip3PctJAaDY@mit.edu>
References: <YYVo8ZyKpy4Di0pK@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYVo8ZyKpy4Di0pK@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After committing some exclusions into my test runner framework (see
below), I tested a potential fix to xfs/076 which disables the
real-time volume when creating the scratch volume.  Should I send it
as a formal patch to fstests?

diff --git a/tests/xfs/076 b/tests/xfs/076
index eac7410e..5628c08f 100755
--- a/tests/xfs/076
+++ b/tests/xfs/076
@@ -60,6 +60,7 @@ _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
 _require_xfs_sparse_inodes
 
+unset SCRATCH_RTDEV
 _scratch_mkfs "-d size=50m -m crc=1 -i sparse" |
 	_filter_mkfs > /dev/null 2> $tmp.mkfs
 . $tmp.mkfs	# for isize

						- Ted

For why this is needed, see the commit description below:

commit c41ae1cc0b21eafd2858541c0bc195f951c0726c
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Nov 5 20:46:19 2021 -0400

    test-appliance: exclude xfs/076 from the realtime configs
    
    The xfs/076 test takes two minutes on a normal xfs file system (e.g.,
    a normal 4k block size file system).  However, when there is a
    real-time volume attached, this test takes over 80 minutes.  The
    reason for this seems to be because the test is spending a lot more
    time failing to create files due to missing directories.  Compare:
    
    root@xfstests-2:~# ls -sh /results/xfs/results-4k/xfs/076.full
    48K /results/xfs/results-4k/xfs/076.full
    root@xfstests-2:~# ls -sh /tmp/realtime-076.full
    25M /tmp/realtime-076.full
    
    and:
    
    root@xfstests-2:~# grep "cannot touch" /results/xfs/results-4k/xfs/076.full | wc -l
    656
    root@xfstests-2:~# grep "cannot touch" /tmp/realtime-076.full | wc -l
    327664
    
    The failures from 076.full look like this:
    
    touch: cannot touch '/xt-vdc/offset.21473722368/25659': No space left on device
    touch: cannot touch '/xt-vdc/offset.21473656832/0': No such file or directory
    touch: cannot touch '/xt-vdc/offset.21473591296/0': No such file or directory
    ...
    touch: cannot touch '/xt-vdc/offset.196608/0': No such file or directory
    touch: cannot touch '/xt-vdc/offset.131072/0': No such file or directory
    touch: cannot touch '/xt-vdc/offset.65536/0': No such file or directory
    touch: cannot touch '/xt-vdc/offset.0/0': No such file or directory
    
    What seems to be going on is that xfs/076 tries to create a small
    scratch file system --- but when we attach a real-time volume this
    balloons the available size of the file system.  Of course, that space
    can't be used for normal files.  As a result, xfs/076 is incorrectly
    estimating how many files it needs to create to fill the file system.
    
    I'm not sure what's the best way to fix this in the test; perhaps the
    test should forcibly unset SCRATCH_RTDEV environment variable before
    running _scratch_mkfs?  Anyway, for now, we'll just skip running
    xfs/076 for the xfs/realtime* configs.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime.exclude b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime.exclude
index a9acba9c..bafce552 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime.exclude
+++ b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime.exclude
@@ -1,2 +1,7 @@
 # Normal configurations don't support dax
 -g dax
+
+# The xfs/076 test takes well over an hour (80 minutes using 100GB GCE
+# PD/SSD) when run with an external realtime device, which triggers
+# the ltm "test is stalled" failsafe which aborts the VM.
+xfs/076
diff --git a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_28k_logdev.exclude b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_28k_logdev.exclude
index a9acba9c..bafce552 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_28k_logdev.exclude
+++ b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_28k_logdev.exclude
@@ -1,2 +1,7 @@
 # Normal configurations don't support dax
 -g dax
+
+# The xfs/076 test takes well over an hour (80 minutes using 100GB GCE
+# PD/SSD) when run with an external realtime device, which triggers
+# the ltm "test is stalled" failsafe which aborts the VM.
+xfs/076
diff --git a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_logdev.exclude b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_logdev.exclude
index a9acba9c..bafce552 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_logdev.exclude
+++ b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/realtime_logdev.exclude
@@ -1,2 +1,7 @@
 # Normal configurations don't support dax
 -g dax
+
+# The xfs/076 test takes well over an hour (80 minutes using 100GB GCE
+# PD/SSD) when run with an external realtime device, which triggers
+# the ltm "test is stalled" failsafe which aborts the VM.
+xfs/076
