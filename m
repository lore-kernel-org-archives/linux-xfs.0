Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685D4C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F34520771
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yiS8Mxq4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgIOBv3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:51:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44294 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgIOBv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:51:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1oGuj063428;
        Tue, 15 Sep 2020 01:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9huK5m0g4sZO0Po7govYi+G33PY32q4qpIVtFc2VVOo=;
 b=yiS8Mxq4zRnR4Ahwid5VHUzS1uHzw0ExSczcCYUN8Zxc+KplIT7e6xFkpiOmK72X6+5m
 3Dc2JTkn8xg+n9WbFH3dFt0K3V19zt0XRkozpo/i5KJ9jfrCFGVFex70yI5ZsCbo7GPK
 Zs0EvWXWt6DZngwp86CKfHUIvErSbcEbxtxU1l4s9zopmu0wEjhdC95UFG39ufTPsZdX
 6+yI4V1ouz2WLH2XjZNT0NjJ5p5e2kLLQb9ip34IFvUFPZPXJZqYt1OuEtn2kc99OJYo
 l1YN45TfqmEO92MtG51W1WWpkcJ1bXTbQKFa9BeUIcD4Rmx2hfLWSEvMqb6xPzhKWS2n Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dbj88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:51:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1pO73128469;
        Tue, 15 Sep 2020 01:51:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33h8838fdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:51:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1pIEW010338;
        Tue, 15 Sep 2020 01:51:19 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:51:18 +0000
Subject: [PATCH 2/4] libxfs: don't propagate RTINHERIT -> REALTIME when there
 is no rtdev
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:51:17 -0700
Message-ID: <160013467762.2932378.12947505930529559840.stgit@magnolia>
In-Reply-To: <160013466518.2932378.9536364695832878473.stgit@magnolia>
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When creating a file inside a directory that has RTINHERIT set, only
propagate the REALTIME flag to the file if the filesystem actually has a
realtime volume configured.  Otherwise, we end up writing inodes that
trip the verifiers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 78519872e8e8..f1b4759728ec 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -224,9 +224,9 @@ xfs_inode_propagate_flags(
 			ip->i_d.di_extsize = pip->i_d.di_extsize;
 		}
 	} else {
-		if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) {
+		if ((pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) &&
+		    xfs_sb_version_hasrealtime(&ip->i_mount->m_sb))
 			di_flags |= XFS_DIFLAG_REALTIME;
-		}
 		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
 			di_flags |= XFS_DIFLAG_EXTSIZE;
 			ip->i_d.di_extsize = pip->i_d.di_extsize;

