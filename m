Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B04C28F94E;
	Mon,  7 Jul 2025 13:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751893939; cv=fail; b=Wq1jsD6q10WQ+MKpmmlpnlAs86NcgqzV6eET+IycPefsj+UGkf1OTOKUj/TllBzxhImHBFSnWdo2FdvYd/aFCJRzfEbLL2rbgUykJONSqOSKeEShUvQD/eLG9pmuCTb6YluY5j7wVhu/ajASQmy+P6Jse8WEEkTpVF8bnNPdFf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751893939; c=relaxed/simple;
	bh=FCEN1pczawj+2x5UuZHr0Km43itOqO9sUFh9gQctssQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GH9L2uQaAde+C8sO5St44jVtr2Hy2peGtcQjwPm/IB64GLHd6pI5O9ibRprhHj5sEthlz5hKjMhgP17n3uyTpTq2cVQqBnTw/xnm3iee5Y5Qg5nJzinZW48+9oAeeQAf5jOo8wwraip4gBwuFildh2ZQG9CtNVJdqMt2uRV8kSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IynefbTQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ivwo777m; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IynefbTQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ivwo777m"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 567CpuDb007668;
	Mon, 7 Jul 2025 13:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=r+ZOCiW9J1w6DfiVUleMtEgXSchl7yhV3pwDA/QY97U=; b=
	IynefbTQLO8IO5fDwsXsAPg1i7WaDSTjKz9hE26Jxik1e4BitsqUhHuJLJcnBVww
	yZ/EdHt6MthKw6/Zk2EE5XrfIV91CB10egHcaoYdIOtYuevJUy0hZjGV93i+UvnN
	3z6cWBmEFyR44+OkdZ/TeuZj+4kpA3HMqKZMByT0mhTeJXvle616UmqNNIoudDoN
	V4lESRaxHSFCZ+ynPb4zKa/VqgdzWJn6XUHbKWpeebupGK+DYBpDV5s72GWF/BMO
	TCzh+SnED2sfSsypKL9OPxugXE8HJoG4pfcG6xVIPSc63o/CfPJvQDZeCl6rUrhT
	Vo/wxxj5+j7WDzv84zviqA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47rem4r1g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:12:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 567CUxAw027228;
	Mon, 7 Jul 2025 13:12:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg875yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:12:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKpfwop+mn32QVf1RTD+EHf5Dl6gfopvHZBPf+z6Odx4MWTNsBY7cZFS4BPHfDHsI2vany+4vd/eATqvRAAi5urcVRihNuc+ueTsMZt9KuedX1/Y2sA2EcjggOH9cDcInC2QoKn2KlV5NeA7DW/vUKWq5PnNkDIbKqculMYpPGuk3ct7lLQMZjm2Ho3ttZN+2pt37ojy6an02dF6ezlhe0ugdwPy2munzTJkNFa46ia1TSoIhYM+24GC+7mFSFwqSv9wMqEjb1wq9ue2SMd1uRYZJGUVWyLjK+4eN4EM1M5NwdkaqT2mI5YI3wtRMz8iLM1jsZ5OdHb6HahHs2JRYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+ZOCiW9J1w6DfiVUleMtEgXSchl7yhV3pwDA/QY97U=;
 b=V/EetZ2SCb9Y7pizB9CVARzu9sx53d5moyc6KKRclRkv02Kwi+efpD83t+o23Cim4GUWHf8Th5Cs2ObvlgGntq8sN8w/eMzDp10FQXt3WekyAfISE4GDuZe1byI5v8Hv++vDreabnUVhpbuyOHQkv80YAAuOzuD+zqIKcpn3ZRuNUuNs6YnUzHnD13pirPEAorFdu+mDAUiA1hZFodgzDwYzgueABgXJDjUcRg/6LOOnHre8IVnrAFJ8aWrAAcFJ5cNNKSai85iy1WKJVMY/U/gQeZF08mVPYd61e8Nt6CHvs0DO+iixijRBxrDrT1Oi/R/jwXw5ybWZoRJe2ZCV+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+ZOCiW9J1w6DfiVUleMtEgXSchl7yhV3pwDA/QY97U=;
 b=ivwo777mqK4eS5gn4Ve6Klogmi9+JOUgrlsZjwX/gfuCG1mWbvpO59f2C7WN9rLh7bAxwn8dwCEduriHjay8IvXVYoLwoRtXi2i3aOVC7BAchRUwcA1UXzNB4D+4HtNFZZlLUpK22zmimocqkTRp0vKTwa8Ag3yOxNJ/moKPLms=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 7 Jul
 2025 13:11:57 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 13:11:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 4/6] md/raid10: set chunk_sectors limit
