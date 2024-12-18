Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695B8176ABA;
	Wed, 18 Dec 2024 19:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549485; cv=fail; b=kVQ50Pw41GRM8wrDMF+ez95GIsfj1Apez+Utuc9vkPyu+vg6AhWcPpH/DY0JlB+vewcmczdLgWwKOyehoklK4aRG1B2xr+WBp4MpBDLXhaApc/KJ/wWZRKIq9aQ7aFIRfFMCLSeiA+6NqJwpmxndSEeKayQuEr4q4JV9CUowg5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549485; c=relaxed/simple;
	bh=2thgi1/9WqaVZA+zrrfzOA9mDvE/FlXDAUfJ/1ctKuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N4TIQs4C21AUQtwbtS3l9ytivqlREBpLN34yD6xd0CI7OyVd1xKavgK3sNAy4LC9vooqll7hToCsWIrD9ZiHfcwfmgvAaIObbAC7X1jV6E6yQNNlTFXORlg4imxCtq17fNdgmQLaJeLv2alEf6CQjyQUlCe6MKggEQK3e0hIlS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J1/mmJKo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WkpHxmew; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J1/mmJKo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WkpHxmew"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQlCI012919;
	Wed, 18 Dec 2024 19:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=7Id6XwxjqnOS6MwpTtVGAN8V23g4tkkNTtrZVGRjsng=; b=
	J1/mmJKorm4UTlUDy6L3O90QYSHnfJYa35u7/231age53obVb3o1TdSQZFuObbBx
	8VjGPMXjuhZiPY/buwCLOrBsyTvCveqA5hF55ApaSTxCscO5nOEV3eZcHE1Zdzav
	U5PTm8hzoaCurCZfKPPrNiMgvlYkR687lkc8Pu/GGAUoU/PotmpZ5aEBWr6ZPFSe
	23k1y3QYD3pDhmwOu7QEWN1h8hVjBJnYKE6Frzdu43bZuUVnSZGjB6n9xSUOG5WF
	9ulS8ia0imJgXrvcVgIBZqAy2/Koiet35iMoonnMEuBy3pjD+odphXjsnL7VhHVL
	K1cHZnAb2GyKKOO26Xa/1A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0xb1fju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:18:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHUWov000589;
	Wed, 18 Dec 2024 19:18:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fad5nt-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:18:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oYRIRB65cwB6jLIRImVJUoZ3uq3hMdmdaDEGVvSpFFYkqvGJpv7OkIjX8PDDGaUzQLLMOrRiY7lIWrGqaQMC0gG5FehngNb/AuJtEYvn0LETTq5xYnnF8PAe3zBNvySOH7enEt+EP1We6BOb/C9eyz9QVJwuairzoCQ6uuU9cwt+LSQkux4mR/izCTew59/m5VGFHgIhf6F8U86uCfibXyJUHQLprncQLWcjxKYkP9DTNlBDLn6mKB0D7++vND0tjfabURmHs9Lkxj3uprxuH3gEwB9La4MmAEfJKtE9PDc3FADFAJ1k4dqAZv6VToBS1jqpMAOPsdCN2fI6uee24Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Id6XwxjqnOS6MwpTtVGAN8V23g4tkkNTtrZVGRjsng=;
 b=Gp5h4157SFil0FyN/XWoYMQoxSy3RVNmJ+hUiaF6mGIgJsMcHn57NxTGV5LT56a/AGXZZSTN06dRCmrM9D5BhDgK8Q/q9xgnXC1gl+b9euEom5AOwg85L6vh7fd47uC5gKtdANK/nLSlY9wPq7jLzEMB0OAOto1AdBwJmxGNSg+agqOX1sBT32oRzyU2N6e2jE2W1vIq7Sv6nQVII1UYz6iLYiNvwgNUObjp98eKSKLofi4ndqcx6CHFSpib9IH43DUWa+orC6jH2nDwv7rVjQCh8G6Iw0fmqEVcgdGQTyrATYhqQZTp8tO4zLIG8xslrMd2SrlQBIBKiwYxMuToUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Id6XwxjqnOS6MwpTtVGAN8V23g4tkkNTtrZVGRjsng=;
 b=WkpHxmewGyXR6JeHYmFLgojgwkanUVQm7faMKDcyxH2sz8/x0rQI8EjTQIXd/dHo72nFQCiIQka6mfPUb9ViPOREzoxVSlwPJwVIxfZytzg9WaA8gxnsUmms/thgOzlXYaRlacGDhf2CB1WwIjCsawkYIBvT3XIuR7h+BdMz5cg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:55 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:55 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 16/17] xfs: take m_growlock when running growfsrt
