Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10944C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5CC4207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PlVqMJMK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgEVC4v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:56:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57592 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgEVC4v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:56:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mfmu095053;
        Fri, 22 May 2020 02:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MTEfy5kAZatnRFxNEwjN7hxSBwyQSwTjblpBde9v3UM=;
 b=PlVqMJMKZKdH6L8bggZaGn3dg9nmGb+YuKueZxYYr71u5VQ1U8pnMr7Dr3jcLXrtCnJF
 x3zjl5h2e/DKsCh8LOojjznuma1oqfdQ+XULMwkH5TMUmW/sIRbrDgx0zqBvfTRhbeT3
 v25BQeQ7KIm6txVtbhaa97/eI8cwLPXJlX5+n/0wPNrS0yWbSNSpgvw5FItyUgXduGgK
 nhbY8EdtDaFwiKPqBXFpflorlqeMLZyYmc7VrydJHI6io6hRJ4HpY57dcFNIpxgx4+9L
 /jTc4Y/BzPPSHnNoU+do7jfa/FBJ8t5LyfXqm8EC0xwL2zHmIDzPLOFW4Qbk4ixJub5X 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284mbj2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:54:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mXeC186004;
        Fri, 22 May 2020 02:54:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 314gmaaxqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:54:47 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2skPW030315;
        Fri, 22 May 2020 02:54:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:54:46 -0700
Subject: [PATCH 12/12] xfs: rearrange xfs_inode_walk_ag parameters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Thu, 21 May 2020 19:54:45 -0700
Message-ID: <159011608512.77079.1442881398167792783.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The perag structure already has a pointer to the xfs_mount, so we don't
need to pass that separately and can drop it.  Having done that, move
iter_flags so that the argument order is the same between xfs_inode_walk
and xfs_inode_walk_ag.  The latter will make things less confusing for a
future patch that enables background scanning work to be done in
parallel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index baf59087caa5..fbd77467bb4d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -797,13 +797,13 @@ xfs_inode_walk_ag_grab(
  */
 STATIC int
 xfs_inode_walk_ag(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
+	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
-	int			tag,
-	int			iter_flags)
+	int			tag)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
 	int			last_error = 0;
 	int			skipped;
@@ -932,8 +932,7 @@ xfs_inode_walk(
 	ag = 0;
 	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(mp, pag, execute, args, tag,
-				iter_flags);
+		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;

