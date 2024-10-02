Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999FF1D0F74
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890897; cv=fail; b=fIviiUy+1qdSiEPlEteFYERBq2KYncPOgCrnvtBzFGXOvCdCQkiPHSxUIWPm+hPIuPIAAPGbHbvTRUbMnkhNhvcfcBDcnJwENFpIYABXPwV9M1w5HqEInzdoms4b8abJ2yDEGpalw5X+KoLW3beD7jLyqiXQ3cTDvBT0XUtaq0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890897; c=relaxed/simple;
	bh=eRXTCtBtXvCBu7/qEje6FZr53o/zmKldRfeSYgKKdXU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eVOMRu+x8ZytoAlrWQRct8rNihL3IKcK5CWKOVkeLDBByVRZ26BRU6psgEow63fXR/KjjeHH+1WdD/sUsM0NhjMsvfXEJJz0HNi3tYj3gze3hgCihqReo1ZnJ5HYu2NI+ZUR8SIe9Vfsnd2sKA63MBuMMS1oR6/IkB2RTiGVNzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J/a4Fet9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uRUtKobE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J/a4Fet9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uRUtKobE"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfYa6013221
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=VDjT6l2To5Jm1qeP0e93E9Xc28A8PMY+mIabC0PgSBc=; b=
	J/a4Fet9hgzf7qdT30ej7ZqrrH2YUTczLfMEsfVb7Jygjf78gsKipq0nsp6H3ge4
	hfSk0F0n8A5Kh+PRfoECqlM6QYAGu0Xu08mSprCgVesuaiXCcOB6uEnZztycT3Xu
	jHlVyykoAM2nY74zXVBEWZhScawKv71zcV5PCU5VS/AA2cLeyiU3unrYt0KWbbSQ
	2Ti79RScJndsyoZ+9J46vul6o0Vb6lNAkRJXRwDNUDydyKN39sprnpqFaONPj7WV
	gBPhS9G7dtdGEWQG3URq6laYHSdWdJ2jhIYrxpyHiiBv9GSNU4+FWHrw5NNeMfno
	Ua00+2yvDCJn4jm8ABYzgQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9ucthqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492HEKWL028477
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x889d44x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XxL/VYgb/XubSLZN2XhOaL58hbck23D7C01UmgjipRzYF80NLqdcagqdL1OT3JngILZLtZXY65iK7QnsaWCCnwW5afqgxJJMsZu3axTHIjeFvxs5GALR5dr39SkP96rfNSm1JXcwojS8/DtCP1huvR2gpWMBe+u9ZMHsrhdjd04sCUnS/DQaCXil+sz+GlBgxujapzlxVkDF+BPniKJ0rh+KY7J7DydL4odw2CADwNC9hAI06IRBftj5xm7xelLJDUSYLg2xz+CiM6DwR6Nk7PijXEcfmRu7noCqwrXeWCgBxhumJt+u8WgmTOA9BZGZSwUQ7nlFpBIcZjBEh0TKZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDjT6l2To5Jm1qeP0e93E9Xc28A8PMY+mIabC0PgSBc=;
 b=kVYO87lUu69bN9BBsHiKxxZYrG0SMGrajtjz+KQZZVFkwE2D9rpxO8bfMv4tdN/yCOJicIPT4I0MZDASQjjEiyi2JNQ8aX6mCnpp9FlHzpWJcuPY+qG8lE9ZUNWOBbeD3k8qz5wteD1hogzQlNu4D9rarpCPJMVdpnArNIN8PBJ9kYWTDyBn8F5EknCJtVWRLqGAC/VJgQeem3wTiEw5C1T5DhGuPGTy74Tz9CGp8Co9dYyCxr7ZD72Y81kiFXHbdUlwnSElcGgGmYP3VSVH8U2p3KOb7ZnmMapsv7vLoZ7Vvrmmej/H+wu6JDYmqyznV5WHdZ5230EgTkGfnNwDKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDjT6l2To5Jm1qeP0e93E9Xc28A8PMY+mIabC0PgSBc=;
 b=uRUtKobEu314r/PxlMCx2cyU60G5qHQbwBZ9nUydLJ0CFm2LMSTi6YQJhtw8zdiZyc1BrVl8qbVvpBZN+PcFDv0YzMij5HGSpTOUio3evPfEEPeH15I7zwNDrr9vpGMlso6RB/Kix2sUWd4+FHV9LJNkaUYYTXhzzjvGXOA+A00=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:30 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:30 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 10/21] xfs: revert commit 44af6c7e59b12
