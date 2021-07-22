Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF0CC6377D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49B666069B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhGVRoj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhGVRoj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 13:44:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58F8760C51;
        Thu, 22 Jul 2021 18:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626978314;
        bh=yjp+c2WPjQKI9dGtvXMw5xzU/K21fhwOKpp5FryBGhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j+yWy7T90VlNFjoDKjeGtTBBOq0JfvF4/jKRmPsPeo4Ve24gMDoIYOnQhNPgDV5ls
         lLZ2V7Lsegw1QmLmFcc51vGzTzRCKmeBQr+IqwgyGAlB+vlpf9F/GWk+MBZEuUWlH4
         hRY3WD7BLCPhtzJNztlwr5Y089TwU+tfulkAaPE18H+V0AEaSRf3xQeamq37IvMF7d
         nT4q3ltrzt4FjfwFpKWZR3s8arOgK0tFwSxmGk93wwHmIOBfUxe0Ezr+41E8W5ahf4
         1uN+0IGcpHmWApB4mz60oG9uaAlNiMgib95tIaTZBpVsWEc2lmJoMyPNqo0H16P6lh
         apHrfp+83/6Fw==
Date:   Thu, 22 Jul 2021 11:25:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: use $XFS_QUOTA_PROG instead of hardcoding
 xfs_quota
Message-ID: <20210722182514.GE559212@magnolia>
References: <20210722073832.976547-1-hch@lst.de>
 <20210722073832.976547-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722073832.976547-8-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 09:38:32AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice!!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/007 |  4 ++--
