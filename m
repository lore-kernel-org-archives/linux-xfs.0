Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C18571748
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404470; cv=fail; b=VhQaf5siqZE7xNsJtJhol6WLn2eLBun7HadPzw/iCeRmvE6Kx3UQzygGvBmpzH8TeRyTg0J4/NtRpQn5UcV/I2lKmrFOnq2kbx5h5My6o0WnrSaNpqqUq5bF/LpGb2ujioMsrKdLFA32VyUSDUW33DZs52xaCyq7D4ofp8zGnmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404470; c=relaxed/simple;
	bh=ZwpwA3RCtI3kbM88WL2iOuS5Mi8L3TCb1KYatxm9Ec8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kMrdtDe5cUlkXH2daTOX/XWOMN7K1TstgHhv64A9RWJjdZnXuMiXawPDjSGkV34HSw3TUNSMaIWkeSoAaZLBUjslmAHtKChP3xtEFL1tIqhGlLiwd5Zy2DecsVHskQWv14Gy6Ozd31m96AeQgSYhqbzp3UkcIDIUONRc60M+Yx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NYsy4Bgv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0P7OUOFC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NYsy4Bgv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0P7OUOFC"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFuQu012492
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=V7CJgXfDpvp91R1e7WDQf82WN9gj2dH+OTbWByewUTY=;
 b=NYsy4BgvUeSkfmCq9mVsLp+7KyD/3tvodfmUY6nPkUFxrY2xXavY2aqQQEPwPNwvADtL
 N2DDpNXUJ9u4eNs0fGNEBjgwIrcDvE9E+S9JlD4pqfoEJt0NFV6zHmNWeRpO+5i3073P
 pwfaTEbHAcpWF+gKII23f8ymIfhGenffpqU3eC/a1oaqnzxL0PG6e4P+ydMqCo1Krsch
 W5Mwk0FgIt2pTr3FHfpF+2NMGi9TnDoA/lBzCLg7JcM/8/vrIrDbI2JAKKEO+kxFH4ic
 k40A4v5PP2xduxGQSeE4Wu1PjS0xAy2L35aH+Lxd/quytyJWhmLpPm2AQJXdRBQkK+nn HA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gt7e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKNWnh015902
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:46 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17012016.outbound.protection.outlook.com [40.93.12.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64r3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDxPrJ1PalAZekUADo32sjueDwOuPxS7+khs9MULYmDidns7s0PiH+/CIdKzgOb+k9pX0N5VV4eLUireUovv6qjSgpPFZfM9qkk8Q0zIyyMxuhKiVPhFx7bsI7OdtjKUtPqnZqYGE/9/NQFEV/ZdPzsibaUxxDEw3d8hzvVZk2Jrn1SuV/cf2GPBqDJYMaHKT5rH8op/IQ9GATZEiw2n05gfW/HpENH8ipfI4mGRYtOu7pXe6YzEZ9pN7mDlIl8G6TNM0lvd2tNBh3w27xJyD8P65tnYG2SJ0M78nxYdO3pAMuyBhBtl59Sqy6RbjkWFUqmL3MG8d/k6qLrb3I5W5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7CJgXfDpvp91R1e7WDQf82WN9gj2dH+OTbWByewUTY=;
 b=AjqmNQ7ne1sjKO4FTfk6NBpLLTDW7ZJyZfLimu56nE4dc52nBvAjpTy3zAzW3VECzzcMhy1h9YPozwkmuveUh4Ji01Fdkj+z97s2RfEzhY+zzxOZgLpqrQyVRNu43uOuIYOucmoqdd6ddbXBhvDWfAtga8/Lcf2Gzki+V8NY709nGUHlBJ0OLNdiOu45/tIcQ437L8wjoS3wiKt8SmTu52Srz0WMGCBSz5P6byMGXoAo5hsMaPf4c/GlrjT+W2VNEweeI2FMDkBVX4WiotDwBAUL1n/ZU+uTcYzfxeurf+g0DlSbjEkZ4vwaANQRQivmcR/PRv/qCPN3fUdZKeAaRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7CJgXfDpvp91R1e7WDQf82WN9gj2dH+OTbWByewUTY=;
 b=0P7OUOFCggd9RaGF3g2iqNM4dkhEowJa2VOK4j+Lzn14x04K1xM4WVgePBtgWTAtqAEF+gj+LcMZLOYBlRXJB3pV/17YxbnuyxYUAu882fB8jIrOkTid7S4Mwl01IX7nukPzMi3fMXXgXb69zrtocP46VnpePHMzxXwB1o8mzd0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:44 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:44 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 05/24] xfs: use xfs_defer_pending objects to recover intent items
