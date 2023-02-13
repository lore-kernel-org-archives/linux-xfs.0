Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4A4C636CC
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBMEIF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBMEIE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:08:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650EDE387
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:08:02 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iCI6028397;
        Mon, 13 Feb 2023 04:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=fAs+mGZ0OLDGRqmYJ2gVVpmVFQwiKIcl1w4R0We1r+M=;
 b=y24BYw+ShaooaSTJ34Xo0NTMq/Y9nkf8mIKVQAQy15DQjUVcD1scuFiG+t0Fp+Hn9xsY
 ndux+LpPlB52MwzPqGghD6qLzV1eIba+KiIcWmyE2HK3kzzbBQQ+pbLW5V2Pw2BqGeq8
 PsTu4L3y71QRxXdSZvf2gNy0wMIDxeH95+c2K8B7Fj8aDKv1GtkAMJ8qP3su5j3Jrnw3
 tJvxtPtSWcHE7MaHP3a8BxhUGYKW2jHZkvN3NdCZCSHiBApvAD5jBq7Cdm0A6A2FyEoV
 tGQzH4DfhBGm39RwVRFhU8Z2bUBBPNI+BUXRI5Yxsg/3RlH41yQnOPjhh+8tSJz5RwJ8 vA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np3jtsudb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D36Df1011685;
        Mon, 13 Feb 2023 04:07:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3k1sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLwBfzE6Ddp1v2agoI8dtxldduI/OjyPuXr2RD7WOA4YrqXjcpUR9m47dceOxzHlts1DcBck9HVniOkBaz0b/oekUS5R2uMiYZZQBcvjC2gU9FXn56Tz/EUKcgDPiDBJZ93O2LTEDfM5a8WeVj7hgi1doM4/w+EOh9rSY6iSqOdR7nZKrwBJUo9MUYJfVGEHX3z0nMGDBwGQ66GX4yt6b/vdRfAcmnTdYMreaG5ic+5qvxbxZ/bkTY8wogCnBzCA+BiQzlR2uXcYHJ8dsmQotKHZwwzUc7yqd501yH1B4eC4+vUHlLVpSUQaSdcNlwaSeNHjag5u6kZo/vTJDCkRlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAs+mGZ0OLDGRqmYJ2gVVpmVFQwiKIcl1w4R0We1r+M=;
 b=cq7cNBT9MAWAeYx0S1tLfb87x5TiHcauDcSBt8tdqo/5JmAdxrb8/rPUo/SMuhfE9nRREjhWNfW25QJhRnI7M26bHyRzfvns+OGDONm75TacUNXmbVbQWjpEu/5ToTg/gK3r0m5t4OeSHlp5kcu3xZQpUoS8JNCnESWPvpgQMkCMKZOdpnHatFwgTnULFgXyW3FTTd5yUL2ti/oIlMSPbLc2fh+v48ckwTRUg9E2y+7NA0JZQjtX3hGBMlihW0A7QRGjqH9s5c09grpHmPAZxz5UHDDYzWmVnq6TGIHDdKLd/moG5nkKoMHz31fGM0YX+Ben6HW7G6PbTmsJw1WY/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAs+mGZ0OLDGRqmYJ2gVVpmVFQwiKIcl1w4R0We1r+M=;
 b=MYkz6V3iBj9csEFsnKSi+XusGqGaHzNki4uOBNbp4SHmgL1uIFIO6QXqf/GRU2P/SnbeFRq844x9U7ZAH6SYkdv0kDRNLC/xGhHROonMxp4IQn+wOk61hbAWfiFpub0UVLZaifCr0wuIc6V8gfPo0gXCEHgasTkJ9cP3eWvNXNM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BL3PR10MB6089.namprd10.prod.outlook.com (2603:10b6:208:3b5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Mon, 13 Feb
 2023 04:07:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:07:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 21/25] xfs: fix missing CoW blocks writeback conversion retry
