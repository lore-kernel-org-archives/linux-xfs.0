Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A5EC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243205AbiCUFU0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344376AbiCUFUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB8633E3C
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KK9IaW008859;
        Mon, 21 Mar 2022 05:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=OVUBl4DYKVJiDOKdvHTV78q0/fXz8IkkfxdYtdNvcnw=;
 b=iJ5/Kcnv1M7cvQA+/S+Fu+oZEuqXtULkajJy3yf0Buf6Y015SeXJoWNEHducwubRzlKw
 9XgpId8ZrLP1P4AFgjgJBBxpuA2pLUbhd2DNakCyd5RNde8xWLW9wi72bj/NfeEUgeog
 ZnNlhOobpMFe87VWZ9geRe0su09ww+c3hImr8MCRYbJFWKowi9i2BX8IIBAuuftJyqXn
 MSIoGiApx4c2mykAfnSPwG1GX5XjexxMsiMWzgYTxBXa+ujbKJdCPjknECWIpbFK0oSr
 G2s5AXZ57ynR0D1aSVkC4gp9QEzgqIyek65Md12dXE8kd6t/LbsvrSP86vMkRG5K9DPY gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qt22vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5Im57094853;
        Mon, 21 Mar 2022 05:18:48 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by userp3030.oracle.com with ESMTP id 3ew49r2h0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liSXc//PKtj9RD54NUCjsXB2HycFaS0xLxNt0bPTug05vLEBo+oyGhUb2JvJg+qVY+mKoOq0qzrZqorJOcBGMqWD1D3GNoWooh4p3CJ0qS4eRjPcY5+5YOUX95udSu1Vh/UbKv1ZJa3HxInSun4qsNcC+a084U0eTfNwIr/jy/vSpooD8h/DiMB+1ythzNgS3UFuBsbLJUT1eGX1unkNSYGPSFaV12xWGjVA2dN+nhjy9xQ6LJPfhOKrR5QrXIqGmeFgplb95sZ/yH/cQqRp8dFRXL17Mdr7T3eeWnDk+k1wnFV9U8JbsgBH4WozKzvQMPrGu89iem8tDb+5pcFCIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVUBl4DYKVJiDOKdvHTV78q0/fXz8IkkfxdYtdNvcnw=;
 b=Z3FDtlM5JpaY5SJ7oG/qDPm+ThAwkvK9tGRUtXoTbnH7hBpvkzu4h2BdyGn8wCC77q0IYpYtltqDCbqmJGnsIn0mCHsS7wiaXQTxRnPWXOSdR5FnUsDn+ba2v4QcKappbPNmeMPHmz7tbminbE7IRJCsIPlwJvkCWadEctj6xC95ObvLmhMylM8wIyqFcQywRHvNMFfZ0fheDj4EdydaE6CcQwjND4XYNODFYNSysgrg7HD8/saRk/glxZKidvTyxvgMMvDSGHu0c2fzJdqB33urwEYoX1qPfLCBITQcidADLDdAi1undgLSJe6W6XKpU2lkWOZQy/0EW2oHylpofg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVUBl4DYKVJiDOKdvHTV78q0/fXz8IkkfxdYtdNvcnw=;
 b=VINNw81Pjqkfc+ETWs7FeAS++XLcOAOE+TGKxZWOsfWFFT7EoGk6tcCrNVuQmEjx8tK2ewixsEa/Z5WtBY8lrEmpPmMOXSNp5obvfBzcUkPfAkmw/ATiCi5890lFPOO98XxDNPLR6gWCUCWtScogEYhpfxAZi8quwTY+SGdOWLk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:46 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:46 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 16/19] xfs: Conditionally upgrade existing inodes to use large extent counters
