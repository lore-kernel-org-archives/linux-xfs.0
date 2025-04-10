Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56041C8609;
	Thu, 10 Apr 2025 04:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744259006; cv=fail; b=BFb0zteGheCgh8S7yDv1y2Vji3OhrbMRit5EVvG3AEjyFmxMS++QO+aY4EZxwGDYGXjnFBG82oX1T0sy/BogQ2WkfACoMGbvujHckXf6pdlM/7yhBYcKQmZu6tMYYPBdN0K1tvGKWHtAhxEmPY1CNpK+G8BPXr5o1btGN0oFDJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744259006; c=relaxed/simple;
	bh=SwWBWDR41m2nOaA/lepFcb2JK1Ga8SBpmlm4mhqu+Wc=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=b7iG1g8Tr2TzUzgY4BixMpi/TY7sVN7YJjjz3MSo9MYlssKkJM15egTSpZv1a/fFj/rczYGUzJcySWmRkGnWlfZbIUf0YJO3dtbWaA9nSvZKfQvJAoQxix8lkc4uhrxiJAmm6IBUTP2Q6CAAK0D9ltvpJRwOeV/UD9lMIGBqGCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jVfauoQx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=azozjDCD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jVfauoQx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="azozjDCD"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53A3q00O025562;
	Thu, 10 Apr 2025 04:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=9KSGbimuuSns83Jd
	XSmCWU1oiQnrnri8iqbPx+Bb1UE=; b=jVfauoQxyCHQMLn/0CEMJi8bPHohMCiE
	7k4mlgmidkc3YsNUOWYEknso5yDfCEjB1Muk9gi4srGJqhOfPfvahkTJEGB9mDKM
	PGkhaPetze+fE8IZubEM1qep9FGUHItWuwxjfbjAyzw1rW+oCcVPe3iViP4fTtDc
	ny1cuRrQjHTpt0d5R6ZZ0iT/FbIEEGWBFsfu28g4nWNlqkp01NSbI4OeDpfCaoVO
	yhsgp23m90eDE3wH33HxVRUA5xizKwYYq/F1YNDoYgvVto96AJuzXhEGZxaaM2Up
	q8DBemeRWGqDxCLdQJJOrc7OcG35mipsfJ0AkN+jqxrQjyEeDI8SAg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45x6f200tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 04:23:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53A3bsJi021030;
	Thu, 10 Apr 2025 04:23:22 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazlp17012037.outbound.protection.outlook.com [40.93.1.37])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyj142k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 04:23:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FpkZGQ2DJFMrcY4VjflamrB5LlCd5AAhBZdjwduxIIFrDT+npHCBRYkx0WwY80dneguPMP/LPYKJc/a/1JIN+Av2bPoRzVDbhl1ujdmruIFOyAqKJHHaymUqZzCBonw6wpa1vKTJbBH5DnvtoqsjIi1FeuQ2reNcmWXJH9WF0aJtri7udpfWkuhJowPI96btD2M1gIUUWzL5Tq3vI8OZt0iC3g3V9VWdFu4L0pVAjNNEf06NKnrg1VEhXmmkKkpbrHE7KYw4lay4vGGCbuzG/EAcKeh1dz5zgNFrOM2rbf1nAOSJbxaA/869sajN+l3tctmlvY1yq6mocyVkzKUpIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9KSGbimuuSns83JdXSmCWU1oiQnrnri8iqbPx+Bb1UE=;
 b=rByXLHPrQMpF9y2YtEGOGA1lWh4s9c4/owpCJUSnNLAr8bLgC7wt7gr69b1Z4PsmwKC2GR6ZN+8iaGUI6VS4ghtmeP8hGcjQCEP4B8ts2lacdizGjdQxgG9TnBVKxnAZUJ81pHMplZ0VdEUcq7BXNGkbqffZVN5EVzFE/MxmgqForqeNIgPF1LHcqWGe89odTVz/ZIWlflHcrhD0MwOCUHeU2aeqVoeyjetnJGF4JeYBDVpju1kOaW7n3s6FJ6zLE35fNSXBwQonLLbuCnVx7fICSwV5r663yFlQhkpxKWd3QD/XFQBg2OubIiIzHp/qtxpNwU3EG52d1yaXLbzH/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KSGbimuuSns83JdXSmCWU1oiQnrnri8iqbPx+Bb1UE=;
 b=azozjDCDijstBYFc8eui2pweqX3HONRHpq00uYFJPa9TGX+BmDvPn1PHZxHNoag5lqSNY+K/nqdrtjKIj/ydldO6iiUzTjZPXAYH8LjbRWCfg4ear0XxT1MwtTgj1wY2Mlv7zo+/EDe0gr9K/Un9QE8o4j7KF2IVhuvkzkaiJL4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB8104.namprd10.prod.outlook.com (2603:10b6:8:1f4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Thu, 10 Apr
 2025 04:23:19 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8632.021; Thu, 10 Apr 2025
 04:23:19 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v5] generic: add a test for atomic writes
