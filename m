Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B487C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 10:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351081AbiDLKBD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376325AbiDLHn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 03:43:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FBA457B9
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 00:27:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C3WwkM008887;
        Tue, 12 Apr 2022 07:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ACnaDsycaFNFFEKizdqUJ13uUvZ8rFMAV0wL3QWB4RE=;
 b=id/ap8uWKYnVP6bN5ir3YxIHc9ohmeFOkxwrywoMQi0EPR5oO3SGJMJWYTGiAnSNimJq
 WjP+NPBKY0kMa6TLfJo/atBv5LA+aM7fhijqjFJ5cm8XfWdh+9dKwmT/KotD4oMObugy
 4xOsbSYgChywvNS0qiaz5lwLBO5cwQwo8fqveJa7QIl6Ircg5LdeLrPc7cC+vPMhX84R
 lCJZ8zJxS4vxJfj/IXfbfCSEiSKDWx7yRqZn3/JIIaEmgVZW8GoE5sqQcwRHe78SskhN
 z7UKORkpeqMzx7mwo35DCxgla13S9L8Q/KENKzjC5uFpySqepA5FafTNC5poTGBTaFDI NA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2dvg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:27:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C7QNOR011507;
        Tue, 12 Apr 2022 07:27:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck12ccer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:27:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEm/46i2zwxJRoF3d38o9SIurvEUu9clSWqdbmr8YLJYhyGRqjTVk1DREYFcH/26rFM+5CKrRJ2Ucq5Gvo0g1o94VN56M6yRqn6k2TGpdta/zKOq++EVVTI5vFvVSa6yFbz8Lj6Mvn0q5vb/6Tw/4EfHJf46FIhZ10KPLNNXvBb+zwbk6R8OeNpGmjRcsSskcqmJc4dHVmbwt8ucDY1kHDcht15NZyXEm5Uwig/GaRbdxpePdpYlDz9kqgM6hTlu1qLj8VbAPpo5D3bM/FKX0umVKqyykanBBgeW1s6rjJuiNzV8JZK3A2Z9YE0qRnagzqKiPlgyMJJrDCfgrypxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACnaDsycaFNFFEKizdqUJ13uUvZ8rFMAV0wL3QWB4RE=;
 b=BuqjdTjMCyLNLqPOE97YSpE1tOv563GUFaPpL7EtgesZzysYos67urq0F0oXAkWm4GsdG1cFMu05RuzegZmmoRbreVb6a6gXF/9Y6DTTzvV+6j9gyYTkSxVUjtP2G5F/AazKcptf1xKP7ZtPIYc0EhgKvDnNXqy0GXtENJzp+tgBUKjyWX2byHANxUpGYI9zkDNSBp4vMh8PTlafeCPLCPUwRccb0SLsErfeHlHwGcdTphNT2z4o8Usj7jJGYsnxpv+HMKX4ENFA/ecKKEYLrZnMSwHZ2Ybq4D9AhRacGGNUZ5swJjvO/+cDp8J8qjF8PLncqhimglJMAEIGHnysrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACnaDsycaFNFFEKizdqUJ13uUvZ8rFMAV0wL3QWB4RE=;
 b=uoY0eVVhabeNLAGHBq5TR3e7R2Ltbv040TDGiYc612+fgfq3gAsi49/eruM5Y6f8BgOmuVeSV7Ag51FlaQMeIOtib5Rs//8yXf4iyoWKljKMwQR6Bp4tcpYJNWY7hXODgsm2IwdO8apEBBLXxsLA0eyaCtckHE3R7JIbm3tPUmQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB3464.namprd10.prod.outlook.com (2603:10b6:a03:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:27:01 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 07:27:01 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-16-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/17] xfs: convert quota options flags to unsigned.
