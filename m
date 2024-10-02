Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADF11D172E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890908; cv=fail; b=XAQKt6QOXaWiuQk40MhiZ8VAiHRCC1bYvVxWlaLXLU497HIEZwy7jLS8Lx/iIFsLTeROkC8uG9HMQjXGcJJZ7koI3NHnnHU8MmMTVjubl4RcSTbBDfUf9nP2xh0MTvJ8rxgbHVG5IGcezPcCOvI1IhujOhRwVdUpkM0k1Zwmdd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890908; c=relaxed/simple;
	bh=Zt3oJ/twGwGOQRVa/bsuq4wiLF2dlb18fQvxRTuynBQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EBTO3ft4+RoSuRH4O0KtdoBXvsaN7dppUe5KN2gthgPMOVyIsyeL6QCsu8W5Z1hUp/CtfNqWCGGoaZgXjHH9Mwp32AtF/E7hpWhaDqPAOda2/t1ZThk/zDBcmumni3zoG9e6O/I9gzpQVQwPmwBCVXthu/I4ByPKg6VwfXI6kmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=koUW/4pl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Dy9LkDFS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="koUW/4pl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Dy9LkDFS"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492Hfb5g030327
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=BQgt7dGNuqV73VqoKy2M+ySGGJZUx/rhgtelARpS6sk=; b=
	koUW/4plLp79r+fUg0qCfe5nCOzFian6gDm9lzz9qXjuG6xpX/thwtTxVwsb1GMt
	GtnGGcFhFYsbpzATrVz4tauV9aQumOzINA6tQbRnHALH/hKQPY6U3jiV/2F0YrH2
	/TYw0Q97BP7MZ3zY1Xu/S7QmgckLkb3yF5tcBrzC8zN/i4+R14D/hlS1pBwuwzn6
	fzAZFgXHTlxQyaQIwmST354Bxm6aMm5FtdUn53nK1tmGjZmAY/yAZ+Gbf6ZqPsNF
	WruwAtwS1r5YsZDQkWu0/cvYJlENck+vC8DMW9gaeXYnMTggD9EYoss7hmHa3BJ2
	8zGfb05qy+x9wQdU66Fj0w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8k3aebm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GiOUN039265
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:44 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x88978a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djtrlGsoruD8eGMabplxvvuu9JQHWQ2/maH9447oaWiUqX1BtmE7YMfMSMYT+IRcShv7H0xHHpvHTXMdD+CCfctC6w1sH2HtSRJyyDoiNP2oauXGIBb4yqI0rjqFG7nwRyx4c0VhLSv9gtlh0zKlvK5lb5x98LGnsTVWyVGfClIunTkvFTDy+uQKoqd8CYYbcT28aXquxbmetTM9UU241VwV7pLb5KOLPHzm0b5lr0wxuNfo4/jnFk4Bj6J3oJuKXLa6pLCYqoipXc3SdTer08W60qF+mFVxImMUHM/uEgrLajdZGsDSQCOQYsCITJpwIg7bK7gFqVq3uTwWuKdmzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQgt7dGNuqV73VqoKy2M+ySGGJZUx/rhgtelARpS6sk=;
 b=XA1jsaqTNJyu9rlCH7cfEVbby6ljRBJVQPpgegee1eB2GSE+UU53qhsF2eCwcrthSMaWx4pjTHDl7IyzeENIBKX/529YsjwUzmtkKMgtI4wbz9BMwoWRHmvbyFDKdLLgS9ofpInQ3zgXdPhlL7VWslxGA2vP4KcyjBvqujX4/xnL9FCHhmMU6FEfVX9NVblHPGOoszUIWhGpAOYSuLbslKqxknWiMDh/2wJSk25hRyGn6XMArktYAC3AOYj9I7HoMpp2IliiIXTZZuykdDbHFWcCQ5xbf7HKzJPvMUWBtphuplyhSxB7u+4YNrJXhVmlbAnyv2SNKZM9ADJ9IEtc1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQgt7dGNuqV73VqoKy2M+ySGGJZUx/rhgtelARpS6sk=;
 b=Dy9LkDFSO5J2v5Y+lkzijOzjSkkB8F7KAm4sugTASK510Mk12vX1rdQOLx22MaxbtX9vDPdkewczErYpi+szGBbayvzVkRpDPhCdnQPMRq/ccwCZbh0mKeIB0B5Fec8ChNoA2U0OUpRqhIquDiU8kXqN3W/PTk9hPZH7RPSm7K4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:41 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:41 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 16/21] xfs: allow symlinks with short remote targets
