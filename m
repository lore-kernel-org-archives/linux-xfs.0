Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AE1158524;
	Wed, 18 Dec 2024 19:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549488; cv=fail; b=DtJXcqwb8xouhzh/M7bBGlHLMimrwSV/LpvUv3tC7f10O5Kz2sYF5XaBO5Lz9+er7fpvHUJh032QmyXvPs2vVravespkce4qgvMKjeZpBCipgejh0JD5+J3bfd0AgG5jApyFUbpXYogfV31LT0H3/kNFFMqtTp/m5dFDG/9stAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549488; c=relaxed/simple;
	bh=PHBoGT8gnlHecvpt67kbD3BgVagM9Twn/02QrNyTzNE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pcT6S1I7KXZ8ZB23l0QaRgtlAAKp8GQQwscsHL8aL9961O1jVGrJhKJAkz2m8UJbO2SATHpMYspCAefUCe/O9724XLm8oRXKUgTdKkCl1BLfC+NEmMt+eCMnu4PDibaU9NItrozWc7tFUZG9Palv5gjV1dqYGE1wepUSP7ZUi2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WDdxIeI6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eWZQQ51B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WDdxIeI6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eWZQQ51B"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQdpe007799;
	Wed, 18 Dec 2024 19:18:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=NDagatAf/Kin4dQWrwDS+8SvuTxGdumanGW6JdHdpf0=; b=
	WDdxIeI6+1JMzxJWbJZtPV4plXxV0dVGttGL66BTiAIcLWYBOhKN9A/WZFwdXB+M
	Q1p5Ls87TIUmQFbbQODh18QpjAVq/dBmt519nIg7Jl2YKMqk/mfvtk4nQ2eD06JI
	ToGvNXY2bK2Gibh8h0/EQKok4H1yora/4v44omSrykUQdehzeFWVupDZ85sIa+mC
	gmDkxuzwyBrApGEb+sS/C8jYn6F0PHNdRNZkUj40xXMQgp/ljBykaPZ4YyWL0NGs
	Sw0VmttDN1KVOTcxbJQFoy+N4FA+gekqDgBHqKoFQ6vTeNuXw8Eu0PhTuoxl9ng1
	EadYqMJh/uPhvg+l8TyBjw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h2jt9h49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:18:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHUWow000589;
	Wed, 18 Dec 2024 19:18:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fad5nt-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:18:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fy6//T0c/YNkhfwMhkYr+BBxxhE4mKGjyXCG0QxVHE46cmqVBjfwFidUaTEEKjS5YEVG0Ibt3ozRMQ+6RN0rpK1RsyXqdlyysUtYXD+LTlsMLGpJC6Ax1uvh4U2gH3n2lDxS4ghtfKCIunWI0LOSsv0Dlpl2PVMFxvuCtCmErmQjvwOXswsW1NMLp0QbuDuoPV8z+uDuUKljeym0wyLn3V5wCRxaOkKnJQ0ff1c30Ho7tZ5gP5WnDqNi4IuVUo5Ya50SvLTK0E9uJGbWiin+9oBCMNcUEqou/jrMSpND2a1T5MhGE213PmhmHITgs9K0uZ+sBFn+krHq7JKDeFDbwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDagatAf/Kin4dQWrwDS+8SvuTxGdumanGW6JdHdpf0=;
 b=a/AI6aSR2xWzroQ5JXVFqfmM60sxstyvDlaNi05tv1FJoI4U8vp7RjkqFVyZaO5j8ewi2UbgnQmH+3lQEbOv4Czu6bjpx7xFeJYvhE+rlC51jDev56FSHxk9EjudryuYLZKkV7wI0vYxFsciMQL9G96JMU9Db6ttKrR223oXay8CTmDqI32sq8HgErd7rK6UVDXvP5+bvsz1B/RVT0fTMQUeKyvpiCjJ0JhylKmwu5AUvYqOAD6QcGRk1c+lGKd42KB5GuxLchNRFME/Ou6ICa04RHjkekmJ2ZOgSfYONPYByzxpWmGyD9LY2USJCr/RBFnIfw0suD9AxNHvieW/Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDagatAf/Kin4dQWrwDS+8SvuTxGdumanGW6JdHdpf0=;
 b=eWZQQ51B+XRSsoTpcjluaH0SdSXzNK/wvdawaOLIkZ57nC/QMNQx86fnMWODxZf0QqTRhSS7j+eJMgdpgW0KAxKAmvBZXkI317n6FthbeJYnvpiuSrQ7GK+zUYeEZXoK+mOBVHQNitIxP/tc3lucEQGCP+fPfY0c9HUnrw9urL4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:57 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:57 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 17/17] xfs: reset rootdir extent size hint after growfsrt
