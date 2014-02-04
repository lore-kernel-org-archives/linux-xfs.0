Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0F7B97F53
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:53:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0339C30408D
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:53:08 -0800 (PST)
Received: from mail-ee0-f44.google.com (mail-ee0-f44.google.com
	[74.125.83.44]) by cuda.sgi.com with ESMTP id rw39cqlFFAWQo3qr
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 04 Feb 2014 09:53:06 -0800 (PST)
Received: by mail-ee0-f44.google.com with SMTP id c13so4447792eek.31
	for <xfs@oss.sgi.com>; Tue, 04 Feb 2014 09:53:05 -0800 (PST)
Message-ID: <4D99B558BC4F49568900AE5DEA05DE86@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <20140124025846.GL27606@dastard>
	<CAOcd+r1wUaMyrhvkq++WoswM1ND9+VZJNx0mZeC1Uiu663xbtg@mail.gmail.com>
	<52E95EB8.8080003@sandeen.net> <20140202223525.GW2212@dastard>
In-Reply-To: <20140202223525.GW2212@dastard>
Subject: Re: [ANNOUNCE] xfstests updated to 197f773
Date: Tue, 4 Feb 2014 19:53:04 +0200
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi Eric and Dave,
Thank you for your comments.

I don't know whether my information is of any value to you or anybody else, 
because I am using an EOL kernel 3.8.13.
I have run xfstests several times on two different kinds of block devices. 
One is a local file attached to a KVM instance through virtio, second is a 
custom Device Mapper. My local.config file is:
export TEST_DEV=/dev/mapper/vol-0x5
export SCRATCH_DEV=/dev/mapper/vol-0x6
export TEST_DIR=/mnt/TEST_DIR
export SCRATCH_MNT=/mnt/SCRATCH_DIR
export FSTYP="xfs"

A good amount of tests did not run, because, e.g., I do not have dump device 
etc. I list below the tests that failed for me consistently. I analyzed to a 
very limited extent these failures. At some point I decided to focus on 
making the tests that pass on a pristine XFS from my kernel, pass on XFS 
with my changes.

xfstests/xfsprogs/xfsdumps were built from latest git. fio was build on a 
"golden" commit aeb32dfccbd05.

tests/generic:
generic/091 - dowrite: write: Invalid argument
generic/204 - echo: write error: No space left on device
generic/240 - silence is golden, but then: AIO write offset 512 expected 
4096 got -22 ...
generic/263 - ???
generic/299 - fio crash
generic/300 - fio crash
generic/314 - need XFS fix for that, which is not in kernel 3.8.13

tests/xfs:
xfs/016 - log size 853 blocks too small, minimum size is 1605 blocks
xfs/018 - ???
xfs/033 - Corrupting root inode - setting bits to 0, xfsrepair: 
xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
xfs/041 - for some reason, in my case the log occupies much more blocks, and 
the 32-mb FS has no free space, so fill2fs fails
xfs/073 - after copying, the target device has dirty log..
xfs/081 - logprint with quotas
xfs/082 - v2 stripe logs with logprint
xfs/096 - mkfs.xfs: Specified data stripe width 520 is not the same as the 
volume stripe width 1024
xfs/104 - log size 1280 blocks too small, minimum size is 1605 blocks
xfs/109 - fails with ENOSPC
xfs/111 - Overwrote IN @offset 16384
xfs/119 - log size 1200 blocks too small, minimum size is 1968 blocks
xfs/122 - sizes/offsets of some structs/fields differ
xfs/136 - difference in internal structure's content
xfs/171 - failed, 4 streams with matching AGs
xfs/172 - expected failure, matching AGs
xfs/199 - different feature flags, like 0x8a instead of 0xa
xfs/201 - pwrite64: Invalid argument
xfs/206 - existing superblock read failed: Invalid argument
xfs/216 - number of blocks for FS's up to 64g is 12800 (constant); fssize=1g 
existing superblock read failed: Invalid argument
xfs/250 - xfs_repair: read failed: Invalid argument, _check_xfs_filesystem: 
filesystem on /mnt/TEST_DIR/250.fs is inconsistent (r) (see 
/mnt/work/alex/xfstests/results//xfs/250.full)
xfs/262 - hard limit 0 bytes, expected 524288000
xfs/279 - mkfs failures and ERROR: Module scsi_debug is in use
xfs/291 - *** glibc detected *** xfs_repair: double free or corruption 
(!prev): 0x00007fbd3c0008c0 ***
xfs/292 - output differs only in spaces
xfs/296 - output is identical, except missing: missing: 
RESTORE_DIR/DUMP_SUBDIR/testfile cap_setgid,cap_setuid+ep
xfs/297 - output is identical, at the end: _check_xfs_filesystem: filesystem 
on /dev/vdb is inconsistent (c) (see 
/mnt/work/alex/xfstests/results//xfs/297.full)
xfs/298 - single difference: core.nextents = 1 vs 0

xfs/306 doesn't fail, but sometimes triggers a memleak in xfs_trans


Thanks,
Alex.



-----Original Message----- 
From: Dave Chinner
Sent: 03 February, 2014 12:35 AM
To: Eric Sandeen
Cc: Alex Lyakas ; xfs@oss.sgi.com
Subject: Re: [ANNOUNCE] xfstests updated to 197f773

On Wed, Jan 29, 2014 at 02:04:08PM -0600, Eric Sandeen wrote:
> On 1/29/14, 1:55 PM, Alex Lyakas wrote:
> > Hi Dave,
> > are all tests in xfstests (those relevant for XFS) in principle
> > supposed to pass on XFS?
> > I am running these tests on a pristine XFS from kernel 3.8.13
> > (srcversion 9862FA08CF42E06A4151111) and I get:
> >
> > root@vc-13-12-1095-35-dev:/mnt/work/alex/xfstests# ./check 
> > tests/generic/013
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 vc-13-12-1095-35-dev 3.8.13-030813-generic
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> > MOUNT_OPTIONS -- /dev/vdb /mnt/SCRATCH_DIR
> >
> > generic/013      34s
> > _check_xfs_filesystem: filesystem on /dev/vda is inconsistent (c) (see
> > /mnt/work/alex/xfstests/results//generic/013.full)
>
> uh, so it failed
>
> > Ran: generic/013
> > Passed all 1 tests
>
> but it passed?  ;)

It passed the test, but failed the post test filesystem checks.

> The fact that you saw:
>
> > generic/013      34s
>
> and not:
>
> > generic/013      34s ... 33s
> or
> > generic/013      34s ... output mismatch
>
> or similar, makes me think the test did not even start, and /dev/vda was
> corrupted before you even started the test, but I'm not certain.

No, what that means is that there was no results/check.time file
that had previous runtime information in it. i.e. this is the first
time the test was run, or that it has always failed like this in the
past on this machine.

As it is:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
