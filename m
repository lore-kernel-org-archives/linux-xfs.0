Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1817CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 10:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351677AbiDLKBL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376273AbiDLHnt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 03:43:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E981645062
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 00:26:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C4nImW028053;
        Tue, 12 Apr 2022 07:26:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1At9JkZj2pxD6R26Q5OP2k37SssEj5kCxKK2yueNj+o=;
 b=f0k9L0is/+BbVnr1A6s2rqZufG0FKbYVvGYc9P3L5JkKyey4z4cJXNURtUkfMI9PnZbw
 DnVs517w7RIt7QFvmbOnqTUXUCv6/dIW2kvmYk1YO1FTxCn0Zpgr1wFVYQ39OO6GUuuW
 /+CNFGB3VBPqxXMaSc419s8viVL4Qj8ZlUFJ58H3Rj++Pi/a4sNsLsLU3wyehdLFgSiO
 ttVgQ/LzEqF6fTOclLlu1Sq9FvQJIn/6G/Jd9mynzeGTWLkhYTGh1p5U/U3qBLhZ8FaK
 FBCGy4WJEE8/GvJCxbZ7Iv3SKnmJ7zMLzr2RVIOqqot9xjsMk53ei6kj91dOr0V6pAH7 mg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219wnp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:26:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C77IfV038723;
        Tue, 12 Apr 2022 07:26:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2vecu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:26:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QpZpElcrDfh9DqBdsVaagX8M8P8QyLX30BOkMfaLiCR4Qq2oSwW9sorMb3KGIvASkJ5/MittEReU66zKg+e8vdtrcTzlZMK6I1yh1+ome64mqqSPx7Gkuweox6VimQ/6ojkiwh9nUXeYyVj/IRKQ94JTjFHkROW3KsZEIYc6EGeb+JyCcjRNTOS5nhLjNMUfYCZDasK2AXqOh0Pylr7Cof09CpPTLX9RgZPB6fh33q8gmqEpOk+iZQ2eDs4FpC/ExpZOLzfiB/GmC6/e3JwTLD7j/XL3cNyvpF1g77tHFwrHNPC1RaL2RgM8Mv0DvHZ9vDy4MdkQinUiVXKDztsW4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1At9JkZj2pxD6R26Q5OP2k37SssEj5kCxKK2yueNj+o=;
 b=JXxh64M8CIpabhnDN3En9Cn8mAU1vdXlO/wOgBa6D39Qm0hef00n8WOt8IjnArMZ1DDVZjmuydMqIHatilnGbuKrwkDPyiqF/Cy7LndgcsJEvc/WVYL5mfW4SvOkcFqhbexGMpRMBMwESQUpwr94x/MCfsdmXdJXsURJ4Pi79Y6oWFdXmlFTmvhTxD2PsPPwhRIOneC7LUDG7fAcqCpZQfeS9HJBPc4MJhga/E5kGhCisZVRkT770deIQXV9zLbW6OV5ha/qYOvJ8xAfHLumF5ob9hXSTQKcqmpkKq9i9ste0G1UpsRAww0+345I74Rr3z6qGdKzH6uzEVd5+KJ16A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1At9JkZj2pxD6R26Q5OP2k37SssEj5kCxKK2yueNj+o=;
 b=RgE+yyVw4LwsTpcdUYm5/Yg93dGlw/6YjXNUnyHTvWUN7NnwKc05lG7pg+A7miQgz+FCQSyyV5F6O4uXt2O5InM6loOfqgzRwX5PtbnackOOhNimXxD9NMivnlbQhfNqIyBelMU6xHM8/HaqJ1I4Qlic9g/AyPX9RHNy4EVv+nw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB3464.namprd10.prod.outlook.com (2603:10b6:a03:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:26:38 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 07:26:37 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-14-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/17] xfs: convert inode lock flags to unsigned.
