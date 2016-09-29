Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:22216 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753431AbcI2G2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 02:28:05 -0400
Date: Thu, 29 Sep 2016 16:27:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs/130: don't modify files after failed mount
Message-ID: <20160929062729.GL9806@dastard>
References: <147511610789.12284.10323409415801065382.stgit@birch.djwong.org>
 <147511611421.12284.6952703843128702262.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147511611421.12284.6952703843128702262.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Sep 28, 2016 at 07:28:34PM -0700, Darrick J. Wong wrote:
> In xfs/130, we try to mount a filesystem with the expectation that it
> will fail.  Therefore, it is inappropriate to try to write to the
> mountpoint, since it could otherwise be writable.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

fixes the failure I've been seeing.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
>  tests/xfs/130     |    9 +++------
>  tests/xfs/130.out |    1 -
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/tests/xfs/130 b/tests/xfs/130
> index 554d078..48f6a84 100755
> --- a/tests/xfs/130
> +++ b/tests/xfs/130
> @@ -79,12 +79,9 @@ seq 0 $((agcount - 1)) | while read ag; do
>  done
>  
>  echo "+ mount image"
> -_scratch_mount
> -
> -echo "+ reflink more"
> -_cp_reflink "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file4" 2> /dev/null && \
> -	_fail "should not be able to reflink with busted refcount btree"
> -umount "${SCRATCH_MNT}"
> +_scratch_mount >> $seqres.full 2>&1 && \
> +	echo "Should not be able to mount with broken refcountbt."
> +_scratch_unmount >> $seqres.full 2>&1
>  
>  echo "+ repair fs"
>  _disable_dmesg_check
> diff --git a/tests/xfs/130.out b/tests/xfs/130.out
> index 58d153b..a0eab98 100644
> --- a/tests/xfs/130.out
> +++ b/tests/xfs/130.out
> @@ -5,7 +5,6 @@ QA output created by 130
>  + check fs
>  + corrupt image
>  + mount image
> -+ reflink more
>  + repair fs
>  + mount image (2)
>  + chattr -R -i
> 
> 

-- 
Dave Chinner
david@fromorbit.com
