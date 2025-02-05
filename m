Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A032135A5;
	Wed,  5 Feb 2025 03:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724900; cv=fail; b=n5En+EbZaTjmKbMcibG9tV9KctDGmNxU7kxn97siSvIlJC57tubqNzrO1rV0mmfaCFfcOrNFIuN/DzJvUQgSO5c7J0GtL/3lKnTPOlVvHio3G5w9WXMTVqZQ9TrSfFeg8ex56cMaaVeeZW9+IQdicQITGkDl146yuYaLrAS56Go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724900; c=relaxed/simple;
	bh=8hqdObAeDCQwx6LKepSaTVzNLq6PIUnuAQwMgyNrjd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oTjg9o6/MSE7V3ngyfOQjmxOkUBXNmkR/uEG7ZMFUFUzi4FKo4EDVIT6cVSeJK/x7LuvZEgH1XMityKin33eIvxYu98sSoseoXbZYmLw4YJDKuoPLHcx8aL2QQLvwg7ayfK5w+AugAVO1mTqjyZUk66T17iG1dcwVjz7PyqW0fI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N4U+S4bs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oOnC23nK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N4U+S4bs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oOnC23nK"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NCgik004493;
	Wed, 5 Feb 2025 03:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=L3aSLJY02rkxq16dhFDPNJXKy3k290aHjLMFhcn0aYE=; b=
	N4U+S4bsACKn3lKsW+IBxUTFR3Zn1a1h49nVTcXPnJmRpm2kR+NSuB36nHoBjnlE
	lpDCnz0cP2NwRfv0PT7g89cPiCxVWnjQFE6dLTE/8Byp+RDRc9rQbDMaWAfh6ak5
	xK6WMFRSBKwlrJ72gK6hNQXRhE94sk4Irmw+aUcjE/sdMgHamSGd0XZF8gXjjfb0
	AeKQW4gThcFNRPNdAcj0tHJDNhUPXiSNSYikluMnQ/y67Z5cArU96J5ftDVO8ESY
	MfwzEKEeb0q+1D8sVJEI86iCJwYb8jXKJNSjwcQzYJ4T+/+A5MewtY0vULeND0b8
	elbMB1+LYl1SFVgFsg1Sng==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kku4sdan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51512sb2037814;
	Wed, 5 Feb 2025 03:08:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn9j-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3An8pCZBV2+E6md6yeQDdFCVA1pgiWzen885Sn5hfXFrsIwbUaSVoBDgGi+B+7BNq1Sz8lwLZvhROSJh7R1aPHMEs7EVw+bOGPflkTV0w+BWEq3sdDHTvKpJx6hTltMtYV4zyvXpu1jzuVL+Fkn0bwvwTKAcWDQEofnRNgZ5zQQ5y3eVj4JtZngJaBWr9zJTDuG5ao1i1nSb8xSDVIb3myKFx3ImpYPiPZza5t0sCbjcm/OAp8UttL7TWUQJt3ePN+Y/sOvcLYGtakG+o6m74BIZyj6OETLLol1/phPxeRtg2dgStt9sG8qRivVe0Jp6BY/YqMJAiQZt1ifasXG2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3aSLJY02rkxq16dhFDPNJXKy3k290aHjLMFhcn0aYE=;
 b=mkFd7Gx4IoFggQJBONbnUekNI8HEsNMDfOU1tRgwRSqy5wV0v3j4RvFzozSthmvd3Sgf3bVvvQkrWvyOidRCPjARWrn38WvNrL1bxu91GRQnnwVOt4LZwGiRITJBpMUefqDBTufT7MQFAWzoKEiO5wVj2ZPPBB5Wp49HbOdQ/8onPc8NsG7aD4poOmREiHLsMFj2ZvuavxueELOUj5b/LbRlA3kkCjU1U1JKYsWgz1LpfkxmnjFv8OyY1RofWlDhPlwFBSoZNCIr6jDCq3lzu3Jh5hfCTFugZkeIddw5sR/R0nSC8DcSedeqNpGa4LCK9DrCLt3Tzf644zCsvZtJ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3aSLJY02rkxq16dhFDPNJXKy3k290aHjLMFhcn0aYE=;
 b=oOnC23nKroQRkeWCkVc0sK4/sN3q7g6ZQ1+e522iKSYP4/hjMEfawh0PVXbyYMZd3mzWFDtmDP9PN8atWWKAMRBBWqzcadb5eIadqBvWB5c+Ie7BHy1G7T+yR3GYur/2x/s8kJeTfxSmHVk5Uz82YK6luclvoZ+ECm/iS1ER3qE=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:08:06 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:08:06 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 16/24] xfs: Remove empty declartion in header file
