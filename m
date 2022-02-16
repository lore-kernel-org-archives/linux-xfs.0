Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5711AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 14:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbiBPOsa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 09:48:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbiBPOs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 09:48:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFE92A39D0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 06:48:13 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GEiiB7005637
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=grFXYyKmrDRB8nCsnbS5gU/2+d0JuNV0M4M0NZOEFMY=;
 b=xY/nqHi/ForkK7bTMaRGeMiY/ekv9zyeJ+i/4XlIm8yxHRyc75b8cvNp2eyQi/20Hwzu
 5rik7ZB4UJ7smMYYl3bcUOwAM9Jw8DzsswDXvaUHZ/h4Y6V0u72bsxP5/50+UbMDl6Nd
 6tMCBlKxdsllbNNYMBxFMXFFTHBZ/k8a2zoWi7WJsBEkgX5zrWwwm2AIvQY82BgiCvzl
 Ak+9kL575SU/Kf+/HhTiFGMpyVEyYqrDHUxKJeGJaUNGNSZaIz6uagLK407UeUwDKnHu
 u8JFyMVW47yn3/uQD//hgizA/X9c3AMNnzXU3RRKSZU51tmNuBn32etAofp+Dy5Kqqic MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3dtc6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:48:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21GEk99s147399
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:48:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3e8nvsk7cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:48:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a211Z7+USpXcE5yRKruv4J9BINQnDOXLbTraeu44gW+v8e/y61dzk42++977NJpUbsXsiNEEkD3y5ol/RKRcunVRkAIkpsE/qCOOPhPEYuBGAI19tnuY/Pg2plU8gXilax07WvIseVawiggdaI3ubzmxTPHg36JoKkQJiXLgnQdR4BHeA6WxP/XGwL03w0Rary14M/yDkmTLxLjiyrmwdBjlzkqcsG0KGegdatgmGrBBkfr6fUQ5yQIuEI1pVsprf+5rAv9tZ3gxaRUh1KcxEhX0ojcwIhYAq6i2VlXYbS4oJ4kpPRuCOb2bzvKeNftNP+YNw7AwKKvaUcz7r8kbNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grFXYyKmrDRB8nCsnbS5gU/2+d0JuNV0M4M0NZOEFMY=;
 b=O+3Nl1OsvZIwPwkcLnJwdI5wX4/LgEHKADUcCueazpVEak8ldtM05MBqXmDdvoOs2iOBnmeqMN3xAhEYyq+QTDAF4BIc9astnepaKg6bbw1Z/8b4F91QHOW0RxYuc+EMcMYsdVbSap3R7O6sKvtWKPgmP2sqt7fdJaLEdzajB4X0d3cCNBccsldd6G+T7k4bX3fqaownpl3fRO3bNP+zDO5g+FcOeImoUdLygZlNseascORv6e2HzdUPn4wwv2kIPqrWn8RF8Fh2jo4rVCG/V0EfgBbSsBUbsWlOiwRWiqywCtK87bAmZ2z4HM4MeEDE0omVpXJAZ1LqhtojkcrL+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grFXYyKmrDRB8nCsnbS5gU/2+d0JuNV0M4M0NZOEFMY=;
 b=T7OG8xoKgtcMagdyx15I81qvDVcCFJhw0NJnJC73RA0Rkn6lU+Y5o8fh8XqmVfgLgBeAvV8+TOH0uc6uYRxSvxtoOpoC5Xw4/k2XbIQVZpNguzWGxu253IuLD/biVjYVGHgtGckqeEUbsUNbN4EgCo9lyExHU7DCYTE7CpuF93c=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR10MB1737.namprd10.prod.outlook.com (2603:10b6:4:11::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.15; Wed, 16 Feb 2022 14:48:09 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 14:48:09 +0000
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
 <20220216013713.1191082-14-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v27 13/15] xfs: Add helper function xfs_init_attr_trans
