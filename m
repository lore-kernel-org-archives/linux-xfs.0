Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29305C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjDKDfu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDKDft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:35:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834DA1726
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:35:47 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJ8vGr027510;
        Tue, 11 Apr 2023 03:35:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=9OIDBskNQPK7JbYUJYPNeFMumfUiclUA1Ef1Vsa+8lE=;
 b=jOCNGN1bWzJMha/EKyMlFnJhM/bLeoC/CupgnEjRNyLa59HCsapx7gQzcNC2GIbw4mMf
 YkXbM/lSkFlIq4yFDY0CRJoPM+d+1rHFCHymQ4Yd9RTnWmRXTPDgp/ThXitYyhLJReeV
 1BO17csT0MWyxjbWK4tg9iSTnP6J1G5I8np6U0fBLmt+/0mfAvsfXkmMLyESXwMCEaR4
 JnTZsU6SWBkMjyGjgi99Ptit8GTlJR5ajZ/boMEyoY2ZT8al02fYD8cJnpRBOm7y2Ppf
 d0QWMpFljDWl1TGoUtmIWkVuBgE34/hrvoVrZKXhYgAcyXa87xIx6gam/+eFNGNJZGnd 4w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7c8ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B2vr8E034156;
        Tue, 11 Apr 2023 03:35:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc39dsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lenGXxa6j/3kyUnnLuUTNxMEWsDKpnmsn/6aI3vUBZ7XXRmV93b19vWy4dHxzLUcX3mzzqFojtKhgE9RNS5am/a8ScJxbieAQ3ectTTK0S9iEHtc1T4xrTGN4BRZbYCM5DU86FdGujjONMVJ9LMazFjU72x981e0H9rmPyyfuAg5oe9T1D+KydTbE08PSy132aCeJl4YZAlFp6Cjq9vdBojptJrOMQzjvtluBuZVrwVtQxUpdGVb6qfZ0IwWooqZc6YvKb1GM7Iw9qmWr9r0cXnjI5eU/aV2jxTfmkyFNWXTB36KcB4VDOZmnEb4QbVuH3EfouHYD93CUNuGwTOTmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OIDBskNQPK7JbYUJYPNeFMumfUiclUA1Ef1Vsa+8lE=;
 b=JPwi4K0GKMR3aNJPRBShvotmzlRH/fev98tgtFNV7FymoVk+JoV8EBadphiGmftSUGFpbi9R9fYJZv2JwNVT2Hj51myIeZ/0jR+Px/jjpMk7teTdKzX5zYu/UV377Zk/qFnRfZ3xe7GilPWDwLZ1zaitl7c2zaarN8envZiR1tUCEMK1PypEthY7m22304h8rCDBl+aC4iOZMm1LZjjsrngbQORnyYg1z3MSf5zK0CKkQTmbyPZBG0eMVXzWjOLHXnygiOYZEDwJRTqZKRVTV0E4hN8sx370C62k9A2UkBA5+d39edlQ+Zh6VJ3qLYXGjLIjkXIk9b5AXbARl3++3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OIDBskNQPK7JbYUJYPNeFMumfUiclUA1Ef1Vsa+8lE=;
 b=mgudH96BcKXI61lwNOpOxamZ0Dro74Lq2wf+jrfskJiC6xJ24pQBy/Zxaaz4GqnvfdsUWOC56YKGRg7x4SvxA0U9aHeiXMJkSbNfkZy7NWds1ygGVxKN2bX1s4sinvArjwaghCr7dkMXUnxB7lcSWkPnmprrpbxFYR2V7ZWdkgE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 03:35:39 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:35:39 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 02/17] xfs: merge the projid fields in struct xfs_icdinode
