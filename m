Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4PFVcPa102871 for <xfs@oss.sgi.com>; Mon, 25 May 2009 10:31:38 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51A0B12FE593
	for <xfs@oss.sgi.com>; Mon, 25 May 2009 08:37:34 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id BQ5H08CGdEBZF3rr for <xfs@oss.sgi.com>;
	Mon, 25 May 2009 08:37:34 -0700 (PDT)
Message-ID: <4A1AB9E2.9050503@redhat.com>
Date: Mon, 25 May 2009 10:31:46 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: enable many tests to run on ext2/3/4
References: <4A15B649.70801@redhat.com>
In-Reply-To: <4A15B649.70801@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>, ext4 development <linux-ext4@vger.kernel.org>

Eric Sandeen wrote:
> This gets many of the tests running on ext4 (and should on ext2/ext3
> as well).
> 
> A few things could still be cleaned up; rather than -xfs, -ext3, -ext4
> etc it'd be better to do --fstype xfs or whatnot, and lose as much of
> the special-casing as possible.  But this gets it going, so maybe
> worth merging now as a first step.
> 
> This creates a new supported_fs "generic" type which should run on
> any generic filesystem (well, assuming it supports acls & xattrs, along
> with general posix-ness).
> 
> It also adds a "generic" group, so you can do:
> 
> ./check -ext4 -g generic
> 
> and that way it'll avoid any fs-specific tests.  They wouldn't
> fail anyway, but it gets noisy to see all the "notrun" tests.

For the uninitiated :)  This applies on top of:

http://git.kernel.org/?p=fs/xfs/xfstests-dev.git

Apply my patch & build it with make... you'll need xfsprogs,
xfsprogs-devel, and xfsprogs-qa-devel (or make install-dev, make
install-qa from the xfsprogs tarball)*  A few other standard devel
packages like e2fsprogs-devel, acl-devel, attr-devel, libaio-devel are
needed too.

edit a local.config file in the top level dir:

TEST_DEV=/dev/sdb1       # device containing TEST PARTITION
TEST_DIR=/mnt/test       # mount point of TEST PARTITION
SCRATCH_DEV=/dev/sdb3    # device containing SCRATCH PARTITION
SCRATCH_MNT=/mnt/scratch # mount point for SCRATCH PARTITION

mkfs.ext4 the $TEST_DEV

./check -ext4 -g generic

-Eric

*another TODO is probably to make ./configure cope with lack of at least
the xfsprogs-qa-devel headers.  There's still some work to make this
cleaner/easier but this at least gets things going.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
