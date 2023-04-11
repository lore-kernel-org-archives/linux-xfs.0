Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0B6C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjDKDhr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDKDhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:37:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E3B1726
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:37:44 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJvRd9014257;
        Tue, 11 Apr 2023 03:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Tojna6HgD/8dOt+Yjc1R0xAaY9N92JRnwqmDfM20RBI=;
 b=YwidoBTl06TQg4oXTHqWZrfj8OJH1x2/DWvekKuJuCw6g5rbYt9St65JJzPst7wHUpsu
 5zxteRWrtHyspPQr2JLj1sFAd6r9dyAwhNS9047U+MaBVaxTBC1pdBoGU24xW3S6Kr71
 JY5dhxKCHHwsFKB6cIHVXg59dC1u+Tg83xPXwTJrKB+iT/7M/+oUm76xONuMYTAuDtYz
 FUkhY8EPDTbemW8mlQ/j6ZCjydEU0VGd27jJAqIZyZgyHD9uABZmqCDzUfVRFrzbelfU
 /OoN4j2hVnuCg3WkIjZmTU7DnGwrZytxCMdi6Ap7CZmubdlBuEYJoiOPO5L5fM+dA1vl GQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2v9v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B3ATDp032604;
        Tue, 11 Apr 2023 03:37:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw909bma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXWRaa/MihEj2Rqj1Kv548SZAo/rrlhnLvzDILYpymEbyZXFCOAGQOkmf5jPS/SZzw1ACZsciYg4zp2OI2yRKEm2vAD2vjT2p4zoULXgq3XyRJjX+0iGlxBoQ9VA3RJ8i220yh9GcOAzgGETW0Xh4nG7q1oEa9Tb2mdiRmNZ6r6dtMG0yRqotnh86j7QE+NNp+qrdV1WAu2J8H7XFYg/pEnfSuw4oJQ6vvDIzQ0CynaILsWpEMIsazvaqcwqmfBvqGVmn3u0QuOOMcIlhSo5MzUhTvRd7d8GxXN8ZBSdmwCy9QhD76RUY+2MJh/5Oiv8aehPTedv1bDSDiPRUHu01g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tojna6HgD/8dOt+Yjc1R0xAaY9N92JRnwqmDfM20RBI=;
 b=HlSn2wTvDAVBVRncOgoMSM64V5VkMSMLxTiiVI5bnZmUMRegy8ROpJAnB1kjHVDzeuFCsD6IkqKbEjSHGpIvRLai5qpyvsT8RKnphuf9xm22MU8Hu0hmWppEFUZsWjZ1VpzrynIsec6EdXfxFGGQBHWLFoate3zQGdjb/ZMKsQZSbaWjCPSo7j4qAma/syIYfLSdJkj2WBsVOOzgr8DRabgXDpBqO80ZHN03u+aRELN/EBxBeJ2YBlMDwxVgnSSiL3DTGMEEz/JiF+I1pc4cSx2l2FSUZoAwmArNlXncXERYIe+ivltvwhozXVuQH/8R8BkjUc00eumZf28ROJPkuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tojna6HgD/8dOt+Yjc1R0xAaY9N92JRnwqmDfM20RBI=;
 b=d7luZNCZ5bYxxSHAifVKGLLTRWvfm6Nj6IEKnYRmMuPoRStdiaPdL8xOfAKp1GtdfW/Z0ElAWxYD12cIRyk8EgvMZAXuUCX2KaQECbgvZVUZW6hpzQV1M7jLOYsDQKBQfP8kiT4e1mT1eIYLU9BDYgOQhI1RypOJs+vkh3iy40E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:37:37 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:37:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 17/17] xfs: force log and push AIL to clear pinned inodes when aborting mount
