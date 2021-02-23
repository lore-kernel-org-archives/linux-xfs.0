Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7607CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F71D64EC3
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhBWUUE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:20:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46804 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbhBWUTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 15:19:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKE1Ws111192;
        Tue, 23 Feb 2021 20:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/kwV0LNmnZ4wAqeJv+vw6UX+UZmuY0tW0fYiL/IeruE=;
 b=qRK5IiK8uwWOEGbOQDMXLJ4zucIFgFOLCfix92P+yU5RudWqM6Y10/djoQD+0eNPlwyW
 enMVoZqn5KSinVzi7lbC81Oct+ibL2n8QsWE87cV2WvLU5TWy71bGOO0rzA/t0az/MRo
 cGHKYFAYT3B4+KYLxtu/2GeHODIVcrRq5eUGd5StpgyffoFfB8NWhaQwQM+Vx+5U196Q
 wXs1V0doaopl+G6EdYv2jxsufKLIs8JNUGQCpFhb1qZtspiDIhU/TeBmEP2xHeD4e996
 9jgozpN49KOkTsadMTm6XfTyJv+24ZF5h79wolxByRaowY+fTFK3dovZk3qjUD8X6yNB YA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36ttcm8qd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKAZlu121118;
        Tue, 23 Feb 2021 20:18:28 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2053.outbound.protection.outlook.com [104.47.45.53])
        by userp3030.oracle.com with ESMTP id 36ucbxyp53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7rTPzTEQFNiWABTqQgNstkZjfVk721N1+F9a+mwCJpYjpOKKjvJH8Fl19X9P9+r7FixO+1crItBrnYN8EnMz3SFDehecp8xRCLXK0elXr1v/XE1JQrdmNiEvdJscmTu+rIaKOfOPZAn3ynNwL9PsK1Pnp2MVLzx4MLuC1XiG0HeFqciVJ9ICPyfdsWvDusnlcpMWf5Oa4WPhrJ2bFCVKJgNpF1YdW1i1eyXZHOksadVReQsswaUT9qsENEqrbgRik314orLe/3oMKnMU9nhgtZuxDY4Onzk1Q+qAUAOjkhl7rpjDdcLKCvG3eIdXVfe8p3pkxucV6VjQTe67a+D6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kwV0LNmnZ4wAqeJv+vw6UX+UZmuY0tW0fYiL/IeruE=;
 b=NBG4+w4LGUYYyoNYt01N01A/qAge/u/3uh8v2zXZ7z6Sq+xWgGZHP77pqrz/G2ni17nK2SqqzMUJCGROjLXuvLDhPEzN2j5Q0ZreOzDjF8kNnVxvILeBuHMp0fEiYquhTn2/SAITBhxx9zsdQaLNQFN4dLldzjJaq3TE0N/sP6DC4O0tCLJjm7DrPJd7BQLgvkoduXEWUI7VIHnuOiYX/dMnfMUa0CIMxXvv7+sLYHb+capWgWtlyb3bqlcR46lpDON1ZlwOZHslMACR2O+Q/EcyKwwjNdmQ+qd15Ukgf/lGkAFX2Lc1+sI41LSpXZTlvWx51/D4a3SU3k0uCnwJig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kwV0LNmnZ4wAqeJv+vw6UX+UZmuY0tW0fYiL/IeruE=;
 b=QFa7AuRngfpygRS2o2E4D4fgl09olx0+BKeAS9g7crgPgjfLRlDgcmnl7PHotbkndWQgxZ6851CwiZUDD/eqY4OQ1+Kj+gBpCHns36ERnlvzvOfvePQtUf3V3GfRI27Fb4qLVP9V5wDbESxVH2xJdURZLuahZsI7ALw+yjpGTzg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB5211.namprd10.prod.outlook.com (2603:10b6:610:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 20:18:26 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6%8]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:18:26 +0000
Subject: Re: [PATCH 2/7] xfs_admin: support filesystems with realtime devices
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-xfs@vger.kernel.org
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
 <161404922974.425352.3747623410781587574.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <0ae9f6ab-3725-92d4-8fdb-78bde9e5c2b0@oracle.com>