Date: Wed,  9 Apr 2025 21:23:17 -0700
Message-Id: <20250410042317.82487-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB8104:EE_
X-MS-Office365-Filtering-Correlation-Id: fc181e68-5814-421d-460f-08dd77e76c25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|10070799003|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?weN5bPYI+rnOkR1ctjOatOIJAHyQPta4kTtLaBjDm9JygEWAXvok6SpPDb8M?=
 =?us-ascii?Q?1B6YSQtkfxRFHnooio64wmiGgfJzWDma3BIvB17rxtnNxrvEhdTJiBa1oGZL?=
 =?us-ascii?Q?z9OcfBK16s1T3U53gDVYsJCmL6FotTimvrco8xnemLgmJ88PUeUWPxtLmwBh?=
 =?us-ascii?Q?CQTUzhuq8y/C0e2maM21TN+ZKu6hLxnxuqaeyiXKw4FjrLcY0TtYVy5nbPwx?=
 =?us-ascii?Q?PXYQE9WXg8N8N4ErhzbApRzA0NduF0WZolG8NNxGPAx1l1Hwh2bXgGj95zzH?=
 =?us-ascii?Q?+FlDTGY0Zok6MC33QSbKSzd/C7Etul8RMtE/kpGYo+bfjt5k+XBZhBCf0c22?=
 =?us-ascii?Q?krMM84WaobMdW5UcRK6KuGcKEuCW2g5APOGbGXAzou/Rst+yIroQKIqK4iOS?=
 =?us-ascii?Q?SAXQjQlN98fax5Oj3fX8741htqBX4Y24EWRiQQA2Csp6ZBT52OedDdv5zHtF?=
 =?us-ascii?Q?DFVn9+sPf7pc7HDVRTkI2B0K/fGZ+oiVjM3atR55zhxLfJMzpXuY99DTYJ8D?=
 =?us-ascii?Q?7VzXvvChhcoYY2xZCpdebFKhvGAwOcv9mliuHxAJime28ngQ/KB7iVv8kRLp?=
 =?us-ascii?Q?77LrcdG3xmck7IXwLI2/nkSFZQdXFhLsmdmWFJkKTJ/QeKr5tmYZJZxIyqVY?=
 =?us-ascii?Q?r3fP4hIROaqabQs1tou6v2ysgDSMyTlB6H7PkGPiXm3vX63NGRXE4/wjiZBO?=
 =?us-ascii?Q?KBcPPl/FuFyTYEnNcweidbnG7sceZq3O6xBi1b6FSTdXx+5xSGGp3LW/buqe?=
 =?us-ascii?Q?+x0zx4JkshoGuQfy2BBOs0HxCeCr3aAW7zFSqzwtJyT7X68q38w/97RHsC3k?=
 =?us-ascii?Q?yCUgbVL5p13VNxZEs7IkkpGVUcHlV7P7VJFqa6+dmv/hbSB4Aph4n0wYMdiw?=
 =?us-ascii?Q?71QQwSeitdne5dIQ9VWmCkBfx6gNr/zZ2pTOQOwuuZ2G6LDeV/sUBCaet3MV?=
 =?us-ascii?Q?8j8x364HvcQetdW9i6BG71sUAjGjqUaTmuk6DMLgHdenGcOaWpcb+Mwf54sN?=
 =?us-ascii?Q?FdCQYQ612fKTZ5sbKU2LgIbfEj8ZehRYdMbeaaL9L7vozF0ldQ30SQClVB/2?=
 =?us-ascii?Q?mtsnmMg+pdDfpuH+9GIDWM2xYavQvVDcaoKnlY0bDCl/KMe3zlVOWGCNzO7m?=
 =?us-ascii?Q?PMpBQhcFWgTJufRW3a8anJns8r97ezDJEBeQq+2Wbpqz1durvyC5dFux+/E7?=
 =?us-ascii?Q?tWO9c15IHYJls2SSc7KT+itlCI8sL3PO1scUcyj0huo1/jKkFtqlyXxVH04B?=
 =?us-ascii?Q?50WkD5MaxTeIWc1/NtBHmcyJP7fQlTIQtQr+q9azdqeGpaDpedFG4KJjNen8?=
 =?us-ascii?Q?Co0IqN9Iz6lohr3cVOj+2IQpjrp4vA0kEhnHEyOASzY26ZkBKJT0WwdnfNQp?=
 =?us-ascii?Q?RLeTf3r1aKyGe2mhdyXXs+PeYyKGAS8yZvbQW4MR2ieMC2UuhInU2KrovKXq?=
 =?us-ascii?Q?deII8IkrJis=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EIVBUGtSjiggPthFwNmeJIr3D2CZQsKoHfRCSR8UbvUPwcN0IR53r7BcjJAs?=
 =?us-ascii?Q?RNUXAWXxswNSAtCNomBf4NQCrOYKTtnvbgYiMHgw+lfGaqXuNi1dvh8k/Qad?=
 =?us-ascii?Q?NgQK7tRSAmSP5Punk9ke6Vn2XSppB1k1/yAbYJHXOinq2qzaiCL0RRj2M/MV?=
 =?us-ascii?Q?U+FYbAWOcqXIWcXdk94+vQ1OjtARX9Oiu869sWRluJYlwsZMvsOdGG1G84yd?=
 =?us-ascii?Q?abxYYp/GzZfCPZd77k/22vQMMhWzIGKVJbhAzmgKfehZ5tuBVtyl8UvrxCs3?=
 =?us-ascii?Q?0/vw0byLT+3lhic98o7Yh60SiofEjOKU2KQC/pD/V4IDAs4B3i/TeOLC+moh?=
 =?us-ascii?Q?tmQ5GW5ju5Ar+1mSz+gZMjF4qu6NnhFMftZXTYRHp2eGw91PVFQpzrqoJey8?=
 =?us-ascii?Q?5MKZS7nZukNm5LpEjXDqnOBpPXUx+WRKAdbOEDMDcsWE/kBVMtxFKxEsEtaa?=
 =?us-ascii?Q?vS2zGp/aWmLsbyhVCLGfl5x2Q8nufpdGZpMg0vjyajLhD5DxOOb/kfUSZZK+?=
 =?us-ascii?Q?EoTQPdOTICqa698IsJQv1kQIcc7pr0bpakHkpwTDQSTxrv71kvscU1tbgKH1?=
 =?us-ascii?Q?Hh3uDCP4wm3tlxmh3LdjPRXemIQn2u5wz0wcMSo4i+LU7W2bzDIm9w5O42tw?=
 =?us-ascii?Q?iirq2L4DjgZEXjdDQBStA8j+v2M4J+J+0wVqPX1H+MR7KLz66ien7O4/fy+G?=
 =?us-ascii?Q?SpkcyajaOFr5/hFLBpkI3zhIqTnVQ25FzeLOgCOkxCdJqFnwPPgXKUagkLPB?=
 =?us-ascii?Q?3CT7fDq53aoEeoRvkqgf5EujrZH1/3CvMDlQFrGcRkPWsSWETSWbbZJFFq6y?=
 =?us-ascii?Q?pi7lp5i4LrgP/4uZ3+3f9Rgae3SIO0s4iQaarjOXCSRTktJPXRjlnhJEXSQb?=
 =?us-ascii?Q?n2ajQW/yAn6McZySPo/cjW4lmIe3X7PT25ZNQiyr0S6kdGKXNg4EoxfQ00/8?=
 =?us-ascii?Q?V+Ms1nY9Gp07GMc9Pn/KlykWxAfqvIHVHYxu4q4w91RrzSXQoYNVy4aeNKAr?=
 =?us-ascii?Q?8pqQhLJPCW8lNbdJ0Zhi/VXfSUm9S4ZwrVHoYFMlpbaGqL59b3ZmT9Y7qpuQ?=
 =?us-ascii?Q?XOT/605SOzhUKCxxHSXfX+VAHCwQlv+GoleN6hS+oirINS9rQUlctSMDrCGl?=
 =?us-ascii?Q?7CM2lJUa+G6IJ/ywWpbHn/bZKJ0aAI7vYd/Jrq9zyfpofNh4aNH65KeFTEmO?=
 =?us-ascii?Q?VLpVZw1/cUa9yxyCTnd/1u7NS+pgIRHQ0mWxx7TMV4CxPu9oDADl9OKKqPql?=
 =?us-ascii?Q?S5nIqmzPwI1B7DWDvM6mXmskH8jCot6LtDoTMtAg5+UEL+8wd38MSV1JHnl7?=
 =?us-ascii?Q?phRcaQvTOljn9EEMlB8F72vQO/0cyAr5TNDgdfP3ajkBb8PG/nOCBUyPvBMr?=
 =?us-ascii?Q?hGrIA6bRicCH68h7K/UD0BBjC7eaiOU5tkblL7OxUjosm1KXTntJjFyeNRcr?=
 =?us-ascii?Q?54szHjIWYlfygN0mZygc70uMv8uGks65T7BkA5RH/59Q+0g39iVxeweYkJoL?=
 =?us-ascii?Q?JtR51Jh486vbFYwk6gy9nD5Q08SkIPCxfRr2aiznSGzdN5rQfoCfb2eVimVH?=
 =?us-ascii?Q?IonwpauwEpBNWGLQSAw6QuL6Ru5oiU90I5LnJFBcs51Lm2y1aJWCIKeT2kRP?=
 =?us-ascii?Q?Wsm8vbL70TaMOfM3mlUyIfyoYkEvv0AcYo5rgt0ik9xoOVCPHXFwiyEd0e0h?=
 =?us-ascii?Q?w3Z6NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+vCQmjmDF2kUhCvPJNt0N7blqhVigzervODF3xehjZYFafwo7Q0M90/RfBcV3WmDrAVVccniVjABaq1ruqDmJ4blkdQ+u4hx0LvIom1nBkFHwjye2V506kuP6aE95Gf6CmweGu3611FX1lqfk9MCFASIKcaY9E3o9E7X4+dKhlStxWFgrI8Gl6mi2aiwfiR7eCjBrdHH2CPr3FyHMHF0vpjaWf0dMVfzJZZTiDLrB2T4V5yFEdTNuP85sDbPenDFUs+TRT4j7T3Nv5BJTJyD/QbpbKU/nhgju3arV4iV8MtUlorhBY4g63iyVnsdszlx5ZRFq0JqB3MFfZIzLCcVyayGzWD8+5NOhJq86A/OksPkdqLTVOnWNdBKrwimbHdfgdeh6b5ZR26YMZNmadk4ycylOFuSVYS5radGGucg5YY5pRMKxG/K/8MAQ6eXXfgHyFIdCE/57AsviOiIaJ0RTfM7vK0nXU9ovDX3039mCmClFG1tr4HhNgADqYq7vepdLbL6dc/SmFAFAEji6qiLMGNSxlUgo463BdWOZqYnliCjir+0FcWMna3sKAZuvyjDw0+7Q3iZYOE1JTnetMFGseWM4ChDiL/ktXbG4JIRJrU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc181e68-5814-421d-460f-08dd77e76c25
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 04:23:19.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TaykitLrBzIrO/s9t1z9fQD+98kehBQvLH2LOu6IXi3VX2UyRH1/Y4oPBD93Md/zQjmsaF0nknupW50Q3OQnIqZCQfLSLI6ue+bvRkwsZ7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8104
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-09_06,2025-04-08_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504100031
X-Proofpoint-ORIG-GUID: UQPJXCfqPbC9kw8jYKjhSXHEqUDP-6zW
X-Proofpoint-GUID: UQPJXCfqPbC9kw8jYKjhSXHEqUDP-6zW

