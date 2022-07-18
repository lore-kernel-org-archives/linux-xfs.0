Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5ACC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiGRUUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235151AbiGRUUh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E862B611
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHUT9C013970
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=RfDQaFTJ2peyZtPxJgtawUcik0Pb0vWHQCcSJCeqo7M=;
 b=R/CEUFXO2YuRvReg5JNStMck446Ug73SF5Y3jHdU7SdmXrEwnc7Osa0LIfKbeGiFk+UY
 z00zFl4zG8/XDxsZywZzsD1e8flqO5W94ryLl907+lpSd+7sE/MNJrbW4FxSuRcRYgXD
 Y4MHGMsN9YSBFM9KWvUkrh/UwyleZBN+QOY8g/pl1r8Tm2hjDwYIRllJjvgT5wWrPp7p
 tttahOUKza8l+aQmJZGp6eFbcZLQsM8oj5RPJQTW+g8YAmygrlIsQH82lvaa5nbmoiWu
 MCUQebE5wRq71/MgXSre/J5h0BR9GRjZA38ySs1nfI0uMlJHseuVDcrwMMfAgd5D4hQg hw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbmxs4ddt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4tC001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cn8kWzaDrheofVgD42j9uPt7FOc18phBiZx4uITYmqJw/1Njp7Fj/2ol0DZbPg2nW43Ze0hkKtV9jWeIcGmi7YW4FsWSgLthuh1FAa9U5sDU+5UVMf/sSmVgAbSk5MDZv489TVqmMY1cAj1f8tZtDL0VO6p0IwSK+3IUzzZ0UI3yLhaj/9PeqkZP82audHi8zsS7RdeT118oOLgIuJIj26QNZmYzo9MdBM+h7J6pX3UEiz/bM4+CTZb81RtzPBrsIybRSUj3vtgI2CZUWjxAVewQXHOLNvNF9xEa2Zqs8O0pYAdw8R+TqNo8LpIk0GielhDmtc8nFlDQQ2QdvJyXyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfDQaFTJ2peyZtPxJgtawUcik0Pb0vWHQCcSJCeqo7M=;
 b=J3Xm7NMPNjnNRzZxiaptY//kblHaWniBOIDmSs8pJ5gcy1X/dggfmrddriLCjbdE2cfTrLUgt6GWCqoKtKGsmKVWsn2lKwvOqcrTGBLS20H3uneLQRZDF0Tyl1uwh7NYv6yzp3CtbRHQmbzwCetd1ER1lV6Ys9e5kUKsUIkMHube2F2n/+oqgNH0KB6fQ5v1isiJgLxOpjKBg18jv9AlVtnVilTc403lhd8pL6+a4d07w3Dy27665JWaMIZZPh2QLk9XQE2vzLiwXhIn8W3EYmFOTQHqbxzxJJYXAZodPL3mQ6Sqf/VsGJutLy8q0Klz2TVqZS9a3/xB6NPmpmgeJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfDQaFTJ2peyZtPxJgtawUcik0Pb0vWHQCcSJCeqo7M=;
 b=aVBgHlZHZxdWKhzyJF6bBLcEyGzWkg8nzbyegnXwkcYsytyEp2kUPDYy5lpRDuCB4+7mo4vSlyLRkFA0f1JgS7ZHfgYuMaqzwi8iy7kHOsIAehV2EsZxkFgFziOSfanhtQeHWF6PI6fptQQL0fqkHizx1H1/L1rFte1Wgj60clU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 09/18] xfs: define parent pointer xattr format
