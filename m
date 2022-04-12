Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3BBC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 10:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243791AbiDLKA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359852AbiDLHnq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 03:43:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C548744A2A
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 00:26:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C5HlN5031973;
        Tue, 12 Apr 2022 07:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iFraxEXRo73ztw/6XuhRbHwA0I67eUFjzx3N0XXwK0s=;
 b=VHluqHNXLIespy9K7+a/zZD44bAKTNPjI10Nlh7WqN0oH/I7uJtXzY0/x5Gq9/fcy6JY
 O3lU/nq5Il91DBaYHGhzaAVQTudRWQwy6xjorZctaetba1jMZaNtJEdjngIgKdbdazST
 faAzzwWmet2XZEFsU0fdzbpXNDU+sI/WWuo357hr6w4PoFlD82IJBqihAI3mRgurKz9E
 USZrEtKob6+LSVvdgFonrcEvLYf2jC2WB8e47IDlH6NIvBH6DkDt4z1ZNkbzJyMkp2Ms
 HMMVF9Pq8sRqhzttkrYs7EBwD/3tvbj2bFpyrd0mnrn5raaGwyjVmLdX3W/ex815V8P/ Zw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd5r5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:26:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C7QENE010567;
        Tue, 12 Apr 2022 07:26:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9h3eq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:26:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esTfD6D+RjWlDzhdU6vV1rhZj9B0iT06lB0nOtsC8s1yBZ7I63Tf1RG4NN8YY1xV2U4FPqpbK+4MjIQ6EfKWZrRL9gqfO6QVUDQ/8hQzlhzZ2Cwku67ZvNvi5leXpZsWjlh+o4uUGlSsLcnwhUNmr45htut7PuOhNuVJS8Z+eJwAZ/ShuRUo5lhj0ZmOa5YsqZUhL48eIP5UcvLa+OjK2WyehXvQDoy7kyYHv+hcWKNkRyP1WDS3zhOgfQ2gBgTQB6PIe9Q76Iffg9an/RZdkvLB6uCTKbp14gnM1ItRLmvw5S8aN2V/TVSZSzbpsnHuE8AlkiRLcmjw2aExrohZIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFraxEXRo73ztw/6XuhRbHwA0I67eUFjzx3N0XXwK0s=;
 b=LvzQ6A/s6blNpkDxuk2braT6mxfORCb58vx8uI1ID6E1vcbDOaECzrFqneoqTvdqtjgvLRN9dlDA+0NAluapR+hiTbvtcH/lWUHuL+x3jUTGhtTc5jk/l7vB2IcchAxR0H0UwfkzSKTdsxemKkr4JLWFtbn+pUesUZaJEj6TILq79mzz2AFCoY5EqlCD38uB9nZw1sG4SE0HJRvSaAHMczdMN+KNJK+0jhr9gPZ5HEz1e6xe/giAEvEHWGi+LIstKz2iTdwyV9sbbF08oqP6uApEBXRxFRQ9i5lsTr4EToYpbPoXRfxklJnWGON74kFj1JqlSwJYH1XAsJEFo9S49Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFraxEXRo73ztw/6XuhRbHwA0I67eUFjzx3N0XXwK0s=;
 b=jXTQDvIDKZEpLsJLemPOToCkDx0u4NHLmDXDCdnsx08oxUiZnbhDo3gSzoaVdyYtOmDMc5FJzLZw24/cOEGq/l4yAlg+8lV1Zr5MgX+AfSbJpHDLu1qkb59FuxvbyYWnvkT//kPcoeuoDpF4z3nR96RvTPpXCMRV/iEIH9yHFdU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN6PR10MB1761.namprd10.prod.outlook.com (2603:10b6:405:a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:26:24 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 07:26:24 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-13-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/17] xfs: convert log item tracepoint flags to unsigned.
