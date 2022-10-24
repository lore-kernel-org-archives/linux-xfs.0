Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD4AC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiJXExd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJXExb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:53:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5639E3A4B1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:53:30 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2eWiM025813;
        Mon, 24 Oct 2022 04:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=q77NBc9k0e81lewq7wqOIHBylbTVdA8xp3ZPdm8Wyv4=;
 b=eMbb/24GS74RIkekxHPXtna2cz8lRfP/kaD/SqusuVpeCdhi5cMUIiDz1UnJYXl+a5ZO
 sn7z4iG6m9/GanWp+gc9c8BOpLoCErdRsE01ASAymNlwkP9zFB3sTsvy4XPaLvqXVvXz
 dBTNfOkkjHiXpAS6nQQdcj6SpmHQxylQMDBHAvrROJ1H++WGFrPryvNFxsfS+1XFERU1
 04AdveY/0t0rV4kd9WPO/TF2DNyo4Ahh4Yn9hJpdasUbygBHel4XCkSEwMfV8TsfxBFi
 tOXb6mRD3ZUKTQNp1nrpTkkHjhFy/Xe98SCAt7H5GMdeoiQrgETA/AXAfXvlGbmaU3rw Gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xdtn3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O45qdb030665;
        Mon, 24 Oct 2022 04:53:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3bmha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:53:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpNIL98l1pwNPOn2ZGVDW1hxwvbNAs8ZKukycK89PKrvxhlQaLya+JvpdzsqDJyYuylHF0gsu6rv2jYWdIFo8liFx2vvP6JhilHIm6nGZ6SV8E8kbeLXsYvHx51M5zuqeQcchCF/M1X4Lg6ySAGOZxVXEta06ei66gY4J71sxAIuhaYVgvq6f5o00P3SurS/SYWs2jhNtU08j9AjX6/oQyLmVAiWRHeWytBEmbXInKPnUFPG6Ci4r+mmpvh17/MtjZmQGQElYUIMskH3ua+qYmkJWqtgHXEeD1NDDvMfk4u+D/bdOYcTOKHZ3BuTGcAGGyUKJBJD95emt+2QRPyLCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q77NBc9k0e81lewq7wqOIHBylbTVdA8xp3ZPdm8Wyv4=;
 b=kgyYq5BH7cQa/EqOGzqT+Diyhnt0+hbyL83HoX8ocr8OBd5Z+Lw7Klkb6geYrvLo7FaLIEWm3X+y8aVP4Dr4O6BTGjeAmVbiWCHRgq9sd8+UJ2Do9HmZLzVO5gNV0LbYeU0c9nygXXE4g6MNm1IyLFDKL9+wESM1q1XAlxatZ13kwx3/drKsVhVaty506GqZAboirxt4iwaMMJcmSBiep9hJt0JJjKmm61jyQ5bDDamGZPosM8JQm9/6YXcGME532NYPp1IQdHJ0tdSHXiANdB3pAKx96t41HU2XMhOIylkX7ZQztNeXcDvAzaesdMO/ES0WseFRVjRu4S2X4SA9Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q77NBc9k0e81lewq7wqOIHBylbTVdA8xp3ZPdm8Wyv4=;
 b=jixF6C9up4twiMP3PnSvkiiw44a8YIPGsa2cQhYKN32bLGvEXiCCCsw/pqamIWN3yKB6I1Fti4ACsxYWlM7fyxeGnZzlnpNB8y6MukkoQy+vxOMoQMp7VjoHCS7R/MKp8hwcsFdYD22JZMtXCQAS+gofFICnJMguJ+yWsAQ3AQM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:53:21 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:53:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 00/26] xfs stable candidate patches for 5.4.y (from v5.7)
