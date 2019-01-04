Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36682 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfADV1j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Jan 2019 16:27:39 -0500
Subject: Re: [PATCH] generic: test that xattrs can have slashes in their names
References: <20190104212336.GC12689@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c44b0678-a050-e887-aa6d-9dc29d6b45a8@sandeen.net>
Date: Fri, 4 Jan 2019 15:27:37 -0600
MIME-Version: 1.0
In-Reply-To: <20190104212336.GC12689@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <guaneryu@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On 1/4/19 3:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Eric Sandeen recently found a bug in xfs_repair that flagged extended
> attribute names containing "/" as corrupt and purged them.  There's
> nothing in the IRIX or Linux manuals that say anything about slashes not
> being allowed (and Linux certainly allows this) so let's make sure this
> continues to work.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/708     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/708.out |    6 ++++++
>  tests/generic/group   |    1 +
>  3 files changed, 55 insertions(+)
>  create mode 100755 tests/generic/708
>  create mode 100644 tests/generic/708.out
> 
> diff --git a/tests/generic/708 b/tests/generic/708
> new file mode 100755
> index 00000000..ee63ba79
> --- /dev/null
> +++ b/tests/generic/708
> @@ -0,0 +1,48 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 708
> +#
> +# Check that xattrs can have slashes in their name.

Perhaps a note about what failed before?  Because set/get/list has
always(tm) worked:

# (xfs_repair previously flagged this as a corruption)

Is it worth also validating that '/' in a dir entry /is/ still flagged?
Or maybe that's a separate test.

-Eric

> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
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
> +. ./common/attr
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_attrs
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +echo "set attr"
> +file=$SCRATCH_MNT/moofile
> +touch $file
> +setfattr -n "user.boo/hoo" -v "woof" $file
> +
> +echo "check attr"
> +getfattr -d --absolute-names $file | _filter_scratch
> +
> +# success, all done(?)
> +status=0
> +exit
> diff --git a/tests/generic/708.out b/tests/generic/708.out
> new file mode 100644
> index 00000000..6978532e
> --- /dev/null
> +++ b/tests/generic/708.out
> @@ -0,0 +1,6 @@
> +QA output created by 708
> +set attr
> +check attr
> +# file: SCRATCH_MNT/moofile
> +user.boo/hoo="woof"
> +
> diff --git a/tests/generic/group b/tests/generic/group
> index ea5aa7aa..f88125b4 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -525,3 +525,4 @@
>  520 auto quick log
>  521 soak long_rw
>  522 soak long_rw
> +708 auto quick attr
> 