Date:   Tue, 11 Apr 2023 09:05:14 +0530
Message-Id: <20230411033514.58024-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fa96fa3-b599-4ccb-3533-08db3a3e1814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPWY/ojpvCmN/HD+iCLx63ab9gsa6HVXqIDYPhFLMSfSgeRrQ7kdpoav0HX3wHo+b0+/EbyAAqYO/3SAXmDP0LSrOqatQddINdssDUAn7Eikh4Fk3z1TKQl0j+TR3Uh4fT3Lo3rY9xdu8kIxPdnqs7YEpPMFFXFXaVjBnY3RHrqBeXP3muzfuvEzYpf//GowAhQ6actD77S9KLkU9UEoyJI4tvkNElZAh09juP5/hNw0KfzYTUUefdTfmi/6ThplUp3Kw9PjrLQWTwnCRCH7QsZQlt5MaBQEJwv3BN9/jg9rFwT9sMugg97tBZEEfDuCw3EaPqvYcxlyTO1yKNu6TdWxc6MpRi31RFAqFpcd/DAGbvpUStsdIgZr7sYRy6V9OmXS6SGrPDCZJkB4exTVchCeUFPvsTkKerxkS2nq7KdgcrX9iiNQ4mcf9T3IGJ3mL/7w63/y7yTB18gBaURB/uoRTZYaAslsBquF5/k3ciCWPV3ckoxq7/o6JJ40+T5EbBp5ldvywMIkQ2wYgHUOpKwxp+PMm1ktcrsSsjvtrbMTHU5R/O5/a3Yu5eyYUxm7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RQYEa0QaJpJl5PVjJUAywB90Ozj0wMR9fc3Ap8rWbxjT2DkEJ8KalBCAC/RQ?=
 =?us-ascii?Q?dn12PM4ATbpExzefjqqxGuLo1JE5jC7TdPZBuhxRCX3Uhd1Wya+X8J6InF67?=
 =?us-ascii?Q?cqSmdS+ZkymAO6XabZ2ef4eq861+ZVpnJZ+8VVL+6BhUcrBSsIPoLV4yhuUY?=
 =?us-ascii?Q?dmdzhGJmpo2S18stY4QsZ4HBQ16iGoHaUfYDb2R1kd6dfU+0LMirSzZdGpRT?=
 =?us-ascii?Q?TOQVnLeZdiWnQGm/u6wH1LsXZyHGMjHOCzkdrgx8fDvJGPgN3YvY24BS7B/x?=
 =?us-ascii?Q?SlHgkFnQ30HaPmx6imOtmjU6cOMmNhE4vmv6wlPULhhGF5KsbTMMX+BvkaRt?=
 =?us-ascii?Q?AAVSdiITYGJ8HOYrGisz1pmjyQWa7t+l4MzHp3Qy2IJvlBkDeNq2byI+CfUH?=
 =?us-ascii?Q?UxwkNxmwgeEFThlj5E0s+OP/66gTJYN7xrVzZLOyVkiQct6UN5A5cCJ2sonb?=
 =?us-ascii?Q?Pxd2duy1VeleIQis0XMHrvo2ll4QGue/IL//8XIKezo8zaCI5DDf0uzrK59k?=
 =?us-ascii?Q?DUyyl23mSOz4qzAEe4gv6wU5Z+2NvrbDHrDN/DwKUvCMfoFobGPbE7pycVan?=
 =?us-ascii?Q?63/5L8EzCj3/p2CxxuNPF6RrcsHnqbQwnU7209mv/Q10J7HlC6yBAVMUc3DY?=
 =?us-ascii?Q?5JFcywUosivePvyXS0+xGdKhzQjCPmCS7UCSnN7ywoyuSMEL2JWDmz9eHXbq?=
 =?us-ascii?Q?T2ReZkxLQG8aQ6VVIi79U/BcWdmycdKMkle4j6txdYu5RmP0Htc0SdhnDmoz?=
 =?us-ascii?Q?C0LBEm6onxxlsKplVewMuMRX+DqdO72YOm9FwKV9nMOckehgSy2QCAgJrXVQ?=
 =?us-ascii?Q?HPkRhz/S5JzIc7KRon/5u2Mt78UzZrW5L96WQMEelz9/ZgT92iDn/EJy6AIO?=
 =?us-ascii?Q?mxzS1V3iY0eQRkxOLyiN2ggxhFIqsk+Dc8/XQsh72VDP5I+0IY7byq+qPkWT?=
 =?us-ascii?Q?3ONwFWLf4xdVtOqIY1CtfjPatGUGXr8M7+2qYl6eKzImmz8jVD0UZ07xPd2B?=
 =?us-ascii?Q?0TOoxj8Jik63Qyq76WHzNyVBWXB2gfEpPkv/M2fO9hmY7G7LJs67/ZKOtV2I?=
 =?us-ascii?Q?Xw7bStOO9F7Og4bYEZpFT8b1HZNjQvtEuOrQ7aPK1hodXeNnPGulRBx5rnTg?=
 =?us-ascii?Q?kSJRjTu0Ksnorch7wJu/Elqbp/vXeN6viw9cnw//v+iO2zkjDZcuLhjcApDG?=
 =?us-ascii?Q?hj0aG3RohESPwXz89W/dVXBce/T8tzNn+zwoo4wXQfqQNN49xxgol5fwUVNR?=
 =?us-ascii?Q?/xP8dht3WUiARvRzsxxrqDr+BW3INx46ju2XJrwwpG5x3JnD5CyWdG3j+jgL?=
 =?us-ascii?Q?07zkStnxEc2W3/GiFtpOsKHa7hNfLLU2KWZVJ7YBBsRWGEBpT+NVk56ppynR?=
 =?us-ascii?Q?7ChFQx/dn9nlnVVuKbOsqclaqigqgpMfWU6RGSMou2f2/czFkBHyfZVDsjTt?=
 =?us-ascii?Q?UZp2Yc0sAhIZ/VOCVSbZ82EHrtmn7RCVJKt0IqX75u3fWt1YenR+fXpsFLmq?=
 =?us-ascii?Q?4v+JG3S/30Nt2gsiIzmA45aRYVz6YYyWayT+zMZZ8CnzEZc9znaD3HksiTYV?=
 =?us-ascii?Q?KRiFM02V/GJEoWt4PSGeC8y4QuwgwsNriMxLn/4mKxaViA2kywBlovZ6XSl9?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: k1+8U1jAyzgHQuBE+XoM5iZCQkWehbjnYjYS2A2w1yTC2R0TF6ZtmPuuc4EDEit9160lAxuhnnr5LldYzxH0cYw65Zu4sOGnlsempbhJJ/HwTTG4xC5fdfYOJn0v2EwncFKNjZiwZmehuojFvisP1uik8wtAk+6Hv7kcZ4+GRwECxEVyzvqbEWBwE6ixomq9s4FKsLUpTgkuuDNtyx7UvqzzSg8W6wEDTbpBTFAa3niZbOCnOY9KLr3bMhFa1CltdDbyN1LTq2P63cdJGAVxeueE1pGtjmYXesYsCykzoz4T/kSKdGXSEBDCMkcnYILNPGSBr/cCK3jpZnW2pBZ9t/pQzp4YkTmY2TbuPnworFdO/I+Q8hSOthype9BnwX6ERrjlleikZ5BhUnCx4Zp/ts1alI8tVPdOG3MnT759ZbiOKBNAYtwMAYWZzO2HAvX/oJs2l8BNeSteJ/f4Hcl96wY5jl9tGWSjUHpV+0VkTEKEQs9PTxjfT+53JMwdFSqOKbOLUAMxcaw9XS+XdttnbC4KANei55CuKhW66SOCaVyQVsuklTt+k9iLmsLVJHhlvgTf8obJGKiXR83XYADAvz2yYureRo2dn4kXBGYx3tAb6f9++IVDAaN7j3dNimvrP9s1OP0Vxi0ReV5sahfBv3L859voiKRUxlh1SXEbT54r/S01pWY91vs1YDvjGY8UhqjpJyZz7mnusjLePIcUp0qvR/z0Th/B1DX7aRPEMqO+DD5KVBLgSZl22wd3zcttFgQhnGVYHBM4sD+hFQd/OAzazblBestPij6NnjK+cTEWhEz/OpfwPnr6j243GnHM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa96fa3-b599-4ccb-3533-08db3a3e1814
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:37:37.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fIU3tDKLrrB2m7C45zC4twR66f8TxtQD2SHdAsWZjNku2ZoQwCxpscP5PgYh4K+OECDaUzcHC1f8rrgNcm8NKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: dDNXoAy5oqjTOEJ5KFO-4_ydahubaBih
X-Proofpoint-ORIG-GUID: dDNXoAy5oqjTOEJ5KFO-4_ydahubaBih
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit d336f7ebc65007f5831e2297e6f3383ae8dbf8ed upstream.

