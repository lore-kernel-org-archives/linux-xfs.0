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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9109CC4707F
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 790E1613AF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhE1A4L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 20:56:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbhE1A4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 20:56:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0sSu5048263;
        Fri, 28 May 2021 00:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fZXRA9IOvh3mTHlxwOBfqqpeIOJQcqcjJSDyWZa/Sbw=;
 b=fESGREw3Y1u4Cn1ZKMESTodNmdoKpUxgXUaOrZAQ1aAs/RiLdQIbWcKYNU5la3uSQfk6
 HVstp0IhEVsQxFTPcxIqexH44br0yb3sf5OBTUas/gwz7JUx9iKvmQgHwAxp/OXlNpea
 ubMCbfeDOJQcKDI3+NbNiEcF6lpY78BlSVoH5Rr/u+bwnJ8ChgKDUra2CF2DDRVt/oqq
 UKhWxeMUBGecbYMfxpZGU0yfzvvWLtSro5uvYePT6ETwKOi4kzgpwjRZABAiBl/H9MhX
 V4PCjRtboO0uL3pqd378+MC5FRBM233PtpEUlHfNFe5ofbG1wDu77ZqIW7Fh55DodR2d dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkpdkmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0kLxQ014672;
        Fri, 28 May 2021 00:54:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 38qbqux9yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0yCP5hQtbgeGmouq2AjYzshOISajGjaW74mvkIJp7yeVJ0ZsISg2CwppbKGfsR8oK5C+pLoirU6K6p3LBdh3iA2OzVAVgmM2lwcTs7Zp2XWcx8wPHj/2tJzbJSzgRKn35wvYbXzx3wdiKZfYzTpeXRIxTey/1oGl29RI/mydr+8SdO5k7X9DoKSqUIyhjVM249NcjoP7sc6Om0ZJViK4v673NlLyUMxiWKq8iFGmj7YJsG4T3lxFTBZISlLy9rgcI7E5LyQkmiyNmqn7g61tlg00k1LF9hOnPqZaWz4NtXxrAgwY4EPhtJeQh11klaZ8lkYiDi8X3IW4D4ZQdxPVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZXRA9IOvh3mTHlxwOBfqqpeIOJQcqcjJSDyWZa/Sbw=;
 b=JrSYPscB2JWkN1bqrWuD7vW2wmdR4eQ7+vbuKQ5wCyp/NRvCs13bNHYQitD8yoBaOveWRC1fmoFCxdCWi0pA7XDE2SWt0ZFq8rlF4irvzXlKBxqoWKqqXC2loI6cIQFGueguEqHd073jfDtdovLzuXV2OHrmvDOOY4sCy/HFoqo3ESH5Hv1GWZbBavjoM0xSqTsodPx7eArC8Q+BWXpFjCLSX13jshhlq/X6qGmrjq9jp8NNGF5M6JxJM3niz7KL7oTH2YJw23O4QnfWYIrgdS94CgGvlLCBRIDweeAKrZvRkVQC//wzZTCZhE4id5Rs/wUk5wYcrODVWvPq00GUTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZXRA9IOvh3mTHlxwOBfqqpeIOJQcqcjJSDyWZa/Sbw=;
 b=zz+2h94XhSjuw5wjn/mcp85tH4GqF0s/TKvgKBTeKikAtMJ9IFsYs5PQr1A7pVut6NLGG1RjWZyu6hSWMMMKL2hFknUlHtHiZUoemKlQhPfuEumvTJuTgWGrCDle5wS2k97cOJPixSniV5PCm0es+GvrBvgyYvL1OPv0z9T0Rrs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Fri, 28 May
 2021 00:54:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4173.022; Fri, 28 May 2021
 00:54:25 +0000