In-reply-to: <20220411003147.2104423-14-david@fromorbit.com>
Message-ID: <87v8vezrrt.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 12 Apr 2022 12:56:30 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:196::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df563e3d-3d8b-4994-7de5-08da1c55c791
X-MS-TrafficTypeDiagnostic: BYAPR10MB3464:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB346464100D05AEDB44F5C20CF6ED9@BYAPR10MB3464.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kd15N1A2F1/Fhr89El3QWSTdF9dNNwM99HZXwSyG70RRs6Tb4WWCyu9LIwpuV10paWQwTuGOUJTAAK0twqIH3rRA8g8lCeBD3dQraje1Pb7vGjCNWx3nW1qNFVoHRINkUEGVX7lmu/jdktO3cCzoC5CMLT6BMnA7ItLMTXkd9EA260oQ5fA0LUwAHlKNffwJqunNcvBtbhIqbh9UQ8mD/B+39gxoF/ifcCQkGxFbUQ8eQQNanXV3v9dZ8qxjPPd6uwh0hFUyvaPIhX4ZCNEXl5vM4UwSZVkv7DUE8d6QFzlJPUja5xVHkNaBaX+WWE9DAIeBREf8yoDzgBG7UVVvX2kmSOMT5VwFC02Q8UndbX+ntMz064i/S1oByb1H7LH23dM2oLf25D97TNFETt1BEw0wqdSqWMbAc6k0x5dchhpVXR/olURolZcayo6hrWTTMgm08CmFp8c8XoNEN3+s2IVnKqfkMX7KgA9yhOt6jmbXU2qTJDOtlZafhxVPljqeO5iO0BJMFp0srGUqLCx0X/3e/IBoWhJST3DywDyTVdTZvD/3BI7HppP89Fz+ft4IJ3/unn2dCkHwzDxAlyct20yNDS0nN8QjpuzZqjwQkzKjDa6i8c/gBMj2cvmr1A8pLe0aCf8W80eiDXBtS0MWCc0eP/AlWxdLjig1sllXBtVCL/Nj7VWuZUeyAaxGaoij+gP56+FW+bkCwbsbBHursA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4744005)(66946007)(53546011)(4326008)(5660300002)(2906002)(86362001)(33716001)(8936002)(38350700002)(38100700002)(6666004)(66556008)(6506007)(6512007)(26005)(186003)(83380400001)(8676002)(52116002)(9686003)(316002)(66476007)(6916009)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gHFGsMBy9zxNS9PmtotXfhAmeiORJdSP93/ET2JcwRi03ImIGp0fCUfEq4ud?=
 =?us-ascii?Q?1wVTVdD5p3lb4X6v5sf3E794cu4m51IDEpgASXf1myzXrSu3uzCysB1zYxR8?=
 =?us-ascii?Q?MoD51CvS4JgDI++H1C5YhJqX53iIatFPJUtz7tzN26o5qsPP/lD9jYTtAArD?=
 =?us-ascii?Q?kFU0iHTs5X9KBdiqRe98sBCvf1LYGTxnWIFZYA4dPicHsF3R30QtCNaTLwDT?=
 =?us-ascii?Q?2UeaCVBPOv+qiQwR5hkJh9jhN6IEIplKO2LnJIEC5W9A9Z1/tsFLiO3lDEEL?=
 =?us-ascii?Q?ETmxq5JPWYCsBjWDc78RqVsEf9m1fZhfAYfsGzg0HdoBnyw32n+bkXuRyap/?=
 =?us-ascii?Q?Rp7Y8F6RAN+bfcNnLhAwCynBNMn5EVZBvMAevRiVqiNXEHKwvZAER8TfDQu6?=
 =?us-ascii?Q?JNgTMJ9OokrnmpLpw93yaDz5P3wIIyrS6rcqiEuQDUYWfo81mONjQ9aV8b7o?=
 =?us-ascii?Q?KI28KrQi/BquZC45ov58i/unONQhJ24iGwbXobdWOEcnTIoQ1Y0Jx6T5zSrr?=
 =?us-ascii?Q?ed1VgisRNQPx/NdDFthPRWpwcYTxzBYttIxmrCflQpZP931qAmMl8d0LXjUU?=
 =?us-ascii?Q?z418uhdB2rwZ4kzcIk/0JfVlTx+R8ggZ8ltcJWF5yFX9DYrc86W1auwhehWx?=
 =?us-ascii?Q?Y/ZRAbIt5igogWQSA1AmpVm2AK6bs562AFe/7qYmZBwhZM8azDL+POaWE2hr?=
 =?us-ascii?Q?5uZPtGlRyls6v79+ckdU660bDBVdojbJffUzZPKIjpVJKHSn7H22J3DARM0E?=
 =?us-ascii?Q?TPmbAFJIrOb34aQM6qd+7K+Zh5AOzgnmxL+DAYpmUSwkSZl2VThhGrITEDAQ?=
 =?us-ascii?Q?57UycVQmfRsWd/LxEJG/fpwRQygSYY+TNzCkMF1uXl5hoxKqANQOZYwdTdMX?=
 =?us-ascii?Q?xvrp2k/2xIwH61EixYEQJscvjHca4CwJ27mt485SrxNTdnaY64/IPMfm3TjK?=
 =?us-ascii?Q?uxt3iSvU8pFZ92fFiONhYaig4fYcfpH3z07aTm+/z4+YlKIdlmq+CtNdh9cL?=
 =?us-ascii?Q?GjI/ksQREB0As67QPGSsXoAbkLspmeo8aBDYEwJVSqjrpoO5dkmxsDw6kPvs?=
 =?us-ascii?Q?WfupZuqc56sPEjaTyLH3L60YQCnPWmmtOxM1Efurdhhgtrd+qB3LpraK50Bt?=
 =?us-ascii?Q?DXEQ0qZ0FJPelWU7TZmkZCsy+VXelyMByVDFriRxE36libb5EKktWrzvEDkm?=
 =?us-ascii?Q?6X5J/EEqYXtD10fGQvWS6sSN59zDugejynndh641JKyG2FznWJUzwiZhy9TK?=
 =?us-ascii?Q?h57Hfh0ecRMRn5kG1+d9KbwY2X+nZnsMtFwLF+k/LIkPWF1frB0uEnKIrfwS?=
 =?us-ascii?Q?ENjnyshl/LDgfIvKKsyWEu1hRcCV7NhSYfR93Tajl7RyQWQZY9bLbpwgWfiM?=
 =?us-ascii?Q?CHViAMKXwhRzI+3VHS7eCkoVXd7Qzi0orGcc5Y+kIh0uCpFVfabP+Z6T+kXm?=
 =?us-ascii?Q?IA7VwXDDOaVYXzauo3TrLf2h/ij+68x4LsXL5nQgeIy4DTO3Yx2YeGInJwpC?=
 =?us-ascii?Q?9scelnTM3J5a/w9j82oD2Xv7cG+SSda+jajRCeDYDwavZAiyzc3J7UIsVs6j?=
 =?us-ascii?Q?D3ChAszCQumfEolc1Wab4qwMIytmb193RTc6wkg04aMNvrEKF82plxmJAK4x?=
 =?us-ascii?Q?F9d4CNOxftVL+uiliWClsdgjGSqKbkwpq7SN85b/GhEBjt5piyd85n0IfUtn?=
 =?us-ascii?Q?4txzO0lzokQoSLJNya6342iz/T8fOlEBSxf0XoMZdn5d3DzQxRvX1K41sL1e?=
 =?us-ascii?Q?omwRc2bJqDvqT/X1pRdoTrgM3oD/P6M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df563e3d-3d8b-4994-7de5-08da1c55c791
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:26:37.5001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rpmv/+ayL3b/0DQcmdcFSS19WE28iQ37oenDL6k64wlTWLUxnMDv/zUpsgUdGTMhrHWRyn/Nz7Pwqu2CVLy1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3464
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_02:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=901 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120034
X-Proofpoint-GUID: E2DewvCa5ywsvT8jq5RL95L5neDwy77e
X-Proofpoint-ORIG-GUID: E2DewvCa5ywsvT8jq5RL95L5neDwy77e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

[...]

> @@ -350,12 +350,12 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>   */
>  #define XFS_IOLOCK_SHIFT		16
>  #define XFS_IOLOCK_MAX_SUBCLASS		3
> -#define XFS_IOLOCK_DEP_MASK		0x000f0000
> +#define XFS_IOLOCK_DEP_MASK		0x000f0000u
>  
>  #define XFS_MMAPLOCK_SHIFT		20
>  #define XFS_MMAPLOCK_NUMORDER		0
>  #define XFS_MMAPLOCK_MAX_SUBCLASS	3
> -#define XFS_MMAPLOCK_DEP_MASK		0x00f00000
> +#define XFS_MMAPLOCK_DEP_MASK		0x00f00000u
>  
>  #define XFS_ILOCK_SHIFT			24
>  #define XFS_ILOCK_PARENT_VAL		5

Why isn't the value of XFS_ILOCK_DEP_MASK marked as unsigned?

-- 
chandan