Date: Mon,  7 Jul 2025 13:11:33 +0000
Message-ID: <20250707131135.1572830-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250707131135.1572830-1-john.g.garry@oracle.com>
References: <20250707131135.1572830-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d72f023-c0cc-4f60-7ef6-08ddbd57d9c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vPGNuIegzDwr2aslepgtHmcUU+Y06D4qnylYu0VyreAvIrjBIWzVdYIdtFSG?=
 =?us-ascii?Q?7pLrNSPINrC3d5355cSgN/VAhlGeFnFnsKJJR23LQIDR5WxZixWVE5BCqyOL?=
 =?us-ascii?Q?9e8uZc6j7tdebnpVug3nujC9gC7WY8B/PlPskQvDKDwiP/Pq0RS9YPnt9HEl?=
 =?us-ascii?Q?unZxNwmV9XOuxH71h2xKBOVgVOXDXdRoS/E8Vo9mOjOsomK2IaThwD8Ye+Jt?=
 =?us-ascii?Q?NB9fdG3WZrEHUOJmHQbvz+RFvekGgTxVxLbqT02WgmEStTJ4nfPFnELMGdfr?=
 =?us-ascii?Q?1T9R/ooAmVS3z/J148xL8dBblDA1RRSm3YSODnbhUlRyoAvXF+y13fanl7kH?=
 =?us-ascii?Q?HE+x/Pk/Bhbpn7NcYIFwlUEzFf1bwGVPgv5ejPag0ojtGmw4VOUvfOgv0xgI?=
 =?us-ascii?Q?RodbGgAJSViKZD5eA4Y4+LqLGtBl4Kst4Phhel0BttKpVxrC4RVVSv8J1TDQ?=
 =?us-ascii?Q?0VxQ4F5wvAxAMDdSiUbyuP1hp5nRvnbeid1K2mzT1rLBATZ5L7SKA1LP3DRE?=
 =?us-ascii?Q?Sdev6svLLHEhVL6XPion6FZMDTsv9SGcISj6rcRJcZXUobezPvXaIJAZUiYf?=
 =?us-ascii?Q?av4BF5NcU8SCaWfC7RyPCjKvRzqu80aVc07QYaANTQZJa/4YywLJjDb0EuTg?=
 =?us-ascii?Q?aCKoL7/Bbk192hAnO27pGlbfo8ArgSeIjC9+7b4OqyQTwjCIBeLU8zoF2Z0/?=
 =?us-ascii?Q?Enkg0vP7bSgaT57DeotzAnVxE42ha3HRO+xU+pukoEk0GMs21qI9mfOWpE56?=
 =?us-ascii?Q?F9eqhzlqBnMrdXJHYVFWwxqA6wDpj2wMmAPRsSB0ZtV6ZSTAagefbtJvajtR?=
 =?us-ascii?Q?sgDBI+5TT2wlyrehPvSWevbmy6tEB0tbvaYUjee+DfteqxR0p/Zo/F62ooeO?=
 =?us-ascii?Q?GVyZYiT6gBNVc9JTxRELZzZZUurDUyOl1T7jEVQUjtC/IU01u89FEM0ANep6?=
 =?us-ascii?Q?rsUCgWYU7C7wSO9xmqvv0rwIu5SSADq447TIYQb8n+e1tDOjPslXtvhOr2Ei?=
 =?us-ascii?Q?zoViY+YR38Ivs9D5V8uPXbtbZF9e0RrhboHmJDh65PPGu4prAlYE+hPrUxiZ?=
 =?us-ascii?Q?gyVzqBXVhT367koIcneQ5TthYaEHO6+PXzmUOBKHRcdePiIc6SgFiGx4eK/+?=
 =?us-ascii?Q?qrW69YA4xTrnFiABxT5ywfoZwZ6sIIf2ZGPvw41eJSkiNmE4DYI0jzTB+sj5?=
 =?us-ascii?Q?r5qcp0KGg8PMeQ+K1wrLQVhrpzq+kVWhIxf/n8+iHrI/D4+EFFAqKnWiEKZ6?=
 =?us-ascii?Q?79bfWQYKDWbIYv7QFWM6bg9+KiD0MmPUSRmGihX4rEOFFqh4Wdx5XlcbBQzg?=
 =?us-ascii?Q?36y+zaEKzxJavfKWlwK13LRXr59ikj1PiJXVEzwKIqyoJiaYRTzaqhV54cZy?=
 =?us-ascii?Q?c/FB78MAj9PiG0CB60419ZKS+iJvhbekA9Cmk1bvRDOmihMDFpga5mpsPos7?=
 =?us-ascii?Q?ZwN2RgWThEI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wYpUyIh0GKgGED/tQfCFCzcOjQsNpknYhm1VWwj8vq0hwX2eJVO2bzoYL45M?=
 =?us-ascii?Q?e7O+sED5CqZDy0tyWFk45V47Uph/ND+hTL5rIdGXLAEh4TbH9MlBeN3BzH6n?=
 =?us-ascii?Q?XzB40PFLRwhO8g0DgmqCj6mjqM8eqoDWxf0Lh+0DMv28mGtXg46od3/IzMfb?=
 =?us-ascii?Q?y/M2ZIna5KcwQTyqIWLlZ2N0tu+fy+i4mgF+AT+aofF5tEwBK0pPyA78hIYA?=
 =?us-ascii?Q?tyU8Esltn2I9xxHhwu/kk2ygwcHi5NcB+MwzEs1yNQ2Q4kZ59WFx3NntldOb?=
 =?us-ascii?Q?dQBfyj8Pd8h6ik4vklkdnQ/0onXzVSWlSUNYxeCAukP+DGOcFoif3yMGMFvE?=
 =?us-ascii?Q?57ROe6w4k8LDGBHScfmuz0OWDGldbevv3vCuKDpM/8zqX+kVLzzqaV3tQGTq?=
 =?us-ascii?Q?46Id+tsifb8JicWH+KO1e7sF1EF6ZtJUhBiW1Qd5ZZq5rI3QdVbZrRUHaBJp?=
 =?us-ascii?Q?vibOXET81pyNOYPmw4k7He6FMSUBB876x81jcg9qu7ffrmIuOcQaacqcSHRe?=
 =?us-ascii?Q?n1CGbC1tFw2TlJwwQpxyyE6M8aqIGW3FVOgnX85i9SJBrfaxjvh8eBof6Bwu?=
 =?us-ascii?Q?2e+WRV34y+9fZ4mSXxpi2d/AjVuGhSMttaGPlD9DGYYCM62BpTcLVNOv0Tho?=
 =?us-ascii?Q?+dI/uDJwQuv5I+QYmcFO9kRZg+QAwNm+Cbf4coIWMsPzLFyPOJsgv25QKiJu?=
 =?us-ascii?Q?mDUXtlrJeYTDH8cFQz4HEQs9taZjVBgN6souPfxpAzIJhVKMZ9CGjbqfYQYk?=
 =?us-ascii?Q?N2D36K52H24WWAK2HKiyqe2ErD0eX+msxMU1iqH6K1DoJJ/AnOhTZ8iClx6q?=
 =?us-ascii?Q?3gKX3z8+y4wkATOfQ6OlpTT8eU/EbBfQTMcQKBdVGP39PCoP7rSR80T6NUvp?=
 =?us-ascii?Q?dBqPuYxaC/ASp27lvrwrdTGiIIV1oMxhXUsvyAobthHH4JYCjzoeHPpjxErW?=
 =?us-ascii?Q?6zmQdxEPs9y6lGbowhPAD6bP9ptvDUO33LoR5HlL8o5jPyiN+zevFwzxsrfh?=
 =?us-ascii?Q?PL7mQeKMvz/OgbIiEez+C+/Yif8UL3cKbCQihK0TF7nZkdlW9glz5jzRfyy0?=
 =?us-ascii?Q?rVU3AJojZ7LLjZZVWb97BC5q1oVC8wV1escA/gWoburHSgAXTNRKOAytm9w/?=
 =?us-ascii?Q?1T1X1ewfOuQyTgYJmfC88IQ38y6BHk5KP0A7IiSjybghnXprymcjauc2pPPg?=
 =?us-ascii?Q?euNM0liD1uL3U2pSl5WUK3XpXdMQ8uWjtaus1Ywq6c6C6aPkIBrB9TE+sSB+?=
 =?us-ascii?Q?1bsUOwU4EBDbzuqbipjC2DHNdBtwVTCwlgliCMreo9Od19roLwu5Pk8sW+Bv?=
 =?us-ascii?Q?toG2JM+Qh2pRZNFqqNZ27i8YHrYukVWgeOEcqEcemS/mvSTQU0/ovkCEBj4R?=
 =?us-ascii?Q?rQviiMzZN3nqeBOJ6kXx6Hg+WOgSDcFP4TxMm/FE8Nk59ZYbvDbv3kxE/tNj?=
 =?us-ascii?Q?4nxrW23VctcxLTyw1k61aYS7cQZuG1UyGWaMuxdyOZk9jbRaM/TMxE126STJ?=
 =?us-ascii?Q?8Owb65hsLaXXiI4YzK7C6RwxmqpRRoiuvXuGXC3N2P32DRguZlmpWEgQdIm6?=
 =?us-ascii?Q?BTBFmTPzVa4KFq9S2RcXzS8xn6L7iuhjafWSqOM2QalfN8rRil7xL6eRIHyR?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nchO3QgCkCFODr+sF21Act9fKO0+WHUXWIzN/zFd4S8CppDgQEJ6wI80Tm5KXOSB8mDji48KlyYGdtFDTFA6hEs99rMPl4QNpJNb/o3WNaLafwi2y538avwaWM97mtte/jNBEGvFsyEiqMFlpfmVkcsgt+SOZfXFcqFqmXZZbIru02Pi8xK4apt9WJ01nbdeNnuSMSnwJXkbQntlme4u9gHODj/8gHwNsLSCmAJazg+MgTkGXSPluQx1rx844i38Wk6Hu0msch6VLywFyxkfTOnHJWdyGFuugP0B9nmdWnOx/oKE5soOefqk3SywF14iYvRTWYadeKWPOjRhAc+atZF4oRSqvzhE87OzmzQLEJE2mPaY4Ww0zq2x7U3JnCJlI22Pn+Ab3iDrosEwe5WG29VDrXOGI5fQDkMc6aJz9EnfU04gRvbeJczSQONLut15WRMIV60zNvR5GYr1HkMMbb18Nqs/3IyGz/B9IkIzTfseL5jnwOCL+2T3zKxtQ7+FEpLM/VK52iLQOppdtAbYCJnpGYemoJvHHhm3fwMephmugFrMD1A3vCbiflDnB3vELMags03pWfWihNJFl3jXbMFdjmFX8aNQ84OVucUlzqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d72f023-c0cc-4f60-7ef6-08ddbd57d9c3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 13:11:57.1173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJOKMYloX6DytVBTjqalfoWyhsPf/VxKwhX/lKfhmOkIqbqN5PKYC5bC8wCWB7u+OJkIHjf8LbzCyWLcICDMAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-07_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507070077
