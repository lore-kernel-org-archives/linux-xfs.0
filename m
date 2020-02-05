Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A40C3524D
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08427214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M21JkgmE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgBEACA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:02:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41746 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgBEACA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:02:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014Nx4Lm096861;
        Wed, 5 Feb 2020 00:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pbbDtoYXRJuh38ts3Orjrn9Kiqx/Skv8mtJchaS0ThE=;
 b=M21JkgmEycNlhHahna6WsCWEk1wRyyp+DysyUiSEBFzlxiqxStu4IsY9uH1JpcWT63h6
 G2zAAHsXPX6Wo3wLF+3mVfWC0zE1sSwOzeSJWUfgPFFo9GaeZQavtxKuzvuNe+nXeJHi
 YzCge0BCOQvbW6v9ISwRHZfbEhWGy4ESjLYEPbPtXB0VkL4fZD1KGdhvjrJPY7xrDv1g
 4nZY8CohlxpdjTPWnyoIusRQOfNyT5J6iDSErWdXf3HoYuS7oAH/lpf+5CBzLp3/IJJI
 YYFk5fn6+88C5Uje69O3obxgkZUHy/VWomjOqrgAxyZdbLQJaNhjuSw/hHxKkaq4gHWO SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xyhkfg87q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:01:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NwNHj016139;
        Wed, 5 Feb 2020 00:01:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xyhmvhwqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:01:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01501trW021792;
        Wed, 5 Feb 2020 00:01:56 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:01:55 -0800
Subject: [PATCH 2/5] xfs/020: fix truncation test
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:01:54 -0800
Message-ID: <158086091464.1989378.4282506455041445127.stgit@magnolia>
In-Reply-To: <158086090225.1989378.6869317139530865842.stgit@magnolia>
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=910
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=960 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we can't create the 60T sparse image for testing repair on a large fs
(such as when running on 32-bit), don't bother running the rest of the
test.  This requires the actual truncate(1) command, because it returns
nonzero if the system call fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/020 |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/020 b/tests/xfs/020
index 66433b0a..4f617379 100755
--- a/tests/xfs/020
+++ b/tests/xfs/020
@@ -42,7 +42,9 @@ echo "Silence is golden"
 
 fsfile=$TEST_DIR/fsfile.$seq
 rm -f $fsfile
-$XFS_IO_PROG -f -c "truncate 60t" $fsfile || _notrun "Cannot create 60T sparse file for test."
+# The actual truncate command is required here (and not xfs_io) because it
+# returns nonzero if the operation fails.
+truncate -s 60t $fsfile || _notrun "Cannot create 60T sparse file for test."
 rm -f $fsfile
 
 $MKFS_PROG -t xfs -d size=60t,file,name=$fsfile >/dev/null

