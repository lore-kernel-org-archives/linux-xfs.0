Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14319C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 08:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbiDGIVr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiDGIVo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 04:21:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26744B369E
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:19:46 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2377Z0PI024447;
        Thu, 7 Apr 2022 08:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vSVn3J1pMtYW6ocNlFVFzhtj1u5D8OhAMkYinSm2eCc=;
 b=hbeVwMSOclpuVc9jnnd5VxLmfMfWTrjS1FYmcypNZgS0o6mrx0CYTCdrjA9SaHQdaU7i
 40HlMxU56TDU5wLoJjgAqTmzeTmedoPbQX5DMcvBv37+xn+HR6t4V/2TA254N4wdB+T6
 uWTrCBgae6GuFRC3jWrilYiD1JJWbIx4YR4GWdTPiNJvbALLVrz9mR9+NcIUhkU5bf2N
 PQSd4Y+u5T86FVIcOAhLQIa57z4psefDy83QPeHLlpRWIPsjiEg9XNTnwQibD3Wep8R8
 qTtY641BkcQ7eNedFVDeR6STdF/yXfHJYb8fiGJnXIH++WOmDZVZJFt+DC3X5RWoJ+bG sg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tbb09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:19:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2378B7a8007986;
        Thu, 7 Apr 2022 08:19:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f974dse7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:19:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmlCqwIX1IEOEwCNce1M7/M6M9U2iGjveQtxoD99cV83A2q4GzB9y9BGAK3PCGWIGh3q3nHX11BhwOjLulgG+TAQwA690Zm1hKMJ6490aRi0ROAQJRDmMYzQJn9BnCwPis3Op8PGHT+S337E7dLhoy0KsYRd1N2t14rkVycmGKEfGOpxZLo+x3Es3PU0/bD0JzWg+HkZzPVPFb+o3dfKd5PRcCD7PLNI+id46cDd8C3BBBTXJNVIe0JSiBMPI1jb9SOUKmh0Ro9tU/zBlO0S6j540zagyETHT7Qh7L+scHzmkTsHpjLSDY0R2+CiAoS5awnO51Rbp8K62xGEhf073A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSVn3J1pMtYW6ocNlFVFzhtj1u5D8OhAMkYinSm2eCc=;
 b=mX0ihdIIRawRXsCUyJ7uq9xNw4/l3GOi0aDPlgPOQvVnWttUotmQZCraoQ5FwW/Cg9KVNRuw+dNusLxWciVrxMMguCaVBUsorDNK9wzmZzp0pyJTaY+/P19OZtsKxgEFXcAUg4eecXYQg+YJObk/qyjMHuzJpMaZsJaSGVWP5Ch1b6rJcN9Rsqo2Q/1uAAyX1Ik6v+UmapTRZWG8PL/pnxV82RWSgahLOQvnsWJGiM9FQpvjK4kuYUpBm8sqkXI6yvqxhtYeSspglcTTO1bzRiGMwQQqMeAi4RVeDwnCTg3ykyqalgQ/ZbcDSoC6Ga9ZGh90rVSY+muidoGKcsJdNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSVn3J1pMtYW6ocNlFVFzhtj1u5D8OhAMkYinSm2eCc=;
 b=P9KcU5Nif0f9sqhYJkvlDFj4giY49Ee0fOnIpWZeFhk/UXgbr/vZHHA4Ja8AIxKHFp8DfiTzM8H/fZprAvVqzf2ZWVZO9wVucVHbZWjdLfmcANHFOJhfB1xK7skb6kKxhTGRSD9O8Rx8mBVW6z1zUdOfbugxL/W3tdyzoOgSRjY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 08:19:40 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Thu, 7 Apr 2022
 08:19:40 +0000
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-17-chandan.babu@oracle.com>
 <20220407012225.GF1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V9 16/19] xfs: Conditionally upgrade existing inodes to
 use large extent counters
