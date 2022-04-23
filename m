Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B483C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Apr 2022 01:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiDWBIq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 21:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiDWBIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 21:08:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775FF1B9EC6
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 18:05:50 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MK5r95024809;
        Sat, 23 Apr 2022 01:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vDNO9LkZEP8CEaTqkBYSBa3WXqZJpi9268kWTt2Aw5s=;
 b=v3hwaDYf7IkraRW2H8TKqGX3c/nZOKEhWS+6LCnC4T6qBWK2aXT3INJDOspBoAq4efHz
 BjQLguefP19tiah3Noc/YGR0IV8mAQdzLIMx0zl0l9addxqfM+SLGob31enKhdVtoL8A
 3usEBKHcgzEWk4+9VtwWk9T1BReQy/4tJhULtQBVIigA6IZe/wyENoN3bGOwHd9YAJy2
 K7r0Sg4IGrPRYquLlO1BHFdBGFTE+wCD+U23ZbdehKeVU0Fk48n52FQfsWF58t1yIana
 HuLUse7ls9koKsviCPo//pbL2pLSv6aG606FWp+uyz1draEeV4Yo076GXCbzhNspM+t4 fA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9qh4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:05:48 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23N0uJjB016031;
        Sat, 23 Apr 2022 01:05:48 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8eg762-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:05:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsXBu3oN4DtVGCI1CT04oU8lS4nbG2ex7K9HN/1WGpZI+E2dE09xO9EAV8ncu8VfzRIO1Szcfyx0rkP+mlLnLNk3GCSUzeR8kKTB+rjWNuGYnrgRtWG8g8O6w/0mb4+enP9HveWfsZ4NcqSgTUjv/q8/LEG5983tHaDPwcgBHhm+KQrnartz9Ndh0K32GmQVqrgVa0IEErtTlIXxltbxIAWeT7IJRRNMIKC/VDWGraEqa2JmxB96GE+9EIyO/pooBXPIUXI/5rtyWpe8gn7wKcVy3SmCSHkR9GaJY/Mmd4i86IJCjFbgQbvjA2C5b6yh6/2J2yanH/vress/4m46XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDNO9LkZEP8CEaTqkBYSBa3WXqZJpi9268kWTt2Aw5s=;
 b=iErr/NH+fFwI69qW5iJ8sQkhU9VT5b8HTKRsKWtIzhXS/+ZSg5dFWnIwaz3wBIZkVxlPHejcYUQzZ2JcI1v6QY2FygSQ+u0pvNqtCaEtFMCcgR+ghTI5KjJiJMgs8HpfltWYyPDGgoMMO1xHM1eLuMZ+DuBtndiY0L4GoSzuF9V4wF7bQmhxf3aJCGVyhHe+hqIDpmoDsOLiRO4UdEOROPiG6N6mGE9xYl/nAwqYsfLPwTc1CNteiZfKU6tbIGJQeTuAVz5BTZLGZKPUy8fwhgWINA0hCaePqrLvdYsKKTws3Fqc+0BzKxqMhrQPh8Fg8uZ1mV5MGN1wuk9UvszdzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDNO9LkZEP8CEaTqkBYSBa3WXqZJpi9268kWTt2Aw5s=;
 b=pchXpGsIRLDK6K7//POZQgwQDy6s6ALBpC5vylq9Eof6z6jJH6/wrgMmGTWJRs6JpsijzApFLC6H1K54I7JV3NXbjHdqSEpmw1SdbSNbQW4cHoy3snn/k5kXh4nFjXxj+H7v2nhzd8qkz8uMB/k1k0XsnsZVFo1oQZVVxVyqh3o=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4066.namprd10.prod.outlook.com (2603:10b6:a03:1fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Sat, 23 Apr
 2022 01:05:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.018; Sat, 23 Apr 2022
 01:05:45 +0000
