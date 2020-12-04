Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273D3C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA85A224B8
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgLDBPd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:15:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLDBPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:15:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B419k9s068074
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:14:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IApmRNFLf8E7OWKbmy3AHqTyNNrow7mea4MCJaBBtyk=;
 b=G2q2WEL0DuIOdX+RM+HjvCVpYzoZxXrM3rJtM2F5vPk8jeRFLm3O7V4KgGqWybG0ReD1
 gf7vze1074Key3cPZ0uoXIoudefuLy+NWvYc1oDz6MIsadDmZKT8vK2bNVGtOFiN3tEK
 rNhjPcAHZulMzJp+airDVt1/m7ZJMxFM+RsR3SOW965uiAlEaskzA0D3LL+Eyy/sc5QL
 mzS2CJMkgjS1KHmbDrYflWxKX6gD4qkze1US+E+7DbxVFlaIyVoq+F5+mSTWkytt/ZXi
 8jET+gG5l/sigOAg9WS9bi0ntSDv2H4sRbu+Nh08d9yordm+vugdo5mOntqg2P56ZxPC iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyr126p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:14:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41APNb099316
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:12:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3540ax541e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:12:51 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B41Co6r016578
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:12:51 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:12:50 -0800
Subject: [PATCH 1/3] xfs: detect overflows in bmbt records
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 03 Dec 2020 17:12:50 -0800
Message-ID: <160704437017.736504.13199098088562847416.stgit@magnolia>
In-Reply-To: <160704436050.736504.11280764290946254498.stgit@magnolia>
References: <160704436050.736504.11280764290946254498.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Detect file block mappings with a blockcount that's either so large that
integer overflows occur or are zero, because neither are valid in the
filesystem.  Worse yet, attempting directory modifications causes the
iext code to trip over the bmbt key handling and takes the filesystem
down.  We can fix most of this by preventing the bad metadata from
entering the incore structures in the first place.

Found by setting blockcount=0 in a directory data fork mapping and
watching the fireworks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d9a692484eae..de9c27ef68d8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6229,6 +6229,11 @@ xfs_bmap_validate_extent(
 	xfs_fsblock_t		endfsb;
 	bool			isrt;
 
+	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
+		return __this_address;
+	if (irec->br_startoff + irec->br_blockcount <= irec->br_startoff)
+		return __this_address;
+
 	isrt = XFS_IS_REALTIME_INODE(ip);
 	endfsb = irec->br_startblock + irec->br_blockcount - 1;
 	if (isrt && whichfork == XFS_DATA_FORK) {

