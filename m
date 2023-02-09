Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6DCC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBIICh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBIICe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0832F265AC
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:33 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PePH003345
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=42eV6BCZMwlgEoy0Eapx6sPtbfuRIysXlYYK6QuNkXA=;
 b=0wF2jxeCzROz5LYS+eL3jLkZ46g4aX480I9D+h6slnuGCUzeDsiZjmhBkAuPcDO/BCSm
 DNcz/KLfd3CLHTyxTg6q9TTzP/roJ3BFVch7szFWa1lSwgQzx8DFZLv29tp64szAevqk
 r6s98T21AuLxk0/prqqVae6v/1mvfxDzdECisMAiG+B/AVuE1LOTH+4g52zRotsRJqoP
 CUluhpS3e+dMCU7RCV2Q5mxOd3JiJSd1huHZOck89JAe8S6citUJY8v00Cjb6C+al+ji
 /XwD8yQd0Wv8hWMHOsqh/QKZrz12iopRAEkjoXx3HiRM1xZd7SxBEOSXrHxRALi34Oro WQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8aa44v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196KLvo021320
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dvja-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LR4ZpiiO6EHUTu9zgLnZZbC1mfXtKIlPBmoqKbwnH15lj8WNO85iFbxqRN1doz/fdXPbvZjWU3o4jO4r+DAcy9NmxJKxzWw9W72FWkRyaw0YfHTu0fJMcEdbsb5D9zwJQA7DvJ6heTwlpKIIcE262cAw1LGbbTWQmjiNMBB9FX7R6MnXdBP6srmDPBF2L5SjlTkb8AepNwWIqH4ea1StxC8gizKjXdcvk+3CikudjVoOzVPOLuIs+sgZC1EnJK+jAkhaOVEE0VkI7qYeAfPvyBGIR5tpkJ/FhKylGDPIAdywZcXvr8cATqD8gY4SCL7CdnTFR0HC1Edzgj6b4eaVFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42eV6BCZMwlgEoy0Eapx6sPtbfuRIysXlYYK6QuNkXA=;
 b=ha4IXNlKH5xz6GN6+5b4R1r2uvYX42M1D2QgASd2az/7lQSBE5q8SZkQ3rHLRMoi6B5jL/tKbtFosqRGyMYVZQy+gURi8mu72PtpDjyKz4PPI7GmQB6909gJX7ULTv9Tu31qnxo9eHNzNQOdHWa4ZSZE9ImaOQ5xbVdb2izclZLntpJztNxBf4qRIFOEA/Gi/ikZLCL7Irmoemtt347CdQYvHzfpe0JMORgjdennKG1mE5+3jzdFI9pQycY7DIGEUEq+90sy7itql93GOIMYKH9H2PwqAY0quV4qP/buM4IfQ1iJy6cvrc81YE6EoUB/x1UFej+g6XSIv4RW4Sgtdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42eV6BCZMwlgEoy0Eapx6sPtbfuRIysXlYYK6QuNkXA=;
 b=Uo3A0NCsdBUh3fFe71SSFLGOyu5dr29PEIZRXa1NwkBCufddrdshXoiEL+WP0l2cbfpennLc+D9JtsMK8S5/TQv9dRJOXa4aNpLbKUwzzeIZU+KWXxI8oUk3HGi4bg6XK5aJGIM0A3wJckHxmhoiABvS+QPIuvKMqnrAnHa7uKk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:29 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 22/28] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Thu,  9 Feb 2023 01:01:40 -0700
