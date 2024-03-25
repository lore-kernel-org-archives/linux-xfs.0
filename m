Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338DE71739
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404504; cv=fail; b=DQFx23mXP+f21B2nqqU+ZasxukekS0HcX5FNnP7VclZdL3NWqVgWkYRE2Z4H78fJ16iAKYPWMtrM50gwvtu5MmC7ILUU7NvKBDynYt1kgBxtyZvigIXALpSPYhFaE1DW3dvGIteyHutEp4UL2KzihBSs53ZCd+FJDF9jBHqFkV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404504; c=relaxed/simple;
	bh=rUAMEtmpcIZndKy+7cogowvrPkY9Igh/p0wted4LzF8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A9UA6VA9pSzpCGjGABA0+IYDk4xnSSN32sIfx/P5J8YBuzjGikE4qlsaQPn/dYZrlXcpx9xNZJOp1AtU83UERk6aZjO3520FpVZn3h5cb9JuVoqBYVwYSY1y8Kt2PdDDDA+pmbonk0O9pACzS1ub3xpKWwLt0q3Xdewff38wDaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NeDQ0Hhl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AFwccrsC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NeDQ0Hhl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AFwccrsC"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLGXjp019954
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=IP8YqveRGDMFP+gsryZm3it2jc6yYcGEm0tKl8H2S5U=;
 b=NeDQ0HhlXXOUiq0totGGB63VFVOOsZl1bG7yB0fti7fZ7W2QqtSiVcdtPiJ9dY/DG5aU
 zXPKvGaZhLWTU4DmG47MXN3ayBpjiuNRu/yEl+eaN3wFHdeyVCDxRxQ+G4X50PgFxFxf
 LBFWE7XVYdbRYJzYDzvdjzEYI/+pzi0xYKDs1ZoRlDd4LzSwgpDC43xVBK+/23mWO1U1
 0PhQ3UhL+LUUwm7m9bBlsIkFStLf6BgnJXg0jECq36dPoXROMdGmKE9KVlfiV0/eeaQz
 u/po8TSOANZSjJF34i0ZM8y9vP7t7Bplt33eLzwMb9gavLTstM04fhZrfj+lvaS+W/qP UA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1ppukrut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKNtd1024519
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6ccn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aly9qSnoa3qxE/u9TKCSyqY4dgCcIcGCJXPLIs4zqgjix/l4VtOp2ftc/HjF6ljWzDg1VVVLAvXRqq0nB4Wntvjjc1BycbhGRSlhnH0JhgWZDcwiedBNdSBOeiafcrtDd1MjkMMSUzI/GD70Ggq/qme3ERsIm3fkj/+qFBL7z0vKYMH/e1lwu63DPLYmKdSS4QJ33UAr2H18L5bz4DlPAOCl5r9qhGkSSPBj4lCfVlsOQGCeuiQPq6DnlfFApGfiAkBPCqA0878jvnfNUVNKjYzR2DA5bEIlJmvn+Gx/TsBweOsf3aq7xqnhVG8E4/tPap3pVagV8vjthyXUxOSJ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IP8YqveRGDMFP+gsryZm3it2jc6yYcGEm0tKl8H2S5U=;
 b=iPmywb+Xg7eRFhjZ44p6ABghJCDCVvxesyqXqESnKh+o5crEIoXvKhiVcYQFn7Ftrn8bEL4Issfz82WmvjIwVzC3ZeySdKO/doDk8i790O2NoNiNrZeA5qUYNqH0ZUfdjVi4GgYyrvOze66CjglSrasBd7TE8Arcyenex94n86xttU8J8RuPPsxzjDerAShD4f/qLwk737KnCMXNlhRYroFL3Xoe2uHTuuBnB9coDvsNpualXIBWhts7PuSZ5cD3GLDST4BfL4nhEgxGZdgIebzzzeHf+CT4HJoL1tJId2EG94ybr3dKklNqUrUKwug0yps40kw/nv2L1VcbQCLVXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IP8YqveRGDMFP+gsryZm3it2jc6yYcGEm0tKl8H2S5U=;
 b=AFwccrsCLXZfQhtYxIx/kR/kaPRgYcEwBxpNeJb0S6Iw8z7Fz5tr3r+N4dVUMT1jkzHpeYvGDKAN5fV4u2eIQcQ4/W9VDFy1TjV9mIY/yJ6NCL9GywRmbcuEbpoNsuBhQv9Lv2WQf105xC7euk3OMiurTni6EQwNvuXpG2djBQM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:56 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:56 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 11/24] xfs: make xchk_iget safer in the presence of corrupt inode btrees
