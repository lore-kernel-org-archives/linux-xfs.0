Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA74C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 09:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjDLJKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 05:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDLJKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 05:10:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFDDDD
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 02:10:47 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33C6UlCZ011552;
        Wed, 12 Apr 2023 09:10:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=zU2HMkIt8577mZsnoBhvuyn1TrHQUyrfo94aFzUTUVc=;
 b=ZUsnvEG2YiAgPYoUaftBYjJexiZqluJGsnho0U9nD4PRTRL60sIeY5TCbd6lyNZKnlBh
 61Z0jp1sx5GeSYxkrvPzxdGnyzMSOicYbFthIb/xzlmH2pFRgpCFn0Bo0kIWybDvKukk
 XWrKLkpIkI/6GipBNNYijK0gtDnmmJhq9rN+AW78ktDfjPI1kN38CvmiTXnPR0PNKge5
 iYyAN9WLqDjX1jg7Fwh7X+q9/TPpOUzYueTZ4+F+ZB4PdKaCYxajLwLpLfToQB31dRZ/
 gWSQhIhe3TUGREr0BlLhUnbRmvTY0JgYI85eeHGpjAe8/955IWXS4ftGrHtM86pQMcJ2 sg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq7jb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 09:10:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C8QK9M025064;
        Wed, 12 Apr 2023 09:10:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdqcuce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 09:10:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxWEGKwRnQQaugGOYabWkmRv2ATJ1/hxZPy6m8RkLEm4D4D+pvFXJA5pp3OBRTdwUu5V30VVNrKsqs4V2V4JI1O6XkyMd+Avb5IfpfYlzqtGjocdwGnk5dQ5XcOljw0nlkLzghZa0aiMCs4D7Jbm18BjReakyqnKMXWXt5CavJfcaklIvTROB80HLfLSOvrKXQ7xX5KgFpLC6xPrFSJjX7jyxqrILu+UeEznMQxNqptUoNaycHuZePfxPrmjXiDbwNVtk1FozTBMBgMbyAOXiBEMVSwZRmhiJPCZo4rS41w3S6QXoVi2pdccC+Bd/+XJf2f/yQVhO/wh8/s9r/SacA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zU2HMkIt8577mZsnoBhvuyn1TrHQUyrfo94aFzUTUVc=;
 b=Uk0qvefEzznG25NMsUkNeVrzjU6fJ2cTh2BrzPfZK7wAt7FTvzGEC25CCH2s9s8m/xcMXojnl9KremxK/1SHweKcURnlvo2OYNEADvJQt/6rZyT71UvQ5ZhYiu/u+LaVtnac0lmeHr4GF9swR2horltGDSeS+1v+BIVFc6lqAMIoPa2BdOKqCDjub3XPi1DHGXS3Iw+YgJzPUqYxS3AGffMJPOLjmukYBDlOcRdEtUo5hd6weqvJhov1mlj+/w5AtOzZnX/WNmFy3kksOWzg31h9xh6xa1nS1EVEKEpN0t6s2S4n9OYHlT5WUd8rVQovw9uG4fbtjZYVWySW+LguxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zU2HMkIt8577mZsnoBhvuyn1TrHQUyrfo94aFzUTUVc=;
 b=JgRVFsh8hoHlveNM2Wn5WUiMxDF/XNc4fAqFBFiwALukEnb0JEjADy7YGFj4cDZSLB8P10KfRAqmxCFgurQshi7snHkTDRGPVBy4aVPsziLh/HCVeHQiWDLGKBgaW+QRFYCmnhG/O5l3k9cqlgXpJ0cRAMLCEITt0Xz+mTP3rqE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7066.namprd10.prod.outlook.com (2603:10b6:8:140::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 09:10:43 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 09:10:43 +0000
References: <20230330204610.23546-1-wen.gang.wang@oracle.com>
 <20230411020624.GY3223426@dread.disaster.area>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix AGFL allocation dead lock
Date:   Wed, 12 Apr 2023 13:53:59 +0530
In-reply-to: <20230411020624.GY3223426@dread.disaster.area>
Message-ID: <87mt3djwj9.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: 759933e6-69ad-444c-06a2-08db3b35cb79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKlGADC/9e2G4y96iV5rJPq5kOPxSBd0oc8Pshguqyha65ZDaJDjqmRvErKflIyrrzRLJWgESY9LQNanfXDrfpfkYAXNkpzt0uW71ZOuZjm318A2BatQtN6cUBl5J1vH5/d9iIgubfWPTs1NGl+enitj5L21k6IJjv8d2mmKIO0stjKDCYyZ38A3JhutgbpMjzp8Dftqvfgsxf2k0YQr7JVrsDzdyVedTCRI/ql9N19ZLpRGkyW3qL0loTqEWpTOmZ6C2TQsV1b6MJ3YOH6qe26e6RDX+H4C+QHZp43rzKIJSWjud7zEjSu0ld722+v0rm82J7pHcDw15K8PFzdCEJHdfHjZv9Xm3hJCxosICnM8HDPj7p4P3CmP24Co0ypoof+a/ZW8mTy7sl7HotV5YRbx6yQsgvmtQheaOUmrK/+7hEjz70h+B/+aVUBojlVKqVQs3w387eMl0nAyhyUdgJcsUKEOmifCQjA+jRH+ha924fdhSQzBsPApAjxKG+ytpvFU33Ls+YLtKlZfM6trZ8AvAw1iU7n9shtwGpv6lEA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199021)(2906002)(8676002)(478600001)(8936002)(5660300002)(41300700001)(316002)(66946007)(66476007)(66556008)(83380400001)(4326008)(6916009)(186003)(38100700002)(86362001)(966005)(6666004)(6486002)(6506007)(26005)(6512007)(53546011)(9686003)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/AO6VQYweWQSFtAvrfXHnhyeSCa4LA7SEn4B8oFxcBe/5CqdJOPow/XIQsP2?=
 =?us-ascii?Q?iyrxnwMeysLSTeS8Ic/egzEBn4oA6MSUwjxv4NlAK0s0DNXK+fRA99I4zFQw?=
 =?us-ascii?Q?wrE0KK3bM7NfT4kcjPoEFqNZ+bOOYGY4Je1Tfav2Ums8GLgaZ/mdDVmqikdZ?=
 =?us-ascii?Q?lAGjfo5PpVBq5umhSsiJkV/FnTasUqg9K8r/hhcXv1n2PSrDPrDYqwGpfTNC?=
 =?us-ascii?Q?UDM7j5ee8O7OL1xpLn+s/et/RUOW0XVRGCs9/waKxWlK/FAKGqtE0tBr77UE?=
 =?us-ascii?Q?DpQF9u0zoyVYYkkvU2Cf2of0uaoPzl+XzQ9AJoCdjlbOefoF0myczn02Ank5?=
 =?us-ascii?Q?j4zz30NH21dxA7dAuW4Dm6P3DvbwV3M55oP2wiCNEK/TPgndhRQNYxQc4MOi?=
 =?us-ascii?Q?dW6WTMYwoIt2lGYJX6QcITpdQ2LO4s2SCLgPNBJexBXj8sWoJHLqsO2VpGGX?=
 =?us-ascii?Q?sry4qDZZseboJ83yyO3MAv1EhIjeDf4t2enk4wHTHK1uL3BJuR/Bb4dN6KyW?=
 =?us-ascii?Q?CdBQqUlRbiPsMrh/51/ib0anY0VP11FasuIwnf5u7JIrReDDebaEO4/mCu0j?=
 =?us-ascii?Q?eJ5pZHzIGMxBlm9sIUqhYqKbT0GErIOZwNvgjwIDpJLSqMJwkxnLvtXo7pEp?=
 =?us-ascii?Q?EEyWFBfXemlEqQm8T/KsHbqU+TLX1wg26dEgAm0heZnOs6CC8N/eYiWGzuF/?=
 =?us-ascii?Q?EsSZRM+kTzXzpWY6dfgFkJ3KTGS2GLs/FwhzXdKjgmfqeeskPwLXnZ8oH+VD?=
 =?us-ascii?Q?oriv9DiccKuymMYjpk9e30RykS0WUgXnPVzqIi8ybBvYfb4X0oARWz02+tSW?=
 =?us-ascii?Q?cCgDUsesi84U8UHItw6SXAUnYCckDZNcGh+22Op2ZbwSqR4JqKntqyjN/6Ml?=
 =?us-ascii?Q?b0D2ZGZqdB25wNCv+qgMTvtYCnzcG6i4vIj07ZtsIpRPYbgrpBm0pkwSRiQS?=
 =?us-ascii?Q?4EtSvVqSG4fleO2ANBadjzNaUYusm2Mc2swsYNVXrx7dMAzZGK0ns1Unl5ge?=
 =?us-ascii?Q?OzV5cA6WIoT85ZL1I74UPmuxm4IxKl7SIt5RNsnjgWXhTSysrLNUitLMxZVO?=
 =?us-ascii?Q?75DRMVqMWD9PaLZ4SOdc9kzO0bwsUYlv6OXbkOZIOyTE0NhwQ9qZmcL4p/d2?=
 =?us-ascii?Q?etqR42viqxp+4BJDMS9YzRFAP2gc8hUGp7/D75/tHOj9V1xoX/v4Hz4hz7UC?=
 =?us-ascii?Q?1u58Q8Mg/tpqwpG7fv8VGf31JwzTX8hKncPwzVqXMEOhuf3QB82F+92fHy9P?=
 =?us-ascii?Q?6JZ5hJ4AxJ9YxikXshRaM1LsLf1dbiHwgVEtL/4K1RMKj1P2wQtspj4frVz8?=
 =?us-ascii?Q?lU7j1nHbIFQTdiSk206zI/B/i/hJtGmXx7QiBrZHM5/2MY0ZaGJY/JdRt69h?=
 =?us-ascii?Q?+wKd/QN2Vime6B18D2loHkvvd05GXrfGljCNLmcilVyQPiYEqHLiKa05i1JX?=
 =?us-ascii?Q?Br4j0pHdABTSehsRc9qPEzBketUIAMftqUMXrTy3Il2/2kt0VGrrd88qugGI?=
 =?us-ascii?Q?Y7gMc79yK2B/ancIfZOQR8f9Lljuo23nWjnoiTmq7iMRDSHWs+gDXJVmkCUV?=
 =?us-ascii?Q?LiVoquPSyeoXSgYbCB6V2rj5WNVia9oW5jnxaLGADqYm6eSBPNgAYNs21hTk?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9JyBNH7Uo3uCvrs019VTD1d108ehj8PNSKDK/Dn6xFJ6zGgcK2l75Yyb75ZMBvl1Bw9r1azogaemBRU40QriI9mAfhyUbAIziEMudyNx8DkRsVB+YQz5Ysf/f5N4JsX+/Cmw1sH8eGwjsoWWbJBT/CNk9xSB8MFwwE4NMBSA92qtbriOhQSj+DFfBgCgTDIiRseH/Mmw+lKUKTmq21V5joCN5i9G1f62BHEisvoe6dfhj2dTVAmCNAafxNnZpLesF8nOR0lJr8yGRCqfBxwbj4C+A9SnYzJQ1KX9RRV8I9r0U19OOVWk+HY9J6KJRwY9IyS5DBCTmanK9ruEkTaqTcL63PtexTkAKXV4MORTzjwIMVoFco2w0x50K9aTpkqbNEdCygmVKNebUxK6nE3fiaqKU29p8rlWjlbFqSiFjIp5Dn1O/LOMsJ98/58mxO8zmYvZ1hsYwRuGJxMwKUKFcSwkCuKrGE42938VUq9HIbxCFyIq7N8IJWA8AQA1jXbquM/lv66WMajt6oAZ/Rm7Srw/TiHvuBqC4NlFh0rdSfWa7ekPSZP3nOmvTcb5EmaWQmKIS3OAvqzY4LGAkSIDUaiyO2+HXsyFBXL2jK/QUHnkST2ZQCxTbpit4gQ099FHXRTdylFd31QR8huB6HTdNS00wAvsc5JJD84TiSj5gbvZaAKTMmIfuKrPpSLRsBCD8zzikG3zZjMU3jpIVovD01PVsb1fm1F8UfueW7d393Fh97vbND76p9EP1dsBaq0/N4Vlh2G5eQ88oQLgl0ST5z2GyQbcwSdZhRPY3IND0dQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759933e6-69ad-444c-06a2-08db3b35cb79
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 09:10:43.8134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXCDk/dI+h8wQ2ikiK25FWk62N/KqBDcB0WAV1xN3KLBESpiLKu7O6k9ICVDWoTta+BA1KsH9CYSr4ODL0rqIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_02,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120083
X-Proofpoint-GUID: fUmHiLjRW-gGzWrWJVcrukML51fcctNj
X-Proofpoint-ORIG-GUID: fUmHiLjRW-gGzWrWJVcrukML51fcctNj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 12:06:24 PM +1000, Dave Chinner wrote:
> On Thu, Mar 30, 2023 at 01:46:10PM -0700, Wengang Wang wrote:
>> There is deadlock with calltrace on process 10133:
>> 
>> PID 10133 not sceduled for 4403385ms (was on CPU[10])
>> 	#0	context_switch() kernel/sched/core.c:3881
>> 	#1	__schedule() kernel/sched/core.c:5111
>> 	#2	schedule() kernel/sched/core.c:5186
>> 	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
>> 	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
>> 	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
>> 	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
>> 	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
>> 	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
>> 	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
>> 	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
>> 	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
>> 	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
>> 	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
>> 	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
>> 	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
>> 	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
>> 	#17	mount_bdev() fs/super.c:1417
>> 	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
>> 	#19	legacy_get_tree() fs/fs_context.c:647
>> 	#20	vfs_get_tree() fs/super.c:1547
>> 	#21	do_new_mount() fs/namespace.c:2843
>> 	#22	do_mount() fs/namespace.c:3163
>> 	#23	ksys_mount() fs/namespace.c:3372
>> 	#24	__do_sys_mount() fs/namespace.c:3386
>> 	#25	__se_sys_mount() fs/namespace.c:3383
>> 	#26	__x64_sys_mount() fs/namespace.c:3383
>> 	#27	do_syscall_64() arch/x86/entry/common.c:296
>> 	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
>> 
>> It's waiting xfs_perag.pagb_gen to increase (busy extent clearing happen).
>> From the vmcore, it's waiting on AG 1. And the ONLY busy extent for AG 1 is
>> with the transaction (in xfs_trans.t_busy) for process 10133. That busy extent
>> is created in a previous EFI with the same transaction. Process 10133 is
>> waiting, it has no change to commit that that transaction. So busy extent
>> clearing can't happen and pagb_gen remain unchanged. So dead lock formed.
>
> We've talked about this "busy extent in transaction" issue before:
>
> https://lore.kernel.org/linux-xfs/20210428065152.77280-1-chandanrlinux@gmail.com/
>
> and we were closing in on a practical solution before it went silent.
>
> I'm not sure if there's a different fix we can apply here - maybe
> free one extent per transaction instead of all the extents in an EFI
> in one transaction and relog the EFD at the end of each extent free
> transaction roll?
>

