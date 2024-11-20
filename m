Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF18AAD58
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 02:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732070152; cv=fail; b=ScUkmL0ISxVSHbg1m1MhBjm9SP+wcIR/IMnG7vqU3AKxxzhurXFIEJJM3ggwvyzT5U7V6CGs5iKheCrgXVk+LZbc4VZRGGGCyDz78dN9CEucg4O2Dbt8VkwGUUguupCMzk/Rvf3dWKNifq2zfDEwbQOxM6q5+Bde81BdXCpLu/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732070152; c=relaxed/simple;
	bh=MuDErdHsqMiYRETrY2a3Rji9AkFrbhnrLTgE6egQGxg=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=N/7/h7U7e25RkwylaXvR+ACeqqtT71pBCzGAA2BgMRmvgYVYboWEoZVaTJOODYXMt1uVgtuS9+oc/mYF3n9OOS708TjdQ7V5e9pUiZeZ94CIIlrmH6EayDwf5OqJIgApc7Zkj0x+vspOFR+bH1/mKDta8M23SAmExBx4yFlBkKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DXR/Hp84; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z0VLDdM+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DXR/Hp84";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z0VLDdM+"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AK1tYcQ018408
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 02:35:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=Wqihg80gJ4apClGD
	gxOg2R7+Ici9AKCW32baQbMxuWI=; b=DXR/Hp84Bgc/Rh1xdYT6mCBsCTYnb7B6
	lRGoRwlMGjo/r73zfMlQ9dUhrOVStf8Xf5Is6tNJplbAbMtN3Ar/pMEgbs6/NQJg
	FqixgUggsRoJse/zzy77i+1Xck+nAhx1dWJuCRH/xYwLWtEUreADmwcJtm+aR0Ja
	8hxAIS2/vUjS4CCkyARIs944vRx/xTZehKi1pstUNxV+wTtT4PLpnRAAFy53NaWE
	grdJMTr5f3hSXdeBiFqVwYjuHvVsbXKia3wUvm/+OFuaVsytnv0J+uqWKziBtdhU
	YFFKSUq9C37vmEeslMTQ/YXQtxnyOoQ6EykEM3Iu8AZl+JGMr4SRJw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xkebxg0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 02:35:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJNmGmx039174
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 02:35:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu9bmu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 02:35:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f877n/HKO2P/idhlcfbxYokNYuhSqBdAMe9W8GeSHyQxzMkySNjRGOBbrvvYsJ7KoIZ3LltB/wbwSsiGJCaLSyZawW102Qr4NEHcbXwBAC7ADBLo+f7V7wuqd6XJTGIHtmY01c2/y7dhXNorV8hVaJXigUBX/zQV0BkLxylSNwynP68KafF0XNoeZJi/axFpmLiDwptCY/GDWn5CQYXD9sx3Pa1yd8W2Ydlm0h12t9oeLobmuIQyGMLbaICJi5D/lgE1+t3klgzCSvbR2tId4V0AdD2wKHRbvA0okkyMXZGWq/rNd4tOl12WHvglDcyGzRp3MlQOFbQkhXl6OsxA/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wqihg80gJ4apClGDgxOg2R7+Ici9AKCW32baQbMxuWI=;
 b=bpHFztmgnh0Nxurbp5Vjo71osmkS/DfmpMJe2+nyi0BhosWjpKpl6xuqtAoWtX6F+akR/+86WDgXlXFk9rXZfmcaQYBNKZLkorTwsacyKhrTRaA/MNAkmrCJQu71nojIWcER2aehh78BqwFhrCcZrrbDD5ZO8qLoqNlV/rEdE3cK2zNCHlV17YBjwsqv5W58CIEBygEuHOSHop1RYLXIqkBrwMdTxyNt1qtXUNaGZ6Z1Lz4ez1Jrmzi0hJLiy77qFzxZS+eAaLfK3Zm58oBIfFqILo2+sjvOZZolqiRMoRcWZGk6wb9nZnBIXf5Bbny+AkVZqRBCf0u2XdqWn4vGSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wqihg80gJ4apClGDgxOg2R7+Ici9AKCW32baQbMxuWI=;
 b=Z0VLDdM+MRG6nRiVQ3pgIERu4D0hhPCYZnZ4PN1KN7xKPUq1jE85h1quw0Thmq97j50w1DaGFMwayY9PMcrw+Wn32A1bXVyeD9yut+d/SfNAWwz3Q5ocz+r1Iw8okq+wh0r4EQvHcFQn2xk8pRoREfXv7/sSgeqyre3LX5rqbp0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB7556.namprd10.prod.outlook.com (2603:10b6:806:378::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Wed, 20 Nov
 2024 02:35:45 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%3]) with mapi id 15.20.8158.023; Wed, 20 Nov 2024
 02:35:45 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfs_io: add support for atomic write statx fields
