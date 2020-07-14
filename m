Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC3FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 078BE206F4
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fbhWYS2m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgGNVsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:48:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44728 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:48:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELku7D157609;
        Tue, 14 Jul 2020 21:48:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VePl/wuVX0h6Wxwm47k6Y3Dyt8UqCY2EBtrFRkgCbAE=;
 b=fbhWYS2mO5H7s26/lfz8jdLZfAGHx+di5MgkC9F2zIWdo4VjqqYUk52REHAf98ogpE1R
 tkQ21vO+Ou6geeihsaakLtKjhJiP9R5AR2UIoYmNcsYNhggTBOmUokSLYcpBRUh3QXyo
 1HcgGxvZAZoVL346h9I77vp1tKqCUzsZ7TSo309M/BYQD1qu6dGWoHLQgOZDvjXYJ5zS
 jtfnEFZRCWhWk4Guz6ysAOn5oDg4/hWI9ef7j14NM0jsLkwdpDl0F0Wf3gIuOrpG01e1
 959TlXPfq6X/qNh0H/VNuD9vPU6gvz5kMImPxZVe7XfFNDS9ATXq6PEpuhlIpX11br47 aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cm80qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:48:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELhaBR051399;
        Tue, 14 Jul 2020 21:46:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb5be2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:46:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06ELko3W024992;
        Tue, 14 Jul 2020 21:46:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:46:50 -0700
Subject: [PATCH 2/3] xfs_repair: never zero a shortform '..' entry
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:46:49 -0700
Message-ID: <159476320951.3156851.9608086404704132538.stgit@magnolia>
In-Reply-To: <159476319690.3156851.8364082533532014066.stgit@magnolia>
References: <159476319690.3156851.8364082533532014066.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Repair has this strange behavior during phase 4 where it will zero the
parent pointer entry of a shortform directory if the pointer is
obviously invalid.  Unfortunately, this causes the inode fork verifiers
to fail, so change it to reset bad pointers (ondisk) to the root
directory.  If repair crashes, a subsequent run will notice the
incorrect parent pointer and either fix the dir or move it to
lost+found.

Note that we maintain the practice of setting the *incore* parent to
NULLFSINO so that phase 7 knows that it has to fix the directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dir2.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)


diff --git a/repair/dir2.c b/repair/dir2.c
index b374bc7b..61e1aaaf 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -165,7 +165,6 @@ process_sf_dir2(
 	int			tmp_elen;
 	int			tmp_len;
 	xfs_dir2_sf_entry_t	*tmp_sfep;
-	xfs_ino_t		zero = 0;
 
 	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
 	max_size = XFS_DFORK_DSIZE(dip, mp);
@@ -494,7 +493,11 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
 
-			libxfs_dir2_sf_put_parent_ino(sfp, zero);
+			/*
+			 * Set the ondisk parent to the root inode so that we
+			 * never write garbage parent pointers to disk.
+			 */
+			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
@@ -529,7 +532,11 @@ _("bad .. entry in directory inode %" PRIu64 ", points to self, "),
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
 
-			libxfs_dir2_sf_put_parent_ino(sfp, zero);
+			/*
+			 * Set the ondisk parent to the root inode so that we
+			 * never write garbage parent pointers to disk.
+			 */
+			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {

