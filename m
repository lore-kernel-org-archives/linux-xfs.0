Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA93C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBIICV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBIICS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB10F26867
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:17 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197Pfpb003363
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=XtWI1EIcxYzAAlrvI3LZLUi4XGR6A1SB/+X000AMgD9f8xswQJ0y4wIw2OEUBLRhoxGo
 6xZqcEJDDqbKgLwiyh2kPgtm/W/vCPkgeWmeREOwHdL1j/ceEPFBCoTbjWGHKUikXqcK
 nvLg80p49vCmtu9+YcjRsbrqnMEQ7UCIiDJ3OjzFfDFhkFZmCdcNiJxRXum9povzs4qB
 x4cMqZRfcdW40FX1DHTVQGyNFXfe3C3GBd1ZJFIioqujiic8eQLxRomStGMNi70+5x1E
 eoqkF2hzR8TuLsbFC4FkUkmAfReH+iErI/WnHihWUfBusbJEBBsfDEyS+PmFSBlNtbZA lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8aa44b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196eBvF021294
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dv71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVS0Fn5t/10oSNsmxWbMuXU12iC9FFz2Mi0+8+ry1gxOawJi+Ux3XkU7fVvCs+6TEEYNx+eFsmjAbPi5Rs+PeJmSROZhtcUAcAm2Sw5OvEv+aXOs7lBJ2SJOkblpA6tyQYZD1SDYd9jUlBa6OPoNMXBw+5kdV78hoWrMESdGeoqlcxBENjRDfh8ikI+Xosi5E+DzfI5vMEm08g2aMAL283Kn7HWKpAq0wammbnFnWfV5GsODJVV+WYZXCqbiaIPLx7bF0AVlGpcgAokBQqLNO+U2maKLX+zpHlhMlBoJUJdzG2w4lGOe+vwPjNK8ZaiQbTzGlVtX+SRlNRyCDVqV1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=S/8DZa+rzCFY5Xlcb0K7wZBYZv348BNOqsWYVWwPPw2OZDPr0km2ct4KtLGacqyUpYN1VvexdkADTiJWRGo3rwS2ijJob3ta1V5ORK2qOhKZMX1K2g/84IxeOyB3IBK+8P36Oc1eH7ow0dXNYLFvuC5gcNCg4VYAA8LR6F8VQt7xbveUVlQqR+3qEeOZkf5ui5n7GP8LHh+EH68rWsFAnhONRcO1dIJ5MqblnM2/5sMI0byiXHY+ZDebdIGSgEkSPDK8vr2XYSX2gzJCtYsT2iUWjnAPDoARm93Y4xGN4JMTxDGmgAwylmw84fFdOh4uhz/z+hJxnLh6vkjDe1cjAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=qrAyB5TaesIJMeLu0C5pIGBV8PRhqmfN4jJsuL7HzcXramd9I5XFyK/TcA7hDu3d0tIfoPjdwLE1ZOVaIfU2NvyMFyyfHZpwibGT+6xpPni0ALNEbYUw2XWcgu/wOYqxSCORtjMw7+PaqLtSQDbbxyY82PMSta6TDwTb0xPov+w=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:09 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 12/28] xfs: define parent pointer xattr format
Date:   Thu,  9 Feb 2023 01:01:30 -0700
Message-Id: <20230209080146.378973-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a6b22ee-5178-448c-de49-08db0a73f1a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GjPuia6MaqzBnZmhxtCPJxG5JjbzH/Pybfn1IALp3HB9Szu5gOSCmH7xFUkJnsq7izbp3pby+VWs7KRNd/YLLxP9ubhHFv5Ve1Xrh8pn/UvYiAMNNymHMld9Kz44SXlYCIPT8RhGsYn1qyuNsf2waAjfbxSMWkDDvfAj6VvTZ96d4tF7hKd5WeT5ptaiTMOkg5yFUqoGIp1lpNdXSxzvQwnrM2LHj9pfg2oRhudXVXE37imMxhw1hGAEbxhUbHPI8+l4StZDBaSe+INAk8kUcU1dt8IO06Dk2X8fDYDEnkciNGP6Tm60hJaLTgvcHnwrEJPT142Usoh19Za8qVGRKz4pbf3auXNYOgLKcyLjUKsXjG7yxMuvKav/fMgipNg+Xx8NfQHgg7WvJrrAbcF4eREjI1mlYcSlgYUVTXx2hKqay9kl1Ah/Yp46MvmL2TGmSVNqRTbjVPOxkdWRpS6zaiumts47PY8ABGAfpKiemome9mpN0P9LSpElu278nv/YGmSaDef5C/EpYrI2ZeKHtUjJ1kIijFo3LzTiLiWk+QLlsQ9sa1G7xcOrqE3V3D5IibEIj46aYhnyQyKM9+KLOl04jcCyxNhLAvgRBfgCFsEaWlHL9BWTAY3rSXDuGYD1hF9hpUm/p5M/O0vNJZ8VMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r1a3oJobhZfY1sVG5afnSQXaANgqzqcfRRQNURvNNHr+VDSGA7VGm5I2/3UF?=
 =?us-ascii?Q?XvZlENnFsWglPJfFb72xIXAI6Ex9//0NQN02JCworv0JwOu2tX/tsp2EX9gf?=
 =?us-ascii?Q?l1eqhcCjl8RL4AhKwKFwv0vNaFclJqmhRE1io8nKU3mNI5UlQ/qvVlZfaAx4?=
 =?us-ascii?Q?w1qenngXYV5OxjuPmmEZpeX6mr0xeYVrhI1X51yti5Tn5wKac5F6Mq9jEhon?=
 =?us-ascii?Q?+c2elLhP/F82scnivUosa7ENgYBiKQHCLoO9GBLHrc6z8BSvxHFhCe1NLeXn?=
 =?us-ascii?Q?QxBDzL+9zdtVTSkcpmgISv8iomo0p554xtQ/ZpKhfK5dFhjkoKJbeyHMR2+m?=
 =?us-ascii?Q?EBKhnhygt08Sd1/dPU16wA+s/eckAQrAjPjBZ7YmYPrMsNvXMnrv9vtrzwvu?=
 =?us-ascii?Q?R1zPb2Bk74xS2L1yfNl2o87Ds70zNparNxoYe8W2x2lnl7FHPYDaIxBIRgky?=
 =?us-ascii?Q?QwIQssIwVYdp3SY2nEV9UNZ9rGe5TlsicUMeFGCDUx7GHgDhb9+6CfrzMLyc?=
 =?us-ascii?Q?GXXgAkQMo9uoMVXlR0JqdyYqK6Yh0YsV0SAV4Q6jcrgvwfVqbCPFZlwfsWGO?=
 =?us-ascii?Q?EVtJNbWY0fejBJQxDI+wDuysRBVaumyaCWw8yiKoZzExjfzqB+xrzdum8mNj?=
 =?us-ascii?Q?TJgm8fal6VUTIEs14cK2cIb2RWKFmyC1wopC8jS1tgdGZ/cFH0EDvqxHEg8c?=
 =?us-ascii?Q?07GTTH2iqq2GHt0TR3ZHGfEc4zTrKSExLMBudvT7P07rK4Siy05Vyxqnj2Xw?=
 =?us-ascii?Q?AXNlpMxOxMaekylszBd1N1ucqWUKiAOr4NyC7Oet1VUHiQINzpHiQG95ZsFN?=
 =?us-ascii?Q?6cA+JanxY7J0ArQfmQUiRlYEWoA2MtVJ1N+wQqHkHWLTNrMKKPDxLI6cuHCN?=
 =?us-ascii?Q?Ms8RtigIpHTiPCDeiVvMRGJfL/ntTQASBH83b5chJ/pSUR8YkjFLTtZzhmeb?=
 =?us-ascii?Q?rgDLmezgQ886uQtwsYbTDnRURWxmcAzLHU+O81u6IzlZ5YJ0Peycq9D5Bdur?=
 =?us-ascii?Q?fznbSVXyQGopSHjQpOTplnyvUJ8WflLxdpkNxdA+FI/C9O7ahQ6IIZJ/EQUk?=
 =?us-ascii?Q?ilD+bvKaYPtrUdzHaWQMkxIjoPuAlYaNbT8SiSRLSe74Luof98SuY5f214+v?=
 =?us-ascii?Q?kzsDwqyaAZmeMxfs/BlTEJKftiQRvzZMZ2yd3VLWXA7MLHhUTyyTYGJXkjo/?=
 =?us-ascii?Q?ZoZnH39v8OHeBQlvje9Q1iqKR2XzPaHWAL/ubg+P2ZeaTQBYcH0lY7G5+aaQ?=
 =?us-ascii?Q?YDOsYH9FLbB+4sYw5/g85hxV7vTneMz4SrTeKfK8vZbxSpD0mvk0ESAAvKco?=
 =?us-ascii?Q?N1uHcEfftmcNjnYKKPWRMEGfOW6SsoNYEDEeej3TtimY+U49xKqECnKgboSR?=
 =?us-ascii?Q?BCRTrMtyEhj58kv4jctAGZE+ucGbKuS6BSxXh4q0RWbT0IJHsob6G0wlrMEm?=
 =?us-ascii?Q?hNNLiC7s+2VM2VKKWH3nTs2vBjoaJ+jyPkPTRa8kXTE5HNdW095oJlSqLo0l?=
 =?us-ascii?Q?dXSyc4mIi1n94zKTrr0Sc0wdJAHw4CZOLkIbzGO64+OHgrJ699szLxPKzJzX?=
 =?us-ascii?Q?qX03e7SDRrGiwOmEpxIOTXVpBbyDvkyqHzzUAGhsCrbK+FVz74bRRrVwBmd0?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cD+tsFD+JsI1l9JoXOp89zP8goJvEgHmlCYIpnxEegLk8tXVCBIJunFqstR2Oy3DcQGA8vNuKkkODKUyWhzQi+PaCXMz1EDm68KghxxcI6X52J1DHtgchaUsiCD9Qjb28h45nE3m79em1TWupH4NcUX2K8cZ0+DGiMftYCfmeRi5NEk1qvW4uhJJgUOKf44HwJCtC9N8YlnFlI9u9OmBwFakHAy+a219fECy+P7K8E3J3NJVvk8bttx8RwAPsDxKpjmaSZCQF3osGIlnu1ALLZkBqZLKraRyMhzkTDSt9ZR1bZpuWCROFo1iOmmL6ZaCNJN6v275XeiogHVsUSKaGmp8+ImZAVp7pAUDvT7ZRv5Ky67PKDy23FtrvaI/2yu0Zd/nRBGb6760lvp4MB9Vu6yMAbtLGLg7AtCV+2r9UA1v1kuiVc3I4UllV8dhcVhhmTHK9N5EDTc5+ytRDwxIRtyB9cXOlDBAfqAWBT46rfUwjgOz/QB6Ba6Dh173Lyw1Ww5c1jYeqfWmH55x+v3/1Bz8OqxwxuqXOayXjXh9O70wcIeiyIZwny4UKKCpskX2YdCdHr1GGxkoc4+fIcLeJ8x2ggncMxtyPGhDj7/4Y5gKRDXkJ8qiOZcfKnhSU54RkqFQgVYupJjE3wgpn28i+gmAcfhJNtiPOJaPNeF8kdUyuD5IQX1kZuzV6Rvk7TPYBdBoXboHOPjhp/o4DXuqQf+lpevgK9MAV/F1o3WecQIKn0nf9cOgPVGXyzXpxTam
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6b22ee-5178-448c-de49-08db0a73f1a8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:09.6824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vnKMXJVTCztkaUQmvdn8urlh+Y2dxkwiDi0phwar9HHj6mRXZES0k1W2N8h8xhZUW2oDgfzezBqJGG7CDhzgrScxZO6QXSThEF8m1DBxzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: jOsqXyLg4YfRS8myWDnA1tU3yl0E0qLR
X-Proofpoint-GUID: jOsqXyLg4YfRS8myWDnA1tU3yl0E0qLR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

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

