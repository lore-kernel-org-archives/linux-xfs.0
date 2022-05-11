Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A19C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 00:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiEKAyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 20:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiEKAyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 20:54:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AF6522D0
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 17:54:30 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AMSXJ7010429;
        Wed, 11 May 2022 00:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OoraBN5KB7GAibHk9RKzheHxIGEHapmh7hJTtOqeMa4=;
 b=sHyIZzi0zEA+AgYTrGZ3e8E69cJu9RPXLi+dnZMXvy+a3go/o1SAywzCMUuge29J3lf0
 +CKDXBPrA4EZhG3CsgqVAmJt33JDFn51XBmwkK0tPYZ6HXSWc72yh+EnEVDNy+d4nPXn
 mjTtudRTmIteDUQu4p1ki30VaEpAaB+mfgyvNxc3ZESLL9U9JyfE98oRCLik62XBrIXJ
 x4rRgvPwL9go1nE9KetBGjsDx8CIChWfGsZyvCgBXWy6x650ZAdvYJRhzznjcCz6snkx
 2h55VjNIwauMMqoR9SpuGZCfQ70dFANrNuP1rvZzpvmUFjCE/DDGaTJuGEATTCTQocyI Bg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwf6c84nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 00:54:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24B0jmEb034811;
        Wed, 11 May 2022 00:54:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73qf1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 00:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VidfCRweamRSus8ULbgyY6K2GuhOJEPAMKb/6zkOiXzP7k9AFDwk6ailQxCgmtBiP44/UGbWg9e3qf8NGILDclVvP15jdNfXM00pLU0QGxLwjmqrV9CDNjza/ZSlXirQBF+iI5ll8lZD2jsNUd+r4pGvgqyDOJZw75XIha1IPW87Nhr+BfP3345RkcQOAxEfRyIJpSnXSr+ekCMznrag+uW0xygp+yWdR0N3jgfvhK7Lv0rOzBzK8nt6vA7mHp607m444pXy+RZvo/RBny7g3nZ4J/BWFQ8PCZq66KuAWSEmuKY47s0Hmz7HA4u68vKgEIKf1mxkZ+1J4Fzbs+TfIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OoraBN5KB7GAibHk9RKzheHxIGEHapmh7hJTtOqeMa4=;
 b=WsPlkhW7lKugEXsJ46ExWB+rRViOXzz0yAIOZgTqoQsOUJXuqgy3/FFB0WMZp0i9RDFh0t4SlaS23C2EfW8kUMinusFQxcZrray4Fy+BGhfQpqthNKF29BVf+GJ6c0VtOT+PttQyMGA5I9L2cIqvb0LOLSdV4uBSvzApIj9FF3cI7LmyGvQtPqhSsh2e9+Rvhd9/EJb0dgeB8sJh8el7tuOZunRPZT0HYcPNOdCwhqZQD34IzIcNee8fFfYiMbPWqOCg+PPItGHSRo0Ul6C4adtyhT3VxnC5O9PfMf6mR+4Gcl1Kl+e2FCCoCkrABFzwJhgU3SLRlO/zxKtb3dzi2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoraBN5KB7GAibHk9RKzheHxIGEHapmh7hJTtOqeMa4=;
 b=xdodewuatwu79QDdU5ifPfPBQljuGn4szwDCQzMaJc44h7+qyQyKhj3yFOSAeAGHxD1qKL8XaeGTa+Mbq5b4iNKhqm07JOag1evK7iqVpiMwFHcTxvnFEjgVeDdCn03Dqrp9An3G2JTV1le8bRVP+JF8A9Z/BXQ37uVlsP7OPhQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB4830.namprd10.prod.outlook.com (2603:10b6:5:3ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Wed, 11 May
 2022 00:54:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 00:54:16 +0000
Message-ID: <f2fdf0afdec6e1dcef75f5d7b51bb6db8f062208.camel@oracle.com>
Subject: Re: [PATCH 19/18] xfs: can't use kmem_zalloc() for attribute buffers
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 10 May 2022 17:54:15 -0700
In-Reply-To: <20220510222716.GW1098723@dread.disaster.area>
References: <20220509004138.762556-1-david@fromorbit.com>
         <20220510222716.GW1098723@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efd5616c-0fc5-4ab8-9908-08da32e8c60d
X-MS-TrafficTypeDiagnostic: DS7PR10MB4830:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB48300BD6E3ED97DF1F106BFB95C89@DS7PR10MB4830.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZsnUKRbj/KkucFBSq3ZNsNjcl5zkMEqFhlK0FvGOTXYFQ5jUqYvslena1u1Y0lLaOOSYv3IcLjucN36BIg10jHulQMTkRIgJD/FKuxOBESG/15foEdSam2vRvgcge9e3GtIKq4ZmYpIKbMoxwETtm+qSmfnOV1bkoYN5EJXrkwvXHgZwlgPeKPXg7sXtJ6sTN1KTINfqByQm29jpTgofLzD463nQOqqCGUwqRu+yYgvlWkFLKEtwFQcqKW4n3jL8FtqXDitKF4f/NLYHjtZZLEmUCo9no2GvevZiUbALwKcCKAntbjh5GAMMFyABbmvE5jSZ+Ja9z+VOgsCSCSLz0TZy0ifavJlzL0ItBS8oKA7WuwB/Llik+tWjT4An2hjqnk/Ai8y0J1rTO2wv/f8bxLsBjTYvVPilfUwFdun1QbtUneOgbSYV6qs1uX4CzYj3Os2AABBR/5SWm4bNNlGgCLYyNwl8pwFHD0K0WXgUDeVrtx3xGLVTRlw4TtOo/TTL31EFQrdh6IdY6+k/EyHIWpxckE5jKPjX6fHzYdUZ8SBhU4uEDAkcZfgsc3sEQQwDZeTX+ac0vqDU65mBQugP2lodDk9q4GLsuBeGPMzWYhr6yFnoXe6nt08usXIJKEDsN6yjxy7ZFpYDunPkV8pgrR0/KztKp76nzw09b7DNcL7wIWWq3Xl5vVcra1//Rf+aFpgr9lIxBvNpTShifcx8ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(2906002)(8936002)(38100700002)(38350700002)(5660300002)(186003)(83380400001)(508600001)(66946007)(66476007)(2616005)(66556008)(8676002)(316002)(6506007)(52116002)(6512007)(26005)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEVDQk42blpDKzg0Qy9GLy9lWlUwdC8wTG45bnYrVUhlK2lXS2RrQTUxSjB0?=
 =?utf-8?B?NjVwSHgzYWxvbGkvZmNFeS93RnJVVmZrdC9rS3ZoL2NxMitvTVJaVWhFMHpL?=
 =?utf-8?B?TTFVaEZWUWNXeVVzUS9CTUhDKzdxajhhSnhCejBnQ3hKbmZ5R2EyeDQwU0hO?=
 =?utf-8?B?NlUvNzNnUVJSdUM1NXZPRXgwQVlKQVVFUEVkSkhJdE9tMWw3bjZtNm41b1Ew?=
 =?utf-8?B?MmcrWkgzUGJkODF6Y0lxNEsxWTMrMGJzdDBwcll5UzlDUHdBMEZjdGt1NEhC?=
 =?utf-8?B?NDNrR3Z3WXVwZWdvMGp0YVdpZmUwNW0vVENHNU9zTUYrMkRtNlNFNFlxMGll?=
 =?utf-8?B?M2VzaUk3SkVMZTF4QTlrTUtXbEVQd1BoMGIrZXRVeTJuNUxpSytDSm9VWS9K?=
 =?utf-8?B?c01EN1gxaDNxY1BzTXJKQW5nUzA3eDlSbTBTTStiVEFqL0NWZWttTjFjRUpp?=
 =?utf-8?B?QjZOaXdjUS9PcFNLWmwralVoZi8wUGd5Q0pCYUQ0RUZ4K0RjT3lLaGpzZWdx?=
 =?utf-8?B?T0hqMzN2MlR5d01iRzQ3TDluVUdZZlRSWEZjVlZVejYxZmVSeUh2ckJjbllP?=
 =?utf-8?B?MGlTNzc3RGxGM1ZGa3JTTHdCUnJuOTRxTUhBM09BZ2ZmSG9DWThGVXBmUk1s?=
 =?utf-8?B?K1lOOXFlY2M4TnNQelBvN3pOZm9yVWhKa1pHdmVoWVYzRG1hM3ltdWN1amVz?=
 =?utf-8?B?eVYrRHF5UkdtbzRWQTgvalhpK21ZNkwrSVpDaE8rbUtEeVJoUmdidGpWdUtM?=
 =?utf-8?B?NmsxNDNvZ1NkS1NqSnJTVnNYVkJiS016VTRlQm9lVFpYT1hnVUk4R2VWR0E0?=
 =?utf-8?B?VjVOalJuTWtIVmdQTGFvTndyREdIM093WXVQcVYrTEExVUlTYUhhd05xWGlJ?=
 =?utf-8?B?WmI1ZGhJd2IzVTU5NzdRRXJoY2dSbGxLUXVrUG9jdm5ZUU1DTHN0cTY2ZXRp?=
 =?utf-8?B?SXBHcHF1M3NMc1dXM20rUGtsSWt2REhlZEJrQkVob05LRTNMTFhvZThWbFFl?=
 =?utf-8?B?SU5qQWJuZlNndExDTXpNUUFiVkxuVTFiWVhqN2hyamRxTC9UMmg1NThVMHNq?=
 =?utf-8?B?Q2p3R1RLdHlQT09JemRDanFmZ3NlZWNVQ2c5T0RKK00rM2hDV0J5endtd2Zu?=
 =?utf-8?B?V1pRR25PSnFUUVdBSkN3Mi9IWFNKMW1MQ25QckF6NGd2K05mTllZZlEzNEM3?=
 =?utf-8?B?akRRaUhSM1g3QmpMQVc0UW9MKzZWTVlsdHNuY2tYelNTeU9TbmlhcGhtYU9n?=
 =?utf-8?B?STlpOXRKQ2Fxd3BiaHFEdUd6M0ZuWEZXTU10UnlaZ2FHOWgrY0NPMHFhK3ow?=
 =?utf-8?B?anNyMTJza0hzU2hmeEZTU0hoYkZRdkh5QTNCbXVzU3pvR3BsaFlPVmwxa2c4?=
 =?utf-8?B?b0llSTVLeGNIM1BtQkpWNFRNWHdncGxMUVJXSk1UUU1oOVIvUDRMQzh0cnJM?=
 =?utf-8?B?Z0hVc2N3S1NaRnEwVzRCKytVczJHNlRySzV1V1Q4dzRDSHRyNWgyeG5rV05X?=
 =?utf-8?B?cC9wakNjQ1BuMEVzZGEwUVc5Mm5PNHNtNnFZenc0VGUyUEdaOU1JTnFWaG16?=
 =?utf-8?B?UThVMzNkR21yclc2LzNYNWoyQndueDIxbWsxWmRxM0lrRXVWQnBydzF3SjlX?=
 =?utf-8?B?VThtNEpHcDVCaUxudHpPaThzc01SNlgyMjdhTkhUYlZaMmVqcklEa0l4VE5I?=
 =?utf-8?B?K0FtdmVYUTVnZUMwM0UrcGN3YWkrQ3BDNURNaGVESEgyckFHT2R5Z25YUEFK?=
 =?utf-8?B?VGVoTWliVUxJK3BRN0VuRVY2d1FNRUppalZtb1lLdCtKZUhwc1p2Z29LWnpm?=
 =?utf-8?B?NlFRdkczZHkzZWVPeDgwNnduUXd4NlcrbmNXSzZHRDVYNVFNM0IzOXVMNEho?=
 =?utf-8?B?Tk52SnoyT01yZWVrNDl1QWs5Y1Z5Y1pzcm4waG9xK0tXSTRvRWFuSHVyUUo4?=
 =?utf-8?B?dmZXQmNtYWJWb3BlRkdYK2hEVUt4MVFwRTVOZVV6MGtoNGQzSkdSd2k2R3pW?=
 =?utf-8?B?RDBvOURscEhHanlIWDRJbkZIR3ZuSXg4OXlua0RQV2Y4cHZmclBMam0xMENt?=
 =?utf-8?B?MzFvRm5pUHhFbUsvYlQxaUNwbmJwbm1CNnZyRm5td0lSZnNRdmVsQXVNR0hn?=
 =?utf-8?B?RFExeGoxY0pDaEtmS0xzY2hxand5NEdEL0k0WUcwTkgzRW5kRnI3QXhyNStx?=
 =?utf-8?B?aHI4R0VyamhjcUU4Z041TlB6bFE2K2JMRnQ4SVBoYWx0bjVQeHM3ekIydE50?=
 =?utf-8?B?dUtuOXh5ZWNGM1oxMm16eFNJT0hCblZ4RkhlVUFTWVUrZGJ1OHVqUS95SWtu?=
 =?utf-8?B?WWFuQjIrM1ByajN5aTZ2YkcvZ0V3NG5ISGxrM3ppNklucjBxbmkzNDBxUUN3?=
 =?utf-8?Q?EPXWwV7B8qnTltXQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd5616c-0fc5-4ab8-9908-08da32e8c60d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 00:54:16.4021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /85iqPwA2ZP+MN2FEptPb2H+Zm13oNZnfgHq0norcW8fKTIVQO5AFhV+uN44nDhNCY674BRWqrEFflotwfzHlHLpkamw/YSpw6pqRmTtrdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4830
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110001
X-Proofpoint-ORIG-GUID: uKyRxiJvZz11xQ0wK2Gedj2Aj1SpG2YH
X-Proofpoint-GUID: uKyRxiJvZz11xQ0wK2Gedj2Aj1SpG2YH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-11 at 08:27 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because when running fsmark workloads with 64kB xattrs, heap
> allocation of >64kB buffers for the attr item name/value buffer
> will fail and deadlock.
> 
> ....
>  XFS: fs_mark(8414) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8417) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8409) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8428) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8430) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8437) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8433) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8406) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8412) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8432) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8424) possible memory allocation deadlock size 65768 in
> kmem_alloc (mode:0x2d40)
> ....
> 
> I'd use kvmalloc(), but if we are doing 15,000 64kB xattr creates a
> second, the attempt to use kmalloc() in kvmalloc() results in a huge
> amount of direct reclaim work that is guaranteed to fail occurs
> before it falls back to vmalloc:
> 
> - 48.19% xfs_attr_create_intent
>   - 46.89% xfs_attri_init
>      - kvmalloc_node
> 	- 46.04% __kmalloc_node
> 	   - kmalloc_large_node
> 	      - 45.99% __alloc_pages
> 		 - 39.39% __alloc_pages_slowpath.constprop.0
> 		    - 38.89% __alloc_pages_direct_compact
> 		       - 38.71% try_to_compact_pages
> 			  - compact_zone_order
> 			  - compact_zone
> 			     - 21.09% isolate_migratepages_block
> 				  10.31% PageHuge
> 				  5.82% set_pfnblock_flags_mask
> 				  0.86% get_pfnblock_flags_mask
> 			     - 4.48% __reset_isolation_suitable
> 				  4.44% __reset_isolation_pfn
> 			     - 3.56% __pageblock_pfn_to_page
> 				  1.33% pfn_to_online_page
> 			       2.83% get_pfnblock_flags_mask
> 			     - 0.87% migrate_pages
> 				  0.86% compaction_alloc
> 			       0.84% find_suitable_fallback
> 		 - 6.60% get_page_from_freelist
> 		      4.99% clear_page_erms
> 		    - 1.19% _raw_spin_lock_irqsave
> 		       - do_raw_spin_lock
> 			    __pv_queued_spin_lock_slowpath
> 	- 0.86% __vmalloc_node_range
> 	     0.65% __alloc_pages_bulk
> 
> So lift xlog_cil_kvmalloc(), rename it to xlog_kvmalloc() and use
> that instead because it has sane fail-fast behaviour for the
> embedded kmalloc attempt. It also provides __GFP_NOFAIL guarantees
> that kvmalloc() won't do, either....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
This looks ok to me, didnt run across any test failures
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/xfs_attr_item.c | 35 +++++++++++++++--------------------
>  fs/xfs/xfs_log_cil.c   | 35 +----------------------------------
>  fs/xfs/xfs_log_priv.h  | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 50 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 56f678c965b7..e8ac88d9fd14 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -44,7 +44,7 @@ xfs_attri_item_free(
>  	struct xfs_attri_log_item	*attrip)
>  {
>  	kmem_free(attrip->attri_item.li_lv_shadow);
> -	kmem_free(attrip);
> +	kvfree(attrip);
>  }
>  
>  /*
> @@ -119,11 +119,11 @@ xfs_attri_item_format(
>  			sizeof(struct xfs_attri_log_format));
>  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
>  			attrip->attri_name,
> -			xlog_calc_iovec_len(attrip->attri_name_len));
> +			attrip->attri_name_len);
>  	if (attrip->attri_value_len > 0)
>  		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>  				attrip->attri_value,
> -				xlog_calc_iovec_len(attrip-
> >attri_value_len));
> +				attrip->attri_value_len);
>  }
>  
>  /*
> @@ -163,26 +163,21 @@ xfs_attri_init(
>  
>  {
>  	struct xfs_attri_log_item	*attrip;
> -	uint32_t			name_vec_len = 0;
> -	uint32_t			value_vec_len = 0;
> -	uint32_t			buffer_size;
> -
> -	if (name_len)
> -		name_vec_len = xlog_calc_iovec_len(name_len);
> -	if (value_len)
> -		value_vec_len = xlog_calc_iovec_len(value_len);
> -
> -	buffer_size = name_vec_len + value_vec_len;
> +	uint32_t			buffer_size = name_len + value_len;
>  
>  	if (buffer_size) {
> -		attrip = kmem_zalloc(sizeof(struct xfs_attri_log_item)
> +
> -				    buffer_size, KM_NOFS);
> -		if (attrip == NULL)
> -			return NULL;
> +		/*
> +		 * This could be over 64kB in length, so we have to use
> +		 * kvmalloc() for this. But kvmalloc() utterly sucks,
> so we
> +		 * use own version.
> +		 */
> +		attrip = xlog_kvmalloc(sizeof(struct
> xfs_attri_log_item) +
> +					buffer_size);
>  	} else {
> -		attrip = kmem_cache_zalloc(xfs_attri_cache,
> -					  GFP_NOFS | __GFP_NOFAIL);
> +		attrip = kmem_cache_alloc(xfs_attri_cache,
> +					GFP_NOFS | __GFP_NOFAIL);
>  	}
> +	memset(attrip, 0, sizeof(struct xfs_attri_log_item));
>  
>  	attrip->attri_name_len = name_len;
>  	if (name_len)
> @@ -195,7 +190,7 @@ xfs_attri_init(
>  	if (value_len)
>  		attrip->attri_value = ((char *)attrip) +
>  				sizeof(struct xfs_attri_log_item) +
> -				name_vec_len;
> +				name_len;
>  	else
>  		attrip->attri_value = NULL;
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 42ace9b091d8..b4023693b89f 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -219,39 +219,6 @@ xlog_cil_iovec_space(
>  			sizeof(uint64_t));
>  }
>  
> -/*
> - * shadow buffers can be large, so we need to use kvmalloc() here to
> ensure
> - * success. Unfortunately, kvmalloc() only allows GFP_KERNEL
> contexts to fall
> - * back to vmalloc, so we can't actually do anything useful with gfp
> flags to
> - * control the kmalloc() behaviour within kvmalloc(). Hence
> kmalloc() will do
> - * direct reclaim and compaction in the slow path, both of which are
> - * horrendously expensive. We just want kmalloc to fail fast and
> fall back to
> - * vmalloc if it can't get somethign straight away from the free
> lists or buddy
> - * allocator. Hence we have to open code kvmalloc outselves here.
> - *
> - * Also, we are in memalloc_nofs_save task context here, so despite
> the use of
> - * GFP_KERNEL here, we are actually going to be doing GFP_NOFS
> allocations. This
> - * is actually the only way to make vmalloc() do GFP_NOFS
> allocations, so lets
> - * just all pretend this is a GFP_KERNEL context operation....
> - */
> -static inline void *
> -xlog_cil_kvmalloc(
> -	size_t		buf_size)
> -{
> -	gfp_t		flags = GFP_KERNEL;
> -	void		*p;
> -
> -	flags &= ~__GFP_DIRECT_RECLAIM;
> -	flags |= __GFP_NOWARN | __GFP_NORETRY;
> -	do {
> -		p = kmalloc(buf_size, flags);
> -		if (!p)
> -			p = vmalloc(buf_size);
> -	} while (!p);
> -
> -	return p;
> -}
> -
>  /*
>   * Allocate or pin log vector buffers for CIL insertion.
>   *
> @@ -368,7 +335,7 @@ xlog_cil_alloc_shadow_bufs(
>  			 * storage.
>  			 */
>  			kmem_free(lip->li_lv_shadow);
> -			lv = xlog_cil_kvmalloc(buf_size);
> +			lv = xlog_kvmalloc(buf_size);
>  
>  			memset(lv, 0, xlog_cil_iovec_space(niovecs));
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 4aa95b68450a..46f989641eda 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -679,4 +679,38 @@ xlog_valid_lsn(
>   */
>  void xlog_cil_pcp_dead(struct xlog *log, unsigned int cpu);
>  
> +/*
> + * Log vector and shadow buffers can be large, so we need to use
> kvmalloc() here
> + * to ensure success. Unfortunately, kvmalloc() only allows
> GFP_KERNEL contexts
> + * to fall back to vmalloc, so we can't actually do anything useful
> with gfp
> + * flags to control the kmalloc() behaviour within kvmalloc(). Hence
> kmalloc()
> + * will do direct reclaim and compaction in the slow path, both of
> which are
> + * horrendously expensive. We just want kmalloc to fail fast and
> fall back to
> + * vmalloc if it can't get somethign straight away from the free
> lists or
> + * buddy allocator. Hence we have to open code kvmalloc outselves
> here.
> + *
> + * This assumes that the caller uses memalloc_nofs_save task context
> here, so
> + * despite the use of GFP_KERNEL here, we are going to be doing
> GFP_NOFS
> + * allocations. This is actually the only way to make vmalloc() do
> GFP_NOFS
> + * allocations, so lets just all pretend this is a GFP_KERNEL
> context
> + * operation....
> + */
> +static inline void *
> +xlog_kvmalloc(
> +	size_t		buf_size)
> +{
> +	gfp_t		flags = GFP_KERNEL;
> +	void		*p;
> +
> +	flags &= ~__GFP_DIRECT_RECLAIM;
> +	flags |= __GFP_NOWARN | __GFP_NORETRY;
> +	do {
> +		p = kmalloc(buf_size, flags);
> +		if (!p)
> +			p = vmalloc(buf_size);
> +	} while (!p);
> +
> +	return p;
> +}
> +
>  #endif	/* __XFS_LOG_PRIV_H__ */