Date:   Tue, 23 Feb 2021 13:18:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404922974.425352.3747623410781587574.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR03CA0028.namprd03.prod.outlook.com (2603:10b6:a03:1e0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Tue, 23 Feb 2021 20:18:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5c9b5d4-44ec-4aa7-9c28-08d8d8382d01
X-MS-TrafficTypeDiagnostic: CH0PR10MB5211:
X-Microsoft-Antispam-PRVS: <CH0PR10MB5211F60F7976BC086BBF4B9A95809@CH0PR10MB5211.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qwRbultmp52OLQZv4H9tUNb4bHr4z+UrwykNQVcoaEpqh05RYGOkt2MijCikw3xECaBhKsiI2dgQm1VEGfaCHc+zS2mCvqdyhtDIWKCo/AjCnr/DubpThQVAhX8WqvOX8r3SWXSgKt0iYGkZfeHCgOPvSCplMRftOaCd7O2ir/dBFuHb2HDIYflikd9GqlnCNcqlgiMtst4JzoVc/IK/iU8TrOz6xkn6zVm9pOrialblDDCT7YFcGkEAKQJlg/f3hCeXEPw5LgK4EKw86rTAOiHnQS8LDO6lXVTfCh2gJII1qUdyB6yFf1TTW3Ja498Q5hOyO9LSe0613gk5A+K58K1jE76z8C1MO6RSxtEtlz9puhL0UCSSr5zvmsjIc1zM9GvwNesZKp2RW1TRJLSPzNZrsvCYDP8pMq+P6wCefZy6fw18Xa37xJbc80LwMvTrdR84MnLX2FFdY19mNNGO4mwy7otdEdyPLodGw8cYRpViYMWNoaG/EZpJffV2DEfLzf9yoo1n9T6+6dJ19nI4yGLaHU6w0D0Udybfh+AqidbovmykA9Uv0uFECovqGqSJyJUeK9L4IcBwyhQ6Y9MF7X4atiAWBet8GkfkCMKVJNY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(366004)(376002)(5660300002)(44832011)(8936002)(66476007)(6486002)(83380400001)(2616005)(186003)(26005)(54906003)(2906002)(16526019)(36756003)(31696002)(53546011)(956004)(31686004)(4326008)(66946007)(16576012)(316002)(478600001)(8676002)(66556008)(52116002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QnpscW1rZkQ5bXFGVUVpRjRGQUpReUk4WVB6RzFLbWRMZzAvaUhBOXQ3OXRR?=
 =?utf-8?B?WDUxcWxBYUlENGttL21QdjRYcTBlMHAxSEhqMER6QUN5NVJCcUZNNTdZWWN5?=
 =?utf-8?B?M1BUMWUxdjA3RVBqU0cveTNkOW9LZzVKeHZMQXN3VE4vdWNnSnBwVGswd3FP?=
 =?utf-8?B?akw1OUFpNTZXL0lNMXhXUWNMRktUR3pYaGZ0U3Z2cDhTQ1E1MWJJWDh4NnB1?=
 =?utf-8?B?L0g2RlYrVGo0QUJWazZSTDQ3VDd5THQybFhkNjllY1BHU2IrbXJEZ0hUUmVw?=
 =?utf-8?B?bzd4bVRZMXh1aWhzbm5tSzJNOTNlUXR5QU5jbmtkM1dRNXkwWDYycUMrMDdk?=
 =?utf-8?B?dkpySkxidTBLVXZpaVF2SWpMTWxNZXc4UU1mRldYam9xQmpJOGd6dkFjVGdj?=
 =?utf-8?B?UGdENXh0VjlaOG5BalhaUERXeEtMMGQrNm9jQzhHRDl0Q21peDQ5L1dWTW5o?=
 =?utf-8?B?c2pxakJsYXFxd29obnRMOXp0dmJnQUFjZzNyR3pqV01Yc0sxRDZGNDM3SHM5?=
 =?utf-8?B?N3Q1QjRHNnZtb3ljUlowdFNyR1dYbU95Zm1VUFM5VzdXZy9wc3hGVW9hZDRz?=
 =?utf-8?B?dlZmNzZHd0dOa0tsZ3BuTUlpQTZFSnFjZVp0Z0pzRWw1ajNFTUFHNHFLMXlU?=
 =?utf-8?B?YmViTHF3TjFJN1pGV0JnUWRWek8raGJTbStTeTlWU2h1M05PdjFOWFJWS01x?=
 =?utf-8?B?QUxzMVRIdWxGUGkwMG9iS010bFpmQ2JVOXQrVis3N3BsQkZJeGw5bzZBSiti?=
 =?utf-8?B?ZTNuOWdvYkVlUU8yZlNKYnZuQVVwOFJzRzJ6cjN6d3V1RzI1SWhSUUdicFlU?=
 =?utf-8?B?UUpRSnQxMTFTUFpGUHBiOUpuYXBFZCtVZjFzUEsvN1d6U3AwOVJiTVUwbkU5?=
 =?utf-8?B?clRPeXptNnlHOURUWHhZK3pSUGV1Vm9hRkRwUTJGU3RhOUtkallUUkNveW1N?=
 =?utf-8?B?dTg0bEQ1c1Avd3g5VGhvWnpmRVlrbEVKVElqOUpFd1hmMVpGWE5tNDgwV3hZ?=
 =?utf-8?B?NGVGNUxXdlhVZ2JrUGJYZXRXYWZiREVNUjVEcmQrZzFOSTBKMW5EOGUyWlBR?=
 =?utf-8?B?UndXbjR4QkhNS3FPS3F6YU1UWWxyRVBlK25MbFB0Z3dhU29yYTcyM3VHbHgr?=
 =?utf-8?B?Ym51dmhJME5BVy9sTFF1OVFYbVpkeU1LcHhyQVZRQXB1a2dFK3h1dXg2dmNK?=
 =?utf-8?B?RUg2UmdKSHRLN0NWdmpXWTRmWCtxUTZMaFR0SlNtWXN2VXNlUGhsM2pnTW1I?=
 =?utf-8?B?OWhNaXBXalBiVFg5R3NaQ25uc3BTS3V4K1lqVmpURi9vR25lY3NPV3RGNmxp?=
 =?utf-8?B?YmcvMXBPb3YyOU5BdXRmWGkvamJNclNMNlBYY3pEZ0piQ3E2WVlDU0kwVS96?=
 =?utf-8?B?Qkc2cXlMVEhzUXhxMXZ2d1JUZXcyZG5udkVhSDc5L0RMNm81eDRmY0MyNUw1?=
 =?utf-8?B?dWNNOUNCTysxQmlIQ3lneEFSNk9BRW1FNEx0a0VzT3JNWGUyVEszRHpkOHA0?=
 =?utf-8?B?MXFzRFRNdXdnWFZFMlVRSjB3SkhZTDBkN3JJZU5qQzBwWEFUblhUL2ZrUUhy?=
 =?utf-8?B?NVB3bEdDV1FhRHVzOWpvekZmYlMvZUkwVXZ6ZVBFN3YxRkFzVEZ6S2tsQVJ2?=
 =?utf-8?B?ZzEzZG9mSmFpQmRRTWd1S1I3ZkJFeGVzMFBIYjNiNU81M2hnMVhabWtrYThE?=
 =?utf-8?B?c1c4THh1dWlyaE54RkNVNmgvMjdEcWJRelpTR2x2aUNEbXhEeDN0RG91bkhH?=
 =?utf-8?Q?ntWPagKGonmgfbqjCYAR6ELjgK2c5TAcslvTUbM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c9b5d4-44ec-4aa7-9c28-08d8d8382d01
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:18:25.9257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6IweK6KK4UGj382q14XupDJoVfyyUmQ6Gn+O1n5hxj+xuhVT5pD4JQAKbgjfxMR2WUHkUL4uIoN0CcA7RiJJsuulQzUT1+usTeWYzB7DRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5211
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:00 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a -r option to xfs_admin so that we can pass the name of the
> realtime device to xfs_repair.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Looks ok to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   db/xfs_admin.sh      |   11 ++++++-----
>   man/man8/xfs_admin.8 |    8 ++++++++
>   2 files changed, 14 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 71a9aa98..430872ef 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -7,9 +7,10 @@
>   status=0
>   DB_OPTS=""
>   REPAIR_OPTS=""
> -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
> +REPAIR_DEV_OPTS=""
> +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-r rtdev] [-U uuid] device [logdev]"
>   
> -while getopts "efjlpuc:L:U:V" c
> +while getopts "c:efjlL:pr:uU:V" c
>   do
>   	case $c in
>   	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
> @@ -19,6 +20,7 @@ do
>   	l)	DB_OPTS=$DB_OPTS" -r -c label";;
>   	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
>   	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
> +	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
>   	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
>   	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
>   	V)	xfs_db -p xfs_admin -V
> @@ -37,8 +39,7 @@ case $# in
>   		# Pick up the log device, if present
>   		if [ -n "$2" ]; then
>   			DB_OPTS=$DB_OPTS" -l '$2'"
> -			test -n "$REPAIR_OPTS" && \
> -				REPAIR_OPTS=$REPAIR_OPTS" -l '$2'"
> +			REPAIR_DEV_OPTS=$REPAIR_DEV_OPTS" -l '$2'"
>   		fi
>   
>   		if [ -n "$DB_OPTS" ]
> @@ -53,7 +54,7 @@ case $# in
>   			# running xfs_admin.
>   			# Ideally, we need to improve the output behaviour
>   			# of repair for this purpose (say a "quiet" mode).
> -			eval xfs_repair $REPAIR_OPTS "$1" 2> /dev/null
> +			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1" 2> /dev/null
>   			status=`expr $? + $status`
>   			if [ $status -ne 0 ]
>   			then
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index 8afc873f..cccbb224 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -13,6 +13,9 @@ xfs_admin \- change parameters of an XFS filesystem
>   ] [
>   .B \-U
>   .I uuid
> +] [
> +.B \-r
> +.I rtdev
>   ]
>   .I device
>   [
> @@ -123,6 +126,11 @@ not be able to mount the filesystem.  To remove this incompatible flag, use
>   which will restore the original UUID and remove the incompatible
>   feature flag as needed.
>   .TP
> +.BI \-r " rtdev"
> +Specifies the device special file where the filesystem's realtime section
> +resides.
> +Only for those filesystems which use a realtime section.
> +.TP
>   .B \-V
>   Prints the version number and exits.
>   .PP
> 
