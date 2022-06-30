Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CFCC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 01:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiF3BaO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 21:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiF3BaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 21:30:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8BD29823
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:30:12 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TM4Bb7014124;
        Thu, 30 Jun 2022 01:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=l9r9QCHXP0l+k2xPXeAUHpUEhLLxwN+GDw+98Z+uQzA=;
 b=AxNwRu4KamVmy6Xh7SEgWFU3BWPEj/BVoVsdNjLBkGX2kp0sWXF98Zz8yq0/pqE6psmM
 ynDYBPMVh89x1GoqYrssMnNsAyJC+1LwKWIYEi8IvW0Z71yZ57nKjgwB2HjVLk8gxQJJ
 gZ7v7JN4HYM8Dug8dX1zobNE/IblBiRRy0V5ZoLthAWPh8JeMw9oJB6wbtPRMWUdWzTp
 z2Kse+Sc/m5NOlSSIYclQ7h15MJDwmBZwqQ8JX9tmWHGYs14UBEN05lPWh46KGyLOwo7
 BqVPbZzRJkj32beQ+/fISH4/O6cT9T6Qc9OH1K/VajqokpU4tTST6JXO4fG6O9dIY4N8 7Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsysjnyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 01:30:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25U1KvKo037477;
        Thu, 30 Jun 2022 01:30:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt9kejx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 01:30:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lyy+g0D1mwpl17+7H6UMJIbiIrK+I9muoVR9X7AkQmGl7b9H+8/d42EFaz5I/16kpdXJFUiCGNouhaEiqjH6rA9VaKOq2gsarPGJ2vi+UEhRsX5SpjeYwGi/XWBL4K88eUmo7bp/kJdQHH0C3VD6uxf8Lx3lEiXmQiiSh/kA3KcpCVZMaRkAJTXDRnMsccNwD+dafCKqPjKsFDhxWWx0QPVX1MvxFYFjwUAthTC5ZZCW91MugxHMDl0eYoW1aZY1A7IPGL3LCVQ1aCvklVHXmhZZcAwi0GxFI2S9Hp29sN+4eCdYWp6YfmFPljmTRlZTrRAuLsdIEcupAMiQuQv0kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9r9QCHXP0l+k2xPXeAUHpUEhLLxwN+GDw+98Z+uQzA=;
 b=AoLd5BV1Uz1VXRYeQV+UuLdMnnOYoMNbvbmYkkYRPnkgWlCSGgbCAMR490x8buDNJrZMNDSS+Es1+4h8UiTLyBS9KgZ12NXrjwk6vhEEVTJtsEhQ0h/frQyDvS8alJp3z5E9xBVu4qgmr9mGLKZCDS4hjRcVNFfTcqyCSLlLAKqKI17m1Wt1t6lanS8DMKZNVB0S5XDQr8XDDn5vX4qrJll1x/DP85Indblwx+SlsGSCMnuA8pZanM8nCLjIK7g2Pg5clQ7e+C8eOcD/iaCqbbxszxPjn7aBGOBnBq7A9GYHohvNx4cZ0cCidDTp3CPk+gyWiQekkfeTKSaY5hhNOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9r9QCHXP0l+k2xPXeAUHpUEhLLxwN+GDw+98Z+uQzA=;
 b=LO6GEVxcHr02iFKiYI23OiksSyvBnb8zgiuIajGNrB3Ibf5SAyxX3LLsr5cXyTjGODa14B+m4/zBGPJqp95jsysIEgVdANzzxi1Dsfwln51Ui7mVKRxTCJ5rgFsC7MaKqgkrxHfA4oWFsRIwTVbnlk+1y8ghyYB3NO3fNMQLF+o=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BN0PR10MB5502.namprd10.prod.outlook.com (2603:10b6:408:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 01:30:04 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3402:abab:e2f5:33bc]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3402:abab:e2f5:33bc%9]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 01:30:03 +0000
Message-ID: <dbbdeb895015267acf0793daa535cfa20a72592a.camel@oracle.com>
Subject: Re: [PATCH v1 15/17] xfs: Add helper function
 xfs_attr_list_context_init
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Jun 2022 18:30:01 -0700
In-Reply-To: <YrydJU8b6rbTc33J@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-16-allison.henderson@oracle.com>
         <YrydJU8b6rbTc33J@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:40::17) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9858d0e-5a88-4c15-bba5-08da5a380eac
