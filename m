Return-Path: <SRS0=0uIH=W3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32575C3A59B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 00:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED92B2342E
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 00:11:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="in6L9x5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfHaALm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 20:11:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfHaALm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 20:11:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7V0A3bJ165339;
        Sat, 31 Aug 2019 00:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VPYDa3FYJR7RiA5aiOAIUBNrgTkmDcr/qSYy1mbepII=;
 b=in6L9x5bfFco6a4HHukmC9NyUEwvdhLz2VN/zPR28R7MWmIDXYnO32pOV2BKQffobRbv
 JpMuywBKRf4kxxdVe/4sHx56ulh+HVnfcYsPPAzIoPsLTKqLymt5hfvM8zfp1iW5ypk/
 eGXrfr/IRP9gclZaXKqSfdWlA/UAso1HCQbeuRzpIFekZ1rKgt6EL1TV9iv/K9VDK85x
 bb5IILP9OHkVkyDKhoNYgWo8FNWHPp8SxAwN/pj74EBKCmHZr2vgLXsXXtqNEGXGHV9n
 aCysCrTxvjQD2G3DEisSDAq8In2prFad72uEEvhPD3Z6j6fz+sIgDDr1n4kwd/3/slY+ YA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uqe430078-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 00:11:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7V08htE149043;
        Sat, 31 Aug 2019 00:11:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2uqe19r5mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 00:11:39 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7V0BcTZ005992;
        Sat, 31 Aug 2019 00:11:38 GMT
Received: from localhost (/10.159.246.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 17:11:38 -0700
Date:   Fri, 30 Aug 2019 17:11:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] xfs: define a flags field for the AG geometry ioctl
 structure
Message-ID: <20190831001137.GN5354@magnolia>
References: <20190830235139.GM5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830235139.GM5354@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=826
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908310000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=887 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908310000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define a flags field for the AG geometry ioctl structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: define ag_flags as an *in* field
---
 fs/xfs/libxfs/xfs_fs.h |    2 +-
 fs/xfs/xfs_ioctl.c     |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 52d03a3a02a4..de2ead2039c5 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -287,7 +287,7 @@ struct xfs_ag_geometry {
 	uint32_t	ag_ifree;	/* o: inodes free */
 	uint32_t	ag_sick;	/* o: sick things in ag */
 	uint32_t	ag_checked;	/* o: checked metadata in ag */
-	uint32_t	ag_reserved32;	/* o: zero */
+	uint32_t	ag_flags;	/* i: flags for this ag */
 	uint64_t	ag_reserved[12];/* o: zero */
 };
 #define XFS_AG_GEOM_SICK_SB	(1 << 0)  /* superblock */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9a6823e29661..93274c16cec4 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1038,6 +1038,8 @@ xfs_ioc_ag_geometry(
 
 	if (copy_from_user(&ageo, arg, sizeof(ageo)))
 		return -EFAULT;
+	if (ageo.ag_flags)
+		return -EINVAL;
 
 	error = xfs_ag_get_geometry(mp, ageo.ag_number, &ageo);
 	if (error)
