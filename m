Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FC9C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 23:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349474AbiEPX4b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 19:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349467AbiEPX4a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 19:56:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCB1289BE
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 16:56:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKYMKL009889;
        Mon, 16 May 2022 23:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=P6HPDijpjmiXrQUAQZy/yvSBRqxbIaSnTQg8QinVrWA=;
 b=rBEUnk8BBHIP1GEPCW7FKtH+jRPcwIxYFmhtzx7oHXnejZ3ruSy6Lio3vmMHCNaO72wo
 1NKGf7DDuxrEB9xToJwzGB1Mn3Xp421bl4pMu0gK3mlT8IhMOjQTKbTEqq48L4lMMyJA
 2iZwetwv0QGLbzU768Gj0K8TFbP1WMJr0uE7Rthl4RSRhyoS24BNdff4hDwXGGW/6QAd
 T3TMKq48BXT/Yc1ymay2/ps9xSOudyGChe/qeE6uIVd7II00OaJLQbZcnCAFoI8v+f6f
 8waA9CUmnRham5+OEeokVEv+J95EbmIHmClY2XBIxL/wvnXuux7sRhwsCBxBKEhOMMGb Lw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310msvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 23:56:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24GNfTdH014017;
        Mon, 16 May 2022 23:56:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v27stg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 23:56:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPfnp8dPvm559M/VdQOk3i+j08Dr8r8rHggSie6GgJaYOA5RYsNwNdzExx53hrBRA5pnMUFm7iFnxgKrIqeT34SvO5lCJ1ZjmQyO8tuoPXv2hbM7jMRrgYQm9vgNr+PzGiFoHn9wHKFe5ILrDDnLeYI/NviWpbgbjTlyKL7HsoZ3G2iVZLrYmm4Qf/rzRY9r7x+LvD7I4od2PxMevP1m8FzrJRxwjZxXOfAs+L+LMnOFJtDM6nSN527lxaX7wS+EbuwZdEin+msVSxuH1Awf171fq5bk/v2QH3MweFV1JjgeGVXqSkHFPnY41wXaAHreUmr3AVjiaL+5GChdVdtlmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6HPDijpjmiXrQUAQZy/yvSBRqxbIaSnTQg8QinVrWA=;
 b=aSNycRUjF8UpLyz9ab1axAGZbFAT4Tq7CbBWhA3QIGteMZh5PM0/TTtKusEoQ0WWI9Zzkg3FrflNUdPVck2PzgO5qrUonnhNq/cKYQ5yzU4tTZEgN4N/BUsqmKh7tPhhR21qmhSooO4t2pnc1LbXtFGhTn81l0HwTnl7X9xBmbXt9IXraD9w3cAzz2SKcmWylrOQvw9c7xHz/ao678kHIGV8xO+fEUhJlxnte0T+RmjUGcRt0JCDGRW84/K50qk2Y/sxWQ/bJcgMiYUBh88rI6yEtHadvSjuW5+lQdJ+rXfYY6MK9W+KCKrwk1/3aM0b758ZvmE0vX7L1bDOnPLITQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6HPDijpjmiXrQUAQZy/yvSBRqxbIaSnTQg8QinVrWA=;
 b=sHh4miwOUdOwkh3XsFrRObM8zwIKq5zdG7R1mu2sPt2Sxj4arGPQswBxT7HOQ0qtdfQRTgUKmQzjr6yYvRqN+5LnLYXhK8NOfAs4b2OB9LW9xz/FKg4oRQMuAqeJ7xSjlc8ejnHsOTN29yPW+UXs1aFFwlDpRtGoX2ZiP8LGP2M=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB5758.namprd10.prod.outlook.com (2603:10b6:806:23f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 16 May
 2022 23:56:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:56:22 +0000
Message-ID: <e31cb820dfd42734daeace193e08e1589804047e.camel@oracle.com>
Subject: Re: [PATCH 4/4] xfs: reject unknown xattri log item filter flags
 during recovery
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 16 May 2022 16:56:20 -0700
In-Reply-To: <165267193475.625255.2721960601959913094.stgit@magnolia>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
         <165267193475.625255.2721960601959913094.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0040.prod.exchangelabs.com (2603:10b6:a03:94::17)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e0c841f-5e64-4a14-7b7c-08da3797ada0
X-MS-TrafficTypeDiagnostic: SA1PR10MB5758:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB57583ABEB5CD592F27A712F395CF9@SA1PR10MB5758.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b3BQCdIpshRu8vjhSEiD6HjmCUVVGXl7KaAcBwP8dl27AvmsD4UB+bKVotDrBFHTI97Bebiq5kpTwHBlIB++DeRLgYwmCzFlauViHJug9Q3cX695DuAUfDmAIdP6s5qB6dKjmMFXFzMmVBLLoscoBSu2YYfR6zdHHpEt2ZxhrWW4/u7oWsxk09KR3m3XGpOARB6MCb2KL8yfM5VoBGOrBUL2bO4IvRgYFFAHpZKZ3hQkkjetRT+def5tgY8cyFKR42Cww7RYpOeo8PChTzv3zZMr9CC2ldr6l6FZwf767gUM9v3x8nWAw9JRxjjNAtWufZVjoLwErYQ2HPHKrQu6g7/tyw+L3AxTjeEmGIOxemdzBk0yzqIewOOeK0iSwmcmIGJsT5v8Pqv14ErxWriwxpKgBt2x3PG90gKXUYYwPbWrkgHvQSQR4cP6KlMgfOxqaGFFVBrChSEfmfEnBc5DHGuiYsBuXv0ZW2H+e+s4Pt1ox3Em62f4WJu2xd76+LtiN3dCIeZkucUYXotTmVLpyjjV3dCu09IUqHeIpCoCyHloXzbwrC+TvpI0H3i0T/pNNJCZAOJVn5eafQHApene8g6dVxTTjgJ+1eAkahL/PidG6ivqC9lsVYAP25Q1f4twvi/BCvh+qV+JEKBJQYsVKY416AzCgpVrIKIMA/7VkcFAGOicGXA2X0n3w+5ewnpXegwKIkITmqXr1Q7Nf+/2Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(38100700002)(6916009)(2616005)(86362001)(38350700002)(83380400001)(508600001)(6512007)(4326008)(26005)(6506007)(2906002)(8936002)(36756003)(66476007)(8676002)(66946007)(66556008)(6486002)(52116002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXJZTkdsUlFpWVV2WllzVHA5ZnlqaUR5Y3BBRWppK0FxU3V6aFRXMnNlOTZS?=
 =?utf-8?B?TUxKWHAwa1lMbFkxMTliTnFyTkxvdXhSMkM4c3dTdHc3aGUxeThPbDBhTjlE?=
 =?utf-8?B?OTJVVGNpSHJVMWw0WXVZdWdlUnA0WDJNZUZCVGhwb1draVV2dStQK0VORFZt?=
 =?utf-8?B?elVadlAwbzdST0pGeDZoT1lyL0o5ZGpOYzl5STFkR2daMWxwcFJicTRycUNW?=
 =?utf-8?B?cjZKTE1ZZkJyTWIyZndITEtGM05RL0IyWm9YT0M0N0c5VEFzSkUzMzRqaStG?=
 =?utf-8?B?UHB4RjNYU3dPeHp2eXhjeEYzSG9PT0xDakl3dzVpd1JjVHlMaE1tS3l1K2Fp?=
 =?utf-8?B?RWNHL1BkeEQxVWZDTzB6eWFPdDN4VVd5NFRFL2ljT1ZsOHBEVXRIZGhRTTBM?=
 =?utf-8?B?bm15QnczNTIvUE9QSlhjSjZwVm1UM21LcHVNVjVzdTI3dStTMFdjbVU3djdD?=
 =?utf-8?B?N2hjUCtXWXBzU1N3U3VrOEF3KzZPc3FQY1ZkVFpWYnB5dHdwWEp5VzRZd2ZC?=
 =?utf-8?B?TXNvSUZ2dU1TTSsrRG1wdUhjZGxEcUtwNTNpT05QdHI5VlpxMmI4ZERSc1Ji?=
 =?utf-8?B?cUx1WUdXcjBSd2tONmxEa3NhRG95WDV5MHlwL291SzB1eXVaMkRKd0xDazUw?=
 =?utf-8?B?WkFGU05ZTm1uVlNGZEVGQkRoZnFwaU9NRVY5VUxNaWU2YmZlZ2pQTExDK1FB?=
 =?utf-8?B?MGtmSGVxWW14alZDOCtHNXFWeGkyQVFFaHh2Lzk0THA5dGNmS3BlTmJiY0xG?=
 =?utf-8?B?NUx6M2tUdnRYOVMzSmZFWjdzVGZsOXpuZnpPbGtPaThNSkFCRGRzOUdxZndN?=
 =?utf-8?B?WnFKLzQ3MEdjMU5WTzlHcEdIT1ZPT1NVV0VCYWNDTHhBSGEzYXJzdTJ1VG5P?=
 =?utf-8?B?Q0dUNklQcllDT0RGaHNZcVoxWnpXZnF1c0wvKzFScndQMmNUN1E1U1ZmSGgr?=
 =?utf-8?B?NmxYS3dGL2pYYThCQU13Ulp6ZnBpaWFZd3FJODFXeXpwSjVJQTdlMlZJd21q?=
 =?utf-8?B?azNYVVdnZEY3ZTdEd0I3Qit1UGErajlQd1ZkbkhkWkhKR0FqbWNHRzl3eFZF?=
 =?utf-8?B?RFVhb0FIREVaOE93aGl0RUpOSksvcDg2OUtHamFDUFl0azFsQUFERnNqTWZK?=
 =?utf-8?B?SzlTR2pDY3h0dDh6aVQ1SHNEaGpKakRGbFA0bnRMN0Jnb05IdUFEeHlmMVFO?=
 =?utf-8?B?bzUxMVpXNkZNZ0VoNFhwdDVYQXFJa2ZqdnVNV2dqWkVIT0xSOVZRZUFCV2pv?=
 =?utf-8?B?NUhQTFMwSlFEYk5RTXJFYzZmb1ZOM2ZHZzRnaFl3blFaa1BtRmVVOFhBQ1Qw?=
 =?utf-8?B?TnFmcVdLbk9JNmN0cDc4S3loYno0Q0Y2YWoxYk93TzBIeDNtOG1LM084Y2Ev?=
 =?utf-8?B?eEd4ei9UakEvb3pvYlM2ZzhvaWZOYWt1cHFTMWhzUTYyaHJiSks0cWtNM0Uy?=
 =?utf-8?B?K0JzejBwRFlWV3U1OUM0b010bnJ3Y2hOYXZLUkJpWUVYeUhnamsvUldmSzBj?=
 =?utf-8?B?d1Y5YWJsYTIxRlV5RU9NWWFFRnZ0cUpEY1hFZ3VUdHhaSklieE1qZnloSnpQ?=
 =?utf-8?B?Tlg3ZEljZThwRFZMQkkrVncvZnhIdTVsbnQ4RnVKVGZ0NHB1M3dyaitncThy?=
 =?utf-8?B?U2krTlRjcG0ySDVjZTBXYWlnTnZkS2laYzVjUVo3eTY4d0dzRXZkOEFKVWIz?=
 =?utf-8?B?SkxvM2RQRElIamhlQnRjMFhZNXNCS2d1TnhTT01CSU5EYzUyQVZnMVlXVkJl?=
 =?utf-8?B?OWIvK0IrQjJjRzI2eklWbllBWHZJOGlDT1h6QVZuUzlOVVI3enJHUHY2clVp?=
 =?utf-8?B?V1QxWU0xTitIdCs3d3MzNUZSbDF3S21GcWhhaVBlcVpMZlFBQmZUaWY5L1Ro?=
 =?utf-8?B?TTBBakNhVlQ4SC9rSmVBOVQxZmdoMGVQRFhoSFVFd2tzMVFWUmU1VVRja2lq?=
 =?utf-8?B?cHlQUGlmVXN5eE1LRTh5d2NIL05jR0Q3eE00N2RDKzM3ejZUS2gweENxOC9n?=
 =?utf-8?B?QlBEbnB0ZHJQZExJdGNlMTh0cFhFSnhtalFIV3V4OURUL3d3T3B1RUtpbDRM?=
 =?utf-8?B?ZTdOMmNsOEVORnhhRUhMSkpWTUxIWFNUMG4wS3I2cWpyQmJHUjlERDdPMHE4?=
 =?utf-8?B?U0t1eXpYT0NoZEpha2d3SzdmMGZOdW5GdmZkTlRoWUUyQlB4YmhrdWVxcENu?=
 =?utf-8?B?cUJMWWJqTzhqV1JmSkp3c05pTjAwM2gxZ3hqNmc5MkdvVG1uWFhXdUlSdjFm?=
 =?utf-8?B?OW1SN0RBNjhwQ1ZRUEQvMlJkaEs2ZTlqYzJSNklBaHRKb0w4aFZKQzRoeTlU?=
 =?utf-8?B?bWt3bEIwNy9VRU9rRjVEMFd6QkVmUFpJMjBFTzh2SnpjL1NadkE2ajkxM0dy?=
 =?utf-8?Q?FOoXPn71oFjSB80k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0c841f-5e64-4a14-7b7c-08da3797ada0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:56:22.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CnaOK4QTbOevxqEQ7oPJnoNDqlzQB/ebiJzXwtqzW9tafXWq0RUGUs2eTR0yHJB2Fj2fihytkF4jE9+1DdHhBiHgu+17ib3mz1da969Bjrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5758
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160131
X-Proofpoint-ORIG-GUID: UOtVweDkq9d7j2SmLl9Oag4a6jgw30vn
X-Proofpoint-GUID: UOtVweDkq9d7j2SmLl9Oag4a6jgw30vn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we screen the "attr flags" field of recovered xattr intent
> log
> items to reject flag bits that we don't know about.  This is really
> the
> attr *filter* flags, so rename the field and create properly
> namespaced
> flags to fill it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |    9 ++++++++-
>  fs/xfs/xfs_attr_item.c         |   10 +++++++---
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h
> b/fs/xfs/libxfs/xfs_log_format.h
> index f7edd1ecf6d9..5017500bfd8b 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -911,6 +911,13 @@ struct xfs_icreate_log {
>  #define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
>  #define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>  
> +#define XFS_ATTRI_FILTER_ROOT		(1u <<
> XFS_ATTR_ROOT_BIT)
> +#define XFS_ATTRI_FILTER_SECURE		(1u <<
> XFS_ATTR_SECURE_BIT)
> +#define XFS_ATTRI_FILTER_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
> +#define XFS_ATTRI_FILTER_MASK		(XFS_ATTRI_FILTER_ROOT
> | \
> +					 XFS_ATTRI_FILTER_SECURE | \
> +					 XFS_ATTRI_FILTER_INCOMPLETE)
> +
It sounds like your already working on a v2 that doesnt use the new
flag scheme, but other than that, I think it looks ok.  Thanks!

