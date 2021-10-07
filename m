Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1807FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 16:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E684361263
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 16:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242661AbhJGQWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 12:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242664AbhJGQWG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Oct 2021 12:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D141361260;
        Thu,  7 Oct 2021 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633623612;
        bh=o7lVzGFEgjFYixw8suikOZPrYEQyxL8jyMVFjbTcNE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K5y7XZQyOT1Gagt+ASrQ01Ho2oyaO27BSlV3iX/MWYrl5zRTMgYjB5bFlgHurVhT1
         y/to3eL3EAFuk5A92bvokWtK2j4bcL18KWv+oqEyUOQtksOVdX9nmxftpO+ADurGI9
         MnKEs9RDGT9X+aDs0sVv1FrkMm2Seh7DqqfS4badB2k/GMIFNx6SJbPWzs7QYDVd43
         Blfnn7825l1xsYxFR+yU5R7pg4mDsBv7xuLWXHbqYLxTa2KO2QPV29M5aTWLUMHHOb
         ANv69hhvlL9cZ1jBmpzxtJkp6EudAFcf1HV4ULrYk5mre85F/mL/W8tC8+zjd+SppQ
         al3q3XgojSTgQ==
Date:   Thu, 7 Oct 2021 09:20:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH v2 1/4] xfstests: Rename _scratch_inject_logprint to
 _scratch_remount_dump_log
Message-ID: <20211007162012.GD24282@magnolia>
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
 <20211007002641.714906-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007002641.714906-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 07, 2021 at 12:26:38AM +0000, Catherine Hoang wrote:
> Rename _scratch_inject_logprint to _scratch_remount_dump_log to better
> describe what this function does. _scratch_remount_dump_log unmounts
> and remounts the scratch device, dumping the log.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Looks straightforward,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/inject | 2 +-
>  tests/xfs/312 | 2 +-
>  tests/xfs/313 | 2 +-
>  tests/xfs/314 | 2 +-
>  tests/xfs/315 | 2 +-
>  tests/xfs/316 | 2 +-
>  tests/xfs/317 | 2 +-
>  tests/xfs/318 | 2 +-
>  tests/xfs/319 | 2 +-
>  tests/xfs/320 | 2 +-
>  tests/xfs/321 | 2 +-
>  tests/xfs/322 | 2 +-
>  tests/xfs/323 | 2 +-
>  tests/xfs/324 | 2 +-
>  tests/xfs/325 | 2 +-
>  tests/xfs/326 | 2 +-
>  tests/xfs/329 | 2 +-
>  17 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/common/inject b/common/inject
> index 984ec209..3b731df7 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -113,7 +113,7 @@ _scratch_inject_error()
>  }
>  
>  # Unmount and remount the scratch device, dumping the log
> -_scratch_inject_logprint()
> +_scratch_remount_dump_log()
>  {
>  	local opts="$1"
>  
> diff --git a/tests/xfs/312 b/tests/xfs/312
> index 1fcf26ab..94f868fe 100755
> --- a/tests/xfs/312
> +++ b/tests/xfs/312
> @@ -63,7 +63,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/313 b/tests/xfs/313
> index 6d2f9fac..9c7cf5b9 100755
> --- a/tests/xfs/313
> +++ b/tests/xfs/313
> @@ -63,7 +63,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/314 b/tests/xfs/314
> index 5165393e..9ac311d0 100755
> --- a/tests/xfs/314
> +++ b/tests/xfs/314
> @@ -64,7 +64,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/315 b/tests/xfs/315
> index 958a8c99..105515ab 100755
> --- a/tests/xfs/315
> +++ b/tests/xfs/315
> @@ -61,7 +61,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/316 b/tests/xfs/316
> index cf0c5adc..f0af19d2 100755
> --- a/tests/xfs/316
> +++ b/tests/xfs/316
> @@ -61,7 +61,7 @@ echo "CoW all the blocks"
>  $XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $((blks * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/317 b/tests/xfs/317
> index 7eef67af..1ca2672d 100755
> --- a/tests/xfs/317
> +++ b/tests/xfs/317
> @@ -54,7 +54,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "Check files"
>  md5sum $SCRATCH_MNT/file0 | _filter_scratch
> diff --git a/tests/xfs/318 b/tests/xfs/318
> index d822e89a..38c7aa60 100755
> --- a/tests/xfs/318
> +++ b/tests/xfs/318
> @@ -60,7 +60,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "Check files"
>  md5sum $SCRATCH_MNT/file1 2>&1 | _filter_scratch
> diff --git a/tests/xfs/319 b/tests/xfs/319
> index 0f61c119..d64651fb 100755
> --- a/tests/xfs/319
> +++ b/tests/xfs/319
> @@ -57,7 +57,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/320 b/tests/xfs/320
> index f65f3ad1..d22d76d9 100755
> --- a/tests/xfs/320
> +++ b/tests/xfs/320
> @@ -55,7 +55,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "Check files"
>  md5sum $SCRATCH_MNT/file1 | _filter_scratch
> diff --git a/tests/xfs/321 b/tests/xfs/321
> index daff4449..06a34347 100755
> --- a/tests/xfs/321
> +++ b/tests/xfs/321
> @@ -55,7 +55,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "Check files"
>  md5sum $SCRATCH_MNT/file1 | _filter_scratch
> diff --git a/tests/xfs/322 b/tests/xfs/322
> index f36e54d8..89a2f741 100755
> --- a/tests/xfs/322
> +++ b/tests/xfs/322
> @@ -56,7 +56,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "Check files"
>  md5sum $SCRATCH_MNT/file1 | _filter_scratch
> diff --git a/tests/xfs/323 b/tests/xfs/323
> index f66a8ebf..66737da0 100755
> --- a/tests/xfs/323
> +++ b/tests/xfs/323
> @@ -55,7 +55,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/324 b/tests/xfs/324
> index ca2f25ac..9909db62 100755
> --- a/tests/xfs/324
> +++ b/tests/xfs/324
> @@ -61,7 +61,7 @@ echo "Reflink all the blocks"
>  _cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file4
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/325 b/tests/xfs/325
> index 3b98fd50..5b26b2b3 100755
> --- a/tests/xfs/325
> +++ b/tests/xfs/325
> @@ -59,7 +59,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/326 b/tests/xfs/326
> index bf5db08a..8b95a18a 100755
> --- a/tests/xfs/326
> +++ b/tests/xfs/326
> @@ -71,7 +71,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  
>  echo "FS should be online, touch should succeed"
>  touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/329 b/tests/xfs/329
> index e57f6f7f..e9a30d05 100755
> --- a/tests/xfs/329
> +++ b/tests/xfs/329
> @@ -52,7 +52,7 @@ echo "FS should be shut down, touch will fail"
>  touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>  
>  echo "Remount to replay log" | tee /dev/ttyprintk
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>  new_nextents=$(_count_extents $testdir/file1)
>  
>  echo "Check extent count" | tee /dev/ttyprintk
> -- 
> 2.25.1
> 
