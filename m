Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8160C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86523206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oNNG3v22"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgFBE33 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:29:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBE33 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:29:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524IvBT134904;
        Tue, 2 Jun 2020 04:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mXy5YEuIaZGeAvHZOI1Kt5Bqd63avZ3RVwpo2nDf6w0=;
 b=oNNG3v22Xf9mbMZyomoFevswdjixJQ6LdoYX71jXCLD0FT+fkMTRKJcB1s6NM3wRv5gS
 moXw8pmWvM3jysq1UQvw1ZQPIPCXr19sijcW2uqIr2ul4OdFk6PiPbAGU3326DwlfC6p
 gxcVSnIEAgQ87DlzYkcbApvg0xlr7KG52+GvXTlo2JEEjwyODsUhiKWIVoodVME48Ziy
 aWCBIWH5uSdjlMyMcmGrZB1hraZmGihuUAy/k6Pbe1VciySQTcot/2ABPf/LWxRLTIGr
 kEhB/TYMfxwDvUlpFOQUunZB8WUoszcut9fLQBlwoMzu5zBN75S0XLUCUn+MRUVzDOKh Aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31d5qr20rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:27:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Hv9H040104;
        Tue, 2 Jun 2020 04:25:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31c18sgg57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:25:23 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524PMM6020412;
        Tue, 2 Jun 2020 04:25:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:25:22 -0700
Subject: [PATCH 03/17] xfs_repair: warn when we would have rebuilt a directory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:21 -0700
Message-ID: <159107192170.313760.304032041602234316.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

longform_dir2_entry_check should warn the user when we would have
rebuilt a directory had -n not been given on the command line.  The
missing warning results in repair returning 0 (all clean) when in fact
there were things that it would have fixed.

Found by running xfs/496 against lents[0].hashval = middlebit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index 5e3b394a..b6391326 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2425,6 +2425,9 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		*num_illegal = 0;
 		*need_dot = 0;
 	} else {
+		if (fixit || dotdot_update)
+			do_warn(
+	_("would rebuild directory inode %" PRIu64 "\n"), ino);
 		for (i = 0; i < num_bps; i++)
 			if (bplist[i])
 				libxfs_buf_relse(bplist[i]);

