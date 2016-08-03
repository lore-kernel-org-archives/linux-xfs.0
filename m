Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 560917CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 17:43:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24D30304048
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 15:43:18 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id wLBeDW0bjHAI4qEq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 15:43:15 -0700 (PDT)
Date: Wed, 3 Aug 2016 15:42:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: test attr_list_by_handle cursor iteration
Message-ID: <20160803224242.GU8590@birch.djwong.org>
References: <20160802235251.GB8586@birch.djwong.org>
	<20160803044722.GD27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803044722.GD27776@eguan.usersys.redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 12:47:22PM +0800, Eryu Guan wrote:
> On Tue, Aug 02, 2016 at 04:52:51PM -0700, Darrick J. Wong wrote:
> > Apparently the XFS attr_list_by_handle ioctl has never actually copied
> > the cursor contents back to user space, which means that iteration has
> > never worked.  Add a test case for this and see the patch
> > "xfs: in _attrlist_by_handle, copy the cursor back to userspace".
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  src/Makefile                          |    3 -
> >  src/attr-list-by-handle-cursor-test.c |  186 +++++++++++++++++++++++++++++++++
> 
> New test program needs an entry in .gitignore

Ok.

> >  tests/xfs/700                         |   64 +++++++++++
> >  tests/xfs/700.out                     |    5 +
> >  tests/xfs/group                       |    1 
> >  5 files changed, 258 insertions(+), 1 deletion(-)
> >  create mode 100644 src/attr-list-by-handle-cursor-test.c
> >  create mode 100755 tests/xfs/700
> >  create mode 100644 tests/xfs/700.out
> > 
> > diff --git a/src/Makefile b/src/Makefile
> > index 1bf318b..ae06d50 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -20,7 +20,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
> >  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
> >  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
> > -	renameat2 t_getcwd e4compact test-nextquota punch-alternating
> > +	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
> > +	attr-list-by-handle-cursor-test
> >  
> >  SUBDIRS =
> >  
> > diff --git a/src/attr-list-by-handle-cursor-test.c b/src/attr-list-by-handle-cursor-test.c
> > new file mode 100644
> > index 0000000..5aef79c
> > --- /dev/null
> > +++ b/src/attr-list-by-handle-cursor-test.c
> > @@ -0,0 +1,186 @@
> > +/*
> > + * Copyright (C) 2016 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <attr/attributes.h>
> > +#include <unistd.h>
> > +#include <fcntl.h>
> > +#include <string.h>
> > +#include <stdio.h>
> > +#include <asm/types.h>
> > +#include <xfs/xfs.h>
> > +#include <xfs/handle.h>
> > +
> > +#define ATTRBUFSZ		1024
> > +#define BSTATBUF_SZ		1024
> > +
> > +/* Read all the extended attributes of a file handle. */
> > +void
> > +read_handle_xattrs(
> > +	struct xfs_handle	*handle,
> > +	bool			root_space)
> 
> On RHEL6, stdbool.h is needed for bool. Or simply change it to int?

Yes, that's sufficient.