Date: Mon, 25 Mar 2024 15:07:05 -0700
Message-Id: <20240325220724.42216-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::27) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	KWOmrW4hWJeS78rKLUuGIicVNUVu62v7bWGvVn5rOhJncz/TVzItBrL8w4/aPL/Hw8G/I7d4uykNOPNRFBQRHcCbmAH8MV9WIrnHoasUuuYfPCC8oZlL/+twdumSvSraDd0wbk2/zqLTTbnVqLSozKqe2/ySvbBDQuFybBT/T6K+pcWLY7vmM3owwB6ajFt3ODmGP9e8VtR6uDmytUuzULXeMJ1DAyo3TTzUVqG8TabPHhStiAbSpfV9FYbW6iiLohUQ/rGvQkLVSgITCwnySG+PLwprtC//qG8tb5ir1SFo612B/6Lls2Q8poAFiOzo2KNs/Nr2MvSQ0Om3lDVLcVitjgAd14mjK2DKzl7x6b/xdymK4e+7o+fnrAj3jLZOI9fOPhK9qMflPS/JI06RioYY3ZCpTv5Uyy0adV7+pzRIx7Qi7h591JQOji652ftlfU1KVeooFg9HnEm+LlRNNgcsfQx6xlMuFayHCuvB2/c6DAbLgpz84Oiv8cyLkK5Ns0SnyWUal6Xs/W1OrOPfRvr8lql7BsxYsq7tDOfMjDjElxv8Sw9V/6l6lJ0a6xV4yhCOjvpkixeTuSFCmXkR8bg0hykHrKhoTgZM7sKvhkG75sG9afomscT3CLRodE/aYQ93RuKkfSVzERDAzdkeUH8fHgC41tGTfWHN6PosxzA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?DvOFKxkEtDD/DZT4zGJdTdKMT+1m4Q0udUPcXHWgCnKp/qWi2XZSbXpxB6sF?=
 =?us-ascii?Q?6oP+blsLhlC4AgJAjKX08oY7GonfC+KFqQpjKrr/Z+6+jgWovy/B+PeXW4Bk?=
 =?us-ascii?Q?mYXvflHc3trWZqr5i+g+7BnX7V1K9wLn3+aA6d5UQTFsCR6IWofccGUC2Ocm?=
 =?us-ascii?Q?aTqoC8+Idp0uixnKSM3KaJ8vDZXgcPQVBZ6L+FE8/j+ORatOh4/+RIN+CcjV?=
 =?us-ascii?Q?1Kt/lPTg/qbfMry1ZPkS/1jsSQYRHnoeM5miaEAZz94TFBSI1PPoTrV5eR5g?=
 =?us-ascii?Q?mfNtVC1DfsLCTgCq59qkR/QTrzs+t6FtUlgK6rCvLdoUTxcNRri8QHYVN5rA?=
 =?us-ascii?Q?FuPMlgcOnsfjfnJRvU0Os1xCXDqUMYt6TSHOd9FPARnty9hPW7XChvBfnO23?=
 =?us-ascii?Q?2K8tsQojhcFvmxYM5FdrMpaH7rkA6WQ2am6wu/qRI2be9C9J2/Kq7Dz+v/cG?=
 =?us-ascii?Q?qxsGvd08+v0Gu3wCy1C4VIaeUEy1Idevu10Mi1YHmEDjcjGw5Du6x5w6kvjP?=
 =?us-ascii?Q?1st2gmrD1tzvCdRr60gWzu4+/B0winyHw6Bhovz/UeiAEP/tVSZKTlcXUssj?=
 =?us-ascii?Q?apMFU/64vMNtahillCgO3+25pPl5xqEpcjDLykHnCPAH5iGCNHGKfViTqAE8?=
 =?us-ascii?Q?ADXO/tw/Fz8yiZ/YzwDJ4Ih+4tn3HD52wu1PwYHQ5g6WwtqO257gC1A1DVYx?=
 =?us-ascii?Q?lPo2seZ3klSxLX3zKiNpvSMMcevYsJlu2F0bGzO1hsz9dJI+azA92YIJbeaN?=
 =?us-ascii?Q?oKZ4fKSDMGHeDevVdKgXKZZd9f/U+psTqhZmNk8MxnEK5Y84Uki5mBeqyeCQ?=
 =?us-ascii?Q?inYIQZYphd3NE94ja2yxepoEJzENucdcWdK8/8tLdVw9UPDAbyfRL8vT7b6N?=
 =?us-ascii?Q?Tlx4Oeo/yh/uegI501BuGStKYmdbjjvDvCo19ISob0PzynPrHBTOmigq/X5D?=
 =?us-ascii?Q?jRe9YDLQH5MAqkvJuCDauuIU0rPvwI6RsVi94WMASM01eSk4n6VU+qYyaM6r?=
 =?us-ascii?Q?R3mQp6H6bbYahHcoZGfpAlDEPjdugH9KfZFtD93R2yEOeelgFsStIPE2Tgxg?=
 =?us-ascii?Q?o6fMgxG0nvpm2hVUekZeuTVdWTS8/OqulxmIhW6kkfI0TedWVMtoT+3kpuK7?=
 =?us-ascii?Q?fZbUk1aLGWpBL5gUQQaFy2smHIuk2uKLmAMADbq6KZOZlPhDsdaqg1hZ75qV?=
 =?us-ascii?Q?6hOGMNg9aWNUaIG9rPfaQ5XkXHuJ4efxZad0EIMxKQHZdP3JVi3RM2lAJlzA?=
 =?us-ascii?Q?8gL6IcJuJ4wsbinptPNHSoZhgKVHi76A1Ix8tAzRCjWhQ1ih2aRuJeMSPMxP?=
 =?us-ascii?Q?yX/OGr+dPSpyFXRslH0y730uS8QDmAkucR1NZbk0MSuDAAM3k5sxxTUpx5Rf?=
 =?us-ascii?Q?llX+EAwAxvoV+UkLN5m2OZZ4jGgt5ncNwPjDAJcQrVisKPdds3aPDzzUImP0?=
 =?us-ascii?Q?Q7ApdIT5vaKGLum5gIFTNnCIA1KgbsS4fUB9d3Zbnn6NrfDHLBxc9xNAJ2YW?=
 =?us-ascii?Q?gOzdX8ttlOl+rzQ40Bra7MKZnfEA7Fz3p0B2aqJM0sBVOHjPUGQJKPjz5/FI?=
 =?us-ascii?Q?fIPxB5vKBOlV7FQ3eBmv2x2AVI8WGqHzG98+HVboDeMdOs4lzNfn7SForNTR?=
 =?us-ascii?Q?hLytapz+xNnvxbJYEKGTOQEor9xNcocdcdiZLoKjOr5oM2OJgPzDLQmz276v?=
 =?us-ascii?Q?6IdqhQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LydXl1uuVv1hgXiPb8u6RJl3kjUnRzCbXW1Oze5NMeCiC8QOu+GX14yhigf3GYMxsSTcT4R2YTEGAYT068K5ryJ7bY8yaLNwPioUdKBue6T1lsHghiJ0nFl/zFnAA0IF2CXeGqUHXmCq13koXQSfKgYL1DCe54s6ktEyo23WKOX93RPQGyg3/m3oMdA45mRIpwoHE0Lf07cSxaFgDlULyyTOq+NKVwBFNqCb+TomA5oohnAIh91fFE0EKL/t56FRlyEw0qXdIz8kPQcYdix5bss1agBglnMXlWNlAPXgPFYigCxFiUsOfcZJEhfU2Vo9YvlmgnndXLjsbYwCyzMsAK1oGWUza2LKsi7aST4EfEdXZ9NdSXIxJuxEl+vdI6fVVc56n2O65aqdBglo3Snq7KzlVNtsz5ppTe4Cy2mrPRSre8+PD+AHpjO2AMhH4+DUOHctxhKTGR09Az4un2nDTlky2vVGPlW2smjO0iOZkr8dNT9tAOlcoVD+Me1a3s8iezR+Nzl3fCKP5ydHW5+M26VLpa4VKTFSvFvyurAnPPOhb7PYZjmiFMUwyQm2HKj6x15etHk5D/9Y27lHXrhGc9NCEWsQvoz7bdM4KC++q0g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d731f6d-63bf-4d51-3237-08dc4d17ff4c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:44.3600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cGsDRKYcHnsNR2Aj9E4guJ8+jqlLL/Vc9LdFmNrvT1WzVJKUKaLWexovc5UPUpjeIjuONDzamJGQyOqkTjSjzijheXPpyw4OnwUBAPiuwUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250137