Date: Tue, 19 Nov 2024 18:35:44 -0800
Message-Id: <20241120023544.85992-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:254::30) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cb7c959-f4f5-44ca-ba94-08dd090c0951
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|10070799003|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hHkpFJfzp0LGLgLKdoMzK3zRJieEfFut/mTQ2P4WahfxhubTsbFrG/Gxb20A?=
 =?us-ascii?Q?KZMkAnVdX6xHIphxStfBew5DASVm3TkaZeg0fdWcByJ3wE9YYg117+Pd+seQ?=
 =?us-ascii?Q?/jmmV98+pFW5OR2RxwZH/AW+GechZIj/Ll0RxAIIKB1ce2EK5HApdSduMiSu?=
 =?us-ascii?Q?91jwE6rPEiRjxsDWxJ4bHgUMmT/r6JLS1lSSNtuJHpT/E0/4LxhsEivFhupy?=
 =?us-ascii?Q?7MdFdHrr/VRQ9x2OLYGzBTUBLbshY80dDseCTK+b7cEyqiOEH+zuZTC9pBfe?=
 =?us-ascii?Q?I8G7LT4DV8vezzKHXSLn5wJPyP6R2EzvR89wPZyZBY3hvQjcPAICJDCX8ndp?=
 =?us-ascii?Q?lVdvWzjr0S+GpWJDWgWXDefb1sz3+v/ymRIKe+p8fY4irrHPsOdiSlc7ai8q?=
 =?us-ascii?Q?6fGhXhCIEk3lTn1HbiN+WnTRhYztjk6uxH6cMD7giJJsQ/hhqVeEDWXMi3+f?=
 =?us-ascii?Q?mOC34m6dIhpxc8OiKzJxo0CySnqKMp1hdxe9nps8sGc/LuD5uhnB6iJX7mBp?=
 =?us-ascii?Q?G9g7iSmrvOee806tU7f3QTwz9/TtuLGZJRIDh1iMu83vBubrii4FlkV06uR4?=
 =?us-ascii?Q?U9bYU+V7uCVHIeHo96QFdDaX9KVP79uelpR1NbAvNu707KxEu9Ff2GOtCVbI?=
 =?us-ascii?Q?C4I8MnIcVvsd03e516ce5TST10lORZR098f8FsdS3i9h0HmGAgHA/Ux07xOj?=
 =?us-ascii?Q?UofE/8KbJtY1+PoGt3FdiTlY1zpaRXJpO1CuQcuUS1gVU3ZlVCSBH2FQFMPc?=
 =?us-ascii?Q?h3grxtDDhZHJSeBghtV0nnVqSv2trH++TPskfD2bb+jdgYyKFYvHNiurHhTt?=
 =?us-ascii?Q?Q762fNYdQATcXbrfVV6dOe3QgPcnySsWlT30B8gXpEVf/STlfemsIEmsCSgB?=
 =?us-ascii?Q?LvsF8x1WWrNAgi5Y9lf2ocGbzWmMZvvpaZASrl9swfamMtA+JuvKE7OVmJlQ?=
 =?us-ascii?Q?pSSryHHJ7x9aHbwnodG0fQs+QqGxuiry4LaNbn3SnhLIVuQ/bdQh47YKD6Cm?=
 =?us-ascii?Q?knHZofOAh5Zw7kKg2Fj1JvIjxjAg6g3QYoNrANLSoN1FDAJ5k/EY2nx2nBXq?=
 =?us-ascii?Q?CCX9i7vUPyNGmR+ZT51bgj92jKhM+2CujdMQulqVZITTEXGqFSLtgmopnsak?=
 =?us-ascii?Q?1qJE1aKCdlbRuJroCiHTB8W+T+3AFA8A3D+qhvKu6Jm4K54o6N2ic8H/1QlT?=
 =?us-ascii?Q?XFKmAEbroQGanFDTqSux2LmbpfUorttw+6V/lBqtJfNecFT6aUiGDKw7jDwj?=
 =?us-ascii?Q?sciApyb0BQqsKX42z50qfS1yEZCxoTArDl8O9OnvyIkau4/Yhwsb+OpU5Mz8?=
 =?us-ascii?Q?I5esP26WLXEVQtaWQyX/h2ll?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iGW1kVJTxn7Vpbmhf+hjVsMtziH/8SXji4zKt0/MWeZ/+YVRAVrc+12NdZcq?=
 =?us-ascii?Q?bAhiHDnfDwtW7jjmHn7xbSs2OK3kmPBm3zCaEzIY+MteblvyOsUGCieJGH4q?=
 =?us-ascii?Q?YiVlAdEj3iBEWK1QAdnplfSSlCpXyR7Q+B3v8zWYnMfvlHEigphjaUTQ4J66?=
 =?us-ascii?Q?EKGV8h2b+eQlsp/es7l4UXX8rsVC+xnbFTBvrd+pqPjs1oKj5wb+RxQRpMNR?=
 =?us-ascii?Q?oO+EhLFQU8e0rQzE+MhvsXqToWIbnVUW3IyRUo+nplOyuewWOVhjpFym2bcQ?=
 =?us-ascii?Q?IHhod9sqkuyV/f1jGG503FLpBBYt7YTUjCw/Te53IeH9csdWKeK07CneftQx?=
 =?us-ascii?Q?mVxrbXUbMkyuYi0on6eJay6d5WvyoNsCb/HM2VN/tYJMEPG+0NEhYE1PtPTW?=
 =?us-ascii?Q?PKfS0Vzk+43SvbJCa0yBRP7f0AT5OV0RPpf8DWhHFlBsmwIxSr7uiaRw5t71?=
 =?us-ascii?Q?POMDXajesBE6FermB9rBZloDdGLuC0xY4epxmjDXzt3mLH0+UNq8SpjMLy0f?=
 =?us-ascii?Q?/fh4Q/bAUu5Buk/syEYcByDe8UFW6d3mXL1beMHGtVc3akskcPgzXfNfq196?=
 =?us-ascii?Q?NS6Yx/0yNI9VglYRJSg+9qpDPLdBe5bQrhaevfqBuVyNGuWSQqP+wmyLlQgU?=
 =?us-ascii?Q?+Bb35ttqg9eUlbIR6NKUgKyKcIK4NcbiqZlCsKAb8KiAydfb2st/wkb9gtS9?=
 =?us-ascii?Q?71xIgruRtpPgybZJQD/QDosVPPiMqJk2/7dFlBc88YruCDFpdJOouqoZR+0y?=
 =?us-ascii?Q?QNT3KFgVjRYHv2rioECxyLP+7kBuq+U9WMhsN1CnQTUkNmbpZoa5dkD0VRKi?=
 =?us-ascii?Q?TvCUCnUggVu6HywhMVHCaUXCzdKJPDElJhwuGAzBmyeIUOY85sTwMnnotzcG?=
 =?us-ascii?Q?R2m97LOox8ApN2UYqBiTs9O5oQvxiEFyJPEvStWMRBwRsQWuGHD4/w4DxJHU?=
 =?us-ascii?Q?S/tp3FwYIirZwrOVlgNsy/7GK54b2yzjEQE6XJs0D93594hFBV8Y7+FgmCOm?=
 =?us-ascii?Q?igvNi5diWa0CCgAPLIMwmVGyzAXHsRcG50oJw10ZdY6Bpjya4YSTP+Eq/3sK?=
 =?us-ascii?Q?QTsue1AZSGUsQDp4+0Mfl1laEkgGZUxt33m2QxEfiPxcFVM8tEuKWQmi0KMd?=
 =?us-ascii?Q?RaIxqetPRVmmKCPlsjDq4jsoMeCqcnq8b0tpr5NOfyD3k8lnLSVPPB9EfuOQ?=
 =?us-ascii?Q?PYN1NmBk7TeY584+w/dSmqUEQ1IO8uzFYHT6s688G/cTjnbuDON3ocydLmNN?=
 =?us-ascii?Q?9P5YuMQVgSd9X4AQY+9L95Qq9Rms//sZ9Fa+GGK1+ahbu3jDsN9eUDmW2KdA?=
 =?us-ascii?Q?p0eVxBLj2KJjw5hUWS2WRqfOOQ7MMkqOX9tNnSDYAMoKweZvYhIO82uEpGwv?=
 =?us-ascii?Q?A7MKKcwfycowkT+Fh3nKJ9guwb5WY/HZRaIIt3AW8x6Uxv0ImQqv3a9VYA+v?=
 =?us-ascii?Q?tuVX+Octz4gnS2wzZg9G6z1xmT6DDQhnPeVc6c/pvgP68eA6UdBw44Lxg/0W?=
 =?us-ascii?Q?OWStHNpVHAWSCPB/hfwBA9YXsvs3BmOZ6abFmEenx9vR2bKpFmukhlu2dni4?=
 =?us-ascii?Q?/CvXXnyHlv06IpZFN5cSEruPfTjZMsUraDrHYOkarFbvUBuJmCXNjd7d3ZEi?=
 =?us-ascii?Q?EHUi1JnaYYFxG0byKFLr0AlaJ1Z84vzIRmq6pec7c/GNDY9CxfLpiXnzbQ+g?=
 =?us-ascii?Q?HGnzDw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PKaPGNY8PZi+6zQ6sqp9liAsaYkehKR2kPx/APrxPOjWsM8YP8aAAmf1qvv4qsDCl4um7PPTjLi0Hcqi2cDoONQXamy5oryxF5yFNFDoiIDSoJnexjN8KOBy1uxxVIkxHTvp6yoyadUhKUxEjyW0287wEOzh694Ls/MWS3hHBC4WO4WKOQlwt/cigmmePtBIx+SRDf2EXRNuMoxM+dzFT28jjTt4yUMNjAU8pdBm1xe5e2YPCXlhEC+881ZyGtt4oSXxSM5zky00sS+j5FdSgZyYXxxs/isX+V4umDUCCrkjoxGpKrvEpEElKD951eSCUis305Wm3GrbXy7fry9PbbKF3pIC1u6QylBgX1Jea+sLrSLi+i176681Qs5fRySdwmasvmJT3rDvQqxg2bBZ16yHU6pX0DPtdl0IG4TMKar9SE86Hdg0uqTOcYXPNDqOGNMxApa1lEDKQ7fMlbsJDwWuhCaNqVDyKHdJWvPwfyqcw/P1t/Tmus+y6qx0FPwXV20XQNtQmsN0ZPZ3NhjuPcXbCvTlExsZKdM2WKZ5MMF7e8kl9amaHMDR0FaWm/mZJZ0d5kWpJlOal3EzwDIrzGZIDVV6YTo8qceWUtqiOXw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb7c959-f4f5-44ca-ba94-08dd090c0951
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 02:35:45.8477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kwy8VmJB5YLxjoo718A8E1UBQGSajM7WF05F7p69U0KejSbUj8GTDh84C2ms/hQXbDqeHuhTvRS0mpWYYZm6KkX5RRua9XqbfPKdrF6sWyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7556
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-19_16,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411200020
X-Proofpoint-GUID: 9uyubOO1MK63LbXYK_pAWr_1zq7GS3V1
X-Proofpoint-ORIG-GUID: 9uyubOO1MK63LbXYK_pAWr_1zq7GS3V1