Date:   Mon, 18 Jul 2022 13:20:13 -0700
Message-Id: <20220718202022.6598-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 167bcd1c-0b13-4c91-2c61-08da68faf68f
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qc9u825xxD7HWFWvHPqNidYeCYAn4xUuKo/Y+9ZUuynZ7VhVbgfRo7qVIaAoAJ4rQXvipHZzqBzo4tSkYRE7MaqORAA/F4uUTzMdK/ms6PN9KKQt6tYeL/PkvKc4TigagZJXmpT8dNojI/C8wrmyWmGM6SFkyLfPUcEzGtM4cwX4pgvRUQ6rXrWhQyz6UB8bqmNCcCd62b6RAlUrRcNdeRJhHSUwSvPcIbCCTp/9c1iNOctXVSX9oMZATNTgWAaeXuNDmni1IJ+wsKjTQkyLRbQ+x5s3QYtztVPWaXslGbhpHnrT4xtrUJ5zoE3PIhyYdbhEdKTPNLOZyp5WZT8OjwQ7lPGdCQmNtRYGeCZHrhx6elP6WEw247qhs4zDI1q2bJav8113mUrVxE3ln3EE2r3QE89jEoVex0tpvVE+fa5/sqOTfp6guZe+7TGoTtiDa2a127L6/4qc3a6DaJaqSNcZZpGUnz9Y01lMv9+kx4bqtw6Eo5B6cG6laL6Xtra5sybzAsuzaYQLnWwCJu0LNIi+c+Sn/zybFKfCxec3TglnHVN2LLShK7XuIlDI956pV5dT07eaxRsd+msnrt2HQydOSLTsJIqtInyIT32d5adcJckIuKzafuKAaTip+9ZvFjG9YyaKy7kiOzreHk6XQPuSQrnnPuX6cvR/Rtb7idmWZ258ghAL0jCwtJWM82/Q1uZXe7uxDkjcgsO44elyXqHJ18nMf5ttSALJEQM7veK8z3oqep0nyOPn5Xd5NugZ+QfR6BqPvWYMSpiA/2RbeFoYLv4U19N91eKROVJrYL4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jiu7dIMxbX/jAr0hJW5WziFOqQ+sdX1Gk6KxQr7vESSxs7DhmQaVA1sahhlt?=
 =?us-ascii?Q?FlqSesjOweQ9/V9Hnhb472VpPlEo99ITJcrsMdmdbVhepj0O1DEF1LmXfSBu?=
 =?us-ascii?Q?fPK/4iWO42nCAbym6vG1TJ4YP0TOYruhc/H5kNxPa3WZ09UspIiPZMHZjGnE?=
 =?us-ascii?Q?WESL/L240zWTi7c8huvyhRVB/I7Cyd57xuAH+91Z6HjaRtLpDmq4M/pE2/Lz?=
 =?us-ascii?Q?6MHnzx36+ffUE1R7RiQAt01jTKUnFrUtVJEjd00IfyXhcGR7hO1SM1Z0lV3t?=
 =?us-ascii?Q?jbPqwNBzW6qLVVyCdejzSxwZ3j4yKQh3NXk4lKMxeChwkRqNx7u5e2p1hnxg?=
 =?us-ascii?Q?whf63FWTgl2ox/X3r2wGhhWH1yQFLPxAANFZWfkzY50O2CWAQJhZIBZE04B/?=
 =?us-ascii?Q?Uy2ItV2/EW+YCszMFDRMMo10gKS0RbpUtaTJmIV/TxWJSbn8kgaG+CKSh/oO?=
 =?us-ascii?Q?HgwMtf5nebmwl3fM0q1UQlnwGnjnUlYSV0ObdANuA99kBlke0xi4mSCgLo30?=
 =?us-ascii?Q?d+T8S1EUsSwGXXH4fuXzlDYX7HC752CkjpAb+fXsCe5b+hTJYJm4JoW6rzXB?=
 =?us-ascii?Q?RJK65up7ZHFWC4wEITdzUP6bV6qhgJeKkcPXKlPAMnOJwAqb+Gio5wnSpsfq?=
 =?us-ascii?Q?tuiV2zJubn3bsxPAAoXUcKUBHzY49hWQ3ptTWKyXgLXWqmb0w0ZErK0i2va+?=
 =?us-ascii?Q?ZmpSkaYbxIqudCWo7eFXUTvWi8TL6lxtvCumRvrjnzjUUE8mv9rxA3HNPKxg?=
 =?us-ascii?Q?eMllpM2ijZledu3cmK1xD/v3BQOLdCKM0em1iA6zAco2H3MzRkq9Et96rOcp?=
 =?us-ascii?Q?QqET4hOFlqp0LzEhG8Jk/UqgS3l7qAShaSokumrdkbNN8xGSQhHa7P/XqHtU?=
 =?us-ascii?Q?DAw5uXr1WpUyR0/dzHn50JIdVBg17u0gYk6F662ftvcr+OHrVO3WuVuSh3wj?=
 =?us-ascii?Q?+/M4PaLn/WRArEhBp647r9FmROC8T4cWFBrsyURBwNw2ka+kYg1QgA7ibe5Z?=
 =?us-ascii?Q?T/CPSgOefAMa9bv/fI/VLVg1+uw08e6BubeAPB8aZ8v7E3AX7BZpBtBtx7SP?=
 =?us-ascii?Q?/gBPH/RyrH1xmjjPsBnI7ejZHpe5apWFIcSEP/5+gKOAEvq4hy0lULeugBTC?=
 =?us-ascii?Q?91Teqxn//98OPNfmw/SXtfR7pfzKo2XBDe2MRom7KwW0A0YAGB8F8AQeZdkr?=
 =?us-ascii?Q?zudumwI1wtv2K+T3zFS14lB+aATRGJDYmiPvl8uUu2c7oXTqIR22u9+zg57f?=
 =?us-ascii?Q?pRyhNPPIiXvbPRk7EUHDVAfmAlfwy2kHw/wyWeBbnmPxcz7sgm7oT18I+KIP?=
 =?us-ascii?Q?Nr5unVn3RTJxhz9hUc0XhIoulZM56O/fRGhorV5/faeY9Xw2LPf/sZyAAh4d?=
 =?us-ascii?Q?wnoyT5s+CMG/vtPNv8shQlXEMqSfqijYR07qCrz21S7lKfq4Orz7bBdzHCas?=
 =?us-ascii?Q?5E5o7K5iUYWd6hDYbWGcHrWujir6K11cDJ3yvjWa3DQ9q1dSBBs3jT7nhuD7?=
 =?us-ascii?Q?hSUWhx31tHSQEARg2NoC4IuI7SqsVFnBkZPjeu9MBWWRTUanw80yFbYamCqD?=
 =?us-ascii?Q?VgV3qsXOw1egenozBT7EX77Y7lUI1C+lGuFhn07vYTY86VK12IpsLxql/jFF?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 167bcd1c-0b13-4c91-2c61-08da68faf68f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:31.5752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0Y7RClYidtitXpM2CF3mUzjQ2DGpRD+auqUdO3zWR5qZm9iRwTmNhSR31H3lO6iDcIVQ+onz+wKUr0r3DmWN5Y5a8BCQG+b3QQEdzfenUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: AbPaMQE2oF-xzp2tT_vHZqOeeulzVUQs
X-Proofpoint-ORIG-GUID: AbPaMQE2oF-xzp2tT_vHZqOeeulzVUQs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent offset}
        value={dirent filename}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the dirent offset in the EA name, we have a method of knowing
the exact parent pointer EA we need to modify/remove in rename/unlink
without an unbound EA name search.

By keeping the dirent name in the value, we have enough information to
be able to validate and reconstruct damaged directory trees. While the
diroffset of a filename alone is not unique enough to identify the
child, the {diroffset,filename,child_inode} tuple is sufficient. That
is, if the diroffset gets reused and points to a different filename, we
can detect that from the contents of EA. If a link of the same name is
created, then we can check whether it points at the same inode as the
parent EA we current have.

[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           changed p_ino to xfs_ino_t and p_namelen to uint8_t,
           moved to xfs_da_format for xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3dc03968bba6..b02b67f1999e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -805,4 +805,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.25.1

