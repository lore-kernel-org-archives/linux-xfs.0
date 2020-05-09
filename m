Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB70C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B8412063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IA9TNS8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgEIQba (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:31:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50046 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:31:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgWi072358;
        Sat, 9 May 2020 16:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=93kcITJPBGmsmP93nLZWoLRoycKunbQGeMuqK6ma1p0=;
 b=IA9TNS8eizA0NChTk4wHpIvZHB/stxG8LUZtPOn4op8woe9VZV1zppe59A4uFn0nFmaZ
 PN4fir0ykVVwlBFZ9y/pUfYQJ7zOYCCtK3S2ICnmr9i04StlFpV1moc7gNlgLdJbX79i
 bkg4+eniQrB/9QM1hKMQ1+WICEkRKhR7oFW0KLTWwqQG6C/BC5albWVcIQBuFUNbQ7Ae
 o6MvttgLc1rt4LsAATObH62rP2fllhcc/VUCGCVQnOJP9qvMt9F8GokTfX6pFBGFZDf0
 mvebmt7JO7pAeY+uesQcp16kw/Er4z9j8t6zNLGanOnHJbiEdMl1g+AG+lbM3hAbH8y/ UQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30wkxqs6fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTIVU097742;
        Sat, 9 May 2020 16:31:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30wx18589h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GVQpI026021;
        Sat, 9 May 2020 16:31:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:31:26 -0700
Subject: [PATCH 14/16] xfs_repair: complain about free space only seen by one
 btree
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:31:26 -0700
Message-ID: <158904188639.982941.5408652247371014933.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=2 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=2 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During the free space btree walk, scan_allocbt claims in a comment that
we'll catch FREE1 blocks (i.e. blocks that were seen by only one free
space btree) later.  This never happens, with the result that xfs_repair
in dry-run mode can return 0 on a filesystem with corrupt free space
btrees.

Found by fuzzing xfs/358 with numrecs = middlebit (or sub).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 8197db06..a43413c7 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -306,6 +306,12 @@ phase4(xfs_mount_t *mp)
 		for (j = ag_hdr_block; j < ag_end; j += blen)  {
 			bstate = get_bmap_ext(i, j, ag_end, &blen);
 			switch (bstate) {
+			case XR_E_FREE1:
+				if (no_modify)
+					do_warn(
+	_("free space (%u,%u-%u) only seen by one free space btree\n"),
+						i, j, j + blen - 1);
+				break;
 			case XR_E_BAD_STATE:
 			default:
 				do_warn(
@@ -313,7 +319,6 @@ phase4(xfs_mount_t *mp)
 					i, j);
 				/* fall through .. */
 			case XR_E_UNKNOWN:
-			case XR_E_FREE1:
 			case XR_E_FREE:
 			case XR_E_INUSE:
 			case XR_E_INUSE_FS:

