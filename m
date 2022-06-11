Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B9BC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiFKJmS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiFKJmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC64CBAA
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B1hoNS021293
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=i0XU+PWY+6kM/ytmVPz/a4wYWvNvfL4MNM7jU/83bhU=;
 b=e5JWPKNThYaWmdhDMDm+OPihTwFkmgH00YanD7+I9/Vo2HGj3CTj+mGcMcbkJm6leL65
 rj3+FQ/Mq7nRH/56f5EHBpjupObJgzRT8udK352C2dtK7DQH2n+wVY97MJiMoO8DWP1I
 X7kFz1nbJtKh6YcxqJRlQKKRm3m7/l1KyApkXqZAexJYj4Sh2MZAQwdrNRh1mM0DJTeB
 TuEraqBpwZEedelfSMaTtVjxWMaw/7ZftTq5n3MOU7san8OERZSlD46bBIZHrsDqbful
 nxCf6REY3qUCJqRXwCclMoeXdyUd1oqB4rOziIkzninoB1VaDPeLtmsBWNhhI6m1+dth NQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn08c6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQ7025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBpVKDeIjvqHsyk4BnlHuC2vsmY+hHepau4aNpCKiqQ5FNLHhM3f5T3Q6oLqbyMo9ES3ScsFICEgYDwXUoN/KnITdm4BF1NGgBaSTfviiHh52eFEpJ1B9UNfM27Yjt3Px6H1VxPnxaEAM4UeP8lN2Sa9xjc9aeU2JqhSo7DUwmcumUfMK0tLMSQWqty+Flhy/jxuvWasqncowO/PdloG5AJoN+gqaImkKVN4+ZpRxLF315+F65XMYAw/sDPtqJxjp6/uN3EufCpO9Gyl0qR/w73uAfcWB5AaA/QqRlrNlDUjGSIvnYcFS7K1iDCXz3O8+R51g46+oRw+twaEXKHcvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0XU+PWY+6kM/ytmVPz/a4wYWvNvfL4MNM7jU/83bhU=;
 b=dMhppo8G0WxDv5M9H+H0V6yMM8pAaOqunrLKfzqGHsa1EiRzFcjcskURiLB8ccgN+8ihOHSRIWgnvdK5mtLytTnr8lcdiJdbldBtyIi1NlQi4M/ZGPhcHcqiXL3ug6diz8lN2MbzN35sOxyxN2Mx2gFZ7TWsLnJxueJeqKfRHKESq5WXQgy1Iwl6IYPUP5lEL6GD0JAI++eiKHvOfs3wn4og2Q0jpUZluf8nE3oceWEEphh2qAEsqLDfBBSdx8OEGi2Pu8D37z1vzKs60Qni6Xfi5NLr2o8kCEH0/8ylGfZXJnISb5dS+cYQTLMck10UAb6WJtdgsQKVInd4Xktjdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0XU+PWY+6kM/ytmVPz/a4wYWvNvfL4MNM7jU/83bhU=;
 b=DAKPttXa+qR1sHrgGaw/7aBYYPYL8TjhSoKR4DelYAd7HIkjeDB3A9eXfIkPLX1cdziwiOw39Z+QblcXLGGgEscQXhuW9wyiryA78ek6HbYNrxWbET+GoyNi01t5aLb46jjyBM5xnyCcB94qTsUJVgEi/t4xcI7+tX5Q5JQ7E1Q=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:06 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 02/17] xfs: Hold inode locks in xfs_ialloc
