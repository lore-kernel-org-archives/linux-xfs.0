Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0852E9745;
	Fri, 11 Jul 2025 11:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752234257; cv=fail; b=WFlXAg6ZoAZ7dKPJ55bumoV3HIsovvSW9fH499nHdP8ZOUKYvRY6KbfctVZkN2rcn/W0OfJwpu3G6RHf5wsw7Zo7njMtngQjO2NgDbye+w8q20TVyS20gflXQTtBBSw9Y5ntJvGb7CGzNYLaqVhqFYTN16IOMzbfCjJWxJr35YQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752234257; c=relaxed/simple;
	bh=/cU+JAWQluYUuxMSFGQqlELgTXyKNsXZwhyQrOro4Fc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mjAQtIB6MrliTPwdWOAXQoXQWlJ32U5GS3zZldrbhYuNaancVRxsuEF9QMljnAn3jtiBnUDbplwuIcLOSAqi8mzUuySmd9kYvSpU1WxmvVGFnCrBrxyyAW8vX8t5bzp/gnIHVq9UNR3APgcjv0i1Ns6edtueNyDE99UXOp8jGkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZB7YsFeB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OBoZf1zT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZB7YsFeB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OBoZf1zT"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BBb0uX018168;
	Fri, 11 Jul 2025 11:43:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=m0JMAqAUiH5ekVmHSx
	aPdOU8Iua0gNXFUGZaomBF3Mc=; b=ZB7YsFeBZwTB+q6Ueub107LQtw8BKzAuQy
	ppv7dm1CiOu9gQp2bw1fXIo5vspyY8OdkX+w9wHT2nQ5jGg8bFTQSONU1UtPYJNc
	UnMICRQhzDu7egtuDklKefLHgkbzuayJjwOEqNFLhnljs7HkhZUAEhH3qjnFGRsN
	SY8PpkMcjRPQ1sRcPf0ItggphZRpO1Rm4TGnk98DNvDp2z0MaflViUVj+8oZlRpE
	kTmVFJLnSctG2etLWzrOH/mJ0UPfDiZjNWFliuWJ7DBOdbHHKf3I1iKSf/KGJi6L
	A6UX0MhrxIQdw9COek2BCVcBi8vaDydnhrY/wjN9FDqLZUs8IGcw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47u1w2g0bq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 11:43:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56BA6gWo021575;
	Fri, 11 Jul 2025 11:43:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2061.outbound.protection.outlook.com [40.107.236.61])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdeahq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 11:43:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VDJpT1EKzlC2A0sTLjgLCCpQmjq09eHxgrVAo6VqQ7MeJkuMXwsJuk9DR6qCg/PWdgrICE1axLGdyi/qmSLOfXroxBM/oJCcZEJRi8Qbj/yJiBNcRy2wVqgWlQhdglThgZYb1LZY/oRtDntAuPwlUel9bAeblyF6cUIdvtLGfuZw6qZu+FGfvgzxydemzTEmcvQAxo45cGnZNp1190ncymtd74/LHvkkHRO4tUPrSQq1HZecNvkVQrU/gZr0lRstAZHpxSG7Yh2n/ImyeXYtoMd20Gyau6qdPnvXGIb7W8dBsttGGbzqVDnKcDwuBM+QlGwtGbPMCYO68ByWYf9HeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0JMAqAUiH5ekVmHSxaPdOU8Iua0gNXFUGZaomBF3Mc=;
 b=JbxT0oq9u0Xvq6pOV6UdicxcF+CqJnWUIjUfBATJJ2R9dYUvi6EGSfE7I4hIj+6iblDXJ72S9Kviz4RvZYhP+cEidTOLs4KEGoiLW0/bC96NYLRztyMvoLkugWaqCUY9syFrAGrSY5QF86vps+N1e8J+pzYTB9fe/kK2eW9S/R8QYtx6lZNsrTzxEIpL+d1vjGF7HJTu8bzsBgQb70poK8QRJC4yQghFL18iXlgfhZTWN/JENrW5dYR3T2a3/hJc0HVmJ1OJyYRb+LnBm8LsIu63BacH+MHsJ+TQjOqwud3UWRAdzCoKsHFKxpefc6LidPMvBfQo/hbl7XFBwgHI/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0JMAqAUiH5ekVmHSxaPdOU8Iua0gNXFUGZaomBF3Mc=;
 b=OBoZf1zTvJfMk5oFmAYSaYfs7H01SqY3t8AlsJubi+xnMYFX4aQZrlBQF384bBMQQOheozYoNGALeoz4c3LRNdA1/KdO0Nl8hVjIpTynR/+p3w5Ry5LhroJi/l77QDvts6JV1txk5yynspCWFqRN3jqa3VLi7Xbr239s4le1T2k=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA0PR10MB6820.namprd10.prod.outlook.com (2603:10b6:208:437::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Fri, 11 Jul
 2025 11:43:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.025; Fri, 11 Jul 2025
 11:43:53 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, dlemoal@kernel.org
Subject: Re: [PATCH v7 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com> (John Garry's
	message of "Fri, 11 Jul 2025 10:52:52 +0000")
Organization: Oracle Corporation
Message-ID: <yq1ms9bar6o.fsf@ca-mkp.ca.oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Date: Fri, 11 Jul 2025 07:43:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0100.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32d::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA0PR10MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: b0a018c1-efe7-4b9b-4667-08ddc07035d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XbB7MyOpq6lG77X2hbVbb8aoQfAZp+9uiS2IfvHa8RBX1hA3Pa84abx+zsDB?=
 =?us-ascii?Q?qQsTidEtGcOzYAvBYDPbeKwIJzNDRqpJ3K5lnxk24L2tJQaz2IBFiLrDQ23j?=
 =?us-ascii?Q?3J3Zw9u4A5Xq/RNN4DqEmzohWQBWj3kxi/QPidPiyNrEY7nILVaUTYa+//Ov?=
 =?us-ascii?Q?FBCIcPHtq04dprFDqaqWfTXGTfds0x0F4QboMwu/4bZfolPNzCoRgMJRw4jX?=
 =?us-ascii?Q?ZhSpvmYpwhnXcWAkSZopltujc+mWm0izLYexx6tb0otnSFKsyDbqnycnS7Lz?=
 =?us-ascii?Q?8iGtd+p0Uv0dQ4rVb/hZpMvz9un7mkAmZHZB33Nj+I5OSSuz1SPbILYsurkl?=
 =?us-ascii?Q?G5WaXTe/wWkpoq6YFcHw+9zVx1ffL0xvWDrLAE/Lhg4TpCT/htChimIUiovV?=
 =?us-ascii?Q?1cLclN6a4vBsBkZqwFp1DYNiUtnbwpWG4HnzLnv6S+u+bPKvvhvA0EaXNmeQ?=
 =?us-ascii?Q?7n//ZakNqfGOnNKSonFL/fBKtLnkqVhFwPlkzxQIsDry0Km/OoJ+jhs9otS1?=
 =?us-ascii?Q?aVDDv6k08grxIv/e8zofN1cpYBjZ1JdWe/io+xTfmTJlzbK3tvgfj7B9C7CF?=
 =?us-ascii?Q?DN6tgs5cWDX0MSOfLBIRnSpjGvP2oxpCeL1t8EgR8mF/vUcpARqdz1V6CHBa?=
 =?us-ascii?Q?G5Dysr7siDHKRp9z2SkP6nUwTiL+ySiCQTDJdtvsI6KoK03omuMwqzLNC/jU?=
 =?us-ascii?Q?mH0DRkKSlEmneR6t9jSQEhBPgrtfpiCgmQ95swHT1/cJpwMipr3zusgNns1o?=
 =?us-ascii?Q?hOoL1gQmL7P2OMmBSziLrXJ/c1P6aVCnB0CX4hDvZEEx57ujMhpsevynV86O?=
 =?us-ascii?Q?r91N548UEjpiA6uGMwbe9UmPC0mRymcA3NitBDwc0gG/eYUvzmTJ2M7p/bJW?=
 =?us-ascii?Q?Ewl+ktXfPEzEOo3rVa2lPtkFvslp5l06LBiAj+e5bbS+Jf+LBLuBNnbkiOEk?=
 =?us-ascii?Q?EjqxkRzhzUD3TEXWkzNhhZQPPWb07h/oHQqiwKbbApVSBKG8PIMTcIvYGWCA?=
 =?us-ascii?Q?V1R88F+Yt7lfyGJoqOAU5Ozda7JPou4G0KsLV0fbQ/CdkRZ5buVAj9Np/gj6?=
 =?us-ascii?Q?vmdugEOp6He0P27XGE9UPYYQKADgpcUudiQIF/24TpSIh0nhmY3rir7yxv+K?=
 =?us-ascii?Q?uTtXzhcEF137u05I5J52WQcvOGTV6RakMXqN9vmfDOZ3hdS3yLyiBBTIDutH?=
 =?us-ascii?Q?59ZwLIkbzEMXgf+rcyA1t1wtMomgLQjnvgkI0AjqjzyE2n6AWr0WEEMJtEbT?=
 =?us-ascii?Q?DwbgsdtSohdZHP3+UbQOkpuW16wJlJpMniF/C0bszwhbcORy+x/WxFpH5fMZ?=
 =?us-ascii?Q?ZAO6/hUnuJGks9x3aJUNQXVtrC7nitHZSfbEcbsrbXJN5EWyR3E+hn5teMpk?=
 =?us-ascii?Q?nCSzVEFmYXyFRWiupR4bXDlkK+zWDZ9UATWqgDOBWMmpF1fqkfbQSWurooK9?=
 =?us-ascii?Q?ErhMkmbUOrQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jg/utd/77f2WxoFqbEVO6nLHUrgddm8s/nZMYu9bIeQOUzZhsFfvvD4y/hsw?=
 =?us-ascii?Q?Kx2cneBL0pp2LeJ1pJTL+bmnHn9YhBaoKHWDFZoW0LYBzHo7NDsgsuhny7bq?=
 =?us-ascii?Q?GT8CjBV562NYq2NmQqSUqTgeq0bFNmOBkmdh7EH8yrF9Eg7d0vAt8SL7A62d?=
 =?us-ascii?Q?QTSPHtXaqbOb4dv3IwRU3K74eMiv57q/GW62n1dHr+rDO6mLzGy8Pdg+7oUi?=
 =?us-ascii?Q?F1rwMH53kPiAFA9xxN0n3WsQQ27ER40A3Ga8FxdWcnTTlg9JjHULLxNstUla?=
 =?us-ascii?Q?7KL+FNi8jjUj5qvYGxLai/mHmHNXjFENNPmFITokfN1zhDUIf46X2IcdBmFP?=
 =?us-ascii?Q?OZAZ5viae5DtMAQiJWY/Evurp2CORJTfA4WYqGpcGpwORGSsyci37EfLaWRY?=
 =?us-ascii?Q?7h5QYPoqByWwDUn6s95Rx+vjalymUvIonT8ERm7zBqPHcXBLsAWATdVcmGPJ?=
 =?us-ascii?Q?U/e3KjMSlYjBN3eoXo05PxL4bX+h7k/tSrcQIyVd+uS7yGX4MLNo4Au31AJg?=
 =?us-ascii?Q?1ektwPtvHVwgGdfUxPAazdax/6AVrbHPj2SkVmsLhVO+Pk0cHYBHWNMpCET+?=
 =?us-ascii?Q?MAmqUlOeLjotNIZOf75xLrW/pb/g5a+etoWuZyrfkBeznnAJctAwokEQ21Vz?=
 =?us-ascii?Q?VkU2Kzt1nqRjsyhmGOAXwEMvvofo22zd1OVOYSy9dnQsAAYKPYE6ttsLgfZB?=
 =?us-ascii?Q?wneT+jXLNioFCfjgfQV/y9lCPhYelMt3hBvMqLR/oM/Otu6uLLIDaWR9wwnQ?=
 =?us-ascii?Q?1CDWZzLx/oFRRqZ0yw31AjswrHe8O/wFw7Hmq+GulciJh9u49aJPMn3zwMcE?=
 =?us-ascii?Q?1QHWfAmkWf0c7cWpoLwqYzyhmKdMbhO0zXv/gvLQSHVNgrvb1oC73GJcLYfl?=
 =?us-ascii?Q?9rG3MYRw9mYL3WzlxPtHgoxDUeKqjlG65zESowBLsODLdiZ7do+eDy+2+7nO?=
 =?us-ascii?Q?DuqEgPCYsaT4n73lA1YVp63sWoMz+hEgbUUeIFbHq5SgY+Kc8lfPuVTib2IN?=
 =?us-ascii?Q?x0T2oqw15NKBAmYPF/m051yDLwYS84bNBWSQqNbPtWTR6sSeoT7XQA8FqOIn?=
 =?us-ascii?Q?oBDS/CBlM/OpBsSdOZZflBKplUJDVUx6RU+8oB8PXO6yQ6tEr9fT8KdnChPB?=
 =?us-ascii?Q?eQBMY9fYlFuVmGyWB412+fjzdm7x/WFbQZ4up2js8sxfA8EbUNu8o0uuSXMK?=
 =?us-ascii?Q?kFnQbsehoKTz4gLqldVRJEdy4P0PAERn9Re9wFmo3E0YVGsWivThP5k1JwNa?=
 =?us-ascii?Q?/vIFg6H0lFYWCuRRaOd9H9B2yjhCPV2Hq6kpOGp9lfcKQKSiMai543vHP/de?=
 =?us-ascii?Q?B0mv5vj8kG0hybvIGKD9I0UcHI+MrMpDMnHzVqt0VyLwFjtOWWw+o1sj1jSN?=
 =?us-ascii?Q?D+/+bTo8RSyZ41jBuZZ9y+lyCW1c8oorceyFGdirXc0nE/4TmKTFNRNE0Lu5?=
 =?us-ascii?Q?3euffLNhJVGIxH79ZaQE3aEVgj7naSJ33HK7yDnRRZIs9a4H2/wM24YVM4tR?=
 =?us-ascii?Q?SpzpE0GvyiR31gssihVQi14UroSNGPHC+16VWIZQATHO52yA87otkOPlBXk2?=
 =?us-ascii?Q?dGKKfBNliikPIgaV/jXgHIZwTlfzv3WR1lBxVYFQ+oXbyTDpwDuRE9fhKzPw?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/YiKevbN4tBvQEFbKy8ozh46lMgCSBwN0Ogyn0nl+/A6qKxiDXNOKNJ0MbgX7HtOBZIw9tyz7/jSvJPArDPz1i0oqufnhZpMBNBxp3UPjZ/dad09EawaDEKpbhugixW5E97IwRi/7KvY4HXsoL58cVM+REMyoLQ3ZGQaNMn0Ovhx5M7Flbnh87GscS03mPMYu4VZaiBHsI3HTNTmkhOqHCi4ltpNbxxc2kPYYDI3EHX977ZzQtzgSn2e7qVyEZJk5r+d68w6xykiiz/jqQpt3O8NoMielUp6dhUemtZypSJ6Dp9ERFMF8xUhfVfkrmwpeAny8Rw0vxzjDdeN+dakw2aostIe2zDl8j2lvtjmFYqhQSXvZBOv/vUub0SEipwZptA3+rKAxedrf+M5uRbL3i8ylW2HIlLKFtxB9KWqiZ7DGnd5VGfE+nHJeInEtwIMqVGlRr8EsRd9gTN+pTJkYgdC2popBUk4ujzBE/Ip1WUq2bbLLkeuc5pSzpzSDSJflMIPcqwD9P1EilFbE+8eNVskxoJl3rPUmcg+9vvvQQRn1C5k597vgZiIUX82fVDFnarMeDy41wEIOvftah757rhRo/+on1sZXbuRKSJlAtA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a018c1-efe7-4b9b-4667-08ddc07035d7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 11:43:53.0207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQLYwu9QpYxRKu8RTBAUytLNMPPzr8JV+Y6iutKEoTpZQKXvW+NbrSej7sKA75yDVdlasO+cW/rSECyVMP12eV0WtfmOnL136JOGkZjbV5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6820
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110083
X-Authority-Analysis: v=2.4 cv=X95SKHTe c=1 sm=1 tr=0 ts=6870f8ff cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=lcX1mEZmN8NuPWhCNYEA:9
X-Proofpoint-GUID: iZZqf3nXYfIJhyRtuEl5A69PCAbLhmIB
X-Proofpoint-ORIG-GUID: iZZqf3nXYfIJhyRtuEl5A69PCAbLhmIB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA4MyBTYWx0ZWRfXwL8ZhyVX1VsU GOiw7DFdyIELVAkE1CUTcnhz2XCsF54j4Boy1grJVLWWIl/2S08ZhouUJnvb7As0ySfm0wZYmmf t5aUy/QHt7F2LZKToVfDyxfdwYBx4mb7EX1Fe0XimxMn9+3H1YED16UjB98jT2nHWe1YJk3zJWX
 dbXUP+LE8mvP5u669azhkpsT7Ghk7gEogJVlcCkpodXyatVakaNT0M/F8qYNiqpsxqXn9AIqoxT FLDw7SA6F9zi9Jw2QTTiSiislB7AF82uh0WIJWqm9HrMQU3JtYUh8kgMD+irFuxKmujwLW1yUky 697YwUry+2qMp0ZMLpHzFjbUazJeoS1kZbNfA5AWR0TaICkkyDJfwcuMf98zkGchEZpXdvZmnH0
 WtpbUoMalw/x2UYEh2mQQIsjC3Rcn63m4EDKLGTsHVPLkmi+KU3ZEdiIfnFmCCQVInqxjs0y


John,

> This value in io_min is used to configure any atomic write limit for
> the stacked device. The idea is that the atomic write unit max is a
> power-of-2 factor of the stripe size, and the stripe size is available
> in io_min.

LGTM.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
