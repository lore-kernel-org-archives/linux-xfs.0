Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BB2C432C3
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 16:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA6F20833
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 16:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="An3DRfqW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfLBQ2z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 11:28:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfLBQ2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 11:28:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2GJZW4162797;
        Mon, 2 Dec 2019 16:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=4kQqpR9zCdGlnp8oXL5mTlyg+DDZaH3Xv89tyZCWovY=;
 b=An3DRfqWN8dVpAvfEFzP9i8QaxX8PlS+OvOeZvxig2vigl8BEcrB5gNmU8mA/1vY8o1/
 sZ8vnM18iQiQxNj/upqPqUWlR8FsJCmUlUr6JxkOWv8LsAEH2WAjSYvlG6WiKrN8BRyW
 1/rHlrdmRwgiigJ49YluBVgOA/krNwc4IPduvUAqABG2VbYrvTG5vWlZzRVKDGHFaHIp
 zy937mMaK0TdanVKv3J4EdDSX2fWfuzlLQlnFzlifE4sT6GF/NGvEEKBMD41omEyvIgl
 wqTFJCPDzmbXP0zfoeUhd+PlvvS5iGYEuwdN9JobbNDSO55UtMU1zlOU1dO+z0zfymEx xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wkh2r13hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 16:28:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2GIoEf059854;
        Mon, 2 Dec 2019 16:28:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wm1w2v05d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 16:28:51 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB2GSn6w027778;
        Mon, 2 Dec 2019 16:28:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 08:28:49 -0800
Date:   Mon, 2 Dec 2019 08:28:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic: test race between appending AIO DIO and
 fallocate
Message-ID: <20191202162848.GB7335@magnolia>
References: <20191113024416.GH6235@magnolia>
 <20191201142824.GI8664@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191201142824.GI8664@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 01, 2019 at 10:28:39PM +0800, Eryu Guan wrote:
