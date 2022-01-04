Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5B6C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 04:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiADEW5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jan 2022 23:22:57 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:63130 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232805AbiADEW4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jan 2022 23:22:56 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2041hvls008973;
        Tue, 4 Jan 2022 04:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=we4g0HYZjYIrP4uAtWjwON9WO/qWEI/bPJdGhbrZNQc=;
 b=s0CaHNHRnhFeFIOQHSrr0gGaEK1Bc9ZvE3fyu74a+IK+SbPk8mKNNQWM3xh1ZOLtpoHZ
 pD6iI1SHwhIrh0Xz5A3chTNnMrdOtqtugrQ2QfE32ZEEDzv2ItVmpn6LjDY+aSxj+zUR
 JmsLOu4TSN+HpUCBQkFrGM3Qfzd/48MfxDZz2QpvoUgLt2ZCcPKJiNfUfLWhvmrf6p73
 Kvi3DVRBwwjSWMk4uphUOJ1YTEWYnSkw/nr6R1gNDmkRETc9gig9VJHppvNe+FcnHEFH
 sqXiRk8u6XDuluzH65L/JcYqGaTJ4CXaN9ABmTO8ws5b3EF4Ix9pNIGm+5T5Yum4nqE+ kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc40fh673-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jan 2022 04:22:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2044LZMs123742;
        Tue, 4 Jan 2022 04:22:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by aserp3020.oracle.com with ESMTP id 3daes34wvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jan 2022 04:22:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfSQHL/GjychETd3hLLxh0waGN/9weyelfagyqNmwUOSPZBEtn99de3HfhmNHmGqCwYaw/GDJoMgKpbfjWf9EfIqT89axK0KwuHsVQGovBPx2bTtaDa33lfBV867egIn6DqUYlt9CvHtSucoB+CnTCeiS6VAaAZ4Lwwkd7h25JyQAqs+3oZ+Z0y1f7mylVKuCNrhlET/GIdq+L8S+mR0BC4ucmlmOMSp8dYQNqGUBC9pYmMBSR3WlkJfigAaUW4acRUSSyWFVQRuYJt7eb9imrG/cWbYn0LpyqlUNsjV3YY48km1ga8HhxLXSYEk8t5mlMCKJ/XLjrwYCDEn67Vo4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=we4g0HYZjYIrP4uAtWjwON9WO/qWEI/bPJdGhbrZNQc=;
 b=JaORu+Z9cQqmFWnQr8RYrGgcsIwnVnauWqwkXSgj8vMpGbU7AVJY6ehVIkpv/E52+6/zN8LqjIfLMc698KxKf6ncMwrRgnJvbJHUxpMElOPWBmQetZSFf+jik2cA/T0VvgMfzNbhQA+AGhyX8StXRHXADDhEx1CQveWW6y3YNWPpU/FS5STjCNun4CoJ5RxIhWyrlZAqzquNB1ER8ilAZHZqwjpK+GXw5r3z7u1ktq5Ph0W1REaWknOe9PvaDJSnCiwXolzsnvvVq1UggTxvOB9mUIiknL10mTEjpPwf6W/+IYCtNcp+128Ft7fpaPJ+J5j29d9c72OfoY438ZAE/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=we4g0HYZjYIrP4uAtWjwON9WO/qWEI/bPJdGhbrZNQc=;
 b=Y/XfGIpMDRWFWJd7YIcGmMvYSgKKijFpJ8X5GY7TwWU9uwJ6W82O0qUvb1OtGMdhwx3cVi4kCjcpe99WRXESke7JF+3A8cf8diVSgdL69jy+VyaFUygsvbQs1A/kMWc0//Dpw7DgbCkvJ5rXYH02RNL3n9wFqY2MkQ/XPOvoY6k=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2493.namprd10.prod.outlook.com (2603:10b6:805:41::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 04:22:51 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%5]) with mapi id 15.20.4823.025; Tue, 4 Jan 2022
 04:22:51 +0000
