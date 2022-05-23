Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F120DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 16:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbiEWQS2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 12:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238841AbiEWQSR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 12:18:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B088D674D1
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 09:18:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NEn0Ua005443;
        Mon, 23 May 2022 16:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bNFz0eEGa9lmIqabqLvzRg+4ZXjCyYR8y3HzI13SLj8=;
 b=cLXEfmvSCNEGBpGwvN7P+/5AlvWZD76dgl1HMwdQWHH86wiKxRjUVxOxRNq9f+fEwUA9
 9sgemzMoJGdsTMWvKoPdJq3bcGFizH2G7YSX/4cFJ71ljgKCy0bdA950dmGZt93fMfAK
 obVQX9ago35TTiun4ASVmhurf7XeLrifpG2PybbCPPcginvJoj5X0x1UdAkBYol82S9E
 0aiKzO/8ELMPGKixUwsWYB8HSG02jqSpny4u0TLJ848ucei/ZEy6Sm78H5buCYYOMe3S
 P338sNC8g6IIvO9T6Gqq9P5mSlJ1AI9ejAXxto8BgPS31jrFZBl4Do1grL3ZpS4so4cP /g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pgbkxmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 16:17:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24NGA0ZT002530;
        Mon, 23 May 2022 16:17:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph1ggk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 16:17:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgHghQjiddWtuIzG/J+6LpbkhdO0vwbPD5jUgcOV9oFRJdnrxOp9XymnQdIuMhKdVxkoJLiLbR+IuoHMMP7bJsBL3d7n0dVu87SrkJuRy6KDfLlOU6COtVNk/dKYMfwt9o+w1+le04S8LdY3hD5W2ecCtSBQ4/1eebDv6Un4gd1TjSCk/SM+bEoWOVi3wJrNdTH2uD2jkQeaPgLi7ONetdb4pY8NCJu/qq3qyRS6YfwFlrEEqO6dB9N86R21I6rDcgGQ1JutjEWiQSPDCTondJ12QFQ+oASAxK2zgZK5o6kQcuA5yXgMfDcTL3rBQKF3StUEkQP3T7Sb/4NAbX2tUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNFz0eEGa9lmIqabqLvzRg+4ZXjCyYR8y3HzI13SLj8=;
 b=RgKaq/rMqfqzxuoOyaPKqhQ9ta3qXFpCB05Zd4d9rJ75WPjUYdn2CuGgfhAR/K85EOsyAlAaS4SZmkEapaMdyP/1sB8+Xv7b5DcKok/JM/AaIGe1X2dWuQErZ37bGAPonzhgbIm7TTpprFaxDJS2vpokrT98D2CNVJAecxH34/73GKXXazkmhqQTPwOX7h2TM/VNCzJ/pHvMuRtGS5NBTLOqNvG8/1DampEVyj9o0NjeM1CNk5Qq/1bi6ZU/ZqmEEmaIXFx7QB+OwKz8ZhCQqhMSJhw8XWzIJFOGa6QDuhPAKivH17s4OA9diK7HWM5R6i+gKHdg+d6Z2Aj+Z66u7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNFz0eEGa9lmIqabqLvzRg+4ZXjCyYR8y3HzI13SLj8=;
 b=K+8B+LHRyR2RtqGqYrYKu3SM+vzrP79Jw74l4pnqZVKV1rbUbqvSO/LcWjFis6x12azFUAkjqD9BrTl8e0/0aeG/dCoN4YVv6lX4dnju5dd0NFcaq/HMbwkkiDSUpV9rUr2u4svk3rgbbDXDLuExPPSBo93FY4wFJmlPR47B3Gs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR10MB2025.namprd10.prod.outlook.com (2603:10b6:3:10e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Mon, 23 May
 2022 16:17:55 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 16:17:55 +0000
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V14 00/16] Bail out if transaction can cause extent
 count to overflow
