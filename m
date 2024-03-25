Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066B17175F
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404506; cv=fail; b=FJBMPPJSL38DH/w/0xgF3xqy7DfHLb0tIuU1BPcnly+nQY+ABC2za6vUdIrH1nq/lEHGlEe2C17pyW7z990GBdm7kgC3bfw61SZgnfVYfAbzDCz2tCbf+gG38J255JNEEyCwLmFhmYrm2ebJUfN2b2nctTN7UP4ZA3gtu2H8rxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404506; c=relaxed/simple;
	bh=30Twgc0IfcMPRUzGGnQTvl9S7DTRBTaBbE8+aElTs8w=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nYu+kADdOVgOKk6vI5ACOjWfLIru/EE9zn5FNxgvrgCxb6xzLqpdCCMWHLhpX0sNhXCIpNlphLyHaQyk34fTYDpfJyqdSlljFoKtZyFiAIIUUCSjCsI1qXoDMTQhaAZF3ECuFSbpELZj/lYCMqa5fP3BMqgFaQBuxK4wKuIA+sY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IX5uw0oE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v4O4ycZp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IX5uw0oE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v4O4ycZp"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG0ko019818
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=xZTIQgAe+GRIGY6jWdl/3TORJaysR/+mDZeypqKJx8Y=;
 b=IX5uw0oEZlg8n0wpAN4kdumdRVOXvv+2ATPv3U/3VpwvRoYogXathqMJLvjPWar+rF85
 xECoH1Pf0a1yh0HFopW7+VikAYfvU5notEvO63Dz3y3jjgOoYjOxCb3TywOp7k5+Ieri
 dz9YeueggGNTv8aivmbpw0IXwCv+4+dtSqpiCOQgEHHC0QNgUFyqcdHfUzOcvyA5+paK
 3Ylj6bISrupIJvye9/orzZMKNW4qHJXGjhi1APjKpeDOatFV0c9RJGX1OIuMUBTAeUCJ
 8WAFfR5soV0p7v7KWsvI5WiDzocaYnKKQwWo1WVHMMgbkbc1lBY7XXSa+pYFK8Qk/yZn yA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct32gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKPhAC015960
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64raq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPjNWxxF4FwMNAWeZr6+l5YzZay/5XGHFYhS75YltkTMltL6wryqR85BW2xFlQuOlqBS4lKzzTeDteeFeqHWLK19vnr4O8F8YAcy9FkX5sezjv/26/pvCEiz4dYGQo1znPjbToeGI51BqVirNoLxOzvklKYPlZyBsb0Qlob6a4LS9EpB2xFldhy/J87IuS2rADKnepxEh50qqqAOEtSr/Yl9YVKNNrVKJqpegdedtRSPpokfzDpt33w5UdvlCQwVACKt4l4Wtb57w+e8PdvKySc524IMxnvHOjZ6Iudf54XJ80vx7ZYdw1ZdxbRHK4SXFhEJ8eN8TjBI3Fq0+5XIsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZTIQgAe+GRIGY6jWdl/3TORJaysR/+mDZeypqKJx8Y=;
 b=ebB8C/2noZuLzPl6AIchgiyyJoM0Kqz6D04yWZZsWZlo9Ybgmy+Z3vmvvRCdhw/4mlv2Z5HTclNLPjOGCcfk7l986YWIs/RgyAgHYcUQghYSpRwKP96v/uhcPn0H7XLXa+QlI1Gs+JIzQQOkFtGRANmPnqKk32BV8d8goOhN9ZhQY+aipVlBPr5Af48OhBjKXDkIGkg9f9XpOXaZOU223NM7F2tJ0qB0H//H7ZWwn3FHREgrOqirtaZ0QOJjsngCK8E04Ryv7l0HprH2oW0rxDv/29ut8/8MUkVyKjgKvEqemNlcLaGI35oAvbKv5EgFwg8xkfi2bbQ2WTySz046ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZTIQgAe+GRIGY6jWdl/3TORJaysR/+mDZeypqKJx8Y=;
 b=v4O4ycZpn+ORXnkooPFYWcN9ijXzKZvhgnem4cokrG4xGbhUytq1Ju3cUouAio8d1QAk3l6OxkMCqbdfWID6m+udV9E/1rk+3EZY/ZnVM85eSIgvF9wKH34Iw7bJiNADg3Td+zEIT58joBSYdfvmwNBfXc+BnfGC1CoCM896lSE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:58 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:57 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 12/24] xfs: remove unused fields from struct xbtree_ifakeroot
