Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6242C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C6C21527
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uOnTliej"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444348AbgJ0TCO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:02:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48566 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410146AbgJ0TCN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:02:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsV3R111549;
        Tue, 27 Oct 2020 19:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HFSJOxpdSK3VULYP+EBTOaRwcAJPvxYcslqGRwY1J08=;
 b=uOnTliejaet6E9ttuk5mTWHbiiVQBE0Qg9WC6TDL6qF/7mgLjP6OUL3jmh1g+/TMEhgA
 onNkHrXjX19HNkzKqkwQjz3mQLP/RPo++bi3cVeILj66qJzNdKKP5uEHO+pgMoZORF16
 k61YXQZ6uP+fM0JEgOoiDfBJs1kD+kRqrq6LVcGfg/cUgTwDNhKek4jXPtS40gtU7oqt
 TTk2fbsDYxqEHhs12cy/1Amp+9gZ9GK+Fq1FzWjCB0jhtGnnrZ0Kd8PntrbjJvbC1D93
 vB0bhJj0bUKGWqxscDKM2Od1FGXHc84c6I+K9wiKFKBdm2pvw6H1Wi+MGlJUw8okVQKM Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm41eyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:02:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItLZL020077;
        Tue, 27 Oct 2020 19:02:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6wbmdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:02:10 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ2ADI001084;
        Tue, 27 Oct 2020 19:02:10 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:02:09 -0700
Subject: [PATCH 6/9] xfs/27[26]: force realtime on or off as needed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:02:08 -0700
Message-ID: <160382532889.1202316.11271089772377137054.stgit@magnolia>
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Certain tests have certain requirements where the realtime parameters
are concerned.  Fix them all.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/272 |    3 +++
 tests/xfs/276 |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/272 b/tests/xfs/272
index a9baf2e7..6c0fede5 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -37,6 +37,9 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
+# Make sure everything is on the data device
+$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 _pwrite_byte 0x80 0 737373 $SCRATCH_MNT/urk >> $seqres.full
 sync
 $here/src/punch-alternating $SCRATCH_MNT/urk >> $seqres.full
diff --git a/tests/xfs/276 b/tests/xfs/276
index 8b7e1de5..6e2b2fb4 100755
--- a/tests/xfs/276
+++ b/tests/xfs/276
@@ -35,9 +35,15 @@ _require_test_program "punch-alternating"
 rm -f "$seqres.full"
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mkfs | _filter_mkfs 2> "$tmp.mkfs"
+. $tmp.mkfs
+cat "$tmp.mkfs" > $seqres.full
 _scratch_mount
 
+# Don't let the rt extent size perturb the fsmap output with unwritten
+# extents in places we don't expect them
+test $rtextsz -eq $dbsize || _notrun "Skipping test due to rtextsize > 1 fsb"
+
 $XFS_IO_PROG -f -R -c 'pwrite -S 0x80 0 737373' $SCRATCH_MNT/urk >> $seqres.full
 sync
 $here/src/punch-alternating $SCRATCH_MNT/urk >> $seqres.full

