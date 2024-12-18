Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EBF70831
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488076; cv=fail; b=R8BBdOrPgP4/NJ+fqaudumKfkFBajzFVN4JmSh/ss6wtNXlGaltiH+13cvKHFuifBOXNjNJGXg/hqewYoQRrzeWNvtbOjuujfTGm3MCxXoHh6++OViR/HKeTpMnTX9oPuPNqyZ5FdFtMWide5UK3rKNZtNV900rL8gUi9L/kCyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488076; c=relaxed/simple;
	bh=f5lO/gzx5ahHU+v2tKcHSad2Ini8q+MpqAZnzL+0o0Q=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YXxvORMxaNtlnEYdjpTq+EzU8wCJLdGlsJYumoC7yjRId/hCpLabtBX7mgYxERfTVjaJ0FkwW2pu7l1rVF0JqhIdajARSoOs4v92uHjYTgyu7aHn9278NEGsAaOGUBQfuJSKrL+yRsuvXYZ5IX+4FoKiECMbu3EltWoKfGU9ZtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bCUxKr3X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ltwkVxYh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bCUxKr3X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ltwkVxYh"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2Bpww029194
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9LzWIJD6xO5Rd8t3hneBUiLT7lKdVcuJ5gsQawa9XYM=; b=
	bCUxKr3X0LmFOLi0YhU0/qatL0dvfTEB/vBLeh3OsUUBNk+scTUry4HqXOfUoa0r
	sdUAJSnYwaMLRSJwt6T/ChYqgzWknMFt8dNotYXhpUIPOOi1O1koz+1F2ZJBHMoE
	r/f63pEd2RPbm02mCOSJggePYOnn9fvflVIHFJ0XJAvKtuktVHSsb2VfXUn4aIEf
	rl/9HgEH0mlRG03l4LhOFl19qsZFos3maurUNljd9CqQin7tifTto/VmIROYFFAS
	MCoa5w/wJOjTXe3OyvjzKm+nMCtFVS3gj4eSO3UyxadlOGYjg6SQoBpC9+RofS+J
	gW3JAUwtZR/ydHgqxJhkiw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t2fgc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI0ZIA6035493
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f97yf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gJXo/BtsgClE1xjrHJomvHQRDRA4mSHoaE2K2I18wkZLN9Q3stzI+WCJMnE4GOFD1nAG5SUdGjKuDGXf9R/noF8fPsk4r9KaSHw8vqTdyS3eKxU2X2KEF6/OmZGJ1jaqetWzRTGy8aFyEFLHATb8zZJm0/OJ7RhyUXafSRFmVQWQHy4pPMNKXSKOPhqVML2Zc5XoCFWjSwFP7kvWzgjKf7HgLR/lBKIeF7HO39SHOhSr8NuEDrNCX15ymQTcJq2bGll5Aq62lbQ1AspbIdyYjBg1nwnscSE3lsgSfdN9/iypCq5MsEuQBhKfShqEK4Ma6d33FTt45RBedHjwJ8tOZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LzWIJD6xO5Rd8t3hneBUiLT7lKdVcuJ5gsQawa9XYM=;
 b=MpNrDFbggk29sr/a3uq9Ocxu9/WT8BEjVw0/B0h5Z93I6ULEoCXx02/zCLLM1b/8zPmEj1/PXJ0FCiLr7x6vQwJtBWV0jpbrg1mMBGqS6j6Fg9cPQ4ywAqD4Po2W5KpZ5JA9rkO24J+uFWcO+wHMzQLWZmQl3wLqrBwwgmD+5P3wlttFTIDYscf2AH/USYZiEatSmvTD7+qHTzcNi7lM35b8NKS+tU1pEdom4bnPNw5DxyQxF6ljJ2+CR+HCyZ+Y1EaNEZkC1Y9MsZs00sPBlUBcfBDJrvHxf+HQQltN53dVK4MW1x9/Z7sRzYJS+HgqJOymgoENSXmCuloKqbjaUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LzWIJD6xO5Rd8t3hneBUiLT7lKdVcuJ5gsQawa9XYM=;
 b=ltwkVxYhNfXf6sK3+KK0NOqchYZ8DKRhWu8ETtaDS9wCe7ddw0KezVWjsX9gwSk4+nZY3ESYh3NGlSZbGzXZa2rb/N5dh8GvNTTDpDSgx7Hj2xwq7MceSv6mTL2VYbLUuwvc2G2yHXZFAOpZtsd+r+hHeakigiD+35y5m+kEk44=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:31 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:31 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 10/18] xfs: fix file_path handling in tracepoints
