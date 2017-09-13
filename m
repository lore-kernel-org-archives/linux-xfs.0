Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750999AbdIMHG5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Sep 2017 03:06:57 -0400
Date: Wed, 13 Sep 2017 15:06:54 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/3] ext4: test for DAX + journaling corruption
Message-ID: <20170913070654.GA8034@eguan.usersys.redhat.com>
References: <20170912044521.22644-1-ross.zwisler@linux.intel.com>
 <20170912044521.22644-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170912044521.22644-2-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>

On Mon, Sep 11, 2017 at 10:45:20PM -0600, Ross Zwisler wrote:
> Add a regression test for the following kernel commit:
> 
>   ext4: prevent data corruption with journaling + DAX
> 
> The test passes if either we successfully compare the data between the mmap
> with journaling turned on and the one with journaling turned off, or if we
> fail the chattr command to turn on or off journaling.  The latter is how we
> prevent this issue in the kernel.

Yeah, I noticed that mounting ext4 with "-o dax,data=journal" is not
allowed, enabling data journaling on a dax mount should be stopped too.

> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  .gitignore                          |  1 +
>  src/Makefile                        |  2 +-
>  src/t_ext4_dax_journal_corruption.c | 93 +++++++++++++++++++++++++++++++++++++
>  tests/ext4/030                      | 68 +++++++++++++++++++++++++++
>  tests/ext4/030.out                  |  2 +
>  tests/ext4/group                    |  1 +
>  6 files changed, 166 insertions(+), 1 deletion(-)
>  create mode 100644 src/t_ext4_dax_journal_corruption.c
>  create mode 100755 tests/ext4/030
>  create mode 100644 tests/ext4/030.out
> 
> diff --git a/.gitignore b/.gitignore
> index 2accc37..4bdc5bf 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -154,6 +154,7 @@
>  /src/t_mmap_stale_pmd
>  /src/t_mmap_cow_race
>  /src/t_mmap_fallocate
> +/src/t_ext4_dax_journal_corruption

Better to add new entry in alphabetical order, I know there're already
some out-of-order entries there, but this one is not affected and better
to stop adding new ones :)