Message-ID: <7d351ba17118d488d740be92cdb75de9eb9bbb3a.camel@oracle.com>
Subject: Re: [PATCH 06/16] xfs: consolidate leaf/node states in
 xfs_attr_set_iter
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 22 Apr 2022 18:05:41 -0700
In-Reply-To: <20220414094434.2508781-7-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-7-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d58b4140-2905-46a9-f55f-08da24c564c0
X-MS-TrafficTypeDiagnostic: BY5PR10MB4066:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB4066EE9EB83869C09133083C95F69@BY5PR10MB4066.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXNJZgAhjQDRH0EPC/wOO8kCPMaPeHwv1uCxfdmxKdNMCMXZ1pJkZC7f+hkhst8majoIst/GxUc8Om8nR4Z6q61Gn1F2c90THLHYClxHM6K0pe5WM6d8tSk4nRHBEaMIlknhDA5vqfo9dp7OKSYby38Ojd7wv8LhaN4P8lUv23fPSI9bU6PAR4W0mo22y6by182PWea+lGw6oXH0xTKCP0GfpP/JTFu/JvgL5d0v6X/hWaHGYCkxhz0STi9plIwjUMW8/44wOwB6eaTvdbfTne7darsGQjvytX0cwKdAl6nUA9TaLdsoVQILcuuSLfL+h754rjzyMfB1c4/AoJG80ZW8VkW2Hl8Q/sGiNA9Kk1DBbUUrtGb/X7NgZhq/AJFCiL9gJ+6rXMwCP/4Jz77oE9E7OLZiDan91PCfbR4NroVNW+syFyiFBN88z1ahzBGL1URDUicT6y5y9NRVHWFzjdgZlkdZWKic5fAk/y3j5A0DLgB7Ysw//PM4duThORvCqqDluUs7bYAP41dbpNP2/UdEy1m2pwGwm/1Q5unj267HmnvZvm8+b9rbGSEQrJ0qscnVoJtyIBTFZ91ZwSTKoq1Khsg7K3nrK7vIUf4mIORdyVCMlHdfsCwiKDFnbiOYGYx0uWt0PETmZIYdUKnD6rMOcLOp0Oo4/nKwtacUulE1c7rwtv2e0kh9Sps98XrzMPK0QzddIRd1oJjIjfGeqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6486002)(66556008)(66476007)(52116002)(316002)(26005)(8676002)(6666004)(6512007)(6506007)(66946007)(5660300002)(508600001)(2616005)(186003)(36756003)(86362001)(38350700002)(8936002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3FOZkhLSmt0bFZTd01PSmVXbUZCZVAyRWgxUVgvdUZxMnU4UGdlY01ZN2tI?=
 =?utf-8?B?S2xSVGZtd3BDUFFkaDVJaHkxRmJKQmNtOVdFY1Vsc1pxSU5aV3lrVzExYnpj?=
 =?utf-8?B?RGFSOGozTVBhLys0ek1xMkNPbXFkMm0wSUZQVjErMkwrOWNlcXJIcnB5aEdm?=
 =?utf-8?B?Z1d1ZGR3cWFnUHVhT3YzaUYyN3BxbkJObkR3alpHY1BHOVNlRC9kQU1yVkQv?=
 =?utf-8?B?bGl6MlZyQkdxelRUZFFLa2JMb0xaR3VYTGdnVHZJM0hFb0QyTUlwZHgyWDFD?=
 =?utf-8?B?TVhVMnBaWkJ3R2VsOWx4eVNVa1Vua1NZcS9ibzdIdm4rS0Y4Unh6eUtzWTNt?=
 =?utf-8?B?aU5idzY2WlU5cWJJaXI5U3d0VmpYT04zWnM0aUdXK21mSVVJQ044ZkxlcXhw?=
 =?utf-8?B?YjhlZTJjV0VCQVdualVMeitVYmRoRmxoMmduRlJXcFpIQk45NVBXc2JPMHBX?=
 =?utf-8?B?djRRYlBEM2lxNzBHOTVCemZGTzFYRnZPU2hzeGJtV0xSME92b3g0MUdYR2gv?=
 =?utf-8?B?ZGxZbGRlNEZWMlJLRGh4SHQ4VFltZS9JKzZQVnFkcmpEK2tMZjY1blRYLzZv?=
 =?utf-8?B?MnF3dHFVYVEzUEd1WmFJWllPbGVVMFAzdkhtNlJIKzE2dHpMOEM4aXNXYUhS?=
 =?utf-8?B?bEs5Rzd6MmttZ2ZTS3J3OGZLVC9uRCswRlB2NGQybENHK0s5YmtWWFVkb2Ux?=
 =?utf-8?B?bkF4b3d3VHVOR0lMdHpHaGpydHFOdlUxZ2JodFNkRFU0RW9XRHpQU0RkT3J3?=
 =?utf-8?B?NXMvaFg5UzZqV01ZYTJzNEdzQUVCMitkZE5uZHRRRDlDM3lLMFdmQkhXT2Jx?=
 =?utf-8?B?Q0c5dkxhVHZvcVgzQ3RFbkp2L3V5eGVuclQ3WFJTZWJxSUc4WnRUSVVNUlMv?=
 =?utf-8?B?VThpcTBSUXNiK1QvdDh1TzlOVmtsSjJCTE96ZGZ5YlRvS1cyRkh3eG15bkdD?=
 =?utf-8?B?cFRCMkZ1enpDWUlxbW4xd3ZkUjlrOWE1MkdDTkVGZ0pKOWY1UEpJcTcvbkpP?=
 =?utf-8?B?dTBkVm9odTZQQndKMHd2QnJNZ0JJNkNIVldpQ2JDNWFOYjAwYWxQcHRkOWFE?=
 =?utf-8?B?c0MwUGtyNGsraGdOOHR3UFR6T3FEZW01dTVuWVhEMGhRekR3L2FoOVl6N0sr?=
 =?utf-8?B?VjVWc3dzVkhsNUw1QWd3NDN6SFpBZThvRGJwUVFJdE9SNnZ2K1B0WmxhWTN3?=
 =?utf-8?B?TnpIaTVnYzdEamQrU1JyVWRrQWZhSExCSlUzaFZzbXhZQ3BidmJjaG03OUo4?=
 =?utf-8?B?N29TbXBOWldlaENweThZWUVjcWlSd2dZM3V2Tk5zMUloWHRpd0Z1cjJHT2hG?=
 =?utf-8?B?RXU5eFV3V205anRMbFhEdFh5eERwUGRmQXI5dTlkTXd4UCttWXI3dkMyYkU1?=
 =?utf-8?B?MDhKamVZR1FEUzlPV1ZxRjhpNUZvWWNabWhsOG1GWVNQY3FrUlNlN1R2cmgy?=
 =?utf-8?B?VG1rTkxNQ0pNNFZqcmVBQmJ3WTRpdUJ1blZXNDQyUjBzN2x3bm1mS3V5Nk1X?=
 =?utf-8?B?SndITlZlemNnRnN6ekcxODZXMzI0ZFRKNmJrVlcwc1lidlBrSzFHekUzeDhw?=
 =?utf-8?B?bWJYcnBkNitMTWdtS2RsWWoyQnJvTFNPTFlFL0ZHNlR5QnJRWDVTQXA2Z2JX?=
 =?utf-8?B?VEd6dm1TL2JtYTltK3RrQXVGKy9hc1Zjb2xFOEJwbE1EeVVjODdPSEx5NDNN?=
 =?utf-8?B?c0cveEdEdm9PVEgwWXRwZ3h1VWgzdUlsd1JESmNmUExnMG0rM2UzaXU3MGFG?=
 =?utf-8?B?cTVZOElONVVrUUpUS0EreWIwUU1Rd25mOWxOT3phcUt4RUszTlZ4bG53N3d6?=
 =?utf-8?B?RGd4cHRwUU1XbXl6R2hzNTA5Q2lnY25aNkFxUExDYVNMMklnd1dCWXVyZDJi?=
 =?utf-8?B?V0h5WXVyZTFEVHFrbysrd1ZyYWw1eVNIdnhWRGRyZ2pYZFUyalA4UDd4RjNl?=
 =?utf-8?B?NUwzMmpkaGJwWVRqQjVwODNrZk1TY2hFZWVoSGhwZ0h6WW5ZVU1ZZVVBRzJk?=
 =?utf-8?B?Wlp2SzJVa21wWm9oakgxclRJWmRqS0tKbzZwUFhOK2srMGNYRWN2NTI4aGNl?=
 =?utf-8?B?UlY4Rmw1RTRBQnZ5bGQzdzhUNVAyMFVhTVN6Zlc0YTl6VW1YWDdrR2xHaVFa?=
 =?utf-8?B?cGkvdHdMUEJpRnVVOXQ5dk5JZlIvdWxMVlJIdzdpdXlzUmpBall5QVkzaFlS?=
 =?utf-8?B?NW5zZExkQm0wNHE0Y1lCZVZNSGc4citJdmgyTnhrM3MwL1RmbnpPOWtlWkZI?=
 =?utf-8?B?aFdoUEFUMUxHb2dHekZTd3YydVNjMEs0ZzJJWGpyemZRMW1OSktRNjM5amk0?=
 =?utf-8?B?ak1tQWp2S2ozWURZSzNBZ1JNOUwySUNnNDBnSkxheXlxajZCQVJvaGlFajZy?=
 =?utf-8?Q?/ynl7qp0fmNIzk3U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d58b4140-2905-46a9-f55f-08da24c564c0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2022 01:05:44.9182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZgDt3sxPJ+KLc/cV7njlhIzwAIipsSXMpqaJV5TpT++RWYsDvXM+m2ZDP+/J/NhoTH/Zj0dBO1e6D8mak+rw42zrw4v1BZ2Plb2LGQKkjaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4066
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-22_07:2022-04-22,2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204230002
X-Proofpoint-ORIG-GUID: HN7GwAM8r3EDnM9h_5bhqQEvZJRnbPlw
X-Proofpoint-GUID: HN7GwAM8r3EDnM9h_5bhqQEvZJRnbPlw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The operations performed from XFS_DAS_FOUND_LBLK through to
> XFS_DAS_RM_LBLK are now identical to XFS_DAS_FOUND_NBLK through to
> XFS_DAS_RM_NBLK. We can collapse these down into a single set of
> code.
> 
> To do this, define the states that leaf and node run through as
> separate sets of sequential states. Then as we move to the next
> state, we can use increments rather than specific state assignments
> to move through the states. This means the state progression is set
> by the initial state that enters the series and we don't need to
> duplicate the code anymore.
> 
> At the exit point of the series we need to select the correct leaf
> or node state, but that can also be done by state increment rather
> than assignment.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This is kind of loopy, but I can follow it.  As long as folks are ok
with it, I think it's fine, it does collapse down a lot of duplicate
code.
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c | 127 ++++++-------------------------------
> --
>  fs/xfs/libxfs/xfs_attr.h |   9 ++-
>  2 files changed, 27 insertions(+), 109 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fed476bd048e..655e4388dfec 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -407,6 +407,7 @@ xfs_attr_set_iter(
>  	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	/* State machine switch */
> +next_state:
>  	switch (attr->xattri_dela_state) {
>  	case XFS_DAS_UNINIT:
>  		ASSERT(0);
> @@ -419,6 +420,7 @@ xfs_attr_set_iter(
>  		return xfs_attr_node_addname(attr);
>  
>  	case XFS_DAS_FOUND_LBLK:
> +	case XFS_DAS_FOUND_NBLK:
>  		/*
>  		 * Find space for remote blocks and fall into the
> allocation
>  		 * state.
> @@ -428,9 +430,10 @@ xfs_attr_set_iter(
>  			if (error)
>  				return error;
>  		}
> -		attr->xattri_dela_state = XFS_DAS_LEAF_ALLOC_RMT;
> +		attr->xattri_dela_state++;
>  		fallthrough;
>  	case XFS_DAS_LEAF_ALLOC_RMT:
> +	case XFS_DAS_NODE_ALLOC_RMT:
>  
>  		/*
>  		 * If there was an out-of-line value, allocate the
> blocks we
> @@ -479,16 +482,18 @@ xfs_attr_set_iter(
>  				return error;
>  			/*
>  			 * Commit the flag value change and start the
> next trans
> -			 * in series.
> +			 * in series at FLIP_FLAG.
>  			 */
> -			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
> +			attr->xattri_dela_state++;
>  			trace_xfs_attr_set_iter_return(attr-
> >xattri_dela_state,
>  						       args->dp);
>  			return -EAGAIN;
>  		}
>  
> +		attr->xattri_dela_state++;
>  		fallthrough;
>  	case XFS_DAS_FLIP_LFLAG:
> +	case XFS_DAS_FLIP_NFLAG:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> a
>  		 * "remote" value (if it exists).
> @@ -498,10 +503,10 @@ xfs_attr_set_iter(
>  		if (error)
>  			return error;
>  
> +		attr->xattri_dela_state++;
>  		fallthrough;
>  	case XFS_DAS_RM_LBLK:
> -		/* Set state in case xfs_attr_rmtval_remove returns
> -EAGAIN */
> -		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
> +	case XFS_DAS_RM_NBLK:
>  		if (args->rmtblkno) {
>  			error = xfs_attr_rmtval_remove(attr);
>  			if (error == -EAGAIN)
> @@ -516,7 +521,16 @@ xfs_attr_set_iter(
>  			return -EAGAIN;
>  		}
>  
> -		fallthrough;
> +		/*
> +		 * This is the end of the shared leaf/node sequence. We
> need
> +		 * to continue at the next state in the sequence, but
> we can't
> +		 * easily just fall through. So we increment to the
> next state
> +		 * and then jump back to switch statement to evaluate
> the next
> +		 * state correctly.
> +		 */
> +		attr->xattri_dela_state++;
> +		goto next_state;
> +
>  	case XFS_DAS_RD_LEAF:
>  		/*
>  		 * This is the last step for leaf format. Read the
> block with
> @@ -537,106 +551,6 @@ xfs_attr_set_iter(
>  
>  		return error;
>  
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
> -
> -		attr->xattri_dela_state = XFS_DAS_NODE_ALLOC_RMT;
> -		fallthrough;
> -	case XFS_DAS_NODE_ALLOC_RMT:
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
> -					attr->xattri_dela_state, args-
> >dp);
> -				return -EAGAIN;
> -			}
> -
> -			error = xfs_attr_rmtval_set_value(args);
> -			if (error)
> -				return error;
> -		}
> -
> -		/*
> -		 * If this was not a rename, clear the incomplete flag
> and we're
> -		 * done.
> -		 */
> -		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -			if (args->rmtblkno > 0)
> -				error = xfs_attr3_leaf_clearflag(args);
> -			goto out;
> -		}
> -
> -		/*
> -		 * If this is an atomic rename operation, we must
> "flip" the
> -		 * incomplete flags on the "new" and "old"
> attribute/value pairs
> -		 * so that one disappears and one appears
> atomically.  Then we
> -		 * must remove the "old" attribute/value pair.
> -		 *
> -		 * In a separate transaction, set the incomplete flag
> on the
> -		 * "old" attr and clear the incomplete flag on the
> "new" attr.
> -		 */
> -		if (!xfs_has_larp(mp)) {
> -			error = xfs_attr3_leaf_flipflags(args);
> -			if (error)
> -				goto out;
> -			/*
> -			 * Commit the flag value change and start the
> next trans
> -			 * in series
> -			 */
> -			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
> -			trace_xfs_attr_set_iter_return(attr-
> >xattri_dela_state,
> -						       args->dp);
> -			return -EAGAIN;
> -		}
> -
> -		fallthrough;
> -	case XFS_DAS_FLIP_NFLAG:
> -		/*
> -		 * Dismantle the "old" attribute/value pair by removing
> a
> -		 * "remote" value (if it exists).
> -		 */
> -		xfs_attr_restore_rmt_blk(args);
> -
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> -
> -		fallthrough;
> -	case XFS_DAS_RM_NBLK:
> -		/* Set state in case xfs_attr_rmtval_remove returns
> -EAGAIN */
> -		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
> -		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_remove(attr);
> -			if (error == -EAGAIN)
> -				trace_xfs_attr_set_iter_return(
> -					attr->xattri_dela_state, args-
> >dp);
> -
> -			if (error)
> -				return error;
> -
> -			attr->xattri_dela_state = XFS_DAS_CLR_FLAG;
> -			trace_xfs_attr_set_iter_return(attr-
> >xattri_dela_state,
> -						       args->dp);
> -			return -EAGAIN;
> -		}
> -
> -		fallthrough;
>  	case XFS_DAS_CLR_FLAG:
>  		/*
>  		 * The last state for node format. Look up the old attr
> and
> @@ -648,7 +562,6 @@ xfs_attr_set_iter(
>  		ASSERT(0);
>  		break;
>  	}
> -out:
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 184dca735cf3..0ad78f9279ac 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -450,16 +450,21 @@ enum xfs_delattr_state {
>  	XFS_DAS_RMTBLK,			/* Removing remote blks */
>  	XFS_DAS_RM_NAME,		/* Remove attr name */
>  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree
> */
> +
> +	/* Leaf state set sequence */
>  	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr
> */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
> -	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr
> */
> -	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE
> attr flag */
>  	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks
> */
>  	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
> +
> +	/* Node state set sequence, must match leaf state above */
> +	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr
> */
> +	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE
> attr flag */
>  	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks
> */
>  	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> +
>  	XFS_DAS_DONE,			/* finished operation */
>  };
>  

