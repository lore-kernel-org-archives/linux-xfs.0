Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A4DC43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 197682137B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q67IcqHE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgIGRzw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:55:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42876 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729650AbgIGRzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:55:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HnN0B188340;
        Mon, 7 Sep 2020 17:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mF53+rT+/tdeVOtLF0oLDERGjb8tZ3peZpnZSf1OtSM=;
 b=q67IcqHE8JiCIvsRlMth5zr+klj1KAVcDansB/Fr8FwzaVmw5Gj8aHQhp07H78UuCkDh
 ndJ7/kwh67MoMVzkBtiarcYYx+0YSCjpE+8++PZwv9RJLusILrHiKn7ZFKbxcLEZbcY1
 KKWscbrtObLtk8vXkdwImkgyHSECaR3NSBEd8ZZr9tRepmXl0bkeo/ZzuhcXWadv/Mxc
 IBQML503KdKPB51Fq2JkI9pANcoAfhFHKp36wFhTP7kVpBvHBzKQBQ6UFVXZZaracMwZ
 LbcF9O/5xfDu03MX5WKcjsSaOxhjAQZTWYekPNLpBxI0ToV3gVjyroPBJGm6M6QawM/N tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33c23qqnh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:55:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087Hov8F017073;
        Mon, 7 Sep 2020 17:53:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33cmk15nv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:53:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 087HrcBS012644;
        Mon, 7 Sep 2020 17:53:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:52:29 -0700
Subject: [PATCH 5/7] xfs_repair: fix handling of data blocks colliding with
 existing metadata
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:52:28 -0700
Message-ID: <159950114896.567790.10646736292763230158.stgit@magnolia>
In-Reply-To: <159950111751.567790.16914248540507629904.stgit@magnolia>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=2 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Prior to commit a406779bc8d8, any blocks in a data fork extent that
collided with existing blocks would cause the entire data fork extent to
be rejected.  Unfortunately, the patch to add data block sharing support
suppressed checking for any collision, including metadata.  What we
really wanted to do here during a check_dups==1 scan is to is check for
specific collisions and without updating the block mapping data.

So, move the check_dups test after the for-switch construction.  This
re-enables detecting collisions between data fork blocks and a
previously scanned chunk of metadata, and improves the specificity of
the error message that results.

This was found by fuzzing recs[2].free=zeroes in xfs/364, though this
patch alone does not solve all the problems that scenario presents.

Fixes: a406779bc8d8 ("xfs_repair: handle multiple owners of data blocks")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 1fe68bd41117..7577b50ffb2b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -476,28 +476,6 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 			locked_agno = agno;
 		}
 
-		if (check_dups) {
-			/*
-			 * if we're just checking the bmap for dups,
-			 * return if we find one, otherwise, continue
-			 * checking each entry without setting the
-			 * block bitmap
-			 */
-			if (!(type == XR_INO_DATA &&
-			    xfs_sb_version_hasreflink(&mp->m_sb)) &&
-			    search_dup_extent(agno, agbno, ebno)) {
-				do_warn(
-_("%s fork in ino %" PRIu64 " claims dup extent, "
-  "off - %" PRIu64 ", start - %" PRIu64 ", cnt %" PRIu64 "\n"),
-					forkname, ino, irec.br_startoff,
-					irec.br_startblock,
-					irec.br_blockcount);
-				goto done;
-			}
-			*tot += irec.br_blockcount;
-			continue;
-		}
-
 		for (b = irec.br_startblock;
 		     agbno < ebno;
 		     b += blen, agbno += blen) {
@@ -554,6 +532,17 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 			}
 		}
 
+		if (check_dups) {
+			/*
+			 * If we're just checking the bmap for dups and we
+			 * didn't find any non-reflink collisions, update our
+			 * inode's block count and move on to the next extent.
+			 * We're not yet updating the block usage information.
+			 */
+			*tot += irec.br_blockcount;
+			continue;
+		}
+
 		/*
 		 * Update the internal extent map only after we've checked
 		 * every block in this extent.  The first time we reject this

