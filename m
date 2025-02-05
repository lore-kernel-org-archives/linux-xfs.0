Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C19213245;
	Wed,  5 Feb 2025 03:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724898; cv=fail; b=rF3nKzSXTLkbJJfuYTz1QyJ8KVECquTySXL/b+q10U4Kacs3tlO4bp1xnz7+UkPus7p4GoxVM92OomEzXqpiSkT0qV42fOpPg9gFE2nhhtLtNFnS5ohR6zy7wubf01XjVyT3vMQo2R5dnVBemI7Y3zWw0+BY1zOHzDfgygixVdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724898; c=relaxed/simple;
	bh=+IHG3LDs25/Om8aXDjjRlSZ14kOWvdngdCG7Vd80xfo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bIVFNe1GaQJw8eiiZbV8Io8Bi4Vy/T5re4PgaWMvc4J6MpsG4wcO43U1dqaqU20Mf3/l0ykZdPRoH3+t1Fi42yl37VEjMg+D1FtiRYaYfNH2XYfRmxPLk8dEkyN8zdK3MduktZPQHQPuzLc2v3ydFAMk6XnrpU1gBASMJuMbZeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DA1WDwaq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d/uF9BPQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DA1WDwaq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d/uF9BPQ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBrhG013154;
	Wed, 5 Feb 2025 03:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0NIALwzmJRLuV1yzuSZBDuTCigwDL92lhKWBbEIcqGI=; b=
	DA1WDwaq3eY+OxVM0niuTXo58wLXGndU/EJyPPG71+XJH5jMfSwgGQevsUB3dk3g
	6srYYLf0pamUG48W8fEv1hoBwNsC5/tf7t+Ek9cBWOCOaCZlKe45pNOUeprCKpdN
	vJyKdfv+mAe/tbrDGEkavkxdF3Aeo6JUEawjrucSjEzpAAFFy5MH/54zQD/pMH+m
	LLrochdfc+yXl/dbjgIEYd7q3Mwtb0+SlPjE7Cyt4bsW03O93LT1nDmX5okO5bgg
	Z/rAVY9LqPUKqVSw2+QKAuEBgINib9kyrlH6gmwQrc50w8ns0+MbB3xlxl5QwA5J
	j/tAMNJltkju1FBfg3ULcQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhbte98y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51518ZsZ037739;
	Wed, 5 Feb 2025 03:08:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn1b-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=okEE9hVG876OJKXX/6AIreZ14heGQgpsp0eo7Xnos3B6thxNI2gturGnC/DP9VKCURUzTQ7GkDRiYABFNvpI5DROsLm6mYBM1XrNMl7RJQF8iiEdKTCLricGoa3t1eMn3i+jSaLhLpjQwHwAHUxHp+GOTfb4EnEVUk+gsccnlqD9swg0JzKc0YaQ0la7vw6xHVBep4/F5PjG/Rxu0ha4uMIKa2HJGjCk/9okwSQRb7PaiMgKqj2RGvI1pe2ED4tHOgnokIFp9rwUBMGYXRRH0NY2bJbXXIAvflmLrSFHfXovEPYV/8y1AGsQdEuCvqK7l0ZSWeujydMx21vqe7D3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NIALwzmJRLuV1yzuSZBDuTCigwDL92lhKWBbEIcqGI=;
 b=VofviQMBFy9hF0VYwGH+1d6zF+re51YJOT4yW8G72RF3iCgli5zi8vMYftvP31zS3kQtr8BDYLYD3kUvvDPkAMIfGGww9StHyy9YqieE95HFT8jLMaovR1FAi+SEcoEoTg4F5mNBu7nkqaLlZ00r9PfJFu5C66uZP5Rg6ZAfL4G5waQ8lAhT+6SYZX5eakAT+f1o+n5J0s0wmd7tZd3n4uQFEHKj3eQvbcpwcqPGjeH4QbbJDCVmQQpEMT84414Q02+VCKKx5e+iWHYnuji+dwO/faCtfTFI4yjYN/pk2HEgMJ92hxVFBbXMY+/JbN+RhebpI0YgJ1SisDYNirmhSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NIALwzmJRLuV1yzuSZBDuTCigwDL92lhKWBbEIcqGI=;
 b=d/uF9BPQjt27acaMkc0xXp+qhzDAJwgMh9EQuBwjvh8mXjnqcbIdkPoKKu4/5w8pEoZImIjaCtjqlUupXB+JFJRtBC6rfltmomAG/mlDvq+PZlmrIBGsPQ2GT7LHDV4b4iY18/eEC2j9JiWabmdd3nuTnmgLhXWfdqXR5pwTkXI=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:54 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:54 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 12/24] xfs: don't ifdef around the exact minlen allocations