Date:   Mon, 24 Oct 2022 10:22:48 +0530
Message-Id: <20221024045314.110453-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0041.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29d::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: fec9c249-714d-4ac9-6490-08dab57bacc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NNbfFAD791484hIg8wURrYEfmWdxCSZuYsLsOcNlSkg6uZLje7nTXcZwvI7f88T7o6TIjzLrfyiJP5DIKusXhCq2iMI7iyMfpWen87AVgogq7dGV8hLISzsjpcRVJI5MYJG5gwohGD/5amGienaslsfdj5o3k3w1yNH5v6EGt2PCO3TL14QUH/k3joFlqfKZ5lpoRtkfyL1JYljGfinaBSoW/NQV3X7gXJYZS6BjNPhi/ARF37b5GZzZJCSkcGH6up3CR9Btkd808aWHXb1cmoRU0JS/Ud/g/Ib3FfNHMT1lUP4GXwlwO74Yj6NWOf9cEUYs3soGVHvJPylACWoHVEfCJZhZV/FP/eTgfK7srRBIdr/QAluRz1CuIPAPAMyC2/FlUNxvkRP85csE5sZ1VJbYOL8KOrdWmP4RNzbne/cXjH057QyGUR9YzCR/9ypTr2uaRQEbqWC09+G4lKYJBPTFjKkTq4EW0TxcSXAI1JCn7nKqzwFMye2AERkUug1/b1EeT+uCGxHK4LXWRekVHfVmazESzaNo/0ofHybunXBNyPTsgjq3QVTXoMy2DyICbnUJTrlIIr/WzDUHt4iQcvO7A57YNRQ3lgbko7NMtBdswpWT85LwhyrXdkbGx4wUk5jgQwdDdQBHz8D7KRYkh12328E21gdKgT1QbdUCGZPFasa5pGfUMt9B+3RD+ePho8l3emRLJgKgXNJXTO+eTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(66899015)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YzHmXmBg2veyl1XKFlzaoFtJHLkO1grsjitiTZMFrUTFpDd0IVT+q7ByD8Gn?=
 =?us-ascii?Q?i9aWyEMYhRTW/4HVSs2dXbMqPF5YPX8hSOImcG0J1Fwz5wwZTPu8GZ2LW78R?=
 =?us-ascii?Q?O8jjq0vsNBUGhPQ4A82P7P2mYm2gt6HZuM3enlcjnYgOuAYTz0FJkZ4CKvj+?=
 =?us-ascii?Q?B65s5SU5KdcrAQ0F57Nls00jMWtUTRRkgS30NZ6j7eWiQLIIl+OX0bAh4dtb?=
 =?us-ascii?Q?i5TqlizhTahULGPjOFC/CqpPK1sRoPLQs7f6snD86sjruUNcGF2qR93tG3Kh?=
 =?us-ascii?Q?KB2H9l9DHgs1K0N9HMH4dXEwuTlqeDHS+OF1X1Ey7cWYHgS2QX2DjKkPWFEz?=
 =?us-ascii?Q?3ikg6x1Dj2+KYA3zXpHjC8uEj+obs50L94F/rYWG9SwFbRj8SnsHJPP/1PGy?=
 =?us-ascii?Q?lo1DRGN0RFqlCegqcp43+7ZkecLRSdTnu/ogHovzKHPhAmcEQWjCQ0WG+m4n?=
 =?us-ascii?Q?lxeKJ2BmlMKRMPlSmtdAvIyb+htGO2zTbk7+oWAtJHWu3/3MsSJ5iYBMTMCx?=
 =?us-ascii?Q?5U16x4NqFCokK8Keb38C6EUxtRP6NJv91KwYFjb4SauQewyqaIUaxnv1wBBy?=
 =?us-ascii?Q?EO39RB0I/L6fBJtvr1tMvhZIOGbn2yb3zMphunhqAYjcKzSGdAgQG0wm5I2t?=
 =?us-ascii?Q?mXtopDc0G2/TZZN5fOt3AhDNMRKXeGdznVdtmNMyqs623Q1jUPhHaTlDgN+u?=
 =?us-ascii?Q?A/3y73kE/Zm2EmKvHQ7qrHYSJZGFDJjNJEopB5/5r9xqrxqCs/qruR7UoViB?=
 =?us-ascii?Q?1Dh+ahzg08ciPoVz6ZVASnex41jvQ+W3JeHO1Uf9ORHwcPqDa9T9mEiJDsRZ?=
 =?us-ascii?Q?WnPyvGUa3qdyDA+ftd3y3wnPEAkF0pwe/Imczh2dgLKDHBM9gXj1qWk4Cq2J?=
 =?us-ascii?Q?/E8WyCTH7QgtMGL0VHvRjdPdeK6Z21ehtLnLzCWqW8FeQD3fHEL2BXe7gRtd?=
 =?us-ascii?Q?1tRIdzGlzZWMHM9FdwPMB2l8OXSmh7SbFol4F2waYsZXBNaFNTNbSmBDwj0e?=
 =?us-ascii?Q?KD4nD2tBQTuwFDNX2+TV3fiapY2PGGrVz/426pGc5mHSCopJ1IzbKOSWj54I?=
 =?us-ascii?Q?Zv8/LZx0PfZbaI+2kH6bk5s5bw6VuC0cSArmtFpHJJc1ifyCn6mVO5vIgQFI?=
 =?us-ascii?Q?dCiSSgaiadb5Mxr3G1XTUJX/uzuPcBghOxg+Lall6YAwC2h1pPpzj6sH72cp?=
 =?us-ascii?Q?2PnCZQeaV2faeSoPlbVOTlWGyx60eEsYD3Bt8CERxZyCzxPIcGdewVj/ZUtl?=
 =?us-ascii?Q?HjWVhsdyi8H1+ljj469ZdmmToJ0eHmfCLM1Ox15hYt7HMUN4ZdGmBnjZXdt4?=
 =?us-ascii?Q?eAXC6hWo5+kn4PVP/nYH+ypBDoHI4Jw02Wz2S7kam7qJD/jAQ9ai7mInDRqy?=
 =?us-ascii?Q?hLb9iE6Qfdov3TsLnjhMLiJRuFHKVsnkzOqiokNjGBUApm4A67JVbKhI82Tn?=
 =?us-ascii?Q?GxnBKoshmE5+kV0u8cJO67QcgqsAlfHt0377trrU/taZdRIQTHsBcYbF4UJD?=
 =?us-ascii?Q?y0wtqatJeoEu/JxShfgSxN4ezlAscVglVD3L/OotU9q4c3/eCOlFPYg17VSc?=
 =?us-ascii?Q?9SNYwnAinLOGV5nX7XxWXTX+yCdgqC4Rqsu+ybw6nWRRcbiuJBa5LkKX9SjK?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec9c249-714d-4ac9-6490-08dab57bacc6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:53:21.2822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySusDOk93d2MLnCR1CHSp5nP2fTseozkj2efXIpPJgt7X352jBmToR4cCq+MK3H1ZD3Sjd40rhmNXxLRkuLw3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: SMxLYCZ3S-MNdDpisbi1UZhxpC-BWiLn
