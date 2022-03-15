Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6445C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 09:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244068AbiCOJQ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 05:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiCOJQ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 05:16:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598364BBBF
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 02:15:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F8X41H019912;
        Tue, 15 Mar 2022 09:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JjzqE8GjMiv0RpTfK/aERu66w9NtRUel7CROIraytnI=;
 b=R8NwdnxlCjFqKTJskyulnNUamSYwmB7odsJ5J2bW9vm3gjvMSu8IDg/ZI+cs4USGu5sU
 gkjjkNsuhvTQgWh5TNtH6sIDIaHSu7rw8RvBzN0Yq7wsD7daMikI9th6rPzPuJc+AmmW
 o8+HyGlpCcpu+tphYbMGwgB69vU9NquqfVFrAMSlW5TnvRFH2nfM+hG0inPioDLKb4fg
 +rk6JAuhwnk06t5zLedhHunskdXeORh8SnYoW9cmSkcE8KJDypBa/TS3Ax+n1ZTmHBlN
 uH6X0B2EDSjH3xyJqgXyYfPymiEDMZ9fIFOGTMo9IgywHuIRYX3a5Iz9F+lZdDBMN+Nv Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5xwjfau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 09:15:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22F9AvU7171794;
        Tue, 15 Mar 2022 09:15:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3et65pe4de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 09:15:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/qoUhQtenFEZKYJbpcsbS+3RoTyL+GCy2fVJKallyt0JLXQRyPeGtEq/C2/8FcF74895DFpAuiXMEIBeYqmumE4aHXfYrfYnWbeamUYAbyYYEUTxc02XBXv8+quA1876ncjgPSi5cLPPhox09JwC2TbbGrE2SVhVYpTGf2Umal+w8UzB0rLJ+Hc7OLVAZVJRoFqSzTO1CBVlCC0IYqUME6Xtochj+Hnz3f34sHZ8UANnUMxKoRQ8HsFdaKVxqixMPSAjTDS80YUCIwgfGlUtlEvVVpNxAPoyYwnDDUQE3FbfL7b4ZC0GqTo2aZxWkL4gxAWW1QOgbQY0i3qo0J2mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjzqE8GjMiv0RpTfK/aERu66w9NtRUel7CROIraytnI=;
 b=D0/KaGTPZUZNRts39SuM6cz2czZPWQn5JrkYvaFNI9nN2geMCD22sRHCtfrJYxV4q0BPr7l61pn1AL/P4H8p0tB8Rl4U7G2ZPdDP277P2u2uiaKUQ/8kBCqmn9HRlHPaUBFPQUyfHCP9wM3+/qIYNj7Km7uyz0EHqzeLvZGcogHB3YpnpTkXkJis/IR0t3tOWydi+0oCL71wyUvCGbgFuiKZ4/tD6BZM1R8xRMtlkpdl+93jjGyeGIIOykyoiyW932AQoC+I8z+4KlvfxM7ecCp094Y2MoFp5UR1ej80K1DeeDSFnJ4lN4fEeLBTCOWjqkNX9qPR3WrSTopOML1tSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjzqE8GjMiv0RpTfK/aERu66w9NtRUel7CROIraytnI=;
 b=frZ8lFRyar0Asl6SdQcb8c4iYinYYFm7WUxCo+Ie1CVmWnMtVpgvJJcGrSmwZgwqhaBh6G0+fzxW6oV1J2rzocDooGdMwvnSgibgwiA5shkx1QPB3VIH4IdvpNXKG1xH5fM1bgJyIdVGyH2VPtb9HoGn48k8jNLSfihR+xuajEA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5551.namprd10.prod.outlook.com (2603:10b6:a03:3d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Tue, 15 Mar
 2022 09:15:08 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 09:15:08 +0000
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-2-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: log worker needs to start before intent/unlink
 recovery
In-reply-to: <20220315064241.3133751-2-david@fromorbit.com>
Message-ID: <87a6dr4lwt.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 15 Mar 2022 14:44:58 +0530
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::17)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ed5c53d-7f5b-4f88-770d-08da06644ca1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5551:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5551B51F8193E9F5FEFC0DFCF6109@SJ0PR10MB5551.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DbBhMa8KgjbCU1B6mJWwC+6q/ESwDxqM8z4tWTc6kZWqSh4w4WFJJFCryfIhAxj/HeOPm9hl4VhuZDa7DCK66fSf/Z9Qj9iVI8JBdTe7wBUVTpIKVEgoQ41lJZpOuQgW48J2weuC5o/Gcb+qbdDZOrxhFZs00wLyosq7G/euN32pHeCjraNtfXRDmCpLaBDM+URF0UVcbo4Q+raFQSzL9SYUFs+ILZCPDBVarOqFBYT3tnO8MAd1nz9aCUv8LkmsQhR6mPOxHgHAekny0CS9Q1zpFs1F0p7/IdEWoCJOedXe2R7spoClnfvb5i9EBB9tdQEFwCVJZI88Im87/H2YjQW9gpqDyRMHuVpBaw75YwpfspXDepoBr8CGCgTaEwnJsVL/Eazs3g44tvAg9UtqCdLE0LL/6ma5CwmMDi26PAxYf44M/xqq1MqG0Ge3B00HAOOXrKYPbAWCQfrVWZ3nNkS2vF0befrJD2rL4iwHRcVWIMOmySeU+VZVyy4ABJwmrpV+LYDcbTQhPsvY5T+wUMSl013O4+lv90N8X9avIL+mQRZigoxLTPZGdDvAUQ1y2xEFSyKQf+xm1HxDaVYKxcjQt7KgU1fAYkOmHAWXpmsPAHbPKE3ojq+toI+5UquS3SWhUC0qiU503ZlQkDGvi7HO+jg9+ANOPAubXOyv/2oTmE4caZPfNNndyPGnx9DkG+RNG7WfFdrXLOIcR5Rg7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8936002)(2906002)(83380400001)(5660300002)(6666004)(52116002)(53546011)(316002)(6916009)(6506007)(508600001)(6486002)(26005)(186003)(6512007)(9686003)(8676002)(4326008)(66476007)(66556008)(66946007)(38100700002)(38350700002)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iUfq25W3jrZUH8K5gJTDC0+bRV630y8APF16bplUXGnuTynBrqQWreu/LCsx?=
 =?us-ascii?Q?QNnGO0sC9VLIdieoMezoJzNkPNn5MKZ/lfm23LdV1YwfZX1mzZanK28MtFrP?=
 =?us-ascii?Q?h1K1+xIIsclZ5u4W+o7wSqBAQMsvRLCUTdPIgxumVNQXTqNWxOQvSAermLCD?=
 =?us-ascii?Q?K39xHOTXSo2OE/TKN1VfZBVeHl/loglwuNNgtpnW00ZBcQ1HPQTfmHm1T/+s?=
 =?us-ascii?Q?RRucsXK0WaHm0RFaN8TB9eNRJoIJg9+WBW7SjKHV1lJjWr6A/54CldaGEBzU?=
 =?us-ascii?Q?W9ZnQsW3d/cUOmZdMRK7aKNsoAnZWZZH2mRQydZ9IXpSUAlqi3AZhXCK9rI6?=
 =?us-ascii?Q?UyLIiT/Y6JS0U00+PZt24jqbdN7TIjqUXZVUykYTZ99el2ueud6V7DuCHZ6F?=
 =?us-ascii?Q?ZDoSaOJfRem1FjRa7TjmwIlQext28iq6WchoT2TS5D9uP1MnJ/GC7r7u6Pgi?=
 =?us-ascii?Q?TfKuGVMwFoUJXJ3LuCs05I1nu+sPN7julE/B88M85DfsGkhN/IVejRDnArVV?=
 =?us-ascii?Q?3QvxVBwIHwRzhbFKaAdYnqjMQRklEMBnziHst4reW8VGdjJN1BxfpXqSPFWs?=
 =?us-ascii?Q?o6r7xM3/JUI5HmCH7INCA/Hw0/6t6t6hmXsD1MV2QnLcl6Ue4fkYI2AzlXAI?=
 =?us-ascii?Q?EJw7cdGhaAxXhFxdFKwrwsA1swaLROq+SLAJpVSbQ0HemmJh/mXpKDIugvUQ?=
 =?us-ascii?Q?MObABYowTVX7TezTj7BlOS2Pf+eDFkhwxhXX/lrZfIMo+18l/uh0l1kotyOK?=
 =?us-ascii?Q?vt8o3m6sVP9Ki0Dke7wVvYSYRx9WiiC4tNMmwg5hfmsU/hqJSd5uTDZWNKXF?=
 =?us-ascii?Q?t/E2zfsIay39d+nHbToj56skEs1sgHBeUYYgRJ1DFfgBkcWl+/FIPO1bPfU/?=
 =?us-ascii?Q?QpB3KCUJejzE/iOc0dRH8O1siNuZ7JAdxM87GuVOTghmyDcuOx3E1uYnaw/u?=
 =?us-ascii?Q?oGlXa1O2TnDLgj4w6eHCidjdEA9mbzuN0TDfWML/33VP2Qupy7HVmUziWncb?=
 =?us-ascii?Q?QJ94eofxtTP9bTh0s/v8mzzg5tFJgjjtSgloVc+hmFwwrwpG3TbJ9ADoofmy?=
 =?us-ascii?Q?R1PxOooavUb5hmfCCB/jBOAvdbTY2Ir5Mr1yuTGIQtx2jMX4765k9GrEiSaB?=
 =?us-ascii?Q?ZQ8EdZ/+/p8kbjnSYUp/hMwMJKhUvbPZEGT/ZUjnZ790JhSxxd0kW5ZUTWQT?=
 =?us-ascii?Q?2IFbjfiPaQ2HOf2hR6d9AECIFZqOi6/eOs/lf8bMY8YOJZedfq6t5DCNoeP9?=
 =?us-ascii?Q?xqC57ZmUHYeqiavrRbBTab5HbrmpETOKnu2lWbqliX1MwLorPjF3Xt3Qm3m4?=
 =?us-ascii?Q?YPGhAz6ekaPUCET7bdzlmGA96LMMcCnK7n5bX3VaA4nVNncAzuALy/Y3saA8?=
 =?us-ascii?Q?jKP7qum+0voxnnlLY82C46zCx5JYYOv2D54D6vE+lkfYgtDrb1U3evUfpFa4?=
 =?us-ascii?Q?K0dJh7aJEcyePf6PP4g5sTVkcnIyg6R+4dAuJ+5iKzAJfwFnewsfdQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed5c53d-7f5b-4f88-770d-08da06644ca1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:15:08.1774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zI6CQmwAq5AMjAvGQupO8vADjSlOqLowHaf17V+iyrTbgGBYVbttxOGVdXecXSozDnjGIGdDQsIrw037FKoMBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150060
