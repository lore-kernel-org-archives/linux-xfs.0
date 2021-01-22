Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE29C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 151E723888
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbhAVDO0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 22:14:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44056 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbhAVDOO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 22:14:14 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M38nA6158877;
        Fri, 22 Jan 2021 03:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=b81CyA5ltaGOPGFbtx01fbZDVxqXln1+YmyC7iXRQGM=;
 b=yioNZOjqEdYwuW3Kfy/zF/xgrdWMDjQNQEo4PFYsvFiJVLjKNUacplwalUSWIOaD+iAd
 PUclLiL8wSiHJ36bDqfcmOKdWSBO1kFpELQDKHmX3Ji+Ut5HcybzD4CgEVKAX/9zm3wW
 81+0fVvSd/fkf1woXpkS8Vv72xI4zzMFA2lB2npSpk8jJz5KPkeq9jdYWAHleBqgoydY
 KhGCwo8qNYBJtfRlO4T2+SSrPy3hEDLKJtsNYmVNSnZyQ6X55YqhmmOJWev/MCHksBxm
 /NUbmjZTNZTy9XsUOriyO1SAzVVJXnjritRYolpEI7wQ7IKIgVzRpRwGSh5m1yzd4jvX DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3668qrj7fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:13:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3AtA7101292;
        Fri, 22 Jan 2021 03:13:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3020.oracle.com with ESMTP id 3668r07jtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:13:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHn3SThsA1kXV1s9HPR4uDa/hEEd1+r+1mMgAdoBVl8dsxzk4rmpcz6vB5w/LlzZatsImTVH4xKqCLAkVfiwseBCWZjlzpAvlRhNQtki75oRoFbPqIGH0PAxW7J7x0N+XnXD6nU/zkI4aVrDeyFzin9LxmAESR4PZFy84qCOGHnBpppMLveqpfdI9B81AMziUMhtVuB8RB7aa/Q45gEqgx6ea1kF/pw/7sPjU78uCOD4d6ssllEGa4UwNasfPe+xvLncOg8Z9nA6H6VerFXF3PxoTuMYdVzymc8zIusY7ac+W+v/3op52O0jRryPD4XxOGo+PkYIddtys6QUKR7XFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b81CyA5ltaGOPGFbtx01fbZDVxqXln1+YmyC7iXRQGM=;
 b=Nc4O683/1kOeH9yB5unY3MHC2iH7ANA/iXFXQdm7Y8pIj9/X9SnQ9aGr/5W2j/qHLwTs1NkOKMzwAjKlQ232yYhmQQzHF+3yrI+Ox5e0d0aizW8V6ZkQY6n7vzeduuUJiRMW4NFGsemQ8FVKaMukwTb7W//ARfdxK8iCPxEX0ruQIfScCKUj3LHJQXVhu3icn1r1GhCTIeSVGgYokbVrfRWWbSm3R18WsImCM1t1VYsoI2l2GFwrC+mfL/fmnjHgqWMqn4Ywrky4/nOBpMMqMXG7UbVDLfeEmIZ+hjAxcGoNqhbCAwzAJ+6fhPtMVJ1tmMqQQP3XAM+dPDuFSKnwwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b81CyA5ltaGOPGFbtx01fbZDVxqXln1+YmyC7iXRQGM=;
 b=vYlh/s/VyXsy0ko9wMR8zzvUi3TmDGjkAVSO2TGhO9fawArDPA6yhg5poxjM+svPfc6a3DGRXxO+vnnws+XDKWZWleIBGQHG2wSL/WZhriR0xdZn3WtKMFHK5eUdbNUx95lbateEYIpJkVSwdmC66GQjhVWcImm4MwP10zQxrWA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3045.namprd10.prod.outlook.com (2603:10b6:a03:86::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 22 Jan
 2021 03:13:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09%6]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 03:13:26 +0000
Subject: Re: [PATCH v2 8/9] xfs: remove xfs_quiesce_attr()
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210121154526.1852176-1-bfoster@redhat.com>
 <20210121154526.1852176-9-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <92649004-a4e4-dc30-3df4-f44d4144051a@oracle.com>
