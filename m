Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D990DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhLNIrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:23 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4722 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231929AbhLNIrV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:21 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7snM9004121;
        Tue, 14 Dec 2021 08:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rUlF/WG/Bh7h64KFhNDfEDLTIICVQEvrvKh3cHSc5V4=;
 b=RhJSGzxV8LPw+ltQfO0gFDItHRF3jYf5BmpDpOas5cA7xmL8xVGA2gkDhshVg6NsKKYl
 Iv6tId1sLDlJ3T3rsFp1sa70WK89jZuVoivdLuxGKxXiF/zdsLMS41fGN53MNaa83/La
 psDS3VHoAmMyLqSFDciaEvVSDzhfWFcI9sMAZTzVT0ECcH7IB3f3Jen8o1YzxOs1jISx
 s8ft7C8phH5nU/7BBUew3OdDAPjNee35bGgD38b3t5J1TQqZRl9/JDEmKNl9Avb3Ge3n
 6F1lIh1N0j2ZqFTvsweKVUHsx75sYJOGkdM+vgDZZoy64kU/upSYpgiWfw4pyQ5DGdbx Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3py337t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eRQh074108;
        Tue, 14 Dec 2021 08:47:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3020.oracle.com with ESMTP id 3cxmr9ygb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvJYoEIlqNEtdrX6Nui//7f3HUXG8HYOOzI7JL72a677T2W6Sebjz7/YbL3f9FdBz4VMeKM0sU0iLSMQRsaLg8XU2e25jn9Wd8MHqkOb6CnD2dF0HC8zS15DA/b43Y05lgeZPof0vpds5KBbfJzQXig+rOy9coMlF4Y3Dv7HHgqR9JVbZWK/hFR9eNhNBbp6UXRbc9ZcZ5hX+5LYlfMkFmTVzMKkqazdtJgcPnJHkhrbjFgQKNpAAztdTxFyIb6OVSx0HZUjoHWquJlq+zMyUX/fahhcK5Q8+r8XIGEDREITMKEQtZy6kPNmtAcHe5VDdvAAOgX2Z2g7/hKgSgDT7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUlF/WG/Bh7h64KFhNDfEDLTIICVQEvrvKh3cHSc5V4=;
 b=I7GcKhVfB1OTsQ39XmPR3R2TZ8cF37f+EQdqibAxw38JWIoEcR7i4LuMsbZhIlszLrJPwuoS+wbPUCkD9Hg4h6HyHsN8kQ4dB3ceV5JMLOilHjwtY1i4x+0LfCyQS0cKTCTjgknr10YE4xzfhfCfwvHukFQX8hKyQCWOcf45DDSzfgSIdPE/LziOX5GPzQdb2pLDsq+Y/Rkx1p3n0r1c7bWMrn56avEjYYTW8LTUj96o4RaDkmbKx2acM0VqAtJjD11oDbIAuEG7UsHZs7f992sVS6DePllFuw8L2jGv+XH2kfRuYP9I/Y1LyTEQDPEbq3E5Iv9TcZvZHdOGbASHvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUlF/WG/Bh7h64KFhNDfEDLTIICVQEvrvKh3cHSc5V4=;
 b=l1wuE5gE7EpmiLOZ3vkYcMOsQfuYZvlnKJDHLfPLHqYTwsZtPU4JVsI0eIvSWuFUMMHQqO434ETuxKMmsWEfMoRaLEFpBG4PYoxuixsLhRjmanofwfKM5ZxNCSBeL4j7Htph4NU7c3qVaf6FaJiY7RCWsyEusLsCSkLAylMyAdk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:16 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 09/16] xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Tue, 14 Dec 2021 14:15:12 +0530