>  tests/xfs/052 |  4 ++--
>  tests/xfs/108 |  6 +++---
>  tests/xfs/220 |  4 ++--
>  tests/xfs/261 |  4 ++--
>  tests/xfs/303 | 14 +++++++-------
>  tests/xfs/304 |  6 +++---
>  tests/xfs/305 |  2 +-
>  8 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/tests/xfs/007 b/tests/xfs/007
> index d1946524..66f1f101 100755
> --- a/tests/xfs/007
> +++ b/tests/xfs/007
> @@ -40,11 +40,11 @@ do_test()
>  
>  	_qmount
>  	echo "*** turn off $off_opts quotas"
> -	xfs_quota -x -c "off -$off_opts" $SCRATCH_MNT
> +	$XFS_QUOTA_PROG -x -c "off -$off_opts" $SCRATCH_MNT
>  	_scratch_unmount
>  	_qmount_option ""
>  	_scratch_mount
> -	xfs_quota -x -c "remove -$off_opts" $SCRATCH_MNT
> +	$XFS_QUOTA_PROG -x -c "remove -$off_opts" $SCRATCH_MNT
>  	echo "*** umount"
>  	_scratch_unmount
>  
> diff --git a/tests/xfs/052 b/tests/xfs/052
> index 010f9ad6..75761022 100755
> --- a/tests/xfs/052
> +++ b/tests/xfs/052
> @@ -63,13 +63,13 @@ bsoft=1001
>  bhard=1001
>  isoft=10
>  ihard=10
> -xfs_quota -x \
> +$XFS_QUOTA_PROG -x \
>  	-c "limit -$type bsoft=${bsoft}k bhard=${bhard}k $id" \
>  	-c "limit -$type isoft=$isoft ihard=$ihard $id" \
>  	$SCRATCH_DEV
>  
>  # cross check blks, softblks, hardblks <-> quota, xfs_db
> -xfs_quota -c "quota -$type -birnN $id" $SCRATCH_DEV |
> +$XFS_QUOTA_PROG -c "quota -$type -birnN $id" $SCRATCH_DEV |
>  			tr -d '\n' | tr -s '[:space:]' | tee -a $seqres.full |
>  	perl -ne 'if (m[^\s*'$SCRATCH_DEV'\s+(\d+)\s+(\d+)\s+(\d+)]) {
>  		print "used_blocks=", $1, "\n";
> diff --git a/tests/xfs/108 b/tests/xfs/108
> index 0af22443..8a102133 100755
> --- a/tests/xfs/108
> +++ b/tests/xfs/108
> @@ -47,9 +47,9 @@ test_accounting()
>  	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
>  		$here/src/lstat64 $file | head -3 | _filter_scratch
>  	done
> -	xfs_quota -c "quota -hnb -$type $id" $QARGS | _filter_quota
> -	xfs_quota -c "quota -hni -$type $id" $QARGS | _filter_quota
> -	xfs_quota -c "quota -hnr -$type $id" $QARGS | _filter_quota
> +	$XFS_QUOTA_PROG -c "quota -hnb -$type $id" $QARGS | _filter_quota
> +	$XFS_QUOTA_PROG -c "quota -hni -$type $id" $QARGS | _filter_quota
> +	$XFS_QUOTA_PROG -c "quota -hnr -$type $id" $QARGS | _filter_quota
>  }
>  
>  export MOUNT_OPTIONS="-opquota"
> diff --git a/tests/xfs/220 b/tests/xfs/220
> index c847a0dc..241a7abd 100755
> --- a/tests/xfs/220
> +++ b/tests/xfs/220
> @@ -41,7 +41,7 @@ _scratch_mkfs_xfs >/dev/null 2>&1
>  _scratch_mount -o uquota
>  
>  # turn off quota
> -xfs_quota -x -c off $SCRATCH_DEV
> +$XFS_QUOTA_PROG -x -c off $SCRATCH_DEV
>  
>  # and unmount (this used to crash)
>  _scratch_unmount
> @@ -58,7 +58,7 @@ _scratch_mount -o uquota
>  # The sed expression below replaces a notrun to cater for kernels that have
>  # removed the ability to disable quota accounting at runtime.  On those
>  # kernel this test is rather useless, and in a few years we can drop it.
> -xfs_quota -x -c off -c remove $SCRATCH_DEV 2>&1 | \
> +$XFS_QUOTA_PROG -x -c off -c remove $SCRATCH_DEV 2>&1 | \
>  	sed -e '/XFS_QUOTARM: Invalid argument/d'
>  
>  # and unmount again
> diff --git a/tests/xfs/261 b/tests/xfs/261
> index 3b58db8d..eb8a72cd 100755
> --- a/tests/xfs/261
> +++ b/tests/xfs/261
> @@ -71,13 +71,13 @@ _check() {
>  	# Set up a private mount table file, then try out a simple quota
>  	# command to show mounts
>  	_setup_my_mtab
> -	echo print | xfs_quota	-t "${my_mtab}" > /dev/null || exit
> +	echo print | $XFS_QUOTA_PROG -t "${my_mtab}" > /dev/null || exit
>  
>  	# Do the same simple quota command after adding a bogus entry to the
>  	# mount table.  Old code will bail on this because it has trouble
>  	# with the bogus entry.
>  	_perturb_my_mtab
> -	echo print | xfs_quota -t "${my_mtab}" > /dev/null || exit
> +	echo print | $XFS_QUOTA_PROG -t "${my_mtab}" > /dev/null || exit
>  }
>  
>  #########
> diff --git a/tests/xfs/303 b/tests/xfs/303
> index b2e5668c..6aafae85 100755
> --- a/tests/xfs/303
> +++ b/tests/xfs/303
> @@ -24,13 +24,13 @@ echo "Silence is golden"
>  # An non-existent xfs mount point
>  INVALID_PATH="/INVALID_XFS_MOUNT_POINT"
>  
> -xfs_quota -x -c 'report -a' $INVALID_PATH	2>/dev/null
> -xfs_quota -x -c 'state -a' $INVALID_PATH	2>/dev/null
> -xfs_quota -x -c 'free -h' $INVALID_PATH		2>/dev/null
> -xfs_quota -x -c 'quot -v' $INVALID_PATH		2>/dev/null
> -xfs_quota -x -c 'remove' $INALID_PATH		2>/dev/null
> -xfs_quota -x -c 'disable' $INVALID_PATH		2>/dev/null
> -xfs_quota -x -c 'enable' $INVALID_PATH		2>/dev/null
> +$XFS_QUOTA_PROG -x -c 'report -a' $INVALID_PATH	2>/dev/null
> +$XFS_QUOTA_PROG -x -c 'state -a' $INVALID_PATH	2>/dev/null
> +$XFS_QUOTA_PROG -x -c 'free -h' $INVALID_PATH		2>/dev/null
> +$XFS_QUOTA_PROG -x -c 'quot -v' $INVALID_PATH		2>/dev/null
> +$XFS_QUOTA_PROG -x -c 'remove' $INALID_PATH		2>/dev/null
> +$XFS_QUOTA_PROG -x -c 'disable' $INVALID_PATH		2>/dev/null
> +$XFS_QUOTA_PROG -x -c 'enable' $INVALID_PATH		2>/dev/null
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/304 b/tests/xfs/304
> index 91fa5d97..3c38e613 100755
> --- a/tests/xfs/304
> +++ b/tests/xfs/304
> @@ -31,7 +31,7 @@ QUOTA_DIR=$SCRATCH_MNT/quota_dir
>  
>  mkdir -p $QUOTA_DIR
>  echo "*** turn off group quotas"
> -xfs_quota -x -c 'disable -g' $SCRATCH_MNT
> +$XFS_QUOTA_PROG -x -c 'disable -g' $SCRATCH_MNT
>  rmdir $QUOTA_DIR
>  echo "*** umount"
>  _scratch_unmount
> @@ -39,7 +39,7 @@ _scratch_unmount
>  _qmount
>  mkdir -p $QUOTA_DIR
>  echo "*** turn off project quotas"
> -xfs_quota -x -c 'disable -p' $SCRATCH_MNT
> +$XFS_QUOTA_PROG -x -c 'disable -p' $SCRATCH_MNT
>  rmdir $QUOTA_DIR
>  echo "*** umount"
>  _scratch_unmount
> @@ -47,7 +47,7 @@ _scratch_unmount
>  _qmount
>  mkdir -p $QUOTA_DIR
>  echo "*** turn off group/project quotas"
> -xfs_quota -x -c 'disable -gp' $SCRATCH_MNT
> +$XFS_QUOTA_PROG -x -c 'disable -gp' $SCRATCH_MNT
>  rmdir $QUOTA_DIR
>  echo "*** umount"
>  _scratch_unmount
> diff --git a/tests/xfs/305 b/tests/xfs/305
> index 0b89499a..41c7b7f8 100755
> --- a/tests/xfs/305
> +++ b/tests/xfs/305
> @@ -38,7 +38,7 @@ _exercise()
>  
>  	$FSSTRESS_PROG -d $QUOTA_DIR -n 1000000 -p 100 $FSSTRESS_AVOID >/dev/null 2>&1 &
>  	sleep 10
> -	xfs_quota -x -c "disable -$type" $SCRATCH_DEV
> +	$XFS_QUOTA_PROG -x -c "disable -$type" $SCRATCH_DEV
>  	sleep 5
>  	$KILLALL_PROG -q $FSSTRESS_PROG
>  	wait
> -- 
> 2.30.2
> 
