Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7931DE2B5
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745863906; cv=fail; b=ORkL9Iz0C3jo2yEkJEFttKjKLM9YpN6AfrWKKCdkXnPTs4aDp51AHtngwBCudN0Xf/Z+Uev/PgSeMYFQJmBD2ui+d2JkVmLus4mpIgBgCClsf5uYxnRdkx5qqUEkJnWivxV+7z8QLedks59vSLvaLV/542ggozJ4IST1OPfmuqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745863906; c=relaxed/simple;
	bh=+8aHxU54HcQYWqanWrI5KE7kbPOsNpUe8FsTbpcDYKw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=NWW5kXXXv4LmdiIbQCYfq5LU0Xs+ZNG++Agnn+Ox+gloBolEY3lrJJxCTZvueKCmxO9jOHy0t2vetNARX8iEN6jc+e+bm7lsQF4J9Rd54ne+WREBI40aTwODbK6+e73m1v2M178x5eADyHmAIE3Vtu2vkIvc6/vn5Qq1s07X7dU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jEdz5ST2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HjgDat8s; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jEdz5ST2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HjgDat8s"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53SI6sgF031552
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 18:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=H3FA4r4psG5w4/vT
	g1tmEFSLXypNVFKiYG5N9FYIajs=; b=jEdz5ST2HO609mZANTjPRM2MVIlZBE/V
	YGp9BULTY9jkOlS4ASzeoAUkW3y/9oaYjBSdehzQ3+STqodFeayMyzTaE+H0ARPZ
	bYJfv7D2nhnLD3yeM+0Z0iRMTF+9NTBgiLfCfKM5HS5imlRbLvpTyPe0ZOeMWCd3
	UPooiNa2ZL41/6BXnTvDyoAcjcuMt3BzsOyQ7gBExDPx0UwAZUgvTS5LpYDmx92U
	R43UZM9/O1nliP9vfCqONd27oZUQGHIplGsyTKOpKMfFJ9vWImq1PTY2xIO7Wq/k
	lrXFubKtL+2jY1Jo6epBfC4/jLaAbyqf+523wJZXiDwKUDlgQ33xEQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46aentr0em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 18:11:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53SGqGqE033453
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 18:11:41 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012011.outbound.protection.outlook.com [40.93.14.11])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nx8sq4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 18:11:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7gnVGVD985vdRlqnhn1jr0VhyehA70NPjGaxBEjpLsPpW5gZvwHTbjlF3rCYActYtSdtWfBXpc4GKthZL2gmVNBdq01CsfuCZ4fWZb5Ev+m+CCVXtvbOjxh0rq4EVwok/j+216vshC+FWditOWjzWF1VspZ/vs/nWbtTX4c7f3gEEo2m3eKUFgfN28AL0eeCRwNnr8o4tVFXhMxF616OGY3Q6gW0gX92ThIShqyG4XBinNgcQWla8Gg2IBINaWQ3BBfPRJ68Xk2cJq9DojSbCXSCfLKVmPnjlTTT34GLGqg92a64z7/sAlgfhuPIM5Zg8Qn2YNZztF1JcUzESxzsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3FA4r4psG5w4/vTg1tmEFSLXypNVFKiYG5N9FYIajs=;
 b=T3YxfU6AOza4abfSVDUgEb0YhwXAGnaeeSAOBnjxobykfKL/9mzS5Pz2y8wZ8hqVpF6K9wdUnwls8D8k2nR4uwN5xt4PhIKCsPk7NG61eISPX5v88WcFVc6OrTOcjMaQ8aMC1EjZSP4CNZEL5N/G7H93KmUdpLKb2D0AgP425bNaJ4nff9nmjbBz7rszRV/5Cx/ageC+pwQttCqWgnCFCuyB2kAMSDO7DvERh05VoHxPA1KKIAmAwf4Y81DC3nDyHm3roE8eiPeYfVyw/gMUUg1K4BJXHclVaBolu79n7kUyq/dzGdXSqYPhElZiD8U9IyGEwNlDSob5Hv6ndZ+r6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3FA4r4psG5w4/vTg1tmEFSLXypNVFKiYG5N9FYIajs=;
 b=HjgDat8sLShSoCQS+pg5lLwENVKoUWUc5EyNFjmoTZxfPefwe/EaXsCJ8b7wpXigk3SyuH/kcU6Y186E+48hAUajpfhhn5EKQDsRyq6g72Vj5Z/BrgCq1/HIeXg3NqebZ2bYhUNbAURoKbxa+89Mzn9KbWhH3Xkb7Z3ifSbEUfw=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by DS7PR10MB7178.namprd10.prod.outlook.com (2603:10b6:8:e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.29; Mon, 28 Apr
 2025 18:11:38 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.8632.030; Mon, 28 Apr 2025
 18:11:38 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH] xfs: export buffer cache usage via stats