Subject: Re: [PATCH 03/39] xfs: remove xfs_blkdev_issue_flush
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-4-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f0a59651-cb62-298c-0d77-59ca415eab9f@oracle.com>
Date:   Thu, 27 May 2021 17:54:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519121317.585244-4-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0187.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::12) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0187.namprd03.prod.outlook.com (2603:10b6:a03:2ef::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 00:54:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03839ea3-ab68-47f5-5e06-08d92173238f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4510:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4510D8B22773D4729E98371195229@SJ0PR10MB4510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:197;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7QocV0L2TiTiNKLy6bnI47b7oB8HSynEXz2TStiQAtu7BO2Bbq9vO69RGouL9WPF4goqb42Izrcj93eDCFmHv3mNWcpubx1gWE4xKkz1VboQaSkdZ6ZLEiusYMss5fTYhkWGZNVdxcLB7xhfD+nIldvaVXXSHdp60DALFJLimO17Rr/5Eig22UOm6rsBWRTvovUAEAUs+tzdrr/bHjy9L1+oMy6gQUGryyEo0HqobXXdPfMKlqI5v4ljLLGlddvFeZqFc+afnqVBxD4/SclTbAOwPkevGKqnDdAgC7C09AD+40iHUS+XGbkOi2RBR6542CS7U6Km5HZgwHH0AI4Kf05X+qeUdpkHW5r+hccFdpRNwD5kuhut+fAYOpqzwGEBkWHtPsxCvBaZSOMK1LCM0ecmc7OSB/9b01mXIKdvQ/DOIip1L/Zk0d7C48U59X3iiNRCnwBcha+ql/pSp0T/h0pS99j8lWQa75W5MCqcVIDE5OdnP4cI82UN/RDDbhpCn9SA2BRM87KxR9v06DzyssUxTh/QmydVeGJTD/B9o3WYWw9DotV5aAJ7UgnWv8sRL+lScCsQRLy4FUWfYLPxPvl4Ohzj5d/NbnAkpBg9tn/L53SAne3LhMredDAYetKqbqnvyKZyk06lY8Wj+Ncyc2aRHTloITbvR/GhHTEF/Qlg3HTbSwlVIArMgt+FTygKUR9tpUkTHP4fXq5jV3kZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(39860400002)(396003)(5660300002)(26005)(44832011)(31686004)(36756003)(316002)(478600001)(2616005)(16576012)(956004)(16526019)(2906002)(83380400001)(38100700002)(38350700002)(52116002)(86362001)(8936002)(31696002)(6486002)(8676002)(66556008)(66946007)(53546011)(186003)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RXY1dC9pWmxBeUNMSkM1NmNHcjZIbFdLdWh5WHBuSEJWRnVDdHRpMDkxY0lS?=
 =?utf-8?B?ZDhnM2hkRHlJMWN2M1VrbmdIL1QvSGgwemUvQ1ZueTF6OFFwS01jMmc0aTBU?=
 =?utf-8?B?YWdHTlp1QXlJUXVLdHBQVXV6YklkT2RLTG1iejdSeGloRk82R1V3N2FvQ2RI?=
 =?utf-8?B?eUZnUUZYK3g1REFIYWZHbzhiVGt1RVNuczcxWHBVTXNZZ0ZhdWFJN1ZaOGRz?=
 =?utf-8?B?a0RSUWhRV3hLUDc0WmV2d2U2aDFaN2poeWdkY0F5dVdpd2dZVnQ5MjZLb1Av?=
 =?utf-8?B?eXJZZ2JYZWpPNVhsR3ZhTU1WNTZoZ2NrSUR5U040aVp3TXZac2Z4bHFVbmVC?=
 =?utf-8?B?cENLd1BoQzRPUUx5QW94YVRaQmxvMVE2Sk0xall3SlNLOWE4VGRPSEJQUDFI?=
 =?utf-8?B?TjU2c1ZiYXVrSG5kZHp2NmdmTThpaGtkNEUrWjdNNmpQeVRTQkVLdVliNmNG?=
 =?utf-8?B?KzhoSGNCMjZhUEJHME8vdnhwcTdqZmVqZDZyT24rSkxpN2MzNmF1bnBxWDRF?=
 =?utf-8?B?WWZETDNpOEd0ekMvZjVsWFYwZXByVTBzU2RpS3l0OElzQmc4K0J1djU2NkRX?=
 =?utf-8?B?b3NWSVJNL25INUsreXVKR0RKZVM5d3VZRUVMa2k1YXdvTUFab3F4MHA0K1N4?=
 =?utf-8?B?eTJIV1VpOEphaU5BVitVc0JGemlkL0JmcHRQdkQ2QStuKzBDMnYwbWVLNTE0?=
 =?utf-8?B?SUM0V01MaVlTUmhRZXFVVUxqSTRWcW4zdHNNT0Jxa3FLekh2Q0lYSkd1ZDdq?=
 =?utf-8?B?eW9ZYzBHTVUzTERGREFEL0FkdXkrUHpSWGdvYWZabXpLUDUzT3dCd0NzeWtM?=
 =?utf-8?B?elRYbm9sZlpKRERuVmxWMG5ocWlNK2VMNWoyNnpyeVI4anlxU3I0clFqZldI?=
 =?utf-8?B?MWtrTXRXYjVHeU9qWmp0ZkQ4eDJlVUJQYjlKSXZ3ZHM4WkYyaG8vYWFGT3Jz?=
 =?utf-8?B?SkpXdGFmM05EWCszN2RLWDVvZkZ5S084NnBKSE04eWR4V0xOczNxbXp0eFg2?=
 =?utf-8?B?bllUbis2SG1oREJxT3pMVU1VcFhlUGFMam1uT1VWOVllL3N3RVJZaDIzc0JU?=
 =?utf-8?B?REtRcXdSUjBqd1FvcmY0bGN5bmgzbWo3YVNQYkRxUTc4R2ltWVFBT01Qd205?=
 =?utf-8?B?bzlMWVVuQUEyNEVoZ3BmQ21EU3VtQzdzVTI0SE5vSWtIdkhVQVZxSVU2eG5K?=
 =?utf-8?B?b0NDZURWZVA3d1MveWZ4bTZ3azhCUk9EeExiWDdkVElDS0QvYkxacHFuYmpO?=
 =?utf-8?B?WnVibWloOGlOcmVBTU5hRU8rZTVXZk1sNmF1V2d6V01jcnpUSWRTemNVQ2xP?=
 =?utf-8?B?b1g3RkNqSkJIaHNQVUNsNlE1OFJUekxRRk90TVZJNi9adzUrMGVlNENScG9I?=
 =?utf-8?B?WFVad3hzYU1rS0wxc21YMERINnpqZzgyQkNMTXpaL08xKzh4WmxTODI2TmZk?=
 =?utf-8?B?UWRVTDNBWmhyRlpNUXlORXFFTEEvQTJ4QUhXM1VPZCt2L0w1bTZYVml3Y3pw?=
 =?utf-8?B?cnRwTVhmaldrdk91UGxja2M0VEliOWV5KzhZTVdCTkwvYVJkeVE3N1VlVzU4?=
 =?utf-8?B?OTV6Y2R3MmJBTUFmTEMzN1ZTY1hhMTAyaUlXNHZkZXg3dFA5bzdXYlJkRWd1?=
 =?utf-8?B?RnRLNnBXRVp1QjV0NEJaWDVoMGRhUTNONVk5RVAwMUV2UXdjS1huRnVQcjBS?=
 =?utf-8?B?S1J3R09pYU5JaG50Yjg3OWw5NkJWTDA3YUxlYWI2aitvQXdRcEdOcDFHb2Va?=
 =?utf-8?Q?LJMwRGjAXZZR9X9MWDCXb2xD5pzcRc2GvpWYPFz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03839ea3-ab68-47f5-5e06-08d92173238f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 00:54:25.2414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: km5w2pUoZH/rl6QXye+juMtsuutvPovR8IQTCk5JizNjt6egE4hbsGgucuiKtJft/FtrBK/2IWc8gAi8XsfifW0bYqF9nSNsM7L/YExKWDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280003
X-Proofpoint-GUID: q-x7HYlTh6L_gB81mvOB6-8h1sjvdbOP
X-Proofpoint-ORIG-GUID: q-x7HYlTh6L_gB81mvOB6-8h1sjvdbOP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280004
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/19/21 5:12 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a one line wrapper around blkdev_issue_flush(). Just replace it
> with direct calls to blkdev_issue_flush().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Looks fine
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf.c   | 2 +-
>   fs/xfs/xfs_file.c  | 6 +++---
>   fs/xfs/xfs_log.c   | 2 +-
>   fs/xfs/xfs_super.c | 7 -------
>   fs/xfs/xfs_super.h | 1 -
>   5 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a10d49facadf..ebfcba2e8a77 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1945,7 +1945,7 @@ xfs_free_buftarg(
>   	percpu_counter_destroy(&btp->bt_io_count);
>   	list_lru_destroy(&btp->bt_lru);
>   
> -	xfs_blkdev_issue_flush(btp);
> +	blkdev_issue_flush(btp->bt_bdev);
>   
>   	kmem_free(btp);
>   }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c068dcd414f4..e7e9af57e788 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -197,9 +197,9 @@ xfs_file_fsync(
>   	 * inode size in case of an extending write.
>   	 */
>   	if (XFS_IS_REALTIME_INODE(ip))
> -		xfs_blkdev_issue_flush(mp->m_rtdev_targp);
> +		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
>   	else if (mp->m_logdev_targp != mp->m_ddev_targp)
> -		xfs_blkdev_issue_flush(mp->m_ddev_targp);
> +		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
>   
>   	/*
>   	 * Any inode that has dirty modifications in the log is pinned.  The
> @@ -219,7 +219,7 @@ xfs_file_fsync(
>   	 */
>   	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
>   	    mp->m_logdev_targp == mp->m_ddev_targp)
> -		xfs_blkdev_issue_flush(mp->m_ddev_targp);
> +		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
>   
>   	return error;
>   }
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4cd5840e953a..969eebbf3f64 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1964,7 +1964,7 @@ xlog_sync(
>   	 * layer state machine for preflushes.
>   	 */
>   	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> -		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
> +		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
>   		need_flush = false;
>   	}
>   
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 688309dbe18b..e339d1de2419 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -340,13 +340,6 @@ xfs_blkdev_put(
>   		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>   }
>   
> -void
> -xfs_blkdev_issue_flush(
> -	xfs_buftarg_t		*buftarg)
> -{
> -	blkdev_issue_flush(buftarg->bt_bdev);
> -}
> -
>   STATIC void
>   xfs_close_devices(
>   	struct xfs_mount	*mp)
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index d2b40dc60dfc..167d23f92ffe 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -87,7 +87,6 @@ struct xfs_buftarg;
>   struct block_device;
>   
>   extern void xfs_flush_inodes(struct xfs_mount *mp);
> -extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
>   extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
>   					   xfs_agnumber_t agcount);
>   
> 