X-Proofpoint-GUID: XtQwjYIFvOUdH9XrbgP6iqDexaoSsfXf
X-Proofpoint-ORIG-GUID: XtQwjYIFvOUdH9XrbgP6iqDexaoSsfXf

From: "Darrick J. Wong" <djwong@kernel.org>

commit 03f7767c9f6120ac933378fdec3bfd78bf07bc11 upstream.

One thing I never quite got around to doing is porting the log intent
item recovery code to reconstruct the deferred pending work state.  As a
result, each intent item open codes xfs_defer_finish_one in its recovery
method, because that's what the EFI code did before xfs_defer.c even
existed.

This is a gross thing to have left unfixed -- if an EFI cannot proceed
due to busy extents, we end up creating separate new EFIs for each
unfinished work item, which is a change in behavior from what runtime
would have done.

Worse yet, Long Li pointed out that there's a UAF in the recovery code.
The ->commit_pass2 function adds the intent item to the AIL and drops
the refcount.  The one remaining refcount is now owned by the recovery
mechanism (aka the log intent items in the AIL) with the intent of
giving the refcount to the intent done item in the ->iop_recover
function.

However, if something fails later in recovery, xlog_recover_finish will
walk the recovered intent items in the AIL and release them.  If the CIL
hasn't been pushed before that point (which is possible since we don't
force the log until later) then the intent done release will try to free
its associated intent, which has already been freed.

