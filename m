Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64A5C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665112137B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:53:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="agQ+0AVG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgIGRxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:53:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57312 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730585AbgIGRxI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:53:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087Hnult043282;
        Mon, 7 Sep 2020 17:53:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rc0wq4JG8XXESZa9aYiN9ZqYjc6XW0w4voSqMdLhhGI=;
 b=agQ+0AVGKbxmAgFF9wXEmymkDE5ANwVF2JXnwWGoB6z8gkzR3R+wvkbvlQDZxAGQAx5r
 yO02Y/lpAUyxoJ+vIFbmQHYScw6qZq4gp5LYXKk7VGufFQ23fNiNdKxKeAqB5mLhD8GO
 KXH4/vnAsl58IieTLrLqGhsj4FN8Ot/nvQYofK+WkLUGARTy0eluyCUmZVSwZXiC05B2
 uofKw+QaT95rEL6TD+Qwz8hVdfxHwuryiyJIEmt7fZC2meEWmPHomFfezB82T1o5VNC+
 MP8xvFWPs7risSrdTzoYMJQofvdrU+KgjWxy1+koS4uN75Pb1nnuuFZDHoGs5/TDBUf8 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3amqgmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:53:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HnMva066081;
        Mon, 7 Sep 2020 17:53:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33cmepvgwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:53:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087Hr5mR021800;
        Mon, 7 Sep 2020 17:53:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:52:04 -0700
Subject: [PATCH 1/7] xfs_repair: don't crash on partially sparse inode
 clusters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:52:03 -0700
Message-ID: <159950112377.567790.5885407242137390700.stgit@magnolia>
In-Reply-To: <159950111751.567790.16914248540507629904.stgit@magnolia>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=983 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=2 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While running xfs/364 to fuzz the middle bit of recs[2].holemask, I
observed a crash in xfs_repair stemming from the fact that each sparse
bit accounts for 4 inodes, but inode cluster buffers can map to more
than four inodes.

When the first inode in an inode cluster is marked sparse,
process_inode_chunk won't try to load the inode cluster buffer.
Unfortunately, if the holemask indicates that there are inodes present
anywhere in the rest of the cluster buffer, repair will try to check the
corresponding cluster buffer, even if we didn't load it.  This leads to
a null pointer dereference, which crashes repair.

Avoid the null pointer dereference by marking the inode sparse and
moving on to the next inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dino_chunks.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 96e2c1708b94..50a2003614df 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -792,6 +792,25 @@ process_inode_chunk(
 		if (is_inode_sparse(ino_rec, irec_offset))
 			goto process_next;
 
+		/*
+		 * Repair skips reading the cluster buffer if the first inode
+		 * in the cluster is marked as sparse.  If subsequent inodes in
+		 * the cluster buffer are /not/ marked sparse, there won't be
+		 * a buffer, so we need to avoid the null pointer dereference.
+		 */
+		if (bplist[bp_index] == NULL) {
+			do_warn(
+	_("imap claims inode %" PRIu64 " is present, but inode cluster is sparse, "),
+						ino);
+			if (verbose || !no_modify)
+				do_warn(_("correcting imap\n"));
+			else
+				do_warn(_("would correct imap\n"));
+			set_inode_sparse(ino_rec, irec_offset);
+			set_inode_free(ino_rec, irec_offset);
+			goto process_next;
+		}
+
 		/* make inode pointer */
 		dino = xfs_make_iptr(mp, bplist[bp_index], cluster_offset);
 

