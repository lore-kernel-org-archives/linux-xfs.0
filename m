Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdISHgU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 03:36:20 -0400
Date: Tue, 19 Sep 2017 15:36:16 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] test race when checking i_size on direct i/o read
Message-ID: <20170919073616.GP8034@eguan.usersys.redhat.com>
References: <799f63d9-de03-eab3-1e6e-cd747aa04c36@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <799f63d9-de03-eab3-1e6e-cd747aa04c36@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, Zheng Liu <wenqing.lz@taobao.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Aug 18, 2017 at 03:35:02PM -0500, Eric Sandeen wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In this commit a new test case is added to test that i_size races don't
> occur under dio reads/writes.  We add a program in /src dir, which
> has a writer to issue some append dio writes.  Meanwhile it has a reader
> in this test to do some dio reads.  As we expect, reader should read
> nothing or data with 'a'.  But it might read some data with '0'.
> 
> The bug can be reproduced by this test case [1].
> 
> 1.  http://patchwork.ozlabs.org/patch/311761/
> 
> This ostensibly tests commit:
> 9fe55eea7 Fix race when checking i_size on direct i/o read
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Rich Johnston <rjohnston@sgi.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> [sandeen: update to recent xfstests, update commitlog]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This test was originally titled:
> 
>  xfstests: add a new test case to test i_size updated properly under dio
> 
> but I think the issue is more of when and how it's tested, not how
> it's updated.
> 
> Note, this passes on xfs on 4.10, but fails on 4.12.
> ext4 on 4.10 passes as well but is very slow.
> 
> iomap dio maybe?  Not sure yet.

My test with 4.10 kernel suggested that test still failed there. And I
digged into this test a bit, and found that it was commit d531d91d6990
("xfs: always use unwritten extents for direct I/O writes") introduced
this failure, which is in v3.14 kernel.

This is because we start allocating unwritten extents for direct writes
that can extend i_size, but in xfs_dio_write_end_io() we update in-core
i_size before converting unwritten extents to real allocations. So a
racing direct read could find the not-yet converted unwritten extents
and read zeros instead of actual data.

But I'm not sure what's the best way to fix it. I think taking exclusive
iolock instead of shared lock for direct writes that can extend i_size
could fix the non-aio dio write case, but aio-dio write still fails,
because in the aio-dio write case we defer end_io to a workqueue, which
doesn't take any iolock at all..

ext4 has no such problem because ext4 converts unwritten extents before
updating i_size, and ext4 doesn't support appending aio dio writes.

(Keep the rest of patch untrimmed for reference, as I added linux-xfs to
cc list.)

Thanks,
Eryu