References: <20220104015816.GD31583@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: [PATCH v2] design: fix computation of buffer log item bitmap size
In-reply-to: <20220104015816.GD31583@magnolia>
Message-ID: <87ee5oi0z1.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 04 Jan 2022 09:52:42 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0023.apcprd06.prod.outlook.com
 (2603:1096:404:42::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62441f37-6916-4fbe-6624-08d9cf39df21
X-MS-TrafficTypeDiagnostic: SN6PR10MB2493:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2493AFA0152503CEA6A4F961F64A9@SN6PR10MB2493.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L/NSSbWLKSsrfL0G7Fbtv9kPTqur9xRLgM7qDpOY6u5f+0r2v4D71hhEwENUhShtzPd7oHxd5gk6nGGdy9O7cIzCkpcA+rU0Puddrp2ezjU4xXKhzLwhrBqwFmmA8jzShIpxV56W8oE8H9ZUNPYV8i225W0AkrTpUHX6sziLBbB1Jg9eI4hrCIkJ6ZOXPe2YHJxgSseYPOMcSYD8APCf3NNRHr2TRbtIFXfP7ciy5db+I/QesqYcRYswj3we+58sbR/I64JuBHT55NKsJZ5aTgztza/w4omkQJ0Yzym8X32+HXKra0VrC4311tohM2Z8nCXDi2oLj5g2TgzNuEPXeR74AmwHZfYhymis0e/j2ZeJD1V6nNTuaZJ3Jsipo/yJYsfTXA+NWT1g6LFM6em8jBqwk2fS3yveqAUQjOwiy6Apm1kSJRpx174S7cgRhQZM65EKmIic2wAE6cgtpFMlkr+u8zjcH7escm9poB+vuMARHNd4KIfw7fiDvCMmP8ho0sqNwiwV6OML/2QT5LRpD52K9B8RoYx33VVAXJFg94oqAgwL9ke3pAhQstiVHXaktv66hbBAAc6t1Dmj1KHdmexP4V9e/Elp+s0oSkpoiym+JRBIt20UfHaoY9+dVp1IMsSjF4bdIVeHWklomaK9YvXzmQB7uNmRLb/8oyX5kmKlo3mzp5hWUZGYXzAK3con0vu3eJ4Gw7aEf1WbFQSj4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(38100700002)(6486002)(38350700002)(26005)(6666004)(54906003)(186003)(52116002)(33716001)(9686003)(53546011)(86362001)(66946007)(107886003)(6506007)(5660300002)(6512007)(2906002)(316002)(4326008)(6916009)(66556008)(83380400001)(508600001)(8676002)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RGUFEJBEzAlA6ofspxzeZPN9wn2WCJAEMpfmIKDmnFZSIHy8T5ethcwIqzRp?=
 =?us-ascii?Q?O2u8cIpbHVFH2SXn4d9IeQUTRjDWGUnz86b99Z1QTEQAdva8b/FdIybU2fMO?=
 =?us-ascii?Q?LRVFyozJp7XzND5ARuM72KKcOfNf9rJGQYhTSDyERU2yPc4ObT6jzckdmbqd?=
 =?us-ascii?Q?QChnZGL0gVVCbvjCk95kGgA/izvL4VVE47fpaOpX3wjTI9wzNriBVxw+2Ell?=
 =?us-ascii?Q?ZhYRMOs767M+FNQ/v6sFgxqq9Etr4TQcRwoXm3mafF9ZlDhp7vLEQacma+HT?=
 =?us-ascii?Q?I4Bmo03hacmWtu3oPIFBZPzTbyHVQXMLLsFg2TAr9A6TmGRe1OaPM6pT5Uzg?=
 =?us-ascii?Q?VgTG3paliN0qlY9AxhWCylvt2DOVW0EkJHyY83oCtDSbwMXQXALZIZ121kV+?=
 =?us-ascii?Q?ytchACHZqki8pk3KguDPEsoFVUyD83NQsIitVxxmOyF0a1ekC/ZK6K9VJ+0e?=
 =?us-ascii?Q?KHsfdDsQqfSCj6lWe3BJZJS06g208rY9Zc5X1tGPvMuIzSaqTRUcobkHOlZH?=
 =?us-ascii?Q?BlIstg3AJZA1AO773qQhrRIH2vw8Kf7vujMZfYeRaocijXPbvfYTBv/V/iyX?=
 =?us-ascii?Q?7x8HmhNH6Jj4IsJqmY5ld8tBGRYMHpKs76/uJXLelSGWBgfh8TTbP6/56PW9?=
 =?us-ascii?Q?c/2C50QcYT+IiNvmy5PBUz8vSf00oLp2BwW1UsShNZnD2ZMU9TViNVrY6Nzz?=
 =?us-ascii?Q?xQEXJRvT27THrv8op9nWs3DRqvuZ+7z8C+MlUQID2UjdyluH/HzMPtjDwm3o?=
 =?us-ascii?Q?UVCmw0GYCcFoz6tlK4DpHzTgemMv1J9znrllFe/NRzqtkrTmDXPymdthrUU2?=
 =?us-ascii?Q?Ar4vkcUQRJlBuNvKU2ywIqncUp0ZZwXtTJr+TKty2fZKh8XdORKM4uWraJGs?=
 =?us-ascii?Q?SEk1OjHrwRREDOTbBu0rs6y35I0bNCAfZBQIFg8XG2Am7dfUu3QeR6AS05Fu?=
 =?us-ascii?Q?pEUckpkv0oD+Z/g3ewLovdxM3YE3IiiuEqnr4TK8f5yriCgY+4KoHJMo2vHP?=
 =?us-ascii?Q?R2pl5x9GXQNd7+cWkQwHDQ1bh+A6aSJYOmfAxQvi24tdFUrLdnBcQDdWM8E5?=
 =?us-ascii?Q?3XbHKi0ku8qergIvBdvNpafgWrzKBx3W0xfTwumnoT4SIGDuRYtPKDtxAa5y?=
 =?us-ascii?Q?zcijg9JMM8Oz0SAwNDJo1No/9PR0WP94Metaymvx+pYy5XkprHR4RGP1jLKM?=
 =?us-ascii?Q?6LRQ/MBq9uTqPzHtJypuRc4GBGXav1SWD81KTBElnU+dzd7J1gLi6XhLMjTQ?=
 =?us-ascii?Q?q6GWI+RAEQGns2Sun/UyxH3Dgn/QJfqKtE9hQHScGbgvshpTMBi2l1XBe7G0?=
 =?us-ascii?Q?CTdwK60KdKI5M8F+bl/e+/1DVMktjwRGmvT3US3h+WxXl1o+Utfg6kJeSzGg?=
 =?us-ascii?Q?O6E1OQcQXeO+33uPMA1xk/XZF8k7kmI4vgXFTfWGqVksthxrwgRBC+TSUnP4?=
 =?us-ascii?Q?l7bbVhv1IxY8Mn+hazKGzNqV0Zlyo1LseQJNhWhwDulPdrL25673pe44U2v0?=
 =?us-ascii?Q?/ww09Fh5iDJe+WeHlsPVGNHXgMYKq/GJfgInONQmZkG9WU81JBKodypxTLAy?=
 =?us-ascii?Q?g+lK6u9eqG0ofLf4RX0nbpkBzlSc36w6xfbm3GRjAjUpKJfXoLZLPLNzAsfX?=
 =?us-ascii?Q?n+qq/U41/4sDi/8PR9+0W/M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62441f37-6916-4fbe-6624-08d9cf39df21
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 04:22:51.5449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1XpoghoxdhA/LyQx5xiehSdBQBMjQH/tvfr4qUNECKV9iTvQHRDYWGt6x5mP8GgRN6oSfCvfM/xqIXpq6hT24Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2493
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10216 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201040028
X-Proofpoint-ORIG-GUID: iBKglQebSLC4vHmA7OgR7vWfdbpT4iha
X-Proofpoint-GUID: iBKglQebSLC4vHmA7OgR7vWfdbpT4iha
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Jan 2022 at 07:28, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Wengang Wang was trying to work through a buffer log item by consulting
> the ondisk format documentation, and was confused by the formula given
> in section 14.3.14 regarding the size of blf_data_map, aka the dirty
> bitmap for buffer log items.  We noticed that the documentation doesn't
> match what the kernel actually does, so let's fix this.
>
> Reported-by: Wengang Wang <wen.gang.wang@oracle.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> ---
>  .../journaling_log.asciidoc                        |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> index 8421a53..ddcb87f 100644
> --- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> +++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> @@ -867,7 +867,7 @@ The size of +blf_data_map+, in 32-bit words.
>  This variable-sized array acts as a dirty bitmap for the logged buffer.  Each
>  1 bit represents a dirty region in the buffer, and each run of 1 bits
>  corresponds to a subsequent log item containing the new contents of the buffer
> -area.  Each bit represents +(blf_len * 512) / (blf_map_size * NBBY)+ bytes.
> +area.  Each bit represents +XFS_BLF_CHUNK+ (i.e. 128) bytes.
>  
>  [[Buffer_Data_Log_Item]]
>  === Buffer Data Log Item


-- 
chandan
