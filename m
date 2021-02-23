Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33B7C433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A7B64E61
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhBWSW7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 13:22:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbhBWSWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 13:22:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NIA6hr096472;
        Tue, 23 Feb 2021 18:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MrI34O/S2rnztiFAEz9Yk7jci39P29FHLKGzKRwlPJE=;
 b=JHkHNVaA1buliEK6zKaPJ1yel6M0Sgt9fCVQMBwHu3HuwFMOUfHLdKgZOjjvHHmSP7vH
 p+jyuABbbdhIgW12MQ3GRd3kKLk/ow629VlC+4XVgXqmNLD605vn7XrhUeLwasxUbAPb
 aJW8QsBHDJ9qNoi9KJ255NYPZrJdNLfN5x1F7zsJub4ny+ixQBdR4BFGelX2n2W9C/Mi
 fYsGKnXUZSp11dOBVwgExzm3ekpXq3C4/MSk09Y8vf+WpeScIsjnJp1Qs1n1mqz08S3h
 4GRxOFBdwRlpKeyNmPjixVw8PoGneWJvtrTU9qLE+7gI7HABcGSnZA2WD+5x/bv7hN3f Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36ttcm8c9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 18:22:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NIAV53178949;
        Tue, 23 Feb 2021 18:22:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3030.oracle.com with ESMTP id 36ucbxuj7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 18:22:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpD82ksGIVFxFEb3/lJqpdc2z1JXo/vGh2RXVNQgCfDtz/gFAs/V1kQTVQWJJzm+PHwfs/kllbEt6hqgzKP/Sq4MEljhlOl5bq9+AhR6jlAYpIwtaUiw+fdswtepduLvSXgB99iLOR1NxOgHiRQ+fHDM6ITxURUV0rUPYoC8z0MWDLj95qlpJVtKCFZAfHm3hVsAT47t0vxfsxmFWF3POfRTGADZ5UrsLcPGSQPjXmY2uckB17V0a3JsjpYNwGRYs6CRnJtw8SkI8aFiXtpWa2Sae8DioI8/jQ7j3rxd2wVJ0FNyGx9rnbaC7qlOyTp+GW2Z1h5vcd/XBXkTxo6epQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrI34O/S2rnztiFAEz9Yk7jci39P29FHLKGzKRwlPJE=;
 b=ndPICrE5WouFVSkk4n0qrHXCM8D7s/Hf86WGKgXr1r8q9S9b7Xg9w/qZh5SFwdmNSCaKbYos8zuBcj89uEc22yyBe2yPcCQxIoLiei+EIh580giEmYIxRSX+ZPpYIaV1pjxawlN8qrdkHIC081qDcm7i9iGbGHu/fun53jbnaQ/++vEelOu8/KraQFedT9r6wf4YgiCPtOX1UzcnFQKJYDYz1G9DPIpSGbDLTQQtGp3+Glz8Ah/lu2VDuGjmoqzsPw5xkwpsP3b9saWs24cN7UhmVWc2OmrbVOQHzX0lpOa7JJCGoTmZm6jrKYY/n6CBekjFCqfE7qAA39FvjRqnzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrI34O/S2rnztiFAEz9Yk7jci39P29FHLKGzKRwlPJE=;
 b=xGO1YoFsiTDIejhwVEz3iNzVzs8QpFCx9S8ng/N7/8mROyqlLGEvRxtYcDEG9vAhpgBgiuAY7osmiMzQlDelbvVbSPbPCqTAuMM2V2JRHUnAGk4TethIxK/Tt1zBexJW8/lI/crZFhsFu5BmN7gVadA4wI6j9U4BLRwGIPknYhE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH2PR10MB3813.namprd10.prod.outlook.com (2603:10b6:610:5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 23 Feb
 2021 18:22:07 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6%8]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 18:22:07 +0000
