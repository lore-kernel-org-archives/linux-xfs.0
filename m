Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE61C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D930214F1
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:45:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TLJgxuxY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgIOBpJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:45:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45998 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgIOBpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:45:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1iBUt147465;
        Tue, 15 Sep 2020 01:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yUMD9a5OoiDxVogijMMpxGUcklEVM6umGk+hlhTUJ0Y=;
 b=TLJgxuxYr0pOu/Rrl40sugcviDG3j5NgEyMgX5hP8VGzu6JN/lQeGrp7QXLUR+PKC5v7
 L/OkKDl8j3ssKekBbbj+O5fZTzNLMJdM1wv/W0b6eklPu95o3Fip5d0/SgBxqPYhReV5
 ODbFbP6Vnyc6kSRjWV9xdepTfFEUfCtZXRTDjzFumfnJi4xjmeEU5pe9KQMoZQzn2h8K
 qnJ5pEjB/Zq9C7VmMLGOGGC4qwNve1PzAW3G2O4/tgril9dBE/1vp3Y/ZHplEuW29iBO
 jHgHQvySl0AsIYBVSsp1Ku2q8orvzd5b6GAmF3eOPN3FF3RUH8wRgthXEpbbfqx8Ny7K Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrqsxxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:45:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1fPfR109437;
        Tue, 15 Sep 2020 01:45:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33h883824p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:45:04 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1j3HT001660;
        Tue, 15 Sep 2020 01:45:03 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:45:03 +0000
Subject: [PATCH 20/24] xfs/449: fix xfs info report output if realtime device
 specified
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:45:02 -0700
Message-ID: <160013430267.2923511.8202421356162568130.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Modify the mkfs.xfs output so that "realtime =/dev/XXX" becomes
"realtime =external" so that the output will match xfs_db, which doesn't
take a rt device argument and thus does not know.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/449 |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/449 b/tests/xfs/449
index 83c3c493..938dbe28 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -46,7 +46,9 @@ cat $tmp.mkfs >> $seqres.full
 _scratch_xfs_db -c "info" > $tmp.dbinfo
 echo DB >> $seqres.full
 cat $tmp.dbinfo >> $seqres.full
-diff -u $tmp.mkfs $tmp.dbinfo
+# xfs_db doesn't take a rtdev argument, so it reports "realtime=external".
+# mkfs does, so make a quick substitution
+diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
 
 _scratch_mount
 

