Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6B3C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Apr 2022 17:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243282AbiD3RFh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Apr 2022 13:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiD3RFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Apr 2022 13:05:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B148377D8
        for <linux-xfs@vger.kernel.org>; Sat, 30 Apr 2022 10:02:11 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23UCJH8Z003160;
        Sat, 30 Apr 2022 17:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=A+VPweC6DGLEvm93Ty4vjqfKu3cDoPS/LA+f9hKyYSg=;
 b=J33KeZYri2BgxiYdOhUC9N2O5eQKeHbBgYZST8QW+e4b+ARBHvO47DYtTGGYa1VeRhsB
 NnomyZANwsxlFCSQzQORndkLC+79VWHYP1wtMa+8jvJylMGMSpgqNvwPRw0vo7tXDZ5V
 uafq8hLvyFUCFTA9UbGXvNm+ReYT4lunZhm+DJed7nt5C1wfAqZq2Pnb63yGQKMR5ySY
 ABvXygZeMk+hBL4PUR2NIfUMzabpYhIbkE+p67tGDz28SA1I/9EmmpGPJmKKIy/xrqBX
 8SGVYOWSvWVdeL5n1pShMmr57Cyku+kGhiVdnD8a3hMnleY7gUt4sJnFOQJNxH+6HHmP jQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0agpfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Apr 2022 17:02:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23UGvH0P020072;
        Sat, 30 Apr 2022 17:02:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj6m39b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Apr 2022 17:02:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uc1NrNMqAP6vYttC0V+4LSme+MwK9vEYnBViuvP4Fvbkgbxyeu6iHP9TLNlIo6TKA2T+Dy4EdS0y+SJ6DjfVjar2SNKdo7yn6CbMvZB9BGIaE1qme//IZVsl9jyL3Q/OQU8I3gIlYQPgC0o27fZpMqI0EcR9ZWjE840GaRBr30ZUodQ+20PgpVNEJz5DoUMLUjXiX723gNg50RdcZNG1ChVT2JOa9YEZOOunUWYOq0y4g4eD75t0air6kQ7d55RS1taeHNz7E7OAx0RQ8pJpOwfR29Ye90eaB6cUWS6SAsLrqvLEvCN4tsQsudNI2o2e2Z6rK74/ZRZPdtK/hn/5eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+VPweC6DGLEvm93Ty4vjqfKu3cDoPS/LA+f9hKyYSg=;
 b=RgP4iqgIgJozGiAveduLQDb+K9X8MZdGORkZDeGsmryis+6GspdX5rj6S8CFrK6/EFrUVcRhAGEVxmREbVDNEjEsLCKKbSIt216ZwrjxU86cSI/oDvFmIlwYm4/UO+rM9DAv3wd8tFHhw/Q25Fl/WxwWOILk0Cs6YIXZtY+SVKGWVQlpXp5gamETh8vsrSNiLR9aWmHxNl8t6vEU53zzyWGn6Lt9ombG1s5KP8/43Hb/B7oaLCYtR0rhKs2ickPslw1H4wZoWnJ5Ql1N59jnZr61SOs7KGgI4LQo0tdOXkwGJ08UINN6RpDCHKDw5AVSg1Gaf55DeRO49MrTo2WCKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+VPweC6DGLEvm93Ty4vjqfKu3cDoPS/LA+f9hKyYSg=;
 b=ss6Nin3SqS50RHiod8YTje8aBob3UY+rShFte5CCAx8HJ3XM7wyycmoI3EhHVYACat8z3U0pk5LId/Vb0WqBwqWTmYTXQe+AnYEhQlnuPICg2r1oWpFKyDsbQIw1jJXkxF1P9iXjS/YO44Nn5D1hKBWc+xqyRBfODk1gma7M75c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Sat, 30 Apr
 2022 17:02:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 17:02:06 +0000
