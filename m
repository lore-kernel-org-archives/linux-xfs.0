Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CD8C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 06:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239851AbjFMGwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 02:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239786AbjFMGwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2023 02:52:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF571727
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 23:52:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35D65P3Y002120;
        Tue, 13 Jun 2023 06:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : in-reply-to : message-id : content-type : mime-version;
 s=corp-2023-03-30; bh=DYHZvntaKYSVyGcLxzjybhuEk5BZ4EUkSPpVjZgSmLI=;
 b=EMpX/3X0dk94pqndftpTgfwsSFZrDbtVGiwWuETdWJ3mOSdoeM08pdk9WaDKJNTkCO5A
 52zDK6/F5avl/R0TGDlfR/BoO7v3X7cI9xe9onO3q89EJitjh2gmrgRBeYkkhG0UjnSp
 WsO5YuCZgw25oCcme28X7XkICDwdvaumOKpa3CX9x6QEiv7kUNW2cB9qlUPaoWyHR46F
 vuS+aiV9LbnifhgK8QYB+5CTeDOwtSnaX0U7qf3GZ4aNkstJvwNF66vDD3Pih12swYnM
 NG9oWUJrELetOClrFX8wFyrUEuvw89p+gFBAxtx/SUb3duENY5rIPpQvGOdqxGkTCRBw PA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gstvequ-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jun 2023 06:52:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35D5v5ka017946;
        Tue, 13 Jun 2023 06:52:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm3h153-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jun 2023 06:52:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZN4fdb6UimPnZmrbcTEhraxXbYK/OHdQUATia79Vb5tmuv4LIbwmkplqCYvkWy9hTjkQyKklAEkfCXIhtzgrFENgBJLdKsC4f0MuyuIJirfsWG8Hn233ieb9jTQWVrKcbEOz8rfA2Pm2uKWpmmL3LbOk2QO8ixWTlo6d6Nm7cLZoyVzLsB6rZipfuzxB8lnlUqetO9syta59tIyhc1oEbLOhNoKQ2/koLNMnL75xO3uBlFo+PdsGlIV8kRClGqQP89Z4VSP3uZbw3WKYcwkPG9v8pcSkYG/ekwuT5P4NrvSg72h84s24l9K7tUpHGQbCjeE8QN0npMgEtxVLrsxYjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DYHZvntaKYSVyGcLxzjybhuEk5BZ4EUkSPpVjZgSmLI=;
 b=FWC9IMorLEdqMKTf1leZaxacu3JMtieF8rBdyO7iE4N2f/Ytch439CCJR1AuZGcsvmAu/2FbR7dfkXgaTizR/AITjlx01vER+jTi/5tVw8iTbAz/CPiYE4U9o0HmDAgq7WDjuN6rdmmEGSQY7Jw+oZeeV1MBHzIpOzBhd3RwyPwuBeCoz+SFTfPlswZB2XsT0iAFSiy2Ag1elyxgp4d5yM3poatBE93cp6aHWEq711qXlTwJN0SDFW0keRWWL5PIdp8U9i7V+qnOcb7tvfDdQdrPsuMCK24rPE/Jldm+BdDYh3GSkV26q3ph3ww3Twmdbg6Z6ULjlWFJ+VaTkja1DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYHZvntaKYSVyGcLxzjybhuEk5BZ4EUkSPpVjZgSmLI=;
 b=TqJHgvmiCGbx869s3MZKkg/eTGAOvxVSNZ4wGZooMNdbxQ3P5BBDhN+e8XbL2sRLQHJAUtGbB85uVygjqjqocGmJ/WXGkPRmO0lx0TGlRx2QttuFbDaI7otqG2GP5Eh1dYXiKdsVAqif0DU2lIvCLXSYpH5tpxs+z2ERW8ssKlI=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by BN0PR10MB5237.namprd10.prod.outlook.com (2603:10b6:408:120::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Tue, 13 Jun
 2023 06:52:04 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::9dfe:c1aa:2639:6e69]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::9dfe:c1aa:2639:6e69%6]) with mapi id 15.20.6455.037; Tue, 13 Jun 2023
 06:52:04 +0000
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: logging the on disk inode LSN can make it go
 backwards