Date: Wed,  2 Oct 2024 10:41:03 -0700
Message-Id: <20241002174108.64615-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::25) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: d87975d9-a34b-453b-fba3-08dce309796f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IN8AZwB6tbxjmpq372RxhZc9hb+ES/GUQm4p8TapZx7lvOoDb2JurWqwqdi9?=
 =?us-ascii?Q?52iSUFElhRiM9v05NSyspxpAwQpgS7OZy8yIadWouQ/GI7LB8jInCwSFu9/7?=
 =?us-ascii?Q?gr3+Jr5cpxpvpL/0VIxf8N3iLhv1UpCbPmpoOYkynW5rulC/oI+H+C1hXcLP?=
 =?us-ascii?Q?VFCe72UHCMJED6huN7CC+JSZx07pdarhA43gV8lba4MzPhaGVSa2A18u0r7R?=
 =?us-ascii?Q?kqyVqnCUbryflrz2OYexxlrvEPicEzkReKx5jOtBhzPRl1QDYHUocLC4P7bO?=
 =?us-ascii?Q?CXfHnor2fZ6Q+bMdZTPP5TIsLEZj4NwILz+HXR7CqgTKx59xDQ3u3Oc/3Z0C?=
 =?us-ascii?Q?j6lfBFEbC9xuAJ+eQFYhEkZ69kIWLEs012jiwWVhL181CMwjvYzPHMvyUrtQ?=
 =?us-ascii?Q?1HBC3qiuNvJiMK1G0hOi3sHKyqvpOjFk2SOPw0n+f7JDemzngwyiksOzY5Bn?=
 =?us-ascii?Q?qfNz7TCrJsKw12iWqjbyd9MfVNspNrHUFlZmz6GI1Xev9Y45uqCNQKMCBQvZ?=
 =?us-ascii?Q?cenyq6V7BiLwQ2ovKT2kAFcA3AXOKDBnF+8NRpHzqWxaJWRSvGl0eRDVNZgv?=
 =?us-ascii?Q?d/QpwNrwUWfvI8aaWdz04/9S2fu+RqjteZZO/iqWhDSAVGjQarDKlGBg9l03?=
 =?us-ascii?Q?/Vqf8L2UgzisW8z6TklP7yZ6qsBfOQyP906dXNuSSOoh+uixdmMoSSgLdhbB?=
 =?us-ascii?Q?GUcVIdX9kvN/lthqnTjDDUK9Qz57nhdmSKJlACuY5qHNdN6TOrnZtR6t3H31?=
 =?us-ascii?Q?Q1PzDuX0Ko5I7/tM24BUnsy+B30KLNe/RicltjkZJfTSUdYhWmO+r/Y54GaY?=
 =?us-ascii?Q?Seb0QzAbMFZv4vaq9voPhKn2ZDF4MAEpehkFN87D8khBRSnSZtYDywAwVuWG?=
 =?us-ascii?Q?S9cyy09YaG3NJpeLjVMxoQ3uKGOj73Pby3ymsUpmM3fl7DncaXldUN8yxkVk?=
 =?us-ascii?Q?ExD+qzJcz0FtKDRabs/HPZQ99VDxuWdLR2Hs3MpYZaRO9nFHulInJiws7pfr?=
 =?us-ascii?Q?H/tV1GpJTHdLD+5eCmelohnpRD4LbKY32iMWBVWVL2hAxL2/sRx7MZTkUf6P?=
 =?us-ascii?Q?WWLp2ANH0mEfgFtgPIilChT8mphVfy7e/XhlDsv7NCd6VGSDXRTIxeGWozjO?=
 =?us-ascii?Q?Xp7MmWpCMWnB7Saik136eB4kV7pnuAYBF/Hk9BG9U3nS5Esdc/tLlXhkluXS?=
 =?us-ascii?Q?OLVy9PdkO1OJZl/n63RliWXJlxPJ+ibBvzxhJhWkjxPuRXBc0i50c5O3SGkA?=
 =?us-ascii?Q?Wz9FDFS+TMztsIrB4q6+ZW//ZDPAQs+WzKy4V9h+Yg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cOFkZWzLQUqSs0do43i07TIwnPq0o+ozmUgRppJQup9b3whwAro/kIaqEw6P?=
 =?us-ascii?Q?F7yj2ig46HDFMiMn7p3dochmr7DMFqkzg32f3Y0HXGqEvZvDoP4yw7uQliS/?=
 =?us-ascii?Q?iiMV1ET1saGD10OQ24cYq6fEywB/CSXrSUw5JdqXsDIGMNeifBHxM6zxQEEW?=
 =?us-ascii?Q?+pcEEGVvthxdQ3Ifzz5VoBv5IJM6d4KLHBO4MREy8X9iIK6fuad6fYPKgO2f?=
 =?us-ascii?Q?UkOJVJDqc/y8l7ZX3Xh6WTE9PegaOxuUSgIyKUYuD327MsEjLWUBmNwxYG6G?=
 =?us-ascii?Q?sUmSbAiTnoq4c2D+0YcEeFLpbf3HOmqky1t9lEcVfMztrsMee2fIUOZmQLBg?=
 =?us-ascii?Q?jijw9QGWr5Jnnnr+uKQLzqOwWBnLKl6EIP/+2RfjsEhOKBW2qmnO1nd0U8e3?=
 =?us-ascii?Q?xImAsgGWGGcSJ7Uwk9fm3Lr89/w2yW6jnYT4vwDKOh/3DP5L74rxj5Iycenm?=
 =?us-ascii?Q?AjcO3m485BuUNouFMVypO0dbfKLJOodDtev1Q85WRq3YGZTBfBFcJdcZoyAg?=
 =?us-ascii?Q?x0QTluZWhjRF7s00Wi4taCVqhqqvZdgkijgNSqoUMPATZbZS9sQo96OgweJT?=
 =?us-ascii?Q?Qfj6S6xj9H5Vqi57UlaysHu80VqsNYWQ3YmJypQYpexnsDxHadX28iWQn8Sr?=
 =?us-ascii?Q?xxa3xD+YvTm6AtthjXgaFxSZRijRjHLXEHdB2v2j1e/fE3UpJxxzSkB/2dCl?=
 =?us-ascii?Q?pgArLPJDXWRtQNQEKthmPnY2RufdVfEjhi+2EaELJPYeLZui+KNsmOGvMUn0?=
 =?us-ascii?Q?UddqOy/7pCvE12Mw5Nw1yldqsD/MxZ0uGViR2/Vzob1Cnl+xfzhhNNd0UyQX?=
 =?us-ascii?Q?NrLOD/3EgCvTZ7WTr+uRMwlHYrLVSOYKhh2dB/qJUzOaQo8aK05nmqaggfiX?=
 =?us-ascii?Q?cEBEYpnEsTdCxD0i+1CmMylZFkVOrL9Y201UR06x734HWQtOBc+oyVELwTkT?=
 =?us-ascii?Q?LGyHE/V90t8ZKQkCU6bUyyoMQwgtIYcoVqaKtwOUo2vilc+rSzWlqMenISuv?=
 =?us-ascii?Q?onIV1nNCNTYPLeNhxJgsEKwO5wRfIPdn5mWVSrMRSbhU/4w1dm7+DjUSn+ym?=
 =?us-ascii?Q?lv2tS05orXbgtSRkHip0F9y0HNPNT+Ka7DFe1uYntHHeVIBzJhQVFcqo5QyR?=
 =?us-ascii?Q?1ryLuPt3Wy7gA0d2qwobACwpF8p+4PjxE9okE7iyOA9Qh141OGmlqkpA8+hc?=
 =?us-ascii?Q?bclkJKSdTj007meECOvaUP98/jmOMaOMH5Dl4gbm9LsYcMU8njAqq3nG9geh?=
 =?us-ascii?Q?u7onIDbOGVMJ1sChJS3E5g9pCIrObv5dwMUH345jQMxw886fDzM6bMYezk2S?=
 =?us-ascii?Q?v/0w5OUkOecAKjPAKoYbQbN+aPmFnpHNMuV0bVd3Msl8+KqhH8Rf4aryvpsy?=
 =?us-ascii?Q?CAlrGzTqHVSmnwuEJVLlhVg/Yr6Hfj30u9q14cnFmDeRxv9fBM2aE8c1Jcqr?=
 =?us-ascii?Q?nG7MK97spW09dXMy8NdIijPtkJVePIpxX3PbFmbGoLMhaI8oBiscqk8xfqbK?=
 =?us-ascii?Q?U2p1xjm9zcuJLnANDTJXUMcYhSuc8s4mXko9CPJXx9IikWEXqwy+iA0a+J6o?=
 =?us-ascii?Q?ECZ0jaeec60akC/OJLG4L8C2B6lNna+bVLDyJphokOIMOfzYgn4KRVTP5g/4?=
 =?us-ascii?Q?dp7oK7SuCRZOgVLDV/PVFBj+eUgO/UaIJADhCUKyn2RtErZnqtqRtkCXePfm?=
 =?us-ascii?Q?tks+2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rhse3Si05Vxh2HNQMyELgUeyBJM9GDT20XaPEL7drUNBt869V/zPBMJJNvSElND/1v9i+qKMHfbEp27qo0FeJZp5Qtsoe25k/nga5jpg6jEHMe0+/awD1ePi03JtxNeJbNbCZz6gWp4yp65OekRD8oRDI2q25ae/UKmIdkUTrm6fC6OWcKuqs8RlY29EHwOpgeNifrjpJYlJKrgzZSsyDC9IQlIjsUbHgtYq/knoLjjDNVRgIvz/Zxc6iyNIIMMbl8/QFqkkr3/VRqGhI8MQWvT4h5RdRoUYKvkBLMTmaXbjYZAv8BR932DPg92Oi/KKdttF0kIBSytXMzCNcUFZsY857OXMMjBoNHZTbT8zvTsYbRgOUWxw/tdgnvj+2OmeICL590HfUdwc8XhMY2xnwNdpNikkagGNfZPSAJrIdxqGAFCEmrp3FyeWSFHRh9ubyStk2HDH1ExD8fwXX+w0U32W4tj65KIAhSt/EqY7QJOa3xiU397ifYy2t2Lp5fG7cAT+VgrFSNEKxVTfR+aOP3+AIV+1nyzX7hqoM5MNnZTonvJqyjvgKBqJSxPBESeKgTsx/uYTB/XTZjip86cPnQ9hIiMT0FneIyyfwRccbQI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87975d9-a34b-453b-fba3-08dce309796f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:41.2679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TgCjTlndTLxLdul5Z2KqQQnQQrYWEOPCzMOk6AWokUV5s8loEIUQh8KpogzX/Q5Vhj0g1X3ulvi1wPDudM4KKOaRQG4+WbVP/nYMXyY0VR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_18,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: aSChuWXs2PRWVRxUe0h1JMD6KrOR3zIp