Date:   Thu, 21 Jan 2021 20:13:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210121154526.1852176-9-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.214.41]
X-ClientProxiedBy: BY3PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:a03:255::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.214.41) by BY3PR10CA0023.namprd10.prod.outlook.com (2603:10b6:a03:255::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 03:13:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92a9be42-a372-4ed3-be07-08d8be83af44
X-MS-TrafficTypeDiagnostic: BYAPR10MB3045:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3045BD6EBBD21F69267718CD95A00@BYAPR10MB3045.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qrjpFTdbqjIy8Mu8IVs5INaVtxg+W57SJe4xyMW/N78WX1iuHoFNl4xRV7qipCIiAHGrvawZdyya6V202Tb7sp6GQIJEk5afPn4J6G0mtAEei66pScBopEwxC562Z0sTFZ7H1wYJbvos70+HHrLUe68o3TZ0KYYv/0oRj4+SUD/jEa5sIKCOXNKldBdqUy3gZf/7das1dREIo/nLkQPeIiiVmhFD7yKmkaQilzaZfF+G9bNYf8GzT/saW5jNKF/JNy51ytUUY/Uc6yvVhCEtFmxtW9gpzRXpTKBrAdfbceMiLdEXrAoNG/VELpgNi51WQ3DzhSZj+BWOYSwCS8drc6a6IeEj+Vr8OtyJ0YNnwHYa9WcQNTly6viS22e/0wLuJF06pf0S+6/n1ZFodN3SOVEJFfv/BQrv7bNeg2yNi8zWWo0Z4WFQqLTDOhPP32Vrke/ZWf+Mx3bpiecT0rcpMFjp2O6tRkJvCx/kqIxynP4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(39860400002)(136003)(66946007)(83380400001)(44832011)(5660300002)(66476007)(66556008)(52116002)(2906002)(31686004)(8936002)(316002)(16576012)(36756003)(2616005)(26005)(508600001)(53546011)(16526019)(956004)(6486002)(186003)(86362001)(8676002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y2U2STh1R1UvSDgzYTRQR1lpUG1BbCtYRWtwZkNnTmdDQU04YzBFc3YxVFoy?=
 =?utf-8?B?dmFSLzFUelNNYTh2VkJHQWlueEJISnlNVEpxcEM3RlZtYUJ4QnZZWURidzZt?=
 =?utf-8?B?dnBQK2NGcE51R0E2RCtnNkNEL2x4VGgyRWc3cE1raW9qU1NjN1pFSHhSUGtG?=
 =?utf-8?B?U053c1BBS0ZkRnNFSFJQTG1mVFVMUEdPVGo4WXVOcUkyc2w3U0N0VCt2M0JI?=
 =?utf-8?B?eHlCWmdBbUtVeEZMb0JsS0M4L3BZcGJwT3ZZZnNBNnZXaU44eTNLRWE3UmJT?=
 =?utf-8?B?b3JoMWNDK2Y4QU5ZU243UzgrZEN2Q2xzMjJlb1ZHQ1dpenhWRFlpcUdnWmNq?=
 =?utf-8?B?Sk5seStHMkNYQjM5TWtDVVk4Z3JnUmZCWkpaY3RKbFIrNHZ2YkJucEpBci9R?=
 =?utf-8?B?MGRrMkdxMWhveVNVQ3g4dVpjY3JVaGJVQjZHM1p5TXBxaDVDaC81d1ZCTTZM?=
 =?utf-8?B?d3J1OWNJVk1pa3hVUzF6QzhwbzNaaDFYWFpBNTdEcXZYVkJWNktNRDZIelh4?=
 =?utf-8?B?NHo0dTdnL0RLK2RxLzVaOGxpQklGS0c5dmdhMmtuNjVTNFo5ZEl4Y3l3T3Fp?=
 =?utf-8?B?NDZDZ2cyZTVIaFRZM2VwdUtPbVhxMlNaT0FmdWdXdk1BbGhoclpUU0xtdGxp?=
 =?utf-8?B?UTAxeFNkdFl5YlJNaE1XWmFLR21JaDVjZTBMenZidmU2SnpYSDIyTkpnSExJ?=
 =?utf-8?B?V1A5RThnRFozN2FvWjA4QXFMRVJkd1B3TjlKdWI0UFdUZW1yQkMxWWJlNUMz?=
 =?utf-8?B?WEJDcUNOaTA3Ny90MlRBM1BmUEF6ZGtrenV1NVdkTnBmYU85TWtZV256bGV4?=
 =?utf-8?B?MWpoTjI5QkhHbDBHRW5WbjdackJBczRwQlo5Ym96U2RqSGlnclB6aVQ1NGdV?=
 =?utf-8?B?eGF3Um1BUTZ2eWo2cFlzZU1IVjRtcnVJOEhBLyt0QVFGTkp0QnhtTHdZNWZt?=
 =?utf-8?B?US9hcmRRR0traE0rc2NqZ054blBsN3NQRG9qbE5yZTNHSlA0VUNVVmhWVmc1?=
 =?utf-8?B?S2JYYndXVkZmaW1Ud0hxY3BQQUk1UHF4OTI3eEk4MGtlUmsrbnBPZGJ0QlpU?=
 =?utf-8?B?K3dkcHAyZEZjZ3FSWXQzZ2RhSllaOXhhdHE2Q3Bya2xmcitkdzFLM1ZBVExS?=
 =?utf-8?B?Tk1HRUhFbDN5dk11MzBudmFuSGdpQVgxM2ZMbTJuQWJNVG1LK1A2eXYwU20w?=
 =?utf-8?B?aGVsbTN0dTBlNXk3elZ5KzJSYTVwNlU0R2xjQmFISjUvMU8rZTBtSWwxWW5V?=
 =?utf-8?B?UDZKekZzL2VJZm4yY2JmQ3lnd01BRjJIVXdjK3YxWHhoSk5FZml4VEphZ1JV?=
 =?utf-8?Q?cs+W+1k1EcNso=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a9be42-a372-4ed3-be07-08d8be83af44
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 03:13:26.4521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AsAxtw5ZZgFcJKukT7ZegcG+C6D6Ifdoig3lfcDboHliS+12g8p4pfTlEQdvPnDtig2CcZJXD6X68iNgVlcPBCHWAVnGIb43hUqJd/+9OC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3045
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220015
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220015
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/21 8:45 AM, Brian Foster wrote:
> xfs_quiesce_attr() is now a wrapper for xfs_log_clean(). Remove it
> and call xfs_log_clean() directly.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_mount.c |  2 +-
>   fs/xfs/xfs_super.c | 24 ++----------------------
>   2 files changed, 3 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index f97b82d0e30f..4a26b48b18e4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -946,7 +946,7 @@ xfs_mountfs(
>   	 */
>   	if ((mp->m_flags & (XFS_MOUNT_RDONLY|XFS_MOUNT_NORECOVERY)) ==
>   							XFS_MOUNT_RDONLY) {
> -		xfs_quiesce_attr(mp);
> +		xfs_log_clean(mp);
>   	}
>   
>   	/*
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8fc9044131fc..aedf622d221b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -867,26 +867,6 @@ xfs_restore_resvblks(struct xfs_mount *mp)
>   	xfs_reserve_blocks(mp, &resblks, NULL);
>   }
>   
> -/*
> - * Trigger writeback of all the dirty metadata in the file system.
> - *
> - * This ensures that the metadata is written to their location on disk rather
> - * than just existing in transactions in the log. This means after a quiesce
> - * there is no log replay required to write the inodes to disk - this is the
> - * primary difference between a sync and a quiesce.
> - *
> - * We cancel log work early here to ensure all transactions the log worker may
> - * run have finished before we clean up and log the superblock and write an
> - * unmount record. The unfreeze process is responsible for restarting the log
> - * worker correctly.
> - */
> -void
> -xfs_quiesce_attr(
> -	struct xfs_mount	*mp)
> -{
> -	xfs_log_clean(mp);
> -}
> -
>   /*
>    * Second stage of a freeze. The data is already frozen so we only
>    * need to take care of the metadata. Once that's done sync the superblock
> @@ -909,7 +889,7 @@ xfs_fs_freeze(
>   	flags = memalloc_nofs_save();
>   	xfs_stop_block_reaping(mp);
>   	xfs_save_resvblks(mp);
> -	xfs_quiesce_attr(mp);
> +	xfs_log_clean(mp);
>   	ret = xfs_sync_sb(mp, true);
>   	memalloc_nofs_restore(flags);
>   	return ret;
> @@ -1752,7 +1732,7 @@ xfs_remount_ro(
>   	 */
>   	xfs_save_resvblks(mp);
>   
> -	xfs_quiesce_attr(mp);
> +	xfs_log_clean(mp);
>   	mp->m_flags |= XFS_MOUNT_RDONLY;
>   
>   	return 0;
> 
