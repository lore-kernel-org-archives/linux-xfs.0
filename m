Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D58BC7F83
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 12:34:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C1DF2304051
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 10:34:44 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	byENiwdKinZTDTs8 for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 10:34:41 -0800 (PST)
Date: Wed, 2 Dec 2015 11:34:38 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: xfstests failures with xfs, dax and v4.4-rc3
Message-ID: <20151202183438.GA1319@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jeff Moyer <jmoyer@redhat.com>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm hitting a few more test failures in my testing setup with v4.4-rc3, xfs
and DAX.  My test setup is a pair of 4GiB PMEM partitions in a KVM virtual
machine.  Here are the failures:

# ./check generic/256 generic/274 xfs/041
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 alara 4.4.0-rc3
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch

generic/256 43s ... - output mismatch (see /root/xfstests/results//generic/256.out.bad)
    --- tests/generic/256.out	2015-10-02 10:19:36.807795900 -0600
    +++ /root/xfstests/results//generic/256.out.bad	2015-12-02 11:22:34.838845475 -0700
    @@ -1 +1,500 @@
     QA output created by 256
    +fallocate: No space left on device
    +fallocate: No space left on device
    +fallocate: No space left on device
    +fallocate: No space left on device
    +fallocate: No space left on device
    +fallocate: No space left on device
    ...
    (Run 'diff -u tests/generic/256.out /root/xfstests/results//generic/256.out.bad'  to see the entire diff)
generic/274 7s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/274.out.bad)
    --- tests/generic/274.out	2015-10-02 10:19:36.808795907 -0600
    +++ /root/xfstests/results//generic/274.out.bad	2015-12-02 11:22:37.656868990 -0700
    @@ -2,4 +2,5 @@
     ------------------------------
     preallocation test
     ------------------------------
    -done
    +failed to write to test file
    +(see /root/xfstests/results//generic/274.full for details)
    ...
    (Run 'diff -u tests/generic/274.out /root/xfstests/results//generic/274.out.bad'  to see the entire diff)
xfs/041 14s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//xfs/041.out.bad)
    --- tests/xfs/041.out	2015-10-02 10:19:36.818795975 -0600
    +++ /root/xfstests/results//xfs/041.out.bad	2015-12-02 11:22:42.553909854 -0700
    @@ -4,16 +4,5 @@
     Grow filesystem to 33m... done
     Flush filesystem... done
     Check files... done
    -Fill filesystem... done
    -Grow filesystem to 67m... done
    -Flush filesystem... done
    -Check files... done
    ...
    (Run 'diff -u tests/xfs/041.out /root/xfstests/results//xfs/041.out.bad'  to see the entire diff)
Ran: generic/256 generic/274 xfs/041
Failures: generic/256 generic/274 xfs/041
Failed 3 of 3 tests

The .bad files are attached to this mail.

These three tests pass 100% of the time with and without DAX using v4.3, pass
100% of the time with v4.4-rc3 without DAX, and fail 100% of the time with
v4.4-rc3 with DAX enabled.

I did try doubling the size of my ramdisk partition to see if that made any
difference, and the failure was still present.

I'm using xfsprogs v4.3.0.

Please let me know if you have any other questions about how to reproduce the
failure.  I'm also happy to test patches.

Thanks,
- Ross

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="041.out.bad"

QA output created by 041
Make 32 megabyte filesystem on SCRATCH_DEV and mount... done
Fill filesystem... done
Grow filesystem to 33m... done
Flush filesystem... done
Check files... done
Fill filesystem... fail
src/fill2fs --verbose --dir=/mnt/xfstests_scratch/fill_67 --seed=0 --filesize=65536 --stddev=32768 --list=- >>/tmp/32491.manifest failed (returned 1): see /root/xfstests/results//xfs/041.full

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="256.out.bad"

QA output created by 256
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="274.out.bad"

QA output created by 274
------------------------------
preallocation test
------------------------------
failed to write to test file
(see /root/xfstests/results//generic/274.full for details)

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--rwEMma7ioTxnRzrJ--
