Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ADE6EB7C
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488070; cv=fail; b=u/CMs3Ipaa1ZuYTxMpcj+iKOvGD3yUUi0grDhN3iO+DxOnf/KNoRLFIVAEKkKIB6PsZ4RYdH5y9GDxCpgJEt4HOi5rTirWTp1uxq48qeD4UkGjKlqb2IfUBMjA5zv9g9aRW5RrcHWtEFYeW4V0wGR4IIIPbfn2TV5SyOdyLe5Bs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488070; c=relaxed/simple;
	bh=eAkRDIfdgNvY7AtV87QwAzHyjRXDcN99Tror+mD3NmM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oCDkXesmTNVmptsV+3xuobHeT3vUB8doAX+88S5Vg0VEKYl3tYypkh+vPc9Jl1Zbosy9696EcDzUx2qyDkKI5L0foN8ApfaeItFp6+qfsAEJYu5Q0vyb6HhxR28Iy//XSm2Pe/Jusa6smwTtVZEBxmQhZMyREo6V2nKSqQCoUik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R8D+4JU8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d4Ni1nzA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R8D+4JU8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d4Ni1nzA"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BqnO004593
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=2b1SBqUb7RAVjjDr3PKL+unEbw+rufvv4HkLyA+M2QE=; b=
	R8D+4JU8jU2K2zFU+qwxVyRyM60PARpk/XS2xRZb77KpPo5QHgO82VVzdXnbHJKt
	j+tOezrIf+sp8QaFZf29lSA+LWhi6ECcKYySiZeT7UwQL0y2nyhl8Ud/wjJBJ9Vp
	tvVd31FXexMw/cgxfFgOTOexpN+GkpOiKYHmT8Y0/XkgM6860yxR7fITcOYOG4Kr
	v3y94sHAaM7fNDv27Wn7azBsOlrWnQhKH//Bf6wDXNhKG8MLWmwoZpZ0heHVbMjE
	LjEa//1bqL6YC7sUdcbtThU7ghblYoQdCYDnjIwgqGFaTaBopilMMlj94cHUeTCM
	7odjoxAOmRjTYb4EIqZUXw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43jaj5db99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI1JLxF000565
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f9dc3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eLkHF8DCQT0KXvuNk0FGbhCR0y8u15Q+0kJAjqnqdU96LwxKd/50aqtORwU+jaPkAvKshL+xUII+Ax3UIGFjeM+GWJH4OLkaUVYKKmqaLiwCXvGKRItCrDq/LB5/xH1q7pLPFz1Z9kLP3Pep78EnFqV1x58+KSUG0ZiQBtXA1T9qfrEhRzND0IxMgccJGvTsC8N3r5El8y9oHagadH+msaf1ReLY9/ToJeKygpSS2bE2anLtqGwuTb8F4WRYDcpPwFljsZgdzZP2gleS7kyj5BLWW/fy4h/R+7BsSjHBCItaSMoVJxN2KFNyK6Rj1uYVMwM1sIrqDiq3hYGBMAcFVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2b1SBqUb7RAVjjDr3PKL+unEbw+rufvv4HkLyA+M2QE=;
 b=nMa8/wplmmoD8kGAs5spOxiZ6bUk3sXGV2YWDl8pT/mJnAMl8ekAIQevc5VBCGobNkMpzw9jBjFr6plzva7jAebXdqGhXf7Pu1VkiO2/8r4hjlvqvl/tlmJ/fZvb9xp29pewm3/Lui5j4/3y+8bqzR1GIJu5GoAFRsvSnj2e0xCojXTYoihSrkjUyEFqXhI0VIbsMg7W8vmWESo5NiPs5OjCjLaZyBgbol8fpxxC4sUSsGB6rHn5my5MAQ1OtZnAaaf1x/gJFujQhObRfXe58KriA8kfRrqnfpV5JrYG8Uat4j8vw+99k4l/FH8l5ivKW2dDvwZ7mUReZVCi2akzhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2b1SBqUb7RAVjjDr3PKL+unEbw+rufvv4HkLyA+M2QE=;
 b=d4Ni1nzAkqAp4qYLN+kY0iuTMtRGPxhu2xDyEGvtusl2D9aGmYRkNRCU2EF/vADN51BOsjDaU5bOBlEyxKLiaOS2qkDlqVnGLmzC/cfKJJOAWBBehXKFiEUA3XmQeI0WlVujXTpByos6wtyMhBD6cIU691Ad7jDdeiJ/PVScGMg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:22 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:22 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 05/18] xfs: create a new helper to return a file's allocation unit
