Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76C2C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 16:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A51F461969
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 16:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhC1QtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Mar 2021 12:49:23 -0400
Received: from out20-27.mail.aliyun.com ([115.124.20.27]:57654 "EHLO
        out20-27.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhC1QtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Mar 2021 12:49:11 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.0745825|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.205369-0.00320171-0.791429;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047201;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.JraZUby_1616950147;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.JraZUby_1616950147)
          by smtp.aliyun-inc.com(10.147.41.178);
          Mon, 29 Mar 2021 00:49:07 +0800
Date:   Mon, 29 Mar 2021 00:49:07 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/6] xfs/529: Fix test to execute in multi-block
 directory config
Message-ID: <YGCzg2zwOW03qVaX@desktop>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
 <20210325140857.7145-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140857.7145-2-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:38:53PM +0530, Chandan Babu R wrote:
> xfs/529 attempts to create $testfile after reduce_max_iextents error tag is
> injected. Creation of $testfile fails when using a multi-block directory test
> configuration because,
> 1. A directory can have a pseudo maximum extent count of 10.
> 2. In the worst case a directory entry creation operation can consume
>    (XFS_DA_NODE_MAXDEPTH + 1 + 1) * (Nr fs blocks in a single directory block)
>    extents.
>    With 1k fs block size and 4k directory block size, this evaluates to,
>    (5 + 1 + 1) * 4
>    = 7 * 4
>    = 28
>    > 10 (Pseudo maximum inode extent count).
> 
> This commit fixes the issue by creating $testfile before injecting
> reduce_max_iextents error tag.
> 
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Seems patch 2 to 6 fix the same bug in different tests, I think we could
put the fixes in one patch.

Thanks,
Eryu
> ---
>  tests/xfs/529     | 24 +++++++++++++++++++++---
>  tests/xfs/529.out |  6 +++++-
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/xfs/529 b/tests/xfs/529
> index abe5b1e0..b4533eba 100755
> --- a/tests/xfs/529
> +++ b/tests/xfs/529
> @@ -54,6 +54,8 @@ echo "* Delalloc to written extent conversion"
>  
>  testfile=$SCRATCH_MNT/testfile
>  
> +touch $testfile
> +
>  echo "Inject reduce_max_iextents error tag"
>  _scratch_inject_error reduce_max_iextents 1
>  
> @@ -74,10 +76,18 @@ if (( $nextents > 10 )); then
>  	exit 1
>  fi
>  
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
> +
>  rm $testfile
>  
>  echo "* Fallocate unwritten extents"
>  
> +touch $testfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
>  echo "Fallocate fragmented file"
>  for i in $(seq 0 2 $((nr_blks - 1))); do
>  	$XFS_IO_PROG -f -c "falloc $((i * bsize)) $bsize" $testfile \
> @@ -93,10 +103,18 @@ if (( $nextents > 10 )); then
>  	exit 1
>  fi
>  
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
> +
>  rm $testfile
>  
>  echo "* Directio write"
>  
> +touch $testfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
>  echo "Create fragmented file via directio writes"
>  for i in $(seq 0 2 $((nr_blks - 1))); do
>  	$XFS_IO_PROG -d -s -f -c "pwrite $((i * bsize)) $bsize" $testfile \
> @@ -112,15 +130,15 @@ if (( $nextents > 10 )); then
>  	exit 1
>  fi
>  
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
> +
>  rm $testfile
>  
>  # Check if XFS gracefully returns with an error code when we try to increase
>  # extent count of user quota inode beyond the pseudo max extent count limit.
>  echo "* Extend quota inodes"
>  
> -echo "Disable reduce_max_iextents error tag"
> -_scratch_inject_error reduce_max_iextents 0
> -
>  echo "Consume free space"
>  fillerdir=$SCRATCH_MNT/fillerdir
>  nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> diff --git a/tests/xfs/529.out b/tests/xfs/529.out
> index b2ae3f42..13489d34 100644
> --- a/tests/xfs/529.out
> +++ b/tests/xfs/529.out
> @@ -4,14 +4,18 @@ Format and mount fs
>  Inject reduce_max_iextents error tag
>  Create fragmented file
>  Verify $testfile's extent count
> +Disable reduce_max_iextents error tag
>  * Fallocate unwritten extents
> +Inject reduce_max_iextents error tag
>  Fallocate fragmented file
>  Verify $testfile's extent count
> +Disable reduce_max_iextents error tag
>  * Directio write
> +Inject reduce_max_iextents error tag
>  Create fragmented file via directio writes
>  Verify $testfile's extent count
> -* Extend quota inodes
>  Disable reduce_max_iextents error tag
> +* Extend quota inodes
>  Consume free space
>  Create fragmented filesystem
>  Inject reduce_max_iextents error tag
> -- 
> 2.29.2
