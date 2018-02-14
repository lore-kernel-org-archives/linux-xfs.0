Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1031151AbeBNPYE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Feb 2018 10:24:04 -0500
Date: Wed, 14 Feb 2018 23:24:01 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs/015: enlarge the initial fs size
Message-ID: <20180214152401.GO18267@eguan.usersys.redhat.com>
References: <20180104054626.14458-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180104054626.14458-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org

On Thu, Jan 04, 2018 at 01:46:26PM +0800, Eryu Guan wrote:
> Kernel commit f59cf5c29919 ("xfs: remove "no-allocation"
> reservations for file creations") is known to cause earlier ENOSPC
> conditions, and xfs/015 is affected in the way that no new file/dir
> can be created in a newly created 16M XFS with both reflink and
> rmapbt enabled, thus xfs/015 fails due to the missing test dirs.
> 
> So enlarge the initial fs size to 32M that we're able to create new
> dir/file before growing the filesystem size.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

ping on this patch.

Eryu

> ---
>  tests/xfs/015 | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/015 b/tests/xfs/015
> index 2c57f7882308..4939bb92f6fc 100755
> --- a/tests/xfs/015
> +++ b/tests/xfs/015
> @@ -66,15 +66,15 @@ _supported_os Linux
>  
>  _require_scratch
>  
> -# need 64M space, don't make any assumption
> +# need 128M space, don't make any assumption
>  _scratch_mkfs >/dev/null 2>&1
>  _scratch_mount
> -_require_fs_space $SCRATCH_MNT 65536
> +_require_fs_space $SCRATCH_MNT 131072
>  _scratch_unmount
>  
>  rm -f $seqres.full
>  
> -_scratch_mkfs_sized $((16 * 1024 * 1024)) > $tmp.mkfs.raw
> +_scratch_mkfs_sized $((32 * 1024 * 1024)) > $tmp.mkfs.raw
>  cat $tmp.mkfs.raw | _filter_mkfs >$seqres.full 2>$tmp.mkfs
>  # get original data blocks number and agcount
>  . $tmp.mkfs
> -- 
> 2.14.3
> 