Date: Tue, 17 Dec 2024 18:14:03 -0800
Message-Id: <20241218021411.42144-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0197.namprd05.prod.outlook.com
 (2603:10b6:a03:330::22) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 84957454-449a-4881-ad95-08dd1f09b52d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2IQGXONRpEDTqMcI2JB4KNTYa5qnI227WKsqwzuBqHCUV/0KjO3nejw7+KVS?=
 =?us-ascii?Q?ohh8HM/B57h8mjvgtULxLmqFWqEm/Jn7PJBWxvDNcoqcxzFe4dgY7AhUcS+T?=
 =?us-ascii?Q?JH+Sc1QTGX48so8LahSF2RE7jsxVoDdDSkvxRIWqyis9TV5ctbTN/3RS6wkD?=
 =?us-ascii?Q?kWF6YB6pmnwcKuai1LEYX1ZLVaxUnSeKI3XYUTB5foYmLBmBUiEixbwXxlKF?=
 =?us-ascii?Q?FnDv9DuoG2xhi2AqEs5s/2oAkLU/L2y7xGS7+fw6kXqtY7Ivtn99Srly23z+?=
 =?us-ascii?Q?tB9hLDDye26om7TZrJSUuf2H8zt4/KdbqQg75Q6XoviME0LYfXLMY8GNOQ5R?=
 =?us-ascii?Q?MT0ryfUq3vkWd6h3QeEqPedgQtiGMYFV3E6k+3We+b78D8B+qITUWT2/38S4?=
 =?us-ascii?Q?W1PHeKwmzU+nSxA2XJQsuZobRuxH+V/WBysbJWcPEemM94y+SXFXaaNUH92X?=
 =?us-ascii?Q?8tRaAJ62EdfzyyxE47syo2r5bvc5UBZ+T6lsog/99iovnINeHtbp+0I/j+OA?=
 =?us-ascii?Q?sQstOGA/YX9WHC0MM7HqYeqbovo+KEEzsxMs77PiivIxm/0XSWaACvTlSKAT?=
 =?us-ascii?Q?KUArvI5FDFSD3/9J5lnV30podgYW6MR3403thbaoYePzYXOyazWaWPSVYLkv?=
 =?us-ascii?Q?z+/K+AJGBcNCXkilj/gYmMMj/+LF2Mb/MlgoD8DhZ5YWOA7TQ/idCQQA/PWz?=
 =?us-ascii?Q?/h4SC4KDrwTt+HkJ37RSqNGdO8JLvrXM2D61lTOtuR8ww8H2IuVFYYud5Mop?=
 =?us-ascii?Q?md4J5FJgbOiaPn9A/LJGNClTcstF/vNnDI9quS3EoPVgOe97QqSHYLXDY1Qj?=
 =?us-ascii?Q?gG8evsj7ej2LQh9YQALYP/6d3fSY3Tc7DMjbbtH3koYNB3s60Rym+2t6lfdR?=
 =?us-ascii?Q?/46X+bVH60SG4+MX3z1a0UO43kRzhPG1tYSVZk6l+5Y42LytZw9hPRsf5Tfx?=
 =?us-ascii?Q?XfHiwALG6PCd3KI/tY/xHWaJlUHy0N0+peXMfwVfeX7/uj1qFWv3wq/t/T7Q?=
 =?us-ascii?Q?wNxunAu0rpFjdztvVhfEEPNYF2/mseNE2xj/IURpxyBw+KY8kaaa2p6EAzfH?=
 =?us-ascii?Q?29RWLm+JUBfK8XuOUUQrhqIteMwWdGCBLowGqDG0jLQi2DjpfpvvIzuDWzgw?=
 =?us-ascii?Q?m/rlj2Rr2eBSKwfHo7vxLHGlymJDnHFytYDaW+mGhT0KohNk5CMyjiQE2qbO?=
 =?us-ascii?Q?qT6cwVuEOeOFzVHxbwTlUVk2BUPXEM7FQLsj8A91zzjpvmdL2CMOwoW1CXjz?=
 =?us-ascii?Q?SVi5jPNGPaVBD4yRKtTVYa1PWsYRTQHH6/DhOMw1SGXir6lFnSWgs8hWxBRT?=
 =?us-ascii?Q?mdCG46H/Md4hZCLsK7ORiusyAM6FaAkhihXPk1CFgxBi6QY/CHqOmbP9K7AN?=
 =?us-ascii?Q?ROVun7k0pyght+MbyUhT/gQvZMV8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XrXyBcDzJHWVSLbBxAkeV7NUFMYHGdFWEvs21rkMhO1a4YY9pSia1V2DyFic?=
 =?us-ascii?Q?k0dfIhvC6C1N8cMlWIzKU5OeeVuxY6mwfSsLk20yyLoAVZgkLGSvkPfQd/GO?=
 =?us-ascii?Q?f1eBV6SpuyOfwZqVZc44HWzmX5uIkpeLgsu715WJQ6oFpJNLuztN+XViPNR8?=
 =?us-ascii?Q?73PLZsXk4w+ghNrPJUCQ6TKfEO1bpucDfb5YqNwWTnMmClYgnHiyKXvFmhrh?=
 =?us-ascii?Q?8ViRVvDYwlpEsLJDuoPFfo2cvazZZiXVB4MQgvMUru/odnQIk4VgV9OjpBTH?=
 =?us-ascii?Q?nkQ2ulwsVArrdTqoGxQjH+MdaA0nzw9g+WeUKQuzKid7mrt5L4ukMvNWa7G/?=
 =?us-ascii?Q?+z6yb7+x80vGCHUSDM8S270r4a5oDxZso90udfqZ/0oj5sS7b2mcH1itv5gq?=
 =?us-ascii?Q?8wZ1dTbsNHoKPfLLvuWIcrYCv9rZ1/hlWQpx4kzC5kTow1mFCd1bMDwuZ8gj?=
 =?us-ascii?Q?dVyQlgKTKnZnizzPyImE73qf23LcYsjM+MS/7LkRKR8h+AH51BRa1MR30+rX?=
 =?us-ascii?Q?pBo8wxI6oeU4CFssZTlalGhEN/npnsLAzwz0rny3O/cXG0OXrs/qhzeD5oz8?=
 =?us-ascii?Q?0RqrZGpAG74eTpgizuuuA7Cm+oPLY+6wjV+I1OOetLtaI+Rv1e/wJwHPGPK5?=
 =?us-ascii?Q?1Jz0Hlu66PqJ6u+hmkAwNmSvuxvKLVzY3fzy5vbuCSbLWrgki2Ovc+s3XWMm?=
 =?us-ascii?Q?aMgWZCfMPqGS6qEIhL7tUzgaynf6uT8T7iB/P69CClxCQrJxNpqZ086O2Qi4?=
 =?us-ascii?Q?Exm/nQJiSkld3XPYwoOQFslUikteKBoqrmLnMbLnQj+ZdY6U9STmeAbiiOEu?=
 =?us-ascii?Q?Ed59gsiU4s6uCensiGVy+/h0d6FubF/vkScRBVf5/sIpSpyvuDIszNXdeKDd?=
 =?us-ascii?Q?R60xKNbHf5m9LU2eRmtVOq5taMOvZjzbpNnyAZWfB9ilA23gCf/LUWiAgSQv?=
 =?us-ascii?Q?ObIpn6PYDrsb32QgCIOtUX25vdqJmemIh2vRkdMfH6xkfkPNQ3tQreHVBYNo?=
 =?us-ascii?Q?/WrEUa4P3912N9ASPF8/+obiVNB1RDW/NCe9RxfgeoWJNcbaRBnU9MoGmBe2?=
 =?us-ascii?Q?ZTFOEO0qwcseJZw2Rvdjs8sqozncgNwozYY1GMCkeg0SHwVei++LLe27wPlB?=
 =?us-ascii?Q?m32Dk0pq9wEa+SurCZqKC4VqABDUM9oAyP8rf1SqizFdlUH5MNBQBUBxbur1?=
 =?us-ascii?Q?Oz/sIntzETY1tLhMuXTKj0Wh06OQ0Zdt8nJWkcQEsmS6++hyNRs509UV4FkX?=
 =?us-ascii?Q?qgq11H1zpVpGt8Z0fHRSU8zEW2cGHQivdB70yOxDeC0BKLckzE2Hx8LN+y5T?=
 =?us-ascii?Q?7gD7TXb7T8I+W4VvLcEcW06B8QCXY4g27sdOWDiJN6+6VkhbQLL9PqB096Nu?=
 =?us-ascii?Q?KxHR2DNRMVJk8A6VRnzHrLmPmN3nJZCM9app+lBDit0J5ahB90b8IT9MmXvL?=
 =?us-ascii?Q?Ufpgp/3MZtQ+g2M0wt+VM45G31JGgm+FOk3mSCjH6jGoM1N1k3sEiVTVV79t?=
 =?us-ascii?Q?EcDv7Uqppwwyxum68LWxVOSGdBxnD+kDvxuQXd6l1UQsTCMXhHaO5G7aPk01?=
 =?us-ascii?Q?llVUYx6/tEKI/RIAA2LC89+3oE6g1qVtRMA8gS+6XUWmY9XKNw/ZjCyeIbkH?=
 =?us-ascii?Q?d2+1RSetIDvCNP98lzwP/arRz+DZTXHL9WndAJF2L7C8rcn7jNAcu57YyXCG?=
 =?us-ascii?Q?hvldkw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zm0zO0WlZG76RACcdldG1Y7Zb+1ckB2xI9ZQ1WGkkiUjC1Y8X6jDgjGJbtaYOiN5h2fo9J2He9D9EhvRVYmExv6+35X6ZO4COCVhSQkmxwRi35XSqMN7qyEXz9ZTIwE0sGYOyaNhx7CQl8H6Fjaj49PgDrr9rN77ARWgIgDwBfTe0sAR2NNzvbvPOQQGGRekhoCrmgZHjoY8tUT7E1qLmsRMtSbmhB9BdZt3WMT6ZzL/qlvEyREIOomuKcaKvJx98ko8HX599t/fOpCw+fqnHCZBEqFxy0IaLFcZheythMPKx1dL5Dct3b+7kRGU6wyPQ2bplMwrr6I8vMUp5Bhtlpr16qiARXnW5cHcYGQDygOKiY3VRdRG3sYANZlJWiDiEzTrrEOowCXUFS7v0+TtKwTxuq+uUgKtIQm0KzgeD1CvY7JnJLJx973TvImf8KycQ9KQxHDPvLW3xdkEAsSS40ar4ITNxzEUhzzbhFtbMKSq4p4WMxm2iS98ElUzHzhTRdZRXSPkjZzrPo+ba3w6yWTXPJ5t4ohfw3Z6TFidD5LK08UifT9Psv15jx+xSN3MsMzW8dDMvVOm8DTn+SpTGS3Hli3yPv3q8yCJP8c0qxc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84957454-449a-4881-ad95-08dd1f09b52d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:31.2905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjRFXeCl7YqVJdkeHViNz1VzQhfDZC9FKgQqWVU+zhYKcC8oTBiDXbUwGxfiYpYp1r6SFlmfhv9FTYliiXJFrtjbDMQ8QQ5mGTf0XAhxMUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-ORIG-GUID: TOdMbRG1fo5GgTjDRjGtpFYHPqYyY6a0