Date:   Sat, 11 Jun 2022 02:41:45 -0700
Message-Id: <20220611094200.129502-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 857d210e-7b23-433c-04b5-08da4b8ea5d4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606ED8E2319B0CF8853906895A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kxmKm0TvFqS7oeOOShyzy1mWIMdMQPZJ9u1NkaCllZ7/7EZ+Y2M3MyE1Q5Fg3xYtCsJotcDywnTO+CvhhClPeGUi9PQNwimdbkLPZpruhnVQrt8tZMVc1fIV33zfiOMrEwQX3d36bAdDMYze1XQfXpeMhvFt4hVaNKz/Hd6YZVp69uW9HgJT+LaE3W9XiaiuNiEHu4lLOH17nyVQ66kbIO990knOBjS/ZABmfEHaZLEoa8RF2XAmNQ1qc1TLTeU33FLK2j8Jru9LsCpkaTd309RzQ88a35rzcUDTo33EnWGIPyv6AWQSf7uW0o8Hsv3UKf9qjek30DPCHwep7TG5OJYWApvbU+GNTWvgjMD1wUyXjhUp6adwCRlp38NRfPTJjoR0XqFTWzDrPQQdHYITv1cpLHMk8MdwHKvf9ob+PUw2c9CRl3gTgwb8yJV7P8JGSj1tsOrm+4t/CxGsnLAn7CPVlrcC1DKTQ7X8WwCQ387sngmaQGXmPIhpKnHcCT6dWNp3IyEtUXzzGnBnY6zOgwLhIJ6iOD3Gp8pugpQAZHjPBecQxg7RKuWXcsgpXS3Q5IrcDdli3C0F50P714hoB3MDRzFyt0/j8APwzrgxuTFeZG5/hI4sM26B8+6jiex3VkguQfyJI6y1fpH1/jmjEN1wYtLGvVaciuL4kcbWNqdlmyo+gLqlpHKiVQP4OUkveL14GmNB4g7Er/tZfGOA7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o/D3l4DSe2eiqxRAloGkrCz3LQk1T5tsgOL5jHYfzAdKM8b/ZmTwa0cAUw8W?=
 =?us-ascii?Q?aTJc9jriaNvhcUUqqvPR9g9cnaGGSxrxg0EapOKUGe2AeNEjCYhkPcX0I60W?=
 =?us-ascii?Q?W97Tl4dOW8lPVTpMpdAuFTnaHw5KSLqvlmaZWF3U5Z/3C0VdstBE4n24RC9C?=
 =?us-ascii?Q?eF62NhcrJptSMzSst6cTnQJHFwbMROv5MSuidokyo1280Qgn5z4fazECmNy4?=
 =?us-ascii?Q?RhOeDM/n5M5Ee/H9SE5UggvxPjIif3fNhEBJqX9j6mmirckOnozqc4V9P/Ar?=
 =?us-ascii?Q?+GFscvaoTFh9MKqpV+ncrWOjqlb/bj2LHgwtgsLCdhjJmf+uzkYAFYTB+BzI?=
 =?us-ascii?Q?GOnaccLdeLqZtwV8mDq1daaR8aBo2n/Dfm7ol0UaZSZLcCBYHNwVRotuxJqS?=
 =?us-ascii?Q?9ewgyTFZ7T+dCLHMEHRB0YUBFt0IXdNnHj4xOLUdeMvfJ/RRVzdhPI4QlaXq?=
 =?us-ascii?Q?uLFDQ7YWOHm43bFDT0PgpV/KWs09/ItVq4t5wGRhcPD6OWN9OzS6Xp3vsh8a?=
 =?us-ascii?Q?CsC1hZMfcNWm0FOetkcIz7fL+4+QtYLj4RLF74El8MRRgGRjkdyizYyAlJKP?=
 =?us-ascii?Q?iNLVMM6GMwrBn9ftyuviaB5rOxGK/RV+vpq0NOSCPa/BstlneUM1G5AhHWDP?=
 =?us-ascii?Q?t3ixB/rVk522S93lDZaw/9oLJHvxhms8182AinnuV3ugXfhIDTF/DJxfHIfL?=
 =?us-ascii?Q?GgjX/eLFp9JAOlxwnyRZDzmVxV3RJlGE1ChZMh2CuEqb4wPe/Du+c3I96DKs?=
 =?us-ascii?Q?jr65JEg6BtEqaz66FpJxMBYbEC1aJh9OgXDFkp+xkSZu/cuDgAIExweV0lu3?=
 =?us-ascii?Q?P5hJaWVznbhsnX30WGLEoFXl6+5BF9nhkRyG41mUVnHHRlhXYeYjlmA5wCgO?=
 =?us-ascii?Q?MYrf7Jzzh9aZZ5a+tYjroQsazCTynzFJaGlN0cvdVzfd1XWcA6x76ygGoPYA?=
 =?us-ascii?Q?gaZQkamjc5lclJrsc5TsecoBDDp4jv8sn4symjoR+AxvfMmhKSjc0ZJ70szQ?=
 =?us-ascii?Q?RtkbmTSrkGyXGZZPMHEdUMrC741pjkgF+rxcco0oUGtNU6FZ/AGbCMsH3jS8?=
 =?us-ascii?Q?lF1hTfLWuUsW/eJrT+vRK8v1Bwbol5pCvIxTPGhONZgxxV0e6qimgeyNMYNe?=
 =?us-ascii?Q?aEFOOlHUA5mMQC9YmhSGzQ1C5zyrog1AkNW8uPSvuLjB+VIi3k6aAfhiKqap?=
 =?us-ascii?Q?NmitLvKKjYZzu2ylVQKZGbpxhyrbE+ffVMW+Bml7uwETJErRgsWuc/bmptV7?=
 =?us-ascii?Q?hyh9dN2HO50Zai4cX6Job0A2AeeqPmwuUydKV600QTrSZ2gp8uqlLA/g48Tk?=
 =?us-ascii?Q?amEaM4IKHj2OLnAuLJiqIU7KrBXxOYMBFWvS1jWsTMSOXHlss3T7HsaslmYB?=
 =?us-ascii?Q?GWFLFn1KzEKltKYQeMeDUe1olo2LVavTXa/1vL9KiOiZxUlw+1AM1xLgp2ZM?=
 =?us-ascii?Q?flWFthB7ommNGRsHSST845nLffAXuRofx3Kmt2Sht8jdxH7BXeg/OrAYx0gm?=
 =?us-ascii?Q?uF4YW/EG/XXOuxUvyKSL8qQm3Fn2DJC5egiuQlaWZdBdDMDUwdEkzmBRWtDf?=
 =?us-ascii?Q?t2K7Ugq+sz/QsKnn4PbJw+VfEB4FYh1v92l8ifkL0/3+j9NW9h2cYrRd1v36?=
 =?us-ascii?Q?HzUvshBh5QIyNUP5MuOfnYG1/ObrKIcMVOxG9MIghOsSLl0lJ3+3LkqOcaXh?=
 =?us-ascii?Q?M/7ZXbfDzhLpweaA3hGrypj9BKFlCeuDUiaKA12cqn6lMamBQgyuDcUMJF20?=
 =?us-ascii?Q?qdEtktMySc451zoouycs6Ca5QjbAqu4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 857d210e-7b23-433c-04b5-08da4b8ea5d4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:06.7171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vIr2/9z3puwbmB5kJw6TQUlEbrMgcxbkLt8Sh2NE7BZVVgG4wFdJdAvcl08Z1MLUrah8JJ7SJOiKi5q2zOD/s5fukHFmEBYUI7nI8T3T6b4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: 1VCb7BaYh3hd8Op-p9hBm_IODbZM51Ny
X-Proofpoint-ORIG-GUID: 1VCb7BaYh3hd8Op-p9hBm_IODbZM51Ny
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Modify xfs_ialloc to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c   | 6 +++++-
 fs/xfs/xfs_qm.c      | 4 +++-
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 52d6f2c7d58b..23b93403a330 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -787,6 +787,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -913,7 +915,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1090,6 +1092,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1186,6 +1189,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index abf08bbf34a9..fa8321f74c13 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -817,8 +817,10 @@ xfs_qm_qino_alloc(
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
 		xfs_finish_inode_setup(*ipp);
+		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 4145ba872547..18f71fc90dd0 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -337,6 +337,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -358,6 +359,8 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.25.1

