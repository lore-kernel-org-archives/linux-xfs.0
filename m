Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFE0C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D642E212CC
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tywnuZG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgIOBoY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:44:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgIOBoX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:44:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1iIsf059131;
        Tue, 15 Sep 2020 01:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9d9M48UUJDIoK4CIWIBWIUF892H74kEBloIOiACd2S4=;
 b=tywnuZG+6mjTctaeD3hrHG1EAG9CVykGdXew/1E0KeOWh7E8y4h4MrF+2tsM2bHMPc7Z
 F8HkSP4ddEyiFrwX7f/oBabkmkDmnirtwR8eHNkSayAEyA7+9dMjElo3DQQd5wNQhDSD
 kbNV9dQJ8AJv93N4ynjLxFuLevsYLllNbo+T1xpn+GC+Fa/sNODq5sNs2boBHi1wiD3b
 HKpy8REHAUOdGUiXMqEgh6u9iA4nFr0QHgGE6rLIHzIZGLkVgoYgiyrnPDthFzQwtTB0
 ICHYDwH40ghzl6mdH8CmrIfo35IsvOG/jAYYQ/kvXOSVqbN0Oc2Am5aPjp0LrTlV8brB aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dbhnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:44:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1duK8076080;
        Tue, 15 Sep 2020 01:44:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33h7wn6hd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:44:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1iJIL007122;
        Tue, 15 Sep 2020 01:44:19 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:44:19 +0000
Subject: [PATCH 13/24] generic/204: don't flood stdout with ENOSPC messages on
 an ENOSPC test
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:44:18 -0700
Message-ID: <160013425839.2923511.10488499486430760605.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test has been on and off my bad list for many years due to the fact
that it will spew potentially millions of "No space left on device"
errors if the file count calculations are wrong.  The calculations
should be correct for the XFS data device, but they don't apply to other
filesystems.

Therefore, filter out the ENOSPC messages when the files are not going
to be created on the xfs data device (e.g. ext4, xfs realtime, etc.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/204 |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/tests/generic/204 b/tests/generic/204
index 349f5eff..7250c00a 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -76,9 +76,13 @@ files=$((space / (direntlen + isize + dbsize)))
 echo files $files, resvblks $resv_blks >> $seqres.full
 _scratch_resvblks $resv_blks >> $seqres.full 2>&1
 
+filter() {
+	test $FSTYP != xfs && sed -e '/No space left on device/d'
+}
+
 for i in `seq -w 1 $files`; do
-    echo -n > $SCRATCH_MNT/$i
-    echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
+	(echo -n > $SCRATCH_MNT/$i;
+	 echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i) 2>&1 | filter
 done
 
 # success, all done

