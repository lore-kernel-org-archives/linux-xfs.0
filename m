Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C8FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 01:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiF3B3p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 21:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiF3B3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 21:29:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887B029823
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:29:43 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TM4VD2001625;
        Thu, 30 Jun 2022 01:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hBlLzM1pUq2vNa/NMlADKSAeUOLlJEmUYZVK3JhKDYM=;
 b=H+kZgyjAKRWrJu/xukw7mj7mAbV1zeaUt4O8BjyUO+bjTXH2P7BSaKW5p58KCL0zqmVQ
 u8sfIKu1SPZMe0yYph7XHx3lRCIeDOmIppCT5R18j8TMdk56vx+b5YC24S15AjWiSbUm
 x3NabrKLXKQo9wMqKvPQi//TvJPhYAXgIA7n9uek+OdV0p2aUHgdIDZh6Tli2hfLmtG5
 IH3m5tPbZrlQyIKI2Ep6YduRlKJeNHm7HNBKe7ejYNFGDiKTk2sGQp+Y3n/n15TEMhLE
 x46yPBzLACUGXLSjbqle19m0w9naNE7ptDJ6iqs8l39PtGKmY6vi5kAlbqntWyma9fk+ cQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwt8a2g5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 01:29:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25U1KPX4024258;
        Thu, 30 Jun 2022 01:29:35 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt3kq70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 01:29:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2qp0nb4uQwF3khULMGJZvHqVVKzLRVFHfk3hAq+0xT2ob4TjLNarDhOVsO0/ACC8W4QidPxzXegZ5R9Z+7PoJrZv0A9FTlO4MeKkDbF4+viRkEBxnpm9zaJL61TS/PBHdqK8S95VMW28YurXxh8T9CMbArjvp++iOLCIxA6DagwQGQZ2A3C2dUIV2WwCgW1LqEPv/bs/O0LMMfmDmtNf6LpHbwsJOADvdfhJNg9rT4fXYRCYnFrh2P07VzmTzjU+Gm7ElaQlAC52TNX9ZB8DVmfSEgXC6UAtngKA1k6MVqjDzVO1AXWLvRXYay2Q8MhMR0b8Fn8FbzaQfVEx2+YXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBlLzM1pUq2vNa/NMlADKSAeUOLlJEmUYZVK3JhKDYM=;
 b=aamzZM86pr7rD4+PoHIatYs8+pJvUQqlEELyTglZjq6g6qG4R/j3i/JfTAu0rAGY3othodhI6OxDCnOxh1+RNSS4Z8fzVIf2gf6zs5jsL9tKKxUssES4x7ar5h+PkU1Gz6cbXjOOyEVxwTDXOesREpTQNdieJIcmq8O6jUOIE9VfbbG1UTymomV2R5e12mlx6+mYauvz55GB+HVhmQkIAkfcLCnZkBsWF3dK6trE342nnYj9FpCn8QfHgZE1tfsjW++QUdZ8IdeJX27UmKYWx9Px5S3tAabGFDfnkjFcj/dvguIA+RQdFkm3xho0dJI71OobP+0BiYNTWx9pmjq6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBlLzM1pUq2vNa/NMlADKSAeUOLlJEmUYZVK3JhKDYM=;
 b=DvRoGdd0mUS739Y+ag3MQLYeZbtdJQ6sEbyckfxpwid6ICd31OsTSEksJS+A8FjVreoFQKCrKm7/IBNeaZjGNBe1Xn7pWHwMnBT+9mFzdq2yetPQDRfBBivXwcCd6MIIPOhNkjhBH8eN7Apni3XLQh3lI7NNoACl8hFC2jJ+jPw=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BN0PR10MB5502.namprd10.prod.outlook.com (2603:10b6:408:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 01:29:33 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3402:abab:e2f5:33bc]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3402:abab:e2f5:33bc%9]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 01:29:33 +0000
