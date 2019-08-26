Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C28C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A03A21872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aN5xBnaz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfHZVtZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:49:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56580 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfHZVtZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:49:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLnOeB029770
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RvqUY8BAyRZB5unJVsNmg6poEk1YiCcoAKPxRUmuYCU=;
 b=aN5xBnazBhnlsIm0LLlqdWCH7OBYnhwRLnC1xEqzpyMKfx0/QfK6MJ6ZWyazF41dS9Ex
 X7HjZ41xpcN8uqKyueTsf9Fm7VGxJVMq4qYS0yObh3WM4hFj/TF0M6+1j5pSyxky9y5f
 qAxTBzcDTpKMHN4YdGOR3lohspP683qx7F7hWhi9XrGtBfukDzHeePZMxmBGJu55yq2h
 thKc/9Wg0O2lK8oNpEXi6YE/LC136o1dS7yPGy9/nhlmjgeSmLX4gb4GXnayDD12hd+s
 sISOC7yizirs9FM3NXb+yBJhQ6PxpHGOexLCnyLZHzg7NCnGxlBnQWUBoNQ7yBt0uVob lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2umpxx0822-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLmVKs041905
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2umj278rep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:23 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLnMF4019234
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:22 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:49:22 -0700
Subject: [PATCH 1/5] xfs: remove unnecessary parameter from xfs_iext_inc_seq
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:49:19 -0700
Message-ID: <156685615976.2853674.6448514440230390454.stgit@magnolia>
In-Reply-To: <156685615360.2853674.5160169873645196259.stgit@magnolia>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260202
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This function doesn't use the @state parameter, so get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_iext_tree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 27aa3f2bc4bc..7bc87408f1a0 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -616,7 +616,7 @@ xfs_iext_realloc_root(
  * sequence counter is seen before the modifications to the extent tree itself
  * take effect.
  */
-static inline void xfs_iext_inc_seq(struct xfs_ifork *ifp, int state)
+static inline void xfs_iext_inc_seq(struct xfs_ifork *ifp)
 {
 	WRITE_ONCE(ifp->if_seq, READ_ONCE(ifp->if_seq) + 1);
 }
@@ -633,7 +633,7 @@ xfs_iext_insert(
 	struct xfs_iext_leaf	*new = NULL;
 	int			nr_entries, i;
 
-	xfs_iext_inc_seq(ifp, state);
+	xfs_iext_inc_seq(ifp);
 
 	if (ifp->if_height == 0)
 		xfs_iext_alloc_root(ifp, cur);
@@ -875,7 +875,7 @@ xfs_iext_remove(
 	ASSERT(ifp->if_u1.if_root != NULL);
 	ASSERT(xfs_iext_valid(ifp, cur));
 
-	xfs_iext_inc_seq(ifp, state);
+	xfs_iext_inc_seq(ifp);
 
 	nr_entries = xfs_iext_leaf_nr_entries(ifp, leaf, cur->pos) - 1;
 	for (i = cur->pos; i < nr_entries; i++)
@@ -983,7 +983,7 @@ xfs_iext_update_extent(
 {
 	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
 
-	xfs_iext_inc_seq(ifp, state);
+	xfs_iext_inc_seq(ifp);
 
 	if (cur->pos == 0) {
 		struct xfs_bmbt_irec	old;