Add a test to validate the new atomic writes feature.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 common/rc             |  51 ++++++++++++
 tests/generic/765     | 188 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/765.out |   2 +
 3 files changed, 241 insertions(+)
 create mode 100755 tests/generic/765
 create mode 100644 tests/generic/765.out

diff --git a/common/rc b/common/rc
index 16d627e1..25e6a1f7 100644
--- a/common/rc
+++ b/common/rc
@@ -2996,6 +2996,10 @@ _require_xfs_io_command()
 			opts+=" -d"
 			pwrite_opts+="-V 1 -b 4k"
 		fi
+		if [ "$param" == "-A" ]; then
+			opts+=" -d"
+			pwrite_opts+="-D -V 1 -b 4k"
+		fi
 		testio=`$XFS_IO_PROG -f $opts -c \
 		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
 		param_checked="$pwrite_opts $param"
@@ -5443,6 +5447,53 @@ _require_scratch_btime()
 	_scratch_unmount
 }
 
+_get_atomic_write_unit_min()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_unit_min | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_unit_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_unit_max | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_segments_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_segments_max | grep -o '[0-9]\+'
+}
+
+_require_scratch_write_atomic()
+{
+	_require_scratch
+
+	export STATX_WRITE_ATOMIC=0x10000
+
+	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+
+	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
+		_notrun "write atomic not supported by this block device"
+	fi
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+
+	testfile=$SCRATCH_MNT/testfile
+	touch $testfile
+
+	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
+	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+	_scratch_unmount
+
+	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
+		_notrun "write atomic not supported by this filesystem"
+	fi
+}
+
 _require_inode_limits()
 {
 	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
diff --git a/tests/generic/765 b/tests/generic/765
new file mode 100755
index 00000000..9bab3b8a
--- /dev/null
+++ b/tests/generic/765
@@ -0,0 +1,188 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 765
+#
+# Validate atomic write support
+#
+. ./common/preamble
+_begin_fstest auto quick rw
+
+_require_scratch_write_atomic
+_require_xfs_io_command pwrite -A
+
+get_supported_bsize()
+{
+    case "$FSTYP" in
+    "xfs")
+        min_bsize=1024
+        for ((i = 65536; i >= 1024; i /= 2)); do
+            _scratch_mkfs -b size=$i >> $seqres.full || continue
+            if _try_scratch_mount >> $seqres.full 2>&1; then
+                max_bsize=$i
+                _scratch_unmount
+                break;
+            fi
+        done
+        ;;
+    "ext4")
+        min_bsize=1024
+        max_bsize=4096
+        ;;
+    *)
+        _notrun "$FSTYP does not support atomic writes"
+        ;;
+    esac
+}
+
+get_mkfs_opts()
+{
+    local bsize=$1
+
+    case "$FSTYP" in
+    "xfs")
+        mkfs_opts="-b size=$bsize"
+        ;;
+    "ext4")
+        mkfs_opts="-b $bsize"
+        ;;
+    *)
+        _notrun "$FSTYP does not support atomic writes"
+        ;;
+    esac
+}
+
+test_atomic_writes()
+{
+    local bsize=$1
+
+    get_mkfs_opts $bsize
+    _scratch_mkfs $mkfs_opts >> $seqres.full
+    _scratch_mount
+
+    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+    testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    file_min_write=$(_get_atomic_write_unit_min $testfile)
+    file_max_write=$(_get_atomic_write_unit_max $testfile)
+    file_max_segments=$(_get_atomic_write_segments_max $testfile)
+
+    # Check that atomic min/max = FS block size
+    test $file_min_write -eq $bsize || \
+        echo "atomic write min $file_min_write, should be fs block size $bsize"
+    test $file_min_write -eq $bsize || \
+        echo "atomic write max $file_max_write, should be fs block size $bsize"
+    test $file_max_segments -eq 1 || \
+        echo "atomic write max segments $file_max_segments, should be 1"
+
+    # Check that we can perform an atomic write of len = FS block size
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
+
+    # Check that we can perform an atomic single-block cow write
+    if [ "$FSTYP" == "xfs" ]; then
+        testfile_cp=$SCRATCH_MNT/testfile_copy
+        if _xfs_has_feature $SCRATCH_MNT reflink; then
+            cp --reflink $testfile $testfile_cp
+        fi
+        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
+            grep wrote | awk -F'[/ ]' '{print $2}')
+        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
+    fi
+
+    # Check that we can perform an atomic write on an unwritten block
+    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
+
+    # Check that we can perform an atomic write on a sparse hole
+    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
+
+    # Check that we can perform an atomic write on a fully mapped block
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
+
+    # Reject atomic write if len is out of bounds
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize - 1)) should fail"
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize + 1)) should fail"
+
+    # Reject atomic write when iovecs > 1
+    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write only supports iovec count of 1"
+
+    # Reject atomic write when not using direct I/O
+    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires direct I/O"
+
+    # Reject atomic write when offset % bsize != 0
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires offset to be aligned to bsize"
+
+    _scratch_unmount
+}
+
+test_atomic_write_bounds()
+{
+    local bsize=$1
+
+    get_mkfs_opts $bsize
+    _scratch_mkfs $mkfs_opts >> $seqres.full
+    _scratch_mount
+
+    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+    testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write should fail when bsize is out of bounds"
+
+    _scratch_unmount
+}
+
+sys_min_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
+sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
+
+bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+
+# Test that statx atomic values are the same as sysfs values
+if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
+    echo "bdev min write != sys min write"
+fi
+if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
+    echo "bdev max write != sys max write"
+fi
+
+get_supported_bsize
+
+# Test all supported block sizes between bdev min and max
+for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
+    if [ "$bsize" -ge "$min_bsize" ] && [ "$bsize" -le "$max_bsize" ]; then
+        test_atomic_writes $bsize
+    fi
+done;
+
+# Check that atomic write fails if bsize < bdev min or bsize > bdev max
+if [ $((bdev_min_write / 2)) -ge "$min_bsize" ]; then
+    test_atomic_write_bounds $((bdev_min_write / 2))
+fi
+if [ $((bdev_max_write * 2)) -le "$max_bsize" ]; then
+    test_atomic_write_bounds $((bdev_max_write * 2))
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/765.out b/tests/generic/765.out
new file mode 100644
index 00000000..39c254ae
--- /dev/null
+++ b/tests/generic/765.out
@@ -0,0 +1,2 @@
+QA output created by 765
+Silence is golden
-- 
2.34.1

