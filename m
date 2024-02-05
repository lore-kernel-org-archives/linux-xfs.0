Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006474F202
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171664; cv=fail; b=QbxS4FbNUpOjvI12pZrgt7WcQ8YPCawGVf0FhxBUBd9vb1UySf1ZbqgO1b/VdAaLI0a70pu2KacuIsjnCU6rhBe8XSAfrDrd+x7qgM/uBurZlK6E8CUP8XiYYRNL/WX/Q2PjK4n6gS5Y6PGeokfJHsilL3uYA1UHVl4oHdUwyrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171664; c=relaxed/simple;
	bh=ykF7NpnQT46Jks4gfz8eLGiyCdlQem/AcbuOhppl/6w=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ODgHOpCJJaJk24JVi8Cl5Y2TnRNLLULOwvm48cqFPxyj1OcwF9dQYb33daSC80bxQxNNZDOgsgk2NpYqFHt7SGDPy2Zjsu1UPM5Roqfs4W1o0X5gLE3wztJHNVVhwdll9YuVVaGr2J1t/EOmmbVnCPA+9pPNAA4Os3QZVVkacEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mKUpN7K0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nGbGoknK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mKUpN7K0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nGbGoknK"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LG7Mr020854
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=LuMDbYYENfwkIa7wnMKemSJhWngTnAyZfWqQeSr9hFo=;
 b=mKUpN7K0dHwqQGgmuiSrbIQNf8vIYHYwYVS5C95ALt+5OVy9XuQpHdIlML4p/HABwksS
 T+eVlmmYrEuF/RYE3g3nRFbWF6dcDtbjWZh1iP6tE63JLvKnmMwzvCEJwhmXaTYZiV4M
 SsLDhge8FFvHK//RQSOXCWQ+ujfis/danzelWXxUQuOyx7jaMj64cQXjRDjr1q5gwhWq
 2fPEUZzjI2xN+HSeh3mHSLY7UnrHuwrcTnS8PCnn+Jaea3gTaE5juk4MHRjT61qKL07a
 3sCSjdrl/CFkNgsoYaZl7ao9YMUaqFv3cdTC6h97bgZnUMooOF18/P3DkHNuuWLnLbLI ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dcbd5bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:21:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415KW94X039512
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:21:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx66890-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:21:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjetKDmRZYPnBErSh6epZw28fwYPkMerfeENw8yZm/EZ+GgSTrtLKAs9jt3GbORQPfEAQ4+MIPPA5ppfO5wOqrSOvAoQ+t4VP0C+81mO5PWFbR/noDODMoivqSvtzglFU2hwtEpBwTGKTwrzusfsnzffRXkFdGVKGsSVrj7lQXLgPVE/tbyyrss648PietAOTarfisQqfufgw8Jp2CPasFfq2L0ggcvlBH6xCYLiEQEOdRNsZKWKPykygwjerFaP3xI0pRIuR0c9qzjJNCRotMdntRvjX/OOBboXlkQpw9iv+6W552BpEF2mCeHPErbnS3zyMyvzYmTi8M4ewBsN+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LuMDbYYENfwkIa7wnMKemSJhWngTnAyZfWqQeSr9hFo=;
 b=M7VV5LBfvvFf68yHWyyRzVwxUg5qPS3RMBE9OXI+kgidkmdqlqjiUUrJYvnz+OxCPXIoCfTChNms9FExutk4WgpA25hxWgcWY/4Mo2f4e92xfrdI5CqwNGvEBA+wQIW7viLNYyFGEPtItCT2k2l8WkDHQRuUj37KslMZHCzakQa0pdXz9jE/cHn886NjtbS4R4SuFDjZenRQ6Tp52vyGePB9i/Nj2kgKp5BhWARnjBF17nU9ytrkM4U51A+49vhb+3cJqlJt41vDyL6Upx3xDEkrdpsgaVNnyWWnUPP7BaV+aGobTgKcZaMOww9zZaAd7goNwACxmL1IJCVS8UQuEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuMDbYYENfwkIa7wnMKemSJhWngTnAyZfWqQeSr9hFo=;
 b=nGbGoknKNCPCe1fQolBa1JWu4qhP0SQreHsVQ8RjQ7Q5uP4SZuIAaHLiXoBJk+vvJ+wEUoXasFBM5OuW6902L0uUK0i+Lwr73nGgmS94nQKXBbMcu9m/0YebORsnv+HRFZ13Xv2emcJ0sy8JNCY2FwetQ3qhGOsdFLbGnVwZ6yE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:57 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:57 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 19/21] xfs: dquot recovery does not validate the recovered dquot
