Return-Path: <SRS0=pOan=AF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCAAC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 03:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F242070E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 03:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JP/RUrsu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388603AbgFXDxk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 23:53:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388464AbgFXDxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 23:53:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O3lqOF174422;
        Wed, 24 Jun 2020 03:53:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=eXm6pvibMOeAtvfKOsfN46qVqrdW6gFvpscf3VesszQ=;
 b=JP/RUrsuA/3Ec60V48+oyyyWzTnz4Y1FtiIch60MeHtWIrvZZk/5JiCtqyNNX+GK+/QO
 UwRZ3O93pLlfUapEFAK8IY06NvXdYIGHcbIGmVWxVPuDgf+dRjOoXjuCPFZ4d7qxJs/H
 FaF0X8AUkj+pQYWN/CBuG4vcHv6JZpYvk8VzgAhaKoYX0rUqBvAoqwQAT/OqFeVNX5DX
 EhQiZ1zanEKCAVoBNYVqz8SayNt+j8tRctoo2GbO29wqNe/IBN3qSFNzIYcZ3J9sNtFt
 GE5JJ0mFaVfysEH5HwnfDJHRh+s4H8RArfLaCdTB76rtw4XASycIykIWcNM0+KRJ/pVH Ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31uustgh4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 03:53:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O3lnNQ134281;
        Wed, 24 Jun 2020 03:51:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31uuqy67sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 03:51:35 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05O3pYUW025765;
        Wed, 24 Jun 2020 03:51:35 GMT
Received: from localhost (/10.159.232.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 03:51:34 +0000
Date:   Tue, 23 Jun 2020 20:51:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH v3] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200624035133.GH7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=1 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006240026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=1 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006240026
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
v3: don't play this game where we clear the mapping error only to re-set it
v2: explain why it's ok to keep going even if writeback fails
---
 fs/xfs/scrub/bmap.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7badd6dfe544..c4c2477a94ae 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -45,9 +45,30 @@ xchk_setup_inode_bmap(
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
+		 */
+		error = filemap_fdatawrite(mapping);
+		if (!error)
+			error = filemap_fdatawait_keep_errors(mapping);
+		if (error == -ENOSPC || error == -EIO) {
+			/*
+			 * On ENOSPC or EIO writeback errors, we continue into
+			 * the extent mapping checks because write failures do
+			 * not necessarily imply anything about the correctness
+			 * of the file metadata.  The metadata and the file
+			 * data could be on completely separate devices; a
+			 * media failure might only affect a subset of the
+			 * disk, etc.  We can handle delalloc extents in the
+			 * scrubber, so leaving them in memory is fine.
+			 */
+		} else if (error)
 			goto out;
 	}
 
