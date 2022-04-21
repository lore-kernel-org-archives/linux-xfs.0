Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C7EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Apr 2022 16:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390432AbiDURBV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 13:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiDURBT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 13:01:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774FD49CAF
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 09:58:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LEWkKQ019340
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=sQ5Uguy2wkoqFvEZo67/Onuka4ZSlVlWmFkvtBxpoI8=;
 b=EEQjPza/ctL/NTrqah7ATVddHkEB8jNPDVip43+LhKJtEnPe0JLLLSJYMIgCHj3tBBN2
 0YbGu7yE5+PV0HKFRhnydRUkMi2AekCs9EzxXkFSdwlVkFxXboIW8afo24KD+DnUXUVD
 rJkSpiw9p9R9Z/+N+pULJyW3JHJYYfxTa6twa7p/1vl8uoH+HhZCWkqDLX21HCDbM44P
 ilIgUA3anOf9ar2J+hZe+XMKa2cIxUDY+Lbny7nPk7POQ32ueCoISgDTKhEroJuoXN4X
 QWwBuDtpMFtsWTSU2ccrO0O+YmxS8rQpPg9ecwbqIk88dWtSonDiLnQRNVj7cfkWGMIy CQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cvbbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LGqDqo018189
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8c86yj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7PUGrsqh4T6q5AFUjWS4uYUWvdrfUY+Yv50gxjaCOQtNm0m4sN9NT0CiOVQy1PCtJihvmCsxr8PsNWLxVMyjlHr1URco2gyDGtJLWadwl7+J8gAShtkNI1pU5lSJ9Cspm9YscMieBFK9Tm6uWS5KTE+DnzHseUlZSTpuekYkdDvSqVCqrc5NBSbUODNQpbAES0WtRJxL4feCssZrcc3yODQtWvINFvTrx89jygLr8zkX2/nRAK8B+ykaDsh6NlxMMaApJh6nGiNjukaSwJe9GiWi//79Z1G5TpUR2BtJx3CkhzRmq8CtOKpBPCq2ZIfprgAXchiWdPlZgPtPJLr7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQ5Uguy2wkoqFvEZo67/Onuka4ZSlVlWmFkvtBxpoI8=;
 b=Sr1vDRCYpPNFrhfU5kV+vh3fQNzTSeIc2Uf37/TU6fs8tcG4lC2brYwGpN78HXAI50kRvJVWi7HBHuJI8TWGG77nRG8hiN63vkDfj4EEa4nslOlULbxG6fBoLKAsVuUFAvGdoD3UASgQeN7YgyYou8PyjZHZBPt0Aia3AbO8oRk064R3QM+o1dqjZARDNgfrPR7z7FwI7AW1oi6DwjID5aeuKm6cIyPOTnLyB/YrX8uyWvBJH4o7a4OtsT55e0UZJcKRHWziH4u/NMFgu97U5Gg+wjktrmqcnUwkn14cbHOgvjLPKw2MvWRNIcK9aJXxHIPA3lsCMnY9+BGrIPvi1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQ5Uguy2wkoqFvEZo67/Onuka4ZSlVlWmFkvtBxpoI8=;
 b=maGyBZFE+mj0aYPqwPArIpjrStthF4Gjlw75narFHSdRRanmqpCO+zhH8RSa0039mKSXiThYbo8z38cjuq6/0EvknribUGSOJ68/YHDVYFYF50YYIfpY5cmswYXEKV4CSKrXxNby7Gj2EgPcA4XUq9GMQphzlzu4gwWvtfOR110=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM6PR10MB2537.namprd10.prod.outlook.com (2603:10b6:5:b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.26; Thu, 21 Apr
 2022 16:58:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 16:58:24 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 1/2] xfs: remove quota warning limit from struct xfs_quota_limits
