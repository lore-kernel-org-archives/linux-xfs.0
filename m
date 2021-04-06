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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9302EC433ED
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 20:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B895613CC
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 20:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347151AbhDFUHj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 16:07:39 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34824 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbhDFUHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 16:07:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136K50tl190876;
        Tue, 6 Apr 2021 20:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LruRcvq+j5meHx1StPXSYuj5ak5A2JyQgIV3fDRoPok=;
 b=T9RFZxW1D4e2j22SWO0kx84c8vFiVtBZyclhSEGzNdEzSMX/kiMdZO3tWWcTQp5KbPWs
 k2ogwSyMhFi+1RJ7f8mrX8nq3No+0r4Cs3Xw9TWih5E4OgUm14yEP8EkOuPIYFqvbg7R
 NRk8h+GbY6tWb4KPmL1f9BQFEV0j1Qy5btswex26X8knwftLv8mLJxVp1hbFWSacq+Yi
 BXlBAODC6/ng4FKgGZs7mClq3+yWibsUJgBp+pfDkUoJfBeXL7xuCsb+EsBxwYS87SoQ
 YZ7Xd4ZJUn4/1ppnJIy+j5zfOZsrVuxjX4V/VYijdW12T4Mex1Fk8lgyYbhjPaNMvVxa Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37rvaw0cvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 20:07:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136K13Zs149310;
        Tue, 6 Apr 2021 20:07:26 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by userp3020.oracle.com with ESMTP id 37rvaxn77g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 20:07:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DE3vQ7dRuJYtnh+yGAFMjTgTGzMkvwCt3f5dQlyKhwNhC7NayV8gU5KM0DpwWMItLq4NeUHiYZBO+zH3BAGPILkGW2RG7TVAIgyaL6d0NVkgdLIhFTNBKiBpqIFKZZA6u11jzEVOOAlZTF/E3JSg/lxKMC69IN8D+N3AkZf0HuhZCvwdcyM2lK+d6xsl9NGmfKh3sZ8aY0KC2FeBMcWxZ3VK/id7E/VaWCr7kOw7jyyP/GhwgOnaRk92mlBmyciL15EHutpwmgT3syZqnmIQoVBSDyf8I0rTph+8kun6MlOeTBq1Wc4IRrZP4NZK2R3QL6hqEhkJibtDaFLXVrc1xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LruRcvq+j5meHx1StPXSYuj5ak5A2JyQgIV3fDRoPok=;
 b=IvzM9bN/VK8NQBozYLJvU3vbS7LElGw4hvyV9/lmaidQ/MPbr4kaDnd0Q4BrH9epSLgQVasvMRzI/zUgCKI2AMiVKP77kxpY1gCDpHZ/svHaRujvFe1I7XEOMyeCU520BHhnzrClqr96IxrqADcVX0lPXtRlIjfi4NluGWBBvhL/dqgWedzV47Pn2X/ZxqBCFuDYWd7A1xndWN6z8pow4a6FCmxpzKBZ+zziXJxPMV+V7yG38fvOLC/FnFn4ln91SIZopfU8K3EtbFAD1XEsYR4Zxn7CUXDO7JjdLq0n9o8fKC5FAZPffLTbCu7a3N9jwecqkxaWOORVx2Cd+I+4hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LruRcvq+j5meHx1StPXSYuj5ak5A2JyQgIV3fDRoPok=;
 b=k5AqqKtUn/zWb/537d3vKii5SHAV6endvphuDsIke367anQTncuCIlEU+znAzz5vzHjBOoXmeQKZwghTc+sk3kAEypEs1/1bkPbQXEA9tzygwm4pV459nhTgRC7+JBsIZMajPQwUYIdZwClXdOjOtGFbuSPjcNF9KfAjvenij6E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3111.namprd10.prod.outlook.com (2603:10b6:a03:159::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 20:07:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4020.016; Tue, 6 Apr 2021
 20:07:24 +0000
Subject: Re: [PATCH 1/4] xfs: eager inode attr fork init needs attr feature
 awareness
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210406115923.1738753-1-david@fromorbit.com>
 <20210406115923.1738753-2-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <32ce2147-c663-6091-0b7e-cbbbaa526802@oracle.com>
Date:   Tue, 6 Apr 2021 13:07:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210406115923.1738753-2-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0151.namprd05.prod.outlook.com
 (2603:10b6:a03:339::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0151.namprd05.prod.outlook.com (2603:10b6:a03:339::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 20:07:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5b9f308-e981-4aa4-0760-08d8f9379821
X-MS-TrafficTypeDiagnostic: BYAPR10MB3111:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3111836F1B96A9EEA23EBE4C95769@BYAPR10MB3111.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/keU31i/YCjjiHmK2eQan70sYf2GM0i7uT9JLgBayrhhiIH3os4kyqGPrGaWDD4HRvy0Chi2oyilL6HG2p6YZXb7omQ5hfhgG6RRWM01pEyeM8QlLx2Sisb2jMQ/z7g8/r1w+5BAPa8XWyUZfEy4UdO16uYOI09EqDj+CI9KW2m+nKqT7aDITx7WjLqWyMqTCnDJdnyp6WJtQmVs3UwWn8xgVOhZOBzjbFgt3btsb968p7cmJgiuQXROp37Tub2PI8DZSIqkrMHCm35T3rgRJOK0bFkE4VyL5IUnO3MN75m1cXztsAz5b772xV1jyCP8TNnFpi30U0wkTD1n7DLDbtYeDcq+GG8a9qW6cq6bNs1B24hllZeNtaYMXA8zbu0p62eIM09PMCOccYcjKfLhOmDwDmRswLBx0XmBigzeCXZpCmouVq2TLDzcGSzFyO2sWzXQDJHDTF3Bm/usx6mpwkY0SAhtm0yHgfhRzBkxPdUJq3mRdiaOn/eCw/K0vNlOgb6XqQ9LetCbLFjpaCFcK1itY/ZBf6YUz9ys3AE0YKsx2DM+Dy3+ImMrNo40rHXRYSOGyJn7ZZBoCwBqXd7jxt2PmZQLaXHb4U7y/ahUHogTdSZ/Awjk9cjGhyYWTgzK3inuRaFdVAAgmmfcy8Zeu7awCfUw+hEggxXGmvQZozdMxOBXC30LYJWGzI5f1fWY1voojUj5+a1feU+m+3fRNfIKk4aBostgcl9hjrK8VE9QEtJI4jB7uX0U/r0/1MM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(39860400002)(376002)(52116002)(16576012)(38100700001)(31686004)(8676002)(316002)(66556008)(44832011)(86362001)(8936002)(16526019)(38350700001)(5660300002)(31696002)(83380400001)(66946007)(6486002)(2616005)(6666004)(36756003)(186003)(26005)(956004)(2906002)(53546011)(478600001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OVZIbXhhQXRBRCs2UEJOa05aSTJpMGRPZ2d2Wk54Z1BBM1FHelBDWEJDUW1Q?=
 =?utf-8?B?UHNMUldnQ2tId2VKY0xibzJXaWNOUThOQzZVbDNQUTJZUTczaU1ZdXdWUmpJ?=
 =?utf-8?B?SzdpYkpsbFgycm9lSnR3VXNBTXdEMm5tak1Ha2svcUVZenBuRGpYY2ZQVDdm?=
 =?utf-8?B?TGhoMXVYVGNFMlIrZEE4RFRMc1UzQWZLakxLQWxwVGFNZGtrWUg1RFJjYWl1?=
 =?utf-8?B?dzY0WHhEb3lJYURwQ3kxNTZMcUk0SkN4aXVIR3pKbHBjclpXOUNoMmlKUGND?=
 =?utf-8?B?eDM2b3FwZDc4QmpoQmlHY2Z0cnZGOHo1Z2FVR3BWMDBjeThsK2Y4VWdjRHJV?=
 =?utf-8?B?V2lURnppL25Ia0gwNzJtMzJ1aitYMHgzd1lYODkrZmtsOEkzblA5dzhYejcy?=
 =?utf-8?B?ckFXTUhOcTZrdS8xZEhVYmFhSVpkZmdBSHF1Q29iMnEzTXVZTUVqcE1CVXdT?=
 =?utf-8?B?UDJFQXhOY3hYTFU4aTdOckw0cEZkYkVoRExMNDVwU0J1Wmc1U040L3pvamIz?=
 =?utf-8?B?dnZDdCszTUZpbURic0VvK0NCblB4dkcrZDBaYlB3WWYzWlBEVkIwUlNaNVFP?=
 =?utf-8?B?TG8rVXFxd2dhRFdlMDI0WHh6Qyt3MjB1TXBIRDdDUGErQmhUekk3cjc2cU1z?=
 =?utf-8?B?eDl4eHFxMTNKMHJKdG9VR1Q1TkR0alBscGVxWkF4MWJMRng3WjByVHBRRmVi?=
 =?utf-8?B?Q1hpcWx0SjJwU3RNemU2dmQ3U1A0TE01L2ZLV0hMN3lmQ1VMRnF3RFBoc0pj?=
 =?utf-8?B?L25GUU00dTNrdVl1VzA4OEk3OW9CK01FR3NGYmVXbHBuR3d6aHJtOUJxcEgx?=
 =?utf-8?B?WHdTZkVYZTFzNHRUYy9LeFpBVFlEMEd0N3o3cmRZYzhKMEY2RkdFNmxvbFRq?=
 =?utf-8?B?YjBZREtuWXIxL0tQR2VhcXZvV2lGbEdhTFo4emFTTDFtQmhXek1Na1F2RmxI?=
 =?utf-8?B?MWIyVkpldG9NaEM5aDBwZFRHNlYwdXdDN3BFU1VxemQ1VHExQnlTcVR5N0JK?=
 =?utf-8?B?Tmc3bmhBMXBvR05mZlk3WUFSZVFERmgxd3JiYkpCUGdZdE51NkZtSkFpR2Zu?=
 =?utf-8?B?dktLazNic1ExaWhncmE2RjY0MGRQaDBRcDNVd2F3WjlQSEhLUEgvQXU1NGFE?=
 =?utf-8?B?KzhtV3ZrK2thNEFCU2tKRVBUc3l2S29LYUNWQ2RHUU94UENxandQaXJrejQ1?=
 =?utf-8?B?R0tkSU1zclV4RjNGQXNjWTZ1ampzaXdQWUQyR2VpaTM3UHhYSzA1alI2Smcr?=
 =?utf-8?B?b29vU1ZmOXFrcGUwVGlTWFMzSFJUQU5remZKZ3EyRzZIc1BxbkR2VTdkd3lh?=
 =?utf-8?B?MUhRMkt6UlNGcGhiY3JYM29sbW13Rk5tQnZWWHBCSWJLbittOWtPaW0wOGU0?=
 =?utf-8?B?K3ErNGN4NjZXWVoyN2lnZXBOdldMY1lUdmw5d1llSy9Ka0lXS0k4MWJuc1pJ?=
 =?utf-8?B?ODBHTWxmQ1JvZHBxU01Fb3prL01JZzRIUnFQUVhneXp2YTRDWWJiMWdnR1Vj?=
 =?utf-8?B?bUE4d0hWbVZTZWZ1MHN6cU15V2ZEZnlxNjZDRXVhVTVKYXh6SlZNSkVFSk9H?=
 =?utf-8?B?V3hzT1owaDhTMitCTStYaERja21sRkh2T3JqUWlINEk3VFNUeDRUNDhpRTY2?=
 =?utf-8?B?WVBhb09oSGk1TVphNXF1M1MzU25pWXdpb0I1V1BrWlZJMzFHRE1IZUVnVUhG?=
 =?utf-8?B?Tm16TE44TE5YY0I4KzJLVmFsMGIxSEVXWnJobnBLdUNwSFpCKzdQYXV1TFdM?=
 =?utf-8?Q?qZX8leTJKO9+iNnYEzNph1fVy9OaxAXmdktj1/J?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b9f308-e981-4aa4-0760-08d8f9379821
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 20:07:24.6472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +NxvmIvNM3l5CnjQie4d4HzCUX+b0+UQrDyRmImmRzxQRyIgq3fTKB1S+S+/whd3GdkYzppS8ubAm+RHk1OTgVniJDrgditIJl5M7HrvCaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104060136
X-Proofpoint-ORIG-GUID: P-3qgzqRK-p-jh197bwZjCYm54Rrt-Nh
X-Proofpoint-GUID: P-3qgzqRK-p-jh197bwZjCYm54Rrt-Nh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104060136
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/21 4:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The pitfalls of regression testing on a machine without realising
> that selinux was disabled. Only set the attr fork during inode
> allocation if the attr feature bits are already set on the
> superblock.
> 
> Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c09bb39baeea..3b516ab7f22b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -887,7 +887,7 @@ xfs_init_new_inode(
>   	 * this saves us from needing to run a separate transaction to set the
>   	 * fork offset in the immediate future.
>   	 */
> -	if (init_xattrs) {
> +	if (init_xattrs && xfs_sb_version_hasattr(&mp->m_sb)) {
>   		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
>   		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
>   	}
> 