Date:   Mon, 21 Mar 2022 10:47:47 +0530
Message-Id: <20220321051750.400056-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a42196b3-b411-4854-bb1a-08da0afa461e
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5537562C54CF3A22AC8B10CFF6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fPnyv7cjzy4/V4rJx2Fy2ZqC6Q/MOGNs+ETIyB45NosiUPGLirY6k+o4HArR5sZjXE0ajAgzFkEqkgB05q2f7jYtdDcDzQjA0dOmeSvEB4KuDue1/qUmUKdep3aAoNcGUuxuBui8/3BKCeSgV9Zs0rA9j9uSjuHccwZRebHd7QpzuoLduUfX2KzSdcDO2ccluGbNyge46pQsl7O3S8AhWZhAp75WD3u8gzycfFNVD5bG1oQWI1aQYdVz+oazONO71VWeluon/ZnMqMpPn+Do8xh5ucJrGJB9oN45eO1csUBO8VmS4eMsCV7tg/pckxlMTjne9HtRplwm41Uk6+OJvolnfCY/FmkFqgeAgp+rCoyyHyVBYnpqxkSaqhxZKlJRODSiW99jTKJIGcl852Ave780LrfPGqKINWvLhIA7IZ31dGA7alpJ5J9NsSG9zLVylydr9xecbed8bOPiTr/OpjaiTPlhqgSlo5hatKwsaEVHfsIhBevryUUCknU9FoBjt/9imUaXMXmM1rIjDZ1kWEJ5RiF23gX7oDBVXsDwE6a+04fdHk4T9QWidW/I+cXr3Y0MwGzxFDXczXs0yRpe44j/7pfISigICvdlzCicJvFO3rftLOG4quDNhgGUYyF6UcadyoUzYlcHH7aypsZk73LB1rUMVG0H6qeVUuN0Hj8o4/UWIg2wbbJs7v4tOnedP1ySgQtmEnBhLKPoOmvKDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6346fV1JAvJsNLAbujPyRX/cR+NT39K34OBT8um2fZJt/kO2fv0GkDpYe7gV?=
 =?us-ascii?Q?+eLVqWLWiaBYPx1O6nNGpkjNx+CdgBPZPO8gIqftMpgC+1AbBvzhj0KwI8we?=
 =?us-ascii?Q?qIcDwv/k2vYIEP7aWxR/tUOJG0+sXGuLQx5znGT8WiXI7b1ufoOyMG8SiGdO?=
 =?us-ascii?Q?cc1RDV8WYzMic3vmzBiwNV7Piz89eJiY9hwxcxzs7RWV1j2LgjsiS3y29UsV?=
 =?us-ascii?Q?6332SkLOrfSEY1AG0LYDNHIriUduE3DzsBJ21onojnp+8jsQcYfAaGxu5Su+?=
 =?us-ascii?Q?ADrP3ACxYQLU/isw3JXke4sFbflYmXj1fCF/yd89i41X+9GY2q4MNSeaEDsX?=
 =?us-ascii?Q?GYI3XU5jNMBsQGQHJ4o6QpNIPs8RoEAvE8qJqcCFoOXp3vFuirC/N/252jKl?=
 =?us-ascii?Q?cs2At+iiKlKhXIkK7jFdukvCdJIlzrWzsw0T3OmVEXnB5Ls2SF7eq751TnI/?=
 =?us-ascii?Q?lCwOsD+ccpGM46837al7Iqm4jmBkI3v/aBV/ZBXsECDO1X7zdXfK4qWIUh1k?=
 =?us-ascii?Q?oFxKl7TVkIXXbYBRi4EVjlEgKsalK2AUdqaJXKS6x4ITfUh/OC6O+iQNpjcg?=
 =?us-ascii?Q?6Wh8LSDdvh2kvLSB5ncQsTQ/fL+eesd2TPFyyZ2Xbys2VjUNSG+lGlFuYSmC?=
 =?us-ascii?Q?oPVGWYWKBH/og3fa5S3UoHNGrmRsdvNGuntTKcGXvgShZfhg95K9CW5FR4Ep?=
 =?us-ascii?Q?rj1jmd9YjmxIja165m87rscafI0j7vBX02/dtYXf893yovArKz3s3ssQAoul?=
 =?us-ascii?Q?rNTBMySG1D9mDKdR+6KW6YIxfb8LNrLsABhcgZU20Js1ynqrfcfo2DsY5JFE?=
 =?us-ascii?Q?5eyPz3QH9e9u5omCkO7P09VnTLQX0YrH/DJeCzD8zNy1eyTbhuMRZEGZbJki?=
 =?us-ascii?Q?lQFgt6RsG5zvOjjxK1qC1Z4S7bxALvz1H0s4zOCzVB7A/NR2E6wANTMBT6KG?=
 =?us-ascii?Q?4O6kKWDuj4+9feu5GCrvm7ydXs4xK0/LNxaT0OOyz3cl3bbzWWHdY9je06j8?=
 =?us-ascii?Q?ECJQncgkxfNfna11m2wXKy8KQFy8qNEFcwtdbk9/iYv0Ev3TKX9eLIJ3GZ3/?=
 =?us-ascii?Q?Td3I8Tqr9fl4aJ/5xyz6qkoEQLxVDW0FRJd+tt+OzIat99YZaNDcw2X9gTSv?=
 =?us-ascii?Q?QrUtIxrZqYvds07LkGoQO2y2oX8Br6gR2qPCJ6lbyLIA1JV+u7Ko6AbH/dHK?=
 =?us-ascii?Q?H+6YUhnEEdhS6yxIUEYVrPUxYNmnwETqhVtWKcyGl8vyQw6dw3YNqctVzlAW?=
 =?us-ascii?Q?oHjOEPGt/ungwjN4/4KKuQ3wFPuN5oebxnIjV00E0SjcRUvt4scWuJFosQiw?=
 =?us-ascii?Q?fy/Gn+9TzAafPdwOLhv3YfWkRfeZAqF2AqnnaOKqIBpSGOCAHHXflVb7Xh97?=
 =?us-ascii?Q?dZe1Lm/Qpm3kSDlwJB/SkUpjyfDGHFXL6e7owIDC81yP8+0CyGq1II+m/7M0?=
 =?us-ascii?Q?9S4GiSZrBAwAvk8ltxk4wU+3yJQQFM/WFU8JsYwzl/hDq2K+oAM2Rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a42196b3-b411-4854-bb1a-08da0afa461e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:46.2585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /meBWVdDAhCmow21iixRv4GqZpZzPrjr8y6VK1pNgVUolyOsnLhZisYWREOguj1UTmhJMjKKn+7V20uPrCMk2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: vTDnw36dV7llH39VQfW628ljFgy8OLa8
