Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C97CC2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 18:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4CB12220D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 18:24:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bKi+xBDG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgIWSYn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 14:24:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57848 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWSYn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 14:24:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NI8m7O016847;
        Wed, 23 Sep 2020 18:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=goBYjx1igozNwouTP+qmSzB5jrSnNnpjJfH0YYfo72k=;
 b=bKi+xBDGKRi0A8F2Mq7FN5DXQBTjC4DNQqgBIicq5j7qlLhg2eKxcwxf4MZvW+ih2wUq
 ODp+rKk45I4Ln7DcvujcVXZaAxa7PRLIr26TliamjocmnIc+LJVsLRiffMoTUaKctisr
 0V2z4BZKkN2fJkXUdm5XWfhY/U/5B042Kq6i0C3998T8f+K2Tj7mdHOTuFzbeoG8DdLM
 a4/NI59PxZ80RyA+dl4aWIxJ8RZ5iOmLQxjUTy/CXRVqn8kNagipnku4GAeeLoHYz9s6
 dqnv1E4wDHmZaO16Q5tfNT2f+vvfqN11iKAwJiH8p6Zay+7XANSoRLyY10mekrd5jlYy Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33ndnum58n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 18:24:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NIBQsO166113;
        Wed, 23 Sep 2020 18:24:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nux1hv53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 18:24:39 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08NIOcNR022239;
        Wed, 23 Sep 2020 18:24:38 GMT
Received: from localhost (/10.159.225.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 11:24:38 -0700
Date:   Wed, 23 Sep 2020 11:24:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: coordinate parallel updates to the rt bitmap
Message-ID: <20200923182437.GW7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=5 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=5 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230138
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Actually take the rt lock before updating the bitmap from multiple
threads.  This fixes an infrequent corruption problem when running
generic/013 and rtinherit=1 is set on the root dir.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/repair/dinode.c b/repair/dinode.c
index 57013bf149b2..07f3f83aef8c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -184,6 +184,7 @@ process_rt_rec(
 	xfs_rfsblock_t		*tot,
 	int			check_dups)
 {
+	struct aglock		*lock = &ag_locks[(signed)NULLAGNUMBER];
 	xfs_fsblock_t		b, lastb;
 	xfs_rtblock_t		ext;
 	int			state;
@@ -245,6 +246,7 @@ _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
 			continue;
 		}
 
+		pthread_mutex_lock(&lock->lock);
 		state = get_rtbmap(ext);
 		switch (state)  {
 		case XR_E_FREE:
@@ -270,6 +272,7 @@ _("data fork in rt inode %" PRIu64 " found metadata block %" PRIu64 " in rt bmap
 			do_warn(
 _("data fork in rt inode %" PRIu64 " claims used rt block %" PRIu64 "\n"),
 				ino, ext);
+			pthread_mutex_unlock(&lock->lock);
 			return 1;
 		case XR_E_FREE1:
 		default:
@@ -277,6 +280,7 @@ _("data fork in rt inode %" PRIu64 " claims used rt block %" PRIu64 "\n"),
 _("illegal state %d in rt block map %" PRIu64 "\n"),
 				state, b);
 		}
+		pthread_mutex_unlock(&lock->lock);
 	}
 
 	/*
