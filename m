Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D970BC4320A
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Jul 2021 15:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE8FD60E09
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Jul 2021 15:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhGYOWC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Jul 2021 10:22:02 -0400
Received: from out20-1.mail.aliyun.com ([115.124.20.1]:53674 "EHLO
        out20-1.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhGYOWA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Jul 2021 10:22:00 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07570033|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.637282-0.000114646-0.362603;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.KqjFUkr_1627225348;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KqjFUkr_1627225348)
          by smtp.aliyun-inc.com(10.147.41.199);
          Sun, 25 Jul 2021 23:02:28 +0800
Date:   Sun, 25 Jul 2021 23:02:28 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: use $XFS_QUOTA_PROG instead of hardcoding
 xfs_quota
Message-ID: <YP19BK83JkDYI9iv@desktop>
References: <20210722073832.976547-1-hch@lst.de>
 <20210722073832.976547-8-hch@lst.de>
 <20210722182514.GE559212@magnolia>
 <20210722231707.GQ559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722231707.GQ559212@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 04:17:07PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 22, 2021 at 11:25:14AM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 22, 2021 at 09:38:32AM +0200, Christoph Hellwig wrote:
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Nice!!
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> OFC now that I applied it I noticed that you forgot xfs/107.

I updated xfs/107 and folded it into this patch. Thanks for all the
reviews!

Eryu

> 
> --D
> 
> diff --git a/tests/xfs/107 b/tests/xfs/107
> index ce131a77..da052290 100755
> --- a/tests/xfs/107
> +++ b/tests/xfs/107
> @@ -85,17 +85,17 @@ $FSSTRESS_PROG -z -s 47806 -m 8 -n 500 -p 4 \
>  QARGS="-x -D $tmp.projects -P /dev/null $SCRATCH_MNT"
>  
>  echo "### initial report"
> -xfs_quota -c 'quot -p' -c 'quota -ip 6' $QARGS | filter_xfs_quota
> +$XFS_QUOTA_PROG -c 'quot -p' -c 'quota -ip 6' $QARGS | filter_xfs_quota
>  
>  echo "### check the project, should give warnings"
> -xfs_quota -c 'project -c 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
> +$XFS_QUOTA_PROG -c 'project -c 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
>  
>  echo "### recursively setup the project"
> -xfs_quota -c 'project -s 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
> -xfs_quota -c 'quota -ip 6' $QARGS | filter_xfs_quota
> +$XFS_QUOTA_PROG -c 'project -s 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
> +$XFS_QUOTA_PROG -c 'quota -ip 6' $QARGS | filter_xfs_quota
>  
>  echo "### check the project, should give no warnings now"
> -xfs_quota -c 'project -c 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
> +$XFS_QUOTA_PROG -c 'project -c 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
>  
>  echo "### deny a hard link - wrong project ID"
>  rm -f $SCRATCH_MNT/outer $target/inner
> @@ -107,7 +107,7 @@ if [ $? -eq 0 ]; then
>  else
>  	echo hard link failed
>  fi
> -xfs_quota -c 'quota -ip 6' $QARGS | filter_xfs_quota
> +$XFS_QUOTA_PROG -c 'quota -ip 6' $QARGS | filter_xfs_quota
>  
>  echo "### allow a hard link - right project ID"
>  $XFS_IO_PROG -c 'chproj 6' $SCRATCH_MNT/outer
> @@ -118,12 +118,12 @@ else
>  	echo hard link failed
>  	ls -ld $SCRATCH_MNT/outer $target/inner
>  fi
> -xfs_quota -c 'quota -ip 6' $QARGS | filter_xfs_quota
> +$XFS_QUOTA_PROG -c 'quota -ip 6' $QARGS | filter_xfs_quota
>  
>  echo "### recursively clear the project"
> -xfs_quota -c 'project -C 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
> +$XFS_QUOTA_PROG -c 'project -C 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
>  #no output...
> -xfs_quota -c 'quota -ip 6' $QARGS | filter_xfs_quota
> +$XFS_QUOTA_PROG -c 'quota -ip 6' $QARGS | filter_xfs_quota
>  
>  status=0
>  exit
