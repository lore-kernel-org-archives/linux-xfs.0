Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1651C77B7C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242821AbjEZIxZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242838AbjEZIxO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:53:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC724119
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:53:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8YaGD013795;
        Fri, 26 May 2023 08:53:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Hu6DFB7e/fApAtVeH6vUZ+WsjGUm3hT72w7nqQ+EwB4=;
 b=LpVnvRYiwg9tY/7/FnvKGMV5ovhRnB8glHUk+A7h/XNF5nUzIeTaTm4uz936zwQEOudI
 sV+WHqUbo5hul6LAOg4EFJUYRkAWiG7FlWGLvdkmnk+78bjp/ct0eBW3JZe0ULltRjAy
 LkKmnViFP+joelt41YVO969ftJcW6P8YGQmYtyqxulpLz3BI5kb23NAqKFmh9L0KSSA+
 M48V5KIaRYZwo8yJkdw8ZcIdd8uy2/l1IkgMo3dxj9Zsrj1foGuNrBBrbNHqVTZz8c15
 n3cviMkfZmzLl8fWCqyHSq+h8rm7MtYIs4rftNdo+wXR7I+OlBIlfBKxRLQ+YSUM0dbB CA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtscd81fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:53:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q81mCA013061;
        Fri, 26 May 2023 08:53:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk7jrpu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:53:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAs6EcGxziA+vK0coA0FVt6JAm9iuEQjizJeNjYWom3cXf9v/Qn72NkThfjNjAdxlnkDyNjxUR12IQTlxtfqrqo61rQlA9pHGGkrK5dgvjpswTq9hRMUDsdiOWvHSu0mB4GP5u9Byr+kl8fhY+ptKdyBbUFsEdzUg05bHiSL6MZGLB9aTPbvfsaHFbmjhLg10Nvx4Z2hUoVv6AZNtUyavRUxeqHIc6u4esdWZPYnEx90cFbl3SbBGZP0WRvha4Q00+iffzUqlUk78ceCsxXP3R7oWKkHaymtFKkw/R4z0I5Kpx4ZMH89Qen0tC5vGORqx732fnekSXP7UwKgr0eAvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hu6DFB7e/fApAtVeH6vUZ+WsjGUm3hT72w7nqQ+EwB4=;
 b=oeKY2caGCYI0HJybp+WkNBq9a9Xj6d6yyD5I8tBBaZM+skB76fxddmoraEGt8K99YDfmEemeXyT0j+ge5ANlh6b7QvJKQ/AWVuh1nYOVIGPaCC3rAT8EtOJOD+Z2GjTRbzqndjQQXtpOD4WcUdt8CYiObPKz54umOCjQ77Xg3F3RFpCDpx0IHj/Ca76SSHpe8Wh2xb7iGI0+G/+Rh2fKFoOlBorzfk9BMryp/fTBF32yQH/GFplQ43vuMNVOEahTX+sOf6FeOS+0n2+fZPJvjt0gic2igsfwMyXspXrziubgo4H13TIZJ24u7RrvQk5a1XoBtJIH4XoqXV/aHs7pig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hu6DFB7e/fApAtVeH6vUZ+WsjGUm3hT72w7nqQ+EwB4=;
 b=stZWORm33iDvjVGxIk2FmrIK5vAQmJleRiI77Ltn7rOWMzmEiutvTLhMiLhlhw/MRf+nEJvwPgi+nqjhWxGmvlnMpbe75qOmqvvaxBpM4q6VfrTqS6tsCDGjM6kjf9jR8xwWmSmC9ItNLvK3vX/sWLzn4E8ClnnOgbLsx3EkLrA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:52:39 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:52:39 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-18-chandan.babu@oracle.com>
 <20230523174415.GX11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/24] mdrestore: Add open_device(), read_header() and
 show_info() functions
