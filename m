Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351E1C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 10:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346906AbiCOKFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 06:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346904AbiCOKFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 06:05:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A016176
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 03:04:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F8HMXA008015;
        Tue, 15 Mar 2022 10:04:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=AHeet3KaBVnrDSkqdESelvtKJ3yc9EhTV0vjaINe3kc=;
 b=pao7RVeHCKzm0VqUNhnWygTayNb2Ax+eG1AOPGHoNEIdJly0VIyHkNsjmcvsPoyQW1US
 GODYXw1QULgtPXyI73zg+r03isWNS5IPGlHBmNOkkJ4PXv3uhemYGdvjFNp2CEmUt5v8
 9ObxlUGnQtJCEOt/GXGBw6scy6GnW24or952crgc77v0jHIQfVoiG7wr//X6J7GJ7AnO
 2eNv7jXtAusayc0bckeD0PiKBKZhcz9yhO7DfOqitSqjzdUmANq93vz/HtOEm0Jeu9NT
 TKMKEOqTtBn6xY/ZPLeKi0FakwED40+COKB3GT8/CiOE+37I6HRgwI6pS2XSAO/Btj6q Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6jqj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 10:04:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22F9u5ua078900;
        Tue, 15 Mar 2022 10:04:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3030.oracle.com with ESMTP id 3et64thg98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 10:04:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVdOusTa78EUUydmjpiakRhO1rp8k/5VhkgkbXf9GUafHj3kgLy3IQyiCfzEG243Ewds1mSe5iTpmW6XDvqDsGysMtBGFpA7BGt0YMSUkGnr3Ar3ZcPwXV6NCBing5OZCcz3zWCp+nei87pt2d1hWwiZ3JjU9PtgvkeRjRjmQiNPAzvw48wnigMGybhOHQrxPTLyuyiev8Tqi9zVOq8SW4c21ChChRk649cgaodpc4pSfyMyDjafsvgmLV8W8U+OlfpkZ0hj9+dEz9c5V6XIrvBvGafGW1n3+245Bz6e+xcSX5XcDRycHf7eKp9alIwldE1Bpidms9xisJsAV6ZOFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHeet3KaBVnrDSkqdESelvtKJ3yc9EhTV0vjaINe3kc=;
 b=Yc/9+OQBxGKyIAiZanvkVL87VY4yDQ88wKD3VJPGRqSGJLcKTmtCnM6pj0/eUIn2xE+sz9C/cnsixbgXhAfRoYlkkrDEjUYQ8vwuYNI/k1C8gO1uorrGPlTWR+5DIhVPU1HVf8iz1aILNb0JE7ccyI4ydRm9w1lj2Krp/Shg7W8tNjZu0wg+dHVo5xbP31lxFr+Z8uhD4OLgSIn3EkHyXm7TETij+Z+Uw8ObyDOCEjz5zwCDdAWGFjlwk+XTy4UaMLrksdCROHHdtz1Q/Cj5Bq+rOQjwgV46SFcvXqzBXtRXLWI6frCfd0pobMD9D1H12EjiR4W92y3KMkaa9iFXDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHeet3KaBVnrDSkqdESelvtKJ3yc9EhTV0vjaINe3kc=;
 b=SMYXdk41nsHQDRLuaAR3UQrvpUT3g+Zt9uy8g5h20sl18cfQH1XvbXwk8XT5/Bz1TYZEh6daU4AvOruZMVaMHgmNIqI1dlGlfFIP/BM2KUQM2JsUdmrk89oTbkcsmNx6pQ5RvwlP+kIgBt7PlPJR48AZGZg+iSY/NVyPSYjtOzw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2509.namprd10.prod.outlook.com (2603:10b6:805:4c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Tue, 15 Mar
 2022 10:04:27 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 10:04:26 +0000
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-3-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: check buffer pin state after locking in
 delwri_submit
In-reply-to: <20220315064241.3133751-3-david@fromorbit.com>
Message-ID: <877d8v4jmm.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 15 Mar 2022 15:34:17 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0145.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f01587d-0e4d-43df-22e8-08da066b3013
X-MS-TrafficTypeDiagnostic: SN6PR10MB2509:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB25092CB247626BC11BD427D7F6109@SN6PR10MB2509.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HdAlEU2Q9CfuycU0e2yXoBP7X+mBRnR3f/r8K/pNyh4AgUQZCteaayMenjW7x0YZY6CLOgAZGuy94XRGpzdPe15V4pqAy9o7VI/6pi6qUtxfcUwQIrG4wwzkQ64XVKD2gG+090iEDPRUEhh1UKEBAlyF2FNb/+Ik0uNfSaMyAh0dkUBIL7Cp8R3YWhMGUnAXY7913nTZfdtqfcgmZpNKWgIJ8fMSPMKH3CawFnoGZeAqj+57R6lwh3/XhaV4OO8zF2Vl0Nrml1IuTkjlfgp6xAF3hUVMXinndGHaqA9dGmvJmWXAq15/N2tsfUnXFBCNgJhimAyiNxvAP7JULYoGJC1Bja+fKryjTpfJeRAV/yTj/Zjyib5Tk3ryZYvWwjer3uJk6W/0nX2iwWUZjq9+/l1Jlju5x+57uVUwh1MXymsw6DzJY7qfRUaOHyCiGS20N9J4/YzYfN9o25JviBbhat0KIX5N4o5MxzG91TeGPuUVB1B/oUb7vynuqJpDS+3J7xh51Q6YfA/0Rh2MPAl+HLx22bOCMzIeBX/T+iFaXEdn3jjqWDI8OhQskOnjcsoU+ZRmICB5DPBinGgmwWs+rpkCEWeeNElqU7bCXSjWNIH/VIYg1Gg/Hh7b1GU825otxb3vFC2Kpx33hNj78zT+h+zvGoiyqtuWZajAVDx7xW5SAAFDpDaMXXBxbWKHFRS0YrvVLSd/UbgCUUau3YjOXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(86362001)(6916009)(38350700002)(38100700002)(316002)(186003)(26005)(2906002)(83380400001)(6506007)(5660300002)(33716001)(8676002)(6512007)(6486002)(52116002)(508600001)(66476007)(9686003)(53546011)(66556008)(4326008)(6666004)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8xDM/JV3GBeWQ9dDDu7iZPdz8CW6SuLnMQ9XR21WsH7Tgxd54/urSRE7SWvh?=
 =?us-ascii?Q?v1P36eKe0KBgYQXlwA7P5g8k5le+lQWPJ3WM8VrP3qNWensVN8t2X9/aiEC4?=
 =?us-ascii?Q?jT+JLY+vvIqMujWCqeucF79NnMl9BkDe/HQnPjhiWKpz2jlMcimkLEFyFlTW?=
 =?us-ascii?Q?A6lui0dlpGZWLilbrHu04j73WA7f35igp/MgZfFBZcCquP4N8GA+vRywSQQR?=
 =?us-ascii?Q?EgHVOCzW+aGS199sYI6PK3T8JYgh2iMovnD1addGgCGOO5sMulzqpTDavKsu?=
 =?us-ascii?Q?dAXDM1EZiRHRqIEI+GlWysEzliG5kGfduuHkMM0CkC/HYHhWJymdc3k3+lul?=
 =?us-ascii?Q?KqcmfghPUsdM2QF/K/9Q9o5QtvfJ0sUnAkA6CHnKNniVHEmVyPbC5U5wl38N?=
 =?us-ascii?Q?P1P7Je/ex7ji8CO2lZw3dHO6eoLBDTFTf/SvIBt4vwnk2ollQ2K/4klS8nRC?=
 =?us-ascii?Q?DIXSjFssVhBX5fPJrq//zQOs/LMzISNHF4uPf4tdllIFHTOwKSmOsSkPJPfj?=
 =?us-ascii?Q?gsRM9RUCCeXB2j9t/y4Fxkv08f+x9zR7xTdwcHTFiizz6WB9R83CQP+2sq2m?=
 =?us-ascii?Q?HeY8li2Sl0nWAz5Ej5knjfgixG5Ojr/aRWjy9T+A5UFSABvtD9PUoIZUFZV7?=
 =?us-ascii?Q?rSJhYtkFLHWLb0iUf5Mq5aMEJVOUk2/8CiX9vbCyeGSTbvq65NfIn852ZyE5?=
 =?us-ascii?Q?CRl+l1jlRvD67BhNDKjGsJQLJNfzhv5mrZkFYihTB2M/3I9AhA6GDD7rb9YB?=
 =?us-ascii?Q?TZqEV6vnqNFxYWgjsbBTVpv/UhkOxdpSESIkzHVbYtu2RXA0GstUnwpY3ayf?=
 =?us-ascii?Q?Q9CLHhbxaYTiml+jpB94QQCW5OTxB2ytOjXtRZIoF5ot1jvcaLBUi3rDfnVs?=
 =?us-ascii?Q?GRbDJmqOQEupNCtqmjFkUGKAqDsVg+87txjzNCMo+EPFDFKpn+W7pV5SHwAD?=
 =?us-ascii?Q?dASFtYSsLh4yrN/CfKhx5Xz2W1tguJ0iqCL+mzNQGHjoXwa6+ii+Wp53h7Ov?=
 =?us-ascii?Q?3EXMDDzRh38nooDqQXtlbKfDAS64TQzTcV6HyR/yhUqKDbQveTZiIpHWzJRx?=
 =?us-ascii?Q?FHwm64Scik2ZpXEr9K2/1jczvs7gerAVytjd9oltr/0KF9PwmCX18eTneZXc?=
 =?us-ascii?Q?yG3GdOksmFHPiUojRGFlsfDLgbk3hG7db+wYxKTTGkxuq1RsGKa3pbG71dEK?=
 =?us-ascii?Q?XYqHEhgxYlvbTCpl2PaPvuY+9sLQJHrI7Ym2FB8JMKrFdhU6DCFx/bVTtJBi?=
 =?us-ascii?Q?PXS2AfN/TOh8EA4V8OJ1wkCYqDNGONSncZ92iY7ksIk9WfgTFCq77yl1/luE?=
 =?us-ascii?Q?ceV+oEzC+wgtGY48FXvku8WQdtG6/YHSktEIavPQbBe+Dr7/K18jweJ/UoZ2?=
 =?us-ascii?Q?rrUpahjSUoIgfAD3ZevE3iKkoNNfuO3JkmCySC3tJXColz9bnqULry++/8Sh?=
 =?us-ascii?Q?gyLZ61Ti8SIU7PwmLKZ964t1pd3AMtQa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f01587d-0e4d-43df-22e8-08da066b3013
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 10:04:26.8548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJfapNzkfare1BwjnhcdQTmkRph1TzgKT3Q0X71bGfmjYzyGvuoJNvbs1XLDKPUTyGBCigBB5gQq6tFSVblU+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2509
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203150065
X-Proofpoint-GUID: xRUgubE15zoz0R29_Elnux6hiC-qWIkn
X-Proofpoint-ORIG-GUID: xRUgubE15zoz0R29_Elnux6hiC-qWIkn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15 Mar 2022 at 12:12, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> AIL flushing can get stuck here:
>
> [316649.005769] INFO: task xfsaild/pmem1:324525 blocked for more than 123 seconds.
> [316649.007807]       Not tainted 5.17.0-rc6-dgc+ #975
> [316649.009186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [316649.011720] task:xfsaild/pmem1   state:D stack:14544 pid:324525 ppid:     2 flags:0x00004000
> [316649.014112] Call Trace:
> [316649.014841]  <TASK>
> [316649.015492]  __schedule+0x30d/0x9e0
> [316649.017745]  schedule+0x55/0xd0
> [316649.018681]  io_schedule+0x4b/0x80
> [316649.019683]  xfs_buf_wait_unpin+0x9e/0xf0
> [316649.021850]  __xfs_buf_submit+0x14a/0x230
> [316649.023033]  xfs_buf_delwri_submit_buffers+0x107/0x280
> [316649.024511]  xfs_buf_delwri_submit_nowait+0x10/0x20
> [316649.025931]  xfsaild+0x27e/0x9d0
> [316649.028283]  kthread+0xf6/0x120
> [316649.030602]  ret_from_fork+0x1f/0x30
>
> in the situation where flushing gets preempted between the unpin
> check and the buffer trylock under nowait conditions:
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
> This means submission is stuck until something else triggers a log
> force to unpin the buffer.
>
> To get onto the delwri list to begin with, the buffer pin state has
> already been checked, and hence it's relatively rare we get a race
> between flushing and encountering a pinned buffer in delwri
> submission to begin with. Further, to increase the pin count the
> buffer has to be locked, so the only way we can hit this race
> without failing the trylock is to be preempted between the pincount
> check seeing zero and the trylock being run.
>
> Hence to avoid this problem, just invert the order of trylock vs
> pin check. We shouldn't hit that many pinned buffers here, so
> optimising away the trylock for pinned buffers should not matter for
> performance at all.

Looks good to me from the perspective of logical correctness.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b45e0d50a405..8867f143598e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2094,12 +2094,13 @@ xfs_buf_delwri_submit_buffers(
>  	blk_start_plug(&plug);
>  	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
>  		if (!wait_list) {
> +			if (!xfs_buf_trylock(bp))
> +				continue;
>  			if (xfs_buf_ispinned(bp)) {
> +				xfs_buf_unlock(bp);
>  				pinned++;
>  				continue;
>  			}
> -			if (!xfs_buf_trylock(bp))
> -				continue;
>  		} else {
>  			xfs_buf_lock(bp);
>  		}


-- 
chandan
