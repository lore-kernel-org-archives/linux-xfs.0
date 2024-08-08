Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28C8188CCF
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 07:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723103339; cv=fail; b=GV9es0xoV7UFFtz7RSoj8RLK1Sp5F5q2n+zHmwOADlPwvM5gBc8O8U8oVgQKsD+Ta+NO4t8lkNUz/2sxb3tzUnNCxwDBbVmltGz2l37x0RG20GoFZBefrBP36V7VUhQuIgsaHaeL9x+9LP4RKDsWdip5+6BEaYrxmU6Tv3iQuGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723103339; c=relaxed/simple;
	bh=gyiLwfJ7v/dwWcjz75/q6U/niCcf2rMKZTKmI2kHnTc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=XKEAXE1kTOzfFCmF/0/tMrhTI0S1IKjoGCP3t6Uax905gVhkFf2TXFJaEti53CCymQepcD+bssSZ0+D874SIBjlHYDOAoGYdHP++UeCbw6msOdyzJ4ob2FhJNNb6FWX5TATB/iEq3ci9J9rfg/ezK2x+QuDJ+bUNXBCb89woXrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bsHSCaCi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oqv7CtX/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bsHSCaCi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oqv7CtX/"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 477L3P6G031112;
	Thu, 8 Aug 2024 07:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=O6toAZgxRwaY3z
	6WjMhNDXDlPnKgPPX0vSy0rr1vpNo=; b=bsHSCaCiBo/MKZ79NJxFOPyVkvNxXM
	ZwyXspfRkyJm2Ax6eyRQptrchKeObgobjrBtIPi0KDeFCUs5mlPyFGbla5PFGlP1
	CIIpQ9GzkMxQrFtbVDmE+LGVty3+RWfvbOjvyK82s8l+hKiu6LXiVdX+a+fZgJJI
	7VVeorepSK4b7UhMmrv+F/ODCwctgrbj3FaOMM1vUOyTU2sCCNsw7nwX3S/MdC1G
	6+E9dz+4vnUHuTPGDzcUUocg1fpVc51s/Ug2pabuic+fUlCqtMmY6UPeWwrj/MgE
	LMnhbapYTuecvOeOAsKVFCMqZDTWCV9E6N076743y2ORHP8fcw8gkigw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sbfas9u4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Aug 2024 07:48:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4785Le21027295;
	Thu, 8 Aug 2024 07:48:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40sb0h9eud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Aug 2024 07:48:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v30mTGjY6B157A8cURr45PNharMkU02JcsIjOkxX0/Iub0J2xDRYkZLVJmeoIx0mCksQbfSwxyk3HqIrRPAvCqpbGsl2s4HZgZu8GJMbX0GO9OMt6fGvm3GSE6Z8xBs1ZXVtKInin5eKuEwcyf3foJbGLGBSMx2eY5bfiUmYIJeM1ACzA7yEN3qwHfaR14XGMFKwlPIIOyytAl9CeN8+9sXRBEOhTmUmsE8/q0B0XGogYGwkFdn5TInNZ2MYtn0k9O0XJr7xDleYCt/9YtfzeQmvlttm025LOhM5uDqmt/aax7pGED2jqzT5gC4YlyiF99UWjOM6dQlMfhFkk5yHOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6toAZgxRwaY3z6WjMhNDXDlPnKgPPX0vSy0rr1vpNo=;
 b=RP9W9ITQX2c/B6YTNXIXDYgurZQWMd+p2ryfLKkB/uQEVEIh6jxqGUvkOiMlvDWZJs3Hg7o8vUiN7GCX53MpsjUjWiMzQraDARpRvFea9zKURwJ+DgL0qPg5bqulfjoo930tbzgKvv+q+PvfWAYqSw7UZfn98PJULOFUf5C7xMkppzeYMi09N4p0QsvjKrckTh2KINl85tD28THB9TgSVtOZprsHVwCCqApGpiTvsZCZZo7i8zlnjc5Z8swmz6UBBDSpiqa/O71YYNUTP5GacZfHPyLRmxmleyxvZon3SlGB9ElkoIq0rOH4T3wHC5d6SoGx14d33eWUorGx38GzIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6toAZgxRwaY3z6WjMhNDXDlPnKgPPX0vSy0rr1vpNo=;
 b=oqv7CtX//gLkzbY+0zD/hFcqcrura39riFRRQ3oQfg/TiI1OIDscBKYBoN6reMCMYciuSg0sRgPfqNCTt8wCwfYbtihpm52lQk110yShxPm3bIGbYFTlV/6S5YU9d/OU/AaQnb3i2YHVKnYfyajo5KBKBalaNIBc1pF4Iyv5et4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7917.namprd10.prod.outlook.com (2603:10b6:408:207::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Thu, 8 Aug
 2024 07:48:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7828.023; Thu, 8 Aug 2024
 07:48:45 +0000