>     [CC]    attr-list-by-handle-cursor-test
> attr-list-by-handle-cursor-test.c:38: error: expected declaration specifiers or '...' before 'bool'
> attr-list-by-handle-cursor-test.c: In function 'read_handle_xattrs':
> attr-list-by-handle-cursor-test.c:49: error: 'root_space' undeclared (first use in this function)
> attr-list-by-handle-cursor-test.c:49: error: (Each undeclared identifier is reported only once
> attr-list-by-handle-cursor-test.c:49: error: for each function it appears in.)
> attr-list-by-handle-cursor-test.c: In function 'find_inode':
> attr-list-by-handle-cursor-test.c:135: error: 'false' undeclared (first use in this function)
> attr-list-by-handle-cursor-test.c:135: error: too many arguments to function 'read_handle_xattrs'
> attr-list-by-handle-cursor-test.c:136: error: 'true' undeclared (first use in this function)
> attr-list-by-handle-cursor-test.c:136: error: too many arguments to function 'read_handle_xattrs'
> gmake[2]: *** [attr-list-by-handle-cursor-test] Error 1
> gmake[1]: *** [src] Error 2
> make: *** [default] Error 2
> 
> > +{
> > +	struct attrlist_cursor	cur;
> > +	char			attrbuf[ATTRBUFSZ];
> > +	char			*firstname = NULL;
> > +	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
> > +	struct attrlist_ent	*ent;
> > +	int			i;
> > +	int			flags = 0;
> > +	int			error;
> > +
> > +	if (root_space)
> > +		flags |= ATTR_ROOT;
> > +
> > +	memset(&cur, 0, sizeof(cur));
> > +	while ((error = attr_list_by_handle(handle, sizeof(*handle),
> > +					    attrbuf, ATTRBUFSZ, flags,
> > +					    &cur)) == 0) {
> > +		for (i = 0; i < attrlist->al_count; i++) {
> 
> I applied the patch "xfs: in _attrlist_by_handle, copy the cursor back
> to userspace" on top of 4.7-rc7 kernel and did some tests, in some cases
> test failed because nothing was printed by the test program, e.g.
> 
> # diff -u tests/xfs/700.out /root/workspace/xfstests/results//xfs_4k_crc/xfs/700.out.bad
> --- tests/xfs/700.out   2016-08-03 11:32:02.502000000 +0800
> +++ /root/workspace/xfstests/results//xfs_4k_crc/xfs/700.out.bad        2016-08-03 11:34:57.018000000 +0800
> @@ -2,4 +2,3 @@
>  Format and mount
>  Stuff file with xattrs
>  Run test program
> -Test passes.
> 
> Debug code shows that this is because attrlist->al_count is 0 in such
> cases, so it doesn't go into the for loop.
> 
> Failed test configs are:
> 
> 2k block size XFS with CRC enabled
> 1k block size XFS with CRC enabled
> 512 block size XFS

Hmmm.... apparently I was feeding the wrong inputs to BULKSTAT.  Most
of the time it would (eventually) return the $SCRATCH_MNT/foo inode,
but occasionally it wouldn't, which caused the test not to pass.

I've changed the program to use BULKSTAT_SINGLE since we only care
about the one inode and it seems to work now.  This also makes the
program a lot less convoluted.

> > +			ent = ATTR_ENTRY(attrlist, i);
> > +
> > +			if (i != 0)
> > +				continue;
> > +
> > +			if (firstname == NULL) {
> > +				firstname = malloc(ent->a_valuelen);
> > +				memcpy(firstname, ent->a_name, ent->a_valuelen);
> > +			} else {
> > +				if (memcmp(firstname, ent->a_name,
> > +					   ent->a_valuelen) == 0)
> > +					fprintf(stderr,
> > +						"Saw duplicate xattr \"%s\", buggy XFS?\n",
> > +						ent->a_name);
> > +				else
> > +					fprintf(stderr,
> > +						"Test passes.\n");
> > +				goto out;
> > +			}
> > +		}
> > +
> > +		if (!attrlist->al_more)
> > +			break;
> > +	}
> > +
> > +out:
> > +	if (firstname)
> > +		free(firstname);
> > +	if (error)
> > +		perror("attr_list_by_handle");
> > +	return;
> > +}
> > +
> > +/* Iterate a range of inodes. */
> > +void
> > +find_inode(
> > +	struct xfs_handle	*fshandle,
> > +	int			fd,
> > +	ino_t			ino)
> > +{
> > +	struct xfs_fsop_bulkreq	bulkreq;
> > +	struct xfs_bstat	*bstatbuf;
> > +	struct xfs_bstat	*p;
> > +	struct xfs_bstat	*endp;
> > +	struct xfs_handle	handle;
> > +	__u64			first_ino = ino & ~63;
> > +	__s32			buflenout = 0;
> > +	int			error;
> > +
> > +	bstatbuf = malloc(BSTATBUF_SZ * sizeof(struct xfs_bstat));
> > +	if (!bstatbuf) {
> > +		perror("bulkstat malloc");
> > +		return;
> > +	}
> > +
> > +	bulkreq.lastip = (__u64 *)&first_ino;
> > +	bulkreq.icount  = BSTATBUF_SZ;
> > +	bulkreq.ubuffer = (void *)bstatbuf;
> > +	bulkreq.ocount  = &buflenout;
> > +
> > +	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
> > +	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
> > +			sizeof(handle.ha_fid.fid_len);
> > +	handle.ha_fid.fid_pad = 0;
> > +	while ((error = xfsctl("", fd, XFS_IOC_FSBULKSTAT, &bulkreq)) == 0) {
> > +		if (buflenout == 0)
> > +			break;
> > +		for (p = bstatbuf, endp = bstatbuf + buflenout; p < endp; p++) {
> > +			if (p->bs_ino > ino) {
> > +				fprintf(stderr,
> > +					"Expected ino %llu, got %llu.\n",
> > +					(unsigned long long)ino, p->bs_ino);
> > +				goto out;
> > +			}
> > +
> > +			handle.ha_fid.fid_gen = p->bs_gen;
> > +			handle.ha_fid.fid_ino = p->bs_ino;
> > +
> > +			read_handle_xattrs(&handle, false);
> > +			read_handle_xattrs(&handle, true);
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	if (error)
> > +		perror("bulkstat");
> > +out:
> > +	free(bstatbuf);
> > +	return;
> > +}
> > +
> > +int main(
> > +	int			argc,
> > +	char			*argv[])
> > +{
> > +	struct xfs_handle	*fshandle;
> > +	size_t			fshandle_len;
> > +	struct stat		sb;
> > +	int			fd;
> > +	int			error;
> > +
> > +	if (argc != 2) {
> > +		fprintf(stderr, "Usage: %s filename\n", argv[0]);
> > +		return 1;
> > +	}
> > +
> > +	error = path_to_fshandle(argv[1], (void **)&fshandle, &fshandle_len);
> > +	if (error) {
> > +		perror("getting fshandle");
> > +		return 2;
> > +	}
> > +
> > +	fd = open(argv[1], O_RDONLY);
> > +	if (fd < 0) {
> > +		perror("opening file");
> > +		return 2;
> > +	}
> > +
> > +	error = fstat(fd, &sb);
> > +	if (error) {
> > +		perror("fstat file");
> > +		return 2;
> > +	}
> > +
> > +	find_inode(fshandle, fd, sb.st_ino);
> > +
> > +	close(fd);
> > +	free_handle(fshandle, fshandle_len);
> > +	return 0;
> > +}
> > diff --git a/tests/xfs/700 b/tests/xfs/700
> > new file mode 100755
> > index 0000000..4a5680d
> > --- /dev/null
> > +++ b/tests/xfs/700
> > @@ -0,0 +1,64 @@
> > +#! /bin/bash
> > +# FS QA Test No. 700
> > +#
> > +# Check that attr_list_by_handle copies the cursor back to userspace.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
> > +seq=`basename "$0"`
> > +seqres="$RESULT_DIR/$seq"
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/testout
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/attr
> > +. ./common/populate
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_require_scratch
> > +_require_test_program "attr-list-by-handle-cursor-test"
> > +
> > +rm -f "$seqres.full"
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +
> > +echo "Stuff file with xattrs"
> > +mkdir $SCRATCH_MNT/foo
> > +__populate_create_attr $SCRATCH_MNT/foo 100
> > +
> > +echo "Run test program"
> > +./src/attr-list-by-handle-cursor-test $SCRATCH_MNT/foo
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/700.out b/tests/xfs/700.out
> > new file mode 100644
> > index 0000000..493a68a
> > --- /dev/null
> > +++ b/tests/xfs/700.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 700
> > +Format and mount
> > +Stuff file with xattrs
> > +Run test program
> > +Test passes.
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index ff0efa5..ae12e74 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -307,3 +307,4 @@
> >  325 auto quick clone
> >  326 auto quick clone
> >  327 auto quick clone
> > +700 auto quick
> 
> Also add ioctl group?

Ok.  Thank you for the review!

--D

> 
> Thanks,
> Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
