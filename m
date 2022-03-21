Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC12C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbiCUFWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiCUFWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465223B3FD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:20:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L3Wgxc031204;
        Mon, 21 Mar 2022 05:20:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iNV55zyITuNYkqP55QbvGKD/9pnnByfTysigs8xxDIs=;
 b=vEBeMbTpP5ZJ4dT4pguljcAGf5ckDKl2x/Driy743WrGaNhA5BoV1RHRdulM7MnZRIUY
 fHxert6iuJ6YbkC2zbmXlGOPNf6uly1yb7x28R5d7PjIxefZkcjDYnvGMbh2v73jdqNB
 y0QGjoZbpQrjDXgvI36tTuyEspufithBgCo+SbpLLOokScTCRTxYxR/lFNpSx4g3w8zG
 RuF9L8qMDrVCVGzfCOb+7r8BsOflq7tZp++IacFfd3N7wl+6kwmkncUxE/6iQZhuXqPt
 1MEQfoLwth3+oIgXv6HZ1kQS1BjGgPUtBuzMiZm4MxOAP0gD/F+7kgQi+tLDU370G4EM 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0j538-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5FvH9057853;
        Mon, 21 Mar 2022 05:20:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3exawgevrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGkfHvlZ9cAMQKER3Argx0X8pQg2gWnZXpjXSHBeNKegGoLr7e/CLmjv2YSShamWgDpxs3Fs/t8vo0D/FBvBT8u1zXPL1Z/mAEnzgoCKYrWCQ8HNQdIDz/MapL/7XLokc/FvcrWqHCddImvQ0nDjKnEw9vH/+6bllZrYAAnpQF8rNfDASBfIeM8Dw5uVdx6O/2mypVe6cER3ELVgENWpBg+ewZfahbqsccM6kycWnDY2Lka2K22exhNCLaR6PauYM9OGaNNw0VSe6fF4VQ69IOhMPqnot9EN9jFpZXj2C6/KIkN1UaEqR4xqLVP2KXwOESi3FUMGdrfwMsqaJtMMkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNV55zyITuNYkqP55QbvGKD/9pnnByfTysigs8xxDIs=;
 b=fEylpaXhdCuQuayTZJW2TbX6Ow9abkBnwXw5FKQhhTr+aKaDWH9552DwfS1wVyViKt+JbIgLVER2IAlmTXutehVsXkxaOd72BrJvcD9IDVlMaTs3p4AO5wtiEtDmu82+AtIb50C326Jm8gl49NxS64AvdANdZqLd2BH+zTJqoYmd6eUhZEDcl8aMooCHoaPyRcmQg1cLAcEBSYUGDZCCR3Wd+32oBO5ydb0A5pT1dV+u6Yhm8LaHqtFYntmLgVzlp0PqUw49xdTVZywvVaXXJRGNn0ixgiMt7pSNxPVLVZLVPZC6Caf+1KVl2SN2elIKyq8+XfLwnjaCaymoMETFTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNV55zyITuNYkqP55QbvGKD/9pnnByfTysigs8xxDIs=;
 b=xH7yJTtL0FcXNguziCt+5PWbg4ao/Hp0GuIXOZADHBL1WMW/Fe8Ox1VI4fSSQtPWMkyWWz/6IOxCBIwHHVwOGyTFVsLCEQ1e+HzY4tH7mYbcQEy9ymmuwISt5ONx3xTrcxdvwHZl8/+eULcKiZUbeO42X1Ive9tH/oRqnU2OsfQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:20:43 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:20:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 01/18] xfsprogs: Move extent count limits to xfs_format.h
