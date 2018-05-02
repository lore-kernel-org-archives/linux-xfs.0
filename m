Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52326 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbeEBOvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 10:51:01 -0400
Date: Wed, 2 May 2018 07:50:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/9] generic: test XATTR_REPLACE doesn't take the fs down
Message-ID: <20180502145056.GQ4127@magnolia>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
 <152518916637.23023.9591675479884571356.stgit@magnolia>
 <20180502073325.GB29084@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502073325.GB29084@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, kanda.motohiro@gmail.com

On Wed, May 02, 2018 at 03:33:25PM +0800, Eryu Guan wrote:
> On Tue, May 01, 2018 at 08:39:26AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Kanda Motohiro reported that expanding a tiny xattr into a large xattr
> > fails on XFS because we remove the tiny xattr from a shortform fork and
> > then try to re-add it after converting the fork to extents format having
> > not removed the ATTR_REPLACE flag.  This fails because the attr is no
> > longer present, causing a fs shutdown.
> > 
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199119
> > Reported-by: kanda.motohiro@gmail.com
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks for the revision! Because I found more issues in v1 than I
> expected, so I drop the patch from last fstests update. I should have
> made that clear..

No worries, I was at LSF last week and probably should've sent a "there
are enough bugs in this thing that I'll resend later" message.

> > ---
> >  .gitignore              |    1 +
> >  src/Makefile            |    3 +-
> >  src/attr_replace_test.c |   60 +++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/706       |   68 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/706.out   |    2 +
> >  tests/generic/group     |    1 +
> >  6 files changed, 134 insertions(+), 1 deletion(-)
> >  create mode 100644 src/attr_replace_test.c
> >  create mode 100755 tests/generic/706
> >  create mode 100644 tests/generic/706.out
> > 
> > 
> > diff --git a/.gitignore b/.gitignore
> > index 192ca35e..af9743f9 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -53,6 +53,7 @@
> >  /src/append_reader
> >  /src/append_writer
> >  /src/attr-list-by-handle-cursor-test
> > +/src/attr_replace_test
> 
> Seems this should be put before attr-list-by-handle-cursor-test,
> according to the result of sort.

Oops, yeah.  Do you mind fixing this on the way in?

> >  /src/bstat
> >  /src/bulkstat_unlink_test
> >  /src/bulkstat_unlink_test_modified
> > diff --git a/src/Makefile b/src/Makefile
> > index 6ca56366..c42d3bb1 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -25,7 +25,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
> >  	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
> >  	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
> > -	dio-invalidate-cache stat_test t_encrypted_d_revalidate
> > +	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
> > +	attr_replace_test
> >  
> >  SUBDIRS = log-writes perf
> >  
> > diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
> > new file mode 100644
> > index 00000000..c870d165
> > --- /dev/null
> > +++ b/src/attr_replace_test.c
> > @@ -0,0 +1,60 @@
> > +// setattr.c by kanda.motohiro@gmail.com
> > +// xfs extended attribute corruption bug reproducer
> > +#include <stdio.h>
> > +#include <string.h>
> > +#include <fcntl.h>
> > +#include <errno.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include <sys/types.h>
> > +#include <sys/xattr.h>
> > +#include <sys/stat.h>
> > +
> > +#define die() do { perror(""); \
> > +fprintf(stderr, "error=%d at line %d\n", errno, __LINE__); \
> > +exit(1); } while (0)
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	int ret;
> > +	int fd;
> > +	char *path;
> > +	char *name = "user.world";
> > +	char *value;
> > +	struct stat sbuf;
> > +	size_t size = sizeof(value);
> > +
> > +	if (argc != 2) die();
> 
> die() doesn't seem like the right thing to do (and some other places),
> it'll print something like:
> 
> Success
> error=0 at line NN
> 
> I'd define a new "fail()" macro and use it where appropriate.
> 
> +#define fail(...) do { \
> +fprintf(stderr, __VA_ARGS__); exit (1); \
> +} while (0)
> 
> I can fix the minor issues on commit, for real this time :)

Ok.

> Thanks,
> Eryu
> 
> > +	path = argv[1];
> > +
> > +	fd = open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
> > +	if (fd < 0) die();
> > +
> > +	/*
> > +	 * The value should be 3/4 the size of a fs block to ensure that we
> > +	 * get to extents format.
> > +	 */
> > +	ret = fstat(fd, &sbuf);
> > +	if (ret < 0) die();
> > +	size = sbuf.st_blksize * 3 / 4;
> > +	if (!size) die();

fail() here too, if you're fixing this up.

--D

> > +	value = malloc(size);
> > +	if (!value) die();
> > +
> > +	// First, create a small xattr.
> > +	memset(value, '0', 1);
> > +	ret = fsetxattr(fd, name, value, 1, XATTR_CREATE);
> > +	if (ret < 0) die();
> > +	close(fd);
> > +
> > +	fd = open(path, O_RDWR);
> > +	if (fd < 0) die();
> > +
> > +	// Then, replace it with bigger one, forcing short form to leaf conversion.
> > +	memset(value, '1', size);
> > +	ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
> > +	if (ret < 0) die();
> > +	close(fd);
> > +
> > +	return 0;
> > +}
> > diff --git a/tests/generic/706 b/tests/generic/706
> > new file mode 100755
> > index 00000000..9f98c3b1
> > --- /dev/null
> > +++ b/tests/generic/706
> > @@ -0,0 +1,68 @@
> > +#! /bin/bash
> > +# FS QA Test No. 706
> > +#
> > +# Ensure that we can XATTR_REPLACE a tiny attr into a large attr.
> > +# Kanda Motohiro <kanda.motohiro@gmail.com> reports that XATTR_REPLACE'ing
> > +# a single-byte attr with a 2048-byte attr causes a fs shutdown because we
> > +# remove the shortform attr, convert the attr fork to long format, and then
> > +# try to re-add the attr having not cleared ATTR_REPLACE.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2018 Oracle.  All Rights Reserved.
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
> > +#
> > +#-----------------------------------------------------------------------
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $testfile
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/attr
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_test_program "attr_replace_test"
> > +_require_attrs
> > +_require_scratch
> > +
> > +rm -f $seqres.full
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_scratch_mount >>$seqres.full 2>&1
> > +
> > +filter_attr_output() {
> > +	_filter_scratch | sed -e 's/has a [0-9]* byte value/has a NNNN byte value/g'
> > +}
> > +
> > +./src/attr_replace_test $SCRATCH_MNT/hello
> > +$ATTR_PROG -l $SCRATCH_MNT/hello | filter_attr_output
> > +
> > +status=0
> > +exit
> > diff --git a/tests/generic/706.out b/tests/generic/706.out
> > new file mode 100644
> > index 00000000..61c8419a
> > --- /dev/null
> > +++ b/tests/generic/706.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 706
> > +Attribute "world" has a NNNN byte value for SCRATCH_MNT/hello
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 19be9267..54a85ea0 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -487,3 +487,4 @@
> >  482 auto metadata replay
> >  483 auto quick log metadata
> >  484 auto quick
> > +706 auto quick attr
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
