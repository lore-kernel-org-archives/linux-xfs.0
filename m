Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDC6224FD
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 21:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746653143; cv=fail; b=lHSyixHBRJzpANmbAwtavRPxOboX3f3yFPACZyhWB3I5bzDxSRCq0Gq/3Jwu3Z0NBby+GyqKycdnfQVQlW23AtkwjWnsyKV6oyvASg+MQDur2rem7+sK2jXrUs66FEQhHIntyTrhyExMiMo1rE8aJ1i4cdkUxeHlBLmzq4EUHFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746653143; c=relaxed/simple;
	bh=Ik2wWyJ2kym7rDlQeG6b1WOibU0ebr3cYV1HGkzM2ps=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=XrYxue2GzPqFUvovkGoxExP0csHQRsInst7EbToAETJyzHhfJE1ZcMa+0RaJSHrZcaR33m4CGpJREGdJuMIJLzwrKGKAOrhfkb+NSScgh/HjsD8VvwSigYQTG25z12KxWW9RqrUoEH0uDz81leKJ9o2fSRRvkqLBieKxeeGlc1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hgy8xp00; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hcpenal3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hgy8xp00";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hcpenal3"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 547LH9i0028759
	for <linux-xfs@vger.kernel.org>; Wed, 7 May 2025 21:25:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=NXb6ibS8lkTQG6Bh
	YuDUjWIecjYBnKHbI6HXrQkZteY=; b=hgy8xp00XnUI8RlO86Ftd1i3fulKS1Xm
	YNStbSRZCfIKn0+ZHW/b9vgz7hEqA/GpMfx6N1Dio8lYvWQNuEaaGQu4bR5T03iR
	zyNSo182QoNvS6tIf9sGoFy6TSCzc7oiKGeUp10/ekoMj1jXjTueIKrVVKAiqkwK
	Up7h3o7Hivgeieykv1UJw+e6qs4qsXtehBFPVXt1ZMfyabBxzIL6dDTWepdW5Geh
	Xqz6E/lKnzZA4e7HFC0HI4sg74gByMD5ILprpfK3p+p8NpCsX/KXbpSuX5HqdGUp
	/6pecOBZ4WbZ6vtDKejK+cj4fZZc7Tf9F7od6RYd6n9r81tg7R9ZIA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46gf9x00ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 07 May 2025 21:25:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 547LLEjF007326
	for <linux-xfs@vger.kernel.org>; Wed, 7 May 2025 21:25:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46fms9h7qe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 07 May 2025 21:25:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=angoc7fz9H4dnhjWAsKxp3jHC4yEBnaeAkeJcxw2XS691wEfNBxUuzE1pnHqDLfi6ODtfu86RkMhG7UHGKb75wwH6mVBguo5flb1yh+nuCK7av8Jv/z15MHyamIZ42SI4Orrc3gbwvwveoquUh2vZ14U9fC9D30x+Bc6GI9Hserbl8zx93+8FofBl+S/aJZ3ycLQv3LPV2Hjt2ZCEDUVyw8ozTp06ZoMYZED/E2Zv2PH0m8OcGavtrrHzgHIKVICrlJbfgOwdb9H10zTbX4JyRv0fpKOVI9xb+9rbrTodkugrQMDzqH4JoLimFYZ4Hff6FO6yyfjNy0Xeh/iDFC/nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXb6ibS8lkTQG6BhYuDUjWIecjYBnKHbI6HXrQkZteY=;
 b=J6Vto//0iFgyMD19ZKmvKRLG5AvPF3TyXzs+k/FYm5pSV4wsjtHlDdL2NZhioTEcRm4E76wzWY8k+s+CqBvd7uvTadqpG6TrtXtPiTQvS1OKsZir1legsOgDb0L9jQKHqIxWEaMrSudgJ1SkuXEQS+NQGMkMp6OdMJ0m6v7orWXRQHv0Nsb1U8ZrkDo6JGASIx46igO8naf28pvA9BEOHX9KlHpg65RtA2pD0OrYY/YxARDBWjphzkzWlnSkX3jmFwFxC9LFceANJZ3yRsQbMFJvu90Q28/YPwDXtBViPXhJ44/p9ALpFNU1/vjnCEqwazOb59U8OBm0qftjeXV3Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXb6ibS8lkTQG6BhYuDUjWIecjYBnKHbI6HXrQkZteY=;
 b=hcpenal3nL3Ui1C9X4UIBgxKZQyFrdjLHbZhUMm9/ydGu9f8WBjPKhneChksLD6K72fbI/5zjPJr4/NWX311y1kaZtgCHy/qmiZ0jbLU9S+syo5E5DIiKdsdD0psOLq8530Xbjf8S3SwcqsPgeJgva8GgjKj2kHjzJu5EqKIMCg=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 7 May
 2025 21:25:32 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%5]) with mapi id 15.20.8722.020; Wed, 7 May 2025
 21:25:32 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH] xfs: dump cache size with sysfs