X-MS-TrafficTypeDiagnostic: BN0PR10MB5502:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1WFQp20I9XnfCfvCBnRDhJt44Zi7L3oJsmQVwwcOKPYlrcRy+/FuDPUUz0P1yVjVokvkSfRUI/MhEDLhBYonqn197o6RP149AemGUPLSUAr8IZbJRTiNy/UCcS1FBaA5/eplBbTw2b5NmL88CY3PfM2OwxS/OAoHtGJcfTWdTvrlcY2lwJpClEQxmYzkdZ6uRTkCgIglmvGEGECWaErTm0NPENhxhY359ZmpyjE3QJp8AqIPuS4G30Cn8O5025+xg+NwB2yAOfm9ggB8HcQieue/1QekwkN1TSoDm54japyiGWfLSQLipQCIT324CSBL7SG/GXp3R31LVANvF3zjQKd+n1EZ6J6Se7SGeKQpVzPinaMC3XZR+NRXlaYhdrPVcXZss97GYHmez5KZg3ZMmfDsGI05mfJzOMfauInwRLHm8zkTEGDPulVYXvP9gcm7J8vfm/jWFcZK/oNJIUuKX3AIle+6ruPWfnOH+MQsMIKXera17K/yj/rcf/MZHfCS9Cm9JgIPESfjysv2ysoY7IDf7RGUOxLjHhi5LQ/5X5BnqUxbuazUl/s2notk/l7VPjMfBNifDRYF+hG2VMcfz+cQvmqUnBS5DShX/IsX8THTef4FSZ83LFtzD1RMStEDHDcXNFajwjooDQb8hWTCZQCY33zoTd9uJuDZ5ZFXKG5uwyEg/5+PhN+3hwiVhk0J0FTvODE9kCoI8HKux7shvrl0fHXbOzFLl8XA5CiJJg+7YJaEHyAEM9UGLNucYZAgva614u4WQubGzjvCGeTySbPQYOJDIJIdcloc0umjudI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(39860400002)(136003)(396003)(38350700002)(6486002)(86362001)(38100700002)(2906002)(8936002)(5660300002)(41300700001)(316002)(478600001)(8676002)(4326008)(66946007)(66556008)(66476007)(186003)(83380400001)(6506007)(52116002)(2616005)(26005)(6512007)(6916009)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2dRZVQ1dnBEMERpZDZPeHZzVWY3VFNHSktEOEFBOWU3TWJobjZveFEvWCtM?=
 =?utf-8?B?dHJkTnNqU1RUeUhBMXVISUw5TWVlN0NkdUlwZk1YMTZHYzFDb1hlYzFVQUxH?=
 =?utf-8?B?THI4Qk82dko0VkN2N3F0NHkvRGV5WGVGOXo5bWc3bDBmZzFDNHZVUlp5VW1n?=
 =?utf-8?B?a1RFS29leFIwMHl5UHdWb0xyd0kwVW52QzdoeCtJVGtGU0RQM0dQZzhxOSsr?=
 =?utf-8?B?YTZ2eHZrSzYwVVpZL3ZVeFFnU0lCaVhTR0o1T0xWN3hsMm5yTXFuaXRlV0pT?=
 =?utf-8?B?ckpYZHhFUExHSTIyR3E5RDAyMlc5Y25KZEhub2tsMm5BNWtEYWp6UE54eDFY?=
 =?utf-8?B?RUtlSkVHL2RXK2E2aU83LzZmT1pqb1ptTlZ4eEhKZ3Exa2pWaUFETXQ0RjM0?=
 =?utf-8?B?cCtaTjdnaHl4SGI1TmxaOUoyeGFHZUcvYXJmZVN4ZEt4TDRWQUdEdmR6OGFr?=
 =?utf-8?B?Y3RPMStVNWgwUzNuY0ZJZjc2UDJYTEJOdFRTOEZBcG5OY3FmZ21WY0xKOHpW?=
 =?utf-8?B?U3VNOHZDZjhudVhyNWFtSXpIdmtkZVZsYW9hNTBNOVN1cmxzdU4rUnpLVVFy?=
 =?utf-8?B?K3JjU0RMbDlYZWpwd2haSFgyTTJkSGtRM2hDVkc0Mlg5d1lrQ0xTNHZKZ2RM?=
 =?utf-8?B?YTQrU3h3QUtoT0RvcWxoVDYwbG9aM3NSS0lxcXU0aVd2b00vcjhuclc2ZGV5?=
 =?utf-8?B?SjI5czI0RVBmSE9lRElES2lZTy9PRTBNYVU5RllZcW9XdTF3Um10MkxVdklY?=
 =?utf-8?B?TjdHNGpQenBaMCs2RHE3SVZuSC8wZkdXTzVtNHNCVVpaS2FXdGx0WjlqMUJm?=
 =?utf-8?B?OS9wNFY1U2RwRU90ZXQ2UWlhRVdEMkNxb2tucCtRVjdockR3ay9PclBJWURp?=
 =?utf-8?B?S0FqOEtMbHZaWDFtTHozRlRwbHVScDg2eGxvMWgyVWMvMGhFQXUyREE5TXAr?=
 =?utf-8?B?UEdnTm1EYm9NdEErY2xFY09rcWp4ajBVSmUrd3B6WGhzZytUS3ljQ1RYMy9E?=
 =?utf-8?B?M0o5cHJvRlZJdTBPK2hxVUQ1c3dJakc3YUdPVC92MzVvQTZyRHh5UEJFTi9h?=
 =?utf-8?B?c2pKaTIrZXlFeTRlN0xuaTRGZExwOVhHRnhLNXRnYkV4Mm0xU08veXplZ1Ur?=
 =?utf-8?B?YzhoOTFDSFYzVWNjMUdYUDJ3U1ZjZUdYQzlzRnE5bUNGQ3R1ZG91RXJyL2d3?=
 =?utf-8?B?Y2xCbm1Bb2VBTTFTWnozZE02UEU4aGRzRzY5UXhPUEMwTGw2ZURoKzZCdUpO?=
 =?utf-8?B?ZGhrVXNlamV2YTMybGtFUFlNSTZxdXUvSXRPVW10R2d6L0pIczFFaVdiS0Uw?=
 =?utf-8?B?RWFLTWpWN1NRZzZ6NTFBcmxBdHVzZ0RQblorc3R3dzdCNUNXeEl0ZCthOTNW?=
 =?utf-8?B?cjBiYk56YzJQZTI2ejRrYXpkRWpUYWNsZlpINWtycmR6V2VndGFZb0lDN25x?=
 =?utf-8?B?YWZMa0JPWjRsMFJMcXl5Q28xWi9iSitYemhwTStWSnl5YURKNzF3L3d1TzZs?=
 =?utf-8?B?MVFaeUpDWU1uUjArVklzTmMrY2R3bzlBSTRPUTE5R0g3UDdzeC9abllnc1p5?=
 =?utf-8?B?Q0xkVllqcmRNbHp6bE9YQk52MGtNN3VyNXh2K2lxWXBXVHV0dHFuU0NKcDRp?=
 =?utf-8?B?SWVPOTJWYmtHeTliZTNBa2FuNlRveUY2ZzJ5Sk1Hd2M2MlBONUZhWUVKbGI0?=
 =?utf-8?B?UWt1STVzeCsrdm85aWY2Sk16WWNCYldzSlZ2SjJNeVN6VjZWWkc1Mm5Qa1B6?=
 =?utf-8?B?c1ZmcUZyUVBjSzl4amxaaUNBRUJDcHNrUTc0bnRpcXJFOExnbVE2MVJZSGxs?=
 =?utf-8?B?eUpxQTYzd09tYjF2a1JkdWxvSlZoa0pBb3VUK1dCSjY5c3d4Rk4vTUZxMWN3?=
 =?utf-8?B?NXF6Z0RIdUxKSllzM1pGdEV5TEtDS1d1WDlTdG5yWWJzT3g2aHVyb3p2YjV2?=
 =?utf-8?B?TXVqNmptM1NuNXJTUGViNk1mVUt1NHcrTysvNkd6NEpqYk5qNkJpVVA1OHVG?=
 =?utf-8?B?VVMyMGcxLzBFSkMwUUFLL2dLSjBHWlQyL21ESDJIZFpYN1RhQ2tYOGFvSkR4?=
 =?utf-8?B?VG5qMDBDbXhjRHlmdGNaNlV5ejlpYU5LakJsN0VXaTBHNUI3R0NnUy9lZXFN?=
 =?utf-8?B?REprTHRtK05tR3ZuRjc1d0ZMZHZzbHV0RmVNMnorOUlzeTVuSkxNTFJveTlv?=
 =?utf-8?B?RWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9858d0e-5a88-4c15-bba5-08da5a380eac
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 01:30:03.8934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DcJaCPHWjho5wKxPnYocnJ7Dih+H52pUBFdZKLjRBO4yBvPsE9jPumnW0ciJe0RBdFrghNcRXpNiWL+6M2Cuv94HqLHgNDEKFrMMemteb2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5502
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-29_24:2022-06-28,2022-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206300003
X-Proofpoint-ORIG-GUID: uxS01WstZAghlgvCXVvq0pXrlkDaDhLd
X-Proofpoint-GUID: uxS01WstZAghlgvCXVvq0pXrlkDaDhLd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-06-29 at 11:42 -0700, Darrick J. Wong wrote:
> On Sat, Jun 11, 2022 at 02:41:58AM -0700, Allison Henderson wrote:
> > This patch adds a helper function xfs_attr_list_context_init used
> > by
> > xfs_attr_list. This function initializes the xfs_attr_list_context
> > structure passed to xfs_attr_list_int. We will need this later to
> > call
> > xfs_attr_list_int_ilocked when the node is already locked.
> 
> Since you've mentioned the xattr userspace functions -- does our
> current
> codebase hide the parent pointer xattrs from regular
> getxattr/setxattr/listxattr system calls?
I don't think it's hidden, but it has the XFS_ATTR_PARENT flag set so
that the caller can know to handle it differently than a normal string
attr. 

