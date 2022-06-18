Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2286DC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jun 2022 00:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383694AbiFRAci (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 20:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383687AbiFRAch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 20:32:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C93B69
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 17:32:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HJdB0c032726;
        Sat, 18 Jun 2022 00:32:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=r8qrlFNx9PMIGyOliZ5DmNy17gndnn/5LGB1aadkoro=;
 b=il1sXvnONpAK1vKVneMpBO6kPx28jLr/5zY7geYwjFy8futlbA3LmWBrcwVqmrBIvaw/
 xCxHhSDYCxNyLo5Ysm6LOa1oV+ExPM2dGjS4PvH3kNWRvuDHJ7HvcMq+A2lLs3fn1rwQ
 YP9Rr4vOMh3nUR8db98sNKCg5c+dSa2JR++8pc/tIzDdN1zE6u2I3mvWwlD4NqJNP75E
 63J2xtgMqYJeimnlHdJ8EwPqzhfkNLGcD484WbWo0hqTohQPl21dxF2n9b1JAJ7YEPF/
 /8HDb3gcQUT821H7Egps2LnmWD53hj4aAiUEjxf2NdvAonOinEomkpFh69ijeNFHqFIc jw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2y3fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25I0QYNS004509;
        Sat, 18 Jun 2022 00:32:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gprbunym0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYEBkLDe1CMLrO9cnkdRJpv1rYsK8ij9eLcchgWihEv5pehy+kX4EY8kryWRT8JxL1dH8FG+1sh9mpMejhbi2yZOvtJZpSW/i8HTybUhrTBqMT7fU7RLnafyAShz8+R/NyCZWmKePxdXxwE/6SQfeP3GATbfy7XIY3UvKpZPjWWlbWWxdGDS62M5YLtocBFXaVwKwA0mvyYt/Am512uWNbmZihX5+eBm7T/beZgoH82GwUTQahY+T8yqUKZ4uIFJLYdXXNANIhjO/kyF40xnpNWmbOWgbkvd/r2ZNL3jbFs/++kUcbAp1Ypgox87t8PlKmg3ItSGTrt6CcNAC15W8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8qrlFNx9PMIGyOliZ5DmNy17gndnn/5LGB1aadkoro=;
 b=XDT5eLnvfTt00pjp2IiPyx1sYjPmab9XZhZKWzL71wjH2RsD8bQgXZ4fG3uSIxWAF+Hbmt+Un+FI6EtN/MPLnJ+HZw8Rh0DAMYmQc3liVYI3z7/b404eV6uEAw0kMXn3xd1DQO+Kg5XsZSmX/Q+nxsoJpYs2NyNABWfMzs9tHig2bb7osblOeVLmHyybP4nIxREBhSz/yUHOwNT5UqxbhhHSs4IgdjfthmbxUsvnSnVOaVEtyd9u2eyrpNg8hl0t2e9xJ3xQuqU6rl8j7c3Xb1ctROepvrDoj/IC0jWbKtOI99FQDtPVefPtkOnYoqBatbFS25wmao4dPzltlM+T0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8qrlFNx9PMIGyOliZ5DmNy17gndnn/5LGB1aadkoro=;
 b=fgiRfgnUPxWEJEi3eZOIr5A8KqBPS+tg37QJ9IiwOJQ/Df9YI0H51YL1Tu4VmnoKMH01JZuFT8CMuqSw+SqmqLLDEf//hn1iw/qPszpY3fA65jnUGsjg+X9AQlvXDOfK1b1WFtrdfE22kfLQQRjVLMTRP5EXVANAsC1O8g9Ya9g=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW5PR10MB5852.namprd10.prod.outlook.com (2603:10b6:303:19c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Sat, 18 Jun
 2022 00:32:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 00:32:30 +0000
Message-ID: <18699d8320e3705e93cef24f6d30cf60144baaf1.camel@oracle.com>
Subject: Re: [PATCH v1 10/17] xfs: parent pointer attribute creation
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Jun 2022 17:32:28 -0700
In-Reply-To: <20220616054956.GD227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-11-allison.henderson@oracle.com>
         <20220616054956.GD227878@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 281f90f5-c0df-43f3-dead-08da50c2070d
X-MS-TrafficTypeDiagnostic: MW5PR10MB5852:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB5852C4226B3D156938A2ABD395AE9@MW5PR10MB5852.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0UD7ybzz45zeoaxeWoRa1EE1MaxCTq7oEbk296iZlny3JaKNgXZ/thfWEyjWxIRslnWuh5bRlR+svcTgYg+TB/0avYvLQ/XTgsQI0m8OFds90TqOy7ynRDouJC3Pq5esXrXAQp/zlUIfLcr1yywDUlunR/lyZHscr9OypFd5NqX5kh6q8jPhQAn9DKvr+BBIewesJV+/OxMjxCzJQzxkya5Fv7gQBGJh4qmlINF5IvlccWFROXGcRm8L8xQB7eBreaA5I69Ez3zjacSBwhcaZoh9w3WI1d1nSh/jysQjsZq+77jS2ZIfCI2GjGtRDq91MkiV2TJCvcnb6i4IfYBls+pEe6VGWT9X64MIpr4ozYRuybm5pBboshkHvxISG4x1/y3GCxRjU2YxiwzscUsW0SvTvBNFHfGF1lOwZXbzYNYTBhXBTwgQvL9aWV6+fV9H7huVPz5orKpJ1Pw8J1T2g3X9bMxLZCeNPSrgHqcQoqrTBZUhFaPm0Tn+UQFbjuO6w3ma7TuMvxBU6xrx4kxv3gQopsfP3EWXSZ2O449Qk0cyZdPWrp1pmv8T9Yx8WN/uypv0RUwbzFEDLT5YNmX2dmJPB4wc/bsk8i/mnk/b4TOUCgu8iAOVBUFSavtTv6i3KKcDVy81uksE78plEKSZ1KpG6QDzv9dSJSS16Z6UI4Ab/Cl851MSuWccngl6kFWsqiTUIlQYcjWHWJ0mCAE5eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(5660300002)(8936002)(86362001)(6506007)(6486002)(6512007)(52116002)(26005)(2616005)(498600001)(186003)(2906002)(36756003)(66946007)(4326008)(66556008)(66476007)(8676002)(38350700002)(6916009)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3dHVmZKYkxOUEEybzVFbUQzTjlHQlh2VEQwUmdFSVJLMWRoNGNpdDU5VzFI?=
 =?utf-8?B?YnhlQUhxTURmeS84YVRadVgxbnc0NzdYN3N0VHorYjNKYkNSbS9DeGdoNnd5?=
 =?utf-8?B?SG1iYXpIMEIzZlRHVmJuYUFnNmU3QUtvc3lRcVQ2MjRQbmorOEhWWG1vM1dk?=
 =?utf-8?B?QjMyZ2trcjJZOFVBZFpsRDdULzRWd2N3ekEwbWFVMytVeTBhY1pqZ010a0FY?=
 =?utf-8?B?NDdkejFkRGFxcFRCWUJtWEJOa1NMTnRYbHpmWWVhbE1EdTdJaEhYK2EzQkp4?=
 =?utf-8?B?UVExVnBjOW5kc0k3YjI5K2hMNGNadHdTYnRmbmtKRjRiMllsUE05QXZzSE9k?=
 =?utf-8?B?TlFQcnhZdDFOSUxoREJZNkZDNElZdFlJYytacUZoVk4vSHp5OVV6MGhNTlFk?=
 =?utf-8?B?b2lySUlTTDRBR1RBaE05ZkZyVVpWZk5xVWlDc1djRkNuVkplWThhTHRVNHVN?=
 =?utf-8?B?cjlnUzJ0WThsancwSTBWYk1mQ215c3VQa0VoZW9XOHQ3RzJDUGwxTk1XbDJu?=
 =?utf-8?B?VS9JbVNwaUZjZmdKMEJxRi92SjlYRVEwdktHVTZsUkZEZG45Q1hscEtiQVNX?=
 =?utf-8?B?VmJ1aDFJZzk4d3VHVkNjbE94VUhReEpBOC9xNEFWc29VVk94YjZVaml6UEtT?=
 =?utf-8?B?YVgrNDZ3aU8ycnM3RlJOdHFTSHhHSjBXY2dRbFArcWpXTVRqZVNGTjlwSkQ1?=
 =?utf-8?B?N3ZDUDRFMlRDYmlRTW0ySHZYZEtEV0VJc1BOSXJjc2R6RGpKcDFqUEhrek14?=
 =?utf-8?B?UGF4L1F5RDZXU0JYV3hBc000UDBCMUVVYnpMZFQzYTh5WHVCcUo5MVlvRzUy?=
 =?utf-8?B?MFRPaTVJSWYrWmxTTmduUkJIQUh6dW1sTHRHY1FZajB2SXN6VllIRkRrNTR6?=
 =?utf-8?B?S3oyeThXM1BPQVlud0ZkdlNKdENRZ1hSKzFNY2FrcVUwNVpNeUo4b09vbUU3?=
 =?utf-8?B?YVdycDgyc3Iwcm9kU1FNV3czOWVicndUalc1c2JzMzZHYjc4OXp3SktaaU9L?=
 =?utf-8?B?RjBCRlRrc2lxQ3NKSklsalRnSEtyTWhwWDdtTW8xS1Q1N1cxV2NKUnVaNEE1?=
 =?utf-8?B?T1NmN2ZRV1hwV1hqblpYYlVXbnN6SVBBUXVuYitSMGlKS3V6L2tyTzQ3QmJD?=
 =?utf-8?B?VGdPM1NUd2VmbXFHQzdIWTFwUXd1NUJmaHk0UUgvL1hDM1k1NExIVm94eDMx?=
 =?utf-8?B?YVRObHduT00wTHQ1aWJNUzZ1WWczRWdCaFczZkxnWnoza2dkWXpZRHI4SW1S?=
 =?utf-8?B?STQ4bUNaaHF4VnlsdzR1VGRMSUhuOXJJaUVHZ1JFTFBpN2FBWUpyd3dZekMy?=
 =?utf-8?B?dlI3bDBkY0xQc3c2SE91QWRubW9MOVl6NFFQTVpzaFBza3dLT2FHeXdLYVU1?=
 =?utf-8?B?T1NhQ2xHdmRmcnpvZWN5MGh3cTJ1OE9GcGdTZkV3WnpQSmlIOUtWSVlHV2gw?=
 =?utf-8?B?OE5VVzg5TlRtdUFDZmxWM1Q1eDNUbm9qalFheU5UTy9OSmFrbzJ5Y1pMdUlN?=
 =?utf-8?B?WXJGdEFHVWpUYlRTd3pRRFVUaUdMKzIxa2ZmYzBnNWExMjlzakdqcU4reVAw?=
 =?utf-8?B?UWZkNFU5cVpnSHRzUVJZSUxoTWRKcE9GZm1GbmRqU09SSHRQQThNQkh2TUxO?=
 =?utf-8?B?RVhqQzhnZUFBQWZJUUJ6bk1UUUNheXVscGFqYzRpMWRCVkU1TmhwdGxWaWQ0?=
 =?utf-8?B?azRQV0JybEdsK1JsSlhjaG1LbnFGODlMa1RtZjVnejRUa21SV2FBUDlLb1d6?=
 =?utf-8?B?REUrdjkvL1oybWJJbjRZYUhUazA0SlR6WGxneVh3RXI4RmlMaEQxVFJ4SlFo?=
 =?utf-8?B?cmVsdmlwNEZTRjZoeVlCUXlzNHh2SEJreXU1aXFuUjJ6bGQ3NS9Xd1VKejNE?=
 =?utf-8?B?VHFDNjlmVnZjNnVsKy9rU2NOUExRWng0emlrd2RpRERHOWJ1dFNQOUVQbWlX?=
 =?utf-8?B?OC9wZXlBcGJxcXptM3MwNEF6SHowaDhtYnNRVVMweHl2SUhxVjl2SzZxTTVQ?=
 =?utf-8?B?bXZ0S2kxcWxwbWVDb2wrMVl2dDR3VWhRelRDZlFudnY3eU1sWHdETXhIM2dk?=
 =?utf-8?B?bUdOTVM1NDQwQ2o4SlZCSFAybmNHcG1Ic05RcTFYZlJjb3B4YzlTUjl2SHFj?=
 =?utf-8?B?UjZacTFwbUpnTVNrZi9KQXM3OERHUWkvMjFmeE41VkZBN3RlbGhQWCtSdUti?=
 =?utf-8?B?Z2wwT0JmSDk5WjBGTWtncVBkUjFGSlNaa3F1dmxkWUhkQ09JN1NKOEpxY0JN?=
 =?utf-8?B?T1B3cmUvZjQzOWZkeFRCc0lMVkZsRk1BdUdMaVhXbnIrcWl1V3BTWmY4a2tX?=
 =?utf-8?B?NVFicHdkTzFxYjI1NFhvTWgyYkswYTUvWHhkdFBpRTR0RENpRmllVEdLSUVy?=
 =?utf-8?Q?k9PtyUrlEXWrTfKk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 281f90f5-c0df-43f3-dead-08da50c2070d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 00:32:29.9979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JOd3x+IpNIynP+xvf73TEjq6ysDs/uqvyFBF0Q5AgNROOVPUkahiiS1bFHYSegsEoesW6+0z6H8Y4v+DHfKNxtgFumv738f8bGJqCIT/R9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5852
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_13:2022-06-17,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206180000
X-Proofpoint-GUID: rrS5dzPwmFWMm5L9LCDYjFkj_Fx4C65c
X-Proofpoint-ORIG-GUID: rrS5dzPwmFWMm5L9LCDYjFkj_Fx4C65c
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-06-16 at 15:49 +1000, Dave Chinner wrote:
> On Sat, Jun 11, 2022 at 02:41:53AM -0700, Allison Henderson wrote:
> > Add parent pointer attribute during xfs_create, and subroutines to
> > initialize attributes
> > 
> > [bfoster: rebase, use VFS inode generation]
> > [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> >            fixed some null pointer bugs,
> >            merged error handling patch,
> >            added subroutines to handle attribute initialization,
> >            remove unnecessary ENOSPC handling in
> > xfs_attr_set_first_parent]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/Makefile            |  1 +
> >  fs/xfs/libxfs/xfs_attr.c   |  2 +-
> >  fs/xfs/libxfs/xfs_attr.h   |  1 +
> >  fs/xfs/libxfs/xfs_parent.c | 77 +++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_parent.h | 31 ++++++++++++++
> >  fs/xfs/xfs_inode.c         | 88 +++++++++++++++++++++++++++-------
> > ----
> >  fs/xfs/xfs_xattr.c         |  2 +-
> >  fs/xfs/xfs_xattr.h         |  1 +
> >  8 files changed, 177 insertions(+), 26 deletions(-)
> ......
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index b2dfd84e1f62..6b1e4cb11b5c 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -36,6 +36,8 @@
> >  #include "xfs_reflink.h"
> >  #include "xfs_ag.h"
> >  #include "xfs_log_priv.h"
> > +#include "xfs_parent.h"
> > +#include "xfs_xattr.h"
> >  
> >  struct kmem_cache *xfs_inode_cache;
> >  
> > @@ -962,27 +964,40 @@ xfs_bumplink(
> >  
> >  int
> >  xfs_create(
> > -	struct user_namespace	*mnt_userns,
> > -	xfs_inode_t		*dp,
> > -	struct xfs_name		*name,
> > -	umode_t			mode,
> > -	dev_t			rdev,
> > -	bool			init_xattrs,
> > -	xfs_inode_t		**ipp)
> > -{
> > -	int			is_dir = S_ISDIR(mode);
> > -	struct xfs_mount	*mp = dp->i_mount;
> > -	struct xfs_inode	*ip = NULL;
> > -	struct xfs_trans	*tp = NULL;
> > -	int			error;
> > -	bool                    unlock_dp_on_error = false;
> > -	prid_t			prid;
> > -	struct xfs_dquot	*udqp = NULL;
> > -	struct xfs_dquot	*gdqp = NULL;
> > -	struct xfs_dquot	*pdqp = NULL;
> > -	struct xfs_trans_res	*tres;
> > -	uint			resblks;
> > -	xfs_ino_t		ino;
> > +	struct user_namespace		*mnt_userns,
> > +	xfs_inode_t			*dp,
> > +	struct xfs_name			*name,
> > +	umode_t				mode,
> > +	dev_t				rdev,
> > +	bool				init_xattrs,
> > +	xfs_inode_t			**ipp)
> > +{
> > +	int				is_dir = S_ISDIR(mode);
> > +	struct xfs_mount		*mp = dp->i_mount;
> > +	struct xfs_inode		*ip = NULL;
> > +	struct xfs_trans		*tp = NULL;
> > +	int				error;
> > +	bool				unlock_dp_on_error = false;
> > +	prid_t				prid;
> > +	struct xfs_dquot		*udqp = NULL;
> > +	struct xfs_dquot		*gdqp = NULL;
> > +	struct xfs_dquot		*pdqp = NULL;
> > +	struct xfs_trans_res		*tres;
> > +	uint				resblks;
> > +	xfs_ino_t			ino;
> > +	xfs_dir2_dataptr_t		diroffset;
> > +	struct xfs_parent_name_rec	rec;
> > +	struct xfs_da_args		args = {
> > +		.dp		= dp,
> > +		.geo		= mp->m_attr_geo,
> > +		.whichfork	= XFS_ATTR_FORK,
> > +		.attr_filter	= XFS_ATTR_PARENT,
> > +		.op_flags	= XFS_DA_OP_OKNOENT,
> > +		.name		= (const uint8_t *)&rec,
> > +		.namelen	= sizeof(rec),
> > +		.value		= (void *)name->name,
> 
> Why the cast to void?
.value is a void*, but name is a const char *, so we get a compiler
warning with out the cast

> 
> > +		.valuelen	= name->len,
> > +	};
> >  
> >  	trace_xfs_create(dp, name);
> >  
> > @@ -1009,6 +1024,12 @@ xfs_create(
> >  		tres = &M_RES(mp)->tr_create;
> >  	}
> >  
> > +	if (xfs_has_larp(mp)) {
> > +		error = xfs_attr_grab_log_assist(mp);
> > +		if (error)
> > +			goto out_release_dquots;
> > +	}
> 
> Parent pointers can only use logged attributes - so this check
> should actually be:
> 
> 	if (xfs_has_parent_pointers(mp)) {
> 		.....
> 	}
> 
> i.e. having the parent pointer feature bit present on disk turns on
> LARP mode unconditionally for that filesystem.
> 
> This means you are probably going to have to add a LARP mount
> feature bit and xfs_has_larp(mp) should be converted to it. i.e. the
> sysfs debug knob should go away once parent pointers are merged
> because LARP will be turned on by PP and we won't need a debug mode
> for testing LARP anymore...Ok, that makes sense 

Ok, as I recall initially larp was a mount option.  Then later in the
reviews we decided to make it a debug option.  I /think/ the reason was
that debug options are easier to deprecate than mount options?  Since
you dont have to deal with user space changes or breaking peoples mount
commands?  And the sysfs knob can be toggled without a remount.

Also, I seem to recall the reason pptrs was stuck as a mkfs option was
because it cant be toggled right?  Or we end up with some inodes that
have it, and some that don't.  So to be clear: we're proposing a mkfs
option that turns on a mount option.

I guess I'm struggling with why we have to loose the debug option?  It
doesnt seem inappropriate to me to have a mkfs option that alters a
debug option.  Other file systems that dont have pptrs on can still use
the larp knob.  And then the ones that do can just assume it on and
ignore the knob.  Maybe print a warning that clarifies that pptr
enabled file systems cannot disable larp.  Doesnt that retain all the
reasons we put the debug knob in?  With less surgery to larp, userspace
and the test cases?


> 
> > +
> >  	/*
> >  	 * Initially assume that the file does not exist and
> >  	 * reserve the resources for that case.  If that is not
> > @@ -1024,7 +1045,7 @@ xfs_create(
> >  				resblks, &tp);
> >  	}
> >  	if (error)
> > -		goto out_release_dquots;
> > +		goto drop_incompat;
> >  
> >  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> >  	unlock_dp_on_error = true;
> > @@ -1048,11 +1069,12 @@ xfs_create(
> >  	 * the transaction cancel unlocking dp so don't do it
> > explicitly in the
> >  	 * error path.
> >  	 */
> > -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, dp, 0);
> >  	unlock_dp_on_error = false;
> >  
> >  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> > -				   resblks - XFS_IALLOC_SPACE_RES(mp),
> > NULL);
> > +				   resblks - XFS_IALLOC_SPACE_RES(mp),
> > +				   &diroffset);
> >  	if (error) {
> >  		ASSERT(error != -ENOSPC);
> >  		goto out_trans_cancel;
> > @@ -1068,6 +1090,20 @@ xfs_create(
> >  		xfs_bumplink(tp, dp);
> >  	}
> >  
> > +	/*
> > +	 * If we have parent pointers, we need to add the attribute
> > containing
> > +	 * the parent information now.
> > +	 */
> > +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> > +		xfs_init_parent_name_rec(&rec, dp, diroffset);
> > +		args.dp	= ip;
> > +		args.trans = tp;
> > +		args.hashval = xfs_da_hashname(args.name,
> > args.namelen);
> > +		error =  xfs_attr_defer_add(&args);
> 
> White space.
will clean out

> 
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> >  	/*
> >  	 * If this is a synchronous mount, make sure that the
> >  	 * create transaction goes to disk before returning to
> > @@ -1093,6 +1129,7 @@ xfs_create(
> >  
> >  	*ipp = ip;
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> >  	return 0;
> >  
> >   out_trans_cancel:
> > @@ -1107,6 +1144,9 @@ xfs_create(
> >  		xfs_finish_inode_setup(ip);
> >  		xfs_irele(ip);
> >  	}
> > + drop_incompat:
> > +	if (xfs_has_larp(mp))
> > +		xlog_drop_incompat_feat(mp->m_log);
> 
> 	if (xfs_has_parent_pointers(mp))
Will update

> 
> >   out_release_dquots:
> >  	xfs_qm_dqrele(udqp);
> >  	xfs_qm_dqrele(gdqp);
> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index 35e13e125ec6..6012a6ba512c 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -27,7 +27,7 @@
> >   * they must release the permission by calling
> > xlog_drop_incompat_feat
> >   * when they're done.
> >   */
> > -static inline int
> > +inline int
> >  xfs_attr_grab_log_assist(
> >  	struct xfs_mount	*mp)
> >  {
> 
> Drop the inline, too.
> 
Alrighty, thx for the reviews!

Allison

> Cheers,
> 
> Dave.
> 

