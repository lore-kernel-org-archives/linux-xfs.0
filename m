Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C66C56201
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 20:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0729F207BC
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 20:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hwQlmyy1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgKYUkG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 15:40:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45192 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbgKYUkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 15:40:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKOfHX035997;
        Wed, 25 Nov 2020 20:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LhOi39AblOhysnC8tMKB8RPxnquedAXf8slOxzCDvnw=;
 b=hwQlmyy1XPqxMGplKw/RpcJp1Tfjs5PxxIQV5H5RGUH3FTmOhSUborqh2iw/1p/aFEoV
 IyV90vTjzyIgAIGApsHl7dz2CjWdEJkNB0JCdX31vD3WS2GwSO7MLB5euxEN8mms5CwL
 L43HHl+bZRYWoPGfe9Vk/B8Ftna6aJy3kmS8ZThJZEybWL6pl3wAQQD8krWm2YxOy1g2
 oyghwn7EiaZSIplmi579KGCYkNmZGB2QDqgqTtY1hYzOomxRSk0LV/0Azabcp++1FfZy
 JsMyTZ0cRRfP2DExtf3kO9A7IwfauTYixFEr7kpCCPmPkUaM7xX+f8K0ZO9N5ucpWdpO 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 351kwhkbmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 25 Nov 2020 20:40:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKPg3D117343;
        Wed, 25 Nov 2020 20:38:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 351kwevga2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 20:38:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0APKc3x9004348;
        Wed, 25 Nov 2020 20:38:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Nov 2020 12:38:02 -0800
Subject: [PATCH 1/5] libxfs-apply: don't add duplicate headers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Nov 2020 12:38:02 -0800
Message-ID: <160633668210.634603.16132006317248436755.stgit@magnolia>
In-Reply-To: <160633667604.634603.7657982642827987317.stgit@magnolia>
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011250127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're backporting patches from libxfs, don't add a S-o-b header if
there's already one at the end of the headers of the patch being ported.

That way, we avoid things like:
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/libxfs-apply |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 3258272d6189..9271db380198 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -193,6 +193,14 @@ filter_xfsprogs_patch()
 	rm -f $_libxfs_files
 }
 
+add_header()
+{
+	local hdr="$1"
+	local hdrfile="$2"
+
+	tail -n 1 "$hdrfile" | grep -q "^${hdr}$" || echo "$hdr" >> "$hdrfile"
+}
+
 fixup_header_format()
 {
 	local _source=$1
@@ -280,13 +288,13 @@ fixup_header_format()
 	sed -i '${/^[[:space:]]*$/d;}' $_hdr.new
 
 	# Add Signed-off-by: header if specified
-	if [ ! -z ${SIGNED_OFF_BY+x} ]; then 
-		echo "Signed-off-by: $SIGNED_OFF_BY" >> $_hdr.new
+	if [ ! -z ${SIGNED_OFF_BY+x} ]; then
+		add_header "Signed-off-by: $SIGNED_OFF_BY" $_hdr.new
 	else	# get it from git config if present
 		SOB_NAME=`git config --get user.name`
 		SOB_EMAIL=`git config --get user.email`
 		if [ ! -z ${SOB_NAME+x} ]; then
-			echo "Signed-off-by: $SOB_NAME <$SOB_EMAIL>" >> $_hdr.new
+			add_header "Signed-off-by: $SOB_NAME <$SOB_EMAIL>" $_hdr.new
 		fi
 	fi
 