Date: Wed, 18 Dec 2024 11:17:24 -0800
Message-Id: <20241218191725.63098-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 48a56300-b217-4ae0-0cd7-08dd1f98ad22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3Qb7CWfgA3V5QZq9mvhZOjD2OYgRsYyPPreX+kz0ipPW4F+D86cxEkFmcCKS?=
 =?us-ascii?Q?E59432KekC6Ivr1ptnPhkT7tKl8gzsHow8deSfsJGLklFSXDzKaKwSJ6SmNi?=
 =?us-ascii?Q?ICyEQaXOPO/+4Srugg9B2vKqwWcei4vY0QcF9687uvN5BbVZXP7Xp65imph6?=
 =?us-ascii?Q?6KvjePzVgeDrazz4IYSJheisl+XrTZ1rEpQjPNsKo8Fj8/duJcHZm0h4TTnv?=
 =?us-ascii?Q?Fp74j8ozmK7NgX4z454URFyaFLAWeeO2d3+LTFcrVa8A4bsQafe9CctZc2CZ?=
 =?us-ascii?Q?cQsu+HWp5NBZbVofDOxqo8KmHIVITu5pbzgKneDLfEk+3UPM3TkiaLphKBze?=
 =?us-ascii?Q?NywRhVc1wf+riH1Q/KdNEK1Cr9lZe5Gij3nMGPrzg88c/oaC9KWKcS7wIx5W?=
 =?us-ascii?Q?xpzdd9aJY3aW0g4BW+2CLfK6lbRLCWQuimgVjYQ+NUWqI/RPjSop76xrDcaz?=
 =?us-ascii?Q?kbSz1+J7A8xWXptizv7FpunbvoTa86A50tqjuYZuBBpJTSw2Qy8uJRHJmRDs?=
 =?us-ascii?Q?qhPx4NUDz1yS1gmjP64vzG6IcKoa5THwbVBsKtuIQUSfDyGzYzH8ej4b7WHg?=
 =?us-ascii?Q?iK8JeLKLzXBJA15Es6X7XufvB7KVbthsMVgIBjs213B/iScyy8lTWtZKRxN8?=
 =?us-ascii?Q?HXs2oz5SpFwz5ANmJQltUjHhGmCZW0RVW25TBUHQ3L8zENeqCz9TzZiSN5GR?=
 =?us-ascii?Q?X7VemxJ6UhXCQWA7myb7+W7R11aRYvhjaZc8KJJJWwRW5q77JoexPLuQjhXW?=
 =?us-ascii?Q?I3o08EoV/zjSRL8OYQz8jFrhRtTDsudEhd1R10+T7qWjvGGOP4Z6GQwYWkry?=
 =?us-ascii?Q?tXL6oVRNHnbhLOsbDc5mxSQeIM3WlLjFjLitx87nh/22Ay8ajGv0x5X6AUGu?=
 =?us-ascii?Q?NWj8thcYsvQp5oG99b6zOXCfCTICfA/lhJAtmJOJiBUny5TJWAXvY3wKy1Y7?=
 =?us-ascii?Q?uSzc0v+WWi/5Wv5UbdYTY+8enWvSsuIc2cBYOnNeubHYT1J6EVD69u6E5C5k?=
 =?us-ascii?Q?V57cqsFFuDFsfc3wDBtQCdfjO43KwjXGEZvAdauUgPnLhtQ3w4ACyIb0P841?=
 =?us-ascii?Q?V95YAosv79+WhcfaJikrFaUzxOFNR5ZGBhISbQ8yLQfRIp5sDXv3BujV097V?=
 =?us-ascii?Q?St8KIXZy7Bqz6XT2nlNrgjD+W2tjzsUsx5Ks6i6EubMa4UaG/NTJ3Y1AzMsd?=
 =?us-ascii?Q?Y6Ffc/UK5OEC4i+dCzaDtv6/JLMr9/ZrZKMRY6/r9mEoT/kGcXeNtzwg2DdX?=
 =?us-ascii?Q?ufdTOew/n+VJBTgdmF82UGWPhd6KyRL88jpPdh7iOYZLCCJ0Ys5k63o6pbzQ?=
 =?us-ascii?Q?bsMpMchAJsVH/dXlcVCXuR50TUYvo4HXkWjuPHwR6SPrJkuYZaG+w188LIwr?=
 =?us-ascii?Q?U1Tnle1tJVqLpwFvLf1LBBclujIC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0vulPxYgOWq9r7yCakzb2iOuZLPpaIXVxvPBHcoH04PkbnlJefraljzNz2Jw?=
 =?us-ascii?Q?MciG21hqt7CJcwuua/y2crWfuT+hK9N8+HjCOZzNbl/s0eYreAGhV3kROswG?=
 =?us-ascii?Q?lzZYgsHHK6Ex0j3iA2yeykOLgf0xXjoyGHFuNAN0drlvC8lYbPH8jMRPpfMe?=
 =?us-ascii?Q?QcMU+68MQ5p8m8mW2TvQemLSpRLd7pMxDpMYJkqxC5JQ4JvStjTyZ994DmgY?=
 =?us-ascii?Q?HK94hulsNprzC/ShA/eK3TfSTuvKssCsTb2LdL8BpI1Aw+VkslCpYHMG7g26?=
 =?us-ascii?Q?VQ7HGCxW2/ubuauLHAEhPr5OjATsezWLTMeH4Du8lohWH3jm84YV8LdhoZZE?=
 =?us-ascii?Q?K9JL6sc176mnUEK2lYt5z/9bD+01TPqbwxCZwUZ2LNFdKmA2jOZ+IBJSbksP?=
 =?us-ascii?Q?TajBW6/xZeGvwLQMb/uQtbhsL403RgYqQPnZiXBN9hNYu+phlXroh2qhSZ2X?=
 =?us-ascii?Q?KWdG4Xl7CunO35Fc9hsjql40AFpmf+GFKbctGvMpTXQaqku6JTwgDW5Z1AlN?=
 =?us-ascii?Q?uqWIyF5WVMJlBC/kRMM4uGfYddIVu0gixwDFlh2Zd/aetWiLUKrYHXKsKYEw?=
 =?us-ascii?Q?Z3B/WpcgAzwa4B7VzQ0RpF6TZVh42+qXpJrJtd3pNJIsT3gy6hG3arWjEBk6?=
 =?us-ascii?Q?DeoZFxjg5hOWE0QJa7pqnjPHwuKHLWrk96GpCbjNGQb2FpEh0rSYkUdKSfue?=
 =?us-ascii?Q?2W41/c42oArBZVA5Y811mKUrcinjDEIeut5IruCBptSlGbbLaFTyKbPOv5a/?=
 =?us-ascii?Q?BfxLDIdU4zivlX+XzEow3hr4IXTMPw0ly5trmvIrjUjTgVoor4mvs6NfygMd?=
 =?us-ascii?Q?t8/ZXnra+ldBf3dteVJRMNa0liEaMylgkmK12j79h/cObZxN/25vJ25ZU5FG?=
 =?us-ascii?Q?1fUAbbVHt/joy9izzBvT3puE2xl98o/ZalGcvXgtLHcEse8xn3t/gGJnCKpS?=
 =?us-ascii?Q?tsTteZHyW5rfCVD036g2fu15mW1Avx/4h9QZ9y5aL2pxSbxgmz0a9Uc62+cE?=
 =?us-ascii?Q?Fqasg8jmQLgqeCE9ZLyOlUxfRgP9cyF8vK/2Evzsu/3pisY0dRJcmOnMc+rG?=
 =?us-ascii?Q?kdYBbxLVcgkeAKRy+XJPmZ2sitM/6bZ9P/JHBzqONkcZePGTdty9gFG3OhuP?=
 =?us-ascii?Q?v6cqPeDW1gO7hKkLmpInj+GKqn0gHYFM6TBXftP0ghtAZR/AMJe3EloEuRvu?=
 =?us-ascii?Q?Amb0lGL4+QDn5WFKEP8JA/nJ1jGPDhaVOHECrMVBsqrfslqZZ5XamIpDRr9A?=
 =?us-ascii?Q?J982SpS6XZ3XH3X6P9obL8Xl2Il28uefeLDG+6yEczyU1HPHfKqR07TE5vEZ?=
 =?us-ascii?Q?H0KxU8H6Y5ocWxPyNkwtpaqberHpIbNbLfIKw3s+KJG9FHdZHsaT414exN3S?=
 =?us-ascii?Q?WBHFCK7sjwWzBcgMCFU828yT3o8BOJn7dsxP1392Pd7jM0GEPcRexZN6wDRW?=
 =?us-ascii?Q?VUoS0b62qGpo7iHywBOvVG0yMT9+Or5rqwq7uJVwvOOWVrKh9phs1V6Lt7mt?=
 =?us-ascii?Q?oqo0LaNRkTaqo5RUwBpYLczHLz1qzKx/5N3zOJV8ABkUYeoTwrZYQuc+MILn?=
 =?us-ascii?Q?pVBGVOHQ5i8PwV42PEqDa+Wtv1kV+cnQiIIQHMO3PTmRCg2zT92n2SgEPP0F?=
 =?us-ascii?Q?NzTgXnQkgh2UFdcx86/xE6oPtt0fwav4skJzG8Hu24gdGtt3hLYVZ8V0E6+F?=
 =?us-ascii?Q?YnrEiQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MjSiOh5HIKbKss7CaVPCzdjnJ3ji2ax/WLbEA1SiJkxMkwt0WwNICLZoj0Lg8othan9q7IU5kotWr2IC6yS4Q2NvTSNVP06wen/7RGkZ3vvVN9YXgkDpw8X7Rk0Gt0Yg2J149BaXuZjh0jIAwOjFeHoivDc2NOzB0bLv/5NiDOSPgbCh6jObYIBH/vLFuQfgadWfrgabC2i832qqUtOxF9cZmqnXNzo4LObyCkRNf+OueFDv0U2FUhfk3MD+P4Z67LRb+Ly4ZCn6grG84QqZZkEfSGmV+zT3VWRkAiocJcBlc9ZA5JIi0wNQ1oCVEFoxWvkliLmSjoqdSSJN/ZoRiodLUGkM/eBCubxkohlqtDj4JAA5oeo4N5llr0653deBUQ0J09KpwHGnXrWp+2SXMxmPRZ8vkUkTQnybPdTZombAt5AX8T5tBTVDpwdy6gp4CyyjA4qx2cAqLbETIKVCF3Tx3Xp8R3IodTe1scUpGQ1Rz93X5pWhOFYhLBTOJjRJax5h5QPY0R3WFRoJmCyaOOwJ8qnaitdv9BF7vfOCPicreBPn0Zv0ZCVLmYaQuYP7OeQTaH5U3z/UMO/h6g979EiX4Ho27pPI82eaNnnNZKk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a56300-b217-4ae0-0cd7-08dd1f98ad22
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:55.8224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FKyYdM1NUo45jA9hJyhJkOQBo5OtpUQpcuApbQkOAvTdjQi1Y9Ubxi0x7d1TVwhAPAD07edXkhlHsOFYl4X4FXR9sHIHpxNK2FKN7eSVupw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: kfJ-FbWnoosnoGbHlmkC0AIfbzIPWwFy
X-Proofpoint-ORIG-GUID: kfJ-FbWnoosnoGbHlmkC0AIfbzIPWwFy

