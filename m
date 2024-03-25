Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601B170CC8
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404472; cv=fail; b=ViKprwTuppLupONFH+JI7W1E+fGO77Bk8DUdNbj6KvvQA/fUxRGIw8Y1klm/y/h66aoLaGmMrXzqEMt7jOUNX8EgyrB2wBoSQ3Iuxz7T88gTl63DGwPK2Lv7XmGVTIrAjpuKXkKXwmpCvwo2coP5nOxrQxHIIl4LuxDTbZe1Y5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404472; c=relaxed/simple;
	bh=JrmZSWiFaLuUuMxdo1qc6+NmRd033gC7WQHcoqIrPXI=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WkILJmGepdShzDWxnNJXc0wzcoN3mj2QPs3Ltd3VigKGKt4/yOB1nB61LnEshNV04Du4dLKo/n72KNO2WdeuJhdMlfAKmaWpMGLVYizbLYXRQrhoT+h8WCYFud7Vj/wVdAUEyCVBlaa6bQCiMh7sNz1ATcU1jNoSH3DO+Do7sSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MaLhVQbz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g7u4i7QT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MaLhVQbz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g7u4i7QT"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFtGj027130
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=/sqs684xErVXEx9ewTWjS/Y9cD7ZGJLSDw5cAre1a9I=;
 b=MaLhVQbzlEImrSrupP+GpqAwTMDwXlgIw6a29h+R7hXAL7wKmkS6IDoa1MzsDweRlnWo
 hyucQrHElcA1VwnQGm/iukQXsclHM8f7ydKxSaF8hhwuQhiCU/IcptTfqH2dWiuGVYJ/
 +38yqMPDR2VHUo7zIecd2ZhpU7FvCo3qY6RMJdGFTxYBPUjzCJaj7DfkFXXKVVP764cL
 LoaxqcZlscSwL1zT8xK8G2TNNAbHT7U7OuQMzljpvZtkUJSX29CvMW3dCBVBXXDqJ51E
 VpEGgsT6cIWnOSiwvFTa6iDYoBIYD/1D5XFGeD/ImxsldsltADGroLXJsIIf6mVuO7a1 tA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybkqhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PK9EIC016177
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:48 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17012018.outbound.protection.outlook.com [40.93.12.18])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64r4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnSdwe2WZPycK7/JwC/siKYhAL1W6yFQnEWMyTbTpP1KH7JdAHLXtYLnwG7r8hXWVBG4q/gRfUHd/io+AWpqWkBBJ+NYcXXqqFVFu/qZ1pZKSI1zHjw0l8IM7a2fJXm907fJiOiJJhjd2W2rbMAZPjhn7UyaUt++uCNou+GrOlI/FcEL8iClWaLGp14GPbt+qUTHU6sgk0nqb9m3R/lJRXClxLrFzjYhdPr92lyGmIcYkv0zAtINMgkzd6Q6sNIZ1X8TH1oR6aWGtnUAaFx3zp16/QQ0z8sieDW/ESgSiCnGw8CWvXNlg3LDvnkKFODxRyPom57I9sjmymZPoQtNNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sqs684xErVXEx9ewTWjS/Y9cD7ZGJLSDw5cAre1a9I=;
 b=ilmXyVhAIXHGZATkMSEIPgO43+/xFx+6/5HaJB3ARJ+oGBQ0FKoXTGf1/HGApmRS2mj7hdYJa5bk55sBbfN0TK1oQAgiQ/zZTWQKpGYJ4D+sBjQwR481+gRZRhhfQxsuZajqO9V6Ad6BORO1owJ+3zgTE/35gtXcsnoyQzHGogSmWfrB0C4f1AHOLBaSvY9BpUoWx7ICTkEmCtS8mksJRA64tqiu+dpzebPbVaPQOTIeeto6VFbASfxmB/+DZ0sastdIEyx3NQRUNBpeygDAhbEuL491gIPCDc2GxC8vHU46dUJob6q8pBn1HLRkTap/bAna+Dt4w7U/pz02Pkdjtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sqs684xErVXEx9ewTWjS/Y9cD7ZGJLSDw5cAre1a9I=;
 b=g7u4i7QT6pSBUiHS28lzcmu810T7q3GRk+5y1kQ0NyF/mpGeDkywZnF/O6uTmg0eoFf+9LqoeDr7ufPisUlAKAnE6DUYZ/TAfCK80w7sT8g9q5kVpkZAZIF8hIB/2kQw0ni93P9M72Mr/xgKSoUrkql5ENh92xcWs8UNl3lxdl8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:46 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:46 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 06/24] xfs: pass the xfs_defer_pending object to iop_recover