Add support for the new atomic_write_unit_min, atomic_write_unit_max, and
atomic_write_segments_max fields in statx for xfs_io. In order to support builds
against old kernel headers, define our own internal statx structs. If the
system's struct statx does not have the required atomic write fields, override
the struct definitions with the internal definitions in statx.h.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 configure.ac          |  1 +
 include/builddefs.in  |  4 ++++
 io/stat.c             |  7 +++++++
 io/statx.h            | 23 ++++++++++++++++++++++-
 m4/package_libcdev.m4 | 20 ++++++++++++++++++++
 5 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 33b01399..0b1ef3c3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -146,6 +146,7 @@ AC_HAVE_COPY_FILE_RANGE
 AC_NEED_INTERNAL_FSXATTR
 AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
 AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
+AC_NEED_INTERNAL_STATX
 AC_HAVE_GETFSMAP
 AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
diff --git a/include/builddefs.in b/include/builddefs.in
index 1647d2cd..cbc9ab0c 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -96,6 +96,7 @@ HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
 NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
+NEED_INTERNAL_STATX = @need_internal_statx@
 HAVE_GETFSMAP = @have_getfsmap@
 HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
@@ -130,6 +131,9 @@ endif
 ifeq ($(NEED_INTERNAL_FSCRYPT_POLICY_V2),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSCRYPT_POLICY_V2
 endif
+ifeq ($(NEED_INTERNAL_STATX),yes)
+PCFLAGS+= -DOVERRIDE_SYSTEM_STATX
+endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
diff --git a/io/stat.c b/io/stat.c
index 0f5618f6..326f2822 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -6,6 +6,10 @@
  * Portions of statx support written by David Howells (dhowells@redhat.com)
  */
 
+#ifdef OVERRIDE_SYSTEM_STATX
+#define statx sys_statx
+#endif
+
 #include "command.h"
 #include "input.h"
 #include "init.h"
@@ -347,6 +351,9 @@ dump_raw_statx(struct statx *stx)
 	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
 	printf("stat.dev_major = %u\n", stx->stx_dev_major);
 	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
+	printf("stat.atomic_write_unit_min = %u\n", stx->stx_atomic_write_unit_min);
+	printf("stat.atomic_write_unit_max = %u\n", stx->stx_atomic_write_unit_max);
+	printf("stat.atomic_write_segments_max = %u\n", stx->stx_atomic_write_segments_max);
 	return 0;
 }
 