Date:   Thu, 25 May 2023 15:41:42 +0530
In-reply-to: <20230523174415.GX11620@frogsfrogsfrogs>
Message-ID: <87zg5riiet.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0190.jpnprd01.prod.outlook.com
 (2603:1096:400:2b0::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 2beb255f-b00a-48ce-6405-08db5dc68f82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p2z46+yU+gNONTRFMe9EPeSnOU3lsg5tkpvIfUg386vCz/1fUcYRjKQEHe5D88EBsI/r7caf/hk1dajuGO/TZSiboZX6LeSKxO98G0mW3rIfuqB4SvHx816J1QWuMsg2LP+TpIcsn+aBseJPIIdn4mo6/xEFtmqxjxWC4dYHbcpDOXoJKiAcphnTrPLEwpKMp94bcW40Sgz5EqQoRvsC6adQY2QmUrEmn2BWwdbcTWFedv1QpBxxHMLa4pPxE5320UCPpbbjtnkKmywml5sDbHuiW+L+T2cwJ0+mc8sqGyYYP651EIGcG6ZjkjtwHL/fSgpmU6eKNOvM6FUfHu0aLvYjTETazXOjqSI4O0nZfNgJ5LYodGinGeLI7RZ/Fng4RQUn2kpJWkcFsdxFRxn6iVUAeN0Pasoy6vtUQEP3v76CRXjq68bCxlkpaNBscuGgBIyRBQo9STMiLGavqe7CJFrjbBR8IihVXRc2E1SnO51gkzpDrIPYZiYltTfvy0wz3VcdEkQ9xxRQB2yT7beWfsx3dp0l6AtcBcBTRo0RuFjCVGCKLYDKNlRdvrsCIw3R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hGAKgKv+EX/dBL/lc3caJhTeFFdKtXnaIyZkx3v/H+JsVD6VlzQoY+OCkBLc?=
 =?us-ascii?Q?eUbuKlsn/kID6el500LKkDCb5wwR9zCSnyN3UCeb8oyBdrOhCtGA4K+eHS+R?=
 =?us-ascii?Q?nrQLdzTd37/GrJ6b7nKYLf71zXzdiC/o0/uF8pQ+CJRAGcX5EZwkbJnc0JJv?=
 =?us-ascii?Q?3yojHGAEwr9bn3VIWaL7VbuCG2I5cdg6HdMwEH5+J5sJIrKes+PMqEviyE23?=
 =?us-ascii?Q?sUZjOyG/tNLNb0EyJNQeVENIjdwcBSgNUdQf7Ixxzt2I27EhPVyQoX/Z/Ndl?=
 =?us-ascii?Q?NhojMyL8SSRIOQurDTjfMICV1W/sKIjRiv97LW+lT7QWG1No4sD99p3GSmjp?=
 =?us-ascii?Q?t9K05M43EougNbDxlHIV9GShHmqHhzSzaq4fhAYRmcnjKQ/9tXHAsWmdbohz?=
 =?us-ascii?Q?ZevyLXWYXn3i5tSbMAY85nEXAz7cVCqRMBrfnBwnPGantnSvTfkv2jlYq0OJ?=
 =?us-ascii?Q?0R0Vuzu0HVbxalDDxm5CWwYCYuqvMbqKJcgA93NRh2gr4IPlxT8PxlDd9Y8r?=
 =?us-ascii?Q?wlQaDqWkH64+WWHp77Hi7ypKOvPOzozcBCNSRHQK/0CL6gmZlygDpc/QnCVZ?=
 =?us-ascii?Q?gEBsZOfDCqtN3q0f2ZyStgQizH0M9Jk72mumd2K4OYqEmvAxCTgpSxOSIRiE?=
 =?us-ascii?Q?mA8Lo5h8USODvLxpJjExTWCma8XVp00NGaHu48/PmvgUY5HrnW3Xmh85/TXl?=
 =?us-ascii?Q?4IbPnCAPL1UsRHmw6hDq7LYXElSJdSkXLAxVln8Odp9wArMmZI6AzAkOHQYg?=
 =?us-ascii?Q?9qqynjovIT1tqm6lovQLJ7yFC+HszA892GDGk4aAn18xzfkF14J9mfIc1oyo?=
 =?us-ascii?Q?aZ76utAG1fqVqKuemZCHlHl9rrecNCMbMK+5xINrvTOkG4d6GBmxVaSwy8xs?=
 =?us-ascii?Q?v3hfKjX1O2nSt5zdRnsVTQZ1tQ3jPtKVYvwPMKhoTqgjlg0VAb05wBckmhLN?=
 =?us-ascii?Q?/UBJ8HRioktX3zLP/BQzGvqJPitaWJN7NAhvpDmcidnOY+Rc2C8D4G5upt9W?=
 =?us-ascii?Q?dko02vq4bo8IwgCgQd2pOsEIrbl7aePD8g99Y9DLlojlkY1nY/l/QR9BdQuk?=
 =?us-ascii?Q?ZlCLf0yrn1MPcDKc+vQu6bJzrIK57d7RUq66dy9dZtKnTnWeS2x8Tf69sloA?=
 =?us-ascii?Q?//pwrvlbhg/z+pq3B7goYstS3uKCRDy0u/30gVoOuM/8DLO5nTZKcgR0t/j8?=
 =?us-ascii?Q?z0Ui5mELMWXBxHsTY4/tXd+pS+mdCQWuR2MObDZkff1XM05DzWe7B2ZWES8b?=
 =?us-ascii?Q?OqDTQmn27wf834CdLkOEzLkJrV4BnsDA8KoL/KjhWbk4EcNPwRnVcWrQVHuz?=
 =?us-ascii?Q?KOaqdF2o7BDjAG9NA4v1nXnypbM3/HBFWLAQ/NBap/yeAw7MHN//iOCsAKEK?=
 =?us-ascii?Q?AWUqu62XuLj3sjwUke6Qyqv5CNEuXtdX/43LkqGepi1R5GItr3FX+dNpojZ8?=
 =?us-ascii?Q?zEX3vqkKbM8VoeYWgLUjBr/jtzdqnRLC1jyqcgfhOjJ+gjtfqvrsBXGww6FF?=
 =?us-ascii?Q?3H311lZ1lgE0eGlkjogfB36tSfUKi0toRqigfNupyySWOKQXR7xfnSDWNAJd?=
 =?us-ascii?Q?YMbrQ9vpZgr94yUVy3fuipsLPHugIzY0SqDfhzx8B/tGfQxOgnS2UMCvYeY7?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Hs+mQJBdCpsWFZIUeUqarJv5R/v6/FWPcwm7h7zDlj7wvs0dEozuNhMgzBYNrsE4XEeOS45jhes/mfA90MeRlDkxntUIr3w9uGg0MzNPpiNU7d4FWqFydeMYcWIRutwxEUjazvG+iEXHdG4qfv3H5Ce6ZJ5bqcxxR/uf+waD9ExNBLnDEMGMGTSEk4Q3T/PmB54Qbr466ESwnm9unvef2hjFKYdrGl59iOtBbr4r3cRGUx2yWE8fS4fsphCOS08vwgNog3XTV6zkbatbyi/kMBGeBSiAqiB70ryc4CFFT1hEEzr0tMw3qDF8W0J0y/SLJDa5UEMKcLS4DcYKaz6ca4bW6xDotrt7GdS4PQhmTRVFx+4FOuDWsW208Kg9GfuovLWUbVVZRz9RR6kCdiCmGN8glnPHUHToNf9/wbFrlC+GKFILwf1AXQkIWAUIHZSnSfCMyr0xOfV6rNw7WQzMJUWrGRCK4esjrzmm5YHFagoWDSqDjpkqtfKUU8slwnTy3WZ83Z9pWGuPuVHtbuMA+Yq2wQMXWS7NAqqqbKaTKPDCH7GbvFfroDauoFmTdnyATr1JcKrM2+rZc+Rb60h6xSHsPRrYVm3/Vm0m4cPKcxcPWdys4CDGrmbM5FogJdQ5Tv64LanMEO6bvRa7FYs0w7I7/5T516ErZjyJLgKFbjbemtOqFDo+laX9tHqbXHPxxby5bduS2oIlQjQMcwIO/n8jE5FVnMnJJYNI+hTw44rGG7mo+eNrtB8pQeBMZDorqAuQRzXMtdLF8LeYxiOyO0LcSSpHfvAsAAc/xxsBHKM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2beb255f-b00a-48ce-6405-08db5dc68f82
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:52:39.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Lpb6lwzO+W2e8LbVzAcaZ96QxdKeira2BHply2s4WBI+FIanFYabYM9avUZMEJutJNC3S8B/aYmwnk0fXCV/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260076
X-Proofpoint-GUID: gmVi3PosU2xttmYpUsWILgNZMPe-T89n
X-Proofpoint-ORIG-GUID: gmVi3PosU2xttmYpUsWILgNZMPe-T89n
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:44:15 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:43PM +0530, Chandan Babu R wrote:
>> This commit moves functionality associated with opening the target device,
>> reading metadump header information and printing information about the
>> metadump into their respective functions.
>
> "No functional changes"?
>

Yes, this commit does not include any functional changes. I will update the
commit message to reflect this fact.

>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  mdrestore/xfs_mdrestore.c | 114 +++++++++++++++++++++++---------------
>>  1 file changed, 68 insertions(+), 46 deletions(-)
>> 
>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> index de9175a08..8c847c5a3 100644
>> --- a/mdrestore/xfs_mdrestore.c
>> +++ b/mdrestore/xfs_mdrestore.c
>> @@ -40,8 +40,67 @@ print_progress(const char *fmt, ...)
>>  	mdrestore.progress_since_warning = 1;
>>  }
>>  
>> +extern int	platform_check_ismounted(char *, char *, struct stat *, int);
>
> #include <libfrog/platform.h> ?

I will include the above mentioned header file.

-- 
chandan