From: "Darrick J. Wong" <djwong@kernel.org>

commit 16e1fbdce9c8d084863fd63cdaff8fb2a54e2f88 upstream.

Take the grow lock when we're expanding the realtime volume, like we do
for the other growfs calls.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 608db1ab88a4..9268961d887c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -953,34 +953,39 @@ xfs_growfs_rt(
 	/* Needs to have been mounted with an rt device. */
 	if (!XFS_IS_REALTIME_MOUNT(mp))
 		return -EINVAL;
+
+	if (!mutex_trylock(&mp->m_growlock))
+		return -EWOULDBLOCK;
 	/*
 	 * Mount should fail if the rt bitmap/summary files don't load, but
 	 * we'll check anyway.
 	 */
+	error = -EINVAL;
 	if (!mp->m_rbmip || !mp->m_rsumip)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Shrink not supported. */
 	if (in->newblocks <= sbp->sb_rblocks)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Can only change rt extent size when adding rt volume. */
 	if (sbp->sb_rblocks > 0 && in->extsize != sbp->sb_rextsize)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Range check the extent size. */
 	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
 	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Unsupported realtime features. */
+	error = -EOPNOTSUPP;
 	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
-		return -EOPNOTSUPP;
+		goto out_unlock;
 
 	nrblocks = in->newblocks;
 	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
 	if (error)
-		return error;
+		goto out_unlock;
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
@@ -988,7 +993,7 @@ xfs_growfs_rt(
 				XFS_FSB_TO_BB(mp, nrblocks - 1),
 				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error)
-		return error;
+		goto out_unlock;
 	xfs_buf_relse(bp);
 
 	/*
@@ -996,8 +1001,10 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
-	if (!xfs_validate_rtextents(nrextents))
-		return -EINVAL;
+	if (!xfs_validate_rtextents(nrextents)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
 	nrbmblocks = howmany_64(nrextents, NBBY * sbp->sb_blocksize);
 	nrextslog = xfs_compute_rextslog(nrextents);
 	nrsumlevels = nrextslog + 1;
@@ -1009,8 +1016,11 @@ xfs_growfs_rt(
 	 * the log.  This prevents us from getting a log overflow,
 	 * since we'll log basically the whole summary file at once.
 	 */
-	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
-		return -EINVAL;
+	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Get the old block counts for bitmap and summary inodes.
 	 * These can't change since other growfs callers are locked out.
@@ -1022,10 +1032,10 @@ xfs_growfs_rt(
 	 */
 	error = xfs_growfs_rt_alloc(mp, rbmblocks, nrbmblocks, mp->m_rbmip);
 	if (error)
-		return error;
+		goto out_unlock;
 	error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks, mp->m_rsumip);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	rsum_cache = mp->m_rsum_cache;
 	if (nrbmblocks != sbp->sb_rbmblocks)
@@ -1190,6 +1200,8 @@ xfs_growfs_rt(
 		}
 	}
 
+out_unlock:
+	mutex_unlock(&mp->m_growlock);
 	return error;
 }
 
-- 
2.39.3