This patch starts to address this mess by having the ->commit_pass2
functions recreate the xfs_defer_pending state.  The next few patches
will fix the recovery functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c       | 105 +++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_defer.h       |   5 ++
 fs/xfs/libxfs/xfs_log_recover.h |   3 +
 fs/xfs/xfs_attr_item.c          |  10 +--
 fs/xfs/xfs_bmap_item.c          |   9 +--
 fs/xfs/xfs_extfree_item.c       |   9 +--
 fs/xfs/xfs_log.c                |   1 +
 fs/xfs/xfs_log_priv.h           |   1 +
 fs/xfs/xfs_log_recover.c        | 113 ++++++++++++++++----------------
 fs/xfs/xfs_refcount_item.c      |   9 +--
 fs/xfs/xfs_rmap_item.c          |   9 +--
 11 files changed, 158 insertions(+), 116 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index f71679ce23b9..363da37a8e7f 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -245,23 +245,53 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-STATIC void
+static inline void
 xfs_defer_pending_abort(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+
+	trace_xfs_defer_pending_abort(mp, dfp);
+
+	if (dfp->dfp_intent && !dfp->dfp_done) {
+		ops->abort_intent(dfp->dfp_intent);
+		dfp->dfp_intent = NULL;
+	}
+}
+
+static inline void
+xfs_defer_pending_cancel_work(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct list_head		*pwi;
+	struct list_head		*n;
+
+	trace_xfs_defer_cancel_list(mp, dfp);
+
+	list_del(&dfp->dfp_list);
+	list_for_each_safe(pwi, n, &dfp->dfp_work) {
+		list_del(pwi);
+		dfp->dfp_count--;
+		trace_xfs_defer_cancel_item(mp, dfp, pwi);
+		ops->cancel_item(pwi);
+	}
+	ASSERT(dfp->dfp_count == 0);
+	kmem_cache_free(xfs_defer_pending_cache, dfp);
+}
+
+STATIC void
+xfs_defer_pending_abort_list(
 	struct xfs_mount		*mp,
 	struct list_head		*dop_list)
 {
 	struct xfs_defer_pending	*dfp;
-	const struct xfs_defer_op_type	*ops;
 
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, dop_list, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_abort(mp, dfp);
-		if (dfp->dfp_intent && !dfp->dfp_done) {
-			ops->abort_intent(dfp->dfp_intent);
-			dfp->dfp_intent = NULL;
-		}
-	}
+	list_for_each_entry(dfp, dop_list, dfp_list)
+		xfs_defer_pending_abort(mp, dfp);
 }
 
 /* Abort all the intents that were committed. */
