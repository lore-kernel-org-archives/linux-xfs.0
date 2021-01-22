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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B8CC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9056623884
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbhAVDOI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 22:14:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbhAVDOG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 22:14:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3AQIm009265;
        Fri, 22 Jan 2021 03:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rnLBhRxK6D1VCB7gPFgnOg6y4aQFBQXJfv3tyEMsGSI=;
 b=a91psglwWrvAHI+8h1cjjXmChhmNRAjsAFepUR/TcALJBVwqaxI3V1ewO+xRvu7RDW8F
 PGfHIwAQoom3/qCB4WF0YyuJ00X9ZgeMOknzuFnX6EUJmlX5zXZzYVpxmPYtSTLMBWQv
 83l5DEVI2JubIjC9IN32H8LYksjqtOKGH5LBoclXnUSrIefmBkirVu2cx9d6JgJFc5f/
 jOLFWkN34nwhh0zp4a8f25TYZxEeMe6ETRlFj1QH1yeWUdaguebNs5d+PGjvZDfytxom
 9G+T1mfJXmYf8ndFzb3D4Ux6pCvgjbElmcyJSgYzaVbcGfonJ39NJzygAI3ueKiVgK4k 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3668qaj7dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:13:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3AlcU055917;
        Fri, 22 Jan 2021 03:13:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3030.oracle.com with ESMTP id 3668qy3ss8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Grh79JTO/P7hIJpzZDxjTKAkP6K+m89WBqmaZxunrBjR7Hez98JFVwLUMM/EzBSRmBEqCs/CBvYwYNfaMTBLZUqYhLdPGIJoeNChI9GknzAPpWn8h1HBQYcqZ7OvVcTtksJ67GER1gd5Jyks8VKkmTSwDTc7YBl/ICN4JbzdkK7oaaH5vaUSm2ORtywGWBmqKRjt6eQTXabtxstz8pzZTayRVwPiJxu1D8o1VsHNpTWEr77LZoqqsmOva7KZjbOPEODJ2CWNGlf6etlkttUuZlRh2WmcjjZgd0uZ/Cp4D3JWD29gxUYq6g0UoUFpbQKVc0gxY0N6RKnBxwrbMkp/ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnLBhRxK6D1VCB7gPFgnOg6y4aQFBQXJfv3tyEMsGSI=;
 b=koVNn7ZHiq0qx5hsfZMzEzgf65vQzoTIUsf/pcXtsl8oMXttT0NDgCWb5cNVpRrS4QlRlqeG1LRwKUqczlU1EJor/4MQt6N/mTsVMoq9aiBLnStzPvYMRg8HttLDnxMT2b/K7wwniITy4gkSYzCFdLpd4bnsqp9SGUdq8HEcKOAUvE5wSn2XsVjkOxK+jCZm/PIilJjDDBDoKs4aWZvRAxIayJs619CijbG538RvvdB44DL/a8G33crPPm4w2V8vhV6hGFpz7z5ZlkwJwECH9VhiqJsh5Y+TG3ws+tz/Tw0bDRPI2dZ1z7fb/OreXNpZwKcI4B6LnL38Qfb/wf8pJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnLBhRxK6D1VCB7gPFgnOg6y4aQFBQXJfv3tyEMsGSI=;
 b=Q3pRjnuoqrnUkZ0AUd4q5/9dkBQB6QWVrQmMZ8huWsrSEKXz1RIFMk2c6iYZ6Pq6CfsyXrItFQYIZN1ukqKzDMraporyNKG01qo36Qi8Vt110UCUz54bY36SvwWu+53yGaMaN2WA5bFjfgG5/SXVfI/7TFo03N8KzG5HrqPzKoU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3045.namprd10.prod.outlook.com (2603:10b6:a03:86::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 22 Jan
 2021 03:13:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09%6]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 03:13:19 +0000
Subject: Re: [PATCH v2 7/9] xfs: remove duplicate wq cancel and log force from
 attr quiesce
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210121154526.1852176-1-bfoster@redhat.com>
 <20210121154526.1852176-8-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <5bab6971-03b2-6929-ba70-0e79aca9f8d9@oracle.com>
