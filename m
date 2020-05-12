Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E8BCA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 17:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9007A206B9
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 17:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="in2VXdiG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgELR3o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 13:29:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELR3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 13:29:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CHD4fE126956;
        Tue, 12 May 2020 17:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=f92tz4hCzc7caoysQJgOQvqePErN1abE88PhfHwhqlI=;
 b=in2VXdiGk4cpzhAxI2dfBFnTFo3P0yS8EU14KADV7v7LQCAJ7dPgmmALzyHtlWNLEMMu
 WYGuJEZHIMya6eumE9/sjdbqj51fQrG8APmP3np+Pro1dWf2PvH8Px23AytFU5d/LEiG
 RShRkQOK4c/fbJ507mS6FCBpaXrQJ8whRudVDtHtEbbSluXQ1CJ3nTsP4nhCJQRPHSHv
 LvGJ5VeTbK7f7nNisAdXY3QFq2lf+qRlrOOIPcVK9RE53MWNC7u1gzFuicb4VRJKUYn0
 OaxQIqo8aV8IM5f785aLcAiQSIhLsaXxVCBxO4+/IOMW2AJ9ENXTs+sW5yPUteAXIQo/ Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30x3mbvd8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 17:29:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CHCYtu077816;
        Tue, 12 May 2020 17:29:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30xbgkdhpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 17:29:27 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CHTQGJ001181;
        Tue, 12 May 2020 17:29:27 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 10:29:26 -0700
Date:   Tue, 12 May 2020 10:29:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: [PATCH v2 01/16] xfs_repair: fix missing dir buffer corruption checks
Message-ID: <20200512172925.GJ6714@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904179840.982941.17275782452712518850.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904179840.982941.17275782452712518850.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=3 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=3 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The da_read_buf() function operates in "salvage" mode, which means that
if the verifiers fail, it will return a buffer with b_error set.  The
callers of da_read_buf, however, do not adequately check for verifier
errors, which means that repair can fail to flag a corrupt filesystem.

Fix the callers to do this properly.  The dabtree block walker and the
dabtree path checker functions to complain any time the da node / leafn
verifiers fail.  Fix the directory block walking functions to complain
about EFSCORRUPTED, since they already dealt with EFSBADCRC.

Found by running xfs/496 against lhdr.stale = middlebit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: check for corruption before checking magics; expand corruption
checks to other da_read_buf callers
---
 repair/da_util.c |   25 ++++++++++++++++---------
 repair/dir2.c    |   21 +++++++++++++++++++++
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/repair/da_util.c b/repair/da_util.c
index 5061880f..7239c2e2 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -134,6 +134,15 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
 			goto error_out;
 		}
 
+		/* corrupt leafn/node; rebuild the dir. */
+		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
+			do_warn(
+_("corrupt %s tree block %u for inode %" PRIu64 "\n"),
+				FORKNAME(whichfork), bno, da_cursor->ino);
+			libxfs_buf_relse(bp);
+			goto error_out;
+		}
+
 		node = bp->b_addr;
 		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
 
@@ -160,15 +169,6 @@ _("bad %s magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
 			goto error_out;
 		}
 
-		/* corrupt node; rebuild the dir. */
-		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
-			libxfs_buf_relse(bp);
-			do_warn(
-_("corrupt %s tree block %u for inode %" PRIu64 "\n"),
-				FORKNAME(whichfork), bno, da_cursor->ino);
-			goto error_out;
-		}
-
 		if (nodehdr.count > geo->node_ents) {
 			do_warn(
 _("bad %s record count in inode %" PRIu64 ", count = %d, max = %d\n"),
@@ -562,6 +562,13 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
 				FORKNAME(whichfork), dabno, cursor->ino);
 			return 1;
 		}
+		if (bp->b_error == -EFSCORRUPTED || bp->b_error == -EFSBADCRC) {
+			do_warn(
+_("corrupt %s tree block %u for inode %" PRIu64 "\n"),
+				FORKNAME(whichfork), dabno, cursor->ino);
+			libxfs_buf_relse(bp);
+			return 1;
+		}
 
 		newnode = bp->b_addr;
 		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, newnode);
diff --git a/repair/dir2.c b/repair/dir2.c
index cbbce601..b374bc7b 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -983,6 +983,13 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 			mp->m_dir_geo->datablk, ino);
 		return 1;
 	}
+	if (bp->b_error == -EFSCORRUPTED) {
+		do_warn(
+_("corrupt directory block %u for inode %" PRIu64 "\n"),
+			mp->m_dir_geo->datablk, ino);
+		libxfs_buf_relse(bp);
+		return 1;
+	}
 	/*
 	 * Verify the block
 	 */
@@ -1122,6 +1129,13 @@ _("can't read file block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			goto error_out;
 		}
+		if (bp->b_error == -EFSCORRUPTED) {
+			do_warn(
+_("corrupt directory leafn block %u for inode %" PRIu64 "\n"),
+				da_bno, ino);
+			libxfs_buf_relse(bp);
+			goto error_out;
+		}
 		leaf = bp->b_addr;
 		libxfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 		/*
@@ -1324,6 +1338,13 @@ _("can't read block %" PRIu64 " for directory inode %" PRIu64 "\n"),
 				dbno, ino);
 			continue;
 		}
+		if (bp->b_error == -EFSCORRUPTED) {
+			do_warn(
+_("corrupt directory data block %lu for inode %" PRIu64 "\n"),
+				dbno, ino);
+			libxfs_buf_relse(bp);
+			continue;
+		}
 		data = bp->b_addr;
 		if (!(be32_to_cpu(data->magic) == XFS_DIR2_DATA_MAGIC ||
 		      be32_to_cpu(data->magic) == XFS_DIR3_DATA_MAGIC))
