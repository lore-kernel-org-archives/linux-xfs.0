Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACEBC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A2A2063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ykXgCty6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgEIQ37 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:29:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQ37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:29:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GPEbw065521;
        Sat, 9 May 2020 16:29:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RSrfQkciovASR1Fxn6sYNsh6qd73FAcozOr4PRCvm1E=;
 b=ykXgCty6sVLKJaIA6RR0a+WsXElXFauUn85bJop19bfEYjWuwZex8NyuvJSC/x68Vy4Q
 9Fyx63U2SQpxYXTfVtMHWjNswL28rwLMiRSQ/y67WaN4UTt/OB1zf0VosK5sPA8D5z0n
 WpB3JSq96DoxRZsSSVcDGu1AEG+eXzIsfucLWHWkkRKP/rfbWABliY9Ip9dwPcUfG034
 e7PEmVtObz3zSiUbyXX8CPI5I2pOpphASPsBG+Vi3ruU4sd90aeqkb3X/Xl2E7Kxc1jY
 j9OdW8cjmxxRpHzSVSk8n37tFFqSJ+0Fl3/DahcHBsl8oIc2Oh7DH3T+1CbhOB9ejNec Aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30wx8n86m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:29:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTuKR112501;
        Sat, 9 May 2020 16:29:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30wx11cty1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:29:56 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049GTocD004435;
        Sat, 9 May 2020 16:29:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:29:49 -0700
Subject: [PATCH 3/3] xfs_db: bounds-check access to the dbmap array
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:29:50 -0700
Message-ID: <158904178997.982835.3080374978418485288.stgit@magnolia>
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
 definitions=main-2005090141
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

Try to check the array boundaries of the dbmap array so that we don't
just segfault.

Found by fuzzing xfs/358 with recs[1].blockcount = ones.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/db/check.c b/db/check.c
index c9bafa8e..6f047877 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1294,6 +1294,18 @@ check_blist(
 	return 0;
 }
 
+static inline bool
+dbmap_boundscheck(
+	xfs_agnumber_t	agno,
+	xfs_agblock_t	agbno)
+{
+	if (agno >= mp->m_sb.sb_agcount)
+		return false;
+	if (agbno >= mp->m_sb.sb_agblocks)
+		return false;
+	return true;
+}
+
 static void
 check_dbmap(
 	xfs_agnumber_t	agno,
@@ -1307,6 +1319,12 @@ check_dbmap(
 	dbm_t		d;
 
 	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
+		if (!dbmap_boundscheck(agno, agbno + i)) {
+			dbprintf(_("block %u/%u beyond end of expected area\n"),
+				agno, agbno + i);
+			error++;
+			break;
+		}
 		d = (dbm_t)*p;
 		if (ignore_reflink && (d == DBM_UNKNOWN || d == DBM_DATA ||
 				       d == DBM_RLDATA))
@@ -1468,6 +1486,13 @@ check_range(
 	return 1;
 }
 
+static inline bool
+rdbmap_boundscheck(
+	xfs_rfsblock_t	bno)
+{
+	return bno < mp->m_sb.sb_agblocks;
+}
+
 static void
 check_rdbmap(
 	xfs_rfsblock_t	bno,
@@ -1478,6 +1503,12 @@ check_rdbmap(
 	char		*p;
 
 	for (i = 0, p = &dbmap[mp->m_sb.sb_agcount][bno]; i < len; i++, p++) {
+		if (!rdbmap_boundscheck(bno + i)) {
+			dbprintf(_("rtblock %llu beyond end of expected area\n"),
+				bno + i);
+			error++;
+			break;
+		}
 		if ((dbm_t)*p != type) {
 			if (!sflag || CHECK_BLIST(bno + i))
 				dbprintf(_("rtblock %llu expected type %s got "
@@ -1599,6 +1630,12 @@ check_set_dbmap(
 	check_dbmap(agno, agbno, len, type1, is_reflink(type2));
 	mayprint = verbose | blist_size;
 	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
+		if (!dbmap_boundscheck(agno, agbno + i)) {
+			dbprintf(_("block %u/%u beyond end of expected area\n"),
+				agno, agbno + i);
+			error++;
+			break;
+		}
 		if (*p == DBM_RLDATA && type2 == DBM_DATA)
 			;	/* do nothing */
 		else if (*p == DBM_DATA && type2 == DBM_DATA)
@@ -1627,6 +1664,12 @@ check_set_rdbmap(
 	check_rdbmap(bno, len, type1);
 	mayprint = verbose | blist_size;
 	for (i = 0, p = &dbmap[mp->m_sb.sb_agcount][bno]; i < len; i++, p++) {
+		if (!rdbmap_boundscheck(bno + i)) {
+			dbprintf(_("rtblock %llu beyond end of expected area\n"),
+				bno + i);
+			error++;
+			break;
+		}
 		*p = (char)type2;
 		if (mayprint && (verbose || CHECK_BLIST(bno + i)))
 			dbprintf(_("setting rtblock %llu to %s\n"),