Message-Id: <20230209080146.378973-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0197.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 2efa8c66-0ffa-443c-c437-08db0a73fd6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wI7bp4czE7WQGKN1jgMF3s+D7/otGaiMY3wuTYMjSyROGLvZKWtXCs4Qo3hXvESwES/bbikyVXmPZ0WC0EPPQ7e+hiq0qw0+M5ZG1MkdnpfWcp7ucuSv5f1XBB9eDwuNG4JqGnNL0NLOMnW7uai55dKVnP/7bn0PAo5jUfp30zv8DkAw7WbCPmBuyCsRcMSg/deQdUjkABUbwra/DBkrCY9xi9/OL2fXzT+HxQSHrvKcuLI6VP1xRFFjWfdn2qS5WgrBl2PG//u2KLPBuzEiJVOYaRfF7CLEG8p+JL8srEFtS/lN2YSX6FoROM03p7M+XATf7zK6e7cvGF+IleaXNvmrCogk2TOpPafsbPkl1PvjZz3chsEIj4/QeGew3xeq7XYNWyD9Ca4+oU9CUqd6+1vgnbC7I0Jq+viu3PMDsjMubn/Lg3B1CRpqi9U4P9+pwyy38l723ADKIiodMBPiQvBQIFBfcE0UtS5hZm4HlGePzzhpcs5OcYBc54QDCzFZv2E5uwsaiZLx/Y1WC//KmnLM3zwjEWkRda5MUbNkuIhU/VzglSQve4uyt5z2F1FXXoKw68mPgdLjbdeGz9Vnd71MCwZUow3DUaLdtMEQ+xEclsKDiN0fikurBSIfPtcCXhNS8vLKni2emOS4uWEeig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jNpn3YawfS6v6bApGZE7hgYdlYMJTcKXjgvuFNT371krzouDs1H1nMHnnRte?=
 =?us-ascii?Q?kRGdILVpsG0ayw5h6h08te2bVVnwyNS4BEL2fMb9rJLoj2Y/GpbGYYC+lbW+?=
 =?us-ascii?Q?3D6Romp6/QNqBzjsUIFYDVr+GiiWWdK6GgNVL3+piXnG6osEJj/RrI2hUhoJ?=
 =?us-ascii?Q?TvsclD8gkC7Z/+6rUMDg05n1qwbbOPudT4jNNuaJN+dsvz8ebNOevLjisU2K?=
 =?us-ascii?Q?rJYrM3E2paxpFfdgZG/v8fUn8oMS7jw4tzP4hR8YSnvVz46cZyWWknMKggx0?=
 =?us-ascii?Q?7lTZHyto5oksA+w4FM/Xpig58SrLw99XLvZLtQYQFIx2thHiEdhZ9gmdgzL6?=
 =?us-ascii?Q?TfiyLWzLBke4ne8LkslH8SbEEWgAJvIogJQvyrfjjbau6y/YjyBQHo5kslEg?=
 =?us-ascii?Q?4/446q6QOdZrNa/spZVcpmRe6qaXPrApelmxVDjDLSyPaUxCmgnXcpxl9tWf?=
 =?us-ascii?Q?DEm1Jrxk+bnuONJoHhEdKqgOY+br5Z1JpcLOYVYL03D8xTDgBL8HQV24lw9G?=
 =?us-ascii?Q?xUJ+yWunBk0+aJon2jO+fZjE0RQb175TiQkW4VsEL/Jh160dUo9nxE5gxEJJ?=
 =?us-ascii?Q?PFzywEN9IITyGP9JDmkqesIEJgZQTCtXsrwCwD5ZtBfqNvzhQmPxU3FyCRAs?=
 =?us-ascii?Q?VuwU9f6tN2K/U6gXyUzA7UjAS8E3OWUZbwNF7I+kelyJHe2c6/uGzkxqbGaI?=
 =?us-ascii?Q?7LEl+BOLsWwPfqdcN5XrygoPcwoHqP9zqr1fbatYAd4JbziLl8V8xpbrC9BC?=
 =?us-ascii?Q?f/xlE8ZIpJLsI6mLQbxcg9EPZ4tN4FEZPVQ7OTVF69ux0WEc2/qNHz8sxvX7?=
 =?us-ascii?Q?BR4Fucm9sHAVBqacnZxE0DTeq3liUAYFobLrLB0IqlyJ3urPI9M5gJ4AwvMc?=
 =?us-ascii?Q?dNFCV1/U4C3SL7SgPLiwLQRP+mbV7fAsyXvJbe9YBoOctGhg76t9zAR/2W+F?=
 =?us-ascii?Q?JpIn9pDZIgiMNdIL/akgsIOf2TYMLThQGJTvW8pFGSvb5PKQjCEhBGRPRkql?=
 =?us-ascii?Q?zNZi2ALdt7T/U6g4BvQwRM9DYG7fwIdsNxP+bLD1U6kVs/mpRNX/X3sO6wmm?=
 =?us-ascii?Q?bNbNCiZ9ZI00pUj/KwOKphaxw5gVhdRm78E6yiQhK5Z2g7HBbgzdoZ8hnWlM?=
 =?us-ascii?Q?BIzteH8qL1ybYpQSTrwzeGKjFU/7sSEoi/9fMrTAVLiYuUe+E2zLIkhi1zke?=
 =?us-ascii?Q?whSdm8XuHifMGluZTai7yP+k+zwJr1OogG34n33Fpj68jdjHGb83/anDFfLK?=
 =?us-ascii?Q?PcIa8tWVyEzJ3bNiA1cYfaEj1rkFnZLo+b9crHNfYm4bl6JGWvlGoEKrngTR?=
 =?us-ascii?Q?Ewm5BI/sYIAg4Yx68R4bCE3ZU4gofEGxBazxEUs5iEhxyF+2DR3Ji/Bqmt0c?=
 =?us-ascii?Q?y7kOExi31fQQYNspL0OKkaH9hBOcsFEucsu1mJpTQQNp8d1zJ3m26s3LI5ZH?=
 =?us-ascii?Q?X3sxneFXAozqbEpOT3XQ8L6bBXGymeu7ckxmLe1vPME9jcvmysBzBgymUvHj?=
 =?us-ascii?Q?vD1qURurmqbOyrf+SbavlW2g3ahxJCGcLiEGygRdbANim1I32mIWxscNbFLB?=
 =?us-ascii?Q?JI1FPfDZDfNI/QKCrPMRqr+tCj+cRWQ0Ezpg4laz1efhkwSOILuB0+gxvizm?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eP2pnd0RDsahcUZr+pHaV1jXaX9gSh5i+SxJdcbcsoDxJiysuyuPd4XFVRGwseo+pjg3Q6qvT+Dcznum4GKtrjWcA50eBXVMmhmZlun8WQtLZ3nNZ1ORKn6HJd7DYe79d+mqJG0uvmmWMlCYs9rHCCRNagabGKXr0xbMATZMJXonL3pONCQQb8kVkW/t4ZTQNrVEXMj+o8n8RbPTBzzRjWtSEcAPdZ8eDFqAvQ4X8AEj+sUpguAoZtQwzC62X7CdYJPYAcgM7lCjFOl4iFmrcwzLJrKOAKkm1c0L2ud0HqQu4GC1Gs3STWsrp6KVaHaAzijIqaiJNcPXTW2RLTBHjEzZCxlpwpUjoVA5Tmh51ameY4JApW3i9wO7sNZIQmECgtp2E/tkFIXQsJHhgJIoaanBrmhPnf4DCxFBTmDGPFblqiEpt9g1buGxhbBFWme/XuGGKfNKI/k4y92v3nBhA3BYdETj9uudGd8s2/V+ZoPudD0vaZHKIKbeCpZ0P0vZC+OeOMQ//bjLPvo78AVs8VieVSSpfkV9YHMAGWDnfyNNHrjmv6uD+55YnLM6whUDA9HM/K/RO1KzHBA+OhsCcjJdTK/hYePb4CCv7YaSv6anApWZLzVHgOoA6Nu3+Od+mzon4qb/dMrRaf+tOtPoVzpF/YNZZFzqgYETejckpmgIYEcoTOgza+UdGDvFid1BR8s0YD0s1ZxxAdDXN0WkrK/unfTBfB11uICMBhiEMHNWQiG7OtC2twDQ195XfUis
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2efa8c66-0ffa-443c-c437-08db0a73fd6c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:29.4368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKdqZ5c25I9u+WoJeyl/200nl5AfZOVFgsrDLxB+VknH8Ii9WD9Cwia3qBXipkK+bAoLdAJMfdCHPDwwMqr1l/pw7cexWqggkp8hpls8n9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: apd6hJHMX3Hbmt4T_mcz6i1QCFv5rgp4
X-Proofpoint-GUID: apd6hJHMX3Hbmt4T_mcz6i1QCFv5rgp4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 4 ++++
 fs/xfs/xfs_super.c         | 4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..f413819b2a8a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..b0b4d7a3aa15 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 1eeecf2eb2a7..a59bf09495b1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -173,6 +173,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1189,6 +1191,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6795761c31e0..0ac55d191f1f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1664,6 +1664,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
 
+	if (xfs_has_parent(mp))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.25.1

