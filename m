Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCE7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B268B611B0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhJTKq7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:46:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50392 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhJTKq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 06:46:59 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K9tWT5021306;
        Wed, 20 Oct 2021 10:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OJdEFjF4Ghqmb4+YIXciIzpIzxARcPgpNzraYCs7IB0=;
 b=uFTW4v4/0V58EOmOmY2SqqcPUwrkE9dv5SuIlqGKGvkekGeUdKLmziWGj7Qbs5oyBSYN
 +/2klgQ5MSoE3++GnvQrNq6ckxW3V4nSjQn8vR/rbDgls65VociTN7f6aSHQnuW1LM3e
 0uOB56FW7PRsTQeQZpDUem2IHNK91GY6ZWyhAjdNThVKeilUePfZmZpee2yxYvf4FOt2
 mHliYuqKyU8DoX/S2nfowWXb7Xek4G1hoi7Fk9/1eD1EwJtA2RLIucqcyXYWACNN/rhx
 BD4rDNeFvriDJthY1LPwTowNWeygs7hzx97tkG8VyB/l8eGjVg4B0ZPClwGErMHv3EAi 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bsqgmr7af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:44:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KAaqov093725;
        Wed, 20 Oct 2021 10:44:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 3bqmsg8cuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:44:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSeHB0gacq1lJf4aclLHscuJZ0PFwaz/AmNWwyAP27WXZBS5dhySaxXuXmSLLXkpGzWYjZNmGZi7+TCMyGZKrWd+bMmoN6aVxTheIkYkxfmS9kIjbUtT20hCvG+TR2jWeeU7UWqNiHwlLOr0qd0++ghEIeSLM/v5Tn8Xdhmf6l4wljrtUhk0SxKCRV4mAPaa6FVipk0LJbJ0vsQPT8IfIVbBW9TMSaC4TIzBjLeqnp3iFDIGLtBkkb/68O+4Q3OQt2CwZXVDVXe67VCf/cZ9WZe4eYYckw8SyVEZtyoZgp3ZMtck5hU34MmLh3AMjRRtMnnBW53r/jUyp9O42ezemQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJdEFjF4Ghqmb4+YIXciIzpIzxARcPgpNzraYCs7IB0=;
 b=N8XXaANa2jowy/6j6cc1CcPjfxVvfpN1sI4vz6DHyGuxqmxljNACcW3HHN33fa87u88XUpdwmw7P68rZO2Sveie45ALGy7uaQl0dptwkDVMLZcZGmVS9iPiAHI21DhsSgbbJWVpNKxtVnwrCHziDdp+RL37tKZCPTKrO1sDyi9ix1RsHn8eFG2n9Jyy0Ymu6SJG8ix1YCm7D6RGLxIpFzNp8uqVCejRiIV0E0YczTpjzdV5ty2IzX+sUwrRmGZU+1FkenL/xfBGnGcSmEJ6SeRcMZToG5vfBB5+lBc/MZ1X+Gm6LoXydNxzTCt+/zx17DZaU4Ntm2pASYcDUiXSQYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJdEFjF4Ghqmb4+YIXciIzpIzxARcPgpNzraYCs7IB0=;
 b=fyzT9QJaZbpTpA/uirGnsOJsEo+/yL1qJW8Y43ifsTLF0stvpfICAusfHVcRqVB4mrYm8O0ATxCmneYCHt7ozu2Jd0b/PEkdcEB2BdAAOCO9OAje1al1xCK1yyMokzXlWT6xgppJvtOdZdhBUm1tT7QCN7CBGf/2F1K3QuhsbdM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4778.namprd10.prod.outlook.com (2603:10b6:806:114::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 10:44:41 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%7]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:44:41 +0000
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
 <163466953269.2235671.2810573391142102057.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: compact deferred intent item structures
