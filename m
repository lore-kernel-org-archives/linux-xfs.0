Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88112C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbiK2VNr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237107AbiK2VNK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D47E6A742
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:06 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATInVaq022634
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=HAGOTB4fmLEl0yo1xWsclEpDRas15fAFXP8a8idrHfBKNY5z5v01Yy8PvdumOCHh7D19
 xmjmePRWZEx1YIeWQREvTqpQa1XUoYO+z3Up6NTtznhBzb1DcaOS2YnK2IhIik3frIgS
 LR/n55//N4kKbpn6ZewBdsOVo7J9ZlE5DzgeSd3u9iaZ0Rl2RdNU/H8atWROmNf3WZDf
 Zuz7A/eO9M0g0AVipbIGun9krwaoX1eXA+Fzsp8St99BE9CtQlbYcdr8qKbOBCL0FfCE
 uD4WzRRcJad/io75kuRIv2NEGL5pNSMn5c7YfX/crZhyZPii0QkDHKJ1tuR52gFKsGuR gw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397fg5gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKlGuW028131
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987w8v4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNbM8FNNtoOFVh1TYxhGfMqXTV8N2hbKfcZc/UWt8IoRgjReghPQML6W9SIfgDAh4IYNrS/Wo6UKfLMRZdDE4Fi7RaybC0YoVdRIVp3mhUrODYLQOVmuSD2JcZcU0fWOVVKtK0k2R3xj8pNnTQiE3iyS5JTCqZ06VIZgPk79xSrs0ZnMQ0GvJp4lEa2Je+R+/4DfErS23VWYVCVTYhkKYgcjOhKbgoRXvGUAhjCvP+xRBmvjxfm4F8FX9i357XF/2lEPLKkQ+Fgp+2JxQSuBhZeoFNSWOEaitmhBJ4HKAKBZPdOnxsX9JcpXq0O9seUENs1uLveqyM/1I3JX81o9rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=KPa4aS8UIDdfMIjd1YtTmIv5L2ts2VNnBH7DViFoUJ7kUZfzWw5uBu+fzxjlUP8LRB128nxrLtcSMBUJAJTXm0vCEjc718t01YBVLXjDTjtFZNz6mS2B0LysOXd4i5EsFs/HWrECXYO6BQTXZ2rtD11Bc1DAC+Xot4BFjVMdVPoA7PLNR7smgjs5UvuQLmDBLgYX+TrjSitGM+TZTXsCTbvJl8FWU26U2FQb3vjw/K8jVD0PLZ+8IJJUKY0F6aKKXAKXvq1DbOMIypyL/aTeUkEs53KcAwVzIzL4phOkLoqVOQ9eg3xrR3nAaWxp32PK8/U0BEMoFh9l1jtvok0ONA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=BEQCrCkx4biK7dkwfhu93JAYwcP1fK8yJNP51gtsyf9D/al/Zkb59E+23pANYILdlL84mUO0Dtrl2qrjXvTU7YM1r75dh7Pgb4cQcsZx9fgNMXi0/3XU1P576LwiMIMJ/aFGRvaPPuFoSzfOimJFyYx/e3fJXET3jZqdvhyDW0k=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:04 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 12/27] xfs: define parent pointer xattr format
Date:   Tue, 29 Nov 2022 14:12:27 -0700
Message-Id: <20221129211242.2689855-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0003.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: df0348b9-036c-4191-318c-08dad24e80f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /lSN7f9p6p83hjcvColranmpGit7hExBR9d0rcMpvcVT9PeYtQ/GtIp3duJ/vD0kqsV1tlSRQgQIBi/wARyuYi76Qy5Mkiw4G0Zb8veQaniMsAmkfeVWS0W+VNc3z1/8Yd35fAmXDM6H/Gxq2heJdq7iL6AHH8OqxCODiQWNN8Yy+wTGp8WUhX0zdOYs0EzWYVPe+kxkP+AOT0n7s/qj6APTCm/RuHKNip2d3Wfy5hrnhrghtDu0gsBQgV3e0J0UBJTVQ3vS8g6xeqkD9kmxCW6cBQFz57ex8IHUfyx79UD4waIKvmhCweA86ST/dwXxUlEV4Bpk/vbhSEC9BwijigT/fNzEQ1hsW4eWVH650ClMdHYO52BmT19+a4YISIZHfhXhjigV0esqqamDmCGPr2Y6Cu/YxQLAkkPlS891XMq6NpWB1zPvl++0Egct0wsQ25hPDl4PELtC+WJ0KjnQ0Qv4h07ZQyWw1D4AG58Rz6RVP+50CnBxAJFfhpXtjcNuLB6VJgKp7+i9pYNiwl105Ds61wGwz4/byEW5gG3j/kbZo3NbR7J+c66N4xALjbbawOjZv4hd/99oN3S5WT+SE+dLp2eNSGQaA8eLp4RzdS4j1YUM+xyi+4tuCX1bbedx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yJlxSY1dE/iwz1xztH1uStRFkka3BByKId3dYZyKxRx4EDi9xHNaLYq0hrTC?=
 =?us-ascii?Q?ywKzdRzlD7MzOigbtE7CNi4fIeGcXRZyGjeuQCQRb/Hj0UYnqHjfJWXgmVdD?=
 =?us-ascii?Q?PSCUZ0Ooec6X9czZknmglyPhst+2xF6DSoafifRcbjbWrz0fgW1INcBL7ARF?=
 =?us-ascii?Q?f14bksN3y46hYIW054AkCj4Iwq7Mgib8tTerV+PJ/Zr7MLGTQJMX7MXF3tpX?=
 =?us-ascii?Q?bRDBO3SEdDvu/v/OZ1Cmt4RklSz5ukzV+NLZ2FuT6qzWXWdXxI6yMbPc+hOc?=
 =?us-ascii?Q?O9CO/Di6A5siA++twqCaUBAhtrXTfgoOSdRT32g5o9wYYoKiJSQCFn6bDHyX?=
 =?us-ascii?Q?3NGWtpEH4htSc5WJ3OotXLZRF4BuIiflI1/hM3bVFFQh636OnWhaoS4EQ1DV?=
 =?us-ascii?Q?qmDwcCcH0o9BVN0Ugz4fKeZeVVtv4ygM3e5pKV18fwoyHooHyJYJQgV+C2ZL?=
 =?us-ascii?Q?sydZQADD+ioJMi1kNoMefJqKeNb1n1LcsoZiKxtGPdBdVqplicHLb4UO5KBZ?=
 =?us-ascii?Q?vF5n3Ny4WUmz1xB6gRA3BmYxuS19cgHSW5ui0l3AkOO7v3N8pKHndM34krf6?=
 =?us-ascii?Q?xat8rxObQbGMxv0OrRvLm47+I+WWESfeteqoB3IioX5HTke1ltSDe4q/gZeC?=
 =?us-ascii?Q?BSaHn3JSpyi6ZHt+Wnorn0BgWY8PkpzhLWfTpJWaOTMajf21CjlsTGn93rdi?=
 =?us-ascii?Q?ZABqT80AvdXg2K5/YL2+SjCMPjy4uRaVrlgwq/m+z+5omMWoblKkRfVhNueJ?=
 =?us-ascii?Q?m4R1CSFg9+IGlCB53Zj3DnMd2RofDJJcxQ3j5ta1wgswCCEX22/RVYlyZGB/?=
 =?us-ascii?Q?sNw53tnt3YXfqoeFPaXFxmFcVFLDLx4fHkDjRq8xUR0oh881w+MoFrard+Ls?=
 =?us-ascii?Q?EX6oh+WPugSU28wqpWQq9cTmVtXoTtBL/LPizjSciARqgORD/TGOnsxnF6wz?=
 =?us-ascii?Q?vTAHToiMvHkVasZbbPgGj2UONbh81UMUMR0m2puNrFL9E2gHldWli7B508X6?=
 =?us-ascii?Q?F6y0c0u5u3X1QpLtcItUm1FNRGPyLQ4vHWLgmnmMx9cWJRMeDYb8dKQ5qz9r?=
 =?us-ascii?Q?LOQ13GSHzzwwNBKyJBIaqA1oGU9HFmRKHOXQ6z8LkfaveILQJ1pGBvWytwTY?=
 =?us-ascii?Q?M+OoT5Z8GHzzfWe/C18+D8fLSP8RPcKdskQ+ZIltutFrImjk88WTo44BQPB/?=
 =?us-ascii?Q?nnQAMO43I5gJAEBehNtwBMCxjRCHRyZPqhWzOIgFZ51lzUhv7n1Bo/+pssgK?=
 =?us-ascii?Q?G3HMWVHG0QTlYcuUb1fMdtLerMlyrGm6JRIn0/EswrQ1oVKwa2lJElDSifNV?=
 =?us-ascii?Q?drPCJPA0JNJMQOoVFGZdwvfBXjU/0JAWfBIonjijSus4VGUNlfUOjYNqFrVu?=
 =?us-ascii?Q?8CNzKcb8Sp/blu7gsiH8uGz0JqCBCEFebyfCJCMEiNq5w4lhQxrJapXk56b5?=
 =?us-ascii?Q?Z0zefJaDrExGlPz70xgoBAVX6bFGyfhYRbzLvSpy042VaAuvJKAcVi24cQR5?=
 =?us-ascii?Q?c/4duqSQoiy22aMYwqc5mksdkkDNK+GhvrJMupd2Q4jDSFZkeByawZNm6L75?=
 =?us-ascii?Q?d8S4zufbGDXg4IMlw6J5tqHqP4MVotXyyGsXhIufLJYwvZkU7jo5v8C62xZ7?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 84kKV1R0JOXOBnqDcUOvGxMr4QeWV3bLBbSPv9kv/eFEXDrnganvomEh2IPUbFxO5hbjuVy2q/XutIX0LH+dWwFWnnRgxOWRzj8pYPm7kfDkUfM7wxySf5IR8nqECrH4ON7dfNO+bn96DWBLwLgTAaq9pHj+wOphLUVABzjEDFnh11tfcA88UsTJlUkTVlTwUpPLC6petPv1iKXotZgbSHVbZPnai9QMyPqV+mv4jAyTWF+tgrBzAe4aZmRj4RuNjJ4YfnkJIHSjkINy0T0Yys9FRmNV1butdpl0Sv2UB1PbM6SfzGcOZm9zFjvHKLUZblPVVF8W/aWHW6dOGYNdXj7X5QYkDAoboS+SGVzDiumTu/HXcseBA3iSCbqn0RRw2XvKCS2Wad4HNhdEO3oLbQgpYC+kV2gwE3zX7Qxu5M5yd8NGCKIWCWcPNwNPbTPm9cPLjnb/wVo9bNj47NN3MSf2QzAXTWTxhrviZyS9SyZ7lpgAsdDguuAaCJk+qpZzQNjsun0qcQ9tMOSaKQt4Jd5foThFLs/ZNIF8FiTufgigC/Dc+6S9WKGU0xfHPDyjBdrwbTpbGyJy8w0Ae2Gejd7bL+slVqBkRQcZEs9i/E4WoCgaRU3eOKDfNNsZ+t6WKo1C/v5whPqDTlMJJ0yMoDbtrtTLS/1yxV/bBQPyUv4diLwBhrlVWme3t+Lk8SekViaE7Txa2ZEIsIOokTlxkH5PeWBuHpN50KHG/Se/5/jqW4glxm93HOCwnV+5ARHFmHfWA4v4x5Zm+dbaY1V/0w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df0348b9-036c-4191-318c-08dad24e80f6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:04.0496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1RM7v4yokhKimo/iX8uceLhgTYkY4Rbh7lND1YbCV7aeaqqAdHrn14PkczSF7CWNnd+LFfa0BQDSuiVTpsS/BB4AHL8S0k01AqrekiJRnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: iqpZgifN29KtzxTyOF_47auGW7-lhIP0
X-Proofpoint-GUID: iqpZgifN29KtzxTyOF_47auGW7-lhIP0
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

