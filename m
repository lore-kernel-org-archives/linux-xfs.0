Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555B2C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 03:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FD78206C3
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 03:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vV5b8110"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbgFWDuQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 23:50:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60224 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731216AbgFWDuP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 23:50:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N3lwGw038490;
        Tue, 23 Jun 2020 03:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=wI4udoOjxO4JQF5BOhRnQJMdH1tNXqjBvozsxHVU4Nw=;
 b=vV5b81102n1Y9fSM9u3KcpqLox8ZqRbw2db9lPHF3eHsFO4dpgwNmen9xTOKgJfIrw/G
 22YZvNmVK7LWQdkoOP/p9kDbva5+FLkI+noeqaYp2MIFWmzpx1bEn8TOjuUgbc9z5Ln/
 CBuQ53clkbY+9/EHy29Mbj+fUwz4u03PIreeEg4Yx/2KLBPVKZe+82ujFtJz3E5COIWg
 YzQGYXEihfCaNN1vj7IG8vAi8tNrX8s9VC2WGdLgzPBFmz2bBw7GxaWQVLGehaYIbcjB
 PTtExEl8HDqM7EYwJMsJN8fp/yMGuiDDtGM2SmXt29/NzY6hnkOCQ7SqjYtar32eQx2G DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31sebbat11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 03:50:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N3h6Kf035409;
        Tue, 23 Jun 2020 03:50:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31svcw351k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 03:50:12 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05N3oB5h015400;
        Tue, 23 Jun 2020 03:50:11 GMT
Received: from localhost (/10.159.143.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 03:50:11 +0000
Date:   Mon, 22 Jun 2020 20:50:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200623035010.GF7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=1 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230026
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
v2: explain why it's ok to keep going even if writeback fails
---
 fs/xfs/scrub/bmap.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7badd6dfe544..0d7062b7068b 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -47,7 +47,24 @@ xchk_setup_inode_bmap(
 	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
 		inode_dio_wait(VFS_I(sc->ip));
 		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
-		if (error)
+		if (error == -ENOSPC || error == -EIO) {
+			/*
+			 * If writeback hits EIO or ENOSPC, reflect it back
+			 * into the address space mapping so that a writer
+			 * program calling fsync to look for errors will still
+			 * capture the error.
+			 *
+			 * However, we continue into the extent mapping checks
+			 * because write failures do not necessarily imply
+			 * anything about the correctness of the file metadata.
+			 * The metadata and the file data could be on
+			 * completely separate devices; a media failure might
+			 * only affect a subset of the disk, etc.  We properly
+			 * account for delalloc extents, so leaving them in
+			 * memory is fine.
+			 */
+			mapping_set_error(VFS_I(sc->ip)->i_mapping, error);
+		} else if (error)
 			goto out;
 	}
 
