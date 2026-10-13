Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5AE4DDB52;
	Tue, 13 Oct 2026 09:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884454; cv=fail; b=gw4w9uW3RMQj0WKYoUXHOGZ4I30Cf07g5x1lzbgun5Nh23ovvwlI2hoJhfSjV6QJZ+jWtdYO/E0LAdHMVZ9cm+hc1JBXEVi/25dOFSxxIjHA/DXJe6FvAA0/K1a1UT90iDRLtzriuMFy/XuH6fW+8ZY+GeLhDtY/pHb55mztxuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884454; c=relaxed/simple;
	bh=0W/1AyRffqF1mbiq9Om8nOTdMoyQB4FGR2Ljkcmoeng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BFMhMFdufgYuA8yv0R6zZrMx5MVRYXcv7mo/V9HguGPIGulIYxEn7WnsSUJ1XcQ8C2g67+AimPXwpI/Ba30ySt9Pph0n80zBnJFNUHWHkmopIvWNw4SlKJRnN3b0bfMtdgSwqLr2f2Au1hXdvRddEJPNU4UGo0dyNAwBua5ZAjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WKWONuO6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LjLPTVZ+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WKWONuO6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LjLPTVZ+"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BpxD678222;
	Tue, 13 Oct 2026 09:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vKLJeps4qMf2q/pSXjE+5feu7orCUCQOHCCesGf4RTc=; b=
	WKWONuO61IPpafQ6ul3ZE+GkVxsQZODfrdMNEiXAMxa6w3eLlr6jNGtpAAt3tMO3
	qE8Eu9Pdj08e1KJJBaBxvoyON6kSoY2mI4suLvD5TNrk5B7CiwmVo8y/fz4yAB14
	H2XPZpPVtuQcAwhJTBJbhAzUYML0y1vcdRWwRSQr+NYyLj7JiZO51vW1nE+s1mx5
	oQAWT7G7XPGRy6i0n91QAjqfGs+p6YLB0+HxG2MQiZmrQATMdH1cS4cxTeoLH7RV
	QvEi0Bxmqb29QBdZpDA94eu8FupJhAD3jI8bfA9TvCn48744btY5vSpxg5A2mRb8
	lx8vYl9m/4X68pchkzH2MA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dddusd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9ahsu002279;
	Tue, 13 Oct 2026 09:40:47 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010004.outbound.protection.outlook.com [52.101.193.4])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjuveg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NTi/Zw7lP+eRPTkbcydusdAV3nk+4eupd3TiPXlx7Fpvce2hZSwyhy6BXFKyR+T98NqqowI6bsZIysbqZmUkMQq+0nZqqy7ljMr76/Z6AmnCrvX7kgnjbonjBvcFiBANbe2S85XIzfitH90rtO4NShyfTIoDgJZXSxfVeWS4VpUpjJIl1TTfQAr04DSGfG0DWciFO40Zo3a1ugmO/qMOoox2LXOZN4iDsWNwKEM18PERwjITafvrP3muhoX3YjRcmrQPgjvQDBCuD10mChDb3DQ4cbHWvyMs85hBhEMreUtGx1Ld2puOvPE46UVOMEkzBXP+ESGJF184jAmVd/iZ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKLJeps4qMf2q/pSXjE+5feu7orCUCQOHCCesGf4RTc=;
 b=Zm7p5N+UFJrD8IuJ79c6lZ2ypnqhyiyHbZReU/WsQu5dh2m0kcyCDVeSzzpdfVYnHBr79jhpQcQRp140AjtOW1rj+gNKbz/5vigEUWH1t6dvts3DRYNLmhumj7tN52Q2QKW//wG7JGQf+v8se7aCOMclOV1l1W0BKNzv8DFhMnvrymLALOqoNLO7UgK3l1W0dBRlCwDe15jX9LpRgTFD+7BspiuFxKdSftYTNohbHyM8Fer6mvSLMEvirIXpME9Gd2DIRX/pCqWyL2iLofxsUu9zgN32fl4Rz4bdSfALAYnVreLNVdMjLDSnlDX25nxuqYF2BZHpzOV9YI/1IvCeWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKLJeps4qMf2q/pSXjE+5feu7orCUCQOHCCesGf4RTc=;
 b=LjLPTVZ+S4mkvegK+SbADQaMgTeiHbTTP4h1vqyKYPrCzJ9eBeVVSkM3kh66VH+nd95LnMAmLJexNjkmmMEQWJMiXyPHG9+jcolquq3S4Q7AZAQWNc6rXJrND/ec4AOApxvq2rNNeoPX6zRwO7vhn+F/554kl5lo+NMFxURARUg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:40:45 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:45 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 10/19] xfs: aborting inodes on shutdown may need buffer lock