Allison

>  /*
>   * This is the structure used to lay out an attr log item in the
>   * log.
> @@ -924,7 +931,7 @@ struct xfs_attri_log_format {
>  	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
>  	uint32_t	alfi_name_len;	/* attr name length */
>  	uint32_t	alfi_value_len;	/* attr value length */
> -	uint32_t	alfi_attr_flags;/* attr flags */
> +	uint32_t	alfi_attr_filter;/* attr filter flags */
>  };
>  
>  struct xfs_attrd_log_format {
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 459b6c93b40b..7cbb640d7856 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -353,7 +353,8 @@ xfs_attr_log_item(
>  						XFS_ATTR_OP_FLAGS_TYPE_
> MASK;
>  	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
>  	attrp->alfi_name_len = attr->xattri_da_args->namelen;
> -	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
> +	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter &
> +						XFS_ATTRI_FILTER_MASK;
>  
>  	memcpy(attrip->attri_name, attr->xattri_da_args->name,
>  	       attr->xattri_da_args->namelen);
> @@ -500,6 +501,9 @@ xfs_attri_validate(
>  	if (attrp->alfi_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK)
>  		return false;
>  
> +	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
> +		return false;
> +
>  	/* alfi_op_flags should be either a set or remove */
>  	switch (op) {
>  	case XFS_ATTR_OP_FLAGS_SET:
> @@ -569,7 +573,7 @@ xfs_attri_item_recover(
>  	args->name = attrip->attri_name;
>  	args->namelen = attrp->alfi_name_len;
>  	args->hashval = xfs_da_hashname(args->name, args->namelen);
> -	args->attr_filter = attrp->alfi_attr_flags;
> +	args->attr_filter = attrp->alfi_attr_filter &
> XFS_ATTRI_FILTER_MASK;
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
>  
>  	switch (attr->xattri_op_flags) {
> @@ -658,7 +662,7 @@ xfs_attri_item_relog(
>  	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
>  	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
>  	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
> -	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
> +	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
>  
>  	memcpy(new_attrip->attri_name, old_attrip->attri_name,
>  		new_attrip->attri_name_len);
> 