In-reply-to: <20220407012225.GF1544202@dread.disaster.area>
Message-ID: <87czhtxq3y.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 07 Apr 2022 13:49:29 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0030.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::15) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e644c150-55bc-456e-b335-08da186f5c5c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5613FB4B95C3718FC5ED10C3F6E69@SJ0PR10MB5613.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SMD1kb2yehZAsfDxlP1FqUBJ7fQMFIZGKoAsCyWbi9WBgxlRwxrngvHkF9KEv+Css5TCT+RaXkRsP0G/MKjDIa5FzrMIxarT6EZ0K0uCzc0JFFINP9aCfDB3uI67b4dAFq9SY9dfV4aLJROYe/JcxYI9pexsVQmcuWCiCVMUdJ+2xm16Jbx+dJlyDPtjdGDlhxOhJWAd1QoeZlAN2YhG2GxxXXcOiUiK4dXhZX50GQvbejzc6KXxF9/MGnd0ge6R4YJyfPL6aoCJFrO73F1Us0S44PwOvxKA3vLeHElxpjrZw9hPSrs6ww1o+s+n7pgvJJ3xE6cTgyCRfdk6XHA4zRu1aG3ZZh6w6HWT/TTQZP3falZBgD4I9LXok1n1Y9VHZMoOKuDxCB7rdVMzhjQditoBB8V2B5Nhe64vDR7PvDbOTSexaWzcNbVOdpuVVnvsWvGaT3lmjeWJm7hPZdBOFGcwVc4CYru7S4oV64F4yznZMmADfgMsc0sidy2e7/pm9yY9C+Z86QqbIQ80LJOovJbRMVEFDDynNotYf/3otY8ywcpYBjsh88r7dPQAEIQeerCW4N5XDlNvTSSTKEqEGoMfpz0qv3/YigVQBAwYyMXc+yRmDfockORHmpa4lj5GB7gURiSaulxRFnnQY5EnSBXSIPz6RLX7sIJo88pZQJuX4ES8LACOVQdxl515XfkiLwFc7fEdoK5PrG7bI/YPVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(6486002)(38350700002)(33716001)(508600001)(38100700002)(8936002)(5660300002)(2906002)(66556008)(4326008)(316002)(86362001)(9686003)(53546011)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6916009)(8676002)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FfBHwOPx68N8TQ1fA+F0HwIMLYHxceCAEjQvJiXf5HEcw0GInQ896utK06RU?=
 =?us-ascii?Q?qBnNigJVDGpRyZFKP5KtxEE7QqZDO7e7r3d/CDfTP0pr2nSfdUVWFMkZTxYD?=
 =?us-ascii?Q?Eig8awFGd2xuSYoOw/qfoyW7FVuz2WkO5hl4UyzeyVv72ba5XMwFeiyolrp9?=
 =?us-ascii?Q?MwT/QTGvfVZLTQvRAUWFzcXLrylOXnFdd2rRynMftmzmAx+tTxp7I1Y0kDZn?=
 =?us-ascii?Q?SYzU703r0oZC8wIpVGalcor1xz+SCjeOD/4TH0TY2tfvelNWgW2Zg9Hb7/Wk?=
 =?us-ascii?Q?7AkxLLkK6bwXOygjVPF0DbdAAoMan01CQd1Q84of1HbHp9gdXI0DZYrPukv2?=
 =?us-ascii?Q?n6wPt9Uu5KgEW1amkCgDUpks3Jxbkd1OIaVLsDq+WSKSKPUMwL/ifHcK5nZl?=
 =?us-ascii?Q?79RXs5b4TI7z46VJJYcMXj4foSLFSSkfx85I5eUFVfgGU4Ds16dNP2FwN4tX?=
 =?us-ascii?Q?tkADsRxKbCv7fvRt9BlnZbi9AvADLfir/1lu9Rtd/iPs43Jjv5SgZnK6sYUP?=
 =?us-ascii?Q?G8TgRaUh5/+BQREy9/PZVbIz3dSO5OCK7jC/helV5RUMrNDVOMycedU+yUpp?=
 =?us-ascii?Q?N5m44h/j2ooG408u2RFvKZM6MkL2bqOO8PyAmRmwzk0FPQ0hvtd3ldADmwT8?=
 =?us-ascii?Q?gyyzSKFJz4lcq3lvBK7Y8V91xpkOSG53ZcOU7vFosHneUgA//IhnB/st2eoo?=
 =?us-ascii?Q?LxcA7RYa6i+hksf45F51UZveUwhz9xPGvAsAjMgii6c+kcN+WnZqieIOjFrU?=
 =?us-ascii?Q?rCH2WPRTw6toNx2u6Bu2zb+MEggTvUM95ttFEgYpc3LMefjbpmEbAdlWSlQ1?=
 =?us-ascii?Q?1YdpaZskQYnUhjlrSrfJRyV3cPEsLsrlvYaSPTqnn2HdnvQsvkdTBfg0OFFJ?=
 =?us-ascii?Q?A9fzfyJlIXsSP9tj0o0B2ip1vMsHQHPksnopRqqA+SVUwqbD7VB5p/peA4vi?=
 =?us-ascii?Q?eR1ZdoAbb/COp4Hdaapqc1arqp/6P2hFrENIqrN8qZKode6FZQxLlLgfXjXD?=
 =?us-ascii?Q?kTcAAyfiXBIfJIFIMjOhvkqozlirqiGlchQsLow+0tc4uOE6WlnpMGXglxFQ?=
 =?us-ascii?Q?BcXolncR4i8bvKu1Oug6T/eRCzKUTg/X5RyjGSMrY/JL8lzCthEeSQ63Z5eu?=
 =?us-ascii?Q?dfDnVNA9J6FOZ/iPT0O33Lk9uqrmAICZt1VzsEILFg7jaXZnPXP9YWRro2Dk?=
 =?us-ascii?Q?LoAU29uLSAZ3xuX4O9+9F0epNU4SDCEQ94rn4yW/L0z9xTtnxcRBQZ7WAeHU?=
 =?us-ascii?Q?j9SQ2ENVtybTdAWEBcb0unQaiVpJiujbPIaQT8LbsRLIP5qeqT74BBCBh6rm?=
 =?us-ascii?Q?Eim4+wZWOQbuKEwy7INfcuyEzJCu/eqAclgeHT3WfBIGAxCo91ErKqPDlEEr?=
 =?us-ascii?Q?wHEt4SrY0Xzti3geIYWXjZWSaxmQNy6k9RdUEobjyaKI9UOwmJW1q1J+nWjs?=
 =?us-ascii?Q?lgPeIPCovkZh2jIrvAoI92hcncm8TtTSl94JCa56v/irWS+w/y9bDyhHHpng?=
 =?us-ascii?Q?fRrLlOTLgjw0m5f/dJG/Qq1d0w1JP/8uxftQLoIodut45qVHYXV6j9Xst7eZ?=
 =?us-ascii?Q?JbHBmSq5GMlqMCxw+9MAPI2Z5GzomrnwZRhx/Aqzvbn9J/W5wHgrWAi/E4i6?=
 =?us-ascii?Q?7Z8JXOo4l30bq3p6x8z3kpX6JnHu4JMPuasx/M70Bwfu/6MDxEl6Pi7Xk3ov?=
 =?us-ascii?Q?i8V8Ju6+0s6tmre/VjoSwD4tJIks6L8aeQznk6phNZtiiESovysS6TE8FgCo?=
 =?us-ascii?Q?i1ovKtY4nO0VMou3k3UrDK7pUGs0Y6s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e644c150-55bc-456e-b335-08da186f5c5c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:19:40.0268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnRFX2O7PSbv9cJpjve/D77tdNEPlQPYE3CNwcxKC4xgp8T6r3Pa4weh5Otp58H6xmyUQm9kpi4BU64M7400pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070042
