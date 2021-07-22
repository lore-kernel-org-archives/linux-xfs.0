Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB37EC63799
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B0C60555
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhGVRnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhGVRnP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 13:43:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACF0D60720;
        Thu, 22 Jul 2021 18:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626978230;
        bh=JkAAlO63M1kT6xHiSVvHDNwcRfgu+K7dZZqsuY7HmuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qefjV2MOibGA1nKisS/dBlxbi73m0NKcGrl9Kfbzr4g0I0GU4BOufXeYa4iVpUjuk
         OgnvJR7ES2ARXAezDrVOmrCQLiQ37gLXdi3nVAPYXYUAxIHOsysNw4LURIl99xA6u5
         2V3yFm6wn9CkR0Vainbha3lDYgdKcx3CHPJafhTC+0LNMvPHg0GzEmN11jQSFLjgQf
         Me3MZf2mpgbI5dojbceQZDq1S5YkEauOk3qjf9ozM07C2/qFa93QsS+USZHjaBLvJE
         sdWN4d5mep0XinEatfpMcv3UFZuY1N05jlMgryEY1W9uuPlTd5Xj/mdEBueolWYauy
         Mr1vYqBVVHHJg==
Date:   Thu, 22 Jul 2021 11:23:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs/106: don't test disabling quota accounting
Message-ID: <20210722182350.GC559212@magnolia>
References: <20210722073832.976547-1-hch@lst.de>
 <20210722073832.976547-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722073832.976547-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 09:38:28AM +0200, Christoph Hellwig wrote:
