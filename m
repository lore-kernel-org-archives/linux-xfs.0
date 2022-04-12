Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA04BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 10:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351637AbiDLKBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359518AbiDLHnH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 03:43:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD160201BB
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 00:25:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C2QjCH029058;
        Tue, 12 Apr 2022 07:25:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uSg6pazruv00yAnBm3MrOdbPmiRECNJzH+GyST/MJw8=;
 b=lFDXyqb6i2eUV3Q/Qq2B/tzS3N3+uXIqWzlsuI7JlAgKZ0OAnyV9S3k6aCpM/kZdMwK3
 FON+fzbj8Cfa0xORn0GLPag8dAMy/E0CQIxVVjGFLW9wptT4rLfP99v2xfhSxfUU8O79
 Y6x7x7IaVk+VXS5Cpyk7w8rKhi8v4HopLRPX8jyZ216yLZpR668hRqpMjI8VtaLRB5r8
 boUO9GWbftNlfwmwXA8EkxyiMNc/BAX2cHlNdMEoBAaaKH/R3UhUSL6AvNNstYZcROFB
 KuDp/i0Pg/owtBr3pyFS3ofWClQfG80PaREYKP5hMsm4PmSZaGUsqkrzJErkoIl9R+Mh QQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rs5wqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:25:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C77Mmm026139;
        Tue, 12 Apr 2022 07:25:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k2fhd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:25:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b37fDDiTosaWa8zzeRvDR5db8WcPfpGp8cgBMLoayI8oqACzYcSdglicryxzfmEUMB6KjSpQRraY6Qf0izjnokQUqFUnDk7JlkmcpMduqNnN3cRlNV464AJUHCvW0BvGGWntGNe1GdtX+tvk7UqjWm7sZkXJLjWHXnAp79yL/9aHPKdDXC+WoUvk12FEN1RlCNA7FUgbc/tB3GBJUmbhlM7Yerf2e6J8OuzVAnWastnEZiIO8Vcu4NwFoHZyMJLZEAh99IPwfrcGA0KfDcuYDrNRPAORNxIx6cShRdwpI200hoCd/g0mh0qbgLUqmfQNsEgu3Qcq12GNkBs64jIymw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSg6pazruv00yAnBm3MrOdbPmiRECNJzH+GyST/MJw8=;
 b=GpYM6E3mxX69ralHQ3qjbhL4QJRGjcbejxLCFJGnul9qe5nb8HEtDUfVdCAySkzteBI0yARxHOB7ynCDa8mgYxAPCTFjTrzeYdGUDMOrAaNXSIbcv58VDoV5yaPdA4oMGep/zCmL6BwZSVeoPLuhLo6EZ9/weZ35q1FrGmMZrwRyENykLfTVGsRhseCGA2geLx75FXnFIMZdUSZ8TWvewHK2G/Gw33ec/8U1jUuAr17BZHmT0zZ2I2CVJLTW7alarxO752GUKSsPGDyzxj69hMfhiSfHGctDfYazqbr8LaQmufCgWpY55wZDE4SiSpOwpa8hy/lahmCmbnZO9Hb9nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSg6pazruv00yAnBm3MrOdbPmiRECNJzH+GyST/MJw8=;
 b=gAa27/b/Xm9sjdKJ6pTTvYRw/ROd/RdVJ//QtEj8YHYxm2B2mN879xC/YOG9w7Tvt6ioL79WpeWz8kfmskZNnJjQS4YCX0Qh4lxB9yK+QluC0lYJqaElscto4ujutDET9FhAFDApNd2Ko90cLIIZtj8j+kfAYZwKD6ntfLw7J7M=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN6PR10MB1761.namprd10.prod.outlook.com (2603:10b6:405:a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:25:43 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 07:25:43 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-10-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/17] xfs: convert buffer log item flags to unsigned.
