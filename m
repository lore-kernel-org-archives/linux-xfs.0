Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4D5C2BA17
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C8D0206B8
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:52:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ups+5uaO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgDFSwf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 14:52:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgDFSwe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 14:52:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Ii1I2008165;
        Mon, 6 Apr 2020 18:52:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+clQqJtXAQG3J61UCBVU7NdgM0TYGyCruCqrfe41qmo=;
 b=ups+5uaOARlLORLdRnrk+0mnTeZwcZ8CuPi+xj4Mqkl4Ku0HybdbHRSUyV3lK8CJhOlV
 6lBqHtg1cU5efJcfoIEKsANoCX7DS9Kg+GAtPGUFOa1gCmGZW1nMffKDQer9O1VVpsd0
 GdIUxb5EbnaPvpCKHbhrx+wFzBkOJ+2AaVaAdmAFWdqRsuUbX/lazMT6+H53W+JOnqUc
 RH+97Zo1DnyzAmEtTvdPF0Z4aqcavs7zuOaqrhDaADYwPD5mvVYaYnmd/J4LxNF7cM/n
 G8tha62vnrkbe5pH5KNanPQlHkS3gWHydqmMReQk8Dk6PhkRXiecg0XWsAqch6VemU49 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 306hnr0qy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IfPxF040719;
        Mon, 6 Apr 2020 18:52:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30741bcu79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:31 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 036IqVKb028842;
        Mon, 6 Apr 2020 18:52:31 GMT
Received: from localhost (/10.159.131.9)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 11:52:31 -0700
Subject: [PATCH 1/5] libxfs: don't barf in libxfs_bwrite on a null buffer
 ops name
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 06 Apr 2020 11:52:30 -0700
Message-ID: <158619915000.469742.14620929774691026014.stgit@magnolia>
In-Reply-To: <158619914362.469742.7048317858423621957.stgit@magnolia>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=844
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=906
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't crash if we failed to write a buffer that had no buffer verifier.
This should be rare in practice, but coverity found a valid bug.

Coverity-id: 1460462
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3c43a4d0..8a690269 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1028,7 +1028,7 @@ libxfs_bwrite(
 	if (bp->b_error) {
 		fprintf(stderr,
 	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
-			__func__, bp->b_ops->name,
+			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
 			(long long)bp->b_bn, bp->b_bcount, -bp->b_error);
 	} else {
 		bp->b_flags |= LIBXFS_B_UPTODATE;