Date: Tue, 17 Dec 2024 18:13:58 -0800
Message-Id: <20241218021411.42144-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:a03:80::48) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: af30b3db-21f3-4ec0-6ede-08dd1f09afb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pmFhTZxusFRZt9TxR+aDSWN5aTpp6Yfpu9qQcncTd2hbd7T/QeFjzu1P87z9?=
 =?us-ascii?Q?Zcigg0enViG5U5P+pxblx8Vy+o+hDe5oOFw7K5VPXtPUK6ZTJY+yFD6/9nU0?=
 =?us-ascii?Q?omNMG3kiLd36KuF5Jv9pOJtXRPKPS9Tgw2QN1R2pw3DL5Pu6JoxRJYvadACe?=
 =?us-ascii?Q?OT0Q1YVqZ9Vf0XN9ur/AYhr66LRPDmGGlxCRM6dZeWWjZWsW5kWxR+32w8eC?=
 =?us-ascii?Q?N0/zGyysqphi2ECmh3LCJHQyHnCQn04o450Ae1+/r54pw7c4HpaRJoo2n9yd?=
 =?us-ascii?Q?pHoJVGzNa4njsytKdTzBPWswizdkAy+VC5L3w+cwkS6Bhp1ETNoj2oW7Q9gK?=
 =?us-ascii?Q?otz2TG7jIKHJa1+Ot5X6PUG0cAx/o6kcJS3fLSvz6045LsqHQ+C10lMaefDE?=
 =?us-ascii?Q?uyeRR0acf3eas2L1MbxZLeWjUa/Vg3Us3EoVL0Gd/vmRtCdDbUTxrZJaL/KE?=
 =?us-ascii?Q?YaxVQ0vGNkwjn0vH3UsHYpvcgW8P/kEHYjBOQKI4EruUMaTPXSFavpSSIQTi?=
 =?us-ascii?Q?wwOlFsJFzHU7od8pOzkUOY4lPD7xWkN1hpC88jqlZSgxAWTegUuWB9IUtjhS?=
 =?us-ascii?Q?GkGG09SyaLfs4BsPkarGBoTF3nvyWtnJ0YLIl5D3PYvkhtqvZp3IrybihhuR?=
 =?us-ascii?Q?SnmTbUSsPeDUHU0D0zeKr1gp8Mh0bgK8aUJLF2/ajDxSyWWtD5ExTLtEbbK/?=
 =?us-ascii?Q?fCtwCAgC09lii/PcYKtQuw+qUmRwlJR1p8t+gMyeGMm1qb+lx2RA8WJbNaqq?=
 =?us-ascii?Q?U2P5hoF6vRCMLAsD3486z5XHP6VWQYJ4acLWSad2ZGzVo3W8nxlU5gSab7oK?=
 =?us-ascii?Q?pEW5TzFADA82S5/0BZu6brUHChxcEUnaeIfKpWJq1+ylReCvy1nxwvMLhh71?=
 =?us-ascii?Q?3fh5bRnGCMXcQRnoGc8Owapq8Twen+MFMWu8Ij782U4TMb3xdOFEbK0UKAZV?=
 =?us-ascii?Q?UJWPgVQBzLbrkQS3bgukdWCj+h5YE3hlxnQWhnADfWr3EgiPWa4aNtQmqyYl?=
 =?us-ascii?Q?yMGy+5STbmANKDcKdRDemXJjzoZs8GBqHea2fcDr6xk2htmbMP7J9lkalf7B?=
 =?us-ascii?Q?uq7Hn0Lul/f0dHN1MVOx7JVMRQbygqBtXHM8ZgSMVkLD6yJH0Zm/LluQHG07?=
 =?us-ascii?Q?i83DbXTfxCirEWpNko3W6D0sqvcewF0gRgnkrK6HVYPpmz8JBtRm7WReY6xG?=
 =?us-ascii?Q?5odtf5ByNIMJw2lAQkMVDFwdk17jnWFmDRnspgldLQtCKZOZhq7u/SJrmhKS?=
 =?us-ascii?Q?4b5MlFbBpke/RUZdg3uT/onxo5SmMvZpAFq7sian2l4VaEoL3GqyeYO7m84w?=
 =?us-ascii?Q?f59go7NTig2lP5ANgV/7R42PGjslKGAnL6CuTXXvm38O/H46VF/EH/8RPiLy?=
 =?us-ascii?Q?l/pkwFAEkQcbYiRfMJQao1ZToxz1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2mphwFw4BgN0LB40ZLkVul/nKpC5i0E0SK6y/NjX44wr0K+0QjgYsalKAqNA?=
 =?us-ascii?Q?up76SUjvRpMamh7Eng7mwxEA0QaPxLf9/lpHkkuaIWZPvN98QcW4zgV1rAkg?=
 =?us-ascii?Q?z3/Gp9zlC53ELYa7Vs8G6WCw4FGPgcXvCzaBefJab5/4q16mOSUPYkxmd3IW?=
 =?us-ascii?Q?dChwbgcbt/cHo3V4nrArbk6J0o5YQFSSXRnaDYivvZET5soGX7Wmh4NCRvJC?=
 =?us-ascii?Q?01syrx7ohq6bqlmxKYF7MUke90/kCl6v1uANCTHmGESFskAsgm99hRmU07zY?=
 =?us-ascii?Q?SQbgJX3gXrQGFW1Q77wtBQ5PAXqx0qfnLX5YjgWlCX6vDlzU9ptW+kvbxq+g?=
 =?us-ascii?Q?7rjg2SDXtYvsvsO291oKkDVvNaZs6otHQff2nTV9YwOrUMnYDdn8OU/0JBzw?=
 =?us-ascii?Q?bo9X/yoUi3bc4fMUpFLvfPuEI5fZxFcitoQz9DfP4iTiBvqkgl+cUXiAg7s3?=
 =?us-ascii?Q?qjvoUBB0upeSju3Fz0OhLxnYXRGsaCXVY++RDIiCt6un0yhDtmrAz6d7IPmU?=
 =?us-ascii?Q?D0y0Lm8RHHG5x3PI3Xr+Kyl7vWoOW1hvOU8avlYTN2ZZSWtbysj3B6N+J2tw?=
 =?us-ascii?Q?vw0oEBVW3t5vSqdUJ0fiv4z96bD4EPjAuscVMoSPaDjVr/FjElMnZKCbSrj/?=
 =?us-ascii?Q?mDuch9zJYugMqDpdsuRaXom9yECZcJuxnj51kvkcl+chguYAcaF+OJNEsidj?=
 =?us-ascii?Q?BHUyVs1FZyhIIrbGWjvg2Y0HjVlqosXiwjPsb1cm0N4fiFmZvCgCTjWqxHj4?=
 =?us-ascii?Q?8+98gDcOmdrGyw0OjHwgw1IluIcbqVnELxlG2Z3/MYzLrxJUr38IRFfy5gKH?=
 =?us-ascii?Q?rKZ1wN8ZBgFvl5X2SnTsP15PDYmIqqgMt1mTLjHuoU4LL2m99Dc1Z3JxCkJv?=
 =?us-ascii?Q?3bqSG0894ubF6OjoV0wTAV4EO6kMW6WXOihsZXHCvZ9zulM5E4iqUpzk/s9N?=
 =?us-ascii?Q?oDAvUFBXuUvFJ+txAD1lZDt9CqijlbHlUurYBzvDBDSN2/DJRvAqNX+s/zUN?=
 =?us-ascii?Q?hD1ZHusKtimPLKhNVInVG41U5dlv5+o3Y15oeKRD84M/wbNJCEm6RTsrM+lZ?=
 =?us-ascii?Q?1rjPnRyctBU7mF8z3WR8/4zRY9vPTfvTHPkf36u76KZ4XWsFHMlQmxEaRZ+u?=
 =?us-ascii?Q?XDPIwLCKsqFotZoqYybCWgFtos2BTOAgimqKCCSz0szX5iGpWeF6ii7xW2UG?=
 =?us-ascii?Q?6H5TkRSdLkxFu4O/wMcNuCt89pLM+blhFkus1WEHzGTnX2l2a2szqZrqq7Oh?=
 =?us-ascii?Q?TawT6weVj3pDoaF7aT6RP9whwa6M4GgWVzaiTnighaBiNZ1EfJWa89U2VaWg?=
 =?us-ascii?Q?8sTBVx+gE37uQVU8Tfd2g8S/M7uu42XLVAuWP43i+D8adZdkAdTJPdM0L7va?=
 =?us-ascii?Q?993IDj9eQIaQ/z7xdP2sN2IGYQzCYWs6NYmVQGuwBYsUVLasINyVpZFJlelQ?=
 =?us-ascii?Q?4mgkoynI5Ixgt54GqNTKGQOaXbMMyaMyagmvhZXsrAEJtQrMdAYntiZQ++UJ?=
 =?us-ascii?Q?QWFfiknTtB8W9k0xnE8iE1yPzXyuHY294kVI/XNgS39UqTaCcWXtzJFN8Oix?=
 =?us-ascii?Q?vrWK3H++wxmBPZX0ko2VP8YQfv2FcjfghkT8tHOnF0SlMTZ9S/1C8wEiT3tp?=
 =?us-ascii?Q?H0Zv5wbwYM+8GJktAeopLhkzmYo7U9lOEfgKdiE4hiLgdOq+w+Csb9cQ1tGR?=
 =?us-ascii?Q?wJvmgw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RNfiGa3qNKWFa3L1a1KaoscKViYVngNtW0QAxG0ZB8KkiKcF2fEqghS7ROdLUVedNN+uXlYCdIosdAJF5Due9dpI1k02Y9XivDAgiSkBjZrgxiKuE2cujnU1E8Q9WATEAJDPn7jadYs4mblrMmxWm/F6vBeUXf1bXEFliEU9nmOCf2yri/ie9y+s5BHZ4Kju0z58Ox4glzaIpOyveAiWiR4xMZ3VzQ268K8oDL9HtvgGfvxMxh2wMuxQgGEpSWtc1kwQDjilBac5ZgDSKKBcmNTzrdH6KuG2mzDzXLNadmpUDy0K0HWXX2I+4Lt30qjTdShjpck5f4Gx6VzFgcTHtqLS0DlUitAdsw2/onpy0i24tJoYhfhgM5gJq+L14tsilKZppeIEPdVKo2RPgE9JABD3zEvDRi8yZeHtHiHMlk9bkcfS34Z11GBjv+mwjJsRalNcyAEEb0+KdiCUCcY7QL0t07g94hIgG9IEQr3hHC/wUaRNXtg3DsjVXT2O8L7y1GXqBNXwLnsTKjz74xLDF9mDG6Kq7LvJs545YH8GwOgLZYIswqgK/ElfDXhqanOeVqFqxViABgtEFjlDRos83Ub6/VHZg1LWELc87TfGYlM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af30b3db-21f3-4ec0-6ede-08dd1f09afb9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:22.1380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFTJE9VgTS/rmXHVyrbQbHryJz+35LWjGaToEf4NDyLYBA3YvuuBLrX3B9odUMctiN0Gd2EBEr+chqt8CpteLqjQxZP8wQ6FuAplm7wp9lo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: ceduvBMBnza8HJ5Z2LlqgorgBcT91Yyw
