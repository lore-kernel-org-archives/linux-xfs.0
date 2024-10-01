Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90717191F81
	for <linux-xfs@vger.kernel.org>; Tue,  1 Oct 2024 18:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727807337; cv=fail; b=UEpXR1pXvSqNFX0dUbjVbUEdzuO4s8xCm0ucF7cXYiM2qHFtCeTYvBLqXq1eZna5jjlCF9yrOn1pKXv0Aa+Xk4ZUTyiUwbC3UlaZTJR4nn2XZZakZSYTUgKSlqy0knTuRSs4LYthZBLt1GyrihUyjGTpCjoYcfyBgvwpj5MqshI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727807337; c=relaxed/simple;
	bh=+EuVvDqraPzzOkGaNPEcN6gyKBoWHJkD8RE5bYVoMdw=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=bk4EWFqo+o6Lp/K5545hqq1uPm+A6mqQk2aWB58ekh64Y9dcF0yC1112lioJzd+jJUDNeONmIBh7owAsrCy+U/XNfgdVPgrexM2kQPUZr4l3vtFbk9pgg2emvCA+Etr8Vxx9GeC44GvXjHhUm5vfsLZHOP3b/+xI6FdsN7T5spY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GUwNh5fR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KkhNiaah; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GUwNh5fR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KkhNiaah"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 491HMZcf017541
	for <linux-xfs@vger.kernel.org>; Tue, 1 Oct 2024 18:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=npDFlY5rKeuvTK
	L0l5MLvSbVZCpWl5H2NSGp43ZkDkQ=; b=GUwNh5fRuMD9AYK7W5UhcJxc9ONRpb
	l3CYzVZwlKW0rhMGNelLkQ5nLKv+RCSnbYcVok2XdaOtOswnuWdEgol+K4EU6ak6
	5G0K4skE1PRBdJ2hGDjVSg+K15GepzzUtQ/Rr6cjPDkLEs7fOIx9X5ULibJwFnLR
	MsdjBQWvmyaPxcFB/l7S1bvpaRTl9UuPAOQ4Qrv1zea8ZIiE9OCrFejyzVF9naT2
	n8yA0lCl6gOFI29OIMHKBER4pGGwAKpNXdS3D3FngyDhcrXqI2L9bzdf5iI9uiSu
	mvRZhnccFeUUPV5ZE1XklhZPp/W77Qnrztd5CjMp7qumZgiTOM5aqePw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8qb71ww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 01 Oct 2024 18:28:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 491H8YQb026273
	for <linux-xfs@vger.kernel.org>; Tue, 1 Oct 2024 18:28:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x887yb3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 01 Oct 2024 18:28:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XHlsKacxxegDYgV/W44TldxCu8QZqxgmRw2vLdVI2JtXS6tr0N3HNjxq6Aibv7nYH/x67lJEZPjTnR9cQ4O+RbJqH3sYRlMAREv8BRA07lHjSyDtaW4oOtgS8Zv4fYZ56/pC1zlyxjWN6C9jGGXdVdvI2gxtRkadxuXyGiToV+df6CdCZ7ZCmGBk0dDI6Y/yz8mxyK/eVF7HLNPwnik1V/Jxn8XGx6IgE/fO48LRIs5ajTzbHdP97w2q7bhZLhAKKuub3O6+9987twRqOKnaWfXKfKFCGSiD3mzaGJCJ0TUGZ2o60KctbxJG5LTAmPhMzzXyNP4by7NUq8ArFkE/NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npDFlY5rKeuvTKL0l5MLvSbVZCpWl5H2NSGp43ZkDkQ=;
 b=hFA7LoK+fjA1JWpzUlTvNHgW0VBgtSq4Spn7GVUfZXhrUozHYpfQtkMixPc4DmmL0BQx1Mw4A+BFpaFXNEDNAGBaIpeu0sVcn7yFTNML+a13TThWiHp3Xoae56XXIEjUfQwavPuKATRpfPHYachx4EkkQw4R1N56EE3mHYDHCE0JnrKcqvy6j7tXnVQu4agPSqDtSGBfvtn4p0EXZA5F+mrJnbpuVYZ5K35KHHphrFAgbJQXLt0Fdoq2fAYSPggu/Ae6AH379yEQ1V867M7zVd2Qzwx5lDV/6tWhsRQZpuICCwTJZ5cOSbm/7qhJphgTD9bjAwXZsECa/mL11Jwyjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npDFlY5rKeuvTKL0l5MLvSbVZCpWl5H2NSGp43ZkDkQ=;
 b=KkhNiaahz+hleClfZ8VBjtGBbeeepeJwWinkPDjECdpKZMxR6a/9JmBrlQFk32o+cK+VcUts5P4a5BP1aLfQnd5A6ok1BwbiqU3GlqyON6iIKajGf+1GAeUIOT8m+hAw3LchlHgEckweQziUclYjXSJFuabhmyWkzsZ9DDAQuD4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by LV3PR10MB7772.namprd10.prod.outlook.com (2603:10b6:408:1b4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Tue, 1 Oct
 2024 18:28:51 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Tue, 1 Oct 2024
 18:28:51 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v1] xfs_io: add RWF_ATOMIC support to pwrite