From: John Garry <john.g.garry@oracle.com>
To: cem@kernel.org
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH] man: Update unit for fsx_extsize and fsx_cowextsize
Date: Thu,  8 Aug 2024 07:48:33 +0000
Message-Id: <20240808074833.1984856-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0063.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7917:EE_
X-MS-Office365-Filtering-Correlation-Id: f644203d-660e-4e21-4ef5-08dcb77e87e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kr1AXc/HCx6fdJdOocz/eFBFo8++IZGFR4AxKrVrmxvzDJeMKcSusi1Fpx4x?=
 =?us-ascii?Q?JDXzuisjexd876tUqrc+M7yv20i6C1+layKmRLl1CcGT10tAtyfEQLiYBkfP?=
 =?us-ascii?Q?0t/gJpTIWd8PgZMd7LZVxIHtSzwwBiwiwz44BDPhGFSLwnFhHrwik3NDX1h3?=
 =?us-ascii?Q?3ZpIMQ9nk3JyIqgCl65BLlkLKrebecAUJ+408SqgO81IZnKZmCnP9Zk7Lx4M?=
 =?us-ascii?Q?A5amF0xl7JB0bV9wncayCBQ9pNt26isSoD4Jfa7ry1KrgQ4AlJqpSTJYgDmv?=
 =?us-ascii?Q?iwWs6BhICByConDcLJln+7Y0izh5dq66VgGWtUz3Fro05idtYAGDQ0y5e46G?=
 =?us-ascii?Q?o3UeqYN7QwQOPI3M0C5UMevEE+V0s7XQ+xDK7Zt6y5p6jq82GHboxZ34nnHW?=
 =?us-ascii?Q?cPvjkcl7NLIz219YkejuAjA2YuueD758OrgLikH0fuquT9RKzVifTdiGUizn?=
 =?us-ascii?Q?C6o5nz+fx9RATgSciQ2BzG0GaPFwyqlhaRutxTZEdQnbCjGYx4UKIO8i1Trc?=
 =?us-ascii?Q?nkP7tikwHJ1/Au1zWXB3n/KIDdC6w2K/lVMEw+ID1UPdBBkSIr3w8WMGjze9?=
 =?us-ascii?Q?yxkiGIvFG6YTZJd9zn4w4mMHE6pfwQJrALij5DZ7wTxxLUqB5s6IkfZEPMkj?=
 =?us-ascii?Q?6wGWg1eaDOufAa+LEUoRegDg1HKiZXp/rpYZTQEF8dPadq69CmvdyY5CBAkO?=
 =?us-ascii?Q?SSGT4mbBa2+Z2uq2L5gS4cwSTp+WI44n21cp4nNe+anvr9Xhdov+lmXlcNOF?=
 =?us-ascii?Q?0XmI80pNjSKRmT9d0v4WHAz3hlo42ZX+JGQx1P/4o5c9wJ9KeWN6KSu6d0c+?=
 =?us-ascii?Q?rNBrq5XAu2/Iwf5v3agMrO66MfNZV4dW7zn4vQpBJZ4U1CyX0zP/FA4fh5No?=
 =?us-ascii?Q?XVpkPOWhcGyWzA5gCeQ4HpmjG4Bu+7sk1P4S/H3ivH0MnrTfq+uvqZ37Oj3f?=
 =?us-ascii?Q?XWq5GpvKMrlrW8/wxYOS0AyVwebcnNQLLX+/zw41OhjmcY59UBmHLNFCo9Jz?=
 =?us-ascii?Q?4se3FEXMWJef94yQEGpDB9r8C9KRQE93dWSbfh/JEsXJ4CaQNwM799miSn1F?=
 =?us-ascii?Q?cAeYf3bWnakmRkk2t1Cf0FDc9OW6k1oDTbVlIS3dEM2rdUmKONc3hRQ3COPJ?=
 =?us-ascii?Q?RLa944MHCxDQNR1S5tAYTbPTwc5vXyIyN4w28F3uE+9dJXyzr8Zr5OWRLj+D?=
 =?us-ascii?Q?5HcuLmPDiAURw8cDAdylJcMYIinL2UWfWhWxw/wtIsNf7qaxm7ATXHICc4ZV?=
 =?us-ascii?Q?gdZplzO2rlESM6sMllhWPlq791TvI7ECMaN6inLJ4I5lRGssUVusLY6TuHGd?=
 =?us-ascii?Q?JfzJMvo38w4/U2XOWv2QWhadypY4ZSql1W3JQGow4cO1hg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ru5f2zxM5AmbE5MVBX5itXk9+P7SxDUF/6F2cXq4kCR+Dtsrl1ZaqmeXyxPl?=
 =?us-ascii?Q?b2svYiLp92wT66tH44zv/Q6Y+gl6c8yzEcr6b1dFT172fSh5RRNyVGj458mW?=
 =?us-ascii?Q?33JHCPT/+aLyk0SzIDlBLe7X1C8OyVrtI9av0Eh5/slUFn29ePMC3Q07nMC+?=
 =?us-ascii?Q?LzyS30dlL3v0bAvMGU+8k8LDH68zgsw9OY/uLbf82p9l6zH+rLEoa9YTh4Gr?=
 =?us-ascii?Q?Y0VVioWMq2JbB5CvW9F01q8xw7AXpOsX4idCdViZY9ZkItor/yf9l50sbaG2?=
 =?us-ascii?Q?VoQnP0924Dhawe0a8SbINqmCH4EcjQmWlHi1h7umSa6IOwbR+ir9u5EvFOV6?=
 =?us-ascii?Q?ryVLuoNt39L4iLBDPSeWx3Ruxb68cTP8ZABbcD/KiUyxV/yjYvod6vIzZTno?=
 =?us-ascii?Q?3Srb+90FpU7nvK3fgtjlmc5cB3J8hDQrqoMsawd5wkpKyZUivxPcRt2mPq0z?=
 =?us-ascii?Q?o8Vt2icsqnOThWUyWXt9qOtodlymmBAomi71A9703MAujb39ruQTv9PWD4i6?=
 =?us-ascii?Q?zJLMncZEFC2/ILme1U5shsVEk2/yrZo7baZosHCDZHZqWiR/vHm+/XRiabNn?=
 =?us-ascii?Q?Q2FDpnt/39zkcAcoBZcU4UXdAmx79ZFwU8Z2Pfag2kbRV1hD7jQuym/+EIxG?=
 =?us-ascii?Q?XyQ6ye3iN9L1DxVyGiogI8cuc9IWH0QU5wg1KanlUMJXwi62M3ErHbdIz/3P?=
 =?us-ascii?Q?MDsFjw0DJ2QEjOLb15Wdx0f0A1q/BZivguKHN9II8hsQDyaEDzMU79KkrV74?=
 =?us-ascii?Q?I4Ug3h6JBSiPRiM4DYqlWORv6IiOQAYynDdgUriOW/GQKzXn6Q2iZhLCHhq5?=
 =?us-ascii?Q?3t8U4wZfoQUPiie9pxnp3Qpl01WLfSmN2+EfFJcWwaKPcjMKwouD5EdUrcsb?=
 =?us-ascii?Q?uVVEnF+y7Z3WjsAL2yZl4UvXfkJbB/JBN84yNVzmAqMOJlpFuh2/VBRuW/cg?=
 =?us-ascii?Q?BwLD4qEZT9hd2yhqP1iHQIcDMa9xLiRadjBtbYaus+iFRbCrJbgo2jiALsUd?=
 =?us-ascii?Q?BcZTjM5lqqVo56lG9MpYnoCBTFyY3e5izzsB/2b+/a+QbgVvV2D4tRsZqOvW?=
 =?us-ascii?Q?5PAq/w3rZ7LSiCA/yiCmmT2IQcZRHVHHjluPQpT+jxit0buo/e3mGqw3Qxju?=
 =?us-ascii?Q?LlUGd9YnkOV7PKKf4XxMCxPQqcSfjWwS7yea6J3kuIsKjR6RbCqKfdQwx6zj?=
 =?us-ascii?Q?ZnVQrJs6l9NJ9/xTfxshHVJ/ty1PIXePvi4jcVN0jrhxvgq/egACtxkl2SQg?=
 =?us-ascii?Q?DJkApA265E5n1b3JAoIv+2GIaE57/MQ6IY9o18mYJVD6UmaAQXQ10U7/P2FR?=
 =?us-ascii?Q?m3v4ajUShsaEy7hykEKVHw/9N1L2CAZBe2U5dLp84JBIWfsu3AtbbdDEh7N/?=
 =?us-ascii?Q?m5mE4HnRjxXTD4tJ0GhzGUGXzRDP+2YL8Uq9/ZRveHtx+yo+HMdMBSqptKnY?=
 =?us-ascii?Q?uPPyjHVLqBzUbIUX+PgKrrlSMO9nIZMKJ8X31VHoyc4lF18KoHnxtsvvxZFh?=
 =?us-ascii?Q?pLZfrfawnB6jOVH06BasALmvtletx9Cu6dmbxoX+RADH3wdsIaV2w8K7ctyA?=
 =?us-ascii?Q?vSVcG9uzTFPZlOEa5ffs8bSRp5BkOi8U1gE2HgGB/2OkjUijMq8fkT9Vuh9q?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I1qKRUqH1kTpALUo/Q6ytnZqjNEXaCfrMlufIz7KG/lgvbaY95OOYXV3KTu0EmOJoyQ6hcxnNsYp0rHfKKvZOpvyaUI2n+iVxa0XAL3Q8VRvWzB0YNHfdBpBFybyo/yB4Q8Vrikg82KviyxttROflpBAyGGWCU7fjwNWYIHKUUw5KHLwXEnv/U5T69TKXdWWD2MVnKRtfeWhS7Kw5Jcny3qSA6+ZiUUeKhTwjXqVrEaAjB0lugwY32ieoysg//Ntr9GCap6+0ppzRHE96d6we1Hx3DOrEgELsSQwgB4u2Gs40CtfMNJGi6Fk4tTGy/Vj5+2b7l+WL8cX5bCOJ1U4/JDR5AF6XptnM9mhi+8LpsEsY2I89LUIRnDWewC5Vqh8sBKAzt9+sNqN3BtfEKig92dah9cf85VYHX275t4u9B8+VUHEhE0W8pSYh5oWDx5ujCRx+o7KOMwI/9uh7CyO0NGXpXT00KnyctgUA3fHi017LnG9Hksw7QbDGnhunw5Q2Rv+3sAdwRXCMhrzAvPspHWzsoVlcdKTsnl24QxReuej8SCmv0f899j6URqHkjkDMrMyMV6/k1FYP3rfE+UaDxuR4NGxqhG2pIDp3emHiyU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f644203d-660e-4e21-4ef5-08dcb77e87e1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 07:48:45.4098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s4/BWqw4mfkekT4BKbiBOsa2vn/SY9GaBtIAZXI5aAYUQRMqazXQs5vpEbFpu94Mk9f+ODlI+KynD8upSTCC5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7917
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_07,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408080055
X-Proofpoint-GUID: 2UE2a74BBMRt-f2ADmaRnY2uiLLEcerH
X-Proofpoint-ORIG-GUID: 2UE2a74BBMRt-f2ADmaRnY2uiLLEcerH

The values in fsx_extsize and fsx_cowextsize are in units of bytes, and not
filesystem blocks, so update.

In addition, the default cowextsize is 32 filesystem blocks, not 128, so
fix that as well.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
index 2c626a7e..25a9ba79 100644
--- a/man/man2/ioctl_xfs_fsgetxattr.2
+++ b/man/man2/ioctl_xfs_fsgetxattr.2
@@ -40,7 +40,7 @@ below for more information.
 .PP
 .I fsx_extsize
 is the preferred extent allocation size for data blocks mapped to this file,
-in units of filesystem blocks.
+in units of bytes.
 If this value is zero, the filesystem will choose a default option, which
 is currently zero.
 If
@@ -62,9 +62,9 @@ is the project ID of this file.
 .PP
 .I fsx_cowextsize
 is the preferred extent allocation size for copy on write operations
-targeting this file, in units of filesystem blocks.
+targeting this file, in units of bytes.
 If this field is zero, the filesystem will choose a default option,
-which is currently 128 filesystem blocks.
+which is currently 32 filesystem blocks.
 If
 .B XFS_IOC_FSSETXATTR
 is called with
-- 
2.31.1

