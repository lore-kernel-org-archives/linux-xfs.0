Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2B6C5517A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A9EA221E9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N4R6/iqy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbgKKAnb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:43:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55250 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKKAnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:43:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0ZB38041806;
        Wed, 11 Nov 2020 00:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LsWyiV8KDRBcLn56P5V3qKQOwRRwjsluHdN3zrQbKIY=;
 b=N4R6/iqyfl6XIkbjLQLD1Gh2JieBd6EgWs6/+HqCPSZAEnuEfv52NFKF6kZpuej6ex/Q
 +S/eAzxhN77SVypRYeVfPO2WZAPkfvhSlas7r8fxx28oSZokMikCzv26vzrgT9f/6qa4
 e8efzIN2spogUDnTkrCySty/okrAIfKdb2wIGIs+gDNcyySkqslJq/VD9kGFY+dkj8v1
 bhQWboYpjfyHVa19ir471e26UaWkkzkX0F8fHOSwBKpCqlPS4ekTFJSownt4hrGLrcaI
 hhy5yx1239Q5Fb5TShQJofilJd/7Q9vsZzwWzi0bP0kuo0mm2oU66I9R2CXJQPPj6/xv ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3axw27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:43:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0V7xh027794;
        Wed, 11 Nov 2020 00:43:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp7kqg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:43:29 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB0hSx1013620;
        Wed, 11 Nov 2020 00:43:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:43:27 -0800
Subject: [PATCH 3/6] common/populate: make sure _scratch_xfs_populate puts its
 files on the data device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:43:26 -0800
Message-ID: <160505540684.1388647.10815510555273538238.stgit@magnolia>
In-Reply-To: <160505537312.1388647.14788379902518687395.stgit@magnolia>
References: <160505537312.1388647.14788379902518687395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that _scratch_xfs_populate always installs its files on the
data device even if the test config selects rt by default.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/common/populate b/common/populate
index 0b036051..f4ad8669 100644
--- a/common/populate
+++ b/common/populate
@@ -154,6 +154,16 @@ _scratch_xfs_populate() {
 
 	_populate_xfs_qmount_option
 	_scratch_mount
+
+	# We cannot directly force the filesystem to create the metadata
+	# structures we want; we can only achieve this indirectly by carefully
+	# crafting files and a directory tree.  Therefore, we must have exact
+	# control over the layout and device selection of all files created.
+	# Clear the rtinherit flag on the root directory so that files are
+	# always created on the data volume regardless of MKFS_OPTIONS.  We can
+	# set the realtime flag when needed.
+	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 	crc="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep crc= | sed -e 's/^.*crc=//g' -e 's/\([0-9]*\).*$/\1/g')"
@@ -306,6 +316,7 @@ _scratch_xfs_populate() {
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
 		nr="$((blksz * 2 / 32))"
+		$XFS_IO_PROG -R -f -c 'truncate 0' "${SCRATCH_MNT}/RTRMAPBT"
 		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RTRMAPBT"
 	fi
 