Date: Tue, 13 Oct 2026 15:09:39 +0530
Message-ID: <a647f889e727d10b2a71c3ba89f1ac7d286151bc.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN4P287CA0077.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::13) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c121b4a-55e3-4d9b-c50b-08df290e0e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|5023799004|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	JuamtgmVVnGWMYSFSImnG7lHXBRxDbeLGA0xywfO6LAFVGMY8c6EkskmkVF2QlVDxUnXJ++LLAdyF4OqNG2p5CBoOqKkw1ix2PGkReP/4/cE4SCB+vYBDWLTP9F6ilPBHn5U8ot4vEA46rkrNh5EQDB9SLbdwk6ykSApvr8wRhvq+ZWyK2izXf0jkMhdVdzD0/N2SG9p89QBWJaXl0dxHQKpL/nRymFIgasY4p0GAzErcFN4umIk+qo/1yj8s2YftAKyc2lGrEKvesT2ZpufN/oHLo9cHUjJ8pexJhwR3kjpF855g2oqu4GFEHBg2prjJWUWm9LNykqzIk1um8GuN3OPLqYl+ojulp+GubMWuu7rK+7ZXvNffDFccChzBCrbKwEe8eRvxOlWz4xVjk1bvgIFu00/PI0fIvfUnxjSHzKqgWY5ujs6zz3kjv6mmeD33cJbG1xTgrDR3J/v8vr5fATGdpXgKsqQVWhyMrKwb+JyJmrcVugk32eg6P32jLgfTuL8hnFKvhO/5nZ6na83ecD9paQEyOcMag2EGXLAC0vdtSaq/xkWKeNt3nnMb2MKd7wXpz6gsj+wLEc5ackDwt3M7hVhQ5M5/3kfztfYa0PfVQAaHk1ZH9gfGhYZiK9s1Us7pdPDU010QaFWcbD9/4XNLLytHJYyyts+ng5+USc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(5023799004)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?53/TLOIJNUmTB2ABPAsBoU5mggmDLKnIi2RIAa8Q7Nnu4xV58sAaxpI2kVGq?=
 =?us-ascii?Q?lADxapujkToN83KcuhfBJLDvxJH724+zn3yocz3AayUawWT6DR4CQB1ymtlV?=
 =?us-ascii?Q?/8pDJOqXEejMK90hqymg3hTOnovDybqkgfN/UZrtz7ruMjRUSn0ZGKvn89yc?=
 =?us-ascii?Q?hQgio+b1qstf1+Igwzwl+es5F4JFqC1Zk2stFehIkvuWHUP8o8D74gzpoD6M?=
 =?us-ascii?Q?cTiDkzgDkzsog5mCC9xLV/1O5enXvv/2aw7D2HTUVS5N9LqJZwEFOVsmsEft?=
 =?us-ascii?Q?Z3Q64SgfSg5HoRd0aNrk88AVovXc2XfTofRwgmCJHXc2yee4mh0lVxz7LdCX?=
 =?us-ascii?Q?x/x6xpYbMkab6Llq5wvbQ1sIzfYsMS+JeBuE0j1PjLPFZWs4dFWZuLliqLwv?=
 =?us-ascii?Q?tFc2M6ZYg0S52aRYnA0tv5O5V+JyIYtYn94XdKUmJgQh/oIviFIj3SXQDlYp?=
 =?us-ascii?Q?a6+l6XN+SUQGRA9OwBAbVV20ylQrEi2eZCrf2dyvQld8EMjRHmZnA/CObyzb?=
 =?us-ascii?Q?UVud5ElkfxHBlXMlaxFbKIJ0stOWOuyqM246ZuwV9JmY8am3H6yCrQTVAC7Z?=
 =?us-ascii?Q?6c4BYbKmzefVaKb7/vZDXCfJHpzB2GDMXMKX6fz0tfNwruQIxVsmztHUQSoJ?=
 =?us-ascii?Q?W6zbmi8XWHQEf8FhYpHLUh8ty7WOjEznrceUl2CrDJkjQNSpHgiUsXTmxN9t?=
 =?us-ascii?Q?7IF8uUrwsymPYNfhU3jsRzD6FlltmQO+G8A7SE/ru32FxXUf2jTPAGahnIWT?=
 =?us-ascii?Q?rPxH5nsuv6Dkz8hQyLW5pu6ZO9VJ8zI+flArSii9JuYPzGcqpfpOBmN4yG2c?=
 =?us-ascii?Q?+XjBaWrJJoLPhU/ORRzMkkXnuEjr1IRQ3sd7UJE2lRDYTGqy4LhELxOg00YJ?=
 =?us-ascii?Q?tGfxneDNCnFiVoUEpDH0iQBkurMna7BFZHJv/cTjoldUNEgMYDWSbfzXzLTJ?=
 =?us-ascii?Q?DiHiw1sL1AiQ3RhQOsx4jNk/tzHUVujY5mCqUD8kCSZqyUQLodugpgm9JG0L?=
 =?us-ascii?Q?BeqnZ5G7o+/eNXv1hN4aaOdE+DIxGg8IVDU75lEKZceCgv3vi/VGJ+uTQcBL?=
 =?us-ascii?Q?s+P9aZW+qhNz69zB9Z71F4jG9YE2fYdATpkGwCWatKrCGBo3Q0xOY+oHsnTx?=
 =?us-ascii?Q?kFz9EgWT1RIiXD406EepIUpgIHIGcmuvb8R3fmTCvlVpFhRcGhZ4iqWEwDgv?=
 =?us-ascii?Q?PtemzHtZTcYU4/VgIstqrQ373ICsoBSmna1C3p6Pzl+nZVfJhDeeTwcPP7Oa?=
 =?us-ascii?Q?gudxzg9WT5VVAWKjm/B36f7zcbI2mzE1yMytfCnC4SpqRF4rdnXjaJLJvONO?=
 =?us-ascii?Q?yTKE0smwo9Il2p90djYtP5x6MhC6S6Mlm1zB3X4dZ7lDGfc8WRHzVJKpQOna?=
 =?us-ascii?Q?R0UQrZuw31u1nq8sFq/IYbUQDh+1OLYZm4xNHdajPXiPspMEfMCi2T/2NRO3?=
 =?us-ascii?Q?LU2d/fJyxuJPF9juGD1mYeuX9HAfFvRvgJgwQhuRcTO++iJcIusue9boU9BP?=
 =?us-ascii?Q?x0aUb/mFkdhJ6lPhuEZczwCqQL6WMHT1CgTiZiN4MAZq7MCfrz1gyrx5unK3?=
 =?us-ascii?Q?nDfk+CdkhNnUyXqzz7kJU+CKJeV4hV27FunSGmpwJsTWP3niJvLU2hg260yv?=
 =?us-ascii?Q?H12Dd8xHmWZ/+fgauNwJobPhUCAHp+mdDPnwQD5hraXLiF0tZGxjiIOVr8vB?=
 =?us-ascii?Q?h1H0yth+RiDH9uwlwFp9Shu9Rv4GNSK7zzxjukI7cqQgJlX5LFhqWcq7iEpj?=
 =?us-ascii?Q?Ge1L7PtzA6TSoELaiCIKc6rTyj0cIPQR1r3bPS0xgHRCHfMQi5bpO/lD31bY?=