Date: Wed, 18 Dec 2024 11:17:25 -0800
Message-Id: <20241218191725.63098-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 3118b383-3207-4ab4-f6bb-08dd1f98ae3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1iu0rt3r8Ipm0vn2pfNaJIl4g3pSuqqkfrNnR+Gw3InElG/Gn1DDV4ZO1hte?=
 =?us-ascii?Q?yo+WG9B3YgsD1SIa9Dpq4GQNzgb1t+oxLG+Axbg9FmHRMgsuwnssy31rKOVq?=
 =?us-ascii?Q?+M8cex6GbnppLVklX6A/9Z8+MJSzB+ewvl9Q7PUIFNdmg4kKlBS7QCjMp46O?=
 =?us-ascii?Q?XbFLsW9ioVCMKx5j8P44FE3R0+e8GYQSEKut3rajZDKZcXFcreEPnPvgwHTN?=
 =?us-ascii?Q?4rE7RCYY6pzzIjwHCI5lcIs2qOttviMGaFnLQ//NXlNIIoQBg3PpiyjrUDrz?=
 =?us-ascii?Q?10r5z+vngA7Z1k3musyJuQED9qRGUFkZ+TtQBEjEJV5UjBWbH8ykCCX3RK0M?=
 =?us-ascii?Q?ekONKRTkH6ctHEWpFuRHjsrsJoOAMOoRUNKfrWdEVNhvsl5d/vsKO6jslc24?=
 =?us-ascii?Q?3AASbAcPPbukeWKS56E9qcdVSwy3vQbP9ITyMUZeXWMrtNboZP58MSUPJ4cx?=
 =?us-ascii?Q?T4ZkIpRCtL1dqGt9qF82uqutcMUc9DM1muiFlN9xDeCpjdg0XkucrIOZp3zv?=
 =?us-ascii?Q?RQxieXV7j+ul4aml8NQUPrdDb0NOGkkxQVlR1F8e85lghLuu/P+FxUPAGTSO?=
 =?us-ascii?Q?m/4aPAPi/a19yORVNizAzHktIYFaSHQYy6g42oU0N0yeYG6YGJgyixVeNJtS?=
 =?us-ascii?Q?Q3tn20k/OPeZ8qzTxHBN9mKv7aPddzVGXi2bbM8dVvej2el6D+1PoGGsRI9w?=
 =?us-ascii?Q?hMnK50zGDRnZcA4cjZ1IjDuDOs9mHp9eYZ7d8wp7hEhzGB/scTi4BYb34Nd9?=
 =?us-ascii?Q?PeYeW24VSFarNQ2I4D+xHpFGIEJWFRjbHZ7CSarA5fEQS/egnSm/xyIr6IjA?=
 =?us-ascii?Q?7+PyNGXJi7xARhJM72Uhy7D0oJ7qhHo7/G9yD4l9M9WO5htLrgnl+UOOG8bZ?=
 =?us-ascii?Q?lafmG5Rk/HJkJlV0egX7DSYbvfpI9yPv/HjPvCTBxJubZzvosL7If8/iMbRn?=
 =?us-ascii?Q?kutZZrnXclEPW0qhjoLxXYf1TBVZ9EoIH40EVHAw8n6nZG71x1o7+2iUQBVp?=
 =?us-ascii?Q?Y/QIOIhrtxIlwPNEn6fEBrDnhgajHS8WaIhWQ1SAb6rknTlcw0H68VKigblB?=
 =?us-ascii?Q?+uoG4KBPFQhcP5JYy1C2Ouyk8qglrU5UR+gVah6AhE8r6sc8pdb7UhI93kEj?=
 =?us-ascii?Q?hK3xUuvKZ3RwOxAPUAT3B1SDskp/V7kOQVnOT6mdqW0BZrCLr8YTpDrlL8Ve?=
 =?us-ascii?Q?odiTMd3itl/cQk2gLL08qnJu5hWPgSDPTkkj435PCXWXK/bvuRyJh6WcTMd6?=
 =?us-ascii?Q?Ir0LEFWvL9OGZQo70k/sR++KRyPXTf0tfqN7kBEMlq5DrE1Vs50yWGYEsOda?=
 =?us-ascii?Q?KhgsdcJCPGbUXnMVGJ2rQiGg+Yj6OqDVHIYxiEvMY+W3ZsH4Kp8i4tUXLNTE?=
 =?us-ascii?Q?CAKUwVVlPe2L4j+dQB44agAOe72c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RRbCvfz6kDHTTfnk+HFqQb6ih5ia08nwMZFvyj1K00pnsEdDDcbUc+soKTTC?=
 =?us-ascii?Q?NERs8Epy/walx1+qdQGXvl38drE5Bv4NlCUPokB0Ka0olWuU8Z061IQXr3va?=
 =?us-ascii?Q?yNQWbL0yXEV/UoO6ethKo8NSKXUAacaZWh9DV7U6pGHNIVlwsJ9Qpzz0dKCr?=
 =?us-ascii?Q?kI6yM+fJ6E3xDz0AaLEJoTXc51ib3P6qt74OrnZ+GcgbvHKEfCaUl11CZ5km?=
 =?us-ascii?Q?Gz4ufB+Aq7QFpFFIqtu3wnTJuCaXAk6mRL7yUvp3RRENLQcKOi/8MZr5rPcz?=
 =?us-ascii?Q?anYYME08QA7b7BA+gYpahYA8Wh6AmX6Hz0NCbN+0qYcbSdApPNKD8s7ePHj1?=
 =?us-ascii?Q?0K5Qm+pBq2HC+yNGOrab4bDU3D/R8b+dAZp3qw5V+kxSa30F7E+9dhqyPo7p?=
 =?us-ascii?Q?uka+oCKemO62MYpvQhwmFXsEHhPCCEATIAOWs0sqBrG8O1X3cDLpRnq1sEeD?=
 =?us-ascii?Q?5PyBzQj7ALiG7krO4/OXAErpBD5JBBMkuZndKxFZ4pna38chg3B/C19huKLJ?=
 =?us-ascii?Q?20VpFBBMNZ0CJvAPZXwozQCN2Hl5eobyz85xalWgxkjce1W7VeN062xRVYB4?=
 =?us-ascii?Q?rtbzyuiepcljx//obh8Rt2qJJ8nSbj5tqfibX51sAZUX114gWpCTZfviaBWz?=
 =?us-ascii?Q?2tAvJ0cr7MAkhUongA3YVgiUC+bUhXqqiWNl7pR6vozhcIffEJ/GQfQhINMq?=
 =?us-ascii?Q?bG6OBrCJjOorJRqTG8+tAXKZAt1PmJKiFKU4e4yo9BxnyIx2LlALHv2RKVmV?=
 =?us-ascii?Q?jcDRujImIAWKmZMpcyRPOIk+fYISrXaqYjbMnsTTiKVz+KwSs7GbMnYGeIHm?=
 =?us-ascii?Q?KVJcvUSDcuUhRp94LD3IHtrpuUoW3oGD1FRaSyYy2LwUrwbpvaMgVsHmyolY?=
 =?us-ascii?Q?qydX0tbh8l5kVGtmQl3sqk5j8gBlKNIYwddxRslEHbgGoXC36+GFum6nMp0z?=
 =?us-ascii?Q?tKWME5TBtwe1sf+v6vwvhAstZLXnvpzAIgddEmiaVQitDrtET2nyeEesOfB4?=
 =?us-ascii?Q?9QwgrLpKpgHCNUzUSssL+AsO1AsOjF6hKDxXRmqh7UPxaAA7lSPQ23s2ohA3?=
 =?us-ascii?Q?PJxkdskCSV92qPTNhUudcsYy/h5DN9TdAUTg5BtKzuF8ErTVy5sXe2lqEkxq?=
 =?us-ascii?Q?ZEuK4wZadRdU2swGw4iRkbBxd3ZHdTXAdYE72BaTd32Yjw4YLG5d8brBYYEl?=
 =?us-ascii?Q?eLrDnNvfhAbDUbrcmpil/bOXwQRFYoSxHSMToO8s9upqwyk3kH7fItnhBaCs?=
 =?us-ascii?Q?CkUy1Ndh8JW1cZnglkMADTb2p7C2WRJNJ4ECHfawBceFiPFqXIL0yG6aNLk9?=
 =?us-ascii?Q?Ibpipmc7bu46TuKTOFM+FRthnOFwNKc+nlUlMrzQHYUcNJ4xVBQ2wLk5dV3w?=
 =?us-ascii?Q?fXNMpwAGHoV1hHM8MXwQ5yjdbSk22BRelKRLEe4F7/U9RKG7YYPt7ZexlQWy?=
 =?us-ascii?Q?h09mhd1D5fkCJ4nlGy10wJTGsWDYNGxZJ1Kt465Dc3kXa8Ar4kTtUAgfXths?=
 =?us-ascii?Q?OqwixUtcNYS9UOd3awDyKbwFHr9Nghu4ufTjgzftmxseT4Nzyap56MW6AHaQ?=
 =?us-ascii?Q?hQJZ7xT5fXtUEwXamoM3gC/3ysMOF+EXTqrn8yRxGembapIeleSDcw5VFG10?=
 =?us-ascii?Q?Oegjl4ccq3z2ZJ5/+HpKUWV4muU27fUZKXwakA2yzYuyQ0sTCEfDK1SZqMpp?=
 =?us-ascii?Q?3JuLng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZWjPNX1lD6rMpKrQ0aXwmLk9kEEhiyXIAKetFZADi+helWJhZ9x+0KJJo/aZXipa2SH7QVoIA3uQOPAOxj/gCRybVg+6rTqvg2KKSNmkSUfIUugP0EDvQoOOkZxmalgXmna9briI2AJBA5YidsYVW/GnxnMmZxC15ymHeIAj3wAX+5axa31OQld8IN2AqZLOkOwmyxJiCbRHO4WMiNMJTvowUzfnUHFwOcONFlhs2g3EiYoTn4BkoPzY7ZSUXamyemQHpi6wTmSJCodPFprlWfWTWEkYBHbVxwgXxxZZLi7r0+kL+JwEMAbvxcKvznYO62lC8eSUgNoax86V69ZwoWbqNbEBK1glJQXY4fVuZvozF4kfIlrdVudcYiqJudQ/2O+Yd9gJZdEHZGVX0PTUrhqutZKGnb7mA7MOXNVV456rd27URBT1yZTldpswdJ0fmONHv+whM0H005WA/mRgJtdSjGB70lrq12uyP/rmEx9RlUaVw8uqubMzO+7F/IKHI3GnFe1GarK62uQp8f/TBwOF+CfhroJnjTjgNf1vhI7b9dDVB+FJ5L5ejGjbONIzIxK0weOZAD5z+053b1obabpNjiKyTEkpw3mRwrB0tZc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3118b383-3207-4ab4-f6bb-08dd1f98ae3a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:57.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJ/iEVeJfqhkfkskJJgEo+QzrU4z/FmbF9nFrpQe7wQJZutrBriTrCJhHCi7bT7vxPuebJj6ZOJaMC3T2liKUL8BWy2c+YJElMVLGkRA1Fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: znJggbcBKefxqSPvX4qGuQtvJMXJHnWQ
