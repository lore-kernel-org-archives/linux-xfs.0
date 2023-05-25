Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC89C77B7C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242855AbjEZIyk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242854AbjEZIyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:54:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE632195
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:54:30 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q84l8M008628;
        Fri, 26 May 2023 08:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=u0uCpya/IAPRUyXXe1uEaplJZtXTGDbUGg+b5yfPbpM=;
 b=k09dAtM78YwWnqTGqgyH6HIM16OAEZxhrrDwp1tNIwxHstJCUDqPEoiAnLgWsw0xtI+F
 jrok3mGVU3tym0uvqWVzSQJl4otbxuo049Tiqz9VAf0oGc+mZT0vATQRDtzS8/3+MxwE
 SOSV+rXz2E3OBeYPlaQ+rH0+Q7SF/xf4vMxt/5NcEng/8QIktVF94GB+XfPzouJV8S/F
 2a7hVXJIPucWShp3rd+Qb7nczNtwHt+8Dt8l5co+YLFosvjNW95iOQRXR1Lr1QeNBqDe
 4LEvbxInBce76JcbHcA6GT6fV6RVFyY/hCoVqtkgqQxm232Ijd+n4qZpZko65vRNjlQQ Sw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtrxfg4hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:54:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8HOmJ027123;
        Fri, 26 May 2023 08:54:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2hea9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:54:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUDguQKctuIQyGquzmMWdLvp8hW3EyDmBVOhgBaT8brp7mS/JP4LmYFRPK0lOCu6eAgtW/3p3psg2bjv3hLEcr3cAZBLiPH4owLOgNBeqRvduw8gjFBzIi50IAGRPD/mQclZyU3nYdZgcLzuFwNJXAYeyFt2WwUxx/pBywr9/L/3/RgHOZrLOgsThqEKdMFsUk+11/ZMTIirpNo8j69nLxQv1cPnRBhopECuzudPXUHxSBqx+FVYJ8eEISJUfQF9RZMWithZu2Nb77AD27vJcaXXG32Bp20MhU6gerbCtUC7tarHIVdN2XmMSx6WK38+tsEtgVX3n8FNS/tapkYwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0uCpya/IAPRUyXXe1uEaplJZtXTGDbUGg+b5yfPbpM=;
 b=fk8HReWA4rUVLqjkSnpyEIB8bnh+fIK11Zhu+iWe3KtElPsoyWxqn2Ze7uyJM1h1vhf3YHFlyKFjMgHIP5WION6zrIgZlGRqoFNn69n2/nvz1R4S41d8vVLVHqKmC2cCGH8Jlqj7+A4QHJSQ/x0u6zBCar33qZVIYe6wV6d0DIf/saco9Rh4ClVogMzPYtrYhlDVJxh1o71x2TuLaB9HjmOtN1PCs8THbSxEN57BaSIFOIIl5OFyQOXrXuitMyPub/StwrXx3nOpaNZ9G6EE3CljCro4AqnRnMXNoi36QsC7dHkaJF6zBpQsgXSnyNU43FltSDsWxQNBUgU0LLIsfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0uCpya/IAPRUyXXe1uEaplJZtXTGDbUGg+b5yfPbpM=;
 b=g4T+f0oAP/nuW7u6Mq1PD9ZQDWdVO7F0fvNY3rOzqB1ZCGLjzWQ7HxqnIUhI7howX1AopCMxIGUyACuQ5WEir+F23f3YRcnjf0s86lhHj5aqRP7pTnmbhzxvlJq7LWD5GXQ//k2ENDD+EdZXZ/X73e8n801fLISpEcS15ng75xU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:54:19 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:54:18 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-22-chandan.babu@oracle.com>
 <20230523180701.GB11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/24] mdrestore: Extract target device size
 verification into a function
