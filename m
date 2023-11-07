Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02A7C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbjKGHJL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbjKGHJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D4611A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:08 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NmP9031897
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=bQupO75Zvy0ifEPUPUOBCixJ8Lj5K4EIaTt5b0MTbAs=;
 b=cwG/vqe5SsLERMCyC3Kt+Fd4NymYx26DEqRbhbJyJCCEGjsXd/8WBScMIVBift/XR0Bi
 NQR2bJoIDp1o0Khr3XZdb+8HCNStduQiMge2gGwfnJUMyZ/yT4fD5x5nDhp22UCL9R53
 mrYdxXowDzroc4qZe345lXKR+tRifTDq7bWmCNUop/pV+DZK84zV/IQenIFJvXwYFnSG
 ov8fU7+anXqHM1GVFjs9aQaXeH3c4CtGvAF4BRpoWrqTktDxzTmDdUEucnzySypCgLxb
 z1h3wPyeDvi+MT8njs60QSSvKMcqwc0h/ebmdWtiLoPUPFrGt+wKr8J7EsYAXIyTxDas Jg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u679tm2mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76PYwF030550
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63fev-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ml73lyqGn0Gj+LMytw/1WwlVDVE9B79f9Cua8r/T/Y6POxHL2Db/6piNowuXRLv6bikPyASiemh8vy7S7th3IHNbrHmB1/x1pGYPGDRym548L/On1Nxow7441ErITg9E3yeqsEnMpaI/0LokP5r9DDfmRjwxNhVqzJqSW5IOUWeotUwsbLWrT0BU46YeHn70MeDPs/lC4Jp02LE4S/SIjUqzMPFgQ9E5/28GiipzyUXogIOuxGBhw/+j/Xiy4RDhRsaJXfRvEDpV0TjQgbQVNLuJsfb02jTdTNMjP8vAXgPZhjDe93CA3p2h+C6Ib8h2CZqA1fczR4EFStocRke+nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQupO75Zvy0ifEPUPUOBCixJ8Lj5K4EIaTt5b0MTbAs=;
 b=OP0uZ3TTuVLAqrMrCSiyi1hqLiGFKFw/x8nWIzgpfKJsbARUbZxr6JSPoOBii4nyfaGJ6jDzRmwJh3rKUcZQv8kcc1Yeu3bt7mOUbs/lTYZFNwB1udyxc2IXPmNrkvPT2wYpdiS0n9NBkqscHUUtsgHkgiXPmDZtF0ENsVUuXzgnmzKWZG6rf5F3Y7pl0rPx6SmShFnKnNhHPEO51EMQdED98EiqutYHOE5llGBnuE9pURHlarWoKvGkgTPE7bB8fP9sJ/oVMXZq7twBlaRdYtry1oCUyL2iwQTBhTsHgjgraxAiyVuIJ67WcZSJbV3U+SYFK+p/2BGpSDJ1MVqzhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQupO75Zvy0ifEPUPUOBCixJ8Lj5K4EIaTt5b0MTbAs=;
 b=W/EXQntiZA1/fMtcruEincej4bgfOTs/0HA35EFunJpk4hfvQK4qn1yNsKlPjU8+d/IR8LTFED5X5xS9VZsa9NWD6L12vDYP7qIS4EWBvxkipBC7Z+mafufFuezcfXFb4jOjcDrUogpVXk7So8SGG2dD67iMS7EIMrDO//BD5Ns=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:48 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 15/21] mdrestore: Detect metadump v1 magic before reading the header