Date:   Tue, 13 Jun 2023 11:50:03 +0530
In-reply-to: <20210727071012.3358033-9-david@fromorbit.com>
Message-ID: <87a5x3am7m.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0120.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::20) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|BN0PR10MB5237:EE_
X-MS-Office365-Filtering-Correlation-Id: 39adb116-8b24-4f4a-f69a-08db6bdab25d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TUhX9PIoj7N0rDZd3qUs426zaZNWGPElDICtM3M70MvhmrmuhOZdombQ8cgJWGBNRX15wl2YDLIZZ9O3pA17nNXtN5upLQbFZ20bkVNai9j+DKsFBwoqzwKMBFlLOWvRP4OGVwP6MnqkMAcTz4u/qHKLJSkkfesuKmFjtQPDN/H46dwP8L18GIWqtS22N1Tvw2NrYZDSkRjciGcr0hySk3m0CwAMYmDHF0EGxfBflWaOU1J0N4+wjcxmmsjJTtkpnZQSned4c2isQtWkNtVxmyDIjIHyVDuz1hDvvdxexUi0sEFdhapeJoK3eRevP6zWFC0is17F2bj1DrSqyUcjdTA2CVAK9JNT5xLltBw7Y4t9HqH5M3vz+X6yfrgWb1CQJDkZLg94Che6GnZgviolg4q/wGy9UuQ/RkXMuSy36yegJLLviIvgB/xyJnIqb8hkS+BLdE81Ho+XkPCldZDx7PRWlrsSg49mokAEWq6f8tZxtsvC3yku08K3gUKn2pzL5KglBEMN6sJi9cT67JbnTBxcJ9t3x7bbdDqP0ANCQoMQJBktYECo1pV8nHiFeKxi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199021)(83380400001)(86362001)(38100700002)(33716001)(478600001)(4326008)(6486002)(8936002)(8676002)(30864003)(2906002)(5660300002)(66556008)(66946007)(66476007)(6916009)(41300700001)(316002)(186003)(6506007)(6512007)(9686003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4wSb/Fa6mGtLqeZjmT8tEcVr8Ner1jP8LgQw8Aad7kRBTGxU6xWRcAw+3A+r?=
 =?us-ascii?Q?idGUN+NG2pEQwRTWEIEnwXWHSP6wU72ECXaK/ES+4aivg5Fo0kP/prVWDJ03?=
 =?us-ascii?Q?XZckOBTOrIbKpu6jnW9QJLHOpr8AsrXJXvVlX5JkwDWMdKA5uvM9ctmNQzSp?=
 =?us-ascii?Q?eZe/y2suXrta91/0JxR9vxrdg4qdJGRkJqND6SHUcQduLx6jWEFmGGsMk/iL?=
 =?us-ascii?Q?m0dzh7hbO9nzVAAvCfOK+m4sMUhxohPRvvQNa/AE785ECD8IdlDr7DOg6/Je?=
 =?us-ascii?Q?LiNBJWOUGNRKIBdYq7TL+0o74B/o/8X+QuB0B4U1UfSpjgU3O8opAVDdJF2K?=
 =?us-ascii?Q?R7lo2E9a5bySa8kc8SZQxJI2oqsd80shrvSxLZiyrl3W6ly9LxVoyi9SCMKY?=
 =?us-ascii?Q?igMmdTRTDUA/eW9C7t4q+K8XuvrRgjCrIeEGxHp6Wg38U/0d0/bg/LVUWEqZ?=
 =?us-ascii?Q?X3pd6LE7JsQE27HKZpVtAthwTzM5NoV5ByzUgYAxqHKesZMGBgOdGvpLW7aT?=
 =?us-ascii?Q?iNCSqp0wJ567uWBzwW2xzikxlXVjnN9X0hA/p+T2TPqtYxYWTmuOMlBSJ+Yg?=
 =?us-ascii?Q?u7G3+junmOqRfrGClv9lYlmTxE0pwYtdJdWC2TnJDBIr774GK4AHiyGTHIr7?=
 =?us-ascii?Q?/kGG/G0kJd6VL+SE6/Kv6IAUFfGYLLi18618AXunR6n2CMOBuyNl2M0tZOLi?=
 =?us-ascii?Q?aHxT/uT4vSw93jPtqD0u3xq2Yk1VilAkl1X+SfUaKvQeA6JnTNpfVMv8pKVM?=
 =?us-ascii?Q?9ovXRI/ZkCEPpcvmIz/MeatzJ6PuumHNqjhzdCeDptAeq6ZLSGdskpaZTe1+?=
 =?us-ascii?Q?NqrofMjiz2TprixMCAq8PA3e9HtbT3X6egSqXKW1bzzlaSQ53C3EDtDBYzc4?=
 =?us-ascii?Q?UY9EBmlxJorGc4Dz2vvztGbalOrfAkT/+AtS5upFrEhiTOkVKF7bOJIdflbI?=
 =?us-ascii?Q?msqUfLMmuyI3uY/ISYecgpQmJ9qwXE/shtuT07aX+vXVyZErF3a7YnDMABJP?=
 =?us-ascii?Q?1NNb1+o3Xe3nWbCU5tOv1fdkVwul2tBUeDMXxDH94Ffth4qsEn07qUT/VHIX?=
 =?us-ascii?Q?qPZo8NCpbqJM3nxMAOCcUtNEwyXNStCBqM9w8leWBUeyarWQKCHjoMaUi4xH?=
 =?us-ascii?Q?WdYVriz1LGNtUvssl/7ek9nsxwt1mbYAE7xyu3ikeLlQ5LosBiWYCryGLeo6?=
 =?us-ascii?Q?MQzKPQTeRHC9y+fTmw1tygT2CF3OhpdaAGLfHbYshPTDGu5A2oUF2EJEiMAq?=
 =?us-ascii?Q?TiHgmDXHP1g6mjIpQWnMwiwM3ylKrF5NBFcZOJYOpm1D9bEuXm+M1KXwX4I3?=
 =?us-ascii?Q?6oO4MLxLE+De8TvEWYVO+R26kRbm1DviNDEk2GHHz8JlLvnj6BBm4i/b30hH?=
 =?us-ascii?Q?X31DUJA1dFjYm/FYNa/jVtzKCCwC3N6X0T2e2a8B33J21byUA6cSg3r9Ly0l?=
 =?us-ascii?Q?ajml5waosZ3whnTZ4HSa1MWyhTIUH/fdn4YwXzcXM9pMC68bdRdqW5RaQFoc?=
 =?us-ascii?Q?GPVr2yDy7q649FQhK4MUHZ4WXInHvt2oHgvpd28U1EwvBBL9fRUARf1OX98j?=
 =?us-ascii?Q?e8Pc2qRiLNgxdT4VlwvDyMjGASGDZAK8EZ2DF7vH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qx84aFKn4mIx5GaImp2B+iJa07Ed071YXjGF25VLcWATCmSLy6qsGhRFsWH20/IfW71NIPq5Ngsd1/YZTVNW6WRl/AC+xCR1TN/I9WNH16BG9vFHkuIykm+aDDWuIbRVvhIE8y1KNqwp6h/vdJEF/dc+wUL0nJtSSfHf/6SsRtdDstCprbf+7WeGYtFct+Fv3JUn/oj/AqwV2wcqzwCfDdn0m66JyDBuGSwPO8+imI8FwtFoqYl5OyRGppp94lqIcFBQqwohz2C+T5LlPg9HHEltpm63OIGoRbgDF2Tkw8zc55FoAx0/Ded0qJ3RYk5lXeO7ZkCI4IoaBDbgzrR6dlFC4iaReTz1FsIoEQ6B+inMAdaDBCXvJhgoKrhHR3i8xBX8fP9SACTB8XMNzu+LIjp6YAAwCsH4JbCBGve3JRemw+AvihsEnHmoTLoyybp8q7lWCyuW4Xe0me/A+zCGEu2Sxtkc1i9xyk0eVtZns0tLS2kk2IG/ffrtIqF7KNW1HoMr2pdbOd9E4G5SzoSx8utPDS8I8d9WukkBFhcv/bhftqlXZvORf1NW6XdoMTYZLBzgAWDvd3yG5RsWrd1BXSqSUNuuHij3ozRea+WmXb58UqwQC4v4g6qKZjyCCttbFcPggfMltKcYbCib85M/S1OD6zEEQkdub0I5KF7FggI3GlXHSRAHDhgCjYjpwQ0IMz+wRQoiW41UtBWAyNdOk1WiEy9iIFablKShmIQwfImc0qFUtvffz6WZvv5GkgeTg9HUW7HSpjS0FtQbkKDQLL57mDntD6eTH5wkJbSV5UE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39adb116-8b24-4f4a-f69a-08db6bdab25d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 06:52:04.5137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HG05xYgAyymOTF4kjGXs06nSpvvs1vySSrA49BjmgfSnBP5B0cLOnOY4nkl/vVEWqw27n1YZVQ6b0lieO6O0nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5237
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-13_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306130060
X-Proofpoint-GUID: 6kUPGvCttU3ugCMDO1oiqrk-f5iXBbMM
X-Proofpoint-ORIG-GUID: 6kUPGvCttU3ugCMDO1oiqrk-f5iXBbMM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 05:10:09PM +1000, Dave Chinner wrote:

Hi Dave,

I am trying to backport this patch to Linux-v5.4 LTS kernel. I am unable to
understand as to how log recovery could overwrite a disk inode (holding newer
contents) with a Log inode (containing stale contents). Please refer to my
query below.

> From: Dave Chinner <dchinner@redhat.com>

> When we log an inode, we format the "log inode" core and set an LSN
> in that inode core. We do that via xfs_inode_item_format_core(),
> which calls:
>
> 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);