@@ -271,7 +301,7 @@ xfs_defer_trans_abort(
 	struct list_head		*dop_pending)
 {
 	trace_xfs_defer_trans_abort(tp, _RET_IP_);
-	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
+	xfs_defer_pending_abort_list(tp->t_mountp, dop_pending);
 }
 
 /*
@@ -389,27 +419,13 @@ xfs_defer_cancel_list(
 {
 	struct xfs_defer_pending	*dfp;
 	struct xfs_defer_pending	*pli;
-	struct list_head		*pwi;
-	struct list_head		*n;
-	const struct xfs_defer_op_type	*ops;
 
 	/*
 	 * Free the pending items.  Caller should already have arranged
 	 * for the intent items to be released.
 	 */
-	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_cancel_list(mp, dfp);
-		list_del(&dfp->dfp_list);
-		list_for_each_safe(pwi, n, &dfp->dfp_work) {
-			list_del(pwi);
-			dfp->dfp_count--;
-			trace_xfs_defer_cancel_item(mp, dfp, pwi);
-			ops->cancel_item(pwi);
-		}
-		ASSERT(dfp->dfp_count == 0);
-		kmem_cache_free(xfs_defer_pending_cache, dfp);
-	}
+	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list)
+		xfs_defer_pending_cancel_work(mp, dfp);
 }
 
 /*
@@ -665,6 +681,39 @@ xfs_defer_add(
 	dfp->dfp_count++;
 }
 
+/*
+ * Create a pending deferred work item to replay the recovered intent item
+ * and add it to the list.
+ */
+void
+xfs_defer_start_recovery(
+	struct xfs_log_item		*lip,
+	enum xfs_defer_ops_type		dfp_type,
+	struct list_head		*r_dfops)
+{
+	struct xfs_defer_pending	*dfp;
+
+	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	dfp->dfp_type = dfp_type;
+	dfp->dfp_intent = lip;
+	INIT_LIST_HEAD(&dfp->dfp_work);
+	list_add_tail(&dfp->dfp_list, r_dfops);
+}
+
+/*
+ * Cancel a deferred work item created to recover a log intent item.  @dfp
+ * will be freed after this function returns.
+ */
+void
+xfs_defer_cancel_recovery(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	xfs_defer_pending_abort(mp, dfp);
+	xfs_defer_pending_cancel_work(mp, dfp);
+}
+
 /*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
@@ -769,7 +818,7 @@ xfs_defer_ops_capture_abort(
 {
 	unsigned short			i;
 
-	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
+	xfs_defer_pending_abort_list(mp, &dfc->dfc_dfops);
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
 
 	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 8788ad5f6a73..5dce938ba3d5 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -125,6 +125,11 @@ void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
+void xfs_defer_start_recovery(struct xfs_log_item *lip,
+		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
+void xfs_defer_cancel_recovery(struct xfs_mount *mp,
+		struct xfs_defer_pending *dfp);
+
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index a5100a11faf9..271a4ce7375c 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -153,4 +153,7 @@ xlog_recover_resv(const struct xfs_trans_res *r)
 	return ret;
 }
 
+void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
+		xfs_lsn_t lsn, unsigned int dfp_type);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 11e88a76a33c..a32716b8cbbd 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -772,14 +772,8 @@ xlog_recover_attri_commit_pass2(
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);
 
-	/*
-	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
-	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
-	 * directly and drop the ATTRI reference. Note that
-	 * xfs_trans_ail_update() drops the AIL lock.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
-	xfs_attri_release(attrip);
+	xlog_recover_intent_item(log, &attrip->attri_item, lsn,
+			XFS_DEFER_OPS_TYPE_ATTR);
 	xfs_attri_log_nameval_put(nv);
 	return 0;
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e736a0844c89..6cbae4fdf43f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -681,12 +681,9 @@ xlog_recover_bui_commit_pass2(
 	buip = xfs_bui_init(mp);
 	xfs_bui_copy_format(&buip->bui_format, bui_formatp);
 	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &buip->bui_item, lsn);
-	xfs_bui_release(buip);
+
+	xlog_recover_intent_item(log, &buip->bui_item, lsn,
+			XFS_DEFER_OPS_TYPE_BMAP);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3fa8789820ad..cf0ddeb70580 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -820,12 +820,9 @@ xlog_recover_efi_commit_pass2(
 		return error;
 	}
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &efip->efi_item, lsn);
-	xfs_efi_release(efip);
+
+	xlog_recover_intent_item(log, &efip->efi_item, lsn,
+			XFS_DEFER_OPS_TYPE_FREE);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ee206facf0dc..a1650fc81382 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1542,6 +1542,7 @@ xlog_alloc_log(
 	log->l_covered_state = XLOG_STATE_COVER_IDLE;
 	set_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	INIT_DELAYED_WORK(&log->l_work, xfs_log_worker);
+	INIT_LIST_HEAD(&log->r_dfops);
 
 	log->l_prev_block  = -1;
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index fa3ad1d7b31c..e30c06ec20e3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -407,6 +407,7 @@ struct xlog {
 	long			l_opstate;	/* operational state */
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
 	struct list_head	*l_buf_cancel_table;
