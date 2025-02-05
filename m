Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04BA213240;
	Wed,  5 Feb 2025 03:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724868; cv=fail; b=RXevFMFXcjokaeJJCWQOmQnVxyzOOPSWSUE1b+tCulVWCfyCH7ZNGtst8J3EJKRK6CBmA3G2/dPBQzwJLOffqDDLkBme2uRvNQtxsxlwspPgDGww6MK0GmUDSiyvujDOmEk6jemXGMCBqDVssBevyIgdZYW4paiLnkAwkT59v90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724868; c=relaxed/simple;
	bh=4zogDmxRdn8kmjsjxztf2r5qIlQ4ba9qITpnECQvas4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c+f2tMtEdPp4Of2ugAOQqQlZ71ZEp8INtuWwK1HJrUu4l45CH18Un5jb9XvC+BNz6A/tyb2o+Yg7/yNyprvylJ0fAvUq/ReRil/96p9K2Ho/idwKBSgik+Xymz0YEKYR8xEbrqyz7u9hgBrny3hKKWUM1JY5fjSsgKLlb3I30FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZfJjlSnc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Em5JJLxi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZfJjlSnc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Em5JJLxi"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NCNGM000388;
	Wed, 5 Feb 2025 03:07:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RnlQog9JW9wancgfM7d7ecyRFCyAGBcX/P+KQ29r6Os=; b=
	ZfJjlSnc9gG2jC7YOF20GpkQ9CZwlMuzuE58OtNFP1rfXa/0w+WRR5wajdEjT4Zw
	O7gHc/C59tXDszY1SwsO4vGNeGMpHIf0W5nh9wwatJre2mXO/gob6zTZx0u22eNG
	g80GvsJVaQTPiCQv4QuCeQ9NQV85IS5qAu9Q8v3Q8kk8YJYnoUdng+jxB+PcvUxr
	TYCDzq0JTiWifJgTDEpp4xLYL2hUTLRtU5UnC9Rkt/77Yhc5vTIh7s+Act/91oxC
	Ymlb87F3RcIKTohFknbMgDp45MZyiLcAHFc8pPpwDG0XIZUJdRpVVlhwYXfgeWRI
	/vjj/S33qZ7HNDroYf9AOw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kckxj3qn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5151At3m039057;
	Wed, 5 Feb 2025 03:07:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e8ht3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nSN8vUtOybHNJCEXy5nVHWbZn6OFK1Zu8fu2uYgjK35kbmuD8491Gev8ADKQu7DFld1+1Epz/hrRyWXNfl8XIBY6qXNmtgGf6jpk520xyRttThQZsk5b/xlAjNrvM7QA438TIMm7y3y6NmpWrk7Xx7VFAzy1YgOn4OB9vMnm4WQlTau0r/I/gewpv1GFld6vD909/qFpej9mZ9HWrY7nponhU4LniB8piSObU+QN7uE94ZFnYWN8HFO68OLo9i4pnykdWcFHH3qSMwdo+09fWvbgQDIAo9wLkab6POItmaZwG3St7dwed3hojB7Hs/F5yVJ6wGm5vM4ZbHwRz9bEkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnlQog9JW9wancgfM7d7ecyRFCyAGBcX/P+KQ29r6Os=;
 b=xEKPJJ3Eruk7pz4XqYNY5HRJTc5dZ7wXnGS+cdWN59INKEDbQ/fkn+yGy2MFG5/UEs1CjK2EzojQbZdzXjJAUjbtIok8/e0MiUVrzNKLhAX87qB8H1mBTZOU0r/AHGvs1rD8N775oWG6hhtaOTf56Z0VjOSkUyZIq+jZoktRnfGwA3CcSVUS/QAo3dY0d+ZaPpS/jUkPsroySsH/ji2r0dNGHrM6T1sJj1ies441x2rCJOgC3hPkNRSPSf5j+wdMVN+QaH5nUcW3erpQ0iXnvUe8fnUg18sIXpv6c9GpEYk1muPAMdgaVtwqlVzF49wgq0WuvtEDXGlJfW0jBxKuFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnlQog9JW9wancgfM7d7ecyRFCyAGBcX/P+KQ29r6Os=;
 b=Em5JJLxillFYV9zizHdYklenXAt04HFou9gdvkwlabZwOJrfnE6OaQkWRIJNA1OLO7ImuW8W15KtomzFZRTMK5yNZtsx97x3Rx2ZBerLINsvSXXgGYff0e6WzRr8vsKhwAM4HvpwaPFaPgUCPGuKGWnwtgZna5p0zFnFVGaMP1k=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by PH8PR10MB6477.namprd10.prod.outlook.com (2603:10b6:510:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Wed, 5 Feb
 2025 03:07:42 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:42 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 04/24] xfs: fix a typo