Date: Mon, 25 Mar 2024 15:07:06 -0700
Message-Id: <20240325220724.42216-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0141.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::26) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7476:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jBUnv7XKLxWCHq47pxP0ev5Mu3AmTwO2rDH0xl1NnQtAU8IH+8pbu4nANrpPrIKPgE/56yKpsjSPAFEfsYzU/61X92zraKIYezqeGLlSjVllECJ0w97DLmaLCt5F5dWvdwo5cW+ODrogHP86pe3f5nvALdbUbqjtWOGXIskqzmRjn/EAoU/+3lbq1lzZ9xKTLX8Q2674F1SG4eOboM6BQgw0giErz1sfyV7cYNZk4wDC4THYBd5s7vwQylN9jP0bX4IVqcZ8lxTqvUz6axn7r5FgGQQ0oBq2WfjiQcQzcrsgCgD3XG4ys/73ogekPXkOwS89Zz2cz14xwRYiOS2sIJssgaDOZt4Y0g7BF18XnbmPVBgYM/EwmQNnFO9DTnNzK/j6sO7qU4jlDQbtHsbmbwIEkqmITbC/ivdMzAYXHX+i9QJceCYRlM2dHc731nkzdf65OQkZJnk/7f8DvnQZgef9WpU6HO/mvMi3RwuoubpRnhu6vCqhTXhlp2wA/B+5y8XqbiOfDcxpPHqFItb6UWd3y3HwvT+yNRRa3k8nUiqcNzmjPD2qfZg8RGoda62/WNAAKqnbxvWVXotG1TzB2Mkdh7dkcFLz3swF/oS9scZ7sGZE5BSbC+URWosFQHnuA59BgdWs6R5EqQr8n7hnPO8x8WSSmeKtu2L04Le+Gns=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?6y9ZPKq7HMmykKTcltmmeQVso2kesoT+oUHUHgJdBJEdUDrMWnu1DVDGZP7/?=
 =?us-ascii?Q?PwbvZnziVGXi9DA0eHofTW/3gCzNJotOMVcozRiFskgcAmI+8cTfvyzYbWgz?=
 =?us-ascii?Q?tCNTrr5NKeHuYYRt0NO9jNDKaQU6++e9K+kPb6sat/2dELxzTx+TcYPPer3C?=
 =?us-ascii?Q?R94n8YW41oNA9pqjohGnSpwMadzgdq/4IfBhXGwDGESihBk1oGduGpU1M+sb?=
 =?us-ascii?Q?GPWUNLC4x9pR2uCqJFTrUnPOQGHduwacfNSHtJo7vc2Ppt5Rta6wnyIhAcIo?=
 =?us-ascii?Q?OswGE9tnkslSk3M9OubYuZfGxennATa0VZ2IgZ5wXAWPdSlnQN7bcd2IFQwb?=
 =?us-ascii?Q?k2rGQuuQnFkqd9NZMO2x2nV6Mjb7E4DCHMOQoeuo5qZnu9XxHjwWyNwf+Tn9?=
 =?us-ascii?Q?J/HcYDmCbWN+ct8vBKBnFmrt+mbG5t8ZWri52f40IFD4/vygiZ8QL93p9GJu?=
 =?us-ascii?Q?2Stp6Eom+/tPqnYJ+4wQ7XEE6sYD5wEDKeFgS4LbSB0l/1QLSsMXJFghRv9r?=
 =?us-ascii?Q?j6JO2AIV5VNVgAWOwDyDTqHCKRR6Erh4AUESMGlpsBTxugaoi/eUToScc4qU?=
 =?us-ascii?Q?/XoTbAJowfXomrH7QZmkNhSVB0bh8NnYN6bpVI3b8VBtZk6Bd6sBz5G5Ea5+?=
 =?us-ascii?Q?E2nWSpm3G9jK9hy44FrZUBRk+U3eEOR3qF7dvEAMtLlYiwF0khXw9u3xgOjn?=
 =?us-ascii?Q?UF0zXjh5ExSV6N1YCdeV5AYMt9VHb+uSJ8VY2+VqWshitzLbB8xH7uwoG7Wj?=
 =?us-ascii?Q?MDMhPfPa9TleXUYleAm+0+9DGNE+xu3EVWg3YthfBA5jnbJ6rg0L90A2iA52?=
 =?us-ascii?Q?Fz1ezmLYLCgxhjDQtdstOQ2bJDpP/F10UkXtaENvUizNq/E1iUVy3T7RHHjE?=
 =?us-ascii?Q?uF/JQtaMmk7qopON6EMjEBNBNySMwYz43RZEGyIO3KT/4F7kYYjoW41TjvZG?=
 =?us-ascii?Q?marJmjNoCA70mqFqZxY7psAAZBUoHTdJxlnS0SwB04QNE23llJneU95NC+56?=
 =?us-ascii?Q?1DxxYQRvQiHDPb6IL98BaA3VpX7W7oRWAYD1g+6ID1YrJLFu4D0YNU9GlYI3?=
 =?us-ascii?Q?cN8IUtYBFRu6zVlj1aaCAS1TzmCklkOoyBfysKlau3ZwmK2MmOFhBDhiJSyx?=
 =?us-ascii?Q?adXLD8qzkmdJAlTQORqMivTDDmQ9R5BNPoLc7hGJSOqvM9uSbweRLTFg0lIo?=
 =?us-ascii?Q?aAUSIo2xTIHDxHJLG0JBHkvxKTSXa7J/lopzdIKS+S7eM3+vcnpcu+q4AtiF?=
 =?us-ascii?Q?6aTXZxWoPL9JmDmT0GrJnCymn0G6jin7gKa6Ris/DOOrcHCCGrHBN1QbBaYd?=
 =?us-ascii?Q?AQfBHp2S0d+2n5z03WdR7RP2+weUiAwqG5eoXk46bj6K1z8tv3enV54Ibwo+?=
 =?us-ascii?Q?i/a7BjNmTrXWvuUBC9yxiZSFjBvUIfQ6XSzr39BsrXpsN8Nhh7UUmBSPc8Nw?=
 =?us-ascii?Q?RXqiPXyfTBFX+kBCI4ZqP1+Z1b+tbxecYL/aCrALkQIXns/VzmVREGNdNSJk?=
 =?us-ascii?Q?iUHck7oEzS96umD9UNmIXifrSypwLXZcPpsr/Dozzzhxi5zTp2GUVP3eO1wO?=
 =?us-ascii?Q?4N6XAuQJpbwX6qTufs5BPlKwZkPBHo0wocdfqHDvKqylYfrFufhlxvqnFuQO?=
 =?us-ascii?Q?2OIoJ5mNDW6rt0AKa0Qk1FztnQ4Z6Z0PPs7LuoR8upq988PA7z3kQdIWlzsG?=
 =?us-ascii?Q?sCyz+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5u9E3BuZpE1SC01BaEtINj6tmzjWXvZR+0knX2Q5XIzEkT1YSr49rR4nMcFziLTqrW6dIJJ7vLkISvsx7TQ/w0TZU7bNd0fGv03rbtfnEBPV5A67WlwApuNHzmbqK6ItHwgLVdhhXDc1ZNeDuubEPARPIxNTdX3xBn+5IwM9mwzkhF8CbzKt+FZ+yt9Bec8kj/rdQVXOt/d7o0qJF7PAALbdOU+zhyfU4bm/eqc0pl5VXkUsVmAvGDOllr6Ihi/BfF8PasdkFfUL5NY6ky/GxfJyLfQvtzIWcuDrAs55ycKGuxgB00M+ZCNcxj6xNwAlqIqdgP/CW+Hgb9y49ELu9bKs1jYRDyQSbMygq3R/xkqVO60LXmcPYXDgKIod/ZTkIwaxcg1n5iOMAJPxDGctdq+asy9j73OGRQIwQ5l3bLMRnOTO5/C8y2kaw9oFNfu/lIuy3JRU9G6TRHTvQJ43GYYaO61PDZ3PDoxE8RDKtWggeAsdCfjNPhI9mmAtdwwwWIsns2zuTQA/JvXOl5irvAWGHCvQ2PPwEW2Ip/0F73//e8SqbX9JLZt1A+69cznSg0XXsX0rhfOp+vbRWiOSNqQMH82Deg512Co+fjWoxAA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd78702-44da-4409-b67a-08dc4d180084
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:46.4313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cfUjRZ7xlRQmff6g/Vwy2RaU8hntZyuLnbWDHdD3YTfFqkCJDjrcrOqTb8atk2iI8IzE5GvhtJ2JnnsClk1kcfYjrn1/nxBZCbej4WlKXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250137
X-Proofpoint-GUID: xtMnSOGHs0mNWDPk_p-FVzoIaBNXXx__
X-Proofpoint-ORIG-GUID: xtMnSOGHs0mNWDPk_p-FVzoIaBNXXx__

