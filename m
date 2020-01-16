Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E6FC3F68F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F38D62077B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:10:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kKgkMTOb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgAPFK6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:10:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47202 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgAPFK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:10:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59Gn2170242;
        Thu, 16 Jan 2020 05:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=L6I0Gt91+jQ90cx0jHdsAQ7QD89K0HvplVXu18i1S4c=;
 b=kKgkMTObHhPfWc/Q4RZlnwXyFHjUFbVmKZk+5WOMLI5hLGni127UioYFi8EO12tbE7MD
 2CtClFf5XjoudNzJ3D4GVeO5/2FpTkKRO1Oq+dgb7KqRc5sE0sK2IGgfPa0WiI7h+yNk
 9kog/ldDzyd1VkvZIQzEZRS7zdKrJ9cs3i+buf6e06tjZCq1ynqPVb72Ev7NfWH5Ice8
 93W2uC61NPOX58FF//Giepgwj8w6zmjQ4ZlhY8cePHhNKG0ikDGEeK1kkfarGnw57t/r
 TVKBxYtHSG25nGgfsHoKOCroIeXvE1vo2NkvdEoODuWTlF9YvBudpES59wKM/XcpkeRm 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xf73yr77n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:10:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59EHn085482;
        Thu, 16 Jan 2020 05:10:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xj1psd0sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:10:56 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G5Atge000620;
        Thu, 16 Jan 2020 05:10:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:10:55 -0800
Subject: [PATCH 3/7] xfs/507: skip if we can't create a large sparse file
 for testing
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:10:54 -0800
Message-ID: <157915145418.2374854.11482414938923072334.stgit@magnolia>
In-Reply-To: <157915143549.2374854.7759901526137960493.stgit@magnolia>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=885
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=945 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Skip this test we can't create the large sparse file needed to test
overflows.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/507 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/507 b/tests/xfs/507
index 0bb697f9..fac5d243 100755
--- a/tests/xfs/507
+++ b/tests/xfs/507
@@ -68,6 +68,7 @@ _require_fs_space $SCRATCH_MNT 1234567
 loop_file=$SCRATCH_MNT/a.img
 loop_mount=$SCRATCH_MNT/a
 $XFS_IO_PROG -f -c "truncate $loop_file_sz" $loop_file
+test -s $loop_file || _notrun "Could not create large sparse file"
 loop_dev=$(_create_loop_device $loop_file)
 
 # Now we have to create the source file.  The goal is to overflow a 32-bit

