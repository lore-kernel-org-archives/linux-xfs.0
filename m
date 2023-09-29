Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736C8CE7B1F
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 09:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjI2JyX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjI2JyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 05:54:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2FA199
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 02:54:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SK91Uw018353;
        Fri, 29 Sep 2023 09:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=nmZx3gXorfzX5hJXn3baKWEAmVdgS+GoPoqZSJu/0ig=;
 b=OSz0uX0kFnjU7OBtiegGErAaikrMPkN1kXV0QsOSuREjuAHG6sYw9QrT41QgFSCAe6nL
 hJkT0HCc6pXG8YGK97E5l5wmeELtGb91mBTfsOYBTR9CE2r8crB246A7yQHlTfPt1XMR
 Isg6YliocI3YeRxGZdi5G1YSAW43CAnR/BpIdWFQ7gNQWg7DQHO1oOfYYQWl0pzEiMSy
 azBXPcZQUY01LolVk531i9FbO/sYiL1bFbnpwp1TGYPIuXd3QWd8LJLh7uzI6QcyE0su
 MnJaJO+GjuQdX0zyykeCe3DvPdD+PVGYvQJnUtKAlVQ66FLc2j3r6+kW2Xs82lrc1joJ oQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pt3xct7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38T7bmIe025296;
        Fri, 29 Sep 2023 09:54:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfh231p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7xLHIX1RIqN57rrRYPYSDd+tpQ0uInwtaAQnkj2UuQwLqXcStxYg8fg+i2pnf/fnN1mIspNNP36FRWmOcYxVHjdhtKBibEC2YGyqsnjlMsxmWMvpEgigtZak/eh/qcgGSibBH12rKLGfewK/wRs/SGToszgcRT8up8meJGkqAYYc+pIr1mLBmtkw1dXguDNpdVbpmxjQNJzx4DvWR9+wpYlPHhvdGjKRDhrcpRojWDEav+TPDWW/Q98tXvehTMGKUzUcQHYnR51/JqJ3phJm26mMSfeyu270rRrIOfsXRmDRzPCa5YiIseQanlDxhzFTFXgF8cc6L7FuOEcaLLrdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmZx3gXorfzX5hJXn3baKWEAmVdgS+GoPoqZSJu/0ig=;
 b=bKW8Tp7h3CtqJrRxkTB9XpHYPry4NYwZbCGwleIUt5p4u1ZBgtwBc1s7C+E/cexa8ZrXtHW31YkRP9zVBMSUjosPip4bnwswl3wMLJAPpb0NmrsRMcFXYs9DJcWFUHtR9F4+3DPrM18eleUMTlSOhDXrc9rSV7j8lBV4R412AIYZ4B6OUerXbA1Fo/B1OPKAE4iJ0cVeKeVm9EOND+VhkCIz7nuZDxk/BZglsn49YjqeRSCGNyqmryX+F4eBIypv3Zw5hrL8NlPvF9rjdbiUQvVAY+8kYlViHj/47j6QayML6iI+oWSYyNcDx84kv2WhLu7dXawlnrCuyhAq7nOotw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmZx3gXorfzX5hJXn3baKWEAmVdgS+GoPoqZSJu/0ig=;
 b=yYAX/QDKBGeOKBapbJcyXRuqMuwoGcBXjPkMONpBjMg8J33QXnzclM5DB4RsrUGW/gdgKsalZHdEHAgZOzqSyHoeSlEfWHRVNnG0tZbvWVxEmJFx5KVaDiXvzKDFvtaxFj8eBqhcQYD5m2z3PjF804dkq+FVHWpi/0pwyhPkCZ4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5742.namprd10.prod.outlook.com (2603:10b6:a03:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Fri, 29 Sep
 2023 09:54:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.027; Fri, 29 Sep 2023
 09:54:13 +0000
From:   John Garry <john.g.garry@oracle.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandanbabu@kernel.org, cem@kernel.org
Cc:     martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 3/7] xfs_db: expose force_align feature and flags
Date:   Fri, 29 Sep 2023 09:53:38 +0000
Message-Id: <20230929095342.2976587-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230929095342.2976587-1-john.g.garry@oracle.com>
References: <20230929095342.2976587-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0210.namprd05.prod.outlook.com
 (2603:10b6:a03:330::35) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: a1891a27-eaca-4439-df44-08dbc0d20963
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E7V1kDL4nGI57248q+mDRR2gSeIT6e5zYPLsLcdBh2iDF0p0PCFdCK7egvmFqygeID4g0LUjW4tOjkjpQRT8BdeT54PUE1qe7lYLGQ6EB3mTGqE9pWOm43Qau+jKXUPgGF8SLZl7NpAHdXHSHtP7JNmXDieEpZjqMYTcJB9Kl+nt/V+O/goiWI9fBH+T9v/ub2KdEzONcvV66jb0L/g8GKlmrq5yHMsmqKWoWJyY7nygGx7fXnarAwaZIFQssKdB+mrGpa6tDzPHlBizzUFtm3UzMx94QIBb0T9ItpMSDs74FAA60xOWz6mCS3cVSdtGgFc+4d/nrKSOUs/Le4/FOAgJuWs0FBYd3DKST1cOWdq35hzN5dPuXRfp2A39JCsol6JrFe0+AMDAf4pw+Be4uuhosR4JEB/PNxFzTlYA5d+WsU345uVRhZ6alWiI3sehI6APQ/2IKCJODlJWWGB0SiEva3S60UcOn8ntMjUsomR5U8Ti7AvBonfMvJuKllXRSu8m/cc4oedaCQ7tSVndqC89A3nwqDTLHdOWqmEj8D7kBItdg1e6tFb6TlKX9DKd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2616005)(5660300002)(107886003)(4326008)(8936002)(8676002)(6512007)(41300700001)(26005)(6506007)(1076003)(83380400001)(38100700002)(6666004)(478600001)(316002)(66946007)(66556008)(66476007)(36756003)(86362001)(4744005)(103116003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AbsCxRai8bOqAqCs8lmwboibDz9ovglgXzeryKwz0VGjVAHENkud078yhDi4?=
 =?us-ascii?Q?fb4siIXwcgQo2IJShEO9guZJjgfxCgIhkDtTukVQW9C4rDb46KOkN0J6KzHT?=
 =?us-ascii?Q?Y9OmuVK2GdNPPPyo4s6jVHUNzYXcIKJomEzY6qToxxfwI939BUM39vaIZC7G?=
 =?us-ascii?Q?Io1Bqro5A0OHB8vHOCzxpBcc+lwP2SWYKSKZmFBUOgtVmLXzsMNg4javwzE8?=
 =?us-ascii?Q?MX5Vd93D2NT+06j8Jg1DhMIiT8EAfe9iwcX5PDUETnGQm4mGkocLeMS4qMX4?=
 =?us-ascii?Q?6yurv6SdtIQFerExebNePmlktO0iRf4UHpc7Z4QModSdJvvp+3eAOv63FLDA?=
 =?us-ascii?Q?Y39KHLTbys4C/tJW93yqKNr/5EyNJ0FBOBMUZccd8X7t326nZQDrJrJ/rnFt?=
 =?us-ascii?Q?hLXAtzywY7sc8ssxN+x24TUhvlVSC7rUY/3L1Mro2B3blP7lHkShNkAXZwG8?=
 =?us-ascii?Q?UeF1eYYieTpu6sihNMsHfjRiR9Rmk3j9JYhg3YAcP8yoDedqsTc4UxjavN/4?=
 =?us-ascii?Q?T5jUmWe7SLdEZZHforM7PrOhCXBCZrV41OVfT9dE+yJEYKxA0wFLJhPvwul+?=
 =?us-ascii?Q?h+3qDrha4BGAidpeh8Ns9c1RCSUky5q5Zk0sNG1CYIC42NmOyDf2hNH6XeOU?=
 =?us-ascii?Q?kNsfkspmTGYHRnCjeWBThmhg9+ZYOqwYw/FyokZV1dRaiGgSZMLGEuLDaYMS?=
 =?us-ascii?Q?kmz30aQQpamRk5L08g3aAGB2wMtN8pMSgIv8k2L58rMs1ksAMctoiWxsmiMu?=
 =?us-ascii?Q?wsuF9Tu+lO9Sx9F2LQQKp13ilbXfs4szAJlTGygXOCYZ7MRo2DWpxN6jc0rp?=
 =?us-ascii?Q?k9XFPKvRrEUQvQ4PyK3/dvEwlhJzc6ZBxlzkxnRGXtXf+6todc2E/2+HymJ0?=
 =?us-ascii?Q?impMX/80xZTDk208Pk2+VGi5uERIKwdZoyMve2jR7RMAeysnWP/wSVLeg8sm?=
 =?us-ascii?Q?vMk5Bgbg2yuxPlmoh4/aXtTBBMzaMLkm5ENMJQEj/I1DfoWU0mV0fmD9KGrO?=
 =?us-ascii?Q?kXg1/yRjf5xBt8S2TSoUXaMkAHX+/1n4GWPQAAYh2iIK3JcHXiCmU5tMt5DO?=
 =?us-ascii?Q?zZg383YER7bCCya+m6Nr2Ymi8DNMW5LtQFE4bUSTGXnjSuFK9f7feawegIrp?=
 =?us-ascii?Q?mVNoBdhKw8XZKqIrFkuPBwFQsDiBQhKty3aDqrJv9LtgEx+CwIYmltCNx/3L?=
 =?us-ascii?Q?3LIDXRkSOaaz9ofqXOgpYCHXBe3gU1pPwCW+vFTE3V2ykHsJqfyRUHuJnkX+?=
 =?us-ascii?Q?FT/XVBnecOdKT0esmclHyXOjEsehwEPWcwZ0zkhL70S8j+B8pxDRXS3R5p/U?=
 =?us-ascii?Q?tlN8QQjfTVk/hku9mpoJz2smd4zbVKO1OJ22l335zgo05dnhsRKEGRFAiZmj?=
 =?us-ascii?Q?xBZb8NYag6fWrv3bu6XMvpCeQBGYrMsemSM+Tr1mzAcSxeNJb6alfrsxfD/0?=
 =?us-ascii?Q?zmZP2yDVYEp1uI1UCRXH3j0eI1Qiksxm9DdqKIAkkQHGLHZfZtsc4Ea6CZTs?=
 =?us-ascii?Q?aFqoU+AqJbAsbsU4B29Io79zO1lyLLaNSQ1hKbpGfZEmLXjeWJ9YRJVefXsZ?=
 =?us-ascii?Q?B+t9KnlogvHuGFhHWeL8s5VhhkjRHW9enRkIAX3nU+IRxf/i8C4txdNLZjJw?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uWvVg9KiEhnro9p7eSE78T7kelgzdhwBGkZwwnwTrhwcubTlkhWxMFfbBtXAgRNNZonkAmzf9TBMfVrxSI+YyvJfXTjCOpOigTCQvNxkK8+0ls7sCOac6N0K1u6NrazIcmj2ZhkAK+MrPV2PNEDL3xfcf1Sb9swoQZJvzg0CH24/vBB1bp1VyV+GtMIwCWx7nOpu47SyFjmCvO2TRCIOFDLSrdCZMr9foZLOICC1eMYKOg7rdlZyo5rdObuzrpzjq4R3AuPbrZjyWlGIbnSvLFHUtwPejgYxjslVVpFa9dNbK0GTAEoFJu47yV2+SEfa+CrJxX/ugC3/7s58ozNnLb72pBZMminEwUyyw6TiIpTH8zZR8zCeq63vDqXaPknhL94yghKk6F4BsilW3/+RWI5VDoN6n3SSsb6x13WWir25zAv6OePaPEeimpT+R9vC/eswBKC/mKzMgkMInz97RB9HzpspDpR2fCgvCx6ORtkNHBPBDncZWwjO6vmPDr4aJPLZGbN480WwV/rzo9QKqAOlpLZH7mjiDIuk0dKrcpvjULlm0hysQZNNVPYj1+kf8eFBC+fMxkI3qPdKBTG8/MTcHL2uiY3ubVKH3v6cVtciGXQ3Dr4Osj/WPypd4Ps0uKpY+now+AAjKJ5XvD7tOjjiHYnJIfHB8eF4HleJRdd1UeFMTJ6QFmj/mjEziguE93bfF4UxFUgJrVtKXonWpAzZRlbh7xMgaMYjoGXAMMkZV7yryVx47UoWEBPi1uwcM2Z4a1abAkQv8n+t28IxPpcGARqVJtjVXd2ZSKjEO14MyWl6Ouh8BahrZc2XloHQjNb8cDcaTp9OvDu7Q3gyPw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1891a27-eaca-4439-df44-08dbc0d20963
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 09:54:13.7676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWmkFV5G5pJ39UmUq4RKAHINhkokwi0N3AHvWd50JysE6CaI7Zjqk8q7fxCPmmFfWqPyWbQWGsuHITLJYbET7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_07,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=984 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309290085
X-Proofpoint-ORIG-GUID: LnLP_Yglpm0Ndja50DrzI4yxkmkEI445
X-Proofpoint-GUID: LnLP_Yglpm0Ndja50DrzI4yxkmkEI445
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Expose the superblock feature and inode flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 db/inode.c | 3 +++
 db/sb.c    | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/db/inode.c b/db/inode.c
index c9b506b905d0..b674db3ca1c6 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -207,6 +207,9 @@ const field_t	inode_v3_flds[] = {
 	{ "nrext64", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "forcealign", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_FORCEALIGN_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/sb.c b/db/sb.c
index 2d508c26a3b7..8b7d7c215a48 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -706,6 +706,8 @@ version_string(
 		strcat(s, ",NEEDSREPAIR");
 	if (xfs_has_large_extent_counts(mp))
 		strcat(s, ",NREXT64");
+	if (xfs_has_forcealign(mp))
+		strcat(s, ",FORCEALIGN");
 	return s;
 }
 
-- 
2.34.1

