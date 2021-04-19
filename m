Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B13C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 18:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9297C61285
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 18:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhDSSdS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 14:33:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240971AbhDSSdR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 14:33:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13JIUK9s132933;
        Mon, 19 Apr 2021 18:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=N8jMEyjQ1OVluL7gcTBY/cRdeItOqpUXtcX1BUduwHc=;
 b=dMDzfkEEgYqo8aMTgs8U6A6KiG38jt903KLPOXWubc/JvfcTefH87PXClNcbJL1FK5tU
 rXcv7hwhOJ326GgTIUjnukQ9A26BvMlCRqguN7eY3gG3Q6pyTW9iG4is/Qcc/8hzDB1C
 VDJk8DmR0WKn+W3f/N22yqlajvV8bfykCroffG1LRtW6Xl22SmeZLduAhvHisav48Wnl
 +HvNn7bjnrTOdmvg7euQONkgdHdnx6xohmeN7NFGwEhflmDSfwoRrn6IAt26uveJMYjd
 k1zM/OChi8Kb05kjvWqx7jd2MDHMvTLtVVS9LvVT95ytD4abjMnOTpE0DLxNhepMVEZZ 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38022xv3k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 18:32:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13JIQ7nx074230;
        Mon, 19 Apr 2021 18:32:45 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2052.outbound.protection.outlook.com [104.47.38.52])
        by userp3020.oracle.com with ESMTP id 3809erdvdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 18:32:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YH9Fk0Mml9FdVoak98uKWSveGmu78bWHKxCASTM29eUImApMzesvWUCkCvo8aKvJ0FFZUAlNOo7xRHOcKzjDwzDAtXZvvFVpgtRcyU+MyE2pf1xy8xzKhW7xP25Q00NHHHIWTi2AWzsudiSihpHe9YUEah3cDhXwXkuVKlunzHO8uBpbxRrezus2qbUgnhzbD+5mzzKWh/MUQNPJ82E8xGFF1aRHMTv4L1uWHBAbMAtsJP7xtPpiTJyEG5Ep5HAn+Pcr4qnAjHpq8AeiSfEincklVJq3fLKaJ5d1rpsoRUP5TWOVWsI4KO1PCa2yGvklP+hn+rz5xMgrjUH2xsOSgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8jMEyjQ1OVluL7gcTBY/cRdeItOqpUXtcX1BUduwHc=;
 b=i00Yes4xxQ3dIdqguqVIQDURvSxRvc8QFCR/Yk9d1dUdk8skfw8qK3kFXt9UR6orS99mExaDHDds2TgIRfZdcqRPB5ZBx2TPATewLDAO20cQreu8sz+bIU04ui9bUARJ5woh5XfZKyc3yVs0giy1QkgVFiyJwrivFLlDPIIZcLjXdDwqeSYwSJGZWv4i0yCbFjDVcMLdA2tT6S3qhV1D4yIcnvOpAiTwpYr0XhnCYFwCbyH7Wln89bK3n62YE99ow94nBvsAbA3zLrZEsBsfbQn887po52rXAbY6K5mwCYzjp6rRgDrWc/UqsHq4//QLkwhwoDF6gfJ0tEsIyoOp6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8jMEyjQ1OVluL7gcTBY/cRdeItOqpUXtcX1BUduwHc=;
 b=C4Z69aJ+/1xTJRvOx2aXI7rrBF6Acu546IiAsvV1MAwGX85OTIG4nejJbS+7id+IVuvnu1dm711gJv+Upvkw3atv15Xgx/zoKOGpVb7usZ9a+EOCLHJhwyqV/u+ATVd/vQTdIQRmgFS1vi8XDr3ObpjSvjO00tPZ7tzrtd+FeGc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5471.namprd10.prod.outlook.com (2603:10b6:a03:302::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Mon, 19 Apr
 2021 18:32:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 18:32:43 +0000
Subject: Re: [PATCH v17 10/11] xfs: Add delay ready attr remove routines
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-11-allison.henderson@oracle.com> <87lf9eix4g.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <7e10e900-5ccf-766c-dd32-108f92360057@oracle.com>
Date:   Mon, 19 Apr 2021 11:32:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <87lf9eix4g.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: SJ0PR03CA0194.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by SJ0PR03CA0194.namprd03.prod.outlook.com (2603:10b6:a03:2ef::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 18:32:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e09cece-3110-477e-1d43-08d903618537
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5471:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5471AE871E0907A75BA017D995499@SJ0PR10MB5471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13kr2oWcTkZC7C2oovqCmagRoUX8xeJ+9ic46RGbUiZesQv6lKlwkvVm6yQk2mVU11IvN9JJris8XtvPwSmkhYVGNySN8FgRFnIOzuoOwNFDvPWEYAUL1dzByilhBmWIDU5iQV29PCJTBJ/zjJpAlm4nc6nQ89YVTh/IDdPfcXZENBnHLU693HNoUTJUVvr8HhNcAC/BS5bnIvi9WQVS+xfNfsyuJ4cVJ3b1EBEDCb5vtqgR9LAX1DcFUlNnzQQwWE8WWBviHNkU/BoZgrO32yZQoc9VZuEzFGd3DCgoYE0A/E3v7yH5IjlPCPWISj6i8O8yEAZCZh3bT9LpMaxQEMj5M3qOdEqnLMut4xYgIZXenUTXG/5Ikf5CKLjDOA/oDZopUhEyvl2+obEQ9xxL/Onk4Se1sonPmq1d5HzYct2aSy4nh0siPINRCLLbaaD49w5XgbNLr+rDLHI72ZhkHSreXIzmX9ToGD2jQS2IQHaQbIDntnev7am0s05SdZHp1rCaiMUXqdQBRECtrs8vUfz4FgJhQLvRSKGhqe/1tmc2telwyWwWLj0ZLhkoHN9pEopDArZEdYld8HBV+EsubFF2YVzCNAi1eL7KO+q8ZsbBu7TZ7e+rYhK++vIsu1FJFoAUBkB7BwTknmjYm++Cg9gb+/prllLak1WzyEDA/hluE5kN8dtyb4xlTHMDCIJWGe0mFW8BBwA6k/9d2fMsGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(6486002)(186003)(31686004)(36756003)(53546011)(2906002)(4326008)(86362001)(31696002)(44832011)(16526019)(316002)(38100700002)(83380400001)(8936002)(2616005)(16576012)(66476007)(5660300002)(38350700002)(478600001)(30864003)(6916009)(956004)(26005)(8676002)(66556008)(52116002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bURwK2l3VkdhV1VrQVpuQVpLTThnakJ4b0QyRWV1aUpEekZKUjFPWkovTHpY?=
 =?utf-8?B?c2hhY1lQeklWbHJpNGRQTnlsQlorQTAyQitsRmZuMnlXVjdWTHdMNkNyNHJE?=
 =?utf-8?B?NmdzdXl2d2RabHZ0bHNWdkg0LytJdFp5WEFqUW5JcG1NVXdVejhjeVNzU2p0?=
 =?utf-8?B?bXlwTndjRnRJRitseGR0QllVUEwrMHUyemtaQU5sTmF5VEsxek1HM3RCaklN?=
 =?utf-8?B?ZmducXlscm4rZHRTWmR1c0d2Q2IwZCtHekNjeVdFQ0p0Q1BQSnphc1hna0l6?=
 =?utf-8?B?RlBrS0JVbFNYYjdOMllXNTRCeDRaaFVvRlhKUUJlZ2EvRkJleU9Cb25rRnVh?=
 =?utf-8?B?Ymp5ZWVXcXRyNTF5eUFVcWM3WVNYam44R3U2cTVqQXdyQ1U4RmRucTM3bWxT?=
 =?utf-8?B?UWxnak1CTFZNTk1uNkpYc2I0cE95YkdLaFFoRloyTHNyM1hCbVJ2WlpzVWtO?=
 =?utf-8?B?amc3d3YxTDJjK0NRTTFrSzVLY2FXeENJSlpaUlBiNkN2WGRzSGNCYTdoWGZP?=
 =?utf-8?B?QVozVjVqZ2VrSTBGK0VlZThObFZhMTR5RTA3aitta2V2a2VaSjRmUDVZeGVh?=
 =?utf-8?B?SWJReVJFS1gwc1RvSWh3d3RCWi83a3BoeDd3Ynh5V095Y0Y2OEoxenJ0MmU2?=
 =?utf-8?B?WDVqUEFubUNvaGtoTDJsK2tQSTk1UmRPaUtXMFdzSFZqalE2aTRyenh6VmZ0?=
 =?utf-8?B?Z2NlMm5EWGZtVGpwaW1kRU5aYStNVHhCVDkzZ1dWMnN2dEtPelNBVCtXc3pp?=
 =?utf-8?B?dnFzT3NWMjk2K1lwQUJXLzhWek5VOTVQK3ZQaDZIU1JoTVFqbVkzL0RmTjc1?=
 =?utf-8?B?ZHcxNFBaRG5XS2N3bklqOXg4a3k4NkhDT2RYQk9LQkVnYmg3L0NOcFVKbk9Q?=
 =?utf-8?B?U2t2VmF1Y0dabllBc3J6YkRHdkpNS2JLRERxbkZWU1lRUVhvSkFGbmc4d0w1?=
 =?utf-8?B?aVIvTGdOSm5CMktOWTZuNkE2RkFmd2Erb1FzTFhlcnRZNDErNzZLTzRtanJM?=
 =?utf-8?B?NDF3UmxMQkQwdVZSNXBRSG1PY2UvcExmRU03d3hDRDVCUFVGaTFHMzRNQWZV?=
 =?utf-8?B?Q0xxK2g5Mkg0YVdwTzAwUjZQSG1Xa0thd3Y1Q3k5S2FPaDZLeXoxN1FyZERz?=
 =?utf-8?B?VDdPYjg3OGpOYmhlWHBsN0hna3F2dWJIcG9SVllVMEpoOUs1U2VKSzJFaEY2?=
 =?utf-8?B?alpvZFR3b3ROWjZ2ejllMDlsbWZwYldFMlVEbG1RK2VPVDNCNm5RUGtXWHVR?=
 =?utf-8?B?NkEyNUNlakE4SlA5SElzcWVIR2xZZ1lUZDhNMUZweUg3ODB2L2FpQVlIRUFM?=
 =?utf-8?B?VjFBMHR2OFhYbmlhOTlJOXgyMFJuUkpjd0NCSW95YTJGU0d2K2NjVy81NktI?=
 =?utf-8?B?R0R4Ylg2blZZZ0NIMGNSRTlNR1hjT3h5bDlYMGFVQVZMMWd4TlJZNDA1TmFj?=
 =?utf-8?B?QU14K215ZGVuM2tMa1hhTjhTbjFzalVWTkNsb0dQaTlZLzhKS3dLWmx1dWw5?=
 =?utf-8?B?TC9JdWJ3YmtmMkVsdjlMelZobHBPbTVCYWhrbEg3dzEvd0h4VmFTaCtlc2xX?=
 =?utf-8?B?eS9ONVppWjlwT2pRbVlTcy9XOVR5Z3ZCdU81U2V2VGczU2Zic0lZTzFQTGZu?=
 =?utf-8?B?RFcwcHR1d0R4a0ZGSDBRWmlHSG5Ic2NNZ2dhRzErTDVRMWJ1bHJuekJQMmI1?=
 =?utf-8?B?OC9TVTlGaG9XakxTVENkdlVYWEhSYUsxZHplVGNsTzNiQ2ZmY1Q3QURBRWF3?=
 =?utf-8?Q?QSFa9ZBtJliMCbPWqDrTuMgxbB/DG/ZgiYmttkA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e09cece-3110-477e-1d43-08d903618537
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 18:32:43.2493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nPHsX00+EkZIdAaL1EOs8mIBRpu0d95DoH69mpXINPO1Te/1WsYJ6JG5M2m2pE2jZUoNphhScJpJtdQoSdCkE0O5yL+jn8rD9Z/qrrXo0y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104190126
X-Proofpoint-ORIG-GUID: y3Gz5SxQcjzOit30wERaF6rZWbVYEVc0
X-Proofpoint-GUID: y3Gz5SxQcjzOit30wERaF6rZWbVYEVc0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104190126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/18/21 11:53 PM, Chandan Babu R wrote:
> On 16 Apr 2021 at 14:50, Allison Henderson wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>> this series, xfs_attr_remove_args is merged with
>> xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
>> This new version uses a sort of state machine like switch to keep track
>> of where it was when EAGAIN was returned. A new version of
>> xfs_attr_remove_args consists of a simple loop to refresh the
>> transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
>> flag is used to finish the transaction where ever the existing code used
>> to.
>>
>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>> version __xfs_attr_rmtval_remove. We will rename
>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>> done.
>>
>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>> during a rename).  For reasons of preserving existing function, we
>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>> used and will be removed.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use
>> to keep track of the current state of an attribute operation. The new
>> xfs_delattr_state enum is used to track various operations that are in
>> progress so that we know not to repeat them, and resume where we left
>> off before EAGAIN was returned to cycle out the transaction. Other
>> members take the place of local variables that need to retain their
>> values across multiple function recalls.  See xfs_attr.h for a more
>> detailed diagram of the states.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 208 +++++++++++++++++++++++++++-------------
>>   fs/xfs/libxfs/xfs_attr.h        | 131 +++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
>>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>   fs/xfs/xfs_attr_inactive.c      |   2 +-
>>   6 files changed, 305 insertions(+), 88 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ed06b60..0bea8dd 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>>   				 struct xfs_da_state *state);
>>   STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
>>   				 struct xfs_da_state **state);
>> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>> @@ -221,6 +220,31 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>
>> +/*
>> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
>> + * transaction is finished or rolled as needed.
>> + */
>> +int
>> +xfs_attr_trans_roll(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error;
>> +
>> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>> +		/*
>> +		 * The caller wants us to finish all the deferred ops so that we
>> +		 * avoid pinning the log tail with a large number of deferred
>> +		 * ops.
>> +		 */
>> +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>> +		error = xfs_defer_finish(&args->trans);
>> +	} else
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +
>> +	return error;
>> +}
>> +
>>   STATIC int
>>   xfs_attr_set_fmt(
>>   	struct xfs_da_args	*args)
>> @@ -527,21 +551,23 @@ xfs_has_attr(
>>    */
>>   int
>>   xfs_attr_remove_args(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args	*args)
>>   {
>> -	struct xfs_inode	*dp = args->dp;
>> -	int			error;
>> +	int				error;
>> +	struct xfs_delattr_context	dac = {
>> +		.da_args	= args,
>> +	};
>>
>> -	if (!xfs_inode_hasattr(dp)) {
>> -		error = -ENOATTR;
>> -	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>> -		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> -		error = xfs_attr_shortform_remove(args);
>> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		error = xfs_attr_leaf_removename(args);
>> -	} else {
>> -		error = xfs_attr_node_removename(args);
>> -	}
>> +	do {
>> +		error = xfs_attr_remove_iter(&dac);
>> +		if (error != -EAGAIN)
>> +			break;
>> +
>> +		error = xfs_attr_trans_roll(&dac);
>> +		if (error)
>> +			return error;
>> +
>> +	} while (true);
>>
>>   	return error;
>>   }
>> @@ -1187,14 +1213,16 @@ xfs_attr_leaf_mark_incomplete(
>>    */
>>   STATIC
>>   int xfs_attr_node_removename_setup(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state	**state)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		**state = &dac->da_state;
>> +	int				error;
>>
>>   	error = xfs_attr_node_hasname(args, state);
>>   	if (error != -EEXIST)
>>   		return error;
>> +	error = 0;
>>
>>   	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
>>   	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
>> @@ -1203,10 +1231,13 @@ int xfs_attr_node_removename_setup(
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_leaf_mark_incomplete(args, *state);
>>   		if (error)
>> -			return error;
>> +			goto out;
>>
>> -		return xfs_attr_rmtval_invalidate(args);
>> +		error = xfs_attr_rmtval_invalidate(args);
>>   	}
>> +out:
>> +	if (error)
>> +		xfs_da_state_free(*state);
>>
>>   	return 0;
> 
> The above should be "return error". Otherwise, we might be missing out on
> reporting failures from xfs_attr_leaf_mark_incomplete() or
> xfs_attr_rmtval_invalidate().
Ok, will update the return

> 
>>   }
>> @@ -1231,70 +1262,117 @@ xfs_attr_node_remove_cleanup(
>>   }
>>
>>   /*
>> - * Remove a name from a B-tree attribute list.
>> + * Remove the attribute specified in @args.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>>    * leaf nodes and even joining intermediate nodes up to and including
>>    * the root node (a special case of an intermediate node).
>> + *
>> + * This routine is meant to function as either an in-line or delayed operation,
>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>> + * functions will need to handle this, and recall the function until a
>> + * successful error code is returned.
>>    */
>> -STATIC int
>> -xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +int
>> +xfs_attr_remove_iter(
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	struct xfs_da_state	*state;
>> -	int			retval, error;
>> -	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		*state = dac->da_state;
>> +	int				retval, error;
>> +	struct xfs_inode		*dp = args->dp;
>>
>>   	trace_xfs_attr_node_removename(args);
>>
>> -	error = xfs_attr_node_removename_setup(args, &state);
>> -	if (error)
>> -		goto out;
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_UNINIT:
>> +		if (!xfs_inode_hasattr(dp))
>> +			return -ENOATTR;
>>
>> -	/*
>> -	 * If there is an out-of-line value, de-allocate the blocks.
>> -	 * This is done before we remove the attribute so that we don't
>> -	 * overflow the maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			goto out;
>> +		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>> +			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> +			return xfs_attr_shortform_remove(args);
>> +		}
>> +
>> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +			return xfs_attr_leaf_removename(args);
>> +
>> +		if (!dac->da_state) {
>> +			error = xfs_attr_node_removename_setup(dac);
>> +			if (error)
>> +				return error;
>> +			state = dac->da_state;
>> +		}
>> +
>> +	/* fallthrough */
>> +	case XFS_DAS_RMTBLK:
>> +		dac->dela_state = XFS_DAS_RMTBLK;
>>
>>   		/*
>> -		 * Refill the state structure with buffers, the prior calls
>> -		 * released our buffers.
>> +		 * If there is an out-of-line value, de-allocate the blocks.
>> +		 * This is done before we remove the attribute so that we don't
>> +		 * overflow the maximum size of a transaction and/or hit a
>> +		 * deadlock.
>>   		 */
>> -		error = xfs_attr_refillstate(state);
>> -		if (error)
>> -			goto out;
>> -	}
>> -	retval = xfs_attr_node_remove_cleanup(args, state);
>> +		if (args->rmtblkno > 0) {
>> +			/*
>> +			 * May return -EAGAIN. Remove blocks until 0 is returned
>> +			 */
>> +			error = __xfs_attr_rmtval_remove(dac);
>> +			if (error == -EAGAIN)
>> +				return error;
>> +			else if (error)
>> +				goto out;
>> +
>> +			/*
>> +			 * Refill the state structure with buffers, the prior
>> +			 * calls released our buffers.
>> +			 */
>> +			ASSERT(args->rmtblkno == 0);
>> +			error = xfs_attr_refillstate(state);
>> +			if (error)
>> +				goto out;
>> +
>> +			dac->dela_state = XFS_DAS_CLNUP;
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			return -EAGAIN;
>> +		}
>> +
>> +	case XFS_DAS_CLNUP:
>> +		retval = xfs_attr_node_remove_cleanup(args, state);
>>
>> -	/*
>> -	 * Check to see if the tree needs to be collapsed.
>> -	 */
>> -	if (retval && (state->path.active > 1)) {
>> -		error = xfs_da3_join(state);
>> -		if (error)
>> -			goto out;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			goto out;
>>   		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> +		 * Check to see if the tree needs to be collapsed. Set the flag
>> +		 * to indicate that the calling function needs to move the
>> +		 * shrink operation
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			goto out;
>> -	}
>> +		if (retval && (state->path.active > 1)) {
>> +			error = xfs_da3_join(state);
>> +			if (error)
>> +				goto out;
>>
>> -	/*
>> -	 * If the result is small enough, push it all into the inode.
>> -	 */
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -		error = xfs_attr_node_shrink(args, state);
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			dac->dela_state = XFS_DAS_RM_SHRINK;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		/* fallthrough */
>> +	case XFS_DAS_RM_SHRINK:
>> +		/*
>> +		 * If the result is small enough, push it all into the inode.
>> +		 */
>> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +			error = xfs_attr_node_shrink(args, state);
>> +
>> +		break;
>> +	default:
>> +		ASSERT(0);
>> +		error = -EINVAL;
>> +		goto out;
>> +	}
>>
>> +	if (error == -EAGAIN)
>> +		return error;
> 
> The above two statements probably not required. AFAICT, the call to
> xfs_attr_node_shrink() is the only instance which can cause "error" to have a
> non-zero return value if control reaches this point in the function. All other
> locations in the function seem to either return from the function or jump to
> "out" label on detecting an error.
Ok, i suppose it doesnt hurt anything, but i'll go ahead and bump it 
since I need to pick up the change above.

> 
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
> 
> --
> chandan
Thanks for the reviews!
Allison

> 
