Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FA8C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 20:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A20B820791
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 20:52:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0Fk3QosJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405322AbgFYUwi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 16:52:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405230AbgFYUwh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 16:52:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PKlx4U047319;
        Thu, 25 Jun 2020 20:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SQWU5THf1dMHGKvS+QLyXkOGjRAuQ527TyOTawK4zWk=;
 b=0Fk3QosJpjOLk8xikoHFb7odBYqrzwivAOMDB3W7Ad2vpPk403nMpEA7RzeXPCUcbyin
 xu7geqTz0490ybYc6nOBnAdk5auofsETrSkRUPo4BHt/+LKvaYQiwvrXquL+ANimCr37
 pmLgA1VWu2oYjyamB0uqLCHFx0zqCuF1+JxLZ8HTo+Gq4g/Vcx/XnFKrnKBBpSYX0g5s
 HxYpXR3D3IdEG7sIgOakzr0nZFrODsYg+8dE1i2sGCm1vSKKIoH0O91dPhQIYy1lGsra
 yPoZjM6apONJTz9qmxAeVfL+egIYVmiyH3yRqei4/IyQh1pthVF2251anZkYKIhDTwOu 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31uusu2t36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 20:52:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PKmHwd070819;
        Thu, 25 Jun 2020 20:52:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31uur9k9bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 20:52:34 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PKqX3a025547;
        Thu, 25 Jun 2020 20:52:33 GMT
Received: from localhost (/10.159.246.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 20:52:33 +0000
Subject: [PATCH 1/2] xfs_repair: complain about ag header crc errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 25 Jun 2020 13:52:32 -0700
Message-ID: <159311835284.1065505.8957820680195453723.stgit@magnolia>
In-Reply-To: <159311834667.1065505.8056215626287130285.stgit@magnolia>
References: <159311834667.1065505.8056215626287130285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=2 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Repair doesn't complain about crc errors in the AG headers, and it
should.  Otherwise give the admin the wrong impression about the
state of the filesystem after a nomodify check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/repair/scan.c b/repair/scan.c
index 505cfc53..42b299f7 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2441,6 +2441,8 @@ scan_ag(
 		objname = _("root superblock");
 		goto out_free_sb;
 	}
+	if (sbbuf->b_error == -EFSBADCRC)
+		do_warn(_("superblock has bad CRC for ag %d\n"), agno);
 	libxfs_sb_from_disk(sb, sbbuf->b_addr);
 
 	error = salvage_buffer(mp->m_dev,
@@ -2450,6 +2452,8 @@ scan_ag(
 		objname = _("agf block");
 		goto out_free_sbbuf;
 	}
+	if (agfbuf->b_error == -EFSBADCRC)
+		do_warn(_("agf has bad CRC for ag %d\n"), agno);
 	agf = agfbuf->b_addr;
 
 	error = salvage_buffer(mp->m_dev,
@@ -2459,6 +2463,8 @@ scan_ag(
 		objname = _("agi block");
 		goto out_free_agfbuf;
 	}
+	if (agibuf->b_error == -EFSBADCRC)
+		do_warn(_("agi has bad CRC for ag %d\n"), agno);
 	agi = agibuf->b_addr;
 
 	/* fix up bad ag headers */

