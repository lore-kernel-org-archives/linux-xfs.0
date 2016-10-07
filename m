Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752243AbcJGLmW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Oct 2016 07:42:22 -0400
Date: Fri, 7 Oct 2016 19:41:45 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 8/9] xfs: test realtime rmapbt code
Message-ID: <20161007114145.GI27776@eguan.usersys.redhat.com>
References: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
 <147520223583.26891.8504154002804973181.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520223583.26891.8504154002804973181.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Sep 29, 2016 at 07:23:55PM -0700, Darrick J. Wong wrote:
> Test the realtime rmap btree code by exercising various IO patterns
> on realtime files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

[snip]

> 
> 
> diff --git a/tests/xfs/877 b/tests/xfs/877
> index 194b3be..04fdb4c 100755
> --- a/tests/xfs/877
> +++ b/tests/xfs/877
> @@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _cleanup()
>  {
>  	cd /
> -	rm -rf "$tmp".* $metadump_file
> +	rm -rf "$tmp".*
>  }

I fold this hunk into patch 7/9.

[snip]

> diff --git a/tests/xfs/886 b/tests/xfs/886
> new file mode 100755
> index 0000000..f0c3997
> --- /dev/null
> +++ b/tests/xfs/886
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# FS QA Test No. 886
> +#
> +# Cross-link file block into rtrmapbt and see if repair fixes it.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
> +
> +seq=`basename "$0"`
> +seqres="$RESULT_DIR/$seq"
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -rf "$tmp".*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs xfs
> +_require_realtime
> +_require_xfs_scratch_rmapbt
> +_require_test_program "punch-alternating"
> +_disable_dmesg_check
> +
> +rm -f "$seqres.full"
> +
> +echo "Format and mount"
> +_scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> +. $tmp.mkfs
> +cat $tmp.mkfs > "$seqres.full" 2>&1
> +_scratch_mkfs > "$seqres.full" 2>&1

This second _scratch_mkfs doesn't seem necessary, and it overwrites
$seqres.full. xfs/887 has the same issue. I can fix them at commit time
if you think they're safe to remove too.

Thanks,
Eryu
