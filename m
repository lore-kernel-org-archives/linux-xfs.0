Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C1FEB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjGXEiq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjGXEio (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:38:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894821AD
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:38:43 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMRLFN003455;
        Mon, 24 Jul 2023 04:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=qNul3HMxDlJGg3OshNDufhqpzwhhTvYBklGacV/IRvE=;
 b=IRdAS17fpvgoB8G/Kjp4GETOWrw5bGAq8lB9ckHwXR5LjcBhxra3xZDjiNb5f1nJZJam
 xY8O6tE7VAAud+IbYGmAdHpNZryGzSsFxdEnZoHycf3CvEuMH68cNKC5BgUvRMU5RHht
 D1zgbJl18GMde98oNOxqQs0rUCx/BnJta4X5vGNHY1+S4arIAHma1stk4E0/S/Vvk4V7
 QoS3GyMv5AKzjaBbrAWC0J5K2obyOT318AjKgPTYPbrH13ihBq1mpg2U79z6TCVtXVms
 1t1jF2imAsc6G6yGxwO7/dU/4c6RqjUKc8GKZUWrULn4SvpV0bJ2Y6gkSHq2vGACHdm0 lw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061c1vfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O1U6vU029023;
        Mon, 24 Jul 2023 04:38:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j96k37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVmJu7cRlldWgC0v6YXXxMZdZEWpOL2ZApBgr83xIiTwBtg33RdMKxcofu8ZTu3uj7lP+xm0GZ1EHsUy5JwmcHxNr69jREAG3Pyp0io0gXQk9KEkX5+GGDsZV5rZI0BdcdBSjFq2GYQU6nh/hhhtmabmQ98QvIuxuhMjtl3i8rY+oSnAISG7ONdySbfHpvrRrJodOsvv/Ss2j8oo15m7RTgWI8w1Zms24+NZHM1HY0e1VpvWqJDbx/ER0TIDLy4OxBnj8/Hot5e60Wkd2vP5Mn7XpyqxCHGqVdaXJ+GZe6mrs3IygLc80F4qzSuk0wqg4oG7i74ohrMkbe5FCssxLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNul3HMxDlJGg3OshNDufhqpzwhhTvYBklGacV/IRvE=;
 b=OZ7KmPxnfVnlqJzhDEC3nIxwXBPcV2UbdD9TstlAXQMylysCP9RjzLJU2P6TsMpAbPeArXk80dqwItefXr6rL0xvB9XxQjgdrxqcSrLMeHcpNyRbYT2zo4wBZhrFPCg/l8wQ5wLsX8Y6pgwZAKnKiJC/tTgF6jon+PFmDKfoZSG/rz7XWMpn/pygBAzQ3ouaMBrmGx9FKNI3VKfP0HnyjeJRdwez/OzcnnXF+xFmTzN0tcpJCRlPYxys2fhGNi+1xnz8/5S1p4RxE4Qyqf1zaPcpcKLo6Qg8TsATlU+TfX0roK6rSquc74i9OquDkJndufS+4f2VleIPZhWMTNRwfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNul3HMxDlJGg3OshNDufhqpzwhhTvYBklGacV/IRvE=;
 b=xY60z5eoYyt0RMqxq3QjbmF8fxXcy9+H/uz5YCVx0wm36eTyFLYxcCM+zaEcr2ZkD0mpa/wj7OuXlc1/Vq+AR3lxkQqccgW+nSImhdbV7U2OkmcUJfDdUZFHfYA8PoyqjLZytylEUCJK4XpGfK2SsHbhDREL/QSNVNJoGz5PVzE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:38:37 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:38:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 19/23] mdrestore: Replace metadump header pointer argument with a union pointer
