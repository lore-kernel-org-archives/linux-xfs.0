Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE6AC33CB7
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 800282077B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:11:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="THqqVBe9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgAPFL0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:11:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52500 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgAPFLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:11:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59DDh193165;
        Thu, 16 Jan 2020 05:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=A18qrB6XgGzak+9jhg/cWndz4SCdqDc5oK4aQN4JJV4=;
 b=THqqVBe9uANwE5kkeZp/UGcHANzDOuA6/Z1bYP5TUEzAfQIDmzCiO9eEJTyt96Qyji2m
 fmo0aQ2AB6LkL3vzKdZOp93rv6WhACsCyJNN1dhdd29U0oZnPoAd4VJ+JYp92QKBBupF
 S8a1bLzZTwNs4aAoK3jBwLTITDX95MqG3mNoWndcD9Iol7EEPY1RzukiLV1XUw4923aS
 aeaur3t1K4usYeCAM6eQQokIDLcOHZBHIpn1a00v3b0SUf79RhDWXd8EhHXxvvoH9su6
 81GBgHxQH3pOOe9gI+Y9TeuNrhcpcoZwmZgB36QOI2re80pW8d1fTYyyBb/aJ3ne3b+r KQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sg6sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G58Mr0185569;
        Thu, 16 Jan 2020 05:11:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1at7q3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G5BLVv000928;
        Thu, 16 Jan 2020 05:11:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:11:20 -0800
Subject: [PATCH 7/7] xfs/020: call _notrun if we can't create a 60t sparse
 image
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:11:19 -0800
Message-ID: <157915147960.2374854.2067220014390694914.stgit@magnolia>
In-Reply-To: <157915143549.2374854.7759901526137960493.stgit@magnolia>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=787
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=847 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we can't create the 60T sparse image for testing repair on a large fs
(such as when running on 32-bit), don't bother running the rest of the
test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/020 |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/020 b/tests/xfs/020
index 61da4101..e39c3482 100755
--- a/tests/xfs/020
+++ b/tests/xfs/020
@@ -42,6 +42,8 @@ echo "Silence is golden"
 
 fsfile=$TEST_DIR/fsfile.$seq
 rm -f $fsfile
+truncate -s 60t $fsfile || _notrun "Cannot create 60T sparse file for test."
+rm -f $fsfile
 
 $MKFS_PROG -t xfs -d size=60t,file,name=$fsfile >/dev/null
 $XFS_REPAIR_PROG -f -o ag_stride=32 -t 1 $fsfile >/dev/null 2>&1