+	struct list_head	r_dfops;	/* recovered log intent items */
 	int			l_iclog_hsize;  /* size of iclog header */
 	int			l_iclog_heads;  /* # of iclog header sectors */
 	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a1e18b24971a..b9d2152a2bad 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1723,30 +1723,24 @@ xlog_clear_stale_blocks(
  */
 void
 xlog_recover_release_intent(
-	struct xlog		*log,
-	unsigned short		intent_type,
-	uint64_t		intent_id)
+	struct xlog			*log,
+	unsigned short			intent_type,
+	uint64_t			intent_id)
 {
-	struct xfs_ail_cursor	cur;
-	struct xfs_log_item	*lip;
-	struct xfs_ail		*ailp = log->l_ailp;
+	struct xfs_defer_pending	*dfp, *n;
+
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		struct xfs_log_item	*lip = dfp->dfp_intent;
 
-	spin_lock(&ailp->ail_lock);
-	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0); lip != NULL;
-	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
 		if (lip->li_type != intent_type)
 			continue;
 		if (!lip->li_ops->iop_match(lip, intent_id))
 			continue;
 
-		spin_unlock(&ailp->ail_lock);
-		lip->li_ops->iop_release(lip);
-		spin_lock(&ailp->ail_lock);
-		break;
-	}
+		ASSERT(xlog_item_is_intent(lip));
 
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
 }
 
 int