Date:   Thu, 21 Apr 2022 09:58:14 -0700
Message-Id: <20220421165815.87837-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220421165815.87837-1-catherine.hoang@oracle.com>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c72c3203-6f2a-40be-4fcd-08da23b82598
X-MS-TrafficTypeDiagnostic: DM6PR10MB2537:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2537D77AC6AB99916B146C6789F49@DM6PR10MB2537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzIa0D7ErzVsQ12Gmmc1Heu39LVJ2nylVCNcV80wnj3jFSgDxnmHTYDxWYEWAmGP8Qc+rJr4re8v3vQ9GrUuR8uHKssk6Zc66K5rEOgCMRAHtZW7XtCtz8+WeRn/kYg4Xq87gfIoYuq8BKgyBuICYLlJ9T3RSckAeru2M/D5AyOn4zz15ad5zFTUZq6r/1GH46BGnimuxIw+DsTyaE0z6A1c8B3ZoM5ooUP0TzLKscJIKzaoN/21dHGPUB/LqoLxZGSCP1pfI3nhsNdlpRJqENJSpZDhc4EtrBFWRyjFfr7hzkruXaqGfRleTIiHWSJbAVlhRxyLXpEatE0Ge5/wW+NHR8hG8pvc79ylCEnw1hTt1ADqc+r6UvSyCDEHIxwWodNcCoIa1rn8ok1O8EmuqySioDdFsyRsrgyCcAK0HstsZvAht3qr+RxXuovgUaNvQ3DDXl0xa8I3Vkbha39E99EFO2VbjIOKLQTaNRgjBAkyxnZzBakNrz37mUvV9cHw7hhSFUzfDsOdUNnED2lUmlY2s3ySbA12uPP3IDpPajdlsU/wF+J1rv/BZ2SggUFttqMUtLOlHJZ4G5IUSpV6dZrmVt5UwvOEsUTQE724onTMqYEOdXbciWrg0w3msHAbEK2yVhvPksGZRGSdnXwMzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(6512007)(316002)(38100700002)(66556008)(8676002)(6916009)(83380400001)(52116002)(508600001)(86362001)(1076003)(36756003)(6666004)(6506007)(44832011)(6486002)(186003)(8936002)(5660300002)(15650500001)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTBxRUx5bG5kWkY0TVlpbzd3SUZrWTdIMDJSaVc0QTFOd2xaWldHWXI4Yld2?=
 =?utf-8?B?dzBqSEJGWkhjRlRucjFKK2dKMGh5ZzJ2YW1INndXTy82NWl0STJSZjJBZnZx?=
 =?utf-8?B?TmdjWjU2THE1aTExV29YL3p0NmtmR0hHUDQ5VWtPYnQ0OVVkdmx1Y09FcHdG?=
 =?utf-8?B?VkFWaDQwV0ZWM3dUbVJ6ZFdqVm5PWTNEZUtMOGdDallCb0N4SUpTMmVOS0Zo?=
 =?utf-8?B?bXd2UE40R2F1c0hGZGZRbHltQmNzTWhYRitwdGJudzJQUUoxMWpHSVJhU2ZW?=
 =?utf-8?B?bElZVjh4c2xZVjNnbTI2ZXlvWU44WW1iWjVraXhtUytHT3J6dUpqK1laaE82?=
 =?utf-8?B?UFdHN0tnQlFaeVdHa01zRXpMRXcrcVpVdGxzdW1jdE5LdzR2UnlPRzc3T0VZ?=
 =?utf-8?B?MG9zR3hSS2YwbllBN0I4UkNXZ3dHLys4RTlVa0VpdUk3NmhaakxWK24rSnc1?=
 =?utf-8?B?Y0RPSUgra0c4VXk3ekxlalBqdHlJZ0pRRDVSY2FFeDF3VTFNVFRqUlBCUjU5?=
 =?utf-8?B?NUIxUnc2MEN3TU9MM1ZJdkNyZFNhaTdoRklGbDVMUlF3NmhKMUErdlhiTWdC?=
 =?utf-8?B?SzBRcDZ6cXVlM0l1ejlyTk1RRWdzVHUrZUw2eDNLalhBdUgrdmUzcjM1VVBL?=
 =?utf-8?B?cmlSRDdJMjB4eHFhSTNDV1Z2bXdhY0cwd0JhUm11MFQrK0h0VjJxRDViQXcr?=
 =?utf-8?B?NFdsT3hXT0pkejE5NTFmQVV5dzJVanpKMXg4cS92bUtTdEVrNG9oVE5sVXow?=
 =?utf-8?B?b1czOUEyQ3o5RjRiaU9rc3FrOHplWUdERXpUR29PZ1NPa1ArNCtDMWIrWHpk?=
 =?utf-8?B?bE9OWC9tM212NDhWejNQaGpQcXhmOWFkNFpnRytDMGh2Kzd4b1VPeHlKWGtC?=
 =?utf-8?B?aDltb0p6RzVIUDBUa1ZJdGZMdXZRejRBekRPbFZ0Y1JBa0kxZms4S0pXZXdl?=
 =?utf-8?B?eHFYeG1VNTlXdWRlTDRPd2V6M1c5a0cweWJTLzU5SWFJeUdUSWN6alQwQjZq?=
 =?utf-8?B?QXA3WDFzS0FNanY2eU9lM3I1MnJyMmlFQ3A0ZXRETWI2TzFQOVBabjRwRkVE?=
 =?utf-8?B?bHlSWTdXSlJReC9MeEpzM1ZFVFA2Y256Uk5CelZaVVUzNGNMajBiQU4xejJp?=
 =?utf-8?B?KzVGMHk0cHZwREJmTjhmWTZpbVFhbVV6YTFySmRLbS9oOGRtTXF6d0lTRGFS?=
 =?utf-8?B?YzAwS0llNjlVS3A0Z2NZT3ViNzRtS0lxTWhRV2NIZ2ZCOWV1WXFSUDVhdjlV?=
 =?utf-8?B?YjJ6M3QvMFYxcjJYV0V1a3pSdGlyYXpvcFRmaFNvU1RsbHJrREVVWTVMQ1hF?=
 =?utf-8?B?RnlWbU1OOEFIUHNKMVVpOXNLTUlsRUhzbi9tQzNBaWZKSG5qNVVXNnJuWjJE?=
 =?utf-8?B?N095Q0hOZEpMajRSOUtFMVQvWE1IOFBYOEpUcWRVK3JVQjRZUENtSVBIV3RX?=
 =?utf-8?B?dVpjVEJ4SkNMSFBLTjNiSWxQM0pZOXIyYVNZZURWWGR4eWREVHFlcTZ1TFBa?=
 =?utf-8?B?ajIzSXh6TUI0eXMxL1FlajNpQzN2ZWxpQXluT0ZYS0grMkJGM2VoQWh5Y0xP?=
 =?utf-8?B?MTJhcmZCREl5bWZXNko4S0poMFFCa1UrckxOMWFGUlhqTVZERzF0MUNKVnVn?=
 =?utf-8?B?cnl1Q25UWisvN0x4TDUxcjBmTFVUZ241QzVHdXdqQkdHdkxmbFFNV05nNVdw?=
 =?utf-8?B?Y0haT2cyaUVKS21rVWFJS3JINldmdklkckMzNnl0YlE4T1lPUXN1Z21zWWdU?=
 =?utf-8?B?bzh3SUJUa0dxTm1vekd0UWRHSEN3MVZCRXVkR2tIZ3lVOFFoczBoTUJYMXcx?=
 =?utf-8?B?TG1Pa3QwME1GT094YXd6TnNOaW9PaTM3SzkyOGR0NVQrVUtDWHhNR3FwTVBx?=
 =?utf-8?B?Sng5d0RVTFpQT2lvOE9mRjdiRmZ1eC9IZnBydnJxdC8wcWxZdkV2NjNONnFR?=
 =?utf-8?B?WWpKQmlYVzg3TTM3YkNFUUxQOVMvNStBZXdoZlh2NGxMdUhVdHNzU0RWOG1v?=
 =?utf-8?B?YTlpSmNzd0dFUlpzZldsemc0azJlVXlmeUd3SUo3M2JtNmNRdTRCN2FsZ1Uz?=
 =?utf-8?B?VWJERWYzT01rVXJmaS9yRUsyajIwZC9rS2liTGRtcFJkTjV2ay84aUE5Rngv?=
 =?utf-8?B?MGtneDhZMlRPU2t3anloa3VHT2hCQ1Q3WWsyaXplaUR0K1ZpUjMrNWplUjBu?=
 =?utf-8?B?WVVsNDFoTWNFU2lhZThQcW5WZlcrbWxZMktUWGcxOGlyeXdGVkZZQjlDVVBO?=
 =?utf-8?B?Nm53N2dtQjZoQmo1MmZNbWVtaG9TanJGYnJ2Qy9rczlrK0E4ejJGMi9qeDgz?=
 =?utf-8?B?TFV5VzhCVzU3U1BxWWVvcUcyQmpFb3FtRzJnYjRDcG5CK0hGMzVSRkt5REUz?=
 =?utf-8?Q?oYEcQj2zN+vZANgigKXrlzFSJM//WW71ZiuK8CabwbwWY?=