X-Proofpoint-ORIG-GUID: w8XNSiYdhWMwAk-GV4MUmhjZHMd7Ysae
X-Proofpoint-GUID: w8XNSiYdhWMwAk-GV4MUmhjZHMd7Ysae
X-Authority-Analysis: v=2.4 cv=GvtC+l1C c=1 sm=1 tr=0 ts=686bc7a3 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=w2tMMWzikjCRSElI7Q0A:9 cc=ntf awl=host:12057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA3MDA3NyBTYWx0ZWRfX3z/4soo9276p BbCW/HfsVHlHiq8UZfSfiELBwv8BeIU6a5kMfXwXsvB7hULZ/J3xCh7KBGqLG/rjdmFha7golhl Zn2kqyYNn2mKrJwsrTBCcH2jXFrM9/9nvt+mv0RuLVZ6dXojcVkVNJgPi/5Cpug3OjRtEW2eSr4
 hGTTGrStMQhlagGTMtGeIG/TcvOQMWM0TS0rKhsX+x1KoYmGNh+O1xQN4deeqCAjC9S9c1apjPz L7mn+foAFtoO9rAJ7smYIpiiwREva/T13thBpUsHSp9XYXts9CoNXVbM5mfDwfZ6XT8fsU6NNn2 Oq1n1JiH+TuXVij5You5psE/a94EC7KHgPwBMYV4WPE2RDy9IGQOgkOFwsM1noFqC7/2Kn2KKRY
 GByvoGki9WaCTOtEEVdHFLrH1MOUTxgOFxWTFpJuu0GckLLSJCDe+m7FbMEh8LOFRJfcgLgc

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c22..97065bb26f43 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4004,6 +4004,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.43.5

