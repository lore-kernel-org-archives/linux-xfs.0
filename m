Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F9BC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA6142189D
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k+ld77dc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbfHZVbi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:31:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbfHZVbi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:31:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLElSn161898;
        Mon, 26 Aug 2019 21:31:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=3CNZ9YyYt92xEwH/THf1ZEoalA/EolQF17uPAhtkRkM=;
 b=k+ld77dcEhirAjpYaqf1xMMD80W0yqxNQCSdKTU4/7hhlRRWBDx28nHvvsFQoPugjUPS
 o2NZURH1gAszYtw8M1rtBrvnJ017Syk5z0Kj3MoIq7dcTatPHBq9KeRJ3x2lkMZMATTF
 HFjR87Qy30mid15Qh4vwbzaWZ/tlyIPzHq2wEDjhY3kxra4j0dx+ku1J2IKAgykk2qIX
 Mb0lK0aq/OwooMRgsnLpzZumwykeO2SRLPJ44THhqy4k2FfCfkwxBXpWwh8pSvZ7JocJ
 FIRabTiPc6KETYngR9rmdykW0JnOwGz9dUx/yTfx5C2dxoajXHDIjbNgP8XVc57PdmF5 FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t82cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIMal170042;
        Mon, 26 Aug 2019 21:31:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2umj2789xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:35 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLVZFg030229;
        Mon, 26 Aug 2019 21:31:35 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:31:34 -0700
Subject: [PATCH 04/11] xfs_scrub: improve reporting of file metadata media
 errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:31:33 -0700
Message-ID: <156685509389.2843133.9738555995561268153.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Report media errors that map to data and attr fork extent maps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index a83fffdd..d6688418 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -385,6 +385,17 @@ xfs_check_rmap_error_report(
 		str_error(ctx, buf, _("media error in %s."), type);
 	}
 
+	/* Report extent maps */
+	if (map->fmr_flags & FMR_OF_EXTENT_MAP) {
+		bool		attr = (map->fmr_flags & FMR_OF_ATTR_FORK);
+
+		xfs_scrub_render_ino_suffix(ctx, buf, DESCR_BUFSZ,
+				map->fmr_owner, 0, " %s",
+				attr ? _("extended attribute") :
+				       _("file data"));
+		str_error(ctx, buf, _("media error in extent map"));
+	}
+
 	/*
 	 * XXX: If we had a getparent() call we could report IO errors
 	 * efficiently.  Until then, we'll have to scan the dir tree

