Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0117EB64DC
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 12:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjF2M1F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 08:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjF2M0t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 08:26:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAD83AAD
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 05:24:18 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35TAoWpv004635;
        Thu, 29 Jun 2023 12:24:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=vwNMCWXNDd77UF/oKpttFbRI34GeZ0OiYDeVjWKKYTY=;
 b=askVrYoWf2IMfygPSchixNBZdjrffyq7AqSfPdi5APGDn/1afWoetkJPUCW3WT/Dt4tm
 R03A7gdKnNnrwpk61lr+IIEvZc+NvnJ+b+PANoCBrETce5OH84hdKFWNeBhNVNqKdq05
 kTfeunGvE6PRNe1JQTydWjnNHTJysVKwC1p6RnRml3EUObYWU4gRNY2cBWBgNsPz0/hE
 1m2c5011SnFM2WQgPGIwB3NeOpWVONk6NAlf8x4poe/grFxHF/gsZIOpH+J5oay0avm3
 ZdMT+cLTiWXYIx9w+tJSPkWbwdATXsrEuozHa4djjvgRHh//hHlYpDkD0EvpGtA8U0W5 AA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rdrhcv5md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 12:24:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35TBO8gf029655;
        Thu, 29 Jun 2023 12:24:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpx7ajts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 12:24:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuhDPb95Vx8g8tzL7gqJeXy8HpLlSs4B0+Y8QJM2nQ6Wq2WSoE/8AHXA7o3rYoeMICsgi2TvTPTt2JGQOekr9v4saNMgvA2Ifd7XK+DhQLuVQyuOsObsfsTb8ajgRdWZbFsUh1xeIPCHQ/gm6bjevuMR5w1BQdvLsiqx6Pn8jtP27Fl2GV5y08GNf/gCmWaDYva1NpLWdo+2cC/7LxIEjFSBTR2ARLOGROsziZrfjZekRNZBKuMcVzLd9NSpXaicxTfj+OeofTEAIjwb2SYbJaEtv5yy6laMzDgN6kX8KV9E/+gGGgSKipBPF8mP9Ecr2jo4gm8UQyjPxZtBD3i+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwNMCWXNDd77UF/oKpttFbRI34GeZ0OiYDeVjWKKYTY=;
 b=HZ9xiSHvjUnFI0NJ3w0yVQSa4oApYao01nHi/peuf6kwU7zoKTR1TUk5JVgLkTGAaPPCZrD7PlLhTP18TNqKRIskWNboAxCZhx0JP4fWLnU/BOBsUFqd32jCCt7u4i1c9OGGf+OyPOFI36dmc8VlgFQb44uFeiyhFTgRELaY9mRPFpddCcsmWJDFIyoyaQ+k2wBs2P5hXfj0krBwU4Bmcs3vWkXrxwqSQVD4geLnG2obah/YixPgU/XkD86fkgmIvepfy2b+8ia595xsy3UX4tLEJdSTSifbReJNSncH3EkXz/Fg3ysIARvSt8p7VtJaZc+SOYxKWAZC210IbQUhLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwNMCWXNDd77UF/oKpttFbRI34GeZ0OiYDeVjWKKYTY=;
 b=qBZjF4CToiaosAN4Y/Wfs2ioGmF3CPkoPiASuoObu2D3dCJPBwualxsStrd6ITmfgbkqTzQTrA/O7f05mnnmda0MgAN/JDhVNccAnMPcKn/uJjePHA5doQhAWPG28YZIvCdpJEVtyqOotilkeUNT/ieh+2ywIhtiJib5lTmlI8Q=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB7717.namprd10.prod.outlook.com (2603:10b6:510:308::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 12:24:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17%6]) with mapi id 15.20.6521.024; Thu, 29 Jun 2023
 12:24:14 +0000
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-2-david@fromorbit.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: don't reverse order of items in bulk AIL
 insertion