Date: Wed,  7 May 2025 14:25:28 -0700
Message-Id: <20250507212528.9964-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:408:e5::7) To PH0PR10MB5795.namprd10.prod.outlook.com
 (2603:10b6:510:ff::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5795:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: daa7d9de-ea28-4366-59f8-08dd8dadb270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?im7tKcjbZOXYEHlZipDhVpN2egNxZ0wqeMIGUdWi1NUSRBm0T/2L9oH5SemJ?=
 =?us-ascii?Q?pig74ok+QFBRMCG7GMFr0X0pQJQ2cqH6SiB+UKBnFzWOMUo/JCsHILrB6s3k?=
 =?us-ascii?Q?L/uxXtYmtXlKt6nbjZZEoWno6gYN2gCkghDUItWdxwuZy33aSPeLVQEpgBSG?=
 =?us-ascii?Q?J6rGeZsRNFKwh4opdvXxmvzSKEXxMblplLw8GAfMQ20TWeKzvIQhWmn2AM1q?=
 =?us-ascii?Q?EhqxjzgLwXa5zzV9mEBHINctriddFeTiKij0KNUWETcn/mz+gMgb8wuvsxqk?=
 =?us-ascii?Q?MG3FVVK4X0FKABUK2r5+dxXVbAQj1SF8c1jTDMBZ30q6IpSDSTqPy4NLutbO?=
 =?us-ascii?Q?8QXc1Pa6it/NWAXJf071+pS62rMD+Q7/RxjbIOkoao2lb0BI/mh8yLTrPMWv?=
 =?us-ascii?Q?Ndvn/TSxpyZITtvXmXC1sYTrEWr1y9kPApw3XawfWL3AzLgRmmIufX+nt3/p?=
 =?us-ascii?Q?ya9j17dDzwlqjlqJz9/Y067Iu7m6xXWfF0MeCRUV76HKc5y941NNzEXhMtmT?=
 =?us-ascii?Q?r8B6bXfiml+iXIuoPD0IsZkKVcG7dfrUzBhtEKUAzh8o7MyLuEjoc34xWWV6?=
 =?us-ascii?Q?f+IfpaHcauYs/386cZQ6dIHRK2yTnFrQNncpRtH5KAAQ5z3mkknhk04SoVpG?=
 =?us-ascii?Q?pY97DVwSMwpjth+xc0mWdp8M3hX+PGU+bxO0Y8IBHeIGocOOrf2xZxPK5/6C?=
 =?us-ascii?Q?IBRxxnIyCKcQGCLfSVnBHUknacdNOrV3Qv6onjfCKf9p2eiHxQAiEt+2PI0T?=
 =?us-ascii?Q?8rp1VG5mz5bcDMi55Jf00MwF/NC4xBoO9k4PRtvretXZ4fUgWn7FtX03tzkM?=
 =?us-ascii?Q?vv/asZ5QUSwobeNcVxHYEy3LwGP7MGsNpHpwtfFDY7xWJmpRD1HPB9x7akZx?=
 =?us-ascii?Q?B7w7KktFaRxyunvmdI/7P/z45812gsZv3cOyKJafJX9kVzsK0bd0cCLiKZWA?=
 =?us-ascii?Q?a6HmnK7g30zvJbDaOYeBpfzgvUEXj288KvYGjzrk0F7VFoo31MGIup3h3bPO?=
 =?us-ascii?Q?+TN7sNkqwsTGVNFBPrAzEauacCajVwDBIkF1MDg5UC0SBfrQ2I1x0tkkbfrc?=
 =?us-ascii?Q?TdGy+t9tqW3p8yTzDgueH1xETN1HNu8LfnsXxyGy7/Y2WiI1p8Yry+vg0ic1?=
 =?us-ascii?Q?it43W5fC8Vv/cxGhzOg+gduGi7YvlJU5RerGMhvMNRfcf6vxxLVmQv9OrD6s?=
 =?us-ascii?Q?jc3GCd6uyVqb1v0zry9HQI+YaxDtupesQ2j71bELbIgzeVFtrbB59Xp9f/l0?=
 =?us-ascii?Q?6FSeJHROdZTSahSGa7+iHEYJZ7gNU4W4Ave2M0+lDOlyGmLvhfFy8qg4zQcm?=
 =?us-ascii?Q?RYoTWY8IS06ybx9wNumsHEw9l7QaiBc941ktmtd94eRbjNHV6M0/KjjMCvRI?=
 =?us-ascii?Q?b9d7haLBi1TZVEJJvUq1IIlxAwdDjj/9LrbXEy0Sw0OgxpkYRa8uYsZ6LaIR?=
 =?us-ascii?Q?/hohBb+QaHs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MtUFOZv7MMXf5cV3I/yr7+TACSiXW4ZbFc6zGY1nTBuQYB+L5/eVI5Fl68TU?=
 =?us-ascii?Q?YgZDD8hrwD1Aoqj7fC5nhzT4sSnDNQPaPkDXVIiTcEJ+9m1ASd7nl2DVJur/?=
 =?us-ascii?Q?OjQCSnaQYTqDsrepWDYsGKsLESOOJjoMWnSJo4WAe7gxpGy8WTtorgFXuK/W?=
 =?us-ascii?Q?3kzlJi3YZw5CnnF4qvIrxiFAeh2fkKlCmCtignhf7s+FNdpz1cKuFZQxxY43?=
 =?us-ascii?Q?YD0Vg1keTO3kFt+ansS+qbxMriE63uL0LTjYr61MV2N+WNJRDaTigejZn8Xt?=
 =?us-ascii?Q?dIp+ZkMePOL9rn3+A2Uot2OPzADhwj8uLqOZ9ZXaDzHIFheMOxlMnlJBih91?=
 =?us-ascii?Q?4gQ41Ae8hQH2s24rzqrssHX4TJRHItzHMpgdC4ko0yLccWa0QtziqgH5Gpwa?=
 =?us-ascii?Q?Kn/LRUb1XYldJAPelY3n60S3MUeIHJkRPYZfQX2Mh5X4EvyXZgsdp+QWz+Xn?=
 =?us-ascii?Q?3opYUXXXWQMwP5Uoywpjv7+rUmvWnbTPxRBd6861oyOq+FoC9vP2jJAqNrP1?=
 =?us-ascii?Q?N96QOTS66ZJYwgvvFzRAee2EB9nMBk2dv6+jtormBF0a5DHZIG8aA92u1RwV?=
 =?us-ascii?Q?KbgIZ9ZHSJlvi3S7gQA4Yj6zRf9r4AasisJmUTSX/ikBkVlCV6jiGD7DYpQ+?=
 =?us-ascii?Q?6mx4Nc4SguYc6LBPo6qn5DaDnwAxPs1AIhYNHWunqaOYKjJKy77Yi5jHr1Dl?=
 =?us-ascii?Q?ux5jLu2ZVYPJ65LuyuANTk9WzXwRyMGwZ6Zx/cgd3HpVchAo/5FccNcMOPHN?=
 =?us-ascii?Q?YKdAiv7VV51IblVifISjh65QVg0y7uTQAdhPmq1/YqYW5PLdwiyftxxQvP9v?=
 =?us-ascii?Q?Xlc5WE4bSYSNrWyxhoRiUpBoR+gEogA+DWqJBLx9JG94HvcfOSmO3tT0xpMK?=
 =?us-ascii?Q?wQpgspsbUyBsJAaBFSBuYwJt5zkMLkDbejvo49ej6Q4r+DOwXpH0WyXhSSTI?=
 =?us-ascii?Q?9+qinF/W8XvH8HX1P0eEK69toTpUcFILo62bQBA9MrCwnGB1tOVjVdy8AQsg?=
 =?us-ascii?Q?8VND1ZMsMp5DMmrmubBL8gmOlB6mRc38oGNaSV35C3qtPBMgI2TSkfZCXnjU?=
 =?us-ascii?Q?yzs6VbX/pIYWFS7GCmTGoeJ1Zm36or4haYA22KxGXQDREIUjTYERHup4IFpq?=
 =?us-ascii?Q?ZjJkSxHUL6tHdWCOOOvgxSN50U80KFbXtljT8IoiR8osKk0jVgeeUGF2b93I?=
 =?us-ascii?Q?8S94F+qmemRfhxOIbmpbLhiL8zNcwUnSfX7I4HswBXfWc13SOBayXy7OBg0z?=
 =?us-ascii?Q?EwGFoUQPt7gcJBytR0OzoAZwEkd5ov+2JaKvQ5zqI6MbDs0hHDJ++fg8gT+/?=
 =?us-ascii?Q?M8qtH9wMbpgL7GhorWBdxEnR5gIi4pF13qGGyX8gXCaYBC/U545z5rr5XmKm?=
 =?us-ascii?Q?JbQpFruhIXF3kGR+ERs+Qg9FCWZY4r4za3x9jAZdNfzp8oGBjl90b6UDtOKv?=
 =?us-ascii?Q?4AR9w3dhKWwTX01Kg3YHF78kew+ev1rg0IXa8StmxE+yaJ+CHHzd7A3MxcFK?=
 =?us-ascii?Q?jI+jqKSqt+7kbNG8kYqvcM7NhOt66kmUuyxEMC/o8cj27y5PtNo8vGetb6hN?=
 =?us-ascii?Q?naMIDyI50cVdprN4V4/WOx1dYpFfVaZv0dPVgON9ojjyjWbFO9vJWnShVAS8?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RLpP1ASbp6HB5K7TFR0yfN2BS6AGWolUebs/UdH8qljxWqsfZym7pOSUknEw/s75KgBfsXp85Ik/RPADZJOPmggQJGlA0hyGs34ykxZSZFnECtPaNb6uhTdd8NNo0lRhaVVCMYaNtKw3GoGgL9+lWf0DdGz1N91Fr+4CXSPbTJEW3Op9Sh/qOh4i4iMzXrAFyZJ/I2C7mQEx5AKmuRrbijsAQr69nyF2goWueaS5i0pIFr/RhINTlXFlhjOja1sXq3RXbvM14oKN1l22yOtd9d+EWDg+dDMCttb2v1QXIPBKiEfAx+TJdV97X3kaf2GcIW+B3l70EhW8I2sdYXPOEZveJfuOY29UiNvrp7wYa7CYxN/rIS38knARh08AHgvyktZXPUVrWJvgdi68epm5hpmz1+PKSZUDbIXshMj4+wHpjNKYz/rkZX6j4pqvmp4u5vGLRNzejUqnxrCDbzbMhioQe6hgwPyW3AEDaELMze929F6sW1kvWMFaYWh9yFOE7IEwkiR2HtgM+IGHiY5aAafUT/DON0a4Gir0Iz6Qh24Pgvc1wLJ6N7tGkgSYDO9M47cE7CuK/fTI1zSXApK92mIX6Y5F+f3Mp2rPtGeiVMU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daa7d9de-ea28-4366-59f8-08dd8dadb270
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 21:25:32.2922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6C9x+B36cK/H0smxsL5pt7RQXj6u8uFptMI4r8UDtcDYxGUh1MXByBUQ+VmAwumZ2Kz8607Vylro9SDSrRsW99iWTMlIL+r0O+5jo/dzqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_07,2025-05-07_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505070197
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDE5NyBTYWx0ZWRfX1NulOSgrCRCv hX4mS0nu1ZBEI7BZFLJ1pZIdV4sH56fJF22g+Txy3Y8LEcvLEB8yjOflQ+l0pJFSkkl/u4pOmaJ 9kLWEOuiSNnI4ffp0JZOS89fFK35PX1JlZ48Mwz+LPLRTTORJxFJbcmME7Pi8InqoydYsa/Z9FD
 Tfl18q+rcp75yR+Zl7NUTLPnJ2Zq5+6H2/v6ju/QMLmDKkbZq2e1INZZTMawafiADamvOsUYcpq rFvPB6skemumAHGD40Lqj/8deO87JXYtUSBcd2muWBME22y1sXsbLeJJ9pXuxFmSzp13Zhvd1fB Sa/4YXDgcH2vxO65obx+Lvznbjxvbuw6P0w95HfTp6JYAoVMMCZrGx1LdeZLZe6Pm87qo4Nd5uA
 WD9B/e275p4XuDe4YN07hehkeT9g27cg4arejqeHnIn9RjfS1PEm78iX9gzQgYJT3XbayfKl
X-Proofpoint-ORIG-GUID: PJ4JYfsQDO6ei2pI0MqW5BkExFqCANdf
X-Authority-Analysis: v=2.4 cv=Ov9Pyz/t c=1 sm=1 tr=0 ts=681bcfd3 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=-4EYkIDXW3_-auf9iWYA:9 cc=ntf awl=host:14694
X-Proofpoint-GUID: PJ4JYfsQDO6ei2pI0MqW5BkExFqCANdf

This patch dumps buffer cache size per mount.

Counters for buffer size 1 BB to 257 BBs are stored in struct xfs_mount.
The last one is for size >= 257.
When dumping the cache size, we try to dump for each exact buffer size
if the output memory buffer (PAGE SIZE) is enough.

Buffer_size Count Total_size
size1	count1
size2	count2
....
>=size_last count_size_last total_size_in_BBs

For each size, we
1 dump it the count is not zero
2 dump two fields: size of the buffers and the count of those buffers
  so that the total size can be calculated by size * count.
  We don't dump the total size to save space.
3 for the last size (if count is not zero)  we dump three fields:
  the buffer size prefixed by ">=", count of those buffers and the
  total size.

If the space is enough to store about exact output, we are good.

In case the PAGE SIZE is not enough for above format, we then change
to the following size range based format:

Buffer_size Count Total_size
<=1	count	total    /* for buffers with size 1 to 1 */
<=2	count	total	 /* for buffers with size 2 to 2 */
<=4	count	total	 /* for buffers with size 3 to 4 */
....
<=256   count   total    /* for buffers with size 129 to 256 */
>=257   count   total	 /* for buffers with size >= 257 */

For each line, we
1 dump three fields: size range, count of those buffers and total size of
  them
2 dump it no matter count if zero or not

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_buf.c   |  36 +++++++++++++-
 fs/xfs/xfs_mount.h |  20 ++++++++
 fs/xfs/xfs_super.c |  36 ++++++++++++--
 fs/xfs/xfs_sysfs.c | 118 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 203 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1a2b3f06fa71..9b0aae04745b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -99,6 +99,28 @@ xfs_buf_free_callback(
 	kmem_cache_free(xfs_buf_cache, bp);
 }
 
+static void xfs_cache_count_inc(struct xfs_mount *mp, int bbs)
+{
+	int idx = bbs - 1;
+
+	if (idx > XFS_CACHECOUNT_SIZE_MAX_IDX) {
+		idx = XFS_CACHECOUNT_SIZE_MAX_IDX;
+		percpu_counter_add(&mp->m_cache_cts.last_total_bbs, bbs);
+	}
+	percpu_counter_inc(&mp->m_cache_cts.counters[idx]);
+}
+
+static void xfs_cache_count_dec(struct xfs_mount *mp, int bbs)
+{
+	int idx = bbs - 1;
+
+	if (idx > XFS_CACHECOUNT_SIZE_MAX_IDX) {
+		idx = XFS_CACHECOUNT_SIZE_MAX_IDX;
+		percpu_counter_sub(&mp->m_cache_cts.last_total_bbs, bbs);
+	}
+	percpu_counter_dec(&mp->m_cache_cts.counters[idx]);
+}
+
 static void
 xfs_buf_free(
 	struct xfs_buf		*bp)
@@ -113,6 +135,8 @@ xfs_buf_free(
 	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
 		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
 
+	xfs_cache_count_dec(bp->b_mount, bp->b_length);
+
 	if (is_vmalloc_addr(bp->b_addr))
 		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
@@ -196,8 +220,14 @@ xfs_buf_alloc_backing_mem(
 	 * allocation for all power of two sizes, which matches most of the
 	 * smaller than PAGE_SIZE buffers used by XFS.
 	 */
-	if (size < PAGE_SIZE && is_power_of_2(size))
-		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
+	if (size < PAGE_SIZE && is_power_of_2(size)) {
+		int	ret;
+
+		ret = xfs_buf_alloc_kmem(bp, size, gfp_mask);
+		if (ret == 0)
+			xfs_cache_count_inc(bp->b_mount, bp->b_length);
+		return ret;
+	}
 
 	/*
 	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
@@ -231,6 +261,7 @@ xfs_buf_alloc_backing_mem(
 		goto fallback;
 	}
 	bp->b_addr = folio_address(folio);
+	xfs_cache_count_inc(bp->b_mount, bp->b_length);
 	trace_xfs_buf_backing_folio(bp, _RET_IP_);
 	return 0;
 
@@ -245,6 +276,7 @@ xfs_buf_alloc_backing_mem(
 		memalloc_retry_wait(gfp_mask);
 	}
 
+	xfs_cache_count_inc(bp->b_mount, bp->b_length);
 	trace_xfs_buf_backing_vmalloc(bp, _RET_IP_);
 	return 0;
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e5192c12e7ac..9141d0122fc9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -135,6 +135,21 @@ struct xfs_freecounter {
 	uint64_t		res_saved;
 };
 
+#define XFS_CACHECOUNT_SIZE_MAX_IDX	256
+struct xfs_cachecounters {
+	/*
+	 * index to the array is the size of buffers in BBs minus 1.
+	 * elements are the numbers of buffers for each size.
+	 * last element is for exact size and biger sizes
+	 */
+	struct percpu_counter counters[XFS_CACHECOUNT_SIZE_MAX_IDX + 1];
+
+	/* total number of BBs for last element */
+	struct percpu_counter last_total_bbs;
+
+	struct xfs_kobj	kobj;
+};
+
 /*
  * The struct xfsmount layout is optimised to separate read-mostly variables
  * from variables that are frequently modified. We put the read-mostly variables
@@ -276,6 +291,11 @@ typedef struct xfs_mount {
 	 */
 	atomic64_t		m_allocbt_blks;
 
+	/*
+	 * Count number of buffers and totol size of them per size.
+	 */
+	struct xfs_cachecounters	m_cache_cts;
+
 	struct xfs_groups	m_groups[XG_TYPE_MAX];
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct xfs_zone_info	*m_zone_info;	/* zone allocator information */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3be041647ec1..30bdb9382786 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1121,7 +1121,7 @@ xfs_init_percpu_counters(
 	struct xfs_mount	*mp)
 {
 	int			error;
-	int			i;
+	int			i, j;
 
 	error = percpu_counter_init(&mp->m_icount, 0, GFP_KERNEL);
 	if (error)
@@ -1142,15 +1142,38 @@ xfs_init_percpu_counters(
 	for (i = 0; i < XC_FREE_NR; i++) {
 		error = percpu_counter_init(&mp->m_free[i].count, 0,
 				GFP_KERNEL);
-		if (error)
+		if (error) {
+			j = i;
 			goto free_freecounters;
+		}
+	}
+
+	error = percpu_counter_init(&mp->m_cache_cts.last_total_bbs,
+				    0, GFP_KERNEL);
+	if (error) {
+		j = XC_FREE_NR;
+		goto free_freecounters;
+	}
+
+	for (i = 0; i <= XFS_CACHECOUNT_SIZE_MAX_IDX; i++) {
+		error = percpu_counter_init(&mp->m_cache_cts.counters[i],
+					    0, GFP_KERNEL);
+		if (error) {
+			j = i;
+			goto free_cache_cts;
+		}
 	}
 
 	return 0;
 
+free_cache_cts:
+	percpu_counter_destroy(&mp->m_cache_cts.last_total_bbs);
+	while (--j >= 0)
+		percpu_counter_destroy(&mp->m_cache_cts.counters[j]);
+	j = XC_FREE_NR;
 free_freecounters:
-	while (--i >= 0)
-		percpu_counter_destroy(&mp->m_free[i].count);
+	while (--j >= 0)
+		percpu_counter_destroy(&mp->m_free[j].count);
 	percpu_counter_destroy(&mp->m_delalloc_rtextents);
 free_delalloc:
 	percpu_counter_destroy(&mp->m_delalloc_blks);
@@ -1177,8 +1200,11 @@ static void
 xfs_destroy_percpu_counters(
 	struct xfs_mount	*mp)
 {
-	enum xfs_free_counter	i;
+	int	i;
 
+	percpu_counter_destroy(&mp->m_cache_cts.last_total_bbs);
+	for (i = 0; i <= XFS_CACHECOUNT_SIZE_MAX_IDX; i++)
+		percpu_counter_destroy(&mp->m_cache_cts.counters[i]);
 	for (i = 0; i < XC_FREE_NR; i++)
 		percpu_counter_destroy(&mp->m_free[i].count);
 	percpu_counter_destroy(&mp->m_icount);
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 7a5c5ef2db92..3c2f948c3165 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -467,6 +467,110 @@ const struct kobj_type xfs_log_ktype = {
 	.default_groups = xfs_log_groups,
 };
 
+static const struct kobj_type xfs_cache_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_sysfs_ops,
+};
+
+/* .../<dev>/cache/size */
+STATIC ssize_t
+size_show(struct kobject  *kobject, char *buf)
+{
+	int	left_size = PAGE_SIZE, offset, len, i, power_size;
+	s64	power_nr, power_total, c, last;
+	struct	xfs_cachecounters *cts;
+	struct	xfs_kobj *xobj;
+	struct	xfs_mount *mp;
+
+	xobj = to_kobj(kobject);
+	cts = container_of(xobj, struct xfs_cachecounters, kobj);
+	mp = container_of(cts, struct xfs_mount, m_cache_cts);
+
+	/* try to dump for each exact size if buf is big enough */
+	len = snprintf(buf, PAGE_SIZE, "Buffer_size Count Total_size\n");
+	left_size = PAGE_SIZE - len;
+	offset = len;
+
+	/*
+	 * for elements except for the last, print size (BBs) and count only.
+	 * as total can get be get as size * count.
+	 */
+	for (i = 0; i < XFS_CACHECOUNT_SIZE_MAX_IDX; i++) {
+		c = percpu_counter_sum_positive(&mp->m_cache_cts.counters[i]);
+		/* don't print on zeros to save buffer space */
+		if (c == 0)
+			continue;
+
+		/* "i + 1" is buf size */
+		len = snprintf(buf + offset, left_size, "%d %lld\n", i+1, c);
+		left_size -= len;
+		offset += len;
+		if (left_size == 0)
+			goto power_histogram;
+	}
+
+	/* last element, print size, count and total size */
+	c = percpu_counter_sum_positive(&mp->m_cache_cts.counters[i]);
+	if (c) {
+		last = percpu_counter_sum_positive(
+				&mp->m_cache_cts.last_total_bbs);
+
+		/* "i + 1" is buf size */
+		len = snprintf(buf + offset, left_size, ">=%d %lld %lld\n",
+			       i + 1, c, last);
+		left_size -= len;
+		if (left_size == 0)
+			goto power_histogram;
+	}
+	return PAGE_SIZE - left_size;
+
+power_histogram:
+	len = snprintf(buf, PAGE_SIZE, "Buffer_size Count Total_size\n");
+	left_size = PAGE_SIZE - len;
+	offset = len;
+
+	power_size = 1;
+	power_total = 0;
+	power_nr = 0;
+	for (i = 0; i < XFS_CACHECOUNT_SIZE_MAX_IDX; i++) {
+		int buf_size;
+
+		buf_size = i + 1;
+		if (buf_size > power_size) {
+			len = snprintf(buf + offset, left_size,
+				       "<=%d %lld %lld\n",
+				       power_size, power_nr, power_total);
+			left_size -= len;
+			offset += len;
+			power_size <<= 1;
+			power_total = 0;
+			power_nr = 0;
+		}
+		c = percpu_counter_sum_positive(&mp->m_cache_cts.counters[i]);
+		if (c == 0)
+			continue;
+
+		power_nr += c;
+		power_total += c * buf_size;
+	}
+
+	len = snprintf(buf + offset, left_size, "<=%d %lld %lld\n",
+		       i, power_nr, power_total);
+	left_size -= len;
+	offset += len;
+
+	/* the last element contains count/total for bigger sizes too */
+	c = percpu_counter_sum_positive(&mp->m_cache_cts.counters[i]);
+	power_total = percpu_counter_sum_positive(
+			&mp->m_cache_cts.last_total_bbs);
+	len = snprintf(buf + offset, left_size, ">=%d %lld %lld\n",
+		       i + 1, power_nr, power_total);
+	left_size -= len;
+
+	return PAGE_SIZE - left_size;
+}
+XFS_SYSFS_ATTR_RO(size);
+
 /*
  * Metadata IO error configuration
  *
@@ -810,8 +914,21 @@ xfs_mount_sysfs_init(
 			goto out_remove_error_dir;
 	}
 
+	/* .../xfs/<dev>/cache/ */
+	error = xfs_sysfs_init(&mp->m_cache_cts.kobj, &xfs_cache_ktype,
+				&mp->m_kobj, "cache");
+	if (error)
+		goto out_remove_error_dir;
+
+	error = sysfs_create_file(&mp->m_cache_cts.kobj.kobject,
+				  ATTR_LIST(size));
+	if (error)
+		goto out_remove_cache_dir;
+
 	return 0;
 
+out_remove_cache_dir:
+	xfs_sysfs_del(&mp->m_cache_cts.kobj);
 out_remove_error_dir:
 	xfs_sysfs_del(&mp->m_error_kobj);
 out_remove_stats_dir:
@@ -841,6 +958,7 @@ xfs_mount_sysfs_del(
 	xfs_sysfs_del(&mp->m_error_meta_kobj);
 	xfs_sysfs_del(&mp->m_error_kobj);
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
+	xfs_sysfs_del(&mp->m_cache_cts.kobj);
 	xfs_sysfs_del(&mp->m_kobj);
 }
 
-- 
2.39.5 (Apple Git-154)