@@ -1939,6 +1933,29 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
+/*
+ * Create a deferred work structure for resuming and tracking the progress of a
+ * log intent item that was found during recovery.
+ */
+void
+xlog_recover_intent_item(
+	struct xlog			*log,
+	struct xfs_log_item		*lip,
+	xfs_lsn_t			lsn,
+	unsigned int			dfp_type)
+{
+	ASSERT(xlog_item_is_intent(lip));
+
+	xfs_defer_start_recovery(lip, dfp_type, &log->r_dfops);
+
+	/*
+	 * Insert the intent into the AIL directly and drop one reference so
+	 * that finishing or canceling the work will drop the other.
+	 */
+	xfs_trans_ail_insert(log->l_ailp, lip, lsn);
+	lip->li_ops->iop_unpin(lip, 0);
+}
+
 STATIC int
 xlog_recover_items_pass2(
 	struct xlog                     *log,
@@ -2533,29 +2550,22 @@ xlog_abort_defer_ops(
  */
 STATIC int
 xlog_recover_process_intents(
-	struct xlog		*log)
+	struct xlog			*log)
 {
 	LIST_HEAD(capture_list);
-	struct xfs_ail_cursor	cur;
-	struct xfs_log_item	*lip;
-	struct xfs_ail		*ailp;
-	int			error = 0;
+	struct xfs_defer_pending	*dfp, *n;
+	int				error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
-	xfs_lsn_t		last_lsn;
-#endif
+	xfs_lsn_t			last_lsn;
 
-	ailp = log->l_ailp;
-	spin_lock(&ailp->ail_lock);
-#if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
-	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	     lip != NULL;
-	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
-		const struct xfs_item_ops	*ops;
 
-		if (!xlog_item_is_intent(lip))
-			break;
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		struct xfs_log_item	*lip = dfp->dfp_intent;
+		const struct xfs_item_ops *ops = lip->li_ops;
+
+		ASSERT(xlog_item_is_intent(lip));
 
 		/*
 		 * We should never see a redo item with a LSN higher than
@@ -2573,19 +2583,22 @@ xlog_recover_process_intents(
 		 * The recovery function can free the log item, so we must not
 		 * access lip after it returns.
 		 */
-		spin_unlock(&ailp->ail_lock);
-		ops = lip->li_ops;
 		error = ops->iop_recover(lip, &capture_list);
-		spin_lock(&ailp->ail_lock);
 		if (error) {
 			trace_xlog_intent_recovery_failed(log->l_mp, error,
 					ops->iop_recover);
 			break;
 		}
-	}
 
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
+		/*
+		 * XXX: @lip could have been freed, so detach the log item from
+		 * the pending item before freeing the pending item.  This does
+		 * not fix the existing UAF bug that occurs if ->iop_recover
+		 * fails after creating the intent done item.
+		 */
+		dfp->dfp_intent = NULL;
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
 	if (error)
 		goto err;
 
@@ -2606,27 +2619,15 @@ xlog_recover_process_intents(
  */
 STATIC void
 xlog_recover_cancel_intents(
-	struct xlog		*log)
+	struct xlog			*log)
 {
-	struct xfs_log_item	*lip;
-	struct xfs_ail_cursor	cur;
-	struct xfs_ail		*ailp;
-
-	ailp = log->l_ailp;
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (!xlog_item_is_intent(lip))
-			break;
+	struct xfs_defer_pending	*dfp, *n;
 
-		spin_unlock(&ailp->ail_lock);
-		lip->li_ops->iop_release(lip);
-		spin_lock(&ailp->ail_lock);
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
-	}
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		ASSERT(xlog_item_is_intent(dfp->dfp_intent));
 
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2d4444d61e98..b88cb2e98227 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -696,12 +696,9 @@ xlog_recover_cui_commit_pass2(
 	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
 	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
 	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &cuip->cui_item, lsn);
-	xfs_cui_release(cuip);
+
+	xlog_recover_intent_item(log, &cuip->cui_item, lsn,
+			XFS_DEFER_OPS_TYPE_REFCOUNT);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 0e0e747028da..c30d4a4a14b2 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -702,12 +702,9 @@ xlog_recover_rui_commit_pass2(
 	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
 	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &ruip->rui_item, lsn);
-	xfs_rui_release(ruip);
+
+	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
+			XFS_DEFER_OPS_TYPE_RMAP);
 	return 0;
 }
 
-- 
2.39.3