X-Proofpoint-ORIG-GUID: ceduvBMBnza8HJ5Z2LlqgorgBcT91Yyw

From: "Darrick J. Wong" <djwong@kernel.org>

commit ee20808d848c87a51e176706d81b95a21747d6cf upstream.

[backport: dependency of d3b689d and f23660f]

Create a new helper function to calculate the fundamental allocation
unit (i.e. the smallest unit of space we can allocate) of a file.
Things are going to get hairy with range-exchange on the realtime
device, so prepare for this now.

Remove the static attribute from xfs_is_falloc_aligned since the next
patch will need it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_file.c  | 32 ++++++++++++--------------------
 fs/xfs/xfs_file.h  |  3 +++
 fs/xfs/xfs_inode.c | 13 +++++++++++++
 fs/xfs/xfs_inode.h |  2 ++
 4 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b9b3240a3c1f..dc26b732aa24 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -39,33 +39,25 @@ static const struct vm_operations_struct xfs_file_vm_ops;
  * Decide if the given file range is aligned to the size of the fundamental
  * allocation unit for the file.
  */
-static bool
+bool
 xfs_is_falloc_aligned(
 	struct xfs_inode	*ip,
 	loff_t			pos,
 	long long int		len)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		mask;
-
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		if (!is_power_of_2(mp->m_sb.sb_rextsize)) {
-			u64	rextbytes;
-			u32	mod;
-
-			rextbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-			div_u64_rem(pos, rextbytes, &mod);
-			if (mod)
-				return false;
-			div_u64_rem(len, rextbytes, &mod);
-			return mod == 0;
-		}
-		mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;
-	} else {
-		mask = mp->m_sb.sb_blocksize - 1;
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(ip);
+
+	if (!is_power_of_2(alloc_unit)) {
+		u32	mod;
+
+		div_u64_rem(pos, alloc_unit, &mod);
+		if (mod)
+			return false;
+		div_u64_rem(len, alloc_unit, &mod);
+		return mod == 0;
 	}
 
-	return !((pos | len) & mask);
+	return !((pos | len) & (alloc_unit - 1));
 }
 
 /*
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
index 7d39e3eca56d..2ad91f755caf 100644
--- a/fs/xfs/xfs_file.h
+++ b/fs/xfs/xfs_file.h
@@ -9,4 +9,7 @@
 extern const struct file_operations xfs_file_operations;
 extern const struct file_operations xfs_dir_file_operations;
 
+bool xfs_is_falloc_aligned(struct xfs_inode *ip, loff_t pos,
+		long long int len);
+
 #endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1e50cc9a29db..6f7dca1c14c7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3782,3 +3782,16 @@ xfs_inode_reload_unlinked(
 
 	return error;
 }
+
+/* Returns the size of fundamental allocation unit for a file, in bytes. */
+unsigned int
+xfs_inode_alloc_unitsize(
+	struct xfs_inode	*ip)
+{
+	unsigned int		blocks = 1;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		blocks = ip->i_mount->m_sb.sb_rextsize;
+
+	return XFS_FSB_TO_B(ip->i_mount, blocks);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3beb470f1892..0f2999b84e7d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -622,4 +622,6 @@ xfs_inode_unlinked_incomplete(
 int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 
+unsigned int xfs_inode_alloc_unitsize(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
-- 
2.39.3

