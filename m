Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99384C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 12:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbiEXMhG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 08:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237398AbiEXMhF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 08:37:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E38555362
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:37:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OCYVvo028038;
        Tue, 24 May 2022 12:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rv0wqYyna1ItmpsInRW2GQK9eeb5YCGT7Hvkcab8LRc=;
 b=jMKsUfNgCZKs4J/4cspjyK/wpiqoUkOTiBIYzbQ18K+PmuHNEUg+uigIThuUtjtGptLr
 wxy8238NmAoRPGhugW1/bxJGEYkqygyjbk4LpM9ecgDUno4b0hYwYJN3BIgtDsoxUngd
 qvYPMPO8CAWhuLN4x1AF+vOp5F6KSIXlMfdSJi1juyhLhoith0HlYSbF/rO0Pd7FuGan
 MQixw2twEyLzIHbltrOlsFWdKiuwhnIKeuNodHbU6U86w1QjBUEH5IA+5Sml0pPc4L3M
 da7QHrsqj1qd17ys2PQhRyIWJCQ8nHQyIFwwDOsb+PbVexqbbLXRdgH5EugcjkqmORUv Dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pv26bxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 12:37:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OCVL7k036647;
        Tue, 24 May 2022 12:37:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph2e94k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 12:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iM4Gkrl9ATjiqhpUFMyiA/x+IPAEBBTcaXgmVr50oyDSC/Bxmb+cpeGSJG0c51asj6ZwgaowhO+VNnFr/g8KXhL5+QMa0/hsMvrhQZO1owLSnRMax8h/4etLh1JxN1uP3lOENzLmFV0SrJk7sN846/SSjgmw5TpeSBFDb44KR7W7vzm5DbwVJ1qwf/kuDru4W2gNsJPl0Sg6wlRh2nhDaA7qV+AsrpbecSh6CC3EK1cpXs80Q+44B7FbtrC6vh9IHr8myKgeDXfJod1ZJbNdvD5OzKw0az9hC9yN1A6+Ay1mWBB1yd7k0Se3O3jYE9AZG3gDgHmILRLG3odsyAKTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rv0wqYyna1ItmpsInRW2GQK9eeb5YCGT7Hvkcab8LRc=;
 b=Lj57FrK4R0diCAIRL1hjwg76pHP3hzHwvEjA86U9BYAWBXMEw7dxCFA6ixgFUK9Vjq3vWhZYsq/AE7wLym1bBKcP1AAfwbY2MCahbrE4A96xFwoK8fBKKTCZ23K0wwInviOJBAoPxL7UuI7exx6lxClDE61s/mfqmxrRyc+OyuQCkHgs7f8cauvWSxCKtmdGwSeqcEt4WCGzFL7X1mSSv8h0cMOEgqgG0YhviHcbGC4MMgPMySydDtsWf2ImGtUkieW/oQQyq5LV+rgHeRM21UVXlBm0lR3PCSTWejbkfgytGUV9cij3zucjoUNgTvChzAw0y+2vMsdbqM0RWqSpAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rv0wqYyna1ItmpsInRW2GQK9eeb5YCGT7Hvkcab8LRc=;
 b=qFAdZk7fKCeLQov0xWqIVBYhL5JsHywfDSuZeMOhHKvLETzO2EpwC10oVzHvl1Jycw5r+biX9gj/zslqhrtZUei5Vh+YukNvc5xqdl+VGMaP9u1PCWjJ71kMVLI7fDkjM6TRja5Q/WBEaYPHleHxN5oZjWwLU6t5S6qJZ2IiDZA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2439.namprd10.prod.outlook.com (2603:10b6:a02:ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Tue, 24 May
 2022 12:37:00 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 12:37:00 +0000
References: <20220524070543.GA1098723@dread.disaster.area>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfsprogs: 5.19 libxfs kernel sync
Date:   Tue, 24 May 2022 18:01:15 +0530
In-reply-to: <20220524070543.GA1098723@dread.disaster.area>
Message-ID: <87tu9frtsq.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::15) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47682657-c5f6-4494-3784-08da3d82192e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2439:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2439F88BE8A81FBDE90B612DF6D79@BYAPR10MB2439.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1iccxvFXAZhCariQ2eYxPPY0RUez08VtNoP8mcrTkbjUuCfu39dQhpmteQJAoqI0cuBgVtVImCaULgUhBTc+aTrio2NgIWMZ5HmUqJNzLc3NPR3z+uAecIZN+8zAUxOLLJBTSWlvVs+2syWYyowl9Qu2uTP5Ky5bEgkUnXwuMALtNyBBiz0q8Q4LaOCcCejNXPZ5KQgNV4HRWq7fosNgkikcuD8kDWmVkerUbuQ5qWCmW5keaeMzU+ZRBg79rrTzorZXSzwOfnxldm/tnCFR8hvVcNokUXoxJ+UmszHA6htOg6sU4j/ELv7pOQ2JbbC4JJ7/WI/BqDRiLTE09ogfj1P9DaewWmIaPrnrS+NzQDaJ0xOpIsaGFCxzDZINeH9I7uesDUvDAX8psytZt2HZniA4/V0JpxWkdf6x8/ZS2ZTv2QqB7n4F+tDHS89w16JYPgjzfKU7LoGsJKlmv7hO1RkBmmZ0XzognouJUJ3hGZmaSb2m1WU2yTCFYpiC03Z/6mVXFlugTEdhrpP6RpUMhkzjws7rfy36lzUROSg97Cghf2o5uzY9lAlisOhQGdI3UXI+Dk5lPmjaHkG29yQYgkziLhCnFI9H2l1GGfvWicrls65Go3MxdI7bvNCZ/nvMomX443R6E2XhUGjakFwWuD27SiVwF/a67glV3gRhbooN6oCU2QCdKccvi4+AVeirzMKCl8PzA+kGoUPwhG1HLxkRjw/jMXiF3kDAI6NNigDrYHORsiHRLyzECiCj7j29wOoHrSdBrtPNRE4+EmUFaWU+1ZU9HD8fQtzn9mIYkyI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(2906002)(66476007)(9686003)(6512007)(26005)(33716001)(66556008)(316002)(38350700002)(6916009)(38100700002)(4326008)(52116002)(8936002)(966005)(186003)(53546011)(6506007)(508600001)(5660300002)(83380400001)(86362001)(8676002)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SpyTiCfszBSOXadJMKPzpLrFfFjMQi+KbUPKTgiQ4mN/YnXY5Q+SNgmDT6VZ?=
 =?us-ascii?Q?LnQha4F5o74V+ePD4hJw1kU0qLPXLbDWItq59Tfg3M1HuST+x+srTTmYmAEE?=
 =?us-ascii?Q?skqDYuFuAhlCmjheuZao1kTJRVV1KNJxAinqJOL95cnC/mNW2kA+GVgCFL13?=
 =?us-ascii?Q?5K7DA7qj6bWpOwncnqHHQ0HlYtqIVxOsOtYX/pY+hBpRvqZKILmTXHPTQLr6?=
 =?us-ascii?Q?php80X/q3by5kBwMPv3qDVzxAjO27oc2Uaqo5jJZDDro6AJDNxkWQwgKxHsm?=
 =?us-ascii?Q?cuqrzla9A/Q6+A5jkiX7+AQA7BqB0dYFMRVxbV7LVZHkQ+ABYb8S6UyVIBlf?=
 =?us-ascii?Q?7tza8pC3StHjcnhn+LYTOj77UBIvb6GmkigHchNUEiiODYKJqDrSN2uIOS6N?=
 =?us-ascii?Q?EuaUv+i+covdlHLLN7s6PWVDS8qqgi2qkXSPyp+2aB3MKpLKn2qCiFFd4txo?=
 =?us-ascii?Q?mj492Mtla9RTEuIZGjsNUfgDmYXHvKyu9Rfay9SoTjFfslfF1pgO6D+vOJHI?=
 =?us-ascii?Q?1yL94SP7WtcVgW7/4a0H4/n5N9SUDYikQ1LNwYfTBvqjPskNXH0TG0JAX1ZV?=
 =?us-ascii?Q?s2KMXifWim9Ey9InnNuvCa0pLRXMDQPkO63UQdIiyQid5nSb8sXzU6EgxOLb?=
 =?us-ascii?Q?QvcFfW73CJf6iKZUcws02X0+ZGwCoYdTH4du2ch21U6f4IVTvnBkmq5lad0a?=
 =?us-ascii?Q?gzjOKyOf9+HQv0cPYBfpgA4cR0cWcLDgFlVZKNL4+Lj/CkAiG3C5FLOvO8oK?=
 =?us-ascii?Q?1PvBiYxT1wEKMFr5pQ9EQpo2cT+A6IjjtZWYWp0KvurTKgfmq7DkkJU4dhfP?=
 =?us-ascii?Q?TAw3zDO4GjIGqU7+eSST4415m+ZAJYc5d9O/BnrTTnU230Bu4JUJusf9uejm?=
 =?us-ascii?Q?jREnufmcE5+czHD/KdT0bsIoOwBuBZiAHRsNtq7+9eIlHcisEfIVM8AqbK3X?=
 =?us-ascii?Q?bElIA8pYSnHKpmErypRn8dNHADkV0/Uv8SconMZ/2gTnv+uRotKGzCabNjYJ?=
 =?us-ascii?Q?4Ow4WysIdw+MbFIAKKB3rzd4iDK0aVNgjzBOgDpRHUzi4xuc3ZaHuCsXDQNu?=
 =?us-ascii?Q?8V/04JJdQbtXM3iUcJvd6leqbxQMWNQKLs2FIXpNVmfIRcYAtv5i+7AzTEi5?=
 =?us-ascii?Q?+zJdEJEhB/F39NGaVkpUZlalEVVlFFRZFDqNQzlHuCu9ldvjQ9TbF1WLehxx?=
 =?us-ascii?Q?puMLrDg/FIGQx9hqFns7grjc4Q7BOnabPBYWRFcmVQVv3EI1arj1gZXTVQCI?=
 =?us-ascii?Q?vHONCh0FNExn90a5fl6jmJyivEqxffCMq9SM72mxXV7k5oYTlrNQqmlhqe2e?=
 =?us-ascii?Q?SjVf2kSJPUfmAI1bDxK6bq74J2fxtjpD82krO4ZjR4rCWsUp/BnLtmlOL4aD?=
 =?us-ascii?Q?s1TYWg0ZuUb9UlVzVJpK6f6aknbqCSlDBAIWwTrN73X8ce2CeoxvSevJoA1i?=
 =?us-ascii?Q?PidsSe47rmmzQTnRI2TgA6Kh8ggZhgqV2OlDAGqL622c1/Mum6iaJkrtAwFz?=
 =?us-ascii?Q?+ODUhFi4aLDEvvPQF3jBeyznGWyAl98IdImpW8vqo9hgxttdhZNR1T1LXxd1?=
 =?us-ascii?Q?24unl7JptdHNqP8EpOBtN/e9KY8NwEarZA0OomXsCYZnz05kvMt3x1QTXzNl?=
 =?us-ascii?Q?0NsAEM/OvleEG10VCBrcu0cf9FXrX8zEderP2mfDCFjEkjfHieA1BtR5TyMP?=
 =?us-ascii?Q?erVqv+6Kmgiy5S3bRjS8WH6KShx0vnY7l9wE1jH41oE5kZUfdxFOO/SpxALb?=
 =?us-ascii?Q?vPuIgg5bL19DzCbWwSU1VMyVu6JcnO0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47682657-c5f6-4494-3784-08da3d82192e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 12:37:00.5085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JjcLewi2hDxEMaWJkyF0s/s9KsJVWCdMWmdoMn84yaBhtGhsDqcHQRMrQI50l81ao8TXOtNIeNwhDLR52inBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2439
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_04:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240065
X-Proofpoint-GUID: g0wZS1bt3ITT96zO6sfi3rQbBIgteDdP
X-Proofpoint-ORIG-GUID: g0wZS1bt3ITT96zO6sfi3rQbBIgteDdP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 05:05:43 PM +1000, Dave Chinner wrote:
> Hi folks,
>
> Now that the 5.19 kernel code is largely stablised for the first
> merge, I've been starting to get together the libxfs sync tree for
> xfsprogs with all those changes in it. I have built a branch
> that can be found here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsprogs-dev.git libxfs-5.19-sync
>
> that contains my work in progress so far. It's build on top of the
> current xfsprogs for-next branch. I've ported across everything up
> to the start of the LARP series so far, so I have done the porting
> of the large extent count work and all the other bits and pieces for
> log changes and so on.
>
> For the large extent count work, I have not added any of the
> specific new xfsprogs functionality like mkfs, etc. Patches 14-18
> of Chandan's V7 patch series here:
>
> https://lore.kernel.org/linux-xfs/20220321052027.407099-1-chandan.babu@oracle.com/
>
> still need to be ported on top of this for the functionality to be
> fully supported in xfsprogs.
>
> Chandan, can you port those changes over to this libxfs sync branch
> and check that I haven't missed anything in the conversion? I did
> pick up one of your patches from that series - "Introduce per-inode
> 64-bit extent counters" - because of all the xfs_db bits in it for
> the change in on-disk format, but otherwise I've largely just worked
> through fixing all the compiler errors and converting the xfsprogs
> code over to the new functions and types.
>
> If you port the ramin patches over to thsi branch and test them,
> I'll include them into the branch. I'll be checking for stability
> and regressions on this brnach for the next couple of days, and if
> everythign looks OK I'll send Eric a pull request for it....

Apart from a single nit, The "large extent counter" patches already included
in libxfs sync branch look good.

My original patch "xfs: Introduce xfs_dfork_nextents() helper" had an
invocation of "xfs_dfork_data_extents(dip);" in process_dev_inode() instead of
"xfs_dfork_nextents(dip, XFS_DATA_FORK);".

I will try to port the remaining patches by today and will run xfstests
overnight. I will post the patches tomorrow if the test execution doesn't
reveal any bugs.

>
> Once I've done that, I'll work through the same process with the
> LARP patches. I'll probably lean heavily on Allison's recent
> xfsprogs updates for that (no point doing the same work twice!), but
> right now I'm hoping to have the full 5.19 libxfs syncup done with
> both large extent counts and LARP fully functional in that branch
> before the end of the 5.19 merge window....

-- 
chandan
