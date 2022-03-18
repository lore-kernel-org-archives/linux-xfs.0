Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CA7C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 11:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbiCRLcf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 07:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbiCRLc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 07:32:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98F31FAA39
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 04:31:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22I9Ckqe009049;
        Fri, 18 Mar 2022 11:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6EX7XFiQkjmihKITbe6wQqyPs6U3XKohMMr7TJVTqsI=;
 b=UXc3TotPsrSSWqdLhY6xaTjB7xxn8sAe4BobmnCFOu/Pg29Wwt3V3fANpug7vu1PuJqK
 pvlcpjPQeT6UjYKnAVGc8hmOXwwyI5KSkriKorTO+uhz039XRK889bwvCcBl2HqW5eXk
 rwA1jQPpCAxyk/oq5ibBbE1n1mYmoEES1q+f8SRuxypwVG2FSAT8Te2+WZVLW0Vu/i44
 tmFBIi9c1taolpBcmUlnDlQI5/+CqDQ2yECFealYGBuM82g4XpspZDO6rcw8elagfTSm
 FLXnGaBFAksGdimnJUKDi1c6CXuqKhEweoJtnfJ4YpafIctKWosUVme1xigFFJctMLPh vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et52q3q96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 11:31:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22IBGiOs080250;
        Fri, 18 Mar 2022 11:31:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by userp3020.oracle.com with ESMTP id 3et65a6bgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 11:31:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgXDdXdhjd6tJn7drf+DsmStPsDV6mWCgnPsfqb5R45BHIan/Is//Iim/Dol7vL/85UO+tR78DxrYzdXpbtPYH13Ieeeq9saFH5scmomwnZxXt4d4KgK1FkXKyMynBA+hj+xmYqZwdXtca13W+XCF0Dfs3fEzcy7Q2zzrwiH5mDlwdpf1s3xbC1d/ptzMr3NZPYGgUUcRNmB4pH6A+nohJpQ6mEpkfKn4mJ5bINvZ2TLNkNacVvEOSkZasfAh06io7eW/yni+1P7qP/y58oURu2pf7S61wB18PL/2AowkrsZAQk/qkAsb8T9TLf8MX21ytFwLat6j3qWUXyjIvta7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6EX7XFiQkjmihKITbe6wQqyPs6U3XKohMMr7TJVTqsI=;
 b=Ob9r/E+1VHvXDQX8tdSURE+3qW9Fci9z0EKgAxlt9N7pLZWoMZN/w3ASOql61QCFakYnLXgSqDzFuT71IDBYC4BMRYDCbeKvEuH5Iob+jklMVuOPAF390vx/KiSUhfpjOv7vYMEWZsscvFaU0OCEg2dWjk2QZtJALoWHwm8tp2QKkFUCbqsIh7qG7tU8lN+YitwVQU3JC8i/U1JU+kXK1/nnHfUCBCNPhu6hmX/q4cT2q1co9UWn4aFL0u7fs8gp7cYcmo+pOEDIlf1VBEsQi/L/v0gptAeLgFfyX1EdJp4fF+AQs2bdAU1CIfHtr3L2VxnVqaQTLelN4HqYNqlx7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EX7XFiQkjmihKITbe6wQqyPs6U3XKohMMr7TJVTqsI=;
 b=HvTKfh4NE2MWJ2hP0pEf1xmj8SP0Xj4f53l2CCNYD9ChwoLSYRyFlZHL3Z6gsci99ZGlwH7156pcSLtDYjAjwnCaTkP2DRi3QzPiO3jScPUpWG+U3Z8RLr+3O6CzkS1YsLX4Bh2dMt6zh5XHG+3m0vVm/XES0SS6S54yNoSPOBE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CY4PR1001MB2216.namprd10.prod.outlook.com (2603:10b6:910:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 11:31:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 11:31:03 +0000
References: <20220317053907.164160-1-david@fromorbit.com>
 <20220317053907.164160-8-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: xfs_is_shutdown vs xlog_is_shutdown cage fight
In-reply-to: <20220317053907.164160-8-david@fromorbit.com>
Message-ID: <874k3vcxar.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 18 Mar 2022 17:00:52 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0128.apcprd06.prod.outlook.com
 (2603:1096:1:1d::30) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efb81ee1-e2a4-4c90-c75a-08da08d2c86d
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2216:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB2216B686EA7ACE2A08951EB1F6139@CY4PR1001MB2216.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UeU9pxnDJ8uhSn8S+C9pVZmbb9n2flpfRhDwq+5EW6JRDao4X4hNdWxwco9kR09UeGQx4f8+Qx1hIsOCmgWMdKK+n2e1uFYqYvok6X44N0uyqZHuP8sVEfaLxI4n7Ab/XFjvNr0ysQzXgQfavYB853v2H17unfvFLBGIzlRWgs8rVHCmDyU3qT7Ic1xB8DPkBI/KYE7NhGvcdUXXRcuKU5VrCdqsDXB9SNSywGG4z/exRQU0EzOPMS6J/oG4i0t2g786k1wmS2T6GChu3nWmJesf5NH7IBspxDB8ojPKo8UGrpl+w3LvP8IRnCsNHoCEr1auy0QAC9FO0gBYSb37Z9kZbw13TxnS5RtH5A1YNkeKTavRUHR7XGLE72iDG4O0nFd9BUxl91TPqaPxCUK1HH/VEFgRrG3jtUZoShBW1WZ17I1B5zd0R9VXGuQoYcScw7eapZGqlAajOj7WMWPsogL65KjhcHAFbypShChc65s+jkIcfQDx46rHSCu6a3UQlbACvZnQpbyT42GrNyzEGNYrFHoALvk8WNW6WjhbOF6t4PQAOOEbOkmv5bJiQO0DEi4+DQuFU0Z2bIvN50+ZsfW0XGqC5qqQc5xGM8MA81RIpSq7yVnKpBQrq/dpGc6/s4Ph1ROv7ul+laLbdcxWVI4Qbv46jkX97kJHIFII2J5C02k/2OMfI0vgBk/AHY+sxEsEroKPD3eM5rSVLxTiXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6916009)(316002)(6666004)(6512007)(9686003)(6506007)(186003)(52116002)(26005)(53546011)(6486002)(83380400001)(5660300002)(508600001)(8936002)(30864003)(86362001)(2906002)(38350700002)(38100700002)(8676002)(4326008)(66556008)(33716001)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rh6Gk/cyrA/FguN/iB9mEyFZYxOeTm17jyjIrYXGb12u2TDdZJt2oKL7VCgm?=
 =?us-ascii?Q?0aIccaM49QOxkR8uUiUhV1tUAF0TmvFShyrEnzAg7Q1PEYxg5X/8myCycaYn?=
 =?us-ascii?Q?E9vYiEPPouKzqs0EKELkWO5ttqpQFxUalHrLyQGxdJQdHEKTgVZTQz9gRSck?=
 =?us-ascii?Q?xNOqr7/82K82wh3sTPB2ZsZm6wNikpowNe9+rjpvHj3xKk7cM9UuZe5DIwjr?=
 =?us-ascii?Q?kjJsFuBKoNGWKrdT92eEIjva5wKg1l56+Wan3mps2XmL2HfmYy2McHNuikdL?=
 =?us-ascii?Q?w00Sh/1Uq2k5Q13LjSP4s632ZJDcYrtJHxj9ytW9Ztq4jbR0/Ja6ZNN9/xLi?=
 =?us-ascii?Q?kjbIko3GLazPvneJ3/ZJp7gkI+jBievOzT7P3reoEKlWQL6HAup3XsfscXz5?=
 =?us-ascii?Q?19GEwTBLwo8NoCbGNTJ7IdJfLL/+0o9qmBqeMEemWprhRJyATBs4L0nZc6Mc?=
 =?us-ascii?Q?J9/45GVZMxCzSsNi0YQDiQ4n5VbTwsTQewKBGxgKfAYTQXIrxohqK9ehtljA?=
 =?us-ascii?Q?FRA7Qf2G9MLFGQgwqt968/B46iTfUlelFJEjRPgSpY5ac3od+BArhGlQF9B5?=
 =?us-ascii?Q?C453cqzxQuNY94epDofA8F8p0EcoJ40MkM+FEbv4wK4MkeAypZeV3wyzxjIs?=
 =?us-ascii?Q?nnEqnnoKmSLQUy6uup/+BuWHukGQrI79xPvvAQocRcR6qPHq5lyTRJ1CDPLg?=
 =?us-ascii?Q?/QSLAyNQ0BDmTEPXbysGtYW1J/mvSIDZNpWKhk6MnljWZ8DvH2q1VZ2+i4Qr?=
 =?us-ascii?Q?QnkOlpSt4yaBQxrfisiuWs+klTsXDgMkeDhU3KSVwri+AphpoEzPwY2NRAXR?=
 =?us-ascii?Q?EovPiAY1wnlfNXtgxqtGMlgnnrX1OPkYMFnV9kt9urnMxRsQAYcjbneT8jdy?=
 =?us-ascii?Q?XpZt6c352gKLhWGtv6AAvseLYS1GZopmEJfq3EobS8zveIl/k8Wi7FvMHXJB?=
 =?us-ascii?Q?U94bKkvT7gbhCUhYszkPSn5zgSIg20XNMZ7joFy1LdT3uIko67dYYS4oULgh?=
 =?us-ascii?Q?GDo9OOey5i6sWsMBy+6/i6oRzDn/jCwsf6409dgUq0PHNHBWnr3SLNwNQ9zG?=
 =?us-ascii?Q?QjxLrLraM9XM/PGi14/yjU4ojX9Tec3Jk+3lkd0xiCFZpMhvC/gfgSz2sZS1?=
 =?us-ascii?Q?np5+50Ebwq44M++US6YzBKz9abKyEnZmHk6TZ4KZ/ljv+UsjGCur2WirYFpL?=
 =?us-ascii?Q?1n1rGTEHf78hN07YGYtA6VYFHwpeKSit5ah9HJZ6fMPLDdvUlfprLKM4JbXX?=
 =?us-ascii?Q?MGNJPifatscNE3iFGrOwdoeKAd0ctp690CaBx/s0ORfbMkv1ncaPyhKQSoFb?=
 =?us-ascii?Q?LCJCU3yDWukV4KOf0K2kttk7r7MHJcVf1MS+jG8tb4zlceHN1qwi8Of0z2CS?=
 =?us-ascii?Q?7hRKTw8GbZGrkXuDI/shtjGOPlI4QhSgEJ3+marGaRtxSwiuxsUROl+UTiTV?=
 =?us-ascii?Q?e34UR2iLjCVaMJWrxTz/z/fN4p+g/nEz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb81ee1-e2a4-4c90-c75a-08da08d2c86d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 11:31:03.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V4zlyewMeGdDvyJG/njMLv4DFMLq10I7lDUbYAlCo8jMhil2MPqzWUwebeQ0PjTEnEfpztfMqAbcMsjJwhifjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2216
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10289 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180063
X-Proofpoint-GUID: QfXB070s1L6-8JA4AebdRoVEUzVwa7ay
X-Proofpoint-ORIG-GUID: QfXB070s1L6-8JA4AebdRoVEUzVwa7ay
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 17 Mar 2022 at 11:09, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> I've been chasing a recent resurgence in generic/388 recovery
> failure and/or corruption events. The events have largely been
> uninitialised inode chunks being tripped over in log recovery
> such as:
>
>  XFS (pmem1): User initiated shutdown received.
>  pmem1: writeback error on inode 12621949, offset 1019904, sector 12968096
>  XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xa3/0xf0 (fs/xfs/xfs_fsops.c:500).  Shutting down filesystem.
>  XFS (pmem1): Please unmount the filesystem and rectify the problem(s)
>  XFS (pmem1): Unmounting Filesystem
>  XFS (pmem1): Mounting V5 Filesystem
>  XFS (pmem1): Starting recovery (logdev: internal)
>  XFS (pmem1): bad inode magic/vsn daddr 8723584 #0 (magic=1818)
>  XFS (pmem1): Metadata corruption detected at xfs_inode_buf_verify+0x180/0x190, xfs_inode block 0x851c80 xfs_inode_buf_verify
>  XFS (pmem1): Unmount and run xfs_repair
>  XFS (pmem1): First 128 bytes of corrupted metadata buffer:
>  00000000: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000010: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000020: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000030: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000040: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000050: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000060: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000070: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  XFS (pmem1): metadata I/O error in "xlog_recover_items_pass2+0x52/0xc0" at daddr 0x851c80 len 32 error 117
>  XFS (pmem1): log mount/recovery failed: error -117
>  XFS (pmem1): log mount failed
>
> There have been isolated random other issues, too - xfs_repair fails
> because it finds some corruption in symlink blocks, rmap
> inconsistencies, etc - but they are nowhere near as common as the
> uninitialised inode chunk failure.
>
> The problem has clearly happened at runtime before recovery has run;
> I can see the ICREATE log item in the log shortly before the
> actively recovered range of the log. This means the ICREATE was
> definitely created and written to the log, but for some reason the
> tail of the log has been moved past the ordered buffer log item that
> tracks INODE_ALLOC buffers and, supposedly, prevents the tail of the
> log moving past the ICREATE log item before the inode chunk buffer
> is written to disk.
>
> Tracing the fsstress processes that are running when the filesystem
> shut down immediately pin-pointed the problem:
>
> user shutdown marks xfs_mount as shutdown
>
>          godown-213341 [008]  6398.022871: console:              [ 6397.915392] XFS (pmem1): User initiated shutdown received.
> .....
>
> aild tries to push ordered inode cluster buffer
>
>   xfsaild/pmem1-213314 [001]  6398.022974: xfs_buf_trylock:      dev 259:1 daddr 0x851c80 bbcount 0x20 hold 16 pincount 0 lock 0 flags DONE|INODES|PAGES caller xfs_inode_item_push+0x8e
>   xfsaild/pmem1-213314 [001]  6398.022976: xfs_ilock_nowait:     dev 259:1 ino 0x851c80 flags ILOCK_SHARED caller xfs_iflush_cluster+0xae
>
> xfs_iflush_cluster() checks xfs_is_shutdown(), returns true,
> calls xfs_iflush_abort() to kill writeback of the inode.
> Inode is removed from AIL, drops cluster buffer reference.
>
>   xfsaild/pmem1-213314 [001]  6398.022977: xfs_ail_delete:       dev 259:1 lip 0xffff88880247ed80 old lsn 7/20344 new lsn 7/21000 type XFS_LI_INODE flags IN_AIL
>   xfsaild/pmem1-213314 [001]  6398.022978: xfs_buf_rele:         dev 259:1 daddr 0x851c80 bbcount 0x20 hold 17 pincount 0 lock 0 flags DONE|INODES|PAGES caller xfs_iflush_abort+0xd7
>
> .....
>
> All inodes on cluster buffer are aborted, then the cluster buffer
> itself is aborted and removed from the AIL *without writeback*:
>
> xfsaild/pmem1-213314 [001]  6398.023011: xfs_buf_error_relse:  dev 259:1 daddr 0x851c80 bbcount 0x20 hold 2 pincount 0 lock 0 flags ASYNC|DONE|STALE|INODES|PAGES caller xfs_buf_ioend_fail+0x33
>    xfsaild/pmem1-213314 [001]  6398.023012: xfs_ail_delete:       dev 259:1 lip 0xffff8888053efde8 old lsn 7/20344 new lsn 7/20344 type XFS_LI_BUF flags IN_AIL
>
> The inode buffer was at 7/20344 when it was removed from the AIL.
>
>    xfsaild/pmem1-213314 [001]  6398.023012: xfs_buf_item_relse:   dev 259:1 daddr 0x851c80 bbcount 0x20 hold 2 pincount 0 lock 0 flags ASYNC|DONE|STALE|INODES|PAGES caller xfs_buf_item_done+0x31
>    xfsaild/pmem1-213314 [001]  6398.023012: xfs_buf_rele:         dev 259:1 daddr 0x851c80 bbcount 0x20 hold 2 pincount 0 lock 0 flags ASYNC|DONE|STALE|INODES|PAGES caller xfs_buf_item_relse+0x39
>
> .....
>
> Userspace is still running, doing stuff. an fsstress process runs
> syncfs() or sync() and we end up in sync_fs_one_sb() which issues
> a log force. This pushes on the CIL:
>
>         fsstress-213322 [001]  6398.024430: xfs_fs_sync_fs:       dev 259:1 m_features 0x20000000019ff6e9 opstate (clean|shutdown|inodegc|blockgc) s_flags 0x70810000 caller sync_fs_one_sb+0x26
>         fsstress-213322 [001]  6398.024430: xfs_log_force:        dev 259:1 lsn 0x0 caller xfs_fs_sync_fs+0x82
>         fsstress-213322 [001]  6398.024430: xfs_log_force:        dev 259:1 lsn 0x5f caller xfs_log_force+0x7c
>            <...>-194402 [001]  6398.024467: kmem_alloc:           size 176 flags 0x14 caller xlog_cil_push_work+0x9f
>
> And the CIL fills up iclogs with pending changes. This picks up
> the current tail from the AIL:
>
>            <...>-194402 [001]  6398.024497: xlog_iclog_get_space: dev 259:1 state XLOG_STATE_ACTIVE refcnt 1 offset 0 lsn 0x0 flags  caller xlog_write+0x149
>            <...>-194402 [001]  6398.024498: xlog_iclog_switch:    dev 259:1 state XLOG_STATE_ACTIVE refcnt 1 offset 0 lsn 0x700005408 flags  caller xlog_state_get_iclog_space+0x37e
>            <...>-194402 [001]  6398.024521: xlog_iclog_release:   dev 259:1 state XLOG_STATE_WANT_SYNC refcnt 1 offset 32256 lsn 0x700005408 flags  caller xlog_write+0x5f9
>            <...>-194402 [001]  6398.024522: xfs_log_assign_tail_lsn: dev 259:1 new tail lsn 7/21000, old lsn 7/20344, last sync 7/21448
>
> And it moves the tail of the log to 7/21000 from 7/20344. This
> *moves the tail of the log beyond the ICREATE transaction* that was
> at 7/20344 and pinned by the inode cluster buffer that was cancelled
> above.
>
> ....
>
>          godown-213341 [008]  6398.027005: xfs_force_shutdown:   dev 259:1 tag logerror flags log_io|force_umount file fs/xfs/xfs_fsops.c line_num 500
>           godown-213341 [008]  6398.027022: console:              [ 6397.915406] pmem1: writeback error on inode 12621949, offset 1019904, sector 12968096
>           godown-213341 [008]  6398.030551: console:              [ 6397.919546] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xa3/0xf0 (fs/
>
> And finally the log itself is now shutdown, stopping all further
> writes to the log. But this is too late to prevent the corruption
> that moving the tail of the log forwards after we start cancelling
> writeback causes.
>
> The fundamental problem here is that we are using the wrong shutdown
> checks for log items. We've long conflated mount shutdown with log
> shutdown state, and I started separating that recently with the
> atomic shutdown state changes in commit b36d4651e165 ("xfs: make
> forced shutdown processing atomic"). The changes in that commit
> series are directly responsible for being able to diagnose this
> issue because it clearly separated mount shutdown from log shutdown.
>
> Essentially, once we start cancelling writeback of log items and
> removing them from the AIL because the filesystem is shut down, we
> *cannot* update the journal because we may have cancelled the items
> that pin the tail of the log. That moves the tail of the log
> forwards without having written the metadata back, hence we have
> corrupt in memory state and writing to the journal propagates that
> to the on-disk state.
>
> What commit b36d4651e165 makes clear is that log item state needs to
> change relative to log shutdown, not mount shutdown. IOWs, anything
> that aborts metadata writeback needs to check log shutdown state
> because log items directly affect log consistency. Having them check
> mount shutdown state introduces the above race condition where we
> cancel metadata writeback before the log shuts down.
>
> To fix this, this patch works through all log items and converts
> shutdown checks to use xlog_is_shutdown() rather than
> xfs_is_shutdown(), so that we don't start aborting metadata
> writeback before we shut off journal writes.
>
> AFAICT, this race condition is a zero day IO error handling bug in
> XFS that dates back to the introduction of XLOG_IO_ERROR,
> XLOG_STATE_IOERROR and XFS_FORCED_SHUTDOWN back in January 1997.
>

All the invocations of xfs_is_shutdown() replaced by xlog_is_shutdown() are
correct. The analysis posted above also looks correct.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c        | 40 ++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_icache.c     | 10 +++++++++-
>  fs/xfs/xfs_inode.c      | 15 +++++++++++++--
>  fs/xfs/xfs_inode_item.c | 12 ++++++++++++
>  fs/xfs/xfs_qm.c         |  8 ++++----
>  5 files changed, 70 insertions(+), 15 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8867f143598e..3617d9d2bc73 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -14,6 +14,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  #include "xfs_log_recover.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
> @@ -813,7 +814,15 @@ xfs_buf_read_map(
>  	 * buffer.
>  	 */
>  	if (error) {
> -		if (!xfs_is_shutdown(target->bt_mount))
> +		/*
> +		 * Check against log shutdown for error reporting because
> +		 * metadata writeback may require a read first and we need to
> +		 * report errors in metadata writeback until the log is shut
> +		 * down. High level transaction read functions already check
> +		 * against mount shutdown, anyway, so we only need to be
> +		 * concerned about low level IO interactions here.
> +		 */
> +		if (!xlog_is_shutdown(target->bt_mount->m_log))
>  			xfs_buf_ioerror_alert(bp, fa);
>  
>  		bp->b_flags &= ~XBF_DONE;
> @@ -1177,10 +1186,10 @@ xfs_buf_ioend_handle_error(
>  	struct xfs_error_cfg	*cfg;
>  
>  	/*
> -	 * If we've already decided to shutdown the filesystem because of I/O
> -	 * errors, there's no point in giving this a retry.
> +	 * If we've already shutdown the journal because of I/O errors, there's
> +	 * no point in giving this a retry.
>  	 */
> -	if (xfs_is_shutdown(mp))
> +	if (xlog_is_shutdown(mp->m_log))
>  		goto out_stale;
>  
>  	xfs_buf_ioerror_alert_ratelimited(bp);
> @@ -1593,8 +1602,23 @@ __xfs_buf_submit(
>  
>  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  
> -	/* on shutdown we stale and complete the buffer immediately */
> -	if (xfs_is_shutdown(bp->b_mount)) {
> +	/*
> +	 * On log shutdown we stale and complete the buffer immediately. We can
> +	 * be called to read the superblock before the log has been set up, so
> +	 * be careful checking the log state.
> +	 *
> +	 * Checking the mount shutdown state here can result in the log tail
> +	 * moving inappropriately on disk as the log may not yet be shut down.
> +	 * i.e. failing this buffer on mount shutdown can remove it from the AIL
> +	 * and move the tail of the log forwards without having written this
> +	 * buffer to disk. This corrupts the log tail state in memory, and
> +	 * because the log may not be shut down yet, it can then be propagated
> +	 * to disk before the log is shutdown. Hence we check log shutdown
> +	 * state here rather than mount state to avoid corrupting the log tail
> +	 * on shutdown.
> +	 */
> +	if (bp->b_mount->m_log &&
> +	    xlog_is_shutdown(bp->b_mount->m_log)) {
>  		xfs_buf_ioend_fail(bp);
>  		return -EIO;
>  	}
> @@ -1808,10 +1832,10 @@ xfs_buftarg_drain(
>  	 * If one or more failed buffers were freed, that means dirty metadata
>  	 * was thrown away. This should only ever happen after I/O completion
>  	 * handling has elevated I/O error(s) to permanent failures and shuts
> -	 * down the fs.
> +	 * down the journal.
>  	 */
>  	if (write_fail) {
> -		ASSERT(xfs_is_shutdown(btp->bt_mount));
> +		ASSERT(xlog_is_shutdown(btp->bt_mount->m_log));
>  		xfs_alert(btp->bt_mount,
>  	      "Please run xfs_repair to determine the extent of the problem.");
>  	}
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 9644f938990c..4148cdf7ce4a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -23,6 +23,7 @@
>  #include "xfs_reflink.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_ag.h"
> +#include "xfs_log_priv.h"
>  
>  #include <linux/iversion.h>
>  
> @@ -873,7 +874,14 @@ xfs_reclaim_inode(
>  	if (xfs_iflags_test_and_set(ip, XFS_IFLUSHING))
>  		goto out_iunlock;
>  
> -	if (xfs_is_shutdown(ip->i_mount)) {
> +	/*
> +	 * Check for log shutdown because aborting the inode can move the log
> +	 * tail and corrupt in memory state. This is fine if the log is shut
> +	 * down, but if the log is still active and only the mount is shut down
> +	 * then the in-memory log tail movement caused by the abort can be
> +	 * incorrectly propagated to disk.
> +	 */
> +	if (xlog_is_shutdown(ip->i_mount->m_log)) {
>  		xfs_iunpin_wait(ip);
>  		xfs_iflush_abort(ip);
>  		goto reclaim;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 04bf467b1090..aab55a06ece7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -35,6 +35,7 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ag.h"
> +#include "xfs_log_priv.h"
>  
>  struct kmem_cache *xfs_inode_cache;
>  
> @@ -3659,7 +3660,7 @@ xfs_iflush_cluster(
>  		 * AIL, leaving a dirty/unpinned inode attached to the buffer
>  		 * that otherwise looks like it should be flushed.
>  		 */
> -		if (xfs_is_shutdown(mp)) {
> +		if (xlog_is_shutdown(mp->m_log)) {
>  			xfs_iunpin_wait(ip);
>  			xfs_iflush_abort(ip);
>  			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> @@ -3685,9 +3686,19 @@ xfs_iflush_cluster(
>  	}
>  
>  	if (error) {
> +		/*
> +		 * Shutdown first so we kill the log before we release this
> +		 * buffer. If it is an INODE_ALLOC buffer and pins the tail
> +		 * of the log, failing it before the _log_ is shut down can
> +		 * result in the log tail being moved forward in the journal
> +		 * on disk because log writes can still be taking place. Hence
> +		 * unpinning the tail will allow the ICREATE intent to be
> +		 * removed from the log an recovery will fail with uninitialised
> +		 * inode cluster buffers.
> +		 */
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  		return error;
>  	}
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 90d8e591baf8..11158fa81a09 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -17,6 +17,7 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_error.h"
>  
>  #include <linux/iversion.h>
> @@ -720,6 +721,17 @@ xfs_iflush_ail_updates(
>  		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn)
>  			continue;
>  
> +		/*
> +		 * dgc: Not sure how this happens, but it happens very
> +		 * occassionaly via generic/388.  xfs_iflush_abort() also
> +		 * silently handles this same "under writeback but not in AIL at
> +		 * shutdown" condition via xfs_trans_ail_delete().
> +		 */
> +		if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> +			ASSERT(xlog_is_shutdown(lip->li_log));
> +			continue;
> +		}
> +
>  		lsn = xfs_ail_delete_one(ailp, lip);
>  		if (!tail_lsn && lsn)
>  			tail_lsn = lsn;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 32ac8d9c8940..f165d1a3de1d 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -25,6 +25,7 @@
>  #include "xfs_error.h"
>  #include "xfs_ag.h"
>  #include "xfs_ialloc.h"
> +#include "xfs_log_priv.h"
>  
>  /*
>   * The global quota manager. There is only one of these for the entire
> @@ -121,8 +122,7 @@ xfs_qm_dqpurge(
>  	struct xfs_dquot	*dqp,
>  	void			*data)
>  {
> -	struct xfs_mount	*mp = dqp->q_mount;
> -	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> +	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
>  	int			error = -EAGAIN;
>  
>  	xfs_dqlock(dqp);
> @@ -157,7 +157,7 @@ xfs_qm_dqpurge(
>  	}
>  
>  	ASSERT(atomic_read(&dqp->q_pincount) == 0);
> -	ASSERT(xfs_is_shutdown(mp) ||
> +	ASSERT(xlog_is_shutdown(dqp->q_logitem.qli_item.li_log) ||
>  		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
>  
>  	xfs_dqfunlock(dqp);
> @@ -172,7 +172,7 @@ xfs_qm_dqpurge(
>  	 */
>  	ASSERT(!list_empty(&dqp->q_lru));
>  	list_lru_del(&qi->qi_lru, &dqp->q_lru);
> -	XFS_STATS_DEC(mp, xs_qm_dquot_unused);
> +	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
>  
>  	xfs_qm_dqdestroy(dqp);
>  	return 0;


-- 
chandan
