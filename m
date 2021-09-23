Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C90DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 05:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6970B611C6
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 05:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhIWF57 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 01:57:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4708 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229645AbhIWF56 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Sep 2021 01:57:58 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18N5X6Ef006477;
        Thu, 23 Sep 2021 05:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=E7i4GkA7gWc9owEyj/YfX0YqOuAhcNykJZiDalH+lYo=;
 b=dcgGUSn7h/9D32LZO3xyFNsTW7uVf1fHD6PA/a2BIU2syxb/2qRlKW9+WJ5PrtC9L/BA
 l8QzBPqbNZvtjZicGvxBrF5jBEr6gwTd80Q23PntGSsZaBTw/sbs15+guhB1/Hea/WWY
 NAIQ1ygwWH12amHVIUtBqX1NgPKkdhxi1dPVrBUIl1pmko8/Xwu06LxVQtgS8cAYhcsQ
 uuJqyPU2y34nDKjUXDiNJgvjF2M1lT4EBLXmekZ9jU5CFA8cEnM2yTJZfP1uOvgfx/gi
 9sYlqLYfOZVXqYs/+KpyafqXz2Ygh+Kk5IGyA+opLKRFVrGDM9vgisv4fVroY8p4GzY/ Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4p8evw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 05:56:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18N5o4QA074827;
        Thu, 23 Sep 2021 05:56:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 3b7q5x9dbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 05:56:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/kaOX1P6E7QmMu6L05TqrXl7sH/9ySuyRHIFsF7DYkP3hrKHLYZtEB6WnFsKBbj0cEs5f+/M1DcXU+YG6F2M6U7sHjtA+kBusv9i5EEgOLHZG66H1aAfFEJmFEiVGt0zCJYUb8V998FzkSsphk5BZzEcdjbaIHdaWz+0yF/eBSDhahgILluA0nAlFdLihy2MeNH1/QMI/3teTH3I/InMaWUnpZQJa6YYDZ5D1hBHjyZXkItriQ5Ju+y6qefd+9aksQBQxDFtd/MUYGatZXLo3UG1vG5SgIIm939/YyuSuS2a+WzFcgKHjFso/6iozoNqli1lHXObCR3TCVc1MTE8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=E7i4GkA7gWc9owEyj/YfX0YqOuAhcNykJZiDalH+lYo=;
 b=eLgoHublgyyoLMdb9CO//pvoVYRt3pnwd+R//Uq3/puh8nrqsYjSoSpKBuoVNTXmqkiRTYGsWbfqBzTyQc7LCKctz4NvaZH/HtG7gvrXIjCl/XKYVY+mwDMaIm+2KWU0COhvHEU9ZU3XhdD32DZDMmqDNpbrlFcbW+Fp3HkrO020TQd9cAo+DOJ/jt6VaZNpE9mx2ytq3NxM3sABWgyIZR11N4qpXYcVHFlZUlxdCbH+qeZhmF4/fK/IOEvkUhgfyrav6smvXa8Pfn153a9kCckRa5rIJZx7HYxz3F6DDMPruNp627Tfni3w5IbprcLlS99AqCZG/ikag/PdBmNVQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7i4GkA7gWc9owEyj/YfX0YqOuAhcNykJZiDalH+lYo=;
 b=dS17vOZvrRdqq8jCpmLlKuEqX7xkaFp8Xx3AQEcwoejpUX8oDAQQPtrNdMKl1Fzh09aTLFdsTcZQVCJfe4F6EiHHw/M5mbCJywUYw6v7kELdJ5rM+pC7TE8ZrSyif4BOHXIfrqJrMlOTI758Cr+8CdJfI1Gcztxnw4AfKQusFE4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2749.namprd10.prod.outlook.com (2603:10b6:805:4b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Thu, 23 Sep
 2021 05:56:21 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 05:56:15 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192861018.416199.11733078081556457241.stgit@magnolia>
 <20210920230635.GM1756565@dread.disaster.area>
 <20210922173821.GH570615@magnolia>
 <20210922231015.GU1756565@dread.disaster.area>
 <20210923015848.GR570615@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: dynamically allocate cursors based on maxlevels
In-reply-to: <20210923015848.GR570615@magnolia>
Message-ID: <878rznltse.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 23 Sep 2021 11:26:01 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0180.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.179.108.138) by MA1PR01CA0180.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Thu, 23 Sep 2021 05:56:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b74527f-94c7-4143-ab33-08d97e56da4b
X-MS-TrafficTypeDiagnostic: SN6PR10MB2749:
X-Microsoft-Antispam-PRVS: <SN6PR10MB274943746BCB073D3EF4C632F6A39@SN6PR10MB2749.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GFEoYcWkP/ZXerlPZeqUvX4P6G0RqAl/sqmRWirfk9jxpCtkgFQIvxNCqU08a8vi714C76QIFCH+qX1oJg6oS2GwRGKcqNOqg7Mi8scGY2HMwK+L9mAlDNlHVo7uhaOhbdq/ikGfi+AkXkZSOYN6SZYmBLdIK/lnEU/DHHr4h1Xh05ha4P8dydgn77WWzheMq4kStodUFCJyzucrYMQ4Us0xCCyKae02gFpaGJVf1AvydL3gy6HLjMuX+oy+nVrZJzKNsCYrOnlRhTzr1WWbWrU4fUvR50l6kWWGALznyrswq4a30kuZI3wDr/KH0iVHk90ITwqpT7rppPbqZ7e6R7x7FM4BL1GkW9Q0aMLA8Xr/51o4gI0hA1tqGmnBRw8LZHbiUp4iOVHQbhi0AXhkOiwYjFUqyAoq8uTIk16ii1xJUd+H3CaALeAMMtLTVLHb8rLpRl/hSjRWjn0UOsrlgS1st+CxGwnlyRovyQJolUrQS0J5eFiZlVhRqTL8ttQ1czg3jImKZybBUYweGaMdEWtn/waPuwtFiJzjc01DXsRAhiCaobqi4fn4U4TYcxCh0QV3eeKd4GpO1PX4BDbwlcBCy6jHS0yCt16O+ELIE3sIDiagCc1Tio3TBSOUg1WphEECjxvhDBfhg9tuhclxvmH2ow79DQkDENTadYFFFgsfHDPmx1QKELK5fbEajkC2Usz6GDtryn4MWGuxGVEX7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(9686003)(8676002)(5660300002)(6916009)(38100700002)(6496006)(186003)(508600001)(8936002)(30864003)(66946007)(66476007)(83380400001)(66556008)(38350700002)(316002)(53546011)(86362001)(6666004)(4326008)(52116002)(6486002)(33716001)(956004)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QYoW5E0iymF161TaZbPUg06K1MIFvyTLvmwbsvOMjtnMyXVSzXUF3aZfkx5A?=
 =?us-ascii?Q?lATVUjijGnei+GKaxRV783qQDx3VJ0qWJxav4FrvG3W0bZ5M+m1BJlklRWic?=
 =?us-ascii?Q?r/VZCktD6z9sVu5Vz9OWCEELEeE5VBKPX+j/q+C77ZBu9dh5/Ws0h3vVltq3?=
 =?us-ascii?Q?aFTAnzqYJmmpCKquFSb/WRsA4yke/0Jb1kjQwOKC4AOllLgVkn7zLwvzMr1Z?=
 =?us-ascii?Q?vUU+F5WP1PoOuqsrWfZorKjrFU1tXXwI9ZjJS2clqQFOeElfQ+Q3HBxUp7VE?=
 =?us-ascii?Q?crM7UclLTxWROTrMm+lHBX0vdHg3RFjiYDIHBmRH5OPMFM7pM8/L/M6U/aJo?=
 =?us-ascii?Q?/3cSIZyLgrgkwp0xrJeGk2psWIAOcmaQKqxZ7+5D+wru7bJvUBfTxF7IXLlC?=
 =?us-ascii?Q?/FnqHmCMEKSfwWKJc/GGMyJxJbCR5/p5QKo+z6lifWyDB0v4Vl4qzTflIwQG?=
 =?us-ascii?Q?Ho6MI24ed3UqXO8MT8dbsXLH7QtUTpBaqnA34oFZ0zy8uLA86ngFH0gtJqHk?=
 =?us-ascii?Q?WmsTiTbcX59SM8q/k/NR2gCuo20gVGQy+R5008tAA6vArPzTjI07Ht7K/deD?=
 =?us-ascii?Q?G1Wbjsg4SDfeCsa/rTa/v7CR6iRTsvWXkDoF+9qPz/Eoq3yoHGtJT72wsNKj?=
 =?us-ascii?Q?/bjDbsF7yHET5B8oEQrSnx36kYcoQCxQedJ12fNhlL1W01gsDgt5d5/z9hmK?=
 =?us-ascii?Q?Jx4ioJ4sIZMC/Dhvjmh/XNLwUDwQq31clNixogsvoaNy3iy4jSoJp6x7azeG?=
 =?us-ascii?Q?IcjT/8pKJvwkHpsTW/3im4S6ddiYyG9MVB/twe2CL+q2hKge1xvVII4Jf0pD?=
 =?us-ascii?Q?Ar7sXS8mye1PG9vRLq8ohfd+r6lM8PmC447dQV8W98Nod7EKKISXk7utjaNz?=
 =?us-ascii?Q?Z5ZdjntB0F2mYaflQZkayd5XEsH2FimTXSxXGf/xs4XqDrqcCtPExoR1V6+T?=
 =?us-ascii?Q?HMpkrk/M1b8HVUPMCiyEKjL0S9jxd+mNl5blxT990adMdhSiE3i4Vbv8i6yA?=
 =?us-ascii?Q?fSG9X+sE6lJ/V3KBRdvr6IY9sP55PMGqO3IgrXxWZ1+HE7A4Pvlbv/CLTFyn?=
 =?us-ascii?Q?dQBP41DcDqWoHMJTw2loioUtG28UKg2ZJ9kfsW450lQvf0YicOC8nEJWcZAB?=
 =?us-ascii?Q?ayCz07mpshJbZ8O38Fn/ZwvSPC9wo6anZEbTuv4VlDdqytK1Pm/xwqJ+3UW3?=
 =?us-ascii?Q?b9cJxfwZr9S+Wrh6YatrfrG7QX4tALx3yRHxwZk0vXHVDQwFT9UczvNh/Tr2?=
 =?us-ascii?Q?34JptGOWBIXxBnN6bczK38w3fwpaUY8MeQgW7tier0UMkNMguFtK8fD+4Dzh?=
 =?us-ascii?Q?VZ9C5jQILP7mWQvOD715gwn3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b74527f-94c7-4143-ab33-08d97e56da4b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 05:56:15.0727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3/jgwYOCGthqeCYNXN81hfk+mVCKL9gfwKyEhWY2DVjD9lTATUfypMFj5X1aoh0eXp2gWVEmkc94PH7P6MgvXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2749
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10115 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109200000
 definitions=main-2109230036
