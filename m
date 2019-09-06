Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13D6C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA95E2082C
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="loVyS6yl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392152AbfIFDih (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:38:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44662 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392146AbfIFDih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:38:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YUqd074698;
        Fri, 6 Sep 2019 03:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=on1+A8FomuxiRkvyrWNovC5Tib37Rb5iUHxgWJMkgEI=;
 b=loVyS6ylRxYjuQUKjtcMfPvrh0coVBcARsz4yGiwugNFeUTdZm7PinDkXpI7zYaFpAUw
 3bsySNuc1d66gjsRYDtczhiD/YcdiwDjTrG2+oKiEZtbxfydasm3GG7Qw2Sy8m/tcCN2
 hHq65VzU7pgaM+MOaz/B/GhgdmiLFx5EyASQ2fZVo3hT2y7WHdxW3a8GLni4iCY1Xr8N
 9aakRnNj8x8K2XCP5etXO192G//xG/KeANJ8tPK5x4oLzNRjRYTGS6bXL4QAY5ymfGql
 q7E+RRH1BA+ES7a1JjFjFJHZBFUXEsnhkhp4yy1FBxiblZ4LRky7tPS6pjiG//c42JYX HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uuf51g3bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:38:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cRQl078087;
        Fri, 6 Sep 2019 03:38:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2utvr4jxvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:38:34 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863cXLj005667;
        Fri, 6 Sep 2019 03:38:33 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:38:33 -0700
Subject: [PATCH 08/11] xfs_scrub: enforce read verify pool minimum io size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:38:32 -0700
Message-ID: <156774111276.2645135.1979781895407724434.stgit@magnolia>
In-Reply-To: <156774106064.2645135.2756383874064764589.stgit@magnolia>
References: <156774106064.2645135.2756383874064764589.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we always issue media verification requests aligned to the
minimum IO size that the caller cares about.  Concretely, this means
that we only care about doing IO in filesystem block-sized chunks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/read_verify.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 73d30817..9d9be68d 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -77,6 +77,15 @@ read_verify_pool_alloc(
 	struct read_verify_pool		*rvp;
 	int				ret;
 
+	/*
+	 * The minimum IO size must be a multiple of the disk sector size
+	 * and a factor of the max io size.
+	 */
+	if (miniosz % disk->d_lbasize)
+		return EINVAL;
+	if (RVP_IO_MAX_SIZE % miniosz)
+		return EINVAL;
+
 	rvp = calloc(1, sizeof(struct read_verify_pool));
 	if (!rvp)
 		return errno;
@@ -245,6 +254,11 @@ read_verify_schedule_io(
 	int				ret;
 
 	assert(rvp->readbuf);
+
+	/* Round up and down to the start of a miniosz chunk. */
+	start &= ~(rvp->miniosz - 1);
+	length = roundup(length, rvp->miniosz);
+
 	rv = ptvar_get(rvp->rvstate, &ret);
 	if (ret)
 		return ret;