X-Proofpoint-ORIG-GUID: vTDnw36dV7llH39VQfW628ljFgy8OLa8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables upgrading existing inodes to use large extent counters
provided that underlying filesystem's superblock has large extent counter
feature enabled.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  9 ++++++-
 fs/xfs/libxfs/xfs_bmap.c       | 10 ++++++--
 fs/xfs/libxfs/xfs_inode_fork.c | 27 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
 fs/xfs/xfs_bmap_item.c         |  8 ++++++-
 fs/xfs/xfs_bmap_util.c         | 43 ++++++++++++++++++++++++++++++----
 fs/xfs/xfs_dquot.c             |  9 ++++++-
 fs/xfs/xfs_iomap.c             | 17 ++++++++++++--
 fs/xfs/xfs_reflink.c           | 17 ++++++++++++--
 fs/xfs/xfs_rtalloc.c           |  9 ++++++-
 10 files changed, 136 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23523b802539..6e56aa17fd82 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -776,8 +776,15 @@ xfs_attr_set(
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
-		if (error)
+		if (error && error != -EFBIG)
 			goto out_trans_cancel;
+
+		if (error == -EFBIG) {
+			error = xfs_iext_count_upgrade(args->trans, dp,
+					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
+			if (error)
+				goto out_trans_cancel;
+		}
 	}
 
 	error = xfs_attr_lookup(args);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5a089674c666..0cb915bf8285 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4524,13 +4524,19 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_iext_count_may_overflow(ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error)
+	if (error && error != -EFBIG)
 		goto out_trans_cancel;
 
-	xfs_trans_ijoin(tp, ip, 0);
+	if (error == -EFBIG) {
+		error = xfs_iext_count_upgrade(tp, ip,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error)
+			goto out_trans_cancel;
+	}
 
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
 	    bma.got.br_startoff > offset_fsb) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index bb5d841aac58..aff9242db829 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -756,3 +756,30 @@ xfs_iext_count_may_overflow(
 
 	return 0;
 }
+
+int
+xfs_iext_count_upgrade(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			nr_to_add)
+{
+	if (!xfs_has_large_extent_counts(ip->i_mount) ||
+	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64) ||
+	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+		return -EFBIG;
+
+	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	/*
+	 * The value of nr_to_add cannot be larger than 2^17
+	 *
+	 * - XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL
+	 *   i.e. 2^32 - 2^15
+	 * - XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL
+	 *   i.e. 2^48 - 2^31
+	 */
+	ASSERT(nr_to_add <= (1 << 17));
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index fd5c3c2d77e0..f2fe513e7252 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -288,6 +288,8 @@ int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
 int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
+int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
+		int nr_to_add);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e1f4d7d5a011..e8729abc15ab 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -506,9 +506,15 @@ xfs_bui_item_recover(
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
 	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
-	if (error)
+	if (error && error != -EFBIG)
 		goto err_cancel;
 
+	if (error == -EFBIG) {
+		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+		if (error)
+			goto err_cancel;
+	}
+
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
 			whichfork, bmap->me_startoff, bmap->me_startblock,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 18c1b99311a8..9f7112625934 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -859,9 +859,16 @@ xfs_alloc_file_space(
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error)
+		if (error && error != -EFBIG)
 			goto error;
 
+		if (error == -EFBIG) {
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_ADD_NOSPLIT_CNT);
+			if (error)
+				goto error;
+		}
+
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
 				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
 				&nimaps);