Date:   Wed, 28 Jun 2023 15:25:40 +0530
In-reply-to: <20230627224412.2242198-2-david@fromorbit.com>
Message-ID: <87edlu1moy.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0111.apcprd02.prod.outlook.com
 (2603:1096:4:92::27) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: c108f017-eb0b-4360-d174-08db789bbe1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uGHvgI57OwyknxTtmQjf5QU5+cz2y4AS5Gp2ahFnVJIYmSVS9zd1EtU+zTzJUYDZ25urSSHe4Mqw5MaLg+pKMpjg5W4OzXTYbLP/sJ5eddjrfGIM4qTpx3GJMkA9IKwT+S4hUrH+Oztw+w5SsLjKSgGjknVmR9MIV7ZiAlWJSfUp/pVL4RVga0T8enhzVoTsYZNJoB/8nvqFWjOqzr+gQvE08BYFFCfhCFyBaWF2upzsBaifKaAomDQ3/01DdV1e7wasoiEk771177XXQawBMM1HEdZ5kKvvp/hgJsRmN/5jagylhQtqW9PCO8u9J+ZJvikGBtr7L9296THnXwO/YpBVQl7seA1L9/SRdy7ESqr8r8iGeOnmMxbn3zRWsRf0m7bkIbMZtptq9wJjXVh+9iJ1SJ05He3Q9grFnp6+KEBR8omiSPY3USk0IDLdD0RepMSl5oA0a4+0hJykMXOxD3uqSIn0l3xT6MrnpyufPvgaqVvIOwpGO6ek3j/qaMCgMS7GTTLmrj1tAm6MEo06U2vh14xbRco8GRl707HfqDaAB1nfR6VRmk1GUcxT5Pai
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199021)(9686003)(26005)(186003)(6512007)(53546011)(6506007)(83380400001)(6486002)(33716001)(5660300002)(8676002)(6666004)(38100700002)(8936002)(86362001)(478600001)(2906002)(316002)(41300700001)(66946007)(4326008)(6916009)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9p0qvEF8Rm6lEqIxYHScKeFehrexKn4YLXB1Jec3MRZe6G1W3Ruzn8+KVPlX?=
 =?us-ascii?Q?ZNWDCdm9yfl5BdlLG4RKabGaOaiTzmCYiVyt7AXJuz3VVWNcHNRl7a2xBHCK?=
 =?us-ascii?Q?hHp0iFvfcIkC+8Zra4W4HviNobT8I6xwUt8kqro0UO7FMeGANF3Pnr3OIoT5?=
 =?us-ascii?Q?ArQg/dfEx+RDO7m5haQI5xoBAGe2rub6q0sYfejVe4HVnknS5VWpEzewlmm2?=
 =?us-ascii?Q?8GFJETp1vYNwQ+adf1RG/zZi3ok8TQmYqr4i+Bt8V1ZQe/dy2t43vk1Mx2tN?=
 =?us-ascii?Q?DKYK1TNMwU7cpsGkSnqxQjwgA/UP471+GrWI8NqpqVXwRyVIZl3CqjMln2MP?=
 =?us-ascii?Q?vDZZCIdMm2hRgAypu2mfnQzYtcDQqINqGfLKC6nGoEIQ4vqMluwwPGT+Q8Ks?=
 =?us-ascii?Q?RBflfmrV0kOJGd7Ve/shQmRp0B77ngZzX0OaXU9r7NI4bUBJa8QZ8MBtS5RT?=
 =?us-ascii?Q?pkDvS3gIuohrbV9cqAXofjagWx3yCbXr1/sf13b/JEUONIaMX3rsP8MbY+cR?=
 =?us-ascii?Q?sbNGgUVg53VMjPYAgPpk1X/M2+ZsadIPCn+HJIor9ef+C5WnsQnKqeE44sDQ?=
 =?us-ascii?Q?9VDmcrSXFvGgRhbHN7zmuM23YL37wGUp0qkUfZJvJWBm/jkoKkyZtqCqsS0V?=
 =?us-ascii?Q?Qv6YU2cHwsh1M+HHWU5BoMqV/coBT0o4JSWxpFHTQSdrGgY/CC7F8+rPlrFn?=
 =?us-ascii?Q?JBnW8ij1lM4cYC3CQccl/KmTw3Yamz/I9Il/KJQvbKh+XO0ru+FOYIwQNdXd?=
 =?us-ascii?Q?hLtkkESXDG99cYkTXECO/JSke9d/UCGgW/ToTP6JjpaN5jmDXqWFMZ70t2bp?=
 =?us-ascii?Q?ohHuGHQ106rs6QzExETqpLw/zsXZXAp+ymbI8fOgCQIrGaDcuOruNaGw5069?=
 =?us-ascii?Q?d8IV0SaU2qOJT2YVAJ2Q1IOVP0f7kkjHcP1eNXMMrXk11lVKmk0u4OVFcs0h?=
 =?us-ascii?Q?tZHA/Hd9zclwu+/NpBWHmnvF9X0bzAQbM6pnrahcdeujwsoPHA0aazY8jMsP?=
 =?us-ascii?Q?AqM6GpaU8i1FtNdlogyhFZCMPJuToBX5hINNQnr2tL2twv4oTtyWjUtcVD8E?=
 =?us-ascii?Q?78YCeDTXnS/5ASKjGQPZYoeJLAvl2azp/+4r6ZhJyEFmIq+Wo1NI4iG0MCa/?=
 =?us-ascii?Q?tkje6Qd6uhpgbvM1CAx/acuFvbDZ2NsjXwfYLB52sjs5Aw8ZW5nUqNsk/Z4d?=
 =?us-ascii?Q?ogLXYn2v+OjrWaJbi57pSzrNoZq5Zq+KZnKhY7e3Dg8v/ovTXTzVk2dLCSQy?=
 =?us-ascii?Q?oaomOMFGrBnEK9ZpVOt5bozBHWVVaIjcoPmt1uze2S6ETgVwOmzMM3KwIP0T?=
 =?us-ascii?Q?Ita5O4OivMp+jallRdgnEazkHFH9WoGicfAB8WfTyomJh6gH+8ek1uobqfCz?=
 =?us-ascii?Q?UNVEt0aQkOk8cDZEza80jmirHbHP/EGmNGcX/oUvA5JMYjv2bDeN85ZOlMS7?=
 =?us-ascii?Q?ocPO2eKF6MC53cNx74pZSBw0W9h9w55hUWPQWt7CCh1dD3PYjRNCH7Ngtj9t?=
 =?us-ascii?Q?7Ne4lDmmtvvc5GaED4ccu/se2YujnLMYxH66unNrb/zQsKR8RWTu3gcl5tU9?=
 =?us-ascii?Q?gZd8taxKXSjb/dBvd6XmPTlCvmkSOgiMLtGkUjRt?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DWJBY5qCirQ9Ht++LkyeBkCrbWsBpO/SlckMnJOOUCa9oi7cMSOlp/SSbDv4pdUNKwF9EZ4ACJNkmggvNxy8KRksIX+ENQ2wex9RGy2w2pufKfhU9OyDaRVObNbf5REvAzmeUw58ax8oOvYPSHaXP8pv9kXl+KHRAd4CGOtcugicYSynHeVKLBe+AriEhuZFLLg7wmmkK1CEHvkqOFGhGjwa+lJ13QCnvSBrL2m/l39NWRpwyT6PsTUYZPJfScrzP79+PXfSNn+ztGyGYvWG18+J9t02KoYl4Dq6Px1wckMOEzX+BMqrv1zu+cFJ12iLSSz1YWsi6oH4b7nIWxaD5oM3ubwhcFW4Yo6m9UW+ZRsZFA2U2RZ1xSJuKKwx/zy0zdr4fYHKJt6w3Eu//SlKV2MAm4fO3JNbGJDQPlrv1HOSe+73zv91IPfjrSlqjsqYDqZQr62vqmXqUHmB2KcSdFpTvJlbyx0XUDGIoSFbO0fCOb8LzJbZEuPtvlpeEYxCNRUZIxRV+i5SiUPIau8jT8xDrxrUVCvmNiOEh7AfV4wBSz3msrjlUFuBmlPYPWYT6hj63sz7x8ZSk/KhOWxO5zR0Jyh/qi83O6tyg68dglmThign6cPNbUQBugdY3WKVzoDHlpZnHeo1wzQTItxFEzMCOaA2VnoekmlpNJPm/ZbzGqvr8gAoBGKUaGYDSm9/jmq7zUEs+baiEQRSr6ji/YcJUZ9O4kfEG9FgDnQaHYXKGM4yZgiJSdg1jyiTcG0zsUQAkYvDVWpjOeJZ85dXecJGrryuaHbeQzMEkBnfO/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c108f017-eb0b-4360-d174-08db789bbe1a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 12:24:14.0404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kv0Wuidt5/lLlPqw2HDPMqMM/GbS6bpeQN+XOk9tuepc8YEkhtXmaGa0nwv6Lr/YKCUW5hd/vue5aRcLcwWc/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-29_03,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306290111
