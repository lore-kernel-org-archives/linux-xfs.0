Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FD8C2BA17
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67C0920719
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:54:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OABW8c4E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgDFSy5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 14:54:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56184 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgDFSy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 14:54:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Ii2Nh008235;
        Mon, 6 Apr 2020 18:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IEG62u8wtp/0Xws54c46GQDEElqwza1jiA6aytfKuxQ=;
 b=OABW8c4EC6QRCf2ONYpMsvpqGZwAc4D6fbUv3DdED4ocJO0JBLq91Z8ezFoE/HrJ5jQP
 kwWDG9GSljYhl46vbg5dHzeslygLlx5hkY++nF+/i2yMZEVTDzwI20u/1YhE9KRh6txW
 pau4uq0qC21PzTTQRjXq/Zn0CcDvkZX7bXZn4sAyfIVMrMrCMaEPmfYw3HAurjeFP2X/
 Dd2bXV/6RRk33qf0FaCH7TWdiYLmA05lYb+KnggXpTHMj4t+IL5ppjpBMd8otZdfuLq/
 3JpTXfdQShQm9l9bTjGwVAGE0n7OOaWAZJB0FhdKWqTl6JQDlfFVgp6Tu2VHJ0LO+9r/ vQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 306hnr0rac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:54:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IhFuw116984;
        Mon, 6 Apr 2020 18:52:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3073qdt86y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:47 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036IqisS028880;
        Mon, 6 Apr 2020 18:52:44 GMT
Received: from localhost (/10.159.131.9)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 11:52:43 -0700
Subject: [PATCH 3/5] xfs_db: clean up the salvage read callsites in set_cur()
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Mon, 06 Apr 2020 11:52:42 -0700
Message-ID: <158619916259.469742.7875972212442996405.stgit@magnolia>
In-Reply-To: <158619914362.469742.7048317858423621957.stgit@magnolia>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Clean up the LIBXFS_READBUF_SALVAGE call sites in set_cur so that we
use the return value directly instead of scraping it out later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 db/io.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)


diff --git a/db/io.c b/db/io.c
index 384e4c0f..6628d061 100644
--- a/db/io.c
+++ b/db/io.c
@@ -516,6 +516,7 @@ set_cur(
 	xfs_ino_t	ino;
 	uint16_t	mode;
 	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
+	int		error;
 
 	if (iocur_sp < 0) {
 		dbprintf(_("set_cur no stack element to set\n"));
@@ -542,20 +543,21 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b, bbmap->nmaps,
-				LIBXFS_READBUF_SALVAGE, &bp, ops);
+		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
+				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
+				ops);
 	} else {
-		libxfs_buf_read(mp->m_ddev_targp, blknum, len,
+		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
 				LIBXFS_READBUF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
 
 	/*
-	 * Keep the buffer even if the verifier says it is corrupted.
-	 * We're a diagnostic tool, after all.
+	 * Salvage mode means that we still get a buffer even if the verifier
+	 * says the metadata is corrupt.  Therefore, the only errors we should
+	 * get are for IO errors or runtime errors.
 	 */
-	if (!bp || (bp->b_error && bp->b_error != -EFSCORRUPTED &&
-				   bp->b_error != -EFSBADCRC))
+	if (error)
 		return;
 	iocur_top->buf = bp->b_addr;
 	iocur_top->bp = bp;

