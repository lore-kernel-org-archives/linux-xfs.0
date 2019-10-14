Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39CCC4CECE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BC95206A3
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iWi6fkZ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388356AbfJNRMb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 13:12:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39386 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbfJNRMa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 13:12:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EH9TkP038907;
        Mon, 14 Oct 2019 17:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=8TMgfkcICjuiRPLhcjRMCr/jlUIWDDJGApIKSpIeFlY=;
 b=iWi6fkZ3ymjDJmRX9U0+BJoY5imttPemsylqhNP8HfQuX2EhJyhzH7kAYBWI3U8HFp1q
 SPN/t0VaSR0zf/mRALKrJiopXjm49xYccz4SKIl1RBMdP/xo4k5e1Q6pRf84hOg7KGHd
 JxVFgg8c0PUP3prZkbQdPhUJ7pDB9KEEuRwurXjgv9xnvBncpt0eJaZ9WubY+9l7isUA
 oR7YuBIgEd7WBXs/rZh2CyAEjlGypkOHLIwN25LQW8T/1GDzNeIduvkzyeO1XdTt/VlL
 ognCLaK/Sw2tLnJOSdjEecB6EPFvU0OCkSX5gqQDept3yW5ykrWwfhe8e8cR8nPVThc3 MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vk7fr278g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:12:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EH7w4Q149582;
        Mon, 14 Oct 2019 17:12:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vkry6r3ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:12:13 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9EHCCbX012319;
        Mon, 14 Oct 2019 17:12:12 GMT
Received: from localhost (/10.159.144.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 17:12:12 +0000
Date:   Mon, 14 Oct 2019 10:12:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: change the seconds fields in xfs_bulkstat to signed
Message-ID: <20191014171211.GG26541@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

64-bit time is a signed quantity in the kernel, so the bulkstat
structure should reflect that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b0c884e80915..8b77eace70f1 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -368,11 +368,11 @@ struct xfs_bulkstat {
 	uint64_t	bs_blocks;	/* number of blocks		*/
 	uint64_t	bs_xflags;	/* extended flags		*/
 
-	uint64_t	bs_atime;	/* access time, seconds		*/
-	uint64_t	bs_mtime;	/* modify time, seconds		*/
+	int64_t		bs_atime;	/* access time, seconds		*/
+	int64_t		bs_mtime;	/* modify time, seconds		*/
 
-	uint64_t	bs_ctime;	/* inode change time, seconds	*/
-	uint64_t	bs_btime;	/* creation time, seconds	*/
+	int64_t		bs_ctime;	/* inode change time, seconds	*/
+	int64_t		bs_btime;	/* creation time, seconds	*/
 
 	uint32_t	bs_gen;		/* generation count		*/
 	uint32_t	bs_uid;		/* user id			*/