X-Proofpoint-GUID: TOdMbRG1fo5GgTjDRjGtpFYHPqYyY6a0

From: "Darrick J. Wong" <djwong@kernel.org>

commit 19ebc8f84ea12e18dd6c8d3ecaf87bcf4666eee1 upstream.

[backport: only apply fix for 3934e8ebb7cc6]

Since file_path() takes the output buffer as one of its arguments, we
might as well have it format directly into the tracepoint's char array
instead of wasting stack space.

Fixes: 3934e8ebb7cc6 ("xfs: create a big array data structure")
Fixes: 5076a6040ca16 ("xfs: support in-memory buffer cache targets")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403290419.HPcyvqZu-lkp@intel.com/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/trace.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index df49ca2e8c23..0497a2d681e5 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -784,18 +784,16 @@ TRACE_EVENT(xfile_create,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned long, ino)
-		__array(char, pathname, 256)
+		__array(char, pathname, MAXNAMELEN)
 	),
 	TP_fast_assign(
-		char		pathname[257];
 		char		*path;
 
 		__entry->ino = file_inode(xf->file)->i_ino;
-		memset(pathname, 0, sizeof(pathname));
-		path = file_path(xf->file, pathname, sizeof(pathname) - 1);
+		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
 		if (IS_ERR(path))
-			path = "(unknown)";
-		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
+			strncpy(__entry->pathname, "(unknown)",
+					sizeof(__entry->pathname));
 	),
 	TP_printk("xfino 0x%lx path '%s'",
 		  __entry->ino,
-- 
2.39.3

