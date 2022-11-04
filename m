Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51451C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 05:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiKDFSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 01:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKDFSa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 01:18:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B621F9C1
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 22:18:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A44NiJr001421;
        Fri, 4 Nov 2022 05:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=HpUdG6+zf/TkGaEXOQqteAg07sjvy0jTCz/yH5kSgYg=;
 b=fMI6H20rc1MD0G8x71jbos7f2pVBX2fvSeRAJOkqm8tnt2ciUZSeZhbQpCUSOT9rjVeE
 1bGiYwQY4qVn0X7tMOdSLMcbuBoUcS8EgmTGVYb88T0fvXib+dM89ZMkWZ0VWp9SNiXj
 m7vk2jmXIZP2A3mGCXhfWdLzraw2WxdSrjLYk7BoLSUmhKhMKR0JrApd7OIZQMeInCg3
 fSDEQzhhKr3Ex0VvseKrjma56THKIMwUt2QKc/3rFW3hBrz3JY8iuA9ivsAKXtqW9k6Y
 fRYbNdYra+BlsNj8SC+GJUcmN2KOPORaRSQ54oEa/aXkYzFAO/Mnyz9xDgSCiANB1Y+x XQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgussxt2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 05:18:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A44wSFR031941;
        Fri, 4 Nov 2022 05:18:16 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmqb5wrpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 05:18:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FW0wH+AphqsgqlK8SGnE3y+Od7PN6CFM4VWfAvVT5sI6rzHo+ob/WwZg1O8tP0jUFBhyrGdvhSieSuOnIYlmZixVCv+sAVu4CwAJIMv6slLziBBtBGKYHRnycFPt7s/VxLbVtu1ku2WHs04U4jA2HZDzGF+IdI2K9jhcXDNUV9MKR4+K0kz2BLDW+pjwzSBkI0MR/wyecb4+3S2shc7BqiExMrnuo7BllFD9gNQ4HZ8XKhFnmZH+/Q58fnZUtIFvtM5FTewQkEWnIqpBUzQ+lgbOakLjcW3wF/L+yui6mlvfn/CWJ0Xlj29DmqVz23Zi7dq63L+TkeL8J75a+9Z5CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpUdG6+zf/TkGaEXOQqteAg07sjvy0jTCz/yH5kSgYg=;
 b=jyRDQkWZ9x9P32L8rasfrXPhnsVXj8TdFyL4umSfJ6s3bIkf2DTnTTbcMU0mSIlyLraqyFivo62PVGJ2bwWJn5JfRWNQkzlLLpvp0VFPUreZZ9O2iQLTcaFJiGkMEWCtwB5VDtySa3guD2B8qpb8QR8+gGXF5q02BpB2scjuyvEHJJ0RWg8ZkhNb3NDukGRJ9goAtCwAKFlwwITFrnC6zQbLY9hHi/kNyxQyEx1hgPjXt0OWHRGM8MtCg5TydOX7KPCu9fdH9NCVGr3vCPB2wX2CSkrcOpXE0AOwrFUs0ntuE53hHu2LEi9VepsFvEsEYsMYNWF5+Bv8KTBP/iTYGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpUdG6+zf/TkGaEXOQqteAg07sjvy0jTCz/yH5kSgYg=;
 b=dB9K13xwzdklO9ZHYqDhzhad7SEUhWnz6mcs4216zlRuokRnLrgquT3W3Dnn7Cvw+uCgvZZEBrLPz2qD8QVeOrf+WWsLmzhz7nbr5wczC0RWwfR1yT/e1hb2mMEnEWdLgf36JFLO1MXhGwNshLlkXMSxJvRr83Nv4WSHfz3AdGw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4224.namprd10.prod.outlook.com (2603:10b6:208:1d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Fri, 4 Nov
 2022 05:18:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 05:18:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2] xfs: use ordered buffers to initialize dquot buffers during quotacheck