> 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> The change itself looks pretty straightfoward,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
Great, thanks!
Allison

> --D
> 
> > ---
> >  fs/xfs/xfs_file.c  |  1 +
> >  fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------
> > ------
> >  fs/xfs/xfs_ioctl.h |  2 ++
> >  3 files changed, 41 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index e2f2a3a94634..884827f024fd 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -17,6 +17,7 @@
> >  #include "xfs_bmap_util.h"
> >  #include "xfs_dir2.h"
> >  #include "xfs_dir2_priv.h"
> > +#include "xfs_attr.h"
> >  #include "xfs_ioctl.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_log.h"
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 5a364a7d58fd..e1612e99e0c5 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -369,6 +369,40 @@ xfs_attr_flags(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Initializes an xfs_attr_list_context suitable for
> > + * use by xfs_attr_list
> > + */
> > +int
> > +xfs_ioc_attr_list_context_init(
> > +	struct xfs_inode		*dp,
> > +	char				*buffer,
> > +	int				bufsize,
> > +	int				flags,
> > +	struct xfs_attr_list_context	*context)
> > +{
> > +	struct xfs_attrlist		*alist;
> > +
> > +	/*
> > +	 * Initialize the output buffer.
> > +	 */
> > +	context->dp = dp;
> > +	context->resynch = 1;
> > +	context->attr_filter = xfs_attr_filter(flags);
> > +	context->buffer = buffer;
> > +	context->bufsize = round_down(bufsize, sizeof(uint32_t));
> > +	context->firstu = context->bufsize;
> > +	context->put_listent = xfs_ioc_attr_put_listent;
> > +
> > +	alist = context->buffer;
> > +	alist->al_count = 0;
> > +	alist->al_more = 0;
> > +	alist->al_offset[0] = context->bufsize;
> > +
> > +	return 0;
> > +}
> > +
> > +
> >  int
> >  xfs_ioc_attr_list(
> >  	struct xfs_inode		*dp,
> > @@ -378,7 +412,6 @@ xfs_ioc_attr_list(
> >  	struct xfs_attrlist_cursor __user *ucursor)
> >  {
> >  	struct xfs_attr_list_context	context = { };
> > -	struct xfs_attrlist		*alist;
> >  	void				*buffer;
> >  	int				error;
> >  
> > @@ -410,21 +443,10 @@ xfs_ioc_attr_list(
> >  	if (!buffer)
> >  		return -ENOMEM;
> >  
> > -	/*
> > -	 * Initialize the output buffer.
> > -	 */
> > -	context.dp = dp;
> > -	context.resynch = 1;
> > -	context.attr_filter = xfs_attr_filter(flags);
> > -	context.buffer = buffer;
> > -	context.bufsize = round_down(bufsize, sizeof(uint32_t));
> > -	context.firstu = context.bufsize;
> > -	context.put_listent = xfs_ioc_attr_put_listent;
> > -
> > -	alist = context.buffer;
> > -	alist->al_count = 0;
> > -	alist->al_more = 0;
> > -	alist->al_offset[0] = context.bufsize;
> > +	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize,
> > flags,
> > +			&context);
> > +	if (error)
> > +		return error;
> >  
> >  	error = xfs_attr_list(&context);
> >  	if (error)
> > diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> > index d4abba2c13c1..ca60e1c427a3 100644
> > --- a/fs/xfs/xfs_ioctl.h
> > +++ b/fs/xfs/xfs_ioctl.h
> > @@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp,
> > struct inode *inode,
> >  int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
> >  		      size_t bufsize, int flags,
> >  		      struct xfs_attrlist_cursor __user *ucursor);
> > +int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char
> > *buffer,
> > +		int bufsize, int flags, struct xfs_attr_list_context
> > *context);
> >  
> >  extern struct dentry *
> >  xfs_handle_to_dentry(
> > -- 
> > 2.25.1
> > 

