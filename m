Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58271C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 00:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442965AbiDVAlE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 20:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiDVAlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 20:41:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E188443FA
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 17:38:11 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LL4RVG024600;
        Fri, 22 Apr 2022 00:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2pVfCaR0ob3elTutJr9FIbrrUJv46/2iEUU43HisM6U=;
 b=Y/BtVL7wrp3yRyQCvG3tXww2DfKc4hgA/lQjuMkGGMOXqbQ08hCyrghR9OJHIss+4Vn4
 EQH1yW7Q47ssjocZS1bwSsriiGVyKRTLBEb6OiwreZxZ2jTBXvfvfrolxGY5FIwFz8m0
 SsmntrEL7Eb9zdEes8qFoL3SkaforJEiiVP1vHvnNYmcUwoZVsYdC5eX9tJC8CFpZKqq
 qvBxXFoEwzpSR4SAwx34bfMZQ8TIIWr6v4Yq9zyLgfvN8ajH3f+6Ux2tolR2OHB08WZq
 lMs+7ynZs1WqGcKYKA/6lag2bmEfW3+01QB17uCkIjcd2uHqEfEjEnMF5P6pTKCmIP4G Dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9n32n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:38:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23M0ap2A037164;
        Fri, 22 Apr 2022 00:38:08 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm89rm1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:38:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVC6rspwINdAg1xNaZ2bA0Ey1tdv0/kNBgsJ4vQr35YqX2XvlgKf6iho/wGbWcNPIYCIUszPqr3P+OMqbtq+cqo7/gdG+l2vONm0qoE6Zo6RxUD9R/BWiVkCyKH8guonjmRipC8MwAM+2M3KUJOTdC40f6eb7s0wYbCCbTIazONEtzMJ9R10MTZhEy4IKBbMOa9qYVbGDfhduYfKW/cXN/UpQIGwK8RTfbOJ/sDIxyDj1qrSGLz0o5RGdWEsBUl/xfLrJEAm2x/7bIg0DwfFvUnrZpb8xosRQ8+gAI818JYe3QhvNZRlHx+nIOnzQ9aeICR2OkkrndqKdiuWEOHAUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pVfCaR0ob3elTutJr9FIbrrUJv46/2iEUU43HisM6U=;
 b=goFa4ML+nmBifSY3SOLy7IdViDHpoHPvEOtQJ/KHgBZn/kFrPjvpgnj2C7ssAKjz5dHK6UvfTLDWmyxuTHCmr2wYOnxBIH9a9sKj6zKYnCXjr66TAkhqPxc73WcYadNQT8Cdym0f7R9G3Ag3RFGe1eph8+/CxS2ghkL8MnRQrbgzWJFCqoQ1085OCenVXLu/XmlWJofCUh736j/J44li9IcYlwtCnzmdYPaWMfHRgyv1JKNitWe+jQvBYoK3HmxfV5Ul2LKeUcf5GgK9vj1NV3rvJLiY7fRGeKSXKgGysAINC43g3VXz20t5Pg5BTdqFK2HWnkS5BuS9e1a8HH2o3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pVfCaR0ob3elTutJr9FIbrrUJv46/2iEUU43HisM6U=;
 b=TrdFe0+IQopk4f0XVnzmycQ7iiuAdgVLuXtrJV+gXozX3P4YXfyVUyjqu1DV3GYRPXrPPRjj5fSKQkPzUn7EyD+Bo+IlURiuD6YlPy9OWShNe/LIoVl7n99XyQ/gzUqHuuVo1AJXmU70ycp/9qRerwNHy6HjuU8Po1EWvd4qUL4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR1001MB2251.namprd10.prod.outlook.com (2603:10b6:4:2e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 22 Apr
 2022 00:38:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 00:38:05 +0000
Message-ID: <14c2f684d3c5319b57d36f2f0bee25f9986f7335.camel@oracle.com>
Subject: Re: [PATCH 04/16] xfs: separate out initial attr_set states
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 21 Apr 2022 17:38:03 -0700
In-Reply-To: <20220414094434.2508781-5-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-5-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0108.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::49) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba511467-f272-4f1c-1dcb-08da23f85d8c
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2251:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB225148F390FFF54C9C0C623295F79@DM5PR1001MB2251.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eh+kuetygVUaO+CJ8uDFsQN+1Bg0RCD0+z8xVfwBHvMIesdNCaaV6MoW27Gbh2TxImwi8xNKjEg4R34cihuod9IoD1eTO1Ezy57nJTFoCnhrdp9KvC2jt4KmivepJ+hUcUyJyBoXuENnrAxcE6IGWWMH6ACkUYOrR6JzN9gv0qstqYq3xhAhtwLQUepe7tUl1/EdDPuneMSXF0L6FAUNhDjLDVTSztZYPSLtnM0IrtGLW9yrTDut0KzHjJgiLAlgtEOsLr9k9AoZWQzxcGexR3GbNyEdvIOBjV/qlsHP865N+VlujGb9FrBOPbRUwHViLbufpeXIm/kY+yk6ML0clFivTn+8zG7Tbgij0VJkFP3f3LPqwjfLV598wmsjsESngRRcDkEXzZ8k+CpaoNRa7EKPdqcNr/egJoT7CfsEzO1cg7js8YV1t84S45KPE9bnTA8XuLz1+SVM4b1UuHbPsfkD7Fg0s8qTBZ7y5AzLwmVt3re/2m/+Dk55LxdshTa0+BgJDIy2kxKpjAKVo/82nTELxrSeOpQ8RaB75YbWqGVYNBuRuO45FRaos5QcWsfi+qymWF70ZqAi0TX3ehXGkciiah9sK7/fEzBw0ti0TOP+2vSHJ4QYbi6i1jr9griucp089ckkG/4hcrcz+CTIDnrimg2x8WtDiH5/G8S4h3y0w+3ApVVrZOnPlzB3Zr9BkW3eLI4by4WAm7PVsKsCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(5660300002)(36756003)(30864003)(8676002)(8936002)(66476007)(66556008)(66946007)(316002)(86362001)(2616005)(508600001)(6486002)(2906002)(186003)(52116002)(6512007)(6506007)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1BXNkZWYkhjWk9QL0FQY1lOeS9Hb096a0lpS2x5OWdaeUEzNDlSTmpUS0xM?=
 =?utf-8?B?dXZ3MjBpZDllQWVHSFFIdmhFOTJibmU3R2ZFQVd4SCtIL3NNRUNVQmFENWNJ?=
 =?utf-8?B?UTIvcVRLM0tFdkN3M0tURTVwZ0lFbG5FSk1lQzREWDNBSEl2a0M3bEo4TTkz?=
 =?utf-8?B?YUtyVERtanBXMW1qTzhKTEtxUXFRbllMUktCUzZpdGJaQzhpR0hVMWNvalc2?=
 =?utf-8?B?NE9PckdxTmx1NUp5TFA5ZktBRkg4MU9BWHVYcFNCTU5zK2VnQ3QyUGNTVUNL?=
 =?utf-8?B?b1pUUWUzTVJiQzNIdlNld1NQdmk2bDJmNWRKcWhwcnVYNnloMCtkVEprT2dJ?=
 =?utf-8?B?NU9Sc3ZlQzJPZ0wzejhZQW02cVRweEtOaGM0dXdhRlF2ZTVHTWEyelRaQStl?=
 =?utf-8?B?QkhWUmhHMFpQbGJFRk1zdDNITmpMWFZKeGpoWUVJelArOXREOVgxWTI5dFRh?=
 =?utf-8?B?QnVNKzR2dHlSUjh5RkxpMXUxc3VPZDJtcEg3L29yS000bHNXcGdndFNBcVRw?=
 =?utf-8?B?STZkRjhUdGljL0N2RjF1c2dwM1dQMGlaeC9CVTMxU3BjY0tSTXJDYTEyOE5z?=
 =?utf-8?B?V0NISXRFYzB5a3dvUGtrUkhXc05qdHkwZXJva3orK3ZsNHF5TEpNcTYwZnR5?=
 =?utf-8?B?YmFMVlVSYXpmVXNDaysvRlFIR2llYmkwNTJmOTMwbTVvdTlXZFdDV3huUEtS?=
 =?utf-8?B?aW9FNXVwVHdYaVI2bVNaaGxRTUtUQ3JiN1YvZnpocVBTb0VwRmNpa003NjJQ?=
 =?utf-8?B?TE5xR1lidHZBRFFPWVgybTdFKzhnSGQwUzJtM1VkK2pmdUp0dC9pcG8zbzdt?=
 =?utf-8?B?SUdtaFlPQU0yMTdmaStSZzhxZ1BhQzh5ZmpsSS91RG5XU1V4VmxyNWlLWjM4?=
 =?utf-8?B?aVBvNlRQMmk1UXhyM2I5Y3hPT3BEcmlEeTJIWGhIQ1pFUTBUaTN2dVBqQXp5?=
 =?utf-8?B?ZFB3b0ttU1ppallqVW5pVTNqRU1DQ1RuVEc5NlVDMGczS2pyeHUxWWlqQjcr?=
 =?utf-8?B?ZitQU1ZxV1dGWWpLbXJqeTRqTy9TR2RyY2tYajBKL29wN1RtV3BMNDJDdlZa?=
 =?utf-8?B?Y1d5TkdMWmRLOUNYZEcxekpZRnFrNG5uc293bko4YW5RWHdaVmpHWnBTRE9z?=
 =?utf-8?B?Q0Y1VFVRa3VZaXhTdWxFUGdkT0QvS1FLdzFVR0tYZUtJSzY0ZDd6UkFob1RL?=
 =?utf-8?B?eFlnSC9adWtuQitVZmZFKzZUWnJ2WDdPaW1MMFpvdjhFYzRVQ0FKR1U1eDVG?=
 =?utf-8?B?MlBlWDVzalRzdWQzekluQjNqaFczcVVYRGVKM0ZWRFJ1aUc2cDlkTmFxVDFX?=
 =?utf-8?B?M1hEcm5KMU5wU3pvSlBrQ1FYM3Q1Yk9DZW1KYU45NG9sUDJtTTNNQ1RVWXpO?=
 =?utf-8?B?SktCRVlJY01HenZBY3RHWlFhSS94blZ5RkZzRk9DRThkVkQxVlNkUHprWS9F?=
 =?utf-8?B?U1JCeFgxbmwrNTdncDdwOTBPVUR5a0lITXRaQmsxMVI3c3NyTHJ3Tk9iSFky?=
 =?utf-8?B?endwcXQvaTVuUE1LRS81QTdkVVMwQ2VFNTlsbUhKQmpMQXBERHJsN0lBenBF?=
 =?utf-8?B?UjBYcCtBSng2MGZId1RmaFhTN21YT3dpaWFJNEc4Ulk1QkxGY3FKTFd1UTN0?=
 =?utf-8?B?SExKRi9zbkQ5azg2V3ptWXc3bmI2ek1VZ3I5QzBCdFdOaU1hcHhlT0NCNFBv?=
 =?utf-8?B?Vk93bGhmSG5PZmErNXprUUVyRzNzTEhNMm9lQnRwRXIyOGU3WEo3cXJJamNa?=
 =?utf-8?B?b0dWRXVrZkdOWGJPMytRRTVnVGU0Ujd5SFk0WXhIS1ZsN0hmaVNmM0Rvd1ZV?=
 =?utf-8?B?OHQvVkhtVVlUWFB1QXpyRm1MU3lFWFJuRTh2MXpiTXdYWXQvN2tqTEYwM2sv?=
 =?utf-8?B?Qzhjbm43YVA1c0dlai9hUm5MZE1TKzBaYkJxTXpScElPZ2RCaXRwcmFGZ2xY?=
 =?utf-8?B?VmllUThDQ1J6bWJEc1B3dWI2UWVQMForUjlyem1ZYXdaL0g5UTZZOWtURmJn?=
 =?utf-8?B?YzVBOHhrUWJvYk8yNXowNEVuOFFwNy8vRU5FWVFibnRkbjBsMm9TQ0Q1NEJR?=
 =?utf-8?B?Nzh3YmYxSFdTajBFbUhGd2VRZElhTWNhWWhIaVRZdStLcExiS2JVZ25URGpo?=
 =?utf-8?B?bUVwbXdMV2w5K1R4NnQ5c0EyejNDUDlwNVkva1I3eVc2RDlJSXd1VGh1OUsv?=
 =?utf-8?B?bXBselY0NUY4YUZwWklBdlFoZWlNUVlxNXkwQ3V4Y0d1dXRGYytybnNKZHJ5?=
 =?utf-8?B?UU1wZU1pSEwxQ2dzZUx0dVVNR0RwQ2tNbE5uMmlNWnptMWxKMHdLQytnamJ4?=
 =?utf-8?B?T1dDWm5JNk9IRENDU2pUTk1NTG9mem9EWFM2OGhnZS9vTHk4NWUvN3RaOEkw?=
 =?utf-8?Q?5rf57mVFOlTYz6Z0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba511467-f272-4f1c-1dcb-08da23f85d8c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 00:38:05.6221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Oatpmh+df2zsDvx6HjOjTBgUmYaG9vqIzP/feXlKbGUt06IJ7vG7z9O+2Ht8OycyMzJIN3nrFlY6Hwm8hn9A5aUct2psnYzRIR15VJCuy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2251
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_06:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220000
X-Proofpoint-ORIG-GUID: iL4_pPlVtKo4QW8_KkaIN38-3KC9xu6-
X-Proofpoint-GUID: iL4_pPlVtKo4QW8_KkaIN38-3KC9xu6-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We current use XFS_DAS_UNINIT for several steps in the attr_set
> state machine. We use it for setting shortform xattrs, converting
> from shortform to leaf, leaf add, leaf-to-node and leaf add. All of
> these things are essentially known before we start the state machine
> iterating, so we really should separate them out:
> 
> XFS_DAS_SF_ADD:
> 	- tries to do a shortform add
> 	- on success -> done
> 	- on ENOSPC converts to leaf, -> XFS_DAS_LEAF_ADD
> 	- on error, dies.
> 
> XFS_DAS_LEAF_ADD:
> 	- tries to do leaf add
> 	- on success:
> 		- inline attr -> done
> 		- remote xattr || REPLACE -> XFS_DAS_FOUND_LBLK
> 	- on ENOSPC converts to node, -> XFS_DAS_NODE_ADD
> 	- on error, dies
> 
> XFS_DAS_NODE_ADD:
> 	- tries to do node add
> 	- on success:
> 		- inline attr -> done
> 		- remote xattr || REPLACE -> XFS_DAS_FOUND_NBLK
> 	- on error, dies
> 
> This makes it easier to understand how the state machine starts
> up and sets us up on the path to further state machine
> simplifications.
> 
> This also converts the DAS state tracepoints to use strings rather
> than numbers, as converting between enums and numbers requires
> manual counting rather than just reading the name.
> 
> This also introduces a XFS_DAS_DONE state so that we can trace
> successful operation completions easily.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 151 ++++++++++++++++++++++---------------
> --
>  fs/xfs/libxfs/xfs_attr.h |  49 +++++++++----
>  fs/xfs/xfs_trace.h       |  22 +++++-
>  3 files changed, 140 insertions(+), 82 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a4b0b20a3bab..b0bbf827fbca 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -59,7 +59,7 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args
> *args, struct xfs_buf *bp);
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
> -STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
> +static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item
> *attr);
>  STATIC int xfs_attr_node_addname_clear_incomplete(struct
> xfs_attr_item *attr);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> @@ -224,6 +224,11 @@ xfs_init_attr_trans(
>  	}
>  }
>  
> +/*
> + * Add an attr to a shortform fork. If there is no space,
> + * xfs_attr_shortform_addname() will convert to leaf format and
> return -ENOSPC.
> + * to use.
> + */
>  STATIC int
>  xfs_attr_try_sf_addname(
>  	struct xfs_inode	*dp,
> @@ -268,7 +273,7 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> -STATIC int
> +static int
>  xfs_attr_sf_addname(
>  	struct xfs_attr_item		*attr)
>  {
> @@ -276,14 +281,12 @@ xfs_attr_sf_addname(
>  	struct xfs_inode		*dp = args->dp;
>  	int				error = 0;
>  
> -	/*
> -	 * Try to add the attr to the attribute list in the inode.
> -	 */
>  	error = xfs_attr_try_sf_addname(dp, args);
> -
> -	/* Should only be 0, -EEXIST or -ENOSPC */
> -	if (error != -ENOSPC)
> -		return error;
> +	if (error != -ENOSPC) {
> +		ASSERT(!error || error == -EEXIST);
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +		goto out;
> +	}
>  
>  	/*
>  	 * It won't fit in the shortform, transform to a leaf
> block.  GROT:
> @@ -299,64 +302,42 @@ xfs_attr_sf_addname(
>  	 * with the write verifier.
>  	 */
>  	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
> -
> -	/*
> -	 * We're still in XFS_DAS_UNINIT state here.  We've converted
> -	 * the attr fork to leaf format and will restart with the leaf
> -	 * add.
> -	 */
> -	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
> -	return -EAGAIN;
> +	attr->xattri_dela_state = XFS_DAS_LEAF_ADD;
> +	error = -EAGAIN;
> +out:
> +	trace_xfs_attr_sf_addname_return(attr->xattri_dela_state, args-
> >dp);
> +	return error;
>  }
>  
> -STATIC int
> +static int
>  xfs_attr_leaf_addname(
>  	struct xfs_attr_item	*attr)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
> -	struct xfs_inode	*dp = args->dp;
> -	enum xfs_delattr_state	next_state = XFS_DAS_UNINIT;
>  	int			error;
>  
> -	if (xfs_attr_is_leaf(dp)) {
> +	ASSERT(xfs_attr_is_leaf(args->dp));
>  
> -		/*
> -		 * Use the leaf buffer we may already hold locked as a
> result of
> -		 * a sf-to-leaf conversion. The held buffer is no
> longer valid
> -		 * after this call, regardless of the result.
> -		 */
> -		error = xfs_attr_leaf_try_add(args, attr-
> >xattri_leaf_bp);
> -		attr->xattri_leaf_bp = NULL;
> -
> -		if (error == -ENOSPC) {
> -			error = xfs_attr3_leaf_to_node(args);
> -			if (error)
> -				return error;
> -
> -			/*
> -			 * Finish any deferred work items and roll the
> -			 * transaction once more.  The goal here is to
> call
> -			 * node_addname with the inode and transaction
> in the
> -			 * same state (inode locked and joined,
> transaction
> -			 * clean) no matter how we got to this step.
> -			 *
> -			 * At this point, we are still in
> XFS_DAS_UNINIT, but
> -			 * when we come back, we'll be a node, so we'll
> fall
> -			 * down into the node handling code below
> -			 */
> -			error = -EAGAIN;
> -			goto out;
> -		}
> -		next_state = XFS_DAS_FOUND_LBLK;
> -	} else {
> -		ASSERT(!attr->xattri_leaf_bp);
> +	/*
> +	 * Use the leaf buffer we may already hold locked as a result
> of
> +	 * a sf-to-leaf conversion. The held buffer is no longer valid
> +	 * after this call, regardless of the result.
> +	 */
> +	error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
> +	attr->xattri_leaf_bp = NULL;
>  
> -		error = xfs_attr_node_addname_find_attr(attr);
> +	if (error == -ENOSPC) {
> +		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
>  
> -		next_state = XFS_DAS_FOUND_NBLK;
> -		error = xfs_attr_node_addname(attr);
> +		/*
> +		 * We're not in leaf format anymore, so roll the
> transaction and
> +		 * retry the add to the newly allocated node block.
> +		 */
> +		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
> +		error = -EAGAIN;
> +		goto out;
>  	}
>  	if (error)
>  		return error;
> @@ -368,15 +349,46 @@ xfs_attr_leaf_addname(
>  	 */
>  	if (args->rmtblkno ||
>  	    (args->op_flags & XFS_DA_OP_RENAME)) {
> -		attr->xattri_dela_state = next_state;
> +		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>  		error = -EAGAIN;
> +	} else {
> +		attr->xattri_dela_state = XFS_DAS_DONE;
>  	}
> -
>  out:
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state,
> args->dp);
>  	return error;
>  }
>  
> +static int
> +xfs_attr_node_addname(
> +	struct xfs_attr_item	*attr)
> +{
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +	int			error;
> +
> +	ASSERT(!attr->xattri_leaf_bp);
> +
> +	error = xfs_attr_node_addname_find_attr(attr);
> +	if (error)
> +		return error;
> +
> +	error = xfs_attr_node_try_addname(attr);
> +	if (error)
> +		return error;
> +
> +	if (args->rmtblkno ||
> +	    (args->op_flags & XFS_DA_OP_RENAME)) {
> +		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> +		error = -EAGAIN;
> +	} else {
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +	}
> +
> +	trace_xfs_attr_node_addname_return(attr->xattri_dela_state,
> args->dp);
> +	return error;
> +}
> +
> +
>  /*
>   * Set the attribute specified in @args.
>   * This routine is meant to function as a delayed operation, and may
> return
> @@ -397,16 +409,14 @@ xfs_attr_set_iter(
>  	/* State machine switch */
>  	switch (attr->xattri_dela_state) {
>  	case XFS_DAS_UNINIT:
> -		/*
> -		 * If the fork is shortform, attempt to add the attr.
> If there
> -		 * is no space, this converts to leaf format and
> returns
> -		 * -EAGAIN with the leaf buffer held across the roll.
> The caller
> -		 * will deal with a transaction roll error, but
> otherwise
> -		 * release the hold once we return with a clean
> transaction.
> -		 */
> -		if (xfs_attr_is_shortform(dp))
> -			return xfs_attr_sf_addname(attr);
> +		ASSERT(0);
> +		return -EFSCORRUPTED;
> +	case XFS_DAS_SF_ADD:
> +		return xfs_attr_sf_addname(attr);
> +	case XFS_DAS_LEAF_ADD:
>  		return xfs_attr_leaf_addname(attr);
> +	case XFS_DAS_NODE_ADD:
> +		return xfs_attr_node_addname(attr);
>  
>  	case XFS_DAS_FOUND_LBLK:
>  		/*
> @@ -874,6 +884,13 @@ xfs_attr_set_deferred(
>  	if (error)
>  		return error;
>  
> +	if (xfs_attr_is_shortform(args->dp))
> +		new->xattri_dela_state = XFS_DAS_SF_ADD;
> +	else if (xfs_attr_is_leaf(args->dp))
> +		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
> +	else
> +		new->xattri_dela_state = XFS_DAS_NODE_ADD;
> +
Mmmm, I dont know about putting this part here, because the
xfs_attr_*_deferred routines do not get called during a replay, so this
initial state config would get missed.  If you scoot it up into
the xfs_attr_item_init call just a few lines up, then things should be
fine since both code path start with that.  Rest looks ok though.

Allison

>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
>  
>  	return 0;
> @@ -1233,8 +1250,8 @@ xfs_attr_node_addname_find_attr(
>   * to handle this, and recall the function until a successful error
> code is
>   *returned.
>   */
> -STATIC int
> -xfs_attr_node_addname(
> +static int
> +xfs_attr_node_try_addname(
>  	struct xfs_attr_item		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index f6c13d2bfbcd..fc2a177f6994 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -443,21 +443,44 @@ struct xfs_attr_list_context {
>   * to where it was and resume executing where it left off.
>   */
>  enum xfs_delattr_state {
> -	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
> -	XFS_DAS_RMTBLK,		      /* Removing remote blks */
> -	XFS_DAS_RM_NAME,	      /* Remove attr name */
> -	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> -	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr
> */
> -	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr
> */
> -	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr
> flag */
> -	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
> -	XFS_DAS_RD_LEAF,	      /* Read in the new leaf */
> -	XFS_DAS_ALLOC_NODE,	      /* We are allocating node
> blocks */
> -	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr
> flag */
> -	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
> -	XFS_DAS_CLR_FLAG,	      /* Clear incomplete flag */
> +	XFS_DAS_UNINIT		= 0,	/* No state has been set yet
> */
> +	XFS_DAS_SF_ADD,			/* Initial shortform set iter
> state */
> +	XFS_DAS_LEAF_ADD,		/* Initial leaf form set iter state
> */
> +	XFS_DAS_NODE_ADD,		/* Initial node form set iter state
> */
> +	XFS_DAS_RMTBLK,			/* Removing remote blks */
> +	XFS_DAS_RM_NAME,		/* Remove attr name */
> +	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree
> */
> +	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr
> */
> +	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr
> */
> +	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE
> attr flag */
> +	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks
> */
> +	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
> +	XFS_DAS_ALLOC_NODE,		/* We are allocating node
> blocks */
> +	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE
> attr flag */
> +	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks
> */
> +	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> +	XFS_DAS_DONE,			/* finished operation */
>  };
>  
> +#define XFS_DAS_STRINGS	\
> +	{ XFS_DAS_UNINIT,	"XFS_DAS_UNINIT" }, \
> +	{ XFS_DAS_SF_ADD,	"XFS_DAS_SF_ADD" }, \
> +	{ XFS_DAS_LEAF_ADD,	"XFS_DAS_LEAF_ADD" }, \
> +	{ XFS_DAS_NODE_ADD,	"XFS_DAS_NODE_ADD" }, \
> +	{ XFS_DAS_RMTBLK,	"XFS_DAS_RMTBLK" }, \
> +	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
> +	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
> +	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
> +	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
> +	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
> +	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
> +	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
> +	{ XFS_DAS_ALLOC_NODE,	"XFS_DAS_ALLOC_NODE" }, \
> +	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
> +	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
> +	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
> +	{ XFS_DAS_DONE,		"XFS_DAS_DONE" }
> +
>  /*
>   * Defines for xfs_attr_item.xattri_flags
>   */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 51e45341cf76..9fc3fe334b5f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4098,6 +4098,23 @@ DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
>  DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
>  DEFINE_ICLOG_EVENT(xlog_iclog_write);
>  
> +TRACE_DEFINE_ENUM(XFS_DAS_UNINIT);
> +TRACE_DEFINE_ENUM(XFS_DAS_SF_ADD);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ADD);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
> +TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
> +TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
> +TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
> +TRACE_DEFINE_ENUM(XFS_DAS_ALLOC_NODE);
> +TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
> +
>  DECLARE_EVENT_CLASS(xfs_das_state_class,
>  	TP_PROTO(int das, struct xfs_inode *ip),
>  	TP_ARGS(das, ip),
> @@ -4109,8 +4126,9 @@ DECLARE_EVENT_CLASS(xfs_das_state_class,
>  		__entry->das = das;
>  		__entry->ino = ip->i_ino;
>  	),
> -	TP_printk("state change %d ino 0x%llx",
> -		  __entry->das, __entry->ino)
> +	TP_printk("state change %s ino 0x%llx",
> +		  __print_symbolic(__entry->das, XFS_DAS_STRINGS),
> +		  __entry->ino)
>  )
>  
>  #define DEFINE_DAS_STATE_EVENT(name) \