Date:   Tue, 11 Apr 2023 09:04:59 +0530
Message-Id: <20230411033514.58024-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0104.apcprd03.prod.outlook.com
 (2603:1096:4:7c::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: e574b64a-c102-4980-139b-08db3a3dd1ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ec9MfaIGG1+D75MyfoMOcaQr8CFmEvJnXPA0c6VwyzUxkI37AtouuitbmfvuA+hr0PPCzyVquln6AlKUTQ9Cstwfal+0TvUo8VYfAuLrCQ90+afULdDWDa6Sdu+cHIOx82kMnkkjhceBddIqJ348HSSn5Kk15p3vQ2pFToejDLEUDW4oi4EdgmDtMZXXvAsF0bH4nYRGrqEhC6rhtw4kV8bwlyL+3kUPhIIAder2cVLSbWfH1/ioVVTbTfT2ci25kdpxH95im+RHoP2+YYiuJgzcj/a83SOX3nweW1rTmow7BO/IhF/0aN3ux69H4t+YTT7XkGIN3eeGTVkAt9OGm3fanFSxuKyMvykIVE94d6w+Zo/Q8C+Mknk1W+HBrchMLXiSmDaZ4x58Gu4pvkLfR6GJ4LZU8fFNACaXIU0ly4QTCqCU/RR9F+w9lee6rTQOpiZ+0oAbl35uAlV/HC16LEnE8bfrSVXoolUgvuUALL7KNPa+uyhJgpowBKjiHSTqpLPABox1BMpDGrLe+TMybzji8VwfdMvUgy3Grv9sHKhH9D4jWr36irOASN3CBMKq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199021)(6486002)(4326008)(66556008)(66476007)(478600001)(66946007)(8676002)(6916009)(41300700001)(83380400001)(316002)(36756003)(86362001)(2616005)(6506007)(1076003)(26005)(6512007)(6666004)(8936002)(2906002)(5660300002)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F+TLJWaRD4WtiMPiEo6OWjbU/kyEiTzc0OZCG63IUSUWaZG6kHS2xv7SrNAv?=
 =?us-ascii?Q?tf6j5xQgwM2Q0AY2nEH/9dSOqWdPbanflgWxAGOvXUBvRcQsSlh5MNkKA9Yl?=
 =?us-ascii?Q?V5AaSKTiNCil8uC44HGWIDSe1yFrvrtKMlPqJFxaw/bmTaFN7i8IB4QPABq2?=
 =?us-ascii?Q?fqufIlZDw3S66GILo5y1fFs0Kl9vkN5dB/yOkL8nax8S8YdnzU8gMiKsa0Db?=
 =?us-ascii?Q?GMl76lHUhnMlPe7IVkQWWHODnn3sBgr2T4ylHhObVUr5khbsDrMrOywh4vac?=
 =?us-ascii?Q?DxsJM66+MsKYn3ipzb1JOmXqWh3xS63Es47m3iUYh/RbMeEgKLPsGVh8t6L/?=
 =?us-ascii?Q?1RXowxOPmu0mA3ahjUXokc6eGzpx/fVu6cDOOQQwJfs9cGfr297OdwylAHQe?=
 =?us-ascii?Q?hFbXciZsrpTUM3hSYmvu3LbOqmKCv+KvRzFfoirTxoWIRoHMKdVWbiYPt/jp?=
 =?us-ascii?Q?DVYTtgYIH1e7hW7ZcCsgqFxn/BOoPuZy/uLPfoYnNYXmongWQhV0exvEoqcp?=
 =?us-ascii?Q?rl8dDZf9a3UUoED2EzUimrBltwqU6DD13t7j15wc3YKwjyxaxhpUpzWQvedo?=
 =?us-ascii?Q?GSziKTlXDaTF+PsNgO2IZoOLJph3vBpe/6kG+37kY2r+YUQt/DOtla1IJxX7?=
 =?us-ascii?Q?QAftOjpO0+1IVOxCRUl0hkxaNqSlHZVKsn5THwcKglkHDv6s2cUSNlCuOIP3?=
 =?us-ascii?Q?15ESw8JlYUKl7aI9tzZHnkDzapC9ljUF49FDGEAPaciN9JXbVSXXkHz4TsbX?=
 =?us-ascii?Q?3dS15gFU5OVc0WSVylo0awUVt0upq8jmq2dcGLb5UZOv198XSOKW+2DUTg/l?=
 =?us-ascii?Q?bXNBnioV8AUgDIA8T+A0LXBOKMXSrfKexXQVlxKap6vo99uFdYJCSswv5dBE?=
 =?us-ascii?Q?xb9vfEDeigD2eH4r44Pnb7SkXud7tAlEIkPlGEh1E3IuJMoSwz4Z1tE+TQsi?=
 =?us-ascii?Q?e09JaqaHMF1rYu8Ce3NZFneKddE35rYvID8fA6qL6zTpvegwrP+2K2JIhj4n?=
 =?us-ascii?Q?TFSoGm2bvR/7vch0HLBR8dd5N8dvxAxcXhhnjvydZIA1y3OprLVXkbcUD8MK?=
 =?us-ascii?Q?x2vn4phvO7skcavKyhZFPbl/92StW8BumLh67JgAwev+qeOCAhtg8HM4sTol?=
 =?us-ascii?Q?0I1aqNGbQ9zYy5sm1CysZqPStwySvJJlPGo2nvs9O0bnNHpdaFDrBph53L1R?=
 =?us-ascii?Q?HpA87s41uOyZNmBYAU2lt964mS8eBROwmi6yDgxvYDcL1uuK+JRJfgM86Hov?=
 =?us-ascii?Q?uI/oA0XE+tzi5BAFnN4gri6K3Zm8ExWVvx9Ln5eU4ruy1wmFvxhP4kj9LvDC?=
 =?us-ascii?Q?FCehg/ZEPTCg289NaAWwv5he94rq6fV/LcZmmtnUs4ge6BdxrsWFOkjGy7TW?=
 =?us-ascii?Q?gZCi4bi7BcaDzTlZAQonV1qf4JhT3W8HJcyHLAAkO9PZmtUMtqjZSF6YPFqd?=
 =?us-ascii?Q?ZOM5qaZpmbvHJ3yQqf70iZb1St3FASmrd7SGTNDyL/sjz0PBBDF16zOu1uOq?=
 =?us-ascii?Q?AWkBuLstWWyCd7wdsqm/ZwxfFm5d8c4cC8fICYIAs4l9MZNzFhet7qV8gXAO?=
 =?us-ascii?Q?F/3cd/plVNjnbTPhScKfJpA52Vog7ycMHwiV5wWZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mm6lvE2Z8zUYFtyK46L3M75CjfqyZMmiYbl2/3Id/vxQsAOaFkmSpZPmo6+3Yj7k1z5yJyix4d7/XOaTNPB353flQ7fSBMYu9vG6mFONzn2PtYO1Ge7QZAbC5/sbh+i5P2juiqbCNfH9sJAbn0OGaT4G3XBp0mRFTeQKHe8TiL+qtDt78GpjdPa1SLsn3bmlPyy2B6URMz/d3ShTxr9RO1jqArx8DuA7WYHrQbN9+nUY94aG0j73/R6E620vCKJ/zcaGNC9sZ0aic8drPq0HTiHJ0w+qWGXbAJGDFLYcgMIaisN4M3iKvB0lBcu4B0f07Q/B5an3ogPfDTVPl2+dioz/HNWjATZHFfhlp8Za27SDkj490hUmcPckGTplSbdo91jwUT4l+VEveu7KIArNWAXE66DfjyZ76ibmkK6y6zb7jFb72WZ1bM5nmSnLoym7xvDT8YX7YqWwis6FlXrhhlJPYwqOozaPqo7l171zzlZBBIRHBB85GNJ6FIu+i6YNphx79pFBsgndRpbwmDgIH+ruvIeEhYI4yDu18hj58EIQq5wTaY+pqZKgt4Y2F6sn9wfHeLFw+UMDL1ac1dBpfZwi2ctPZ7DO97oVZZj4ee0QUtRqlnnrv5YbM8lXhMkT/ZEM1OZRDtenHcuaaZpl3vMq0sEok3/t2oVp/5Pk7tPQNKV2At1LDb5dGMbtehLbySxc1OiulL7eTjBOLPmroZg6n74x3Eo+PTKhXBaO+8jiiL2WG4JVDZC+bJv8pIMOV/4XXhqTSO2q9G7c7rFjgXfRsjVmvPKuYqjoGwVUtwEOBjHQcJ/b9IiNOj3gcnea
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e574b64a-c102-4980-139b-08db3a3dd1ef
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:35:39.5297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VbXmsa+6VAGsiaPeMf/5hWiyQ4jxU60HaN5593IhGWrv9cnrSHu3MMWXQPHtrTzGgpqxw+nS3c9TjBsn2TqTnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304110032
X-Proofpoint-ORIG-GUID: kqDEyJd1eHFZtOjeMZbqVltPuIX53LMs
X-Proofpoint-GUID: kqDEyJd1eHFZtOjeMZbqVltPuIX53LMs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit de7a866fd41b227b0aa6e9cbeb0dae221c12f542 upstream.

