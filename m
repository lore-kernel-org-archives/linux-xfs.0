Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46654 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfA0FPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Jan 2019 00:15:52 -0500
Date: Sun, 27 Jan 2019 13:15:45 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 1/2] common/dump: do not override test cleanup trap
Message-ID: <20190127051545.GM2713@desktop>
References: <20190124083310.25928-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124083310.25928-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Jan 24, 2019 at 10:33:09AM +0200, Amir Goldstein wrote:
> Currently this doesn't matter for the two dump tests xfs/022 and xfs/068
> because they do not have a _cleanup() routine and the override dump
> _cleanup() routine does the generic cleanup as well.
> 
> Instead, call the _dump_cleanup explicitly from the trap in those tests.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/dump   | 5 +----
>  tests/xfs/022 | 2 +-
>  tests/xfs/068 | 2 +-

I just scan all tests that source common/dump quickly and it seems we
have more tests to convert than xfs/{022,068}

eguan@desktop:~/workspace/src/xfstests$ grep trap `grep common/dump ./* -rI | grep xfs | sort | uniq | cut -d':' -f 1`
./tests/xfs/022:trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/023:trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/024:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/025:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/026:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/027:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/028:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/035:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/036:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/037:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/038:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/039:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/043:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/046:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/047:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/055:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/056:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/059:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/060:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/061:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/063:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/064:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/065:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/066:trap "_cleanup; exit \$status" 0 1 2 3 15
./tests/xfs/068:trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/266:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/267:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/268:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/281:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/282:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/283:trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
./tests/xfs/287:trap "_cleanup; exit \$status" 0 1 2 3 15
./tests/xfs/296:trap "_cleanup; exit \$status" 0 1 2 3 15
./tests/xfs/301:trap "_cleanup; exit \$status" 0 1 2 3 15
./tests/xfs/302:trap "_cleanup; exit \$status" 0 1 2 3 15

>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/common/dump b/common/dump
> index 4d1a1607..47d14601 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -45,9 +45,6 @@ session_label="stress_$seq"
>  nobody=4 # define this uid/gid as a number
>  do_quota_check=true # do quota check if quotas enabled
>  
> -# install our cleaner
> -trap "_cleanup; exit \$status" 0 1 2 3 15
> -
>  # start inventory from a known base - move it aside for test
>  for dir in /var/xfsdump/inventory /var/lib/xfsdump/inventory; do
>      if [ -d $dir ]; then
> @@ -227,7 +224,7 @@ _wipe_fs()
>  # Cleanup created dirs and files
>  # Called by trap
>  #
> -_cleanup()
> +_dump_cleanup()
>  {
>      # Some tests include this before checking _supported_fs xfs
>      # and the sleeps & checks here get annoying
> diff --git a/tests/xfs/022 b/tests/xfs/022
> index e1162798..f091b7c5 100755
> --- a/tests/xfs/022
> +++ b/tests/xfs/022
> @@ -17,7 +17,7 @@ echo "QA output created by $seq"
>  here=`pwd`
>  tmp=/tmp/$$
>  status=0	# success is the default!
> -trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
> +trap "_dump_cleanup; exit \$status" 0 1 2 3 15

Let's follow the template and trap a generic _cleanup and call
_dump_cleanup there, and we could remove the following lines from
_dump_cleanup, because they've been done in generic _cleanup.

    cd $here                                                                                                                                                                                                         
    rm -f $tmp.*

Thanks,
Eryu

>  
>  . ./common/rc
>  . ./common/dump
> diff --git a/tests/xfs/068 b/tests/xfs/068
> index c755bc3e..95a8cd12 100755
> --- a/tests/xfs/068
> +++ b/tests/xfs/068
> @@ -18,7 +18,7 @@ echo "QA output created by $seq"
>  here=`pwd`
>  tmp=/tmp/$$
>  status=0	# success is the default!
> -trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
> +trap "_dump_cleanup; exit \$status" 0 1 2 3 15
>  
>  . ./common/rc
>  . ./common/dump
> -- 
> 2.17.1
> 
