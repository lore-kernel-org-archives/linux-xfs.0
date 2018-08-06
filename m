Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39745 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726870AbeHFCjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Aug 2018 22:39:24 -0400
Date: Mon, 6 Aug 2018 10:32:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/2] xfs/288: _notrun if xfs_db can't write values
 into dir or attr
Message-ID: <20180806003251.GB7395@dastard>
References: <20180731054119.13539-1-zlang@redhat.com>
 <20180731054119.13539-2-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731054119.13539-2-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, yangx.jy@cn.fujitsu.com

On Tue, Jul 31, 2018 at 01:41:19PM +0800, Zorro Lang wrote:
> Commit b3cf8b72334fd35ef961869506e5a72ab398bc82 help xfs/288 to
> support v5 filesystems testing, but there're still some old
> distributions don't support xfs_db write '-d' option, or can't
> write values into dir/attr of v5 filesystems.
> 
> For compatible with older versions, skip this test on v5 xfs
> if xfs_db write can't write v5 XFS dir/attr.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> Xiao found v1 can't work well on xfsprogs-4.9, due to 'write -d' can't
> write vaules into dir/attr of v5 filesystems before xfsprogs-4.13.
> 
> Only check "if write command has -d option" is not enough. So I write
> a function _require_xfs_db_write_da() to make sure current xfs_db
> can write dir/attr (not only on v5, but especially for v5).
> 
> Thanks,
> Zorro
> 
>  common/xfs    | 28 ++++++++++++++++++++++++++++
>  tests/xfs/288 |  1 +
>  2 files changed, 29 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index d971b4a8..95dcfd59 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -720,6 +720,34 @@ _require_xfs_db_write_array()
>  	[ $supported -eq 0 ] && _notrun "xfs_db write can't support array"
>  }
>  
> +# Before xfsprogs commit 89baf918(xfs_db: write values into dir/attr blocks and
> +# recalculate CRCs), xfs_db write command can't write invalid data into dir/attr
> +# field of v5 filesystems. For some cases need to write dir/attr (especially crc
> +# enabled), use this _require at first.
> +_require_xfs_db_write_da()
> +{
> +	local inum
> +	local count
> +
> +	_require_scratch

Hiding this inside a another requires rule is kinda nasty. If the
test already used _require_scratch_nocheck, this will now cause the
test to check the scratch device at the end of the test.

And vice-versa - if you use _require_scratch_nocheck here, it will
break tests that have already called _require_scratch....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
