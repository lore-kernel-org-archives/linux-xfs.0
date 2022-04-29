Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8ADEC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Apr 2022 17:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiD2RZp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Apr 2022 13:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379534AbiD2RXr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Apr 2022 13:23:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68D32229E
        for <linux-xfs@vger.kernel.org>; Fri, 29 Apr 2022 10:20:28 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TEDjS7032133;
        Fri, 29 Apr 2022 17:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3+ASsP7rjp9rM+frKyT2dF/+DEUc/ZYeUROKlae74Go=;
 b=Dp+3txz/754JSp0IHOMsw3l+Q1pR96mf/Q/9Cgw/6TITTfvTlJpas/RW5ASNBLok5er2
 MHKHfSltQI/Q9cLZ18TA/bc50akb+ll4S4uorHNH06PgKV706J5BjxXI1TC/v7cb7ptY
 YNiulgEsc/qkAXBnGg8lfKA+O/C1wVsvqSo9sRBo8iU3L9wUVsVUbflqJQBlY0cUjFJj
 GC1pjEB/I0OQjrL+N8g6aw8bxRPYKbasl9r2c9WJcPJVza4C/hU5BB7+wuGnjMv5AmMa
 Ype57n7rMUN/oxo4hROfAeqYcBcg/gzjGopLg98vIvAsSHcCEExDJ49NvK+6TV2tnfBK ow== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb106pem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 17:20:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23THGhic033424;
        Fri, 29 Apr 2022 17:20:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yqdv7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 17:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/afk4pQPl+zv3adDkXm63yM2hSVZ7B0Ro+PUnovVQX67KSoHSyorWss7JH3g2PdagdwncchJHxhALhFdf0+WlIOwTyT7RhZiG5g3jm9T8icCSnbzRQvqb2qcfW5a6S+oboPSitZHAZbtqxHUeeSQyZ3nk5W2QggeMDfGV8sCgPEiZIVKoEh0rbA1PkeaPxSZK9DlQtH5Zmo6diWVP/vvfIu9e+4Pr6MZF0CzWF9kSafeLKQGVSweYasHwv6zhKrlR6MYaHdZm52lGuYsua8j0seG6JkCenYLS3TzZ9kPYIsDYXFW7+u6TkrhFuxuE4bo85lRdNML5bwZ/54LiHvQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+ASsP7rjp9rM+frKyT2dF/+DEUc/ZYeUROKlae74Go=;
 b=Oti1nZyXZKvSOvoykB2LhNDfspQEFnz2yFeEVyw/j7QGmmHdrWwPEKK9rzpS9w8ZzqAZ8Bib4ICah1TR1MT/6d2PHzN7iAdBn0cpMt5RX9AAR1fChtFQ4ShWMe7vKvJgtIeSnwhkKCRPD6LjGVdtxXwwrpBb5wiOQVNgVgCsnz3Orv6ZV7rS1KUq2/du4kX9PDBmmJmQ4PqQMGnisVUnuIZ0dCCSG5K6Xb1q7hJeMQj73qceK2iiI9JzFka6UOxRQ5XED2Wx3SmXGLuVu+MdAUENnrUH8cX2xDavmwfGFOYQMpovflQ/L4wG4hi7pZBW8Nizjy8uQX04eebOF84uYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+ASsP7rjp9rM+frKyT2dF/+DEUc/ZYeUROKlae74Go=;
 b=vsybpWVVRyDUcxadiyyNmsDjBIjsiZr+XBqLIwS8C9H0Lah0VnL+PsNiveLZl3OD3aYDgKPHmdbupisu11zX/qshMOvVMU9ew+wob+Xw4iVBOkBSQ87dmveU8qBHOa+Jkf+ZDRMWlDCtBBE8UutKC1hGUnkyTFGTA61ID0ZIWNs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR1001MB2243.namprd10.prod.outlook.com (2603:10b6:405:30::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 17:20:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.027; Fri, 29 Apr 2022
 17:20:21 +0000
Message-ID: <f9680a721516bbdbc411a9ad9b6e10daa313ce2f.camel@oracle.com>
Subject: Re: [RFC PATCH v1 2/2] xfs: don't set warns on the id==0 dquot
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Date:   Fri, 29 Apr 2022 10:20:18 -0700
In-Reply-To: <20220425224246.GJ1544202@dread.disaster.area>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
         <20220421165815.87837-3-catherine.hoang@oracle.com>
         <20220422014017.GV1544202@dread.disaster.area>
         <05AA5136-1853-4296-8C56-8153A34F44D1@oracle.com>
         <20220425224246.GJ1544202@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce702fb9-d7bd-4642-6571-08da2a0489ed
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2243:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB22431BFB8A378CB1B3714F4295FC9@BN6PR1001MB2243.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XK+RelkwyREiFHYrT4tELDYOqgac5YxPMwqcrv3Gj2sYWJGG3PkQWoDcl7BfXKXe7fUFuBlrUK2TJ04keRlClZtkw1YdEs3og85WA4eJlc32erDb2oDgZ/wVJhUV9ysPaR+VtNaRR7dJEpi1v9MrF6i2ST8PfL8an2OKKW/F4vvgybS6DzNlnrnEBESW1ENfZx7R6dzWjmwR/QDZ+78MlwPOK2VKggUkoN8cixvA89nfzB/1y7TXkjRrWcBCET+xzqT364vFs/XSQiAzNXOSti0PWKnTKU5XyLgsQIAPhtvF5Ys4lVa/jgW+5PZqr8XnONdAjJtdklFV/hjmXF2pNoSmnGnZ8YsK6bb+mp2yhBWMRub14epHl/rNu7FB6tTfB2MGlVCRDzE8Bg0Bze+C3hD1KSTbM/r76Kvo9wKeEgOw7U/ZvIKrq9Q2PtkbhiOKuPloaXdvGWOXvnBM5NqfhNdc45YQXAK1R38nudpMbR6+xpdTPg5Iik0QBKQfBvk5YBknpoaGVPvVLvFhK8V5jqBWbByesibJS6JMNaC//T1CG3oqUtixPn1RW33NIBtRbdmJ7RWq2BeeA35ZOsS+ELoUdus81J8R7aJIgb4LtRukbSiMpxq7AOsQ0katJ/CqweWk88djXq/FliAjNTxHGnfuxAMBQLZuQxIkm/jG9g04VwHyllAHO6hz3EllP8B7QvhxpaRsaMitocAWkUwQQ6IilODY5FDcCMbBFF+ujzq5N1PnZgJ7M+MFhsX9IZiuhxd8ikto062iwkglTjRPIN6LRlYsqK9tsF27VyLJxBx5oxC1BK/2dQX1Y1BKvAtojydMetPAgip01vRCbe4m8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(52116002)(6506007)(53546011)(6666004)(86362001)(2906002)(6512007)(26005)(6486002)(966005)(186003)(5660300002)(8936002)(2616005)(38100700002)(38350700002)(83380400001)(316002)(110136005)(66476007)(36756003)(6636002)(66556008)(4326008)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ky9ORVR0ck41bEVhTnFCak11SkZ1V0tQMitEamZRWHRqWk1mTlM1aDcyOFBi?=
 =?utf-8?B?ZnFaZmFiMTJBam5wQy9nOUtIL3FUSGI4R3JtWUc3V09GaUZYNDlTejZ4ZjRp?=
 =?utf-8?B?cjdNUFdUb0l1NUZwSzNESk1Ec3E5N0hEZHhQR1daeU52SVdDelBvbkYxbVR5?=
 =?utf-8?B?c0l2Zmd6cS9rUnFyOUw3VkgxS3FybUF1T3JwMWZUWmhWTy91U05SNHo5N2FS?=
 =?utf-8?B?UVlsVG83V3k5K21JWVk3UUlvZkl6UVM4MEtBazBzRTJDSGZmelFsUE0vendG?=
 =?utf-8?B?UHNSM2lFakxFcnd4RE4xaWxBMk8rc1RGNmVQNGdReG9vSnlQVFNiSUI3NERo?=
 =?utf-8?B?T2wrdTcycW9wNFkzMjB5aDBqaXZvcEVMbVdIa3ZmdDVTYU9iMnBMNmlVWVRi?=
 =?utf-8?B?MmtHSG5kVHhyLzFqVDczRGVFb1U3bitEc1NURysxWC9aakRneGQ5eUYrUlZX?=
 =?utf-8?B?UVFXKzRwUlBUOUZveGIwWVNJWnRQelVUNkVhQWhENW0zQ0FROWIrV1FMOGE3?=
 =?utf-8?B?eFk0NHZxbGxOODJxZjA4a1QxNllhTWpXNFpYQUpab1JtRWJxSFBUekJadEY0?=
 =?utf-8?B?U240YnBoMDN4Y2dnSThvUVg3YzBLblYzejFzZ0EyazVBY0U5dVFFNlhKeFlJ?=
 =?utf-8?B?TEJ6MnFKVlVRRjdleWZyQUFXak1oMlhOZEVzakdFTjVkbXBxaFgrYXJMeTJV?=
 =?utf-8?B?dUhTRUNaZWFHOWtkY25nRGc2R3J2MkVxRkdGV1oxTUVzamgzNWZIa29KZTVN?=
 =?utf-8?B?LzdValFqYzFFcHNlZVZWcHZ5UnhzbWxidzQ4ZDg3WFEwQVkrMWFYUlh4SlVO?=
 =?utf-8?B?RmRlMFZrNnA0NTVhdU1VWWg0aElCeW40Nk9PcnhKdkRIZjZSQ21zdDFwODAx?=
 =?utf-8?B?cWhEMGlRcUNoU2xwa01zV2JRdm81bVFoY29qNjZHc3ovZ3E0YWxwcS8wZTQv?=
 =?utf-8?B?TXQwQml2dGkyeTdIYm51ZGhIRlBjT3FLK0I5RkFsYittVWJvWW5kZ01wN2Q2?=
 =?utf-8?B?WmtHNXNlVmxvTHhKQzBtZEI1ZXdGaTRkWUp5VE9oczVZcXFIUm9CdHRrTFpr?=
 =?utf-8?B?NkVqcTR2L0F1NEd1ZlNmRDBLc2tOSm9GMlZraHBFUFhvMjdCMVMxZ2J1bFls?=
 =?utf-8?B?eTVWV3Y3TmtUSHh5c0NLWTcySExDM2xMdGwyaDJWVDgrTFRHU3A5Q3dFQ2p0?=
 =?utf-8?B?bXZpU2Q0VEh4T1ZwWUo0bHV5ZW5GS3RrZGlMM21CeUU0bkF5aWo0SEJPLzJE?=
 =?utf-8?B?YXQ2b1NKMGpFcmdBZ2dCMG0reTY4aGZLekIyVm85S3FXSEt0Umx3SC9XeXpT?=
 =?utf-8?B?MWE0OTZHRkErSGQrN3BqdHFwTllSNTRIVUZiNUtSZ1dWczR5eERseUJsUG9y?=
 =?utf-8?B?bGFxcndUS1ZwUlMxdU1nNU50UTVYM3I0ZmpTaG05TDNBZHlFTEc1ZHN4aDRy?=
 =?utf-8?B?SEd2bHNVbExhZWJaRlZ3RlBhamFuOVNudUE3eGdVdGhrZ3hKc0x5WHU4TUNk?=
 =?utf-8?B?QU5iSGdkZ0EvQk0rSXZoUnBkL1VSOUNveHdZTXJsZ2pMUzloNnRwVWF4MGZl?=
 =?utf-8?B?M1IrM2dGelV3a29ZVEp0OWV6NTBYbi9IcmplRGhEMVlvQklqRVR5dGxIYjI2?=
 =?utf-8?B?NU94bW1SMXIvS0x2MTA1VnZLaWFuUGlQbE9MYlNJbmFhcytoRWE3UmUzRzdu?=
 =?utf-8?B?VDh2ZHpFK0s1R0dPQ1ppSE1aWVFRV1NUS1Vjc3V0UFpQaDB1UnQ0WFV3byt3?=
 =?utf-8?B?TjZXVytZL096WnE5UlZBbEI4ajZkVGZ2WHJidUFVOSt3YlNoUFNuOGdKZlg5?=
 =?utf-8?B?WEpyMGJSVlJxWVFLUlkvSXJYd2IrTzNpblJxSmdxSEUwQldZVFZvaGFuWEJo?=
 =?utf-8?B?UFNhenhQRUN5cGFHNkZpZTJlSUR1MmVSQzU5d2tsWjJoNnNuNDVhd3lvQzl2?=
 =?utf-8?B?d2FZQ3NRWXNsT3RBalhlYkxOZitGRDBvTmVYUjR0SjdYOEFhL0xoeVFnUGtI?=
 =?utf-8?B?WG5zeG5lWmwyTE16TTlHY05DbTFsdWFZNDlrdWd6NmlmQlNWTEdsekRKTUgz?=
 =?utf-8?B?b2ZxVzk2ZGtBUnRSV0lSR21nWkl4eGlvVGRBT0Z0V3ZWeHJJZmJqMlVOMUk2?=
 =?utf-8?B?ZjMxaWppcm1EUkpDbHlHWlFRdndmRnp1TWdCZy9raG0weTlxZUU0UXdDRUdF?=
 =?utf-8?B?MHpsNlNhTURRcXcrVFdVYUJQRHMrOWRZZEVQQld3d2wwTDMwclQ2TlM3NmxN?=
 =?utf-8?B?SU0yYUQxdzFJK2plSUF3cEp0T1JOaHE4bWVCQVlrbHlMZGx3Njh5N1hiUXdI?=
 =?utf-8?B?RnN2M2ZyT1RDRDVaRjdTZ1l5U0JEY2lpZWhlYnZLM3M1OEYxRXhUSDU1aDA4?=
 =?utf-8?Q?GTRls6kfqXaSKTEo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce702fb9-d7bd-4642-6571-08da2a0489ed
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 17:20:21.0337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkLZtvYdGVWzz+9YDn7E8hUbciXZqnxOo7Os0GzaDY9rGPNqZs7YKy33RaU5v2+c00i8lTQofsSJ/qBZzuAwz/oCmdCs8o85Tw4Y0u592mo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2243
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_06:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290087
X-Proofpoint-ORIG-GUID: eGRWKxPVXneAnCXrJFKYUDRtD3r2-ud_
X-Proofpoint-GUID: eGRWKxPVXneAnCXrJFKYUDRtD3r2-ud_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-04-26 at 08:42 +1000, Dave Chinner wrote:
> On Mon, Apr 25, 2022 at 03:34:52PM +0000, Catherine Hoang wrote:
> > > On Apr 21, 2022, at 6:40 PM, Dave Chinner <david@fromorbit.com>
> > > wrote:
> > > 
> > > On Thu, Apr 21, 2022 at 09:58:15AM -0700, Catherine Hoang wrote:
> > > > Quotas are not enforced on the id==0 dquot, so the quota code
> > > > uses it
> > > > to store warning limits and timeouts.  Having just dropped
> > > > support for
> > > > warning limits, this field no longer has any meaning.  Return
> > > > -EINVAL
> > > > for this dquot id if the fieldmask has any of the QC_*_WARNS
> > > > set.
> > > > 
> > > > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > > ---
> > > > fs/xfs/xfs_qm_syscalls.c | 2 ++
> > > > 1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_qm_syscalls.c
> > > > b/fs/xfs/xfs_qm_syscalls.c
> > > > index e7f3ac60ebd9..bdbd5c83b08e 100644
> > > > --- a/fs/xfs/xfs_qm_syscalls.c
> > > > +++ b/fs/xfs/xfs_qm_syscalls.c
> > > > @@ -290,6 +290,8 @@ xfs_qm_scall_setqlim(
> > > > 		return -EINVAL;
> > > > 	if ((newlim->d_fieldmask & XFS_QC_MASK) == 0)
> > > > 		return 0;
> > > > +	if ((newlim->d_fieldmask & QC_WARNS_MASK) && id == 0)
> > > > +		return -EINVAL;
> > > 
> > > Why would we do this for only id == 0? This will still allow
> > > non-zero warning values to be written to dquots that have id !=
> > > 0,
> > > but I'm not sure why we'd allow this given that the previous
> > > patch just removed all the warning limit checking?
> > > 
> > > Which then makes me ask: why are we still reading the warning
> > > counts
> > > from on disk dquots and writing in-memory values back to dquots?
> > > Shouldn't xfs_dquot_to_disk() just write zeros to the warning
> > > fields
> > > now, and xfs_dquot_from_disk() elide reading the warning counts
> > > altogether? i.e. can we remove d_bwarns, d_iwarns and d_rtbwarns
> > > from the struct fs_disk_quota altogether now?
> > > 
> > > Which then raises the question of whether copy_from_xfs_dqblk()
> > > and
> > > friends should still support warn counts up in
> > > fs/quota/quota.c...?
> > 
> > The intent of this patchset is to only remove warning limits, not
> > warning
> > counts. The id == 0 dquot stores warning limits, so we no longer
> > want
> > warning values to be written here. Dquots with id != 0 store
> > warning
> > counts, so we still allow these values to be updated. 
> 
> Why? What uses the value? After this patchset the warning count is
> not used anywhere in the kernel. Absent in-kernel enforced limits,
> the warning count fundamentally useless as a userspace decision tool
> because of the warning count is not deterministic in any way.
> Nothing can be inferred about the absolute value of the count
> because it can't be related back to individual user operations.
> 
> i.e. A single write() can get different numbers of warnings issuedi
> simply because of file layout or inode config (e.g. DIO vs buffered,
> writes into sparse regions, unwritten regions, if extent size hints
> are enabled, etc) and so the absolute magnitude of the warning count
> doesn't carry any significant meaning.
> 
> I still haven't seen a use case for these quota warning counts,
> either with or without the limiting code. Who needs this, and why?

Hmm, I wonder if this is eluding to the idea of just removing the
function all together then?  And replacing it with a -EINVAL or maybe
-EOPNOTSUPP?  I only see a few calls to it in xfs_quotaops.c

Allison
> 
> > In regards to whether or not warning counts should be removed, it
> > seems
> > like they currently do serve a purpose. Although there's some
> > debate about
> > this in a previous thread:
> > https://lore.kernel.org/linux-xfs/20220303003808.GM117732@magnolia/
> 
> Once the warning count increment is removed, there are zero users of
> the warning counts.
> 
> Legacy functionality policy (as defined by ALLOCSP removal) kicks in
> here: remove anything questionable ASAP, before it bites us hard.
> And this has already bitten us real hard...
> 
> Cheers,
> 
> Dave.

