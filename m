Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A3EC4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB6B720878
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k6Pr/LBF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444538AbgJ0TCd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:02:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55898 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410146AbgJ0TCc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:02:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItXO4022089;
        Tue, 27 Oct 2020 19:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BWEJZAdbHuzmGHpCdp0K1nbgZ+Zl3a8MnBf5mulTQsg=;
 b=k6Pr/LBFazGIGZjaB3G7rwO5uKhzLI4uCCUKRFdtT/baR/Ljy0whYmRE7V5CYyjZW4rs
 CJleFvEbvkK7XLu/ny+nT2QaD1evUoRjBcHu1aV0S2O2i3phkGiu13WUsY5RwfOGWm67
 g2uH3mGQfKOICHVziKBKo/PZA1Z0DYNrj/ZHvoghMyBUJrTaB6nbOrRtk3DRt1qxJLvc
 Aw/A6KyCAprz3kjEL8TE2JwBSN0oxJSu8fQB84sSHd7exy91ueWjW66UuMOynHDRo7a3
 gasPejPctUCIbcBT/WZsqOkAW9MknJizik6dY0ayOYZyqSSWWVQTvr5WLLCwfxvGTDFX Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sav066-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:02:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIu24m133026;
        Tue, 27 Oct 2020 19:02:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx5xg8ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:02:29 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ2SE1027470;
        Tue, 27 Oct 2020 19:02:28 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:02:28 -0700
Subject: [PATCH 9/9] common/populate: make sure _scratch_xfs_populate puts its
 files on the data device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:02:27 -0700
Message-ID: <160382534741.1202316.10109027018039105023.stgit@magnolia>
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that _scratch_xfs_populate always installs its files on the
data device even if the test config selects rt by default.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/common/populate b/common/populate
index 0b036051..75e6f499 100644
--- a/common/populate
+++ b/common/populate
@@ -154,6 +154,10 @@ _scratch_xfs_populate() {
 
 	_populate_xfs_qmount_option
 	_scratch_mount
+
+	# Make sure the new files always end up on the data device
+	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 	crc="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep crc= | sed -e 's/^.*crc=//g' -e 's/\([0-9]*\).*$/\1/g')"
@@ -306,6 +310,7 @@ _scratch_xfs_populate() {
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
 		nr="$((blksz * 2 / 32))"
+		$XFS_IO_PROG -R -f -c 'truncate 0' "${SCRATCH_MNT}/RTRMAPBT"
 		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RTRMAPBT"
 	fi
 