Message-ID: <2bce485c9cafaadd4e3640f416e9fbc0cc156eb3.camel@oracle.com>
Subject: Re: [PATCH v1 10/17] xfs: parent pointer attribute creation
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Jun 2022 18:29:29 -0700
In-Reply-To: <YrycxuNGtYUvtYwC@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-11-allison.henderson@oracle.com>
         <YrycxuNGtYUvtYwC@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0029.namprd21.prod.outlook.com
 (2603:10b6:a03:114::39) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ef3bb4d-7ad8-488a-91d1-08da5a37fc2a
X-MS-TrafficTypeDiagnostic: BN0PR10MB5502:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4C8f6NBWebkvJadnH1dhERTnPsJ5XK8e96eIcg8cXlwAGYe2Prdki2y98iT1MWrQRpXLSOxQNq3bVMr9OeRHL4PA9BXj0DzvIHU4xOvgMAFoLLg+6EmRHQsAGEYRAIHx3rvIA7162/g1ZPgVA4qq8Pgi8VIP4kSEz3m/oTosaLwSAUaovYq3UGeKLRLdwDo56XlstIJYglEouilazvCL8ADcMjRiA9Pt84/reuE/ooNj8J1mvmg42WHUy2i0rMUQ8BNiCe/ti2pSMFxCv8tlsUY4xTrVeuv7x75xV0+Cz4/4pNE1noq+pbI+3Rp2miJZqa4siAT+l/xm2n8cV09X1C1rQM3CKLk6kVuvTjVPf7x97ew7n3It7IyIwWSAMBES8MWT8J8nFVUGbIKvAH1ysijQhNW/DxwMzygIzNMbyFwoujWbObO1o+NdUN8vwGF+d6R7bKgSz6RWWZUy+QGyGq2Dc/a4Rp6EMiSVtKST7WYh0oy6CNL8AZjoxJbTPyzU0gt6YyyKJYtoRvC019F9niIPwVarLRW+uHn3Kk3X4z40XYBSw9T6HY2zbQOWPzx2W3GVlgQuC3gbyUkUwl7+DXiSSi6u3GkeX5rl/kYyaCc0ZcTOuT4IOa7ImYG2U2O0s2VRIgCwew16JJBOZLaCOp2eKFBVFn8jqe1NnwmF9bdRRjJUhSmBB7CrEhij9xABGCcC7U01Us64XFtBE4nW6gyzOhfnl3gphbq0JHuFiGX/g+KDzDfddVrxxZB94QvEDU7GtQ+Xc4mG1rf8RuvfYhU1ys7ahOqYNAmjIH+vs305ddsXQK1a8h7NOfEwTzfd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(39860400002)(136003)(396003)(38350700002)(6486002)(86362001)(38100700002)(2906002)(8936002)(5660300002)(41300700001)(316002)(30864003)(478600001)(6666004)(8676002)(4326008)(66946007)(66556008)(66476007)(186003)(83380400001)(6506007)(52116002)(2616005)(26005)(6512007)(6916009)(36756003)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekx0MWwxYUhJS0J5ejRNMTFxQ3lyTG9xUDgzbVd1Uit1TGtpUkJLYXA1aFpN?=
 =?utf-8?B?M0NLM2cxN1cwN1BicDNDY29DY2lYeW1hWlIyZXhQTVlRc2hseDlJTEx2SEtm?=
 =?utf-8?B?cUZoa0FJb2YyaGk0bGZMdFhVaDRoQ2x3QWlCRzFrZGFweWppaEZZQlgrL0V5?=
 =?utf-8?B?TUFlaTJyYU1tTE9zZG1kWGF2QmYrQUhzamFac09uTlhwRFFnRE5YaWh6bTJR?=
 =?utf-8?B?OFZUbjllM29zcWd0c1BQVFhNSmVzRXlYVUdsN21qWlRlK2ltOXAyV3d1Q0I5?=
 =?utf-8?B?dmQ2SWNqendJTlptVUNFQ0FJUlkzbTZtWGVqQjZobXJCVXp6ejN3VHE0SjhU?=
 =?utf-8?B?Y2d1bnBpOEVtWlZIU0NOcHZiQS9sK243YURlVkpDdWc2eTdpWUhyZUZnOXN4?=
 =?utf-8?B?T21XcDZUdjg1cXpzeGRlUUNiVHdRTzA3aUFla2VKK1RCdUo4T294RUNyZG5C?=
 =?utf-8?B?NTZVdk5GdFZOV1c0MnA5QVNlYTMwR3U4NTZNaW1HWW80YXFFM2xtL29rUzFu?=
 =?utf-8?B?a29jNmtEMnV5M0UvSXNjL3F2VVFNMVFNMC91N1E0M0lmWEJrM1VtbUI3TGhG?=
 =?utf-8?B?Vjhqc0lpWTRuWkRnNVhOWXNNMmp4K0Q3TzV0aE9LdDlVSEN6MFlGdk9pMGJ3?=
 =?utf-8?B?Tkl4T25mYjI5a1VCeGFPYjlRVndrZkluUWNKVnRiLzV1NWlEUVIzWXBCNW03?=
 =?utf-8?B?SkpBaTJIeGhsZFNuVjkwbDdody82amtURHllRkhOVDJ6SGtPcFRoQmh5S000?=
 =?utf-8?B?STZ2OFFQSlhKczdXWHpxZzJvdEU1aVV5UTQwUjhnRnZwWlA4OHd1STJHaTd3?=
 =?utf-8?B?YmlpOFg1bnJUbTU2c0w0N1FlZWd6dlhWdVVqV1NuUVlER0d2UHRPSUJ3bmZB?=
 =?utf-8?B?RUowMDIyV2t5VE15aGpsSnFiZjFiUGZEaWV2MWhOWjRCNmVFc05KWmowYTQ0?=
 =?utf-8?B?a1ZvS25SUzVxMlhZZGtsSzhISjBneXVzN0IwaXFKWCtUQitZdm5vdWIwM2Ir?=
 =?utf-8?B?MkFJc2NHMHU3cFdVTVBHbFlJTGdKWFdOVExyWVRRR3QxL2ZQZmpjNUh6djZJ?=
 =?utf-8?B?R2pxRnptVUJhQzRaSG1GREZIbXphMWg1YnpVSVVqN005ZlR1dVIrM0FjdWRZ?=
 =?utf-8?B?WGNnOENQMVphNDZzZG14L2FXMHYyRGJITnc3MUJWZmVDbjVPaUpWNTYyUnUw?=
 =?utf-8?B?SzQ5NVVyOHBRM1lNN0VaMFgrTFkwNFd6bUlJbkZuZVNUWXJaZmwxYVZhaURw?=
 =?utf-8?B?RThZYXdKV0Nwem5sd1NiM2owMFY0NGc1bFNxdTBHLzdLWThVMVNPcWRDaDI4?=
 =?utf-8?B?Z3RzYURrWXlsSTkzUGZRSnZTYkhVeEJ1UzZKd0pvTkVhM3BuYTkwQU1XdDJX?=
 =?utf-8?B?OHlnYmhPNXRRNGpSbXZDWWpkTGx5M0wxZkxVSHVScVdZcnBiZTRPQ2ZPS0d0?=
 =?utf-8?B?bms1d2FJdktKcGhSbHdTY051YmFrdGpETjg1MExwR2s2aEFUSEtHV2lCV245?=
 =?utf-8?B?MlduUlgreFhHaE9qSTF3SmRwZFZkMVdyQXQ0czU0NVlPUUl5eSs3OTNCQUlX?=
 =?utf-8?B?Tkp5d2ZrRFBqWU1lZ0E2U2VCQWxtZHYzZ2lSeWZWWVVzTyttZjJDQmtvSjFK?=
 =?utf-8?B?TENDV1crRUVNWW9zVGl6QXIvNE43dlFvTWVCMFh4RE0wVExtVUhSeXg1Mzd0?=
 =?utf-8?B?Tmg1RVdOemt6NDZVdmpXMysvWk9vcit4WlVnUHFOcnhKWnhHWllaR0ZYendU?=
 =?utf-8?B?Nk9XSnFPTTJlbWhqSDlQQmxsWXk4L015TVJlUlUxNXFUdWxiZ0ZQZEVtei95?=
 =?utf-8?B?Sk1zK1hZRnA1U05zV05NS0tlTVFnZEFTelZiRkZnNmNCR0tBT256d0ZuZnlE?=
 =?utf-8?B?VXdSTzlRcFBJYW5WOWhhWllsMG5lWlppNlV0ZW5CTU1qRWdCK29aMDhicWtW?=
 =?utf-8?B?bUFzblBwQVk2MFRUTEd2d3h4bE9ZdVRwdWZ4aHduR3FXSk44dDBGTElabHZw?=
 =?utf-8?B?dlAwZk5XVjNvR2FOVGtQYWYyR2U5VnNreXB2QmwwRWpFTzRId2pXOTRzbExG?=
 =?utf-8?B?WlBmNDJ2RGE3RnRxd1BCMTFMam8zVmgwYU9CUDVIQkV0WURTSnlDMUtoUkM2?=
 =?utf-8?B?TE5CcFZqZ0Z3N056bm0vM2VNL2ZSMmJBMFJnT3MzNWhoVkxLSTJCNG5WMk9k?=
 =?utf-8?B?WVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef3bb4d-7ad8-488a-91d1-08da5a37fc2a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 01:29:33.1071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hc6UP2yf/4ATg6O5XCvxOlX5RCW6jkLl4J6SqeAO94lZMlJWgqcsUO/xHJRKeUygK7vaRTO2G+2A2zhZv76J61LN9El1RtJxbRf4NYg0tWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5502
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-29_24:2022-06-28,2022-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206300003
X-Proofpoint-ORIG-GUID: D2kjoFVvaq9sO1SWv4aFmbsprkR6E_F4
X-Proofpoint-GUID: D2kjoFVvaq9sO1SWv4aFmbsprkR6E_F4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-06-29 at 11:41 -0700, Darrick J. Wong wrote:
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
> > 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index b056cfc6398e..fc717dc3470c 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -40,6 +40,7 @@ xfs-y				+= $(addprefix
> > libxfs/, \
> >  				   xfs_inode_fork.o \
> >  				   xfs_inode_buf.o \
> >  				   xfs_log_rlimit.o \
> > +				   xfs_parent.o \
> >  				   xfs_ag_resv.o \
> >  				   xfs_rmap.o \
> >  				   xfs_rmap_btree.o \
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 30c8d9e9c2f1..f814a9177237 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -926,7 +926,7 @@ xfs_attr_intent_init(
> >  }
> >  
> >  /* Sets an attribute for an inode as a deferred operation */
> > -static int
> > +int
> >  xfs_attr_defer_add(
> >  	struct xfs_da_args	*args)
> >  {
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index a87bc503976b..576062e37d11 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -559,6 +559,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
> >  bool xfs_attr_is_leaf(struct xfs_inode *ip);
> >  int xfs_attr_get_ilocked(struct xfs_da_args *args);
> >  int xfs_attr_get(struct xfs_da_args *args);
> > +int xfs_attr_defer_add(struct xfs_da_args *args);
> >  int xfs_attr_set(struct xfs_da_args *args);
> >  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
> >  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> > diff --git a/fs/xfs/libxfs/xfs_parent.c
> > b/fs/xfs/libxfs/xfs_parent.c
> > new file mode 100644
> > index 000000000000..cb546652bde9
> > --- /dev/null
> > +++ b/fs/xfs/libxfs/xfs_parent.c
> > @@ -0,0 +1,77 @@
> > +/*
> 
> New files need an SPDX header.
ok, will fix
> 
> > + * Copyright (c) 2015 Red Hat, Inc.
> > + * All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be
> > useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > License
> > + * along with this program; if not, write the Free Software
> > Foundation
> 
> No need for all this boilerplate once you've switched to SPDX tags.
> 
yep, will remove
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_format.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_bmap_btree.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_error.h"
> > +#include "xfs_trace.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_da_btree.h"
> > +#include "xfs_attr.h"
> > +#include "xfs_da_btree.h"
> > +#include "xfs_attr_sf.h"
> > +#include "xfs_bmap.h"
> > +
> > +/*
> > + * Parent pointer attribute handling.
> > + *
> > + * Because the attribute value is a filename component, it will
> > never be longer
> > + * than 255 bytes. This means the attribute will always be a local
> > format
> > + * attribute as it is xfs_attr_leaf_entsize_local_max() for v5
> > filesystems will
> > + * always be larger than this (max is 75% of block size).
> > + *
> > + * Creating a new parent attribute will always create a new
> > attribute - there
> > + * should never, ever be an existing attribute in the tree for a
> > new inode.
> > + * ENOSPC behavior is problematic - creating the inode without the
> > parent
> > + * pointer is effectively a corruption, so we allow parent
> > attribute creation
> > + * to dip into the reserve block pool to avoid unexpected ENOSPC
> > errors from
> > + * occurring.
> > + */
> > +
> > +
> > +/* Initializes a xfs_parent_name_rec to be stored as an attribute
> > name */
> > +void
> > +xfs_init_parent_name_rec(
> > +	struct xfs_parent_name_rec	*rec,
> > +	struct xfs_inode		*ip,
> > +	uint32_t			p_diroffset)
> > +{
> > +	xfs_ino_t			p_ino = ip->i_ino;
> > +	uint32_t			p_gen = VFS_I(ip)->i_generation;
> > +
> > +	rec->p_ino = cpu_to_be64(p_ino);
> > +	rec->p_gen = cpu_to_be32(p_gen);
> > +	rec->p_diroffset = cpu_to_be32(p_diroffset);
> > +}
> > +
> > +/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec
> > */
> > +void
> > +xfs_init_parent_name_irec(
> > +	struct xfs_parent_name_irec	*irec,
> > +	struct xfs_parent_name_rec	*rec)
> 
> Should this second arg be const struct xfs_parent_name_rec* ?
> 
I guess it could be, but now that I look harder at it, it's not
actually used.  I suspect it was likely just a suggestion from an older
review to add it as a sort of utility function, but with out an actuall
call, maybe we should just take it out

> > +{
> > +	irec->p_ino = be64_to_cpu(rec->p_ino);
> > +	irec->p_gen = be32_to_cpu(rec->p_gen);
> > +	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_parent.h
> > b/fs/xfs/libxfs/xfs_parent.h
> > new file mode 100644
> > index 000000000000..10dc576ce693
> > --- /dev/null
> > +++ b/fs/xfs/libxfs/xfs_parent.h
> > @@ -0,0 +1,31 @@
> > +/*
> > + * Copyright (c) 2018 Oracle, Inc.
> 
> New file needs an SPDX header, and you should probably update the
> copyright to be 2018-2022.
will fix

> 
> > + * All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be
> > useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > License
> > + * along with this program; if not, write the Free Software
> > Foundation Inc.
> 
> No need for all this boilerplate once you've switched to SPDX tags.
> 
> > + */
> > +#ifndef	__XFS_PARENT_H__
> > +#define	__XFS_PARENT_H__
> > +
> > +#include "xfs_da_format.h"
> > +#include "xfs_format.h"
> 
> Don't include headers in headers.  If it's really a mess to add these
> two to every single .c file, then just add:
> 
> struct xfs_inode;
> struct xfs_parent_name_rec;
> struct xfs_parent_name_irec;
> 
> and that'll do for pointers.
> 
Alrighty, will do

> > +
> > +/*
> > + * Parent pointer attribute prototypes
> > + */
> > +void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
> > +			      struct xfs_inode *ip,
> > +			      uint32_t p_diroffset);
> > +void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
> > +			       struct xfs_parent_name_rec *rec);
> > +#endif	/* __XFS_PARENT_H__ */
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
> 
> Convert the struct typedefs...
> 
Ok, thx for the reviews!
Allison

> --D
> 
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
> > diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
> > index 2b09133b1b9b..3fd6520a4d69 100644
> > --- a/fs/xfs/xfs_xattr.h
> > +++ b/fs/xfs/xfs_xattr.h
> > @@ -7,6 +7,7 @@
> >  #define __XFS_XATTR_H__
> >  
> >  int xfs_attr_change(struct xfs_da_args *args);
> > +int xfs_attr_grab_log_assist(struct xfs_mount *mp);
> >  
> >  extern const struct xattr_handler *xfs_xattr_handlers[];
> >  
> > -- 
> > 2.25.1
> > 