Date: Tue,  1 Oct 2024 11:28:49 -0700
Message-Id: <20241001182849.7272-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::24) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|LV3PR10MB7772:EE_
X-MS-Office365-Filtering-Correlation-Id: 62edd1e6-0d1b-46d5-b0bf-08dce246e5c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bIIIGk1CDv7DDDwDDo8FnTH1Nhb9cpvGHc4anRNXi5nPq7xZbjHDKyOvjiJP?=
 =?us-ascii?Q?UVmaws2Vz11g6lTCerHp6mpJ0KCXYyCVwzznoo+9X3J3CSJyhyK5wAdyPUOX?=
 =?us-ascii?Q?1FUMH9Mkpghekml0qoFDi7Pl0CFN92LaWZvpzxtcePeD0640kaf0rrWQ2dci?=
 =?us-ascii?Q?LnKjnHBSoo58yIxMxwrgK2oC43Jqs5fX7lwwLAzW6x2/xc2USBEN2tlqViF1?=
 =?us-ascii?Q?+1UVqY0uDJqfxKAuaKse50eQ9zCVd16scWS6j4JExBdtupLtTyaB/Q6bg0bz?=
 =?us-ascii?Q?SNIn2eRgV9Zhk7K7w+sUScpXhYbtkudEAQcYgznFMDWSD/wk/7QV1HbesRxA?=
 =?us-ascii?Q?kBTIVsJxLIp6ws6ol9IrZpzcixkCT2YJh65s0ow26IbXNYKSxYKZDi1Fwcpi?=
 =?us-ascii?Q?GXkCvV/BQgcONgUsCSPjE3Ht9Lzs6rDyrEON7V/oB1hUAgHdFXkjl7JMvUxu?=
 =?us-ascii?Q?EiK8aiGA333kWL6kXjHFXLHsNV6SGXzJLnC0+MD/Xg5dP3EjtTaZF+gbuD6q?=
 =?us-ascii?Q?hXlX8RPD8KUlqQZaaCfMx8TovdAWSzDXpGt0EcSeak1dlTZVP7XKj1hiV4Jg?=
 =?us-ascii?Q?SR4YQDPaUyMR7r8bKh1bj9C3xkz24Ze+B8qSvutQDh356rrxf60eTdOJ6hIN?=
 =?us-ascii?Q?2sqr3Jnxf8UtRX4h/jzayLpwYe5JQsJqa8Vqfe+wC/63Cg1rU1Vc8adZMRGW?=
 =?us-ascii?Q?CSt6BedXuZu7dRHs65Wcu1bbfToBRKiSl0VTAaDGuFcP2Y3l45cPrYPtJC8d?=
 =?us-ascii?Q?Ark+ozv6vp+v2CAYWa1gmRJ5ALPkQlxXhcgKL/XVGHgv0fuv6CcFEIg3j4Hi?=
 =?us-ascii?Q?3oQch2OcogzTZn1v6NKsssGa+bD9+6f0xa9rMdHJsZKEyiqrxFldz3TioM+r?=
 =?us-ascii?Q?63XlcTp8T3+dYLYmmqaCYbtJRKI0jDXEP3hW9TTXWzsRFI8+6SuXacFYmQcq?=
 =?us-ascii?Q?2R45OJnfYPqWugSXlriH+iM4a5tlyZ1vhUNRMJ0qGbZc6hvq79lvCkIYSc1L?=
 =?us-ascii?Q?CKIN0LZn2Ie+aJAdVOhl/0AUHyOfSg2RLjI6bdWbyV9GHrs14zxWw17OdA9c?=
 =?us-ascii?Q?J4s/BDYrT7srAJkWVrk3vjg1mCevcOHm3xymY9d3VBLM6GADWjUBc3pK4ITJ?=
 =?us-ascii?Q?BNiIzhn4rZMIGnML6YM9v9MfKcqz8EH0ekUlq+uXIuo+DXq8y5TOavSHf92y?=
 =?us-ascii?Q?4TXK/wYUcOrAowlX8t4dwyLajTG6tNlbvjVMdUIluGWqNs0l+pSeNBH3Epaw?=
 =?us-ascii?Q?RIy1OMclk3C/cjB6Xi1CCMgChiNMl5hzrcCRP5pyZX+hDpSL3pw6teRdtHGT?=
 =?us-ascii?Q?qLhUSf5brjEwd0Yd3b4eMd3q9s+OI1xCEqBCp77X669yxg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F97UrYXFCHww8vTWwtY9RzmIObasm29VWR20PQd+JAZzZtYCP0B+gxL1OO/1?=
 =?us-ascii?Q?IybfXIqEcl87Nk256kk326K8rrbnewKqScQB4z+5SGHkfbe8/hGv8sBAaXyi?=
 =?us-ascii?Q?LPGYuWzi5HtEcJBX3Y4jZ5yShU6o/hlnm8B92M44FmPFFEscbHXWa5iYp+iG?=
 =?us-ascii?Q?CpcK3C70KeMV2N8oXX49Fmp7mIZj82R/BTodLbxcMTFxo691sGxGBNaZBgdO?=
 =?us-ascii?Q?aWF+/G1NqyYifhqiKKGmh7+DvInkN26WDY7QCHF3pAgXq4J4vVkyN3Y/Q0a3?=
 =?us-ascii?Q?fpYn0LOFvv2Tqd/jnK50ZaFrH8yNlN2AnfkyqABv6d9IZ+ZARq3lMevZc5Kn?=
 =?us-ascii?Q?chve1DQ+hhi2Zt7NVZx0EhncX8crQRV/r/2OzF7qJ/XZcR2wB9frVmhHHlOq?=
 =?us-ascii?Q?jQnIrBHlj+tgcc7VtHfxO5QX8LXbtH/u3tdEeoMvdfhqk49CzLa9Yr6pgrd1?=
 =?us-ascii?Q?1ph/ourlFJTCdgGhaSreWJuAzm1e8N2cdWDDABylAxngRp8bJYHamCWDE6Yk?=
 =?us-ascii?Q?SQtJX7CsUX/kwOSQ14XlxqYjDoJvPrI3GiR1w2dawfigrxzFhrtEhRdOxUD7?=
 =?us-ascii?Q?a/b8RoKoIRTOWpR9M/gXk9kg3d6o4/H5ueG+bj/4z4kXIJFbAvh0Y4mvQGk0?=
 =?us-ascii?Q?Gp4kp4mSgTmPytRqmky8LQ5nNaWZnXbHxTkfNMarog9II9OMuqctFQmVyVik?=
 =?us-ascii?Q?rmwd38ITPNShOdKguaEa69FH2DYr+3297lxqUERw/DHlo+UqiazeQEeesehx?=
 =?us-ascii?Q?O17D06x/qJif+X5wcqv04PzWzPiU5zuc4G7GoaESrHPUfxN1ee4AxaK/FRTW?=
 =?us-ascii?Q?m4Tih/YpfBllEHT8aHvfyqsHTK93w8oOHQUZLUJ1bxw5FESgwLG7EAvcstYc?=
 =?us-ascii?Q?GbRyl+mML1lKTDoY4SUcjIE8agVuc7RiOcVH+zG/wrZNCBWw2auugLB1KfvR?=
 =?us-ascii?Q?xoDxvKHMKtFP3qGlQ7J7bCjwGq52glF0w++C98xoSR805OFxBd7+8XXtPezj?=
 =?us-ascii?Q?OnrzvRR91ZpmPNvecolyoFHF+UMek0tnYn9zz14Jdwbax7KEKOUHZX0CYwEn?=
 =?us-ascii?Q?oorW5lZuYa++LqYlBK09HNzNhpKcihDXSKlD03jnlxMVY1LSBQkJtj9Tcc2b?=
 =?us-ascii?Q?EIkBan06fW7Uv3HfObPj3PaLkIh16ZP+HmHjrLqQmYhaTBGkq+/EB+QzFq0u?=
 =?us-ascii?Q?7ODN6SWLYzCGUn8DPB2XuPtjGbYE/dSqEfxp5N3F0FJ3flHCDdfTp/se1feK?=
 =?us-ascii?Q?Kj/wp4cKnOSa+w+zPcgA2aFZbg7vMlBYRAOcoarQoSwH8MqTbFkZzW0Ok2ud?=
 =?us-ascii?Q?F9TQXcVpxD/c8bMrEA9XMGRpQWTPrQQH9+HvmTgPuzmLwHD4G3WrIksjAUt5?=
 =?us-ascii?Q?cBjquFlhLhntgzyykh5YixRA1iUh/ekzUgAvyahxae4YL5jnnxceStl9TITt?=
 =?us-ascii?Q?4klqZNJ8Cm/j4g9MrfUh10F95RFk3eu33NDTtAAoEFygSupZrRrkco2+o1X9?=
 =?us-ascii?Q?r9/r06jyenl913HfWvlNoW0e3x6Ucn8wL5Q5joWkFwdOUgqdVeDvvQqYG6Ay?=
 =?us-ascii?Q?yZz2vJ1yJ1pqnPPw/BXYEZAgWQTmnnHVsqyo35mrYsE/o5PB5mjjoR4afzmN?=
 =?us-ascii?Q?okHxc7E1dt6oiFIeXkH2TqZ/hc7c++kBeG+kJwbOSMiBto6TMwA5Blgdj9QU?=
 =?us-ascii?Q?8U3LLA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tr0C7eeokDEAbHQCFQaW+810pRxoeFmMA0pyv3V/FV7MFm1YNyQS1BymonzUE1VxO5nUS+lFad7HI5x158/jRBL57dTyfDU/21P9jysVwyhAZ8EVFgVmpRqPmA2cqMPSsoljXw7QNH2jQNAAwqmEbpo5QAkI8t/YL1/8LSP1ncPXrIV1hpCocZanmEhJGV19VA3avX/DnblFuTpoK4uonRqHuc5PFS7K9Gqpcm5bx9Pgrcxh+Gw/VplocqBfJrLiW40Ta9uLZ3b0EN7fiezFykU0inCbIIsnKNeBVw8X+CYQpK7gnD2TEFAHCiDwUGAUwFCY2G0Da8BijEsRIbFlNMKUju7lWoSfrRb3psh6xAJ0tDEVJEAtjKSzw9GIUvmm6it9eua1eCzbby1DMJyAI5FI+NJ2G3R5YYx46ZrY2+bB95+Qzh5zYab0qfDB+9cwQyQwUgmu3nxCN/TNNumMLZ0s4OZGfUtnxtIl4piKLetFrUTxYY4zWdKVqLCwIeyORj76GuZsLLQSfBwrj0vM2+jSup3b9kAAEPlUQ+v4GZCa5B6+DTiTB5QbmLBeXRW2amct4k+vO2BSEtDHAQ48pahPReOiEGvl+4LQKRQ5q8g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62edd1e6-0d1b-46d5-b0bf-08dce246e5c7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 18:28:51.1341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YECiLUAIcyGCjsU/CSPSlHIhsv/WX3rETTvW/8aWZSpz8HVrl5LGCrEle2pPNfdcSx3dV6xiMAXA+8Fqs+ZZwvQJ/ULJOSvecrxO7V9cKyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7772
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-01_14,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410010120
X-Proofpoint-GUID: 8O3kvOLqSiOvvSA7ltXLDIOFkUOQg4Aa
X-Proofpoint-ORIG-GUID: 8O3kvOLqSiOvvSA7ltXLDIOFkUOQg4Aa