In-reply-to: <20220216013713.1191082-14-allison.henderson@oracle.com>
Message-ID: <87fsoij2an.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 16 Feb 2022 20:18:00 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:404:f6::29) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a0d9169-f7c4-4e53-4d17-08d9f15b594c
X-MS-TrafficTypeDiagnostic: DM5PR10MB1737:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1737959CE7A9024DE14C240CF6359@DM5PR10MB1737.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kYCcNPef8E+Ck6BM9NtRniA36lCi71B5mT2xDED2rBHr5P3BO4p1OVauED0hWh5H1W7XBxvuehViLP+I3yjUALiwVvw99+4vDQtmddGW+2QrekTr3amfaWdCGmrQlz0pfoMGMfqm8fvMoEQueJG7wNkSV8X8QMmeYoKp4YeEm3Sf0adaal7Noh6bbN7eXp5ARInAhsM5MBH64NgTkXVD6HTGnnueYA2TMw0WMsQimW6axn3mgYMsTWB+vujIGErxrk+YQRLyWXGvFhHy0hb3nH5MnDsp5f8SLu+A8PTj8589JEX54asb44Mredd20wR+4Amgt890TKXatldOT/gCirID33YsRIRPxu77G18Lm4WioDoNT3eanqDqe75NDvuUD4K21CdxPlLzKg8+CBLUfs7e7UkFyh7qhe6Srfh3VHkWmhW8m8swWWVv8P92oC/UvvIrY4Tiofj5sKgJJy0gh2AzMs5iUp0tu75Gw8K9XEka6OTDg9ljbf0KnJujfzM7Vgcm1jDpTzInaJ0v5jQu2qbBe8t9boxq7XuBTj8cPulMjfNJNgU252sMSE3crG1X+8peqxqQvFmBE7yXKuF21p24i96zMT2hpvheMHCaZ84ZFxm9O+sb3sLSWANSeDcL6SqlFxuIL9ZiXHRvTDFnlxmoh9R7nGFQLupG53CvT8R3Bm9nak0C3oZxOGZ6lpLxG4Z32YWFHFueoYbq1GY2HzocR8kHqdWsPtBHUPA3P2W3ERmgyye0NbLkkJJO7r+8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(66946007)(4326008)(86362001)(186003)(6506007)(2906002)(8676002)(508600001)(6862004)(9686003)(66476007)(5660300002)(66556008)(6636002)(6512007)(6486002)(83380400001)(26005)(33716001)(38350700002)(38100700002)(6666004)(8936002)(52116002)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R1HPROLwaDWypbh0ynIvsqof7REZq7jHHEy+kn+ar7pC+8Rx1YkOpKHiIO9v?=
 =?us-ascii?Q?gO7uY9lqyPWZCRQKChOEOpBNmNWMNicqDe91Oy7qiIyhFt7ZtfDME1FilIsr?=
 =?us-ascii?Q?ugp2S2n5j9nMDzQp0hYal4vYWBFys/Y4aeiK61pHSgSlq17omIoUrWIOmgoN?=
 =?us-ascii?Q?TokCvPLtoZVGXB4XAOdu1pOAhmAn8ertz410A+UFp9lQiEWGBVgltBnJiosa?=
 =?us-ascii?Q?cmb/JaWCNLu8CJzYq/7Hx2UzZT8jQi0Qz4TMRwD68svUnyg4aM1KcHSxycm6?=
 =?us-ascii?Q?uk9QV+6klTEf8/0p3C1heCsFwSdZgsqBds9vd8amJ1PCPu9MhmQLWW4BtCQx?=
 =?us-ascii?Q?aLsK+M8iSS9LiSZNbsSeAwqvr5f+QOHLueb39ZRKhhJ8lHT/1d1NYAcYhlf0?=
 =?us-ascii?Q?wfAF9fHrsnhZYUUDkMMW3K53fXEWV+b2n+uInIKFCXdczb5mgIFDdy9fpGKT?=
 =?us-ascii?Q?K4IC0X0iUIcZMnWx7yD5gCyLLQrlofrG4e9Wr/VlpnEUKRqO53nSL0q7VAp2?=
 =?us-ascii?Q?2fETdI05CrBCUmIU/oFAQ50NeHz0JUql/6IOKU4VmaREXwKjdX1/9uUKYzA2?=
 =?us-ascii?Q?iZbQXio8EzZpgkiDvOBYOKhMSs5XQl4AatAWE1QAYk86N9apy6p9GZmIb4g/?=
 =?us-ascii?Q?oUOha+1PlqQOBldGLbp37H5TecUJXFt+LBUg8dqpLyOogvSYr8hq+p9b7Y0F?=
 =?us-ascii?Q?uNoBdDK6YH1MAOPwBpga+XqTmhhROCXb5xvsCYVULnfbjIYcV6syukZFfXUE?=
 =?us-ascii?Q?rLaq3hs6ZThonR7C3WWnJw/ZI0lNdcAkHfFZu1835wttIi47wlyaRBJs34Bf?=
 =?us-ascii?Q?k/9tAL2i/M+DGpTg9eFWUnTtuQNvBj9suUKT+FPMLeMdwgEwvWuuffh8TqC1?=
 =?us-ascii?Q?1hLkeSFAEubCrrJ1vc0+aoikOcnBBzjW5RCA11IAcz8pblsvQn1dq1Sytm8x?=
 =?us-ascii?Q?/GWSsrLSf/rcqHQT2heLoqx/vkOWLnlvr6vSeuTq7IJ8yzokWWnQgIHv6ToA?=
 =?us-ascii?Q?rYLusnD/XS+bSrsw7I0jUnIeKN42ij7xt78htCbmvbV0B15iS72ivvMO+SeC?=
 =?us-ascii?Q?a7EAO7brp7SGpVWmzcbwVU22QIH3oZH4DKjvO453MmwhtQUk6N53zP3H6kUU?=
 =?us-ascii?Q?kWKzfg7VJ5Fny5bCBfYdTFWpF1yy1VqW9Z7W9tB0+oXEsQzZh2wOMhebWUMT?=
 =?us-ascii?Q?bbw6fcvKLD4GrcpGTbDp2AEKdrL+cst6inHYY2CqcU1if61baPggS52CivSC?=
 =?us-ascii?Q?kDLiS1vR4/cyuq79oBULAwjs4i59euk67TJFr1bOM8VAYxkkTGIB/VsdHPBw?=
 =?us-ascii?Q?tR+B7h/C0kGoKmq0CcW7bw5bmQCeiWRE2+D8t40DZOIy3etmDj7lQ8cSfRWH?=
 =?us-ascii?Q?yBQT5ovSNkhVq7GWmWjmV7JCMpqrhLGE3u4uEL1PQibGd/wqZ3Sue1ER/DgB?=
 =?us-ascii?Q?A2s8UQE8xqUOyde2qxylipRyjTjb6+KuWZNXxOA6TBpkBriDbwG2DKAi7gVb?=
 =?us-ascii?Q?uGpM4RK1pJqOOJERq3dZTbgp4kKzMx9p8yHdByC5lbdMO0J2ndt3nSNiDimT?=
 =?us-ascii?Q?lFrsNsrDoYYufgyT62xfkEajVwqfsOs4xpQrfN+HHUiDp5U/tiS6E7M1aZDC?=
 =?us-ascii?Q?JKxfru85U3fmIUyNIKb2uWM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a0d9169-f7c4-4e53-4d17-08d9f15b594c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:48:09.6981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: umWKwcBuzZFuVy7v6ULLdigWIo+/9tM31YJzK6QabnNOZDP+7N6DV1TjqZdx2feNuSVh0QsfmiMdxWK2l7d1lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1737
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160086
X-Proofpoint-ORIG-GUID: hgC3vRhrudC7phZ8XNZl0dqMv6r0bell
X-Proofpoint-GUID: hgC3vRhrudC7phZ8XNZl0dqMv6r0bell
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Feb 2022 at 07:07, Allison Henderson wrote:
> Quick helper function to collapse duplicate code to initialize
> transactions for attributes

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 32 ++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr.h |  2 ++
>  fs/xfs/xfs_attr_item.c   | 12 ++----------
>  3 files changed, 26 insertions(+), 20 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 7d6ad1d0e10b..d51aea332ca1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -202,6 +202,27 @@ xfs_attr_calc_size(
>  	return nblks;
>  }
>  
> +/* Initialize transaction reservation for attr operations */
> +void xfs_init_attr_trans(
> +	struct xfs_da_args	*args,
> +	struct xfs_trans_res	*tres,
> +	unsigned int		*total)
> +{
> +	struct xfs_mount	*mp = args->dp->i_mount;
> +
> +	if (args->value) {
> +		tres->tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
> +				 args->total;
> +		tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
> +		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +		*total = args->total;
> +	} else {
> +		*tres = M_RES(mp)->tr_attrrm;
> +		*total = XFS_ATTRRM_SPACE_RES(mp);
> +	}
> +}
> +
>  STATIC int
>  xfs_attr_try_sf_addname(
>  	struct xfs_inode	*dp,
> @@ -701,20 +722,10 @@ xfs_attr_set(
>  				return error;
>  		}
>  
> -		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -				 M_RES(mp)->tr_attrsetrt.tr_logres *
> -					args->total;
> -		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> -		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> -		total = args->total;
> -
>  		if (!local)
>  			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
>  	} else {
>  		XFS_STATS_INC(mp, xs_attr_remove);
> -
> -		tres = M_RES(mp)->tr_attrrm;
> -		total = XFS_ATTRRM_SPACE_RES(mp);
>  		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
>  	}
>  
> @@ -728,6 +739,7 @@ xfs_attr_set(
>  	 * Root fork attributes can use reserved data blocks for this
>  	 * operation if necessary
>  	 */
> +	xfs_init_attr_trans(args, &tres, &total);
>  	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
>  	if (error)
>  		goto drop_incompat;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 1ef58d34eb59..f6c13d2bfbcd 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -519,6 +519,8 @@ int xfs_attr_set_iter(struct xfs_attr_item *attr);
>  int xfs_attr_remove_iter(struct xfs_attr_item *attr);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
> +			 unsigned int *total);
>  int xfs_attr_set_deferred(struct xfs_da_args *args);
>  int xfs_attr_remove_deferred(struct xfs_da_args *args);
>  
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 878f50babb23..5aa7a764d95e 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -532,17 +532,9 @@ xfs_attri_item_recover(
>  		args->value = attrip->attri_value;
>  		args->valuelen = attrp->alfi_value_len;
>  		args->total = xfs_attr_calc_size(args, &local);
> -
> -		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -				 M_RES(mp)->tr_attrsetrt.tr_logres *
> -					args->total;
> -		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> -		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> -		total = args->total;
> -	} else {
> -		tres = M_RES(mp)->tr_attrrm;
> -		total = XFS_ATTRRM_SPACE_RES(mp);
>  	}
> +
> +	xfs_init_attr_trans(args, &tres, &total);
>  	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		goto out;


-- 
chandan