> On Tue, Nov 12, 2019 at 06:44:16PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Dave Chinner reports[1] that an appending AIO DIO write to the second
> > block of a zero-length file and an fallocate request to the first block
> > of the same file can race to set isize, with the user-visible end result
> > that the file size is set incorrectly to one block long.  Write a small
> > test to reproduce the results.
> > 
> > [1] https://lore.kernel.org/linux-xfs/20191029100342.GA41131@bfoster/T/
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  .../aio-dio-append-write-fallocate-race.c          |  212 ++++++++++++++++++++
> 
> I added an entry in .gitignore for it.
> 
> >  tests/generic/722                                  |   43 ++++
> >  tests/generic/722.out                              |    2 
> >  tests/generic/group                                |    1 
> >  4 files changed, 258 insertions(+)
> >  create mode 100644 src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
> >  create mode 100755 tests/generic/722
> >  create mode 100644 tests/generic/722.out
> > 
> > diff --git a/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c b/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
> > new file mode 100644
> > index 00000000..091b047d
> > --- /dev/null
> > +++ b/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
> > @@ -0,0 +1,212 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-newer
> > +/*
> > + * Copyright (c) 2019 Oracle.
> > + * All Rights Reserved.
> > + *
> > + * Race appending aio dio and fallocate to make sure we get the correct file
> > + * size afterwards.
> > + */
> > +#include <stdio.h>
> > +#include <pthread.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <unistd.h>
> > +#include <string.h>
> > +#include <errno.h>
> > +#include <libaio.h>
> > +#include <stdlib.h>
> > +#include <stdbool.h>
> > +#include <limits.h>
> > +
> > +static int fd;
> > +static int blocksize;
> > +
> > +static void *
> > +falloc_thread(
> > +	void		*p)
> > +{
> > +	int		ret;
> > +
> > +	ret = fallocate(fd, 0, 0, blocksize);
> > +	if (ret)
> > +		perror("falloc");
> > +
> > +	return NULL;
> > +}
> > +
> > +static int
> > +test(
> > +	const char	*fname,
> > +	unsigned int	iteration,
> > +	unsigned int	*passed)
> > +{
> > +	struct stat	sbuf;
> > +	pthread_t	thread;
> > +	io_context_t	ioctx = 0;
> > +	struct iocb	iocb;
> > +	struct iocb	*iocbp = &iocb;
> > +	struct io_event	event;
> > +	char		*buf;
> > +	bool		wait_thread = false;
> > +	int		ret;
> > +
> > +	/* Truncate file, allocate resources for doing IO. */
> > +	fd = open(fname, O_DIRECT | O_RDWR | O_TRUNC | O_CREAT, 0644);
> > +	if (fd < 0) {
> > +		perror(fname);
> > +		return -1;
> > +	}
> > +
> > +	ret = fstat(fd, &sbuf);
> > +	if (ret) {
> > +		perror(fname);
> > +		goto out;
> > +	}
> > +	blocksize = sbuf.st_blksize;
> > +
> > +	ret = posix_memalign((void **)&buf, blocksize, blocksize);
> > +	if (ret) {
> > +		errno = ret;
> > +		perror("buffer");
> > +		goto out;
> > +	}
> > +	memset(buf, 'X', blocksize);
> > +	memset(&event, 0, sizeof(event));
> > +
> > +	ret = io_queue_init(1, &ioctx);
> > +	if (ret) {
> > +		errno = -ret;
> > +		perror("io_queue_init");
> > +		goto out_buf;
> > +	}
> > +
> > +	/*
> > +	 * Set ourselves up to race fallocate(0..blocksize) with aio dio
> > +	 * pwrite(blocksize..blocksize * 2).  This /should/ give us a file
> > +	 * with length (2 * blocksize).
> > +	 */
> > +	io_prep_pwrite(&iocb, fd, buf, blocksize, blocksize);
> > +
> > +	ret = pthread_create(&thread, NULL, falloc_thread, NULL);
> > +	if (ret) {
> > +		errno = ret;
> > +		perror("pthread");
> > +		goto out_io;
> > +	}
> > +	wait_thread = true;
> > +
> > +	ret = io_submit(ioctx, 1, &iocbp);
> > +	if (ret != 1) {
> > +		errno = -ret;
> > +		perror("io_submit");
> > +		goto out_join;
> > +	}
> > +
> > +	ret = io_getevents(ioctx, 1, 1, &event, NULL);
> > +	if (ret != 1) {
> > +		errno = -ret;
> > +		perror("io_getevents");
> > +		goto out_join;
> > +	}
> > +
> > +	if (event.res < 0) {
> > +		errno = -event.res;
> > +		perror("io_event.res");
> > +		goto out_join;
> > +	}
> > +
> > +	if (event.res2 < 0) {
> > +		errno = -event.res2;
> > +		perror("io_event.res2");
> > +		goto out_join;
> > +	}
> > +
> > +	wait_thread = false;
> > +	ret = pthread_join(thread, NULL);
> > +	if (ret) {
> > +		errno = ret;
> > +		perror("join");
> > +		goto out_io;
> > +	}
> > +
> > +	/* Make sure we actually got a file of size (2 * blocksize). */
> > +	ret = fstat(fd, &sbuf);
> > +	if (ret) {
> > +		perror(fname);
> > +		goto out_buf;
> > +	}
> > +
> > +	if (sbuf.st_size != 2 * blocksize) {
> > +		fprintf(stderr, "[%u]: sbuf.st_size=%llu, expected %llu.\n",
> > +				iteration,
> > +				(unsigned long long)sbuf.st_size,
> > +				(unsigned long long)2 * blocksize);
> > +	} else {
> > +		printf("[%u]: passed.\n", iteration);
> > +		(*passed)++;
> > +	}
> > +
> > +out_join:
> > +	if (wait_thread) {
> > +		ret = pthread_join(thread, NULL);
> > +		if (ret) {
> > +			errno = ret;
> > +			perror("join");
> > +			goto out_io;
> > +		}
> > +	}
> > +out_io:
> > +	ret = io_queue_release(ioctx);
> > +	if (ret) {
> > +		errno = -ret;
> > +		perror("io_queue_release");
> > +	}
> > +
> > +out_buf:
> > +	free(buf);
> > +out:
> > +	ret = close(fd);
> > +	fd = -1;
> > +	if (ret) {
> > +		perror("close");
> > +		return -1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	int		ret;
> > +	long		l;
> > +	unsigned int	i;
> > +	unsigned int	passed = 0;
> > +
> > +	if (argc != 3) {
> > +		printf("Usage: %s filename iterations\n", argv[0]);
> > +		return 1;
> > +	}
> > +
> > +	errno = 0;
> > +	l = strtol(argv[2], NULL, 0);
> > +	if (errno) {
> > +		perror(argv[2]);
> > +		return 1;
> > +	}
> > +	if (l < 1 || l > UINT_MAX) {
> > +		fprintf(stderr, "%ld: must be between 1 and %u.\n",
> > +				l, UINT_MAX);
> > +		return 1;
> > +	}
> > +
> > +	for (i = 0; i < l; i++) {
> > +		ret = test(argv[1], i, &passed);
> > +		if (ret)
> > +			return 1;
> > +	}
> > +
> > +	printf("pass rate: %u/%u (%.2f%%)\n", passed, i, 100.0 * passed / i);
> > +
> > +	return 0;
> > +}
> > diff --git a/tests/generic/722 b/tests/generic/722
> > new file mode 100755
> > index 00000000..937abf36
> > --- /dev/null
> > +++ b/tests/generic/722
> > @@ -0,0 +1,43 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 722
> > +#
> > +# Race an appending aio dio write to the second block of a file while
> > +# simultaneously fallocating to the first block.  Make sure that we end up
> > +# with a two-block file.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
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
> > +	rm -f $tmp.* $testfile
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs generic
> > +_require_aiodio "aio-dio-append-write-fallocate-race"
> > +_require_test
> 
> Also added
> 
> _require_xfs_io_command "falloc"

Thanks for fixing these. :)

--D

> Thanks,
> Eryu
> 
> > +
> > +rm -f $seqres.full
> > +
> > +testfile=$TEST_DIR/test-$seq
> > +$AIO_TEST $testfile 100 >> $seqres.full
> > +
> > +echo Silence is golden.
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/722.out b/tests/generic/722.out
> > new file mode 100644
> > index 00000000..8621a87d
> > --- /dev/null
> > +++ b/tests/generic/722.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 722
> > +Silence is golden.
> > diff --git a/tests/generic/group b/tests/generic/group
> > index e5d0c1da..308f86f2 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -588,3 +588,4 @@
> >  583 auto quick encrypt
> >  584 auto quick encrypt
> >  585 auto rename
> > +722 auto quick rw falloc