> 
> changelog v3:
>  * rebase against latest xfstests/master branch
>  * update commit log
> 
> changelog v2:
>  * add '-lpthread' into LLDLIBS
> 
> diff --git a/configure.ac b/configure.ac
> index 57092f1..4663004 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -59,6 +59,7 @@ AC_PACKAGE_NEED_GETXATTR_LIBATTR
>  AC_PACKAGE_NEED_SYS_ACL_H
>  AC_PACKAGE_NEED_ACL_LIBACL_H
>  AC_PACKAGE_NEED_ACLINIT_LIBACL
> +AC_PACKAGE_NEED_PTHREADMUTEXINIT
>  
>  AC_PACKAGE_WANT_GDBM
>  AC_PACKAGE_WANT_AIO
> diff --git a/include/builddefs.in b/include/builddefs.in
> index cb52b99..fcc8b90 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -25,6 +25,7 @@ LIBGDBM = @libgdbm@
>  LIBUUID = @libuuid@
>  LIBHANDLE = @libhdl@
>  LIBDM = @libdm@
> +LIBPTHREAD = @libpthread@
>  LIBTEST = $(TOPDIR)/lib/libtest.la
>  prefix = @prefix@
>  
> diff --git a/src/Makefile b/src/Makefile
> index b8aff49..e9419bd 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -23,7 +23,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
>  	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
>  	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
> -	dio-invalidate-cache stat_test t_encrypted_d_revalidate
> +	dio-invalidate-cache stat_test t_encrypted_d_revalidate diotest
>  
>  SUBDIRS =
>  
> diff --git a/src/diotest.c b/src/diotest.c
> new file mode 100644
> index 0000000..7d2378f
> --- /dev/null
> +++ b/src/diotest.c
> @@ -0,0 +1,166 @@
> +/*
> + * Copyright (c) 2013 Alibaba Group.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +/*
> + * This is a normal case that we do some append dio writes and meanwhile
> + * we do some dio reads.  Currently in vfs we don't ensure that i_size
> + * is updated properly.  Hence the reader will read some data with '0'.
> + * But we expect that the reader should read nothing or data with 'a'.
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +
> +#include <pthread.h>
> +
> +static char *prog;
> +
> +struct writer_data {
> +	int fd;
> +	size_t blksize;
> +	char *buf;
> +};
> +
> +static void usage(void)
> +{
> +	fprintf(stderr, "usage: %s [FILE]\n", prog);
> +}
> +
> +static void *writer(void *arg)
> +{
> +	struct writer_data *data = (struct writer_data *)arg;
> +	int ret;
> +
> +	ret = write(data->fd, data->buf, data->blksize);
> +	if (ret < 0)
> +		fprintf(stderr, "write file failed: %s\n", strerror(errno));
> +
> +	return NULL;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	pthread_t tid;
> +	struct writer_data wdata;
> +	size_t max_blocks = 128;		/* 128 */
> +	size_t blksize = 1 * 1024 * 1024;	/* 1M */
> +	char *rbuf = NULL, *wbuf = NULL;
> +	int rfd = 0, wfd = 0;
> +	int i, j;
> +	int ret = 0;
> +
> +	prog = basename(argv[0]);
> +
> +	if (argc != 2) {
> +		usage();
> +		exit(1);
> +	}
> +
> +	wfd = open(argv[1], O_CREAT|O_DIRECT|O_WRONLY|O_APPEND|O_TRUNC, S_IRWXU);
> +	if (wfd < 0) {
> +		fprintf(stderr, "failed to open write file: %s\n",
> +			strerror(errno));
> +		exit(1);
> +	}
> +
> +	rfd = open(argv[1], O_DIRECT|O_RDONLY, S_IRWXU);
> +	if (wfd < 0) {
> +		fprintf(stderr, "failed to open read file: %s\n",
> +			strerror(errno));
> +		ret = 1;
> +		goto err;
> +	}
> +
> +	/*
> +	 * We set 1024 as an alignment size for write buf.  Feel free to change
> +	 * it with 4096.  But the problem is also hitted.
> +	 */
> +	if (posix_memalign((void **)&wbuf, 1024, blksize)) {
> +		fprintf(stderr, "failed to alloc memory: %s\n", strerror(errno));
> +		ret = 1;
> +		goto err;
> +	}
> +
> +	if (posix_memalign((void **)&rbuf, 4096, blksize)) {
> +		fprintf(stderr, "failed to alloc memory: %s\n", strerror(errno));
> +		ret = 1;
> +		goto err;
> +	}
> +
> +	memset(wbuf, 'a', blksize);
> +	wdata.fd = wfd;
> +	wdata.blksize = blksize;
> +	wdata.buf = wbuf;
> +
> +	for (i = 0; i < max_blocks; i++) {
> +		void *retval;
> +
> +		if (pthread_create(&tid, NULL, writer, &wdata)) {
> +			fprintf(stderr, "create thread failed: %s\n",
> +				strerror(errno));
> +			ret = 1;
> +			goto err;
> +		}
> +
> +		memset(rbuf, 'b', blksize);
> +		do {
> +			ret = pread(rfd, rbuf, blksize, i * blksize);
> +			if (ret < 0)
> +				fprintf(stderr, "read file failed: %s\n",
> +					strerror(errno));
> +		} while (ret <= 0);
> +
> +		if (pthread_join(tid, &retval)) {
> +			fprintf(stderr, " pthread join failed: %s\n",
> +				strerror(errno));
> +			ret = 1;
> +			goto err;
> +		}
> +
> +		if (ret >= 0) {
> +			for (j = 0; j < ret; j ++) {
> +				if (rbuf[j] != 'a') {
> +					fprintf(stderr, "encounter an error: "
> +						"offset %d content %c\n",
> +						i, rbuf[j]);
> +					ret = 1;
> +					goto err;
> +				}
> +			}
> +		}
> +	}
> +
> +err:
> +	if (rfd)
> +		close(rfd);
> +	if (wfd)
> +		close(wfd);
> +	if (rbuf)
> +		free(rbuf);
> +	if (wbuf)
> +		free(wbuf);
> +
> +	return ret;
> +}
> diff --git a/tests/generic/450 b/tests/generic/450
> new file mode 100755
> index 0000000..cfb424c
> --- /dev/null
> +++ b/tests/generic/450
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# FS QA Test No. 450
> +#
> +# Test i_size is updated properly under dio read/write
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Alibaba Group.  All Rights Reserved.
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
> +    cd /
> +    rm -f $tmp.* $testfile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +
> +testfile=$TEST_DIR/$seq.$$
> +
> +[ -x $here/src/diotest ] || _notrun "diotest not built"
> +
> +$here/src/diotest $testfile # > $seqres.full 2>&1 ||
> +	# _fail "i_size isn't update properly!"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/450.out b/tests/generic/450.out
> new file mode 100644
> index 0000000..734761a
> --- /dev/null
> +++ b/tests/generic/450.out
> @@ -0,0 +1 @@
> +QA output created by 450
> diff --git a/tests/generic/group b/tests/generic/group
> index b9cd0e8..a555fa0 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -452,3 +452,4 @@
>  447 auto quick clone
>  448 auto quick rw
>  449 auto quick acl enospc
> +450 auto rw quick
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
