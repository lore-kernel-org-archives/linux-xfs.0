Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44820 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfBCMkt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Feb 2019 07:40:49 -0500
Date: Sun, 3 Feb 2019 20:40:41 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2 2/2] xfs/068: Verify actual file count instead of
 reported file count
Message-ID: <20190203124041.GQ2713@desktop>
References: <20190127075057.25254-1-amir73il@gmail.com>
 <20190127075057.25254-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190127075057.25254-2-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Jan 27, 2019 at 09:50:57AM +0200, Amir Goldstein wrote:
> This test has the number of files/dirs created by xfsrestore hardcoded
> in golden output.
> 
> When fsstress is added new ops, the number of files/dirs created with
> the same random seed changes and this regularly breaks this test,
> so when new fsstress ops are added they should be either added to the
> dump test blacklist or golden output of this test needs to be ammended
> to reflect the change.
> 
> The golden output includes only the file count reported by xfsrestore
> and test does not even verify that this is the correct file count.
> Instead, leave the golden output nuetral and explicitly verify that
> file count before and after the test are the same.
> 
> With this change, the test becomes agnostic to fsstress ops and we
> could also stop blacklisting clone/dedup/copy ops if we want.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks fine to me overall, thanks a lot for the fix! But I'd like an ACK
from XFS folks :)

> ---
>  common/dump       |  7 +++++++
>  tests/xfs/068     | 14 +++++++++++++-
>  tests/xfs/068.out |  2 +-
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/common/dump b/common/dump
> index 89fa0391..f112fc37 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -1514,6 +1514,13 @@ _check_quota_file()
>     _check_quota 'xfsdump_quotas' 'xfsdump_quotas_group' 'xfsdump_quotas_proj'
>  }
>  
> +_count_dumpdir_files()
> +{
> +	local ndirs=$(find $dump_dir -type d | wc -l)
> +	local nents=$(find $dump_dir | wc -l)
> +
> +	echo "$ndirs directories and $nents entries"
> +}
>  
>  # make sure this script returns success
>  /bin/true
> diff --git a/tests/xfs/068 b/tests/xfs/068
> index 7f5900fc..264a9e96 100755
> --- a/tests/xfs/068
> +++ b/tests/xfs/068
> @@ -30,12 +30,24 @@ _cleanup()
>  . ./common/rc
>  . ./common/dump
>  
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
>  # real QA test starts here
>  _supported_fs xfs
>  _supported_os Linux
>  
>  _create_dumpdir_stress_num 4096
> -_do_dump_restore
> +
> +echo -n "Before: " >> $seqres.full
> +_count_dumpdir_files | tee $tmp.before >> $seqres.full
> +
> +# filter out the file count, it changes as fsstress adds new operations
> +_do_dump_restore | sed -e "/entries processed$/s/[0-9][0-9]*/NUM/g"
> +
> +echo -n "After: " >> $seqres.full
> +_count_dumpdir_files | tee $tmp.after >> $seqres.full

The "Before" and "After" both count the file entries in $dump_dir, so
they should always be the same, we should count $restore_dir at "After"?

Thanks,
Eryu

> +diff -u $tmp.before $tmp.after
>  
>  # success, all done
>  exit
> diff --git a/tests/xfs/068.out b/tests/xfs/068.out
> index fa3a5523..2b276b77 100644
> --- a/tests/xfs/068.out
> +++ b/tests/xfs/068.out
> @@ -22,7 +22,7 @@ xfsrestore: session id: ID
>  xfsrestore: media ID: ID
>  xfsrestore: searching media for directory dump
>  xfsrestore: reading directories
> -xfsrestore: 383 directories and 1335 entries processed
> +xfsrestore: NUM directories and NUM entries processed
>  xfsrestore: directory post-processing
>  xfsrestore: restoring non-directory files
>  xfsrestore: restore complete: SECS seconds elapsed
> -- 
> 2.17.1
> 