X-Proofpoint-ORIG-GUID: aSChuWXs2PRWVRxUe0h1JMD6KrOR3zIp

From: "Darrick J. Wong" <djwong@kernel.org>

commit 38de567906d95c397d87f292b892686b7ec6fbc3 upstream.

An internal user complained about log recovery failing on a symlink
("Bad dinode after recovery") with the following (excerpted) format:

core.magic = 0x494e
core.mode = 0120777
core.version = 3
core.format = 2 (extents)
core.nlinkv2 = 1
core.nextents = 1
core.size = 297
core.nblocks = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
u3.bmx[0] = [startoff,startblock,blockcount,extentflag]
0:[0,12,1,0]

This is a symbolic link with a 297-byte target stored in a disk block,
which is to say this is a symlink with a remote target.  The forkoff is
0, which is to say that there's 512 - 176 == 336 bytes in the inode core
to store the data fork.

Eventually, testing of generic/388 failed with the same inode corruption
message during inode recovery.  In writing a debugging patch to call
xfs_dinode_verify on dirty inode log items when we're committing
transactions, I observed that xfs/298 can reproduce the problem quite
quickly.

xfs/298 creates a symbolic link, adds some extended attributes, then
deletes them all.  The test failure occurs when the final removexattr
also deletes the attr fork because that does not convert the remote
symlink back into a shortform symlink.  That is how we trip this test.
The only reason why xfs/298 only triggers with the debug patch added is
that it deletes the symlink, so the final iflush shows the inode as
free.

