Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C518C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1862B2072C
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PZwzPrXx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgESAtZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 20:49:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59180 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgESAtZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 20:49:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0l4d1144876;
        Tue, 19 May 2020 00:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=e+hR/OBeuw9R4ZaZ29O4B/39n7TlbQkoxTCaAWlSAgc=;
 b=PZwzPrXxCHGNpLvSOcTa03QQw9RPuvuJPffmcUwu1CKMHmzy2pYVVF8rQyE3islXUFaU
 NlsKv+9FbyvvkgerziGjtQy0Ue5T3LoFRh/aXT5xegWfznzNWBmhexzhDjOD1gbcj7pj
 1Y/UECo/YLujqJXXBCRrQHED2/tks5EAFjbGSc4PQTPRjU7czOjxvXpznhI51D7fsrF/
 fzc/TLk4m1IX0OIJbmZNnPeurEdWYEWtsjOmFB56MXHbqt20QPxtx09i5WA9togzRADI
 /JwgkcrMQkAKiVH/9/JTc2NoTnUlTyVfWq5Tq6bS0MaUoJN6CmiC6wCiMyIsS66/kUoc fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127kr26t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 00:49:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0h41C142472;
        Tue, 19 May 2020 00:49:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 312sxrjj1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 00:49:20 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04J0nJAu014523;
        Tue, 19 May 2020 00:49:20 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 17:49:19 -0700
Subject: [PATCH 2/3] xfs: don't fail unwritten extent conversion on writeback
 due to edquot
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Date:   Mon, 18 May 2020 17:49:17 -0700
Message-ID: <158984935767.619853.515097571114256885.stgit@magnolia>
In-Reply-To: <158984934500.619853.3585969653869086436.stgit@magnolia>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During writeback, it's possible for the quota block reservation in
xfs_iomap_write_unwritten to fail with EDQUOT because we hit the quota
limit.  This causes writeback errors for data that was already written
to disk, when it's not even guaranteed that the bmbt will expand to
exceed the quota limit.  Irritatingly, this condition is reported to
userspace as EIO by fsync, which is confusing.

We wrote the data, so allow the reservation.  That might put us slightly
above the hard limit, but it's better than losing data after a write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index bb590a267a7f..ac970b13b1f8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -563,7 +563,7 @@ xfs_iomap_write_unwritten(
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS);
+				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
 		if (error)
 			goto error_on_bmapi_transaction;
 

