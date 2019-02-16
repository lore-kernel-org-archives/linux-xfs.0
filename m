Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42082 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfBPRY4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Feb 2019 12:24:56 -0500
Date: Sat, 16 Feb 2019 09:24:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/3] generic: posix acl extended attribute memory
 corruption test
Message-ID: <20190216172447.GX32253@magnolia>
References: <154993784038.1948.7502664832930298472.stgit@magnolia>
 <20190213204814.GB6477@magnolia>
 <20190216120530.GZ2713@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190216120530.GZ2713@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sat, Feb 16, 2019 at 08:05:30PM +0800, Eryu Guan wrote:
> On Wed, Feb 13, 2019 at 12:48:14PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > XFS had a use-after-free bug when xfs_xattr_put_listent runs out of
> > listxattr buffer space while trying to store the name
> > "system.posix_acl_access" and then corrupts memory by not checking the
> > seen_enough state and then trying to shove "trusted.SGI_ACL_FILE" into
> > the buffer as well.
> > 
> > In order to tickle the bug in a user visible way we must have already
> > put a name in the buffer, so we take advantage of the fact that
> > "security.evm" sorts before "system.posix_acl_access" to make sure this
> > happens.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  .gitignore              |    1 
> >  src/Makefile            |    2 -
> >  src/t_attr_corruption.c |  122 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/712       |   41 ++++++++++++++++
> >  tests/generic/712.out   |    2 +
> >  tests/generic/group     |    1 
> >  6 files changed, 168 insertions(+), 1 deletion(-)
> >  create mode 100644 src/t_attr_corruption.c
> >  create mode 100755 tests/generic/712
> >  create mode 100644 tests/generic/712.out
> > 
> > diff --git a/.gitignore b/.gitignore
> > index ea1aac8a..0933dc7d 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -114,6 +114,7 @@
> >  /src/stat_test
> >  /src/swapon
> >  /src/t_access_root
> > +/src/t_attr_corruption
> >  /src/t_dir_offset
> >  /src/t_dir_offset2
> >  /src/t_dir_type
> > diff --git a/src/Makefile b/src/Makefile
> > index 41826585..ae09eb0a 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -27,7 +27,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >  	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
> >  	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
> >  	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
> > -	attr_replace_test swapon mkswap
> > +	attr_replace_test swapon mkswap t_attr_corruption
> >  
> >  SUBDIRS = log-writes perf
> >  
> > diff --git a/src/t_attr_corruption.c b/src/t_attr_corruption.c
> > new file mode 100644
> > index 00000000..1fa5e41f
> > --- /dev/null
> > +++ b/src/t_attr_corruption.c
> > @@ -0,0 +1,122 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * Test program to tickle a use-after-free bug in xfs.
> > + *
> > + * XFS had a use-after-free bug when xfs_xattr_put_listent runs out of
> > + * listxattr buffer space while trying to store the name
> > + * "system.posix_acl_access" and then corrupts memory by not checking the
> > + * seen_enough state and then trying to shove "trusted.SGI_ACL_FILE" into the
> > + * buffer as well.
> > + *
> > + * In order to tickle the bug in a user visible way we must have already put a
> > + * name in the buffer, so we take advantage of the fact that "security.evm"
> > + * sorts before "system.posix_acl_access" to make sure this happens.
> > + *
> > + * If we trigger the bug, the program will print the garbled string
> > + * "rusted.SGI_ACL_FILE".  If the bug is fixed, the flistxattr call returns
> > + * ERANGE.
> > + */
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <stdlib.h>
> > +#include <stdio.h>
> > +#include <string.h>
> > +#include <stdint.h>
> > +#include <unistd.h>
> > +#include <attr/xattr.h>
> > +
> > +void die(const char *msg)
> > +{
> > +	perror(msg);
> > +	exit(1);
> > +}
> > +
> > +struct entry {
> > +	uint16_t	a;
> > +	uint16_t	b;
> > +	uint32_t	c;
> > +};
> > +
> > +struct myacl {
> > +	uint32_t	d;
> > +	struct entry	e[4];
> > +};
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	struct myacl acl = {
> > +		.d = 2,
> > +		.e = {
> > +			{1, 0, 0},
> > +			{4, 0, 0},
> > +			{0x10, 0, 0},
> > +			{0x20, 0, 0},
> > +		},
> > +	};
> > +	char buf[64];
> > +	ssize_t sz;
> > +	int fd;
> > +	int ret;
> > +
> > +	if (argc > 1) {
> > +		ret = chdir(argv[1]);
> > +		if (ret)
> > +			die(argv[1]);
> > +	}
> > +
> > +	fd = creat("file0", 0644);
> > +	if (fd < 0)
> > +		die("create");
> > +
> > +	ret = fsetxattr(fd, "system.posix_acl_access", &acl, sizeof(acl), 0);
> > +	if (ret)
> > +		die("set posix acl");
> > +
> > +	ret = fsetxattr(fd, "security.evm", buf, 1, 1);
> > +	if (ret)
> > +		die("set evm");
> > +
> > +	sz = flistxattr(fd, buf, 30);
> > +	if (sz < 0)
> > +		die("list attr");
> > +
> > +	printf("%s\n", buf);
> > +
> > +	return 0;
> > +
> > +#if 0
> > +	/* original syzkaller reproducer */
> > +
> > +	syscall(__NR_mmap, 0x20000000, 0x1000000, 3, 0x32, -1, 0);
> > +
> > +	memcpy((void*)0x20000180, "./file0", 8);
> > +	syscall(__NR_creat, 0x20000180, 0);
> > +	memcpy((void*)0x20000000, "./file0", 8);
> > +	memcpy((void*)0x20000040, "system.posix_acl_access", 24);
> > +	*(uint32_t*)0x20000680 = 2;
> > +	*(uint16_t*)0x20000684 = 1;
> > +	*(uint16_t*)0x20000686 = 0;
> > +	*(uint32_t*)0x20000688 = 0;
> > +	*(uint16_t*)0x2000068c = 4;
> > +	*(uint16_t*)0x2000068e = 0;
> > +	*(uint32_t*)0x20000690 = 0;
> > +	*(uint16_t*)0x20000694 = 0x10;
> > +	*(uint16_t*)0x20000696 = 0;
> > +	*(uint32_t*)0x20000698 = 0;
> > +	*(uint16_t*)0x2000069c = 0x20;
> > +	*(uint16_t*)0x2000069e = 0;
> > +	*(uint32_t*)0x200006a0 = 0;
> > +	syscall(__NR_setxattr, 0x20000000, 0x20000040, 0x20000680, 0x24, 0);
> > +	memcpy((void*)0x20000080, "./file0", 8);
> > +	memcpy((void*)0x200000c0, "security.evm", 13);
> > +	memcpy((void*)0x20000100, "\x03\x00\x00\x00\x57", 5);
> > +	syscall(__NR_lsetxattr, 0x20000080, 0x200000c0, 0x20000100, 1, 1);
> > +	memcpy((void*)0x20000300, "./file0", 8);
> > +	syscall(__NR_listxattr, 0x20000300, 0x200002c0, 0x1e);
> > +	return 0;
> > +#endif
> > +}
> > diff --git a/tests/generic/712 b/tests/generic/712
> > new file mode 100755
> > index 00000000..6348a797
> > --- /dev/null
> > +++ b/tests/generic/712
> > @@ -0,0 +1,41 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0+
> > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 712
> > +#
> > +# Regression test for a bug where XFS corrupts memory if the listxattr buffer
> > +# is a particularly well crafted size on a filesystem that supports posix acls.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +testfile=$TEST_DIR/$seq.txt
> 
> I removed this definition, which is not used in the test.
> 
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/attr
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_acls
> > +_require_scratch
> 
> I also added
> 
> _require_test_program "t_attr_corruption"

Sounds good, thank you!

> Thanks,
> Eryu
> 
> > +
> > +rm -f $seqres.full
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +src/t_attr_corruption $SCRATCH_MNT
> > +
> > +status=0
> > +exit
> > diff --git a/tests/generic/712.out b/tests/generic/712.out
> > new file mode 100644
> > index 00000000..a2ba09f3
> > --- /dev/null
> > +++ b/tests/generic/712.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 712
> > +list attr: Numerical result out of range
> > diff --git a/tests/generic/group b/tests/generic/group
> > index f56eb475..b3086154 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -529,3 +529,4 @@
> >  524 auto quick
> >  525 auto quick rw
> >  709 auto quick
> > +712 auto quick attr
