Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EEDC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB8B8217F5
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pdf6hLhf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfHZVtK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:49:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41890 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfHZVtK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:49:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLiJVk185176;
        Mon, 26 Aug 2019 21:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=NSLXMo08ShW+H1eBhwOYZSXglIzBA2hXyxQTJdpKsO8=;
 b=Pdf6hLhfRyi4NzKjm0nrleeBmMEUY2qtEdjNLThsyuqMl6wd1DndkKYOShGwaf0B6v60
 VTfPfkjYuRxO/WfokRj0JlJomYcz6xZLFii/0hJDMQcCQ/hVniC9O7q8chdjC9BUPgqH
 Am/0MnZvc/u8VI3jzXuyjBKz6g6Ca0GMDO41crgtlaVRYb8cgMCZEVzmUNsHtuaJ1Epm
 vIxLmFeY+tAkl/Ve4DuRGrCUHzcwuho7mMvFRbKQ9TQdssDM0ZOmO5rbHTI8/eAahhNw
 IWRGsnGyBjdw1EavPp68qv2xneLAM+5HZ3o4E529q+SXs41EttVbftIYjmM3IIot6txs gA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2umq5t84pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:48:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLmC4Q035947;
        Mon, 26 Aug 2019 21:48:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2umhu7xdn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:48:58 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLmvdp008125;
        Mon, 26 Aug 2019 21:48:57 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:48:57 -0700
Subject: [PATCH 2/4] xfs: fix maxicount division by zero error
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 26 Aug 2019 14:48:56 -0700
Message-ID: <156685613618.2853532.3571584792178437139.stgit@magnolia>
In-Reply-To: <156685612356.2853532.10960947509015722027.stgit@magnolia>
References: <156685612356.2853532.10960947509015722027.stgit@magnolia>
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
 definitions=main-1908260201
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
index 04377ab75863..aa190a502326 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2788,7 +2788,7 @@ xfs_ialloc_setup_geometry(
 			inodes);
 
 	/* Set the maximum inode count for this filesystem. */
-	if (sbp->sb_imax_pct) {
+	if (sbp->sb_imax_pct && igeo->ialloc_blks) {
 		/*
 		 * Make sure the maximum inode count is a multiple
 		 * of the units we allocate inodes in.