X-Proofpoint-GUID: y__SIK522Msgc4IQzCmLlo3uIzjEGlpD
X-Proofpoint-ORIG-GUID: y__SIK522Msgc4IQzCmLlo3uIzjEGlpD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:05 AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> XFS has strict metadata ordering requirements. One of the things it
> does is maintain the commit order of items from transaction commit
> through the CIL and into the AIL. That is, if a transaction logs
> item A before item B in a modification, then they will be inserted
> into the CIL in the order {A, B}. These items are then written into
> the iclog during checkpointing in the order {A, B}. When the
> checkpoint commits, they are supposed to be inserted into the AIL in
> the order {A, B}, and when they are pushed from the AIL, they are
> pushed in the order {A, B}.
>
> If we crash, log recovery then replays the two items from the
> checkpoint in the order {A, B}, resulting in the objects the items
> apply to being queued for writeback at the end of the checkpoint
> in the order {A, B}. This means recovery behaves the same way as the
> runtime code.
>
> In places, we have subtle dependencies on this ordering being
> maintained. One of this place is performing intent recovery from the
> log. It assumes that recovering an intent will result in a
> non-intent object being the first thing that is modified in the
> recovery transaction, and so when the transaction commits and the
> journal flushes, the first object inserted into the AIL beyond the
> intent recovery range will be a non-intent item.  It uses the
> transistion from intent items to non-intent items to stop the
> recovery pass.
>
> A recent log recovery issue indicated that an intent was appearing
> as the first item in the AIL beyond the recovery range, hence
> breaking the end of recovery detection that exists.
>
> Tracing indicated insertion of the items into the AIL was apparently
> occurring in the right order (the intent was last in the commit item
> list), but the intent was appearing first in the AIL. IOWs, the
> order of items in the AIL was {D,C,B,A}, not {A,B,C,D}, and bulk
> insertion was reversing the order of the items in the batch of items
> being inserted.
>
> Lucky for us, all the items fed to bulk insertion have the same LSN,
> so the reversal of order does not affect the log head/tail tracking
> that is based on the contents of the AIL. It only impacts on code
> that has implicit, subtle dependencies on object order, and AFAICT
> only the intent recovery loop is impacted by it.
>
> Make sure bulk AIL insertion does not reorder items incorrectly.

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Fixes: 0e57f6a36f9b ("xfs: bulk AIL insertion during transaction commit")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_trans_ail.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 7d4109af193e..1098452e7f95 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -823,7 +823,7 @@ xfs_trans_ail_update_bulk(
>  			trace_xfs_ail_insert(lip, 0, lsn);
>  		}
>  		lip->li_lsn = lsn;
> -		list_add(&lip->li_ail, &tmp);
> +		list_add_tail(&lip->li_ail, &tmp);
>  	}
>  
>  	if (!list_empty(&tmp))


-- 
chandan