> Switch the test that removes the quota files to just disable
> enforcement and then unmount the file system as disabling quota
> accounting is about to go away.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks reasonable to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/106     | 42 ++++++++++++++++++----------------
>  tests/xfs/106.out | 58 +++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 72 insertions(+), 28 deletions(-)
> 
> diff --git a/tests/xfs/106 b/tests/xfs/106
> index f1397f94..d8f55441 100755
> --- a/tests/xfs/106
> +++ b/tests/xfs/106
> @@ -155,9 +155,9 @@ test_enable()
>  
>  test_off()
>  {
> -	echo "checking off command (type=$type)"
> -	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> -			-c "off -$type -v" $SCRATCH_MNT | _filter_scratch
> +	_scratch_unmount
> +	_qmount_option ""
> +	_qmount
>  }
>  
>  test_remove()
> @@ -194,6 +194,15 @@ test_restore()
>  
>  test_xfs_quota()
>  {
> +	_qmount_option $1
> +	_qmount
> +
> +	if [ $type == "p" ]; then
> +		_require_prjquota $SCRATCH_DEV
> +		$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +			-c "project -s $id" $SCRATCH_MNT > /dev/null
> +	fi
> +
>  	# init quota
>  	echo "init quota limit and timer, and dump it"
>  	echo "create_files 1024k 15"; create_files 1024k 15
> @@ -236,14 +245,19 @@ test_xfs_quota()
>  	echo ; test_report -N
>  
>  	# off and remove test
> -	echo "off and remove test"
> +	echo "disable and remove test"
>  	echo ; test_limit 100m 100m 100 100
>  	echo ; test_quota -N
> -	echo ; test_off
> +	echo ; test_disable
>  	echo ; test_state
> +	echo ; test_off
>  	echo ; test_remove
>  	echo ; test_report -N
> -	echo "quota remount"; _qmount
> +	_scratch_unmount
> +
> +	echo "quota remount";
> +	_qmount_option $1
> +	_qmount
>  	echo ; test_report -N
>  
>  	# restore test
> @@ -255,33 +269,23 @@ test_xfs_quota()
>  }
>  
>  echo "----------------------- uquota,sync ---------------------------"
> -_qmount_option "uquota,sync"
> -_qmount
>  type=u
>  id=$uqid
> -test_xfs_quota
> +test_xfs_quota "uquota,sync"
>  
>  echo "----------------------- gquota,sync ---------------------------"
> -_qmount_option "gquota,sync"
> -_qmount
>  type=g
>  id=$gqid
> -test_xfs_quota
> +test_xfs_quota "gquota,sync"
>  
>  echo "----------------------- pquota,sync ---------------------------"
>  # Need to clean the group quota before test project quota, because
>  # V4 xfs doesn't support separate project inode. So mkfs at here.
>  _scratch_unmount
>  _scratch_mkfs_xfs >>$seqres.full 2>&1
> -_qmount_option "pquota,sync"
> -_qmount
>  type=p
>  id=$pqid
> -_require_prjquota $SCRATCH_DEV
> -$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> -		-c "project -s $id" \
> -		$SCRATCH_MNT > /dev/null
> -test_xfs_quota
> +test_xfs_quota "pquota,sync"
>  
>  _scratch_unmount
>  # success, all done
> diff --git a/tests/xfs/106.out b/tests/xfs/106.out
> index e36375d3..3e6805a6 100644
> --- a/tests/xfs/106.out
> +++ b/tests/xfs/106.out
> @@ -124,17 +124,31 @@ Realtime Blocks grace time: [7 days]
>  checking report command (type=u)
>  fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
>  
> -off and remove test
> +disable and remove test
>  
>  checking limit command (type=u, bsoft=100m, bhard=100m, isoft=100, ihard=100)
>  
>  checking quota command (type=u)
>  SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
>  
> -checking off command (type=u)
> -User quota are not enabled on SCRATCH_DEV
> +checking disable command (type=u)
> +User quota state on SCRATCH_MNT (SCRATCH_DEV)
> + Accounting: ON
> + Enforcement: OFF
> + Inode: #[INO] (X blocks, Y extents)
> +Blocks grace time: [3 days]
> +Inodes grace time: [3 days]
> +Realtime Blocks grace time: [7 days]
>  
>  checking state command (type=u)
> +User quota state on SCRATCH_MNT (SCRATCH_DEV)
> + Accounting: ON
> + Enforcement: OFF
> + Inode: #[INO] (X blocks, Y extents)
> +Blocks grace time: [3 days]
> +Inodes grace time: [3 days]
> +Realtime Blocks grace time: [7 days]
> +
>  
>  checking remove command (type=u)
>  User quota are not enabled on SCRATCH_DEV
> @@ -288,17 +302,30 @@ Realtime Blocks grace time: [7 days]
>  checking report command (type=g)
>  fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
>  
> -off and remove test
> +disable and remove test
>  
>  checking limit command (type=g, bsoft=100m, bhard=100m, isoft=100, ihard=100)
>  
>  checking quota command (type=g)
>  SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
>  
> -checking off command (type=g)
> -Group quota are not enabled on SCRATCH_DEV
> +checking disable command (type=g)
> +Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> + Accounting: ON
> + Enforcement: OFF
> + Inode: #[INO] (X blocks, Y extents)
> +Blocks grace time: [3 days]
> +Inodes grace time: [3 days]
> +Realtime Blocks grace time: [7 days]
>  
>  checking state command (type=g)
> +Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> + Accounting: ON
> + Enforcement: OFF
> + Inode: #[INO] (X blocks, Y extents)
> +Blocks grace time: [3 days]
> +Inodes grace time: [3 days]
> +Realtime Blocks grace time: [7 days]
>  
>  checking remove command (type=g)
>  Group quota are not enabled on SCRATCH_DEV
> @@ -452,17 +479,30 @@ Realtime Blocks grace time: [7 days]
>  checking report command (type=p)
>  fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
>  
> -off and remove test
> +disable and remove test
>  
>  checking limit command (type=p, bsoft=100m, bhard=100m, isoft=100, ihard=100)
>  
>  checking quota command (type=p)
>  SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
>  
> -checking off command (type=p)
> -Project quota are not enabled on SCRATCH_DEV
> +checking disable command (type=p)
> +Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> + Accounting: ON
> + Enforcement: OFF
> + Inode: #[INO] (X blocks, Y extents)
> +Blocks grace time: [3 days]
> +Inodes grace time: [3 days]
> +Realtime Blocks grace time: [7 days]
>  
>  checking state command (type=p)
> +Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> + Accounting: ON
> + Enforcement: OFF
> + Inode: #[INO] (X blocks, Y extents)
> +Blocks grace time: [3 days]
> +Inodes grace time: [3 days]
> +Realtime Blocks grace time: [7 days]
>  
>  checking remove command (type=p)
>  Project quota are not enabled on SCRATCH_DEV
> -- 
> 2.30.2
> 