Date:   Mon, 13 Feb 2023 09:34:41 +0530
Message-Id: <20230213040445.192946-22-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0019.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BL3PR10MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: ff7ed880-d944-40e8-68b3-08db0d77e2c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dbeduf8Hyhkk4Vy4bVxhVIG+NHe9n0/Rt9wP198cxnxAZun2oQXBjDOtx1eDgQ2TIYXZLR5ctS1dd2e45idOMEVs5XtOVhcsiqhH9IUuPdH9+YDDIaqrqCrQ3GhIL4PQEiY3CtvgdTWRwgdmt7bOzX/rZUdFtU9HbRrc/KjPWgjcVftUlcDPwZ5D+Ul9rEM5JAe9fnlKwtOIg9LcU/sPvvaJ5Hfu4YchS1H78H8ea5suoRsNCJXOm5sDIw9CSiAMsqbaUcWhUtVWv5p4OxIo1NOQpr4d/hAi9f0eEQhCAPjOWttP/kgm3wRKCRHToLdwP1fFUdPHDKtckfO0dOtnhjlUoJoepdn+Ou8MFr5j9+aK1HWmr+3EjPG+RGEMdwZCUo8sFnUH/KA9En7hILLdZ8uObaZFH+zWF6wIYedfAspY6A4QAGqKLh53RealiskzMi0Uhlb2WmH4TI2U12P/csVbKHDlEhBo2H/5YLMCJ4kqOFW1oLEoSsQCAJ5wRW8YwXHFs5Qz76GUwd5QLdDp+msQ7VgYUs5CQ3y3qe+PdGZgfGizzgp2+pxm18WhxLneWLICKsNSMATr34kGsIDx+KJ+I40DizIOGT+MtXdv2iqjizqsW/8jWy4Ef9/tlVzbRdUWakjPlH8reFoJnRusJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199018)(86362001)(36756003)(38100700002)(316002)(8676002)(4326008)(8936002)(66476007)(5660300002)(41300700001)(66946007)(6916009)(66556008)(2906002)(2616005)(83380400001)(478600001)(6486002)(186003)(26005)(6666004)(6506007)(1076003)(6512007)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q3obJYMordSTsOVv3T5A5quzJ8r+cEmIyIrLlSsPf91VbURNY7r2ENqzrx/7?=
 =?us-ascii?Q?xVAPlYBz5lJ1wQWGlflO5C8hNHSoc4wO9LAp1ymhFf04QtvbmCnGCKEU9Xyk?=
 =?us-ascii?Q?vf0gcEdcarRAWLvIIL+Pmjt+VAQYzeY029cQnUvaW6MFtcP2XNvdRPbY++Rx?=
 =?us-ascii?Q?atiZDBn7DH/4leTIWhyZByli3F4Je7iYtn6Z/9W0UQAjrRfbHI2W7qIWzbys?=
 =?us-ascii?Q?qER7SX5ukbydSa2gDBrE2dEmxHWUbH6BHyH+ps5Gpkq/7XA/SYRSfm6R6Oid?=
 =?us-ascii?Q?zy/AtKy/sfqOjW3esyH+rrrneMKxZuCBrX8eVTcG+QdA1y5HUiwGad9y/8on?=
 =?us-ascii?Q?UNi+FoBe5MRb39SOhmJj+58qBmrzSHZG72TGpbZELX+8gucxiO1Y3rdatVGa?=
 =?us-ascii?Q?9RDIzXwhJ3l/vTb4AT64bnLQUa2JGg4uUSLuJ0sET0cP/djNd0AGhNvTLa90?=
 =?us-ascii?Q?3poDHtkqAeW+nMH9kz6rr4m8GG9PFT5kLA6DS1hCOIhkm/1ByUKasUs9VVW5?=
 =?us-ascii?Q?hdxlkpGUITK15XVJzl7oorWVmCzGAc1kNWT0COPed7bxKYcWobBHaV/L5tuN?=
 =?us-ascii?Q?CLHQ9M8TpWBNecdyWo1BrNKSIoaS+ZHoP7/CPXk3vk/z8dK21KR72PHeAWvd?=
 =?us-ascii?Q?6a4iXFIol77A52y7drZBLhlJTzm91tf8PJae1NmX9jlfGWonB0IgAXQCC8hA?=
 =?us-ascii?Q?+Jj5qtCKPPLF3Do4gaWHcXRl2No7Q+WzZ2aem4FCSyDS2vRGjv2qBMbIeKDl?=
 =?us-ascii?Q?YsaSqJjxr/RHiIc1uWPSk3Bktew7PCC50wP/W4tlwffnOe16OR7oYRr7rlzQ?=
 =?us-ascii?Q?QZFumXv0iNBbYocJKKvce6qITC/Bc2uycw8jVLWEaOYM7P5mMsgp46FZGSVf?=
 =?us-ascii?Q?k/zMLM9e7yM83scAMErVx/QbMDh6Hh/vnQITzVnO34ecq8Hy/OAINxhGb60x?=
 =?us-ascii?Q?9fQsiwsCOtX5g7sp2ryS39MMs7nYMWaPdR7K7THJcsCW6e+m7a4Q8+5ltkDQ?=
 =?us-ascii?Q?KKRou7xWFDljfS/RQKoZyTGAExk8g5qnPrVRNC783aHccbSh9kMF22F71p6U?=
 =?us-ascii?Q?YgeETH+AwWalkcgIZR6qg+TURHf2JQwR0a6hxVMSjcs7FlZXKWpMf9InUElL?=
 =?us-ascii?Q?2v/AeOVqiTzNQRHHGvkfr4qvxrEKOLt0mMEq4SHvoydXFyFaLZ2o81H1iaga?=
 =?us-ascii?Q?2CT7ScUkFJiQG5Xmkp/USwIzYaQpZCUFTF5AOWy5n1o8aITzCLn//jPwTWOZ?=
 =?us-ascii?Q?L6mnBHHooBPYHaDYzjRHvr8Hna87NILXC9rM1iHqhHE2IVhuCm8sjyBaFjpr?=
 =?us-ascii?Q?28Hcu+/wM0LqGp/b5kt5ujwHaQyP2PPwp/g3+h7GL2gpaatKLCPfEf25twja?=
 =?us-ascii?Q?ZI/ytXlvAXfdxDZ7yO7HOq3Ghxb0Myv3o5Xum+Wo4QoRMMTR2XfVAQjdwrAp?=
 =?us-ascii?Q?lTZmgGQMwdGYAtTHU5XiDFZdf7o3pvL3wjCJ/7Fz2cWlkpB9On72zauOIyS3?=
 =?us-ascii?Q?dNGWDdXerawvoxYeZLpS2n2SbOtSvW9jh3RwjSQ2+OFlydakewNE+Fvmw3Xx?=
 =?us-ascii?Q?9vqn5srhkinxYQ1TPu+yWLfiT0jSDtrL5eig8M11JybgeW6hKXObmsHagkBL?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TZtGIb3Jz7+VXVPyNCZ8xljsh7igzlg11+x+MGMQGM4aQaq7hIi6VJUrDZHKjnb4Z5GGBd0fXGK7wX1mqrhquab31VZ62reeSmAl1nSawqkyahlHHOennff5SxX8EdM/XJ481xeHt1X8SPzCkDmWfwOPTnoiSMG0ZvF/zMgn87IJ0ZqrgVZUryD0PrbdgNORVlkN6ASP1z6uaP729CBJQI6XNDZJXFvy49Ut/6KZsH7fEgPk0q8EpsDmGvslSWcI4YzzWwz93O0ZTzSL7FUDpVxi3k+9S77Dc8nlnx96djzxrUGKMq9z9BvYJiTEkne2Ra73zJ/4oc8MyrVtrpWpC+/mX3ZwNlADcaZxgSqK/BUDiZD76JohsV5lEnySfXm1GdsYgG+onA/zyRSHZKIiNHfjPcvat3bjW3eEqVnX2Rt9Z6opdpJFGx2MXVHDvbanC2GWwLPPK356Vmfwh4cAh36/T6PWyszlnUyyx4MGgKr7nWVE7WZY/gpm18zRX5p2P796jqqbajt1wA7Q3Nq3fa99dCr2DvJTtpsvX0PyB4vpjefbmEgUf3g0QjV578qOqpxC37Y7wSTF8P1jEnaIg9BUItmaGhoZ4Bf78Yq3gjzjqd4RebJfN+IORJ4XwTGiR1WHxPCb0ux455S0cf9UBBjoaDIy/JRh6dD6hfHVBM2mIGfK0QlTbaJvZiRV4JbQ/ZRtsOfhy1BYbGerJ5l7gEQFmrIuzAAk1NugkdJBmHHbvbdf6EjRok2Du5pcTIW26HhqnnMEZlRjEtOS3dxnMd1WgN4awVeg3mtDW2xgTEn6JTtP5BwNjbJ3zmrL1j3f
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff7ed880-d944-40e8-68b3-08db0d77e2c3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:07:56.0732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hm99taoCb1nLUA+mngz34GUKKhDWzabXvHzkrBbrGDgjggCQ8bR5s6GJ2Qyh+9gRFfV24M8hbsIS8Xg9lyPU5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130037
X-Proofpoint-ORIG-GUID: rh-5k1bXD9hvRY5tzRm94kJNyKXcNpRz
X-Proofpoint-GUID: rh-5k1bXD9hvRY5tzRm94kJNyKXcNpRz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit c2f09217a4305478c55adc9a98692488dd19cd32 upstream.