Date: Mon, 28 Apr 2025 11:11:35 -0700
Message-Id: <20250428181135.33317-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:208:160::34) To PH0PR10MB5795.namprd10.prod.outlook.com
 (2603:10b6:510:ff::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5795:EE_|DS7PR10MB7178:EE_
X-MS-Office365-Filtering-Correlation-Id: 341853c9-75fe-4069-08ea-08dd86801e86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BwWjocxEbEwN1cens2TeySaTgQdoL7E2OGKybgENIx74Z8du4I62vqiv0n7A?=
 =?us-ascii?Q?k64twjNYgkPMs5ADu6aGTlZ+boNhulN9PtuSWZNbt+bliIRPdyel8jOdizCN?=
 =?us-ascii?Q?ptaTdJW1W6XiiajsNdHTflRuYNk56fRkwrMTT99FKP1Gh36uvalJNljc2Lki?=
 =?us-ascii?Q?qgbldUGu7K+vyhY558vKLrmhUk3iiUs/6mg3iUYNfbcngBuiQMbNmZhTkbap?=
 =?us-ascii?Q?mpfxK567v98c6AFjgOs5nZMPWFRMJ+dHEsZAVK8foqzM7V0aV7RtSmyKcziW?=
 =?us-ascii?Q?sKtKt4HD4SsJo1Odwlhhn9o5WRo1uv7gyvQEN8tTe3SQPZWre3I0eoupGeXR?=
 =?us-ascii?Q?uOMOm/ZcROZ7Lv+zJEcW9q1zGfidYThReAh3POK/73WpRRIG34DvOMu18FXf?=
 =?us-ascii?Q?NHNzoBITKZt4x5fwuBJ7HVBXxIh7EqQvWuzSvUAfWj5rQn8IT4qf6AWtKZjP?=
 =?us-ascii?Q?ut6igQ0s8HCxzs6XPDsaf58lIc8yT9IDFC57RuZagejKk6DseoojrYeaZcEM?=
 =?us-ascii?Q?6L5Jr3iFdSmCpbRzEzQAtYCPfF/+32cLUbwizlGftwZDMi4bLNsU4TBozIZX?=
 =?us-ascii?Q?UmG+EqFBzmdiv8GRnBtHkg+4Dj9MveFtp3JoToNpMdI0nJB1U5Ottauozm6b?=
 =?us-ascii?Q?UzqwAnVEWWA3X7LckM3S6MC9x76E29w2mlk+qaC/NhAI8wirrUkEhnxtbpCD?=
 =?us-ascii?Q?g1hNWdb/IEbcSQuqa28GHYU4AWMVFwH0W0lu2DFjSUhpCj3qWgR6eIQmWzSK?=
 =?us-ascii?Q?7tbG//soJYpP2MNRRFes0POe3xhugpXKWsNCK4KNpZZybXSKZDfr3Rbb+8qF?=
 =?us-ascii?Q?2v79oXSKQlmzvdzEDl7oB2+33zpnz90xlKe64LrpWHQUrZRU/UBMyM14tZu+?=
 =?us-ascii?Q?0Au1kEtet2kIb4XzOl0KyEaExkwKv+cLM7wo+6SQVVbKEDZihJvMwWKcIzYh?=
 =?us-ascii?Q?0FE7peLIHKbaVTdjVSZ0x6Bn6wk8giwcJ29j1YYgmk6K0SPAonayelH7kR6Q?=
 =?us-ascii?Q?racq4az3nUXztEwCu1nvm9IynaSPvJ2gytRKCOax1fB4Dq/coS6nhLlztNds?=
 =?us-ascii?Q?RKB+hDSXxuasu6yLu1L6wYEw1E0nQ39s875CKajJwp8aAoFhamKkgHT7O9Zd?=
 =?us-ascii?Q?Z3b+rJoimwHDH68z5f+o6rYQySwQ3m9EQ3ZHPbOFgZH5qhfyHVuFc5kd6HoX?=
 =?us-ascii?Q?UjRL6SGTPuoD5JyXte70miOwKS3xATQPHe248oPCfoMAAWZPq3SM+Av3ZbJX?=
 =?us-ascii?Q?ctn4HH3zwFQ9vXx+pJpLDcn6FAxQqjSGPmYOzXDahawZXvD5Cf9brp/fiujr?=
 =?us-ascii?Q?WIdQ4BLEeNaqy6PWy/BbYjUbgg5AyRSVLKHHIrFbA/WIFkWIj10rS6WfQ43R?=
 =?us-ascii?Q?486H9O9Xu3yPAQ+UkCVlLgLCqkPNJh4zhzfBmI5eQ5UHdwbLJgORLFsd9KC2?=
 =?us-ascii?Q?cBV/2947Fls=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZJOlTWw6IRgsuPvwSKU+ZAJRzitgn06GEu5gYtHKDt2iwWnWAvjwT2AfSsBu?=
 =?us-ascii?Q?egIMeUlzN4wGf0trx9lo4pQ1bxA7m2phsDtG/UFfMfUAtrJNrSlyqOOzLR4t?=
 =?us-ascii?Q?VFPriLGF4oiZBrMrIIi0f7TWLv6yoscTHpsB/Z9slZ0VnBYgemojnSu3yi7+?=
 =?us-ascii?Q?H4mkvseJWANi7T1vMAZHtz/ccWjBxKKdb87loMYdvuXAiIjJpnE3Y/Qcx4eB?=
 =?us-ascii?Q?Ih+ppPb98MuhccT0XjiTazxkR/LPneLd/wcLGLfETGMwyY9MK7lAL8Ix6lN4?=
 =?us-ascii?Q?iAqRAwSXeEQl4JRmVWtwsO8mqNAm/OSvp8J+rzwf+HP/hEqg+nO6V8dKcHk8?=
 =?us-ascii?Q?LhZD3Fe1CJY0G0D0QCn5e3YXfbWqSO+feRKPL+lG0zJkD5g3DANRnRDIbnNH?=
 =?us-ascii?Q?CC+L9gUu/6z9FW0/4pxUtZQ17/Yl0+APZVnJUQofekgvgDlTd57RAc32W9es?=
 =?us-ascii?Q?KAkVj9CUVQpMpVX/zu3EfpxRkCHwZH0MQ73nAh513NGbUaN5byrv+ORiHpUQ?=
 =?us-ascii?Q?QKWMbDwn+RHn60ZXuUhPGEx9iyJ3AFNNX9HPtG5bSvCE42xNmATvCBi0TpVa?=
 =?us-ascii?Q?//m2kP48H17VQNTz+FrOPZQpiOyMU62/EuLpyojk+GKUEfKp6msBb/DaW0kB?=
 =?us-ascii?Q?Utrfbw2al8bEPxc+rdnfQ1ThVtFVSe+7fwGYqXxnkIkz6mRstrZM7ViNC2Kw?=
 =?us-ascii?Q?Mtll/Jca6dzwSJCgYrObY5nlJ5olhl00v589B9n+fdE0nACDf6CXfjlbQcif?=
 =?us-ascii?Q?qyA3YdvoZhvXe5f4pcNciM4ZcBOyuxU3Xj/shGeuB2n+7rptoHlUMdJSZssW?=
 =?us-ascii?Q?8Zb/afeG6GQFqAT/2rgdxA4sinDFAa0I34z56WLeCS1foFxAYVpMO29WcBRm?=
 =?us-ascii?Q?8w3CquoJcw2zQaBUDiQsLnq4GhKLoyhtzTa96obZp57TYGQdx9MUDT5cKoOO?=
 =?us-ascii?Q?WtNLZwK4VJWICzD6j5UKYi4wen7F+Ry54ZjECBG7znaHvyDENZZDNY2Gxv2d?=
 =?us-ascii?Q?OxhDu5DJcoxeFOiJMpDRB5rFm8487Hs5V5diFFZzCVwXChXEE1w4ye4LPvZZ?=
 =?us-ascii?Q?GSThysMajWLJhGuAs9hIHaBn2L0LLja7w5xkhPnjTlqHFS3TXYLbxUOv4jXA?=
 =?us-ascii?Q?KTOZX633Di90jGhArHCeXwzGK0LfjuLEnWY1MpGrlDRgtQQzblmT4EAOH9bi?=
 =?us-ascii?Q?khpQnCCLajbZ8A5pg4Gw8OkQkPNNbJDXmRo7u/sfxnoTYbi7pL/zqysT9cKW?=
 =?us-ascii?Q?URIuDsOlq/2z04YACjzgDeSYmOHmmCVZLReGkpcX4qqlV6NJ+b79rs+k6+dg?=
 =?us-ascii?Q?oFT4m9UDmxF8H2hTVlMLKgu99tAluE6GMnXl3cNG82CdgrWtPGChvReJUG5x?=
 =?us-ascii?Q?PoyYz0/fHsFp9fjI0PXbY3K8TTD0ez+fTWP7/LawYt/zVOlLnEI05QObTDVB?=
 =?us-ascii?Q?OQPCTH9UjkF+VnrlrZ1JNwzf55EUgW9fsneLSeAyFRUPRxbc5tiIn6AZrMdt?=
 =?us-ascii?Q?8E6bPFYrpw7LvCkiiAM9oSzJ3BG6ZocxgCX7r6zfanfsnF93AUXPa0eP7/jg?=
 =?us-ascii?Q?B/NfgyQ7BIF5vqyeCy/7/GNJZDgO2V2vaxYPJPnAShAZA5D5oTAJG6CSprj+?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FfKrZOOeH7pbQG5tEfmrIRVz0ceg3TszlxMbOt1/m8so0g6a+2g9agSvImjkZQaVlnjKZFJS3S7tyf6d2aPpt0MU6RulS4WV/cEzIcbChzmUP+/uPf26PujzPKZ4KMGqW/WripoAlRnVAuStDWDzWQgOkGNfQvvGERfr6pNlZZbzraMNLi76Fdp+jIZgzf/Endkgh/gkRAyQOAZ1aMjCGxt/TpEqljDo1AbXkp3UJ5OZM4Z22blIkxEK5KpCIvuql8mCxcBrhs0r2LON+39/MuVd0yZeUO7eS1eFA9fvshEDXwgK4Yaj3UvpVC3OOnAUXf4P2UvNcMVq7aLKtqSRT4XQRdbbk4sqWwcPOze2lISC3FyQA1suI9E/7dudqkb8nDoRlMS57KTxyKog3RMf6IVTurUh+q6U4EdWWvVEpsHoG+B3s28/LIsZzNjEoFYWjV1rtF206DsrEL7YIH7ii0RakziZUJyPMsVLnJMyKVK0NeqUcm3mKSahHEeF+BTLwkpFDp7kst0JL4R7PsW4eHX4YR/O0FpLY9BGK2+Ztvqwee+TSzPa1QNhdKtfWXtwAEy+pJqjjCa6OtYtedFSXdp0ZaxfSO7CJ/+EgU0kZm4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341853c9-75fe-4069-08ea-08dd86801e86
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 18:11:38.4872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xoFKNtBsPOYCL3VI7adbKwgSNJ1iiSFvQEkiCuz+Q40NrNYlhxHlqjhoFeHC9uqHm78HmbH93tWMi4ZKsxWbpZ3IhRek80BAcSapzx+6bDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-28_07,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504280146
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI4MDE0NiBTYWx0ZWRfX7a1HvCGMPtFS aE4jV3jC3cSd7q/P22y4axKi+MapmFNromvZybSGbIHHCqEXXZSV297+REBB9RU7vWVQrrsleUm Bawn7908+1vl+Sn61P/5cDMkRSLkGmu5e8mCpe2ESjtlwYWaHi4W2mtOnxGW+KY3y9+yFrmrOMW
 +g4WJPyJ6BX0CwI+tNIZt3GM0EJZzZM6raa2MrVMuzsZTyzBLDbXqEGCN1balkG7SHSBR4ltu0U Jutc2ZfkudanLMlDi7cNRb/jKFYAdrT2igkgBRrMVuuaG8dpTDDp6Sqol3acGjelqPojrKchkVf EBLcXwGu6HF9p00P6PcNYFCaH3sSbzT9H0X7g09L64tR9R/KZbaVyE+l4pIjRlLCyT2KEVEzP8s 1wf444Ce
X-Proofpoint-GUID: 2LGVLetGOyGBzMF6QfoDlOLbczZhzAXt
X-Proofpoint-ORIG-GUID: 2LGVLetGOyGBzMF6QfoDlOLbczZhzAXt

This patch introduces new fields to per-mount and global stats,
and export them to user space.

@page_alloc	-- number of pages allocated from buddy to buffer cache
@page_free	-- number of pages freed to buddy from buffer cache
@kbb_alloc	-- number of BBs allocated from kmalloc slab to buffer cache
@kbb_free	-- number of BBs freed to kmalloc slab from buffer cache
@vbb_alloc	-- number of BBs allocated from vmalloc system to buffer cache
@vbb_free	-- number of BBs freed to vmalloc system from buffer cache

By looking at above stats fields, user space can easily know the buffer
cache usage.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_buf.c   | 15 +++++++++++----
 fs/xfs/xfs_stats.c | 16 ++++++++++++++++
 fs/xfs/xfs_stats.h |  8 ++++++++
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1a2b3f06fa71..db3cb94eabee 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -113,12 +113,17 @@ xfs_buf_free(
 	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
 		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
 
-	if (is_vmalloc_addr(bp->b_addr))
+	if (is_vmalloc_addr(bp->b_addr)) {
 		vfree(bp->b_addr);
-	else if (bp->b_flags & _XBF_KMEM)
+		XFS_STATS_ADD(bp->b_mount, xs_buf_vbb_free, bp->b_length);
+	} else if (bp->b_flags & _XBF_KMEM) {
 		kfree(bp->b_addr);
-	else
+		XFS_STATS_ADD(bp->b_mount, xs_buf_kbb_free, bp->b_length);
+	} else {
 		folio_put(virt_to_folio(bp->b_addr));
+		XFS_STATS_ADD(bp->b_mount, xs_buf_page_free,
+			      BBTOB(bp->b_length) >> PAGE_SHIFT);
+	}
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
@@ -147,6 +152,7 @@ xfs_buf_alloc_kmem(
 		return -ENOMEM;
 	}
 	bp->b_flags |= _XBF_KMEM;
+	XFS_STATS_ADD(bp->b_mount, xs_buf_kbb_alloc, bp->b_length);
 	trace_xfs_buf_backing_kmem(bp, _RET_IP_);
 	return 0;
 }
@@ -232,6 +238,7 @@ xfs_buf_alloc_backing_mem(
 	}
 	bp->b_addr = folio_address(folio);
 	trace_xfs_buf_backing_folio(bp, _RET_IP_);
+	XFS_STATS_ADD(bp->b_mount, xs_buf_page_alloc, size >> PAGE_SHIFT);
 	return 0;
 
 fallback:
@@ -244,7 +251,7 @@ xfs_buf_alloc_backing_mem(
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		memalloc_retry_wait(gfp_mask);
 	}
-
+	XFS_STATS_ADD(bp->b_mount, xs_buf_vbb_alloc, bp->b_length);
 	trace_xfs_buf_backing_vmalloc(bp, _RET_IP_);
 	return 0;
 }
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 35c7fb3ba324..a0f6813dc782 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -24,6 +24,12 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	uint64_t	xs_write_bytes = 0;
 	uint64_t	xs_read_bytes = 0;
 	uint64_t	defer_relog = 0;