X-MS-Exchange-AntiSpam-MessageData-1: c+/mYXMHGbNAZXL+ecNXRUNl7mHQuWD0xhM=
X-Exchange-RoutingPolicyChecked:
	eyMmld59GgtkNnMUJWLkk+BbmzeOw2fUr/rOhN/7S0nSJ8TbNdKL3TLNVN6h2DHONoKGTb5D3MLXp9mJ/oS7BJnX2Yvd+13BU01wk5FryYIG/8Gk4BmxIGI34ScTfSRBbqueeIgmO1mcMiFFhdhGeQrXLM/NLTWVmtYu+1o2Od0ATVjwUkHJ8583pwCp+OzO3xSxF3IIkLxsN1RetNnTAhN+2d4304TqFlpc1twfrjr7UBE5EIEvTrxZyZX+obA2RxZoPQNPoLMQxDyOiblqCakJTZKG7z8QgTmWNJksyW/TsjgE1JfFhshu+0HoIFpT5S3kOh929dYpsdCFBO4TvA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2p0TzqOwxN6Umwa6DmKm9gJCpuY/Cf6r5VUNbSkKpQtdFxPEY1jwFDoGcoxuK2TSyYF+TKm1H5ZTQX1Ps+LBxS7SnwauQGKQvWKSANYE8QbiEgGoRxYDMvo+s3cEnf8cJqEQq4xb/FAFEn60RRDhCcthivSrVJB2nxut9yGEw7QGzwuFa+YpVH74AGZFXKhXFfi6n9gsH2tzNmptTGcvIMqOFBxY+WAS/aihbfEcvbG8wmexYrKNdSaZpKnxQo750vezRnXX9XROBab3OU+g4JBElYQ9jSPYpa5EFqpW9NjHxA7OfABv09rewoSogALG/YQr79ZKOcYXXTeYj0Ua3giFsO+XUbfYO1vfQeSR3wd/st5j6HH9kZuVJZcUIKG6+kPZV86ySyuEYU9NXQrYobwhfnxWaBnF61ShboTjt+vnEYab8tWV3pS9f0iPsXiG/YOp3og5nHei1FjPsmSyoaVVyIwfOjhAL0BoF6rj64DIPV5vDMZS8GVRksxtMY+dNwIczpAwsmWdrm236m5rSF+I9T09Oc8txbdNpzA9NiQHzibd0HymkhgQA7ROiuvfaK73ldA2V/qrnMj1cA3pnLuWSZve567CyaYGE0hR7Hs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c121b4a-55e3-4d9b-c50b-08df290e0e40
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:45.6571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMue7G1BBHa8m2kOPuCDwGDzwmG3XpUYdsf6DgnZKBvMo+wZMrA44SScw+65ynVFakg/tPNyTs/J8MwxD+70oU1QKv5vMdhAmYLSNMEoMRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-GUID: uSMt8OjG2xUQGcA_vJ0eRouwD8Q7zi1r
X-Proofpoint-ORIG-GUID: uSMt8OjG2xUQGcA_vJ0eRouwD8Q7zi1r
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX+pocsE9TICvN
 s8TLC9ctCA35a1k6dc0PpiXC0vBcZKJMwvy7px2eiiYaI5ijrjneiZTHhphJKV5WAHF74fnf93F
 HiaQPE3ZmGXyq0Pt41LAlOeYF0LsgwFT1IgH/20jOjqFWIFsWhBY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXyqOzIToWrRWi
 fDR8xdQX5a9eVwPfKcrgftkODLLSGLW9oTVV0k2sT1LgYC2C585AlAO+myWY6A3gz/yRuzipQcM
 TseHTJWQ9tejq6G6b7+JfqLDfI2nwDvG+o6bY4SEllnriuOfWu6K6D7GEcU2qUVW7flG0cAa7Yc
 MZScu9djLfzVx/uwQXoQzivBoC9g+YhQDD5+dscqzEarPhm6ae00z5P4lJTOOWHx+yV1ky2PL1x
 gqIZYHYAB/4Iq768IsZABxXAqqrKRVejbvpY/Qrn6+qmZKXN0RzUP/uyudHMgpXDgrsSfs8Z7GL
 w9oDhPb392Mp3kCKRooY2Gi9b24dgVg8p9jbNHj1vxSXpA3dyxGoP4FncaKcHQejMFTLo5+Wf/r
 CXnY7K0HQnIKCmeitaGz05Q+CQX5UfZCvomoOwW8kUaKQAKZtdDarFWuLIL/D26Lu3MegF1qz7K
 U2ezMlhAlnd3eVE6/hq18xppALyiSVyAaoO2c/v0=