[ Set xfs_writepage_ctx->fork to XFS_DATA_FORK since 5.4.y tracks current
  extent's fork in this variable ]

In commit 7588cbeec6df, we tried to fix a race stemming from the lack of
coordination between higher level code that wants to allocate and remap
CoW fork extents into the data fork.  Christoph cites as examples the
always_cow mode, and a directio write completion racing with writeback.

According to the comments before the goto retry, we want to restart the
lookup to catch the extent in the data fork, but we don't actually reset
whichfork or cow_fsb, which means the second try executes using stale
information.  Up until now I think we've gotten lucky that either
there's something left in the CoW fork to cause cow_fsb to be reset, or
either data/cow fork sequence numbers have advanced enough to force a
fresh lookup from the data fork.  However, if we reach the retry with an
empty stable CoW fork and a stable data fork, neither of those things
happens.  The retry foolishly re-calls xfs_convert_blocks on the CoW
fork which fails again.  This time, we toss the write.

I've recently been working on extending reflink to the realtime device.
When the realtime extent size is larger than a single block, we have to
force the page cache to CoW the entire rt extent if a write (or
fallocate) are not aligned with the rt extent size.  The strategy I've
chosen to deal with this is derived from Dave's blocksize > pagesize
series: dirtying around the write range, and ensuring that writeback
always starts mapping on an rt extent boundary.  This has brought this
race front and center, since generic/522 blows up immediately.

However, I'm pretty sure this is a bug outright, independent of that.

Fixes: 7588cbeec6df ("xfs: retry COW fork delalloc conversion when no extent was found")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_aops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f16d5f196c6b..5d9f8e4c4cde 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -495,7 +495,7 @@ xfs_map_blocks(
 	ssize_t			count = i_blocksize(inode);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
-	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
+	xfs_fileoff_t		cow_fsb;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
@@ -529,6 +529,8 @@ xfs_map_blocks(
 	 * landed in a hole and we skip the block.
 	 */
 retry:
+	cow_fsb = NULLFILEOFF;
+	wpc->fork = XFS_DATA_FORK;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
-- 
2.35.1

