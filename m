Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E39C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC0E214F1
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rV4t1KZO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgIOBpO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:45:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51232 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgIOBpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:45:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1ilop031237;
        Tue, 15 Sep 2020 01:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/UENgHT+JqPB1/laXzd4VJ3skakw2bdCBXg+VAmTEiU=;
 b=rV4t1KZObpnCKm1rZOmjFAWhU7Wiq2+hDr5W22ZI5TpeGx1QbD2LW3MydR0V3Sarjb7P
 W1jJViIyyXYu1n/iQpnJGxtmeesSZY35p30M7uJzHlXgWn/QK2jVpOm8iA3zJ/AqhU9D
 gzCssJieuOg4/EW7igmkJXDsK4RPjFDr4j7UVk+xRODUV7iYSaSyqfSBJhQKBgkUlTgz
 nYmkGvv3XclMYjghHkFSZVrScvkuivcDIYpBoWPqb3rwYf2JGOe93n/y6egED/I+t5ZB
 bjIcsAJENdiJ0rxO6jvU30PRKQ8ZDWqK1nITOyQYlZH10Mb3ARbBxPAjF6tlLMnUriq3 ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9m1wus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:45:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dsuI075952;
        Tue, 15 Sep 2020 01:45:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33h7wn6jdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:45:10 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1jAAB004718;
        Tue, 15 Sep 2020 01:45:10 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:45:10 +0000
Subject: [PATCH 21/24] common/rc: teach _scratch_mkfs_sized to set a size on
 an xfs realtime volume
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:45:08 -0700
Message-ID: <160013430895.2923511.7033338053997588353.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Generally speaking, tests that call _scratch_mkfs_sized are trying to
constrain a test's run time by formatting a filesystem that's smaller
than the device.  The current helper does this for the scratch device,
but it doesn't do this for the xfs realtime volume.

If fstests has been configured to create files on the realtime device by
default ("-d rtinherit=1) then those tests that want to run with a small
volume size will instead be running with a huge realtime device.  This
makes certain tests take forever to run, so apply the same sizing to the
rt volume if one exists.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/common/rc b/common/rc
index f78b1cfc..b2d45fa2 100644
--- a/common/rc
+++ b/common/rc
@@ -976,14 +976,20 @@ _scratch_mkfs_sized()
 	[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
     fi
 
+    if [ "$HOSTOS" == "Linux" ] && [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then
+	local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
+	[ "$fssize" -gt "$rtdevsize" ] && _notrun "Scratch rt device too small"
+	rt_ops="-r size=$fssize"
+    fi
+
     case $FSTYP in
     xfs)
 	# don't override MKFS_OPTIONS that set a block size.
 	echo $MKFS_OPTIONS |egrep -q "b?size="
 	if [ $? -eq 0 ]; then
-		_scratch_mkfs_xfs -d size=$fssize
+		_scratch_mkfs_xfs -d size=$fssize $rt_ops
 	else
-		_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
+		_scratch_mkfs_xfs -d size=$fssize $rt_ops -b size=$blocksize
 	fi
 	;;
     ext2|ext3|ext4|ext4dev)