X-Proofpoint-GUID: HACqMhpGzNOjVwaAsiT9EwMWNzz3nnM0
X-Proofpoint-ORIG-GUID: HACqMhpGzNOjVwaAsiT9EwMWNzz3nnM0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15 Mar 2022 at 12:12, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> After 963 iterations of generic/530, it deadlocked during recovery
> on a pinned inode cluster buffer like so:
>
> XFS (pmem1): Starting recovery (logdev: internal)
> INFO: task kworker/8:0:306037 blocked for more than 122 seconds.
>       Not tainted 5.17.0-rc6-dgc+ #975
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/8:0     state:D stack:13024 pid:306037 ppid:     2 flags:0x00004000
> Workqueue: xfs-inodegc/pmem1 xfs_inodegc_worker
> Call Trace:
>  <TASK>
>  __schedule+0x30d/0x9e0
>  schedule+0x55/0xd0
>  schedule_timeout+0x114/0x160
>  __down+0x99/0xf0
>  down+0x5e/0x70
>  xfs_buf_lock+0x36/0xf0
>  xfs_buf_find+0x418/0x850
>  xfs_buf_get_map+0x47/0x380
>  xfs_buf_read_map+0x54/0x240
>  xfs_trans_read_buf_map+0x1bd/0x490
>  xfs_imap_to_bp+0x4f/0x70
>  xfs_iunlink_map_ino+0x66/0xd0
>  xfs_iunlink_map_prev.constprop.0+0x148/0x2f0
>  xfs_iunlink_remove_inode+0xf2/0x1d0
>  xfs_inactive_ifree+0x1a3/0x900
>  xfs_inode_unlink+0xcc/0x210
>  xfs_inodegc_worker+0x1ac/0x2f0
>  process_one_work+0x1ac/0x390
>  worker_thread+0x56/0x3c0
>  kthread+0xf6/0x120
>  ret_from_fork+0x1f/0x30
>  </TASK>
> task:mount           state:D stack:13248 pid:324509 ppid:324233 flags:0x00004000
> Call Trace:
>  <TASK>
>  __schedule+0x30d/0x9e0
>  schedule+0x55/0xd0
>  schedule_timeout+0x114/0x160
>  __down+0x99/0xf0
>  down+0x5e/0x70
>  xfs_buf_lock+0x36/0xf0
>  xfs_buf_find+0x418/0x850
>  xfs_buf_get_map+0x47/0x380
>  xfs_buf_read_map+0x54/0x240
>  xfs_trans_read_buf_map+0x1bd/0x490
>  xfs_imap_to_bp+0x4f/0x70
>  xfs_iget+0x300/0xb40
>  xlog_recover_process_one_iunlink+0x4c/0x170
>  xlog_recover_process_iunlinks.isra.0+0xee/0x130
>  xlog_recover_finish+0x57/0x110
>  xfs_log_mount_finish+0xfc/0x1e0
>  xfs_mountfs+0x540/0x910
>  xfs_fs_fill_super+0x495/0x850
>  get_tree_bdev+0x171/0x270
>  xfs_fs_get_tree+0x15/0x20
>  vfs_get_tree+0x24/0xc0
>  path_mount+0x304/0xba0
>  __x64_sys_mount+0x108/0x140
>  do_syscall_64+0x35/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>  </TASK>
> task:xfsaild/pmem1   state:D stack:14544 pid:324525 ppid:     2 flags:0x00004000
> Call Trace:
>  <TASK>
>  __schedule+0x30d/0x9e0
>  schedule+0x55/0xd0
>  io_schedule+0x4b/0x80
>  xfs_buf_wait_unpin+0x9e/0xf0
>  __xfs_buf_submit+0x14a/0x230
>  xfs_buf_delwri_submit_buffers+0x107/0x280
>  xfs_buf_delwri_submit_nowait+0x10/0x20
>  xfsaild+0x27e/0x9d0
>  kthread+0xf6/0x120
>  ret_from_fork+0x1f/0x30
>
> We have the mount process waiting on an inode cluster buffer read,
> inodegc doing unlink waiting on the same inode cluster buffer, and
> the AIL push thread blocked in writeback waiting for the inode to
> become unpinned.