There is no point in splitting the fields like this in an purely
in-memory structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 11 +++++------
 fs/xfs/libxfs/xfs_inode_buf.h |  3 +--
 fs/xfs/xfs_dquot.c            |  2 +-
 fs/xfs/xfs_icache.c           |  4 ++--
 fs/xfs/xfs_inode.c            |  6 +++---
 fs/xfs/xfs_inode.h            | 21 +--------------------
 fs/xfs/xfs_inode_item.c       |  4 ++--
 fs/xfs/xfs_ioctl.c            |  8 ++++----
 fs/xfs/xfs_iops.c             |  2 +-
 fs/xfs/xfs_itable.c           |  2 +-
 fs/xfs/xfs_qm.c               |  8 ++++----
 fs/xfs/xfs_qm_bhv.c           |  2 +-
 12 files changed, 26 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 28ab3c5255e1..e1faf48eb002 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -213,13 +213,12 @@ xfs_inode_from_disk(
 	to->di_version = from->di_version;
 	if (to->di_version == 1) {
 		set_nlink(inode, be16_to_cpu(from->di_onlink));
-		to->di_projid_lo = 0;
-		to->di_projid_hi = 0;
+		to->di_projid = 0;
 		to->di_version = 2;
 	} else {
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
-		to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
-		to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
+		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
+					be16_to_cpu(from->di_projid_lo);
 	}
 
 	to->di_format = from->di_format;
@@ -279,8 +278,8 @@ xfs_inode_to_disk(
 	to->di_format = from->di_format;
 	to->di_uid = cpu_to_be32(from->di_uid);
 	to->di_gid = cpu_to_be32(from->di_gid);
-	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
-	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
+	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
+	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index ab0f84165317..af3ff02b4a8d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -21,8 +21,7 @@ struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
 	uint32_t	di_uid;		/* owner's user id */
 	uint32_t	di_gid;		/* owner's group id */
-	uint16_t	di_projid_lo;	/* lower part of owner's project id */
-	uint16_t	di_projid_hi;	/* higher part of owner's project id */
+	uint32_t	di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6231b155e7f3..f59c3265dae7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -863,7 +863,7 @@ xfs_qm_id_for_quotatype(
 	case XFS_DQ_GROUP:
 		return ip->i_d.di_gid;
 	case XFS_DQ_PROJ:
-		return xfs_get_projid(ip);
+		return ip->i_d.di_projid;
 	}
 	ASSERT(0);
 	return 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a1135b86e79f..8e6dc04c14d4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1430,7 +1430,7 @@ xfs_inode_match_id(
 		return 0;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    xfs_get_projid(ip) != eofb->eof_prid)
+	    ip->i_d.di_projid != eofb->eof_prid)
 		return 0;
 
 	return 1;
@@ -1454,7 +1454,7 @@ xfs_inode_match_id_union(
 		return 1;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    xfs_get_projid(ip) == eofb->eof_prid)
+	    ip->i_d.di_projid == eofb->eof_prid)
 		return 1;
 
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 02f77a359972..891f03a3fd91 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -809,7 +809,7 @@ xfs_ialloc(
 	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
 	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
 	inode->i_rdev = rdev;
-	xfs_set_projid(ip, prid);
+	ip->i_d.di_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
@@ -1418,7 +1418,7 @@ xfs_link(
 	 * the tree quota mechanism could be circumvented.
 	 */
 	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (xfs_get_projid(tdp) != xfs_get_projid(sip)))) {
+		     tdp->i_d.di_projid != sip->i_d.di_projid)) {
 		error = -EXDEV;
 		goto error_return;
 	}
