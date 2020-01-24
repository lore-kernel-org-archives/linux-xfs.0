Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F97C2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F91520718
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:22:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RaGzQs1t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgAXFWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 00:22:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58928 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729545AbgAXFWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 00:22:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5ICFF059298;
        Fri, 24 Jan 2020 05:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=RV8jKa85XBog2tjf2sIrBRzUiu5+dJRAUyiwO1R32Ig=;
 b=RaGzQs1t2Z3zM3FYhtv1vIJLF6IamTOpycBvfpzGmuDHazJ+1aQG93KryN+WMYFChuGb
 YZ6K8+eKxk5wE3/lJXYHU2yYOSAweBn6cUtBKTpik8siX6gqdzJlteIUDR1oChsI2+Hd
 kpUvTmtmeiJAy2T2JLEZPPOXwsLizzeAX2dlHYLNHBpWfGKcAgDnliZ8UM0MDcxkZJ5+
 1YT3GsrSJOvnpwxY7KSkM6L52oDTstijoYMXCZ8JRx7VZUWrpq8Ass4EaTWZoXs9lHNA
 B2YH65SxojfF5ricZWU6ap7tPHyF6P0ZlKa8+dpGm5hc9Yg81oX4HeBrZk5+/2LZlu1Z Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xkseuy303-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:22:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IJPJ156108;
        Fri, 24 Jan 2020 05:22:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xqmuy3hf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:22:13 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O5MBwi028810;
        Fri, 24 Jan 2020 05:22:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 21:22:11 -0800
Date:   Thu, 23 Jan 2020 21:22:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] xfs: remove unnecessary variable
Message-ID: <20200124052210.GV8257@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Stephen Rothwell reported an unused variable.  Remove it.

Fixes: 4bbb04abb4ee ("xfs: truncate should remove all blocks, not just to the end of the page cache")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1309f25c0d2b..1979a0055763 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1520,7 +1520,6 @@ xfs_itruncate_extents_flags(
 	xfs_fileoff_t		first_unmap_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
-	int			done = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