Date: Mon, 25 Mar 2024 15:07:11 -0700
Message-Id: <20240325220724.42216-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0150.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::35) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vFfA5rBWfUtz8RbSKrBqp4cRUKD9Yc4h05G248gR7Vd0B+zYsTOM12vyBVXH6OtCueM03DFtHpQEDsXIge7bX4lM47iaUJOBKvK7BvZ61bvDz06cCnh/v6tNVERs98o8dYwDK/sbLZ6em8/Y8b3Ro9xDtJS2lIGNY9W67/W62aoH+j3j3bocGFFouK42tq1jsYp5l+a5CfdbFmQQjKShyDhwvkZbeNDD8vnavvJSjv3+2Uf7bMW0jZTY9gw/ckvnsZaJbpvKovCkYVqyP5xwXdIBER31ZxC4uksMPE9NDS7CjJPv0FtPNmGsn1nuGMZHierr4mbqnRopkSg4HRXCiaDTSP7/L8ZEPNncftItL4uMEjk2r/L+gcWo/ZcPLEwWGRgZ6bIclfvDjHYj6gx7nwvwC8PLi4wbUnTZSWraFw2DGvhcSJ+ZgJFhwWiDGwmSmc8jV0inrx/G1i778+87QV5jLSyTyNeraRJhGuvUxjbF1OwxL9FgYEliamhP1vxfbj9NNNlajxCTup36vZNQDSnwC42utitmdTJzt/Uv0tw8WNgBVvjRQnc8xcrlpKkny630PN8UnvioQXEu529/ZOLoKC+zEfcQmGATIHffzf/uq1qFugohN9yHNtUr7aLyui24qfpT832ETCH2gGkXRmcctxJ2So4ZdI0exO/TDvA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VWFGqgyFk3/YUj2j9eAVqCRGJv2mnU+wh+AeqQwMzshIBhSPOqaVZQVeya9k?=
 =?us-ascii?Q?ISc+Z/jTD9o/GQqJuhX3zuaGQtcoWfH9CK7r2tHmnUUIXRqztUi1vGUcPGjE?=
 =?us-ascii?Q?zbMeZBvVboSk65wz0YSKVwVb+jZCwrEAF5aC+YgbY5ct0Y8rgId/uQZVIsKL?=
 =?us-ascii?Q?dJmBsFcaEvJ2zdKgfkGXr+o4Gt71DdUcI2BVUNdcgJ5g8QePoen/sPHCuvRZ?=
 =?us-ascii?Q?o4E/nDZTs08vkjBjrk1wFXth1oK1RRAxX5x2ZS/kVvG8XOuXPpo6pRN/ncrh?=
 =?us-ascii?Q?oNykCfEsD1nGlUh8OT1MdjMrmHRakIquYMbKQNul3+R6ZVhSbzcKjqYiddXS?=
 =?us-ascii?Q?CdWMSewRulzvbCDsWf52o6wwjzYN7mfcob/ofNqG3KNy+uNxxNNd4NcT8Gt+?=
 =?us-ascii?Q?m8BzQNF9E2V10ft10YWo1WMva7av+ujEfntMUI9nwOAcbd/ZOgDFj6EexX2/?=
 =?us-ascii?Q?6SgILZ309KFGF/1niUbZ+MdtzI/TkVEscTbLQDnG4R/qV1tTPNncosGpD7Jf?=
 =?us-ascii?Q?4Y28Mxt8Koe1aYIc01xmouQ0Qc8WvaQycFuVNUksodzMgwtfFeueGFMcKgK/?=
 =?us-ascii?Q?Gm0UGP1L9H+g2MgjOPznq9EAc0YCmYbB1/Y7lnQSZ8Aev7IQUGCtk+Psp3Xl?=
 =?us-ascii?Q?RXxT8jKpEdP57IgofSqL8MEmG0+bdu15bskhWyEVNY9pmEcG0F/O2d7TkL2Q?=
 =?us-ascii?Q?z4Zh2cJNuRVyvgrSbE8g8Q3NMThliiSdxAJSqdRrUmGe0GFbIil174xuzY73?=
 =?us-ascii?Q?+FX6hbPxxN+dzk1o+PeI7T9WUyzLNCptMO6BHHUtcSrk4UyhcoVYyU9sYTSK?=
 =?us-ascii?Q?HRb/F7Wq2dstzweY7tKsRtTNj3AxwIMIASRbMUOsTWSV7FWnJ1TgQ9Clpdl8?=
 =?us-ascii?Q?gSJE40FmcXxEzKwy9xvjbMSwATAaUa+2KEhMw+zWAOebgx1gXAjPO/QfE5yd?=
 =?us-ascii?Q?32/Exk4ymvpid6BkMasrOGY+T0EVB5sr+DsOJUhI7EmZsMsYe07L7nTO15ur?=
 =?us-ascii?Q?tXX0nsgY2HuM5ID+GBOB6aphtmMLRDrahPbyylZmiGJYYeSo4IBNI7CWPIXO?=
 =?us-ascii?Q?t88y8pAyYBvctNMWPXBODwVci1Hv/MPYw3vHu4xk3vMpzdnom7L3hTkOIZ5R?=
 =?us-ascii?Q?rowtp3uwbH6Fj+7AQ28cWsvwnC2t7e4iUiDepY2Mom5eEVrCKW5CH0nkiw9D?=
 =?us-ascii?Q?S6h7WRiST4Zhu7wE05kKdOhVCVXYyj9cHuQKpGPu/1SwIU3j5b4AOdjXaR6J?=
 =?us-ascii?Q?Jw+iRcYudQONY6cHPD6Ga4eh1JnuxQOeZaYlEuEazMK2mnmXSjDpRwv/DMEZ?=
 =?us-ascii?Q?Ljkd1LOwgbSzIFJjnTA/fo43nAgwKaoPNyqgdqS2qASgYoXe5Cw/hloY7rqR?=
 =?us-ascii?Q?zQuorx06FcETDZ4X3hWUOsHUL7zyU7BvHNoPG6JcUKOP71k+TZ4Odes7RteW?=
 =?us-ascii?Q?rWqvWoJMZ6rsxdY9w2Cz2W9XW0XJs5a+lnwyt/W+K4KbFtHP2ndSLNuxrejT?=
 =?us-ascii?Q?jjhYYqdqRdpsdNkolUTvKs6c0yfQRPc63ZufbxmK+pGqTEZ6cmx73QdCf7l9?=
 =?us-ascii?Q?IQjV3duAFRppdLDTc+kKFTMnAWhkkGpPtBvV1+fKf0Jmrl+0/pHkuvenZj9G?=
 =?us-ascii?Q?06Q2LK7cECDrzylRtUQt2fdmpx4JM0YsQN6xO4IsBy2g/WKaPSqYR0jDqkmG?=
 =?us-ascii?Q?0YE+Aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	yxUZOaIvsHq3tCtYcmLFvu7O9pBDI7YFIYZg1oqxFIRAnUYGqrDMLvG/yyhp3t0uK9l7uJqbKf3Jmv+nxnr544ebR6tg89CB4eqRXzzIftaAqTBYs+aVEh/7xfuud4wYg10CHCZtpNWcK2ev1ptkiHyAzNC6Bx8zumZKl6p5WYeccyK4ZOptdJsaEsqCtu1Pjexi5cWVaswwHOo13E2du20nFQs+g7jH771dUwCe1ioPPZjGlgWBmwR8oNZjK7TYbmHR1JjIfAAl5Ihz3WwbD10I5Bvlbjr/jOmRacxF648WQWVIvTv0bZYZABfX0HLriwvPvqJz3azrSMoBGZYTdqN7LAjTkex3L97khAsXso7odcEbnV0JtfKMg4PIM83PUah/4CBxxcnzs8+7Gun2FVd4nDqJpk051JYzAp7O3PPr2/GL03F4CroguI422k6vgY19FFkFfkDgdHFaJ+6eg4QNFqBy9bZVtbeXeNGKZpWb4tXk8PHzD6MRtqwPe95iJUmV88/K0JimTHvEkwnur7XFfsP7zpd5kohT+C5kOjatNIIfMljeA/jYipd20Q6zN2aG2WHXFT4qfl9yUpM4NvlWfxxHYVLHtqHp906cIzE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e77aeaa3-c643-4648-bdb2-08dc4d180660
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:56.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GRaDe1ioplSTLxKKuZmeNyejOGWsgxQzo/euY8yXrM2P59qhdGr03lI8InI88wYb4nzJZLBa+fZh0hnv8+d17uO7xqkJSm4rwKA14qgPcMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-ORIG-GUID: KR5wRcB4CJA0yAC1WGbQ6pGWe1mhN_h_
X-Proofpoint-GUID: KR5wRcB4CJA0yAC1WGbQ6pGWe1mhN_h_

