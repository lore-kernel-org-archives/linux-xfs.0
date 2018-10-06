Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37691 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbeJFHhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 03:37:47 -0400
Date: Sat, 6 Oct 2018 10:33:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V5 06/20] Fix xfs/139 to work with 64k block size
Message-ID: <20181006003338.GC6311@dastard>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
 <20180924151942.8220-7-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180924151942.8220-7-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

On Mon, Sep 24, 2018 at 08:49:28PM +0530, Chandan Rajendra wrote:
> For 64k block size, the agsize provided in the test causes mkfs.xfs to
> fail due to insufficient log space. Hence this commit computes agsize
> based on block size of the filesystem.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  tests/xfs/139     | 15 +++++++++------
>  tests/xfs/139.out |  8 ++++++--
>  2 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/tests/xfs/139 b/tests/xfs/139
> index 2a26635..c074273 100755
> --- a/tests/xfs/139
> +++ b/tests/xfs/139
> @@ -34,17 +34,20 @@ _require_cp_reflink
>  
>  rm -f $seqres.full
>  
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +blksz=$(_get_file_block_size $SCRATCH_MNT)
> +_scratch_unmount
> +
>  echo "Format and mount"
> -_scratch_mkfs -d agsize=$((32 * 1048576)) > $seqres.full 2>&1
> +_scratch_mkfs -d agsize=$((8192 * $blksz)) > $seqres.full 2>&1

This breaks 512 byte and 1k block size filesystems.

$ head -3 139.full
Invalid value 8388608 for -d agsize option. Value is too small.
Usage: mkfs.xfs
/* blocksize */         [-b size=num]
$

Minimum AG size is 16MB. There are more changes to other tests in
this series that also demonstrate this regression.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
