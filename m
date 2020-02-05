Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7006C3524D
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B7D721744
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:01:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YNchd+7u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgBEABx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:01:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42398 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbgBEABw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:01:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NwqQP086013;
        Wed, 5 Feb 2020 00:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yoHjzEoLeU4OqrWJ4cCJO0a5dvQ9kLQmXeRaDfXK/vo=;
 b=YNchd+7ui8SReqXT0AuG+GrzwXkdzfufU5luZy5uCG6scDHrzWQBopEoa3DMylsIeGs/
 bpLdo2SsZ9dDgjPTpZv+tJuL++P3qMzU5RRg6OXFf9bIQfUSRsMhx1vA6MabwI3cz3ww
 cTre5PoHeZD5zCtrvG2+NnJi/uzGhYINe/XWRb5ljq1fDQ4/M0LxJFj2jEdxg0aoir+F
 nMPTWx68eKatRlYbUE21UsAhVxCcYnMAtnMhLNV1AgwOkO1kJmTv6cQNER34h/KyX+k7
 60+2FlYEBBu+rX1L0/FxtHowRf1QGbd6a3PTM7IKkaCdtKia1fxM0hv5WneTa08CQ1OR Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xyhkf88a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:01:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NwrJ1059200;
        Wed, 5 Feb 2020 00:01:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xyhmq3gmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:01:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01501nwr022436;
        Wed, 5 Feb 2020 00:01:49 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:01:49 -0800
Subject: [PATCH 1/5] xfs/449: filter out "Discarding..." from output
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:01:48 -0800
Message-ID: <158086090849.1989378.625300470019425718.stgit@magnolia>
In-Reply-To: <158086090225.1989378.6869317139530865842.stgit@magnolia>
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfsprogs 5.4 prints "Discarding..." if the disk supports the trim
command.  Filter this out of the output because xfs_info and friends
won't print that out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/449 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/449 b/tests/xfs/449
index 7aae1545..83c3c493 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -39,7 +39,7 @@ _require_scratch_nocheck
 _require_xfs_spaceman_command "info"
 _require_command "$XFS_GROWFS_PROG" xfs_growfs
 
-_scratch_mkfs > $tmp.mkfs
+_scratch_mkfs | sed -e '/Discarding/d' > $tmp.mkfs
 echo MKFS >> $seqres.full
 cat $tmp.mkfs >> $seqres.full
 

