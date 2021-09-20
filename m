Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A042CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D49D60E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbhITKLj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:11:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11058 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234414AbhITKLe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:11:34 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KA20wG028266;
        Mon, 20 Sep 2021 10:10:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Mj5J9r3G8YwO7LxWbDkzKyJXZdcyTTxMyu3m2Bgb7Us=;
 b=Y9/uRTekXQHdjmKuokP+Hmc2SbhNMkaMjZCgfErR8UdgbdlB9qC5/GognsLfVzSIP27e
 j1VwZ0/FhNLyHAKpiCgvrwC09jjkVP3HpyCjzF5xR+kPLvQ21wFrIozsIXPeUR4cqtl2
 BM0XewkrMKGUrwsZ/xTf77lWNtEVmAFKIswDz5wiOqZ8qCLPAfsV0KG1gb7WFOnvzpsL
 B49VwjP9T/MH6gwekxuAHWQYuviokk02jPicmtBMFW/HXBzYZ5ioXUhPxrrzXIeAmla9
 IBekydagveQL2jJmQ3L9JIRqSLEnzl6TKN1CNjo1GKFv+1ZSyJsbrMGcLwrLGq/EocAv UQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Mj5J9r3G8YwO7LxWbDkzKyJXZdcyTTxMyu3m2Bgb7Us=;
 b=fkJlY5dlQmxSCbTIgrPCNdYGZ5W18M0oXOPAvudKlWJ8Br+H0sc7I+be4o5gVBKHAAMq
 1ET2Yo+bsSofVeNOY9hacqRKGu0uwBoBjeRsv+Z7+qVR8O/SC//qvM3Es2G7HpoZadwE
 B3QKKiZ3jXfU3HUfEqzpY5UwbSXozKCBYQwxOFdaeQ7eqATMRuS8BFl9I3r7hVxfuOyJ
 h9VhcAfEkUJrs8B8/ME8D4kkV568aVtsRuZx3JVB6YqSJj0AMqE9PQ5TkcLbtWAVe3DF
 9t2TBw6X+aK6DhUtmL4KGX22KnZ4qgE7ld7hfkBX+N2FBalPwGIVVkry2IuDhmcaMBdR iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66wn1sur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:10:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA4hVB096408;
        Mon, 20 Sep 2021 10:10:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by aserp3020.oracle.com with ESMTP id 3b57x3txjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:10:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQgKU3f7CkGGAiFosWctpI6GCPbwWPskTVmjz4VKNdNsCdDg8xN3u652rtymd/DYJPTHggIa+4TNSEE6Y/vMmv+mFtCtHutSP0sbAIgZHy9BOxHMSBZ56Tt5ciIwJwf15BxKrfsNcO5bp/DcTwMuy4Z9nh+Z7wGp6gZiyRAc53+x7FPSRL3faTm5s+jIV0gboT4dXgaafgADHvCA4D1q14UvtnoBVk0Sc/Q62KE4Ot3QHu94EsxnXPySx9jVt/z8FKqcEqXIy8cpn2ic/Kwdl/UaXaJ0XLJqZdSLZz/M/QGhDXEvGSpl65rd4y+YnfcKtbXx5j6UdSV4sP9HW8jgXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Mj5J9r3G8YwO7LxWbDkzKyJXZdcyTTxMyu3m2Bgb7Us=;
 b=br20IQE5liJsQ8mRu2nBQ8p8ImeOywlGBBm0lIIUa/iU2ivUFs57SXRIbIkxhDF+i4sp1v+dBEu1tCcPVwOjIueouEEBehzfXelN0+3bRVqVJntkEIr9ExpASfZ3fUgELKggH+6tIJFmoY9L4Ue8sqghkZChejIsVWztLCJDri9wys8BFQV3pkcM0+EFWVC0rB8GL3gkrRPQ21eCx4qSb1f+mz9/tW+YqpELxOOotBox/w/LRit4ogDIdaGaDlAfPLXY/Vag6vuK6EtHRkV+NtFFwsXaCXvcCNpWNIzSwUgqO7MherQP3h3/oU8yRea34y8gBDdp2FrbT1lfjU/EXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mj5J9r3G8YwO7LxWbDkzKyJXZdcyTTxMyu3m2Bgb7Us=;
 b=Hbib5sZTX6DSDDDcgmEfpf89GXzXtRYQz2vCgaLXwFkKrZGZYgzH6WIkn78PRJ6Q9UYQZ82dUjamNP//IpANNEcygShwhaIxvRV8shKw1O/6nI26grzda7cvy8XS/dmPxXEAazq8UV+wrHBCxDu2xmS+yMHNTYeXEgkOqPoBAC0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4410.namprd10.prod.outlook.com (2603:10b6:806:fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Mon, 20 Sep
 2021 10:10:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:10:03 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192857728.416199.11679791890386351921.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: stricter btree height checking when scanning
 for btree roots