Date: Wed,  2 Oct 2024 10:40:57 -0700
Message-Id: <20241002174108.64615-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::22) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e62c707-af3d-474d-4779-08dce309730c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lnAujW0pZOzUJh1Qc2v7htn4z8mb5xp3C7UoeDzaIsoTV9ch9LPNiIC/sElR?=
 =?us-ascii?Q?usJfgevdr6vk86I7ebJYplrhNDkAeWoyV8f1BuZaAjQWLcjUB2pVyYcSRJES?=
 =?us-ascii?Q?CJ9jbnn/zNWtquz9yLRFzsmXo2ar9M+S/PO7O2zxVQrY0uhxakfU92WmQRWc?=
 =?us-ascii?Q?fBV+bzlFANRqc1kGdkSRo0bTODyiK6U3bJ9eCkH51qUy13D6z3PB8FuDOmu8?=
 =?us-ascii?Q?lPyHl8pDn9k47HyIOuXYopAgy2OJOhvT5Hd4Ke0iB6oi+2OM+WwPMQGj1thh?=
 =?us-ascii?Q?bnE6zlQQxrhcsT9GZKMmwAVhoGzoxqBSWCSISahWg8/9apLsIOHWbIXcxPCl?=
 =?us-ascii?Q?c1AGr3eGWc8T3Lb4eDssaPB8Zm0DErvP3dg3lSv3D1QWEwpYv8qm0KAEbKZg?=
 =?us-ascii?Q?hFbyARKudHak8AA007Dky9IIINNyitMXGlsJNc7mWrosccF8rEmzr9iLktdl?=
 =?us-ascii?Q?wMRhpqbYY4xMSnLPfJeF4H5YaUloa+jsh3kxxIdsE19bBuTW/SqWBKjdtmYj?=
 =?us-ascii?Q?zbpxTO1ttlPH5hSIfa53C5BLfo+PI3Dg1k8IoxA9pJdGKg953QKjRHXe9JYN?=
 =?us-ascii?Q?uJLa56GPcwUrjxPUd9hUhqkEDlKSPIm8KFJIg9/uFMaGLSHipbNkoaZGAy83?=
 =?us-ascii?Q?Sb71Gwu4g5qFz1B2fpAE9pajcE+8mNDjd1oHW8sZYEEN6LUL70Hl1dzR4gZQ?=
 =?us-ascii?Q?4S19lXpo6BcYbzc+mDPcofVaa47/OP913oWUfqE+wzxYMsd885ScfNwxLi1r?=
 =?us-ascii?Q?J1SV+OLX/fQYbJQYTR99Ce09hoXnw4oVVc9/rDsoX4HlXm3PcFmJSmCj/l9U?=
 =?us-ascii?Q?Z6Ai2LIEo0d6U5Olui2GaWTVxS10R84lv3z4b1XTfWd1lOAefNf7Ht2aixAC?=
 =?us-ascii?Q?dRt9vy7Cii3JARKlpmghvtHEo0dFQ9fWpyuSPHeJJB4RCZDifd8FxBp9jxcj?=
 =?us-ascii?Q?8TAhTg0DaQpPWIrqXtX+zPvgGWeqmQce1uZFpkMbkFl8gUryj8nTCY7NVWj3?=
 =?us-ascii?Q?lsVk4i5nui1aIKi7LfwoPSTzXA2F2HrtCK/SAClRbrqD1ZPrZLtSPxir2e4l?=
 =?us-ascii?Q?SVsK9zHzWmwASkPRqRsq+jFqawpjBHsSTEG1Ri7W1qXG9+02zCGl+6nhv3uD?=
 =?us-ascii?Q?6CoqLt6VKR7ebiDkAnNhN9OoXbH4Li6xwOWUGcFdyLs/MaY5e/CZ3K11Plv4?=
 =?us-ascii?Q?lr0DWPWBlgBCxGmR0yWGfKRxCOxyHcQmkiraNGVSbHUWJB9HE7OcXAj3CdeN?=
 =?us-ascii?Q?BqXLt0BqmvEMH0KKuEALDXWN5i5/N1A9JiV10b6lIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w4WPO11uL0Q3luGaPMMIN7hRRgcOtu7rbtYqzJJGJmJ4vUiCxTHApOq8r+rF?=
 =?us-ascii?Q?rVW24rBSFhCiCpMi0g1zLLQq9jKH8MeZwVUj0WvEPjQkFywO1BFf3aU4I3cB?=
 =?us-ascii?Q?UjQMbDBO202suXQiPYG5AyO0OyYkPQqKeI+PVBrw03rAcWxkC51+zn/lizCd?=
 =?us-ascii?Q?T1igqT8NLlm1K0Xsorbh3EYyRvyzoSXGOtaMg7FpIGVlizHAemQ3Iq6proKl?=
 =?us-ascii?Q?6ATID46xzS6w8TGat0q7QcLdi1j+88ZiX2r5UgnrrMM8Fy/R35aj3bT2yRIZ?=
 =?us-ascii?Q?6kuKFPcacfcgrIMxGKYLC5K601zv/tIYvM0yHJJS1JaV6gCUgHb8XzVM8DRC?=
 =?us-ascii?Q?Jm5HcYFI7ELdeG2f3NMTgUmM4gkkZ5R1ZACM8v8un0Kx5F4bUgXPCyRaC8lP?=
 =?us-ascii?Q?LNRhbam//GJjSqRIF8VGZjV4dQX9HEYAv65wTFk4pkTtTA4NEU3p2qfHtxQT?=
 =?us-ascii?Q?ku1uuH1oFC6gCdq8VLlYQOsBgk1lVO1hDfM2WBHkshpIglu1SQwul5HVJ4rA?=
 =?us-ascii?Q?Txk0tXRV1nyUkomZE4Y7FV+riUPjy4cewVQjbXGErRBp6L5sLb5TKCNMNgNg?=
 =?us-ascii?Q?ecDbXpKNESNhxebysPa6/x2ywdHuOx4u9+Wg0rxBt1ZKiZi+HD7RfMxasvyB?=
 =?us-ascii?Q?QUosaEvPpXfz+j2sFi6tIoRLyePQbKfXtVztj/aZraefXicv75yMQczMX5oC?=
 =?us-ascii?Q?lflh9YQnP0bZDTxQT2I3cNPrsFNQLcxCfqR3TKXdRZ6gkJ89NPAa0M+Dgi9C?=
 =?us-ascii?Q?xXanOP69j1/PPr+YqzyguKZA7ZIIA700+4YTcrrMM55N/ryw4HO5SVn8KwX6?=
 =?us-ascii?Q?xD2SNczGYfMngGQYOukSPsAaajgroQvk3lwOiCNszSVzwURL7kxixMoft1N6?=
 =?us-ascii?Q?gLNA57HG00JWOrCmNV7HXWnW7xyfEXHQwze9ZvfRvhjlzf+Di3zLtXsuTRfb?=
 =?us-ascii?Q?aU3aAcjlEo2uIk35FIUOVi8gPhLGbcXxlrjcHerGXrlHe/FApUHzjaa7pTSR?=
 =?us-ascii?Q?hmpr7Dka5gVXb1EFnbcUcX8z4ykeBUoi0YLb6JlXv8sqTcd5NhpKcIk247P6?=
 =?us-ascii?Q?TxYfJlHOEshyTjCnmwg7S9O9yfS+tzLP2S2y6ySpfJoRr7HOkseUmpV87rAn?=
 =?us-ascii?Q?D6tSJjDlnHcV/7iAtF5cjTOEXGHg7HriQqrwyGtdAyPfcwSs4FWZEBrOZeOx?=
 =?us-ascii?Q?2pFUubrcJv5CVyOmBqrYiwASVUJXOFJezJ40hiH7J0W4naR7aLYZ1X3sNTbd?=
 =?us-ascii?Q?YPuPtutXbJw3I5OVRIZq7wPg/3zRH4HCILq2GOmb8AJOlWrxRzh0XoSssyfB?=
 =?us-ascii?Q?j5bjrJaCWv/aqTxUJNHwpHphIJ+vRv0+3rOT4vKcd1K+NypXQKbkypd4gX5q?=
 =?us-ascii?Q?y8yvgsj1VHYZW387OrHNZUGvXjDOHHw5HkJPBhkquzajZh8LZ0/I3niXs1P6?=
 =?us-ascii?Q?rPfAj/CZby86LqAEqtCKh8qBYkjUn6L2KSwR/mQg8ONm4alNJqRPcKErC2KW?=
 =?us-ascii?Q?whOKWnbay1RLcMeOLXgcBfLDNNg+uau8/g51RlgT65WZMcSV3DKE6kJZJTff?=
 =?us-ascii?Q?pXbZf4EVVidgjWJZ1RUMI1iDdYCyHrQ4TWufZKb8zXAShtrFlhuEKRwzKTtI?=
 =?us-ascii?Q?lUV9LFs6H6LNl8+KBv0E+h3+YI7TdlRaZQ+UoFlN8Pre4FlTr5RI7s919CpW?=
 =?us-ascii?Q?YER5MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G68mROuPH1NFpOTHeWgKNfht+efn+zGEy7M/dgsY/94ljdyG72HHADC+Wx2J5z/YKDRI47RJufopqTVVuqDR/Fp1SfpA22leswfrOVjHfcP18cVULLiwcuIHfGQzCI181luxg8navA8vof+HmrVSeQs+cfPBiSEG41Yl1iJgAooX3f+agqKDurNXE970pzuBLuS19v4spdqvwBfuW42T2u3ayY/CZP61LA4p2ba6DapnEoljjqP21HSu6vsEZAF6RPrrGcUt/KHIQUaN/h3ZCtzw4dKedtfj2IJV88CluJXG4dIz6zl4FG3dFglDbTfMl/ljEM9rTbCqcqyOJG5VSlZvTVvIYuoSaae+RW2zMnrfXiEZBtAtsjrZpE8oyxG68o8dDk2o+A0NwBmG6UV4dYNA+yXxECGyTGShObQhqLLI+bM1C4q4cpccq/3hXvFXbX2NkbBIr+iab8cdLFqSokGNeoISaPSk/j6r/pvBtgGWWcXVeeaAaiIBoSW52cgxSs+fsUx9H5cAXaH3n2l0alkl6szwdxElbomIFQJv018Siqjx+dtGGwte5UXt0NSJv9jAl/BXifG14l4+4c35hmdgqWFhBtq3DPp1xwbDIJQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e62c707-af3d-474d-4779-08dce309730c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:30.5627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbBCBi2GAApvtrg1whLCKmlHTYFJEdGfGMAUB7+7DN2KbB9ZSbC6yihCe0ce/kkozUv3XBsb296qx6zYy2pZkX0w8enJdJ6uQ5F0WYZZYeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: TICPqz68NwuSo1lZyMcBkCPIhtiHsEXr
