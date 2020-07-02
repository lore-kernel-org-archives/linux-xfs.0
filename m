Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5E2C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6887C2073E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N9zvbi9z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgGBP1D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 11:27:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgGBP1C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 11:27:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FMWDM186945;
        Thu, 2 Jul 2020 15:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5mussjs/5BC7Vkixw+efYmkR2hduC60wv+pDg2e6Xbw=;
 b=N9zvbi9zAbF9aRF2yfn8oiRr/8X8Hs86OcjA9h/WunRFx0g7lEpGIsA7tpfsk9kRirk1
 ijTHpi0kB0F/ihpyEbNvGElA95Qw93Cwymfx9MPxhmCf5sJbr0dBbxXSpwgW7b/9Deq0
 gooY1HcnMn80WkgNauFXnR7LmsksmxKarq1iNUtBlenKwERgyEC+lZ6xrU1aHnXrP3fn
 7HXy+XmNrMo7ifaIf4dkzCWDOH2KwnP621LSX0i12jkSLyZSGIdRQ+0PRCmWRGN7QS54
 wrVUpJvjjgibVn961WXsCILFEOmjY1x8kQXXgnWQLHiqBMM6PbD+VU1BLm2+hbSRrTYj Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31xx1e5yc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 15:26:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FN4kK033126;
        Thu, 2 Jul 2020 15:26:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31xg19jjky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 15:26:58 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 062FQvZc003664;
        Thu, 2 Jul 2020 15:26:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 15:26:57 +0000
Subject: [PATCH 1/3] xfs_repair: complain about ag header crc errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 02 Jul 2020 08:26:56 -0700
Message-ID: <159370361687.3579756.17807287829667417464.stgit@magnolia>
In-Reply-To: <159370361029.3579756.1711322369086095823.stgit@magnolia>
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=2 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=2 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020107
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Repair doesn't complain about crc errors in the AG headers, and it
should.  Otherwise, this gives the admin the wrong impression about the
state of the filesystem after a nomodify check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