Date:   Fri,  4 Nov 2022 10:48:08 +0530
Message-Id: <20221104051808.153618-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221103115401.1810907-1-chandan.babu@oracle.com>
References: <20221103115401.1810907-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::32)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4224:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e6936ec-c704-4d2f-91fb-08dabe23f985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IhVVsWCPMmexLr/W7c7dJ+rDOUzFEHQrN/tXV/nlSE6S3irmK05/TGyZPHdYu4L92eyvXTrKILIomG0SJUC6fzqeOeTQrjByvl6pjUZyFW/JH8o0y5QhTTAz8labuTszP3N5WXKcz0LptXYzkrLIpcO9397HDfdGEqwQnpLV6/s4Eeyby7C+XycyfxbTiMudochwfcql/itwdkPjt0icZf+TTbMXlljcIggCQ7yHBzwaAyXWGPjC/nWLE32a1SVt4g1ybr9RBhaJEBTpnw/vxz92bKFjFF3PrWxUODaKXLjBgW5b8SjtHjXePaRquyEBjKC7NZoINqojQp2KHWIVXD+WoE6tvk6HqWqG5nwCqaon6sxA81VRPhEidfntOKfPk0qx6YJilo54ucV2T9JzXoskqwe2kKk4B+EEgw1HxBNczgoK6ui9Kbg5Idgl16SzR9tJMhNhDAg3UEiWgRy3CVeNaLTYyEuPeO2kZMWIcxJvEqQoVHouliEailF9QrEf0fAXyC8CyHsfG6vTqcWcl0qBlPEMcQLSz4JE2tVON0hrXNrAWXSn1U1NYF8q6snK23NnE6jJc195wuC5EGW0Zubav3c7UsQyONa5kLVYu4PpkJbhQ/euPwL7y4nL3rdfSTyCBvSWuWN4JA9REqkD4CAkyICyyPHidm5eKkQDLRyq5O6DQNwFoP+qN6wRcde7bA+/UwAh9ShX/kauSLXU0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(6486002)(66556008)(66476007)(86362001)(6916009)(316002)(478600001)(8676002)(4326008)(66946007)(6506007)(2906002)(38100700002)(41300700001)(6666004)(26005)(6512007)(2616005)(15650500001)(186003)(83380400001)(36756003)(8936002)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nlZFlqG29MRGuS0bzOgA0e4NoKbkrKNFlLLLt0R4q4nKMlvRlqPjOoGjQ1Sc?=
 =?us-ascii?Q?c37zZBHIK7UvM6Wrey2lurwPvR3+nEn64IIRFJa2A9Qo8fEy9gwFAw7Ak1Vt?=
 =?us-ascii?Q?sxtNm7Y9P8TCCofcqC4cWxlvE++EWksD+k7aUEyXcBYULUUGCzakL8LC4pUD?=
 =?us-ascii?Q?atXrDreCZyEzRczjV/wdde++MvnCU+T87GdVAVv2/PRI5jHXTUp/LSlyN0IJ?=
 =?us-ascii?Q?39m8Ed576BavRjzkE8LazBgIIVJJ6Gps2hPtc7glGCi6H83ypNKOEEsJruox?=
 =?us-ascii?Q?KmhAQS4IzKVW120cvRfHev15XAa25cxbupkyvi0EY8IXqHXU65joP9LjAn1t?=
 =?us-ascii?Q?+HLimSKEaqtIl4NAs2R7JRd404A6pALlfWalEHVyL3GU0cW/L0XurUCe/8ZK?=
 =?us-ascii?Q?DyWJ2o96P30c65YeSDkVvlkMzSbz7yfMaTPdi67Gx4bVenaEJ2y3KrB7YAXI?=
 =?us-ascii?Q?40NbBi/JfFw3kvY6bR6AzyaIkgA+5uXaaKGMf9+YlcgUZ8aP0Ry1NmaFoVR/?=
 =?us-ascii?Q?6ZyxHlHftXpsAx5C6Ga+Mqk+5qyFPll0vX2WvXH92t57GEymE6d4AEtv0Aqq?=
 =?us-ascii?Q?4AZ9WraXviVNja22PS/EVp9MkFdnhoxvOQuv/ZWgQk2nvJinn4w8En2W5/cP?=
 =?us-ascii?Q?N3pSZM5hpiEOhHUqqoXMLTWrLOi7Udf638SoVpy9d1VcIFcRjmnD5OSHCaUT?=
 =?us-ascii?Q?2F+M7QAoWf0BIdYj7+vRoelxmR83I1yOhOOCeuh0z7bi4cYJm0GJ2CMuVzpd?=
 =?us-ascii?Q?B4yMGLXxZ3nZ/yF18bF+AiYMlVJi2q9z7tfA7q3uYnK+ghlw88j/okbFcTce?=
 =?us-ascii?Q?kBcO/sYhzUSXzypxkUC+A25J8plpiuTf0MYBrN5acQZE44wGj3QSHgP4f6S+?=
 =?us-ascii?Q?Nhv9pXi7cbLYfzUA+jAv/RpHKTI1itHP3wI2i9jRbWIRUgJqpTCnVEgpcD/s?=
 =?us-ascii?Q?oqWvxIMvp1D/MZzW3cSUEdM/bYVjb+lpeFFZzSPI2wkOBMMm0uawfwKgiS7X?=
 =?us-ascii?Q?CSvBfuF8cWjn3wEddV44IfQRxy2mRRuhkh5CtNGKRTxnARvFaXP48AVxZeqh?=
 =?us-ascii?Q?9vHRCwFCJEUVdjZyt07EEXr6NSLyZLFc+HS4KN/nScyqPDDIXLQL58vBNyKj?=
 =?us-ascii?Q?fIOzKMS/1zxwDGzkAwoImgfK+W6CrIKP/rdlLFVLGmUOITLG6sEw2i1Wo6vI?=
 =?us-ascii?Q?dHsTF0Zt2Y1MBsac2vG7zIjrDZr+Zad/uf69WudX5dtjTtSGYhkde9BKYmvL?=
 =?us-ascii?Q?3SzV5jWAV9ZIt2O+rqPVIFHsvCh9uWBZ+bscyO+Sa1to8mkWMM2QiuGUD5Iy?=
 =?us-ascii?Q?f7cRZMZJjvqx+XEcMLhPOO2bDYgqfQixRjx9XPkHcu2AWu7CeZQSFC/VTIB9?=
 =?us-ascii?Q?dw3bbenWxCntpra6h08sPX242NTIm07LpLUGL7CzY6QffSyf97B2xZvMT3I6?=
 =?us-ascii?Q?kG3+oW4P7jvftMhER5ar+DmBt+FqXPNl5jqIVsL0gfQuc4ePvJPYVHI2LRTu?=
 =?us-ascii?Q?PsuLy0is/buv5o73uAzTfmnqzjjV58JVisG12JoumJ/WH7u9DLUF1BLo3fL1?=
 =?us-ascii?Q?Ti8gwD5Cd+NIVpy18a5jMQKJUSBPCKAojau9R/IMETk6hz14ssV8yUlJWiGO?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6936ec-c704-4d2f-91fb-08dabe23f985
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 05:18:14.8258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZNgdGlP8/V7jZAd6ngsZ9yMaHzHyrLn/kzEbncf2zMWaasqtEuID2EA70JqXTdguO94gXqRnK5oZGxwS7hoiOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4224
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040036
X-Proofpoint-ORIG-GUID: Zj2XzfAK4i3SSIQ1TH2hslyT9D869ims
X-Proofpoint-GUID: Zj2XzfAK4i3SSIQ1TH2hslyT9D869ims
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 78bba5c812cc651cee51b64b786be926ab7fe2a9 upstream.

