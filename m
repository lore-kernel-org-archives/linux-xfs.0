Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EF0C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 16:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A6AC20874
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 16:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VJPmT++7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfHZQek (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 12:34:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfHZQej (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 12:34:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QGOFQQ096977
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 16:34:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=jYQFU8EzWaxpwygxr5rogGraxTd82XOYl2RromH+q0I=;
 b=VJPmT++7twPUg8d9YqJMz0+KrCgXNkYfTDO6UUB2PBYt4xn1tBGVUWzF6LBAZ8Xag+Sz
 HNaGJQ8dyU8jo+W6YKspIYi8TXkPYuMucdROnmkN/bG0X2so8nB99djlBWHjG/yXKvXZ
 ww3PHVTqpIW5mL9oy5McCFvQNJZOeWcyc5FYiFPQtFT1RDCgGnAkYdwCPbe/U30OUnHy
 eUToo55K6SHCULFLJ72hk6lJQAvgXW7+pvMtJg6ZtlLlZQNeLgwTmAVN4curoLLYHGC6
 dCMtD/Iq9uMIdkkJ6HNQy3sU7YL2GPvHY45C0aYj9EFBJd9Kaftd8Y3VDJlKT+5ywVXM RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umjjqr794-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 16:34:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QGO3Il193961
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 16:34:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2umj26u8xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 16:34:37 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QGYbMi024183
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 16:34:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 09:34:36 -0700
Date:   Mon, 26 Aug 2019 09:34:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix maxicount division by zero error
Message-ID: <20190826163436.GO1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_ialloc_setup_geometry, it's possible for a malicious/corrupt fs
image to set an unreasonably large value for sb_inopblog which will
cause ialloc_blks to be zero.  If sb_imax_pct is also set, this results
in a division by zero error in the second do_div call.  Therefore, force
maxicount to zero if ialloc_blks is zero.

Note that the kernel metadata verifiers will catch the garbage inopblog
value and abort the fs mount long before it tries to set up the inode
geometry; this is needed to avoid a crash in xfs_db while setting up the
xfs_mount structure.

Found by fuzzing sb_inopblog to 122 in xfs/350.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1a14067aa4d4..5e95648c346c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2811,7 +2811,7 @@ xfs_ialloc_setup_geometry(
 			inodes);
 
 	/* Set the maximum inode count for this filesystem. */
-	if (sbp->sb_imax_pct) {
+	if (sbp->sb_imax_pct && igeo->ialloc_blks) {
 		/*
 		 * Make sure the maximum inode count is a multiple
 		 * of the units we allocate inodes in.
