Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6FFC3524D
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33A42214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b2Q7l73k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgBEACL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:02:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgBEACL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:02:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NweL2076146;
        Wed, 5 Feb 2020 00:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pFAsHql0ujcNiWWxUCfZWYtIKsSA12QYWWheoFfn0W4=;
 b=b2Q7l73kG8Yb6KuCFvRLLpfvfhJdfuNv9JnNhni9IXhdbESMRrUiBnIJiwJ7zfPyfvKI
 lp4x2YM6bLQ4S/1r/8lyHdd5fgGinCBK8E+pK/38MVVgCfaPvdWxgRCYjiFDpQ6FlHGO
 uNlnarF0RT6zAREeUMAXByL9MofplBMXMW1VW9M8Qm8VAg880j6PWZxBj91cJLo9vTDS
 1raThpolby2srdN7KYWTUKIhlFnH3RDmSnq1umYt3lLA8DtwDrpXQxLN741ezVR3ZU49
 6Q/knwFLVgiBviSJhUEAOvd6NjN3SCvDrUdyH/jzl2PiQtTbKAhMZvPYzJy0AItwvB6r Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xyhkfg8c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NxELu036594;
        Wed, 5 Feb 2020 00:02:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xyhmqwaww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 015028A9021866;
        Wed, 5 Feb 2020 00:02:08 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:02:07 -0800
Subject: [PATCH 4/5] xfs/117: fix inode corruption loop
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:02:07 -0800
Message-ID: <158086092701.1989378.15455195869104309401.stgit@magnolia>
In-Reply-To: <158086090225.1989378.6869317139530865842.stgit@magnolia>
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=996
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

`seq X Y` will print all numbers between X and Y, including Y.  Since
inode chunks contain inodes numbered from X to X+63, we need to set the
loop variables correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/117 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/117 b/tests/xfs/117
index 0a7831d5..e3249623 100755
--- a/tests/xfs/117
+++ b/tests/xfs/117
@@ -70,7 +70,7 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ corrupt image"
-seq "${inode}" "$((inode + 64))" | while read ino; do
+seq "${inode}" "$((inode + 63))" | while read ino; do
 	_scratch_xfs_db -x -c "inode ${ino}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 

