Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8716CEB64D8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 15:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbjFTPR0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 11:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbjFTPRL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 11:17:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63DE1FCD
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 08:16:33 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35KBepEd013014;
        Tue, 20 Jun 2023 15:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=oDNyOzAAeKdUG2ddmBAkwYSu3yKCifVJnyO0bnFqETo=;
 b=t6liri6LD1xDVFWkTxYDuH4wwe+5hBvlFq0TKS4V9iFufrYd8bNh7+lVl67Cz0vtZ763
 oEpDaiYcOEMzIf/14NYFLifQPT8EvXnJW5RWO6E8rL+NWc1EmLVYpzGx7DO2WXucUCS5
 a5/KZix69cpPubJBFQ6ApJ51CEm7Y1tP+9uS8Fdiyzm3qM+Jk4UpCveQsOedQwFdlzPv
 CfVRgBUsmzgoZ8hKieGSoBwzgaWBbpbbm60zyMdmuZtLof4FZYNhtEd47VRQRiFXYRYD
 P8X37bsQu4ib0DxjInOhGOEBbF4s0lWZ3C0223oh8f5ulnYREaWYLxiRPGmqxISLfL3d SQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r93rbn2yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jun 2023 15:16:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35KEKpEn005799;
        Tue, 20 Jun 2023 15:16:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r9394gky3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jun 2023 15:16:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcVizS4DKnHTUSdZ/TZnf67sS9dhbXHpLOjpOpBat5jEhlvIp1zLLShG1W7qkgI/PtZMlOVJbd4nAWCEMypLOKLxeGAxVzFIcKNiAdYOQnUr6qXRikW9PvdV6Jgm/ENp7jYJw9CaPJECxxE7r674QHIydUZYxlYTdnDlFTs33sMbdhdCbX91iXpjGL7frJJRyuWuYeAWzpRB5kB+xFGKSnjfahbI4KDHb6Qwj6e5zNGD6ICUb5hZ0LTmzpAlWPVbztxvNnXBHUW0jLeoNW3OxxEwWew0OPYPf5CUMvsmLPwqbgUss1PxqbpPsfqFM3evw+qHYKI1Yf+sA9o8TeI9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDNyOzAAeKdUG2ddmBAkwYSu3yKCifVJnyO0bnFqETo=;
 b=QW1EdrQBBEq4HgRLKz+0+nTCJS8HavnumJm851M2J6HJ3dVqSCpMhAr31mz9YoD1ESTvVpxLxCZ4/cT7mTLbODR30Lsa1l+uS6jsBrb2E2L5Ib5RwBsumtIVP7n9GeTm6lcT32LbevnDQq00b68e5AJbbxh2AZpY31bEmK4WaRX/tPa6XBEKCzJGUyg+m0uAUmzfg2rNKGyZFWZ69gKxAhyPvIlp/CBZN9/DnxyKHqoPRgtib2HMZV588a/PIHudxGKoI4WWAWT5bweBPMUBzhvhwq7R6hDEiuW0r98w5NeyoYOIYXniMlrikpX81wTIBE5XL9ySw4PTKw3qmdTzQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDNyOzAAeKdUG2ddmBAkwYSu3yKCifVJnyO0bnFqETo=;
 b=bnyuiqFaVwAkCie+euMHLmDXueRq+F5S9RthdW5Km4bnLqxRJAVrtlPPzvjfZNGiK04qO7TDi4D8CAmv2yJHK26IuG43P6oDSnFW7CyqH/PMlpmdTNnh+GrgsGd2Ra5W2bLYP7Mme2mbnieC6PMe9LbAtXSnyG36jLY0ThcyZNA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB5812.namprd10.prod.outlook.com (2603:10b6:303:18e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Tue, 20 Jun
 2023 15:16:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17%6]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 15:16:03 +0000
References: <20230620002021.1038067-1-david@fromorbit.com>
 <20230620002021.1038067-5-david@fromorbit.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: don't block in busy flushing when freeing extents