Subject: Re: [PATCH V2] xfs: initialise attr fork on inode create
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210222230556.GR4662@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6af53b61-6f2c-bf4e-a980-45ecc13a5746@oracle.com>
Date:   Tue, 23 Feb 2021 11:22:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210222230556.GR4662@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Tue, 23 Feb 2021 18:22:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cd048aa-2523-4cb3-bff9-08d8d827ed34
X-MS-TrafficTypeDiagnostic: CH2PR10MB3813:
X-Microsoft-Antispam-PRVS: <CH2PR10MB381342BE037D9F8366A85B2495809@CH2PR10MB3813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BFYx0UDF5vtxQTKQW/q/z45EOl8Ep94xHDDi6cz8MbkdlEQ7qsi3hI73nbdcKSY7B4Ra0JAbMPBQ9gaxOBASVxqOe61+Zy86AHpCiq4x+UteWZfNAT1eocp61j4IzwZqU6x+ItCl4YznWvoCCGdrfdStA0z7we15pvA2K7+W4dgrgE8CQ/anfExfFWhQWnHrb5WBdJ7rDdI67XTBkVSZNyyNyYSwQJlAeY1c22KNhkGpbCtvPRG26dSxieYq+KCBkO5mVC7SO+XBTZBOJqLhMYC0HZAUwMZeRl7PbPxRJEVS0u0g2dHRQSn+p6Po9FS7AHT8gXIeknqI+xCvYXVCk2mGfusHcW8ebv0nN80dnUYZ8mwUEmqmeVS8IqI4oYXf4Ni5nac8/aeiJ8BA1iVEFGdANRSTL4u5cl4+YNYnZz3L2OOvzI1wR1lD5znqTrOhXdgg+jYcFGk/3VXGepNsDNuLegg/7kCGTRUQRPsT3cTYv6rB4O6enu3yf5IADdAFSD6UEW+tl8RZ62Zq1UdZ6z41ACX5qvk7XZDnsqeuSb1gDvIm5CavHq/lSG0CncElVxGkmj445vKWhKNqi23WaexEiXhRiK86/HbUaYR2t+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(39860400002)(376002)(136003)(16576012)(66556008)(186003)(478600001)(66476007)(31696002)(52116002)(16526019)(36756003)(66946007)(26005)(83380400001)(316002)(30864003)(2616005)(6486002)(8936002)(86362001)(53546011)(956004)(2906002)(5660300002)(44832011)(31686004)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VHBCeEZOU0JUdUFvR29wbnBuRFdXTVdCMllBS2drSFJkT3M0emM1bU1RS0dU?=
 =?utf-8?B?VklVYkhWQ1Azd2xra0plNVdRWXdIOWs4RVlNa1VlN1NZWVE2V0J4VGpOcUZY?=
 =?utf-8?B?Qkd1N1NhUjF1VnN1QXUzOVlLVysvT0J2TmlieEx2eERtR2EzSTFSMzR0L0cv?=
 =?utf-8?B?UjV2ZFdkYzc4d3VGVElONHhVYnZDVHJhY2VoakVWRkRkby9sOUNuSXhsMmp0?=
 =?utf-8?B?Q04zUnQwMFZBUGdGZ1l1TDdFWk5FcjJoZG1zVDNhU2hyMk8rcjlUclY0L014?=
 =?utf-8?B?UzF2SUZqU29OT3NocmUwUklrRXFDUXljZUtLTGtVdHZlN0g0OEVmRHhGSmdZ?=
 =?utf-8?B?Y280UUlxbWZ4T1pJdy9vV1REVEsyeWhmNE9EQzVWY3dRSXljazNJdS9HaVpx?=
 =?utf-8?B?T3ZXenROWkNOSmNVRzJJV0R6Y0drUmRSNnNWR1Npc2hKemRRRjExYjFqUDh4?=
 =?utf-8?B?bnpQWlhkbUgwU3N2dGpQRkJBUnhQT005eHZneDlFSjVVbDBFNW05aFQzTnNY?=
 =?utf-8?B?NlBpQnNZY0JOMTZ3WkhNM3VUTTE2VkFQcGR4bWtxd0VYSXdHaGtvaXRxbkoy?=
 =?utf-8?B?VkNNK2JKYnJkOW9mdXd5WUdQSkdNRUp1c2NKb2pNNkJubHlDQWIyWWQxY05I?=
 =?utf-8?B?V3RsMElSM2xkWjR3aHhGRFd2bm9KMGJSTk01bDJnVG5zdXVUM0ZveDFVRkdi?=
 =?utf-8?B?RUJiSmVsNWlZMEdaQlBJcFZrR2xIcHNaVVArZDVkU1hYTERtdmVqazREZkhJ?=
 =?utf-8?B?U3VIOU9XZkpLMHdhMW9WUTZRcklsU1Q0RjljSEpEVVVRY09xUkFMSyt1K3lW?=
 =?utf-8?B?Q3JxVDh0MU9CZXdoVVp2Y0RRWExxT0h0eUd6TngzNnFoejNhWlZyNG1DT3RF?=
 =?utf-8?B?YTdrMXFieGFCSUVSRGtTQkI2djMxSVRWK3dvK2hBcGMydWZZQkN6TkFKaEsr?=
 =?utf-8?B?S3NVTHFHYUplNFpxNnREME13NUJxY0hvLzFjelYrd0VXK2tRVEVhc0dlWXMy?=
 =?utf-8?B?MVNOR3RZYnJySzRGWVExQWVZM0t4dy80V1cvek1lbUJ0cWEyUXNJUWlIZjN1?=
 =?utf-8?B?OXRrcVNHNG9lc2tqek44N2IxVnhBWjlxeVpFY3lrRTFvRDU4ZTFnNXFIK3ds?=
 =?utf-8?B?L1QrdGJBcVl2bUNYYmVHSFJROHhwVU4xcFJ4QUlPVnZadmZ4NzdpeGlKbHJN?=
 =?utf-8?B?dThJTzZGVGhlUTJzcW9ycUhQNUR6aS91SitiV2dRNjZsNzNnTHYxbENlcVVJ?=
 =?utf-8?B?K2NpU21GUkt2QWVQTEUzYnZLTGxvQ3pVSENvM2VJcFZlWXRqdG9RZUFUOUdy?=
 =?utf-8?B?empzbnRxWkNRN2RYRDloYkVkdjY3SnZxUU1aRXZMRVFFcEtDZ0EvYkgrZUVq?=
 =?utf-8?B?VnpjbjM4dU0rM1hPalZlTHJhd0ljWTJJNCtMa1Z6dHlyVVRRUVlpSG1CVm0x?=
 =?utf-8?B?MC8wb1Rsd2F4bE53QjEyL2R2cWxqeG1zQnVhWWNHVGx1NVZMTWgybDFKMmU4?=
 =?utf-8?B?L2lQUDd2NkxwM1pFN2NKeCtUSDZ5NmovUURFNUdkZktlcFloV3JycVQ4RXRn?=
 =?utf-8?B?blZnOWR1V3lQWUNJZ0x5c2h1SGF0VW9LNUE5dGtYditPb0J4U1hNV0RIY052?=
 =?utf-8?B?R0UyWHpMc2NGdk1SK2RjYkttRUZQOWMvKzZoV3RmKzNpQVExYTFyNkVQYncy?=
 =?utf-8?B?V2ZJMHdvZDhKbXA4d3Mwa3FZeCtKeURhM2MwLzF0a3VIeXlIWDhrY2k5Ylgz?=
 =?utf-8?Q?xophA/T5/HPHhXBd81QulRL6QTpmDdpuW6aiHbs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd048aa-2523-4cb3-bff9-08d8d827ed34
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 18:22:07.1012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6TT2JN4xZgJXhdvHcvFMicJc8C/cPZhxvWUoGC/FuJbxC7fQkw+NG5Pl+moNljY0aeqOPomHmkZRa3EhuuKksZWdpY3nwtEijoK75NmYyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230153
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 4:05 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we allocate a new inode, we often need to add an attribute to
> the inode as part of the create. This can happen as a result of
> needing to add default ACLs or security labels before the inode is
> made visible to userspace.
> 
> This is highly inefficient right now. We do the create transaction
> to allocate the inode, then we do an "add attr fork" transaction to
> modify the just created empty inode to set the inode fork offset to
> allow attributes to be stored, then we go and do the attribute
> creation.
> 
> This means 3 transactions instead of 1 to allocate an inode, and
> this greatly increases the load on the CIL commit code, resulting in
> excessive contention on the CIL spin locks and performance
> degradation:
> 
>   18.99%  [kernel]                [k] __pv_queued_spin_lock_slowpath
>    3.57%  [kernel]                [k] do_raw_spin_lock
>    2.51%  [kernel]                [k] __raw_callee_save___pv_queued_spin_unlock
>    2.48%  [kernel]                [k] memcpy
>    2.34%  [kernel]                [k] xfs_log_commit_cil
> 
> The typical profile resulting from running fsmark on a selinux enabled
> filesytem is adds this overhead to the create path:
> 
>    - 15.30% xfs_init_security
>       - 15.23% security_inode_init_security
> 	- 13.05% xfs_initxattrs
> 	   - 12.94% xfs_attr_set
> 	      - 6.75% xfs_bmap_add_attrfork
> 		 - 5.51% xfs_trans_commit
> 		    - 5.48% __xfs_trans_commit
> 		       - 5.35% xfs_log_commit_cil
> 			  - 3.86% _raw_spin_lock
> 			     - do_raw_spin_lock
> 				  __pv_queued_spin_lock_slowpath
> 		 - 0.70% xfs_trans_alloc
> 		      0.52% xfs_trans_reserve
> 	      - 5.41% xfs_attr_set_args
> 		 - 5.39% xfs_attr_set_shortform.constprop.0
> 		    - 4.46% xfs_trans_commit
> 		       - 4.46% __xfs_trans_commit
> 			  - 4.33% xfs_log_commit_cil
> 			     - 2.74% _raw_spin_lock
> 				- do_raw_spin_lock
> 				     __pv_queued_spin_lock_slowpath
> 			       0.60% xfs_inode_item_format
> 		      0.90% xfs_attr_try_sf_addname
> 	- 1.99% selinux_inode_init_security
> 	   - 1.02% security_sid_to_context_force
> 	      - 1.00% security_sid_to_context_core
> 		 - 0.92% sidtab_entry_to_string
> 		    - 0.90% sidtab_sid2str_get
> 			 0.59% sidtab_sid2str_put.part.0
> 	   - 0.82% selinux_determine_inode_label
> 	      - 0.77% security_transition_sid
> 		   0.70% security_compute_sid.part.0
> 
> And fsmark creation rate performance drops by ~25%. The key point to
> note here is that half the additional overhead comes from adding the
> attribute fork to the newly created inode. That's crazy, considering
> we can do this same thing at inode create time with a couple of
> lines of code and no extra overhead.
> 
> So, if we know we are going to add an attribute immediately after
> creating the inode, let's just initialise the attribute fork inside
> the create transaction and chop that whole chunk of code out of
> the create fast path. This completely removes the performance
> drop caused by enabling SELinux, and the profile looks like:
> 
>       - 8.99% xfs_init_security
>           - 9.00% security_inode_init_security
>              - 6.43% xfs_initxattrs
>                 - 6.37% xfs_attr_set
>                    - 5.45% xfs_attr_set_args
>                       - 5.42% xfs_attr_set_shortform.constprop.0
>                          - 4.51% xfs_trans_commit
>                             - 4.54% __xfs_trans_commit
>                                - 4.59% xfs_log_commit_cil
>                                   - 2.67% _raw_spin_lock
>                                      - 3.28% do_raw_spin_lock
>                                           3.08% __pv_queued_spin_lock_slowpath
>                                     0.66% xfs_inode_item_format
>                          - 0.90% xfs_attr_try_sf_addname
>                    - 0.60% xfs_trans_alloc
>              - 2.35% selinux_inode_init_security
>                 - 1.25% security_sid_to_context_force
>                    - 1.21% security_sid_to_context_core
>                       - 1.19% sidtab_entry_to_string
>                          - 1.20% sidtab_sid2str_get
>                             - 0.86% sidtab_sid2str_put.part.0
>                                - 0.62% _raw_spin_lock_irqsave
>                                   - 0.77% do_raw_spin_lock
>                                        __pv_queued_spin_lock_slowpath
>                 - 0.84% selinux_determine_inode_label
>                    - 0.83% security_transition_sid
>                         0.86% security_compute_sid.part.0
> 
> Which indicates the XFS overhead of creating the selinux xattr has
> been halved. This doesn't fix the CIL lock contention problem, just
> means it's not a limiting factor for this workload. Lock contention
> in the security subsystems is going to be an issue soon, though...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, I think it looks good:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
> Version 2:
> - extend use of xfs_ifork_alloc() helper
> - formalise "size == 0" behaviour of xfs_bmap_set_attrforkoff() to
>    mean "use default offset"
> - use xfs_bmap_set_attrforkoff() from xfs_init_new_inode()
> - add xfs_create_need_xattr() helper function to decide if we should
>    init the attr fork during create and document why we are peaking
>    at superblock security gubbins to make that decision.
> 
>   fs/xfs/libxfs/xfs_bmap.c       | 19 ++++++++++++++-----
>   fs/xfs/libxfs/xfs_inode_fork.c | 20 +++++++++++++++-----
>   fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>   fs/xfs/xfs_inode.c             | 23 ++++++++++++++++++++---
>   fs/xfs/xfs_inode.h             |  5 +++--
>   fs/xfs/xfs_iops.c              | 35 ++++++++++++++++++++++++++++++++++-
>   fs/xfs/xfs_qm.c                |  2 +-
>   fs/xfs/xfs_symlink.c           |  2 +-
>   8 files changed, 90 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e0905ad171f0..f7bcb0dfa15f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1027,7 +1027,14 @@ xfs_bmap_add_attrfork_local(
>   	return -EFSCORRUPTED;
>   }
>   
> -/* Set an inode attr fork off based on the format */
> +/*
> + * Set an inode attr fork offset based on the format of the data fork.
> + *
> + * If a size of zero is passed in, then caller does not know the size of
> + * the attribute that might be added (i.e. pre-emptive attr fork creation).
> + * Hence in this case just set the fork offset to the default so that we don't
> + * need to modify the supported attr format in the superblock.
> + */
>   int
>   xfs_bmap_set_attrforkoff(
>   	struct xfs_inode	*ip,
> @@ -1041,6 +1048,11 @@ xfs_bmap_set_attrforkoff(
>   	case XFS_DINODE_FMT_LOCAL:
>   	case XFS_DINODE_FMT_EXTENTS:
>   	case XFS_DINODE_FMT_BTREE:
> +		if (size == 0) {
> +			ASSERT(!version);
> +			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> +			break;
> +		}
>   		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
>   		if (!ip->i_d.di_forkoff)
>   			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> @@ -1092,10 +1104,7 @@ xfs_bmap_add_attrfork(
>   		goto trans_cancel;
>   	ASSERT(ip->i_afp == NULL);
>   
> -	ip->i_afp = kmem_cache_zalloc(xfs_ifork_zone,
> -				      GFP_KERNEL | __GFP_NOFAIL);
> -
> -	ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> +	ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
>   	ip->i_afp->if_flags = XFS_IFEXTENTS;
>   	logflags = 0;
>   	switch (ip->i_df.if_format) {
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index e080d7e07643..c606c1a77e5a 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -282,6 +282,19 @@ xfs_dfork_attr_shortform_size(
>   	return be16_to_cpu(atp->hdr.totsize);
>   }
>   
> +struct xfs_ifork *
> +xfs_ifork_alloc(
> +	enum xfs_dinode_fmt	format,
> +	xfs_extnum_t		nextents)
> +{
> +	struct xfs_ifork	*ifp;
> +
> +	ifp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
> +	ifp->if_format = format;
> +	ifp->if_nextents = nextents;
> +	return ifp;
> +}
> +
>   int
>   xfs_iformat_attr_fork(
>   	struct xfs_inode	*ip,
> @@ -293,11 +306,8 @@ xfs_iformat_attr_fork(
>   	 * Initialize the extent count early, as the per-format routines may
>   	 * depend on it.
>   	 */
> -	ip->i_afp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
> -	ip->i_afp->if_format = dip->di_aformat;
> -	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
> -		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> -	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> +	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
> +				be16_to_cpu(dip->di_anextents));
>   
>   	switch (ip->i_afp->if_format) {
>   	case XFS_DINODE_FMT_LOCAL:
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 9e2137cd7372..a0717ab0e5c5 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -141,6 +141,8 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>   	return ifp->if_format;
>   }
>   
> +struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
> +				xfs_extnum_t nextents);
>   struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>   
>   int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 636ac13b1df2..95e3a5e6e5e2 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -773,6 +773,7 @@ xfs_init_new_inode(
>   	xfs_nlink_t		nlink,
>   	dev_t			rdev,
>   	prid_t			prid,
> +	bool			init_xattrs,
>   	struct xfs_inode	**ipp)
>   {
>   	struct inode		*dir = pip ? VFS_I(pip) : NULL;
> @@ -875,6 +876,18 @@ xfs_init_new_inode(
>   		ASSERT(0);
>   	}
>   
> +	/*
> +	 * If we need to create attributes immediately after allocating the
> +	 * inode, initialise an empty attribute fork right now. We use the
> +	 * default fork offset for attributes here as we don't know exactly what
> +	 * size or how many attributes we might be adding. We can do this safely
> +	 * here because we know the data fork is completely empty right now.
> +	 */
> +	if (init_xattrs) {
> +		xfs_bmap_set_attrforkoff(ip, 0, NULL);
> +		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> +	}
> +
>   	/*
>   	 * Log the new values stuffed into the inode.
>   	 */
> @@ -907,6 +920,7 @@ xfs_dir_ialloc(
>   	xfs_nlink_t		nlink,
>   	dev_t			rdev,
>   	prid_t			prid,
> +	bool			init_xattrs,
>   	struct xfs_inode	**ipp)
>   {
>   	struct xfs_buf		*agibp;
> @@ -933,7 +947,8 @@ xfs_dir_ialloc(
>   		return error;
>   	ASSERT(ino != NULLFSINO);
>   
> -	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid, ipp);
> +	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid,
> +					init_xattrs, ipp);
>   }
>   
>   /*
> @@ -977,6 +992,7 @@ xfs_create(
>   	struct xfs_name		*name,
>   	umode_t			mode,
>   	dev_t			rdev,
> +	bool			init_xattrs,
>   	xfs_inode_t		**ipp)
>   {
>   	int			is_dir = S_ISDIR(mode);
> @@ -1046,7 +1062,8 @@ xfs_create(
>   	 * entry pointing to them, but a directory also the "." entry
>   	 * pointing to itself.
>   	 */
> -	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip);
> +	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid,
> +				init_xattrs, &ip);
>   	if (error)
>   		goto out_trans_cancel;
>   
> @@ -1164,7 +1181,7 @@ xfs_create_tmpfile(
>   	if (error)
>   		goto out_release_dquots;
>   
> -	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
> +	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, false, &ip);
>   	if (error)
>   		goto out_trans_cancel;
>   
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index eca333f5f715..4d3caff2a24a 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -370,7 +370,8 @@ void		xfs_inactive(struct xfs_inode *ip);
>   int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
>   			   struct xfs_inode **ipp, struct xfs_name *ci_name);
>   int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
> -			   umode_t mode, dev_t rdev, struct xfs_inode **ipp);
> +			   umode_t mode, dev_t rdev, bool need_xattr,
> +			   struct xfs_inode **ipp);
>   int		xfs_create_tmpfile(struct xfs_inode *dp, umode_t mode,
>   			   struct xfs_inode **ipp);
>   int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
> @@ -408,7 +409,7 @@ xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
>   xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
>   
>   int xfs_dir_ialloc(struct xfs_trans **tpp, struct xfs_inode *dp, umode_t mode,
> -		   xfs_nlink_t nlink, dev_t dev, prid_t prid,
> +		   xfs_nlink_t nlink, dev_t dev, prid_t prid, bool need_xattr,
>   		   struct xfs_inode **ipp);
>   
>   static inline int
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 00369502fe25..5984760e8a64 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -126,6 +126,37 @@ xfs_cleanup_inode(
>   	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
>   }
>   
> +/*
> + * Check to see if we are likely to need an extended attribute to be added to
> + * the inode we are about to allocate. This allows the attribute fork to be
> + * created during the inode allocation, reducing the number of transactions we
> + * need to do in this fast path.
> + *
> + * The security checks are optimistic, but not guaranteed. The two LSMs that
> + * require xattrs to be added here (selinux and smack) are also the only two
> + * LSMs that add a sb->s_security structure to the superblock. Hence if security
> + * is enabled and sb->s_security is set, we have a pretty good idea that we are
> + * going to be asked to add a security xattr immediately after allocating the
> + * xfs inode and instantiating the VFS inode.
> + */
> +static inline bool
> +xfs_create_need_xattr(
> +	struct inode	*dir,
> +	struct posix_acl *default_acl,
> +	struct posix_acl *acl)
> +{
> +	if (acl)
> +		return true;
> +	if (default_acl)
> +		return true;
> +	if (!IS_ENABLED(CONFIG_SECURITY))
> +		return false;
> +	if (dir->i_sb->s_security)
> +		return true;
> +	return false;
> +}
> +
> +
>   STATIC int
>   xfs_generic_create(
>   	struct inode	*dir,
> @@ -161,7 +192,9 @@ xfs_generic_create(
>   		goto out_free_acl;
>   
>   	if (!tmpfile) {
> -		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
> +		error = xfs_create(XFS_I(dir), &name, mode, rdev,
> +				xfs_create_need_xattr(dir, default_acl, acl),
> +				&ip);
>   	} else {
>   		error = xfs_create_tmpfile(XFS_I(dir), mode, &ip);
>   	}
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 742d1413e2d0..262ea047cb4f 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -787,7 +787,7 @@ xfs_qm_qino_alloc(
>   		return error;
>   
>   	if (need_alloc) {
> -		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ipp);
> +		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, false, ipp);
>   		if (error) {
>   			xfs_trans_cancel(tp);
>   			return error;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 8565663b16cd..ab42f6e0d26e 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -222,7 +222,7 @@ xfs_symlink(
>   	 * Allocate an inode for the symlink.
>   	 */
>   	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
> -			       prid, &ip);
> +			       prid, false, &ip);
>   	if (error)
>   		goto out_trans_cancel;
>   
> 
