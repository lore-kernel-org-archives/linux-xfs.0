Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80450C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbiK2VOO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiK2VNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454A370DF7
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:27 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIe8rU005616
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=BLCJDL36UAdlXxcTxA+6Wc+zP9Y5au2gq7RAOrr9B6c=;
 b=AG2+yF/8DRDB/+5WSOVr4SWkhxl/a98RkUIdUrD2BijC30EENkAfeFWPHgoRUqXE0V8x
 pkD9CrGQUu5zEKvl/I4pmghLpeHq1aig2SVzEAte1Kuxkqs8xxclLN+sOIBjN77j4xMC
 ZaltW9waD1uXT7Mm6p6QADGqbAv9W0oitpZVDE6cUugJwo9osl3JxXYmwPCDnjGfY35K
 TIhbmpRcf7K70/psfmJPehOcBUb1uD5ieFLHo50slvSIdfdI3J5Yv4LuZbKwaSOD3yEm
 u8Ezr/glC8ShBQj7ik1L+3xe1Mp9MLWTxuCYrHw3bEusssbgSquK2kDv4UjQVT/fLtMB 6Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2r9gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATJjd6X019276
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398e6j2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiuZvwJJ4sJuOqXqfNXgjt5q0BMm5O8+kwpUWwRhh4nKB5EfOxwDglN7epbDx+sI7Sk0QdDbicCqBx5AdLUd1IIOwgmcuIC4w70BxjVds6MC/sTy3g2JN1xCYqWxSUZ4aJhg/cKjui6hatM+xBQEAQz26ZE7a31/X0f+C0CWUYCX8RoIm43G6FQGlI2EdW8+oX6URo3N8LgwK8xUi0fyTojYcM8ZgHCZoeqMiKRWjY2A8B58p/s6sx0DErhmgeNlQAbwQ7M4lH5Ic8/Tc23c2nGWX3HyB/SfLYZWxj6tH3AX5WjFxpjjNzexG97L+tna1RZgtjBEpKjvheE//Tvq2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLCJDL36UAdlXxcTxA+6Wc+zP9Y5au2gq7RAOrr9B6c=;
 b=ILzNIe777KB+UWgrBuOsBUG1gcS67qujdkhNDZ6H85Xo0d9qXESW9O9QovtLxCOV0Xrduja4+zbG+7mAI3y4b5ALK+/PPByf/ST7SQCFnAJgbH7Rq6hlKPkHEeyYzyKSgO8g8Dm3wtR+ycUzoBG5ZWr2pVwjl5h1VQwkNL2ecJPogTR93aC6TUvsiMA7CSw8CEo6BQmRc3u+SybwQNh1/TpiIK3P8AA6rPu5OkAX0M4wcWqAeWVa+wl6OB6ka+l27ffy2zOaRJZrGhfqB1L+zmpxB6ODRJSP05Bs8ujSYN/amL+mFJZsdFRhJ/7zBL/K6K+QlSIdq2GM6RkYkhISXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLCJDL36UAdlXxcTxA+6Wc+zP9Y5au2gq7RAOrr9B6c=;
 b=gPxIv+kbnUrfsQfzyWi5/0AVmvpPIfCRD+sui5qEfjsOCfOdrwySTWj6yD1+gEDE58rcusqx9gnzq7/XwMDRwUEC84KncES02GW1XNppTGtpUKIWvZrneuvMMZfCWS2yvZuHyx4acHLRcY+8CPrZHRMg+SD2svsmj1Dor3olCM0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:13:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:23 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 25/27] xfs: Add parent pointer ioctl