> to format the log inode. It writes the LSN from the inode item into
> the log inode, and if recovery decides the inode item needs to be
> replayed, it recovers the log inode LSN field and writes it into the
> on disk inode LSN field.

> Now this might seem like a reasonable thing to do, but it is wrong
> on multiple levels. Firstly, if the item is not yet in the AIL,
> item->li_lsn is zero. i.e. the first time the inode it is logged and
> formatted, the LSN we write into the log inode will be zero. If we
> only log it once, recovery will run and can write this zero LSN into
> the inode.

Assume that the following is the state before the inode is written back,
Disk inode LSN = x
Log inode LSN = 0
Transaction LSN = x + 1

At this point, if the filesystem shuts down abruptly, log recovery could
change the disk inode's LSN to zero.

> This means that the next time the inode is logged and log recovery
> runs, it will *always* replay changes to the inode regardless of
> whether the inode is newer on disk than the version in the log and
> that violates the entire purpose of recording the LSN in the inode
> at writeback time (i.e. to stop it going backwards in time on disk
> during recovery).

After the log recovery indicated by me above, if the filesystem modifies the
inode then the following is the state of metadata in memory and on disk,

Disk inode LSN = 0 (Due to changes made by log recovery during mount)
Log inode LSN = 0 (xfs_log_item->li_lsn is zero until the log item is moved to
                   the AIL in the current mount cycle)
