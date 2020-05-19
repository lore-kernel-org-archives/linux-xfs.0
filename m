Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1218C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A85720578
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:54:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WbWtUo4R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgESAyY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 20:54:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgESAyX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 20:54:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0pM2k008190;
        Tue, 19 May 2020 00:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QAN6/rXCWhE+0I0saiof7BklL1bDqN23aFRnAlTx/Gk=;
 b=WbWtUo4R5eLUUvFVTWmUmJnnK+RMjW5w9acSSaW6u5p3sZXeUGfftcRswmUm5tMIovM1
 ar0IpMvZyr/JPTxijPWia/Wvn82+u8AQIeufp20uA524aCP9IxC4/i9okBTkyaHr4bDb
 GfnSBG20wS+pRRRnL6UxVC4MKSpWcKX9uLZt29Au8cQCjYQQvxTYR3aQ2MATEkJ8TDAA
 NBx1D1SmUEVUB7Qh8N2wvxBBAuqtN0WuKbEDykCOMK+dN5M36VhCHEft0bre+t8qpCWx
 8KoM3mgShfYi4h3lirqaEiDxvdHB3cQBOZP3gwM4kjrB8DuJTHTR7mWPvCZqkPNUOVR9 hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tna33c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 00:54:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0gvPA045850;
        Tue, 19 May 2020 00:52:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t32k57e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 00:52:21 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04J0qJvt015663;
        Tue, 19 May 2020 00:52:20 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 17:52:19 -0700
Subject: [PATCH 1/3] xfs_db: don't crash if el_gets returns null
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 May 2020 17:52:17 -0700
Message-ID: <158984953767.623441.453227281468842512.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190006
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

el_gets returns NULL if it fails to read any characters (due to EOF or
errors occurred).  strdup will crash if it is fed a NULL string, so
check the return value to avoid segfaulting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/input.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)


diff --git a/db/input.c b/db/input.c
index 553025bc..448e84b0 100644
--- a/db/input.c
+++ b/db/input.c
@@ -230,14 +230,21 @@ fetchline(void)
 	}
 
 	if (inputstacksize == 1) {
-		line = xstrdup(el_gets(el, &count));
-		if (line) {
-			if (count > 0)
-				line[count-1] = '\0';
-			if (*line) {
-				history(hist, &hevent, H_ENTER, line);
-				logprintf("%s", line);
-			}
+		const char	*cmd;
+
+		cmd = el_gets(el, &count);
+		if (!cmd)
+			return NULL;
+
+		line = xstrdup(cmd);
+		if (!line)
+			return NULL;
+
+		if (count > 0)
+			line[count-1] = '\0';
+		if (*line) {
+			history(hist, &hevent, H_ENTER, line);
+			logprintf("%s", line);
 		}
 	} else {
 		line = fetchline_internal();

