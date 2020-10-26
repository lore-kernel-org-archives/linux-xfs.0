Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822C9C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B59420878
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OgTWRI4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407169AbgJZXgp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:36:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44560 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407195AbgJZXgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:36:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPvEL177195;
        Mon, 26 Oct 2020 23:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=beFxoQttikHNmMlLxp/7DOwiFr+KbsUrVZvEYc1mmvw=;
 b=OgTWRI4tdjcjo8O8p07r9Xa6jAhYweouNMOzoyDABDIiRQGrFlrIh+aY4QM4d8bEF8FQ
 bMEKtTZgCObabp1voS4brFvYekstFjr/OhO7EcQK6f9oWfBkGCWXjRbJNYa91PnC8eOH
 zMLaGlSpeaEey/1Wf8bVWkXwfRu5mJoSydew8hX20p4nGMouHYf1BLZMhPt+Z4oSXjCg
 Fps6gin5A0biNP9ZOLrNT/TUz9gn4jqpXotHCqgV7Edeqge1MHRFjq/+l3Oh+45KnEhl
 bqzveUd+8JE4hUy20D6hTfB9HLZvKyimENspyQFsC7WHh5jQahrztMmVDExpbYqBWjcp EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqd7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:36:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxFh110502;
        Mon, 26 Oct 2020 23:36:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wft4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:43 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNafJ9006455;
        Mon, 26 Oct 2020 23:36:42 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:36:41 -0700
Subject: [PATCH 24/26] xfs_repair: support bigtime timestamp checking
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:36:40 -0700
Message-ID: <160375540080.881414.4537898211020466512.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that inodes don't have the bigtime flag set when the feature
is disabled, and don't check for overflows in the nanoseconds when
bigtime is enabled because that is no longer possible.  Also make sure
that quotas don't have bigtime set erroneously.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c     |   33 +++++++++++++++++++++++++++++----
 repair/quotacheck.c |   11 ++++++++++-
 2 files changed, 39 insertions(+), 5 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index c1d9d9727d62..16f52c38a43a 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2167,11 +2167,15 @@ static void
 check_nsec(
 	const char		*name,
 	xfs_ino_t		lino,
+	struct xfs_dinode	*dip,
 	xfs_timestamp_t		*ts,
 	int			*dirty)
 {
 	struct xfs_legacy_timestamp *t;
 
+	if (xfs_dinode_has_bigtime(dip))
+		return;
+
 	t = (struct xfs_legacy_timestamp *)ts;
 	if (be32_to_cpu(t->t_nsec) < NSEC_PER_SEC)
 		return;
@@ -2594,6 +2598,27 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			flags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 		}
 
+		if (xfs_dinode_has_bigtime(dino) &&
+		    !xfs_sb_version_hasbigtime(&mp->m_sb)) {
+			if (!uncertain) {
+				do_warn(
+	_("inode %" PRIu64 " is marked bigtime but file system does not support large timestamps\n"),
+					lino);
+			}
+			flags2 &= ~XFS_DIFLAG2_BIGTIME;
+
+			if (no_modify) {
+				do_warn(_("would zero timestamps.\n"));
+			} else {
+				do_warn(_("zeroing timestamps.\n"));
+				dino->di_atime = 0;
+				dino->di_mtime = 0;
+				dino->di_ctime = 0;
+				dino->di_crtime = 0;
+				*dirty = 1;
+			}
+		}
+
 		if (!verify_mode && flags2 != be64_to_cpu(dino->di_flags2)) {
 			if (!no_modify) {
 				do_warn(_("fixing bad flags2.\n"));
@@ -2721,11 +2746,11 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	}
 
 	/* nsec fields cannot be larger than 1 billion */
-	check_nsec("atime", lino, &dino->di_atime, dirty);
-	check_nsec("mtime", lino, &dino->di_mtime, dirty);
-	check_nsec("ctime", lino, &dino->di_ctime, dirty);
+	check_nsec("atime", lino, dino, &dino->di_atime, dirty);
+	check_nsec("mtime", lino, dino, &dino->di_mtime, dirty);
+	check_nsec("ctime", lino, dino, &dino->di_ctime, dirty);
 	if (dino->di_version >= 3)
-		check_nsec("crtime", lino, &dino->di_crtime, dirty);
+		check_nsec("crtime", lino, dino, &dino->di_crtime, dirty);
 
 	/*
 	 * general size/consistency checks:
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 8cbbfa2e6978..55bcc048517d 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -237,6 +237,7 @@ quotacheck_adjust(
 /* Compare this on-disk dquot against whatever we observed. */
 static void
 qc_check_dquot(
+	struct xfs_mount	*mp,
 	struct xfs_disk_dquot	*ddq,
 	struct qc_dquots	*dquots)
 {
@@ -273,6 +274,14 @@ qc_check_dquot(
 		chkd_flags = 0;
 	}
 
+	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb)) {
+		do_warn(
+	_("%s id %u is marked bigtime but file system does not support large timestamps\n"),
+				qflags_typestr(dquots->type), id);
+		chkd_flags = 0;
+	}
+
 	/*
 	 * Mark that we found the record on disk.  Skip locking here because
 	 * we're checking the dquots serially.
@@ -322,7 +331,7 @@ _("cannot read %s inode %"PRIu64", block %"PRIu64", disk block %"PRIu64", err=%d
 		for (dqnr = 0;
 		     dqnr < dqperchunk && dqid <= UINT_MAX;
 		     dqnr++, dqb++, dqid++)
-			qc_check_dquot(&dqb->dd_diskdq, dquots);
+			qc_check_dquot(mp, &dqb->dd_diskdq, dquots);
 		libxfs_buf_relse(bp);
 	}
 

