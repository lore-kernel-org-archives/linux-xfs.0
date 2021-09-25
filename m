Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAE0C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 10:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D81C961041
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 10:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbhIYK0C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Sep 2021 06:26:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2882 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234922AbhIYK0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Sep 2021 06:26:01 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18P87HjM018788;
        Sat, 25 Sep 2021 10:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=CexYPafhx4CYFm8hTAhYMO+sQvcY2W6SNQo+NVUJwow=;
 b=wfPGoGjJB7rCiKe6oGJpITTXgnNTx6FmYpfIxVF9Vl9noPacAC3k95h9MQZ2F0Y1gpPK
 BaOqD3EUKA8MMXHc7o80vvqhAEtz6yRYNZwh4/Uvaih/1946v/vp2aMgkoCNIbtYpJu+
 05DA/Tx7da+7ycyqg7+Vx5fHxQMk5Jaumx90v+GncBYoItRpsIhD7v9vFsFSg275KEgO
 7wdOlugtQbRkCnGTmzccVBol/xN9wbPvopIiWgDqmWf/CCJiU9PLvTmCa762PsHK9wwU
 vQyzsC+SoLYIFQcbzTf8phTvR3Py28dwNivk06NLOz8auEwpqqSd0wZIE0CVTwAAYzlm 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b9tj3gsbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Sep 2021 10:24:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18PAAx8v171389;
        Sat, 25 Sep 2021 10:24:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 3b9x4xm54s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Sep 2021 10:24:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kg1mHIxQVHosU0eaAALeLa/PsB4dgDmsE39Ij3OVBF517I2QP6qjpjb/ZOsRIT2qxouwx7tXQATNJRIp3xnA+kOCKA3itcBcJKD2WY/ej7qU7TjfEWUiYqs2tdeHuMF2iB4oRGbORhiBtXL9TN+WkJ2bkw4N0OEL9hJqqhMC8WRv0VUjD5Z1y0JC5lTXdVb60U4jXB6/4RQ1/QRrRwwnJC2qN/uwJAcQr+Xrvat6xRdq2Mm2nxbW6rvjGj3OxcEaAHo3xsYqTGcOj8BVPU0PbEv7am0g4gI31H+MDWVWvvjNLGVl0Kf5sZvln0R21EoG5bAuHbyksjAio2bmmiyqng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CexYPafhx4CYFm8hTAhYMO+sQvcY2W6SNQo+NVUJwow=;
 b=m7AHqdGurlRHcdS/1FJ6UkazGtNTrGfVgN3JttEZ5XxlfWy8UGbT97bvQ9Qf7KaPD+jwksnCEghuq5RRnor8mTBTwH0si48t0zk1K8HfzRmqEwvUxeBXSYguPacNiGr89Cjvfc1HfGMMblYtv+AOnyb1TadauWfyIg1vJeVsQhJZvGozKC2wQpxSulLDlstFHTywXw6T24Vz5rLgsImdoSXepZZYf2WOFiqegupBIvQYHbfZ3UGsvdkJHi1K/0ngKVsvvOqwWG7OCYC6AoCcL4vOWPcVmUiLTcPCF2lFCD7iNlVjdIhvGjricO35MStcxg8zodmeracqyRISoMmFlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CexYPafhx4CYFm8hTAhYMO+sQvcY2W6SNQo+NVUJwow=;
 b=RWv8Qbp0FLscDinF2wOQzAs5vpgGql+FTtKK2VAg2YXzJ7+dh+rj5W6R5JnNzLIb2vHjA2eFGmwhDIq7+R3+2HXiG5XIXYUx/sop7TOrbCd6MFIDb7IEIsXrjT66wMae5Abz0NXd3Hhw6yNaovsBD0G13HoNP3n+mRFfMDFgTiw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2543.namprd10.prod.outlook.com (2603:10b6:805:45::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Sat, 25 Sep
 2021 10:24:20 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.020; Sat, 25 Sep 2021
 10:24:20 +0000
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-2-chandan.babu@oracle.com>
 <41a4a5e6-c58e-97e7-666b-d1205ed0604f@sandeen.net>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        david@fromorbit.com, djwong@kernel.org
Subject: Re: [PATCH V2 1/5] xfsprogs: introduce liburcu support
In-reply-to: <41a4a5e6-c58e-97e7-666b-d1205ed0604f@sandeen.net>
Message-ID: <87a6k12bso.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Sat, 25 Sep 2021 15:54:07 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0105.apcprd03.prod.outlook.com
 (2603:1096:4:7c::33) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.21) by SG2PR03CA0105.apcprd03.prod.outlook.com (2603:1096:4:7c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Sat, 25 Sep 2021 10:24:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b7fb803-6627-4ca3-7aac-08d9800ea2cb
X-MS-TrafficTypeDiagnostic: SN6PR10MB2543:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2543881BF1B4B077952133CEF6A59@SN6PR10MB2543.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7I08lVcEExnXtbamAXGOUpsQJnLP5lYwa4LD593kPN+S6NZU5r6zA0oDvSzLBTdmQPi48RhQupd92HRG2GnisqgYf857u6RzOLBt3e00Olu2xrxDwAAMjcBrK+7G70bFHbZ5uUDYuUxSUOKr8VBjaihXBTj6Z3fvlW9chxAqXivv0yvQ7LWLbZnEBJvZE5b+ZPAyfCUsHoxs11ms9Tof5fkBe9ecD0RqOSykWqWys92HPr1Mjl6089FHlMvUjORwQlSYBQio2Kqb5LdUmCTEL42loz/UmuSHHXaqebEkipXgSHQmGnZ7HNhb2d8OMIbDt/SJR/O1imBRcQtc2e+M64UzM/93DNvKy6BtS5Ms0nl+nA8tlsJQnB6IMJiN5s5gihDJHfvfICepOCg7DP4Rbs9B2BzD7v4bgAT719B7jz2TuvsnbwZTjiYzHqbM98s0c61pZaYfvh5NSlKwnsjqcW0uBu3Ir85rrtFZlnczGwYGDjd8pG5i9KcZMGLlyZRNtkTY8/Q1CZthRQS8cNn1rArpUueq6Fly+pctqE/UC77A6e4xtybzRQUaYoqd27nf7FS6shscIWdJvLpoDwgtpXaPESbRDCuPqb2bmHxjPyMoCEiJtkbIPXBsv6qtiqipsACcpZzkYZl7+/E14eVNU8VJKZ3Qrx/DeYM1tnPVA+ha0DDfq9QdBvmz1AX06atZFdoLlosOrHeFfDrvOiv9Bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(26005)(66476007)(66946007)(66556008)(6496006)(5660300002)(6666004)(956004)(8936002)(53546011)(52116002)(9686003)(38350700002)(38100700002)(83380400001)(33716001)(186003)(86362001)(2906002)(6916009)(316002)(8676002)(4326008)(508600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?exC9djvrSmG+7MDk74hDOV5c9/eR51TbZnZPvIxJIIMYQxW1saSzvJ6F8mtF?=
 =?us-ascii?Q?MesRULkJePgw/5UnR0mriJc/wU3u5LPfvE9c6E8R398oLxRxnF188IqyLqjL?=
 =?us-ascii?Q?cO5SWejTUsrBWpI07bvw32rzv83m2Ck/OV1eH02uji3rLk6fQCvT1PRN2SAV?=
 =?us-ascii?Q?bG92EAA+s5bdI+miwAroMMt1MoBM9zynykNRX838xO6ONxzwIV+lUdeL8Bcw?=
 =?us-ascii?Q?+u6VTlt76wt72YbMAz63XOez+T03kIj7hftBXGvWIF81CNbQ6edJw8p7dp5V?=
 =?us-ascii?Q?Zp6+hLn5KILpti/2hw83AHpsh1qrmfZXFB7rEsNu42wtDhLv+MSa8QAYfcpw?=
 =?us-ascii?Q?7qacCDYpCIsBC29S6TMa5XVSHlCcbLGJ5pv/j2c7KN1kkHKsdSvxRJzWQNKg?=
 =?us-ascii?Q?YyzMAPgZMEx/couU4cdBVumaHiAHZnQeFWT32qw0jIQGNRxcuY+ZjDKnYVoL?=
 =?us-ascii?Q?Kr1PwxbkBLJKAE5Qn0C4/SXDRwrFag2VhaU1KZNMj0UXR5miP9yGR/t+FBpX?=
 =?us-ascii?Q?dVEKcR+M2mTZ0Ojk9NYydP3BsKo4XilzE1sYs4b0e+/fqv+nP3V/GFdgV0xf?=
 =?us-ascii?Q?hLZzdAnNIKnqH6Fd9fVHudrToUvpC2HJ3hriTDYzBNPgxTBpePWtv/TTx3Xk?=
 =?us-ascii?Q?14xWq6McdMqtVLWcwBWl6/CTufj7sel97ppI9IgbTEqwX03U/st4/IUMQN+B?=
 =?us-ascii?Q?E1P1GTxdCd5yBAhAsXZmblzD4yoER4J1YALhkMBN9cbe1MaB2WtOE9Q6N5hr?=
 =?us-ascii?Q?wtgUe9PFYngwmaK0tT9gQ0dPVGBfT2iYnLKoY/O7sGD4mtAiGK3edbH2xiTy?=
 =?us-ascii?Q?G2dCd1v6tA6eREQ6xq8PR6FkEMgrtmRTGig0eXKyGPk+l1cNq+MXzQIz3C6w?=
 =?us-ascii?Q?GOrkTsehueEYtnfLjIUgdLYaIi0KN4Sgg6g1O7pp7qwXiStHXZZAcS1ttB27?=
 =?us-ascii?Q?4VMeuzxazSmWpcGaJVVobEHthW3F4V5IvdxZG5i0E2LWBAr+cwbaZU4TKp02?=
 =?us-ascii?Q?TGYENxskGSmlg+GLMkUMAyD+1QJXEq/daSu9qI0GVkhmQv22TyPjBflNhm+V?=
 =?us-ascii?Q?iwqVrVxcHh597Z780sP/xFiDhxPFyijKRFO1Y0Drt6vj9h4xH3NDjsGpTMjq?=
 =?us-ascii?Q?5v6y0KjUxVzLoT9iCQGygDWMk+uaOEkWwE66bzUaKvFECJ6YIwjnRQUW6c2Q?=
 =?us-ascii?Q?61kSSG3/ooXMdMjmHEpfF6LcVlPdNLn+5TJzR4c+9gSic6/6aA6Btr347JAc?=
 =?us-ascii?Q?i1+AgSMb7EuoD9Wwax8oPXq5uZI4/m/KcrZilP3FVxocq2Cc5AW4KFu0+mHx?=
 =?us-ascii?Q?dgX8Z3nP5zkY+EVIo08e8cQi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b7fb803-6627-4ca3-7aac-08d9800ea2cb
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2021 10:24:20.3128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F4WxUPl/0lzJ9qFdESBzoPGQhaQIXnWo3CYgHp0sBDzNs64E/zHmLcJY4UTehPHUlTA/G1gd6+o4G7QZqjLk0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2543
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10117 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109250076
X-Proofpoint-GUID: 0X1CbOJgEP2ATeqIGhWvaKy2P29U4dK9
X-Proofpoint-ORIG-GUID: 0X1CbOJgEP2ATeqIGhWvaKy2P29U4dK9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Sep 2021 at 03:21, Eric Sandeen wrote:
> On 9/24/21 9:09 AM, Chandan Babu R wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>> The upcoming buffer cache rework/kerenl sync-up requires atomic
>> variables. I could use C++11 atomics build into GCC, but they are a
>> pain to work with and shoe-horn into the kernel atomic variable API.
>> Much easier is to introduce a dependency on liburcu - the userspace
>> RCU library. This provides atomic variables that very closely match
>> the kernel atomic variable API, and it provides a very similar
>> memory model and memory barrier support to the kernel. And we get
>> RCU support that has an identical interface to the kernel and works
>> the same way.
>> Hence kernel code written with RCU algorithms and atomic variables
>> will just slot straight into the userspace xfsprogs code without us
>> having to think about whether the lockless algorithms will work in
>> userspace or not. This reduces glue and hoop jumping, and gets us
>> a step closer to having the entire userspace libxfs code MT safe.
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> [chandan.babu@oracle.com: Add m4 macros to detect availability of liburcu]
>
> Thanks for fixing that up. I had tried to use rcu_init like Dave originally
> had, and I like that better in general, but I had trouble with it - I guess
> maybe it gets redefined based on memory model magic and the actual symbol
> "rcu_init" maybe isn't available? I didn't dig very much.

Yes, rcu_init() gets defined to one of the variants of userspace rcu. Hence
there is no function named rcu_init().

>
> Also, dumb question from me - how do we know where we need the
> rcu_[un]register_thread() calls? Will it be obvious if we miss it
> in the future?  "each thread must invoke this function before its
> first call to rcu_read_lock() or call_rcu()."

Unfortunately, I don't think there is an obvious method to detect if calls to
rcu_[un]register_thread() is missing from any code changes implemented in the
future.

PS: I am no expert at RCU. My knowledge about RCU is limited to what I could
learn by reading articles on the world wide web.

-- 
chandan
