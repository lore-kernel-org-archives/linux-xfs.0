Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E741D0F74
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890899; cv=fail; b=GwDUzH3yzpP2yJs9lx2UOp9RBMt4i9ZT+7vp2qnTkQtI9C5YnVhgWcSxHtKQ9a1cCXPAS96QRd5TAavdw+ikMBLxZy+KJ9mqLAvjHLsFbQd46oducv1Q7y6fBsWMrdO5ytazZbB7G15GkI0/bbxDE6YiYCOlK8b2brE33VK7wkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890899; c=relaxed/simple;
	bh=GO/FDL+UYj3uZlQGMrB/2CKdekfe7KyVHKMCK/eZz5E=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nZr7k32jZWrq1kIE3oV9fSbcTQiZNqa+41MYwZFCSUu5wi0zhb2FgKIVVQkpqU4zRO7tUqiyXGKhpI+poTKlynQHGqDal+igPs9YE251OVeWKySaBqTGO8OxCD5cqG0ZUF9SqoB3FWwejdlpdxFAHZLYg+Y0/Jww7X+lcZIfcjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ekm0zhRD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GgCx5qAB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ekm0zhRD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GgCx5qAB"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfZnd007356
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=JfVAJ1s4jlNXvn5O2XfmUxuls4+9rdmfFiV4N2Pn/fw=; b=
	ekm0zhRD284SqZQ9mSWdT6d5XvtF/HdbKyz7jmpUYYBfYe2wJkTHwVChMmCL43q1
	TaYiixy8tC/bwKT/1x4STG687UVjtgXprbmAo8MnK5ztTQGhqq/2GSB2gZLCPZEC
	JiBl7aHSB6m/mU+dIGTgxyShIiLKfx0fNLpganOUGKaL7sK/cJhp0VAoUgWkrPX3
	ecCGHTjbybBZ95Q7xDTiwA/+4SbZ84jMAbClg8BiZoZOtjHSj6dK3MPWXyGbVQLa
	tyBWZgNupjOGvvk0A5aO96nnbo7D0GQaJFy+NuAus9TVO5Gias6MWiXX3fyloNay
	nNftYXZZNyLQK5crijRydA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41xabtt6yp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492HDTIQ038719
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:28 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x889782d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZcrW7QT57t+OyHv+wocVXoRBV4u67evDE8QYglny1adWyiT/bgr/Rm+jiGhLbNiVidlijJ0bxvziSvCZtw63Hq6fVvGMZbBDc1RwJhApREEj7mnBc/zem028bwJECAbWy0g9KCDLjHWs5Gvn2hj0EXx0c5TzHxKSZhFlZeOoj4Zij20PIKQUMYgEK+oUPBSC4SYebgeePPXPzpqEc9oMALihmsHSfTBZcNyXPfQte9yyWClwbzfOAt7QG1V3TN2ZLQIt2RCh7ppARKl2KDnx1/dpj09FqSC6++sHVFNsuwgj/7UhNJlhYy8AzaMmlKIZeN7BHgATw1HnAnG5Q8Ad7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfVAJ1s4jlNXvn5O2XfmUxuls4+9rdmfFiV4N2Pn/fw=;
 b=Ex/FyIGcuPKk5z0vQNuMLhEpmlAymmbwykI17J17AK9mfFkZqN0FrWfeiWg9mU7MsJ5duo4/VviWU/DidTZlQpqg3czFNCHmz9O9alUaAJNw0mPon8cOM5J3T+MCSRm9Xy5W/QtXA9jregdpSdmNmsE1fXvZzBCYyqS4wLjGaL+M+Ztq7W/xvGWA5KfacZEmO0ppSBHvxKDv+ngTDXeB6WrQvKYLF332LO2DjsYEg863ycZqP+SRvoHsva7n8nkvh85oDffQhgUNw16WmLDEZtTc2Gt3vbmp53Hf1UpYBkTyYP0o6VVC708Krwh51mMg7juwZsFubPpH5jEFzrBxcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfVAJ1s4jlNXvn5O2XfmUxuls4+9rdmfFiV4N2Pn/fw=;
 b=GgCx5qABf4oSIAimBopOYUokiaFd1Ws3ruiMaZY3Erv399hcdwfNgg+9p39OiewRnKSCd3pbNnrENpckvbPs5dsdU8rUmlz3m3n7BWifwkj7GIUydEb5JDSIV/X+NCiSlDNd/LKJRMSAs9yRLvoIMquG8/EYUrfHFzQsg7t3c44=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6047.namprd10.prod.outlook.com (2603:10b6:930:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Wed, 2 Oct
 2024 17:41:27 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:27 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 08/21] xfs: validate recovered name buffers when recovering xattr items