Date:   Tue, 20 Jun 2023 20:23:33 +0530
In-reply-to: <20230620002021.1038067-5-david@fromorbit.com>
Message-ID: <87a5wumafo.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:194::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: 0143cf52-bdbb-42d1-f2e0-08db71a142eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xjn1H8LALILzSIjwM2h0mwftqajBBJxuIScjxvfcsP06K7BjaevuBvl3iiflNTuLfRl4Ri9VOAvNNEnXMxh9aNxeQTQQXs7BPeDSyox9MbpVZnwGImiqvBgo+iUh9kMR2GVYf88wWMP/PGJnkHnGv07dQlz3TFyMKO2lftv76DW+peuzfPxermMQWYFKdQOv5u1kWsp5cZ6LZQ7X/q9GzcqZK/a2MuHRV+e0OvlcevjMneZha8ZFUnEACbDp4iG/EHxrndpnpY+zuEoo96jeWO1FVTvGKvUqYwTCgCpgeHPk9Qa8mPDtPFYvLEyz4tPbx5/g7aYYwBvduXXbanTifNWxWQ976b2iZqPFTTssSQsJHjW1phFZxb7prtFL075Q+fz2BUolcOIxmnnd2mkyq7UvdqY2D/O3yyrxFV3t/Jz84wYJsUbh/8FsHQXgolrSFtJ5q+7ifp2yer/OE2iDRV4H2s4pTp50UjPCrocXYm0+ntuV5wKZBn5ehNfKhMtWCp5D4CBflbtnlr9YAR9Xn+fY9neMU7dVq6xn+M7je0JzaGANvOZpsszQ9Hr5aUe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199021)(6666004)(6486002)(478600001)(83380400001)(186003)(53546011)(6512007)(6506007)(26005)(9686003)(86362001)(38100700002)(33716001)(6916009)(4326008)(66556008)(66946007)(66476007)(316002)(8936002)(8676002)(5660300002)(41300700001)(2906002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3BFA8N5O/K0wsrBKhCvyJTZJpyLHy++2mP86elB3BBLgMqOTl6efVZ/fQX9J?=
 =?us-ascii?Q?6OHPM/IpYXytjm448qcT+sY7I1BlCOAfRIGH6hhzKOgR1W6+2zKymhSwixEb?=
 =?us-ascii?Q?3LyDdXHXuz8VT2/V34siinWLD2dHB00rYF6pCn5xvIFZAgoqVNlhcNoi+5cB?=
 =?us-ascii?Q?GqBHahkSDj23mH+C2KB14Fb6IeJjTIPYtOMrrb9o/syKBWlmE8jyLCprkUOc?=
 =?us-ascii?Q?yGpTbDRXtyV8yvEqPQykDrByClicPFdC8nNOOBR7mLZGkfbrbN5gPFmO4Vxn?=
 =?us-ascii?Q?xQ5f5vgpF5eQzcU0jqzbXtrCPOU6+/FUSvdzKSlxxjAszKMPKlid1Q4L6btH?=
 =?us-ascii?Q?nQDGq+qRMAdvdkEkP3orc41OmPwLfHh9XuF/QApyFTq97AlftgzUt2GGp8MX?=
 =?us-ascii?Q?fZbr1UBU09S7sFnWjjP5dTPvGI0gHCZ6W6cHiVw4pe45MWn7ey0lZNlXgJo+?=
 =?us-ascii?Q?k+IGA/Iyn4bYYoBj+qWA35QMyc+QD8qOtUeTcmptXwHc3NhKow+0L69o/fst?=
 =?us-ascii?Q?76L9ynbrbCdNNHy3UU//DGOuE5cHg7l40kfQ3pmz9WK7YagXoEtczOwAE+0l?=
 =?us-ascii?Q?lDxOZty8RDqLe3cm3l2UgA+5j1+aQowaADnkHNSKtwus4C4HJO+36tc4WxmD?=
 =?us-ascii?Q?OrxoV6fg6XsBmzAsY4AvnOkxuEMJVjlIUjLA/RdQh+Et3BK8EAqa2Wo8y8mF?=
 =?us-ascii?Q?KyvUwJfu7VuqhdX7ye26H09ZuHJVuh0aMsfLQ9R3DpC0Jb7sX1YiHfVyjsEi?=
 =?us-ascii?Q?/qMCisLsJcYXgsihmLvtIhIK6RNWDyoQU3FMzcBJtfR7j+sQT7wR5ZzFNnzy?=
 =?us-ascii?Q?WGB6+2EXUZ3k45Z0ez6snW4v+BYIHjcmYuIrw3KfFjR64/PuBRYB6EejyQUv?=
 =?us-ascii?Q?vXtwNmfllfSzESRuQMcjymKsYvhBCqHuNSMgl6tQGpEzAOwoVDAs+9T9VWyZ?=
 =?us-ascii?Q?GVWUNzEgD5sR3Cfh/wOSlY6rvPZMxtkjihvcgCxBIa+Jcy5+Zq59r+8w3ONr?=
 =?us-ascii?Q?XiZKeZNQfK0LvHy/XjEs62BIzyCU/26wEGhNBQiGER3bAzIxCc7GfGBDLuDV?=
 =?us-ascii?Q?HfSGeiBS69rRYoRjJ9MWk7mm2JiDmlTuruhDhB6lINtB393ECO+9S0Es9Vdo?=
 =?us-ascii?Q?J5Ok91ZFmuWEdmvC9t0qsmqpA5c+ckyHxh+DfIswQwEqvTTW8+iuCWqGu8xi?=
 =?us-ascii?Q?WNKw62PkvWMRdv6RbGJMMhGiKNhCGjBgX2X+SYMpSsgEwzUQjWFJLOMqJRV5?=
 =?us-ascii?Q?8EUjCgr1YuGKJhg6gJNAuE5lOHCM17nC+yX9jndsZ/L20tcendEr1aC7dVrQ?=
 =?us-ascii?Q?i49+WKh5JlowlYty5qYROrq5M9LGvH66wknKhyDLVeLSEosao8Cgv7I8qg4a?=
 =?us-ascii?Q?ChhXSVmgSiVDXxccTNiPW/UoWd2ZlcXVc4lKWzjSaXeqqiCk/vT6+Wx2rRah?=
 =?us-ascii?Q?i/ktZnMhntlM1mfKpkfWGIBzU8DbQMTHrTXHH7eQ+xhrX3Cc7KBrjN3iUpvV?=
 =?us-ascii?Q?SXZlvq+ahEOHW70yg83paklIGQv/Tn/lAVEYHddV8w8IygpzmyHJvZ29qYOI?=
 =?us-ascii?Q?llFwXsZgTwf/l5bkctpbsBu23SKUZx2cc7YBqj1f?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: X+VcFeJdnZ/7L47fcDmcTIsPGuXALaecfECAjPEFkzG8nnePev72j6UWxmdGbph0NjIXr/T1MxgY/ndBG7xzTRydS4166Ig77CwMac84ZukiFvqnL/EsAe3DIyWn2GxE8hchcVGug+mNz3I1HbM1dA35NkXGoOjRNF64s8mjd/89NEv0E/ZYsaopCX0gZqWMQLFaj89U2T5OqrPkNV804L9lTzOMlOeMlYNffb9fMGzl+LgLZQU9VDYo5ZtOmV1Ua+O0CiBirOrvknbOm13m6kCHxgfBte2b4F7whLqDHTCJg/QL1YmwV+YDHVJ1ut3/OBizh2oOgxIbHaXDtlGSpoM7Hr4bF9+ajAZTJUVgrMjKfLNL7/6K26pEIDNv/+1ZFLsweTrQY4rhSHdaPQLtTKYi4hBYziU6wqUvxguixRja251KW4RgE2xumZbVvfS1WEb+/Ssoa1i+Ol8mO54zzH6W0M9ldYcu/4MqQNPh1SLjVdAKIlj9NKD7hFWAdljllwqUY0ruOnD2hak+rdJRtS4eR3tjx6dyNBgjiaeleub08/lnVoRya3CgqppfaXffdslr5/wZT4fv7HrM5/Xx4M6eLvhMx7b1YmCzA19ggcW0Ru65Kyo7+4pHB3IrTABl5pccdMh6AB3RZ4cZUX45Hzdfl/mTy0xVvL1TLIf9TofMcsby1kXNexJQdSjpliqiodDww3WexppaO5qLNnZ1i8hsmnvceygK9s7KxFbWsJfcpRLAbAmKg0v+DgUuFWQdqP1yRB4MFB1S1WktnhfUik7cET+y1u5p/D5pyxt8YRI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0143cf52-bdbb-42d1-f2e0-08db71a142eb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 15:16:03.2739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CkODYULWgqUfW2ecpyoC9wmTHyuaBwzty1oYIOx0TjGSxDiLVKTcpYAlSrN5xYL0SMBSuZPd9dN1c2XlslrTJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-20_10,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200137
X-Proofpoint-ORIG-GUID: mx4-_ETupHwdqRqelRBdjst1RJzmnqPw
X-Proofpoint-GUID: mx4-_ETupHwdqRqelRBdjst1RJzmnqPw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 10:20:20 AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> If the current transaction holds a busy extent and we are trying to
> allocate a new extent to fix up the free list, we can deadlock if
> the AG is entirely empty except for the busy extent held by the
> transaction.
>
> This can occur at runtime processing an XEFI with multiple extents
> in this path:
>
> __schedule+0x22f at ffffffff81f75e8f
> schedule+0x46 at ffffffff81f76366
> xfs_extent_busy_flush+0x69 at ffffffff81477d99
> xfs_alloc_ag_vextent_size+0x16a at ffffffff8141711a
> xfs_alloc_ag_vextent+0x19b at ffffffff81417edb
> xfs_alloc_fix_freelist+0x22f at ffffffff8141896f
> xfs_free_extent_fix_freelist+0x6a at ffffffff8141939a
> __xfs_free_extent+0x99 at ffffffff81419499
> xfs_trans_free_extent+0x3e at ffffffff814a6fee
> xfs_extent_free_finish_item+0x24 at ffffffff814a70d4
> xfs_defer_finish_noroll+0x1f7 at ffffffff81441407
> xfs_defer_finish+0x11 at ffffffff814417e1
> xfs_itruncate_extents_flags+0x13d at ffffffff8148b7dd
> xfs_inactive_truncate+0xb9 at ffffffff8148bb89
> xfs_inactive+0x227 at ffffffff8148c4f7
> xfs_fs_destroy_inode+0xb8 at ffffffff81496898
> destroy_inode+0x3b at ffffffff8127d2ab
> do_unlinkat+0x1d1 at ffffffff81270df1
> do_syscall_64+0x40 at ffffffff81f6b5f0
> entry_SYSCALL_64_after_hwframe+0x44 at ffffffff8200007c
>
> This can also happen in log recovery when processing an EFI
> with multiple extents through this path:
>
> context_switch() kernel/sched/core.c:3881
> __schedule() kernel/sched/core.c:5111
> schedule() kernel/sched/core.c:5186
> xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> __xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> xfs_mountfs() fs/xfs/xfs_mount.c:978
> xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> mount_bdev() fs/super.c:1417
> xfs_fs_mount() fs/xfs/xfs_super.c:1985
> legacy_get_tree() fs/fs_context.c:647
> vfs_get_tree() fs/super.c:1547
> do_new_mount() fs/namespace.c:2843
> do_mount() fs/namespace.c:3163
> ksys_mount() fs/namespace.c:3372
> __do_sys_mount() fs/namespace.c:3386
> __se_sys_mount() fs/namespace.c:3383
> __x64_sys_mount() fs/namespace.c:3383
> do_syscall_64() arch/x86/entry/common.c:296
> entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
>
> To avoid this deadlock, we should not block in
> xfs_extent_busy_flush() if we hold a busy extent in the current
> transaction.
>
> Now that the EFI processing code can handle requeuing a partially
> completed EFI, we can detect this situation in
> xfs_extent_busy_flush() and return -EAGAIN rather than going to
> sleep forever. The -EAGAIN get propagated back out to the
> xfs_trans_free_extent() context, where the EFD is populated and the
> transaction is rolled, thereby moving the busy extents into the CIL.
>
> At this point, we can retry the extent free operation again with a
> clean transaction. If we hit the same "all free extents are busy"
> situation when trying to fix up the free list, we can safely call
> xfs_extent_busy_flush() and wait for the busy extents to resolve
> and wake us. At this point, the allocation search can make progress
> again and we can fix up the free list.
>
> This deadlock was first reported by Chandan in mid-2021, but I
> couldn't make myself understood during review, and didn't have time
> to fix it myself.
>
> It was reported again in March 2023, and again I have found myself
> unable to explain the complexities of the solution needed during
> review.
>
> As such, I don't have hours more time to waste trying to get the
> fix written the way it needs to be written, so I'm just doing it
> myself. This patchset is largely based on Wengang Wang's last patch,
> but with all the unnecessary stuff removed, split up into multiple
> patches and cleaned up somewhat.
>
> Reported-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reported-by: Wengang Wang <wen.gang.wang@oracle.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 68 ++++++++++++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_alloc.h | 11 ++++---
>  fs/xfs/xfs_extent_busy.c  | 33 ++++++++++++++++---
>  fs/xfs/xfs_extent_busy.h  |  6 ++--
>  4 files changed, 88 insertions(+), 30 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 11bd0a1756a1..7c675aae0a0f 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1556,6 +1556,8 @@ xfs_alloc_ag_vextent_near(
>  	if (args->agbno > args->max_agbno)
>  		args->agbno = args->max_agbno;
>  
> +	/* Retry once quickly if we find busy extents before blocking. */
> +	alloc_flags |= XFS_ALLOC_FLAG_TRYFLUSH;
>  restart:
>  	len = 0;
>  
> @@ -1611,9 +1613,20 @@ xfs_alloc_ag_vextent_near(
>  	 */
>  	if (!acur.len) {
>  		if (acur.busy) {
> +			/*
> +			 * Our only valid extents must have been busy. Flush and
> +			 * retry the allocation again. If we get an -EAGAIN
> +			 * error, we're being told that a deadlock was avoided
> +			 * and the current transaction needs committing before
> +			 * the allocation can be retried.
> +			 */
>  			trace_xfs_alloc_near_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag,
> -					      acur.busy_gen, alloc_flags);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					acur.busy_gen, alloc_flags);
> +			if (error)
> +				goto out;
> +
> +			alloc_flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
>  			goto restart;
>  		}
>  		trace_xfs_alloc_size_neither(args);
> @@ -1653,6 +1666,8 @@ xfs_alloc_ag_vextent_size(
>  	int			error;
>  	int			i;
>  
> +	/* Retry once quickly if we find busy extents before blocking. */
> +	alloc_flags |= XFS_ALLOC_FLAG_TRYFLUSH;
>  restart:
>  	/*
>  	 * Allocate and initialize a cursor for the by-size btree.
> @@ -1710,19 +1725,25 @@ xfs_alloc_ag_vextent_size(
>  			error = xfs_btree_increment(cnt_cur, 0, &i);
>  			if (error)
>  				goto error0;
> -			if (i == 0) {
> -				/*
> -				 * Our only valid extents must have been busy.
> -				 * Make it unbusy by forcing the log out and
> -				 * retrying.
> -				 */
> -				xfs_btree_del_cursor(cnt_cur,
> -						     XFS_BTREE_NOERROR);
> -				trace_xfs_alloc_size_busy(args);
> -				xfs_extent_busy_flush(args->mp, args->pag,
> -						busy_gen, alloc_flags);
> -				goto restart;
> -			}
> +			if (i)
> +				continue;
> +
> +			/*
> +			 * Our only valid extents must have been busy. Flush and
> +			 * retry the allocation again. If we get an -EAGAIN
> +			 * error, we're being told that a deadlock was avoided
> +			 * and the current transaction needs committing before
> +			 * the allocation can be retried.
> +			 */
> +			trace_xfs_alloc_size_busy(args);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					busy_gen, alloc_flags);
> +			if (error)
> +				goto error0;
> +
> +			alloc_flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
> +			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> +			goto restart;
>  		}
>  	}
>  
> @@ -1802,10 +1823,21 @@ xfs_alloc_ag_vextent_size(
>  	args->len = rlen;
>  	if (rlen < args->minlen) {
>  		if (busy) {
> -			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> +			/*
> +			 * Our only valid extents must have been busy. Flush and
> +			 * retry the allocation again. If we get an -EAGAIN
> +			 * error, we're being told that a deadlock was avoided
> +			 * and the current transaction needs committing before
> +			 * the allocation can be retried.
> +			 */
>  			trace_xfs_alloc_size_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag, busy_gen,
> -					alloc_flags);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					busy_gen, alloc_flags);
> +			if (error)
> +				goto error0;
> +
> +			alloc_flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
> +			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  			goto restart;
>  		}
>  		goto out_nominleft;
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index d1aa7c63eafe..f267842e36ba 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -19,11 +19,12 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
>  /*
>   * Flags for xfs_alloc_fix_freelist.
>   */
> -#define	XFS_ALLOC_FLAG_TRYLOCK	0x00000001  /* use trylock for buffer locking */
> -#define	XFS_ALLOC_FLAG_FREEING	0x00000002  /* indicate caller is freeing extents*/
> -#define	XFS_ALLOC_FLAG_NORMAP	0x00000004  /* don't modify the rmapbt */
> -#define	XFS_ALLOC_FLAG_NOSHRINK	0x00000008  /* don't shrink the freelist */
> -#define	XFS_ALLOC_FLAG_CHECK	0x00000010  /* test only, don't modify args */
> +#define	XFS_ALLOC_FLAG_TRYLOCK	(1U << 0)  /* use trylock for buffer locking */
> +#define	XFS_ALLOC_FLAG_FREEING	(1U << 1)  /* indicate caller is freeing extents*/
> +#define	XFS_ALLOC_FLAG_NORMAP	(1U << 2)  /* don't modify the rmapbt */
> +#define	XFS_ALLOC_FLAG_NOSHRINK	(1U << 3)  /* don't shrink the freelist */
> +#define	XFS_ALLOC_FLAG_CHECK	(1U << 4)  /* test only, don't modify args */
> +#define	XFS_ALLOC_FLAG_TRYFLUSH	(1U << 5)  /* don't wait in busy extent flush */
>  
>  /*
>   * Argument structure for xfs_alloc routines.
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 5f44936eae1c..7c2fdc71e42d 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -566,10 +566,21 @@ xfs_extent_busy_clear(
>  
>  /*
>   * Flush out all busy extents for this AG.
> + *
> + * If the current transaction is holding busy extents, the caller may not want
> + * to wait for committed busy extents to resolve. If we are being told just to
> + * try a flush or progress has been made since we last skipped a busy extent,
> + * return immediately to allow the caller to try again.
> + *
> + * If we are freeing extents, we might actually be holding the only free extents
> + * in the transaction busy list and the log force won't resolve that situation.
> + * In this case, we must return -EAGAIN to avoid a deadlock by informing the
> + * caller it needs to commit the busy extents it holds before retrying the
> + * extent free operation.
>   */
> -void
> +int
>  xfs_extent_busy_flush(
> -	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
>  	struct xfs_perag	*pag,
>  	unsigned		busy_gen,
>  	uint32_t		alloc_flags)
> @@ -577,10 +588,23 @@ xfs_extent_busy_flush(
>  	DEFINE_WAIT		(wait);
>  	int			error;
>  
> -	error = xfs_log_force(mp, XFS_LOG_SYNC);
> +	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
>  	if (error)
> -		return;
> +		return error;
>  
> +	/* Avoid deadlocks on uncommitted busy extents. */
> +	if (!list_empty(&tp->t_busy)) {
> +		if (alloc_flags & XFS_ALLOC_FLAG_TRYFLUSH)
> +			return 0;
> +
> +		if (busy_gen != READ_ONCE(pag->pagb_gen))
> +			return 0;
> +
> +		if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
> +			return -EAGAIN;
> +	}

In the case where a task is freeing an ondisk inode, an ifree transaction can
invoke __xfs_inobt_free_block() twice; Once to free the inobt's leaf block and
the next call to free its immediate parent block.

The first call to __xfs_inobt_free_block() adds the freed extent into the
transaction's busy list and also into the per-ag rb tree tracking the busy
extent. Freeing the second inobt block could lead to the following sequence of
function calls,

__xfs_free_extent() => xfs_free_extent_fix_freelist() =>
xfs_alloc_fix_freelist() => xfs_alloc_ag_vextent_size()

Here, xfs_extent_busy_flush() is invoked with XFS_ALLOC_FLAG_TRYFLUSH flag
set. xfs_extent_busy_flush() flushes the CIL and returns to
xfs_alloc_ag_vextent_size() since XFS_ALLOC_FLAG_TRYFLUSH was
set. xfs_alloc_ag_vextent_size() invokes xfs_extent_busy_flush() once again;
albeit without XFS_ALLOC_FLAG_TRYFLUSH flag set. This time
xfs_extent_busy_flush() returns -EAGAIN since XFS_ALLOC_FLAG_FREEING flag is
set.

This will ultimate cause xfs_inactive_ifree() to shutdown the filesystem and
cancel a dirty transaction.

Please note that the above narrative could be incorrect. However, I have
browsed the source code multiple times and am yet to find any evidence to the
contrary.

> +
> +	/* Wait for committed busy extents to resolve. */
>  	do {
>  		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
>  		if  (busy_gen != READ_ONCE(pag->pagb_gen))
> @@ -589,6 +613,7 @@ xfs_extent_busy_flush(
>  	} while (1);
>  
>  	finish_wait(&pag->pagb_wait, &wait);
> +	return 0;
>  }
>  
>  void
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index 7a82c689bfa4..c37bf87e6781 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -51,9 +51,9 @@ bool
>  xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
>  		xfs_extlen_t *len, unsigned *busy_gen);
>  
> -void
> -xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
> -	unsigned busy_gen, uint32_t alloc_flags);
> +int
> +xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_perag *pag,
> +		unsigned busy_gen, uint32_t alloc_flags);
>  
>  void
>  xfs_extent_busy_wait_all(struct xfs_mount *mp);


-- 
chandan