In-reply-to: <20220411003147.2104423-13-david@fromorbit.com>
Message-ID: <87y20azrs8.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 12 Apr 2022 12:56:15 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:195::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9186c00-50b7-4912-b411-08da1c55bf9c
X-MS-TrafficTypeDiagnostic: BN6PR10MB1761:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1761A73D15FC94A045720C6BF6ED9@BN6PR10MB1761.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QNtB4JJTC4cBVAe+1Seyp11oqHFcD8sVfpFkN5V2mGCFbrNkxImyKRnuwo+9R79TbtGgkk3isnzRaTvQyXCcMp/BNlaHWVFryH0PNkjQEToxkwp+OghSAHilW0naV0tkzkrkFBZ220g/qj/fCzbNax3xj+rpVm0UjLCmSjFdY05g6vF46pJrlm91rBlK8w8rFRCitsrSaLoxz91E4bWQSqCa41SeeAwFnFrGX7sPLc3JAMN7icdUOq7FZnx1FCpMX7AIMJIQ9kvYwQkidRwsWN2v0LWxKtmoMVwViO4aMy/zAiGoBmWCcxBHjLOAr8OcNSlyeNBEbsiSTjZvUZ/HHttHLpy2360dMW7aQqwvL+6ayYIf3yFR0ccIz0ivksGMKYeLXUezaonhemC9BIRKDAMWTPQ1+1/iREQgeo1cUbVHDOmlJ94iS2uMlegGVxIn0nK12DOWdAVCeyRxHvLd4sq4AailHa/0wM8VaFAPIexqJ9mlyGhZS8++kYT4nqZHhWPRcXOkRTQsGjn/swQrn/XE4eTO/qsdz9VoLD5C/uqHQtWNxWnCDMNOsTFCFGT/F748c0SMv10pVQfM1eymNzTzYNLJZq+iw5ZJlVqbmCTrsmAVg+c8TQvmE2HUmnrgxce8gl74bcQDFRNiTbrloDPYGz0SiwnuN8HMXkW/jIK3IZcZ0vdrk3qy4XfjJwN6mXMuOBsyDQmiTn9BtFyEOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6916009)(6512007)(316002)(2906002)(9686003)(83380400001)(508600001)(26005)(38100700002)(38350700002)(186003)(6506007)(8936002)(53546011)(52116002)(66476007)(33716001)(8676002)(4326008)(66556008)(5660300002)(66946007)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uLQ/8wOLWeDB16WVpCHWTVXGACpcbeHGTIGkxFQAWoSTROWikF3oPyik6Bxz?=
 =?us-ascii?Q?5U822nsZ3lYF5Ldu+avRE4U6NfnCe/YXq78Tpm2gUUoFEyZXmtB4vNupBiqU?=
 =?us-ascii?Q?rQ/nFxkP9GpkK5ydRijJvPIrUhiY3CAlrp3BpwBnwZMdDzc/CXQV87Sw6QT1?=
 =?us-ascii?Q?i3fanjoOfg/SmA8apsK8QPMIvfA0bheipEn2Uu6vQVy1P3yMggoH/Vbmomsa?=
 =?us-ascii?Q?wCxvM9jm5OLdWM8ZcOFaPwQgwAk7O2y2PYC1UHJTqgAIVNQL/CvqEOv9/eGr?=
 =?us-ascii?Q?+3yZWBLjNBEHDx/yscZDBccSfl/1XFg77COdk/RMESpgIS1dL0LH+numrGnb?=
 =?us-ascii?Q?0ShgxwGQdMtnzf6k6YFOJPJB0MDYLX62+XwGkKmcfigsv0veagg4WoE7og6Y?=
 =?us-ascii?Q?Z/aWAnLf5qtPjazOuOqlNJcr1NFtPnLr3/AUWCu9e3AtEgfBhevjq2x1XUKL?=
 =?us-ascii?Q?v4qN3YvoVyDkT5BrKOSXR1SH/Xyzosf9ShD7WAs1Y+qt/yvV79X+qva3VU6v?=
 =?us-ascii?Q?CbV03FNtm4bT/g4RIzlPj2/GxP7Vs2rwz6sXErBOLNb4h2NS9qZxNbSfxk5o?=
 =?us-ascii?Q?KnxYzm41pbRi2NJyuyUybLrOpjEM9IfuTjZksIEz8CmV+rXshhDuwwc1Pl+K?=
 =?us-ascii?Q?fttC6q9DSLzbX4to5nqZ5m7OP/l0lKm0hddiun9NUwZKcbGWqahcIDWwe6ca?=
 =?us-ascii?Q?JgynnTEjK1AA7m1wc5z8htqWHZU3UCGFcH6iSE624eD5vmtRPaIlsSyvEP/R?=
 =?us-ascii?Q?WMwA9W6zR59zCG1qQBGhXCuEZPGP7u2KwqiGXWBA9+316CezA1WN1QOI1E+I?=
 =?us-ascii?Q?ehVHNHo5wuhLTBVpXGq9exBfDPmSKa41vBUCbEYNrZHJ3yFzcz9XqvQoRDN4?=
 =?us-ascii?Q?sva9LPn62VJnuKNxkrDQmse0N1PGam99jxrJXKB9iVgEFMoYuMlrZ8JAC1Q+?=
 =?us-ascii?Q?11NV8J4Ij5AILM26hy+keRX7TjYSfsKwfmpezh5QjAmgbGLcdldRHJSD7qQS?=
 =?us-ascii?Q?dmcR2rPek2d7c7O+sQh5cmy+CIDYVe+vbVdgbkl5aQ42NBQCAwrgParQW7hK?=
 =?us-ascii?Q?/ZNZrrUKCc0984dgnBYyA2V/cT0U1+bT+0NS3uNVSZEiEDOeLGJb5XUyryTG?=
 =?us-ascii?Q?19TQNkK6FS3LD9mkeYuCQj7OzXYSZeTldjQQl0y1mPQyPsduI5oI18mhtEaG?=
 =?us-ascii?Q?YEZR7vlBMk5BfWPXrz4cEZDF5UMDL6k7w0E6tlL2n2zk6W1CWmddUydYzQP3?=
 =?us-ascii?Q?twXQKQXWFVtJofYMNzk+4qACqPq9N8PLWF7NTNoIb6ypjRMyNrF0rAhCCMDE?=
 =?us-ascii?Q?dfGIlnilyI7xnRVvNzzAZdJi5k9xpSHRKUwfIkfafhY4Xv40s1th4M6U4fhJ?=
 =?us-ascii?Q?9VRbJ7ABm6s7YqBnGQKoQespsak9DWNCNiJKHdVGAw6AfK4Ytc+XS5Mu0hBw?=
 =?us-ascii?Q?WSTxaX15ymAZIj8egfUfEEuCAh8QjV17AIk6xyJ1yRh3MCfh3HZ99CzC9Hqc?=
 =?us-ascii?Q?bYNxgYY4ENgyyo0to67+sIv2ZVZZXyPSuu1Qg+cNGWk+PftfWYsmWKPQ5TDs?=
 =?us-ascii?Q?0jDoaDYV+YOdsmy+debXFAbrYN5KjA3n3GN8q7DPAUrQSf4WugBAktZq/+fb?=
 =?us-ascii?Q?wJQbUPoybxyRDVNHRzXLxpHBXWZtJn4h/U9yR2q++e5iZiPXoNdbBYvh+iol?=
 =?us-ascii?Q?4o6pvgHMHlNcWW3WuSQqQAvcfSBNK8nuYzrWr7PJrupOp9iicmku7JvoIxHl?=
 =?us-ascii?Q?4qEUDEFetTy24eTZ7KsxGDTaYOZilEs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9186c00-50b7-4912-b411-08da1c55bf9c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:26:24.1673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZzsD+xkWzwbOsVVi186pbRAGYGC08SBpM6aebnQdaR4USjH/1Nvx/kAxvXi5b5nemfyaGbMg2Z9t1W1DafGaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1761
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_02:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120035
X-Proofpoint-ORIG-GUID: 3-ONMd8A13tFHihauSUdW9PFAXS9IuvI
X-Proofpoint-GUID: 3-ONMd8A13tFHihauSUdW9PFAXS9IuvI
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
>  fs/xfs/xfs_trans.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index de177842b951..569b68fc6912 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -58,10 +58,10 @@ struct xfs_log_item {
>  #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
>  
>  #define XFS_LI_FLAGS \
> -	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
> -	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
> -	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
> -	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
> +	{ (1u << XFS_LI_IN_AIL),	"IN_AIL" }, \
> +	{ (1u << XFS_LI_ABORTED),	"ABORTED" }, \
> +	{ (1u << XFS_LI_FAILED),	"FAILED" }, \
> +	{ (1u << XFS_LI_DIRTY),		"DIRTY" }
>  
>  struct xfs_item_ops {
>  	unsigned flags;


-- 
chandan