Message-ID: <a5dc6c020bcd216f399e0204e7047dd2e3b99d33.camel@oracle.com>
Subject: Re: [PATCH 2/8] xfs: don't commit the first deferred transaction
 without intents
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sat, 30 Apr 2022 10:02:02 -0700
In-Reply-To: <20220427022259.695399-3-david@fromorbit.com>
References: <20220427022259.695399-1-david@fromorbit.com>
         <20220427022259.695399-3-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0091.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 537e9a4f-e3e9-4845-7ce8-08da2acb278b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4654:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4654605BBC796322514D13CD95FF9@SJ0PR10MB4654.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qXpzHN/CnhDMaNcne/uhk8kOeL1CMPzANJXa6IavjoBkA2IMy8X4egPJs6KUtkBALc2JbKyWoU51S6rYgUswJ3/5HsXcBdtycNIIO32IkEFHK+ovyNfazwlcF0pLyjR2eSqRtDl9uv4EFDjlfc6ACGN4PlgjBXxJzr+D3Ll0BULcKRvKKMkitZjr9430baW3SVZfPVVUJHCKMuaOPBki5gGupTE2LCWiCCD4jgQEs/hbKB8g9utWGCvWc3mf0Kj1hHPdsGzs5im01KlzT/rxlR9U5zYez/OegVE2WkHPnCqtv8aZXd3D64X5oJP3IjfYnNjZECksK+w9IQzy1+sIj/MVgdAeMMPkbIC8zfhNcnwGNsKqZsafEbFWhU92jgniB/Et0Xbtw47Ie3jNzl10W9DlyMY880ICxftC+AmRUxp/EcP4IEfNFgSWHPUfO7pZyxhjkIRZt8Uwe6wugk0HAwuIK41KS1lDz4SycZnr1GdRvf9wZ3AAU1r2bBsSU4zApsUc5l/caflA5pt9XR0IaM/AoHzUDN34xxnADo5+3iTvwIihHfvzkV2VNe5DTT7Tua+YST9Z2JiiPF9AH71fR4tipto+04WILluNa8wackK7+KsZR3FFwEMcRlxMTz4gAds17hb93puF2z/gEfPePPVEvmpXF3roZQpUlQGL+iJtNikhPEWpzWj8S12vnxNBl7nlHOuL+OtnNLEVZEt5HA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(38100700002)(38350700002)(5660300002)(83380400001)(6506007)(2616005)(26005)(6512007)(52116002)(186003)(2906002)(66476007)(8676002)(66556008)(36756003)(316002)(508600001)(8936002)(86362001)(6486002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MExMaFJldEdaUHRBRkdKaW9TMUd0TEt5eUVoMGhQVHl1cmpHNUhNWExySUdy?=
 =?utf-8?B?KzlyK0J1UWhFMnBKUDFTSEt1NC9PbVhKeUpPT2I0MmdvTUJzTU9yNzVZTVZV?=
 =?utf-8?B?a2RuQVlxd3JrRkJTL3A2TDIvc0hZZVYxVlNMYkdyQ3BxTVZScE9LZllXSEpl?=
 =?utf-8?B?UWNXeVhyT0FaTlpvcHg1WE05TXVJWkdLNlBHdkUxMEphWnJ5bEJwUUZkYUs4?=
 =?utf-8?B?YllwNHUzSWhiTEhqSUtMUGk4TjcwZVhHQWY4MDBUU3hxSWxjU2tuZDZyaThN?=
 =?utf-8?B?Uzk0NHFaeEg2d3RFeHhSV0t4Q2hMWFR2SXZaTGluZnk0bmVkVUFzWjVqd2dL?=
 =?utf-8?B?bVpZQ2I4T2w4Vm1sVXFJWkFlNFl3Q0pWVTdLanVRZWJkVTdjUjBQVUIrMllT?=
 =?utf-8?B?OXltWDZ2Y2M2a0pNdzJxRjI2S1lsY0xacEhsSDRyS0V2WG4rQ1E5cFRQNE5o?=
 =?utf-8?B?aXAxZ2FhTElORllRRzF2YjJhREljM0R6ZGVJNVJWSll6bjNUL2NOZFJLZ0kr?=
 =?utf-8?B?Rk1naTJNTVRSUmwwc1U4ZjN1bWN0T2NZTU55TEtjaHJBajMwQndNeDZHM2dM?=
 =?utf-8?B?dUZqZFZWSGo4UUozdWkrc2JNVzBYSENUSmFqOGJWYXQvYUphNi9tZlJXTlJv?=
 =?utf-8?B?S2FtMVVZOWI4S0E0Vm9SbC9XSVU4MEYyTnZ2KytpZk96SHg2U2JWRnJKVmhU?=
 =?utf-8?B?bzM4RklFVTZ1c3pOelppVytIUTd4OWE5Wmh4ckNLVE1ZZVZ3SnRhNFR6V3p3?=
 =?utf-8?B?SEIwcTYvUi9KL2pBSWtON0Faa2RPdXVXV0pKUERXVVVFZ0czeGdiekxHSXls?=
 =?utf-8?B?d3ExRUxSMi9MZjVtRDBPTDNZbGZJajBTVnJTd3FzSDZBQUpnTlFFWVFaZjR0?=
 =?utf-8?B?U3lTNUZCR1B2c21aYUtFRThVSTRqYzBzZTg0Qmdqelo0ZmY2dHlxOTgzYjhP?=
 =?utf-8?B?UCsvQU1OQkxMNkZFY2krcTZ6N1c4eTBEMG9OU3UxZk1ITk03RFYxYkltK0tW?=
 =?utf-8?B?V3E1Q0J1QUtFMHBjYWNZMGowVEhFQUcyejhzS3Jyd3hqRG9US1loQ2JRVnVL?=
 =?utf-8?B?eExob1oxaEdSZ0NlREh0Tld0UHZYT2Fsd0Uvb01MWlZxc01CSk5UU0laTXl0?=
 =?utf-8?B?MG0xMEpSTzMyZ3p0eU43U0h3ZmxNQlFhY01DL01ha3IyQWVldko0M200K0Mx?=
 =?utf-8?B?T01mcWlqZkF2M2YrTnp6WHJiZFBzWE9lRzlOT3cwYTZ2VTI5N3hrYVc5cFRr?=
 =?utf-8?B?QS93S1J2N1RxZm5DS0Y0ZzNnbS83bnFzRjZYSG5KRzJLWUs5d0M0emxuSitR?=
 =?utf-8?B?ZXFrUTJsMXNscDE1dkFGWkFkZHNoVG5Kd2xyemtYekhCZkdTTlljNnJFRmxW?=
 =?utf-8?B?VEkyaUdpeFdWUWpuSFc2bndablN4cUdjcUlWZGtialF2aEw4Mmo2L21tTXhB?=
 =?utf-8?B?SU5DNm1HdW1FSjZrZFVvNmt0Z0hkS2x6MEJMWUlHWFh1OWw5NGEvQnh1Nldx?=
 =?utf-8?B?UDAxNEpQUzJ5ak02RUhDK0lpUmU1bXdqb08wL1dlQjlLOUpuL3MyODJvMGxn?=
 =?utf-8?B?WHMrMUZnaHljYXAyTzg5UUtlVk9lZFh6U0ZRakdRM3Y0eUthVk1WWHFpaWhY?=
 =?utf-8?B?TUd3VEtiM3BxaDVFcG5LVHVzN20vRVJ0TVN3aTFFcTd3TlIzcnpwT0RKVmxt?=
 =?utf-8?B?bzlnSTZKR080bE5TcTRmQnFwOWg4OG5pVUQ4SFJueEtGL3hJRU42bUJwd2Vm?=
 =?utf-8?B?NzAyc1ZxdGlOL1RFUCthanVSWTByNVYxenJ2bFpPWXZuK251K0JUcW5zdm5B?=
 =?utf-8?B?YlF6R0ZDeS9hbTkwWDVPV28vMysvRjZVeHJvNjQ2WmNka2pJa04vZXFQRUM5?=
 =?utf-8?B?K1FCODdEZWZBTzlqRmFlejZ2NklEeTcvdUk5ZkVnaGlMdGxyL1dHUll2L2Rh?=
 =?utf-8?B?R1V2ZWJEdnF5UDlvckFnNVUxL1U3R1hrZ0Y5WjU2MVU4ZkVMWDV3VDBRUXls?=
 =?utf-8?B?SVdLWTdpTU5EQks2SDZ0TnBaMWFuREpocEptL2U0ZExzTnEwdUpKZTZFaGo4?=
 =?utf-8?B?SG8xTzJXTStodzRXWVlvei80THFkcCthYmxVbWJpTWxydUxLVW9OWWZlOGdz?=
 =?utf-8?B?NjdNS2F1STFRMnZDWG1JM25EcnNRM2UwWlpBYnBvTmFmZGM1MmxybTNMNGw5?=
 =?utf-8?B?ZE5pNFlyUk1LZVJUZHdiL3NiM2ZGOHlVNXdjNW5mb2xoUFNyL0FobFRYMXRB?=
 =?utf-8?B?M2JwN0FwUE94dHU2eVRvSTJKSWJBN1pWSnhMSHh5WnZITVlLL2VvM2tNbElk?=
 =?utf-8?B?dEsyWXIwaldIS09kNnNwTXhoYnFwMHpNa1NqYm1jV2ZjdWdLRFEzUDA5eHh2?=
 =?utf-8?Q?fkfDvIImZ9gY5v88=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 537e9a4f-e3e9-4845-7ce8-08da2acb278b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 17:02:05.9991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G4GI2sQkXIS3PjFTmfUcE5Eyrlhmbv8DXHdfg3Kzmlg7EccNm+/knYVoZOo/+BGKbFDAXryzSmFttY0snCSNhM4nTpmXfswA2ngNUrH1/7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4654
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-30_05:2022-04-28,2022-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204300132
X-Proofpoint-GUID: Bm_8zNm0rT7d8Ts1UhDcznj6tEwbEh8W
X-Proofpoint-ORIG-GUID: Bm_8zNm0rT7d8Ts1UhDcznj6tEwbEh8W
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-04-27 at 12:22 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the first operation in a string of defer ops has no intents,
> then there is no reason to commit it before running the first call
> to xfs_defer_finish_one(). This allows the defer ops to be used
> effectively for non-intent based operations without requiring an
> unnecessary extra transaction commit when first called.
> 
> This fixes a regression in per-attribute modification transaction
> count when delayed attributes are not being used.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Just realized I forgot to send this along in my last review.

Nits from other reviews aside, I think this one looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_defer.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 0805ade2d300..66b4555bda8e 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -186,7 +186,7 @@ static const struct xfs_defer_op_type
> *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>  };
>  
> -static void
> +static bool
>  xfs_defer_create_intent(
>  	struct xfs_trans		*tp,
>  	struct xfs_defer_pending	*dfp,
> @@ -197,6 +197,7 @@ xfs_defer_create_intent(
>  	if (!dfp->dfp_intent)
>  		dfp->dfp_intent = ops->create_intent(tp, &dfp-
> >dfp_work,
>  						     dfp->dfp_count,
> sort);
> +	return dfp->dfp_intent;
>  }
>  
>  /*
> @@ -204,16 +205,18 @@ xfs_defer_create_intent(
>   * associated extents, then add the entire intake list to the end of
>   * the pending list.
>   */
> -STATIC void
> +static bool
>  xfs_defer_create_intents(
>  	struct xfs_trans		*tp)
>  {
>  	struct xfs_defer_pending	*dfp;
> +	bool				ret = false;
>  
>  	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
>  		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
> -		xfs_defer_create_intent(tp, dfp, true);
> +		ret |= xfs_defer_create_intent(tp, dfp, true);
>  	}
> +	return ret;
>  }
>  
>  /* Abort all the intents that were committed. */
> @@ -487,7 +490,7 @@ int
>  xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
> -	struct xfs_defer_pending	*dfp;
> +	struct xfs_defer_pending	*dfp = NULL;
>  	int				error = 0;
>  	LIST_HEAD(dop_pending);
>  
> @@ -506,17 +509,19 @@ xfs_defer_finish_noroll(
>  		 * of time that any one intent item can stick around in
> memory,
>  		 * pinning the log tail.
>  		 */
> -		xfs_defer_create_intents(*tp);
> +		bool has_intents = xfs_defer_create_intents(*tp);
>  		list_splice_init(&(*tp)->t_dfops, &dop_pending);
>  
> -		error = xfs_defer_trans_roll(tp);
> -		if (error)
> -			goto out_shutdown;
> +		if (has_intents || dfp) {
> +			error = xfs_defer_trans_roll(tp);
> +			if (error)
> +				goto out_shutdown;
>  
> -		/* Possibly relog intent items to keep the log moving.
> */
> -		error = xfs_defer_relog(tp, &dop_pending);
> -		if (error)
> -			goto out_shutdown;
> +			/* Possibly relog intent items to keep the log
> moving. */
> +			error = xfs_defer_relog(tp, &dop_pending);
> +			if (error)
> +				goto out_shutdown;
> +		}
>  
>  		dfp = list_first_entry(&dop_pending, struct
> xfs_defer_pending,
>  				       dfp_list);