X-Proofpoint-ORIG-GUID: TICPqz68NwuSo1lZyMcBkCPIhtiHsEXr

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a009397eb5ae178670cbd7101e9635cf6412b35 upstream.

[backport: resolve conflicts due to new xattr walk helper]

In my haste to fix what I thought was a performance problem in the attr
scrub code, I neglected to notice that the xfs_attr_get_ilocked also had
the effect of checking that attributes can actually be looked up through
the attr dabtree.  Fix this.

Fixes: 44af6c7e59b12 ("xfs: don't load local xattr values during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/attr.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 7cb0af5e34b1..147babe738d2 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -199,14 +199,6 @@ xchk_xattr_listent(
 		goto fail_xref;
 	}
 
-	/*
-	 * Local xattr values are stored in the attr leaf block, so we don't
-	 * need to retrieve the value from a remote block to detect corruption
-	 * problems.
-	 */
-	if (flags & XFS_ATTR_LOCAL)
-		goto fail_xref;
-
 	/*
 	 * Try to allocate enough memory to extrat the attr value.  If that
 	 * doesn't work, we overload the seen_enough variable to convey
@@ -222,6 +214,11 @@ xchk_xattr_listent(
 
 	args.value = ab->value;
 
+	/*
+	 * Get the attr value to ensure that lookup can find this attribute
+	 * through the dabtree indexing and that remote value retrieval also
+	 * works correctly.
+	 */
 	error = xfs_attr_get_ilocked(&args);
 	/* ENODATA means the hash lookup failed and the attr is bad */
 	if (error == -ENODATA)
-- 
2.39.3