Transaction LSN = x + 2

Now, if the filesystem shuts down abruptly once again, log recovery replays
the contents of the Log dinode since Disk inode's LSN is less than
transaction's LSN. In this example, the Log inode's contents were newer than
the disk inode.

Your description suggests that there could be a scenario where a Log inode
holding stale content can still overwrite the contents of the Disk inode
holding newer content. I am unable to come with an example of how that could
happen. Could please explain this to me.

> Secondly, if we commit the CIL to the journal so the inode item
> moves to the AIL, and then relog the inode, the LSN that gets
> stamped into the log inode will be the LSN of the inode's current
> location in the AIL, not it's age on disk. And it's not the LSN that
> will be associated with the current change. That means when log
> recovery replays this inode item, the LSN that ends up on disk is
> the LSN for the previous changes in the log, not the current
> changes being replayed. IOWs, after recovery the LSN on disk is not
> in sync with the LSN of the modifications that were replayed into
> the inode. This, again, violates the recovery ordering semantics
> that on-disk writeback LSNs provide.

> Hence the inode LSN in the log dinode is -always- invalid.

> Thirdly, recovery actually has the LSN of the log transaction it is
> replaying right at hand - it uses it to determine if it should
> replay the inode by comparing it to the on-disk inode's LSN. But it
> doesn't use that LSN to stamp the LSN into the inode which will be
> written back when the transaction is fully replayed. It uses the one
> in the log dinode, which we know is always going to be incorrect.

