Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o69GB8vR122173 for <xfs@oss.sgi.com>; Fri, 9 Jul 2010 11:11:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BD6415A454A
	for <xfs@oss.sgi.com>; Fri,  9 Jul 2010 09:14:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id A7iCEeDHYD6qzIrE for
	<xfs@oss.sgi.com>; Fri, 09 Jul 2010 09:14:01 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OXGDB-0007DE-Mh
	for xfs@oss.sgi.com; Fri, 09 Jul 2010 16:14:01 +0000
Date: Fri, 9 Jul 2010 12:14:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: test the aio unwrittent extent conversion race
Message-ID: <20100709161401.GE26302@infradead.org>
References: <20100626114334.GA15157@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100626114334.GA15157@infradead.org>
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
To: xfs@oss.sgi.com

ping?

On Sat, Jun 26, 2010 at 07:43:34AM -0400, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests-dev/239
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/239	2010-06-26 11:38:22.000000000 +0000
> @@ -0,0 +1,58 @@
> +#! /bin/bash
> +# FS QA Test No. 239
> +#
> +# Read from a sparse file immedialy after filling a hole to test for races
> +# in unwritten extent conversion.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 Red Hat, Inc.  All Rights Reserved.
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
> +# creator
> +owner=dchinner@redhat.com
> +
> +seq=`basename $0`
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
> +    rm -f $TEST_DIR/tst-aio-dio-sparse-unwritten
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +_supported_fs generic
> +_supported_os Linux
> +
> +AIO_TEST=src/aio-dio-regress/aio-dio-hole-filling-race
> +[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
> +
> +echo "Silence is golden"
> +
> +for i in `seq 1 500`; do
> +  $AIO_TEST $TEST_DIR/tst-aio-dio-hole-filling-race || break
> +done
> +
> +status=$?
> +exit
> Index: xfstests-dev/239.out
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/239.out	2010-06-26 11:38:47.000000000 +0000
> @@ -0,0 +1,2 @@
> +QA output created by 239
> +Silence is golden
> Index: xfstests-dev/group
> ===================================================================
> --- xfstests-dev.orig/group	2010-06-26 11:35:07.000000000 +0000
> +++ xfstests-dev/group	2010-06-26 11:35:18.000000000 +0000
> @@ -352,3 +352,4 @@ deprecated
>  236 auto quick metadata
>  237 auto quick acl
>  238 auto quick metadata ioctl
> +239 auto aio rw
> Index: xfstests-dev/src/aio-dio-regress/aio-dio-hole-filling-race.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/src/aio-dio-regress/aio-dio-hole-filling-race.c	2010-06-26 11:39:40.000000000 +0000
> @@ -0,0 +1,123 @@
> +/*
> + * Read from a sparse file immedialy after filling a hole to test for races
> + * in unwritten extent conversion.
> + *
> + * Copyright (C) 2010 Red Hat, Inc. All Rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + */
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +
> +#include <libaio.h>
> +
> +#define BUF_SIZE	4096
> +#define IO_PATTERN	0xab
> +
> +int main(int argc, char *argv[])
> +{
> +	struct io_context *ctx = NULL;
> +	struct io_event ev;
> +	struct iocb iocb, *iocbs[] = { &iocb };
> +	void *buf;
> +	char cmp_buf[BUF_SIZE];
> +	int fd, err = 0;
> +
> +	fd = open(argv[1], O_DIRECT | O_CREAT | O_TRUNC | O_RDWR, 0600);
> +	if (fd == -1) {
> +		perror("open");
> +		return 1;
> +	}
> +
> +	err = posix_memalign(&buf, BUF_SIZE, BUF_SIZE);
> +	if (err) {
> +		fprintf(stderr, "error %s during %s\n",
> +			strerror(-err),
> +			"posix_memalign");
> +		return 1;
> +	}
> +	memset(buf, IO_PATTERN, BUF_SIZE);
> +	memset(cmp_buf, IO_PATTERN, BUF_SIZE);
> +
> +	/*
> +	 * Truncate to some random large file size.  Just make sure
> +	 * it's not smaller than our I/O size.
> +	 */
> +	if (ftruncate(fd, 1024 * 1024 * 1024) < 0) {
> +		perror("ftruncate");
> +		return 1;
> +	}
> +
> +
> +	/*
> +	 * Do a simple 4k write into a hole using aio.
> +	 */
> +	err = io_setup(1, &ctx);
> +	if (err) {
> +		fprintf(stderr, "error %s during %s\n",
> +			strerror(-err),
> +			"io_setup");
> +		return 1;
> +	}
> +
> +	io_prep_pwrite(&iocb, fd, buf, BUF_SIZE, 0);
> +
> +	err = io_submit(ctx, 1, iocbs);
> +	if (err != 1) {
> +		fprintf(stderr, "error %s during %s\n",
> +			strerror(-err),
> +			"io_submit");
> +		return 1;
> +	}
> +
> +	err = io_getevents(ctx, 1, 1, &ev, NULL);
> +	if (err != 1) {
> +		fprintf(stderr, "error %s during %s\n",
> +			strerror(-err),
> +			"io_getevents");
> +		return 1;
> +	}
> +
> +	/*
> +	 * And then read it back.
> +	 *
> +	 * Using pread to keep it simple, but AIO has the same effect.
> +	 */
> +	if (pread(fd, buf, BUF_SIZE, 0) != BUF_SIZE) {
> +		perror("pread");
> +		return 1;
> +	}
> +
> +	/*
> +	 * And depending on the machine we'll just get zeroes back quite
> +	 * often here.  That's because the unwritten extent conversion
> +	 * hasn't finished.
> +	 */
> +	if (memcmp(buf, cmp_buf, BUF_SIZE)) {
> +		unsigned long long *ubuf = (unsigned long long *)buf;
> +		int i;
> +
> +		for (i = 0; i < BUF_SIZE / sizeof(unsigned long long); i++)
> +			printf("%d: 0x%llx\n", i, ubuf[i]);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
