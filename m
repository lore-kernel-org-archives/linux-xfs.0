Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2672C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A61CB2064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BvZcoqvS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgAABHq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:07:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52234 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbgAABHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:07:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00116xth108571
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=AvRyyzcWAaRRiktbXI5rsDl86ZNrhRZE3t5fyEOKUTU=;
 b=BvZcoqvSPjazOC1m6KaniagbGs3QG1Pr9IySJdcgYmiCO5KxtVU8uFyiACDLSlgscqcv
 XI5qxz2kaYwUklY7QPxQAbm2jYdRgXv0SUSQdU1bvpc9FrZOjGtcdi5X2OQIoz89WihC
 ZtAsNeFoJthGMbk21ynkVtpT9VSbDVFdpAkzA4loHhIG0S/z+MjBDhylLCHciL9qzvyF
 Z1KsD640vcG411Vb3rhmHEN1N/j23GQEsFl9s/ZeTMUqMDVV15BsR8MnqllQXvNzzN/Z
 907llNojVUxmY6an3zWt/SZbSfaod9wkJL+xXSpx9V6ILQpHSenwNNpIfJisIyhgQ4vD 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:07:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115FhC006787
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8guee8a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:07:43 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00117gaW030980
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:42 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:07:42 -0800
Subject: [PATCH 4/6] xfs: xfs_inode_free_quota_blocks should scan project
 quota
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:07:40 -0800
Message-ID: <157784086030.1361522.10089960662044910555.stgit@magnolia>
In-Reply-To: <157784083298.1361522.7064886067520069080.stgit@magnolia>
References: <157784083298.1361522.7064886067520069080.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Buffered writers who have run out of quota reservation call
xfs_inode_free_quota_blocks to try to free any space reservations that
might reduce the quota usage.  Unfortunately, the buffered write path
treats "out of project quota" the same as "out of overall space" so this
function has never supported scanning for space that might ease an "out
of project quota" condition.

We're about to start using this function for cases where we actually
/can/ tell if we're out of project quota, so add in this functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c55fc0dfd457..d954e37af5d0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1566,6 +1566,15 @@ xfs_inode_free_quota_blocks(
 		}
 	}
 
+	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_PROJ);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_prid = ip->i_d.di_projid;
+			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
+			do_work = true;
+		}
+	}
+
 	if (!do_work)
 		return false;
 

