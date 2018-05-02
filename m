Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:45292 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbeEBHvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 03:51:49 -0400
Date: Wed, 2 May 2018 15:51:45 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/9] xfs/439: repair corrupted filesystem afterwards
Message-ID: <20180502075145.GC29084@desktop>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
 <152518917279.23023.13530280927017959292.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152518917279.23023.13530280927017959292.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, May 01, 2018 at 08:39:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> After we mess with logsunit and test that we can't mount the fs, repair
> the filesystem to make sure that repair can deal with it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/439 |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/tests/xfs/439 b/tests/xfs/439
> index 215c4b90..9d5f6892 100755
> --- a/tests/xfs/439
> +++ b/tests/xfs/439
> @@ -79,6 +79,7 @@ fi
>  _check_dmesg _filter_assert_dmesg
>  
>  echo "Silence is golden"
> +_scratch_xfs_repair >> $seqres.full 2>&1

But how should we check if repair does fix the corruption? I tried
adding a "scratch_mount" after the repair and expected a success mount.
But that mount also failed, and repair didn't report anything wrong in
$seqres.full. Looks like the corruption was not detected nor repaired.

[ 8278.679149] XFS (dm-1): Mounting V5 Filesystem
[ 8278.679743] XFS (dm-1): log stripe unit 4095 bytes must be a multiple of block size
[ 8278.680583] XFS (dm-1): AAIEEE! Log failed size checks. Abort!
[ 8278.681817] XFS (dm-1): log mount failed

Note that I was using latest for-next branch of xfsprogs.

Thanks,
Eryu

>  
>  # success, all done
>  status=0
> 
