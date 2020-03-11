Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by sandeen.net (Postfix) with ESMTP id 6B4787880
	for <sandeen@sandeen.net>; Wed, 11 Mar 2020 11:02:54 -0500 (CDT)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgCKQDh (ORCPT <rfc822;sandeen@sandeen.net>);
        Wed, 11 Mar 2020 12:03:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36262 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729704AbgCKQDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 12:03:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BG2OMB160790;
        Wed, 11 Mar 2020 16:03:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=M/KQjwlzCDHF1MBG/tO2Ff/kwZm9deYsF6NCeEoHsWM=;
 b=gETXdtndpznuIqhgKw++bK+D7UNiyaY3c2ff66P4okZ9+rp4/i08LwboBUza1d5iAn+F
 8yOt+ewS5C5IQ8+J+x+QlB4Pyn2d9jAgGgYyxHDTbmnBokMEwU+JyiBhlRQqhzaJypW+
 DWjaCeSFm1uX3xNOq0rolY3Ch9uNGz+um40T8nWQe/A725qHvXg+VG1+7W54gmwuWTHu
 OsRnIdmUA9A/O3mc6S2clG/cAz+ZXZqsj36bBLrNHNRpSgZ81r0sxrDLqNIYFT/3mV6c
 EobJtjCQJBxPhcUdbY//caWGxIypVw5UKg9qTWHTJSJEBvZy9apl0Y+L8IzQ7Hm9V+Fq Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yp9v67rwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 16:03:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BG24u4082148;
        Wed, 11 Mar 2020 16:03:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ypv9vfymm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 16:03:31 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02BG3TXK018177;
        Wed, 11 Mar 2020 16:03:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 09:03:29 -0700
Date:   Wed, 11 Mar 2020 09:03:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2 2/2] xfs: fix xfs_rmap_has_other_keys usage of ECANCELED
Message-ID: <20200311160329.GF8045@magnolia>
References: <158388761806.939081.5340701470247161779.stgit@magnolia>
 <158388763048.939081.7269460615856522299.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388763048.939081.7269460615856522299.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110099
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In e7ee96dfb8c26, we converted all ITER_ABORT users to use ECANCELED
instead, but we forgot to teach xfs_rmap_has_other_keys not to return
that magic value to callers.  Fix it now by using ECANCELED both to
abort the iteration and to signal that we found another reverse mapping.
This enables us to drop the separate boolean flag.

Fixes: e7ee96dfb8c26 ("xfs: remove all *_ITER_ABORT values")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
v2: fix commit message per hch feedback
---
 fs/xfs/libxfs/xfs_rmap.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index ff9412f113c4..dae1a2bf28eb 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2694,7 +2694,6 @@ struct xfs_rmap_key_state {
 	uint64_t			owner;
 	uint64_t			offset;
 	unsigned int			flags;
-	bool				has_rmap;
 };
 
 /* For each rmap given, figure out if it doesn't match the key we want. */
@@ -2709,7 +2708,6 @@ xfs_rmap_has_other_keys_helper(
 	if (rks->owner == rec->rm_owner && rks->offset == rec->rm_offset &&
 	    ((rks->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rks->flags)
 		return 0;
-	rks->has_rmap = true;
 	return -ECANCELED;
 }
 
@@ -2731,7 +2729,7 @@ xfs_rmap_has_other_keys(
 	int				error;
 
 	xfs_owner_info_unpack(oinfo, &rks.owner, &rks.offset, &rks.flags);
-	rks.has_rmap = false;
+	*has_rmap = false;
 
 	low.rm_startblock = bno;
 	memset(&high, 0xFF, sizeof(high));
@@ -2739,11 +2737,12 @@ xfs_rmap_has_other_keys(
 
 	error = xfs_rmap_query_range(cur, &low, &high,
 			xfs_rmap_has_other_keys_helper, &rks);
-	if (error < 0)
-		return error;
+	if (error == -ECANCELED) {
+		*has_rmap = true;
+		return 0;
+	}
 
-	*has_rmap = rks.has_rmap;
-	return 0;
+	return error;
 }
 
 const struct xfs_owner_info XFS_RMAP_OINFO_SKIP_UPDATE = {