@@ -914,9 +921,15 @@ xfs_unmap_extent(
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
-	if (error)
+	if (error && error != -EFBIG)
 		goto out_trans_cancel;
 
+	if (error == -EFBIG) {
+		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
@@ -1195,9 +1208,15 @@ xfs_insert_file_space(
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
-	if (error)
+	if (error && error != -EFBIG)
 		goto out_trans_cancel;
 
+	if (error == -EFBIG) {
+		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * The extent shifting code works on extent granularity. So, if stop_fsb
 	 * is not the starting block of extent, we need to split the extent at
@@ -1423,16 +1442,30 @@ xfs_swap_extent_rmap(
 				error = xfs_iext_count_may_overflow(ip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error)
+				if (error && error != -EFBIG)
 					goto out;
+
+				if (error == -EFBIG) {
+					error = xfs_iext_count_upgrade(tp, ip,
+							XFS_IEXT_SWAP_RMAP_CNT);
+					if (error)
+						goto out;
+				}
 			}
 
 			if (xfs_bmap_is_real_extent(&irec)) {
 				error = xfs_iext_count_may_overflow(tip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error)
+				if (error && error != -EFBIG)
 					goto out;
+
+				if (error == -EFBIG) {
+					error = xfs_iext_count_upgrade(tp, ip,
+							XFS_IEXT_SWAP_RMAP_CNT);
+					if (error)
+						goto out;
+				}
 			}
 
 			/* Remove the mapping from the donor file. */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5afedcbc78c7..8b8fc98a01eb 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -322,9 +322,16 @@ xfs_dquot_disk_alloc(
 
 	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error)
+	if (error && error != -EFBIG)
 		goto err_cancel;
 
+	if (error == -EFBIG) {
+		error = xfs_iext_count_upgrade(tp, quotip,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error)
+			goto err_cancel;
+	}
+
 	/* Create the block mapping. */
 	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
 			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 87e1cf5060bd..57c3c2ccb07b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -251,9 +251,15 @@ xfs_iomap_write_direct(
 		return error;
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
-	if (error)
+	if (error && error != -EFBIG)
 		goto out_trans_cancel;
 
+	if (error == -EFBIG) {
+		error = xfs_iext_count_upgrade(tp, ip, nr_exts);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * From this point onwards we overwrite the imap pointer that the
 	 * caller gave to us.
@@ -555,9 +561,16 @@ xfs_iomap_write_unwritten(
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
-		if (error)
+		if (error && error != -EFBIG)
 			goto error_on_bmapi_transaction;
 
+		if (error == -EFBIG) {
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_WRITE_UNWRITTEN_CNT);
+			if (error)
+				goto error_on_bmapi_transaction;
+		}
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index db70060e7bf6..04717be330d7 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -617,9 +617,16 @@ xfs_reflink_end_cow_extent(
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
-	if (error)
+	if (error && error != -EFBIG)
 		goto out_cancel;
 
+	if (error == -EFBIG) {
+		error = xfs_iext_count_upgrade(tp, ip,
+				XFS_IEXT_REFLINK_END_COW_CNT);
+		if (error)
+			goto out_cancel;
+	}
+
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
@@ -1118,9 +1125,15 @@ xfs_reflink_remap_extent(
 		++iext_delta;
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
-	if (error)
+	if (error && error != -EFBIG)
 		goto out_cancel;
 
+	if (error == -EFBIG) {
+		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+		if (error)
+			goto out_cancel;
+	}
+
 	if (smap_real) {
 		/*
 		 * If the extent we're unmapping is backed by storage (written
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b8c79ee791af..8cab153201d0 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -806,9 +806,16 @@ xfs_growfs_rt_alloc(
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error)
+		if (error && error != -EFBIG)
 			goto out_trans_cancel;
 
+		if (error == -EFBIG) {
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_ADD_NOSPLIT_CNT);
+			if (error)
+				goto out_trans_cancel;
+		}
+
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
-- 
2.30.2