In-reply-to: <20220411003147.2104423-16-david@fromorbit.com>
Message-ID: <87pmlmzrr7.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 12 Apr 2022 12:56:52 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY1PR01CA0154.jpnprd01.prod.outlook.com
 (2603:1096:402:1::30) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6971907-bf35-4125-856b-08da1c55d5c4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3464:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB34645C800EC5D9519F790F1EF6ED9@BYAPR10MB3464.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmd4IFEPOPLtpdnWYZbjttROyDSRiAWgMXuPcarmWBuexAP9SQ3PwAxNkbMgW3Xom4QvvDctVmQFTLHslX0EJSTib45JNPPJaVLJK8+XLuOg7WGah6+UrXslI6mIkkfk9gmCvCgcOSjgyC0UrG1rLjH9wN3wYtWSd38PXwFb2ImLipNMW8DYFFRdSNRWNu+zk3o6trNkAvhnflBhNNboncaon62FjAtT8XIbdG+C4DjfsyuLycX36gqc1zIVeM9fd5w6Fku7uuKBmuUY+c6/Mflb4cE1lxBTdbry1V9Tx6KC2v3SBzv2CityuTgB+q7Ksg1PG0SODSu74HrBmmVoNiSHI4WaeiUaBE7oj+dHSzyJbDi2KZfOGFje4zVe4sfdPjcjsPBLfU6fK1iXOHlgfXaNVkGbAnXVKUxpvxZKgtfwKLcO9j6Sp4rDmaEDbRCPWW0wXMG9UgMhGdUTJvAZFnTcKbGx7ED5+/DeswMAy/cVifnfh3EbyLlldEbkP3xJW7KnvXykgbLShjPn91f9AWt4AceqYZwl5MX4d2u7/gcaSk8L9CyKDADoZT+hzFhiQ7jGWlm/k+heqDACFfVhW2bXrpFjQG+hdsZQnQ2mdQSK+fMhHTNPQ3Atrt0zbVnUvaPoBwOkNjl+BwXJmpHENdwvMYnv9zYDQfitJfQ8B/r7UJOuWB7xUBEocoQh49vzrwGhwJzQnoAzOgiVK6Mg/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(53546011)(4326008)(5660300002)(15650500001)(2906002)(86362001)(33716001)(8936002)(38350700002)(38100700002)(34290500002)(6666004)(66556008)(6506007)(6512007)(26005)(186003)(83380400001)(8676002)(52116002)(9686003)(316002)(66476007)(6916009)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jE1A+g+qwfMg2K7RfdmccCYqr5/EscdOexyfTNH40wrbDAecQTJzrR+JgvKK?=
 =?us-ascii?Q?+pK2md8C+Kk6g8v9uVu71LaoKAb1NDpbCJZs2QuMnj1hxJtf/h5JyjgcT21I?=
 =?us-ascii?Q?2ND5lG6qh0SOShvA//yj/ubWJKCQLhKy94uM9U36/bAKLLgW9PXNV/vPejDp?=
 =?us-ascii?Q?pMJLvUneVxSY3e5/ZeV1jQ8k9FqpRtuXSVUtFFTaW+GYelFQ5gvPcUWlNXl1?=
 =?us-ascii?Q?lgj+i/RjSxiYKNBtlj/04aj8wwwHKkERwA9yn/OuLWyZmvWMYB0xAt9AG3OX?=
 =?us-ascii?Q?QrrlU8u6xahwo8g31ni/Edz0i7P0ZyeYoAX+iw7TVvqxKH3x1ZcGp8g7DvJE?=
 =?us-ascii?Q?I9R67NQj8toV6fNebFh40+cWlsxVLqh6Db6LXe5by72LiT4q/xrQBrGSi8Tz?=
 =?us-ascii?Q?gJpPfcYyHCdSct92MFBAXOxzXJ2fdR9u53NRHvjiXSZ+QzEt8U0TEWInh1H4?=
 =?us-ascii?Q?j/JhelxLuqQSWvyss6XdFrw6XgDGmbqIG/4eaKvvuPR3ryDlo1soDX79fm0X?=
 =?us-ascii?Q?zQmZfOZ4WEddAaIVQvmdDUoEMlhENAgBWaVZlNg20p3XBnxKYBhuhfYjYYiv?=
 =?us-ascii?Q?pbMgLbbJ9zBFqlh3v8kxgW6On6+JsFCKgRzoWAaemIAAJVc2afAjawkzXpXK?=
 =?us-ascii?Q?+w5+hgzyZ6EnXfqTB+o9fH7LeyNWj/ZMPjmb9kymOtuIRnTOaqhd/3m6vPa8?=
 =?us-ascii?Q?VLLu3v4V3OdubZf28bJQMR7hKPR/K9/XsL5XO+KitssCa66BO7g86BdCCHi9?=
 =?us-ascii?Q?sE0NnJSTkvLpyn/him7gIPd3Fx5BujmN7w5xopmWFBpd7vv66bg2GFdD4Fef?=
 =?us-ascii?Q?Gc9Ipin0WfAT5Ijpv+yyKcufzmeWmk1Ra8M/+RkJuytAJ14CvKvzxlzQz0E3?=
 =?us-ascii?Q?mAivVnSa+SoZSW6XZwzKMxzhzw+bmfrDVdzRvPus71crLGtjrk6gqIt0++pt?=
 =?us-ascii?Q?8+FV+Ih8klGj67ASmjAKHEgi8Iz5BLepbk8BBQfMDf2qSXIIsSq2GOthdZx4?=
 =?us-ascii?Q?Fx3RXhiF2sh483aFD7dDlHOG5rW2HgGdnSdp3xkieNGYpiJ0lE8fTKWGbdtH?=
 =?us-ascii?Q?hvdB/jiVHGL95ojnEiQeU2sioOiZdBtLVDUY6RfU96bEX4aLx7imk8PiDedk?=
 =?us-ascii?Q?k4B0c6/MRyBYh4XZ17CeNwrwIutFQOHQuNd5fbBrWatEjSRvBidjD9EjKAIS?=
 =?us-ascii?Q?dygfZA0ygdUhh28uznGfK/r1gDiKf69dVrBicO6TwfIBkesTWjyvywtBAqeH?=
 =?us-ascii?Q?vItetS7aXzScY8cw53YdAwz99LNB/E3xgJhF46k0gdIuGNQId3cdZKCqku2T?=
 =?us-ascii?Q?xX30b/wNxEFlsToY69qfSImOiOk1OmYlWO/c2Jo+hazJPskzt6MhPEivs/rJ?=
 =?us-ascii?Q?Ev7WI5UNR0bCLdk7cmIpeYue4zQFhJs/5hmf6dUt1RRgnEhGfyQlPxVfSFb8?=
 =?us-ascii?Q?1yOAaFf+ybqHypeKPRMsaZrib6NE2JQHR1bkvkWJ4byNAb8+6azyrSpmEeF9?=
 =?us-ascii?Q?EKjs8SMD3BXsxjav9cHPsS5ZGh3G+EYs7qp+lKrZ+vuCkKDiweaaCGUpodiD?=
 =?us-ascii?Q?1I0pEaqb9kjGo5snp8lyZf+7Vabx7nJatBTiVIEGNyS3AQXikwWrSLvI1jO/?=
 =?us-ascii?Q?wehFRq5h7OCBSsdiSJ69Pzd9E5A50UZ9YEtzQ0j/x6Eint+c6b4Q7tWpuQrl?=
 =?us-ascii?Q?mXfo899evHUDqnbkQso8urhpKyTECmTUPGD/7GpkUaQAgLL86GR/j4J/0qmr?=
 =?us-ascii?Q?j7OIZr0UWeDH3eBomUZr86SrxgXS+Ng=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6971907-bf35-4125-856b-08da1c55d5c4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:27:01.2757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irsvN+hOsOlP/lMruAvhSCaDsmWjubsoYHE9tvoc7xCDYWLA/yUGmLVheWpHkfx/C7uPpdQtsjmLVR9p42syAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3464
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_02:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120035
X-Proofpoint-ORIG-GUID: agmM0KezMqxinS69hWbPoW-PMI7EGQdt
X-Proofpoint-GUID: agmM0KezMqxinS69hWbPoW-PMI7EGQdt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_quota_defs.h | 45 +++++++++++++++++++++++-----------
>  fs/xfs/xfs_trace.h             | 16 ------------
>  2 files changed, 31 insertions(+), 30 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index fdfe3cc6f15c..3076cd74fcaa 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -73,29 +73,45 @@ typedef uint8_t		xfs_dqtype_t;
>   * to a single function. None of these XFS_QMOPT_* flags are meant to have
>   * persistent values (ie. their values can and will change between versions)
>   */
> -#define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
> -#define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
> -#define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
> -#define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
> -#define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
> +#define XFS_QMOPT_UQUOTA	(1u << 0) /* user dquot requested */
> +#define XFS_QMOPT_GQUOTA	(1u << 1) /* group dquot requested */
> +#define XFS_QMOPT_PQUOTA	(1u << 2) /* project dquot requested */
> +#define XFS_QMOPT_FORCE_RES	(1u << 3) /* ignore quota limits */
> +#define XFS_QMOPT_SBVERSION	(1u << 4) /* change superblock version num */
>  
>  /*
>   * flags to xfs_trans_mod_dquot to indicate which field needs to be
>   * modified.
>   */
> -#define XFS_QMOPT_RES_REGBLKS	0x0010000
> -#define XFS_QMOPT_RES_RTBLKS	0x0020000
> -#define XFS_QMOPT_BCOUNT	0x0040000
> -#define XFS_QMOPT_ICOUNT	0x0080000
> -#define XFS_QMOPT_RTBCOUNT	0x0100000
> -#define XFS_QMOPT_DELBCOUNT	0x0200000
> -#define XFS_QMOPT_DELRTBCOUNT	0x0400000
> -#define XFS_QMOPT_RES_INOS	0x0800000
> +#define XFS_QMOPT_RES_REGBLKS	(1u << 7)
> +#define XFS_QMOPT_RES_RTBLKS	(1u << 8)
> +#define XFS_QMOPT_BCOUNT	(1u << 9)
> +#define XFS_QMOPT_ICOUNT	(1u << 10)
> +#define XFS_QMOPT_RTBCOUNT	(1u << 11)
> +#define XFS_QMOPT_DELBCOUNT	(1u << 12)
> +#define XFS_QMOPT_DELRTBCOUNT	(1u << 13)
> +#define XFS_QMOPT_RES_INOS	(1u << 14)
>  
>  /*
>   * flags for dqalloc.
>   */
> -#define XFS_QMOPT_INHERIT	0x1000000
> +#define XFS_QMOPT_INHERIT	(1u << 31)
> +
> +#define XFS_QMOPT_FLAGS \
> +	{ XFS_QMOPT_UQUOTA,		"UQUOTA" }, \
> +	{ XFS_QMOPT_PQUOTA,		"PQUOTA" }, \
> +	{ XFS_QMOPT_FORCE_RES,		"FORCE_RES" }, \
> +	{ XFS_QMOPT_SBVERSION,		"SBVERSION" }, \
> +	{ XFS_QMOPT_GQUOTA,		"GQUOTA" }, \
> +	{ XFS_QMOPT_INHERIT,		"INHERIT" }, \
> +	{ XFS_QMOPT_RES_REGBLKS,	"RES_REGBLKS" }, \
> +	{ XFS_QMOPT_RES_RTBLKS,		"RES_RTBLKS" }, \
> +	{ XFS_QMOPT_BCOUNT,		"BCOUNT" }, \
> +	{ XFS_QMOPT_ICOUNT,		"ICOUNT" }, \
> +	{ XFS_QMOPT_RTBCOUNT,		"RTBCOUNT" }, \
> +	{ XFS_QMOPT_DELBCOUNT,		"DELBCOUNT" }, \
> +	{ XFS_QMOPT_DELRTBCOUNT,	"DELRTBCOUNT" }, \
> +	{ XFS_QMOPT_RES_INOS,		"RES_INOS" }
>  
>  /*
>   * flags to xfs_trans_mod_dquot.
> @@ -114,6 +130,7 @@ typedef uint8_t		xfs_dqtype_t;
>  		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
>  #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
>  
> +
>  extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
>  		struct xfs_disk_dquot *ddq, xfs_dqid_t id);
>  extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 989ecda904db..b88bd45da27a 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1096,22 +1096,6 @@ DEFINE_DQUOT_EVENT(xfs_dqflush_done);
>  DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_before);
>  DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_after);
>  
> -#define XFS_QMOPT_FLAGS \
> -	{ XFS_QMOPT_UQUOTA,		"UQUOTA" }, \
> -	{ XFS_QMOPT_PQUOTA,		"PQUOTA" }, \
> -	{ XFS_QMOPT_FORCE_RES,		"FORCE_RES" }, \
> -	{ XFS_QMOPT_SBVERSION,		"SBVERSION" }, \
> -	{ XFS_QMOPT_GQUOTA,		"GQUOTA" }, \
> -	{ XFS_QMOPT_INHERIT,		"INHERIT" }, \
> -	{ XFS_QMOPT_RES_REGBLKS,	"RES_REGBLKS" }, \
> -	{ XFS_QMOPT_RES_RTBLKS,		"RES_RTBLKS" }, \
> -	{ XFS_QMOPT_BCOUNT,		"BCOUNT" }, \
> -	{ XFS_QMOPT_ICOUNT,		"ICOUNT" }, \
> -	{ XFS_QMOPT_RTBCOUNT,		"RTBCOUNT" }, \
> -	{ XFS_QMOPT_DELBCOUNT,		"DELBCOUNT" }, \
> -	{ XFS_QMOPT_DELRTBCOUNT,	"DELRTBCOUNT" }, \
> -	{ XFS_QMOPT_RES_INOS,		"RES_INOS" }
> -
>  TRACE_EVENT(xfs_trans_mod_dquot,
>  	TP_PROTO(struct xfs_trans *tp, struct xfs_dquot *dqp,
>  		 unsigned int field, int64_t delta),


-- 
chandan
