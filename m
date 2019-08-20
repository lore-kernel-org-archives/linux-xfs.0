Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41460C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EE862082F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z9JhSGFF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfHTUbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:31:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730704AbfHTUbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:31:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTJL1166356;
        Tue, 20 Aug 2019 20:31:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=a4Ae/ui4mUzj5LTuy5Kzv3nR5vwNUiZsRpdH/6w0om4=;
 b=Z9JhSGFFvqS8vbDCXIvwFlxRPYh5t6L4Hqc3Y9umLZXGwqQiwfXMsM05+wX+Rmm4JRSf
 TvHVlhrI/OwuQs3TfA9APwCCBn35WqU3TcD6QsDHoxIuEb4Cc57NIoS4hi9HO9kp/3mm
 PZYm3wtBUDs8SZyFA77f7IsyyhHJvSTuSQRwLUF7RDbbK/OKJ6e2nCwmsCdNWZex7Ruj
 Jv9bJxz4uJ3vpHXXy4+kmfhRNYWQjHNLUMjtGm3k5Clg48HKdkqzxX/Nnkx/3q4K1j5y
 Zp3yOBAJ8y7CK3mOVcCffGTJ2upY4hYyXBlQWhCvmdPJEesTMH0DYN7s6bkzDYt5Plqh qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uea7qs0d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTCW4071301;
        Tue, 20 Aug 2019 20:31:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ugj7pnekg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:19 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKVJUl019752;
        Tue, 20 Aug 2019 20:31:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:31:18 -0700
Subject: [PATCH 01/12] libxfs-diff: try harder to find the kernel equivalent
 libxfs files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:31:17 -0700
Message-ID: <156633307795.1215978.8644291951311062567.stgit@magnolia>
In-Reply-To: <156633307176.1215978.17394956977918540525.stgit@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we're syncing userspace libxfs/ files with kernel fs/xfs/
files, teach the diff tool to try fs/xfs/xfs_foo.c if
fs/xfs/libxfs/xfs_foo.c doesn't exist.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/libxfs-diff |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tools/libxfs-diff b/tools/libxfs-diff
index fa57c004..c18ad487 100755
--- a/tools/libxfs-diff
+++ b/tools/libxfs-diff
@@ -22,5 +22,6 @@ dir="$(readlink -m "${dir}/..")"
 
 for i in libxfs/xfs*.[ch]; do
 	kfile="${dir}/$i"
+	test -f "${kfile}" || kfile="$(echo "${kfile}" | sed -e 's|libxfs/||g')"
 	diff -Naurpw --label "$i" <(sed -e '/#include/d' "$i") --label "${kfile}" <(sed -e '/#include/d' "${kfile}")
 done

