Return-Path: <SRS0=pdRq=4R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3DBC3F2D1
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 01:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81F4D246AE
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 01:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y9u8rF6s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgB2BtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 20:49:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40534 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgB2BtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 20:49:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1hYlP146755
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kw3Hqq5GvfrsliriH4RZOH3WhAHMYv7zSEGLPr92iqM=;
 b=Y9u8rF6shW2qTD78qe7UcfZfb46NmJggBgcELMSqc4D4Fk/vMODtJWhRnhmizkttoPL3
 aHu1pWGm9L/eRJsDzJd3ijwEY5wziGejRP+RS+HoaLbbZjP0xMifIKRmozvU1kb8/el5
 Kib6UyzKtb0ylpdvHEV7HUTu3hyEUiZQJlQy4t1WAPYthjDbDhI1vh8xp5oXSiENesDJ
 IF/s3i9yLlLcuHYDvuOip2U6lN1NmWI6En0r5bLJDLjX99wUFb3opFDu9uvZmaamX5/0
 XKl9xQ2Wl6rbg00uyhTgMGpuZjJtFhIJSfrGPG8reHQpTOOKzGJ3cG82X7fGtQ1HFtzi xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ydcsnx732-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1gtf2165374
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yfe0d1qv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01T1nA4V020522
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 17:49:10 -0800
Subject: [PATCH 1/3] xfs: mark dir corrupt when lookup-by-hash fails
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Feb 2020 17:49:09 -0800
Message-ID: <158294094977.1730101.1658645036964056566.stgit@magnolia>
In-Reply-To: <158294094367.1730101.10848559171120744339.stgit@magnolia>
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=825 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=891 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xchk_dir_actor, we attempt to validate the directory hash structures
by performing a directory entry lookup by (hashed) name.  If the lookup
returns ENOENT, that means that the hash information is corrupt.  The
_process_error functions don't catch this, so we have to add that
explicitly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 266da4e4bde6..54afa75c95d1 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -155,6 +155,11 @@ xchk_dir_actor(
 	xname.type = XFS_DIR3_FT_UNKNOWN;
 
 	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
+	if (error == -ENOENT) {
+		/* ENOENT means the hash lookup failed and the dir is corrupt */
+		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+		return -EFSCORRUPTED;
+	}
 	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;

