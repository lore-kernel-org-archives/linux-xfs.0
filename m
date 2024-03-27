Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7426F9F7;
	Wed, 27 Mar 2024 00:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498410; cv=fail; b=g86ZzF4kolmBg0ALAaWJkvKcaf+PXKGT8r72tLkoozshko44iVBcsAYoHGt4UTOOH648M+XL8Z8FZVmfSQ1DhixhYw9ctrfLP7oFJ8cYlgH+IzR4/BxNQTkQPk8kI9ft8CStTB4+nZI9Ppex5EzKbrkNdpMWFy+F780tEfUKaG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498410; c=relaxed/simple;
	bh=Xl3ij5vj3g3Xvjy7TGZDZkQlBo9UhYgvTFd6VlkgLnE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OfO2Yk2eTaGUpxbfcFdL9P5Xe1xR/RS6Q3/C2oS3PpQO++7OoYKxTiEz/Wu4w4Hm2kIezqGLB2Qv5MP2HW93H17OjvAN2gmq953u2tft0p69lrZMD505SwAv/w7qqkiTSPGg+J1i1wSvn2U/dtshsWStIiAS5dg9G7+o7O1O/8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OQEvAzIZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WAnKhBQG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OQEvAzIZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WAnKhBQG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLhvna019967;
	Wed, 27 Mar 2024 00:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=s3+xY8r6U2UecYNiU8JL03T8NpVxJvCwudKQnnJJ3Lc=;
 b=OQEvAzIZRvT9Af5DYG8YnMdvagY/biSufetaHc2jnFymmQlSNe2w5GDYWlQ5csIF1tde
 rwdcLPZGWsPnywEc7UmwOm/+8aFMwYG0TaY42x8pzmvEaV2LWGeMVuDYjmV3+ZnsRvKU
 FKED5hjbUfXdpwCBdC+PRyWlPk4VQXxPSs10hqVDhO689UdTEzwp50uo1fXel5UuuCq8
 s6WpEokxt/VXYCH8g9dgSGxNt5dM2lz9X/Z43P810UxefHXNbVu+U+wO6WNWQ17srqQb
 EWYi43oQ2DGw4kStb7ZbnCQEKM8OA4zKUpgmHouPkqZJSN679tMtdRN5Gfo3jlfE1zoB GQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1nv46adb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R00j6a012418;
	Wed, 27 Mar 2024 00:13:27 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1rpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsyVTLKkzhTS/aG+4D0bO6HK+ABu0kUjghPg0sHIs5f8Lw881zEeL+H0JRJdxeEdVu+lPULsDxUzv0yghfALTmSdicq0R/5uglw1qZUbT65LRNSVMlyTztIcxD/g1Nmh8io9kMNkVpahxKzF3nPQg0NE9bQqMn7dlp0lMqDldabfcYHse3dCyzWLELlnBKp2VgSAF8FVMBIGoCc6SkdI6WhOn44dauaetTWOtX8lW1vdVziZK0NzjEwOrhXEPXKc0pHh+Vwmm+hErP4CAk4e/KA1E9gEwL8dqv1dna+4eotjqxlQ0Uc0O5hXCtEvCWhm7F13+3GVl7rCqDIU6/Zoaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3+xY8r6U2UecYNiU8JL03T8NpVxJvCwudKQnnJJ3Lc=;
 b=RzMHtxAvxQCdxxhsmhYE5Kfrw9EpV8JHfwvo7L9y9E70iSua4n1cMYdMIcmB3FJUI1qCeDFbrdImMlPXNqA5jPrdbqus79vtj/8GGX6a7zz+pZ+pdFYQepiO04/9We8EiIonRjkKVWbwCwnbHO7iEbNl+Al7N1id8qAkbMCIK9eQ6LTCp6RVuRkIXaenexiH608tgEkI719qCu8c7Ybq4XpR2+KtBySNOYWdg1jZmaVYXdSG1JjK+F17M46jqCqSin5v+aQCsMSq4n/vgmsmPBnvyzseI5E6DyXBipYRQUNu4iAJnp+FRj0Y2/ZBODc/MFGsk3mtq/EqssYYjiZGuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3+xY8r6U2UecYNiU8JL03T8NpVxJvCwudKQnnJJ3Lc=;
 b=WAnKhBQG7rOpSXFiDieDiqqLnkZyy+rIQzmonY2REP1lFNzy5cGm4mg1QB/8Rwt4gp9QurdAPCyeIr2zBJsH+keSeH0aFRJMq5s57ZOv/xSGx78adHoI3/CAF+lk1qdwdabhfejVy6LjCBjoYdQfxG0tRsai9fBkHnibMn4+sHY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:25 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:25 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 21/24] xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real