Date: Mon, 25 Mar 2024 15:07:12 -0700
Message-Id: <20240325220724.42216-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0127.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::12) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	w3H8g8z6gWPstDqjmHt8Mz+n+SqKg2c+V8uN9hfqmHEq8VOBRWkgsqsmyAVvSHsJ7rn8OLDPkv1MPWXlL9BvITcRuPAuNmaggdb52UHV9q9fW+J2ffmB0k8jtGPODehls/hsZi1we9wLpvnKv7N8EBt/wsY9utrlmcoQh6zCdWceL8RW/sa2X1GCtuSaaQ4JR8zxsQU/BhtslOQhDtFqrRsrbl+p2ZSm+ZWkll3GHStdaHAv9o6dAbtNNDXUheeF/3dK2w5XMtt8VW4NHKcSvWHc3yCMiqYFVCM3f6YTqJLjO1jxT90+eZGU5GzAOQPYxtiqVOefYe/juDcOJLmJzZIToHMWWPDq7U33Or23iCXQgbVKLPystKJpFIMGVEm559aTa2lvTopo7+SxPyQSDRT9bSAhz+DujzMjd1i/GaL7a0OSHxglWV3GvNTx/rxo/1SBN+xwK/ry7DJ4v3IQW9TGMiEz8/KylA4IjJPMdj76tVFdW6kWU639xIgv+S0vqZCwd9YICbwlprb511u2w6vPd4qL4ep6obfAqaXw9AH0es7gBZLouIzfJI0EdNyxpjeMMdBUxG+TeaK61h1yeQInvM27qBhrxm7/Mek08BJtjwRNoOH2srQgthqImjwcwB0OhFpBK+hl9MJE9caKEog9FewTtSEBPMzph3JuoRI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?MqQVNIX/CnIxeBoqGgdrlJgO5N3H7r0Zroa/npGJdCnBPTJtBwAFyWQfdbj4?=
 =?us-ascii?Q?MnBRfzkX7XmqUosvFv/alGxk+CF0RTsuLbGkYpcYHVGj46qotbsXZj0g2S9p?=
 =?us-ascii?Q?qgj1WrGl0fvJFjaSK+l/C5N1+Dp302Kx2T/snuq/Wjh6dgXJWb5DP7BtzbYq?=
 =?us-ascii?Q?jHqkatfaMeE26neWPwur3N16EWT5VfG5dnx/iqOq3XHQcqY9TWIJKzfroUTV?=
 =?us-ascii?Q?18HPl1mI8pWZrce3XVfO72ina6PPT6sIe5h7/aMbSBrF4qrB8cwQpynhfAEY?=
 =?us-ascii?Q?Co6qRDhGno1ILmktVbDfijGO4VhRl415GuSVYolJv/5KPJxa2cSBDyxHC2aK?=
 =?us-ascii?Q?rWGf12LKlct2lv14niaW/gZ/DbkqR3QbQb+6CoYpeOxvYlZYpONH2IRNqwB9?=
 =?us-ascii?Q?Wq7YDO8XS7LJImD0rv3hSSDtqW6oNvW3+f7UU6L9NJS5So+gQuh/oQRvNadR?=
 =?us-ascii?Q?yIcgA2c6NIV/7A7AR5l7jbSunWqqMUMN8yjHGxWA4ZFEIUGw3VYir2dEDSZV?=
 =?us-ascii?Q?K4NubP6dWEW3MdT36D2MEuSoHREiNAQP6w3YsiBlGN6cyfMEHqclHdopzKzx?=
 =?us-ascii?Q?uAVrBsTVN1DryEFR6v772eD4Kp8ilvxyjs1WBh6XfVS0rtqa7QyU7CF4tvvs?=
 =?us-ascii?Q?jEFILcNvXEnWZMTEeB9+TPcfqTUQUC5IN9SdVYo0ssCdNaPKt/bNy8lOP50t?=
 =?us-ascii?Q?AhnwO3c4VwXKwh77Ju3J7xqbK+yf+zQayzuruR7AEsfkTpcM7VNsgTjWRC0S?=
 =?us-ascii?Q?mSDO5mrCluSvnwPn7lOF0MRTbXZ8JEli1MB8GsWvYgaVO9Le6N4lClPdGuMc?=
 =?us-ascii?Q?IuKrlJdja1oVMx/oeC6MucSwrp7fJe1pNzSPLEDO/XwI1aIMsIgDDTIeCYQa?=
 =?us-ascii?Q?x6JNR3k+XfzvslVvvxpk+KJR5vxkYUyUB8d27B4MXDouTYAXsIe+T35D9yyc?=
 =?us-ascii?Q?LsnGK+3tolDDzfaOh1uwJFHl0ck54DW3b8dis3Sq/lOOD7BqQTiv8MsL2UFq?=
 =?us-ascii?Q?DRwRCL3TUCXTk1Hf56EIaEr5xkCVhogd7AbKwvVVKUJaDeEmmRETTI4OUsJS?=
 =?us-ascii?Q?KC8b7hraqb5neKqp9yzybCsoP/grCkAIN1dYkoLJnJMYDlwsc4oON+xEOJXj?=
 =?us-ascii?Q?asin4N4MpCCBYSf+vs17uitdENsADoKZXfN6BKlM52nuZAh7GTMB7k4elRIS?=
 =?us-ascii?Q?NAz9L41rafgsTAtAM+hRxtQMn9iC4qcZj3/hgD+5zHO40mB2OWdkLob+0zlc?=
 =?us-ascii?Q?9quZSWkIEHZ2NwmryGmIUch9gTu4Xp1rX9kMbqpRcRsus3voMkW1Fvp2tg9A?=
 =?us-ascii?Q?DOrdwZuAT8k3eEP5lEHLRu2O98noNEtYhPNOH60gucKC0HH/5SYgwDWfWyPh?=
 =?us-ascii?Q?UDOChYDKWtHHJVKq8pNn2qICG5JOYV9Twp45sHliRpnWlRhVAFbNW9oX7UOY?=
 =?us-ascii?Q?Rcy5+KOFCf7yW/G8xftho6C7zQUSuU9EfI4t3JomyzlfUbEv2vikAAyuts3X?=
 =?us-ascii?Q?TfA5j6tpcySo2+/8jsLZAhoI0yqtfKJRyLsznrJwIcY5pZHTwDCcDGEXMZzQ?=
 =?us-ascii?Q?CPAdfftGXnYum3/3+Cfojy08z5JOjxvsmck6E2KK07z7fZgHxyzUWcn8iAHQ?=
 =?us-ascii?Q?sybSdgGT1HR8vSbV8RhXMzK34cxPfFUDNI7StNlFfQEMr3xY9P1AskL0r7xp?=
 =?us-ascii?Q?hnuS1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PfgoaQ3bNNvD2FeaPW6s/mOS2uwM7aMVCOMI33sdobj0R7dQOjJfoGcwiRnMf357ifg8JUVQ1d3RK75LYN4sqVA9DtBFUplxqLXRtz6iQ13hZOt3+jsf3R75LJq5MNNpBAod/YS2+I0DTMyJtJ193ZFFvb94HR4AfDs173+HdtNRUXQlrE+VArXNqBPMBb/2vU0CHLS1STO+bJeEcX2NqJjamo70t6lXGPEvavdsuRfl3U5nVxsH11A8HrQVaoH4bzfJlXKY5FkBB599NexFluPLfvG1HwY45Dl1In5HGa2BodI04PSpe/g9ZFuQjB3ZrLpUB0uWH8gEywpz0K1zKcHtdV4+pyCmb2kbg889+GAVZZb7CY0LCR/04+m1H8dF8nR4lnQ7dqG7rG2FwiZnMqj9gbVHrMG4ZIPruUAgVlSSEut6Gfj44/M4o1F67Rj+/nC/d/QaEMHqDzIgARcwO6eAFF+oZVn9PBaOQnnG6FMvIZWU9Oh9cMBrR5btodRu/FdBBl7DwzigchnmetvAnSy6zHlzpAxXkSnEVsAOyTlRoOiKIkXoo4JHpCJyvBz5PkmOyNRhuJOPypJKxcmhHtQtk3zCRQcBras8fi80s5g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d350fe9e-a1c0-4195-c765-08dc4d18076f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:57.9664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X79lN3hiB+bgGdoI30+Hfj+LkOUqnV+YN1WzSj8+fzdAZGcqQSm+oyfVQLXxrx0iBNWeEQohTXyus52a7zkQ/i6Jg9Q8EKXuzrSzrpgCUfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: 2tJxvSGn0sULF1nqqrY-5dUPZOGwSBz8
X-Proofpoint-ORIG-GUID: 2tJxvSGn0sULF1nqqrY-5dUPZOGwSBz8

From: "Darrick J. Wong" <djwong@kernel.org>

commit 4c8ecd1cfdd01fb727121035014d9f654a30bdf2 upstream.

Remove these unused fields since nobody uses them.  They should have
been removed years ago in a different cleanup series from Christoph
Hellwig.

Fixes: daf83964a3681 ("xfs: move the per-fork nextents fields into struct xfs_ifork")
Fixes: f7e67b20ecbbc ("xfs: move the fork format fields into struct xfs_ifork")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_btree_staging.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
index f0d2976050ae..5f638f711246 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -37,12 +37,6 @@ struct xbtree_ifakeroot {
 
 	/* Number of bytes available for this fork in the inode. */
 	unsigned int		if_fork_size;
-
-	/* Fork format. */
-	unsigned int		if_format;
-
-	/* Number of records. */
-	unsigned int		if_extents;
 };
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */
-- 
2.39.3

