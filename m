Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A28AC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48ED120735
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:30:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qrhSu/xo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgEIQaC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:30:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37002 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQaC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:30:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GOnLU065426;
        Sat, 9 May 2020 16:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BMArBvVwY8+92epLm2Hj7Lav0ew0sb6EjqdzAn2eKJY=;
 b=qrhSu/xoQQxqXmOe5ODk1pWJVFOdxGIChK8IMUnE14mGQpxoji2QUHzzk+8N3mQ3Wgmm
 tEabVCuqzccl3RpAu5i61RIdY9ZnVf7s9e3Km2Q77JwvzpqnwMhcCQgWp5N91GEMlMf0
 f+CLZz4vru13D6PGBcyjUf8cFbTI5iTLpuVuHqnUzXIQJjfqnMOgdJvqWKQhnR8+CLq3
 +OtYmPCXu8mYwSmuQggnuh0Cm+g2Zs4/v4vGNSF/bYJv7ZNGqrUVkQqDyWwFtDn8gGyu
 4RJfQghX1H7FjYoAuQGSqPmJJWa/tcO1EC2JxopoqcsDCEfaHSgH8GNxxPriqNPS0dmF gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30wx8n86mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:30:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTuiM112505;
        Sat, 9 May 2020 16:29:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30wx11cu46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:29:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GTxoM020280;
        Sat, 9 May 2020 16:29:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:29:58 -0700
Subject: [PATCH 01/16] xfs_repair: fix missing dir buffer corruption checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:29:58 -0700
Message-ID: <158904179840.982941.17275782452712518850.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=966 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=993 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Both callers of da_read_buf do not adequately check for verifier
failures in the (salvage mode) buffer that gets returned.  This leads to
repair sometimes failing to complain about corrupt directories when run
with -n, which leads to an incorrect return value of 0 (all clean).

Found by running xfs/496 against lhdr.stale = middlebit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/da_util.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/repair/da_util.c b/repair/da_util.c
index 5061880f..92c04337 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -140,11 +140,24 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
 		if (whichfork == XFS_DATA_FORK &&
 		    (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 		    nodehdr.magic == XFS_DIR3_LEAFN_MAGIC)) {
+			int bad = 0;
+
 			if (i != -1) {
 				do_warn(
 _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
 					da_cursor->ino, bno);
+				bad++;
 			}
+
+			/* corrupt leafn node; rebuild the dir. */
+			if (!bad &&
+			    (bp->b_error == -EFSBADCRC ||
+			     bp->b_error == -EFSCORRUPTED)) {
+				do_warn(
+_("corrupt %s LEAFN block %u for inode %" PRIu64 "\n"),
+					FORKNAME(whichfork), bno, da_cursor->ino);
+			}
+
 			*rbno = 0;
 			libxfs_buf_relse(bp);
 			return 1;
@@ -599,6 +612,14 @@ _("bad level %d in %s block %u for inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			bad++;
 		}
+		if (!bad &&
+		    (bp->b_error == -EFSCORRUPTED ||
+		     bp->b_error == -EFSBADCRC)) {
+			do_warn(
+_("corruption error reading %s block %u for inode %" PRIu64 "\n"),
+				FORKNAME(whichfork), dabno, cursor->ino);
+			bad++;
+		}
 		if (bad) {
 #ifdef XR_DIR_TRACE
 			fprintf(stderr, "verify_da_path returns 1 (bad) #4\n");