Enable testing write behavior with the per-io RWF_ATOMIC flag.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 include/linux.h   | 5 +++++
 io/pwrite.c       | 8 ++++++--
 man/man8/xfs_io.8 | 8 +++++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index a13072d2..e9eb7bfb 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -231,6 +231,11 @@ struct fsxattr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
+/* Atomic Write */
+#ifndef RWF_ATOMIC
+#define RWF_ATOMIC	((__kernel_rwf_t)0x00000040)
+#endif
+
 /*
  * Reminder: anything added to this file will be compiled into downstream
  * userspace projects!
diff --git a/io/pwrite.c b/io/pwrite.c
index a88cecc7..fab59be4 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -44,6 +44,7 @@ pwrite_help(void)
 #ifdef HAVE_PWRITEV2
 " -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
 " -D   -- Perform the pwritev2() with RWF_DSYNC\n"
+" -A   -- Perform the pwritev2() with RWF_ATOMIC\n"
 #endif
 "\n"));
 }
@@ -284,7 +285,7 @@ pwrite_f(
 	init_cvtnum(&fsblocksize, &fssectsize);
 	bsize = fsblocksize;
 
-	while ((c = getopt(argc, argv, "b:BCdDf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
+	while ((c = getopt(argc, argv, "Ab:BCdDf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
 		switch (c) {
 		case 'b':
 			tmp = cvtnum(fsblocksize, fssectsize, optarg);
@@ -324,6 +325,9 @@ pwrite_f(
 		case 'D':
 			pwritev2_flags |= RWF_DSYNC;
 			break;
+		case 'A':
+			pwritev2_flags |= RWF_ATOMIC;
+			break;
 #endif
 		case 's':
 			skip = cvtnum(fsblocksize, fssectsize, optarg);
@@ -476,7 +480,7 @@ pwrite_init(void)
 	pwrite_cmd.argmax = -1;
 	pwrite_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	pwrite_cmd.args =
-_("[-i infile [-qdDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
+_("[-i infile [-qAdDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
 	pwrite_cmd.oneline =
 		_("writes a number of bytes at a specified offset");
 	pwrite_cmd.help = pwrite_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 303c6447..1e790139 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -244,7 +244,7 @@ See the
 .B pread
 command.
 .TP
-.BI "pwrite [ \-i " file " ] [ \-qdDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
+.BI "pwrite [ \-i " file " ] [ \-qAdDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
 Writes a range of bytes in a specified blocksize from the given
 .IR offset .
 The bytes written can be either a set pattern or read in from another
@@ -281,6 +281,12 @@ Perform the
 call with
 .IR RWF_DSYNC .
 .TP
+.B \-A
+Perform the
+.BR pwritev2 (2)
+call with
+.IR RWF_ATOMIC .
+.TP
 .B \-O
 perform pwrite once and return the (maybe partial) bytes written.
 .TP
-- 
2.34.1