+	uint64_t	pg_alloc = 0;
+	uint64_t	pg_free = 0;
+	uint64_t	kbb_alloc = 0;
+	uint64_t	kbb_free = 0;
+	uint64_t	vbb_alloc = 0;
+	uint64_t	vbb_free = 0;
 
 	static const struct xstats_entry {
 		char	*desc;
@@ -77,6 +83,12 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
 		defer_relog += per_cpu_ptr(stats, i)->s.defer_relog;
+		pg_alloc += per_cpu_ptr(stats, i)->s.xs_buf_page_alloc;
+		pg_free += per_cpu_ptr(stats, i)->s.xs_buf_page_free;
+		kbb_alloc += per_cpu_ptr(stats, i)->s.xs_buf_kbb_alloc;
+		kbb_free += per_cpu_ptr(stats, i)->s.xs_buf_kbb_free;
+		vbb_alloc += per_cpu_ptr(stats, i)->s.xs_buf_vbb_alloc;
+		vbb_free += per_cpu_ptr(stats, i)->s.xs_buf_vbb_free;
 	}
 
 	len += scnprintf(buf + len, PATH_MAX-len, "xpc %llu %llu %llu\n",
@@ -89,6 +101,10 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 #else
 		0);
 #endif
+	len += scnprintf(buf + len, PATH_MAX-len,
+			 "cache %llu %llu %llu %llu %llu %llu\n",
+			 pg_alloc, pg_free, kbb_alloc, kbb_free,
+			 vbb_alloc, vbb_free);
 
 	return len;
 }
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 15ba1abcf253..5e186880d8d0 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -143,6 +143,14 @@ struct __xfsstats {
 	uint64_t		xs_write_bytes;
 	uint64_t		xs_read_bytes;
 	uint64_t		defer_relog;
+
+	/* number of pages/bbs allocated/freed in buffer cache */
+	uint64_t		xs_buf_page_alloc;
+	uint64_t		xs_buf_page_free;
+	uint64_t		xs_buf_kbb_alloc;
+	uint64_t		xs_buf_kbb_free;
+	uint64_t		xs_buf_vbb_alloc;
+	uint64_t		xs_buf_vbb_free;
 };
 
 #define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
-- 
2.39.5 (Apple Git-154)

