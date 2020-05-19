Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510F6C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2715E20578
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WHGArEZq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgESAwb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 20:52:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60736 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgESAwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 20:52:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0l3ic144873;
        Tue, 19 May 2020 00:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QLZ+5BIOrivyTEWNJEHDfDPxqgV+I3kUiRR6MOj6GWQ=;
 b=WHGArEZqWrTPSNdTCwx2HSx/RQSU15s2d9jLDt4aUtZwZ3HB/sIVNB0sm4XXo8jLKp4M
 dDEpDD15oLmh1PntC+6ACWvgsX8ayoJmptFznAPoZv7nZ81QWl/YEo0alPxQTFKrVDvp
 oN+29HDCTF34KY4o7XkHOjQN+q92Nzry1r4SO3gOvfc4IyyGgYlFNdhz+hbrf8lHf4k3
 GGaXYF9IUPLcFUPeNtuZIf2UtOTq6TZVPdQ3wba0C3beNMkoad1I965AD90GGu3OIi0Y
 n5fJ0XZy0b2RiYsssIZwqH7k7u4xbdeobEoCZ8D5C5MrjbLi6jb7BXTnWzHA9gF/aHMl Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127kr2707-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 00:52:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0gv0G045911;
        Tue, 19 May 2020 00:52:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312t32k5ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 00:52:28 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04J0qQUA002487;
        Tue, 19 May 2020 00:52:27 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 17:52:26 -0700
Subject: [PATCH 2/3] xfs_db: fix rdbmap_boundscheck
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 May 2020 17:52:23 -0700
Message-ID: <158984954380.623441.11000410439582315428.stgit@magnolia>
In-Reply-To: <158984953155.623441.15225705949586714685.stgit@magnolia>
References: <158984953155.623441.15225705949586714685.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This predicate should check the a rt block number against number of
rtblocks, not the number of AG blocks.  Ooops.

Fixes: 7161cd21b3ed ("xfs_db: bounds-check access to the dbmap array")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/db/check.c b/db/check.c
index c6fce605..12c03b6d 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1490,7 +1490,7 @@ static inline bool
 rdbmap_boundscheck(
 	xfs_rfsblock_t	bno)
 {
-	return bno < mp->m_sb.sb_agblocks;
+	return bno < mp->m_sb.sb_rblocks;
 }
 
 static void

