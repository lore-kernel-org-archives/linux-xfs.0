Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F58CC35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7071E21569
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I20c5Mou"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgAXAQv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:16:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33826 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbgAXAQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:16:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O08kNg024609;
        Fri, 24 Jan 2020 00:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=p5WWCQS9/YJVevyQmkRpMF99yu8gjZyqdYBNJMzya7o=;
 b=I20c5MouIybbeifocL7FesRhtMR68ic3nHSwN4OeOM5P42My321aFWC7twmttNGL6hlm
 bei5Rp38t3LcDnq9SQschDeMT6+wr3PGPMe7w/CxJxC2l0Ia+q9Wd/oCoHw8FM9aTNV5
 9Y+WNoEkKFuJutlbTg48f3W6XDz0Ofj3ek2Uv/b7V+povMzsGv5x5oP+pBvv/Nz6lhcO
 qNSYXe7CtrpCvC6DOxKSn7AgEwhCg26WOpWyWay//xu8W80hk/0FGdH6KZLePBlek2Dw
 Ww1GiGVvrDOABeg3My95z2ZMkeyqAajSOLxC49B48ZYzTCZtMnzcWjW05BmknM+tf6/K 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseuwvtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:16:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0E65X111077;
        Fri, 24 Jan 2020 00:16:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xqmwb1b0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:16:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O0GlEj030419;
        Fri, 24 Jan 2020 00:16:47 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:16:46 -0800
Subject: [PATCH 2/8] man: document the xfs_db btheight command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Jan 2020 16:16:44 -0800
Message-ID: <157982500443.2765410.17401149852075835578.stgit@magnolia>
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Document the btheight command in xfs_db.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_db.8 |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)


diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index a1ee3514..53e34983 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -346,6 +346,45 @@ If the cursor points at an inode, dump the extended attribute block mapping btre
 Dump all keys and pointers in intermediate btree nodes, and all records in leaf btree nodes.
 .RE
 .TP
+.BI "btheight [\-b " blksz "] [\-n " recs "] [\-w " max "|\-w " min "] btree types..."
+For a given number of btree records and a btree type, report the number of
+records and blocks for each level of the btree, and the total number of blocks.
+The btree type must be given after the options.
+
+A raw btree geometry can be provided in the format
+"record_bytes:key_bytes:ptr_bytes:header_type", where header_type is one of
+"short", "long", "shortcrc", or "longcrc".
+
+The supported btree types are:
+.IR bnobt ,
+.IR cntbt ,
+.IR inobt ,
+.IR finobt ,
+.IR bmapbt ,
+.IR refcountbt ,
+and
+.IR rmapbt .
+
+Options are as follows:
+.RS 1.0i
+.TP 0.4i
+.B \-b
+is used to override the btree block size.
+The default is the filesystem block size.
+.TP
+.B \-n
+is used to specify the number of records to store.
+This argument is required.
+.TP
+.B \-w max
+shows only the best case scenario, which is when the btree blocks are
+maximally loaded.
+.TP
+.B \-w min
+shows only the worst case scenario, which is when the btree blocks are
+half full.
+.RE
+.TP
 .B check
 See the
 .B blockget

