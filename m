Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC9BC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Apr 2022 01:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiDWBJb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 21:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiDWBJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 21:09:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C4F18D680
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 18:06:32 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MKEaHh009092;
        Sat, 23 Apr 2022 01:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rtdaaJVDiRCvJUF8H+NjSbg4lopLf+mTJT4H/7N6ROQ=;
 b=BATuiBDB5yjHFR63s7sS9towhTwV8CQXeFfGIUMgNiL2Le0H5vNAhccc+oZKWQDLFtdx
 2Z5j8ylIFUnXEXhpay5rA9fxnQnzgGo9GENP48snZksJpEdOs8sFqADUG99BQ5iiZA6h
 T3LwXwyZuvJaRcxWZHG9uXzq1UawcMdFQajaXCDRBVv/M+Sb8wC9s7JZn9o4Cf+wmLGY
 +xbohSkMgc2ADqL9UJ1J90qOIbA9IPEtc/agVpacqpTYVIO+iU7v3dCin0Ie6htqoBEK
 37nxfbWuSbrhAADKrMDqsJCBJyJFzemrneTssOMCP6TsdF8gcCtpHRQ7r9KHErHp1Id9 Ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmk3007r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:06:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23N0uqcc038793;
        Sat, 23 Apr 2022 01:06:30 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fk3awhcut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:06:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkvQ1jxjjyudenUo0nBXxfhRflzP7N+8bFYgirSha6cCedU6Yv6syTdQBx57U05NRhGtW56NjCvIGBKvDhlOh+v9Y4zXlHyVVDomDfTW8aB0OIc7eIkCCMbnA/Cqk13QRKbEXC2topJgb35eCvCxRiQB/DzX37rcXunc7pdQVQu1SYEhoWRoXqu6/O4EL1TJAtv8S5l5iPcq4T/qaR8uFcVCaNCHOlrEg84ctNH2pcCB1Vrsy+WOGwIeoFcIUTKDnZUnGxe8ZK4Jiyw5E/pYg1euibLLxFTJ0BExymvRv8wqdI0ACQg68ngjLaMCk6nIFq+pc+9d1asP/MaEF1kHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtdaaJVDiRCvJUF8H+NjSbg4lopLf+mTJT4H/7N6ROQ=;
 b=ZAfWHEUcz0ua6Mww0k9dyz2j81YXBnX4yVBNDm2SQCv17qIJM3Hczk0Az37pG+WVyv0DyhoHOUYXAmAqFMm08VIqg94zPlLKz28lnoqF8zeCZkxBszV3ENqR7SigRqP9V6WBPJ1g+3QFXMqMVtfsFj1M2FIdOa18mLe+4tfoiWTXRTaTHZ9X4lCviPa7SiHTvrj+RSrqz7pdt06pnqkwAsU8b8bYxHzkF9ZEX2ukdX3n8V9IN1+OrXFcL2kTwmWZUcrAPU+F1snSGXSwmwlORa2hVn27cCiPT4metXhp2ZxzYH90HdTisPXFbQ06A8kWhtAG5dq7kWSExQPhq7X12w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtdaaJVDiRCvJUF8H+NjSbg4lopLf+mTJT4H/7N6ROQ=;
 b=mOp7ozT76HCYCpXexLZiMmcfLtk/NWKozqoJi+QoNraPx/E/DK5uFL0JicmLI0udw4bbfgt9ZAAOcXq++HcI/a9zGWVPs6I6vITazXznhOoNN6XjYAspv7vKUluDu6FLabUpCYMJHz1/Ey3V6O9E+hLnmIRDAKxFICfeWJeOSKM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4066.namprd10.prod.outlook.com (2603:10b6:a03:1fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Sat, 23 Apr
 2022 01:06:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.018; Sat, 23 Apr 2022
 01:06:27 +0000
Message-ID: <26bd35c4b3a52d59d23cde3447dd39c445441f05.camel@oracle.com>
Subject: Re: [PATCH 07/16] xfs: split remote attr setting out from replace
 path
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 22 Apr 2022 18:06:26 -0700
In-Reply-To: <20220414094434.2508781-8-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-8-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:254::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0476d888-9f45-45d8-a337-08da24c57e8f
X-MS-TrafficTypeDiagnostic: BY5PR10MB4066:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB4066E8C6B794582239E730CA95F69@BY5PR10MB4066.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiayskEf6X5aPkh/WkI6DAWebbhco8bqxuahZ3DDCLxN26QSwGBW7yRAu0+NR8PqHVgFSrmv1t2Br/QMdMtGUuxFj3ToD+0bFBqisjJlc2rdFeV97NKW5faCdFdFoRHrkwbXUpNaHdp5ZRfmw1yTCIseekXFz3fTvmf1eGKHuRBQ4GKj883UVwn5L8BKN3SuIKPQg7tqqy6Oycw7P82Lj2+DJXRJJG3US2k3EHyavcwhP/CLVOjHObr4CI0o0sZuztJaYLzgk+RKp/8tAs5ofhbBXqMuRNiDjRkediaJvdGQx0ZTSNGm1KEk4az9hBw+BvBuFpSZyqEIC1khB7b8y4dUupSgraw1bhDbda4do9EouujzCT9t/zjNA5Y+U/P/tcyGM27IEASzAZ2ThVLCqhkUwin9KheF44kkUiNvfJccqoQAmygw995lLbPWtLThdWg7IlKt15iOUoj5dc/7q3+xioQ+ZDCeBzMSfVHfANBaVTMozCMgf/QC9izjmfQQLhSIfbs0Ohfg6LXRvfdu4HUbKETw0NQFoq4uiBByLkobzlOdn238YWU2rNfAZ3J6munkphu3M1luGqqLw2SRN21tQmAg5bBYLnbjsuiQluSUAHXoaB4ksS6LKyYLdhdIwyG14FcetyJ8aosc0G5brdSIBdjQMFJUFBOPQjTaKB0lS94yThCRaRJ0gWnWWAe0C5Pwz46hG3JtFPS9EmVPbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6486002)(66556008)(66476007)(52116002)(316002)(26005)(8676002)(6512007)(6506007)(66946007)(5660300002)(508600001)(2616005)(186003)(36756003)(86362001)(38350700002)(8936002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWc5dDFwSjZrVGIrbklkaWZVTWpyL2R6NUlxOVVxZkpJS011a1VEeDNnMldw?=
 =?utf-8?B?d1NoL2d3N2JMeWVHd1hGUVIzbk1aR3g0elZWOWJZa2R3UjI5MWRQaU9aQmEy?=
 =?utf-8?B?RUNXL1oyK2dqVXdLTm5Tb2dzMHE4ZlV5Mzlta2ludkkrelcyOTZGc0JPMFZY?=
 =?utf-8?B?RzFEMW5STzBtQ0d1YjdMRjRaajRNb1RkaGRaaGlESW9BQmgrME9pbFBUajdr?=
 =?utf-8?B?THVESE51UU00MmpkZXl6cFpQbXRmd2hZV0FJaVpxNnFQQXp0VmlucTI5a1RG?=
 =?utf-8?B?MHpDNW4wYmpydjZoazlldjlPR01TUnJINGhSVEMvOGd6bE9pSUt3aGZhQnBV?=
 =?utf-8?B?YStGajFoMzd0d01VS053L2V2bWd0eSt2bm15bkNyR05FaHV3dk9jTGtnd1hF?=
 =?utf-8?B?akVGYUNGZ0YzRk9WdnFQRDlwWXdPMXNnRDRLbHhvTG0vdEJHZCswU1p3ck9i?=
 =?utf-8?B?T1VGR0hqSHdsc04vREF3b2JoUElKS0hpQjNPTXR1RERmMi9paGRlVnEvZ01x?=
 =?utf-8?B?V2oyd2tEQkFaVDdNa2haYzNDYjF3L3hSUEFkU1dzaWN1WGw5aTNZTTNHS0di?=
 =?utf-8?B?RjArMkNjNUFuZFlQUm8yTVZ1WXk0V25SKzhKUythY25ndHlWRFVnT3lkZGU3?=
 =?utf-8?B?SnM0emdodWIrMGNEcmlMSThPeXB0RmJZNlYwbjl6QmZjRHVyeko0S3p6aUEr?=
 =?utf-8?B?VVdmOWJWano1OGVBd3lqeU00WXNmMXhDSmNVeU5BRlhZMVFrWnFWS2FTc1FU?=
 =?utf-8?B?RFViWllYV0MvcVVBalZXSDB3VlgvZCtDdGxiWEpyTlFpUlFOdTI0a3hPM01R?=
 =?utf-8?B?R2gxYi9wU3JQSEJtcTZ6NldFazhCaW41Um5hSS85THJpNHcxc3JXdFNwNHda?=
 =?utf-8?B?eFpIU25uL2x0bEJuaUZxRy9RcDdRQlpEZjFTbk94NlIzSE1KQytpM29nZjZH?=
 =?utf-8?B?VjdOc2RDQUpsZkJpMEJteU16UG9uZHVZdWg0QXIwclVhSUFTWkRleVlGOFpo?=
 =?utf-8?B?RFhnbk02aUo5d0JZYkFYbnlzOEpWZXlJRWh3VDN5dEx0UG5ZekN6NGFPMEpX?=
 =?utf-8?B?QkhZMWpBQ0ROdGlQQzZRQ21oVEwyeFhmTmtpYklPYjZOekhObUJDUG00bER6?=
 =?utf-8?B?SmVPMVJJcHptWFVrZ0hGTmFMNnV6aW1tR2I5Z1RFaXZtMUE0SHk4TkE4REFH?=
 =?utf-8?B?YkZvenRTZ0FreTFhNE5lRkEveG1OcmttcE9rS3NoR0JuakxibVBJVUgzeXN4?=
 =?utf-8?B?eDZ5TGZmRTRBVVpkd1J6d1ordVNFODN5OWV5Q2NFUjAxU1VnTlFkVndoMzFR?=
 =?utf-8?B?RU10eGdRbVFrc3FtWnlWOEsraWJvZHdLNHRKUGNhdCtxWEsyYTR1dE5YV0Nx?=
 =?utf-8?B?cDNxZjBHTFlrOW95MFBqcVVhUDJwTUFTRUFvbEtiS2pMOG5HN0FoUHZtVXVY?=
 =?utf-8?B?TTRlSlJERC9LWnJhQ2NjZnZrUFJIZjdRYXFKOXVKSVdmZTM3R04ycFl6T2JW?=
 =?utf-8?B?b0dEeUtkbWF6ZXExL2J0eTNuczd6ckF0WWpTenFML3FhVXRLZ0NndjFSeGdP?=
 =?utf-8?B?OGE2L21SOG5FZkpETE03QU00VTl0dGx5aFM1ajlHTFNvK003U2Yxbm0wV3I4?=
 =?utf-8?B?YnBETk8xcjA1K2c4RURiVWdVWmRwV3JBNktrU2YxM1cyY1NHRTh2Z1dSbWMv?=
 =?utf-8?B?bDFSSDRBRzN1SXhPczgwUjB2RzlCUEZMT054VS9BTjBJV0U3eGRycTVKQ1Jt?=
 =?utf-8?B?WlRxYlA4WUVHV20rWHNsV01GbHhxS3hoQkRGY1ZFa0tCN3BCNVU3bU0wUjlI?=
 =?utf-8?B?dUVOM0NuRk9qd3F5d09ybk9IdjY3T3hXTlZiRDNld0ZubEFzdk1vbjlTeGNX?=
 =?utf-8?B?N0xteTgxWEpSL3hReXpPaW5UUndmUlhPUjJOenJWSFdOem13UmV6NnNOaktF?=
 =?utf-8?B?Q1VGME1OeUFobHJzVHBZdVFJbERsY2pvZGFFWmdyWnRTcTlsTUc5NEY1a2ZO?=
 =?utf-8?B?Ykw3czhwL0QwSDJuRy9qVDBBa3kzRGNLc01TekZsdk8vNVUzUVVlU0tLL3Ex?=
 =?utf-8?B?NytzejNoc280Rlo4SlViTVpZSWFQZlRZSG9zZStWL01LMTNGWTdPeUFpUE02?=
 =?utf-8?B?YlZkaWNjam4vRWYrUTl5eHRkUkJVVFpBc0Y3cklKYjFCT2tDTnFpTmxJU0ZU?=
 =?utf-8?B?ditaYTFxT0s1ZE15UUJQR09FLy9Tc0crUktUZ09TTWppTGpwMjZFWHUxTlF5?=
 =?utf-8?B?TVh1b1I4ejQ3RXZvZGY2NTZ6RG9VZ0RTUHB4SFYweEdVQ3IyWFhJc25CSitx?=
 =?utf-8?B?UXBWalRrUm5HOEFYVWg3RzJVaXh4cnFEME1tWGZ6NmI2WWdWV3RYa0gzemxv?=
 =?utf-8?Q?InBINe3mkMpkXMLM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0476d888-9f45-45d8-a337-08da24c57e8f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2022 01:06:27.8564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SC2eu5oIOjDBTNzBlpYzTBoUeR+/qu4ROEO300nfO/6Que+CygWahvn91fIKgswYP7T2fdPt+/Cmk5PegRXHeCS8aSY1pOglcXHZtvFq2AQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4066
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-22_07:2022-04-22,2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204230002
X-Proofpoint-GUID: LKfSot10uZr9xc8Cr0FSYrk-FkGQ6GK2
X-Proofpoint-ORIG-GUID: LKfSot10uZr9xc8Cr0FSYrk-FkGQ6GK2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we set a new xattr, we have three exit paths:
> 
> 	1. nothign else to do
> 	2. allocate and set the remote xattr value
> 	3. perform the rest of a replace operation
> 
> Currently we push both 2 and 3 into the same state, regardless of
> whether we just set a remote attribute or not. Once we've set the
> remote xattr, we have two exit states:
> 
> 	1. nothign else to do
> 	2. perform the rest of a replace operation
> 
> Hence we can split the remote xattr allocation and setting into
> their own states and factor it out of xfs_attr_set_iter() to further
> clean up the state machine and the implementation of the state
> machine.
> 
> 
Looks like it should retain the same code flow.  I can follow it, but I
feel like I'm the only one reviewing this?  As long as folks are ok
with the new code flow, I'm fine with it.

Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 113 +++++++++++++++++++++--------------
> ----
>  fs/xfs/libxfs/xfs_attr.h |  14 +++--
>  fs/xfs/xfs_trace.h       |   9 ++--
>  3 files changed, 77 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 655e4388dfec..4b9c107fe5de 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -347,9 +347,11 @@ xfs_attr_leaf_addname(
>  	 * or perform more xattr manipulations. Otherwise there is
> nothing more
>  	 * to do and we can return success.
>  	 */
> -	if (args->rmtblkno ||
> -	    (args->op_flags & XFS_DA_OP_RENAME)) {
> -		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> +	if (args->rmtblkno) {
> +		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
> +		error = -EAGAIN;
> +	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> +		attr->xattri_dela_state = XFS_DAS_LEAF_REPLACE;
>  		error = -EAGAIN;
>  	} else {
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -376,9 +378,11 @@ xfs_attr_node_addname(
>  	if (error)
>  		return error;
>  
> -	if (args->rmtblkno ||
> -	    (args->op_flags & XFS_DA_OP_RENAME)) {
> -		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> +	if (args->rmtblkno) {
> +		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
> +		error = -EAGAIN;
> +	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> +		attr->xattri_dela_state = XFS_DAS_NODE_REPLACE;
>  		error = -EAGAIN;
>  	} else {
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -388,6 +392,40 @@ xfs_attr_node_addname(
>  	return error;
>  }
>  
> +static int
> +xfs_attr_rmtval_alloc(
> +	struct xfs_attr_item		*attr)
> +{
> +	struct xfs_da_args              *args = attr->xattri_da_args;
> +	int				error = 0;
> +
> +	/*
> +	 * If there was an out-of-line value, allocate the blocks we
> +	 * identified for its storage and copy the value.  This is done
> +	 * after we create the attribute so that we don't overflow the
> +	 * maximum size of a transaction and/or hit a deadlock.
> +	 */
> +	if (attr->xattri_blkcnt > 0) {
> +		error = xfs_attr_rmtval_set_blk(attr);
> +		if (error)
> +			return error;
> +		error = -EAGAIN;
> +		goto out;
> +	}
> +
> +	error = xfs_attr_rmtval_set_value(args);
> +	if (error)
> +		return error;
> +
> +	/* If this is not a rename, clear the incomplete flag and we're
> done. */
> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +		error = xfs_attr3_leaf_clearflag(args);
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +	}
> +out:
> +	trace_xfs_attr_rmtval_alloc(attr->xattri_dela_state, args->dp);
> +	return error;
> +}
>  
>  /*
>   * Set the attribute specified in @args.
> @@ -419,54 +457,26 @@ xfs_attr_set_iter(
>  	case XFS_DAS_NODE_ADD:
>  		return xfs_attr_node_addname(attr);
>  
> -	case XFS_DAS_FOUND_LBLK:
> -	case XFS_DAS_FOUND_NBLK:
> -		/*
> -		 * Find space for remote blocks and fall into the
> allocation
> -		 * state.
> -		 */
> -		if (args->rmtblkno > 0) {
> -			error = xfs_attr_rmtval_find_space(attr);
> -			if (error)
> -				return error;
> -		}
> +	case XFS_DAS_LEAF_SET_RMT:
> +	case XFS_DAS_NODE_SET_RMT:
> +		error = xfs_attr_rmtval_find_space(attr);
> +		if (error)
> +			return error;
>  		attr->xattri_dela_state++;
>  		fallthrough;
> +
>  	case XFS_DAS_LEAF_ALLOC_RMT:
>  	case XFS_DAS_NODE_ALLOC_RMT:
> -
> -		/*
> -		 * If there was an out-of-line value, allocate the
> blocks we
> -		 * identified for its storage and copy the value.  This
> is done
> -		 * after we create the attribute so that we don't
> overflow the
> -		 * maximum size of a transaction and/or hit a deadlock.
> -		 */
> -		if (args->rmtblkno > 0) {
> -			if (attr->xattri_blkcnt > 0) {
> -				error = xfs_attr_rmtval_set_blk(attr);
> -				if (error)
> -					return error;
> -				trace_xfs_attr_set_iter_return(
> -						attr-
> >xattri_dela_state,
> -						args->dp);
> -				return -EAGAIN;
> -			}
> -
> -			error = xfs_attr_rmtval_set_value(args);
> -			if (error)
> -				return error;
> -		}
> -
> -		/*
> -		 * If this is not a rename, clear the incomplete flag
> and we're
> -		 * done.
> -		 */
> -		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -			if (args->rmtblkno > 0)
> -				error = xfs_attr3_leaf_clearflag(args);
> +		error = xfs_attr_rmtval_alloc(attr);
> +		if (error)
>  			return error;
> -		}
> +		if (attr->xattri_dela_state == XFS_DAS_DONE)
> +			break;
> +		attr->xattri_dela_state++;
> +		fallthrough;
>  
> +	case XFS_DAS_LEAF_REPLACE:
> +	case XFS_DAS_NODE_REPLACE:
>  		/*
>  		 * If this is an atomic rename operation, we must
> "flip" the
>  		 * incomplete flags on the "new" and "old"
> attribute/value pairs
> @@ -484,10 +494,9 @@ xfs_attr_set_iter(
>  			 * Commit the flag value change and start the
> next trans
>  			 * in series at FLIP_FLAG.
>  			 */
> +			error = -EAGAIN;
>  			attr->xattri_dela_state++;
> -			trace_xfs_attr_set_iter_return(attr-
> >xattri_dela_state,
> -						       args->dp);
> -			return -EAGAIN;
> +			break;
>  		}
>  
>  		attr->xattri_dela_state++;
> @@ -562,6 +571,8 @@ xfs_attr_set_iter(
>  		ASSERT(0);
>  		break;
>  	}
> +
> +	trace_xfs_attr_set_iter_return(attr->xattri_dela_state, args-
> >dp);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 0ad78f9279ac..1de6c06b7f19 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -452,15 +452,17 @@ enum xfs_delattr_state {
>  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree
> */
>  
>  	/* Leaf state set sequence */
> -	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr
> */
> +	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a
> leaf */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
> +	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a
> leaf */
>  	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE
> attr flag */
>  	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks
> */
>  	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
>  
>  	/* Node state set sequence, must match leaf state above */
> -	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr
> */
> +	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a
> node */
>  	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
> +	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a
> node */
>  	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE
> attr flag */
>  	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks
> */
>  	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> @@ -476,13 +478,15 @@ enum xfs_delattr_state {
>  	{ XFS_DAS_RMTBLK,	"XFS_DAS_RMTBLK" }, \
>  	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
>  	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
> -	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
> +	{ XFS_DAS_LEAF_SET_RMT,	"XFS_DAS_LEAF_SET_RMT" }, \
>  	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
> -	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
> -	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
> +	{ XFS_DAS_LEAF_REPLACE,	"XFS_DAS_LEAF_REPLACE" }, \
>  	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
>  	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
>  	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
> +	{ XFS_DAS_NODE_SET_RMT,	"XFS_DAS_NODE_SET_RMT" }, \
> +	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
> +	{ XFS_DAS_NODE_REPLACE,	"XFS_DAS_NODE_REPLACE" },  \
>  	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
>  	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
>  	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8739cc1e0561..cf99efc5ba5a 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4105,13 +4105,15 @@ TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
>  TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
> -TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
> -TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
> -TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
> @@ -4141,6 +4143,7 @@
> DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_alloc);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
>  
>  TRACE_EVENT(xfs_force_shutdown,