In-reply-to: <163192857728.416199.11679791890386351921.stgit@magnolia>
Message-ID: <87pmt37est.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:24:26 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0150.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::20) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MA1PR01CA0150.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:10:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 434b91d8-d0d2-4c94-2c60-08d97c1ed04e
X-MS-TrafficTypeDiagnostic: SA2PR10MB4410:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4410C21923931F5AF20F2865F6A09@SA2PR10MB4410.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xUyEu+sJVsBlHxLJT2+uSIwXXl1OZxGcmlf7j0IJrm6AsBgWnAYXSz+1jdFHYK0wLZH8QlLHkKp4ztrgcMgR7/x0Wp/r4RFsJ6vYi0AYy4l7dL3E3jsCneIgCr+mUk6DNHkt6s+enDlMNVkkCAxBv3Zs3G2Wz+WqEwuTtMFbLBqPeDm2kzW806CvvA/4Bn3fnUP58PF2k8XbXfqtdCO4G4qSbSdT4cPfbGO+m/GhCw1XTc33KkZ5H+ObhHO06kwQ/C0iIPDeBI+JrpSjdwTjHvQZ2KVyW9S1G/fHhy0qn3oMnBsbDhHLL1xsn5YN/ObnKfMm8ftUYXkB5mdE8f+ZP6MJwEx0oK2GUuG4ndGs3M8tg07netWy5Mdbq+JzhYKw7MsOQMq2Vz5Yl3YQ/hQQVIXjZgmQV/EgtC9nS913DVd5C/RfEPfZ7AzEd/wJnZ21gjOYSpEbgzjVWohncfQ8s+0+iFK80K2ZzdBycbMXfcLvvVynth82tIfyOcKSt5tg5ZOroKUB2Q4ZEO1s4vSrNPCwfSvdUVVNMrUaZag3s48QHqZgLtf9t8wxVUUzsm515ioUEnopW/ohAmopP7V5STZSJtMQV945OPXdWd3WriF4Hff4tVidxMEYbNuQTUhG3EyePT7LWBQN/0e1wIyuoPRF5ZRJ/hA7v+UMU5rCebb2WkH0FRkSvtbVq12F429iIwW2ZfHO7Zsom4Xvroicig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(9686003)(83380400001)(186003)(26005)(6486002)(53546011)(66476007)(66556008)(6496006)(38100700002)(38350700002)(6666004)(52116002)(956004)(8936002)(4326008)(66946007)(2906002)(508600001)(316002)(5660300002)(6916009)(8676002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PnP2Ffs/NqAULNMIDTwqoBq3i0bVypZ6D3RJdjYVUyRzQpqDLNgj6eVY0OGF?=
 =?us-ascii?Q?4ho67fQcEVqXq4RUsfpcNMV3Aa5W0l7d5qtDvrU1XJOcuH+l+gi/o0bHX/oE?=
 =?us-ascii?Q?FeUONpRQlhbott87ZGcm7cWzjh4eR/dq17Qp7tChXvWyWI1bZM7mGM5RLVZP?=
 =?us-ascii?Q?gzUGhUCTFHoYjhXiIrzTfBTmbAfOV8h0EqscHtDuFyFD3RmdBa6noQ1iCY3R?=
 =?us-ascii?Q?M8nrfT9+7mRDrSNQiQ6bIa4xDaqyQFMvQpLRjWc774vJnBMHxCG4QyKb64nR?=
 =?us-ascii?Q?xYznLVv0Nu4DWcbp+Z12Xs1HrXbd9UWQPIV0U68CkG44+0wx40k6hb+sOJHL?=
 =?us-ascii?Q?8YVGeGQb3mwUSh9tjMu/2lgAKbdZfwbPCNIAYbhDF4BmSEgmGDERsbYziA1M?=
 =?us-ascii?Q?cLJ/4jyJRMwhGL5zk4OUTxbb0N7NCltQXqF2C4qCl4Ro8S+qU2gobmi9DV1R?=
 =?us-ascii?Q?P/gYg6/RpbvG+NqsDqiaNhNYSje+GM2DQ9rYGbkTKDza7qso+JA+QfBax/st?=
 =?us-ascii?Q?gpOvaywHdq4DGQ4oFWT2lXpucNCeC+35qHaEHPyYlga2wxfV61HfQy1Xiy4q?=
 =?us-ascii?Q?TkAOfGaSwUIqjdUmTi6g3Lrbetk63B2gyauJMgGNEoFRHwHt6K2H74pnVt7Q?=
 =?us-ascii?Q?L7kWKo/JfFgR4V0aDuJn8OWsaUnE1100j3WbB7geSvjgTvXWhavuyS/BRnec?=
 =?us-ascii?Q?+W2OsUJCv7g60wv8bm2tdV1VdiecZ5ziohxFS0dleUpiLQe2ioOvPRUCX4SX?=
 =?us-ascii?Q?EeOoE7hcsRws1Zr1cbto0Vd24Ym1TjPjceKyKrOILQn/hZaI/qQ+SzUwM8y6?=
 =?us-ascii?Q?sYCx/K8a04nTYVKCZqVmC+/41EsovS/N1QAKMIXJtzA7p1yzKRjch4PBOZkw?=
 =?us-ascii?Q?+TUVLWqmLGivkLtlLcBl8dM40g+v9DWzNdcczZtGdrqReBgiIsJaIu5yiiMh?=
 =?us-ascii?Q?RmV6d0ZD+ExKVb2uua+LXHx8bSQva/Q1k+j1qGpdm4rb9/UncvYGmI8wmIh5?=
 =?us-ascii?Q?7smIxj2To1mAAjebiT6nAR6X41BF6gU9TcyeV2wNcGpmKw/aIIjex1CfqtQZ?=
 =?us-ascii?Q?RoMdFaF4wue+EWzhLto6u6kBFMbLEFHYHH7INcpHQNqwA/vIQnYSEzFr/rMc?=
 =?us-ascii?Q?YegW84P4tvFtVScypexGikETna5KMu/Daqu6XOQK7rfEvfYKzQf63bkxwCmK?=
 =?us-ascii?Q?A/36tV3nlwLr/zdMAVP0ImhQjphF4DK77SWX5THNo7J5mu7Yh9oed1HWj+GA?=
 =?us-ascii?Q?cFDQfv8x6VHAFZTccxTOrRf4mi0dxbET/HQBPkONmD1Gbk8BydIrQ1bOC27r?=
 =?us-ascii?Q?DJvcyYfvJVLxeFcHXXd9YiXH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 434b91d8-d0d2-4c94-2c60-08d97c1ed04e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:10:03.8548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jF0LwEUDOW5qOaDMLSUbwmBzSZIAZ36BHKDB8hFY2BdZ1AMlzvsxI1NyBzit095tJ3TLxvIUAxG7p2YYyXXxdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4410
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200062
X-Proofpoint-GUID: BcWWc9XzYzjGy9WsjWhK3sNfxkzwWVIc
X-Proofpoint-ORIG-GUID: BcWWc9XzYzjGy9WsjWhK3sNfxkzwWVIc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 06:59, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> When we're scanning for btree roots to rebuild the AG headers, make sure
> that the proposed tree does not exceed the maximum height for that btree
> type (and not just XFS_BTREE_MAXLEVELS).
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/agheader_repair.c |    8 +++++++-
>  fs/xfs/scrub/repair.h          |    3 +++
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
>
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 0f8deee66f15..05c27149b65d 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -122,7 +122,7 @@ xrep_check_btree_root(
>  	xfs_agnumber_t			agno = sc->sm->sm_agno;
>  
>  	return xfs_verify_agbno(mp, agno, fab->root) &&
> -	       fab->height <= XFS_BTREE_MAXLEVELS;
> +	       fab->height <= fab->maxlevels;
>  }
>  
>  /*
> @@ -339,18 +339,22 @@ xrep_agf(
>  		[XREP_AGF_BNOBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_AG,
>  			.buf_ops = &xfs_bnobt_buf_ops,
> +			.maxlevels = sc->mp->m_ag_maxlevels,
>  		},
>  		[XREP_AGF_CNTBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_AG,
>  			.buf_ops = &xfs_cntbt_buf_ops,
> +			.maxlevels = sc->mp->m_ag_maxlevels,
>  		},
>  		[XREP_AGF_RMAPBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_AG,
>  			.buf_ops = &xfs_rmapbt_buf_ops,
> +			.maxlevels = sc->mp->m_rmap_maxlevels,
>  		},
>  		[XREP_AGF_REFCOUNTBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_REFC,
>  			.buf_ops = &xfs_refcountbt_buf_ops,
> +			.maxlevels = sc->mp->m_refc_maxlevels,
>  		},
>  		[XREP_AGF_END] = {
>  			.buf_ops = NULL,
> @@ -881,10 +885,12 @@ xrep_agi(
>  		[XREP_AGI_INOBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_INOBT,
>  			.buf_ops = &xfs_inobt_buf_ops,
> +			.maxlevels = M_IGEO(sc->mp)->inobt_maxlevels,
>  		},
>  		[XREP_AGI_FINOBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_INOBT,
>  			.buf_ops = &xfs_finobt_buf_ops,
> +			.maxlevels = M_IGEO(sc->mp)->inobt_maxlevels,
>  		},
>  		[XREP_AGI_END] = {
>  			.buf_ops = NULL
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 3bb152d52a07..840f74ec431c 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -44,6 +44,9 @@ struct xrep_find_ag_btree {
>  	/* in: buffer ops */
>  	const struct xfs_buf_ops	*buf_ops;
>  
> +	/* in: maximum btree height */
> +	unsigned int			maxlevels;
> +
>  	/* out: the highest btree block found and the tree height */
>  	xfs_agblock_t			root;
>  	unsigned int			height;


-- 
chandan
