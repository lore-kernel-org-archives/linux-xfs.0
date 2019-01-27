Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34349 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfA0FCZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Jan 2019 00:02:25 -0500
Date: Sun, 27 Jan 2019 13:02:17 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/2] xfs/068: Add fsstress generated file count to golden
 output
Message-ID: <20190127050217.GL2713@desktop>
References: <20190124083310.25928-1-amir73il@gmail.com>
 <20190124083310.25928-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124083310.25928-2-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

[I'm sorry that I've been absent from the discussion entirely.. I was
busy with other tasks recently.]

On Thu, Jan 24, 2019 at 10:33:10AM +0200, Amir Goldstein wrote:
> This test has the number of files/dirs created by fsstress hardcoded
> in golden output.

This leads me to wonder if we could remove the hardcoded dir/entries
number from the golden output and verify the counts on the fly? i.e. we
count the dir/entries numbers that fsstress created and compare them
with the numbers xfsrestore reports. So we don't have to worry about new
ops in fsstress and xfs configurations.

But for now, I'd like to take Zorro's v3 patch, which follows Dave's
suggestion. And I've verified that the restored dir/entires counts
matched what fsstress created (so previously added
insert/mread/mwrite etc. ops didn't break xfs/068 either).

> 
> When fsstress is added new ops, the number of files/dirs created with
> the same random seed changes and this regularly breaks this test.
> 
> So when new fsstress ops are added they should be either added to the
> dump test blacklist or golden output of this test needs to be ammended
> to reflect the change.
> 
> Since the golden output includes only the file count after dump/restore,
> add also the file count before dump/restore so developers are less
> likely to forget to check the validity of golden output before commiting
> the change.
> 
> For some reason the file count reported by xfsrestore has one directory
> more than the file count reported by 'find'. I did not investigate why

I haven't looked at the xfsrestore code yet, but I guess it's because
xfsrestore counts the '$SCRATCH_MNT/restoredir' as one entry processed
as well.

Thanks,
Eryu

> that is, but did verify that this was the same with the original test
> fsstress ops (i.e. without the added ops
> insert/mread/mwrite/aread/awrite/readv/writev).
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/dump       | 7 +++++++
>  tests/xfs/068     | 1 +
>  tests/xfs/068.out | 1 +
>  3 files changed, 9 insertions(+)
> 
> diff --git a/common/dump b/common/dump
> index 47d14601..23f42216 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -1515,6 +1515,13 @@ _check_quota_file()
>     _check_quota 'xfsdump_quotas' 'xfsdump_quotas_group' 'xfsdump_quotas_proj'
>  }
>  
> +_count_dumpdir_files()
> +{
> +	local ndirs=$(find $dump_dir -type d | wc -l)
> +	local nents=$(find $dump_dir | wc -l)
> +
> +	echo "Created $ndirs directories and $nents entries"
> +}
>  
>  # make sure this script returns success
>  /bin/true
> diff --git a/tests/xfs/068 b/tests/xfs/068
> index 95a8cd12..ffc293bd 100755
> --- a/tests/xfs/068
> +++ b/tests/xfs/068
> @@ -28,6 +28,7 @@ _supported_fs xfs
>  _supported_os Linux
>  
>  _create_dumpdir_stress_num 4096
> +_count_dumpdir_files
>  _do_dump_restore
>  
>  # success, all done
> diff --git a/tests/xfs/068.out b/tests/xfs/068.out
> index fa3a5523..61cbbfa4 100644
> --- a/tests/xfs/068.out
> +++ b/tests/xfs/068.out
> @@ -4,6 +4,7 @@ Creating directory system to dump using fsstress.
>  -----------------------------------------------
>  fsstress : -f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10
>  -----------------------------------------------
> +Created 382 directories and 1334 entries
>  xfsdump|xfsrestore ...
>  xfsdump  -s DUMP_SUBDIR - SCRATCH_MNT | xfsrestore  - RESTORE_DIR
>  xfsrestore: using file dump (drive_simple) strategy
> -- 
> 2.17.1
> 
