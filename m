Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BF3C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1CE62081E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:11:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nZsnw3EU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgAPFLM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:11:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgAPFLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:11:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G58W5P154302;
        Thu, 16 Jan 2020 05:11:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RLvGIBPKpdmH/89mG00PtIWT7eDarZM2ZQVsoBf85E8=;
 b=nZsnw3EUnQ/RugmRXB7Wxc5i1bjMxxCFyLMRIClIEscmUAgBH+rdXyt8+pNcRw/4b0/q
 J7Dzf1+UrFIQih519wXg672LhxqjUuW90hEUtDXV2BDTPXuiVgmUcqNszlOtZ92HXd58
 H89D5DdtwLDdbYT9teLXZVG0VyXjKOS1E0z5ohZ7YBVPl+iyBEhLRKswHmCRQ+Lw7Fml
 PIpWF1UNt58sGJUlMhP1z2M7ueA2vw+mlvr5rqv8cnEqJUrSIZgqlAs16/thtnFIqwIH
 QqKMyxkxSRUZ1KCDFuOB0NOCIkFdNzZIiApvq/7UYUP1BAggi4Ux4Wn0Xih1zSp7uatc Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xf73u04pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59O9e097276;
        Thu, 16 Jan 2020 05:11:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xhy22mrge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:08 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G5B8WW000732;
        Thu, 16 Jan 2020 05:11:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:11:07 -0800
Subject: [PATCH 5/7] rc: fix _get_max_lfs_filesize on 32-bit platforms
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:11:07 -0800
Message-ID: <157915146694.2374854.4708773619544238610.stgit@magnolia>
In-Reply-To: <157915143549.2374854.7759901526137960493.stgit@magnolia>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The 32-bit calculation of the maximum filesize is incorrect.  Replace it
with the formula that the kernel has used since commit 0cc3b0ec23ce
("Clarify (and fix) MAX_LFS_FILESIZE macros").  This fixes a regression
in generic/351 on 32-bit kernels.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index eeac1355..cf6bc9d5 100644
--- a/common/rc
+++ b/common/rc
@@ -3999,7 +3999,9 @@ _get_max_lfs_filesize()
 {
 	case "$(getconf LONG_BIT)" in
 	"32")
-		echo $(( ($(getconf PAGE_SIZE) << ($(getconf LONG_BIT) - 1) ) - 1))
+		local ulong_max=$(getconf ULONG_MAX)
+		local page_size=$(getconf PAGE_SIZE)
+		echo $(( ulong_max * page_size ))
 		;;
 	"64")
 		echo 9223372036854775807