X-Proofpoint-ORIG-GUID: SMxLYCZ3S-MNdDpisbi1UZhxpC-BWiLn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This 5.4.y backport series contains fixes from v5.7 release.

This patchset has been tested by executing fstests (via kdevops) using
the following XFS configurations,

1. No CRC (with 512 and 4k block size).
2. Reflink/Rmapbt (1k and 4k block size).
3. Reflink without Rmapbt.
4. External log device.

The following lists patches which required other dependency patches to
be included,
1. dd87f87d87fa
   xfs: rework insert range into an atomic operation
   - b73df17e4c5b
     xfs: open code insert range extent split helper
2. ce99494c9699
   xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
   - 8d57c21600a5
     xfs: add a function to deal with corrupt buffers post-verifiers
   - e83cf875d67a
     xfs: xfs_buf_corruption_error should take __this_address
3. 8a6271431339
   xfs: fix unmount hang and memory leak on shutdown during quotaoff
   - 854f82b1f603
     xfs: factor out quotaoff intent AIL removal and memory free
   - aefe69a45d84
     xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
   - fd8b81dbbb23
     xfs: remove the xfs_dq_logitem_t typedef
   - d0bdfb106907
     xfs: remove the xfs_qoff_logitem_t typedef
   - 1cc95e6f0d7c
     xfs: Replace function declaration by actual definition
4. 0e7ab7efe774
   xfs: Throttle commits on delayed background CIL push
   - 108a42358a05
     xfs: Lower CIL flush limit for large logs
5. 8eb807bd8399
   xfs: tail updates only need to occur when LSN changes
   (This commit improves performance rather than fix a bug. Please let
   me know if I should drop this patch).
   - 4165994ac9672
     xfs: factor common AIL item deletion code
6. 5833112df7e9
   xfs: reflink should force the log out if mounted with wsync
   - 54fbdd1035e3
     xfs: factor out a new xfs_log_force_inode helper

