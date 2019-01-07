Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51030 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfAGJ7d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 04:59:33 -0500
Received: by mail-wm1-f65.google.com with SMTP id n190so292611wmd.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jan 2019 01:59:31 -0800 (PST)
Date: Mon, 7 Jan 2019 10:59:27 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] generic: test that xattrs can have slashes in their
 names
Message-ID: <20190107095927.yprhqj7h474bj4we@hades.usersys.redhat.com>
References: <20190104212336.GC12689@magnolia>
 <20190104231448.GF12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104231448.GF12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Fri, Jan 04, 2019 at 03:14:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Eric Sandeen recently found a bug in xfs_repair that flagged extended
> attribute names containing "/" as corrupt and purged them.  There's
> nothing in the IRIX or Linux manuals that say anything about slashes not
> being allowed (and Linux certainly allows this) so let's make sure this
> continues to work.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  tests/generic/708     |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/708.out |    6 ++++++
>  tests/generic/group   |    1 +
>  3 files changed, 57 insertions(+)
>  create mode 100755 tests/generic/708
>  create mode 100644 tests/generic/708.out
> 
> diff --git a/tests/generic/708 b/tests/generic/708
> new file mode 100755
> index 00000000..c32f966c
> --- /dev/null
> +++ b/tests/generic/708
> @@ -0,0 +1,50 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 708
> +#
> +# Check that xattrs can have slashes in their name.
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

[off-topic] I love your creativity for naming :D

> +
> +echo "check attr"
> +getfattr -d --absolute-names $file | _filter_scratch
> +
> +# Now we let the fsck tool check the filesystem, because xfs_repair had a
> +# regression where it would flag and erase any xattr with a '/' in it.
> +

I'd prefer this to be in the beginning of the test description instead of
'hidden' in the middle of the code, so, it's easily accessible via 'grep'.

But the test itself looks good, and I don't think this change is worth a V3, so
if you want, you could move it to the test description before merging, or ignore
my suggestion completely :P
But anyway, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


Cheers

-- 
Carlos
