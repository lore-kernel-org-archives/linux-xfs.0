Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D274C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC1F620706
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oy1ROjM7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389070AbgFYBSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:18:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388942AbgFYBSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:18:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P17hud082296;
        Thu, 25 Jun 2020 01:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=pfy6lR2OXDMssL28IJMvNeyzJBwVUI30Bi8/x5M0EKw=;
 b=oy1ROjM7YM/QtCxV6p3WIOZJlWE3cT1y4xaoSq0TSMeC2sd1/LdgfeO5+atujgeVw4zK
 j+sHFJxZPPV7gYyTKHdoU2cRkROLVxaRdqgisdkhsmIqjg6Hou5GLfGb2zBG3ddOdkiK
 tlv6DKDB7QKS1sMDpRao5/1NOSoUM5uziOqPhKZOZjdJPs4M2coxVL4pE99KCZ85iuuq
 XTdE2n8FwHkZHY/DN5cnmTUp80N9EI2nvhe07Fyy1XP/HlE9D7VRX4ANKf7SdcO5UJh1
 WPLS26Seb6RJ7UucXY2T4E2kPMDxiZ6+VKBAHIG5RzGN0XKqOeLZkmr8GlSZc7mbEyST fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31uut5nuyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:18:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P19Lqs009150;
        Thu, 25 Jun 2020 01:16:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31uurrnmst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:16:45 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05P1GiwJ012605;
        Thu, 25 Jun 2020 01:16:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:16:44 +0000
Date:   Wed, 24 Jun 2020 18:16:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH v4] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200625011643.GJ7625@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=1
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The data fork scrubber calls filemap_write_and_wait to flush dirty pages
and delalloc reservations out to disk prior to checking the data fork's
extent mappings.  Unfortunately, this means that scrub can consume the
EIO/ENOSPC errors that would otherwise have stayed around in the address
space until (we hope) the writer application calls fsync to persist data
and collect errors.  The end result is that programs that wrote to a
file might never see the error code and proceed as if nothing were
wrong.

xfs_scrub is not in a position to notify file writers about the
writeback failure, and it's only here to check metadata, not file
contents.  Therefore, if writeback fails, we should stuff the error code
back into the address space so that an fsync by the writer application
can pick that up.

Fixes: 99d9d8d05da2 ("xfs: scrub inode block mappings")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v4: remove if block that only had a gigantic comment
v3: don't play this game where we clear the mapping error only to re-set it
v2: explain why it's ok to keep going even if writeback fails
---
 fs/xfs/scrub/bmap.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7badd6dfe544..955302e7cdde 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -45,9 +45,27 @@ xchk_setup_inode_bmap(
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
 	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
+		struct address_space	*mapping = VFS_I(sc->ip)->i_mapping;
+
 		inode_dio_wait(VFS_I(sc->ip));
-		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
-		if (error)
+
+		/*
+		 * Try to flush all incore state to disk before we examine the
+		 * space mappings for the data fork.  Leave accumulated errors
+		 * in the mapping for the writer threads to consume.
+		 *
+		 * On ENOSPC or EIO writeback errors, we continue into the
+		 * extent mapping checks because write failures do not
+		 * necessarily imply anything about the correctness of the file
+		 * metadata.  The metadata and the file data could be on
+		 * completely separate devices; a media failure might only
+		 * affect a subset of the disk, etc.  We can handle delalloc
+		 * extents in the scrubber, so leaving them in memory is fine.
+		 */
+		error = filemap_fdatawrite(mapping);
+		if (!error)
+			error = filemap_fdatawait_keep_errors(mapping);
+		if (error && (error != -ENOSPC && error != -EIO))
 			goto out;
 	}
 