Message-ID: <8735ijvgvs.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220411003147.2104423-10-david@fromorbit.com>
Date:   Tue, 12 Apr 2022 12:55:35 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0051.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 256daab1-4d9b-4585-53eb-08da1c55a761
X-MS-TrafficTypeDiagnostic: BN6PR10MB1761:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1761BB1BDBFA32098204A7A8F6ED9@BN6PR10MB1761.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gbVM/QgyciGc+6GYFRF71pAB1Mzysh6PEEt3uNNKEGBGRuqbRKQd/sCdFyyrpCAdSDzuNe4E5Diaj/mTiWziKJPGC9HHo1MZTtwJk0DmUgKgwTshy3LeHU5Qdw2UwcrAJ/YjZBEWS1NVHEAqacRRFb0vh5VwkMGv4ynBO/owIBplAhAfv7PwD2c01ggS+aRtAMHhntdnAiQNnqUE8c8oBMZirhCf9SDdaUYMX+yqv0zc7xgQ6EqN9eAcaSrzV410pFy6SwXETBI9YUS/Q6WahGRdrPypZ+BitmLURs40BmUfOkZc82imVhO9oIK3p6f8jS69kOXwxNjZSjvPQjInWfZhPv7Bj2jvDscz2rPeL7KRZmVj+bGFY/AHadnqQRkve6mU/sCLnHyLbKJ3yq6IGC+vIoJS8qldfVlewY28n/z2ONTn7xIvHhsxycItZZvA9zztmP0Q1DB9nbY2jGs98nStxB3EnByQ96wnO4jfvT6RLXy5Qd/DCa2Kwcwei3FIU1yFItUAR0QOKs3ls+uQ2j9pYCANXiM6U9ULzCnmLioQhCLAtZ/DGIzemNPa6l92FZownWbzthjm9OeNXJBL3h5/3XS5PDMsDNOphAHJZBvqKv+iQJBz8Hb3bSAoEqtEpJNW55t4EHlRA1GmuZzvpFyXh/Eyv+l1HbWoNowdS0/a2iYP9gFRQ0REs56O4/gsN8ZeCTngH+rceaAs+QSn5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6916009)(6512007)(316002)(2906002)(9686003)(83380400001)(508600001)(26005)(38100700002)(38350700002)(186003)(6506007)(8936002)(53546011)(52116002)(66476007)(33716001)(8676002)(4326008)(66556008)(5660300002)(66946007)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f9U1sRwii8ffDObUt/5wVrHyLeHDTMZr+7AJk2nv+rSgNbVGAYltWyltD4Tc?=
 =?us-ascii?Q?pJ8TH2Oxc6Pa/KgHCJDI8fwG4joLTiUslGOSefSIoKsGpCL0aECglsDZMIfK?=
 =?us-ascii?Q?p7ohn5OnhJ7ZGfddkp45S0vpcNJzGzMOPceufEV+28GovLENQxAS93Z56ZLO?=
 =?us-ascii?Q?SgRo3mSbbCZ6CYONJe41JUD+9OqVQO2ojFN8aJBEZLiq/5s29ocK6Zcn1aRd?=
 =?us-ascii?Q?+UdqMnRP4MIUDHH9p1MMnX7so1QstHG86X8fQAzxi61VuEPEgEIcLcPifmcX?=
 =?us-ascii?Q?KnW4u8FKRy3YWkUVXBLUFe9Xwuf/0tFe+HIAhEM3yQcFxasU+omMJHnL1gaG?=
 =?us-ascii?Q?j8v2A3ZgI/hV7mDaJ+m1WI/BUPQk0BTUZ0KL0GbeWKw5mibwbfz4ncZZmHQm?=
 =?us-ascii?Q?v/v0AsnJC1rEKNoZ/WKetkzsJdRm4kA7vuR96cotDjxV9izXAbqetMSmpl9O?=
 =?us-ascii?Q?FWSavpnZKKADG27XLrfS72ucjJ+wImAqqRKbk/IYbNjDe3Gg8IsYMDmcgExW?=
 =?us-ascii?Q?51DzhEwznJdBYHWhExfZFFKdFGApYZu073P9EwPfXSpUeuJLhtr96wVkkM51?=
 =?us-ascii?Q?NQQkrSignL3rRL7FRLqhMk7ZxSjesC+4YeAbJlimpoD0Ha+6W2q5HOgt0AMg?=
 =?us-ascii?Q?ABFgb+RE2atvXLxaNiioN5JW4Xk3JxoRjfqKMDqygYFNCTOECukpWtn9VX9O?=
 =?us-ascii?Q?DU6X76uncQmqzKSYmfrLO/gjEQP60FJBS5BVIfz5G4GGXPVDB60xj8m8EtaG?=
 =?us-ascii?Q?+rLPKK2OrbMaZqaGqQWRXcoNeQr0FZK0f72Ac47u4p1PNEm/1NoHw4DEVien?=
 =?us-ascii?Q?Rb01d2RcuRvG2iIceCgpvjL+Bztuks8MeaVSNNGMCUXaCOO4CznU6Owuxltl?=
 =?us-ascii?Q?eNwmdN+orrRhqnx5h1QhVz4Beiaa6UCEqmB6TVyAhpBZUIRW2WXDZem4NxHg?=
 =?us-ascii?Q?uuhsfHv+4yaJDQdf17F26dPhmpHqEn1gjqtc3r9QwFsNpPNR8LIBXhf8Rtay?=
 =?us-ascii?Q?pA7bhTxtKlgfmJD6iOp24OLQmWSE1owZBH/tEqwkZ7jIucnnVDauYGbBmaoz?=
 =?us-ascii?Q?ue9uVIrp9wzuqOpLydlEez9rG0CFP/2AYMmmvQd4rqiw07i4J/Fv3gKnbRb+?=
 =?us-ascii?Q?lPW9dJ0EOj1X6wMRnYNNksk3CyRz1wy7f+NO8VBSPFb4VtnvSfUyuarI6XEk?=
 =?us-ascii?Q?LvO1SLB3icCoYjuXWgOHM4Hei4J2oqF9ZZO6pzC6MmmN5bt9wQ4fIC6lg2iw?=
 =?us-ascii?Q?MyCv7XOlbyjLtTo7GLvMrT5mawm1nKDSvTHPBdXoBCwxeRFzg4jdXDyG4+Nx?=
 =?us-ascii?Q?6pZCYB0Qs1N7iJsyH93zyIGZS+MOxOd7gbEehThkYiqTWq60/Ru2RF2Co15e?=
 =?us-ascii?Q?EnXfRU6hOxle7uAPJY/zKR3TNKVmrXgyUUHKE4L0jTf2f+GWeK3AsILiUopT?=
 =?us-ascii?Q?7LWPEL7WTiZRz0oT9l9FrszjD9MkqBexyHvH5EA///8UD4CDyIcXvXo1Zaje?=
 =?us-ascii?Q?JJhna7keE2SMfMiPFUzy3nRL+K2J1fxQM8Ax9Wf2dvQJVD5F5Yh6dbP6Kc47?=
 =?us-ascii?Q?HGQz1JIaRu1Bu+XQWhP0aEtEw+NFKmgsCmHAsLfhc+UkGBqY8WBRRoMCn3YR?=
 =?us-ascii?Q?IEpIGU47rvMAJ9FktvcBqeRB7cO3WpAqrNohFP4AWLTgsckBSdWWBWm8/IuR?=
 =?us-ascii?Q?LQip81NSQJ/siKK5/c2mJBux5MY5cajZlJ5+AsxNJxEqIMgKz3U7oWDD1/6I?=
 =?us-ascii?Q?zzZq25Z/htAN9MWdlCF9kPQdeZLzSXs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256daab1-4d9b-4585-53eb-08da1c55a761
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:25:43.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XdnCTjLiSm4RTimgZ67qphPv95cfaGmwexjK//4DkggSFZdKk47IG1tl3ExF3awAfromrAvYElrmtCJwuWn7bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1761
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_02:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120034
X-Proofpoint-ORIG-GUID: d80zNFtSAFPuxoQkgeUGR_LZaAIhvZsJ
X-Proofpoint-GUID: d80zNFtSAFPuxoQkgeUGR_LZaAIhvZsJ
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
>  fs/xfs/xfs_buf_item.h | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index e11e9ef2338f..4d8a6aece995 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -8,15 +8,18 @@
>  
>  /* kernel only definitions */
>  
> +struct xfs_buf;
> +struct xfs_mount;
> +
>  /* buf log item flags */
> -#define	XFS_BLI_HOLD		0x01
> -#define	XFS_BLI_DIRTY		0x02
> -#define	XFS_BLI_STALE		0x04
> -#define	XFS_BLI_LOGGED		0x08
> -#define	XFS_BLI_INODE_ALLOC_BUF	0x10
> -#define XFS_BLI_STALE_INODE	0x20
> -#define	XFS_BLI_INODE_BUF	0x40
> -#define	XFS_BLI_ORDERED		0x80
> +#define	XFS_BLI_HOLD		(1u << 0)
> +#define	XFS_BLI_DIRTY		(1u << 1)
> +#define	XFS_BLI_STALE		(1u << 2)
> +#define	XFS_BLI_LOGGED		(1u << 3)
> +#define	XFS_BLI_INODE_ALLOC_BUF	(1u << 4)
> +#define XFS_BLI_STALE_INODE	(1u << 5)
> +#define	XFS_BLI_INODE_BUF	(1u << 6)
> +#define	XFS_BLI_ORDERED		(1u << 7)
>  
>  #define XFS_BLI_FLAGS \
>  	{ XFS_BLI_HOLD,		"HOLD" }, \
> @@ -28,11 +31,6 @@
>  	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }, \
>  	{ XFS_BLI_ORDERED,	"ORDERED" }
>  
> -
> -struct xfs_buf;
> -struct xfs_mount;
> -struct xfs_buf_log_item;
> -
>  /*
>   * This is the in core log item structure used to track information
>   * needed to log buffers.  It tracks how many times the lock has been


-- 
chandan