X-MS-Exchange-AntiSpam-MessageData-1: 07Jc11nYmfVUv1aIlat6BCRiJvb0rMbv/6s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72c3203-6f2a-40be-4fcd-08da23b82598
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 16:58:23.9914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: namlwTcnxiKN7olaBrZd/HWlYMN/HvZQgwF7YXhz+VkW7pcAX5sh5CCnDikscFL3qLj89vOYfyN1exugGxhBcERCcx4K0Eu/GPpILSY/H/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2537
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_03:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210089
X-Proofpoint-GUID: b5UmtZaXR5JmsGu1Zqzr2uVH6bwmM-LW
X-Proofpoint-ORIG-GUID: b5UmtZaXR5JmsGu1Zqzr2uVH6bwmM-LW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Warning limits in xfs quota is an unused feature that is currently
documented as unimplemented, and it is unclear what the intended behavior
of these limits are. Remove the ‘warn’ field from struct xfs_quota_limits
and any other related code.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_qm.c          |  9 ---------
 fs/xfs/xfs_qm.h          |  5 -----
 fs/xfs/xfs_qm_syscalls.c | 17 +++--------------
 fs/xfs/xfs_quotaops.c    |  3 ---
 fs/xfs/xfs_trans_dquot.c |  3 +--
 5 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f165d1a3de1d..8fc813cb6011 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -582,9 +582,6 @@ xfs_qm_init_timelimits(
 	defq->blk.time = XFS_QM_BTIMELIMIT;
 	defq->ino.time = XFS_QM_ITIMELIMIT;
 	defq->rtb.time = XFS_QM_RTBTIMELIMIT;
-	defq->blk.warn = XFS_QM_BWARNLIMIT;
-	defq->ino.warn = XFS_QM_IWARNLIMIT;
-	defq->rtb.warn = XFS_QM_RTBWARNLIMIT;
 
 	/*
 	 * We try to get the limits from the superuser's limits fields.
@@ -608,12 +605,6 @@ xfs_qm_init_timelimits(
 		defq->ino.time = dqp->q_ino.timer;
 	if (dqp->q_rtb.timer)
 		defq->rtb.time = dqp->q_rtb.timer;
-	if (dqp->q_blk.warnings)
-		defq->blk.warn = dqp->q_blk.warnings;
-	if (dqp->q_ino.warnings)
-		defq->ino.warn = dqp->q_ino.warnings;
-	if (dqp->q_rtb.warnings)
-		defq->rtb.warn = dqp->q_rtb.warnings;
 
 	xfs_qm_dqdestroy(dqp);
 }
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 5bb12717ea28..9683f0457d19 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -34,7 +34,6 @@ struct xfs_quota_limits {
 	xfs_qcnt_t		hard;	/* default hard limit */
 	xfs_qcnt_t		soft;	/* default soft limit */
 	time64_t		time;	/* limit for timers */
-	xfs_qwarncnt_t		warn;	/* limit for warnings */
 };
 
 /* Defaults for each quota type: time limits, warn limits, usage limits */