Date:   Thu, 25 May 2023 17:32:54 +0530
In-reply-to: <20230523180701.GB11620@frogsfrogsfrogs>
Message-ID: <87mt1riiby.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::36)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cad0da4-1456-4a94-0552-08db5dc6ca9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuxGMzGOqdjBjweI3h36ZBiiOlaapp6ompyBGPSOJ7cEYTZUuosPCtqElPa6KbE8nEFUSHCR61A/N3otClo7ohENfbG0KFb1tHn4UOrKee9opJYTaSReVwPW54a9/ZusqA3eXkk713jEwTRAhsmg2I2vFYOvKzUqj0r8Ybi7IIp/0YoGVKl9qxIxjFR6Wylv3Rpq0SIPv46YPCwoXti82RyoQ0X2uiQ3Au88R23e0MRxHrl3L7SvFtEL67Qt8j7pJbiIA2FH1vwX+tI1w3a/l60QhGP9FL4RLqNA3eNmTwSmKKCIhwyZCcm4K21gazEjsXlCZFnJ152TzSpKH1lvCwzw4X8pIkXfhRMzhSSi5/Fx/aiQBYeXis4U86nQ+7MdA/FQm7NBotaUZ65ujlvW1TNP/ISyzee/wEUokRC6WvGtpOqhhzwXRAXxY9LVED2FXTS+EAfaxaZygZMRXcxO09D6G/c7TruMO1qMjw3blPnSPAFg5hwMzQbX7GDZCx+CWc1R2vioymtWHbU/+mE/uz3hQc7O70U4Mwk0KOOGzcabIOG5r+YpNNFuBl6ZzMdE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(4744005)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(15650500001)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mAPxL0+TKAM+k+P1+1DZCubzy9WOraVu/z7CaLdJHNoCVk42uZMe3ppeivPb?=
 =?us-ascii?Q?laX3hX1ljEJjAxu9kbMMEEyq1f3moNP6KtJIo571OpKqwrIedppDdj7blQvg?=
 =?us-ascii?Q?+44cDD+PTyjYGiMWWowUiVh7sw09JbgFMLCp7BQSB2DXWBTU3EVFhlpuA5y9?=
 =?us-ascii?Q?PVouElUwSO8xA4pqJx2gcs5iOgMxxnRHuie5fMb3kYd/lro01kdv2H8DKVn6?=
 =?us-ascii?Q?sXDnSW5LtFZFBTm4q9tFnm0U/BtLe7z5XmWVUynBGMBNt/BMk5Tr+VEJcEDY?=
 =?us-ascii?Q?QpfhxNdzbzPz3cffa//RzQ3vGuGXFssNV5grpM5w1vuP84pAqWeTN0bgRp0f?=
 =?us-ascii?Q?jdl4aHohzKMe5gt3BoJJAq4ZZjrC3I4pcxOPQ0aP7CI6wUNjlIEio7dIZZQV?=
 =?us-ascii?Q?d6mTk+myNzrgzslUbjvcXMWPHGpAI7rVxKND9IsqES0AbI1Q7M/dOvpLL7XW?=
 =?us-ascii?Q?RVv3/y3DrO6/gQFEytcm9UhwlYgswQMAANZRgH1wh88UG1ecxAWpKWZT4Oyy?=
 =?us-ascii?Q?2LJZj2S9iJ9GAe9gHdZhiQb7vqp2Ge5iH+ZFSXCsGsWjOjQz3N4wEqw14cng?=
 =?us-ascii?Q?8FO8om5zfvsV87hIZMVSAkLp3NouORqryjCnDGglRV1JCtIF03vh+uAk0wSE?=
 =?us-ascii?Q?y8hXwssHEM2ZsAL/ct/z579VyyFqIVft01QmJd0awSfuFKu6NqGj6uM8j4K2?=
 =?us-ascii?Q?FBzc4cHn2066YhWUXzzwFtllg3ol9diYDdBOvMj/SVZVVe0ejml3jPJGE77S?=
 =?us-ascii?Q?9j1UwAL5WBAqzJnPhkjq+yne98RqoC25IN8ucwNRy/5D7aMtgCM3Y2DO6sqs?=
 =?us-ascii?Q?Aod92LuE6wXeLIKElkuOmArf4mJLEZzSPjdgbvjGNpOnnp+Hxt89kRNPrBk5?=
 =?us-ascii?Q?7PWIoXzEfpEqsoNFkt4N69z7bZaqJ5n88meWOzPilozd906LdhweFbc1O63+?=
 =?us-ascii?Q?7Ofnmuv3tFvmtZLhXpDkhoCKNLfOkQi3hZal6f/a6QWbqfCW8RF2LBjcMmBf?=
 =?us-ascii?Q?q2qEJ+QyuaUV+DWdFlDCKkAiBscg7uAdMAuaIlpBx0dQfjyg4oZ7WqVkTA89?=
 =?us-ascii?Q?X+whU5yTc/OUDgf8u+swDaTYhcEtzbFx2Z2H0W9Zd6Ozu035G+1JmpMxY9q/?=
 =?us-ascii?Q?JhZMw9X7Wp4SY5IDisrpXD/bY8EuR4aFt7I9zH9dl9EXvfV4959YdPfxkVeb?=
 =?us-ascii?Q?2KnsjIxM4tkj12z7tPMdAvXwmI7cxliqZUmAyN4fmjQBiUj4wqseP1/YGJqu?=
 =?us-ascii?Q?Fk4bjsLe1/umxtaDN5Sn7G9weqYEy/HG0zYWljPlMeqmyLfCG1YcCW5zc6ik?=
 =?us-ascii?Q?6Hx/RT0dvIWpbCu2zzbp4Va5TRaMaWt2EL0bBBU5rfN+QTI+cgiFC+F07e+N?=
 =?us-ascii?Q?yfWzYVpl3DDd8H/G6xnteLYUydTk+t6NznR4jm6pK210izj7JXfVwMHIREO7?=
 =?us-ascii?Q?ZOCqDchv14qaMPJjhnY2vUatwX3o09A5vm7LySqUfCuleCYfQJL/pnwA0rgX?=
 =?us-ascii?Q?/N4pI2NkU6zrdCveEP9saLbk1HCgR1XewPRQdKTgapeuKkHdCYs9uHMif0aw?=
 =?us-ascii?Q?1oCzOnShHMIE/mvj2SMCVtAVm93RlHVwDBzThgB0otTwXInToqHlf+GRhVHW?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PxfTcV0dy+iQ7Gc4ZMko8yjoYuElbNQ/UquYasOLcA9mS1WtJJihMfoGx/Lh+Bgs4GBh+hOkE8ATjkhbyE2379rlaZ7VMzpexpiBvu+kKwwoO2WT7M3Xmsb/Sa1U8pFJodwIqJlk3gIL0XNH/Pm+KSm2qruo9/MXA9mAKxa4wwAI8j3f4HIdvZooa29jX6Gx/ZaSQ37oMyfvXKv5y3fkC6sXLjQsGib079h8xLiaMVhvMyW1d3wl7qSw7S0IHjzWubEw9GJ8XQyvjMPhUgrOjbTyQ9vYPpHv5o3vBAFvjWLV2KbJIJTGLOzbcV21uT2y0G7NXXoTnH8EoLraIpS3lKqIHIvvTK/9wmn0CMKFIZopHOlk8j79VgVoj+mrkBRdaa7tj7ZYmFtsfKLh5joZap09GBNQwgs6GBIvRsbg1I9ZCML5nQeJ/T6kvh1XrP/SHuvUrnXw/+frB+k5Yye/+zER/gDGkWxXs1vs41K/kH8iGu6LWJOJLAYbWQM8Af1WOHKWUetdxS98LZ+0RvkqMHX287Mx1EtNB23crOi9LCuiC1n3WGFXJdfZe/2R3GwVpKEOwdwQzMCgnbXIoDYO2h6h7TiYi0zNMAg3XDjRG6lAIEgj35Af3LY5CA1AaJt+ok+3fAg2NwcCnd4B37n4jNyKc9wsBCBMUpU3usBB/XTR5Hif9JArDSA+ibKy1i0JRux5q9xuSRi4Ftgn2MIfSuip6aPqKnB6bUkA/QGo5s6m9rMl2dKdM/Cc2U7S978KR+Ek2sKDR84EF8xuJLSnnjOdbqL76u7XgYeTkG5hTuU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cad0da4-1456-4a94-0552-08db5dc6ca9c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:54:18.8298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mj/BlmRKyHilAzoPQrgTXsxNMFOSI5+eqA4EZESoJ0MSQov5c0POpzlkzO1TL04osyjxFVtVbZklq8d4ETUVWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=691 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260076
X-Proofpoint-GUID: pyVwcK7Rp_eYY5VQchwz6m6dU6ZnMHvS
X-Proofpoint-ORIG-GUID: pyVwcK7Rp_eYY5VQchwz6m6dU6ZnMHvS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 11:07:01 AM -0700, Darrick J. Wong wrote:
> "No functional changes" ?
>

I will add a commit description which will also indicate that there were no
functional changes made in this patch.

> With a better commit message,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

-- 
chandan
