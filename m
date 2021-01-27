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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6844EC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 384472072E
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhA0HUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 02:20:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43906 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317177AbhA0Amm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 19:42:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R0dAEL020153;
        Wed, 27 Jan 2021 00:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5PzI8FjGU3n/5s9hTTj66mBX8A6aQsxYj/bneuhNfcE=;
 b=bUNrpgSdk+GoGcXQn8qBWtvm57jhKbf5Rqy4+la3QtYw714lg6ocxzBfJS/QRY6jiDE3
 qnnzCNcXkh9FbA7uUzcPYSZX1W2YMPq6vA3nWuHlcpDi2MMKNOo2x1bNO0CBirUUIRGm
 S/xDVeJcwK8/b2mJmICTAnzsb2ZN2S3kO1+hQd1dvf73fFF+dV1D2O7+Xy/s67cjQ97S
 bRIiiIzKgSpWUDcmNyZy7QIntyH5jiy9HzSVLUFlM2dvWd60hpShpKlw5vPaMbBNuiwE
 u42v/2ZkQ8CCL67d2o6qryfrKLyOpPFiMpvCvjPel86fPFgyzKu1yPB6vX4b8IuQyLMQ UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3689aamuek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 00:41:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R0K9EP157445;
        Wed, 27 Jan 2021 00:39:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3030.oracle.com with ESMTP id 368wqx56y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 00:39:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRfY66CijSQyLpRRMu4gEkBGDpJxzH8XNOMMxNBZojlr00+aE548jXdjqaJcebjq/5ye0IriH82+8PucKXsp2x9eqUAJUdPpwfUhwN2EAUIz3+UYYs8/wBoZAtff1bMGwokUxnT9r8IwCEmw8e5abNHY19S6sCeMvakBDE5u+7quOxyU2IljyMI4tM1SpCrfuBODFmyPHR9fqsgE6zU2pwTCFdJZHyhQINYvA1q6i9HJjzERcbumPGCByr7bPYNrihCycpAzk23RfZLYxEJ/dbN+NpIXX4hqj70ux0FVYBnbHcsVyauE2cYvLcdDBPD5i3Msqqn4vk+NYOmrQ41Nvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PzI8FjGU3n/5s9hTTj66mBX8A6aQsxYj/bneuhNfcE=;
 b=A+C0uTtXXErOtwvsnN7TT5ceTdv0fDkcR31hWmDNcbgTzGt8XDSpNSWJAcPto/nBEzS95P0ffUem+OBRtzCugdJqN/kVGzAyo870MeIq5mQ0vziE3vcoqrEsUPIL35gGbsAtHw18Ny8OjE04U9cZpsReNDRRyIjZrgJRaGjGy1I1FTSOgm1mUsfOPOZOWBYPGyXLD7++q3A0GY/ZRwvnFI+d6IRX0xfrchJAr33Gn8+2sonx8dQR0q3muYDFWZi/m9jvxlcaLls8K9zXB3KgUZ85kuRdtDJ84eSGMv59upJdFScFjjTNPGV1SoIJq6SXflCHK5w8jkdmB+a7R3Xnuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PzI8FjGU3n/5s9hTTj66mBX8A6aQsxYj/bneuhNfcE=;
 b=kyZp1OlQmqck7lVonLmwviRlzMVJ94cNpDBd6cQgN/YsJev4m8IOONZ8W5DV9iLcGVETqi6pyhNurbvA/k2unTTlVoyTuhFTD3sDvVlEDIJ0l8iUB9JIq8tAFwoFWbt8bNWNMJOftY1oCM4dwaIBhWC2gBIC4SLw+7fsz8VTZJo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Wed, 27 Jan
 2021 00:39:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 00:39:40 +0000
Subject: Re: [PATCH V15 04/16] xfs: Check for extent overflow when adding dir
 entries
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, hch@lst.de,
        "Darrick J . Wong" <darrick.wong@oracle.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
 <20210126063232.3648053-5-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <44a702a3-6ae3-737a-c4bb-b24036c7ec34@oracle.com>
