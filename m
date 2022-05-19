Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63171C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 20:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244753AbiESUeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 16:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244765AbiESUeP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 16:34:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079E57A833
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 13:34:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JJxKEU016136;
        Thu, 19 May 2022 20:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nmfskrS/oIVC+my3O6IXGZkxvcqGlzTnrEH9GUO/Rts=;
 b=SGjSA0yNZUlKZtwb8TKxqXG2De3psTcMAmYG/qktj/UIzUJG8FMzC1LZAGyRRNuNcYX7
 w41q2/b86c9a+qsC1dGRZ6jt73ZFzBgh1t9I6E+cpKl7EBanCkfpPrc4QPISHNI4lT0Z
 5ikBvRiWWKnEIuvB/3Rwn6sBav5VPP2bSlAaFyRMv1NrvXvvS+ziW59iKQHKPTvs53+e
 XxKSuPnssml26ECy/d2wRgJQm6QXOhYyaSds5qwFLRSUIRhVzGtxCZ4bAJESE6MUwo7d
 DxEMilrwoETb19mFs0dYPh6ApVdzIuA0WO4M/fBtd+McWz65i9S3GPlxPCexbEuUsF9M xA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytwewf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:34:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24JKFftb009846;
        Thu, 19 May 2022 20:34:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v5cv7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:34:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K06o7KsHR9WVOFWZk8j5C0kWF9Hxn1vVbbkYoq+9pURFhyJsgRS+qOr26bUVtshaGafX+AA9sski4/HnSic/sLQ9L8qjWLllRW6chkArvoRYA6daz1zSsLqOvcTuBDu9+IlOfHue2sRbtLWSMvb6AWIb5r1euLi/f5Tc1KGI93j8DWBFede5ijknBA49YVJg5e3yugDbpT97aN760zHYOT1KUxWfggFL8FVl7cmJOLkouAH8pGV9TG9r+wnrgYsLZFsFrorMpKlo2kjdnD1pEj0f2XeDN3oz3zkn+mapNPY6xfYJxMZezVFGwXCuCRf9/ZELobvaX5yfCM7uuVF+2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmfskrS/oIVC+my3O6IXGZkxvcqGlzTnrEH9GUO/Rts=;
 b=R2SAcvN1vTgntfcm53UXSZ8L7JwijOfBjbC1YSBEd4ON2965ecD5qdX9c2M80UoAtPJc57OmijZdKUhzZrP5gT8LKxSBwFGtj3DD6sRIU0tsUfgTfOiSOIxMYV7adNXn6e2JX0FVovrpeBZNnJ42GlkD1e/BpgX+NFBxTUmEx6J+s8BfPmsS7FJlg5yXNtFAZtBGUs3raFay41PwHLNmj7/d8wSxE66aZp/fmBE92BhRZsGIdgK1xUF6rKQORrkssq9C9IdCqSSkf7ttPkpZULAYgMU/W5xI6Yq1925XupdPRT1sEAmGF/PNJJ5QMhc20QNSYPm5NXbK88lBpyY+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmfskrS/oIVC+my3O6IXGZkxvcqGlzTnrEH9GUO/Rts=;
 b=ff65tgWrgkngk6g+zM4fIiSzdhe9P8fXayMMOfdw5sBG+Ze94eK0LAmBHSSKh7sLceGATCeqYhgVuqqcBI5mziSbeA0M02rRDkIkBZ8kg6CozjPR7X0RGS3hZ3IgAi2lefLjSCS1CGdvvoyj7n1ms4K6J7X4F2RNgD/eFiZCAds=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR1001MB2186.namprd10.prod.outlook.com (2603:10b6:4:35::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 20:34:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 20:34:07 +0000
Message-ID: <94ec04101667c23c8aaacca3e8df3bc703ad2b53.camel@oracle.com>
Subject: Re: [PATCH 2/7] xfs: put the xattr intent item op flags in their
 own namespace
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 19 May 2022 13:34:06 -0700
In-Reply-To: <165290015553.1647637.9536028316314201783.stgit@magnolia>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
         <165290015553.1647637.9536028316314201783.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb4fd152-18a8-4b16-8829-08da39d6ec4c
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2186:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21864788E14DF6A5B8692AA095D09@DM5PR1001MB2186.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8W+l6YcYs/oL0zuKGwzycACO+kn/f8o4B9YL8BY2D7/9kUt4syoumgSwo6sROLUyVDiMG+wn/aJ3Dm9Fk7ypRA8rELGOPgoOiIuA11xyJHGE4kppZFC8qc5iWeaJUIfW0+wY8/gbG0VBmp8YSkti2cbKb9NUdJfnb2FKhzXZlXHlu2I8RkYSj/e4lAh0NiQCDZuVBvzajMxpRceMU4p6qx41CvsMA+6vd8ilbfVChuuW+vNTjbDt2Mzbk2rO+u9JBBUk+A+sGtdjIplOBNgsYTPPvRLlhFcbDWSRfxbq9cLKSNGiNFIuMx2KFvsWZatVIw1S+r7Kg34m+4EqjHUdZStVq2+t5DKgtw8iweyXIxRb1Aq+u3El/FYbvGindmRha4ZYabGTeUL20i8FcLwSX/azpa6aVCH47evkeYohUW048anVCVvYrnoSo7xTeMIm5jjBiHfyvcTAVoB8RoPGxuBs/nzZ54mtABqAGq8NNSydtX6+ori+jp+R2RP8oFMHIjSui9ROU57p5F8yE7H4/tjzn05YhGoFcYHeuboQ157NPYLSxf7EiQLnknmSPmSjGOGZsLBCphrnYksSGgA684af07in6TFILoZkpV4mR8aF8WSNki44/zHn8tS04mbfQ4CpW8L/hqwYA4sQAGdTW4mbJRfi7YnG3ul+Nzc3F/MFdAOlKBUrSe0k1udisMyvkNhnicYfOjS1M4dT+72/Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(52116002)(66556008)(6486002)(86362001)(6506007)(6512007)(186003)(26005)(4326008)(83380400001)(316002)(8936002)(5660300002)(38350700002)(38100700002)(36756003)(6916009)(8676002)(2906002)(66946007)(2616005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTBpK0FUSUpWQitXOTdtcnZlMFpWSFZDNnZ0VVdJZGVBVmpveGEyZCtxUkJm?=
 =?utf-8?B?MWlybTBQaDFXbFNYWS8weXJLVnM5Wm9Xckdtc2h0b01CVDdKZEh2U0RPRGdh?=
 =?utf-8?B?SjZoR0R2Wi8veWhSU1dkSjBFRDJ0a1lJUVB3bWtkWWh5a0pJK2pJd0pPbVBw?=
 =?utf-8?B?V052WTdoL0NWaUpQemZMUHhVMTJYK0k1VUhaaVBianEzenBYeEdMWDhwU01V?=
 =?utf-8?B?cjFQRlc1UExqdEUvN1owekg4ano4cEJFaEZNR1BoWWJyN3NyUzRrVW1pT2E2?=
 =?utf-8?B?dmV6M285YnFnVmtka3VkUVkxaXFWVW9XUWk1V1owbkw2N3MvUHdtM2gxcGY2?=
 =?utf-8?B?V1pneTZadlNQckIvcDdyZ1pNZTNrbHIxYllubW5HSjZNd3hrKzBORzg5YytI?=
 =?utf-8?B?VDZwUUtkalNqVjNFWHRCdFhpMnVsQzNEZFl5Y0s5OElNYlBKaHhwL0JXemlD?=
 =?utf-8?B?bXk2TzBSOGt5Mmx0Mk1KQlA1MEhudW5La0Q0UHZJQWVlZ3BvOTBWeTJrMnRu?=
 =?utf-8?B?TXpCMWJPcjRDVnN4Qkg4YzlRTTFGVHJ1eEhFUkd1aEJtZ3hYY1hXWFB5eTNO?=
 =?utf-8?B?cmRkMmZHMS94L3BtdnQ4TkM4MTdBMm9CNTRzK1cyczl2VUhRUi9Cc1dvaUgy?=
 =?utf-8?B?K0dJQmllOHNrSk4zaHEyWWpRZkdDTnA3Mlc0RUh5T3dWTExVd1lmS3pvY29J?=
 =?utf-8?B?VkYyS21HZ29iaVQrMWswejZYQWRwNlprTTI0ZHNIaWw0ampFYW1oYVExWDlZ?=
 =?utf-8?B?dUFEZEVUTmQ1N1ErWXZYNW9lcmVIZnVlTUU0UkM5aDNQTE81NGplN1F3anVj?=
 =?utf-8?B?aTU4T0xxWVArV1ZMbDN2WWx5SWljOUxEZU9xUEk4RVdYRzc1MWNKalZPcG0r?=
 =?utf-8?B?elo3YmZKUGNtVzVwRk85ZnFISUxHbksyZUVDSTVnTTYrQ25vUXFXRzFvUFMy?=
 =?utf-8?B?V0JocUxJeisxaDczeEx6MFRzMTZJSWtDczBFM3lQSm9QNTA0V0tacFJTTHkv?=
 =?utf-8?B?S2dHd2xZbGdaQ3BwdDZIMmNCTjc0K09uVXc5ODcrRFJYZ0FjWnN3YzNleGM4?=
 =?utf-8?B?UENwR1V0NjRSWW1DelRNSjd3ZzQ3TXRNSFFYK1p2RXJXQVFFTU1SZ0xvblR2?=
 =?utf-8?B?VVdBVFgreTNUcktyakNkN0kxaHZGblN4SHRUVVdFbzF0QndZOXdKa2FrL3Nt?=
 =?utf-8?B?cFRPWElLRFJpakR0ZUtuNzJwMTl5VnZRMHlaRWRxRC9tVWpNK2tJb1VmUGZU?=
 =?utf-8?B?N09SOHlVOEtFaEZ1SDhRZVFhZU1jRlBERWNlbXEyV0VOZG55a29GYk16ZU90?=
 =?utf-8?B?WE9RdHB6UFFkaEJodU9uUmQ3TmwwbTdYbU8wREUvZGRPL0xualNNbjY2RTlC?=
 =?utf-8?B?NElPU2w4WlIxQ0ZnM2twcWU0Vnk2Q0ZhN2JNR0JNOW5CZ0NBOXpRZGt4U0VC?=
 =?utf-8?B?ZFVhQkVLNUxHLzNXU3BCeWowQWRmN09qek9aYTVXeGxpa3ZQM1lnWmxNTzIr?=
 =?utf-8?B?c292V01CUVgzM2lFVXNuZndoYmFPd0ZaNFp2Y29xN1JOSDVwbWlEb3JGN28y?=
 =?utf-8?B?NnBFTXZudlZKSGxIMHBxZFNxNHcvb0NOWVpoVzlkREdNTmduK0lIWjdRTHBl?=
 =?utf-8?B?ZmZuUUZXcnN1NmQvZThVYTdzRzI0enVQSTZFNFh1VnVvZWQ5RnJWOVJEaDlo?=
 =?utf-8?B?Nk1vRHYyTUVUd3hSUzNpQkVKbFRDN3dtMTQ5LzN0dHRNUW0vbUx2SjVzQzM0?=
 =?utf-8?B?RUpiZ3E1ZG8reGxoVnVtQXBKOE1ia1pJN2NZY3V5WFRZU2Zpc25INXhWR2xw?=
 =?utf-8?B?dHB3MW00TCt2eDVlYlpBbGlPakNFOHl1Y2VHY3AraFlmRVNPWW9vNkc2Zm1O?=
 =?utf-8?B?Wmthd0JMdGVOMWZFOU8rdkNjQVpCdUUzZmNRT2hBalczdXIxMXlzK0EwSURK?=
 =?utf-8?B?R2FRVytRMll3QnRJZXF0VHhLSy8wbGxOTEpYN3c3enNvOFdVZkFFVWNTdjZQ?=
 =?utf-8?B?cDBvZDdKQnpVR1M3RTdoNTJzMHRaRmV5cDdreHhGbkxOZ0EyY2E4eENCZURI?=
 =?utf-8?B?VFVMVXJaRUJEb2doMzdqQ1RNVmdwb3VUaXBNNitpaFg3Q0JtTnQzbFprcDlY?=
 =?utf-8?B?SFdSeWNROFJGRVgweXJLWGlMcDF5VTgxWmNUOFRqN0hZdE9HR2JHYVgydUxj?=
 =?utf-8?B?YkpUMHlPcmR3UEsyeUF1NERBTGdZZ1ExYndiQ3d0anpoNjQyKyt3clZvTlR3?=
 =?utf-8?B?YkRIR2NLejl3V3c0dytYS3l2WFdlSFl2cGx0VjFEUGRPL2luR0FsNFVLZ1FQ?=
 =?utf-8?B?YXF3OHp6blhxdGVxeURKbTJLNHJuVHlsckN1R0tpRDVkdlBSVmIwQVBuMy9w?=
 =?utf-8?Q?Q0mEF77KVhrwvV3o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4fd152-18a8-4b16-8829-08da39d6ec4c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 20:34:07.8444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7eVbyKcb5mVU35plFOYPQQ3w00fTj7T1NSsLiHeriOWnxZGcrs8O5OjyOtUHF4a89694JjqFycnb7d5wYEGZ0i+uBLODq5wTzguBdthT1Ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2186
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_06:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190112
X-Proofpoint-GUID: psytGihfsqIiIE-gNzj2_wBMtmGf2Lt2
X-Proofpoint-ORIG-GUID: psytGihfsqIiIE-gNzj2_wBMtmGf2Lt2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-18 at 11:55 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The flags that are stored in the extended attr intent log item really
> should have a separate namespace from the rest of the XFS_ATTR_*
> flags.
> Give them one to make it a little more obvious that they're intent
> item
> flags.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
I RVB'd this one already I think
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c       |    6 +++---
>  fs/xfs/libxfs/xfs_attr.h       |    2 +-
>  fs/xfs/libxfs/xfs_log_format.h |    8 ++++----
>  fs/xfs/xfs_attr_item.c         |   20 ++++++++++----------
>  4 files changed, 18 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3838109ef288..56e56df9f9f0 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -918,7 +918,7 @@ xfs_attr_defer_add(
>  	struct xfs_attr_item	*new;
>  	int			error = 0;
>  
> -	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> +	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
>  	if (error)
>  		return error;
>  
> @@ -937,7 +937,7 @@ xfs_attr_defer_replace(
>  	struct xfs_attr_item	*new;
>  	int			error = 0;
>  
> -	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REPLACE,
> &new);
> +	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REPLACE,
> &new);
>  	if (error)
>  		return error;
>  
> @@ -957,7 +957,7 @@ xfs_attr_defer_remove(
>  	struct xfs_attr_item	*new;
>  	int			error;
>  
> -	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE,
> &new);
> +	error  = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REMOVE,
> &new);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 17746dcc2268..ccb4f45f474a 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -538,7 +538,7 @@ struct xfs_attr_item {
>  	enum xfs_delattr_state		xattri_dela_state;
>  
>  	/*
> -	 * Attr operation being performed - XFS_ATTR_OP_FLAGS_*
> +	 * Attr operation being performed - XFS_ATTRI_OP_FLAGS_*
>  	 */
>  	unsigned int			xattri_op_flags;
>  
> diff --git a/fs/xfs/libxfs/xfs_log_format.h
> b/fs/xfs/libxfs/xfs_log_format.h
> index a9d08f3d4682..b351b9dc6561 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -906,10 +906,10 @@ struct xfs_icreate_log {
>   * Flags for deferred attribute operations.
>   * Upper bits are flags, lower byte is type code
>   */
> -#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute
> */
> -#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
> -#define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
> -#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
> +#define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute
> */
> +#define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
> +#define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
> +#define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>  
>  /*
>   * alfi_attr_filter captures the state of xfs_da_args.attr_filter,
> so it should
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 9ef2c2455921..27b6bdc8a3aa 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -406,7 +406,7 @@ xfs_attr_log_item(
>  	 */
>  	attrp = &attrip->attri_format;
>  	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
> -	ASSERT(!(attr->xattri_op_flags &
> ~XFS_ATTR_OP_FLAGS_TYPE_MASK));
> +	ASSERT(!(attr->xattri_op_flags &
> ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
>  	attrp->alfi_op_flags = attr->xattri_op_flags;
>  	attrp->alfi_value_len = attr->xattri_nameval->anvl_value_len;
>  	attrp->alfi_name_len = attr->xattri_nameval->anvl_name_len;
> @@ -539,12 +539,12 @@ xfs_attri_validate(
>  	struct xfs_attri_log_format	*attrp)
>  {
>  	unsigned int			op = attrp->alfi_op_flags &
> -					     XFS_ATTR_OP_FLAGS_TYPE_MAS
> K;
> +					     XFS_ATTRI_OP_FLAGS_TYPE_MA
> SK;
>  
>  	if (attrp->__pad != 0)
>  		return false;
>  
> -	if (attrp->alfi_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK)
> +	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
>  		return false;
>  
>  	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
> @@ -552,9 +552,9 @@ xfs_attri_validate(
>  
>  	/* alfi_op_flags should be either a set or remove */
>  	switch (op) {
> -	case XFS_ATTR_OP_FLAGS_SET:
> -	case XFS_ATTR_OP_FLAGS_REPLACE:
> -	case XFS_ATTR_OP_FLAGS_REMOVE:
> +	case XFS_ATTRI_OP_FLAGS_SET:
> +	case XFS_ATTRI_OP_FLAGS_REPLACE:
> +	case XFS_ATTRI_OP_FLAGS_REMOVE:
>  		break;
>  	default:
>  		return false;
> @@ -613,7 +613,7 @@ xfs_attri_item_recover(
>  
>  	attr->xattri_da_args = args;
>  	attr->xattri_op_flags = attrp->alfi_op_flags &
> -						XFS_ATTR_OP_FLAGS_TYPE_
> MASK;
> +						XFS_ATTRI_OP_FLAGS_TYPE
> _MASK;
>  
>  	/*
>  	 * We're reconstructing the deferred work state structure from
> the
> @@ -632,8 +632,8 @@ xfs_attri_item_recover(
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
>  
>  	switch (attr->xattri_op_flags) {
> -	case XFS_ATTR_OP_FLAGS_SET:
> -	case XFS_ATTR_OP_FLAGS_REPLACE:
> +	case XFS_ATTRI_OP_FLAGS_SET:
> +	case XFS_ATTRI_OP_FLAGS_REPLACE:
>  		args->value = xfs_attri_log_valbuf(attrip);
>  		args->valuelen = attrp->alfi_value_len;
>  		args->total = xfs_attr_calc_size(args, &local);
> @@ -642,7 +642,7 @@ xfs_attri_item_recover(
>  		else
>  			attr->xattri_dela_state =
> xfs_attr_init_add_state(args);
>  		break;
> -	case XFS_ATTR_OP_FLAGS_REMOVE:
> +	case XFS_ATTRI_OP_FLAGS_REMOVE:
>  		if (!xfs_inode_hasattr(args->dp))
>  			goto out;
>  		attr->xattri_dela_state =
> xfs_attr_init_remove_state(args);
> 

