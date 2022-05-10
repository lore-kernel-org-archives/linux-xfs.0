Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B1AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiEJXtp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbiEJXto (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:49:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35C98F190
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:49:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AN9lTu010355;
        Tue, 10 May 2022 23:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=wVq1nPJYdUXrXuF1g6VjwOnKIRXWZB8cTzh0FaWotKw=;
 b=JBqcnyHxT9hp/YmYPr3AooqStHIe8SnJP3SEsJHh44BwTwJajF2GrWYUfc8Q+sEWSEst
 1VdFPGRXCCwSWiZd3XAQLdcSg/BIqB8cJHTkHLF+cdYFmJLa3axGREY7az9bVhpkhSWB
 Q2gBrLCHE0qGj9z4dApQhruTnyGke8X1pMMJ2LmXg332W9uZXh5IrawldGzMn70nI3+N
 IhINHVFL687qy7SKrXA0zSYiL5/0zgr5iOXoV7wfrCrMPgELc8d1BWOyxarwRfhJwd+H
 Zl4yyoxpkd4ogFVssmT32xNQQ9IgukXK9YQlumj3QEWLtKhxFmnHvK3YJK24Tl8DKlIo zA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwf6c825b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 23:49:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24ANje8d028985;
        Tue, 10 May 2022 23:49:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73p1qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 23:49:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icdSum3Mk1n5AeiIkgtql3aYQHon7en4WkV6QyXNRnlfIsBtn+ybqX3lvVypBpDmzeJMf84p73bsd/pV2Th425Nu0enVE5fgbsJf9AO+n1kPDTGjI6rpo7XCGeN3upYjc16Iv4zB1dlUmV8B7PxtS7xauyr+2eavqw4t6WAUPhNSoQDxU9kvUfKmvLcBDKJSNi/lORr8HQqqqkDwHzzC+Cxj0uLtnbB0zqWYK4id6KdVRvdotmW+jl+UNjhfOyJKUJU5k6zb4v3+mF9RkRBHZbLFg2gON7H62eVAl4Q8gXv/6kAlAn4EOZ07RtaSaM+rPL7XnRnY8lKJSh4OmXioJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wVq1nPJYdUXrXuF1g6VjwOnKIRXWZB8cTzh0FaWotKw=;
 b=i0GtLXaMPjkBcqYLq9VORvotYLV3MKojngSWq4iqb00fSO9/KiqcKDz7Jz3ok8or/CwBnDyiolYJai3uJ5nJ60UdKpAXeGe0Tet7+pNswJJ4mH2hlqw4L0EyPYqq5w2SBIUEed9tYdLZGtDWh4JHJwcGrLGK4nqWp0vz0PyLNz/xAKFAFSfQ1E6pgZF3uRMUaP9CtRwS+XyDZOSKv6XdCGgL07yyjXUPCa7mykp0cuC2qspiEmaWiKG/bh14fqBelXtTxHuwembxZKpSj/hfRRALmistPFoWEIJMgFh5KxZ7plLEol7OXWU0VQ63wELe5jyQblo1bKlAngiuHLobZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVq1nPJYdUXrXuF1g6VjwOnKIRXWZB8cTzh0FaWotKw=;
 b=HKurRseMGwkg7Zqm43UFWfa7CQP2dMEOavCNc9PWoxoDz+nAxOQ89kQtrXZqSYgzTP/C31ehdMs2z/Ouk09VIeclxkYWY26yNRZkJpy/drPq5RLSTAUZCRLX949nq70InlYyi/1dLQ/CVS2goCUTJSGI89J3KSXmS6wtaO9uMZw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB3027.namprd10.prod.outlook.com (2603:10b6:208:7e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 23:49:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 23:49:37 +0000
Message-ID: <f61dd2e905e6b153474cf0c69823a13d1ce5eed5.camel@oracle.com>
Subject: Re: [PATCH 16/18 v2] xfs: use XFS_DA_OP flags in deferred attr ops
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 10 May 2022 16:49:36 -0700
In-Reply-To: <20220510222015.GV1098723@dread.disaster.area>
References: <20220509004138.762556-1-david@fromorbit.com>
         <20220509004138.762556-17-david@fromorbit.com>
         <20220510222015.GV1098723@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b35f1d9c-efd1-4b33-4876-08da32dfbe13
X-MS-TrafficTypeDiagnostic: BL0PR10MB3027:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB30277F89CDE8630C86EC1B9595C99@BL0PR10MB3027.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nkhCQ5wLBkEHAfuWusd+iN4Oxh7uR0poIKhnHljj5vzVMEsFM/XxuXS4vtw54JZZMxL4f0XvY6PW4GmnwBQXMyiooKWWHUJevumcm5UgDFuNYzbGvaiD5B80F/JQsNquSq8PQc4/jkjUXpp/cVavwxC/MpISeRQAIbRR6Qx0rkzc560A687OCsRiucaxbdKYJJBXeWCCLEp1vF1cx19AXl4Sg0cgOY9tCTRL1S9zq9qrjAai9dW/fMw+5pZTAtfQg9qOP/tDR2hQWhzUYtIFKYxTMfqalTU6QtzoSFwHQko+iu+47uAt10dNwA2mpDnXT0JRLPzz39Cb9xS3Efj6AqgipsZGSlDCFioHk62eNeZVSV9k1FBEj+FVMNmBvDYVfZoYuqmkaagfSj0NNyviaayV3MluIEkROx1G2DWq1vfOvc+CUvkLiKSi2AG6ymfUTMPZ/ZrbmLSnVFkF1FXvO05eQD6+KYNz0pEantwRA6PnTZOzR/MVLhjpu68jNZ3vgfq8N62UyNYsCbIFjQd5VOhgExJrGON7GhB5U+m1U59PF4k5tqlC6ZEr7oSo8m1quZ9Thu0BVbihKN3wuN5pIL7WqVi0hzSsYzdBV4wb4qmib75FqhSQFnBJWqIQ3UFZFpyW9mStBR6S2DQUaPgcKkyEfg5VExk5JbD/EJaLcPeyUyGPfLPg85BwE7NTYtObiN0+J/iwaqsndK4EBc6RVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66946007)(66476007)(66556008)(83380400001)(86362001)(36756003)(316002)(38100700002)(30864003)(38350700002)(6486002)(508600001)(2906002)(186003)(2616005)(5660300002)(6506007)(52116002)(8936002)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzlsejZuQlJtSit4Q2g2VmlrVnUvTVRoY2lOcjVaaW00dGRKakpJTFpTb01x?=
 =?utf-8?B?VnZoWkxBSVlidTNwQjhnUldUY0JTQm9WZGwrTldPWU9JTXJvZjRRSXNtLzNH?=
 =?utf-8?B?dVFENXRlSUZuM1pra3kzUFlhejFhcWlNSlRmSUMwaVI0R0UzV2NyKzdiYWpI?=
 =?utf-8?B?ZVhrNS9MZXZ5QlhHN3RFYlZDT2VEVlBNZVA1dE9GZWJIVDVqZ3VRWnJYa3dW?=
 =?utf-8?B?S2NtWXhscHhwa0R4SE5hRVFCbmgzTWZub29CcU02RUNDOHk1aDVLQzNTNkNP?=
 =?utf-8?B?RjZrbkJoeFU3Z0ZtekdOSFVUYTNMZ2xrZy9vOW5MU08wR3VSNXRCMGdtTlNE?=
 =?utf-8?B?OEkrd3lPMDFxRzlYZ2F6VGxUcFpZODFhQ2thRXNlVG1SeGIxTTBNdXBSSE1l?=
 =?utf-8?B?UkVwTmtCT3l5dGQyMis3S3V3MStVbWJ6aDJFM2M2bFArR3lvajkzUWJCdDNE?=
 =?utf-8?B?MnRCVEdaNVhsZjhacUxTNDJ6VmFoOGQ1S0lBYVZFNlRNM2I1QkJVUW1iZ0Jx?=
 =?utf-8?B?dSt0cGRkbm9zRDMyZjF0cC8xQjdYMENxRis3S2lQT0s0a2V3eTRJcis1Smp3?=
 =?utf-8?B?VEF5UDdCK1JLeE5lWDJmcS9uaG5yb29yTEQ5a1NYcTRoVDhRQW45ZVhsT0tr?=
 =?utf-8?B?dWIxcTVzaGxKWE5nMERIclBEQ0ZMeXBJaHVUbWQrR1V6QmRnWENiQm9PT1M2?=
 =?utf-8?B?S1FyVnh1OXkrLzVSNGNFV0dnckZNVXNocGlhUU9pUUdYQVBEUEt4dG5ONitx?=
 =?utf-8?B?dWFPOW5hTWk4bWd0VlRSK0oxdnBrSUIzTEpIQ2lHNjc5UTkxWTRURzJBQktX?=
 =?utf-8?B?c3hQNnIzejlaaXIyOHgvRS9tdmlIVlVLSk9aMjR5MzMyNDdqR0pZQ21ZZUg3?=
 =?utf-8?B?TDAvNXdzUG1lbFg2Q1FhSVZ6Z3ZxZzVMT1J1eWU4dlc5QklUdjB4Z204aWZL?=
 =?utf-8?B?czFGeUVIbWo1anF6aEJKcm54dFgxaXg3SndXOHUzWDV6UldFZThCdzRYSnAx?=
 =?utf-8?B?WGJLUjdSRW1HdG9DK3BnWmM4NStibzVIMzRWeHhTeStYTVhaTjZmc0EveGhp?=
 =?utf-8?B?OGk3cDBhS2RqZDdHMytRd0F1MDFjT3ZzTHZZdklYSjBZTWZsRHNqWGpaYlpz?=
 =?utf-8?B?NzR1M3RWYjZJRG9Lblg2a1RMa1VWdXRLZ1I4U2FsSGhKRHBCTkhxeDBYNkZ6?=
 =?utf-8?B?SnhkdU1WVERJTnpTYUsyVHl5TkprMDJHbEYrWGx4WU5DUSszQ2U1dmNMekNh?=
 =?utf-8?B?cEtUY1Fma2FaN3RQNVJVT1FCS0NiRFhlc0haN1VDVWd2VVlxaUNXL3gzSGRQ?=
 =?utf-8?B?MDEyRG5KeGN4RE42eDRCWU1LUVA1UUc5bXN0bFJEUlljOVMvRHFQbC9ENkc4?=
 =?utf-8?B?NkxkcVEvWUdYcURRNUFUYXhRMG5DSzQ0NzcrajlISXRLcDdlQmdsSU16TEVi?=
 =?utf-8?B?dExRUnVTZmtTRWVhQWZpSi9PZTRuZ1p3cFE0NFM2MXZjWG9yM3RKOHU3OXdG?=
 =?utf-8?B?Rm1MV2loREdGR2RNOUpKbDU5emYwZEhxb1FMM2ZwVU1QOVNxck1MRGw2YTdL?=
 =?utf-8?B?SzdGLyt4UlVrdzJFUDFmaGMzVlZpRFhhOWZzRkQ5SWl0MnNXOHFJZjB3Rldi?=
 =?utf-8?B?TDdaeXJUSlhKbWQxSDU1UlZpRTRiZlkvY1Vua2VKZWVuMkZTK0tvTXdjY0tP?=
 =?utf-8?B?dklrSXVlRFBnTmE5bVlWTmU4VThiUkh2WUorQmQ3U0c2WDZVcVErUER1RUpQ?=
 =?utf-8?B?YUIxY212MVRBV1ltbWJxeGVBOVdudEpWOUREVWtPNnEwNTVtNkkwV0c0T0ZO?=
 =?utf-8?B?Tm1rVFNEWE8vUjVOSFJJSkNBTTVNOUErQ3F6RUtGamYwL3VyT1Rmb2xaamhJ?=
 =?utf-8?B?Zmw0dmQ3cDNIa1p1cDFlMHlDajdxOVBnM2NaWEQzbnhFc1g5UnlYbnIyb2ly?=
 =?utf-8?B?MXlRaEYraVlxZ0NlbnlONmk2R0h6RlBmRWVXd242R1JpUS9IMytOZ3RSYm1n?=
 =?utf-8?B?TlMwbmo1MFUrRTNVcXJmVWhrRjJhTVQ4MmVTeFFySmxDbytiaGFacGFiaFkz?=
 =?utf-8?B?MURLSDlFL2d3RkIySUFJczZBT3l0N2FSTXpoR2ZtMERNaUpDY1E3YUN6aGZE?=
 =?utf-8?B?THVHaWR6ZXhvOTJOZ3B0aFpsdW1aLzJEK3B3SjIyTjlkZm5rbWRCakNtYXVK?=
 =?utf-8?B?SHRmaEZHSDFHbzN2Qkd3WjJNKzBXdkQ0RmtHRXhESlNNK2RnTnFOWnNpRVYr?=
 =?utf-8?B?NkdpNkFlOEl6dGU5aEtIcjU3SVNlVjkydnZJQXdyM0M1UVNQT3ZRQkxMbmh4?=
 =?utf-8?B?Zm9qbTArR2RsMnlqZHI0Wk5EKzV6eWQwbUEyRXZBRWhqbWFaRUdDS1krR2Nn?=
 =?utf-8?Q?ksbNCYNOvnEabZp0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b35f1d9c-efd1-4b33-4876-08da32dfbe13
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 23:49:37.7032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IT6vUlCQsdPL0D2Wa1IzWFlIam/YHF/qklWgdVJYGt9o1nR45HKW0g6Z8TnRiZMdjl7uADGTaQpwnMbwrMTjE+TiyXZuGW8ImeD9TWEfnxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3027
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100098
X-Proofpoint-ORIG-GUID: -Jz-DfmJVohJuldsYLoL5-vgmKtyKzsb
X-Proofpoint-GUID: -Jz-DfmJVohJuldsYLoL5-vgmKtyKzsb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-11 at 08:20 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently store the high level attr operation in
> args->attr_flags. This falgs are what the VFS is telling us to do,
> but don't necessarily match what we are doing in the low level
> modification state machine. e.g. XATTR_REPLACE implies both
> XFS_DA_OP_ADDNAME and XFS_DA_OP_RENAME because it is doing both a
> remove and adding a new attr.
> 
> However, deep in the individual state machine operations, we check
> errors against this high level VFS op flags, not the low level
> XFS_DA_OP flags. Indeed, we don't even have a low level flag for
> a REMOVE operation, so the only way we know we are doing a remove
> is the complete absence of XATTR_REPLACE, XATTR_CREATE,
> XFS_DA_OP_ADDNAME and XFS_DA_OP_RENAME. And because there are other
> flags in these fields, this is a pain to check if we need to.
> 
> As the XFS_DA_OP flags are only needed once the deferred operations
> are set up, set these flags appropriately when we set the initial
> operation state. We also introduce a XFS_DA_OP_REMOVE flag to make
> it easy to know that we are doing a remove operation.
> 
> With these, we can remove the use of XATTR_REPLACE and XATTR_CREATE
> in low level lookup operations, and manipulate the low level flags
> according to the low level context that is operating. e.g. log
> recovery does not have a VFS xattr operation state to copy into
> args->attr_flags, and the low level state machine ops we do for
> recovery do not match the high level VFS operations that were in
> progress when the system failed...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
I popped this in place of the previous version and it ran ok for me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
> Version 2 (now that vger has finally got this to me after 2 days):
> - fixed bug by that removed clearing remote block values after save
>   for node format blocks. Clearing is now done by
>   xfs_attr_save_rmt_blk() for both callers.
> 
>  fs/xfs/libxfs/xfs_attr.c      | 136 +++++++++++++++++++++++---------
> ----------
>  fs/xfs/libxfs/xfs_attr.h      |   3 +
>  fs/xfs/libxfs/xfs_attr_leaf.c |   2 +-
>  fs/xfs/libxfs/xfs_da_btree.h  |   8 ++-
>  4 files changed, 83 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8be76f8d11c5..a36364b27aa1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -467,7 +467,7 @@ xfs_attr_leaf_addname(
>  	 */
>  	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
> -	else if (args->op_flags & XFS_DA_OP_RENAME)
> +	else if (args->op_flags & XFS_DA_OP_REPLACE)
>  		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_LEAF_REPLACE);
>  	else
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -512,7 +512,7 @@ xfs_attr_node_addname(
>  
>  	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
> -	else if (args->op_flags & XFS_DA_OP_RENAME)
> +	else if (args->op_flags & XFS_DA_OP_REPLACE)
>  		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_NODE_REPLACE);
>  	else
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -548,7 +548,7 @@ xfs_attr_rmtval_alloc(
>  		return error;
>  
>  	/* If this is not a rename, clear the incomplete flag and we're
> done. */
> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +	if (!(args->op_flags & XFS_DA_OP_REPLACE)) {
>  		error = xfs_attr3_leaf_clearflag(args);
>  		attr->xattri_dela_state = XFS_DAS_DONE;
>  	} else {
> @@ -967,8 +967,6 @@ xfs_attr_set(
>  
>  	if (args->value) {
>  		XFS_STATS_INC(mp, xs_attr_set);
> -
> -		args->op_flags |= XFS_DA_OP_ADDNAME;
>  		args->total = xfs_attr_calc_size(args, &local);
>  
>  		/*
> @@ -1126,28 +1124,41 @@ static inline int xfs_attr_sf_totsize(struct
> xfs_inode *dp)
>   * Add a name to the shortform attribute list structure
>   * This is the external routine.
>   */
> -STATIC int
> -xfs_attr_shortform_addname(xfs_da_args_t *args)
> +static int
> +xfs_attr_shortform_addname(
> +	struct xfs_da_args	*args)
>  {
> -	int newsize, forkoff, retval;
> +	int			newsize, forkoff;
> +	int			error;
>  
>  	trace_xfs_attr_sf_addname(args);
>  
> -	retval = xfs_attr_shortform_lookup(args);
> -	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> -		return retval;
> -	if (retval == -EEXIST) {
> -		if (args->attr_flags & XATTR_CREATE)
> -			return retval;
> -		retval = xfs_attr_sf_removename(args);
> -		if (retval)
> -			return retval;
> +	error = xfs_attr_shortform_lookup(args);
> +	switch (error) {
> +	case -ENOATTR:
> +		if (args->op_flags & XFS_DA_OP_REPLACE)
> +			return error;
> +		break;
> +	case -EEXIST:
> +		if (!(args->op_flags & XFS_DA_OP_REPLACE))
> +			return error;
> +
> +		error = xfs_attr_sf_removename(args);
> +		if (error)
> +			return error;
> +
>  		/*
> -		 * Since we have removed the old attr, clear
> ATTR_REPLACE so
> -		 * that the leaf format add routine won't trip over the
> attr
> -		 * not being around.
> +		 * Since we have removed the old attr, clear
> XFS_DA_OP_REPLACE
> +		 * so that the new attr doesn't fit in shortform
> format, the
> +		 * leaf format add routine won't trip over the attr not
> being
> +		 * around.
>  		 */
> -		args->attr_flags &= ~XATTR_REPLACE;
> +		args->op_flags &= ~XFS_DA_OP_REPLACE;
> +		break;
> +	case 0:
> +		break;
> +	default:
> +		return error;
>  	}
>  
>  	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
> @@ -1170,8 +1181,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * External routines when attribute list is one block
>  
> *====================================================================
> ====*/
>  
> -/* Store info about a remote block */
> -STATIC void
> +/* Save the current remote block info and clear the current
> pointers. */
> +static void
>  xfs_attr_save_rmt_blk(
>  	struct xfs_da_args	*args)
>  {
> @@ -1180,10 +1191,13 @@ xfs_attr_save_rmt_blk(
>  	args->rmtblkno2 = args->rmtblkno;
>  	args->rmtblkcnt2 = args->rmtblkcnt;
>  	args->rmtvaluelen2 = args->rmtvaluelen;
> +	args->rmtblkno = 0;
> +	args->rmtblkcnt = 0;
> +	args->rmtvaluelen = 0;
>  }
>  
>  /* Set stored info about a remote block */
> -STATIC void
> +static void
>  xfs_attr_restore_rmt_blk(
>  	struct xfs_da_args	*args)
>  {
> @@ -1229,28 +1243,27 @@ xfs_attr_leaf_try_add(
>  	 * Look up the xattr name to set the insertion point for the
> new xattr.
>  	 */
>  	error = xfs_attr3_leaf_lookup_int(bp, args);
> -	if (error != -ENOATTR && error != -EEXIST)
> -		goto out_brelse;
> -	if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> -		goto out_brelse;
> -	if (error == -EEXIST) {
> -		if (args->attr_flags & XATTR_CREATE)
> +	switch (error) {
> +	case -ENOATTR:
> +		if (args->op_flags & XFS_DA_OP_REPLACE)
> +			goto out_brelse;
> +		break;
> +	case -EEXIST:
> +		if (!(args->op_flags & XFS_DA_OP_REPLACE))
>  			goto out_brelse;
>  
>  		trace_xfs_attr_leaf_replace(args);
> -
> -		/* save the attribute state for later removal*/
> -		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic
> rename */
> -		xfs_attr_save_rmt_blk(args);
> -
>  		/*
> -		 * clear the remote attr state now that it is saved so
> that the
> -		 * values reflect the state of the attribute we are
> about to
> +		 * Save the existing remote attr state so that the
> current
> +		 * values reflect the state of the new attribute we are
> about to
>  		 * add, not the attribute we just found and will remove
> later.
>  		 */
> -		args->rmtblkno = 0;
> -		args->rmtblkcnt = 0;
> -		args->rmtvaluelen = 0;
> +		xfs_attr_save_rmt_blk(args);
> +		break;
> +	case 0:
> +		break;
> +	default:
> +		goto out_brelse;
>  	}
>  
>  	return xfs_attr3_leaf_add(bp, args);
> @@ -1389,46 +1402,45 @@ xfs_attr_node_hasname(
>  
>  STATIC int
>  xfs_attr_node_addname_find_attr(
> -	 struct xfs_attr_item		*attr)
> +	 struct xfs_attr_item	*attr)
>  {
> -	struct xfs_da_args		*args = attr->xattri_da_args;
> -	int				retval;
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +	int			error;
>  
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> -	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
> -	if (retval != -ENOATTR && retval != -EEXIST)
> -		goto error;
> -
> -	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> -		goto error;
> -	if (retval == -EEXIST) {
> -		if (args->attr_flags & XATTR_CREATE)
> +	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
> +	switch (error) {
> +	case -ENOATTR:
> +		if (args->op_flags & XFS_DA_OP_REPLACE)
> +			goto error;
> +		break;
> +	case -EEXIST:
> +		if (!(args->op_flags & XFS_DA_OP_REPLACE))
>  			goto error;
>  
> -		trace_xfs_attr_node_replace(args);
> -
> -		/* save the attribute state for later removal*/
> -		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic
> rename op */
> -		xfs_attr_save_rmt_blk(args);
>  
> +		trace_xfs_attr_node_replace(args);
>  		/*
> -		 * clear the remote attr state now that it is saved so
> that the
> -		 * values reflect the state of the attribute we are
> about to
> +		 * Save the existing remote attr state so that the
> current
> +		 * values reflect the state of the new attribute we are
> about to
>  		 * add, not the attribute we just found and will remove
> later.
>  		 */
> -		args->rmtblkno = 0;
> -		args->rmtblkcnt = 0;
> -		args->rmtvaluelen = 0;
> +		xfs_attr_save_rmt_blk(args);
> +		break;
> +	case 0:
> +		break;
> +	default:
> +		goto error;
>  	}
>  
>  	return 0;
>  error:
>  	if (attr->xattri_da_state)
>  		xfs_da_state_free(attr->xattri_da_state);
> -	return retval;
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 6bef522533a4..e93efc8b11cd 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -584,6 +584,7 @@ xfs_attr_is_shortform(
>  static inline enum xfs_delattr_state
>  xfs_attr_init_add_state(struct xfs_da_args *args)
>  {
> +	args->op_flags |= XFS_DA_OP_ADDNAME;
>  	if (!args->dp->i_afp)
>  		return XFS_DAS_DONE;
>  	if (xfs_attr_is_shortform(args->dp))
> @@ -596,6 +597,7 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
>  static inline enum xfs_delattr_state
>  xfs_attr_init_remove_state(struct xfs_da_args *args)
>  {
> +	args->op_flags |= XFS_DA_OP_REMOVE;
>  	if (xfs_attr_is_shortform(args->dp))
>  		return XFS_DAS_SF_REMOVE;
>  	if (xfs_attr_is_leaf(args->dp))
> @@ -606,6 +608,7 @@ xfs_attr_init_remove_state(struct xfs_da_args
> *args)
>  static inline enum xfs_delattr_state
>  xfs_attr_init_replace_state(struct xfs_da_args *args)
>  {
> +	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
>  	return xfs_attr_init_add_state(args);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c
> b/fs/xfs/libxfs/xfs_attr_leaf.c
> index e90bfd9d7551..53d02ce9ed78 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1492,7 +1492,7 @@ xfs_attr3_leaf_add_work(
>  	entry->flags = args->attr_filter;
>  	if (tmp)
>  		entry->flags |= XFS_ATTR_LOCAL;
> -	if (args->op_flags & XFS_DA_OP_RENAME) {
> +	if (args->op_flags & XFS_DA_OP_REPLACE) {
>  		if (!xfs_has_larp(mp))
>  			entry->flags |= XFS_ATTR_INCOMPLETE;
>  		if ((args->blkno2 == args->blkno) &&
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h
> b/fs/xfs/libxfs/xfs_da_btree.h
> index deb368d041e3..468ca70cd35d 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -85,19 +85,21 @@ typedef struct xfs_da_args {
>   * Operation flags:
>   */
>  #define XFS_DA_OP_JUSTCHECK	(1u << 0) /* check for ok with no space
> */
> -#define XFS_DA_OP_RENAME	(1u << 1) /* this is an atomic rename
> op */
> +#define XFS_DA_OP_REPLACE	(1u << 1) /* this is an atomic replace
> op */
>  #define XFS_DA_OP_ADDNAME	(1u << 2) /* this is an add operation
> */
>  #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else
> die */
>  #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if
> found */
>  #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode
> timestamps */
> +#define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation
> */
>  
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> -	{ XFS_DA_OP_RENAME,	"RENAME" }, \
> +	{ XFS_DA_OP_REPLACE,	"REPLACE" }, \
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> -	{ XFS_DA_OP_NOTIME,	"NOTIME" }
> +	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
> +	{ XFS_DA_OP_REMOVE,	"REMOVE" }
>  
>  /*
>   * Storage for holding state during Btree searches and split/join
> ops.
> Dave Chinner
> david@fromorbit.com