@@ -3299,7 +3299,7 @@ xfs_rename(
 	 * tree quota mechanism would be circumvented.
 	 */
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
+		     target_dp->i_d.di_projid != src_ip->i_d.di_projid)) {
 		error = -EXDEV;
 		goto out_trans_cancel;
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e493d491b7cc..62b963d3b23d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -177,30 +177,11 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 	return ret;
 }
 
-/*
- * Project quota id helpers (previously projid was 16bit only
- * and using two 16bit values to hold new 32bit projid was chosen
- * to retain compatibility with "old" filesystems).
- */
-static inline prid_t
-xfs_get_projid(struct xfs_inode *ip)
-{
-	return (prid_t)ip->i_d.di_projid_hi << 16 | ip->i_d.di_projid_lo;
-}
-
-static inline void
-xfs_set_projid(struct xfs_inode *ip,
-		prid_t projid)
-{
-	ip->i_d.di_projid_hi = (uint16_t) (projid >> 16);
-	ip->i_d.di_projid_lo = (uint16_t) (projid & 0xffff);
-}
-
 static inline prid_t
 xfs_get_initial_prid(struct xfs_inode *dp)
 {
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		return xfs_get_projid(dp);
+		return dp->i_d.di_projid;
 
 	return XFS_PROJID_DEFAULT;
 }
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 83b8f5655636..a3df39033c00 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -310,8 +310,8 @@ xfs_inode_to_log_dinode(
 	to->di_format = from->di_format;
 	to->di_uid = from->di_uid;
 	to->di_gid = from->di_gid;
-	to->di_projid_lo = from->di_projid_lo;
-	to->di_projid_hi = from->di_projid_hi;
+	to->di_projid_lo = from->di_projid & 0xffff;
+	to->di_projid_hi = from->di_projid >> 16;
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7b7a009425e2..fd40a0644b75 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1144,7 +1144,7 @@ xfs_fill_fsxattr(
 	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
 			ip->i_mount->m_sb.sb_blocklog;
-	fa->fsx_projid = xfs_get_projid(ip);
+	fa->fsx_projid = ip->i_d.di_projid;
 
 	if (attr) {
 		if (ip->i_afp) {
@@ -1597,7 +1597,7 @@ xfs_ioctl_setattr(
 	}
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
-	    xfs_get_projid(ip) != fa->fsx_projid) {
+	    ip->i_d.di_projid != fa->fsx_projid) {
 		code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL, pdqp,
 				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
 		if (code)	/* out of quota */
@@ -1634,13 +1634,13 @@ xfs_ioctl_setattr(
 		VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);
 
 	/* Change the ownerships and register project quota modifications */
-	if (xfs_get_projid(ip) != fa->fsx_projid) {
+	if (ip->i_d.di_projid != fa->fsx_projid) {
 		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 			olddquot = xfs_qm_vop_chown(tp, ip,
 						&ip->i_pdquot, pdqp);
 		}
 		ASSERT(ip->i_d.di_version > 1);
-		xfs_set_projid(ip, fa->fsx_projid);
+		ip->i_d.di_projid = fa->fsx_projid;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 80dd05f8f1af..05adfea93ad9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -668,7 +668,7 @@ xfs_setattr_nonsize(
 		ASSERT(gdqp == NULL);
 		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
 					   xfs_kgid_to_gid(gid),
-					   xfs_get_projid(ip),
+					   ip->i_d.di_projid,
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 884950adbd16..f1f4c4dde0a8 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -84,7 +84,7 @@ xfs_bulkstat_one_int(
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
-	buf->bs_projectid = xfs_get_projid(ip);
+	buf->bs_projectid = ip->i_d.di_projid;
 	buf->bs_ino = ino;
 	buf->bs_uid = dic->di_uid;
 	buf->bs_gid = dic->di_gid;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6b23ebd3f54f..8867589bfc3c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -347,7 +347,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
-		error = xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
+		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
 				doalloc, &ip->i_pdquot);
 		if (error)
 			goto done;
@@ -1715,7 +1715,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
-		if (xfs_get_projid(ip) != prid) {
+		if (ip->i_d.di_projid != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
 					true, &pq);
@@ -1849,7 +1849,7 @@ xfs_qm_vop_chown_reserve(
 	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    xfs_get_projid(ip) != be32_to_cpu(pdqp->q_core.d_id)) {
+	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
 		prjflags = XFS_QMOPT_ENOSPC;
 		pdq_delblks = pdqp;
 		if (delblks) {
@@ -1950,7 +1950,7 @@ xfs_qm_vop_create_dqattach(
 	}
 	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(ip->i_pdquot == NULL);
-		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
+		ASSERT(ip->i_d.di_projid == be32_to_cpu(pdqp->q_core.d_id));
 
 		ip->i_pdquot = xfs_qm_dqhold(pdqp);
 		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index b784a3751fe2..fc2fa418919f 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -60,7 +60,7 @@ xfs_qm_statvfs(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_dquot	*dqp;
 
-	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
+	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQ_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
-- 
2.39.1