Consider the case of executing a truncate operation which involves freeing two
file extents on a filesystem which has refcount feature enabled.

xfs_refcount_decrease_extent() will be invoked twice and hence
XFS_DEFER_OPS_TYPE_REFCOUNT will have two "struct xfs_refcount_intent"
associated with it.

Processing each of the "struct xfs_refcount_intent" can cause two refcount
btree blocks to be freed:
- A high level transacation will invoke xfs_refcountbt_free_block() twice.
- The first invocation adds an extent entry to the transaction's busy extent
  list. The second invocation can find the previously freed busy extent and
  hence wait indefinitely for the busy extent to be flushed.

Also, processing a single "struct xfs_refcount_intent" can require the leaf
block and its immediate parent block to be freed. The leaf block is added to
the transaction's busy list. Freeing the parent block can result in the task
waiting for the busy extent (present in the high level transaction) to be
flushed.

Hence, IMHO this approach is most likely not a feasible solution.

>> commit 06058bc40534530e617e5623775c53bb24f032cb disallowed using busy extents
>> for any path that calls xfs_extent_busy_trim(). That looks over-killing.
>> For AGFL block allocation, it just use the first extent that satisfies, it won't
>> try another extent for choose a "better" one. So it's safe to reuse busy extent
>> for AGFL.
>
> AGFL block allocation is not "for immediate use". The blocks get
> placed on the AGFL for -later- use, and not necessarily even within
> the current transaction. Hence a freelist block is still considered
> free space, not as used space. The difference is that we assume AGFL
> blocks can always be used immediately and they aren't constrained by
> being busy or have pending discards.
>
> Also, we have to keep in mind that we can allocate data blocks from
> the AGFL in low space situations. Hence it is not safe to place busy
> or discard-pending blocks on the AGFL, as this can result in them
> being allocated for user data and overwritten before the checkpoint
> that marked them busy has been committed to the journal....
>
> As such, I don't think it is be safe to ignore busy extent state
> just because we are filling the AGFL from the current free space
> tree.
>
> Cheers,
>
> Dave.

-- 
chandan