In-reply-to: <163466953269.2235671.2810573391142102057.stgit@magnolia>
Message-ID: <877de8ht6a.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 20 Oct 2021 16:14:29 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0015.apcprd03.prod.outlook.com
 (2603:1096:404:14::27) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.50) by TYAPR03CA0015.apcprd03.prod.outlook.com (2603:1096:404:14::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.11 via Frontend Transport; Wed, 20 Oct 2021 10:44:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6927b917-55ae-4f2c-c0de-08d993b69ed4
X-MS-TrafficTypeDiagnostic: SA2PR10MB4778:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4778470D0CB95CA9A172A947F6BE9@SA2PR10MB4778.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3NKAqc9dk+on393/yqAA9SUDEJoLOgbzsNKXScFAbJp582C1Hxhlm9YU1W+REi/HbvSjCcxBRKKqFIZ5EhrSLij4fSKWtMWOe8OjZ7Cv3krI8gxsseoI0w5uc3eBfISYIKfCgP5Svuo/ZwQPDBr49Civ/zU70FO37P5VATU/Z4XbYbJAf1R0otcyAsIEydvUb8o1HKgwVD9CnMKYSLemvaOD0vxOxkZNl354jnfWobSXaab6sPjRgFdAM61ZM7W0y5DHsQ+WSmfrpY/JMKm9z4ElRfjy0rLItD5qitNFkR/4d2ePFLFurK/uAMPKyUJuuWI09GUmapRpShdn2f1Xw0JMyzCzLlbsqJ0vyUveStus4iZsXRON7GS7qpA8SXKFWnzU0/II/LHmjAPsevDNFAcUP5TkER3Dids0RHoI7QaogAt1JD3uzAF2hQhOV+5enqJ1Q0a0/NCFwvSzIHnZDxkgtrsSYHEvRRYe3LkxhUAWBOEmP2P8mvGhhUiqm6i4SA/HUN2alulSjuKjbSE8Z4JcHxaVXQ9RLRcYsYBQ5l0BHffyg6yCJc99hGiRSTXohm/NQNyDa297SOGNO0KV3qdTL1iRTTue12evGJg2DFwL2rEfOCrDkIAi4LkdO27Aq2nWnY2EYF+XQ7hFw0eL+QzVQfdoue7nsEl863kwjdINan9UDpkyqtbj4E374+kGopXOeIEGAZ9z620wQRcVZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(66946007)(26005)(9686003)(6666004)(6916009)(66476007)(38350700002)(53546011)(86362001)(8936002)(186003)(38100700002)(8676002)(33716001)(66556008)(52116002)(6486002)(6496006)(83380400001)(2906002)(956004)(316002)(5660300002)(508600001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eZ0vlLuPcyVpghRjSvG+06VLjlBoJLmz4UF3NlkIctTZOKnO1F1SZsAY/kjw?=
 =?us-ascii?Q?aS6K7hmnC5mR4iGcyHhl5av0L2uiQOXszMFO+1Nm1PQyeHlzhywstSZf2zU2?=
 =?us-ascii?Q?knSahgnmgP6MBO3ILhvuvRahMpJJ/gju9cJV91g+qPY1TmdBF/esYLEQ7dmC?=
 =?us-ascii?Q?o4nlM0txjOS5qQ0IjscV+d4qOFmnSdy08Ig1hob8dn66xs2fFFuOYffPvSh+?=
 =?us-ascii?Q?sM5EDuFlNrdYA8u7FOLn7CekStkVeaR//TX+wSi2AL4YCxLv1gUJE+c4OTjK?=
 =?us-ascii?Q?3PUNSl96xFQJ7rAsh9ohRm8Dhe7QU+oC7dQx0UH/e+vz7UuJyjQsKc56xBfK?=
 =?us-ascii?Q?q0/HmY8IutoJwF3i2QUh5aGfGzxPqtjCTH0vP6YdJF15gogDJt5KvB+08RtD?=
 =?us-ascii?Q?Hc9TQdb2RG/Pu4DAPP0vXlNjy1xKmvRkLmLp5hT8Q7x6HqinLQBSGM1BiNzf?=
 =?us-ascii?Q?uIR7alP8JobqQAtpZidEtjqm8apXzVQ7aTUjsz+mQ05DDoBAmZdUbU7CERZn?=
 =?us-ascii?Q?ZhHpzUyy9s6M6IyEtv4KOLt2gG6ldUao1mhn6YOm7Q5nkefPFnESMoWFMPBR?=
 =?us-ascii?Q?vR0v1yCpHmzJApkVX3gB7M6tfRleSXgunPgne6lBsqzIPLTDhMfGzgKKZKGt?=
 =?us-ascii?Q?nCf9S4etYoisgrnZq3Z3Y/+ZZxEim+SmsNJIL12JZFatQyl0EQApYJYJjlIn?=
 =?us-ascii?Q?O/eWh2Ln67KRnChxyGCidAfu718WGR1GMiUykMTU25+hVV9RKCN/7GD12fvc?=
 =?us-ascii?Q?5oRbK6RQp2rs7IfaEk93x0iysiwgU7rDPROc9hl1aUvx8yrEqYggab2Fh3vu?=
 =?us-ascii?Q?e4aPY3yHOWdKueWWkulrVcpgqJxQqnznrXinTpu3wrnPfL8MKIe9sdKBrEdQ?=
 =?us-ascii?Q?p3vVA4ZRTJ0JwY7c2DTRZrKH3yJVW1uFXSt8jtXagjFMlVJlLaYCDNRjAS5L?=
 =?us-ascii?Q?YRiPjTgAJjdYFe5B9be2WMyQFKLIpMoFrtkBGQNuAzncLWWVv32C57Wot+/0?=
 =?us-ascii?Q?P05SGYr7DpdZiMnULAT2RH2or9Hc5qb/tffdTemGH9HM3jlZ+qjC60eXeCB6?=
 =?us-ascii?Q?dz2d5A4epHeVotPRL3ZN03VEY8Vg3YwTXjqYUyJXTpO5kOS0M1RA0bOYVC1g?=
 =?us-ascii?Q?uk0r2azY0Eq5s4dbQx1bYFuJPWwj3T4B7Y4bgux95iRN+bObU74uUbrlLVaI?=
 =?us-ascii?Q?k4tPd3o/yDAd2kmMixwJpWu9eI1HhC89G7VqaSri7l/1IztN1vRItmd4qE70?=
 =?us-ascii?Q?bfGMqMCo/sbJ0xX+gY+8QmLcthecOPiNxrn/BoFLqVvxyZjSOf+sWw1Tn5nG?=
 =?us-ascii?Q?TO/U11zLdXAeGTfXQrPH7xea?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6927b917-55ae-4f2c-c0de-08d993b69ed4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:44:41.0547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xfytFxh8s5EPeFKrOSbVVhOvABMKqLpKerH2jKLgv8ZTpQhIHbjDC/x4EX3ryReGtEvX0vxrQybTTJmuBsxeug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4778
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200060
X-Proofpoint-GUID: Z0L14iUTXhRSq9jCxtruzHdeHZ4CE1oU
X-Proofpoint-ORIG-GUID: Z0L14iUTXhRSq9jCxtruzHdeHZ4CE1oU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 20 Oct 2021 at 00:22, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Rearrange these structs to reduce the amount of unused padding bytes.
> This saves eight bytes for each of the three structs changed here, which
> means they're now all (rmap/bmap are 64 bytes, refc is 32 bytes) even
> powers of two.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.h     |    2 +-
>  fs/xfs/libxfs/xfs_refcount.h |    2 +-
>  fs/xfs/libxfs/xfs_rmap.h     |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 2cd7717cf753..db01fe83bb8a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -257,8 +257,8 @@ enum xfs_bmap_intent_type {
>  struct xfs_bmap_intent {
>  	struct list_head			bi_list;
>  	enum xfs_bmap_intent_type		bi_type;
> -	struct xfs_inode			*bi_owner;
>  	int					bi_whichfork;
> +	struct xfs_inode			*bi_owner;
>  	struct xfs_bmbt_irec			bi_bmap;
>  };
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> index 02cb3aa405be..894045968bc6 100644
> --- a/fs/xfs/libxfs/xfs_refcount.h
> +++ b/fs/xfs/libxfs/xfs_refcount.h
> @@ -32,8 +32,8 @@ enum xfs_refcount_intent_type {
>  struct xfs_refcount_intent {
>  	struct list_head			ri_list;
>  	enum xfs_refcount_intent_type		ri_type;
> -	xfs_fsblock_t				ri_startblock;
>  	xfs_extlen_t				ri_blockcount;
> +	xfs_fsblock_t				ri_startblock;
>  };
>  
>  void xfs_refcount_increase_extent(struct xfs_trans *tp,
> diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> index fd67904ed446..85dd98ac3f12 100644
> --- a/fs/xfs/libxfs/xfs_rmap.h
> +++ b/fs/xfs/libxfs/xfs_rmap.h
> @@ -159,8 +159,8 @@ enum xfs_rmap_intent_type {
>  struct xfs_rmap_intent {
>  	struct list_head			ri_list;
>  	enum xfs_rmap_intent_type		ri_type;
> -	uint64_t				ri_owner;
>  	int					ri_whichfork;
> +	uint64_t				ri_owner;
>  	struct xfs_bmbt_irec			ri_bmap;
>  };
>  


-- 
chandan
