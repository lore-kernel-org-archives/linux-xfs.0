Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752688AbdKBOXu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 10:23:50 -0400
Date: Thu, 2 Nov 2017 22:23:48 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 12/14] generic/204: break out of fs-filling loop early if
 we ENOSPC
Message-ID: <20171102142348.GZ17339@eguan.usersys.redhat.com>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957286222.18388.3253654888670864191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150957286222.18388.3253654888670864191.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Nov 01, 2017 at 02:47:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If filling up the filesystem causes us to hit ENOSPC earlier than we
> thought we would (the sizing estimates become less and less accurate as
> we add more metadata) then just bail out -- we're checking that the fs
> is robust enough to cut us off before we actually run out of space for
> writing metadata and crash the fs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/204 |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/generic/204 b/tests/generic/204
> index 4c203a2..1e2c1e1 100755
> --- a/tests/generic/204
> +++ b/tests/generic/204
> @@ -82,8 +82,15 @@ echo files $files, resvblks $resv_blks >> $seqres.full
>  _scratch_resvblks $resv_blks >> $seqres.full 2>&1
>  
>  for i in `seq 1 $files`; do
> -    echo -n > $SCRATCH_MNT/$i
> -    echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
> +	# Open/truncate file, write stuff.  If we run out of space early,
> +	# we can bail out of the loop.
> +	out="$($XFS_IO_PROG \
> +		-c "open -f -t $SCRATCH_MNT/$i" \
> +		-c 'close' \
> +		-c "open -f -t $SCRATCH_MNT/$i" \
> +		-c 'pwrite -q -S 0x58 0 36' 2>&1 | _filter_scratch)"
> +	echo "${out}" | grep -q 'No space left on device' && break

This doesn't look correct to me. This test is meant to catch spurious
ENOSPC, it's designed to be a "delayed allocation ENOSPC test"[1] by
"writing lots of single block files" and catch early ENOSPC. IMHO, this
change ignores ENOSPC, which defeats the test purpose. And I don't quite
understand the purpose of truncate open/close/truncate open/write
sequence..

Also this significantly increases the test time, 4s -> ~120s for me.

Thanks,
Eryu

[1] commit 143368a047ea ("xfstests: add test 204, a simple delayed
allocation ENOSPC test")

> +	test -n "${out}" && echo "${out}"
>  done
>  
>  # success, all done
> 