diff --git a/io/statx.h b/io/statx.h
index c6625ac4..347f6d08 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -61,6 +61,7 @@ struct statx_timestamp {
 	__s32	tv_nsec;
 	__s32	__reserved;
 };
+#endif
 
 /*
  * Structures for the extended file attribute retrieval system call
@@ -99,6 +100,8 @@ struct statx_timestamp {
  * will have values installed for compatibility purposes so that stat() and
  * co. can be emulated in userspace.
  */
+#ifdef OVERRIDE_SYSTEM_STATX
+#undef statx
 struct statx {
 	/* 0x00 */
 	__u32	stx_mask;	/* What results were written [uncond] */
@@ -126,10 +129,23 @@ struct statx {
 	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
 	__u32	stx_dev_minor;
 	/* 0x90 */
-	__u64	__spare2[14];	/* Spare space for future expansion */
+	__u64	stx_mnt_id;
+	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
+	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
+	/* 0xa0 */
+	__u64	stx_subvol;	/* Subvolume identifier */
+	__u32	stx_atomic_write_unit_min;	/* Min atomic write unit in bytes */
+	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
+	/* 0xb0 */
+	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
+	__u32   __spare1[1];
+	/* 0xb8 */
+	__u64	__spare3[9];	/* Spare space for future expansion */
 	/* 0x100 */
 };
+#endif
 
+#ifndef STATX_TYPE
 /*
  * Flags to be stx_mask
  *
@@ -174,4 +190,9 @@ struct statx {
 #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
 
 #endif /* STATX_TYPE */
+
+#ifndef STATX_WRITE_ATOMIC
+#define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
+#endif
+
 #endif /* XFS_IO_STATX_H */
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 6de8b33e..bc8a49a9 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -98,6 +98,26 @@ AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_POLICY_V2],
     AC_SUBST(need_internal_fscrypt_policy_v2)
   ])
 
+#
+# Check if we need to override the system struct statx with
+# the internal definition.  This /only/ happens if the system
+# actually defines struct statx /and/ the system definition
+# is missing certain fields.
+#
+AC_DEFUN([AC_NEED_INTERNAL_STATX],
+  [ AC_CHECK_TYPE(struct statx,
+      [
+        AC_CHECK_MEMBER(struct statx.stx_atomic_write_unit_min,
+          ,
+          need_internal_statx=yes,
+          [#include <linux/stat.h>]
+        )
+      ],,
+      [#include <linux/stat.h>]
+    )
+    AC_SUBST(need_internal_statx)
+  ])
+
 #
 # Check if we have a FS_IOC_GETFSMAP ioctl (Linux)
 #
-- 
2.34.1

