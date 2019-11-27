Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB60C43215
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 04:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 366C92071E
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 04:16:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mrCf/uNU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfK0EQH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 23:16:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37794 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfK0EQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 23:16:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR44a78091595;
        Wed, 27 Nov 2019 04:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=pPvfybOe71hsOYKViqA12mPSC1vD4lD86Yi3OoKDTs4=;
 b=mrCf/uNUJl0vGze1d2cZWHhSN0N+749zzBbJzsqfgp8nmrtC+w+Zzklk3w673Vji0745
 RoQmz4onrMAqszhaYlyc5QLj579Bf98SjozS5pWFjSHTgaxzXmx1Yw2AfCEhDa+ZSxTN
 zVZpOjXGDSaoXnZqPSmGcJrDLgD7dVxXcwg9YuLmAWvkL4G5DBRrK+Tc3d5+ZjQEh5Gf
 EJx497Ta5EuaTsq3IBlNrVxjThJxfcEAYEmoNy/KvSBgyzXyh+R9z0ywS/iyJho4CGH6
 p8upzkD1hiuDX2zOpuXjBKSEaWdVxALnTBnmsXquvb7A8mLy0e8L/eTDukDf2gbKyDID AA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wevqqav0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 04:16:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR448Li120333;
        Wed, 27 Nov 2019 04:16:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wgwuttk6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 04:16:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAR4G3sG027418;
        Wed, 27 Nov 2019 04:16:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 20:16:03 -0800
Date:   Tue, 26 Nov 2019 20:16:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic/558: require scratch device
Message-ID: <20191127041602.GI6212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test formats the scratch device, so require it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/558 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/558 b/tests/generic/558
index c05aa961..28f4c0e1 100755
--- a/tests/generic/558
+++ b/tests/generic/558
@@ -45,6 +45,7 @@ create_file()
 _supported_fs generic
 _supported_os Linux
 _require_inode_limits
+_require_scratch
 
 rm -f $seqres.full
 echo "Silence is golden"