While QAing the new xfs_repair quotacheck code, I uncovered a quota
corruption bug resulting from a bad interaction between dquot buffer
initialization and quotacheck.  The bug can be reproduced with the
following sequence:

# mkfs.xfs -f /dev/sdf
# mount /dev/sdf /opt -o usrquota
# su nobody -s /bin/bash -c 'touch /opt/barf'
# sync
# xfs_quota -x -c 'report -ahi' /opt
User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            3      0      0  00 [------]
nobody          1      0      0  00 [------]

# xfs_io -x -c 'shutdown' /opt
# umount /opt
# mount /dev/sdf /opt -o usrquota
# touch /opt/man2
# xfs_quota -x -c 'report -ahi' /opt
User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            1      0      0  00 [------]
nobody          1      0      0  00 [------]

# umount /opt

Notice how the initial quotacheck set the root dquot icount to 3
(rootino, rbmino, rsumino), but after shutdown -> remount -> recovery,
xfs_quota reports that the root dquot has only 1 icount.  We haven't
deleted anything from the filesystem, which means that quota is now
under-counting.  This behavior is not limited to icount or the root
dquot, but this is the shortest reproducer.

I traced the cause of this discrepancy to the way that we handle ondisk
dquot updates during quotacheck vs. regular fs activity.  Normally, when
we allocate a disk block for a dquot, we log the buffer as a regular
(dquot) buffer.  Subsequent updates to the dquots backed by that block
are done via separate dquot log item updates, which means that they
depend on the logged buffer update being written to disk before the
dquot items.  Because individual dquots have their own LSN fields, that
initial dquot buffer must always be recovered.

However, the story changes for quotacheck, which can cause dquot block
allocations but persists the final dquot counter values via a delwri
list.  Because recovery doesn't gate dquot buffer replay on an LSN, this
means that the initial dquot buffer can be replayed over the (newer)
contents that were delwritten at the end of quotacheck.  In effect, this
re-initializes the dquot counters after they've been updated.  If the
log does not contain any other dquot items to recover, the obsolete
dquot contents will not be corrected by log recovery.

Because quotacheck uses a transaction to log the setting of the CHKD
flags in the superblock, we skip quotacheck during the second mount
call, which allows the incorrect icount to remain.