Date: Tue,  4 Feb 2025 19:07:20 -0800
Message-Id: <20250205030732.29546-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0331.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::6) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b8ba77-f04b-47d1-657f-08dd45924895
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lEjqy5Ag53AEIzmbstkU8q/uCdMwD5Kl+4XFzjrTip9BQmgfpgY9rZa55HpQ?=
 =?us-ascii?Q?L/ugo9ot5Hw4huExXiiE5SYBen2OMzfBpvX+OC2HMdfMVnfg+DtENeIipYM+?=
 =?us-ascii?Q?AYJ8vPjGjNjxAzFSqVnNGObsnJzSqXSKOaCHNanL+vleO7YF1E03GKxeqG1c?=
 =?us-ascii?Q?tFZSVlqpNXYBq/3ALahijRA3UJQw7WjzThmGFSi48U4jqFygUVAl2hozaP9B?=
 =?us-ascii?Q?HObr5bxpSDtFTjZaReQaqVdR/b031liI4Z9mahOoqaNt3lSxoj3DWEhXPxNn?=
 =?us-ascii?Q?lPsrG6JbVxgcN6OgvgvOr7Hu6N6qFfot9xgamxBii/8Cu58xWXDYBvtFTZdw?=
 =?us-ascii?Q?r13go6JX0DeS4g6M19izkDzLiVHSrcvtebQaYXIXYHBBWzCGw+31C9WMZ+qX?=
 =?us-ascii?Q?0CjmoB/4YAGRUzNUSZw0WTWXauxX3Hhl1tj8lQ3vvbtVbhso/8q3exnXkkgz?=
 =?us-ascii?Q?YNsKYH0VV6jP2sd9AhR3UYmLxc9Tei3L1eGUhQptwDOrw4zEuNJ4bZc2F3uN?=
 =?us-ascii?Q?6mYwPMNFH4rqjJsgG5tAmMk86X/i0NAaYoFjLZe+Xv8jEf7IbQyBS7FQJ1i/?=
 =?us-ascii?Q?z5voiH0m994jqd1joFxI8Y+gJX3Qq0GWcFT4zPfxiYzGSxyAvAatKRdmOXFu?=
 =?us-ascii?Q?SYOcoJ+iqltNbMqG6G9ZDuPHkgP6MdYimmMc8HHfA9FykYPEoTqHFqT+K/kO?=
 =?us-ascii?Q?aS0fna0uv2JjyvA2n3YC5O248zTKPpIbA9zJ+EY5ynIBtL5bQrsioNXWrmj6?=
 =?us-ascii?Q?bcw83pXLrDt1J5L4QDkbdgza9ND6hu8owXhViixfKcoYMhOpm1Fg7wsA4tFY?=
 =?us-ascii?Q?ol4zxS4uRutK6cn/RvYqKcDZIh7UWjMKSFPT6kWT2YUocDRy40Mh1j3fWVwG?=
 =?us-ascii?Q?lnzTarjo0XWHIk3cwUE4Nb4Wl1VdsBJcN5xQsz2D67hsJUztcWHlvalpcr7u?=
 =?us-ascii?Q?F2pCJf9ITH12aJIGOYU+qKvhX1vIoM24VnNYAEh39h3OZbKc2f2oMiXvMlGv?=
 =?us-ascii?Q?151PraVGAd6UTl5fJjdScG7lLfGa1hoORXT2f9qf/as88jxitFQqaBMdIMMb?=
 =?us-ascii?Q?owhnprheUDOddacWNwXpWZTEPZPcQAiKHzJ74IpnXmDEBfWXvczy7FjQ8wGL?=
 =?us-ascii?Q?bFk/h7GYB7JPXJM+6QlsbRef0WeidUwPi5AwQ1NaXKA+9V2IExIusm97DUXC?=
 =?us-ascii?Q?RAET+uvRajtljOw2aSt+/1majssg6QXS8K1/E9y55q4SaHbRX4Sd7pbK0y6h?=
 =?us-ascii?Q?ArrLc29p1f51eW4NJV1hDv2Zh+gOigxofGjWlxyTFulrL4I+ig0MNctqP9bc?=
 =?us-ascii?Q?dJxIhrOohKAArsgnAp7kBuoBqd4fwuF5AfdJz3w4ePQER4N4ny9uZSgX+aAk?=
 =?us-ascii?Q?4WsABDzPfEKQzMe7zQVKQlOotq4S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cuo3iQ/E7e5A2hrAYBpilTaM2ip+mfahoVBnrQTxNcymjR88m9tgZOaMpclw?=
 =?us-ascii?Q?nZ74bgIM/G1KcfxuupIYgYlQjG0gjmJSKhv7UZAvyIWugecpxNEP0sVC8IIF?=
 =?us-ascii?Q?Eq8L/5Hf8VtVcQk0T4TNVcWwALup3lBTN8RN4mjP9ioLrCyGN1k+2cQ8iFct?=
 =?us-ascii?Q?gktkSQTSQUIudxSe5lm8nD0eWhzBybEuG+dP227uBL0VdMUlXUANkDFl0mwt?=
 =?us-ascii?Q?7IQ1zaeXB5ZlMp+pcgyqTNwxNQIXcuHCcUU8snqhtCt4rLTY0UYMgYFLX1hu?=
 =?us-ascii?Q?qs5rd2V6fyjag1iIqlMsQHLjGBzaQjL+BcWP4S9jtJVSolRv5zl9/1zn3tdZ?=
 =?us-ascii?Q?iNVjOgkVpPK8z9DHrPflXvfbUIIfMWKBXI15COGegMgcKC5CTz/a4zT7VuID?=
 =?us-ascii?Q?wm1MOFXFpISKkGHhoBbYU0S+kpbGrSpSajjjOISLcTqbRSrRoEVW0ojTZ7V4?=
 =?us-ascii?Q?D58BYeuu3TQgEq1fuuQ7OCiMfKuSNxtcpPjYyPS3qsA+1BkxncJJZ6ngDI13?=
 =?us-ascii?Q?jOqITscy1qtDGpHHWOfFYq6E2fbx1ylaizY9ZEXUUDDu5zmJ3wPyDKvRLogt?=
 =?us-ascii?Q?dOPuv+wfUmZS0HMX1rE2eoVxsDC/84NzoelbAv633/O8uMH7LqCRKmLIuKaw?=
 =?us-ascii?Q?GDKyQyboWONmQUicapVxhpL1Ppiat7PNQlkXJ9KlsrdxdwPanB7591C49pMz?=
 =?us-ascii?Q?GOwwCZ4E9YpD8CQufp9QLind4WSN/iz+U/DVApsDAi+6j5By1SypoG3Lz7QD?=
 =?us-ascii?Q?9HH8BSDInKjLLQkVsEu3y5TnGTrmlvl/Kwt9LKex4ktGNQASjSfG53B+3EC/?=
 =?us-ascii?Q?dLbyzVNy6JEAr2GvqpRNspyCWlMeB6VwF3DWkW69stlNRflL4U0Iu6yduB0P?=
 =?us-ascii?Q?vl4bEEAPESCAeK68TOsrFuaYOysAkNDdC0Ommf7Hlmm6arVxnZtEvUvg6n0t?=
 =?us-ascii?Q?31829JK3js9/W5sEUcMBpPMsZZM/Vk8MLJPa10h/d4DfCZ5sXFPGHtBV6g1Y?=
 =?us-ascii?Q?RnSr1/PzOoUz89BZTiR0PPSesseFg/ilrJuZj/Vjz7OIHLo28DR3IazJog8W?=
 =?us-ascii?Q?V+R9zMYdyELkOb+LQkRcEUh0cp5lzsbygtERgxGUzYrFXPDsPILh2fZGs0fw?=
 =?us-ascii?Q?4zSKharlDZi5hx6xcSouxktNdxXpXQyVjH4OXp1cjTSTstF/jjivu4f7H47a?=
 =?us-ascii?Q?9Pek6Xdy21lFXQNTT01X5uqmJIiCnHx3VVGoSklCJWWCBTJiRXAPI3sxemgW?=
 =?us-ascii?Q?8EbkZI8vwoKqjzIcMfg1OvDh3Z49w8t9bMHktQIuEUglgwo92GjtpaaHFVp8?=
 =?us-ascii?Q?Kt3/FiGitHRcbvYORgDnnNoYFePob4cBoTd8f8nzr6lJAs0WlENA5wPi0ezZ?=
 =?us-ascii?Q?bz802DrXbsK9uVhFiXaFzMtnPKxZh+DuMMDXlyi0U6Yy+EhKwIWXYNIc5Y3g?=
 =?us-ascii?Q?fG0IkzbR736NU6SClKKL2ndtswkPhi4JGTQ9GXLzd22m+Z1ZL4+smvlwApzy?=
 =?us-ascii?Q?ex/xBKZ5t3jQwUogoKxgmsuPAeH4TZud3kPMlFKeUCgHO63d4cJPUj+fHwv5?=
 =?us-ascii?Q?rjU/fKtBKAbgDbdWFSLaY1fFH59Ic2KxbXiZzYwgaLr/LQedWw4oJKfm7Bd/?=
 =?us-ascii?Q?hHMS/bjFdqPunukoIulnpq/L/VZrmadstvYecFmJA76yjNl5nT7DFIuCquni?=
 =?us-ascii?Q?KoK/og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jz6LQAJMkEC9o9RazlLM3sJMW/7XlHhnXvY03+U/SYJ8OOxBLohRB66yRmZM4/G+ERsek+iEf1WQ7V4OuZo3v3h0hhp6hK7KAc0ar8cUrMJ/bPErUmw1pPTr28fZQUSAZ7mO3hGYmVxU16P1YdUhDkJboBkLPV/Ij58LHuLC8VZVaOw58+12M4k3TOQvL3+hqZviICSmY6H2YyJkN77xdZB2xmbOw7OVJo/gaw1wPHCzZLupWBOQiOLh5BDOHrE0EPk0cUYhfzHVxoi6gi16jk50NKdOxF6Sf4llzZaTDenCzRtDDkdr3hzm6fih/NSjCc3kxzRVLorgjjxlP/uGZlVdHwpb+ySN5e8Wmp8/3w9aYq9Y87ohi/pKNOjwjIgzSaGf0QLtAozOxU5B61qWHBvC1ccX9JoNeSxJ8I/F4ypuEqqtQEaIZJJA9qZNdM2VzOzEbD5p/Ehqe6oR6eI6NlRp0hl34Lm2HDpmGlNDQO/owc6AlufIviqsU7igRjdDZUWRO5BbnhGWxtUpuAt7gOYUAegZs+7dwe9zrUA5v6iQkaIXobkyxrRZUrZLmYB83gxtQKij4z6E5AsS0nF0SzLXET/aNLhbC4CeLgHntgc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b8ba77-f04b-47d1-657f-08dd45924895
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:54.4051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AHML62BNqdgoHQ8Rkox0qXXTzWUOU/3nJUDSCQDPYxbdzOyAT2XeqpDf3hNWQYY/FD3qH3yYVCJIYUqRAVL7ClpCQD+CXPpK4VZzsy9L7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: FD29Jelx6JEdAeHpshFH7dwwVfyx7Fmj
X-Proofpoint-ORIG-GUID: FD29Jelx6JEdAeHpshFH7dwwVfyx7Fmj