From: "Darrick J. Wong" <djwong@kernel.org>

commit a050acdfa8003a44eae4558fddafc7afb1aef458 upstream.

Now that log intent item recovery recreates the xfs_defer_pending state,
we should pass that into the ->iop_recover routines so that the intent
item can finish the recreation work.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_attr_item.c     | 3 ++-
 fs/xfs/xfs_bmap_item.c     | 3 ++-
 fs/xfs/xfs_extfree_item.c  | 3 ++-
 fs/xfs/xfs_log_recover.c   | 2 +-
 fs/xfs/xfs_refcount_item.c | 3 ++-
 fs/xfs/xfs_rmap_item.c     | 3 ++-
 fs/xfs/xfs_trans.h         | 4 +++-
 7 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a32716b8cbbd..6119a7a480a0 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -545,9 +545,10 @@ xfs_attri_validate(
  */
 STATIC int
 xfs_attri_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
 	struct xfs_attr_intent		*attr;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 6cbae4fdf43f..3ef55de370b5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -486,11 +486,12 @@ xfs_bui_validate(
  */
 STATIC int
 xfs_bui_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_bmap_intent		fake = { };
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index cf0ddeb70580..a8245c5ffe49 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -657,10 +657,11 @@ xfs_efi_validate_ext(
  */
 STATIC int
 xfs_efi_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
 	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b9d2152a2bad..ff768217f2c7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2583,7 +2583,7 @@ xlog_recover_process_intents(
 		 * The recovery function can free the log item, so we must not
 		 * access lip after it returns.
 		 */
-		error = ops->iop_recover(lip, &capture_list);
+		error = ops->iop_recover(dfp, &capture_list);
 		if (error) {
 			trace_xlog_intent_recovery_failed(log->l_mp, error,
 					ops->iop_recover);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index b88cb2e98227..3456201aa3e6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -474,10 +474,11 @@ xfs_cui_validate_phys(
  */
 STATIC int
 xfs_cui_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index c30d4a4a14b2..dfd5a3e4b1fb 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -504,10 +504,11 @@ xfs_rui_validate_map(
  */
 STATIC int
 xfs_rui_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6e3646d524ce..4e38357237c3 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -66,6 +66,8 @@ struct xfs_log_item {
 	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
 	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
 
+struct xfs_defer_pending;
+
 struct xfs_item_ops {
 	unsigned flags;
 	void (*iop_size)(struct xfs_log_item *, int *, int *);
@@ -78,7 +80,7 @@ struct xfs_item_ops {
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
 	void (*iop_release)(struct xfs_log_item *);
-	int (*iop_recover)(struct xfs_log_item *lip,
+	int (*iop_recover)(struct xfs_defer_pending *dfp,
 			   struct list_head *capture_list);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
-- 
2.39.3