Date: Tue, 26 Mar 2024 17:12:30 -0700
Message-Id: <20240327001233.51675-22-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jrpE6S+mZ1+E8VAP4zj5L2XHt2YfT7KgCtVIbZtuQWD+otjlUUI3ncWyaiBJDNsBQ/TKGSd4cfZWMpc9YIsbRaQhvnSa/YC5PR0pszn8wyEg684e1oODz3jJkYTQ0XAvpWe8EXXViWUVT9lTvw1FMoYWdEFGNzDcaBZju18c1DBApzSPkDkz3SN0Cx+9zdvJSh3eqtId/8Ch4ZHqQL2K+dzqQYXVwjkcJ7+Kp3nBzOcIfbAeJ2gMu6ZTQPJiqSrYKCndg/TtEzLbSjiVQ7S0cz/YeMCdjnsx7mk3aItSR4KFOLeODqpNfP2TNo8zYiOhvovjotgQk7wkyVOdoX3Pefaj+/brNRlDpyHG5rP5WmRxnmMJO9SWf2IDAN/xlvAoSIJ+joWb0M+Dy2JtkDjpyecECtqs/tL3ZaZoQEAO7htOWbJuWPu/Cvqg4aKr0KXIUjdEqcmIFsjJws6+2tCyVihlipFqPuHqKHTI68rhHObaEHmbIA5CbJEl+xuhz6pFqt2RVBo4DjhOAYINcQCb9eUfWaJnJXUiENQf8C1Zz2UPhoyFDiPe2rjcGI0xNDU5WPNUcyhotI4kPHIbfb5Z5IbwlRI84pkXL29nfjs4V3p3UxmvWmHmehXh8xG9WxCOG8JeThwQZyEnLWQjUpXr4VwYGZu4dGdjOeR9QeH1g7Y=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?7alLr2lNjCRxDR+TqAG31SG6CAD+/r9A1gqJEU89HWu057neQ9BfCJPAljxB?=
 =?us-ascii?Q?teUOKGxKKVGFCPLTUfK4gCaTPKh1rFKcGmDP3E+QnuH9EnEPcoItBWsXDgum?=
 =?us-ascii?Q?TZNCkX8T4UOi6n6fEAlFMtx4LrBzixr8eY+lwd8E8BryaSi9NtFg695s7qXd?=
 =?us-ascii?Q?tXIrAZjxH2K2G+uIPzQEcFX/UAvwzAt9UBlx8AMA3HttgTw76xnEhk+q5nxe?=
 =?us-ascii?Q?6x9WVNMF83K3OuL8ayAhI83FW/XelncJhv8UUHzA6Y6B/29ZwMwmul1QGFxS?=
 =?us-ascii?Q?R7+YvdPvHLaJWt9O/xYs5ROLhSynQ/MG5yjy73WSzSR4UpfODrfc5S7+NApZ?=
 =?us-ascii?Q?ATlNzIZ/XSnHhqxFRKh3ajrif78OT2tRrTGbQKaaplEA0l4kqWrbWQtWcOtk?=
 =?us-ascii?Q?bnzqqER7tOprOZz7KQY0HXmiMG9EafxQhdy3QduG7CFIW1oZ0BjbeAf2R+gg?=
 =?us-ascii?Q?j57HU54G+5XTUEmRI2cVxNQRDaiShb4tFdWGFKqLkVKp1Li/3pH424JncC9D?=
 =?us-ascii?Q?5pA7oEEq9HjV6QNAp6rlu1HBVURDIQRcoT5p5IJUpn8VVZVGWN+L/445gUfR?=
 =?us-ascii?Q?iE2QXBMDj07hj7cEHAD1hfEhY17qGXQPf8im3QK9USEKbYaQtQVzI8K0MacX?=
 =?us-ascii?Q?5zcEMl17Jgtyujs+03VBaiEFnu+8480OU3YMVgBgWkkMoc1MtSEptN4s/yij?=
 =?us-ascii?Q?Ae65VBePNEuU3JjIuO5Mtgwjb2gDy0T3sCEocrtY3/YxAAUTwCMaD5Q9o+P+?=
 =?us-ascii?Q?GdrxlIUunv3I1j5bktpOHbvJDhw2aYAcq9FWY3baSQP/3kKJCDbPOX6Q/RBR?=
 =?us-ascii?Q?j97NdFRKNHdgTH08ICs6cO11gv9r93ytl3gTBDG8IWStPIyYgOETZaqwoDx0?=
 =?us-ascii?Q?mnDSqrIXa4aFWW+Vg8VbbFjFTPsdtrB+8+b38udQyy1KyMmQKoSZlDVJJX8O?=
 =?us-ascii?Q?LJ2yOwKO1T6hASMkG2GmThENVoEt64sm6URZSZRa3fC19xIHZ/weR9CRSSTO?=
 =?us-ascii?Q?x8bosA7FXro+lpI1qKlnVSDjMyVHYbfzEpFryeyj4IDB3eA/ClUPEl+IxTu9?=
 =?us-ascii?Q?cst4L7IIej1TDE5qTC+MP3n1l4JJb8qX6UaBlK2p0uz9c6MzjNik3d2L988n?=
 =?us-ascii?Q?pydy5Q6bLSt3v2r3W/rWt4hYtVt89zFjgw1W+A8YSY3iJA64GhzasrHYSyme?=
 =?us-ascii?Q?uBzPlQisKyTgVDKOl0WR97DbLVNJyPy/0CswmbkxWHXk6fAadzGN8+DMbwvP?=
 =?us-ascii?Q?BbK/X/qL/DuZpfzhchfzl1/C6tyJvBCfki+jIANEm6lU7euZRmKbzU+ArBFq?=
 =?us-ascii?Q?0iRyczopT/RBl6hndGs3ro/PVyZOgwF9Odu4mB2kRdNtE/eC+ekptcj00hZH?=
 =?us-ascii?Q?gFr3f+hspNzs9ZriUSXXR7Ek66ryrS5Pu356IXKAHlMwTUCDyrHNJug8lkpQ?=
 =?us-ascii?Q?IyFOov/MROk+r3laYF1pZgAcR9/G0Uv+ofO93osHgrGx1RbR8d+JEqUn+J2K?=
 =?us-ascii?Q?QWrQeJwtnExUB2RxjE+5mV8TvvxP7skdhS032m9KW9fHrLajMwLMfoavFf17?=
 =?us-ascii?Q?MBOWyqoArm6f8vHtoTPTx5sUP9WHNEWAVz1cJJbxZq88SPx0pd6W6D1Utr91?=
 =?us-ascii?Q?ncbC4sMoL9CztkjSkKN+Mj/JMfHJWYMvItXHsPv0u8lBVjHh8Uvgl3lWAFtP?=
 =?us-ascii?Q?zPZauA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	C7opM6U8LRaK/RHFhe2Mk92gtau+uvOWT833Q6iJmUAMRG1SEmjEtrt2HAsNajTj0tpolvBBI7NU9wAUtpOOnt6NpOs7AneNyOBHJN/j/BX+hC1fGzCBvrOWMiy+O5mreUKi28gGwx1IhrsHBDwUI9N8JDjsNn0V7cZMnttdNvFbF2+Q3GZb6Ht6soigl3GDNk6Kt79jI3CZzGG4opSJwcUUemZUcPx0vYOYA362bk/AycNiY4Ayv1JIfMoZqpZuCC/3JMPz1OcrIheoKFCA8m/mLf/FchQHl7V4xBr7k9DB49/dmoN6SfmsxqvR9R3hA7X/c9bIIGxS73hrSAVUXX+FHJpmWPz7eXeKUhy0r6eFpia9TGjo8cRbBymzrwIuWbCLJ+P9Z9NtQ2iIAubZ7Yj77Lyh8JIqmRVZZTezz9RRq3oMJY9LW98+OsfuZwvRbIgLpT8landwPZT9IqyfT9qfIxSbzQzZUcZj2XzffBy1y0KKvbzoYoehOz1pkENILPFoYwDXsfuxyh+YMUTd6jdaCvKMoL21LoL+O08qin+mJu2o7Eysfc7r/LCbJPpyFdDwjMiZlfYRR++pCthE900+kl4LNkhyE4UcOgU8ow4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d3e2b2-89c6-4e21-0687-08dc4df2b899
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:25.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vm4Ub/cCa2Ow/gVWk5szcwnPY4/mIN/kHeY6M/Y+SCO//Uf92zu8SOlU2PM/F30DVjEikrBR++2fDBmdUWSUcMBbah8RX35S6QIauB84nso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-ORIG-GUID: sN2zaCGeRBpqid1rTKvs98tcmustxNOU
X-Proofpoint-GUID: sN2zaCGeRBpqid1rTKvs98tcmustxNOU

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

