Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD885C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 00:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442964AbiDVAkp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 20:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiDVAko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 20:40:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FD4443FA
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 17:37:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LLUPR8025975;
        Fri, 22 Apr 2022 00:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Fg9dDaUd5vhigDDJi4frL1B61DvrfA1PdpUhttcRzDI=;
 b=F2FRDuDo531aD54nBKeUDPt7MDhBfSpM5RD2vH2dyud1gjxnmDyvDIaiFrYMrP9tOTgC
 r8DETPrwv1+XRE/uKEb1t1vo/S3NAJ0zDyRQf5xOQc4B4QHV0wNyuhykqeRDaFBBl++v
 afFAYJ9j7dNAe4RusQ+JTfH89qWRkT1b8S5hvXTrFUm8ihKlZ2XFoxoQQxFEW+/vswMv
 zQH4LJksenyk2MNXZPjAUQh2QUEDak6F2S5bhCk7A/UNpdhrwqnKaOiH4JeT7sWo66ZZ
 v6jgmztGj1syeYm8eZVVYRu+3v34k0gzFHYJiMexOUuPRXNZ7eips4X7Ai5TIjhRB1Rl vg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cw4sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:37:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23M0athA023251;
        Fri, 22 Apr 2022 00:37:50 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm8a9afy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:37:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vp50atRiJ616i1NnN7LHB6SpJrmyqUEqEUaeh+uUFM8A0/2tX3wI09fYHbu0x4TK4/uhn/ly1iIcg81V6DTX01y+ekJmv1cKYXDJBlVKk5TNc8IK6ZSvNdlcf9COFcltcdGhAiy7aphcPwKc7tqtbKweUtnydYWFL4sE1qRncSBCQy9zEkrtnldfe7nxXUlBQmMPZpSyiH2fidfY9nP9HHzJ7KoR0uhI3X++UpTI+dw+IZ6IB94vCr4A4b/i2ZMb/od9jbaWGIcl1g4GmZ3ykjqTDjB22sRks463TU6fLv6W17od00xaftWuYEUxla4p5U/ZcMtxtF350iVRia2kug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fg9dDaUd5vhigDDJi4frL1B61DvrfA1PdpUhttcRzDI=;
 b=l2sc6gae3m+4ZOm0kZicEPj084ENrKdUL021Med7Zju6p9YnQ0hSjvGAdXjkD1ZybZsnZ3nxW9HkMbjlNwT3Pm0qFcsxIYrdSIugrc6Cs+Oy9MgK6VdT7/8xXn8eT11RD1Vhbnj4s+Q64rp6U74YXaH7Q+2fpu2DGQWCWMiwoUl0G7yXLe/Q8UYKq5t7WCK5C83ln35wmAPHhVOa7BdzUTvATS8RlvRSbXW1qH7baf9F9ps+TnDqpxzYB3OMKnIqBQ/T+iPDuFVoXK+STGERuvYseCJnEMOqseJfzfwbU5mPedZb8GuKlGEWS2OepC9Tatnjoh1JMGBey45nvkaWqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fg9dDaUd5vhigDDJi4frL1B61DvrfA1PdpUhttcRzDI=;
 b=c5kPQ4rgtIL6to6rr/sCLe+8l+6yPaPUmcFid2aFvCwzk9EiTD/q+rg4+Rf5Gpd1FzlfLr5cxItwJ5m2dLpbr48KHVIWBqzxSqDrKFd5YGbaOg6OfVEGP2XSmcRYwvKvF+2GfjBlpSnLGZuh8qZzZwlZiTL6GaYpxizJe3O3EYQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR1001MB2251.namprd10.prod.outlook.com (2603:10b6:4:2e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 22 Apr
 2022 00:37:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 00:37:49 +0000
Message-ID: <db42da82f0829c9ce59b959807b0156149099f8f.camel@oracle.com>
Subject: Re: [PATCH 03/16] xfs: make xattri_leaf_bp more useful
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 21 Apr 2022 17:37:47 -0700
In-Reply-To: <20220414094434.2508781-4-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-4-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecca01b2-d803-444d-f8d4-08da23f853b0
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2251:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB22515F37FBE8FB992CC2C33795F79@DM5PR1001MB2251.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1V4bp9UtF8cG+8pxH9OIYEehYlFoOAEN97ogyAPT8OO7WaB8o1QibUdM6mJ4oXpSjsf9nljwvYProb77Adyiw4d6E3kOX9l+KMYd1e+5vFYtCV1sOiEh08fp5PDRvBP5oEPnXKoO7t/dXPl1vlsMH9597fQ+Ev4t0jokjnzMUvd5HJiLHXCUg3QDVs8W+3LA1YOV9zVyaxjUtGpFvj3EzsSrxdXdxloc/xsd03gCYzZDk8lRlurEzfEjTcCZ8iM0SURHWFozxb1eO1CIDAeXozbG66pDHhraHd12WizHhr735TG1c2XEk3rtx6M1sYqXDiDDb2oiexbdJ1IQJtpYJ/NLAkQZhdUUsiBeo5PqUNDaho9vBtrLCgQycP+7wTDzV2nywok1L/hOkDMcEe4QcN9U0+uEBtoZlbDEoGW91LPimsjZybPeGwrl2MTDTzXZju98HDPz3vwlGC80pjKbpreTCQsuOYaZa8dMLIQElJW3ruAQJoDEX+LtsuysyHN4z/rOX2yr4EdwabInkz0gQqwZPWS0Jf1OQqXtPi/iI3A8lEtK3Wq8mDY52RmXvB3Oa0PyWLYEG45X2JjRw9Il9K+egxBAbr0VEZip40iu4sghcwxb8iN/KNEA/BjcRPVIGJ9JrzZ9rv5owkSSKOhM2aAfAXCheVLoA8CbZNwcjB/c6JWWGLw+iTKi+QpCoEeuUnopWTlScaNQrW0kiqAk2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(5660300002)(36756003)(8676002)(8936002)(66476007)(66556008)(66946007)(316002)(86362001)(2616005)(508600001)(6486002)(2906002)(186003)(52116002)(6512007)(6506007)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sk5JUlREd2dqeHV6TWZOZjdqYU5zeTdPTjJJcXZySVN6TXVYTkJjZXh2Mkhm?=
 =?utf-8?B?cTFGSjVWaGV1Mk5XLzMyVlNiOHZtV0JLYVN0em9oa0FhRS9ZVldjVFVZQXEz?=
 =?utf-8?B?N3czb0NYYTAxQm1QT1NVL1hJRGMvSmFyUWFHeUpDWlNqUmlLa2NPcVpLR2w4?=
 =?utf-8?B?N3NkNVVNbi9XNmM2TXRud3l0ZWV5OWs1c0R5NlZ0aEp3WU5qZHpPTHdOeStx?=
 =?utf-8?B?SnNPZWtqZUc2UERwOVhwanZ0WjJsVGt5YzNZbEZvU2J2bmcrWVVpcVhML25o?=
 =?utf-8?B?N2ZuOEM4eFhhSyszZ2NrZVZFTkR2YVA5T1l6SGE0ZVF5Z0g5TVZ0TUh2T2J2?=
 =?utf-8?B?ZFFJb2hUdzQybmV3OWFhYy80NnlqM21LbWl2cDUxdGM4REJOcVJLVExhdU5m?=
 =?utf-8?B?bkpjUFhEOG5RY3JoMnhyNDlQSlFYNHNtREdQNnhBU1ZRaEM5bWxIcGxhUm1r?=
 =?utf-8?B?ODNHR2JGN1FSMVkvWTdGZjZBTWxLNkttd1ZRQkdpTkE2Z2g1dUppdlI4cDYy?=
 =?utf-8?B?a1dlL2cxRjhqdDVrWndXa2VHYzVpdjJBS21LcTl4TzB3OHdBazB0QWRpeG1p?=
 =?utf-8?B?QzJwZWl5RlFJcEJRS0pkT2tmeHBGbmVCazZ4enY3VjdPTWZYYlM0NG1XOUJG?=
 =?utf-8?B?R3NhaUFNSGhmNTJhYk5PUzJGc2NIWjJxTCtGd2VjaFgrOUFUQkRrNkxNSkhl?=
 =?utf-8?B?QlpwZHhXMUlDdzF5Tmh2RWNoZEVmRS9yL0YwZkpDbktNdStUdndJTGFBN1U3?=
 =?utf-8?B?SzIzU1NjR0pZRHJOODZ3allwTzlqU2tkRVFsN205WjU0bHpsNklQbUVJRXdZ?=
 =?utf-8?B?Y1cvYzJmQ2U0bElNWXhFRk95NmFHc2NRWEZxV2xVeEh5VFZGdzdwVC9xQ3BG?=
 =?utf-8?B?ZXpoN2IrVXpSSy9EcUQ2N2VhaVVDcm1ucWNFNUZOaGRBY1gwVlQyZ00rdTF5?=
 =?utf-8?B?YmxJYVhnRXFMdmtvVjBZUExndlpRa0VoU0twdUFiQjY0VXVCU01SK1UrcVZl?=
 =?utf-8?B?ZDRINmh1NUtPUndPNkYvaHNQdHk3UGx0dDVnaXVnbHhmV0hYaXphQ1RFV0lB?=
 =?utf-8?B?clFhRU9MVHA2WU50R2lJdFlUK0FQRnkwSTM3TWVuaCtnUXNhVUJ0UmZtMGxJ?=
 =?utf-8?B?c2QxblNvNk4zZlRXcVFEZFhaMEYvbGdCUno1dkdzNmloOWVQOWpPekpCc2Iz?=
 =?utf-8?B?ZzlmbmhhWkZTWFZhSGc4ZStQRlhCUndBdVkrNVVZOW44UHZsMWx5V1MwV3ZB?=
 =?utf-8?B?SkV2YURaUDY0NDkwT3NWQ3I2QmZrU3JqQXY4TkZJNE1RWmIyclk3ajRpUnlX?=
 =?utf-8?B?RzVIMFh2WHZBN01lUUhsSFF5MUcrdUdpTFdVT1A5OUhjM1NtWmxVbmRjWHFi?=
 =?utf-8?B?K1ZzS01Zb1dGc1lwUm1Ed1V1UGRac1NqNTdTaUV6ME5naFg1aTNRbFN4VExQ?=
 =?utf-8?B?UDlsVmxGNkw2eE1nMVVTOW03N2FZWlFyTmQzR2dNRnRLczQzNVBXOUlYZ3pm?=
 =?utf-8?B?T2VFeUVmMjdmQk56amJSNkxSNUVyWksvMzJUSmxDbWNlV0RKNk9zWTJNYm9O?=
 =?utf-8?B?Qm9mS3UwMllVVllDTkppRXkrV2JhRkgzMjVQNDZ4UUdqSGt3M0pWaEw5UXF5?=
 =?utf-8?B?TmJqNWxqaWxHS2p3YkVoOWJacHZSOEx2WnkxM3N0NmtVamxUYlFBd2NNTldq?=
 =?utf-8?B?MVZycTg0b0FibWU1U1kxY05tQ0ZGWCs5S1dCTmxOeU5vUTJmc1dabHV1OTlr?=
 =?utf-8?B?UkI5WHBWMjAxeGtLT3ZyOUErZGtKVE5qeTVab0k2K3hWbFlOV2x6eW5RS1Vp?=
 =?utf-8?B?VHdEWEFMb2xmUllPNnFnY21wdzQxbTB3N3RVOU5vZWRDKzFuZ2poK3RmR1RD?=
 =?utf-8?B?Z0F5S0l0ZTZ5NjdobDBpL2IvU24vNmpFTkJGYitLOWl5K0lRMVZENHN5WlIw?=
 =?utf-8?B?RWpuMUQzbmxzSHJKdHFVZDFoTlhsUExFOGFieE5EbkpBNDRmU1dXVkZ5N2RP?=
 =?utf-8?B?NDlZSzJxSlhCTUdJUVk5RmVVQnpoYUFQWTQrU1lqeGx2ZUNZd2V4YkJuNDM1?=
 =?utf-8?B?aW1FYXJGQW9pMmJNTVlRa2Zrc21jMCs5TXJSbTJWWjU4SlE1R3U4UEN0Z0Nj?=
 =?utf-8?B?R3A1TndhWVpPRkliWXJqdnpOSjhXSXJJVFMra0JNN2VicHdIUDEwMTF3ZmV6?=
 =?utf-8?B?WVJoWi9iMW5ISE1CK29FN2pITEpEcnI3VFlzMFdHOWRrVnA1dzB5N1J2Y3U4?=
 =?utf-8?B?U1VPZkJNdjhkeEg2WDFWaGp6cTNRZEZaVGtQL01uejBMRmFNZUk5VUQ0QkRO?=
 =?utf-8?B?T1l3cVdOa3RZVmlzUUFkLzlNSDYxMG5vZUFRYTJIc0lSMEtMOUJ2YnVNLytn?=
 =?utf-8?Q?2+W2O9ObcaczIJP8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecca01b2-d803-444d-f8d4-08da23f853b0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 00:37:49.0252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: au8Pp18Yk2yhdzs4wxr018n93mPJUNtwAlo3be5iTNn++a+dRKtkX41M+XXASznX5wsSOSO+/WwDqbVXud0elp1qfauKc4tZt4zfjnlFcts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2251
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_06:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220000
X-Proofpoint-GUID: Cl0XjQO6-QD_X79y7fD4nk0Yz2myVN6Y
X-Proofpoint-ORIG-GUID: Cl0XjQO6-QD_X79y7fD4nk0Yz2myVN6Y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently set it and hold it when converting from short to leaf
> form, then release it only to immediately look it back up again
> to do the leaf insert.
> 
> Do a bit of refactoring to xfs_attr_leaf_try_add() to avoid this
> messy handling of the newly allocated leaf buffer.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, I think that looks good
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 50 +++++++++++++++++++++++++-------------
> --
>  1 file changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b3d918195160..a4b0b20a3bab 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -319,7 +319,15 @@ xfs_attr_leaf_addname(
>  	int			error;
>  
>  	if (xfs_attr_is_leaf(dp)) {
> +
> +		/*
> +		 * Use the leaf buffer we may already hold locked as a
> result of
> +		 * a sf-to-leaf conversion. The held buffer is no
> longer valid
> +		 * after this call, regardless of the result.
> +		 */
>  		error = xfs_attr_leaf_try_add(args, attr-
> >xattri_leaf_bp);
> +		attr->xattri_leaf_bp = NULL;
> +
>  		if (error == -ENOSPC) {
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
> @@ -341,6 +349,8 @@ xfs_attr_leaf_addname(
>  		}
>  		next_state = XFS_DAS_FOUND_LBLK;
>  	} else {
> +		ASSERT(!attr->xattri_leaf_bp);
> +
>  		error = xfs_attr_node_addname_find_attr(attr);
>  		if (error)
>  			return error;
> @@ -396,12 +406,6 @@ xfs_attr_set_iter(
>  		 */
>  		if (xfs_attr_is_shortform(dp))
>  			return xfs_attr_sf_addname(attr);
> -		if (attr->xattri_leaf_bp != NULL) {
> -			xfs_trans_bhold_release(args->trans,
> -						attr->xattri_leaf_bp);
> -			attr->xattri_leaf_bp = NULL;
> -		}
> -
>  		return xfs_attr_leaf_addname(attr);
>  
>  	case XFS_DAS_FOUND_LBLK:
> @@ -992,18 +996,31 @@ xfs_attr_leaf_try_add(
>  	struct xfs_da_args	*args,
>  	struct xfs_buf		*bp)
>  {
> -	int			retval;
> +	int			error;
>  
>  	/*
> -	 * Look up the given attribute in the leaf block.  Figure out
> if
> -	 * the given flags produce an error or call for an atomic
> rename.
> +	 * If the caller provided a buffer to us, it is locked and held
> in
> +	 * the transaction because it just did a shortform to leaf
> conversion.
> +	 * Hence we don't need to read it again. Otherwise read in the
> leaf
> +	 * buffer.
>  	 */
> -	retval = xfs_attr_leaf_hasname(args, &bp);
> -	if (retval != -ENOATTR && retval != -EEXIST)
> -		return retval;
> -	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> +	if (bp) {
> +		xfs_trans_bhold_release(args->trans, bp);
> +	} else {
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, 0,
> &bp);
> +		if (error)
> +			return error;
> +	}
> +
> +	/*
> +	 * Look up the xattr name to set the insertion point for the
> new xattr.
> +	 */
> +	error = xfs_attr3_leaf_lookup_int(bp, args);
> +	if (error != -ENOATTR && error != -EEXIST)
>  		goto out_brelse;
> -	if (retval == -EEXIST) {
> +	if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> +		goto out_brelse;
> +	if (error == -EEXIST) {
>  		if (args->attr_flags & XATTR_CREATE)
>  			goto out_brelse;
>  
> @@ -1023,14 +1040,11 @@ xfs_attr_leaf_try_add(
>  		args->rmtvaluelen = 0;
>  	}
>  
> -	/*
> -	 * Add the attribute to the leaf block
> -	 */
>  	return xfs_attr3_leaf_add(bp, args);
>  
>  out_brelse:
>  	xfs_trans_brelse(args->trans, bp);
> -	return retval;
> +	return error;
>  }
>  
>  /*