Date: Tue,  4 Feb 2025 19:07:24 -0800
Message-Id: <20250205030732.29546-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0108.namprd03.prod.outlook.com
 (2603:10b6:a03:333::23) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c4fe47-e4ad-4f88-19e0-08dd45924ffb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nx5wPmDJRIUFhrLW+2copM4kz5x0z12zITurNEGBtBXa2SJDUYTjIcTDRr3T?=
 =?us-ascii?Q?71jbd2oVl7q9k1iOM0gVrpp0J+GMnDQJSq/HzKBpEaQzaTsfFIyD7sed+6GE?=
 =?us-ascii?Q?hedGtb4I1pNPG3AbJ3yBgxgYNSN8hY+HmnbFRBPkgJ6W9MOpMqsLEYl3qHFS?=
 =?us-ascii?Q?nqMY31ElpinM6BFCxho4cbNbf8K1NJo5zjp83sRkFauYk+Qr332RLdsQeP9k?=
 =?us-ascii?Q?Pi/VpnuFpEaxNXTLc6IUsmcHg6Qa55lHgzVQmMgFrFs83gbqE1BChBnK5v3/?=
 =?us-ascii?Q?/6aeavwsKjU82+frxLFVrphzmN05ycs+1W2RHUQARsaP9nrVhYAs4Bn8atJ+?=
 =?us-ascii?Q?ZuoS8NoothVDeqxPxd6yf743Y/gSB9HA40oxgJK46kSYxJpisKU84NeT6hzm?=
 =?us-ascii?Q?BBG0/CmvQBZF3KnIjGDNvqNoDHYE9DGyH6x5P8Wlx74x6h8UaSzXPf5qvObM?=
 =?us-ascii?Q?8CB48YUpcgykH7pHlrhhQA0dVcxwnR3K3IE6q+uSr1saSBRIxq//CcdDOTGQ?=
 =?us-ascii?Q?FEMoxsS412hy7rh666anZK1jD/oviyp4FKAJQqgnQGZlgtKBXHKZObhgOHeY?=
 =?us-ascii?Q?irL2aPYTtNiXdg9gZ7vG3bOzn0aVwLAne7kJxMkKS0RWLqFFe24eAgWk/VaO?=
 =?us-ascii?Q?8Wd49YOYZwYHwD5nxxunEJNOSQ7necvEPcVC/zKWwUAXCnVnjwbzZB9eOAmB?=
 =?us-ascii?Q?zNwimHfbuN+dOwwncxrfSHB6dYvsNBIE3G42NMsOOoaa2hXE4YN2CiEplBQ/?=
 =?us-ascii?Q?h5uoY8l55uTRjhZBAnrqR01IattLph43GcaWOhrmvFkO5FIJfNqjAHCRj2Bm?=
 =?us-ascii?Q?KSZcwMQkcAW2JUkS5V7I5FL8yJ62kZfCYLd2abGArbDLRK2mtsPM4/OxGVan?=
 =?us-ascii?Q?kOf14B6CHB/upndZjhcZAL8gmFWvMciBVWRDEaGJ3Lfjc2ArbCKkvjdZNz1q?=
 =?us-ascii?Q?r453L0PUxbK0aUrQqbRdH+NyW+fVjajoJLKYiMLfPlzi3yyD10hUunCJB3zE?=
 =?us-ascii?Q?ate+PKVseYkph0akrUFW0Mt+XbT2LLdQ409sBXFdxyIqY0j0kOpNMBjvMBrr?=
 =?us-ascii?Q?DDnEUPgM1HhEzPgzoMh99P/aH/lh+bN1wGMEbFbCY4l4ldQ6VrHHdP5OftRq?=
 =?us-ascii?Q?pAEA4ASaH+0CKw9NMffcW3+o8ZCpE8/B/UItqFYrm7b05c7NR+OHn06xkPd0?=
 =?us-ascii?Q?KvwdXJHuQ1N4g2IwM5pdXaFSZSnXR/Q2bDurAJqm7f970XxbsDdPKMn1F+6l?=
 =?us-ascii?Q?TXSahiRD9QvigOjoiMf3bxRq2KSFlBNpPXYSCWfQ6MagEhJ7ZnH01/w9EBRT?=
 =?us-ascii?Q?gXRVIRaq2A1cFygA4rvsblcOept/sFri7rQgGpsWRXilNmi9IHoK44Ib6BXp?=
 =?us-ascii?Q?46dPpxo4W6BvwElxF0y7uy4ob/+i?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NujxhvazOMDDIJoov6UNUCFDtyZqW819dDoM0W9SFJqGfBBWulsafOGvYwBT?=
 =?us-ascii?Q?6pC98dGaHBuf0oasxxMRl+XkdBcKOOfCnHPlFeAnRlhpEaC1sASKuhUdhj4A?=
 =?us-ascii?Q?hP2oZr8279N51AmGNKqYdAI4FL4iUhBgCd/XUcnui/f9szLKy8LippsmNKZd?=
 =?us-ascii?Q?sXLGhfvi00of6h0m2pihUQ4w+jEMRTvyjlVwSi1PG5Kr7ZZcd9eZ6SZ80rPd?=
 =?us-ascii?Q?HakjVOeQ8sYAXrzl5sYBobAKMsQMe/10ci/MjMxeJkqRMIZKwccoxX17btdA?=
 =?us-ascii?Q?bu6JX8Mq7jMKkwZxyCUc/ipYRNTTCgI03VY/7OS3ub+nONqto/01gKDpDsT3?=
 =?us-ascii?Q?PncZ+yQywR0yU61M3xt/7qa5RpM7EjizJHNlTsSzgvaQgrr0FZmWrd8ysB1r?=
 =?us-ascii?Q?7TOeZ1QgQuQoDQ4P6JFiqhZzAxviUvwtGYjOPtIkLnne5gVKkbhR2cJshGez?=
 =?us-ascii?Q?wKSlNx2AVd5jmiY57ifCSOdA0ck6X5Ny9i0/nA4+pIVB1X1JgEeQZpjjYJ6J?=
 =?us-ascii?Q?4Wc7SC7JAaCQ0mg3/qy14Ty18syO9Pphi1lcVKhiyIcoA+IG/TGxha38Hc5o?=
 =?us-ascii?Q?bxbDhOud3IZqpMpZ7xvRUqAQrN/zvSRnedyIkWvAxgklWkJwcbcK8wZaovRd?=
 =?us-ascii?Q?07ltpi+3k6TMRM70+DgTYbhSIPdg7pCNt+Ih+BzkdGyDSg2B0Ky5zz4IUmhn?=
 =?us-ascii?Q?3UgXF2ohYU3FC9oVWHRMA00OExiT79mM0DDjvxZUAQabocQV92288RXBZoe8?=
 =?us-ascii?Q?LVI1z+swbFphlLwa7jQP1jDpXgdbFRfItWpQd1NI0YAioytzjTP1vZ/8MpEO?=
 =?us-ascii?Q?LmSI5W4qDeh9G8MITDmzuyZAnquEn22EoApTeliMbLD9zsWECAqqvRbnUsFs?=
 =?us-ascii?Q?lUFCvpub176d3Df7ysrZGdWVkb6LCi4Zyd0whkHHXkCBTR/N5Nxjqw6r9I9v?=
 =?us-ascii?Q?6QET5bqaVEwwL9sItT5zplUlafXofOzxFU8BnEkLPm/dgBNj3VfQlA/H15yz?=
 =?us-ascii?Q?rTuAfAmK2dfyCzxqh7FUJeZhlr7MHn6IKTX+wINHIjM92Z40yNZFpRIqK89a?=
 =?us-ascii?Q?OmrsrCMRbWASq6X6HKvZUjieb2B+ukhzaz2WXdkj3e0r/F8i8GxwgRswNHHA?=
 =?us-ascii?Q?7KRBKlVoPY1QACh/LM+keDtW0P3r1h8uXuTOoMS+p/7mFT6XJh3Dw5JwpEgV?=
 =?us-ascii?Q?+okdHBGeQH3CgHC0kBth9FPjourTpDxiWL88Mjg4MF63JHcchVz5JmroE870?=
 =?us-ascii?Q?ISVpWBmazRMtu/Vzyc/+MOFVNxQZEW0KVIXFFX5vMGNA4wl0IZ+qL+U0NGuR?=
 =?us-ascii?Q?X00W8OvTLM7lsQVsQ18Z5zbHGpvU5t2gMssG2U62fKfdJ1tMbSqabllswS9m?=
 =?us-ascii?Q?ztdqpcGp2KC3tmnqA1T9iXQumhk87TFdJOh2oTU1mQeer0YDYVxKCqg6OGes?=
 =?us-ascii?Q?77lET5Cr6B9/ANnrrWj+QmIFrI5iNR7vQrhRuEZv+RQ90W1LOrb7Oio9junR?=
 =?us-ascii?Q?Y3FDAXlkyzW3ZmGryK7g7HYKpfFe8mpOyPa6F4aqstQnxgT3jOzOBT5ufP61?=
 =?us-ascii?Q?7g2jfyWhM85ubdM7qW1vOGtPsYdL1tGgezISQzpeS3R8VBdS9fO6Lo6N4YDN?=
 =?us-ascii?Q?QQh2S9oBlpFADJHt/LhiotpbsAaLXgN0s8u6DMrGbclNXbk5rkDitBTjAHmJ?=
 =?us-ascii?Q?iuViPg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X2C9IRar0tIIUG3pWZOCyshwK3ZYKcIMURlN5Bz1sibZnXGfD+GMVzZUerXRaWliiQPB2lmJKzckEr9HDf8k0FAGclCIYqKFOdQJ6y7MJM96SMrZJJCvOXpgFzMlPizCDQ3MCjhWfjQuT8dHkroeDN3UwXCzaPpOOhdttdBnxOwYafb0NLRkAy9l7WvtZvbxxAqdsNKOy+hnvbbdjcU3e1nQ298WnUB5fmQn5LykHRBxSWyrH3IvEJuZEOD9k3NVtwdtOzmyDlEk3wEMVQCN3K6jfOXcJ3dDv9W3MI+zWTWk4d4boZ1dXS+b6DSWmSX6fTX0RSPEXOTS51T86aLN2Ifk9N6q5PNDT4BjfGlkZhpPYFo7v5EbArNabJKB1Bt7GjayvEWSucHNC7BhNrShoBBYHgUf3vRwZZj8Djwz/dEuVKnot8KPxTWmkAqQh2bYB+oH2L6fONTbKJtx+675/KWapkKkZYyEhvE7buPbZ0aunl/Ar3vwGBcMwYs4pgoO/ChIGxiEyfNctlFoDokmFsuZ9rjrAauLPjWKVQsg5pRsKONL455IwHo6eCN+lci42PQMFkSKwpy3bTkxwPKC766YstDwl7WBtXYs+cCn/iQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c4fe47-e4ad-4f88-19e0-08dd45924ffb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:08:06.8042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMArr8WPt5Ev08xdqU3HWFzwhHLJrb7G3pU1mUcNLqDGjNyB4piEa7tCERDvAKdtg0NKUBKn1IW+Iayj1b14cWjtaTPERGzslPK6uTItG1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: OqJe42uZrwY77fmlq2S472SJsjHhwSPG
X-Proofpoint-ORIG-GUID: OqJe42uZrwY77fmlq2S472SJsjHhwSPG

From: Zhang Zekun <zhangzekun11@huawei.com>

commit f6225eebd76f371dab98b4d1c1a7c1e255190aef upstream.

The definition of xfs_attr_use_log_assist() has been removed since
commit d9c61ccb3b09 ("xfs: move xfs_attr_use_log_assist out of xfs_log.c").
So, Remove the empty declartion in header files.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_log.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 2728886c2963..8e0f52599d8d 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -161,6 +161,5 @@ bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
 
 void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
-int xfs_attr_use_log_assist(struct xfs_mount *mp);
 
 #endif	/* __XFS_LOG_H__ */
-- 
2.39.3

