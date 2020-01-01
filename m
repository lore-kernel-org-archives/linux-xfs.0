Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0921C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 938312072A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:01:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D98kE1oM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgAABBd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:01:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47708 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbgAABBd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:01:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010x7AB083286;
        Wed, 1 Jan 2020 01:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oFSOsY8I+PnatbzfX1cwBS0pQc8hw8tpMm3eF8ArcAo=;
 b=D98kE1oMsZiSeKwo5CLP5wwTNjY+ZWXJRm+I9EXsGPQMN/wyTTdVmTb780pOj32v99Wi
 TidFQF5esRnsHqmckynL/NJ1t9ynX9ce8SsIRPQq+1NSsnfHyh1AQzduOLc8cvJSbY2b
 WPiniLM8HtIodUZ0F1rYI5snZv18RpFCtBhziyqbV0946iERwPS4YhLywuGCCL62b87y
 05ZtUFHZ8PKM5Yg7yKk2dQ9b07Auxm6HGsR7nZ/6f1cNUtK4wFpuDH52qdK7ZW6WtdHy
 2AnmV1oX2JOYih982Thm0N1di4NfGSY42+w6YJdNk6codb01hfxspV/88wleFDoURKEP yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:01:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010x2iJ154798;
        Wed, 1 Jan 2020 01:01:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2x8gj910cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:01:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00111Qnw002683;
        Wed, 1 Jan 2020 01:01:27 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:01:26 -0800
Subject: [PATCH 1/3] xfs: xrep_reap_extents should not destroy the bitmap
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Date:   Tue, 31 Dec 2019 17:01:24 -0800
Message-ID: <157784048460.1357430.2294347936319130263.stgit@magnolia>
In-Reply-To: <157784047838.1357430.18292934559846279176.stgit@magnolia>
References: <157784047838.1357430.18292934559846279176.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the xfs_bitmap_destroy call from the end of xrep_reap_extents
because this sort of violates our rule that the function initializing a
structure should destroy it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 fs/xfs/scrub/repair.c          |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 7a1a38b636a9..8fcd43040c96 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -698,7 +698,7 @@ xrep_agfl(
 		goto err;
 
 	/* Dump any AGFL overflow. */
-	return xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
+	error = xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
 			XFS_AG_RESV_AGFL);
 err:
 	xfs_bitmap_destroy(&agfl_extents);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index b70a88bc975e..3a58788e0bd8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -613,11 +613,9 @@ xrep_reap_extents(
 
 		error = xrep_reap_block(sc, fsbno, oinfo, type);
 		if (error)
-			goto out;
+			break;
 	}
 
-out:
-	xfs_bitmap_destroy(bitmap);
 	return error;
 }
 