Date:   Tue, 26 Jan 2021 17:39:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210126063232.3648053-5-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.89.149]
X-ClientProxiedBy: BY5PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.223] (67.1.89.149) by BY5PR20CA0013.namprd20.prod.outlook.com (2603:10b6:a03:1f4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 00:39:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95c2d4a0-fa69-4cfb-50d5-08d8c25c082f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44963F5395774EA7509C741A95BB9@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XUvjKz5rwpocGk7OFP21jXSYQ3bucBSFfIbwUrA2a5KUswbLq58A3kmYmoqVqK++y6ttUBRhd/VeR02XwM2DT2EpoeXu/iKn6E3+G2pr6oM4+aqRIfXip8xbE7fLdD81/4xMMjb9hQOPFbdTBiCVKwI7ljl1OaGBYc1LyPR/TIA1VrpVdTpv3iuR9zTNBvl31xF6QykIpkDivhPLv0iJf5RK7hBp5kJoR2yjdWDtuU7TgggNMlPCCTTFDROAAqGmclIAaEPUTVKAMeK6byMAk7mnd6blcHUpNf09TYLsiJF4O/ByQfex8Z32VM5VXVQvhZeOn4esh/lME3BTudZMDumJY4fS9bV4iU4G9CcgJdyq+nylqEdDVIgy5BDpKlIZknKVb63+OQg/YeIwe7IVIHrb8mQAnwb/StFyKmcQzp2TROkTa7cpBLQOtJMQl3nAIeNgcq6DzCsXqAHBax4/vXTNB5wvm/2BLZtNeM1nkbwByz9nkGUKHTjU4wNx+8U/Ymxkyh/GoNSy5j8sEo3b1eNyUuxzOLGTz6RPYRfespGhm8PFyar1DSMHXuyMtJVKrHwAcyoSNElsyAcAEU/gCdLXb09pMoR8bDeSxSaGITI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(8676002)(26005)(16576012)(16526019)(4326008)(186003)(86362001)(6486002)(53546011)(2906002)(83380400001)(5660300002)(31696002)(478600001)(52116002)(44832011)(66476007)(66556008)(31686004)(107886003)(956004)(316002)(8936002)(36756003)(2616005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yxfhz1VHgZbT+uIeS7Jtq0Gz+nLfDy0JGTcB0tkl3MKjNj8T5M5ILFKk4IwO8FnU9fPD0Y4SNQRrX6k/4tTud8O7LMhvWBpwHlX1vapByBCW725gRbOwmenWRakj+1atW0aYkuQt3tHg0qIg5YNsoLapsN56pwTjwu5WYE8pnEsLVG6yAhMIH2iSeOa66VU0F2Pezg7QBnC4QZcVAQK4Q4NcDusX6Jk8e6ZEqSVigcOu9Dz6RpbWrFnkpaJW/P+zbpWVbHIr8qKKUtTKies7nsdBxKaFIenwEfvLuhsPH8KhHPV88Fd/lFpZsQxICzGff0MyRaroRmytdivY/N5vjt2pK3c94dCj3u/XQTAvwoMavRV4LBTAUmybvM+u5wTre/miXla8OzibV3XSDp4w4bobG4ITsxs/QuHR715pAbdy3DckceMvyPfdmYsGZtgXX9Ta1p6JUgwsrlBG3xUWBv9fyb69DA/7trppW2wRWQk2k9kB1Z2AKUJBDdg8dXJAM/MDeSnFRpJvrPpV/whyKE+L1Dc/rn4EqomF0q4QCwbeiLpAncJzcVSxcz2CT66QqpL/RMZFZ764pnWwydFCJ8zsjrh53MN2x7MwySpHB22Am1EyI82QHjRhsAL6OQCCSVi8OHocOTQkkRKlZABQysQBPPci9AOTPKdel2SdtAFvzP+WmjdSKgZ0WsJodIAk0ZzGbCx3to1GBhtRlhtsXTMShEqXdCaOE5csRH1vG6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c2d4a0-fa69-4cfb-50d5-08d8c25c082f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 00:39:40.4805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FgLzj+l95046WDBajT6ypWv2SkrTm/dTFp5VL8dweHHG9qsaGPEkt3UtVLZP+/TmbQG/SxAcLmkzDb7FuxjTIVNUV75s5yuKZQ+MpSmwhTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270000
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/25/21 11:32 PM, Chandan Babu R wrote:
> Directory entry addition can cause the following,
> 1. Data block can be added/removed.
>     A new extent can cause extent count to increase by 1.
> 2. Free disk block can be added/removed.
>     Same behaviour as described above for Data block.
> 3. Dabtree blocks.
>     XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
>     can be new extents. Hence extent count can increase by
>     XFS_DA_NODE_MAXDEPTH.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Looks ok to me

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
>   fs/xfs/xfs_inode.c             | 10 ++++++++++
>   fs/xfs/xfs_symlink.c           |  5 +++++
>   3 files changed, 28 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index bcac769a7df6..ea1a9dd8a763 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -47,6 +47,19 @@ struct xfs_ifork {
>    */
>   #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
>   
> +/*
> + * Directory entry addition can cause the following,
> + * 1. Data block can be added/removed.
> + *    A new extent can cause extent count to increase by 1.
> + * 2. Free disk block can be added/removed.
> + *    Same behaviour as described above for Data block.
> + * 3. Dabtree blocks.
> + *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
> + *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
> + */
> +#define XFS_IEXT_DIR_MANIP_CNT(mp) \
> +	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
> +
>   /*
>    * Fork handling.
>    */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b7352bc4c815..4cc787cc4eee 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1042,6 +1042,11 @@ xfs_create(
>   	if (error)
>   		goto out_trans_cancel;
>   
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	/*
>   	 * A newly created regular or special file just has one directory
>   	 * entry pointing to them, but a directory also the "." entry
> @@ -1258,6 +1263,11 @@ xfs_link(
>   	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>   
> +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto error_return;
> +
>   	/*
>   	 * If we are using project inheritance, we only allow hard link
>   	 * creation in our tree when the project IDs are the same; else
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 1f43fd7f3209..0b8136a32484 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -220,6 +220,11 @@ xfs_symlink(
>   	if (error)
>   		goto out_trans_cancel;
>   
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	/*
>   	 * Allocate an inode for the symlink.
>   	 */
> 
