Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF18AC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 21:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444632AbiEFV7l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 17:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444635AbiEFV7h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 17:59:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935CF140B5;
        Fri,  6 May 2022 14:55:49 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246K42L2013507;
        Fri, 6 May 2022 21:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rNR1SQWBiDQlBo79qNQL+2YmaYqfVZY7nsihgTJUJWU=;
 b=Pc5b/64RwVuSmuogG/WB2wshvPGqAXceJ7DbEfdV61xV21flz6XIJhEoGehtg5nxabXb
 Z3EweHn9Pdy0osQ1SKoJSqLM++/DhsQKSuXWRrGLVfzE+1bgapfP8YnJSMxNWQes0vjQ
 NpALRxQV8O1JbNqwOFme/9KC2S7dez4eu0Ec6X2g7o22vLepWNS7nBpfBKeZ6diKiwXq
 575RhdhxfayzvkEsCilg7pZRwK8lNGv+dB4MDSv+8jvonUBWRF+Nu3ZBxwDovkIeyLXz
 thvdSgldO1jGGJTIrLrNPK5UoVlen9ZJG2tHQFDaXgtQ9Y5e/KssjiaJphSyMK6sA20W zQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frvqsq7r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 21:55:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 246LUf9B040294;
        Fri, 6 May 2022 21:55:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fus90qc10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 21:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQMFlecpJAIsjf6ugRTA0+5Drtmt8LFr1nOMuyIxrhV9fYJynNOQ2HUTlKX8g7ByDaRCTn7MRdZ4YpvMFn4r2wpfpj9SJBjYpnHYhorn6vEeTj/7BI2Vz+lAYB0/pPjHowuUDiRVH++lg1rCyUAE1UpkRgm9dldxXB3P+HrnUszUqzDfJxrUaSUdHSnpVtgUv1MUI5HJfdzaSPCWSHfeSQj6VwkYglucQ6EwMe17gyHAohJ/MiG0u0+eb7nfrbuTbdEoW2nEqgqpKYPzlgXejzwAmfuHUIHoGF/wHKUP6CbAcXW3tevFRbm43QifFSSmBYKjaXk6Qz2QdE927C6hNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNR1SQWBiDQlBo79qNQL+2YmaYqfVZY7nsihgTJUJWU=;
 b=QGrNQYLXa2eV1C0t3cKMSxduJTS8iXavYp659nvagC8I+1YL9ComDwsPy3CcdiiKS7fdzRYdvk9gWCWaJoXwIjw3erZrLD6EfPtscTdgnnttgVI/GTQB2OLjawJhl+OdxMlP2lx38YFVtC4tiXmXOZgW9Gaq+KCddpLF2Z5P11I7CDpVhDT8EzFkB79Zb0bqNXmlUlipAOqgjr0gNZMXIa4AvRcQ/hqc5LmtREMBRCJ7aLTnnjYALRsp+weqNLXeOPfGOHV5oUGy+71doj5SRzhNj6PugWoHXhF3EWrO+DLvnykin1i86rOihvrDZZj4uZfGTmWHW+tzxCUQI7Sn1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNR1SQWBiDQlBo79qNQL+2YmaYqfVZY7nsihgTJUJWU=;
 b=f213vptO+AXg8u+dkGYhHk9YOFLl0Sl4NVuyIcKU5cJMYZ2GmjztM3xLJyi2LPAeuYarDGPlm0JYaf7elSahrjab8O2UwJ1WhmzOj7JcX1gmebR0HwfrqQR3jOKpMkuJIl51vwZTF1WIC9Pzd8xyGswjFw1aluB96KdsakTdxj4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR1001MB2099.namprd10.prod.outlook.com (2603:10b6:405:2c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 6 May
 2022 21:55:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 21:55:39 +0000
Message-ID: <98730a89f83f77d688029057db66834d8faa0f78.camel@oracle.com>
Subject: Re: [PATCH] xfs/larp: Make test failures debuggable
From:   Alli <allison.henderson@oracle.com>
To:     Zorro Lang <zlang@redhat.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Date:   Fri, 06 May 2022 14:55:34 -0700
In-Reply-To: <20220506200212.tw6lg5h6q2d2t6lr@zlang-mailbox>
References: <20220223033751.97913-1-catherine.hoang@oracle.com>
         <20220223033751.97913-2-catherine.hoang@oracle.com>
         <20220506075141.GH1949718@dread.disaster.area>
         <20220506161442.GP27195@magnolia>
         <20220506164051.pjccaapyytnt4iic@zlang-mailbox>
         <736E0977-3DF2-4100-AD8D-3EC6B67E44A1@oracle.com>
         <20220506200212.tw6lg5h6q2d2t6lr@zlang-mailbox>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfa48895-0d6e-4708-24c6-08da2fab2854
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2099:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB2099BD3E71933362BCFC7E5295C59@BN6PR1001MB2099.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S1dgVzbj2ioqJ+X57w6y+nXNz3pPNQJXB7q19sG/NKF5Aw0r1WpxoMMTcSVqipWWOTx6woqIhReWetSSxTTlZgVOWNCrPwdHFawIwzSAOrAt5euyc8bZ2kU4x1paeOJt3AglGQeJ5/f9oWBTAfC6sbOn/58PJZrkYMTx/vj6/jzbngqfTLJL55dP8XKEd6Dft35GNLfszbjc1Rvf3G2JzNnhxftHJfoGHGXoAXDvAKwIr8Nlql+ZZJHShsY7bDxwtIFtaz2ejTDecl2Dao7eQX51Ss+OZaTgvcvAbvIiOrNGscjkNxQatahW0RkhJuvKRjnUWCh0m0tB2XsQdleOT9BPyJ3yV4VzL/RasU8RAAJpEzoulkIiOUPC5JWQPoDOI9tRipeHaCrjRWKNLw9yZCbjmWnH4BhLjddpDtI3dq3jN+QhENCRUSmUxGTmT8aY9gtYXH557uNt8+ntDqdZCmr3DkHgdKi45v0tHUJd9XrJWb51l8g0OLpMplab1ixjtIeWBMuZYEA0cBTGkc5RDSuXGPaQmRak21xv/dugNs+1K6Y5FK36wUScITmT5JUsEpE4HiTFmr9odxCFv+UIdhOQ638D+lECQreFIWgIm/ZFgiQ5OK+BW+y2Vsj162X/b+jdYEq2fQ7xrOUFNkvJqPA5UaT3dWMXa13U9Evh28jad2kfmSvJh9N4LQ1qQyQ5vROxb/pxINbxhqR4UuV9UczU4cr2Jimfjd5+Heqrk6o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66556008)(2906002)(66476007)(5660300002)(36756003)(186003)(316002)(30864003)(4326008)(6636002)(83380400001)(54906003)(110136005)(8936002)(2616005)(52116002)(8676002)(86362001)(6486002)(508600001)(38350700002)(38100700002)(6666004)(53546011)(26005)(6512007)(6506007)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnQ4c1pKc3U2MjVZSGtRSVNxbW82c1BGUHZuUFlHN05zMFVMQlA4VTZoSisx?=
 =?utf-8?B?L3hsbVNsUU9NUXFpbGM4Wm1hdk9RWVF6MlNiaDlQNlFXMVdyZzVCSTVDK0dG?=
 =?utf-8?B?UUxsaHBjRG9RVWlJa0xRWmJlakxuWFYrM3kxd0R0bHpMVzJTKzRKc2twZXF4?=
 =?utf-8?B?ZCtnVjBIRWw5akVQeXgxSlZLTFdMQTh5Vi94UmM0RHRpVnBrVS9TZmoxTlFN?=
 =?utf-8?B?dUZFa25GTUYrcFNjS2tnQmdzbm5WMjZVNjBpYXc0eVVTMHdkeFk2NFFmbHF5?=
 =?utf-8?B?RHovRG5vT09XMzEwTXJjUjVucndpeU5ZbERBYkgySkxxeXZpcUhSZ1dOVGJ6?=
 =?utf-8?B?alp3d1ZwMlFmZWhvRENTRE5aNElqMlRwY3gxcE9OUmFOOGJuWmpBK29LdER3?=
 =?utf-8?B?aG9Fdks0NldpVUJZdnh1TVRzZXdtaXd4bGQzZVlwMGFXdGxWS2VwK1dmSTdM?=
 =?utf-8?B?VVVhWjVRVjUySXRUczRqMXpHamRORFF6Q3BCZ2tsTXVPejZocmpzckRvWlQz?=
 =?utf-8?B?Y204bFdJZjdHZkNKZUhrSmZJenlIbGh3QUVhdzNNUTlMRjBhSmxSMmM2ZUFM?=
 =?utf-8?B?OU9PWk9NQTU0RkU1SEQ3R254aytkTWF4OHg0cmhvdXFrTWp5VTZJVjBBQ05O?=
 =?utf-8?B?YWlYMXdheTlZVi8rWHVNNEtHTThaMWdheW1FbXZxYWVxT280c3JucWk5TnBx?=
 =?utf-8?B?Q2JTcnlYbENPWjhrempPSHAxZWtVOXhFaDJJcWN3QThOMFBaZXBRYlFQbU8v?=
 =?utf-8?B?V0x6U3dGT1EvTnY0bldaUjNKZlZFeVAyVnQ4YTR0RzhjQ2FRdlUzSVM4cTFT?=
 =?utf-8?B?eThid3JONFgvZisza0QrbU5jMXQrRVRwaGJ3d3E2TG1iOVpIMzltRUJZUXpX?=
 =?utf-8?B?UDdDQ0tqOG9sTGlHS0FidmJpWGpiTXZRRGZyRDBEVlgzRTJKUWZEVGF3R1RK?=
 =?utf-8?B?bmovT2RFL2hlUGUwVmh6UWE2MW5ZS2p6NXhwckF3cWxVV2Q0UkdYTlFnTncz?=
 =?utf-8?B?L1EvZ3dSSDVCSFc2a2gyUUxDa3N0RzFIR08rNU8xTDBjL2ZyM29tdXJ6MkZj?=
 =?utf-8?B?dE92RE8rdE1kak9CbDl3U2JkdThGTlFlMkt3TnB4UGhDTU1NNDEycWwyVk8y?=
 =?utf-8?B?ZitLZVlBaXE2UGtHU3Y1cjVicE5kVUxhQWVFU1RvSW1zckNlbE9LbmZ0Sm9S?=
 =?utf-8?B?UXY5K3EyUTBSQnk2d0ZrcmdVMjlTY0xCaUhqNzdFaFU0YVp1cnZJMlFqVzR3?=
 =?utf-8?B?NlZpaEF4ZzJVZTBURlBqK3Z2Y2JaUjN0b3pFLzJsQWJ6K1IydDlrcytnMkVn?=
 =?utf-8?B?dmtQRVByRmFNWERSS09YZU5seVFLSXBiQUJMUmh2SWRUbUpaYnZNS0JGMndw?=
 =?utf-8?B?ZkJpaVkyeStNRDJtVU9uRzlrSnVtK05JN2JWTXB3SFcyWVdBYWxQeFJpelcr?=
 =?utf-8?B?d251SXFxcHZ4ZTd0VEpWemJFUVpBbEJVT3VyWlpXSVhPY2ZtSDFJMHBwMXRh?=
 =?utf-8?B?QVAxSWxBY3ExbW9NTkYrWEd0SVc4TExCeXh6OVkzRVIvQnRjTzVFWW5vMDVH?=
 =?utf-8?B?aGlENXNUZDJyU3NaLzRBZ1V6MFA0VW5WRVd6SUtZdzFmSXJrcmswVzZLbnRy?=
 =?utf-8?B?eUhaT3pIaUFFU2RLdGNjc2ZpY3pKN1RXMitTRTd0Z0Q3Rm9xQjN6RUN4dHFo?=
 =?utf-8?B?NHEzZXRzSUg4RllLRURmTkphRVZPS3dybFhEQmROajZUcDhFQUZ6U3E3NEI3?=
 =?utf-8?B?eDU2K05yT1JTa2czU3hRYmpuMHdkaWNXMkJOODlzbnRIcElqekcvbzhFQ2ZG?=
 =?utf-8?B?anNOWVljWkNWSHl0d2tkbVZ5WUJuUElPdmNkSzRtTUxYSmZGV0xQR2FiRTlM?=
 =?utf-8?B?cHFueGlhNVVvTlBxOVhiMkZ0S1NJaytNb2gwMVpuUzZxbFJRZDRNdEw5UU5q?=
 =?utf-8?B?VnpLMXVVNmF6cEhxYkd1UWJkV0ozZnROTnpGZXNOcVovV0R5aGp4dS94NkV4?=
 =?utf-8?B?WEFuL01td1lVOFZWZjNCbHMwMVZkK0d2MTBQUHJZdHBzeEV0YUg2RWZtNzlM?=
 =?utf-8?B?d2x3S3VnN1FhZkY3ZTcwTDJBMHBNbmQ2QW1GcFdubW9KeWNnRm1yVGRiaVo0?=
 =?utf-8?B?b1NlSnFBcWZyZzM1T1ZwYVdoRjlFUlVoMWI0S21MY3k2aTluV0k3VzcrVytN?=
 =?utf-8?B?bWtKQm1pRjU1YU1jRHVOZXhJenloYm1iWEF3clhUdHFDR0k1WXZkaElHYnBF?=
 =?utf-8?B?SDk4SzdST1BCbEVVcG05a2NIclNVaWJEU0piQzFBZkRNMEhoTU1jckd6MDRN?=
 =?utf-8?B?ZEdBSGp1RjA0VUpmS0tBSEg5c2ptSDNVSlIvQUI5TzcvTGM4dzBXZlpWU01V?=
 =?utf-8?Q?uWdTO99krPFiMNWs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa48895-0d6e-4708-24c6-08da2fab2854
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 21:55:39.1049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HCghMZH/ue6ylN1o36nVFkyUGRmzUqROY7ydlf4XmLtZ0JlyioK238xACVCLGiSn/+spj4QIdHsd0KGM6sUnkcVuO4XQQzO5KxFMZmA0Us0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2099
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_07:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060110
X-Proofpoint-GUID: cUkGrM9uZCdfCfqRMr3P0KNdD6ofEpZj
X-Proofpoint-ORIG-GUID: cUkGrM9uZCdfCfqRMr3P0KNdD6ofEpZj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, 2022-05-07 at 04:02 +0800, Zorro Lang wrote:
> On Fri, May 06, 2022 at 06:08:08PM +0000, Catherine Hoang wrote:
> > > On May 6, 2022, at 9:40 AM, Zorro Lang <zlang@redhat.com> wrote:
> > > 
> > > On Fri, May 06, 2022 at 09:14:42AM -0700, Darrick J. Wong wrote:
> > > > On Fri, May 06, 2022 at 05:51:41PM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > Md5sum output for attributes created combined program output
> > > > > and
> > > > > attribute values. This adds variable path names to the
> > > > > md5sum, so
> > > > > there's no way to tell if the md5sum is actually correct for
> > > > > the
> > > > > given attribute value that is returned as it's not constant
> > > > > from
> > > > > test to test. Hence we can't actually say that the output is
> > > > > correct
> > > > > because we can't reproduce exactly what we are hashing
> > > > > easily.
> > > > > 
> > > > > Indeed, the last attr test in series (node w/ replace) had an
> > > > > invalid md5sum. The attr value being produced after recovery
> > > > > was
> > > > > correct, but the md5sum output match was failing. Golden
> > > > > output
> > > > > appears to be wrong.
> > > > > 
> > > > > Fix this issue by seperately dumping all the attributes on
> > > > > the inode
> > > > > via a list operation to indicate their size, then dump the
> > > > > value of
> > > > > the test attribute directly to md5sum. This means the md5sum
> > > > > for
> > > > > the attributes using the same fixed values are all identical,
> > > > > so
> > > > > it's easy to tell if the md5sum for a given test is correct.
> > > > > We also
> > > > > check that all attributes that should be present after
> > > > > recovery are
> > > > > still there (e.g. checks recovery didn't trash innocent
> > > > > bystanders).
> > > > > 
> > > > > Further, the attribute replace tests replace an attribute
> > > > > with an
> > > > > identical value, hence there is no way to tell if recovery
> > > > > has
> > > > > resulted in the original being left behind or the new
> > > > > attribute
> > > > > being fully recovered because both have the same name and
> > > > > value.
> > > > > When replacing the attribute value, use a different sized
> > > > > value so
> > > > > it is trivial to determine that we've recovered the new
> > > > > attribute
> > > > > value correctly.
> > > > > 
> > > > > Also, the test runs on the scratch device - there is no need
> > > > > to
> > > > > remove the testdir in _cleanup. Doing so prevents post-mortem
> > > > > failure analysis because it burns the dead, broken corpse to
> > > > > ash and
> > > > > leaves no way of to determine cause of death.
> > > > > 
> > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > ---
> > > > > 
> > > > > Hi Catherine,
> > > > > 
> > > > > These are all the mods I needed to make to be able to
> > > > > understand the
> > > > > test failures I was getting as I debugged the new LARP
> > > > > recovery
> > > > > algorithm I've written.  You'll need to massage the test
> > > > > number in
> > > > > this patch to apply it on top of your patch.
> > > > > 
> > > > > I haven't added any new test cases yet, nor have I done
> > > > > anything to
> > > > > manage the larp sysfs knob, but we'll need to do those in the
> > > > > near
> > > > > future.
> > > > > 
> > > > > Zorro, can you consider merging this test in the near
> > > > > future?  We're
> > > > > right at the point of merging the upstream kernel code and so
> > > > > really
> > > > > need to start growing the test coverage of this feature, and
> > > > > this
> > > > > test should simply not-run on kernels that don't have the
> > > > > feature
> > > > > enabled....
> > > > > 
> > > > > Cheers,
> > > > > 
> > > > > Dave.
> > > > > ---
> > > > > 
> > > > > tests/xfs/600     |  20 +++++-----
> > > > > tests/xfs/600.out | 109 ++++++++++++++++++++++++++++++++++++-
> > > > > -----------------
> > > > > 2 files changed, 85 insertions(+), 44 deletions(-)
> > > > > 
> > > > > diff --git a/tests/xfs/600 b/tests/xfs/600
> > > > > index 252cdf27..84704646 100755
> > > > > --- a/tests/xfs/600
> > > > > +++ b/tests/xfs/600
> > > > > @@ -16,7 +16,7 @@ _begin_fstest auto quick attr
> > > > > 
> > > > > _cleanup()
> > > > > {
> > > > > -	rm -rf $tmp.* $testdir
> > > > > +	rm -rf $tmp.*
> > > > > 	test -w /sys/fs/xfs/debug/larp && \
> > > > > 		echo 0 > /sys/fs/xfs/debug/larp
> > > > 
> > > > Blergh, this ^^^^^^^^^ is going to need fixing too.
> > > > 
> > > > Please save the old value, then write it back in the _cleanup
> > > > function.
> > > 
> > > Ok, I'm going to do that when I merge it, if Catherine wouldn't
> > > like to do
> > > more changes in a V8 patch. If this case still need more changes,
> > > please tell
> > > me in time, and then it might have to wait the fstests release
> > > after next, if
> > > too late.
> > > 
> > > Thanks,
> > > Zorro
> > 
> > Based on Dave’s feedback, it looks like the patch will need a few
> > more
> > changes before it’s ready.
> 
> Great, that would be really helpful if you'd like to rebase this
> patch to fstests
> for-next branch. And how about combine Dave's patch with your patch?
> I don't think
> it's worth merging two seperated patches for one signle new case.
> What does Dave think?
> 
> I just merged below two patchset[1] into xfs-5.18-fixes-1, then tried
> to test this case
> (with you and Dave's patch). But it always failed as [2]. Please make
> sure it works
> as expected with those kernel patches still reviewing, I can't be
> sure I have the
> testing environment to guarantee that. Or I'd like to push this case
> after I see
> its target kernel patchset be merged by xfs-linux at first.
> 
> Thanks,
> Zorro
> 
> [1]
> [PATCH v29 00/15] xfs: Log Attribute Replay
> [PATCH 00/10 v2] xfs: LARP - clean up xfs_attr_set_iter state machine
> 
> 
> [2] out.bad output:
> *** mkfs
> *** mount FS
> attr_set: Input/output error
> Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output
> error
> xfs_logprint: unknown log operation type (1246)
> Bad data in log
> mount: /mnt/scratch: mount(2) system call failed: Structure needs
> cleaning.
I think that happens when you dont have the corresponding xfsprogs
updates.  The userspace log print does not recognize the new log item.

Assuming you are running with an unpatched xfsprogs, I would have
thought the lack of error injects might have stopped the test from
running though?

Allison

> > Catherine
> > > > <slightly ot rant>
> > > > 
> > > > These sysfs knobs are a pain because they all reset to defaults
> > > > if
> > > > xfs.ko gets cycled.  I know, I know, at least Dave and Ted
> > > > don't do
> > > > modular kernels and so never see this happen, but I do.  I bet
> > > > Dave also
> > > > hasn't ever run xfs/434 or xfs/436, which might be why I'm the
> > > > only one
> > > > seeing dquot leaks with 5.19-next.
> > > > 
> > > > (I might be able to lift the xfs-as-module requirement if "echo
> > > > 1 >
> > > > /sys/kernel/slab/*/validate" does what I think it might, since
> > > > all we
> > > > want to do is look for slab leaks, and those tests
> > > > rmmod/modprobe as a
> > > > brute force way of making the slab debug code check for leaks.)
> > > > 
> > > > In case anyone's wondering, a solution to the knobs getting
> > > > unset after
> > > > an rmmod/modprobe cycle is to add a file
> > > > /etc/udev/rules.d/99-fstester.rules containing:
> > > > 
> > > > ACTION=="add|change", SUBSYSTEM=="module",
> > > > DEVPATH=="/module/${module}", RUN+="/bin/sh -c \"echo ${value}
> > > > > ${knob}\""
> > > > 
> > > > which should be enough to keep LARP turned on.
> > > > 
> > > > <end rant>
> > > > 
> > > > Anyway, since this is a proposed test, I say that with this
> > > > applied and
> > > > the debug knob bits fixed, the whole thing is
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > --D
> > > > 
> > > > > }
> > > > > @@ -46,7 +46,9 @@ test_attr_replay()
> > > > > 	touch $testfile
> > > > > 
> > > > > 	# Verify attr recovery
> > > > > -	{ $ATTR_PROG -g $attr_name $testfile | md5sum; } 2>&1 |
> > > > > _filter_scratch
> > > > > +	$ATTR_PROG -l $testfile | _filter_scratch
> > > > > +	echo -n "$attr_name: "
> > > > > +	$ATTR_PROG -q -g $attr_name $testfile | md5sum;
> > > > > 
> > > > > 	echo ""
> > > > > }
> > > > > @@ -157,19 +159,19 @@ create_test_file remote_file2 1
> > > > > $attr64k
> > > > > test_attr_replay remote_file2 "attr_name2" $attr64k "s"
> > > > > "larp"
> > > > > test_attr_replay remote_file2 "attr_name2" $attr64k "r"
> > > > > "larp"
> > > > > 
> > > > > -# replace shortform
> > > > > +# replace shortform with different value
> > > > > create_test_file sf_file 2 $attr64
> > > > > -test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
> > > > > +test_attr_replay sf_file "attr_name2" $attr16 "s" "larp"
> > > > > 
> > > > > -# replace leaf
> > > > > -create_test_file leaf_file 2 $attr1k
> > > > > -test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
> > > > > +# replace leaf with different value
> > > > > +create_test_file leaf_file 3 $attr1k
> > > > > +test_attr_replay leaf_file "attr_name2" $attr256 "s" "larp"
> > > > > 
> > > > > -# replace node
> > > > > +# replace node with a different value
> > > > > create_test_file node_file 1 $attr64k
> > > > > $ATTR_PROG -s "attr_name2" -V $attr1k $testdir/node_file \
> > > > > 		>> $seqres.full
> > > > > -test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
> > > > > +test_attr_replay node_file "attr_name2" $attr256 "s" "larp"
> > > > > 
> > > > > echo "*** done"
> > > > > status=0
> > > > > diff --git a/tests/xfs/600.out b/tests/xfs/600.out
> > > > > index 96b1d7d9..fe25ea3e 100644
> > > > > --- a/tests/xfs/600.out
> > > > > +++ b/tests/xfs/600.out
> > > > > @@ -4,146 +4,185 @@ QA output created by 600
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1':
> > > > > Input/output error
> > > > > -21d850f99c43cc13abbe34838a8a3c8a  -
> > > > > +Attribute "attr_name" has a 65 byte value for
> > > > > SCRATCH_MNT/testdir/empty_file1
> > > > > +attr_name: cfbe2a33be4601d2b655d099a18378fc  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name" for
> > > > > SCRATCH_MNT/testdir/empty_file1
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name" for
> > > > > SCRATCH_MNT/testdir/empty_file1
> > > > > +attr_name: attr_get: No data available
> > > > > +Could not get "attr_name" for
> > > > > /mnt/scratch/testdir/empty_file1
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2':
> > > > > Input/output error
> > > > > -2ff89c2935debc431745ec791be5421a  -
> > > > > +Attribute "attr_name" has a 1025 byte value for
> > > > > SCRATCH_MNT/testdir/empty_file2
> > > > > +attr_name: 9fd415c49d67afc4b78fad4055a3a376  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name" for
> > > > > SCRATCH_MNT/testdir/empty_file2
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name" for
> > > > > SCRATCH_MNT/testdir/empty_file2
> > > > > +attr_name: attr_get: No data available
> > > > > +Could not get "attr_name" for
> > > > > /mnt/scratch/testdir/empty_file2
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3':
> > > > > Input/output error
> > > > > -5d24b314242c52176c98ac4bd685da8b  -
> > > > > +Attribute "attr_name" has a 65536 byte value for
> > > > > SCRATCH_MNT/testdir/empty_file3
> > > > > +attr_name: 7f6fd1b6d872108bd44bd143cbcdfa19  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name" for
> > > > > SCRATCH_MNT/testdir/empty_file3
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name" for
> > > > > SCRATCH_MNT/testdir/empty_file3
> > > > > +attr_name: attr_get: No data available
> > > > > +Could not get "attr_name" for
> > > > > /mnt/scratch/testdir/empty_file3
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for
> > > > > SCRATCH_MNT/testdir/inline_file1
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1':
> > > > > Input/output error
> > > > > -5a7b559a70d8e92b4f3c6f7158eead08  -
> > > > > +Attribute "attr_name1" has a 16 byte value for
> > > > > SCRATCH_MNT/testdir/inline_file1
> > > > > +Attribute "attr_name2" has a 65 byte value for
> > > > > SCRATCH_MNT/testdir/inline_file1
> > > > > +attr_name2: cfbe2a33be4601d2b655d099a18378fc  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name2" for
> > > > > SCRATCH_MNT/testdir/inline_file1
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name2" for
> > > > > SCRATCH_MNT/testdir/inline_file1
> > > > > +Attribute "attr_name1" has a 16 byte value for
> > > > > SCRATCH_MNT/testdir/inline_file1
> > > > > +attr_name2: attr_get: No data available
> > > > > +Could not get "attr_name2" for
> > > > > /mnt/scratch/testdir/inline_file1
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for
> > > > > SCRATCH_MNT/testdir/inline_file2
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2':
> > > > > Input/output error
> > > > > -5717d5e66c70be6bdb00ecbaca0b7749  -
> > > > > +Attribute "attr_name2" has a 1025 byte value for
> > > > > SCRATCH_MNT/testdir/inline_file2
> > > > > +Attribute "attr_name1" has a 16 byte value for
> > > > > SCRATCH_MNT/testdir/inline_file2
> > > > > +attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name2" for
> > > > > SCRATCH_MNT/testdir/inline_file2
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name2" for
> > > > > SCRATCH_MNT/testdir/inline_file2
> > > > > +Attribute "attr_name1" has a 16 byte value for
> > > > > SCRATCH_MNT/testdir/inline_file2
> > > > > +attr_name2: attr_get: No data available
> > > > > +Could not get "attr_name2" for
> > > > > /mnt/scratch/testdir/inline_file2
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for
> > > > > SCRATCH_MNT/testdir/inline_file3
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3':
> > > > > Input/output error
> > > > > -5c929964efd1b243aa8cceb6524f4810  -
> > > > > +Attribute "attr_name2" has a 65536 byte value for
> > > > > SCRATCH_MNT/testdir/inline_file3
> > > > > +Attribute "attr_name1" has a 16 byte value for
> > > > > SCRATCH_MNT/testdir/inline_file3
> > > > > +attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name2" for
> > > > > SCRATCH_MNT/testdir/inline_file3
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name2" for
> > > > > SCRATCH_MNT/testdir/inline_file3
> > > > > +Attribute "attr_name1" has a 16 byte value for
> > > > > SCRATCH_MNT/testdir/inline_file3
> > > > > +attr_name2: attr_get: No data available
> > > > > +Could not get "attr_name2" for
> > > > > /mnt/scratch/testdir/inline_file3
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for
> > > > > SCRATCH_MNT/testdir/extent_file1
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1':
> > > > > Input/output error
> > > > > -51ccb5cdfc9082060f0f94a8a108fea0  -
> > > > > +Attribute "attr_name2" has a 1025 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file1
> > > > > +Attribute "attr_name1" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file1
> > > > > +attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name2" for
> > > > > SCRATCH_MNT/testdir/extent_file1
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name2" for
> > > > > SCRATCH_MNT/testdir/extent_file1
> > > > > +Attribute "attr_name1" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file1
> > > > > +attr_name2: attr_get: No data available
> > > > > +Could not get "attr_name2" for
> > > > > /mnt/scratch/testdir/extent_file1
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name4" for
> > > > > SCRATCH_MNT/testdir/extent_file2
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2':
> > > > > Input/output error
> > > > > -8d530bbe852d8bca83b131d5b3e497f5  -
> > > > > +Attribute "attr_name4" has a 1025 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file2
> > > > > +Attribute "attr_name2" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file2
> > > > > +Attribute "attr_name3" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file2
> > > > > +Attribute "attr_name1" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file2
> > > > > +attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name4" for
> > > > > SCRATCH_MNT/testdir/extent_file3
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3':
> > > > > Input/output error
> > > > > -5d77c4d3831a35bcbbd6e7677119ce9a  -
> > > > > +Attribute "attr_name4" has a 1025 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file3
> > > > > +Attribute "attr_name2" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file3
> > > > > +Attribute "attr_name3" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file3
> > > > > +Attribute "attr_name1" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file3
> > > > > +attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for
> > > > > SCRATCH_MNT/testdir/extent_file4
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4':
> > > > > Input/output error
> > > > > -6707ec2431e4dbea20e17da0816520bb  -
> > > > > +Attribute "attr_name2" has a 65536 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file4
> > > > > +Attribute "attr_name1" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file4
> > > > > +attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name2" for
> > > > > SCRATCH_MNT/testdir/extent_file4
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name2" for
> > > > > SCRATCH_MNT/testdir/extent_file4
> > > > > +Attribute "attr_name1" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/extent_file4
> > > > > +attr_name2: attr_get: No data available
> > > > > +Could not get "attr_name2" for
> > > > > /mnt/scratch/testdir/extent_file4
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for
> > > > > SCRATCH_MNT/testdir/remote_file1
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1':
> > > > > Input/output error
> > > > > -767ebca3e4a6d24170857364f2bf2a3c  -
> > > > > +Attribute "attr_name2" has a 1025 byte value for
> > > > > SCRATCH_MNT/testdir/remote_file1
> > > > > +Attribute "attr_name1" has a 65536 byte value for
> > > > > SCRATCH_MNT/testdir/remote_file1
> > > > > +attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name2" for
> > > > > SCRATCH_MNT/testdir/remote_file1
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name2" for
> > > > > SCRATCH_MNT/testdir/remote_file1
> > > > > +Attribute "attr_name1" has a 65536 byte value for
> > > > > SCRATCH_MNT/testdir/remote_file1
> > > > > +attr_name2: attr_get: No data available
> > > > > +Could not get "attr_name2" for
> > > > > /mnt/scratch/testdir/remote_file1
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for
> > > > > SCRATCH_MNT/testdir/remote_file2
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2':
> > > > > Input/output error
> > > > > -fd84ddec89237e6d34a1703639efaebf  -
> > > > > +Attribute "attr_name2" has a 65536 byte value for
> > > > > SCRATCH_MNT/testdir/remote_file2
> > > > > +Attribute "attr_name1" has a 65536 byte value for
> > > > > SCRATCH_MNT/testdir/remote_file2
> > > > > +attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
> > > > > 
> > > > > attr_remove: Input/output error
> > > > > Could not remove "attr_name2" for
> > > > > SCRATCH_MNT/testdir/remote_file2
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2':
> > > > > Input/output error
> > > > > -attr_get: No data available
> > > > > -Could not get "attr_name2" for
> > > > > SCRATCH_MNT/testdir/remote_file2
> > > > > +Attribute "attr_name1" has a 65536 byte value for
> > > > > SCRATCH_MNT/testdir/remote_file2
> > > > > +attr_name2: attr_get: No data available
> > > > > +Could not get "attr_name2" for
> > > > > /mnt/scratch/testdir/remote_file2
> > > > > d41d8cd98f00b204e9800998ecf8427e  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/sf_file':
> > > > > Input/output error
> > > > > -34aaa49662bafb46c76e377454685071  -
> > > > > +Attribute "attr_name1" has a 64 byte value for
> > > > > SCRATCH_MNT/testdir/sf_file
> > > > > +Attribute "attr_name2" has a 17 byte value for
> > > > > SCRATCH_MNT/testdir/sf_file
> > > > > +attr_name2: 9a6eb1bc9da3c66a9b495dfe2fe8a756  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file':
> > > > > Input/output error
> > > > > -664e95ec28830ffb367c0950026e0d21  -
> > > > > +Attribute "attr_name2" has a 257 byte value for
> > > > > SCRATCH_MNT/testdir/leaf_file
> > > > > +Attribute "attr_name3" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/leaf_file
> > > > > +Attribute "attr_name1" has a 1024 byte value for
> > > > > SCRATCH_MNT/testdir/leaf_file
> > > > > +attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
> > > > > 
> > > > > attr_set: Input/output error
> > > > > Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
> > > > > touch: cannot touch 'SCRATCH_MNT/testdir/node_file':
> > > > > Input/output error
> > > > > -bb37a78ce26472eeb711e3559933db42  -
> > > > > +Attribute "attr_name2" has a 257 byte value for
> > > > > SCRATCH_MNT/testdir/node_file
> > > > > +Attribute "attr_name1" has a 65536 byte value for
> > > > > SCRATCH_MNT/testdir/node_file
> > > > > +attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
> > > > > 
> > > > > *** done
> > > > > -- 
> > > > > Dave Chinner
> > > > > david@fromorbit.com