... "waiting for the inode cluster buffer to become unpinned"?.

Periodic flushing of the current CIL context by the log worker task will
clearly break the deadlock described in this patch. I don't see any negative
side effects of the change presented here. Hence,

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> What has happened here is that the AIL push thread has raced with
> the inodegc process modifying, committing and pinning the inode
> cluster buffer here in xfs_buf_delwri_submit_buffers() here:
>
> 	blk_start_plug(&plug);
> 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
> 		if (!wait_list) {
> 			if (xfs_buf_ispinned(bp)) {
> 				pinned++;
> 				continue;
> 			}
> Here >>>>>>
> 			if (!xfs_buf_trylock(bp))
> 				continue;
>
> Basically, the AIL has found the buffer wasn't pinned and got the
> lock without blocking, but then the buffer was pinned. This implies
> the processing here was pre-empted between the pin check and the
> lock, because the pin count can only be increased while holding the
> buffer locked. Hence when it has gone to submit the IO, it has
> blocked waiting for the buffer to be unpinned.
>
> With all executing threads now waiting on the buffer to be unpinned,
> we normally get out of situations like this via the background log
> worker issuing a log force which will unpinned stuck buffers like
> this. But at this point in recovery, we haven't started the log
> worker. In fact, the first thing we do after processing intents and
> unlinked inodes is *start the log worker*. IOWs, we start it too
> late to have it break deadlocks like this.
>
> Avoid this and any other similar deadlock vectors in intent and
> unlinked inode recovery by starting the log worker before we recover
> intents and unlinked inodes. This part of recovery runs as though
> the filesystem is fully active, so we really should have the same
> infrastructure running as we normally do at runtime.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 9a49acd94516..b0e05fa902d4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -833,10 +833,9 @@ xfs_log_mount_finish(
>  	 * mount failure occurs.
>  	 */
>  	mp->m_super->s_flags |= SB_ACTIVE;
> +	xfs_log_work_queue(mp);
>  	if (xlog_recovery_needed(log))
>  		error = xlog_recover_finish(log);
> -	if (!error)
> -		xfs_log_work_queue(mp);
>  	mp->m_super->s_flags &= ~SB_ACTIVE;
>  	evict_inodes(mp->m_super);


-- 
chandan