>  
>  # dmapi/ binaries
>  /dmapi/src/common/cmd/read_invis
> diff --git a/src/Makefile b/src/Makefile
> index b8aff49..e6558e2 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -13,7 +13,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
>  	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
>  	holetest t_truncate_self t_mmap_dio af_unix t_mmap_stale_pmd \
> -	t_mmap_cow_race t_mmap_fallocate fsync-err
> +	t_mmap_cow_race t_mmap_fallocate fsync-err t_ext4_dax_journal_corruption
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> diff --git a/src/t_ext4_dax_journal_corruption.c b/src/t_ext4_dax_journal_corruption.c
> new file mode 100644
> index 0000000..e0d63f8
> --- /dev/null
> +++ b/src/t_ext4_dax_journal_corruption.c
> @@ -0,0 +1,93 @@
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <time.h>
> +#include <unistd.h>
> +
> +#define PAGE(a) ((a)*0x1000)
> +#define STRLEN 256
> +
> +void err_exit(char *op)
> +{
> +	fprintf(stderr, "%s: %s\n", op, strerror(errno));
> +	exit(1);
> +}
> +
> +void chattr_cmd(char *chattr, char *cmd, char *file)
> +{
> +	int ret;
> +	char command[STRLEN];
> +
> +	ret = snprintf(command, STRLEN, "%s %s %s 2>/dev/null", chattr, cmd, file);
> +	if (ret < 0)
> +		err_exit("snprintf");
> +
> +	ret = system(command);
> +	if (ret) /* Success - the kernel fix is to have this chattr fail */
> +		exit(77);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int fd, err, len = PAGE(1);
> +	char *data, *dax_data, *chattr, *file;
> +	char string[STRLEN];
> +
> +	if (argc < 3) {
> +		printf("Usage: %s <chattr program> <file>\n", basename(argv[0]));
> +		exit(0);
> +	}
> +
> +	chattr = argv[1];
> +	file = argv[2];
> +
> +	srand(time(NULL));
> +	snprintf(string, STRLEN, "random number %d\n", rand());
> +
> +	fd = open(file, O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
> +	if (fd < 0)
> +		err_exit("fd");
> +
> +	/* begin with journaling off and DAX on */
> +	chattr_cmd(chattr, "-j", file);
> +
> +	ftruncate(fd, 0);
> +	fallocate(fd, 0, 0, len);
> +
> +	dax_data = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
> +	if (!dax_data)
> +		err_exit("mmap dax_data");
> +
> +	/* turns on journaling, and turns off DAX */
> +	chattr_cmd(chattr, "+j", file);

I'm a bit confused here, just from the test code, it's not obvious to me
how DAX is turned off. I looked at the kernel code and there's a comment
saying: "Update inode->i_flags after EXT4_INODE_JOURNAL_DATA was
updated. E.g. S_DAX may get cleared / set." But isn't the per-inode dax
flag proposal rejected?

Anyway, some comments to explain how is DAX being turned off would be
good here.

> +
> +	data = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> +	if (!data)
> +		err_exit("mmap data");
> +
> +	/*
> +	 * Write the data using the non-DAX mapping, and try and read it back
> +	 * using the DAX mapping.
> +	 */
> +	strcpy(data, string);
> +	if (strcmp(dax_data, string) != 0)
> +		printf("Data miscompare\n");
> +
> +	err = munmap(data, len);
> +	if (err < 0)
> +		err_exit("munmap data");
> +
> +	err = munmap(dax_data, len);
> +	if (err < 0)
> +		err_exit("munmap dax_data");
> +
> +	err = close(fd);
> +	if (err < 0)
> +		err_exit("close");
> +	return 0;
> +}
> diff --git a/tests/ext4/030 b/tests/ext4/030
> new file mode 100755
> index 0000000..3ac4952
> --- /dev/null
> +++ b/tests/ext4/030
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# FS QA Test ext4/030
> +#
> +# This is a regression test for kernel patch:
> +#   ext4: prevent data corruption with journaling + DAX
> +# created by Ross Zwisler <ross.zwisler@linux.intel.com>
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Intel Corporation.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# Modify as appropriate.
> +_supported_os Linux
> +_supported_fs ext4
> +_require_scratch_dax
> +_require_test_program "t_ext4_dax_journal_corruption"

_require_command "$CHATTR_PROG" chattr

> +
> +# real QA test starts here
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount "-o dax,nodelalloc" >> $seqres.full 2>&1

Hmm, why do we need nodelalloc, need some comments too.

> +
> +src/t_ext4_dax_journal_corruption $CHATTR_PROG $SCRATCH_MNT/testfile

Let's use "$here/src/t_...", Christoph pointed this out in another
thread so I pay attention to it in review now :)

Thanks,
Eryu

> +
> +if [[ $? != 0 && $? != 77 ]]; then
> +	echo "Test failed, status $?"
> +	exit 1
> +fi
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/ext4/030.out b/tests/ext4/030.out
> new file mode 100644
> index 0000000..06a1c8f
> --- /dev/null
> +++ b/tests/ext4/030.out
> @@ -0,0 +1,2 @@
> +QA output created by 030
> +Silence is golden
> diff --git a/tests/ext4/group b/tests/ext4/group
> index 257bb64..ef768df 100644
> --- a/tests/ext4/group
> +++ b/tests/ext4/group
> @@ -32,6 +32,7 @@
>  027 auto quick fsmap
>  028 auto quick fsmap
>  029 auto quick fsmap
> +030 auto quick
>  271 auto rw quick
>  301 aio auto ioctl rw stress defrag
>  302 aio auto ioctl rw stress defrag
> -- 
> 2.9.5
> 
