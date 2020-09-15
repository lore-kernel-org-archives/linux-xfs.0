Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0F2C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 632DC216C4
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jVA+mVwu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgIOBva (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:51:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50056 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIOBv2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:51:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1o0Ft151317;
        Tue, 15 Sep 2020 01:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DUJc9Bp5nwYqv0TVIGmtesEeKWo6cv1sXHUQr/OghDE=;
 b=jVA+mVwuuXc8xMpENuq/qGLQdDyST6nw5NEb/k6w2Gm+1J+y8hA2qJtCUTWJn7Q8m0YS
 A1nSqe489qmdSdsHrK7ZfkdITM1Z1lRI3WAL7lE5958rpN+iIu3f4lyFJZrXoFqDOQ/O
 ZccyOvtzAHX9Y3GRyn8kJjxmxkOxnIbA1PwlJ0UkflvEGmO5nN1UVU8gUiN0mq/Spmds
 6ftmk5EAhtqsW01WjgkI157nm1x1vfpIpUS0xkPyJFB6rYulk8UtzKnoGAHMOZKpt2Su
 f3RLrUN8aavO8k0d7InelxVvGYHkkwZDVFTxKPuA5H5SPBOCV4ftRctKR4KwudzYI3Lj hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrqsyec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:51:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1nldQ140737;
        Tue, 15 Sep 2020 01:51:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33hm2ycut2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:51:25 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1pPms007625;
        Tue, 15 Sep 2020 01:51:25 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:51:24 +0000
Subject: [PATCH 3/4] mkfs: don't allow creation of realtime files from a proto
 file
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:51:23 -0700
Message-ID: <160013468391.2932378.13825727040727340226.stgit@magnolia>
In-Reply-To: <160013466518.2932378.9536364695832878473.stgit@magnolia>
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If someone runs mkfs with rtinherit=1, a realtime volume configured, and
a protofile that creates a regular file in the filesystem, mkfs will
error out with "Function not implemented" because userspace doesn't know
how to allocate extents from the rt bitmap.  Catch this specific case
and hand back a somewhat nicer explanation of what happened.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/proto.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 9db8fe2d6447..20a7cc3bb5d5 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -244,6 +244,12 @@ newfile(
 		nb = XFS_B_TO_FSB(mp, len);
 		nmap = 1;
 		error = -libxfs_bmapi_write(tp, ip, 0, nb, 0, nb, &map, &nmap);
+		if (error == ENOSYS && XFS_IS_REALTIME_INODE(ip)) {
+			fprintf(stderr,
+	_("%s: creating realtime files from proto file not supported.\n"),
+					progname);
+			exit(1);
+		}
 		if (error) {
 			fail(_("error allocating space for a file"), error);
 		}

