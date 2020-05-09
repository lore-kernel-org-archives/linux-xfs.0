Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DA1C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FE902063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:29:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FmDrmrqm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgEIQ3m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:29:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQ3l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:29:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GOXqu065080;
        Sat, 9 May 2020 16:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nIwDCRwVIWv3dp69JUcxqKycwkrjVIvA+059UVxj2us=;
 b=FmDrmrqmXWZU+/Fb/w1mrU7tb5wy6gqB5ZANxrBGH/KJ+kP/LShSmZZMyUMhpETYdb21
 6+ZMonEKPBfnWZ6V80aFYaKkMcVd4WUtOcNP+ihcFZFVihPnYvtPcT9HfM/ehi65B4Bi
 rKTMvm4CHNkKINe/ZSTWQuG0pTmwgzRf0oQPvHZ+eL0NT16Jthod+W2Bx0r9McDRlm1K
 wQmSStPcgL5qr07uT/t/SYDLUM76Fo/vOE+tdK7Mw7IzKDSindU4tgQ/ls+CMEUefaem
 gSMM2IPzZWyR08kUFfAk0KN0MqZAx3bL9PRCesOivdiGdjGDYuq3E7fmlRHVcGKbs/cp bQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30wx8n86kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:29:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRM5i108376;
        Sat, 9 May 2020 16:29:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30wx11ctrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:29:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049GTbEv004408;
        Sat, 9 May 2020 16:29:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:29:37 -0700
Subject: [PATCH 1/3] libxcmd: don't crash if el_gets returns null
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:29:37 -0700
Message-ID: <158904177769.982835.13533960280738735171.stgit@magnolia>
In-Reply-To: <158904177147.982835.3876574696663645345.stgit@magnolia>
References: <158904177147.982835.3876574696663645345.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
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
 libxcmd/input.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)


diff --git a/libxcmd/input.c b/libxcmd/input.c
index 137856e3..a4548d7c 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -47,6 +47,7 @@ fetchline(void)
 	static EditLine	*el;
 	static History	*hist;
 	HistEvent	hevent;
+	const char	*cmd;
 	char		*line;
 	int		count;
 
@@ -59,13 +60,18 @@ fetchline(void)
 		el_set(el, EL_PROMPT, el_get_prompt);
 		el_set(el, EL_HIST, history, (const char *)hist);
 	}
-	line = strdup(el_gets(el, &count));
-	if (line) {
-		if (count > 0)
-			line[count-1] = '\0';
-		if (*line)
-			history(hist, &hevent, H_ENTER, line);
-	}
+	cmd = el_gets(el, &count);
+	if (!cmd)
+		return NULL;
+
+	line = strdup(cmd);
+	if (!line)
+		return NULL;
+
+	if (count > 0)
+		line[count-1] = '\0';
+	if (*line)
+		history(hist, &hevent, H_ENTER, line);
 	return line;
 }
 #else

