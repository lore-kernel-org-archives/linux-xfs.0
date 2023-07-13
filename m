Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E35EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 06:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbjGMGke (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 02:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbjGMGkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 02:40:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8F41FC1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:40:30 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CLAKAB010415;
        Thu, 13 Jul 2023 06:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=RCiYy8A5rH+A5W8QkS3NGg9dZbKdMAAFrJxCsqKrGGQ=;
 b=iBWmjEkzTmfzxgXxdb+FuxUGoiMIpKDsCLkNGmzIP1SqRzKu3khXvbozLOimefMbWAQ+
 d77+o6VGqZPPn5wPB+wimNreh0hJwjiV1MXr2rkVPSyon63d2xvPcSGh601HIoJ0nSot
 8/tfK39TG8tC9Ih3bsX9Xn8Vla2zY7DWMmtueFaA3LgORGMr0Z/jKFmaL/vttFy8oTmY
 tlXFOvgpKZrf6GQCGvzTY7gemr+iP/G9OmGonDCV2fjzbfN2jcVWIyp/v7etdxBb2lVT
 OYoF9tAx+B3lPFmNQlhNLoNbZGcbiAaweeJcu+hZ5wYVbBInHDx1w4cjEv+bkDfV5Vyp zA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydu0tj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:40:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36D4W7VL033174;
        Thu, 13 Jul 2023 06:40:25 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx88ae69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:40:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVhOetRNaz7h5N+JbfP2bcM4ej9K5pZUrCMxEvV3TLqTHjUb9UQ74G5+z/de9mMgP3rIvzUN+pXh9ZoPw7uQcnfRprRthJXjl6Or7pOGa8l78yVEyoqLOOfuTzgKXDgxNcHgNvOoyQ7jNanaFpqLaQo78dtggbGirc/oRdGGk6YMxOq3hO+Dgnc9g+IYT0DfVcVcYW3oUFWQfFQGphDdVJOPEyA/iIt/2npuT2nPWGGi5KiCVcxclTlFmLox0HHVUwV8d2WwqJ/k+t2EduitIsz/hVlzsO3tA2ja6knlWvhJwZ84CWMUSs+wgCrVcODyL8sRrzYeOnySElFQeAIyTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCiYy8A5rH+A5W8QkS3NGg9dZbKdMAAFrJxCsqKrGGQ=;
 b=a0l7SUQnanJpl87dDYgzSdH1/FlY9/jm4hRodTaeWiUyyXonfq4EMpmmnEc+DT3CuciXH1RkPyAhknqxbL7FR83BJU292iqS7+CMjTTXCt7lRNV5wIxkaz8xhjWMgRmUy3Zd01pqB38JpO7UNLqhfNnXnjfXdAvrqWbcaexuxTPOLnmtLF7/WtZVz56h318L4H50WJO++SeKW/V0EXy8kG0FTkUXeoQYmzXpSRzm2kCeBqfsbkR346gGTBoerdqIGOOaccf6YjTL/eezoP969G9TMQKfvXIXQCsg22cUMt/qhA1G7b+JFQETklDc4sBggvY29rz4YnPWj8QutceJGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCiYy8A5rH+A5W8QkS3NGg9dZbKdMAAFrJxCsqKrGGQ=;
 b=phFn6QmM85Gi0GBpwFfYpWGuBgIVQKHrr3DgRCBgNgWcqVl7xHi6F3MYqnkBPX1H2sqlerLQ2T4xXiNDbc1GfmFICJAS8lxEmZAnT7vCsy6p8MkFyCXZ7wYlT0v0xEL8SLuwAxqZbx1ZIlvaHL7tOftdMmoWNwdsYIBJZHCI7aU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SJ2PR10MB7759.namprd10.prod.outlook.com (2603:10b6:a03:578::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Thu, 13 Jul
 2023 06:40:24 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839%7]) with mapi id 15.20.6565.034; Thu, 13 Jul 2023
 06:40:24 +0000
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-12-chandan.babu@oracle.com>
 <20230712172202.GJ108251@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 11/23] metadump: Define metadump ops for v2 format