Date:   Mon, 23 May 2022 21:20:09 +0530
In-reply-to: <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
Message-ID: <878rqs2pg9.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0089.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::29)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40e4a437-f480-4fc7-10ae-08da3cd7cb03
X-MS-TrafficTypeDiagnostic: DM5PR10MB2025:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB2025373BC7C21230E7C44E13F6D49@DM5PR10MB2025.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baFIn+esGG+fAb4I8URNvFZLq8TJUd5lRDjYyW2E2ELe+0SYn+y0kbfAwJBs02PiAPTLRlEfRvLDEXuOLMFPVI8SH+hwdb2fmE/ZYBWDlZkP25nXb7FipA9PikKGeaGR6bMyJfjcA95y7kNKWOMK8O+8hPU8G0BDSD8p3/soC9uwB3xm0nmkxZUe38h/3gjBqwcLyfE98GyHNh/OXfCs0hsDuE0ufWrUnx5pl/kOAihMBXi9tsRPXowwNg6bHL2z16yr07KCvUyqxAV4ePU8pC+bzTBLOynXDluH8bYNtpJ8RLo1la0EGGgsAwsDdNUrij2vRdhSgaC7Xfr98YRGIP9rpCaOY8oZxeQ8PGQrHLGivH1LyquSRCUpDvyVqa6qj8PpBzNcDw11B2PrWothmyxLyS7olc4EAesg54BXSPj5NBHEafxxAigPECRg77DUAjms1/Dd9B3xBL3bBhSgW3N3LH19Cm8TZbIe/q6cJHM4eqmlOHdtCb4MBTw0y+CrFrdANw5FcAMmyQwAOcOZAtFkQR+uD5aINE1dlYp2J5BiqUMAwc/s+TOxhx9LiqISjklwRKv8HPLdym0IzFoyLKvAiFcy/h/GC3k3XyZLNVb46mPGScM1h9G8I+0kYpkv7hMOu1er+RZ1GLQIi2faNh+69NzKs4IBA4t3yXdbQz/VnRQd7goJhjmnxwrx+4GaxHWeg/aTOrM/fUNyqsZ+5wljo5fNwIg+DRsuRGfUerE3FwDI2E/s3WYuD7wbs2lLzL4mEq1lbrOqOH4Khq39SdbpCo98e6VycayBhQd9Vh/fAAr4mClIM5Bs9yM68mf4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(2906002)(66556008)(38350700002)(966005)(6666004)(508600001)(4326008)(66946007)(5660300002)(83380400001)(8676002)(186003)(66476007)(33716001)(6506007)(9686003)(26005)(52116002)(53546011)(6486002)(86362001)(316002)(6916009)(8936002)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aGgbtG3p3k2Smopkmk2dtpcAdYHqeoQsGdWV4gDngVZp/H54W5+Yw+FjXHtm?=
 =?us-ascii?Q?FB9loaHtVtgBmfqff5Kxlnk4gWAJYVj3ugkLHKJRX+4EI5TV+PyLbMfErgIx?=
 =?us-ascii?Q?6MInlcbKwgJB5PrAF6JRTP5dWL4HtGDk1BxqD5xHNsFmEhpKMd6SwrCFhBXM?=
 =?us-ascii?Q?+Dj+egbJ93RKGauhCw2MQKoGQ29+WdJHYFswLzIKjlO6Emr2xSWqLRAD9K+Z?=
 =?us-ascii?Q?CHdDJ+M3titt8ZXg1Dl9O6O30vLaXdbTSQLt4rc52/qIkXUHAvFI7W103PwZ?=
 =?us-ascii?Q?98phg+EGo64UOnm76Z/WrkCrztPAk2b0ajVHLAq6Z56s6+cQ2uzP3f9Sx/Gq?=
 =?us-ascii?Q?p6MVrwmoWjUfhdHteeNmhJnM6LsCPdyXIWrkOZ6xr+9Y2327A/nhxUzbqDMB?=
 =?us-ascii?Q?/weyTuRAjleIErEPWVoEq00zgEyIWfGCHVDT5LTI4ijeX2entUCDATwRN526?=
 =?us-ascii?Q?YNvjVDH6fQKRwyM/aMYzQQENHez1LH7SPClEozkSCrQccLduYnex+nrGJggm?=
 =?us-ascii?Q?+ysIb9Nz8dmhPWbzF7aFmwcQTxmf5IBm44a/QUE/Nukd7mtdkt3pL4va7tnm?=
 =?us-ascii?Q?NQQso7pxsWSDuq+PMZGrg9rMWFokivh+s4FGbqmSUIN2tou4BMpn05trk4qG?=
 =?us-ascii?Q?Gbv+gzxGO8vDxzwJWh+TSH0nw4Fy/58ruCrDWXfmnrrdG/s/AoZKAOQFZL1+?=
 =?us-ascii?Q?pxOcW4jmCxBANyfpdO7sitTeBNRF1qBxbV92Mefx7iGiJzHk0VzGMlIRneSC?=
 =?us-ascii?Q?PJOzJZYLQTC9H3UM3d14bqA6mpoJEXe/x9U+Ssxf97aalBNuYf3AJPQxR0zu?=
 =?us-ascii?Q?8Kyq7c9QVTB+cP0d0QwEcK+dXbpQ+MzpMKmcgeeoOWeQHqacxl0LR9m5LrQc?=
 =?us-ascii?Q?k33QlvFBBSYag6PWWF0pKeCFfjGG39qbLJPU+XUIRGsxnV6cg4JjVpucFAF4?=
 =?us-ascii?Q?fho6Z23crOJwTKBaQHzQp5ukKZrU6lT+9rxP2wS3CyTfw9O4K6sJMHertGOa?=
 =?us-ascii?Q?KHkRIEmePgd4vW6eDlRxp8148IMezIKoevLLaXaLv42PUq0UyTTxfRpj+ZTU?=
 =?us-ascii?Q?AyQgznx792a+Or2nh4CC0+nqLDqrxHzkcIgrxGKarzlyvXQTyzQRiFQ/0q7u?=
 =?us-ascii?Q?E/Duo7qh9R9i+yMetwR4vMsBgF68lejvNcNAbDsLPpk6CHyv1LrMlRM9SziI?=
 =?us-ascii?Q?BO0WCQaN79RKl0zbkCpXAWE1og4CuV04fOZTnBD36TkZ8Rs/XqVbp4ucVWbV?=
 =?us-ascii?Q?LqDnECc0WPlkr/QYO2urP2nujk+bZ+G5hg/Q4cUXOmIYanBvcLN36zTe2oW9?=
 =?us-ascii?Q?ovX1TzUCrzzQfaNS5RDqWW8n6R421a5EeLdRwTM3WrFJfszGyMc7m/5I/wVa?=
 =?us-ascii?Q?QyZAQyw1RM+efiwxXqZgDAktFHh/GD/7fj193FKI/6e8gcaFYkHms+jD5U4S?=
 =?us-ascii?Q?KznGXLNNfGz+sIK9NiY5DiTrwWvK4bgFixCYJyExTeZTUwsyeYRMDcB8T86G?=
 =?us-ascii?Q?49X7Ii1nGzSAXsjY36cs+JAatyDpRirNoKW5yMqqSr900Q17ZYiPoU75WHs9?=
 =?us-ascii?Q?Phthc9xdarYrLJ9lqRk38u0w9Dlgc40R/C2X/N3pISY2WlQyvB2niZkPLh1y?=
 =?us-ascii?Q?IRllR9/h+jbZi7pBgwFRiRm5ocf45JNhf44bNn9/2GSdKgdEtjyNu8HaG17i?=
 =?us-ascii?Q?544oUClPwiM3ZuDtS2+b6WtDwfpNs/BfIuoy3cfvO2123R5nNfGZxRhCavQm?=
 =?us-ascii?Q?9NzXq7dXPVrk5iZSLub4LoRPi6rYpyw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e4a437-f480-4fc7-10ae-08da3cd7cb03
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 16:17:55.1706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LveZ9adbu6tSnYxk2M8sQ3V2OEOrBkDBCdA/JFPuhKVx1KXKRe3tYy5/J8ULHtJcv4WOYQ7cioELkDJ907kaYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB2025
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_07:2022-05-23,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230092
X-Proofpoint-ORIG-GUID: YfgOnZGkJIc-JWrhGxjWRoo5jcsXwonv
X-Proofpoint-GUID: YfgOnZGkJIc-JWrhGxjWRoo5jcsXwonv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 02:15:44 PM +0300, Amir Goldstein wrote:
> On Sun, Jan 10, 2021 at 6:10 PM Chandan Babu R <chandanrlinux@gmail.com> wrote:
>>
>> XFS does not check for possible overflow of per-inode extent counter
>> fields when adding extents to either data or attr fork.
>>
>> For e.g.
>> 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
>>    then delete 50% of them in an alternating manner.
>>
>> 2. On a 4k block sized XFS filesystem instance, the above causes 98511
>>    extents to be created in the attr fork of the inode.
>>
>>    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
>>
>> 3. The incore inode fork extent counter is a signed 32-bit
>>    quantity. However, the on-disk extent counter is an unsigned 16-bit
>>    quantity and hence cannot hold 98511 extents.
>>
>> 4. The following incorrect value is stored in the xattr extent counter,
>>    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
>>    core.naextents = -32561
>>
>> This patchset adds a new helper function
>> (i.e. xfs_iext_count_may_overflow()) to check for overflow of the
>> per-inode data and xattr extent counters and invokes it before
>> starting an fs operation (e.g. creating a new directory entry). With
>> this patchset applied, XFS detects counter overflows and returns with
>> an error rather than causing a silent corruption.
>>
>> The patchset has been tested by executing xfstests with the following
>> mkfs.xfs options,
>> 1. -m crc=0 -b size=1k
>> 2. -m crc=0 -b size=4k
>> 3. -m crc=0 -b size=512
>> 4. -m rmapbt=1,reflink=1 -b size=1k
>> 5. -m rmapbt=1,reflink=1 -b size=4k
>>
>> The patches can also be obtained from
>> https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v14.
>>
>> I have two patches that define the newly introduced error injection
>> tags in xfsprogs
>> (https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).
>>
>> I have also written tests
>> (https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
>> for verifying the checks introduced in the kernel.
>>
>
> Hi Chandan and XFS folks,
>
> As you may have heard, I am working on producing a series of
> xfs patches for stable v5.10.y.
>
> My patch selection is documented at [1].
> I am in the process of testing the backport patches against the 5.10.y
> baseline using Luis' kdevops [2] fstests runner.
>
> The configurations that we are testing are:
> 1. -m rmbat=0,reflink=1 -b size=4k (default)
> 2. -m crc=0 -b size=4k
> 3. -m crc=0 -b size=512
> 4. -m rmapbt=1,reflink=1 -b size=1k
> 5. -m rmapbt=1,reflink=1 -b size=4k
>
> This patch set is the only largish series that I selected, because:
> - It applies cleanly to 5.10.y
> - I evaluated it as low risk and high value
> - Chandan has written good regression tests
>
> I intend to post the rest of the individual selected patches
> for review in small batches after they pass the tests, but w.r.t this
> patch set -
>
> Does anyone object to including it in the stable kernel
> after it passes the tests?
>

Hi Amir,

The following three commits will have to be skipped from the series,

1. 02092a2f034fdeabab524ae39c2de86ba9ffa15a
   xfs: Check for extent overflow when renaming dir entries

2. 0dbc5cb1a91cc8c44b1c75429f5b9351837114fd
   xfs: Check for extent overflow when removing dir entries

3. f5d92749191402c50e32ac83dd9da3b910f5680f
   xfs: Check for extent overflow when adding dir entries

The maximum size of a directory data fork is ~96GiB. This is much smaller than
what can be accommodated by the existing data fork extent counter (i.e. 2^31
extents).

Also the corresponding test (i.e. xfs/533) has been removed from
fstests. Please refer to
https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?id=9ae10c882550c48868e7c0baff889bb1a7c7c8e9

-- 
chandan
