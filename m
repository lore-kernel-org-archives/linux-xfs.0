Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5ADC2BA18
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D4A32078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0EP6Mrem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgDCWML (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:12:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47032 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgDCWML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:12:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033MA08h082820
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=RC5EGfSFsf5ab2DM6mj9suAAliyUE8J2YH03fLi6o2E=;
 b=0EP6Mrempexbhy/vM7M44xmzznpW5BXTyJ2ASMtSB/QiajQ8qj+panHcC1Qjp2nu2Q+W
 m7rGKUYjH4lvCZuCo7i1EI0ydz0mowPLeq3MM4qt/6GLPzIEoah5G5BlH4v3bMWSVpq1
 e5mnzhMDuVOS5kRtj3iy6pO4LemYv7Zr6HYjvQD1mD+03YKPn9iSjG4NRU32k7Kpdw0R
 s1PES9sFkJyb4wIaFZuqZ4jCN+3Nt9YM0E5TGO96dpE4yBzuToPpqOGxAoR8C65fZ02B
 opfD7tfXKFq9LElzRMSP9Tpqudrq7ESmcw4Cd//qpGPnhcTT8bNbDi2dQduJnEzpw3Y5 nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevkdpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8NXW062341
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 302ga611wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:09 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MA8mV005646
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:08 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:08 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 14/39] xfsprogs: remove the unused ATTR_ENTRY macro
Date:   Fri,  3 Apr 2020 15:09:33 -0700
Message-Id: <20200403220958.4944-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 0c8f7c7..31c0ffd 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -70,14 +70,6 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 } attrlist_ent_t;
 
 /*
- * Given a pointer to the (char*) buffer containing the attr_list() result,
- * and an index, return a pointer to the indicated attribute in the buffer.
- */
-#define	ATTR_ENTRY(buffer, index)		\
-	((attrlist_ent_t *)			\
-	 &((char *)buffer)[ ((attrlist_t *)(buffer))->al_offset[index] ])
-
-/*
  * Kernel-internal version of the attrlist cursor.
  */
 typedef struct attrlist_cursor_kern {
-- 
2.7.4