> Looking back at the change history, the inode logging was broken by
> commit 93f958f9c41f ("xfs: cull unnecessary icdinode fields") way
> back in 2016 by a stupid idiot who thought he knew how this code
> worked. i.e. me. That commit replaced an in memory di_lsn field that
> was updated only at inode writeback time from the inode item.li_lsn
> value - and hence always contained the same LSN that appeared in the
> on-disk inode - with a read of the inode item LSN at inode format
> time. CLearly these are not the same thing.

> Before 93f958f9c41f, the log recovery behaviour was irrelevant,
> because the LSN in the log inode always matched the on-disk LSN at
> the time the inode was logged, hence recovery of the transaction
> would never make the on-disk LSN in the inode go backwards or get
> out of sync.

> A symptom of the problem is this, caught from a failure of
> generic/482. Before log recovery, the inode has been allocated but
> never used:

> xfs_db> inode 393388
> xfs_db> p
> core.magic = 0x494e
> core.mode = 0
> ....
> v3.crc = 0x99126961 (correct)
> v3.change_count = 0
> v3.lsn = 0
> v3.flags2 = 0
> v3.cowextsize = 0
> v3.crtime.sec = Thu Jan  1 10:00:00 1970
> v3.crtime.nsec = 0

> After log recovery:

> xfs_db> p
> core.magic = 0x494e
> core.mode = 020444
> ....
> v3.crc = 0x23e68f23 (correct)
> v3.change_count = 2
> v3.lsn = 0
> v3.flags2 = 0
> v3.cowextsize = 0
> v3.crtime.sec = Thu Jul 22 17:03:03 2021
> v3.crtime.nsec = 751000000
> ...

> You can see that the LSN of the on-disk inode is 0, even though it
> clearly has been written to disk. I point out this inode, because
> the generic/482 failure occurred because several adjacent inodes in
> this specific inode cluster were not replayed correctly and still
> appeared to be zero on disk when all the other metadata (inobt,
> finobt, directories, etc) indicated they should be allocated and
> written back.

> The fix for this is two-fold. The first is that we need to either
> revert the LSN changes in 93f958f9c41f or stop logging the inode LSN
> altogether. If we do the former, log recovery does not need to
> change but we add 8 bytes of memory per inode to store what is
> largely a write-only inode field. If we do the latter, log recovery
> needs to stamp the on-disk inode in the same manner that inode
> writeback does.

> I prefer the latter, because we shouldn't really be trying to log
> and replay changes to the on disk LSN as the on-disk value is the
> canonical source of the on-disk version of the inode. It also
> matches the way we recover buffer items - we create a buf_log_item
> that carries the current recovery transaction LSN that gets stamped
> into the buffer by the write verifier when it gets written back
> when the transaction is fully recovered.

> However, this might break log recovery on older kernels even more,
> so I'm going to simply ignore the logged value in recovery and stamp
> the on-disk inode with the LSN of the transaction being recovered
> that will trigger writeback on transaction recovery completion. This
> will ensure that the on-disk inode LSN always reflects the LSN of
> the last change that was written to disk, regardless of whether it
> comes from log recovery or runtime writeback.

> Fixes: 93f958f9c41f ("xfs: cull unnecessary icdinode fields")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_log_format.h  | 11 +++++++++-
>  fs/xfs/xfs_inode_item_recover.c | 39 ++++++++++++++++++++++++---------
>  2 files changed, 39 insertions(+), 11 deletions(-)

> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index d548ea4b6aab..2c5bcbc19264 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -411,7 +411,16 @@ struct xfs_log_dinode {
>  	/* start of the extended dinode, writable fields */
>  	uint32_t	di_crc;		/* CRC of the inode */
>  	uint64_t	di_changecount;	/* number of attribute changes */
> -	xfs_lsn_t	di_lsn;		/* flush sequence */
> +
> +	/*
> +	 * The LSN we write to this field during formatting is not a reflection
> +	 * of the current on-disk LSN. It should never be used for recovery
> +	 * sequencing, nor should it be recovered into the on-disk inode at all.
> +	 * See xlog_recover_inode_commit_pass2() and xfs_log_dinode_to_disk()
> +	 * for details.
> +	 */
> +	xfs_lsn_t	di_lsn;
> +
>  	uint64_t	di_flags2;	/* more random flags */
>  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
>  	uint8_t		di_pad2[12];	/* more padding for future expansion */
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 7b79518b6c20..e0072a6cd2d3 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -145,7 +145,8 @@ xfs_log_dinode_to_disk_ts(
>  STATIC void
>  xfs_log_dinode_to_disk(
>  	struct xfs_log_dinode	*from,
> -	struct xfs_dinode	*to)
> +	struct xfs_dinode	*to,
> +	xfs_lsn_t		lsn)
>  {
>  	to->di_magic = cpu_to_be16(from->di_magic);
>  	to->di_mode = cpu_to_be16(from->di_mode);
> @@ -182,7 +183,7 @@ xfs_log_dinode_to_disk(
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
>  		to->di_ino = cpu_to_be64(from->di_ino);
> -		to->di_lsn = cpu_to_be64(from->di_lsn);
> +		to->di_lsn = cpu_to_be64(lsn);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &from->di_uuid);
>  		to->di_flushiter = 0;
> @@ -261,16 +262,25 @@ xlog_recover_inode_commit_pass2(
>  	}
 
>  	/*
> -	 * If the inode has an LSN in it, recover the inode only if it's less
> -	 * than the lsn of the transaction we are replaying. Note: we still
> -	 * need to replay an owner change even though the inode is more recent
> -	 * than the transaction as there is no guarantee that all the btree
> -	 * blocks are more recent than this transaction, too.
> +	 * If the inode has an LSN in it, recover the inode only if the on-disk
> +	 * inode's LSN is older than the lsn of the transaction we are
> +	 * replaying. We can have multiple checkpoints with the same start LSN,
> +	 * so the current LSN being equal to the on-disk LSN doesn't necessarily
> +	 * mean that the on-disk inode is more recent than the change being
> +	 * replayed.
> +	 *
> +	 * We must check the current_lsn against the on-disk inode
> +	 * here because the we can't trust the log dinode to contain a valid LSN
> +	 * (see comment below before replaying the log dinode for details).
> +	 *
> +	 * Note: we still need to replay an owner change even though the inode
> +	 * is more recent than the transaction as there is no guarantee that all
> +	 * the btree blocks are more recent than this transaction, too.
>  	 */
>  	if (dip->di_version >= 3) {
>  		xfs_lsn_t	lsn = be64_to_cpu(dip->di_lsn);
 
> -		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
> +		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) > 0) {
>  			trace_xfs_log_recover_inode_skip(log, in_f);
>  			error = 0;
>  			goto out_owner_change;
> @@ -368,8 +378,17 @@ xlog_recover_inode_commit_pass2(
>  		goto out_release;
>  	}
 
> -	/* recover the log dinode inode into the on disk inode */
> -	xfs_log_dinode_to_disk(ldip, dip);
> +	/*
> +	 * Recover the log dinode inode into the on disk inode.
> +	 *
> +	 * The LSN in the log dinode is garbage - it can be zero or reflect
> +	 * stale in-memory runtime state that isn't coherent with the changes
> +	 * logged in this transaction or the changes written to the on-disk
> +	 * inode.  Hence we write the current lSN into the inode because that
> +	 * matches what xfs_iflush() would write inode the inode when flushing
> +	 * the changes in this transaction.
> +	 */
> +	xfs_log_dinode_to_disk(ldip, dip, current_lsn);
 
>  	fields = in_f->ilf_fields;
>  	if (fields & XFS_ILOG_DEV)
> -- 
> 2.31.17
