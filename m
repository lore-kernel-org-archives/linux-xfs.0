Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C38DC54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75AFF2080C
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vf43kUH+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgD0RHi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:07:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgD0RHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 13:07:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RH398Y003491;
        Mon, 27 Apr 2020 17:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=QkAccaML97NCDDUZi0gQBiisJx+PrpUvPLIjXdOcH/k=;
 b=Vf43kUH+hj/uAIkwQo3HqcpDtWanfy10bGiAOhw54xXlx0ALn24il2HIThsfOCMyGS/7
 fbtXSEziFYFFbUwI0GQYlWNfiQU7yItbffXn6xIvPXfPEaKAecby1ZJso8ACCDhk2vnv
 Ma4n7Es81a/SDbve2yI082UX9IhRvV8aFYHE5JLzBgQ5soqzl+5cwM0ZetNMX7enG78g
 PGzPLQTUWr5YYB2AUc64jZcC3U6Nx1Cu/E+Nf23NeWaj68KhK5PJUWrh2OWcGMTI3VbI
 PDuQeLauFL4KVdHiNVWQ2VsFHs/a0VbMKypwHXlcUAAM3upMYQZNrRmRlrfIzwavCLeU Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01nhe38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:07:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RH1tT3171293;
        Mon, 27 Apr 2020 17:07:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30mxwwkhm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:07:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03RH7VrX031648;
        Mon, 27 Apr 2020 17:07:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 10:07:31 -0700
Date:   Mon, 27 Apr 2020 10:07:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: [PATCH] libxcmd: don't crash if el_gets returns null
Message-ID: <20200427170730.GQ6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=1 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270139
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