Date:   Tue,  7 Nov 2023 12:37:16 +0530
Message-Id: <20231107070722.748636-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0025.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: ddf88b00-4aed-4a01-20b8-08dbdf606381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SMJyqh02NBvYJRzWSyNoO6eemeleIX0L1F+GtAoQz+zoCN/FB1OMWGcMz3VeDrPHgH/NATByPjAyJP0Dqyo7iW2uBa+Ki9HRCA+2CZyVCKuCUOaWn2P+wcmACbfpBxtrGl6NSBDjHaHrw3VsrlkQzrnJHfrhi96lpecZ9S06VP5T4B1LxTmPKHfHREhTTB0w3fEZJXn1pAMWmOxXzKkUIe2VtiHK4JsDluafSBImSF313o9GZ5Od67Y1FPKc3nwNyfFXjKsr2MZsP3y7aewpeBUZdJKCE7lE1Lc+pW+ncZMrN6VCnJrv4og4ol3V4DSjYIZGU89Aux5hj4xClp46jb2cnW7IpHe5oNFqdGn5QVx38yZr2DeKtIUfV5ZOabOAp31gJS0uJtXpWohvCHxjxtTFtvKAfUNuASemRkUFLtNcBDntECOuboJMFEPWfNvP+QK4pH6xpkt6MBQatwpey8A17tjJCqJuFkbUNQHwngQEKctQu89JXn7okkHIFAgQXsB7tbFOqKjc/zegi/TWJOCLKma7zq47DijsO3RY9P0UQWVt9uCODSv52laoN9q0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6486002)(478600001)(6666004)(66946007)(66556008)(66476007)(6916009)(316002)(26005)(1076003)(2616005)(6506007)(6512007)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DnMAaf26qf+kwL//LWPnKbsgK+q4dBBrvF4PXw+gOOjS9F7YuiRdKVDLxD0D?=
 =?us-ascii?Q?qekVi4S6A7gwhAnzZZuTEnDm+UAlraOUIyehqAozP2Jd5NMvpf1c0QuYszl3?=
 =?us-ascii?Q?5vjUQDDoT5adQWNo0963hQIiqm7DdvVtvr7b1+ojIr3W8Zxli7IwoDOp/L3D?=
 =?us-ascii?Q?NJ3cwcLgocPzahliaPjT2H6eIrXGrsqhiboNj6Gvbsp1XDy5DkkDTjVO0Smh?=
 =?us-ascii?Q?FQ+ST0QQuLC3MTgqzzMS5XuVLVHF3Dju053XUgAxA+UU7afBQlJFUk5eV21F?=
 =?us-ascii?Q?phxjAruXpDZ3SgbcPjxyl+Fx4HbZBSZqw1D71k76XSCIwXi8mTjsnzF4koSV?=
 =?us-ascii?Q?LC1f4LIWjfTPaMB6Fxyz/KqMRXqJ0edYPM482auJ9kgF5a59eUuG+fjjZFq3?=
 =?us-ascii?Q?rpaKJEebE2WuDZG1uQcmXIQ1Q8gWOx3BrGixu49VVO+38N87DH2WB9kgBkCQ?=
 =?us-ascii?Q?weSNOYR81ktDr7DXmx/w7rrcL32fcPj4lVoHay2Tl/VLjLgATdlA65GaToYK?=
 =?us-ascii?Q?M0V0/ugqKLdfwWzHMkKTs08TlMS3d4B5lZPxGNJWiJ7xv9aDxK9388WDS1sA?=
 =?us-ascii?Q?1y3Q9cGEREeDbm+zcAaY4PdW2moXKGSTRXG8OBbG+VFFxLRV/c06XrbyTqEC?=
 =?us-ascii?Q?/bWmYuNpW1LjRsg3oxeBWMdi2ZUq+oVT2YYiGcLIbGl9JXxTeZnUu2h2pKxj?=
 =?us-ascii?Q?BbcOtS5XqSIfeqq+IQfuFAwovZGNRWGfddXl8u2Rb7RYkd2kDKTLCBGD/Xdi?=
 =?us-ascii?Q?SyX0ee4vNNXpYAQTKnO+IrNG6xI5wAavTK7T7I6WFRQaFKu00y9FkDIsXjeW?=
 =?us-ascii?Q?A7TdOoXFRMBZOKA7O9++9kBf3Z1vlDRU1XCcqlahIdun1R26VKtZ+RlB7xOT?=
 =?us-ascii?Q?/YHkv1Fnqoz+Z0Viv12Mun7D7GcZU/BC+gIn/KxLQDi1j5Jnj/fiiT8xDd3t?=
 =?us-ascii?Q?WHWmY0ekzw+8vVkqRq1HeOJz+0KwVVdvXDfAF/d2shQKq+20cBU6SnDfm2XA?=
 =?us-ascii?Q?ItLL8MYbtctR4QO/QaX4lzwrwFiXy31CO/P0WpAmFctgRr2nVcdWSYW1mKjc?=
 =?us-ascii?Q?y69aJLP5gvKHAiJyifg2Uo7OA7vjZ/uEURhDe23vstOpbDnXmWAK9kWFAMHH?=
 =?us-ascii?Q?TPKx5l+oiiOfjT8plb/vsFUdMoI0U6XK+71G1lkdQKV67b2k/+8f2Gu5nQsY?=
 =?us-ascii?Q?eqzi0OuziffYnQo4aRRngzDBFsKyM0SrpCWyb62CSm67DCPe4i1OYN1+FR4h?=
 =?us-ascii?Q?0rCPzx1SXHEfRX/ef2rirFjc/viy/ENncsdQ8Kvd6wRwxSEVUkalH1XgZa5y?=
 =?us-ascii?Q?UOLIo+Xag04DM1RBDZGRcUvp/ej564Phdq7Kw7UEZEEGnWYr+OJP5bwgxtpN?=
 =?us-ascii?Q?qmtm6L71XrKSOK7U0lRZIAce65giJgR2UcNF/JPsTzRcsuEgYHawIlG1Ympl?=
 =?us-ascii?Q?OGubwfLdOyFBTwBubQLNZrFaA3wSMDsKq/oLl5bqggFsNYnEyKIn3spF/Sji?=
 =?us-ascii?Q?8mcvVr38SdCMdFbquSeOvYXXJAcUybq+p0rWnmAYQ/PmHEfuwfUKq5gkm7Ho?=
 =?us-ascii?Q?o4OgQqHvYnDqZ/D56u8k5+Li/ADOhBtFcPQQ1mefoVDHSGBGr6AdFZu3f4n0?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Uo4O+xyau+OWdTDcqjgFUkl99gwOhwzf1xo6eLT3PBNl4UdMSoutTiuGRkyErLRifm++rcX1vtUgXFM6yqQaY6bMa/Z9E/b/5AnPm2DRfRXJn+b3kxvj6NOaLB7rZKEkvzQwchFcUATq+fL+Nzf8S+HP92e2oshTzFUV0y4Gakl0Q9od73QM/cT0k2VH9NZLu68UQ3WD7npOQHbhacIb1cSZrNAWKQwGhuhw+/ouaDxucDydxZmZHY96K/Qyu96S80bVQhfMRaZZ+c8qf3wFJ43Y8o/FVhIEZAmNUJSaKDlbAis7PzCd9phVCZGX16GzmoAwCbzcwJeuy1EJSxBLqMyUDQxoaCz0PlNuAHLZykQnt3Ojemo7ANKZQOJja2V8dPwE5Gi1N1ydOYSIiaqvf+etkbFNwQBzmNid/cNAGPz6me3OdJpJ+9Q8FVQV9owGpFo8TSPL3VRgBzcCugv0AXcZZaQWFAN0X3JQ/sYpcPIaFDGnxq+nWMQkEyZGfyEOaUNvdKGK1D5wjWd7FYWWCQHUIj8xH19XgMnr1X4LxufHAkcLRJHFxXLpYHxIqSWU5y+RnAhYxts/rSbKCy1lM2nOJiL0+p2VurBMaamsN6o2x51nMXLJ1bRyMuO5L5jH+QbYM0qylxmeeW/FS/5dnW0Qk/kXNbhbOWgg867FLi6g0hm5nr63zX+V01N5n9IHjaEFzcibrHkFfiM/nQGK5QgsUvuZl/dwVmRm5arMX9IrjftMUoCFv0qzvjuep7BHiCHUHMq6dEhL/rgI9N0Ssw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf88b00-4aed-4a01-20b8-08dbdf606381
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:48.4908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zB98I0dYIvV1ivNjLwuYMbc5CWk093EdqObExBC7YRrsCiDvCv7BhD7v4nta0Y6Rcy9b5YbfjKOJ2gwTo6sZow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-ORIG-GUID: qinfoibxUCLSbEdM9HwmJKxI65x9QUHt
X-Proofpoint-GUID: qinfoibxUCLSbEdM9HwmJKxI65x9QUHt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to support both v1 and v2 versions of metadump, mdrestore will have
to detect the format in which the metadump file has been stored on the disk
and then read the ondisk structures accordingly. In a step in that direction,
this commit splits the work of reading the metadump header from disk into two
parts,
1. Read the first 4 bytes containing the metadump magic code.
2. Read the remaining part of the header.

A future commit will take appropriate action based on the value of the magic
code.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 97cb4e35..ffa8274f 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -198,6 +198,7 @@ main(
 	int		open_flags;
 	struct stat	statbuf;
 	int		is_target_file;
+	uint32_t	magic;
 	struct xfs_metablock	mb;
 
 	mdrestore.show_progress = false;
@@ -245,10 +246,21 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
-		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
+	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
+		fatal("Unable to read metadump magic from metadump file\n");
+
+	switch (be32_to_cpu(magic)) {
+	case XFS_MD_MAGIC_V1:
+		mb.mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
+		if (fread((uint8_t *)&mb + sizeof(mb.mb_magic),
+				sizeof(mb) - sizeof(mb.mb_magic), 1,
+				src_f) != 1)
+			fatal("error reading from metadump file\n");
+		break;
+	default:
 		fatal("specified file is not a metadata dump\n");
+		break;
+	}
 
 	if (mdrestore.show_info) {
 		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
-- 
2.39.1