[ Slightly modify fs/xfs/xfs_mount.c to resolve merge conflicts ]

If we allocate quota inodes in the process of mounting a filesystem but
then decide to abort the mount, it's possible that the quota inodes are
sitting around pinned by the log.  Now that inode reclaim relies on the
AIL to flush inodes, we have to force the log and push the AIL in
between releasing the quota inodes and kicking off reclaim to tear down
all the incore inodes.  Do this by extracting the bits we need from the
unmount path and reusing them.  As an added bonus, failed writes during
a failed mount will not retry forever now.

This was originally found during a fuzz test of metadata directories
(xfs/1546), but the actual symptom was that reclaim hung up on the quota
inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_mount.c | 90 +++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2860966af6c2..2277f21c4f14 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -674,6 +674,47 @@ xfs_check_summary_counts(
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
 }
 
+/*
+ * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
+ * internal inode structures can be sitting in the CIL and AIL at this point,
+ * so we need to unpin them, write them back and/or reclaim them before unmount
+ * can proceed.
+ *
+ * An inode cluster that has been freed can have its buffer still pinned in
+ * memory because the transaction is still sitting in a iclog. The stale inodes
+ * on that buffer will be pinned to the buffer until the transaction hits the
+ * disk and the callbacks run. Pushing the AIL will skip the stale inodes and
+ * may never see the pinned buffer, so nothing will push out the iclog and
+ * unpin the buffer.
+ *
+ * Hence we need to force the log to unpin everything first. However, log
+ * forces don't wait for the discards they issue to complete, so we have to
+ * explicitly wait for them to complete here as well.
+ *
+ * Then we can tell the world we are unmounting so that error handling knows
+ * that the filesystem is going away and we should error out anything that we
+ * have been retrying in the background.  This will prevent never-ending
+ * retries in AIL pushing from hanging the unmount.
+ *
+ * Finally, we can push the AIL to clean all the remaining dirty objects, then
+ * reclaim the remaining inodes that are still in memory at this point in time.
+ */
+static void
+xfs_unmount_flush_inodes(
+	struct xfs_mount	*mp)
+{
+	xfs_log_force(mp, XFS_LOG_SYNC);
+	xfs_extent_busy_wait_all(mp);
+	flush_workqueue(xfs_discard_wq);
+
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+
+	xfs_ail_push_all_sync(mp->m_ail);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
+	xfs_health_unmount(mp);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -1047,7 +1088,7 @@ xfs_mountfs(
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
-	 * Cancel all delayed reclaim work and reclaim the inodes directly.
+	 * Flush all inode reclamation work and flush the log.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
 	 * two will have scheduled delayed reclaim for the rt/quota inodes.
 	 *
@@ -1057,11 +1098,8 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1102,47 +1140,7 @@ xfs_unmountfs(
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 
-	/*
-	 * We can potentially deadlock here if we have an inode cluster
-	 * that has been freed has its buffer still pinned in memory because
-	 * the transaction is still sitting in a iclog. The stale inodes
-	 * on that buffer will have their flush locks held until the
-	 * transaction hits the disk and the callbacks run. the inode
-	 * flush takes the flush lock unconditionally and with nothing to
-	 * push out the iclog we will never get that unlocked. hence we
-	 * need to force the log first.
-	 */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/*
-	 * Wait for all busy extents to be freed, including completion of
-	 * any discard operation.
-	 */
-	xfs_extent_busy_wait_all(mp);
-	flush_workqueue(xfs_discard_wq);
-
-	/*
-	 * We now need to tell the world we are unmounting. This will allow
-	 * us to detect that the filesystem is going away and we should error
-	 * out anything that we have been retrying in the background. This will
-	 * prevent neverending retries in AIL pushing from hanging the unmount.
-	 */
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
-
-	/*
-	 * Flush all pending changes from the AIL.
-	 */
-	xfs_ail_push_all_sync(mp->m_ail);
-
-	/*
-	 * And reclaim all inodes.  At this point there should be no dirty
-	 * inodes and none should be pinned or locked, but use synchronous
-	 * reclaim just to be sure. We can stop background inode reclaim
-	 * here as well if it is still running.
-	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
 
 	xfs_qm_unmount(mp);
 
-- 
2.39.1