X-Proofpoint-GUID: 8tSsEkNOxPqpy76mA2Gi6lK2kkDZeYmt
X-Proofpoint-ORIG-GUID: 8tSsEkNOxPqpy76mA2Gi6lK2kkDZeYmt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 23 Sep 2021 at 07:28, Darrick J. Wong wrote:
> On Thu, Sep 23, 2021 at 09:10:15AM +1000, Dave Chinner wrote:
>> On Wed, Sep 22, 2021 at 10:38:21AM -0700, Darrick J. Wong wrote:
>> > On Tue, Sep 21, 2021 at 09:06:35AM +1000, Dave Chinner wrote:
>> > > On Fri, Sep 17, 2021 at 06:30:10PM -0700, Darrick J. Wong wrote:
>> > > >  /* Allocate a new btree cursor of the appropriate size. */
>> > > >  struct xfs_btree_cur *
>> > > >  xfs_btree_alloc_cursor(
>> > > > @@ -4935,13 +4956,16 @@ xfs_btree_alloc_cursor(
>> > > >  	xfs_btnum_t		btnum)
>> > > >  {
>> > > >  	struct xfs_btree_cur	*cur;
>> > > > +	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
>> > > >  
>> > > > -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>> > > > +	ASSERT(maxlevels <= XFS_BTREE_MAXLEVELS);
>> > > > +
>> > > > +	cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
>> > > 
>> > > Instead of multiple dynamic runtime calculations to determine the
>> > > size to allocate from the heap, which then has to select a slab
>> > > based on size, why don't we just pre-calculate the max size of
>> > > the cursor at XFS module init and use that for the btree cursor slab
>> > > size?
>> > 
>> > As part of developing the realtime rmapbt and reflink btrees, I computed
>> > the maximum theoretical btree height for a maximally sized realtime
>> > volume.  For a realtime volume with 2^52 blocks and a 1k block size, I
>> > estimate that you'd need a 11-level rtrefcount btree cursor.  The rtrmap
>> > btree cursor would have to be 28 levels high.  Using 4k blocks instead
>> > of 1k blocks, it's not so bad -- 8 for rtrefcount and 17 for rtrmap.
>> 
>> I'm going to state straight out that 1k block sizes for the rt
>> device are insane. That's not what that device was intended to
>> support, ever. It was intended for workloads with -large-,
>> consistent extent sizes in large contiguous runs, not tiny, small
>> random allocations of individual blocks.
>> 
>> So if we are going to be talking about the overhead RT block
>> management for new functionality, we need to start by putting
>> reasonable limits on the block sizes that the RT device will support
>> such features for. Because while a btree might scale to 2^52 x 1kB
>> blocks, the RT allocation bitmap sure as hell doesn't. It probably
>> doesn't even scale at all well above a few million blocks for
>> general usage.
>> 
>> Hence I don't think it's worth optimising for these cases when we
>> think about maximum btree sizes for the cursors - those btrees can
>> provide their own cursor slab to allocate from if it comes to it.
>> 
>> Really, if we want to scale RT devices to insane sizes, we need to
>> move to an AG based structure for it which breaks up the bitmaps and
>> summary files into regions to keep the overhead and max sizes under
>> control.
>
> Heh.  That just sounds like more work that I get to do...
>
>> > I don't recall exactly what Chandan said the maximum bmbt height would
>> > need to be to support really large data fork mapping structures, but
>> > based on my worst case estimate of 2^54 single-block mappings and a 1k
>> > blocksize, you'd need a 12-level bmbt cursor.  For 4k blocks, you'd need
>> > only 8 levels.

With 2^48 = 280e12 as the maximum extent count,
- 1k block size
  - Minimum number of records in leaf = 29
  - Minimum number of records in node = 29
  - Maximum height of BMBT = 10 (i.e. 1 more than the current value of
    XFS_BTREE_MAXLEVELS)
    |-------+------------+-----------------------------|
    | Level | nr_records | Nr blocks = nr_records / 29 |
    |-------+------------+-----------------------------|
    |     1 |     280e12 |                      9.7e12 |
    |     2 |     9.7e12 |                       330e9 |
    |     3 |      330e9 |                        11e9 |
    |     4 |       11e9 |                       380e6 |
    |     5 |      380e6 |                        13e6 |
    |     6 |       13e6 |                       450e3 |
    |     7 |      450e3 |                        16e3 |
    |     8 |       16e3 |                       550e0 |
    |     9 |      550e0 |                        19e0 |
    |    10 |       19e0 |                           1 |
    |-------+------------+-----------------------------|
- 4k block size
  - Minimum number of records in leaf = 125
  - Minimum number of records in node = 125
  - Maximum height of BMBT = 7
    |-------+------------+------------------------------|
    | Level | nr_records | Nr blocks = nr_records / 125 |
    |-------+------------+------------------------------|
    |     1 |     280e12 |                       2.2e12 |
    |     2 |     2.2e12 |                         18e9 |
    |     3 |       18e9 |                        140e6 |
    |     4 |      140e6 |                        1.1e6 |
    |     5 |      1.1e6 |                        8.8e3 |
    |     6 |      8.8e3 |                         70e0 |
    |     7 |       70e0 |                            1 |
    |-------+------------+------------------------------|

Hence if we are creating different btree cursor zones, then size of a BMBT
cursor object should be calculated based on the tree having a maximum height
of 10.

>> 
>> Yup, it's not significantly different to what we have now.
>> 
>> > The current XFS_BTREE_MAXLEVELS is 9, which just so happens to fit in
>> > 248 bytes.  I will rework this patch to make xfs_btree_cur_zone supply
>> > 256-byte cursors, and the btree code will continue using the zone if 256
>> > bytes is enough space for the cursor.
>> >
>> > If we decide later on that we need a zone for larger cursors, I think
>> > the next logical size up (512 bytes) will fit 25 levels, but let's wait
>> > to get there first.
>> 
>> I suspect you may misunderstand how SLUB caches work. SLUB packs
>> non-power of two sized slabs tightly to natural alignment (8 bytes).
>> e.g.:
>> 
>> $ sudo grep xfs_btree_cur /proc/slabinfo
>> xfs_btree_cur       1152   1152    224   36    2 : tunables    0 0    0 : slabdata     32     32      0
>> 
>> SLUB is using an order-1 base page (2 pages), with 36 cursor objects
>> in it. 36 * 224 = 8064 bytes, which means it is packed as tightly as
>> possible. It is not using 256 byte objects for these btree cursors.
>
> Ahah, I didn't realize that.  Yes, taking that into mind, the 256-byte
> thing is unnecessary.
>
>> If we allocate these 224 byte objects _from the heap_, however, then
>> the 256 byte heap slab will be selected, which means the object is
>> then padded to 256 bytes -by the heap-. The SLUB allocator does not
>> pad the objects, it's the heap granularity that adds padding to the
>> objects.
>> 
>> This implicit padding of heap objects is another reason we don't
>> want to use the heap for anything we frequently allocate or allocate
>> in large amounts. It can result in substantial amounts of wasted
>> memory.
>> 
>> IOWs, we don't actually care about object size granularity for slab
>> cache allocated objects.
>> 
>> However, if we really want to look at memory usage of struct
>> xfs_btree_cur, pahole tells me:
>> 
>> 	/* size: 224, cachelines: 4, members: 13 */
>> 
>> Where are the extra 24 bytes coming from on your kernel?
>
> Not sure.  Can you post your pahole output?
>
>> It also tells me that a bunch of space that can be taken out of it:
>> 
>> - 4 byte hole that bc_btnum can be moved into.
>> - bc_blocklog is set but not used, so it can go, too.
>> - bc_ag.refc.nr_ops doesn't need to be an unsigned long
>
> I'll look into those tomorrow.
>
>> - optimising bc_ra state. That just tracks if
>>   the current cursor has already done sibling readahead - it's two
>>   bits per level , held in a int8_t per level. Could be a pair of
>>   int16_t bitmasks if maxlevel is 12, that would save another 8
>>   bytes. If maxlevel == 28 as per the rt case above, then a pair of
>>   int32_t bitmasks saves 4 bytes for 12 levels and 20 bytes bytes
>>   for 28 levels...
>
> I don't think that optimizing bc_ra buys us much.  struct
> xfs_btree_level will be 16 bytes anyway due to alignment of the xfs_buf
> pointer, so we might as well use the extra bytes.
>
>> Hence if we're concerned about space usage of the btree cursor,
>> these seem like low hanging fruit.
>> 
>> Maybe the best thing here, as Christoph mentioned, is to have a set
>> of btree cursor zones for the different size limits. All the per-ag
>> btrees have the same (small) size limits, while the BMBT is bigger.
>> And the RT btrees when they arrive will be bigger again. Given that
>> we already allocate the cursors based on the type of btree they are
>> going to walk, this seems like it would be pretty easy to do,
>> something like the patch below, perhaps?
>
> Um... the bmbt cache looks like it has the same size as the rest?
>
> It's not so hard to make there be separate zones though.
>
> --D
>
>> Cheers,
>> 
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
>> 
>> xfs: per-btree cursor slab caches
>> ---
>>  fs/xfs/libxfs/xfs_alloc_btree.c    |  3 ++-
>>  fs/xfs/libxfs/xfs_bmap_btree.c     |  4 +++-
>>  fs/xfs/libxfs/xfs_btree.c          | 28 +++++++++++++++++++++++-----
>>  fs/xfs/libxfs/xfs_btree.h          |  6 +++++-
>>  fs/xfs/libxfs/xfs_ialloc_btree.c   |  4 +++-
>>  fs/xfs/libxfs/xfs_refcount_btree.c |  4 +++-
>>  fs/xfs/libxfs/xfs_rmap_btree.c     |  4 +++-
>>  fs/xfs/xfs_super.c                 | 30 ++++++++++++++++++++++++++----
>>  8 files changed, 68 insertions(+), 15 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
>> index 6746fd735550..53ead7b98238 100644
>> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
>> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
>> @@ -20,6 +20,7 @@
>>  #include "xfs_trans.h"
>>  #include "xfs_ag.h"
>>  
>> +struct kmem_cache	*xfs_allocbt_cur_zone;
>>  
>>  STATIC struct xfs_btree_cur *
>>  xfs_allocbt_dup_cursor(
>> @@ -477,7 +478,7 @@ xfs_allocbt_init_common(
>>  
>>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
>>  
>> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>> +	cur = kmem_cache_zalloc(xfs_allocbt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>>  
>>  	cur->bc_tp = tp;
>>  	cur->bc_mp = mp;
>> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
>> index 72444b8b38a6..e3f7107ce2e2 100644
>> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
>> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
>> @@ -22,6 +22,8 @@
>>  #include "xfs_trace.h"
>>  #include "xfs_rmap.h"
>>  
>> +struct kmem_cache	*xfs_bmbt_cur_zone;
>> +
>>  /*
>>   * Convert on-disk form of btree root to in-memory form.
>>   */
>> @@ -552,7 +554,7 @@ xfs_bmbt_init_cursor(
>>  	struct xfs_btree_cur	*cur;
>>  	ASSERT(whichfork != XFS_COW_FORK);
>>  
>> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>> +	cur = kmem_cache_zalloc(xfs_bmbt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>>  
>>  	cur->bc_tp = tp;
>>  	cur->bc_mp = mp;
>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>> index 298395481713..7ef19f365e33 100644
>> --- a/fs/xfs/libxfs/xfs_btree.c
>> +++ b/fs/xfs/libxfs/xfs_btree.c
>> @@ -23,10 +23,6 @@
>>  #include "xfs_btree_staging.h"
>>  #include "xfs_ag.h"
>>  
>> -/*
>> - * Cursor allocation zone.
>> - */
>> -kmem_zone_t	*xfs_btree_cur_zone;
>>  
>>  /*
>>   * Btree magic numbers.
>> @@ -379,7 +375,29 @@ xfs_btree_del_cursor(
>>  		kmem_free(cur->bc_ops);
>>  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
>>  		xfs_perag_put(cur->bc_ag.pag);
>> -	kmem_cache_free(xfs_btree_cur_zone, cur);
>> +
>> +	switch (cur->bc_btnum) {
>> +	case XFS_BTNUM_BMAP:
>> +		kmem_cache_free(xfs_bmbt_cur_zone, cur);
>> +		break;
>> +	case XFS_BTNUM_BNO:
>> +	case XFS_BTNUM_CNT:
>> +		kmem_cache_free(xfs_allocbt_cur_zone, cur);
>> +		break;
>> +	case XFS_BTNUM_INOBT:
>> +	case XFS_BTNUM_FINOBT:
>> +		kmem_cache_free(xfs_inobt_cur_zone, cur);
>> +		break;
>> +	case XFS_BTNUM_RMAP:
>> +		kmem_cache_free(xfs_rmapbt_cur_zone, cur);
>> +		break;
>> +	case XFS_BTNUM_REFCNT:
>> +		kmem_cache_free(xfs_refcntbt_cur_zone, cur);
>> +		break;
>> +	default:
>> +		ASSERT(0);
>> +		break;
>> +	}
>>  }
>>  
>>  /*
>> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
>> index 4eaf8517f850..acdf087c853a 100644
>> --- a/fs/xfs/libxfs/xfs_btree.h
>> +++ b/fs/xfs/libxfs/xfs_btree.h
>> @@ -13,7 +13,11 @@ struct xfs_trans;
>>  struct xfs_ifork;
>>  struct xfs_perag;
>>  
>> -extern kmem_zone_t	*xfs_btree_cur_zone;
>> +extern struct kmem_cache	*xfs_allocbt_cur_zone;
>> +extern struct kmem_cache	*xfs_inobt_cur_zone;
>> +extern struct kmem_cache	*xfs_bmbt_cur_zone;
>> +extern struct kmem_cache	*xfs_rmapbt_cur_zone;
>> +extern struct kmem_cache	*xfs_refcntbt_cur_zone;
>>  
>>  /*
>>   * Generic key, ptr and record wrapper structures.
>> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
>> index 27190840c5d8..5258696f153e 100644
>> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
>> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
>> @@ -22,6 +22,8 @@
>>  #include "xfs_rmap.h"
>>  #include "xfs_ag.h"
>>  
>> +struct kmem_cache	*xfs_inobt_cur_zone;
>> +
>>  STATIC int
>>  xfs_inobt_get_minrecs(
>>  	struct xfs_btree_cur	*cur,
>> @@ -432,7 +434,7 @@ xfs_inobt_init_common(
>>  {
>>  	struct xfs_btree_cur	*cur;
>>  
>> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>> +	cur = kmem_cache_zalloc(xfs_inobt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>>  	cur->bc_tp = tp;
>>  	cur->bc_mp = mp;
>>  	cur->bc_btnum = btnum;
>> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
>> index 1ef9b99962ab..20667f173040 100644
>> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
>> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
>> @@ -21,6 +21,8 @@
>>  #include "xfs_rmap.h"
>>  #include "xfs_ag.h"
>>  
>> +struct kmem_cache	*xfs_refcntbt_cur_zone;
>> +
>>  static struct xfs_btree_cur *
>>  xfs_refcountbt_dup_cursor(
>>  	struct xfs_btree_cur	*cur)
>> @@ -322,7 +324,7 @@ xfs_refcountbt_init_common(
>>  
>>  	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
>>  
>> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>> +	cur = kmem_cache_zalloc(xfs_refcntbt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>>  	cur->bc_tp = tp;
>>  	cur->bc_mp = mp;
>>  	cur->bc_btnum = XFS_BTNUM_REFC;
>> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
>> index b7dbbfb3aeed..cb6e64f6d8f9 100644
>> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
>> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
>> @@ -22,6 +22,8 @@
>>  #include "xfs_ag.h"
>>  #include "xfs_ag_resv.h"
>>  
>> +struct kmem_cache	*xfs_rmapbt_cur_zone;
>> +
>>  /*
>>   * Reverse map btree.
>>   *
>> @@ -451,7 +453,7 @@ xfs_rmapbt_init_common(
>>  {
>>  	struct xfs_btree_cur	*cur;
>>  
>> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>> +	cur = kmem_cache_zalloc(xfs_rmapbt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>>  	cur->bc_tp = tp;
>>  	cur->bc_mp = mp;
>>  	/* Overlapping btree; 2 keys per pointer. */
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 90716b9d6e5f..3f97dc1b41e0 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1965,10 +1965,24 @@ xfs_init_zones(void)
>>  	if (!xfs_bmap_free_item_zone)
>>  		goto out_destroy_log_ticket_zone;
>>  
>> -	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
>> +	xfs_allocbt_cur_zone = kmem_cache_create("xfs_allocbt_cur",
>>  					       sizeof(struct xfs_btree_cur),
>>  					       0, 0, NULL);
>> -	if (!xfs_btree_cur_zone)
>> +	xfs_inobt_cur_zone = kmem_cache_create("xfs_inobt_cur",
>> +					       sizeof(struct xfs_btree_cur),
>> +					       0, 0, NULL);
>> +	xfs_bmbt_cur_zone = kmem_cache_create("xfs_bmbt_cur",
>> +					       sizeof(struct xfs_btree_cur),
>> +					       0, 0, NULL);
>> +	xfs_rmapbt_cur_zone = kmem_cache_create("xfs_rmapbt_cur",
>> +					       sizeof(struct xfs_btree_cur),
>> +					       0, 0, NULL);
>> +	xfs_refcntbt_cur_zone = kmem_cache_create("xfs_refcnt_cur",
>> +					       sizeof(struct xfs_btree_cur),
>> +					       0, 0, NULL);
>> +	if (!xfs_allocbt_cur_zone || !xfs_inobt_cur_zone ||
>> +	    !xfs_bmbt_cur_zone || !xfs_rmapbt_cur_zone ||
>> +	    !xfs_refcntbt_cur_zone)
>>  		goto out_destroy_bmap_free_item_zone;
>>  
>>  	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
>> @@ -2106,7 +2120,11 @@ xfs_init_zones(void)
>>   out_destroy_da_state_zone:
>>  	kmem_cache_destroy(xfs_da_state_zone);
>>   out_destroy_btree_cur_zone:
>> -	kmem_cache_destroy(xfs_btree_cur_zone);
>> +	kmem_cache_destroy(xfs_allocbt_cur_zone);
>> +	kmem_cache_destroy(xfs_inobt_cur_zone);
>> +	kmem_cache_destroy(xfs_bmbt_cur_zone);
>> +	kmem_cache_destroy(xfs_rmapbt_cur_zone);
>> +	kmem_cache_destroy(xfs_refcntbt_cur_zone);
>>   out_destroy_bmap_free_item_zone:
>>  	kmem_cache_destroy(xfs_bmap_free_item_zone);
>>   out_destroy_log_ticket_zone:
>> @@ -2138,7 +2156,11 @@ xfs_destroy_zones(void)
>>  	kmem_cache_destroy(xfs_trans_zone);
>>  	kmem_cache_destroy(xfs_ifork_zone);
>>  	kmem_cache_destroy(xfs_da_state_zone);
>> -	kmem_cache_destroy(xfs_btree_cur_zone);
>> +	kmem_cache_destroy(xfs_allocbt_cur_zone);
>> +	kmem_cache_destroy(xfs_inobt_cur_zone);
>> +	kmem_cache_destroy(xfs_bmbt_cur_zone);
>> +	kmem_cache_destroy(xfs_rmapbt_cur_zone);
>> +	kmem_cache_destroy(xfs_refcntbt_cur_zone);
>>  	kmem_cache_destroy(xfs_bmap_free_item_zone);
>>  	kmem_cache_destroy(xfs_log_ticket_zone);
>>  }


-- 
chandan