Date:   Thu, 13 Jul 2023 10:15:15 +0530
In-reply-to: <20230712172202.GJ108251@frogsfrogsfrogs>
Message-ID: <87edlcjovl.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0236.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ2PR10MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: b447d310-3da9-4b73-b2e8-08db836c093d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wIsbV/myQMeXOL+0jxwBmZmRjoOurzRIax1ykpDEQVRdrB33I1+V4anHb+2NDG/eGfbHZay8mtlDn/+P/GRr1xSDStRts2/RttlSXc8LfKfuP62Bn1w8Dx47BstuMQnQLvMSvg1D+jVncTNtfehiscBvitYfumOC7yfbGEMAtLYVtwmTXZhCDGUF8PKO8nE2dXMiongMSAHSiirkTDpeNWngZjagrxHGz4D2qgn/NCqBE1OY2r/aDzv6iGMmaK9ZCEQFAsnthDQ9GsQjS9q8Gnr4C99/dHWfNONIg+NGhXeXLG7auplh8sfKbXrlLr/jUDseI1FQyhdD41cxTB1ORv6ZMyjyi8/rqhxZI6LbSvkg0D7D1+gz4Mf+esZW9HRt55rNbbH7TVOZu8a5E3NyDjnpKiCxbW8e1t61f4175N/vicB2WlFTrj/NTgrZHgPZBgzalaCZXqB4/h372h/SwJ/NHB9PeHplLIVmTIdzu+79KbJwcPnEGbcWnp21yhYql3myMqRlZv4vocXkchbI+X0ITbqxP7nmtv/A9dg4Q8qvMKfd2MuxTEYixqI6aics
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199021)(86362001)(5660300002)(8936002)(8676002)(41300700001)(316002)(2906002)(66946007)(66476007)(6916009)(4326008)(66556008)(38100700002)(33716001)(83380400001)(6666004)(478600001)(6486002)(186003)(26005)(6506007)(53546011)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2sx9Z0puqlrJfFzy63ocpkHvfGgYQ5yvwuPhC6671iE77MoT6hVykr4fu+Ck?=
 =?us-ascii?Q?iFSf2cbteHBkojGrM6D9Ls2LDfj2Uz/VPR9vTifvrXFLn/BBB98EqDTqcvC6?=
 =?us-ascii?Q?1GvpchwWRB0lTnRColc2PNQ0bxwdAGiJyExhMqsDHglUABFHLSzBhe0vDGsk?=
 =?us-ascii?Q?eT8ban3b11ES3QgFzOFSK6Ie6szkRxtxUzAuFuiHHVLGwvNz185lYhTKcoJZ?=
 =?us-ascii?Q?ppwwYXkpyiZEI+6AgZFpzCTQoC9s4JwbFYKujUSm7DFOIM+fsRU/O74ViEZw?=
 =?us-ascii?Q?wFCDen6PzwHpSmJzdQPGRVU7Z2Btgk2nhn2kWSr/cAiA42ptztlb7HFv5scz?=
 =?us-ascii?Q?M6Yk0PRbaeY2SGyuVa8laTbkfrZvLmwtYodlGYI3biIz6U8Bl0speCpwIhmh?=
 =?us-ascii?Q?mRNGuWMa4I/i+mmczqdhtld/OeIToWg+/NsiEgYPA/UorUMeLGyTtz6IWYWs?=
 =?us-ascii?Q?JkCkBfV2PBYp8FYBlmTUPQAGAYzP3vX8SFyPvcHC/evsxv/61Q2m1wy4ALPD?=
 =?us-ascii?Q?WFh2OPzPtPYUXkSotcOZ8S8ei7Ck5U3WvtcB8kgB3Z/Kc+pAVI79+WMLvYy1?=
 =?us-ascii?Q?gVJYOvwgd7uS50z8mSfj9JYvk1/2rCky0lvkE9PNkDE2eXazFpbgX2dmkA7x?=
 =?us-ascii?Q?OkgG+aOPSLTpVrkCa3rBdY/Vo3T5zCmBD4RrP3D9q9UIPX7KBsvzBXKK+r9a?=
 =?us-ascii?Q?sm0V4N5aIF6I3yc2lkfvTkUfIAYPVYIhJYLYRZkxE1I5SAozyIIddzNBioo2?=
 =?us-ascii?Q?BZYBbMv3IvbE48RtWsDccZQnL+XoB61hFRXOr5OWL8d96yl4hrMs1hUnGGG2?=
 =?us-ascii?Q?X0rkzF90O0dRB12zWFkjioZ/lApUZPJ6pig2guQQR71ZuRP6VaMmSQfMngha?=
 =?us-ascii?Q?dhuPEPBjyuqVhdn72yHMsbmITPe88dOS+WnSyXe4LMYX3GYT7hjIrC5SBpI2?=
 =?us-ascii?Q?J4JOOM3Alhuk6lSdUVGJ4U3NvhefTpnR+fQ2fAwOcVJOyccb4qjepb/XyGDL?=
 =?us-ascii?Q?2EZZPa//cylmksLxutt72Dp5RlARb2qm2oJJimxRvGuCH/Qw1uizeRomieHK?=
 =?us-ascii?Q?k6lRyOS/LqICVNBxAJ4uYimWvIojTY4YjnZufELkjWTz91P8Y2J+Vn9eRHt7?=
 =?us-ascii?Q?gFHjHGaxhi4hKiN1rTYIXrpruyzjkDyG99CrPjIo/PQzyvUzWlmvZ3OeRXFV?=
 =?us-ascii?Q?j+NOugXcZg4NN3V7JJrirUoELsLKjZyxMD5Yc9ZGwU/OiF54qD9PAOBZ78ep?=
 =?us-ascii?Q?Z9cADNtaOjJbA1o/9ItgbKWPbcmxMNwENq10/OalRe8lK2/4i06o13Rkut2I?=
 =?us-ascii?Q?cpiwhDmf/1ITOC309xkf79XkA5qW9E4Rcyp3aUQowrSkue42UrlixQ7L7qhN?=
 =?us-ascii?Q?BhYdvTRmH4YLCcxBoH+EJ2V8kEzVzv7QLio4zosNSJQH5+HsEmgcAxaOXW/L?=
 =?us-ascii?Q?OEfh4ZqnmOcqtOlKCXVr3QuIb6YcF+qwSsNNWaPTFqZ+5H7m+fPT/NuOXI+p?=
 =?us-ascii?Q?eCgJz++cVRI1nBqbi8kOf4nPE0nHti38skNNO0g/84qbtMzXFPpPnIzZQkhJ?=
 =?us-ascii?Q?jYZegbEYjbGyC1Pf3jmFDMEpwEaU2VA89Ia2ZCea7QavULJKGO4zUIgplsa+?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LFlE+RaLZnvk6Pk0cixupPBkCulTC/LnWU+r9FdA+mJ+eWSY0lpym/d+g/cQJpgXg615ioTjcG7/cMLvVwlSTSOQKNKoLOC+DaPGb/9FNWKQe8HtE7E+bAkFbuD2ukNg+oiQDfe0AclF+6y84Qn3LpGJ0JHPNWpN2Rq3ozHVQy2gsGN+4+wzn9Eh5j75t2YAVa4cANRqxbuXazFYFcwFeOa7zDBvnwilr/op03nebJXore+/YIcFaCblLI7v6RI2YDHeOMrCdatlbLKBz/wGht9PiIBQu/KimU1/6dtoLLlMpFceu+dQwTYVzhDcuzBJKnJ0ZRCl8x4YX6Zv/Z+qDfYZqv8MFsD4P+riVeuujbxRvMWCfgbpBHXVseVVxCZSGPyHTVMkF6AGNcU9PF8YRoUM/xhAIl0c/bhDRLHue9nlPqVg0BPDVN7cFG9eCWYj0SzHvguYrilLhE2colI8VT/dcqjtIe7lmQncYbrchj/y0UfMxFhjoWoKETslRcREH/2hzFHFjyJQmdyRMG74lyMcGpsJX2ZPODPksRwLDCT5xDM6nwtYlB8AWIqH1vCWAWesTDFy2xrAEOBM+rf187VfF14YWrxPkh2sbxttfsWNlprdTrjZ0vdVX1vnUxi5RnhhC0255AovDxHvK8YKgu/CHAxEfxYEhHj3s9LVQVMRd4Ist930kwj54b3rT0JnKDvrzDRWazrAR9fADwMT4Hezf7Q+ffKuFSTSsFqNIE6qWn2tpP6twsk26vIAdVf3xIy5dLPljtn2kuNrcsXRv09VUlMzsgKJfskkhu8yxWk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b447d310-3da9-4b73-b2e8-08db836c093d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 06:40:23.9882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JtrLzWxKeiUYS6b1eq7IZtw3RjftYPEgif/4oFZ3HWAjCybTRcvSEerwgdJS/pJahrNQhxW4NdMPC+hEZ8Kh5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_03,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130058
X-Proofpoint-GUID: 5n3JTPa074rytNy6x5eFHr-so_6idLHC
X-Proofpoint-ORIG-GUID: 5n3JTPa074rytNy6x5eFHr-so_6idLHC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 10:22:02 AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2023 at 02:57:54PM +0530, Chandan Babu R wrote:
>> This commit adds functionality to dump metadata from an XFS filesystem in
>> newly introduced v2 format.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/metadump.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 71 insertions(+), 3 deletions(-)
>> 
>> diff --git a/db/metadump.c b/db/metadump.c
>> index b74993c0..537c37f7 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -3054,6 +3054,70 @@ static struct metadump_ops metadump1_ops = {
>>  	.release	= release_metadump_v1,
>>  };
>>  
>> +static int
>> +init_metadump_v2(void)
>> +{
>> +	struct xfs_metadump_header xmh = {0};
>> +	uint32_t compat_flags = 0;
>> +
>> +	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
>> +	xmh.xmh_version = 2;
>
> Shouldn't this be cpu_to_be32 as well?
>

Yes, I will fix this before posting the next version of the patchset.

-- 
chandan