Date:   Mon, 21 Mar 2022 10:50:10 +0530
Message-Id: <20220321052027.407099-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 670d8b3c-8860-49fb-8e3f-08da0afa8c14
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5563D567DB6C41904AA6387EF6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NSNE5aogSEyfA1Cjh/roO0gKBFulX/zy6ZK0BmWkXwks3KqIK1PWLSc8LDMUGuI25MV4Q9/L3BdtdYQrTQC17zL5me0szQErx+IN9n3MN+5GDHfy8b6hVdhMyV/2DuXfQkSB3zgj73Rd44vA5rRMkdWh1lH+kDBPmCW5ykFf4UN+vnls3GB/x9O3Zcj/5arKaSRYZNIXGr90D2nSIr5Yg4XPSugw7MSnOlCrpL1ybb6nFBhA/HgheqUamcHpP+NfjPYryHg5ZTA3ZX0c3K4hPa8BHwMr4hU31oXGyrv343MRxBxWoc7qBcjeLUu5strGQLyyfFYRgsELdmV01DVGUO8b5nLQxcUZCgJqMGH6Pcu9jmj2CZ6Ptx/CmXxiWn2pr8E3K6bFEYJb02lti2e05m8dSpCFWaSebSPvQeWSCPOk9e9w8+riGXGqPIr4iJARFsbXoGNA+C+z8iMDUY7rzYZm3LeqAhgm0C0LBEMG9fXQjKYWvFXay/a940T7CjNJmQmxDkEpmhabiBXI7iWZkYHKUEL1XwtOFpnf00tcw8U3mTrnG2GVPb4kDZ4obckymT/LDpbx0O3eBTxdVlr+daiBNL76kg1T/GswfNsXOaHMLXFiDPiMpQ0LwagO2NyqwbNMOhpVfUEvvXYU1pgeiVgAe/64bRJmRJwM+I94msepe1fJhyyo878IuP5ER2jxvQWoQ+2ss26AY5tI6tmNHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lDywHB7dRlgX2iZFkZDcc3TZjClKZlCcuoQuTZ0uS9kAV5unKIAWV1tz5xqH?=
 =?us-ascii?Q?jYUFrwI5btmO7CsoSjFH6v4IK19K854FZCtKHIoVNSATwtedefE5uSgAfPqu?=
 =?us-ascii?Q?00M21FpHNhv7gEPo7XMegTstIVATAIjta+keM8TY9m3zWebFXAdSizDVFpNB?=
 =?us-ascii?Q?MJjQyyUKnaOk0S3X5kmIg1FQp39DM72RdvEPwH3tFf6Syt2+I4dv93TOwF8Q?=
 =?us-ascii?Q?UPMIK3TBYvybyCEKTzMXUMID3z7td4KdTIUXdNxyWbr7OnI+MWQcAAQeIzZY?=
 =?us-ascii?Q?D+ltPFiaHF+CcSOiFkREf8lEZPe48ZndCx+YWWsawav+KlBkKkljzjymDU4E?=
 =?us-ascii?Q?2b+K3ixFU7E2nd2uAejsLZRP1/Y8F2qS1JUn4sf8xvt11kVKr1hnrXcKqAGK?=
 =?us-ascii?Q?YrbglT4tqzo5bK6a6Je/WtWinYdtaoDWbMft6KIXC8dfSG4MS/5UfSIEBhI6?=
 =?us-ascii?Q?04sn81v4Xfg5PjP33iL3gdouWRICIWCmEcpQhnNRPDwaRDnJv3Qexp2xmMbc?=
 =?us-ascii?Q?R8w0ewcQM4aiHGvl8oAo0ypOyQ2IbO1YsMP5M49/uWFl9ZGRCpSHcn2eqP1j?=
 =?us-ascii?Q?Vqye1OM7x7ztACMLQWzyoic81TZGHomL9ALFIZUHnJdqqocQL1Yvw0swQPsf?=
 =?us-ascii?Q?YiBVz7AazCIuT5zWw6SjWGw+Rduus9QZ4yVmw+Qs37ZAVcgtsZK9w/FhsA35?=
 =?us-ascii?Q?X4FUBO/JZNGieil2KS1tB86he5vw81qvX5h9CnfINtCeuGysYeePRrCFZbvb?=
 =?us-ascii?Q?FnrHJ0LIeAiOmoA0Lr1cBgU37GpqngUG5pNOQiCY+FbVSGnn2cKt/CTNOgOJ?=
 =?us-ascii?Q?zWMn8oA/lBjKj0hHXgtrW3xzB5E02WrBsSUk85YjiWrhYKZdmeHWW48bufJf?=
 =?us-ascii?Q?RyuR44RwAFEqMxOqv/CypJ3mFM8igeBv88rhp+xsP85iRUpNLO2Q2cgP8rKZ?=
 =?us-ascii?Q?rDabDV3acLB+R+HJ4aH0vgDT4+qVRTVYEhiZEak6Ryci3gtnf8C7PBMpZbza?=
 =?us-ascii?Q?HVmasNSdaLYVzzLxnIN+SJ3evF1Ak3WCSsQBMcfKYnUJcc3G2eADMU9hmRMv?=
 =?us-ascii?Q?Zux2cyl6afhjxK+RbRuC7pFOtuA6zFwjBqXDcPW6pGUgFyYK+fMNiVhxbSxY?=
 =?us-ascii?Q?KQZ8Y0LLJQdBBS5kIR6y0YbPmPmn55EP+zBbUcpGgxFjP5RSOBnD5Gc1bH6X?=
 =?us-ascii?Q?6qhgpjXrSH3PKZ+6/Y4n7Ze8ul5HCPLKNVXUmUiCbn8eL8iXtF3N6Me+6FWm?=
 =?us-ascii?Q?GmudARbFTHyTWsXrMobgS+R/lD47qFRPOc2HvC1ZpbtMOq7doDBVoPUlajVM?=
 =?us-ascii?Q?L+yC0Mp5WLyeMsgzWocPjTehgm6uoigy/D/ctq97iNWSpOWOKQPyY7qpnYfy?=
 =?us-ascii?Q?0hZuu0OqyYNSnQFqWbCi3AF4fGWwA0DRrLyn/nuMyHoVx9pUelgCkc+8PkE/?=
 =?us-ascii?Q?CL/HsR+NLwL2puDB3r/ohptmUbcxBzBB+XX1uUlU8uxR4V5l1a3C+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 670d8b3c-8860-49fb-8e3f-08da0afa8c14
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:20:43.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAlxzA3Aw04vVxPtJ+jSRL3JdqDrsxMtKKfsFxgKzHlaqhUo6oM/0V+JKCRD4fifPJxJQl2sTEY/GW1u68gIfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-GUID: -Y2fRvsiRADLYPyp1ta_0CnPWu7d580v
X-Proofpoint-ORIG-GUID: -Y2fRvsiRADLYPyp1ta_0CnPWu7d580v
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h | 7 +++++++
 libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d665c04e..d75e5b16 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -869,6 +869,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index b6da06b4..794a54cb 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

