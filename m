Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753948AbdJIHSf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 03:18:35 -0400
Date: Mon, 9 Oct 2017 15:18:33 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: add a new test for racing AIO COW writes V2
Message-ID: <20171009071833.GE10593@eguan.usersys.redhat.com>
References: <20171003143802.GA3964@lst.de>
 <20171004061616.GA20222@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004061616.GA20222@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 08:16:16AM +0200, Christoph Hellwig wrote:
> This can be used to trigger an assert in the current XFS code because it
> can't handle the case where there are COW extents on a file, but none
> at or below the range converted by the AIO completion handler.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I fixed several minor issues on commit (see inline comments).

I haven't reproduced the assert failure yet on my test vm, but as the
commit log in v1 patch, it's not 100% reproducible, maybe I'm just lucky
(or not lucky :)

> 
> diff --git a/src/aio-dio-regress/aio-dio-cow-race.c b/src/aio-dio-regress/aio-dio-cow-race.c
> new file mode 100755
> index 0000000..c7f8e89
> --- /dev/null
> +++ b/src/aio-dio-regress/aio-dio-cow-race.c

Added new gitignore entry for this new binary file.

> @@ -0,0 +1,119 @@
> +/*
> + * Copyright (c) Christoph Hellwig.  All Rights Reserved.
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
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <errno.h>
> +#include <libgen.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <ctype.h>
> +#include <sys/ioctl.h>
> +#include <linux/fs.h>
> +
> +#include <libaio.h>
> +
> +#ifndef FICLONE
> +#define FICLONE		_IOW(0x94, 9, int)
> +#endif
> +
> +#define IO_PATTERN	0xab
> +
> +int main(int argc, char *argv[])
> +{
> +	struct io_context *ctx = NULL;
> +	struct io_event evs[4];
> +	struct iocb iocb1, iocb2, iocb3, iocb4;
> +	struct iocb *iocbs[] = { &iocb1, &iocb2, &iocb3, &iocb4 };
> +	void *buf;
> +	int fd, clone, err = 0;
> +	unsigned long buf_size = getpagesize() * 2;
> +	char *filename, *clonename;
> +
> +	if (argc != 3) {
> +		fprintf(stderr, "usage: %s filename clonename\n", argv[0]);
> +		exit(1);
> +	}
> +
> +	err = posix_memalign(&buf, getpagesize(), buf_size);
> +	if (err) {
> +		fprintf(stderr, "error %s during %s\n",
> +			strerror(err), "posix_memalign");
> +		return 1;
> +	}
> +	memset(buf, IO_PATTERN, buf_size);
> +
> +	filename = argv[1];
> +	fd = open(filename, O_DIRECT | O_CREAT | O_TRUNC | O_RDWR, 0600);
> +	if (fd == -1) {
> +		perror("open");
> +		return 1;
> +	}
> +
> +	if (write(fd, buf, buf_size) != buf_size) {
> +		perror("write");
> +		return 1;
> +	}
> +
> +	clonename = argv[2];
> +	clone = open(clonename, O_DIRECT | O_CREAT | O_TRUNC | O_RDWR, 0600);
> +	if (clone == -1) {
> +		perror("open clone");
> +		return 1;
> +	}
> +
> +	if (ioctl(clone, FICLONE, fd)) {
> +		perror("FICLONE");
> +		return 1;
> +	}
> +
> +	err = io_setup(4, &ctx);
> +	if (err) {
> +		fprintf(stderr, "error %s during %s\n",
> +			strerror(err),
> +			"io_setup");

This error message format looks weired, I changed it to

		fprintf(stderr, "io_setup error %s\n", strerror(err));

Did the same to io_submit and io_getevents.

> +		return 1;
> +	}
> +
> +	/*
> +	 * Test overlapping aio writes, where an earlier one clears the whole
> +	 * range of a later aio, thus leaving nothing to do for the I/O
> +	 * completion to do.  To make things harder also make sure there is
> +	 * other outstanding COW I/O.
> +	 */
> +	io_prep_pwrite(&iocb1, fd, buf, buf_size, 0);
> +	io_prep_pwrite(&iocb2, fd, buf, buf_size / 2, 0);
> +	io_prep_pwrite(&iocb3, fd, buf, buf_size / 2, buf_size);
> +	io_prep_pwrite(&iocb4, fd, buf, buf_size, 0);
> +
> +	err = io_submit(ctx, 4, iocbs);
> +	if (err != 4) {
> +		fprintf(stderr, "error %s during %s\n",
> +			strerror(err), "io_submit");
> +		return 1;
> +	}
> +
> +	err = io_getevents(ctx, 4, 4, evs, NULL);
> +	if (err != 4) {
> +		fprintf(stderr, "error %s during %s\n",
> +			strerror(err), "io_getevents");
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> diff --git a/tests/generic/463 b/tests/generic/463
> new file mode 100755
> index 0000000..b3afbb0
> --- /dev/null
> +++ b/tests/generic/463
> @@ -0,0 +1,60 @@
> +#! /bin/bash
> +# FS QA Test 463
> +#
> +# Test racy COW AIO write completions.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Christoph Hellwig.  All Rights Reserved.
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
> +	rm -f $TEST_DIR/file $TEST_DIR/clone
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/reflink
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +_supported_fs generic
> +_supported_os Linux
> +
> +_require_test
> +_require_test_reflink
> +_require_aio
> +_require_odirect

Need _require_test_program "aio-dio-regress/aio-dio-cow-race"

But a single '_require_aiodio "aio-dio-cow-race"' did all the three
requirements check above.

> +
> +$here/src/aio-dio-regress/aio-dio-cow-race $TEST_DIR/file $TEST_DIR/clone

With _require_aiodio, we can use $AIO_TEST here for the test binary.

> +
> +echo "Silence is golden"

Added generic/463.out file too.

Thanks,
Eryu

> +status=0
> +exit
> diff --git a/tests/generic/group b/tests/generic/group
> index f2a6cda..014d6ea 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -465,3 +465,4 @@
>  460 auto quick rw
>  461 auto shutdown stress
>  462 auto quick dax
> +463 auto quick clone dangerous
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
