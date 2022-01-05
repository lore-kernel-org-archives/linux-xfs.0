Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB67C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 13:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240433AbiAENty (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 08:49:54 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35144 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbiAENty (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 08:49:54 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D4MDR027777;
        Wed, 5 Jan 2022 13:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vrAAYq8aePuMHLJlLXnkE8g6R41xNQ2H5RCuiSp+nDg=;
 b=UaQs4AAh6cjBHkLBKBtBeXsZ+beGmfO7pLl+ZF9Gz0FDNaJHu/Fr1u2FmqvG1cdvVkVs
 QmcE8gsSP/XH/+R8N+tFeQpPEZRgmrXNpzjEoHJuqOV4fz6vWYiNTONE/1zXKJq/P0Je
 Zx8m5S2LxlRj5exwODW/3sb2Ith5IXbgLJlRExmHxIrNU8DC1MowCF2vSxR8Myd0CBQg
 EcKhCDfSPnHtERv6dEGtn3ZH1JspAWuDc7IKPcQIloq4jwo7e0AOosDTq70hvc6hdBEb
 W/P4L48udBujjrbczzDRv0K0ewVRNe3rGVeodfFQeLfqPieJMUXI1HRrtc7L2SL089hc bA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc9d940dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:49:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205DjeWB065437;
        Wed, 5 Jan 2022 13:49:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3020.oracle.com with ESMTP id 3daes57ww8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:49:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6GcVHv8J8z0MLMziKDT9Ab69pLgQblC5k/4dSyVu2ua0dDQv5HmW1NFSoPdtM1XxhZzxV+DPDKzonZyHDBmKDuV7i0NX5PoQ/0o3Hz9wPOYqeKSRUshyCO1/TEHA5WL+7QLzrYbIxqeOGx2SNl/FfW6ySkuLcaUDNJipT0ZjlxfQOlQdIjgVZq0XaDaonIOA9hXWmMs/XPTD/C6TSWkAsP7OqysRIqkBsXWk8mSTyuvCm1w370P1psuOzw94+yw6/xaUN+CvlZKkXkSen6ERQ9WurAmL+4Bq0kFT+uJ1Ay2RrcHzxcrRzV0Z74iIr81ZVn68FY3OUeJzE+/owIZWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrAAYq8aePuMHLJlLXnkE8g6R41xNQ2H5RCuiSp+nDg=;
 b=bnKDRW9WJlRijFarEL7hAB+QrQBgDHQdRlJHJGbpxzVdJ+PcCcwyRaZQXtyIIGkvqG232uA+VGoUADXEosbU7UCwdn0AX72oXhtaHIkrBbtQYh6NKvkhAlK1YZxeBc3vmU2O0mNkKymMvwA//5/OVIjGhHfe3ncSjVlRl51Ee+W0LXk1PMvb6Q7WDe+/ck5mDxJrulbkmvwZrCUSWLh0gcu978C5zfSKeW2FCDSkuOyjK5/1sxP/nr+bOET0Qhzo+SvWA9tFA9wd4GVHFw5hk4JIsVGm/cEZa/D9i5F2kR4gEnnSDfK76ULd3oKJDlQOMPYnNrw8Ub1CuuPePN/3lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrAAYq8aePuMHLJlLXnkE8g6R41xNQ2H5RCuiSp+nDg=;
 b=bWK50NE1gs4kcH4BItvND/LxnwqUz3ca2Y+ZrzacHmdy/v8QAkftuB8rRbiBbxWy54uYm0HJRboFw/nHjf/6pM3DhVHX/lU59SZ2wLioFpBs4fcS2C35ZFCdE2s3YgczJGEIR4te5RYW9jSMMciXArQEbEk6wr4poxaV6YsllLA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2542.namprd10.prod.outlook.com (2603:10b6:805:3f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 13:49:46 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 13:49:46 +0000
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-14-chandan.babu@oracle.com>
 <20220105001806.GP31583@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
In-reply-to: <20220105001806.GP31583@magnolia>
Message-ID: <87pmp68f7y.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 05 Jan 2022 19:19:37 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cccca2d-a83f-443b-4556-08d9d0523c1a
X-MS-TrafficTypeDiagnostic: SN6PR10MB2542:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2542DDEFD08216DAF015394EF64B9@SN6PR10MB2542.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dE+okCug+CJkAHPxVYv+lXaayJriTv0ggZQDNLj6kMnDKhY3xVrG8UaGjIfFqx93D54e5hcyCLruk/3mju0AogT4tCNNp06hnDW0tV6RgzgjRzfYpGFIwOxoH5N8LWPLNUN0arieivYelFWYWydGEMl4QQ6ypGw5EDgulAxOQLtOwq+Q/wRZemH7DTsllrA6J1rJY80KSXXWAlNdGz3+y2IrZ0YFieqjrQB3gh/i6Qql0m1e8moWnCUnZ7WhsHlQ6bWxdFr7JruKYBvO1jd0wkreyRbO7gl1U7smeJlBTcDmgJyI8neWzprtN6/uJuQyK7M2cQlOu2LRDVucIYnT+0Td+mrXC/FOYJ0aGDhiE74i+LH4TZbQr6/VNZ7ulbfLIGyE6mx/CVzsVgIj7ku0YYwgTf6n7YzPvu7ukQ05my781fSlJDH4Gs1vBNwYojkD80+3uZIuGKWLsF/z3JhSO9zHpRgZFfDQncFvL2nnnmBvcxMn3aVIlG917OP+ebPM2mtb84mhtc3BwI5VbTcR8qKrUj3UNMP3jm/1Xsp44AHVdy+jor8P+KqWUaREOHBTA+kE64q+bmZoR9P7nUxKIkm409Nk0qIQgJPcTxbA8jmHyeeBKyEA1H8VfiNm0LVj8g7pkXXuCnvtrJhhfnHfqKsU4wmE92taMo69uqMIkGYKDYbcocvMfMKeQEF+YwaCF5R6jusIuNebnUI+d8U5ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(33716001)(8676002)(6916009)(2906002)(83380400001)(9686003)(53546011)(8936002)(6506007)(38350700002)(508600001)(186003)(38100700002)(6512007)(86362001)(316002)(5660300002)(66946007)(4326008)(26005)(6666004)(66556008)(66476007)(6486002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XfNsq3wD3ZzY7soocNqsNBA/d++dyKyD0rYmJbVjj610dwCsarJf63spvoTj?=
 =?us-ascii?Q?vF4vmTcs12mC+AIuQgegsTdIQIrVu143MvVJn7vNr+3KmolIj3gEV8HXYq+D?=
 =?us-ascii?Q?S2FEq9goV90awmx2eGvWO2Nxm/uqDhnUetnG1hFu1yHRI7Z13pc+jiSRd0qd?=
 =?us-ascii?Q?5Iyrjo3U/Ri7WsLowfKsfYUVf1cy3d0o037vjpBHTOMHQkR0I7sDcb2JvvDB?=
 =?us-ascii?Q?bmJscorz4AE6vxg8wHuilSXs7Bpzx2qZ+8FGRJpnR2jlCsOzqnvLjbFEtZSZ?=
 =?us-ascii?Q?WukuGX4JNWaSItxXG4T/weIS7EFtnUzg5Nklpcl8QyLO/fjEuP4VCRI5DZdS?=
 =?us-ascii?Q?S5SGb/0H40aGrBvZ08kP8VqrNcaGk4XEGfGEs95XB3jYWmqqJ2OvARtL8hnY?=
 =?us-ascii?Q?4jfhMmvJnMTQ+IEFDSIDRj978xT8IaGHz8AjkCRSKbCdADSQjF1HJgvvgs1P?=
 =?us-ascii?Q?hgvWTFrbdwWV2IlrxPZhW8zlvfhcH3W+vWr+7OTrYCayr+gJdo1HlL6OJubK?=
 =?us-ascii?Q?jHDn72/dWYTf45IkUtAqGS3TJPZJe9RRApHPH42HV3w+7e4K0a2OTQmUNAOy?=
 =?us-ascii?Q?H5/cqbpXP6uIhd+6GLKowP5++mBIWqH0EWHF2408emCAuxeDoDnCACOvZJiI?=
 =?us-ascii?Q?yuLNgJQXAEXVz3lzeh4XJC7wYtLRXEGjX6ui11cLu8T6roi4kV01duUKUFgL?=
 =?us-ascii?Q?qXGmxMkt6I6HqYzMMbmJVXMsqWfcLCxQGI5+PoZRiw3UdaFTbEK9Wsh6h+LR?=
 =?us-ascii?Q?bPMxTm007Cu8HWTFdiIDzJcBXaq8wW+CZaos57v50HKdkD69wrj0+rzZMedr?=
 =?us-ascii?Q?Ui+vCvRrQYl7/7SAY+Pdo4NCq2Qzte/WUA/WC+8ub25ym/ceWRlIKkLNol+m?=
 =?us-ascii?Q?01sMpTzKI4CLX72rctGYqiNPoiNuiqcGA8pq7nhJ/s+0Wu/fQHdcBBXM3HDw?=
 =?us-ascii?Q?IwWXHB5mx5f1oV/opa8NEwTrtGcqQwa+DbmBdVwjgW0nVKHGBitYEEWNtSpl?=
 =?us-ascii?Q?yIN8UDGSpBOsfsO87Z9dyBPvY6s7Y4tHwLo6MnI+VqVqVWc+IWCTrN3dDSss?=
 =?us-ascii?Q?Mh1o7vCXgMnwibiu4N+Eg3m0vWyIIErMj9xQcTL8ebUJA4fuuWv4QsnGNMVJ?=
 =?us-ascii?Q?TA4gXpCVRU1QcXzYuehFfjTwdFP7ruM6h7sgmpNfKhwKEejpEIXRAa6wqxp4?=
 =?us-ascii?Q?/RoKCE/WNHBbW+ORmX4GrE+gk9viVl1Brf2khYNmxv9otU3ySqg0iSK+RRQL?=
 =?us-ascii?Q?fuI6E+oVdspPNhGcHVhpcFSF+nJvMD51a3rD6b/fUMSSWi/ik8jc8alJyBbZ?=
 =?us-ascii?Q?tmncUg0kQJHqnIcfxcc8PG16qXBgfq98rfGK3szcdHFpUt80u/o9s5BGymsP?=
 =?us-ascii?Q?3gPKgJKeGHGd9u353Dc1VYZCe26KYRZ93Lpt2XOMV7EWLa5+YCGZWmwH6kCY?=
 =?us-ascii?Q?ydS3FYyKH6K2eoYRprmuHXimDWLbDJxSjRfdhajBOWN01fCAKgYbY/wMectP?=
 =?us-ascii?Q?qsE7TqQPNuvGn7m7AIIatyVScwRn3fIInNavvzom8Z7pQd/E03QL3s9Ji9Xg?=
 =?us-ascii?Q?q3zORYy8q3qtr761B0WgOGz1kIf9q+4Wj8a8+VJrUdx5sz/VNGA3tixHDi4R?=
 =?us-ascii?Q?H3DvZgi6vNKMyi+vM3ELzZo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cccca2d-a83f-443b-4556-08d9d0523c1a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:49:46.6345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bue5Qpdp5mzTnD8kx0Gz7OCOn47whJ0PFQRxOSvzAbmbLLfUDzAnrrvSB3TvXNeFm3frgFPFmivlcPuPMtGWrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2542
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050092
X-Proofpoint-ORIG-GUID: egy_CxZQG4gelWF__eo5nssAoJiJLBLH
X-Proofpoint-GUID: egy_CxZQG4gelWF__eo5nssAoJiJLBLH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 05:48, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:15:16PM +0530, Chandan Babu R wrote:
>> This commit upgrades inodes to use 64-bit extent counters when they are read
>> from disk. Inodes are upgraded only when the filesystem instance has
>> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index fe21e9808f80..b8e4e1f69989 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -253,6 +253,12 @@ xfs_inode_from_disk(
>>  	}
>>  	if (xfs_is_reflink_inode(ip))
>>  		xfs_ifork_init_cow(ip);
>> +
>> +	if ((from->di_version == 3) &&
>> +		xfs_has_nrext64(ip->i_mount) &&
>> +		!xfs_dinode_has_nrext64(from))
>> +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
>
> The indentation levels of the if test should not be aligned with the if
> body, and this should be in xfs_trans_log_inode so that the metadata
> update is staged properly with a transaction.  V3 did it this way, so
> I'm a little surprised to see V4 regressing that...?

The following is the thought process behind upgrading an inode to
XFS_DIFLAG2_NREXT64 when it is read from the disk,

1. With support for dynamic upgrade, The extent count limits of an inode needs
   to be determined by checking flags present within the inode i.e. we need to
   satisfy self-describing metadata property. This helps tools like xfs_repair
   and scrub to verify inode's extent count limits without having to refer to
   other metadata objects (e.g. superblock feature flags).
   
2. Upgrade when performed inside xfs_trans_log_inode() may cause
   xfs_iext_count_may_overflow() to return -EFBIG when the inode's data/attr
   extent count is already close to 2^31/2^15 respectively. Hence none of the
   file operations will be able to add new extents to a file.

-- 
chandan