Date: Mon,  5 Feb 2024 14:20:09 -0800
Message-Id: <20240205222011.95476-20-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0274.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::9) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc8b671-ce9b-4e51-a03c-08dc2698b9a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	T6x99DFDEpCl7dbrei76YU27VtL5UPZkwucQe7d1DMfefffhuIU9t+6i7IVcR19LDWH10LIIm9cfh3worxkOkfLODtU883Qhzz1g7Q1DxFdR1yIrHLhgKh2pUOr4GwhOGCXMnTsGAvRTNmvxkiEZtIOWmmS2iSWm/0eNfiAt5vaiLt9EZktLN7q1EpRwAeSQUvFft61iatWIZ2nB+fieQM5GQjB+GHhLdoCBqRyu+h5d4TX51aivEmjcFgH/ssnD+BDqveT1sjeWKNSWBU/LmVNOAsORQNgErinxvYlvMcFP9Pc+Fms1ryqwtCV5k+frx4EQxxgj/oVJZIBEnn+LH1PE7BDjz0H/VA8xF5erYSAm6XexuztB41A+agX+7DkyN20nTMlRDBxNcZkb8o6SeiAhUz2I7ARSwnbeGpiDqWnLisdAqXF4zJLKmFvp8+/JJounGNUHQkYdFYrGNilCUeNVERNRAu0694mADvuWEq/j4Ezw1jJcJb4IY2MvXsMZIiDp3rq3pxUoZCc5i34TOx6ue3Xj/iqmaAEldL1M7YaP8UpFf00CucWRu+TBFQCS
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(15650500001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0Eu9R55YvHtvjpa6Mh9Aj//AVMzial58ufI218HsQ/LFr+wXG988/IyvPvY4?=
 =?us-ascii?Q?0OTwBwafhAI5n/QV4Qej8b0+jycUK8QWaXbS4t5+3j4u5B3NwYyK5ywt9Kji?=
 =?us-ascii?Q?b8GYOMP+/9SiKhreauInYmLfaZuOKQpIh6UEvUAGRKlsIK1SaHKmQLV0jmHa?=
 =?us-ascii?Q?zxLqPx6gb+XT/uTqr7eejzBFkKVaMwiTBt67y+pc1LGJEckWYe2nt5AjV9/G?=
 =?us-ascii?Q?bnVDl9HlqFMM8nK7Uixrp1qLvKxFsESgBQfIZSfENcaTOy/TYzMKbz9w0gR5?=
 =?us-ascii?Q?QtSimZvI1W2ZvliTsvltW9u7DDq2+6QfN+I2gxViWsinZ9RgP2/rfIE7Xznr?=
 =?us-ascii?Q?9LBVmNg7W5pitBozFiDMY8D1tLAwBmAXB0fqMc6/I/8nyEqEkFBAI4xErcoK?=
 =?us-ascii?Q?mKc31ligu8x8pbxFZKt9xSNfzbJld6l1drJNal/+Rz5YJMz/HzzvG61Pq2it?=
 =?us-ascii?Q?7DWl1ddBINaPVUzM2bWs7Ew6niDvbrMT9RGnA/sW8TkoDipJ302TmA3SIfYk?=
 =?us-ascii?Q?NCqQIDNI10lBiDBCVgK8803imlvYGEcO4MMTWKyIpeKjzeEpS/H4epzGopzu?=
 =?us-ascii?Q?jdxCkMkmTbc5uwZeFavCv/uGydKEMHd4+7u/s/gfGjt+CPz+8N4P4l7Fwo6c?=
 =?us-ascii?Q?VbqqIYLQ/uLcWV+3GB69nBkJUYD63XGqbcSiziSJ2c+PeabBoL1LctDROF3D?=
 =?us-ascii?Q?IJuadM1ivJjQhfkHkN18bvl7+Xb03LKKK+1ltMGfDEe4Nl5Yl9PJhJCjpdl8?=
 =?us-ascii?Q?j8My8s7mQO6i0X7F1T9t/XGDQZFyqZ1zXTmAgn61BQNDEGDz3n+r6oljDATK?=
 =?us-ascii?Q?faBdjB++gIF/7L8g2h/ScsoMFjIgYSsd/X08pgdBsUwR7GUk/7rmzDM1hFNd?=
 =?us-ascii?Q?pgyrmzKqETdtITwpuH18U/MX00F3UPB9Qars+OrANL8SooT/92WHDXT7DQod?=
 =?us-ascii?Q?yy2e8F+HaSrsua0qSvUBT0FIpS9QLha8OvXEnJMTdc1kN1XIWwPgQTCoQmVi?=
 =?us-ascii?Q?UI1GC4OBEHK0r7c6UDo2wg2imSEw6hjL6jBw+wRJGIgSKldZVpNjP3yLJh2m?=
 =?us-ascii?Q?dqlWOpTERPwBf6ezCAlPsgatih9Bo/ZvVUrc+6iJY+eVVnhjICBSaI3b8U+T?=
 =?us-ascii?Q?XPP44y83FRJkAGseLO8LTmHFivZK/CYI5ak1B2A1hleboXG4rLqSU0n+8N/G?=
 =?us-ascii?Q?sujOwVYsC99UB/7MQ0QcfOv2j9/G9AghOD8hVzDPPXrgVuXmye180IjLix0F?=
 =?us-ascii?Q?iBahPT2IhaUIEjx5CWPlg4aqPI/IC2Zu1h5F2KG8pi+OzTc+EvnaeO1k1RW0?=
 =?us-ascii?Q?AnvPU9eBWGfVnf4Jd9NA2q6c4mIcoARlo6zjoFudMZooT55Cd6+Rw9V8B6oH?=
 =?us-ascii?Q?aLKqLBQEmslPosWO66IvPvDsuCo3NklhDIpNoGU9/aSHUqdPpY2PB9syiw3f?=
 =?us-ascii?Q?X5uKnSc3TUClEYHXTOd154CG6PjvRjili6ohOnGmS9WJsz800YPN4KgvwxOV?=
 =?us-ascii?Q?RQ2g4X+hOy0SvJFomXjg1tMfslD4AN3x2UGFijgIp8EMCvnozTCuZaG+xpoy?=
 =?us-ascii?Q?jv1Qt7dobhii3Ido7qiAwYgBAdtZ7BeW1fjXtKVyyre3Kv1BPPCC4Sd4xnnd?=
 =?us-ascii?Q?det/EcqP8fx6m7kXs3tiwUGHM9abE4eqok9gm21dvH8ZIFn8BPD0EcS7JTxr?=
 =?us-ascii?Q?HG5f3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+EejGv4pkoCq4OLwZvskC5kHj6Jx5mY8lo8iwG2kmNlfGX6LF+WC0xyfjYvSg0XQGicQw5Fnrj094PGi4bY/ebws2eQLbQGXjFUKHdB/JR7foJp1LvtFZp8XFblmNBknZmviTVZ84Be8dFxzI3cHAvLi7eOseYTr44vcISOgUsldp7dSfi4K1JZsEJv1hd4OlKULlq+GZAMT76nlhinHwK7PPo+B2yzBiAM2Re3E+ihfK417Yv8/Q5mXu+oONOuycwWT/tzQvTBCUIja4Rwd0tY2meHm1D47x/lYAJ0U2XwIxNRoNp8pBGNFuI5MzBTPH3iBiH7RZaUWUXYlcwOG9zEO5vTdak272j6osHtA1lDjAb9RfH1BviQ5u+mcWMeK5kELRoSPDbydAxUXrfm7M0WXFBDPMmOO1oVOaKCvCaa3ttkg5KUkzS24Pn8AvJeZ2bCE+Smz91KxJ7ANXkPU1V1Smoj1qiTgiuiuWx7GGbmjbHYQ2jC3rUfyRuc//Yv8oK46+bKaS+guPbRsZFuxaC1AdkTaZKsCdCxyGhGTYi+f+6A+8ocPpPvxzfQzKsFA2YI8TGmL9WstgIZpmputYR8qtv6keQW46Xa9hdfZgU0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc8b671-ce9b-4e51-a03c-08dc2698b9a9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:57.3167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tdzKQ9wF+MorFjN+ftgpKi7d7bAeAUWcJCKB9HsokHOOAIBAT1H/M4f+DR0Oirr4Oq2nerPAkDm03bERBgWinymR2IFPXDNN2Dn1K2O7R0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402050168
X-Proofpoint-GUID: jKyjHqvylAWGHk3uxyFraPv28t2eIq0D
X-Proofpoint-ORIG-GUID: jKyjHqvylAWGHk3uxyFraPv28t2eIq0D

From: "Darrick J. Wong" <djwong@kernel.org>

commit 9c235dfc3d3f901fe22acb20f2ab37ff39f2ce02 upstream.

When we're recovering ondisk quota records from the log, we need to
validate the recovered buffer contents before writing them to disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_dquot_item_recover.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index db2cb5e4197b..2c2720ce6923 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -19,6 +19,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_error.h"
 
 STATIC void
 xlog_recover_dquot_ra_pass2(
@@ -152,6 +153,19 @@ xlog_recover_dquot_commit_pass2(
 				 XFS_DQUOT_CRC_OFF);
 	}
 
+	/* Validate the recovered dquot. */
+	fa = xfs_dqblk_verify(log->l_mp, dqb, dq_f->qlf_id);
+	if (fa) {
+		XFS_CORRUPTION_ERROR("Bad dquot after recovery",
+				XFS_ERRLEVEL_LOW, mp, dqb,
+				sizeof(struct xfs_dqblk));
+		xfs_alert(mp,
+ "Metadata corruption detected at %pS, dquot 0x%x",
+				fa, dq_f->qlf_id);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;
-- 
2.39.3

