Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E000CC433ED
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 12:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B34DC6121D
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 12:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhDRM0S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Apr 2021 08:26:18 -0400
Received: from out20-97.mail.aliyun.com ([115.124.20.97]:59033 "EHLO
        out20-97.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhDRM0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Apr 2021 08:26:18 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3010881|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0360927-0.00441459-0.959493;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047202;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.K.pyxbv_1618748748;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.K.pyxbv_1618748748)
          by smtp.aliyun-inc.com(10.147.41.121);
          Sun, 18 Apr 2021 20:25:48 +0800
Date:   Sun, 18 Apr 2021 20:25:48 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 5/9] common/dmthin: make this work with external log
 devices
Message-ID: <YHwlTMySYgKuaw6Y@desktop>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836230182.2754991.16864806174255630147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836230182.2754991.16864806174255630147.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 06:05:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Provide a mkfs helper to format the dm thin device when external devices
> are in use, and fix the dmthin mount helper to support them.  This fixes
> regressions in generic/347 and generic/500 when external logs are in
> use.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/dmthin     |    9 ++++++++-
>  tests/generic/223 |    3 +++
>  tests/generic/347 |    2 +-
>  tests/generic/500 |    2 +-
>  4 files changed, 13 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/dmthin b/common/dmthin
> index c58c3948..3b1c7d45 100644
> --- a/common/dmthin
> +++ b/common/dmthin
> @@ -218,10 +218,17 @@ _dmthin_set_fail()
>  
>  _dmthin_mount_options()
>  {
> -	echo `_common_dev_mount_options $*` $DMTHIN_VOL_DEV $SCRATCH_MNT
> +	_scratch_options mount
> +	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS $DMTHIN_VOL_DEV $SCRATCH_MNT
>  }
>  
>  _dmthin_mount()
>  {
>  	_mount -t $FSTYP `_dmthin_mount_options $*`
>  }
> +
> +_dmthin_mkfs()
> +{
> +	_scratch_options mkfs
> +	_mkfs_dev $SCRATCH_OPTIONS $@ $DMTHIN_VOL_DEV
> +}
> diff --git a/tests/generic/223 b/tests/generic/223
> index 1f85efe5..a5ace82f 100755
> --- a/tests/generic/223
> +++ b/tests/generic/223
> @@ -43,6 +43,9 @@ for SUNIT_K in 8 16 32 64 128; do
>  	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
>  	_scratch_mount
>  
> +	# Make sure everything is on the data device
> +	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT

What does this do for non-xfs filesystems? Do we need a FSTYP check and
do chattr only on XFS?

Thanks,
Eryu

> +
>  	for SIZE_MULT in 1 2 8 64 256; do
>  		let SIZE=$SIZE_MULT*$SUNIT_BYTES
>  
> diff --git a/tests/generic/347 b/tests/generic/347
> index cbc5150a..e970ac10 100755
> --- a/tests/generic/347
> +++ b/tests/generic/347
> @@ -31,7 +31,7 @@ _setup_thin()
>  {
>  	_dmthin_init $BACKING_SIZE $VIRTUAL_SIZE
>  	_dmthin_set_queue
> -	_mkfs_dev $DMTHIN_VOL_DEV
> +	_dmthin_mkfs
>  	_dmthin_mount
>  }
>  
> diff --git a/tests/generic/500 b/tests/generic/500
> index 085ddbf3..5ab2f78c 100755
> --- a/tests/generic/500
> +++ b/tests/generic/500
> @@ -68,7 +68,7 @@ CLUSTER_SIZE=$((64 * 1024 / 512))		# 64K
>  
>  _dmthin_init $BACKING_SIZE $VIRTUAL_SIZE $CLUSTER_SIZE 0
>  _dmthin_set_fail
> -_mkfs_dev $DMTHIN_VOL_DEV
> +_dmthin_mkfs
>  _dmthin_mount
>  
>  # There're two bugs at here, one is dm-thin bug, the other is filesystem