Date: Tue,  4 Feb 2025 19:07:12 -0800
Message-Id: <20250205030732.29546-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:a03:333::30) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|PH8PR10MB6477:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d701dbe-9054-4a08-a521-08dd45924195
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uR+HKDvroDXtIBB6PpGB15j5mXET1hM+LOui4C4Tss+5Uf/YhgexlZe1tzmj?=
 =?us-ascii?Q?CdgyY4UlXC4Tqxq5UbojiKWsl7el2O5ePG0xoSF431sbRoJ3Lqba841tcAtx?=
 =?us-ascii?Q?zpKZ1DdBucQmY4AyDnsI6MCRfR9KwNDj/u/S5PHuLCXhJKQMiFd5hY1JvPbZ?=
 =?us-ascii?Q?WNxeyu2Ky5m4MuD2957N9MbQYYLde2drff2RGzPtH/sxMj4ffC2KL2GdvSc1?=
 =?us-ascii?Q?Gz8H9tFWHco2iMF4ds/klbAixuG9e4todVXCPOHBb+/dEz5quc8V8A+v9R0j?=
 =?us-ascii?Q?4PaMUvjPDywLtZHP9YfSTgxTPmuJG0KLhVx5kxM9Dy+n3NgSpEppvP/Zo6ZJ?=
 =?us-ascii?Q?wA76h27nuHvfcsQe/gNPyMKz71dsE/G4hBkXVnXL+g7dM1Bpv757qYTxYktW?=
 =?us-ascii?Q?v1k4SBr9sKHR5vYT/TkkFQWiqV+JeyjKe86IhwA/MbX6689wim0aJv2se8Z8?=
 =?us-ascii?Q?9lJcfTchZwZQPqk8iMJ3tOOx7Qyfhw67OayamsOGFnOTcpFAdez7xeaopOCT?=
 =?us-ascii?Q?8TdJcmpLIL4kH2G1I7AlG5efBp4+sEZlfJ5mUI+tM7YfWBQUwPtOCND2ScQP?=
 =?us-ascii?Q?KY/YQAkcuDwZuGVwx8d9GYEglTQVm4JwFxZJkxcbQsADtU4nP8NU/BKB7r7A?=
 =?us-ascii?Q?/uUb+Cty8HBOB1hHzdiGclsxW7ZC/Z+kEFJZllY6mdB7YQohGmV9r6NMGqsM?=
 =?us-ascii?Q?CXZvtnfmZQhzgq3niU0Nm2L7wQBv36U5wAzxqoYTy1v0Z59eWAuG/L7mVJKy?=
 =?us-ascii?Q?1oor3AdRtaBLvx5cj2eBTeykatV5cnq89aWmmqYSOnyJcuePLh2fI4fnI9vr?=
 =?us-ascii?Q?C8mAmKW4OPFnMAZQLHhegtUlpQmNlQil1rlhwTgq6so6n6V7ESkpqC3y7gGY?=
 =?us-ascii?Q?pwzO6obINDEfZSsOKEe4cptpmmgnIjw/08J3GGk8p8qQZQ8u8/a+KRHK4nit?=
 =?us-ascii?Q?CpNma1iQMIVCTrRTlJemP+jeEWIwbAnSMeQbFJadHb5MeCiYeX+IWW2c8d8i?=
 =?us-ascii?Q?hb2FwIB6JCCmDkFRnef5NnqW2BcKyR4zdM0leb6tLw7wkD2NGgJhTQMTMEot?=
 =?us-ascii?Q?5mxIEyNPyHU7HUKOCa4/skGbvvVraz88cOU8UzqmhUUS+NNRWJAGI2+GIy7o?=
 =?us-ascii?Q?1iABOAn7YvHpmP+EPnyYg068ERSqcEjmlgJ0pC6R4cf0Ok9O7IN9XJrN5EMM?=
 =?us-ascii?Q?awfnTfipa9Z0zSxz/qjJHPft3eLZ6AMFaGMjYEYN/2PReArTz4Bak//nbWwq?=
 =?us-ascii?Q?yiri7vVvawXDaR1oM7JyUysPBID8HGFPSa+ua9Jzxzl7ACtn73Mf7tvlRjEa?=
 =?us-ascii?Q?KVH1kNg/JKsnNlPBK1DMNbShpXC+rE4l+NBYAQoyE7aneo2Lp5d4DgPQTpde?=
 =?us-ascii?Q?DpSIEOS/eXJNWMQvV9vx5jxyBOSX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ALep7OA5RJDgyilAXr4NCLoXkcl8VgARn5pPZ0wvcfn71FB63y7x/PJ8RpOH?=
 =?us-ascii?Q?lWeY8WClYZiCz5x8VfbCLbT99ALxfYk82KM+A9n6mBh5g3ScaiMFfsVmt/2H?=
 =?us-ascii?Q?EuqlHza3D95wJIYDJ1GWiIBL4nGZKn1UMkedJFOu0v5pV1XmCg7IqMJNE9p3?=
 =?us-ascii?Q?O140GoZmuGfqJsNSQ/J2mP3LNTGX3rLh1YmChBqNjlfMddFEkXv7mWtxeNWw?=
 =?us-ascii?Q?F+hKcRVgsUUNE8+pRd1qEdIHZ7v9wV1KKorHBry/+MnlAMfcIF6dPqbvbWTS?=
 =?us-ascii?Q?jJQNvkqiIvyMHUYn95nFCi5cOo9Ion0pQsGPtl9OOvp45R+Kogkh/qKvet33?=
 =?us-ascii?Q?6LgXjgZOclpD+jm1X17oKrKHAk9a2oQhpXE/xFeJiUM0rdOAFCo/0LIhNmX5?=
 =?us-ascii?Q?QKp477uDt98zf5FqHHhLg45sWfU0Mbu1+e5Zi605SlltzWAdgKpSGrfDMzVL?=
 =?us-ascii?Q?g6CT6O5HCMP6bYyCA96mUIq43vJ22u05vNq0e4g9lnJMtic6aykthsuHvCf0?=
 =?us-ascii?Q?6Iin8eBHyUMYTXy6JtV3p0ky4rtPdxvtE4g7QyIcL+O1stk05J8isoKbyNWh?=
 =?us-ascii?Q?qG2Q4RkACq1CXWqSZIpl4joK39A0V7DSO2CVRXs2FYOpenJ2uUvHiaG/62GV?=
 =?us-ascii?Q?AIqTHFU0A+oeGMYU95E7wrR80rSXQd7Yf06EE+F6BR3xrL4RRDYK3CrhCcPo?=
 =?us-ascii?Q?oUq3CqxOGMydCyxd578FfjcUdu0Yly3Bi741ACeFH/5PZBkwytR0D1NMV7HY?=
 =?us-ascii?Q?Z+mrNerihJXgtIuRLnI2sdski3wU0nwN7l3X/Ft7STD93XJ66ZvCAR5sLCqj?=
 =?us-ascii?Q?+L3b92zuoTFW+BwEueGa7MzkNGpZFrDubUGvteAcYVQizILmEws03VjwQiVV?=
 =?us-ascii?Q?S54w2rmftFlMyeq8/tF8bNroqknl35kjCX/T303N1Cdk7N54nui91ryFJeeR?=
 =?us-ascii?Q?BVwXMizR3pOHdl7LScBPGVxnrNOQvyd0YXU3xQ3/seaxUOfNCRJUqyZ7DNwi?=
 =?us-ascii?Q?/i6KB/xlYnWxDhtg/oHrCgYcRywJMq7cQ40C9XQw78BkBqlxtVd9VrmWefoA?=
 =?us-ascii?Q?JR7nDuEXbaZiPK+ojPZIibCC9YtVd9kialN7U7oK6nYkwLdqBeH/M33YoVJo?=
 =?us-ascii?Q?RE3GeesnoBDuN3Gnx6V2PRv1cLVAdO0M2A44jztQ9eYh0Fnhb8zaDsFI2yK4?=
 =?us-ascii?Q?YefDoQsT9vKsCod0h0Ja0TQc4L3FFQph9GtVlfFiY9/5qTp1S7j2zD0zqhey?=
 =?us-ascii?Q?l73lREmDe9AvbddxaPqelbJOrCpoc9R1B7QZXkNbgupXjHeIPC4HW7quunZT?=
 =?us-ascii?Q?q4rDCYCb2TFmf6xa9xaCDNMk+ECj2SAYygFWKrJOKLrgzhwIiFNJJbEDfUV1?=
 =?us-ascii?Q?KKFAI4Pd4yy3kVO2Lmy/jnDXm7xpy7FrU39TISaKUaXOzYT3mNvg4PCoeJat?=
 =?us-ascii?Q?0Nq7zjlc27vL/1KM//GgCGg4Ujiuu0LvkxfPlwLzLy7AlrT9QDjJzWx7wivB?=
 =?us-ascii?Q?nDMm4/kNpjyRywO8QeskH46fIURb02vLN5e5Er8MgYgSNTqJZt/S1BdZVMrW?=
 =?us-ascii?Q?9tBg7U48jXCEJ8Ob5mITQ4iZnaJtyTgCNGyDnDqCAmjPX/j3HWgK5YFha7HY?=
 =?us-ascii?Q?6aMcbIBiebJ2YzI7RtKwn/KfkE+WWf2IdGlzL0WAxNaSG9YeQcksL626ATno?=
 =?us-ascii?Q?0QYBCA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W7Fjyx39GtGupM4TK0r7canF8q2VKmDXeTVOiHzYfwnzW7vcKCY6bOF1tc7RrT5kZjuw1KBtaaWXc+aFQYlZo4hdOSpWod4qACzUdvQJRICSiSeaQ39EWvd/25cP6XOHWbKKhEuecOHXx4wQ2SXxEgOUtx4CpZsGHtySoZ7EVaxs5oRyR46C/jLSQ5QnlZepMbWH3c8O6loQvz2J3w/a70UIPqQyps0oXMllQA6lFdvl8WjRR6dklDb4K3VReeOK5D6UIUO8UHkQwzQ4sWdoN9TyTHw8/i7X/4nlCw/RLFfxRN7d/+ZBC8M1k+CvKh61vHahJiKqbNuTUqfnwtmq8ktDRU1dX3Cstnf8V31DIelOXmFYDJ1x37H1PYmMWGWo+ssZe8mF+hunbfvqBlUi6VefxVVTe8Wf006JAMeBgaudsrE9xice9ywi2VV1G6jjDPkcUr5p+eFOGglZuAcIUMeIN8FETWm+lTwgc/cfTEv+L4AKexErb+YtzYeEn9hwE48o4dYxcxp/ISTT7tQJP7GJmUCxHytD3na4ThuWEsO5y/NqmI1P0ytxUFTqL+FokvnS/T+iUZ1xR95JahfXZrQkZwzYLuorynbTEIr5BoA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d701dbe-9054-4a08-a521-08dd45924195
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:42.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKVZ9xuL/Y+PJmrVm0koPO/mTR/3jtoTaF/XgM49kyjrXzMfSnfG4e8xrFDjxRBYIRrIhRoaujxt77AxBO+VJk07N7e12cYjsmJhp5VK61M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6477
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502050019
X-Proofpoint-GUID: n79JMaATQNmoRIgBRqhEoo-wLT2xBVWE
X-Proofpoint-ORIG-GUID: n79JMaATQNmoRIgBRqhEoo-wLT2xBVWE

From: Andrew Kreimer <algonell@gmail.com>

commit 77bfe1b11ea0c0c4b0ce19b742cd1aa82f60e45d upstream.

Fix a typo in comments.

Signed-off-by: Andrew Kreimer <algonell@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d11de0fa5c5f..9ef5d0b1cfdb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1820,7 +1820,7 @@ xlog_find_item_ops(
  *	   from the transaction. However, we can't do that until after we've
  *	   replayed all the other items because they may be dependent on the
  *	   cancelled buffer and replaying the cancelled buffer can remove it
- *	   form the cancelled buffer table. Hence they have tobe done last.
+ *	   form the cancelled buffer table. Hence they have to be done last.
  *
  *	3. Inode allocation buffers must be replayed before inode items that
  *	   read the buffer and replay changes into it. For filesystems using the
-- 
2.39.3

