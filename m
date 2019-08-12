Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfHLQvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:51:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGmiKm167724
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:04 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbt8wee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGm0EW130718
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2u9n9h30st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:03 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGp2NK032066
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:02 GMT
Date: Mon, 12 Aug 2019 09:51:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 1/1] xfstests: Add Delayed Attribute test
Message-ID: <20190812165101.GG7138@magnolia>
References: <20190809213829.383-1-allison.henderson@oracle.com>
 <20190809213829.383-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213829.383-2-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:38:29PM -0700, Allison Collins wrote:
> This patch adds a test to exercise the delayed attribute error
> inject and log replay
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  tests/xfs/512     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/512.out |  18 ++++++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 121 insertions(+)
> 
> diff --git a/tests/xfs/512 b/tests/xfs/512
> new file mode 100644
> index 0000000..957525c
> --- /dev/null
> +++ b/tests/xfs/512
> @@ -0,0 +1,102 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 512
> +#
> +# Delayed attr log replay test
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=0	# success is the default!
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +. ./common/inject
> +
> +_cleanup()
> +{
> +	echo "*** unmount"
> +	_scratch_unmount 2>/dev/null
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_attr()
> +{
> +	${ATTR_PROG} $* 2>$tmp.err >$tmp.out
> +	exit=$?
> +	sed \
> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \

When does $tmp show up in the ATTR_PROG output?

Also, _filter_scratch should do most of this filtering for you, right?

> +		$tmp.out
> +	sed \
> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
> +		$tmp.err 1>&2
> +	return $exit
> +}
> +
> +do_getfattr()
> +{
> +	_getfattr $* 2>$tmp.err >$tmp.out
> +	exit=$?
> +	sed \
> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
> +		$tmp.out
> +	sed \
> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
> +		$tmp.err 1>&2
> +	return $exit
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_require_scratch
> +_require_attrs
> +_require_xfs_io_error_injection "delayed_attr"
> +
> +rm -f $seqres.full
> +_scratch_unmount >/dev/null 2>&1
> +
> +echo "*** mkfs"
> +_scratch_mkfs_xfs >/dev/null \
> +	|| _fail "mkfs failed"

I think _scratch_mkfs_xfs does the _fail for you already, right?

(Or was it _scratch_mkfs?)

> +
> +echo "*** mount FS"
> +_scratch_mount
> +
> +testfile=$SCRATCH_MNT/testfile
> +echo "*** make test file 1"
> +
> +touch $testfile.1
> +
> +echo "Inject error"
> +_scratch_inject_error "delayed_attr"
> +
> +echo "Set attribute"
> +echo "attr_value" | _attr -s "attr_name" $testfile.1 >/dev/null

Can we try attr recovery with a 64k value too?

--D

> +echo "FS should be shut down, touch will fail"
> +touch $testfile.1
> +
> +echo "Remount to replay log"
> +_scratch_inject_logprint >> $seqres.full
> +
> +echo "FS should be online, touch should succeed" 
> +touch $testfile.1
> +
> +echo "Verify attr recovery"
> +do_getfattr --absolute-names $testfile.1
> +
> +echo "*** done"
> +exit
> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
> new file mode 100644
> index 0000000..71bff79
> --- /dev/null
> +++ b/tests/xfs/512.out
> @@ -0,0 +1,18 @@
> +QA output created by 512
> +*** mkfs
> +*** mount FS
> +*** make test file 1
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name" for <TESTFILE>.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: <TESTFILE>.1
> +user.attr_name
> +
> +*** done
> +*** unmount
> diff --git a/tests/xfs/group b/tests/xfs/group
> index a7ad300..a9dab7c 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -509,3 +509,4 @@
>  509 auto ioctl
>  510 auto ioctl quick
>  511 auto quick quota
> +512 auto quick attr
> -- 
> 2.7.4
> 
