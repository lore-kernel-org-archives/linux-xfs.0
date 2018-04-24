Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750842AbeDXQGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Apr 2018 12:06:34 -0400
Date: Tue, 24 Apr 2018 09:06:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] generic: test XATTR_REPLACE doesn't take the fs down
Message-ID: <20180424160630.GB26261@magnolia>
References: <20180418003236.GE5201@magnolia>
 <20180418042457.GF5201@magnolia>
 <20180424120859.GD11384@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424120859.GD11384@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: kanda.motohiro@gmail.com, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Tue, Apr 24, 2018 at 08:08:59PM +0800, Eryu Guan wrote:
> On Tue, Apr 17, 2018 at 09:24:57PM -0700, Darrick J. Wong wrote:
> > [cc xfs/fstests lists]
> > 
> > On Tue, Apr 17, 2018 at 05:32:36PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Kanda Motohiro reported that expanding a tiny xattr into a large xattr
> > > fails on XFS because we remove the tiny xattr from a shortform fork and
> > > then try to re-add it after converting the fork to extents format having
> > > not removed the ATTR_REPLACE flag.  This fails because the attr is no
> > > longer present, causing a fs shutdown.
> > > 
> > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199119
> > > Reported-by: kanda.motohiro@gmail.com
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Some minor issues below, but I think I can fix them all on commit.
> 
> > > ---
> > >  src/Makefile            |    3 +-
> > >  src/attr_replace_test.c |   47 +++++++++++++++++++++++++++++++++++
> 
> Need a .gitignore entry for it.

Ok.  Assuming you meant a .gitignore entry for src/attr_replace_test,
not the source file itself.

> > >  tests/generic/706       |   64 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/706.out   |    2 +
> > >  tests/generic/group     |    1 +
> > >  5 files changed, 116 insertions(+), 1 deletion(-)
> > >  create mode 100644 src/attr_replace_test.c
> > >  create mode 100755 tests/generic/706
> > >  create mode 100644 tests/generic/706.out
> > > 
> > > diff --git a/src/Makefile b/src/Makefile
> > > index 0d3feae..162e529 100644
> > > --- a/src/Makefile
> > > +++ b/src/Makefile
> > > @@ -25,7 +25,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> > >  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
> > >  	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
> > >  	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
> > > -	dio-invalidate-cache stat_test t_encrypted_d_revalidate
> > > +	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
> > > +	attr_replace_test
> > >  
> > >  SUBDIRS = log-writes perf
> > >  
> > > diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
> > > new file mode 100644
> > > index 0000000..583ca17
> > > --- /dev/null
> > > +++ b/src/attr_replace_test.c
> > > @@ -0,0 +1,47 @@
> > > +// setattr.c by kanda.motohiro@gmail.com
> > > +// xfs extended attribute corruption bug reproducer
> > > +#include <stdio.h>
> > > +#include <string.h>
> > > +#include <fcntl.h>
> > > +#include <errno.h>
> > > +#include <stdlib.h>
> > > +#include <unistd.h>
> > > +#include <sys/types.h>
> > > +#include <sys/xattr.h>
> > > +
> > > +#define die() do { perror(""); \
> > > +fprintf(stderr, "error=%d at line %d\n", errno, __LINE__); \
> > > +exit(1); } while (0)
> > > +
> > > +int main(int argc, char *argv[])
> > > +{
> > > +	int ret;
> > > +	int fd;
> > > +	char *path = "/mnt/xfs/hello";
> 
> I'd like not assign default path to "/mnt/xfs/hello", just in case we
> forget the testfile argument and test runs against /mnt/xfs/hello
> accidently and test passes silently.

Ok, please get rid of it then. :)

> > > +	char *name = "user.world";
> > > +	char value[2048];
> > > +	size_t size = sizeof(value);
> > > +
> > > +	if (argc == 2)
> > > +		path = argv[1];
> 
> I'll make sure argc == 2, and error out if not.

Ok.

> Thanks,
> Eryu
> 
> > > +
> > > +	fd = open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
> > > +	if (fd < 0) die();
> > > +
> > > +	// First, create a small xattr.
> > > +	memset(value, '0', 1);
> > > +	ret = fsetxattr(fd, name, value, 1, XATTR_CREATE);
> > > +	if (ret < 0) die();
> > > +	close(fd);
> > > +
> > > +	fd = open(path, O_RDWR);
> > > +	if (fd < 0) die();
> > > +
> > > +	// Then, replace it with bigger one, forcing short form to leaf conversion.
> > > +	memset(value, '1', sizeof(value));
> > > +	ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
> > > +	if (ret < 0) die();
> > > +	close(fd);
> > > +
> > > +	return 0;
> > > +}
> > > diff --git a/tests/generic/706 b/tests/generic/706
> > > new file mode 100755
> > > index 0000000..4d8f180
> > > --- /dev/null
> > > +++ b/tests/generic/706
> > > @@ -0,0 +1,64 @@
> > > +#! /bin/bash
> > > +# FS QA Test No. 706
> > > +#
> > > +# Ensure that we can XATTR_REPLACE a tiny attr into a large attr.
> > > +# Kanda Motohiro <kanda.motohiro@gmail.com> reports that XATTR_REPLACE'ing
> > > +# a single-byte attr with a 2048-byte attr causes a fs shutdown because we
> > > +# remove the shortform attr, convert the attr fork to long format, and then
> > > +# try to re-add the attr having not cleared ATTR_REPLACE.
> > > +#
> > > +#-----------------------------------------------------------------------
> > > +# Copyright (c) 2018 Oracle.  All Rights Reserved.
> > > +#
> > > +# This program is free software; you can redistribute it and/or
> > > +# modify it under the terms of the GNU General Public License as
> > > +# published by the Free Software Foundation.
> > > +#
> > > +# This program is distributed in the hope that it would be useful,
> > > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > +# GNU General Public License for more details.
> > > +#
> > > +# You should have received a copy of the GNU General Public License
> > > +# along with this program; if not, write the Free Software Foundation,
> > > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > > +#
> > > +#-----------------------------------------------------------------------
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $testfile
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +. ./common/attr
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_test_program "attr_replace_test"
> > > +_require_attrs
> > > +_require_scratch
> > > +
> > > +rm -f $seqres.full
> > > +_scratch_mkfs >>$seqres.full 2>&1
> > > +_scratch_mount >>$seqres.full 2>&1
> > > +
> > > +./src/attr_replace_test $SCRATCH_MNT/hello
> > > +$ATTR_PROG -l $SCRATCH_MNT/hello | _filter_scratch
> > > +
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/706.out b/tests/generic/706.out
> > > new file mode 100644
> > > index 0000000..1c654c1
> > > --- /dev/null
> > > +++ b/tests/generic/706.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 706
> > > +Attribute "world" has a 2048 byte value for SCRATCH_MNT/hello
> > > diff --git a/tests/generic/group b/tests/generic/group
> > > index 3f93dc4..fc05315 100644
> > > --- a/tests/generic/group
> > > +++ b/tests/generic/group
> > > @@ -487,3 +487,4 @@
> > >  482 auto metadata replay
> > >  483 auto quick log metadata
> > >  484 auto quick insert
> > > +706 auto quick attr
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
