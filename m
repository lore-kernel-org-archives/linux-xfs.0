Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3D9C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jun 2022 00:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiFRAcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 20:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbiFRAcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 20:32:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB33F5A5AE
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 17:32:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HJMlfo026656;
        Sat, 18 Jun 2022 00:32:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OpNe+MfpIBH4fMgQblOl2dkYDAiihZRe/UDoXWrtKVI=;
 b=Tm/iqRwyrO7AGdOD4CBtwmK1uDnFGHChiT/kOiLTmMJfB3kw2KTWrA130okCramQOP/8
 VzawLbKjJWIokF6OUVqy2UnFn0d5WOERrOy8fY/QEiSUD4LhmGxBaM1eWy8693+M47+s
 EVD+JZwghyQhZiphRKHMeg2FhUeDsdxuEXAQrmpxmcJAZ5CSGWMsQ5g0eDEBlmyNc7FZ
 fVN3pxZnFKoG+FAds49IFLJL0M6E8yWJdyu+i92ZKBp2Q1IeMDBesC06xMnuihjkvRzp
 l+a3fmtjQd57dUvyIS67UCQZc/IcNEVu1LRq3GhkKwSbmz+qf7ZlsQkdxSJZp7RhuAnQ MQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn0q13w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25I0Pkve020606;
        Sat, 18 Jun 2022 00:32:05 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpqwdw9qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktjn5huIh6tU0JwIU6kOQaWIHK1QVOk7wWJYJSs3jL9jVEyh4ps8437yZO5EcutInMHMDR0HUioobPO7gGO8Ex+P2C9ORIU4YB+BK3Vre9HK1rwTiC+smJX5MnKfyi5U7DnwQ9saYn4CDgwfMtSiPMC+kcxYY/TS38ikAGj/Uj/G0C8zvYIu7OFzRjAkxPSSIxO0JjP0J+eKMfIqbvh/gdFcQ/uPHGf3neFpCAsK0nqgMUutiNMyIQS/bNJLa5fR4TSjnGOrfgJ5QUiHROOomG5CBW/p0WXTJ8etIE39y1DlkFrwGaq+LyfD4y/I0eXDfho8xVS/CcKZdNw4zCb+Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpNe+MfpIBH4fMgQblOl2dkYDAiihZRe/UDoXWrtKVI=;
 b=G+Q0hc7LAyk2YDOf4mqhrn5+fw2y30IKo+v1/qeIuB+y+aIk9ZnhW/7OPVLWYbKfqaEiIbrfUo7eXCQdSMLZv83nHOkEJp2TvxHlsVYSx86Id04AuxcR2BO+yenYYW1yaEJxyFohxH2EosFdV4ODJs2LKdcp8prKaz8NOJu1fTrXBoQUSu3FlPvucvkywbkm42XVlJBF1rCOQByxj231cm81iVv2E5bSJXaFYDb18t95CAwdAj62Xa0M2HBzvAYkVXkk9IFIXy2Dp5DTaAbVjcXPVWulrnapIMP8fUQ0U5S2GocBSXQGskS+w4ZsNJzS0j49wjNzo4BTY14Lbx8uMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpNe+MfpIBH4fMgQblOl2dkYDAiihZRe/UDoXWrtKVI=;
 b=SZk1YrmWWDIcDT1f14pIdxQ92cq5vomSJVlY/aTt56ZpJUCIuwxlvZlfHy5PWW0+mhpHtxmvJ2+td9bj3de5G+3rfiM26pKdxZsl2+/ob39VK/rR65aD2nz7B/TL2BQM1PwwpB3hiv6olfluecjxHrGMw1fyuZu3580/Bz1XgFo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5198.namprd10.prod.outlook.com (2603:10b6:5:3a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Sat, 18 Jun
 2022 00:32:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 00:32:02 +0000
Message-ID: <fcdbb58be768a82e2dac8204301439d2b27572ac.camel@oracle.com>
Subject: Re: [PATCH v1 09/17] xfs: extent transaction reservations for
 parent attributes
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Jun 2022 17:31:59 -0700
In-Reply-To: <20220616053807.GC227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-10-allison.henderson@oracle.com>
         <20220616053807.GC227878@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a106a02a-cd80-4ea5-abd6-08da50c1f6c0
X-MS-TrafficTypeDiagnostic: DS7PR10MB5198:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB51985977F92DBF7D74F5671695AE9@DS7PR10MB5198.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A5rRjFMc8RLfHxjVVEphB7bbq6Y8z7BAhy4oP1LSUHTG+pwsidUgsMc72P6qdH+9kovz/c+epZ+YuGD/xig5mrk0Vu3JBX2Id56/rvj1KaJJGdt2TFCiRPpRfcSragoIZwErfmx8OAXQziOjLBb4ueSfWiD0kiCnKR6pDp1RnXqDQOhsIDVs7KWDAyN0Br2oZ/AJ82mrOpWt+89z6vSbEWtq1DnN/sc44Q7Xoy1/x3hEAE6gYu/im/W7viTDuBZ4tiW9l0ym8d+IY2Z8l5b899DfHwiwGCNlQ3b4Ryi0Y5m5lF9z+VsBRh+0Ou4ywDap8VAsBYVRUX22KzZ22UeAZK715nBPzossOnL/z5HlxCw7PwczA7f3p2m/f1Ec1xZmeRAb0CXLHFozA4RRvg//ZurU/j4UR9Df0mJ0Q14YRpC8imbNyB3VHQaeIWQa8/kzpSChtDXUfK70yvO4UjzWNP8JVlEc0Qa7lEXOT6ncgvvRWW+qZdJnPLeiAeoqaPk69CUoUiIDdNzRvqY9XzHSgd3PzPgYzXVfDVF5f4ZlIoQktIvKkN6D8TK19qDD7xox38G49vdAxMN5c3iP9NoNTlfPmgQV/xbLmW2Dnd315gxYN5F6pQ13lzxUoPkaGJdDEALA7O+b3FkQ1lHT89B6pLAVaJiO+4fCGV35G1d6TIuRyq9CwCqXnYoz3nX3R5fe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(8676002)(36756003)(8936002)(4326008)(66946007)(6486002)(498600001)(66556008)(66476007)(316002)(2906002)(5660300002)(2616005)(52116002)(26005)(6916009)(186003)(6666004)(6506007)(38100700002)(38350700002)(83380400001)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2hMTnAwVzB1Z1dQZjFUdnNYZEVRbEJsMnFuV1RuRFBWZUd1VlJSeTk1TnJV?=
 =?utf-8?B?cnJKVzVqQjZrbHBMdmR0U3hwWVFsYW9RRHdSNzZkaUNaV3JJWklzeW8wdERu?=
 =?utf-8?B?eTJnUFowVkNPekZIYWg0em1GQmdCQm5idTJoVjBsYkxxQko1ZVpZQzFyRGtx?=
 =?utf-8?B?QkhaZVlDMmpNem5oOG9lbkV0NGtBUVlpTkRZdGxiTkowODYrUGtUUVRaMnc0?=
 =?utf-8?B?SUxUUGRxbFJSMS9wM2FLU2tjYStDUVJyT0xIanRMdEZpNDA3VENBeEgrVGhH?=
 =?utf-8?B?VWM3UGpHUFlpdG55YVI0V3A3aC9kK1VzaWIyMCtRQXhFd3JscnE5cXFDWDBC?=
 =?utf-8?B?NUVTU2hmTTREK0pTQWp3QWNJZ0FIM1hKSk9TSTNLOHlGbVRMTDZXWGc5azIy?=
 =?utf-8?B?ODFOWVQyRGt5cVdQYTdlV0s5YXhjREpTT1NBN2NHZWE0WDZXZC9YTVFZZ3k4?=
 =?utf-8?B?RFQyeHVOaEJUcHBSa2FoOGNxNEpSc1dBbkhtUlVaeVBraWo5M1NsdE1VaStP?=
 =?utf-8?B?NUp3TGxNemsraU9xM1lzYjRvalEyaWF6V0FmUmVHMHhyTTNVc0M2R3ltbmly?=
 =?utf-8?B?elYxaVRENXNpL25pNHR3YXFESmttdjE4eG10QVROY3Q0RDF5aG9TQk5tQkI2?=
 =?utf-8?B?TXNjQWp5eEJxQWtFTjdLMmFkT3dKS1BvcnVHdEdWZ3BpMXNrOG1SS3lsWEM5?=
 =?utf-8?B?eUVmQlRRUVpDV0d6UFk1WHIrY0NRdVpyWGJRRGF6aDZrM0U0SGt2amc2TDRi?=
 =?utf-8?B?Tmxad2Q0b3FjbytxRTgvblFtMVRxTW4vM3lvd1RaMzdnclczY1o4dG9oNzh0?=
 =?utf-8?B?S0tJcUptTmxFditxRURVUVNVeU1zQ21DWUtKVUdJTmp1WlIxWlJieGhRMWxO?=
 =?utf-8?B?Nm9FVDFKazFrZTlyeTUzM2tNK0JGWklZdS9xR1BXZjZXbkU1dDNpbzgwUENh?=
 =?utf-8?B?a3I3cTBpYzVnL09henhGOWlUMjNCRC9MYlRaTkZzRHowSGFrWVZ3Z3g0Mksv?=
 =?utf-8?B?THFYd291UGVWZ1daSndjMm9oS3hqMHlQUlVkeXNVZDR2NTRyTHh2WGhTV0Vp?=
 =?utf-8?B?U0pXdWVodzBjeTJZMXpTcWZoVG1jdVRhWkYzK3BndjZYcHExUjB1Vy95cnRs?=
 =?utf-8?B?c09LOHNYN24vam90bkduR3k1Ujl0OTZ2aGJMQUx2R1M0aGRQdG5ldHRPU1k0?=
 =?utf-8?B?K2NZMCtLQnkzN1V6dmZqMG8wZldPZVRKWFBKdjkvcXNnNEo5U3BJQUwrUEoy?=
 =?utf-8?B?VGFXTzRTMXQ3S0pBQkE0K09ldlREQmxoUjUvM01tZ0Y5aldqT0ZqVUxsSmpX?=
 =?utf-8?B?WUdkZTZDM0ZlT3ZrdmtyNFN4MmtjY09iVFFUVVB4TW1EQThMWFlUaXoxdW8x?=
 =?utf-8?B?QkxkcTAveGVBUGtqcHFwaHZ3Q20vVTZpUUJxbUJtUkFMWjQzNHdQQnliS0Vi?=
 =?utf-8?B?QU1oQzRiZ0VOdmlvRHNyNjMyOER5SGR2NFdXV1VjTTdkTmFkaHFwZnFBNDg2?=
 =?utf-8?B?bG1WZWkzck1vMk93VlJIcU1YblBWZGl4clE5RUVrOUlnSWszaGNwRGk5emZr?=
 =?utf-8?B?UkgwKytGMUF0Tm5wN3JIMVIrd0NFc0xwSlNOYnc4OFZWRkRSejRBaTM2dkNY?=
 =?utf-8?B?WnJHaEpFQ0YrY2ZGcldCc1NEcVNiRmV4ODJpWnFzeFpDQ1MvSStUWDhjU0xH?=
 =?utf-8?B?UGdUUkowWWxvYVVlRjRLY21QMlAzT3hJWTFpYlFMTjY5NjFzbE1qWnFqb3ZC?=
 =?utf-8?B?SjkrdFFRZWNoZVU0QlJPMExoL3E5clhnMDZJRk5OR3ZLZ3RsbC9WM0w5YThm?=
 =?utf-8?B?ZGJ4TjVnRCtsWTFoT1hod3QzTlFxbFJrNXZqTFlYRjlyTVpGVVoyaVBFMVI1?=
 =?utf-8?B?c0E0N0hxMUJqWnZyZmQxVDdCU1dkU2tuZE5BdHNGd2Z2aTIrNWRCOHFwcy8z?=
 =?utf-8?B?QnViZjBlenVzUFBjTkhrOTloUUFYSlRTOWtwbzI2eitzUGxqbXJQTThqN3Fr?=
 =?utf-8?B?MGsvV0ZRTFFyQ1J5b0EyTEV0aVhqWW1ldnQrUmRlZE1VR1dqU0draGtFbnZR?=
 =?utf-8?B?Q0Z3UGNwZkErbENIdzdkei9Bd0YzMTBCRmZDdFF0bGljUEJsdjFPSE9iUzRP?=
 =?utf-8?B?SUxraXdzbml1NTZ1bjh2b2h4OVlHTUU0UE9jcTZ1eW9GbHArSmw1T2RyY1VV?=
 =?utf-8?B?SXZ1cGZjYjZSNUhGNTJKMWVWbjBYYzBqamtEbU1MdHFyc2o3SlN2bUg0bVhx?=
 =?utf-8?B?RlZudXVEaERLUWZVR0JHOU5iVHMwWW1wWHk4SEFuV0dEa1Z0SUlIdzRFMW5W?=
 =?utf-8?B?YWQ5MnJTdzFMaXVlV2pHOU1iKy8xakhkK2YvTTBOQUN1MnJ5SnQyN21QYlMw?=
 =?utf-8?Q?7z9Sw/Y5/8PuaPjU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a106a02a-cd80-4ea5-abd6-08da50c1f6c0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 00:32:02.8047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VYDHHeskZvvDh7tCDXdcVnuKxAQt1ZXAa62Yd6tijvGHGrKnlwbTQbehk1GSqA+vjU0bliUhaaJrK2o4X5S3LwqLiw3OKmVOZ5vrvj5sxLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5198
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_13:2022-06-17,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206180000
X-Proofpoint-GUID: koBQW0aCjjpQe1r3h0fWdj3qiO8bZO_L
X-Proofpoint-ORIG-GUID: koBQW0aCjjpQe1r3h0fWdj3qiO8bZO_L
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-06-16 at 15:38 +1000, Dave Chinner wrote:
> On Sat, Jun 11, 2022 at 02:41:52AM -0700, Allison Henderson wrote:
> > We need to add, remove or modify parent pointer attributes during
> > create/link/unlink/rename operations atomically with the dirents in
> > the
> > parent directories being modified. This means they need to be
> > modified
> > in the same transaction as the parent directories, and so we need
> > to add
> > the required space for the attribute modifications to the
> > transaction
> > reservations.
> > 
> > [achender: rebased, added xfs_sb_version_hasparent stub]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h     |   5 ++
> >  fs/xfs/libxfs/xfs_trans_resv.c | 103 +++++++++++++++++++++++++++
> > ------
> >  fs/xfs/libxfs/xfs_trans_resv.h |   1 +
> >  3 files changed, 90 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h
> > b/fs/xfs/libxfs/xfs_format.h
> > index afdfc8108c5f..96976497306c 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -390,6 +390,11 @@ xfs_sb_has_incompat_feature(
> >  	return (sbp->sb_features_incompat & feature) != 0;
> >  }
> >  
> > +static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
> > +{
> > +	return false; /* We'll enable this at the end of the set */
> > +}
> 
> Just noticed this in passing - I have not looked at the reservation
> calculations at all yet. We don't use "xfs_sb_version" feature
> checks anymore. This goes into xfs_mount.h as a feature flag and we
> use xfs_has_parent_pointers(mp) to check for the feature rather that
> superblock bits.
Sure, will move.  Thx for the reviews!

Allison
> 
> Cheers,
> 
> Dave.