@@ -134,10 +133,6 @@ struct xfs_dquot_acct {
 #define XFS_QM_RTBTIMELIMIT	(7 * 24*60*60)          /* 1 week */
 #define XFS_QM_ITIMELIMIT	(7 * 24*60*60)          /* 1 week */
 
-#define XFS_QM_BWARNLIMIT	5
-#define XFS_QM_IWARNLIMIT	5
-#define XFS_QM_RTBWARNLIMIT	5
-
 extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
 
 /* quota ops */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7d5a31827681..e7f3ac60ebd9 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -250,17 +250,6 @@ xfs_setqlim_limits(
 	return true;
 }
 
-static inline void
-xfs_setqlim_warns(
-	struct xfs_dquot_res	*res,
-	struct xfs_quota_limits	*qlim,
-	int			warns)
-{
-	res->warnings = warns;
-	if (qlim)
-		qlim->warn = warns;
-}
-
 static inline void
 xfs_setqlim_timer(
 	struct xfs_mount	*mp,
@@ -355,7 +344,7 @@ xfs_qm_scall_setqlim(
 	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
 		xfs_dquot_set_prealloc_limits(dqp);
 	if (newlim->d_fieldmask & QC_SPC_WARNS)
-		xfs_setqlim_warns(res, qlim, newlim->d_spc_warns);
+		res->warnings = newlim->d_spc_warns;
 	if (newlim->d_fieldmask & QC_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
 
@@ -371,7 +360,7 @@ xfs_qm_scall_setqlim(
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
 	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-		xfs_setqlim_warns(res, qlim, newlim->d_rt_spc_warns);
+		res->warnings = newlim->d_rt_spc_warns;
 	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_rt_spc_timer);
 
@@ -387,7 +376,7 @@ xfs_qm_scall_setqlim(
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
 	if (newlim->d_fieldmask & QC_INO_WARNS)
-		xfs_setqlim_warns(res, qlim, newlim->d_ino_warns);
+		res->warnings = newlim->d_ino_warns;
 	if (newlim->d_fieldmask & QC_INO_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
 
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 07989bd67728..8b80cc43a6d1 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -40,9 +40,6 @@ xfs_qm_fill_state(
 	tstate->spc_timelimit = (u32)defq->blk.time;
 	tstate->ino_timelimit = (u32)defq->ino.time;
 	tstate->rt_spc_timelimit = (u32)defq->rtb.time;
-	tstate->spc_warnlimit = defq->blk.warn;
-	tstate->ino_warnlimit = defq->ino.warn;
-	tstate->rt_spc_warnlimit = defq->rtb.warn;
 	if (tempqip)
 		xfs_irele(ip);
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 9ba7e6b9bed3..7b8c24ede1fd 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -597,8 +597,7 @@ xfs_dqresv_check(
 	if (softlimit && total_count > softlimit) {
 		time64_t	now = ktime_get_real_seconds();
 
-		if ((res->timer != 0 && now > res->timer) ||
-		    (res->warnings != 0 && res->warnings >= qlim->warn)) {
+		if (res->timer != 0 && now > res->timer) {
 			*fatal = true;
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
-- 
2.27.0

