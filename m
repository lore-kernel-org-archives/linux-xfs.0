Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90891C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 23:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444480AbiEFXrn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 19:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359057AbiEFXrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 19:47:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33097712D4
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 16:43:58 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246IX2g4027785;
        Fri, 6 May 2022 23:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=F+32L1H9iR5aLkezk1/X7TYpgdODIIXn8/FHRzxOg9Q=;
 b=GOUkFOeAeac8fus3WhTg6rEMGV0r0RMuyLPlAphgZxtIBEck5zJCeCUwJIc9eEnHMSUT
 xVGyIny69siGwg9nY7NryNH5LiEgBWKqWTz16xu4iNig9wNtU1rtQaLysW5pdXnf70NT
 QhpLfjJ+yKKU7BZrx5K67GLN5dOy6YNnowKJ5sCHx7zQX/fwwJ4GfSM4LSATTcMJeYE4
 6b3obENFj0XRkoi8e75+piG1hYRe2pLeqLDzkx1N3hCpP0L8JFJ67Jkwq3WZNDY9ybD+
 ymc33+qXbdkTp8+eHDRHIS6qcnEI9lT4FYIW8I4gVqGUqekDzWMakLIgiD/W4dUUmeRX ng== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2qa98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 23:43:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 246Na0nn013381;
        Fri, 6 May 2022 23:43:56 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fusajgf7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 23:43:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhVWDOjmSW6xtMQpWBcDyyxWfvkmF2pa4PZG2xeJe5cXnBl0/BqnzJDRvAyeu6YeEFRWUwRQS8qOYQQMtxVr51dq9NAABUxqrzVcgpSGg/y+g0IyEMPbXh3kHARWzOEQXZLsLKUJTLioDYNxaWamf1aHE7L3UKOtvpAWLV2fich2ZlOPz3t++m+B3Bs//iSFtNArb9tKBnzWYHA7ot+DAzNE/jJ/q5XM9qfME7JHOEUOk5ZOW9pDvTKHvDSKbTX66y1BTFuQ3wpIw9xpZpXw3efmpZVq2R3WFswj6RFgStFR+/Z33S1svwkHPvn3Sfn3vRZMxrtI5EHwNztXeEy6IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+32L1H9iR5aLkezk1/X7TYpgdODIIXn8/FHRzxOg9Q=;
 b=a8aiZPxVHWE9mk0GxBLBAlCmt9Cu0pUKoTVj0pEkzp4OpAWEX1m+Z8TrnyWNdUlk8zgWlEQrVXVbV8EsCwrwNME+io88GqpyUnR3s+qSjkkzBB+/zXn2HPI0XUAoULicT2oarFVw+qyIPj/IcK/wwRJ6fiiFexBpw1O6+1JuP8fjKT855PvecpjjUi/f8g7TT4YbJbcOWq0XWFSND+1P/AXnzI9HwhLDx0bqsCZ5E30eZXWcs8O2S1+I5LWDfkwZ/2/dSEk+t90EbAS3HYrHQXACqBW8vcqsvlJPGok8B+nWvv+5i9tjp4Tp4vHYOKeSgLKFpdQQL8qOeG0r4UYAdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+32L1H9iR5aLkezk1/X7TYpgdODIIXn8/FHRzxOg9Q=;
 b=xIxKML/tUvu1jEV1BCCqQaU+hbD2PmqgewZpmbDcaNrqdrLCcls4tMYdUGgVzdktpzThtDhFr+F2KNBqMY7jMuloJWNkL49Dhq7wQALjchnJl4/+OgA+e/QCdBVL/HoRTWKMMsiMFQHF4UQZ3FqFg+Tc7sXI+NlgJLFdA9b9XIs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3761.namprd10.prod.outlook.com (2603:10b6:a03:1ff::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 23:43:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 23:43:53 +0000
Message-ID: <df1dcd11949ececee3c118b9758c21cff6f33639.camel@oracle.com>
Subject: Re: [PATCH 04/17] xfs: rework deferred attribute operation setup
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 06 May 2022 16:43:51 -0700
In-Reply-To: <20220506094553.512973-5-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
         <20220506094553.512973-5-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:254::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f5f2eef-0e02-40e6-1691-08da2fba4723
X-MS-TrafficTypeDiagnostic: BY5PR10MB3761:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3761215AD14A9625DDFC2E7E95C59@BY5PR10MB3761.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aG970W4SPeMAMT3WV8sNmEPvs98tuCcwHByOxzKFilomWRP+g09LKpehMHjZXuhzFZcnEHL57OOFpZ2mwsTd+k/LEZvbY5vqmhPb2n7OcgxRAX7Bxgwbk9sjbDLjzqRMIbYDjjHyPsMXfL0uj+PbfBakUblErMMtWiA1Zm3KctNIOMgUnTJCZO6d4nE6NmNg+GfbZIr5ow7pRYnYT+O1YgVHCGRUb2YMpSZ9irDAzKeqcW6s7pjcfg9KL6VexnPrL8gPB8mEIAUfBLs+EtPiJux/FHdK4x+xkPNpW4fGYtep7umgEAfdk3I0M0czO26vYwttv1J3MBYMnuPFj6ujhobkv/8Co7fHaOSUfBFeT8bh3uTPjxgj/RTuKd3TqRPlNCcnMARcqUMMKONZC6xMRdWhJrs8k+WipMx2Qs1FrLNsacpRfqc5MEUtAZiF4dE+F5il11D/m2wax6P+KlfQfJSM6rIxGrqVj4vj8JoGRQGTU6sVlI7IREkUpsairWpAhLiNNF5ilgPxavmb39K5axPnFR5n3IrIUEKOPfD1kCSn45W4tBdOceelyEGuWXZsMZMb6F+5ObEn6qtADq4/Ff16gw6c6CC5v47iaGWYrDJsg7uwdQqYwefpMD23ExXTgsoeHHoU4l+HuqDj6GquxmTnptZjJ7BEw7XHA1cuv+9EPuF1JaNoKVAi7j9UuW/yBNhbN864Q8TREjHawFRiSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38350700002)(5660300002)(186003)(6486002)(38100700002)(8676002)(66556008)(66946007)(66476007)(2616005)(508600001)(2906002)(6512007)(6506007)(26005)(316002)(36756003)(86362001)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEwyTGpNd1FHb05zR1c1SkNLbUlwdnFkd1U2K25DdWVULzBFSm14TG5pZEVt?=
 =?utf-8?B?N1pvcHpPOW9BSlAxMGhIZHBjYzFKeG9QTEF2VldoVDRaMFZMRnVFbDQ3SzBO?=
 =?utf-8?B?aHpGc2c5L2VuMjV4dzYzSng2ZmVwbkVURFg3LzZJUjYvbENDOE9VNDhqSzlB?=
 =?utf-8?B?dTNPcVJpR1ZQcUk3YzNYdjk3ZG5NaFJVV0p4MVc1dlJFclhDZ3BVQTRHamox?=
 =?utf-8?B?NDB3Y0dWZEk3V0h0UkZMakd6dzY3aFZDd1o2Zmd1Z2IxSElJTHpHVVV2ZWQ4?=
 =?utf-8?B?TURoMGMxUy8xbjh5YWZGeEI0RVJ0YzJyaVNGcGZpYzhWYnU2K0VjY1VvUEdL?=
 =?utf-8?B?cnZ6TUtaRTNBRXNOY05aa3NZeVlObUNQWkJzb3hoWmdQVGlQMDZucEpDbGRK?=
 =?utf-8?B?eWZXZ1dMcDlvTWhXN1VDa2FFMzd5bHNzSnlDTU1yQWEvcXpiQUFxOGFwRURs?=
 =?utf-8?B?NHhzU0FYakJ2d1VBbXpNSmpGNnFHY2RXQ0JPSFlwRWxQNWl2VlJkT0t0ckJw?=
 =?utf-8?B?cTRzYzFTdXhySTJwUkZwclJJS2xma3lmcWtNMTdPZXpwODhMY1NCMFZ4eXJ3?=
 =?utf-8?B?d2VwTm5zQUFaUC9CV0gwcnNpV3BJeHFrV0xNYWhvc3ZYbXNxcmdtUHU2UnJD?=
 =?utf-8?B?NWZkTWpjMU9xQjhDa2NUUWptT2VmV0w2czhUVU4rUkxHVDBIdlBXT1BHaUsz?=
 =?utf-8?B?Z3NpSUs4Y1djbjR6eCtpcWg0WUx6RWszTWlKaU5LbDNmVHRHNzkvRVJYOFJI?=
 =?utf-8?B?VzB5QURDR1QrcExNcVE4YzQzTTRwM01vTU1uQ3daa3BoUEJMU3J2MUUwQ2JY?=
 =?utf-8?B?UWRWdEdQK3QzejR1R1Z6REkxeFZ2aWFvZDRnK2xYTU8xNERpMTIwcS9LcDlo?=
 =?utf-8?B?RWZnZjhyY1FSMFBkMXpaVTRwdG5nakNnc1lDS042SzZtZTM5dy9Cb0VpekFj?=
 =?utf-8?B?NGdHaGUvaTd3WVdCYzUrSkIvK0NIMjdweWhsaG9lcnU1R3ZLaUdPZEs0TkFU?=
 =?utf-8?B?SjN2a3VDdkVxNTFxMmh3RnVhWnJNNlN1QU5GOTA1NkYxUDkyVkNxUWZUREQz?=
 =?utf-8?B?am9Ba0FQUGM0Z0ZpYUthN1VYN0FwODVXZ1g5NUJ6SW1abFVuL2tMTW5MRFlM?=
 =?utf-8?B?QlM4bFh1YU9jMFdBUEtWa2pIUHA4OFhLZm56N2FSM2dCWm85S2t0bVZTWW03?=
 =?utf-8?B?YkJ5ZTFrMFEzU09MZjJERGdNRmQ4ZExrVmNqWTZUejdheE1lY3dMcEpyM3Y2?=
 =?utf-8?B?RlpibTgxa1gyaWJKMy9CMkFtcmRQeVRiNDZZcmxOUzV0NlhiWDkyeW5vVlNl?=
 =?utf-8?B?KzF1elFWQjBZendlbFVZcExLYVJ3OWZCKzQrL0VXM0JyY1RlNTZyVXNPS2pz?=
 =?utf-8?B?eHpoZ2tpdzk2c1BQcldPbWM1VHNoaHR5bU9IUUU2V0hZSkdhWUNnQlNXc045?=
 =?utf-8?B?K2JqQnQ4Nkl2T0FGZC9YQ0UvdTJVWE41bEp0ajBiUzBsMzdjVzU0eFpTYlpo?=
 =?utf-8?B?My9OZVlGc2xWa0lMWklUbEhXM1d2ZUtwTVI4Qi84WWkzOFp1RVhmZDhubUFm?=
 =?utf-8?B?aG5id2FneUlFbWltVG1seTBXT0N0TTZIM3RVNCsvM0VzQkRHR1RMOVJYNTlJ?=
 =?utf-8?B?cDg2UDVsT2t5SE1Fayt5K1VDZlo3bDJjVXdtN0VnMksrbFpZRXF1UFJneFc2?=
 =?utf-8?B?bFg4SDlaM1FDZGlXcFlwb0NnTUNici8yZnZQKzFSa3hpQ2tWbGVvUVU3YnhZ?=
 =?utf-8?B?c2c3SDlYeGxXaUxORGZqTktibFZDWTgvQkczSG4yMGxQR1FJVHU4NDJyK0FM?=
 =?utf-8?B?dDJQbjh3bXpmTzhxYmhUVzhSVVl6ay9JNEVteUhUSVJaQTJJVUNVT3BxRGtS?=
 =?utf-8?B?ZGhHRitJVU9jSE93YmswRDZtNjY4TzVvcGJxc0h4Z05aaDU0c3RKUzhmNDdK?=
 =?utf-8?B?QnJUZC9DdTdZeFJxSHJHR01qNWdOczFRNS9DMXUxRFIrcUJocHVBTFVmRnRp?=
 =?utf-8?B?cWdzZGZrbXE2bVp2MS9NYm5jbVRGRTIxK2dtUStZaGZqR1I3QXpOWE1haUtU?=
 =?utf-8?B?SHVhaUN0WEo2Tkg5R2Z4SjBPRjlLL3FCNGlwZ3ZkYm9FWFd1QW9EbGZCZVN6?=
 =?utf-8?B?dlVpWWMxU2pLT0xXMEcvZmxUNytaM21WNXJsbzFweXdueUFGZm9abmlGMkJQ?=
 =?utf-8?B?V0RjaWFYVXM1U1BPbGYrQzdsaXVFZkJoY25sOFdWZ0ZOVWVGWFVGZUlzdC9M?=
 =?utf-8?B?a2F5VEtWV3hJMGVxY1l2citSOFdHWGxSVWd3L1VKNGVjOTBFanNaTnc5Tk5Z?=
 =?utf-8?B?Q29GTGNiUHo1cGhwemV1ajRDZktUTTdGakRSZzJsVHo0YlNtaEUxZDlFS1o2?=
 =?utf-8?Q?Fne5V/Yx9FeRNYew=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f5f2eef-0e02-40e6-1691-08da2fba4723
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 23:43:53.2125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vW2hdXe0O9SJ+WkcvhMKAEuwE1NXkDygFadP5XRONkiupwM3BKOCBX46NyUAhqcvLkW50O/A2EpPZwpXp0sO1dAdsy6M5tJaEkEuIJqwpUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3761
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_07:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060118
X-Proofpoint-GUID: PjpA-EQ_IpcY1BAj4jhApRd-xrRLYPnv
X-Proofpoint-ORIG-GUID: PjpA-EQ_IpcY1BAj4jhApRd-xrRLYPnv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2022-05-06 at 19:45 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Logged attribute intents only have set and remove types - there is
> no type of the replace operation. We should ahve a separate type for
> a replace operation, as it needs to perform operations that neither
> SET or REMOVE can perform.
> 
> Add this type to the intent items and rearrange the deferred
> operation setup to reflect the different operations we are
> performing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, makes sense
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c       | 165 +++++++++++++++++++----------
> ----
>  fs/xfs/libxfs/xfs_attr.h       |   2 -
>  fs/xfs/libxfs/xfs_log_format.h |   1 +
>  fs/xfs/xfs_attr_item.c         |   9 +-
>  fs/xfs/xfs_trace.h             |   4 +
>  5 files changed, 110 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a4b0b20a3bab..817e15740f9c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -671,6 +671,81 @@ xfs_attr_lookup(
>  	return xfs_attr_node_hasname(args, NULL);
>  }
>  
> +static int
> +xfs_attr_item_init(
> +	struct xfs_da_args	*args,
> +	unsigned int		op_flags,	/* op flag (set or
> remove) */
> +	struct xfs_attr_item	**attr)		/* new xfs_attr_item
> */
> +{
> +
> +	struct xfs_attr_item	*new;
> +
> +	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> +	new->xattri_op_flags = op_flags;
> +	new->xattri_da_args = args;
> +
> +	*attr = new;
> +	return 0;
> +}
> +
> +/* Sets an attribute for an inode as a deferred operation */
> +static int
> +xfs_attr_defer_add(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_attr_item	*new;
> +	int			error = 0;
> +
> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> +	if (error)
> +		return error;
> +
> +	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> +	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
> +
> +	return 0;
> +}
> +
> +/* Sets an attribute for an inode as a deferred operation */
> +static int
> +xfs_attr_defer_replace(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_attr_item	*new;
> +	int			error = 0;
> +
> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REPLACE,
> &new);
> +	if (error)
> +		return error;
> +
> +	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> +	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
> +
> +	return 0;
> +}
> +
> +/* Removes an attribute for an inode as a deferred operation */
> +static int
> +xfs_attr_defer_remove(
> +	struct xfs_da_args	*args)
> +{
> +
> +	struct xfs_attr_item	*new;
> +	int			error;
> +
> +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE,
> &new);
> +	if (error)
> +		return error;
> +
> +	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> +	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
> +
> +	return 0;
> +}
> +
>  /*
>   * Note: If args->value is NULL the attribute will be removed, just
> like the
>   * Linux ->setattr API.
> @@ -759,29 +834,35 @@ xfs_attr_set(
>  	}
>  
>  	error = xfs_attr_lookup(args);
> -	if (args->value) {
> -		if (error == -EEXIST && (args->attr_flags &
> XATTR_CREATE))
> -			goto out_trans_cancel;
> -		if (error == -ENOATTR && (args->attr_flags &
> XATTR_REPLACE))
> -			goto out_trans_cancel;
> -		if (error != -ENOATTR && error != -EEXIST)
> +	switch (error) {
> +	case -EEXIST:
> +		/* if no value, we are performing a remove operation */
> +		if (!args->value) {
> +			error = xfs_attr_defer_remove(args);
> +			break;
> +		}
> +		/* Pure create fails if the attr already exists */
> +		if (args->attr_flags & XATTR_CREATE)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_set_deferred(args);
> -		if (error)
> +		error = xfs_attr_defer_replace(args);
> +		break;
> +	case -ENOATTR:
> +		/* Can't remove what isn't there. */
> +		if (!args->value)
>  			goto out_trans_cancel;
>  
> -		/* shortform attribute has already been committed */
> -		if (!args->trans)
> -			goto out_unlock;
> -	} else {
> -		if (error != -EEXIST)
> +		/* Pure replace fails if no existing attr to replace.
> */
> +		if (args->attr_flags & XATTR_REPLACE)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_remove_deferred(args);
> -		if (error)
> -			goto out_trans_cancel;
> +		error = xfs_attr_defer_add(args);
> +		break;
> +	default:
> +		goto out_trans_cancel;
>  	}
> +	if (error)
> +		goto out_trans_cancel;
>  
>  	/*
>  	 * If this is a synchronous mount, make sure that the
> @@ -845,58 +926,6 @@ xfs_attrd_destroy_cache(void)
>  	xfs_attrd_cache = NULL;
>  }
>  
> -STATIC int
> -xfs_attr_item_init(
> -	struct xfs_da_args	*args,
> -	unsigned int		op_flags,	/* op flag (set or
> remove) */
> -	struct xfs_attr_item	**attr)		/* new xfs_attr_item
> */
> -{
> -
> -	struct xfs_attr_item	*new;
> -
> -	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> -	new->xattri_op_flags = op_flags;
> -	new->xattri_da_args = args;
> -
> -	*attr = new;
> -	return 0;
> -}
> -
> -/* Sets an attribute for an inode as a deferred operation */
> -int
> -xfs_attr_set_deferred(
> -	struct xfs_da_args	*args)
> -{
> -	struct xfs_attr_item	*new;
> -	int			error = 0;
> -
> -	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> -	if (error)
> -		return error;
> -
> -	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> -
> -	return 0;
> -}
> -
> -/* Removes an attribute for an inode as a deferred operation */
> -int
> -xfs_attr_remove_deferred(
> -	struct xfs_da_args	*args)
> -{
> -
> -	struct xfs_attr_item	*new;
> -	int			error;
> -
> -	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE,
> &new);
> -	if (error)
> -		return error;
> -
> -	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> -
> -	return 0;
> -}
> -
>  /*==================================================================
> ======
>   * External routines when attribute list is inside the inode
>  
> *====================================================================
> ====*/
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index f6c13d2bfbcd..c9c867e3406c 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -521,8 +521,6 @@ bool xfs_attr_namecheck(const void *name, size_t
> length);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>  void xfs_init_attr_trans(struct xfs_da_args *args, struct
> xfs_trans_res *tres,
>  			 unsigned int *total);
> -int xfs_attr_set_deferred(struct xfs_da_args *args);
> -int xfs_attr_remove_deferred(struct xfs_da_args *args);
>  
>  extern struct kmem_cache	*xfs_attri_cache;
>  extern struct kmem_cache	*xfs_attrd_cache;
> diff --git a/fs/xfs/libxfs/xfs_log_format.h
> b/fs/xfs/libxfs/xfs_log_format.h
> index a27492e99673..f7edd1ecf6d9 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -908,6 +908,7 @@ struct xfs_icreate_log {
>   */
>  #define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute
> */
>  #define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
> +#define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
>  #define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>  
>  /*
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 5f8680b05079..fe1e37696634 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -311,6 +311,7 @@ xfs_xattri_finish_update(
>  
>  	switch (op) {
>  	case XFS_ATTR_OP_FLAGS_SET:
> +	case XFS_ATTR_OP_FLAGS_REPLACE:
>  		error = xfs_attr_set_iter(attr);
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
> @@ -500,8 +501,14 @@ xfs_attri_validate(
>  		return false;
>  
>  	/* alfi_op_flags should be either a set or remove */
> -	if (op != XFS_ATTR_OP_FLAGS_SET && op !=
> XFS_ATTR_OP_FLAGS_REMOVE)
> +	switch (op) {
> +	case XFS_ATTR_OP_FLAGS_SET:
> +	case XFS_ATTR_OP_FLAGS_REPLACE:
> +	case XFS_ATTR_OP_FLAGS_REMOVE:
> +		break;
> +	default:
>  		return false;
> +	}
>  
>  	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
>  		return false;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index fec4198b738b..01ce0401aa32 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4154,6 +4154,10 @@
> DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_defer_replace);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_defer_remove);
> +
>  
>  TRACE_EVENT(xfs_force_shutdown,
>  	TP_PROTO(struct xfs_mount *mp, int ptag, int flags, const char
> *fname,

