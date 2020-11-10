Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495D9C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF20E20809
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k1mQJlWS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbgKJSGF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:06:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46106 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730805AbgKJSGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:06:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHxoxf119596;
        Tue, 10 Nov 2020 18:06:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fDoXWcSJMPZIsqi7t8fb4TJkxNxeWLUck/vrCWHVz1s=;
 b=k1mQJlWS+3Zp0hfJR2Y4Zi8zlY7jW+HU1xiomjrob3Tjseq/0VvOkJNA6HSS0ag7KJfe
 C3t9FT5HaA3hYjYOKpCJ6HO++fp6E1xNenAovtpW4tRDFrbcZR+zoK4XtZZ3FcAJhbHH
 VufHqAQfnIIMXSK46ZqWF+T2gJM1Ppg+12L4qLPkiAdRjcCvCm5kXKIASVAVTMNqf/3S
 4P+lR78OCLG6S+xS7UI4Q2o9jYbpTRvtCrxViZ/WZOmvk+4GS3lftzO+Urg8E1TY0M9M
 d2kA5CGajwkMNJ67NLDbq/EEaxOy+Vx/iJDfzrPyU6jO3ucwHex830fr/Akb3Xzsu2/q vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34nkhkw275-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:06:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAI178d092870;
        Tue, 10 Nov 2020 18:04:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34qgp76mrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:04:02 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AAI41Sj021944;
        Tue, 10 Nov 2020 18:04:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:04:01 -0800
Subject: [PATCH 9/9] libxfs-apply: don't add duplicate headers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:04:00 -0800
Message-ID: <160503144025.1201232.11112616423278752638.stgit@magnolia>
In-Reply-To: <160503138275.1201232.927488386999483691.stgit@magnolia>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're backporting patches from libxfs, don't add a S-o-b header if
there's already one in the patch being ported.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/libxfs-apply |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 3258272d6189..35cdb9c3449b 100755
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
+	grep -q "^${hdr}$" "$hdrfile" || echo "$hdr" >> "$hdrfile"
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
 