X-Proofpoint-ORIG-GUID: znJggbcBKefxqSPvX4qGuQtvJMXJHnWQ

From: "Darrick J. Wong" <djwong@kernel.org>

commit a24cae8fc1f13f6f6929351309f248fd2e9351ce upstream.

If growfsrt is run on a filesystem that doesn't have a rt volume, it's
possible to change the rt extent size.  If the root directory was
previously set up with an inherited extent size hint and rtinherit, it's
possible that the hint is no longer a multiple of the rt extent size.
Although the verifiers don't complain about this, xfs_repair will, so if
we detect this situation, log the root directory to clean it up.  This
is still racy, but it's better than nothing.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9268961d887c..ad828fbd5ce4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -915,6 +915,39 @@ xfs_alloc_rsum_cache(
 		xfs_warn(mp, "could not allocate realtime summary cache");
 }
 
+/*
+ * If we changed the rt extent size (meaning there was no rt volume previously)
+ * and the root directory had EXTSZINHERIT and RTINHERIT set, it's possible
+ * that the extent size hint on the root directory is no longer congruent with
+ * the new rt extent size.  Log the rootdir inode to fix this.
+ */
+static int
+xfs_growfs_rt_fixup_extsize(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*ip = mp->m_rootip;
+	struct xfs_trans	*tp;
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	if (!(ip->i_diflags & XFS_DIFLAG_RTINHERIT) ||
+	    !(ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT))
+		goto out_iolock;
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange, 0, 0, false,
+			&tp);
+	if (error)
+		goto out_iolock;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+out_iolock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+}
+
 /*
  * Visible (exported) functions.
  */
@@ -944,6 +977,7 @@ xfs_growfs_rt(
 	xfs_sb_t	*sbp;		/* old superblock */
 	xfs_fsblock_t	sumbno;		/* summary block number */
 	uint8_t		*rsum_cache;	/* old summary cache */
+	xfs_agblock_t	old_rextsize = mp->m_sb.sb_rextsize;
 
 	sbp = &mp->m_sb;
 
@@ -1177,6 +1211,12 @@ xfs_growfs_rt(
 	if (error)
 		goto out_free;
 
+	if (old_rextsize != in->extsize) {
+		error = xfs_growfs_rt_fixup_extsize(mp);
+		if (error)
+			goto out_free;
+	}
+
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
 
-- 
2.39.3

