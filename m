Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19467C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 23:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB20560EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 23:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhGVWgd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 18:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232024AbhGVWgd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 18:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97D9A60E8F;
        Thu, 22 Jul 2021 23:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626995827;
        bh=VDT6CE/ocFpJnwX/7ZMqhTJy5zy3h3rbipVZOdNkKcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fY71zypO1tX3Put+nV+ROZjv5CxmTRCrEYyokVQExQbPoq45Ynz1LqjD7gfsq6CiV
         JB51dqmwxwnPi2mCyC4QsD3snvwrTEp2gZ0EHKm6qzyT+MiYDlsJ//eifHY1PFIP6T
         9jHmxhvz5xyk8JJPHbnqGr7r7+9+/dGDmBLR50OLWrDHQ7nBnmtI9gl2z+60XoaGYx
         L0suYUpVKRAmWVwz1V5XawRUqwqgSZFbZY/xjIBSISl70TKOK+dShEJbOhzeihHS61
         j4MBqz5o7x04SOmRcEKZyav1H8BtPE7mjBtNBkQrOj0N0hkepp8Dfs5ldpwlxFl50N
         j5h4PzulEYx+Q==
Date:   Thu, 22 Jul 2021 16:17:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: use $XFS_QUOTA_PROG instead of hardcoding
 xfs_quota
Message-ID: <20210722231707.GQ559212@magnolia>
References: <20210722073832.976547-1-hch@lst.de>
 <20210722073832.976547-8-hch@lst.de>
 <20210722182514.GE559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722182514.GE559212@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 11:25:14AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 22, 2021 at 09:38:32AM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Nice!!
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

OFC now that I applied it I noticed that you forgot xfs/107.

--D

diff --git a/tests/xfs/107 b/tests/xfs/107
index ce131a77..da052290 100755
--- a/tests/xfs/107
+++ b/tests/xfs/107
@@ -85,17 +85,17 @@ $FSSTRESS_PROG -z -s 47806 -m 8 -n 500 -p 4 \
 QARGS="-x -D $tmp.projects -P /dev/null $SCRATCH_MNT"
 
 echo "### initial report"
-xfs_quota -c 'quot -p' -c 'quota -ip 6' $QARGS | filter_xfs_quota
+$XFS_QUOTA_PROG -c 'quot -p' -c 'quota -ip 6' $QARGS | filter_xfs_quota
 
 echo "### check the project, should give warnings"
-xfs_quota -c 'project -c 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
+$XFS_QUOTA_PROG -c 'project -c 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
 
 echo "### recursively setup the project"
-xfs_quota -c 'project -s 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
-xfs_quota -c 'quota -ip 6' $QARGS | filter_xfs_quota
+$XFS_QUOTA_PROG -c 'project -s 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
+$XFS_QUOTA_PROG -c 'quota -ip 6' $QARGS | filter_xfs_quota
 
 echo "### check the project, should give no warnings now"
-xfs_quota -c 'project -c 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
+$XFS_QUOTA_PROG -c 'project -c 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
 
 echo "### deny a hard link - wrong project ID"
 rm -f $SCRATCH_MNT/outer $target/inner
@@ -107,7 +107,7 @@ if [ $? -eq 0 ]; then
 else
 	echo hard link failed
 fi
-xfs_quota -c 'quota -ip 6' $QARGS | filter_xfs_quota
+$XFS_QUOTA_PROG -c 'quota -ip 6' $QARGS | filter_xfs_quota
 
 echo "### allow a hard link - right project ID"
 $XFS_IO_PROG -c 'chproj 6' $SCRATCH_MNT/outer
@@ -118,12 +118,12 @@ else
 	echo hard link failed
 	ls -ld $SCRATCH_MNT/outer $target/inner
 fi
-xfs_quota -c 'quota -ip 6' $QARGS | filter_xfs_quota
+$XFS_QUOTA_PROG -c 'quota -ip 6' $QARGS | filter_xfs_quota
 
 echo "### recursively clear the project"
-xfs_quota -c 'project -C 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
+$XFS_QUOTA_PROG -c 'project -C 6' $QARGS | LC_COLLATE=POSIX sort | filter_xfs_quota
 #no output...
-xfs_quota -c 'quota -ip 6' $QARGS | filter_xfs_quota
+$XFS_QUOTA_PROG -c 'quota -ip 6' $QARGS | filter_xfs_quota
 
 status=0
 exit