Date: Wed,  2 Oct 2024 10:40:55 -0700
Message-Id: <20241002174108.64615-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:a03:100::40) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: dd5702d7-bca2-4dd7-fe8c-08dce3097100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nffQbun/1srpN5TE+RakLs+JNQqhQvFVNFis8fHD3//fPuk4NVneM3k/ZgBT?=
 =?us-ascii?Q?DEb4zsJpDGIzlGX1wFrbGeWztKydz0Ye8cOlCLI7U9oJdG/GnloE8YfKO7TS?=
 =?us-ascii?Q?sDFn9GSGuzA61sx/77Xz7rs3zSzXX2sWvLSnvXRPhynr/do4p2sMZqT9ZvT9?=
 =?us-ascii?Q?y7eYzJbGPL1bAhX41/KaMp6FNZ4wZsye8UARn8t0ttC0vBNvO75/3thlRAyX?=
 =?us-ascii?Q?AzZgZ3WXIz57TUPQkxWZ5d9NaZN53eFAyL7e7qgUHBW5ar8XpuEFC4wddF1C?=
 =?us-ascii?Q?BH8qzRLea/XcHEAmWAYM+ZDrfxPO0eBmk7WrIn/3iszKH70rJPp6OWiuWO4U?=
 =?us-ascii?Q?/ezT7BbPq263J1TbLSzZ68mCtScmTRidPHepVOra9sQOAtAGno7E1dYyhl2C?=
 =?us-ascii?Q?MES/PBUoua8RwYecQLgv9ALmdVo/eSIwHZ8ixHLyn5MyB1BUz3yAusfuX85J?=
 =?us-ascii?Q?MgtOcMOEHeKK9qsjw+EQB0t5B5FhjlyGBTvcKnD73ySYTt0sFN52Gy0Dpkzj?=
 =?us-ascii?Q?0BhF/Bohlmqm2PT93hBTPvTxTaC17JYaCsLpsGJdK0JadFXZgHbxsEmofbpu?=
 =?us-ascii?Q?rR3vfzF7TdvuQI5jkUF51IuOULZH/F0Ii+AJwrHg3HinWmTMpsYfYKcKwbEj?=
 =?us-ascii?Q?sZEfxiWNvQcxZZ095NLzMXRr3myH9IKl12J5BPHGL5jpEHxRRrDB8ChBJgVG?=
 =?us-ascii?Q?pDVINHCq/aXSK9hK9ZMk2w0ODf/Dkm/OJyb2GSs7Z7DCXOWgfIA2dS/94mvQ?=
 =?us-ascii?Q?wuf5DWm+vIL4p2olqheVKf/illW85c0aTgiZzhJrqF6ofb9VtuPmAoj9o+xE?=
 =?us-ascii?Q?GhzeksmQ/qfR7+c+fwriaybeBjmhjaQiWxZRIUncufuw3lplG9GKBsjghCxd?=
 =?us-ascii?Q?zfAx87Yr9vUXur4sUWGDA0bolozKLIO0V/bjnWm6tMN5a5qjPzrdPk51Lnau?=
 =?us-ascii?Q?1Pe2ZjRTLnOyFXMyZnCb0pg9l70zyTsYManSdE6VYHzrCuTADwfgNYYb0LvE?=
 =?us-ascii?Q?XZ35k2o9Yihl4jB+O7Bm58TeKdiuKbhgAYEx+t2c181okdt85+afihvUHEi5?=
 =?us-ascii?Q?1Lkj0Uh3CUJETHQUX8uonKB5ACKfqeame16zWqISYifoJpxL551Lz8XRX12P?=
 =?us-ascii?Q?TdqpHtj68Bnqz8MPsLrKnRnu0u1xbIPBfKaHY0tQ6obeuRCiXYC6X7eT56OG?=
 =?us-ascii?Q?jHUJFq0p/jW+kl/1frRPGPewaOQALwMrZxnutDoPxIlj9/Y7p4zb0xfd5dT2?=
 =?us-ascii?Q?Jft0xBTCd80rloLY/Aq5OLrdbuN1/7yejgRbqnejJg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4vylG11uYyBmxbIAPrk1Ziiv9ukwL2mVC4iNuiO+wbdRtz2ql9pnLlJz50Kr?=
 =?us-ascii?Q?p0TB9JF+yhCHIWpTD3ltteD93xq+rEjZ2vOly/BL465jB4JrOUeCuQlGc/Zn?=
 =?us-ascii?Q?IBZh8PZR2m19N4J+CB2j09qdesqx4+K2besiY7hu7GeZTnl6PeOT7vV6M8CG?=
 =?us-ascii?Q?yuBvq/gwZnaCgMy6cAs5pfYpm2XxIM5OpVNQq2mYyQENeHrf8gLCej7+KJ3b?=
 =?us-ascii?Q?bm3p6MF/zvZeAnD7irlGCrAuQIZJdQ31geGLRo2iDoeyKS+MCFAvmBWZCLmS?=
 =?us-ascii?Q?V5+EccEhWghwJ1lZhWJ3t87nd9zzKDhhqUXVDwBUFIUNr/61An6hVVCzCXnq?=
 =?us-ascii?Q?oTsDyohUAL9ARX30vBojI8RRwCSN5rmnv/kv9gVEH/u4uR/ycK6qoxOesZpT?=
 =?us-ascii?Q?XXMwtRzALDXIAANnBseioN4MIeHXlQqHM1xTbjXonvtbmprijDVYcGNvooiE?=
 =?us-ascii?Q?13CgMRUg5g+4SzO3k+iKIHAwawIjPGjCSmOBE/6aeTpqi+J195r/D54WGr5e?=
 =?us-ascii?Q?XA/r8agtON98fbST6paqu0aG2E/ZDzxrCzj/Yd0DLsHZJuLzDHnDpefp72dh?=
 =?us-ascii?Q?aBDQNQjAZB7DpbUnQ89VJMptoYCOlJJO7ytz9R7b/yAMSOHPDU1+ar1eTxHo?=
 =?us-ascii?Q?Mn3fMwN5vR8NY+kHmxsN+f3ZvdWzwUPMoVtjnJtddSpWFs0z+sKfvuQswaZZ?=
 =?us-ascii?Q?1qdjqEynJTQZ3kdITacmWWsEH6acyBJwnIuuDDgeb3mH/easm99bw+bJoC0N?=
 =?us-ascii?Q?aO6tPUzWMGaPEKX2UkyTim7jUmkMpo0+xPNbyzxjTb8sOtHLH4IZqCAZMAd5?=
 =?us-ascii?Q?lMy4FI6YDubXbggWLmyVIrGBi7g7Y4KjrEfXhvkceo/BU32NMgnm5iS57ov6?=
 =?us-ascii?Q?h5FGqlDMfBrierLoENKucyLtfVRmwAr08wxO26pcVGHRJl9UK/ccgqH0B7e3?=
 =?us-ascii?Q?FbTvritASNqVmjGOont/9Hxrs47NBqxDw7RSz4M8jF3hPMT2E+joRzmSUDA3?=
 =?us-ascii?Q?aenYVdqUqw+YmiJCjvu+TvSptr9zpi1wAKBiDH+vuh+uPV+cXA68dS/lXEqj?=
 =?us-ascii?Q?acqjGhb4sGivVYStWfQL6UwDAruW9MZN5m/b0bPv14FWN8K5PNyIi2b7bwvR?=
 =?us-ascii?Q?Q4wXLCPUS5Spcf2ZDmBdjrtkndmaEyn80zEMnTtg4gt7bu1gj7cgQjH/36qO?=
 =?us-ascii?Q?bS2wpkBhbrmW7YcJ5AFxV7vaoiwOGYje+imXEu2XephZYdX1QU7KNel8MVlT?=
 =?us-ascii?Q?S8+ANR5lGUaDSF2jISWCRF3JwyE5U2dXYN9eM1lLU9XXMntE+/Mw2RaaS1aC?=
 =?us-ascii?Q?B6+VTVWId9pACLfCqlvHismi3kfWuk9Ki3nBelaPiLRdSGQpoYexWfotk8FC?=
 =?us-ascii?Q?LmrA/G0ktSz0H4EQdCEgdSPnF2QOwGfiAHp9liFzHIW9f8xybQvHaoHlxAte?=
 =?us-ascii?Q?KN2xdWjrgJZCoYSbKHPtw24subs0N8ukhXdLyCTbchiEV7VAAPO6wV3r3GI4?=
 =?us-ascii?Q?/oAA8ho08XEI184AzTTr5Eb0nGA6OVCXh3Ypz16gG2XhqbRjSOR5DGG0WbC/?=
 =?us-ascii?Q?TJeUsxXyZGP7KvFHFu96lcRrIYSqqDeryoWppm42iL9IRPA/HDzJeSFYAjH0?=
 =?us-ascii?Q?M9eF9hhGzGxBOHARFyifxiAocXxkeex6vD84zxR1/1R3Tm0d0a+4ud8oFOPT?=
 =?us-ascii?Q?UzwFLA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w/4rWhKcJdT1O1TJGzkKMpqu9DH21Z86GxCK4XiyUbm0xsV2e/0fxhzYADHkWIV084R70OR3AypDZ6UlKEVi2/9Cgayyotjr7cKCqwt+cRBW5sr7otOxgr1JzpI+tMvMH6ONHEB1c+UYlkxbDfDTld9VSDAjfOH6h0HcJPzl8rCT0epa76l9/9VZSlSaXviMp2LtinnX4g6q6nVeQkNZqW789tyOiSQHRmm/kjnDffZYkYaWQX7yrbgXVfz7b7qhrWo3BqcrVbtDZZBNrU/Gvbpxsndv0CatCyShLiSqHEH1aPWDFqVOV/vfSgJYl8iE4IYlBRLHPtF2qbkZhfv6/abvn0aLpc8F8FKGyaxZ/q5JjOetZNYIp2UwIafc3pKMByX86325RGLOGRmQ3ofW5AP/p3q/sRizg4GDHwFLj0yFgjTbkIDY/4AnV05FSzAcO3Lzd5uhbrnesfm3ugz0l22N4zNSCtmVr8m9hHR4CDC8q5OOlwuCPfhmRbVC/NDHrpyaQAx/OjVKGaDFbif8yTFwvETyQIdpaoRrzGwRIshh1Mtr/ZhcEjQatxpoGAbUgQCpjfk/gN+XvF6bb4tIyanWNzOdYM/h51ZaF2nUoYQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5702d7-bca2-4dd7-fe8c-08dce3097100
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:27.1303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxENKvbSF/JSphGbPHsJFkFop/t7WnrWbkhA7LpIf09YsSbKXfTUuhUbzO3vHKV28xrpbQGDTE/DT6ffIaodZHh5/9vJsz47FCHFfiQsbwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_18,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-ORIG-GUID: kB2CPiuApyt_joqbAg0aP8fHyxUlOM9a
X-Proofpoint-GUID: kB2CPiuApyt_joqbAg0aP8fHyxUlOM9a

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1c7f09d210aba2f2bb206e2e8c97c9f11a3fd880 upstream.

Strengthen the xattri log item recovery code by checking that we
actually have the required name and newname buffers for whatever
operation we're replaying.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 58 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 064cb4fe5df4..141631b0d64c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -719,22 +719,20 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-	unsigned int			op;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
@@ -763,31 +761,69 @@ xlog_recover_attri_commit_pass2(
 				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
+		i++;
+	}
+
+	/*
+	 * Make sure we got the correct number of buffers for the operation
+	 * that we just loaded.
+	 */
+	if (i != item->ri_total) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Regular remove operations operate only on names. */
+		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/*
+		 * Regular xattr set/remove/replace operations require a name
+		 * and do not take a newname.  Values are optional for set and
+		 * replace.
+		 */
+		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
 	}
 
 	/*
-- 
2.39.3