commit e6af9c98cbf0164a619d95572136bfb54d482dd6 upstream.

In the case of returning -ENOSPC, ensure logflagsp is initialized by 0.
Otherwise the caller __xfs_bunmapi will set uninitialized illegal
tmp_logflags value into xfs log, which might cause unpredictable error
in the log recovery procedure.

Also, remove the flags variable and set the *logflagsp directly, so that
the code should be more robust in the long run.

Fixes: 1b24b633aafe ("xfs: move some more code into xfs_bmap_del_extent_real")
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 73 +++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a47da8d3d1bc..48f0d0698ec4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5014,7 +5014,6 @@ xfs_bmap_del_extent_real(
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
 	int			do_fx;	/* free extent at end of routine */
 	int			error;	/* error return value */
-	int			flags = 0;/* inode logging flags */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -5027,6 +5026,8 @@ xfs_bmap_del_extent_real(
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
 
+	*logflagsp = 0;
+
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
 
@@ -5039,7 +5040,6 @@ xfs_bmap_del_extent_real(
 	ASSERT(got_endoff >= del_endoff);
 	ASSERT(!isnullstartblock(got.br_startblock));
 	qfield = 0;
-	error = 0;
 
 	/*
 	 * If it's the case where the directory code is running with no block
@@ -5055,13 +5055,13 @@ xfs_bmap_del_extent_real(
 	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
 		return -ENOSPC;
 
-	flags = XFS_ILOG_CORE;
+	*logflagsp = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 			if (error)
-				goto done;
+				return error;
 		}
 
 		do_fx = 0;
@@ -5076,11 +5076,9 @@ xfs_bmap_del_extent_real(
 	if (cur) {
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
-			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			error = -EFSCORRUPTED;
-			goto done;
-		}
+			return error;
+		if (XFS_IS_CORRUPT(mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 
 	if (got.br_startoff == del->br_startoff)
@@ -5097,17 +5095,15 @@ xfs_bmap_del_extent_real(
 		xfs_iext_prev(ifp, icur);
 		ifp->if_nextents--;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
-			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			error = -EFSCORRUPTED;
-			goto done;
-		}
+			return error;
+		if (XFS_IS_CORRUPT(mp, i != 1))
+			return -EFSCORRUPTED;
 		break;
 	case BMAP_LEFT_FILLING:
 		/*
@@ -5118,12 +5114,12 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
 		if (error)
-			goto done;
+			return error;
 		break;
 	case BMAP_RIGHT_FILLING:
 		/*
@@ -5132,12 +5128,12 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
 		if (error)
-			goto done;
+			return error;
 		break;
 	case 0:
 		/*
@@ -5154,18 +5150,18 @@ xfs_bmap_del_extent_real(
 		new.br_state = got.br_state;
 		new.br_startblock = del_endblock;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_update(cur, &got);
 			if (error)
-				goto done;
+				return error;
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
-				goto done;
+				return error;
 			cur->bc_rec.b = new;
 			error = xfs_btree_insert(cur, &i);
 			if (error && error != -ENOSPC)
-				goto done;
+				return error;
 			/*
 			 * If get no-space back from btree insert, it tried a
 			 * split, and we have a zero block reservation.  Fix up
@@ -5178,33 +5174,28 @@ xfs_bmap_del_extent_real(
 				 */
 				error = xfs_bmbt_lookup_eq(cur, &got, &i);
 				if (error)
-					goto done;
-				if (XFS_IS_CORRUPT(mp, i != 1)) {
-					error = -EFSCORRUPTED;
-					goto done;
-				}
+					return error;
+				if (XFS_IS_CORRUPT(mp, i != 1))
+					return -EFSCORRUPTED;
 				/*
 				 * Update the btree record back
 				 * to the original value.
 				 */
 				error = xfs_bmbt_update(cur, &old);
 				if (error)
-					goto done;
+					return error;
 				/*
 				 * Reset the extent record back
 				 * to the original value.
 				 */
 				xfs_iext_update_extent(ip, state, icur, &old);
-				flags = 0;
-				error = -ENOSPC;
-				goto done;
-			}
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				error = -EFSCORRUPTED;
-				goto done;
+				*logflagsp = 0;
+				return -ENOSPC;
 			}
+			if (XFS_IS_CORRUPT(mp, i != 1))
+				return -EFSCORRUPTED;
 		} else
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 
 		ifp->if_nextents++;
 		xfs_iext_next(ifp, icur);
@@ -5228,7 +5219,7 @@ xfs_bmap_del_extent_real(
 					((bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN));
 			if (error)
-				goto done;
+				return error;
 		}
 	}
 
@@ -5243,9 +5234,7 @@ xfs_bmap_del_extent_real(
 	if (qfield && !(bflags & XFS_BMAPI_REMAP))
 		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
 
-done:
-	*logflagsp = flags;
-	return error;
+	return 0;
 }
 
 /*
-- 
2.39.3