Date:   Tue, 29 Nov 2022 14:12:40 -0700
Message-Id: <20221129211242.2689855-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:a03:333::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: b51801cf-df98-4cac-f463-08dad24e8c91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XK/yUbly2F+AxQxjsvdR5u8cEZMC3a0o7eEsiKkxP7KS0Co2Jh2+gZF90X3mTUw+WXx0R+rtjBTmWmenpopwiXKXueHZK1NbTcxY1pWlKFgYX0lO/c02Xk35tY1ETgZDYzXlc5PhBmW8nDvaujoODaSklisSUArPUnHEPSRreejKX8QQX2kJFXEQ1VJkr13Of0fMZO9hqOqU/yS8Noolef04WxQA1nwHNzKrA8ISg8Ykt99QPGteyyqx6xDwRGWXQldN9Rad+joiQuT+sHBBfQRTgvMOblkoJYRpD6rphoQaeIVBswMXQ8Bnif94JUSogRdOEEMoFpA4obz6HDbRmYy1g3DIlSbRLNfORoE75gkbr9b2sYywqxxUzixqbn2N3yOuo8rtr4WIyGgSu4I/fm3Bhn59Lwfybdhf52/ae5yQ6yjxz9hA3UEWBzkMBp/j13K3UEDLbD6H03V0CIuhh3engkumjS+xxbtgOlZlTvGsyES3Vg96Dw8W2NqfdoSgtrb9DLFFRnG0J+na4+sx7rLaFaTUTDBuxAbLXcHpq2k9wGmX3UcZHNYJMxWmRhDJqWq6QKT9AOF5SC4ARQjmlc1N2oMp33UMmLt63wPzaYg0tkIfL2PFce8CNinmcDwe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(83380400001)(6486002)(6916009)(1076003)(2616005)(186003)(30864003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iR+akBKKPIs2Ks/MYJT5GE3mltnBY5HZiaqup5hqj5aSY65njsJKb6eBR+dv?=
 =?us-ascii?Q?5iCwiqU694FwP0BFOHI8t9IVIe9qONp814A5F5IFOnahqnQ3TrDraohqDWN/?=
 =?us-ascii?Q?xzr6QXHNR8IvBSxv0E9YQ10p4Etrg21TBA7QVk00/YKFx1tO6VooUjIWOxrQ?=
 =?us-ascii?Q?B7yXl2/q670KAAXhUp9w9EzWLpUcEdB8PBbgtnCboKlqyVDlp47pUFrWYd/4?=
 =?us-ascii?Q?w2obnLYya8QsvaxpE0gnBPb5b6MyvUhhHMd/E2HtflQ4arD0tSxjYy8DfvN+?=
 =?us-ascii?Q?QCRFEYZk68FsBeGhrotaLS+I3Xg66NTNZODANy/mMRXRbh1ZH3J+sHlfVPBk?=
 =?us-ascii?Q?jcOipliRJYcFnaw/9SHI7s7mBqK/0avQOPqO8hva7Km36nuZj0thBt9IBEqA?=
 =?us-ascii?Q?Y7zBp208986NxoCFDET6m2JAAx12vcVS2Vm3T714m1CNDv4kfapwL6z9hVXr?=
 =?us-ascii?Q?YGSHyaqY4K7n2UWlT52Ih3FoqfSJRKuSmJgpW0cNtwLFQ627RRrIeeyxHhn1?=
 =?us-ascii?Q?+5EgrO5mirdX176QwEwLmX10LKsGwwc2JKoRvQe6HFLsrY07DYfC331KvX9l?=
 =?us-ascii?Q?v3qdBcGn7WocsYyGP5stkDsANGPTOeQWHULgKFIwEasprL6LV7HPMngwjjBK?=
 =?us-ascii?Q?F3Whj8CY+SPEWqcXdthx0sCDuoCMdeIAxhEe2grbEAMrcTJSUahGrqCpd/0+?=
 =?us-ascii?Q?AUBk4izfdLyXGklFkHqYVDUZiHmrQoxc8gLx9b6Qh+d+plH6yVeWeNTE5iiE?=
 =?us-ascii?Q?/xGfaT5l8x+4pMz0iLneGQlFdcgVxpbMYYHLHag8iHX8HuM9rdcjyBPUKuN+?=
 =?us-ascii?Q?EppQMNtbFNtIAlnL+ZtU4HorXNaN7//0vPkxe4fDkcOp36SDTr1ZWvVweP7F?=
 =?us-ascii?Q?EgPGtALiFQ3BKigtO3TBghiKB2yq/kS0wJRrfch7nyAAorxl4YjUoRCSTZQ+?=
 =?us-ascii?Q?Bp5k6RfFJ+wTROZqSdiaR7TRocAazMb5gItm3TpE7+W4RVoLtbr4zJ05vAKq?=
 =?us-ascii?Q?aH0QiKsatQTcGmsNw1p57HusaBm5MpDh6bmxCO2kZGSKO/IcC/TX2IpJoxpP?=
 =?us-ascii?Q?DuXJ5GrjxwFp4BUg6ZGkjwTiZo+1QSBLr8SReSbSNOTzgYZgDOH6X1+0rzTX?=
 =?us-ascii?Q?uGd/K0nMniHFsnZbaBWWCHHCbnwNPCq1zl9fe8mFSkzZnCxVQPvbnunvzHH8?=
 =?us-ascii?Q?ZOxfXeWFhl1ni1Lj4h41I2F4Q1F8J6mlzzBpTYZ9s2FB33oRhIPZMeu/q06P?=
 =?us-ascii?Q?s6PnjAX2xYJxwHi/myMmMDl4vKmpQLFCuR5/SSjz7373A+5SYQQOlxx9P6FI?=
 =?us-ascii?Q?PPinMPDUenrpGuoDnt5Qsnn1ZqfHBTKsa2zOJG+MdRkzEoR6NDJpjSZChvl6?=
 =?us-ascii?Q?L6JxYXdFDtDFolkEGdJsNH/RKdVpbl/xAM1gOkW0QSPkBtAETYznb8ZxGj6K?=
 =?us-ascii?Q?p+S+a0FDk2qTBGkNMYbPgL3PrGhDq+4FTxkvictM5MINKjQFskzg3bPrqFnY?=
 =?us-ascii?Q?BXbZjwlZn2/WcdBDrV26L7kLbc49z6KlUsvDNKU6i0TDHdfMSp9VytYtD0V1?=
 =?us-ascii?Q?aPK+NO1/x3wmF6NmzfUE9sCpCgMkM61W4JlexkGFBDZpK7JuUGldmXD+1XQT?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CEQ5RuBCtIrQcxt02UylZGx+i93Q9J+quPgJ0fh1+R6WvDCmFimOkQizHNiQWXHzWFMTRfiDxUelSLEyLTsCO5Tm0CRHEBdoS4QjhuNrB09VdWYzX+h5IGVJ95MDZ4YDF682OKYghUI/c8DpNsgUbO122y/j7x8L1lDp+v6ouRFQm7z9RR8Ikt0Zc/1eNsZRsOgsBv/TIi4hU6D+BsnkuYlqymKU80nbD36574FSzzJ97CSOYZzoClIMFJCCCbvMP2Vr4M01ao+Q+Vn79lgIJOeh51IDRgYH3rH6/MORUxLkiyeAQLid5g1cOV0ny2Vo+STdVYqkBSiOP4ibo56DZgwZEmj/PeoYJrXtwqJ61XEwE9uUw35Cc78hnWpdYLEwfWql372l4pEwvwWiSX8QoRbR4VroV+Nje9UF1LwEuN0OcCJRgp9BPjIDV10S2zsd0WSpkjmkjtUYO/gFvWi8vHERfviKQHukwATO0QzXuBcIYrKl7Ag9ANbMKyrp95/aN0rbFxIhP9fGaFP7fZcoh67ztV5pv/YEukYaEtzVVx6HJYk15Ei/7f2388rQzbiDUWmExbgHeAbxDtqzislIiOlRVtNszT4gywe0UBaGThP2eNV/WggePCstZsPGrZJYpLMnM3PtDPDfphBTu9XKuYFo+CSXIpAatgzKC0k814175rENP4cAvbeqhBL0OfYs0KsToUQrE/9iP3Ml3ZjSYzAbjXRDQI03lMzeeZ12occV/tR9pBnc09pU6ROBuKIze6Jk2wP8uZHOdLtNViTF4Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b51801cf-df98-4cac-f463-08dad24e8c91
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:23.5878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Auu80wlzuohaZcvMX0FASlJY61RvAeEE3rexeclS5a4aIC8LwkE0n5UcQR5DwTu5iiehXp3GUagwZ+Joju4ckFM5Hrp1Xn6+OJTgmUVQwAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-GUID: CAPj_EXLq1y-Mqc9E2igEP6QYouqEmDF
X-Proofpoint-ORIG-GUID: CAPj_EXLq1y-Mqc9E2igEP6QYouqEmDF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_fs.h     |  74 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c |  10 +++
 fs/xfs/libxfs/xfs_parent.h |   2 +
 fs/xfs/xfs_ioctl.c         |  94 +++++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |   4 ++
 fs/xfs/xfs_parent_utils.c  | 125 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  11 ++++
 8 files changed, 320 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e2b2cf50ffcf..42d0496fdad7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_pwork.o \
+				   xfs_parent_utils.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b0b4d7a3aa15..9e59a1fdfb0c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -752,6 +752,79 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+
+ #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG_ROOT | \
+				XFS_PPTR_OFLAG_DONE)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u64		xpp_rsvd;			/* Reserved */
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	/* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
+	struct xfs_handle		pi_handle;
+
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	pi_cursor;
+
+	/* Operational flags: XFS_PPTR_*FLAG* */
+	__u32				pi_flags;
+
+	/* Must be set to zero */
+	__u32				pi_reserved;
+
+	/* # of entries in array */
+	__u32				pi_ptrs_size;
+
+	/* # of entries filled in (output) */
+	__u32				pi_ptrs_used;
+
+	/* Must be set to zero */
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_parent_ptr follows the header
+	 * information. Use xfs_ppinfo_to_pp() to access the
+	 * parent pointer array entries.
+	 */
+	struct xfs_parent_ptr		pi_parents[];
+};
+
+static inline size_t
+xfs_pptr_info_sizeof(int nr_ptrs)
+{
+	return sizeof(struct xfs_pptr_info) +
+	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
+}
+
+static inline struct xfs_parent_ptr*
+xfs_ppinfo_to_pp(
+	struct xfs_pptr_info	*info,
+	int			idx)
+{
+	return &info->pi_parents[idx];
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +870,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 954a52d6be00..fa3d645731a9 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -27,6 +27,16 @@
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
+		    const struct xfs_parent_name_rec	*rec)
+{
+	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
+	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
+	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
 /*
  * Parent pointer attribute handling.
  *
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 9021241ad65b..898842b4532d 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -24,6 +24,8 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      uint32_t p_diroffset);
 void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
 			       struct xfs_parent_name_rec *rec);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 const struct xfs_parent_name_rec *rec);
 int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5b600d3f7981..3cd46d030ccd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 
 #include <linux/mount.h>
@@ -1679,6 +1680,96 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+/*
+ * IOCTL routine to get the parent pointers of an inode and return it to user
+ * space.  Caller must pass a buffer space containing a struct xfs_pptr_info,
+ * followed by a region large enough to contain an array of struct
+ * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the inode contains
+ * more parent pointers than can fit in the buffer space, caller may re-call
+ * the function using the returned pi_cursor to resume iteration.  The
+ * number of xfs_parent_ptr returned will be stored in pi_ptrs_used.
+ *
+ * Returns 0 on success or non-zero on failure
+ */
+STATIC int
+xfs_ioc_get_parent_pointer(
+	struct file			*filp,
+	void				__user *arg)
+{
+	struct xfs_pptr_info		*ppi = NULL;
+	int				error = 0;
+	struct xfs_inode		*ip = XFS_I(file_inode(filp));
+	struct xfs_mount		*mp = ip->i_mount;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Allocate an xfs_pptr_info to put the user data */
+	ppi = kmalloc(sizeof(struct xfs_pptr_info), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	/* Check size of buffer requested by user */
+	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL) {
+		error = -EINVAL;
+		goto out;
+	}
+	ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT | XFS_PPTR_OFLAG_DONE);
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
+		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
+				0, 0, &ip);
+		if (error)
+			goto out;
+
+		if (VFS_I(ip)->i_generation != ppi->pi_handle.ha_fid.fid_gen) {
+			error = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (ip->i_ino == mp->m_sb.sb_rootino)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
+
+	/* Get the parent pointers */
+	error = xfs_attr_get_parent_pointer(ip, ppi);
+
+	if (error)
+		goto out;
+
+	/* Copy the parent pointers back to the user */
+	error = copy_to_user(arg, ppi,
+			xfs_pptr_info_sizeof(ppi->pi_ptrs_size));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+out:
+	kmem_free(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1968,7 +2059,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPARENTS:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 9737b5a9f405..6a6bd05c2a68 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -150,6 +150,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
new file mode 100644
index 000000000000..0bca1814dcf4
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_ioctl.h"
+#include "xfs_parent.h"
+#include "xfs_da_btree.h"
+
+/*
+ * Get the parent pointers for a given inode
+ *
+ * Returns 0 on success and non zero on error
+ */
+int
+xfs_attr_get_parent_pointer(
+	struct xfs_inode		*ip,
+	struct xfs_pptr_info		*ppi)
+{
+
+	struct xfs_attrlist		*alist;
+	struct xfs_attrlist_ent		*aent;
+	struct xfs_parent_ptr		*xpp;
+	struct xfs_parent_name_rec	*xpnr;
+	char				*namebuf;
+	unsigned int			namebuf_size;
+	int				name_len, i, error = 0;
+	unsigned int			lock_mode, flags = XFS_ATTR_PARENT;
+	struct xfs_attr_list_context	context;
+
+	/* Allocate a buffer to store the attribute names */
+	namebuf_size = sizeof(struct xfs_attrlist) +
+		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
+	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
+	if (!namebuf)
+		return -ENOMEM;
+
+	memset(&context, 0, sizeof(struct xfs_attr_list_context));
+	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size, 0,
+			&context);
+	if (error)
+		goto out_kfree;
+
+	/* Copy the cursor provided by caller */
+	memcpy(&context.cursor, &ppi->pi_cursor,
+		sizeof(struct xfs_attrlist_cursor));
+	context.attr_filter = XFS_ATTR_PARENT;
+
+	lock_mode = xfs_ilock_attr_map_shared(ip);
+
+	error = xfs_attr_list_ilocked(&context);
+	if (error)
+		goto out_unlock;
+
+	alist = (struct xfs_attrlist *)namebuf;
+	for (i = 0; i < alist->al_count; i++) {
+		struct xfs_da_args args = {
+			.geo = ip->i_mount->m_attr_geo,
+			.whichfork = XFS_ATTR_FORK,
+			.dp = ip,
+			.namelen = sizeof(struct xfs_parent_name_rec),
+			.attr_filter = flags,
+		};
+
+		xpp = xfs_ppinfo_to_pp(ppi, i);
+		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
+		aent = (struct xfs_attrlist_ent *)
+			&namebuf[alist->al_offset[i]];
+		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
+
+		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+		name_len = aent->a_valuelen;
+
+		args.name = (char *)xpnr;
+		args.hashval = xfs_da_hashname(args.name, args.namelen),
+		args.value = (unsigned char *)(xpp->xpp_name);
+		args.valuelen = name_len;
+
+		error = xfs_attr_get_ilocked(&args);
+		error = (error == -EEXIST ? 0 : error);
+		if (error) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+
+		xfs_init_parent_ptr(xpp, xpnr);
+		if (!xfs_verify_ino(args.dp->i_mount, xpp->xpp_ino)) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+	}
+	ppi->pi_ptrs_used = alist->al_count;
+	if (!alist->al_more)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
+
+	/* Update the caller with the current cursor position */
+	memcpy(&ppi->pi_cursor, &context.cursor,
+			sizeof(struct xfs_attrlist_cursor));
+
+out_unlock:
+	xfs_iunlock(ip, lock_mode);
+out_kfree:
+	kvfree(namebuf);
+
+	return error;
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
new file mode 100644
index 000000000000..ad60baee8b2a
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#ifndef	__XFS_PARENT_UTILS_H__
+#define	__XFS_PARENT_UTILS_H__
+
+int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
+				struct xfs_pptr_info *ppi);
+#endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.25.1

