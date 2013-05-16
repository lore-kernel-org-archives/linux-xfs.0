Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C075B7F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 09:03:51 -0500 (CDT)
Message-ID: <5194E764.6030207@sgi.com>
Date: Thu, 16 May 2013 09:04:20 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: 311: fsck the dmflakey device instead of the
	real device V2
References: <1368631217-15511-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1368631217-15511-1-git-send-email-jbacik@fusionio.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com

On 05/15/2013 10:20 AM, Josef Bacik wrote:
> Dave pointed out that xfs was having issues with 311 because of caching issues.
> He suggested that I fsck the dm-flakey device to make sure we don't have this
> problem.  Make _check_scratch_fs take an optional argument to use as the device
> to fsck.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
Hi Josef,

Looks like it fails test 19 , are we supposed to see failures for ext4 
and xfs?

./check generic/311
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 cxfsxe4 3.9.0+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdk2
MOUNT_OPTIONS -- /dev/sdk2 /mnt/scratch

generic/311	 - output mismatch (see 
/usr/src/xfstests/results/generic/311.out.bad)
     --- tests/generic/311.out	2013-05-08 09:30:37.000000000 -0500
     +++ /usr/src/xfstests/results/generic/311.out.bad	2013-05-16 
08:13:00.000000000 -0500
     @@ -293,16 +293,16 @@
      26b2ad08ac2589804a15ceb473f0b1ac
      Running test 19 direct, normal suspend
      Random seed is 19
     -26b2ad08ac2589804a15ceb473f0b1ac
     -26b2ad08ac2589804a15ceb473f0b1ac
     +d41d8cd98f00b204e9800998ecf8427e
     +d41d8cd98f00b204e9800998ecf8427e
      ...
      (Run 'diff -u tests/generic/311.out 
/usr/src/xfstests/results/generic/311.out.bad' to see the entire diff)
Ran: generic/311
Failures: generic/311
Failed 1 of 1 tests

./check generic/311
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 cxfsxe4 3.9.0+
MKFS_OPTIONS  -- /dev/sdk2
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sdk2 /mnt/scratch

generic/311	 - output mismatch (see 
/usr/src/xfstests/results/generic/311.out.bad)
     --- tests/generic/311.out	2013-05-08 09:30:37.000000000 -0500
     +++ /usr/src/xfstests/results/generic/311.out.bad	2013-05-16 
08:16:50.000000000 -0500
     @@ -293,16 +293,16 @@
      26b2ad08ac2589804a15ceb473f0b1ac
      Running test 19 direct, normal suspend
      Random seed is 19
     -26b2ad08ac2589804a15ceb473f0b1ac
     -26b2ad08ac2589804a15ceb473f0b1ac
     +d41d8cd98f00b204e9800998ecf8427e
     +d41d8cd98f00b204e9800998ecf8427e
      ...
      (Run 'diff -u tests/generic/311.out 
/usr/src/xfstests/results/generic/311.out.bad' to see the entire diff)
Ran: generic/311
Failures: generic/311
Failed 1 of 1 tests

It passes for btrfs.

./check generic/311
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 cxfsxe4 3.9.0+
MKFS_OPTIONS  -- /dev/sdk2
MOUNT_OPTIONS -- /dev/sdk2 /mnt/scratch

generic/311	 46s
Ran: generic/311
Passed all 1 tests

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