X-Authority-Analysis: v=2.4 cv=J/8/fwnS c=1 sm=1 tr=0 ts=6acdfca0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=45b4cX4q9fnkLCOmiR8A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108

From: Dave Chinner <dchinner@redhat.com>

Most buffer io list operations are run with the bp->b_lock held, but
xfs_iflush_abort() can be called without the buffer lock being held
resulting in inodes being removed from the buffer list while other
list operations are occurring. This causes problems with corrupted
bp->b_io_list inode lists during filesystem shutdown, leading to
traversals that never end, double removals from the AIL, etc.

Fix this by passing the buffer to xfs_iflush_abort() if we have
it locked. If the inode is attached to the buffer, we're going to
have to remove it from the buffer list and we'd have to get the
buffer off the inode log item to do that anyway.

If we don't have a buffer passed in (e.g. from xfs_reclaim_inode())
then we can determine if the inode has a log item and if it is
attached to a buffer before we do anything else. If it does have an
attached buffer, we can lock it safely (because the inode has a
reference to it) and then perform the inode abort.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit d2d7c0473586d2f22e85d615275f34cf19f94447)
Stable-dep-of: 09234a632be4 ("xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c     |   2 +-
 fs/xfs/xfs_inode.c      |   2 +-
 fs/xfs/xfs_inode_item.c | 164 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode_item.h |   1 +
 4 files changed, 137 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e69a08ed7de4..d973eca1a881 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1040,7 +1040,7 @@ xfs_reclaim_inode(
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
-		xfs_iflush_abort(ip);
+		xfs_iflush_shutdown_abort(ip);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 19008838df76..2de204f46216 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3613,7 +3613,7 @@ xfs_iflush_cluster(
 
 	/*
 	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
-	 * can remove itself from the list.
+	 * will remove itself from the list.
 	 */
 	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
 		iip = (struct xfs_inode_log_item *)lip;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 38b59e8070ac..c9ef341d4ee3 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -518,10 +518,17 @@ xfs_inode_item_push(
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
-	ASSERT(iip->ili_item.li_buf);
+	if (!bp || (ip->i_flags & XFS_ISTALE)) {
+		/*
+		 * Inode item/buffer is being being aborted due to cluster
+		 * buffer deletion. Trigger a log force to have that operation
+		 * completed and items removed from the AIL before the next push
+		 * attempt.
+		 */
+		return XFS_ITEM_PINNED;
+	}
 
-	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
-	    (ip->i_flags & XFS_ISTALE))
+	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
 
 	if (xfs_iflags_test(ip, XFS_IFLUSHING))
@@ -801,46 +808,143 @@ xfs_buf_inode_io_fail(
 }
 
 /*
- * This is the inode flushing abort routine.  It is called when
- * the filesystem is shutting down to clean up the inode state.  It is
- * responsible for removing the inode item from the AIL if it has not been
- * re-logged and clearing the inode's flush state.
+ * Clear the inode logging fields so no more flushes are attempted.  If we are
+ * on a buffer list, it is now safe to remove it because the buffer is
+ * guaranteed to be locked. The caller will drop the reference to the buffer
+ * the log item held.
+ */
+static void
+xfs_iflush_abort_clean(
+	struct xfs_inode_log_item *iip)
+{
+	iip->ili_last_fields = 0;
+	iip->ili_fields = 0;
+	iip->ili_fsync_fields = 0;
+	iip->ili_flush_lsn = 0;
+	iip->ili_item.li_buf = NULL;
+	list_del_init(&iip->ili_item.li_bio_list);
+}
+
+/*
+ * Abort flushing the inode from a context holding the cluster buffer locked.
+ *
+ * This is the normal runtime method of aborting writeback of an inode that is
+ * attached to a cluster buffer. It occurs when the inode and the backing
+ * cluster buffer have been freed (i.e. inode is XFS_ISTALE), or when cluster
+ * flushing or buffer IO completion encounters a log shutdown situation.
+ *
+ * If we need to abort inode writeback and we don't already hold the buffer
+ * locked, call xfs_iflush_shutdown_abort() instead as this should only ever be
+ * necessary in a shutdown situation.
  */
 void
 xfs_iflush_abort(
 	struct xfs_inode	*ip)
 {
 	struct xfs_inode_log_item *iip = ip->i_itemp;
-	struct xfs_buf		*bp = NULL;
+	struct xfs_buf		*bp;
 
-	if (iip) {
-		/*
-		 * Clear the failed bit before removing the item from the AIL so
-		 * xfs_trans_ail_delete() doesn't try to clear and release the
-		 * buffer attached to the log item before we are done with it.
-		 */
-		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
-		xfs_trans_ail_delete(&iip->ili_item, 0);
-
-		/*
-		 * Clear the inode logging fields so no more flushes are
-		 * attempted.
-		 */
-		spin_lock(&iip->ili_lock);
-		iip->ili_last_fields = 0;
-		iip->ili_fields = 0;
-		iip->ili_fsync_fields = 0;
-		iip->ili_flush_lsn = 0;
-		bp = iip->ili_item.li_buf;
-		iip->ili_item.li_buf = NULL;
-		list_del_init(&iip->ili_item.li_bio_list);
-		spin_unlock(&iip->ili_lock);
+	if (!iip) {
+		/* clean inode, nothing to do */
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		return;
 	}
+
+	/*
+	 * Remove the inode item from the AIL before we clear its internal
+	 * state. Whilst the inode is in the AIL, it should have a valid buffer
+	 * pointer for push operations to access - it is only safe to remove the
+	 * inode from the buffer once it has been removed from the AIL.
+	 *
+	 * We also clear the failed bit before removing the item from the AIL
+	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
+	 * references the inode item owns and needs to hold until we've fully
+	 * aborted the inode log item and detached it from the buffer.
+	 */
+	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
+	xfs_trans_ail_delete(&iip->ili_item, 0);
+
+	/*
+	 * Grab the inode buffer so can we release the reference the inode log
+	 * item holds on it.
+	 */
+	spin_lock(&iip->ili_lock);
+	bp = iip->ili_item.li_buf;
+	xfs_iflush_abort_clean(iip);
+	spin_unlock(&iip->ili_lock);
+
 	xfs_iflags_clear(ip, XFS_IFLUSHING);
 	if (bp)
 		xfs_buf_rele(bp);
 }
 
+/*
+ * Abort an inode flush in the case of a shutdown filesystem. This can be called
+ * from anywhere with just an inode reference and does not require holding the
+ * inode cluster buffer locked. If the inode is attached to a cluster buffer,
+ * it will grab and lock it safely, then abort the inode flush.
+ */
+void
+xfs_iflush_shutdown_abort(
+	struct xfs_inode	*ip)
+{
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_buf		*bp;
+
+	if (!iip) {
+		/* clean inode, nothing to do */
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		return;
+	}
+
+	spin_lock(&iip->ili_lock);
+	bp = iip->ili_item.li_buf;
+	if (!bp) {
+		spin_unlock(&iip->ili_lock);
+		xfs_iflush_abort(ip);
+		return;
+	}
+
+	/*
+	 * We have to take a reference to the buffer so that it doesn't get
+	 * freed when we drop the ili_lock and then wait to lock the buffer.
+	 * We'll clean up the extra reference after we pick up the ili_lock
+	 * again.
+	 */
+	xfs_buf_hold(bp);
+	spin_unlock(&iip->ili_lock);
+	xfs_buf_lock(bp);
+
+	spin_lock(&iip->ili_lock);
+	if (!iip->ili_item.li_buf) {
+		/*
+		 * Raced with another removal, hold the only reference
+		 * to bp now. Inode should not be in the AIL now, so just clean
+		 * up and return;
+		 */
+		ASSERT(list_empty(&iip->ili_item.li_bio_list));
+		ASSERT(!test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags));
+		xfs_iflush_abort_clean(iip);
+		spin_unlock(&iip->ili_lock);
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		xfs_buf_relse(bp);
+		return;
+	}
+
+	/*
+	 * Got two references to bp. The first will get dropped by
+	 * xfs_iflush_abort() when the item is removed from the buffer list, but
+	 * we can't drop our reference until _abort() returns because we have to
+	 * unlock the buffer as well. Hence we abort and then unlock and release
+	 * our reference to the buffer.
+	 */
+	ASSERT(iip->ili_item.li_buf == bp);
+	spin_unlock(&iip->ili_lock);
+	xfs_iflush_abort(ip);
+	xfs_buf_relse(bp);
+}
+
+
 /*
  * convert an xfs_inode_log_format struct from the old 32 bit version
  * (which can have different field alignments) to the native 64 bit version
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 403b45ab9aa2..9c829cf5c839 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -44,6 +44,7 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
 extern void xfs_iflush_abort(struct xfs_inode *);
+extern void xfs_iflush_shutdown_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
 
-- 
2.53.0

