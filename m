Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496C4C636C8
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 14:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19C0F611AB
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 14:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhGROX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Jul 2021 10:23:58 -0400
Received: from out20-50.mail.aliyun.com ([115.124.20.50]:52774 "EHLO
        out20-50.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhGROX6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Jul 2021 10:23:58 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07505499|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0237661-0.00541911-0.970815;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Kkr7JVp_1626618058;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Kkr7JVp_1626618058)
          by smtp.aliyun-inc.com(10.147.42.135);
          Sun, 18 Jul 2021 22:20:58 +0800
Date:   Sun, 18 Jul 2021 22:20:58 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/8] dmthin: erase the metadata device properly before
 starting
Message-ID: <YPQ4yl55EkwibVsA@desktop>
References: <162561726690.543423.15033740972304281407.stgit@locust>
 <162561728893.543423.5093723938379703860.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162561728893.543423.5093723938379703860.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 06, 2021 at 05:21:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then I see the following failure when running generic/347:
> 
> --- generic/347.out
> +++ generic/347.out.bad
> @@ -1,2 +1,2 @@
>  QA output created by 347
> -=== completed
> +failed to create dm thin pool device
> 
> Accompanied by the following dmesg spew:
> 
> device-mapper: thin metadata: sb_check failed: blocknr 7016996765293437281: wanted 0
> device-mapper: block manager: superblock validator check failed for block 0
> device-mapper: thin metadata: couldn't read superblock
> device-mapper: table: 253:2: thin-pool: Error creating metadata object
> device-mapper: ioctl: error adding target to table
> 
> 7016996765293437281 is of course the magic number 0x6161616161616161,
> which are stale ondisk contents left behind by previous tests that wrote
> known tests patterns to files on the scratch device.  This is a bit
> surprising, since _dmthin_init supposedly zeroes the first 4k of the
> thin pool metadata device before initializing the pool.  Or does it?
> 
> dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1 &>/dev/null
> 
> Herein lies the problem: the dd process writes zeroes into the page
> cache and exits.  Normally the block layer will flush the page cache
> after the last file descriptor is closed, but once in a while the
> terminating dd process won't be the only process in the system with an
> open file descriptor!
> 
> That process is of course udev.  The write() call from dd triggers a
> kernel uevent, which starts udev.  If udev is running particularly
> slowly, it'll still be running an instant later when dd terminates,
> thereby preventing the page cache flush.  If udev is still running a
> moment later when we call dmsetup to set up the thin pool, the pool
> creation will issue a bio to read the ondisk superblock.  This read
> isn't coherent with the page cache, so it sees old disk contents and the
> test fails even though we supposedly formatted the metadata device.
> 
> Fix this by explicitly flushing the page cache after writing the zeroes.
> 
> Fixes: 4b52fffb ("dm-thinp helpers in common/dmthin")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

This is a hard one to catch, thanks for the patch! :)

Eryu

> ---
>  common/dmthin |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/dmthin b/common/dmthin
> index 3b1c7d45..91147e47 100644
> --- a/common/dmthin
> +++ b/common/dmthin
> @@ -113,8 +113,12 @@ _dmthin_init()
>  	_dmsetup_create $DMTHIN_DATA_NAME --table "$DMTHIN_DATA_TABLE" || \
>  		_fatal "failed to create dm thin data device"
>  
> -	# Zap the pool metadata dev
> -	dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1 &>/dev/null
> +	# Zap the pool metadata dev.  Explicitly fsync the zeroes to disk
> +	# because a slow-running udev running concurrently with dd can maintain
> +	# an open file descriptor.  The block layer only flushes the page cache
> +	# on last close, which means that the thin pool creation below will
> +	# see the (stale) ondisk contents and fail.
> +	dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1 conv=fsync &>/dev/null
>  
>  	# Thin pool
>  	# "start length thin-pool metadata_dev data_dev data_block_size low_water_mark"