Date:   Thu, 21 Jan 2021 20:13:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210121154526.1852176-8-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.214.41]
X-ClientProxiedBy: BY3PR10CA0001.namprd10.prod.outlook.com
 (2603:10b6:a03:255::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.214.41) by BY3PR10CA0001.namprd10.prod.outlook.com (2603:10b6:a03:255::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 03:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35755767-3f81-41f3-3ce6-08d8be83ab58
X-MS-TrafficTypeDiagnostic: BYAPR10MB3045:
X-Microsoft-Antispam-PRVS: <BYAPR10MB30451777C08A1D5CA7DB55BB95A00@BYAPR10MB3045.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/YDbfhk1by4Ojp4Dlre1TAMAAoIzhNEDWRGKxlvPZ36+4mhC+tSP6nHacH8aJoK1ie5SB4aXgGrMdHGMjfi/peFO2qcUWiCJ09gCIpeZrHkA4GhOVnsbMXIWhPF6Ux87FxuUxJgFzSVrFYE30mdu4HRCfFwWCPMt9YBNuf1MpEp9RTAqiQuMi/iwG9ySwg9KJjK1sGlQFHuDTzT7iifHlzgaTzJ4sZzDeJV9MLaZQgXVLoH0jSWr8kBlntaEc4guQhaNsTIX9KUiy562P3yTwqL9MQsMOR2afAI4GCSoXv1FXyF8ReoZRLA5T0AlFwzvuVQOhJ+Qir88PPRivrdykvGMjOwregqCRrUBL9GufuCjGeKo8IGoFenYkV2mJPbGOO3CZavaarC7+uy2WZtAO2xDPyLwaJBMN3OIn0Q2WF3QfcWNI5lftwoTNc1hIQZLLsWfGksgw3IhynYpYDvMaCMQ0tTTme/sz42y8wL/h8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(39860400002)(136003)(66946007)(83380400001)(44832011)(5660300002)(66476007)(66556008)(52116002)(2906002)(31686004)(8936002)(316002)(4744005)(16576012)(36756003)(2616005)(26005)(508600001)(53546011)(16526019)(956004)(6486002)(186003)(86362001)(8676002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OW1FRXc1dzQyUEY4S1ZSMTczS1hjRk1VR3BhOEJMaUd4dHh2dVBDQ3ZPRnNO?=
 =?utf-8?B?a0dJSjNOMmtObmd1MHJYcnp1Tm5KU28zM2xiWGlodVZ6d3FwaDUwTjRoQVM5?=
 =?utf-8?B?ZGJYbm1xL05CSjdXVWliTWRiVWdDYSszN04vSGp4dVFIQy9CekowWHpLOUta?=
 =?utf-8?B?aXdrMUc4K3BwMVRDL0NjVUpCM0tWK0F6NFF2STRSaS9DNm5ML0NKK1VENnNh?=
 =?utf-8?B?dmtsYmxVY2RqczlOTG1qZVJkZjVUU2ZrNmFCTHQ4cUxNcWJhQVpWQzZZTnIz?=
 =?utf-8?B?WWtiR3lPc3pKVXQ3bmdsZ1VMaC9qRXMvUTNkK2RqVlBxdmYraE1lQjg1S3NU?=
 =?utf-8?B?V0lQQkh1Wk5jVEVwTmZxVGh6UzZYTWRKaWxwUG5tbnVLQVY0RmNvNzBxNHBQ?=
 =?utf-8?B?Rys2akkyYndPa2J2S2ZuWmRwSndnMFY1RVJnMHhlVE54a3hmcFlWTnZtUW5Q?=
 =?utf-8?B?Ykd6aUpkOEd6UTd3WVk5enhoSDRlUmltRTVURDI0SjVCZ21XSUhidEl1aU9R?=
 =?utf-8?B?MEdGR25XSTZYWExCWWI3bkhxeTdjN3pZMDZWc1BTTGp1a1VDS2tRckRvYmxs?=
 =?utf-8?B?OUc5QXVXUFlpRWJlSmk3ZHZUR041NWZJWlNKZjdHMjVURDRuc3VTN2RpZ1Bm?=
 =?utf-8?B?WjhBY0l6QlE1Q1lwNmphb0dvS1kxWFk4bDBkemlIT3hqNnB6V0VIODdqK3kz?=
 =?utf-8?B?eEhRWklZN2k5d3RucGpWYkZvNHgzaWo5czExSnRJZXZCUEhYeXR0eGFXU21O?=
 =?utf-8?B?cjRDdFpMVjZST1ZYK1Fzd3VlZy8zUjBxNWVEZkxFK0JkSk5ZWjJaYUNFYjJp?=
 =?utf-8?B?R2g5L1BEeG5JVDZoQ0JGcEFzVnNnclVQelRZcVcxakNmVXhXcG95NXg5b2lN?=
 =?utf-8?B?QzdhZUpNQkc1cURwLzNXU1luRFFUWGJHNUxzMmRrZG1UakllRHpyYVR3OFAw?=
 =?utf-8?B?WDBiayt2TlBVSGlGclBSVEJabHcrdTFtSk1YNGFDMzhjeGJ4TG9EaU1RK1kw?=
 =?utf-8?B?UHkvbktRaWNETDBJem15N2VOaUZiRFBYUkJjTDVraDIxREcvVHNzZnQ4Y2hL?=
 =?utf-8?B?Zk00T0dPZERuZHhuRDJoZkRvazQ2NGc4RjdXeWJmSnJnaEtoa29QWkZGTnl3?=
 =?utf-8?B?SU1UMGMya3h6dWpFdmhJYXVyUWJ0YW5JZnZ0VktiYmJILzN4NTdUZktVWVEx?=
 =?utf-8?B?Q1V5MCtBVWxSb0JRSmNuc29UWStkY2hYUnY4OVZTOFBjNE0zdkRjN0kwcVJW?=
 =?utf-8?B?bERoeUJvTnJaczhQSHpYR2VNblZHM2xEazdkRk5UZE53Wnp4Mi9CWnc4TWVS?=
 =?utf-8?Q?NEBOcv26IuEoU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35755767-3f81-41f3-3ce6-08d8be83ab58
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 03:13:19.8351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XrinKVz7g8gwvsKIUPn6uh+vLaoIEy+Wmsvf21hchVcT5Xv6Rost9KgD4D13+46MOE10weLXAcXCr6oCIsD3mN8Jz8TFNnyI5+KN3s3jsjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3045
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220015
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220015
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/21 8:45 AM, Brian Foster wrote:
> These two calls are repeated at the beginning of xfs_log_quiesce().
> Drop them from xfs_quiesce_attr().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks ok to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_super.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 75ada867c665..8fc9044131fc 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -884,11 +884,6 @@ void
>   xfs_quiesce_attr(
>   	struct xfs_mount	*mp)
>   {
> -	cancel_delayed_work_sync(&mp->m_log->l_work);
> -
> -	/* force the log to unpin objects from the now complete transactions */
> -	xfs_log_force(mp, XFS_LOG_SYNC);
> -
>   	xfs_log_clean(mp);
>   }
>   
> 
