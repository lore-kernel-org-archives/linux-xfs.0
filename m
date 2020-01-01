Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B18C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4812D206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dIqUrZt8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAABTP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:19:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58556 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABTO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:19:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FNLZ113277
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=YJhyGzHEPu+yrWDOSGdX7uDqHVRHCP9Xo3t8b6dqGwU=;
 b=dIqUrZt8qwWiZ/Mm/QlAD16FgzlhUzcLqSP/dbPfxTcN4riIomnVU3HxEgHAcSh8DMHe
 o9J7dvRks/DpN8qJ2SsBRev/4sr0Zj2+J5/1Cv3CWl4luIN16524b24HtbEPHzk0F1RW
 DGrJeJMMhl/Xef8ncxPIoa4gAI3OqLn+IGzFmWswNbwwozPjHRBS34suBHfJ/2LdFJ2y
 yaF+PCe5kWCJeyhfzpxkTtCtiJUbjlcxGYniV+LLHEynyQJVFRdp9OXQx2RG3voAMC3Z
 fxgsVKCQuUVo8+IFqfLoUeDayELvbbkN+TZ16yxwLYMQb8zdjYZQhmspzDp8MR4YpLUe ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:19:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011JCRZ007226
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:19:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x8bsrg5nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:19:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011IKPd029158
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:21 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:18:20 -0800
Subject: [PATCH 19/21] xfs: cross-reference realtime bitmap to realtime
 rmapbt scrubber
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:18:18 -0800
Message-ID: <157784149829.1368137.12322264434761456445.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're checking the realtime rmapbt, cross-reference the entries
with the realtime bitmap too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/rtbitmap.c |    5 +----
 fs/xfs/scrub/rtrmap.c   |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index c642bc206c41..6cbd3f6413e0 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -136,13 +136,10 @@ xchk_xref_is_used_rt_space(
 	do_div(startext, sc->mp->m_sb.sb_rextsize);
 	do_div(endext, sc->mp->m_sb.sb_rextsize);
 	extcount = endext - startext + 1;
-	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
 			&is_free);
 	if (!xchk_should_check_xref(sc, &error, NULL))
-		goto out_unlock;
+		return;
 	if (is_free)
 		xchk_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
-out_unlock:
-	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 }
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 9b5d55734a41..458b71e5bae9 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -56,6 +56,16 @@ xchk_setup_rtrmapbt(
 
 /* Realtime reverse mapping. */
 
+/* Cross-reference with other metadata. */
+STATIC void
+xchk_rtrmapbt_xref(
+	struct xfs_scrub	*sc,
+	struct xfs_rmap_irec	*irec)
+{
+	xchk_xref_is_used_rt_space(sc, irec->rm_startblock,
+			irec->rm_blockcount);
+}
+
 /* Scrub a realtime rmapbt record. */
 STATIC int
 xchk_rtrmapbt_helper(
@@ -86,6 +96,10 @@ xchk_rtrmapbt_helper(
 	if (is_bmbt || non_inode || is_attr)
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xchk_rtrmapbt_xref(bs->sc, &irec);
 out:
 	return error;
 }

