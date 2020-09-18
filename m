Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75194C43465
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AEA32078B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w/ulQWXT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgIRCIj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:08:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbgIRCIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 22:08:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I254on096672;
        Fri, 18 Sep 2020 02:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7X1FOUfX0O6+9WYPysj3uyalS4r6G8fNTyARC6J9rAs=;
 b=w/ulQWXTCx8PkMeiCtiZBE7qhXrf+juM6O4wK7HdFv9Cj6YILfhlI85FaDPSyA5ovAHh
 UPSDI9TaRKNHBfKmOvI6HdFM+PwDDROGDVLg9IHUcCiQ2F/Kn1TR8Mbc6vsF5Y1vtFVU
 /wRYF1TCJ1nH82p5PtB4HhpVoyRxKDjLz+N09lLgGqlW7yLaV1+1eekhowDNfRX9l7Jv
 wLwzH16AbilTdpJ+RlZ+eoomYe2AZoltXW447usyJvGpFker+blj89L/dHzlwBDmFxmc
 a/ZzSvrKIU1NYVrw+1FxQPnUPjRSlsBJnptLLZpMFhrjBN3+gWrWqN+7H1A1nNeEVJKT ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dx77g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 02:08:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I266PG081898;
        Fri, 18 Sep 2020 02:08:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33khpny3ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 02:08:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08I28YSc003866;
        Fri, 18 Sep 2020 02:08:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 02:08:33 +0000
Date:   Thu, 17 Sep 2020 19:08:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 21/24] common/rc: teach _scratch_mkfs_sized to set a size
 on an xfs realtime volume
Message-ID: <20200918020833.GI7954@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013430895.2923511.7033338053997588353.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013430895.2923511.7033338053997588353.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180018
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
v2: don't bother with HOSTOS
---
 common/rc |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 6366a7b2..b707db76 100644
--- a/common/rc
+++ b/common/rc
@@ -997,14 +997,20 @@ _scratch_mkfs_sized()
 	[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
     fi
 
+    if [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then
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