X-Proofpoint-ORIG-GUID: gjXPCjuHjT7GgZAhgd5bNuY_iiSsnIGE
X-Proofpoint-GUID: gjXPCjuHjT7GgZAhgd5bNuY_iiSsnIGE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Apr 2022 at 06:52, Dave Chinner wrote:
> On Wed, Apr 06, 2022 at 11:49:00AM +0530, Chandan Babu R wrote:
>> This commit enables upgrading existing inodes to use large extent counters
>> provided that underlying filesystem's superblock has large extent counter
>> feature enabled.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_attr.c       | 10 ++++++++++
>>  fs/xfs/libxfs/xfs_bmap.c       |  6 ++++--
>>  fs/xfs/libxfs/xfs_format.h     |  8 ++++++++
>>  fs/xfs/libxfs/xfs_inode_fork.c | 19 +++++++++++++++++++
>>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>>  fs/xfs/xfs_bmap_item.c         |  2 ++
>>  fs/xfs/xfs_bmap_util.c         | 13 +++++++++++++
>>  fs/xfs/xfs_dquot.c             |  3 +++
>>  fs/xfs/xfs_iomap.c             |  5 +++++
>>  fs/xfs/xfs_reflink.c           |  5 +++++
>>  fs/xfs/xfs_rtalloc.c           |  3 +++
>>  11 files changed, 74 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 23523b802539..66c4fc55c9d7 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -776,8 +776,18 @@ xfs_attr_set(
>>  	if (args->value || xfs_inode_hasattr(dp)) {
>>  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
>>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>> +		if (error == -EFBIG)
>> +			error = xfs_iext_count_upgrade(args->trans, dp,
>> +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>>  		if (error)
>>  			goto out_trans_cancel;
>> +
>> +		if (error == -EFBIG) {
>> +			error = xfs_iext_count_upgrade(args->trans, dp,
>> +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>> +			if (error)
>> +				goto out_trans_cancel;
>> +		}
>>  	}
>
> Did you forgot to remove the original xfs_iext_count_upgrade() call?
>

Sorry, I thought I had removed it before testing the changes. Thanks for
catching this.

>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 43de892d0305..bb327ea43ca1 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -934,6 +934,14 @@ enum xfs_dinode_fmt {
>>  #define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
>>  #define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
>>  
>> +/*
>> + * This macro represents the maximum value by which a filesystem operation can
>> + * increase the value of an inode's data/attr fork extent count.
>> + */
>> +#define XFS_MAX_EXTCNT_UPGRADE_NR	\
>> +	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
>> +	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)
>
> You don't need to write "This macro represents" in a comment above
> the macro that that the comment is describing. If you need to refer
> to the actual macro, use it's name directly.
>
> As it is, the comment could be improved:
>
> /*
>  * When we upgrade an inode to the large extent counts, the maximum
>  * value by which the extent count can increase is bound by the
>  * change in size of the on-disk field. No upgrade operation should
>  * ever be adding more than a few tens of, so if we get a really
>  * large value it is a sign of a code bug or corruption.
>  */
> #define XFS_MAX_EXTCNT_UPGRADE_NR	\
> 	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
> 	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)
>
> Otherwise it looks OK.
>

Ok. I will include this change.

-- 
chandan