Fix this by changing the ondisk dquot initialization function to use
ordered buffers to write out fresh dquot blocks if it detects that we're
running quotacheck.  If the system goes down before quotacheck can
complete, the CHKD flags will not be set in the superblock and the next
mount will run quotacheck again, which can fix uninitialized dquot
buffers.  This requires amending the defer code to maintaine ordered
buffer state across defer rolls for the sake of the dquot allocation
code.

For regular operations we preserve the current behavior since the dquot
items require properly initialized ondisk dquot records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 10 ++++++-
 fs/xfs/xfs_dquot.c        | 56 ++++++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 22557527cfdb..8cc3faa62404 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -234,10 +234,13 @@ xfs_defer_trans_roll(
 	struct xfs_log_item		*lip;
 	struct xfs_buf			*bplist[XFS_DEFER_OPS_NR_BUFS];
 	struct xfs_inode		*iplist[XFS_DEFER_OPS_NR_INODES];
+	unsigned int			ordered = 0; /* bitmap */
 	int				bpcount = 0, ipcount = 0;
 	int				i;
 	int				error;
 
+	BUILD_BUG_ON(NBBY * sizeof(ordered) < XFS_DEFER_OPS_NR_BUFS);
+
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		switch (lip->li_type) {
 		case XFS_LI_BUF:
@@ -248,7 +251,10 @@ xfs_defer_trans_roll(
 					ASSERT(0);
 					return -EFSCORRUPTED;
 				}
-				xfs_trans_dirty_buf(tp, bli->bli_buf);
+				if (bli->bli_flags & XFS_BLI_ORDERED)
+					ordered |= (1U << bpcount);
+				else
+					xfs_trans_dirty_buf(tp, bli->bli_buf);
 				bplist[bpcount++] = bli->bli_buf;
 			}
 			break;
@@ -289,6 +295,8 @@ xfs_defer_trans_roll(
 	/* Rejoin the buffers and dirty them so the log moves forward. */
 	for (i = 0; i < bpcount; i++) {
 		xfs_trans_bjoin(tp, bplist[i]);
+		if (ordered & (1U << i))
+			xfs_trans_ordered_buf(tp, bplist[i]);
 		xfs_trans_bhold(tp, bplist[i]);
 	}
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9596b86e7de9..6231b155e7f3 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -205,16 +205,18 @@ xfs_qm_adjust_dqtimers(
  */
 STATIC void
 xfs_qm_init_dquot_blk(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_buf_t	*bp)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_buf		*bp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	xfs_dqblk_t	*d;
-	xfs_dqid_t	curid;
-	int		i;
+	struct xfs_dqblk	*d;
+	xfs_dqid_t		curid;
+	unsigned int		qflag;
+	unsigned int		blftype;
+	int			i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
@@ -238,11 +240,39 @@ xfs_qm_init_dquot_blk(
 		}
 	}
 
-	xfs_trans_dquot_buf(tp, bp,
-			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
-			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
-			     XFS_BLF_GDQUOT_BUF)));
-	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
+	if (type & XFS_DQ_USER) {
+		qflag = XFS_UQUOTA_CHKD;
+		blftype = XFS_BLF_UDQUOT_BUF;
+	} else if (type & XFS_DQ_PROJ) {
+		qflag = XFS_PQUOTA_CHKD;
+		blftype = XFS_BLF_PDQUOT_BUF;
+	} else {
+		qflag = XFS_GQUOTA_CHKD;
+		blftype = XFS_BLF_GDQUOT_BUF;
+	}
+
+	xfs_trans_dquot_buf(tp, bp, blftype);
+
+	/*
+	 * quotacheck uses delayed writes to update all the dquots on disk in an
+	 * efficient manner instead of logging the individual dquot changes as
+	 * they are made. However if we log the buffer allocated here and crash
+	 * after quotacheck while the logged initialisation is still in the
+	 * active region of the log, log recovery can replay the dquot buffer
+	 * initialisation over the top of the checked dquots and corrupt quota
+	 * accounting.
+	 *
+	 * To avoid this problem, quotacheck cannot log the initialised buffer.
+	 * We must still dirty the buffer and write it back before the
+	 * allocation transaction clears the log. Therefore, mark the buffer as
+	 * ordered instead of logging it directly. This is safe for quotacheck
+	 * because it detects and repairs allocated but initialized dquot blocks
+	 * in the quota inodes.
+	 */
+	if (!(mp->m_qflags & qflag))
+		xfs_trans_ordered_buf(tp, bp);
+	else
+		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
 /*
-- 
2.35.1