Date:   Mon, 24 Jul 2023 10:05:23 +0530
Message-Id: <20230724043527.238600-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0199.apcprd04.prod.outlook.com
 (2603:1096:4:187::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0dcb2c-75cb-4954-137d-08db8bffd8e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ozJgIfZ4SUWj3UHhqDk4d+hLTOAIguL2yZtECM7pCA7v5Z4mn2oD8jIgvJzkBwnRYwdRhk4h0BCaaQy+bXs2SqzNGXAbGQyYQZ1lfkXTMGQSfYQtwg3P59J3gajF014UrkHOF70NsF3h5tUKW33V/Emc7xUdkYNVY4DACe1qFJglIxyno0un2i7dTZhKTCGR0SuCdkpRADZ+cb/5DKBp0bRui6b+BpdtLwIkTzEDCX1pNpc0bHP+wuc9IVGQWPR3mxAu0o6E6egkJ9n4DM5JLmH0dQouSb4+lsd/Zi2L7H/lCrP07qG4J6j0JNd3Xz57WzmXBd5uYHXNgkXX73dcTn6N39+JDa+1wcYOoal0yjm9Kk18K3kg48TJ9p0D8ldIj/24MfXX2r4ZrUhAJpey1qIHNyjLtiPGFAzQP2Nj+P03ufEJBAmH5ftlXMYsePsev9DhRQSF8tkmaHSI8rAL5IM4hNXIbFi+Em5OFlEEyZe4M9/CvVDalIBKGSuZBV0Xm5qXcmnDhdM6Amj6ADsSzl1ZId1qQbzCDw37qsg/MiayiP+57uA7w6vuv2dUS+2P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8AclsT2pBhQVqI5+ObopTxaAEsZ+fJFmRKqnRoFNIIfNlZWWsyVx1eL75Nkv?=
 =?us-ascii?Q?1XIqLx8mGfYnbZGZBpIXKUiS79L+m9jya31L6jhDi1WUWCyJk43JurQU7CmT?=
 =?us-ascii?Q?uvRrJ3EBJxe5fQ2MEPfZ7fnkSZDqIekW0Mt6/75IBlCq4mHQ++fHbzd21ZEC?=
 =?us-ascii?Q?8bjMsCNL2Oo2v6Qa6DihNRL5LqHIJj+mklHxqB47GzTxH0PRLDrJHertC84+?=
 =?us-ascii?Q?Npykh+yKmlm1PbgDovxqI6P3+rjJXRczIIZB5FfmvmHnUDMwXNZ1dzMn7r+o?=
 =?us-ascii?Q?5sJUHoRnSGAIp3+suSuVXhSQgx+NwVHvcnX/GsGQ4ey/YnOANDxvIWtsl7pH?=
 =?us-ascii?Q?OV+1x+70IHc9F5G+IgyO41f4ItzjtCSw2tLqXgUcAoNb9rLIs2SETZCkyN0y?=
 =?us-ascii?Q?vUwamr3DnRlZtmBD7q3b1DSybdhj7RUSShK14Wp6psQUsMwBoLWCrYnx6kqo?=
 =?us-ascii?Q?qRI2R4Nv9v+cxzs0YDB5I0eomQ9oaI7CQKnik1tKS5tyqUgqMZRMxfEwOijL?=
 =?us-ascii?Q?ObFLCs3hrHFIZyjRq2phQTaRZqVXYQKxxP3tseYcg8K1amK1UjcLmSA/Zauo?=
 =?us-ascii?Q?SRdIsI2X6RlQXT3kQIqks47hwDVnqa1HG3ckD5ph/PJUXYPug267Hg5haT4J?=
 =?us-ascii?Q?KZArpwe5H5EiCXWMEo28nVrfO8pRClTfg2+lBAZ8lOiasf7m3naCzm+Q1rNx?=
 =?us-ascii?Q?3Ew7ePxM+koOkCzR/9CfGzZo1FjtyaE48WqKHvqZuRtrd4/xfZmEjbi1mNQv?=
 =?us-ascii?Q?zyrz8zIcAjWx246yrBVBdoY9Fx2la0ICCEr/mSbrezBFB1SemJLHFC5k+Wpa?=
 =?us-ascii?Q?LubJUF/9be/mw5G4GT/WXEGxg+eMcg9lsWQD/MXbUU0vk+gl8SdBvEmEJTiS?=
 =?us-ascii?Q?NFqLxoTVspKgMW7KKV1/IgO08WAkqv2XoByFz9couodi3GZ1MJaR/xfNKnjN?=
 =?us-ascii?Q?GtgymGiazdp2yUAiWn7F1eE24mCkn8JyAZB9mD/0spfLDD0HGqLMPzE6K/7H?=
 =?us-ascii?Q?aix7LE85lVvoKpg8fHbwwZl4dXoYWfPQVpZMM+i681N+1lRtyrFxUBRtYxIW?=
 =?us-ascii?Q?wF5xVedAAkzZ+ir8CpvtNU3rVZhMezraQXYMmHy+toHJCED1vH3naszeK3MK?=
 =?us-ascii?Q?b1dkGeaL5hSlyALZQbGViW/nKbndDHoAQtvp2wSB2ZLRuqz2YNDVJrAaJkJd?=
 =?us-ascii?Q?TFknlbsHrT60YWyzrTHClpoTj1GaQXg+OFQZjpoK+P9HIs6PXkHPExkzcW0o?=
 =?us-ascii?Q?7/HupCUByniCfL+TUkTOQnAwN+jvJImzBEK08IK4AbxTBUJfgRvZ36dNpwYh?=
 =?us-ascii?Q?n4bS56lcHv74KzYODwO/emvFqoEGR7VzF04HQ9mUPkSNyqLGx//Ln9Hq7SQg?=
 =?us-ascii?Q?W3KoW8ZjkiU5Hiu7UWfS626+2ZjVIPjCh1U1/1tTRZKi41sAv8P4jE+c9qJu?=
 =?us-ascii?Q?R4397IWsAXCmRVizwdbfni2aQ2WmPONV7sU7PM7mmqEAio7EYTThOpKJlNGR?=
 =?us-ascii?Q?e6uG3ILLcgGeFsXX8hfla0SfEY48GgaSso9gwzThqwGFq5w2vh7P0DA5nv32?=
 =?us-ascii?Q?bxSj/nqUjDrv0VD+GfxH9fj6bwjSQB5Z6bv3wCjRhYbk8nW4Xrt5SFw5MVx7?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mZLQ0hqIgybAWMMihY4q50hSqqg0nNk0+dbhyJhhy+xCDPXXxbRuSmp/T4g1jSomPk1gJPV4Lwid08QsjuNZ6ChvV/jmI8XLZIuYsIfAnLlnjFwO2sU4HnrIf5FDc4Qszz1J8oS6l0uo19836QdcpbGwwW5WyrRhZo13NJ7WcSvyD/X/2YwhjMGzjrErRCPvj54ZS2upyxBHxhn55ceogzDTi0qH1vWV53Og4LyoTv1czE5fXihG8FQLJrpyyfZnqYDKSfvV5zampPcJHuAA5ehC9jziEBkPNL5i/XH7uNTt1HLBAalcrUcWgt5Gp5gTJ+vqc1p/oMMTqGYJNspt139IPiRDh85+c1agbYzToQ3bc4ASFzeXE3UcGtxxf46zXWgJhj1Ak9AYiTpCQj25HE0OjaAdUsF+MCMM+6UsKP3u1tQc0EHMk0/CFwA2LHfRUr1sdGc6llkngiaZ7T/WVm3Mf/HVVBjTrMFUemGhubkODeloo0sdWkfTj1QvnkkmcRDE7g05fAthFKp6MGNAjM0OeW88ihPd4L/V0Bq4421zX51yRGFbwSLn80mxTWCreKyXsvBjbgHVIXzFsHHASqSOWo0do/st4iCldkcuo/h0JbINc9b141Yl6ofp+hNMd6xYAb/M2cy2g1Aah8+ycZxAw6y2fnFEvPQqvUt/CeubcKU+jCsmkmgMcFth4D/SAWKYj1H1nGAi/1VfYI+J2xyRi3TLGKy1vGKUrjDjq03LzymI5d7oC8KhDhDJG6O3zMDlHO+GvjIWGoypKYTIgTTKHjU6jct2dfGasUH8p8s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0dcb2c-75cb-4954-137d-08db8bffd8e8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:38:37.8055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zq3vUlB/pCTbKkdRUpQ8CXjOJ0KmuDt77+o5Rnjkk1bOB16tuK3uwXPA6AEwrwSQxTylDeT9Bcmnla09exo4Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240042
X-Proofpoint-ORIG-GUID: NcyXzg3xsBU9kWr91ykhJLWRe6_ET9C1
X-Proofpoint-GUID: NcyXzg3xsBU9kWr91ykhJLWRe6_ET9C1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We will need two variants of read_header(), show_info() and restore() helper
functions to support two versions of metadump formats. To this end, A future
commit will introduce a vector of function pointers to work with the two
metadump formats. To have a common function signature for the function
pointers, this commit replaces the first argument of the previously listed
function pointers from "struct xfs_metablock *" with "union
mdrestore_headers *".

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 61 +++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 53c5f68e..4d1bbf28 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -91,27 +91,25 @@ open_device(
 
 static void
 read_header(
-	struct xfs_metablock	*mb,
+	union mdrestore_headers	*h,
 	FILE			*md_fp)
 {
-	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
-
-	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
-			sizeof(*mb) - sizeof(mb->mb_magic), 1, md_fp) != 1)
+	if (fread((uint8_t *)&(h->v1.mb_count),
+			sizeof(h->v1) - sizeof(h->magic), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 }
 
 static void
 show_info(
-	struct xfs_metablock	*mb,
+	union mdrestore_headers	*h,
 	const char		*md_file)
 {
-	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
+	if (h->v1.mb_info & XFS_METADUMP_INFO_FLAGS) {
 		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
 			md_file,
-			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
-			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
-			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
+			h->v1.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
+			h->v1.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
+			h->v1.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
 	} else {
 		printf("%s: no informational flags present\n", md_file);
 	}
@@ -129,10 +127,10 @@ show_info(
  */
 static void
 restore(
+	union mdrestore_headers *h,
 	FILE			*md_fp,
 	int			ddev_fd,
-	int			is_target_file,
-	const struct xfs_metablock	*mbp)
+	int			is_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -144,14 +142,14 @@ restore(
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
 
-	block_size = 1 << mbp->mb_blocklog;
+	block_size = 1 << h->v1.mb_blocklog;
 	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
 
 	metablock = (xfs_metablock_t *)calloc(max_indices + 1, block_size);
 	if (metablock == NULL)
 		fatal("memory allocation failure\n");
 
-	mb_count = be16_to_cpu(mbp->mb_count);
+	mb_count = be16_to_cpu(h->v1.mb_count);
 	if (mb_count == 0 || mb_count > max_indices)
 		fatal("bad block count: %u\n", mb_count);
 
@@ -165,8 +163,7 @@ restore(
 	if (block_index[0] != 0)
 		fatal("first block is not the primary superblock\n");
 
-
-	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, md_fp) != 1)
+	if (fread(block_buffer, mb_count << h->v1.mb_blocklog, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
 	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
@@ -213,7 +210,7 @@ restore(
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
 			if (pwrite(ddev_fd, &block_buffer[cur_index <<
-					mbp->mb_blocklog], block_size,
+					h->v1.mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
 				fatal("error writing block %llu: %s\n",
@@ -232,11 +229,11 @@ restore(
 		if (mb_count > max_indices)
 			fatal("bad block count: %u\n", mb_count);
 
-		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
+		if (fread(block_buffer, mb_count << h->v1.mb_blocklog,
 				1, md_fp) != 1)
 			fatal("error reading from metadump file\n");
 
-		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
+		bytes_read += block_size + (mb_count << h->v1.mb_blocklog);
 	}
 
 	if (mdrestore.progress_since_warning)
@@ -265,15 +262,14 @@ usage(void)
 
 int
 main(
-	int 		argc,
-	char 		**argv)
+	int			argc,
+	char			**argv)
 {
-	FILE		*src_f;
-	int		dst_fd;
-	int		c;
-	bool		is_target_file;
-	uint32_t	magic;
-	struct xfs_metablock	mb;
+	union mdrestore_headers headers;
+	FILE			*src_f;
+	int			dst_fd;
+	int			c;
+	bool			is_target_file;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
@@ -320,20 +316,21 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
+	if (fread(&headers.magic, sizeof(headers.magic), 1, src_f) != 1)
 		fatal("Unable to read metadump magic from metadump file\n");
 
-	switch (be32_to_cpu(magic)) {
+	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
-		read_header(&mb, src_f);
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
 	}
 
+	read_header(&headers, src_f);
+
 	if (mdrestore.show_info) {
-		show_info(&mb, argv[optind]);
+		show_info(&headers, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -344,7 +341,7 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	restore(src_f, dst_fd, is_target_file, &mb);
+	restore(&headers, src_f, dst_fd, is_target_file);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