From: "Darrick J. Wong" <djwong@kernel.org>

commit 3f113c2739b1b068854c7ffed635c2bd790d1492 upstream.

When scrub is trying to iget an inode, ensure that it won't end up
deadlocked on a cycle in the inode btree by using an empty transaction
to store all the buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/common.c |  6 ++++--
 fs/xfs/scrub/common.h | 25 +++++++++++++++++++++++++
 fs/xfs/scrub/inode.c  |  4 ++--
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index de24532fe083..23944fcc1a6c 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -733,6 +733,8 @@ xchk_iget(
 	xfs_ino_t		inum,
 	struct xfs_inode	**ipp)
 {
+	ASSERT(sc->tp != NULL);
+
 	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
 }
 
@@ -882,8 +884,8 @@ xchk_iget_for_scrubbing(
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
-	/* Try a regular untrusted iget. */
-	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	/* Try a safe untrusted iget. */
+	error = xchk_iget_safe(sc, sc->sm->sm_ino, &ip);
 	if (!error)
 		return xchk_install_handle_inode(sc, ip);
 	if (error == -ENOENT)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index cabdc0e16838..c83cf9e5b55f 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -151,12 +151,37 @@ void xchk_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
 
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
+/*
+ * Grab the inode at @inum.  The caller must have created a scrub transaction
+ * so that we can confirm the inumber by walking the inobt and not deadlock on
+ * a loop in the inobt.
+ */
 int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
 int xchk_iget_agi(struct xfs_scrub *sc, xfs_ino_t inum,
 		struct xfs_buf **agi_bpp, struct xfs_inode **ipp);
 void xchk_irele(struct xfs_scrub *sc, struct xfs_inode *ip);
 int xchk_install_handle_inode(struct xfs_scrub *sc, struct xfs_inode *ip);
 
+/*
+ * Safe version of (untrusted) xchk_iget that uses an empty transaction to
+ * avoid deadlocking on loops in the inobt.  This should only be used in a
+ * scrub or repair setup routine, and only prior to grabbing a transaction.
+ */
+static inline int
+xchk_iget_safe(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp)
+{
+	int	error;
+
+	ASSERT(sc->tp == NULL);
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+	error = xchk_iget(sc, inum, ipp);
+	xchk_trans_cancel(sc);
+	return error;
+}
+
 /*
  * Don't bother cross-referencing if we already found corruption or cross
  * referencing discrepancies.
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 59d7912fb75f..74b1ebb40a4c 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -94,8 +94,8 @@ xchk_setup_inode(
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
-	/* Try a regular untrusted iget. */
-	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	/* Try a safe untrusted iget. */
+	error = xchk_iget_safe(sc, sc->sm->sm_ino, &ip);
 	if (!error)
 		return xchk_install_handle_iscrub(sc, ip);
 	if (error == -ENOENT)
-- 
2.39.3