I wrote a quick fstest to emulate the behavior of xfs/298, except that
it leaves the symlinks on the filesystem after inducing the "corrupt"
state.  Kernels going back at least as far as 4.18 have written out
symlink inodes in this manner and prior to 1eb70f54c445f they did not
object to reading them back in.

Because we've been writing out inodes this way for quite some time, the
only way to fix this is to relax the check for symbolic links.
Directories don't have this problem because di_size is bumped to
blocksize during the sf->data conversion.

Fixes: 1eb70f54c445f ("xfs: validate inode fork size against fork format")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0f970a0b3382..51fdd29c4ddc 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -366,17 +366,37 @@ xfs_dinode_verify_fork(
 	/*
 	 * For fork types that can contain local data, check that the fork
 	 * format matches the size of local data contained within the fork.
-	 *
-	 * For all types, check that when the size says the should be in extent
-	 * or btree format, the inode isn't claiming it is in local format.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
-		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+		/*
+		 * A directory small enough to fit in the inode must be stored
+		 * in local format.  The directory sf <-> extents conversion
+		 * code updates the directory size accordingly.
+		 */
+		if (S_ISDIR(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
+		/*
+		 * A symlink with a target small enough to fit in the inode can
+		 * be stored in extents format if xattrs were added (thus
+		 * converting the data fork from shortform to remote format)
+		 * and then removed.
+		 */
+		if (S_ISLNK(mode)) {
 			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_EXTENTS &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
 
+		/*
+		 * For all types, check that when the size says the fork should
+		 * be in extent or btree format, the inode isn't claiming to be
+		 * in local format.
+		 */
 		if (be64_to_cpu(dip->di_size) > fork_size &&
 		    fork_format == XFS_DINODE_FMT_LOCAL)
 			return __this_address;
-- 
2.39.3