Message-Id: <20211214084519.759272-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2358f960-ec4e-440e-67ed-08d9bede5493
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054A7A5004853211057A69DF6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:411;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mg17qrQ5UjZ2Q+BMOW/U/touawNsaqH6HCVJtGKRIm2dw3W2I5Jo21liGQngyMPMJeAOc0V1jKy4HqnYzO8SUSTdR+X7XRn/haSmN6TE1Od8mxubOx9HLIxTplbgc00PWUrWX5WcM1RijWGUqNINHlnGb5k5v9A9q+fPupFYFV9l6DiYX7mmAaglaja3AefJt8tFaqLL4443afzZ33CRuXiziRzqjW5C+zla+MblmCCaZAN5ZNL5iTOckjXVgHckfNbvt2aaP51Bo6p1vk4FdhEFPG8+Wc0cHrRMGNNfI8R3MFJw1gQUK7MA+yALxpJCbi/40ClhcRE3s1jmpjpGQAYzuwGKA6nuOTUQINmbQwhwjMZMFrhAtM+zhHYLyWFf5dmb3tpciIF2VPn7mjnDG2wcEnxrL01QB/jDQl3AJZpSCPBotfmV4MqxUxGS6MyENetlzCWoSbGkwtgdGuQTcalh0d41huwlyG+jAWx6c69pAcHPXGhczRXHWTH2T311AOnB6tSj+IE8HnymCEstemyrzMkohrZC5ClhPip2IEv8hyQFPnTQ41Kul2Iv7/fkut/eD7ZcuryaUfLQpFAbT6XhYjOZPurLuYwRJBYILfvzBVYMfdrMZM3jTOpell9FYYUJeuRhx4YRo4WAN8G7FckLwxlZ6f+SJepEWEy/9K3YCRmCuJC5SFLTmhJEzOrRX5JxtU2T6YvFP2PUhn4Lkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yDVEorVGURwIn8RUywpjLkE6vW/Sigv6ccLVBwDIS8kHCt4SD4y+8QYJdQTU?=
 =?us-ascii?Q?1aoIysZ9i2AdSMRtGd+K5oNMaQexjrrrvfo/vBc2eNXCGULC5Mi6thFobnxR?=
 =?us-ascii?Q?KH5IRw+485KuKby4ohEGjRPXDGVRHPASLiMVAcC7ydCd9Xz3Wk7sgg72tAa3?=
 =?us-ascii?Q?JXnL+18t5bTVFvh1S+9qaLq6ds8Pbm15ZFC14y0ShIiPLGYxFRaE5eLl9PTb?=
 =?us-ascii?Q?SbnqhFpquQwgMaN0lbH0pOEa+C2Z+i7JlVEXJGrf5srHMcweAAT940QCQRnK?=
 =?us-ascii?Q?YqxYj5fdKXkgUgKUUb8bgDxR3Dcyv320UW2kKAwQYd48D/z617WS6OqFbyxs?=
 =?us-ascii?Q?Ad0lFi++ARXM9cfAMOHIAXxzriODscAGGOif6Wi1ft2S/O00F4rAoFk50Wzm?=
 =?us-ascii?Q?0Udncg13ope40++crWAH6aP14lsEMZG15NQE1hOumpnzMYm38REVfy2Sty+Y?=
 =?us-ascii?Q?b0qplmW3F2W4bWaJzI7wnGbF4uebDK7oIuRBwlOAz2dbVYeEi3HyYBOW+Eo0?=
 =?us-ascii?Q?zBKKgAN8lSRgxzeKkPUOfwYkRJtAByt9Sdcx7QQY4ZH9M/jFPmZpDKCNHl7z?=
 =?us-ascii?Q?du1LSXSG1H9dFkjaAmASqC/q9iBwhDcNlkMvZlcXzglZscfbeYs70ruV1Qfp?=
 =?us-ascii?Q?KIqRr0KRvn9BuyPj+Z34ECHKFgDCBCqq9ZLb/Qv1rh5lDiBH5MldgbbFCe/J?=
 =?us-ascii?Q?j7t4OPoY11IKeQnVOLh/brV3M0gvy2dseNpfhwSpczaRBv38PfnXgXkLepKt?=
 =?us-ascii?Q?FLMp4X+4o5zfi9VjDSmsiItP/mWFzb8lZU46JqOHoJQ/5eogC1t0Gm6PuO0F?=
 =?us-ascii?Q?DZIdFrdgcBRhOArNpEJ8KLes766ndo2cpGSyL6KCxzmUKFOK8NddQb3rbpTF?=
 =?us-ascii?Q?T/yU0EMsuFDgUFZUnwn8JlsY78zDWrd6CzNgxCfFSGhJ51PcgkTSAkICN9tm?=
 =?us-ascii?Q?C0c3okjZ7eWOS8zC5422J47uhl23W0HivlyVh6SnLoNpQZ7uv/ChC7t1ZmF3?=
 =?us-ascii?Q?hr60jINROxmN81rA+B8p36B0E5mgDANF7FlBvrbSxMiBHme4QkFfdBiRgWrt?=
 =?us-ascii?Q?jL+wkRo3loSGfTyHRja9hTA02GZHCb+SsJyhaaMa/Up6iG8GxitbVw+Cb8lA?=
 =?us-ascii?Q?jFu9qswPKeqKuU9yL16PU8DwoyNDeXTtzJNVKRSMYgycv2lj1o12q2z+m2Zl?=
 =?us-ascii?Q?rSRUBgOR76s2KJDOTLQU7zi/jLW+13AjYGv9b9rwGOmso7d/ZA3WnpQOAFsP?=
 =?us-ascii?Q?pagN61lZpbXnNdYz03xIQwwLgRhANLhJny74vOvHBsCaYSDpa8O0ZrADTldY?=
 =?us-ascii?Q?UOi3LWjt0CxCsIOJ+ZLfO4LUZ8Miaq3IlrggRvgxjcblDxlD5YJnjIP4g6Va?=
 =?us-ascii?Q?JG0UqWhGaR+PK3Y/xq+hfvRcxT7+wet8LpbIMVA0Ckm9jmhZXbs7mRceND+T?=
 =?us-ascii?Q?M6HggJXe7IKJmXCsT0c0gI6oSZRUFOjlofvx3ZRt4I8YQe0gzwA+H/ZvUu0I?=
 =?us-ascii?Q?mE0WG3vhTFhTIFUCyd+/UKv8SS34wlRN4T5WI8YIQt6BTyH86lvyHqB3xqc0?=
 =?us-ascii?Q?35M2CXWBiadRCOASSt3K7K8vysNGhM90zQHa56ddurvHisRdry+1z0UVf7QQ?=
 =?us-ascii?Q?4cW4JzytBBAkbh4NgUbR+yc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2358f960-ec4e-440e-67ed-08d9bede5493
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:16.4203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alNZrQ5TGTSpQ6Yym8392q3T9tbCwi1ydMljKZbz2PD2h4QA6KtW/YZGzpRx/HuMrrtw599uwD/CKtgYxuMlMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: yC_jEV5HHBG1b9-w2PsQjCcGFg4u2o73
X-Proofpoint-GUID: yC_jEV5HHBG1b9-w2PsQjCcGFg4u2o73
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h      | 10 +++++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |  2 ++
 fs/xfs/xfs_inode.h              |  5 +++++
 fs/xfs/xfs_inode_item_recover.c |  6 ++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7972cbc22608..9934c320bf01 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -992,15 +992,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_NREXT64_BIT 4	/* 64-bit extent counter enabled */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1008,6 +1010,12 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b418fe0c0679..1d2ba51483ec 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2772,6 +2772,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_nrext64(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c447bf04205a..97946156359d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -218,6 +218,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 239dd2e3384e..767a551816a0 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -142,6 +142,12 @@ xfs_log_dinode_to_disk_ts(
 	return ts;
 }
 
+static inline bool xfs_log_dinode_has_nrext64(const struct xfs_log_dinode *ld)
+{
+	return ld->di_version >= 3 &&
+	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
-- 
2.30.2