From: Christoph Hellwig <hch@lst.de>

commit b611fddc0435738e64453bbf1dadd4b12a801858 upstream.

Exact minlen allocations only exist as an error injection tool for debug
builds.  Currently this is implemented using ifdefs, which means the code
isn't even compiled for non-XFS_DEBUG builds.  Enhance the compile test
coverage by always building the code and use the compilers' dead code
elimination to remove it from the generated binary instead.

The only downside is that the alloc_minlen_only field is unconditionally
added to struct xfs_alloc_args now, but by moving it around and packing
it tightly this doesn't actually increase the size of the structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 7 ++-----
 fs/xfs/libxfs/xfs_alloc.h | 4 +---
 fs/xfs/libxfs/xfs_bmap.c  | 6 ------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 100ab5931b31..d8081095557c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2581,7 +2581,6 @@ __xfs_free_extent_later(
 	return 0;
 }
 
-#ifdef DEBUG
 /*
  * Check if an AGF has a free extent record whose length is equal to
  * args->minlen.
@@ -2620,7 +2619,6 @@ xfs_exact_minlen_extent_available(
 
 	return error;
 }
-#endif
 
 /*
  * Decide whether to use this allocation group for this allocation.
@@ -2694,15 +2692,14 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, alloc_flags))
 		goto out_agbp_relse;
 
-#ifdef DEBUG
-	if (args->alloc_minlen_only) {
+	if (IS_ENABLED(CONFIG_XFS_DEBUG) && args->alloc_minlen_only) {
 		int stat;
 
 		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
 		if (error || !stat)
 			goto out_agbp_relse;
 	}
-#endif
+
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6bb8d295c321..a12294cb83bb 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -53,11 +53,9 @@ typedef struct xfs_alloc_arg {
 	int		datatype;	/* mask defining data type treatment */
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
+	bool		alloc_minlen_only; /* allocate exact minlen extent */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
-#ifdef DEBUG
-	bool		alloc_minlen_only; /* allocate exact minlen extent */
-#endif
 } xfs_alloc_arg_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e805034bfbb9..38b45a63f74e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3388,7 +3388,6 @@ xfs_bmap_process_allocated_extent(
 	xfs_bmap_btalloc_accounting(ap, args);
 }
 
-#ifdef DEBUG
 static int
 xfs_bmap_exact_minlen_extent_alloc(
 	struct xfs_bmalloca	*ap)
@@ -3450,11 +3449,6 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 	return 0;
 }
-#else
-
-#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
-
-#endif
 
 /*
  * If we are not low on available data blocks and we are allocating at
-- 
2.39.3

