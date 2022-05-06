Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3346BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 23:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444809AbiEFXsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 19:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359057AbiEFXsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 19:48:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D94712D4
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 16:44:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246KvhhT013502;
        Fri, 6 May 2022 23:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cfCQx+QKn2MM+BtY/9Tl9qzCLwZ/Ap5Z8SWSZ8yz1Ho=;
 b=Il6Qt5D/agw8yi2DTqB98E7c9QPRiiCdotuSiUyFbyabs98+qUUCHZ4jBZF1LB8ZRh/S
 ciGGmrbF9VKDwiqmkNb/xE899jOKtrsmqgKzFh044j/ETNPm/DTVFVaY5L3N7UKfjZPO
 eUavW5XowYiUpKGQldfTHDAE3boDPf8EGivw8KhKU2PURxfYmhzl1YQIZFtZqikhPDKH
 mgVbv9vA/TMa+UmozUtSroAo/NGeZYEnrce+jsr37O9EWw4bjdm4ts7dmcgKynMtwHV8
 c4+ZF0RNAAw2oBu77A3pgpHEFX/2uQLb56eBWClZGr245fGkZh+goN4yWzCXHS/5tm8a gg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frvqsqbhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 23:44:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 246Na0BO013387;
        Fri, 6 May 2022 23:44:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fusajgfcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 23:44:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9nj2nK8xQe2chsrPeiCFgC1ySIW37gkyFzMi8vfzSCeu+C3t75bdlZwsNOY5E1We5W9E/+UWTOY0PKFNbmBY1HrgixqHK26FtyEev4VMYv9rbiOYkTMNorNzrzzeH4FUZLUACHM/f/89lVmdohtgq8FX1xUqhMrZTlAJqKJTrEA4Pfc6HK1YqiZ+Uxy/Sg1sygXYs97X+2VUtcIcRXKhXRHFYnBobd6v+g1C8cxOvbiXhAUdrBzRMlmfU8jZ+kJwikhvMHvLAehSzBS7Bq5NcmjaPJs0SEBaLiQryA3e/csgL4DJqfgN+ii5gC7lG8o/GozNIox2+Z9tUWdFyoHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfCQx+QKn2MM+BtY/9Tl9qzCLwZ/Ap5Z8SWSZ8yz1Ho=;
 b=E0AcFybqlkXE3jcptRdsvPDoj4pV+BIIK6FmJeqA7e4V07jGgrUV9121//GI9s9B55RbywFi/7l91eZqhZXJzEuQ7brvtSD5/9MFLXflyJ7V56rIRKMbu2kcNUmypY+cRdJm8lNsruW0RPLJxbY8/DH6dwaDq0Tg7wZTgsqgaSnn6iwBr3hirpJlza5w/vT5b+hv5zQZu5j96QOXv8LE9Wz0coS3eP2Yc5Sax8LzeR2zRvz7CuxkW1VpHOAoo6vvYBXW8KlADZWV6lUcfcUezmwcvt0f++8GgVGC8qu7JvxxrhLiZgX94BArAtI+wX7fYiHCwVvtE8gjWTM+FK7dgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfCQx+QKn2MM+BtY/9Tl9qzCLwZ/Ap5Z8SWSZ8yz1Ho=;
 b=aJoyJ+qsXK8Z07xM7a4FJWi6FDeE13ge0mKg+XSecIsTn58z6lXLtt7sdqbFczYkVg/Boe3nC4IFM9p1YJjbNBz6ep8rAJjCN5lm6ZqzK4IaSi6r5eEUJGhKQ3jK+vUDkghMnYYvq0qQb9mQJ5tK5mpGA3WALPBVTFUjDe/es3k=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3761.namprd10.prod.outlook.com (2603:10b6:a03:1ff::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 23:44:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 23:44:10 +0000
Message-ID: <5384c5b5b6914413dae7614d705f08d511c401ab.camel@oracle.com>
Subject: Re: [PATCH 05/17] xfs: separate out initial attr_set states
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 06 May 2022 16:44:07 -0700
In-Reply-To: <20220506094553.512973-6-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
         <20220506094553.512973-6-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:208:234::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cbc62c6-75d2-47ea-c467-08da2fba5169
X-MS-TrafficTypeDiagnostic: BY5PR10MB3761:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3761B2082D1C710B6223709D95C59@BY5PR10MB3761.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /v4rBQ0wkKo025zjcV54i1o43LDI6H8Qz0/43A9oo5e1ThN5YVZNc+dravCe4GnnbiRv/2lrm2ZH49n0L4wUULEb9Vz2DyMblojxJgOzvQdH6/5JtSAdGMfyq8q6tBXLYqf9rDyH211m+dqJAffEhSgcuDlY6apYhruTW3epRX1+dV1TRaR14oSX1LlhDyxf0uNFcuelcbBjRwJ+vucQlXuDio0XmjEWIFcdOPz4fLCWkte8BQ3SAzijJWQLhKt5Mfwtj6suPbZbRgWcRpFdJNcU3tCcQ23klI+aHCA0F2Kx++YPupCa4FN3QyoApCyHm46Il+6CPL0/42DwaH6FNLDGarbndEzwsZdV39DBNW11ghXlUp+yq6J5jjhPE+n6kBpPFZkvLuCBwTm3GIzR/V7w182V4Yn86D0bC7H0e/gj6lAOraXf/w2HuAH4qdPl/wYkshkJzio0MtPannZM4FU8V5ol0BIfF0mH9jQ+CTvY+bVWxSZ+p4k1q8bh6ajGFFf5F5onJYxGILRc+PjFd4Xw8uFEy9QuBkFW+cVFejfGni7AZnXIa6amdsN5e9+WBUuTSIw9W0ZC4zNcMQJmWnmLbTULbKR65Lsf18Dgfh8lKHzp1ltjp9SEZJ+1fDMCyWYqbeDn5s5DTCV9hy7xMpmiquBM9BgxI9Y1PlRrILjUdVDYdx8igf8ZzyZ6UWvK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38350700002)(30864003)(5660300002)(186003)(6486002)(38100700002)(8676002)(66556008)(66946007)(6666004)(66476007)(2616005)(508600001)(2906002)(6512007)(6506007)(26005)(316002)(36756003)(86362001)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUFvdy9PcjdUWkRLY1NhU3NtZDBZdjZ3S0tHK0dyVnJsZGdERDRKQ1haa2xT?=
 =?utf-8?B?bmlMSG85Z2RCK25oMkl5K3J4ZUI4cHZwMkI5UzJDbWQ4dFZIZUdaR3BSNnVk?=
 =?utf-8?B?cGdZbWFZVzJFMmRLaG5NZDl0QW8rbzZQbnpIYlpTeUMzQy9seUdvMVc1bU5G?=
 =?utf-8?B?cExJN3BINUJvcWdJaGFtMThJeFpMNXRpeUlpYk0yQitRck5ZUFQ2ZmxNR0pG?=
 =?utf-8?B?TUxWMlZTT1ovMkFtN3BmdDl3T3pIbFduWlJNWVpORzRBcDVHbkNNUlNoWWY2?=
 =?utf-8?B?MlE3TVl0S05TUGdLSXN1YUZBZ0ZmTDFFSUdKS2FsaVNFK1M4NXhXeUNzUEx2?=
 =?utf-8?B?Z0puUjE1NHpKQllVSHpURFdRZHBQWXpna3lrWVpRTWhYV1pJSlRuczlRME5p?=
 =?utf-8?B?ZGdkaWdwaFliWTVyekErb1NxWE9aazB3SmE3ak1BbWRyc0ZEYk0wMmNZWHBD?=
 =?utf-8?B?djlSK29OUHJ1RjNCNk1RZklOQjZXT0xiYlkxN0J6L29ObHFGNUg3Z2krWXZP?=
 =?utf-8?B?R3hiTmgxZmEzNWQ2STFMc2ZCeWE4RndRQlhDZXp5VEoxNWd4ZmdyM2tCWlpR?=
 =?utf-8?B?TjV3WjRYQTgrdER4OVlhczhDVm5XaWI2c3NQeXU2bHpiOGhZYStweGhzZmta?=
 =?utf-8?B?TmQ3cVdaZFVqQllaSTFGbDRvSnJ5Z2NrWmgyK2hYSEJLdmlYdHAvd2k1Uk03?=
 =?utf-8?B?b3QvbEdMWGFxeXFlU3pWeWYxT3F5ZG5RTXRZRkFSd3QydGdmVmw5WkFlSUdY?=
 =?utf-8?B?eTVFQk9vY0xhcHFLd0lJT3c2cFZjSjNUL2VSdEgydlB1SG9SR1I3S0dBK2RZ?=
 =?utf-8?B?RkRFOHQwWStoMGM3M25DbmQ3Y2ZudzNlanIyODdVYnJCOC81MWVJRzBvWnVW?=
 =?utf-8?B?dVBUUHJwVnNNOCtEMGhkSzVLVnkvVzV2Y0RVOHFLNzlSODNCaGlrbU8yY0Fs?=
 =?utf-8?B?UUtIQ0tMdkc1SUlXRU1CYVVZNi94L0xJcnFpL29HTC9mcWtsK3hxSzdqdGsy?=
 =?utf-8?B?ZU5VUHZRUzNzSkhtYmZ3OG5QVWhqR0YrSGVoK09hWXFidFl6bTJwUXFjbytN?=
 =?utf-8?B?Znc3Z0tLRjAxZ2Q5bUJkN1NxdWpEZWE0c1gwMlhkcXN4ZTJUZ01QY0I2a2NK?=
 =?utf-8?B?dTZqMHpSNU5NODdHZit2UVV3WmpJTEh5ZFZFdnVDaFdVMHc0OUxFZkJoTk9C?=
 =?utf-8?B?c2xrZFlKTGtZWmJCNDFwU0FmcjluaFYxVjVNQkQ0RlZycjM3dFdiQjZtdEtP?=
 =?utf-8?B?RWFacUp3aWRuWXY1U1ZDUVVGK2hVOXFkWW1oMUJ2ZGhPSG1lOVJodi81cXhs?=
 =?utf-8?B?TjNQcTZpU1dBRTRhNkx1Z3o1WHhTOE85bWNLOHZBNWhzbENhb0tKVTIvbmpQ?=
 =?utf-8?B?WlZQZWdPQkJmbEpDeUh5TzBNVlBONGZjbmwxdEpublZ2L05WdUQ5MnJDV2dX?=
 =?utf-8?B?ZHFZWW00WExqNzJMTmxMV0ZMS08zdWswRkh6UUMxalBXNGoxeDhjTUxzWFVW?=
 =?utf-8?B?TTB0YWUzRjVNUkhmbHFzZnBWVUJyUFJFeUI5ZWZKTXhjdUI4cC83R21UR3FZ?=
 =?utf-8?B?NlhKN2crbVNOUHFwdWFmL2FWTGVkSkVtemhpOWtLVWIrZE8zeWVQdjd2U0VW?=
 =?utf-8?B?MWtxcThMR2VRUHlDL2RQNnFDVW1BeStDeGdCbjVHK1YyeGIxSjhoeHpvS3Jo?=
 =?utf-8?B?SEk2YlBNeDhUWk9QTTM1blpsa1NBeDcyTytrRU5uNDhkdlAyUjUwSWFCYnJQ?=
 =?utf-8?B?NEhTbEhVYkdCSTF0N0pvalpFQVpoVWtxVEVXcUtXeWNVVXdzWmlKSlgxV21V?=
 =?utf-8?B?ZVVsMm1DNlBMclVNL1BQMlY0elJLTlAxYi94S3hpRC9pdHV4cVNpVmNxK0Nm?=
 =?utf-8?B?RVdQUnpKSEFlVzcwNGNkYjRWaTVHVzJVTURMZW9LSitJVkZ0dlZpQytneUxm?=
 =?utf-8?B?KzFBcm5Yck9Sa0ovaGRyWXpWajdnRkdNS082Sm91UzhubVFtRUN3QXhNTExk?=
 =?utf-8?B?bU8zZjlMK0JOcDdBZDltNi9YejR5d09qQ2g3TnRuMFp6eEZ1c2ZYZjdPU2hh?=
 =?utf-8?B?M09BNEFqaEVYblRoSDJ5TGxnVlJyUXA2d3c4dFY3OENMb1B3UHJzYnEzcmdU?=
 =?utf-8?B?RFZrSG93bWt2bjRXV0JQYXJIMy9vK2pzT0I3UitTWE9XaVlRR1dEM1p4VkpR?=
 =?utf-8?B?aUhLNHlMcjBNaGJZOVdnTUlCU1VQTzFqUmtxZGdIR2RmR1ZoNDdoOUFGT29x?=
 =?utf-8?B?REZmL1c4cWs4cUExWkJBOE16Si81SWI3dXR1eGNjUEJXVWxZMXdhYVFyMnlP?=
 =?utf-8?B?bzZQRFNvUVA3RVByUzBkczlDOHM5ajdUeVNxd2I1MDQ5ZXhtUTJTTGFPUkN4?=
 =?utf-8?Q?k25diDLJvBNjPaGs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cbc62c6-75d2-47ea-c467-08da2fba5169
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 23:44:10.4232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6v7DrDHXESonG0R7s8nhnsbKnNjyA52kGJN8Fe8Irs/UumbgUz540o5MCtCNmWf3WSl5SCGt0KTkI8wsUymC0Ix6tcyB1xA58Xdu0aEark=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3761
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_07:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060118
X-Proofpoint-GUID: JwfM3SnDzTwW2gVpd7sxf52-h2D0AzV6
X-Proofpoint-ORIG-GUID: JwfM3SnDzTwW2gVpd7sxf52-h2D0AzV6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2022-05-06 at 19:45 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We current use XFS_DAS_UNINIT for several steps in the attr_set
> state machine. We use it for setting shortform xattrs, converting
> from shortform to leaf, leaf add, leaf-to-node and leaf add. All of
> these things are essentially known before we start the state machine
> iterating, so we really should separate them out:
> 
> XFS_DAS_SF_ADD:
> 	- tries to do a shortform add
> 	- on success -> done
> 	- on ENOSPC converts to leaf, -> XFS_DAS_LEAF_ADD
> 	- on error, dies.
> 
> XFS_DAS_LEAF_ADD:
> 	- tries to do leaf add
> 	- on success:
> 		- inline attr -> done
> 		- remote xattr || REPLACE -> XFS_DAS_FOUND_LBLK
> 	- on ENOSPC converts to node, -> XFS_DAS_NODE_ADD
> 	- on error, dies
> 
> XFS_DAS_NODE_ADD:
> 	- tries to do node add
> 	- on success:
> 		- inline attr -> done
> 		- remote xattr || REPLACE -> XFS_DAS_FOUND_NBLK
> 	- on error, dies
> 
> This makes it easier to understand how the state machine starts
> up and sets us up on the path to further state machine
> simplifications.
> 
> This also converts the DAS state tracepoints to use strings rather
> than numbers, as converting between enums and numbers requires
> manual counting rather than just reading the name.
> 
> This also introduces a XFS_DAS_DONE state so that we can trace
> successful operation completions easily.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good, I see we set the new states in the recovery path now
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c  | 161 +++++++++++++++++++-----------------
> --
>  fs/xfs/libxfs/xfs_attr.h  |  80 ++++++++++++++++---
>  fs/xfs/libxfs/xfs_defer.c |   2 +
>  fs/xfs/xfs_acl.c          |   4 +-
>  fs/xfs/xfs_attr_item.c    |  13 ++-
>  fs/xfs/xfs_ioctl.c        |   4 +-
>  fs/xfs/xfs_trace.h        |  22 +++++-
>  fs/xfs/xfs_xattr.c        |   2 +-
>  8 files changed, 185 insertions(+), 103 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 817e15740f9c..edc31075fde4 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -59,7 +59,7 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args
> *args, struct xfs_buf *bp);
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
> -STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
> +static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item
> *attr);
>  STATIC int xfs_attr_node_addname_clear_incomplete(struct
> xfs_attr_item *attr);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> @@ -224,6 +224,11 @@ xfs_init_attr_trans(
>  	}
>  }
>  
> +/*
> + * Add an attr to a shortform fork. If there is no space,
> + * xfs_attr_shortform_addname() will convert to leaf format and
> return -ENOSPC.
> + * to use.
> + */
>  STATIC int
>  xfs_attr_try_sf_addname(
>  	struct xfs_inode	*dp,
> @@ -255,20 +260,7 @@ xfs_attr_try_sf_addname(
>  	return error;
>  }
>  
> -/*
> - * Check to see if the attr should be upgraded from non-existent or
> shortform to
> - * single-leaf-block attribute list.
> - */
> -static inline bool
> -xfs_attr_is_shortform(
> -	struct xfs_inode    *ip)
> -{
> -	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
> -	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> -		ip->i_afp->if_nextents == 0);
> -}
> -
> -STATIC int
> +static int
>  xfs_attr_sf_addname(
>  	struct xfs_attr_item		*attr)
>  {
> @@ -276,14 +268,12 @@ xfs_attr_sf_addname(
>  	struct xfs_inode		*dp = args->dp;
>  	int				error = 0;
>  
> -	/*
> -	 * Try to add the attr to the attribute list in the inode.
> -	 */
>  	error = xfs_attr_try_sf_addname(dp, args);
> -
> -	/* Should only be 0, -EEXIST or -ENOSPC */
> -	if (error != -ENOSPC)
> -		return error;
> +	if (error != -ENOSPC) {
> +		ASSERT(!error || error == -EEXIST);
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +		goto out;
> +	}
>  
>  	/*
>  	 * It won't fit in the shortform, transform to a leaf
> block.  GROT:
> @@ -299,64 +289,42 @@ xfs_attr_sf_addname(
>  	 * with the write verifier.
>  	 */
>  	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
> -
> -	/*
> -	 * We're still in XFS_DAS_UNINIT state here.  We've converted
> -	 * the attr fork to leaf format and will restart with the leaf
> -	 * add.
> -	 */
> -	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
> -	return -EAGAIN;
> +	attr->xattri_dela_state = XFS_DAS_LEAF_ADD;
> +	error = -EAGAIN;
> +out:
> +	trace_xfs_attr_sf_addname_return(attr->xattri_dela_state, args-
> >dp);
> +	return error;
>  }
>  
> -STATIC int
> +static int
>  xfs_attr_leaf_addname(
>  	struct xfs_attr_item	*attr)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
> -	struct xfs_inode	*dp = args->dp;
> -	enum xfs_delattr_state	next_state = XFS_DAS_UNINIT;
>  	int			error;
>  
> -	if (xfs_attr_is_leaf(dp)) {
> -
> -		/*
> -		 * Use the leaf buffer we may already hold locked as a
> result of
> -		 * a sf-to-leaf conversion. The held buffer is no
> longer valid
> -		 * after this call, regardless of the result.
> -		 */
> -		error = xfs_attr_leaf_try_add(args, attr-
> >xattri_leaf_bp);
> -		attr->xattri_leaf_bp = NULL;
> +	ASSERT(xfs_attr_is_leaf(args->dp));
>  
> -		if (error == -ENOSPC) {
> -			error = xfs_attr3_leaf_to_node(args);
> -			if (error)
> -				return error;
> -
> -			/*
> -			 * Finish any deferred work items and roll the
> -			 * transaction once more.  The goal here is to
> call
> -			 * node_addname with the inode and transaction
> in the
> -			 * same state (inode locked and joined,
> transaction
> -			 * clean) no matter how we got to this step.
> -			 *
> -			 * At this point, we are still in
> XFS_DAS_UNINIT, but
> -			 * when we come back, we'll be a node, so we'll
> fall
> -			 * down into the node handling code below
> -			 */
> -			error = -EAGAIN;
> -			goto out;
> -		}
> -		next_state = XFS_DAS_FOUND_LBLK;
> -	} else {
> -		ASSERT(!attr->xattri_leaf_bp);
> +	/*
> +	 * Use the leaf buffer we may already hold locked as a result
> of
> +	 * a sf-to-leaf conversion. The held buffer is no longer valid
> +	 * after this call, regardless of the result.
> +	 */
> +	error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
> +	attr->xattri_leaf_bp = NULL;
>  
> -		error = xfs_attr_node_addname_find_attr(attr);
> +	if (error == -ENOSPC) {
> +		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
>  
> -		next_state = XFS_DAS_FOUND_NBLK;
> -		error = xfs_attr_node_addname(attr);
> +		/*
> +		 * We're not in leaf format anymore, so roll the
> transaction and
> +		 * retry the add to the newly allocated node block.
> +		 */
> +		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
> +		error = -EAGAIN;
> +		goto out;
>  	}
>  	if (error)
>  		return error;
> @@ -368,15 +336,46 @@ xfs_attr_leaf_addname(
>  	 */
>  	if (args->rmtblkno ||
>  	    (args->op_flags & XFS_DA_OP_RENAME)) {
> -		attr->xattri_dela_state = next_state;
> +		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>  		error = -EAGAIN;
> +	} else {
> +		attr->xattri_dela_state = XFS_DAS_DONE;
>  	}
> -
>  out:
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state,
> args->dp);
>  	return error;
>  }
>  
> +static int
> +xfs_attr_node_addname(
> +	struct xfs_attr_item	*attr)
> +{
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +	int			error;
> +
> +	ASSERT(!attr->xattri_leaf_bp);
> +
> +	error = xfs_attr_node_addname_find_attr(attr);
> +	if (error)
> +		return error;
> +
> +	error = xfs_attr_node_try_addname(attr);
> +	if (error)
> +		return error;
> +
> +	if (args->rmtblkno ||
> +	    (args->op_flags & XFS_DA_OP_RENAME)) {
> +		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> +		error = -EAGAIN;
> +	} else {
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +	}
> +
> +	trace_xfs_attr_node_addname_return(attr->xattri_dela_state,
> args->dp);
> +	return error;
> +}
> +
> +
>  /*
>   * Set the attribute specified in @args.
>   * This routine is meant to function as a delayed operation, and may
> return
> @@ -397,16 +396,14 @@ xfs_attr_set_iter(
>  	/* State machine switch */
>  	switch (attr->xattri_dela_state) {
>  	case XFS_DAS_UNINIT:
> -		/*
> -		 * If the fork is shortform, attempt to add the attr.
> If there
> -		 * is no space, this converts to leaf format and
> returns
> -		 * -EAGAIN with the leaf buffer held across the roll.
> The caller
> -		 * will deal with a transaction roll error, but
> otherwise
> -		 * release the hold once we return with a clean
> transaction.
> -		 */
> -		if (xfs_attr_is_shortform(dp))
> -			return xfs_attr_sf_addname(attr);
> +		ASSERT(0);
> +		return -EFSCORRUPTED;
> +	case XFS_DAS_SF_ADD:
> +		return xfs_attr_sf_addname(attr);
> +	case XFS_DAS_LEAF_ADD:
>  		return xfs_attr_leaf_addname(attr);
> +	case XFS_DAS_NODE_ADD:
> +		return xfs_attr_node_addname(attr);
>  
>  	case XFS_DAS_FOUND_LBLK:
>  		/*
> @@ -700,7 +697,7 @@ xfs_attr_defer_add(
>  	if (error)
>  		return error;
>  
> -	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	new->xattri_dela_state = xfs_attr_init_add_state(args);
>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
>  	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
>  
> @@ -719,7 +716,7 @@ xfs_attr_defer_replace(
>  	if (error)
>  		return error;
>  
> -	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	new->xattri_dela_state = xfs_attr_init_replace_state(args);
>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
>  	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
>  
> @@ -1262,8 +1259,8 @@ xfs_attr_node_addname_find_attr(
>   * to handle this, and recall the function until a successful error
> code is
>   *returned.
>   */
> -STATIC int
> -xfs_attr_node_addname(
> +static int
> +xfs_attr_node_try_addname(
>  	struct xfs_attr_item		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index c9c867e3406c..ad52b5dc59e4 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -443,21 +443,44 @@ struct xfs_attr_list_context {
>   * to where it was and resume executing where it left off.
>   */
>  enum xfs_delattr_state {
> -	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
> -	XFS_DAS_RMTBLK,		      /* Removing remote blks */
> -	XFS_DAS_RM_NAME,	      /* Remove attr name */
> -	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> -	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr
> */
> -	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr
> */
> -	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr
> flag */
> -	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
> -	XFS_DAS_RD_LEAF,	      /* Read in the new leaf */
> -	XFS_DAS_ALLOC_NODE,	      /* We are allocating node
> blocks */
> -	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr
> flag */
> -	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
> -	XFS_DAS_CLR_FLAG,	      /* Clear incomplete flag */
> +	XFS_DAS_UNINIT		= 0,	/* No state has been set yet
> */
> +	XFS_DAS_SF_ADD,			/* Initial shortform set iter
> state */
> +	XFS_DAS_LEAF_ADD,		/* Initial leaf form set iter state
> */
> +	XFS_DAS_NODE_ADD,		/* Initial node form set iter state
> */
> +	XFS_DAS_RMTBLK,			/* Removing remote blks */
> +	XFS_DAS_RM_NAME,		/* Remove attr name */
> +	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree
> */
> +	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr
> */
> +	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr
> */
> +	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE
> attr flag */
> +	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks
> */
> +	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
> +	XFS_DAS_ALLOC_NODE,		/* We are allocating node
> blocks */
> +	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE
> attr flag */
> +	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks
> */
> +	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> +	XFS_DAS_DONE,			/* finished operation */
>  };
>  
> +#define XFS_DAS_STRINGS	\
> +	{ XFS_DAS_UNINIT,	"XFS_DAS_UNINIT" }, \
> +	{ XFS_DAS_SF_ADD,	"XFS_DAS_SF_ADD" }, \
> +	{ XFS_DAS_LEAF_ADD,	"XFS_DAS_LEAF_ADD" }, \
> +	{ XFS_DAS_NODE_ADD,	"XFS_DAS_NODE_ADD" }, \
> +	{ XFS_DAS_RMTBLK,	"XFS_DAS_RMTBLK" }, \
> +	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
> +	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
> +	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
> +	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
> +	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
> +	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
> +	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
> +	{ XFS_DAS_ALLOC_NODE,	"XFS_DAS_ALLOC_NODE" }, \
> +	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
> +	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
> +	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
> +	{ XFS_DAS_DONE,		"XFS_DAS_DONE" }
> +
>  /*
>   * Defines for xfs_attr_item.xattri_flags
>   */
> @@ -530,4 +553,35 @@ void xfs_attri_destroy_cache(void);
>  int __init xfs_attrd_init_cache(void);
>  void xfs_attrd_destroy_cache(void);
>  
> +/*
> + * Check to see if the attr should be upgraded from non-existent or
> shortform to
> + * single-leaf-block attribute list.
> + */
> +static inline bool
> +xfs_attr_is_shortform(
> +	struct xfs_inode    *ip)
> +{
> +	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
> +	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> +		ip->i_afp->if_nextents == 0);
> +}
> +
> +static inline enum xfs_delattr_state
> +xfs_attr_init_add_state(struct xfs_da_args *args)
> +{
> +	if (!args->dp->i_afp)
> +		return XFS_DAS_DONE;
> +	if (xfs_attr_is_shortform(args->dp))
> +		return XFS_DAS_SF_ADD;
> +	if (xfs_attr_is_leaf(args->dp))
> +		return XFS_DAS_LEAF_ADD;
> +	return XFS_DAS_NODE_ADD;
> +}
> +
> +static inline enum xfs_delattr_state
> +xfs_attr_init_replace_state(struct xfs_da_args *args)
> +{
> +	return xfs_attr_init_add_state(args);
> +}
> +
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index b2ecc272f9e4..ceb222b4f261 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -23,6 +23,8 @@
>  #include "xfs_bmap.h"
>  #include "xfs_alloc.h"
>  #include "xfs_buf.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  
>  static struct kmem_cache	*xfs_defer_pending_cache;
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 5c52ee869272..3df9c1782ead 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -10,12 +10,12 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
>  #include "xfs_acl.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_trans.h"
>  
>  #include <linux/posix_acl_xattr.h>
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index fe1e37696634..5bfb33746e37 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -570,10 +570,21 @@ xfs_attri_item_recover(
>  	args->hashval = xfs_da_hashname(args->name, args->namelen);
>  	args->attr_filter = attrp->alfi_attr_flags;
>  
> -	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
> +	switch (attrp->alfi_op_flags & XFS_ATTR_OP_FLAGS_TYPE_MASK) {
> +	case XFS_ATTR_OP_FLAGS_SET:
> +	case XFS_ATTR_OP_FLAGS_REPLACE:
>  		args->value = attrip->attri_value;
>  		args->valuelen = attrp->alfi_value_len;
>  		args->total = xfs_attr_calc_size(args, &local);
> +		attr->xattri_dela_state =
> xfs_attr_init_add_state(args);
> +		break;
> +	case XFS_ATTR_OP_FLAGS_REMOVE:
> +		attr->xattri_dela_state = XFS_DAS_UNINIT;
> +		break;
> +	default:
> +		ASSERT(0);
> +		error = -EFSCORRUPTED;
> +		goto out;
>  	}
>  
>  	xfs_init_attr_trans(args, &tres, &total);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index e9eadc7337ce..0e5cb7936206 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -15,6 +15,8 @@
>  #include "xfs_iwalk.h"
>  #include "xfs_itable.h"
>  #include "xfs_error.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> @@ -35,8 +37,6 @@
>  #include "xfs_health.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ioctl.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  
>  #include <linux/mount.h>
>  #include <linux/namei.h>
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 01ce0401aa32..8f722be25c29 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4129,6 +4129,23 @@ DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
>  DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
>  DEFINE_ICLOG_EVENT(xlog_iclog_write);
>  
> +TRACE_DEFINE_ENUM(XFS_DAS_UNINIT);
> +TRACE_DEFINE_ENUM(XFS_DAS_SF_ADD);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ADD);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
> +TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
> +TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
> +TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
> +TRACE_DEFINE_ENUM(XFS_DAS_ALLOC_NODE);
> +TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
> +
>  DECLARE_EVENT_CLASS(xfs_das_state_class,
>  	TP_PROTO(int das, struct xfs_inode *ip),
>  	TP_ARGS(das, ip),
> @@ -4140,8 +4157,9 @@ DECLARE_EVENT_CLASS(xfs_das_state_class,
>  		__entry->das = das;
>  		__entry->ino = ip->i_ino;
>  	),
> -	TP_printk("state change %d ino 0x%llx",
> -		  __entry->das, __entry->ino)
> +	TP_printk("state change %s ino 0x%llx",
> +		  __print_symbolic(__entry->das, XFS_DAS_STRINGS),
> +		  __entry->ino)
>  )
>  
>  #define DEFINE_DAS_STATE_EVENT(name) \
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 0d050f8829ef..7a044afd4c46 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -12,9 +12,9 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_acl.h"
> -#include "xfs_da_btree.h"
>  
>  #include <linux/posix_acl_xattr.h>
>  