Brian Foster (6):
  xfs: open code insert range extent split helper
  xfs: rework insert range into an atomic operation
  xfs: rework collapse range into an atomic operation
  xfs: factor out quotaoff intent AIL removal and memory free
  xfs: fix unmount hang and memory leak on shutdown during quotaoff
  xfs: trylock underlying buffer on dquot flush

Christoph Hellwig (2):
  xfs: factor out a new xfs_log_force_inode helper
  xfs: reflink should force the log out if mounted with wsync

Darrick J. Wong (8):
  xfs: add a function to deal with corrupt buffers post-verifiers
  xfs: xfs_buf_corruption_error should take __this_address
  xfs: fix buffer corruption reporting when xfs_dir3_free_header_check
    fails
  xfs: check owner of dir3 data blocks
  xfs: check owner of dir3 blocks
  xfs: preserve default grace interval during quotacheck
  xfs: don't write a corrupt unmount record to force summary counter
    recalc
  xfs: move inode flush to the sync workqueue

Dave Chinner (5):
  xfs: Lower CIL flush limit for large logs
  xfs: Throttle commits on delayed background CIL push
  xfs: factor common AIL item deletion code
  xfs: tail updates only need to occur when LSN changes
  xfs: fix use-after-free on CIL context on shutdown

Pavel Reichl (4):
  xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
  xfs: remove the xfs_dq_logitem_t typedef
  xfs: remove the xfs_qoff_logitem_t typedef
  xfs: Replace function declaration by actual definition

Takashi Iwai (1):
  xfs: Use scnprintf() for avoiding potential buffer overflow

 fs/xfs/libxfs/xfs_alloc.c      |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c  |   6 +-
 fs/xfs/libxfs/xfs_bmap.c       |  32 +-------
 fs/xfs/libxfs/xfs_bmap.h       |   3 +-
 fs/xfs/libxfs/xfs_btree.c      |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c   |  10 +--
 fs/xfs/libxfs/xfs_dir2_block.c |  33 +++++++-
 fs/xfs/libxfs/xfs_dir2_data.c  |  32 +++++++-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dquot_buf.c  |   8 +-
 fs/xfs/libxfs/xfs_format.h     |  10 +--
 fs/xfs/libxfs/xfs_trans_resv.c |   6 +-
 fs/xfs/xfs_attr_inactive.c     |   6 +-
 fs/xfs/xfs_attr_list.c         |   2 +-
 fs/xfs/xfs_bmap_util.c         |  57 +++++++------
 fs/xfs/xfs_buf.c               |  22 +++++
 fs/xfs/xfs_buf.h               |   2 +
 fs/xfs/xfs_dquot.c             |  26 +++---
 fs/xfs/xfs_dquot.h             |  98 ++++++++++++-----------
 fs/xfs/xfs_dquot_item.c        |  47 ++++++++---
 fs/xfs/xfs_dquot_item.h        |  35 ++++----
 fs/xfs/xfs_error.c             |   7 +-
 fs/xfs/xfs_error.h             |   2 +-
 fs/xfs/xfs_export.c            |  14 +---
 fs/xfs/xfs_file.c              |  16 ++--
 fs/xfs/xfs_inode.c             |  23 +++++-
 fs/xfs/xfs_inode.h             |   1 +
 fs/xfs/xfs_inode_item.c        |  28 +++----
 fs/xfs/xfs_log.c               |  26 +++---
 fs/xfs/xfs_log_cil.c           |  39 +++++++--
 fs/xfs/xfs_log_priv.h          |  53 ++++++++++--
 fs/xfs/xfs_log_recover.c       |   5 +-
 fs/xfs/xfs_mount.h             |   5 ++
 fs/xfs/xfs_qm.c                |  64 +++++++++------
 fs/xfs/xfs_qm_bhv.c            |   6 +-
 fs/xfs/xfs_qm_syscalls.c       | 142 ++++++++++++++++-----------------
 fs/xfs/xfs_stats.c             |  10 +--
 fs/xfs/xfs_super.c             |  28 +++++--
 fs/xfs/xfs_trace.h             |   1 +
 fs/xfs/xfs_trans_ail.c         |  88 ++++++++++++--------
 fs/xfs/xfs_trans_dquot.c       |  54 ++++++-------
 fs/xfs/xfs_trans_priv.h        |   6 +-
 43 files changed, 646 insertions(+), 421 deletions(-)

-- 
2.35.1

