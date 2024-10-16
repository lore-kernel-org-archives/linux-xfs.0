Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4113AB641;
	Wed, 16 Oct 2024 00:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037517; cv=fail; b=BwuX73R1NINaiRbz9kLYzxKn/Vr0W/6meaFGbD1cV6t32IS/vkeHoQqNg4bYqQFMHUbDvjdBoN+UmgwWaJGXrIbs9a4qEo/lOKbUMZcZVS1FNM7b6jyq4P6XEGr4ZJBhAE+qCug7p9WAUuGvEuUlul0B/EcsmAXzopbqGO4rH70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037517; c=relaxed/simple;
	bh=R34B86ZjNpVyTeQojj4NSySj8Bsc7ZSRsXOV81CBfew=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KFuEZ8KmfrRwhN6f016I/rrPRcFu7T+ehwP4Gzybysq/7IdVeSPycSHgoi8VIGDgV/AQhDDc7YhjaXCha7pF3yEbpPhj9GGwG2AqpP+FmZr+wbJ6amrR0xKXNIdDuRpKcU7d/7RpHRzjMl2nhzziWfKCizJIqiYPy5nEMmeFZJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lY6v0MVF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zdwC9Cej; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lY6v0MVF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zdwC9Cej"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtd8U011655;
	Wed, 16 Oct 2024 00:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0z53B2e9mVUBPLsUzaF++kg5VDFpnCDXMWGARmfnF+I=; b=
	lY6v0MVFeS9VDchlrffRDZPL3gvpGO1BO7mT1j20NZfDrtcSuWpInWiTsygE4FA6
	aeYvifliOs4MUjJw+3MIzEWxeIto+/RTiJmpy4efHXRggwFxuOCBsov2z3ZhZd2P
	LElG3xZfWmqTT4Zjvjt1LV3qqUEA9Kh/q6g7oi+I+m3XLIiBI2zmsr5hobfV01i6
	JNqGxxG8VS88mG4OiEFBQTLakM+RWcgq2e8Hl58+lkjt2TwjKNvU9uVATcFFiAvd
	L/VCG9/pXzpObQvi0109EvtVyw+B1ooN2HZX3PGtVCpkIemdQd+jYNW8auEp/ix8
	1JJtRi2jMst7Aok995bonA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gqt2fp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLU1Pi026220;
	Wed, 16 Oct 2024 00:11:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85ajs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eEU+jj96YAfXj1PeTI9J9pY0j/MuQnvtcWtf1G/N8moChWL3Z8LZ/Ab4MMvuYp6vj/gsUXSndAZy7kgCFmZx3i/kZt0yvn8uXoxuOy59+NWQp3tBBK5zomC4mCFVdalWvbJG1zsUzkfQWZqNeY2395NbVmFzvoA6yd9US1z0HOGB/2AGnF8jTS3lJzGS+zfIe1zu4Iced/VDcPaStt/s7QERvacpxseMs33QwSYjJxxvZ5JwwOB1JhWbkpzBWVMR9QuQCrUOBnT0N/HRswHeWSnpWEPoGzYEInxlG2wmfZwSiIzuu3C2IcvGDybOAiLsd8ylCpcAxGwyobINMuVmEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0z53B2e9mVUBPLsUzaF++kg5VDFpnCDXMWGARmfnF+I=;
 b=EKL3n0EAORAYvtXJ9BUk1reptklizIEw6XTQ7OsYSLwvxNq02oz0C6FaizbXALTh01b5Uk4EdKxXDh7EAuq3Ss94BBZVqmIyKeU6XmsPG97DpOcOwS2iLxD7DBBX3Ay8kAm2epFXHI1iJ62kkeoFoWyZnu6MzBH3yRx12M//g4pwdSfnmS4sNVtXWiTQoGQ2H35/wNRMceVRqktAQhCs/ZIFnJhCz1V76elNLpb4Pf+cpx3jQqstcqautC5c3/UZAJGa3Oxj3ryJtSChQqxW6GZ382GgGLpMJjzmIEBRI1agyVSmyuXpgyz2CcA1leGYt9yTGFmR11OkXHMOIkCEDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0z53B2e9mVUBPLsUzaF++kg5VDFpnCDXMWGARmfnF+I=;
 b=zdwC9Cej7t+sF5NbqdzBJcFUtqntLQ2svg5NQnPisrOJTHv1LWsgggk6BUuwj04P+iGmCE2OCo89vtTskyh5TTjzBGhXUje93OwPoOghWPhTlipe6r/T8Nu6xILy/YWKOa6ORhSPxfw7AwCYGoHSI/MFOlmuIXW0GUbgYFdiyeM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:49 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:49 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 10/21] xfs: revert commit 44af6c7e59b12
Date: Tue, 15 Oct 2024 17:11:15 -0700
Message-Id: <20241016001126.3256-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0194.namprd05.prod.outlook.com
 (2603:10b6:a03:330::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf23861-186b-4b98-0a5f-08dced77213c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IV/gXU6YBQ8b4qrNSphOaPQtrmIbJeEZXcHzg2Rm3IFeIYFYgT0vOB2bwO6+?=
 =?us-ascii?Q?VNRV6/qEXpSgiTRLq0UZwwvVungmBXbTE1y8ubwaa1yHS7Q2QWSASNFHXVfW?=
 =?us-ascii?Q?HhX5OuOMzZgYDUZXqAyUgdKKy7geakTyNZ2aUquc5VkqiTvhuBNq6DR0uWi8?=
 =?us-ascii?Q?jSL9DYi4fONnYRVolxjj6sGSUnljrcsFTvoCAGvzsKj/r7sS+gY4T2lrB5ky?=
 =?us-ascii?Q?pApEYJJIxpSPcrqifAKEzs2IvaLDqa5h52gNkiljNg+ITahSd0xyfjaJTr6i?=
 =?us-ascii?Q?3/eWhfqjVe+Uz0C/N6i9vQI4OcsKKyq9mLKe0bSFCG8RAlvYuk5cRML3uIrl?=
 =?us-ascii?Q?IT0ON1xDKI/ayPsiRt4mp8UNMMjrxaBezWdiGC7oQG5VuPk8Ld8a32Xv+CGT?=
 =?us-ascii?Q?FvnMM9lNtj3ZXYquYNw0z6YgIReXRQFFcmLqD4JeZw5nJThtoYAWxmPY/wxy?=
 =?us-ascii?Q?GI09rvESJiPr3/oWPtSMNT3zjAm576qNX7b1lH1SjZgefPkTC0GKSsyk3TnO?=
 =?us-ascii?Q?PkjQ1ILABjXoDlPyvAK6/ZaqiUzsvZkS7fR7xW2DFWZ2vSgGX9skWXHiLcBj?=
 =?us-ascii?Q?wdC67PA8GdpOlCjXtT8UY1wT1AT2TcpYzzTpimBY/o78zg1hu1YOEaBHfDAt?=
 =?us-ascii?Q?s2K3+t0a3CLZagB1K5lrN1UW4FTes2s+1xdSwNTztsIYmfJRy9iYIrR+eahD?=
 =?us-ascii?Q?OXfzJNciKx5fMoe8CvUV6g/gNP0WcCb5tDQd3f3LXK8rJBie3cQMet2pOiDm?=
 =?us-ascii?Q?sAHlmaXzSlIDCfOD1gjiN+XsPhjQhCr3BTrJjMq65FmkpoEDDctnYDYNF+pF?=
 =?us-ascii?Q?k0sGn+z1Akmkx3oiiPRyl7YD0vIekClYJiBDlrN+V4l5SnXeRBUG7kd4RZ/T?=
 =?us-ascii?Q?H0f8u47SRKVoDiv/P8QOzo0JC3KT1+gh2RYqpNKCw2bJKtK028lnYG7jO+11?=
 =?us-ascii?Q?a075qPDBJ/a5nXIhfc3SjYaZZWavb9lxOqBFvxhHu0vNaKJoDzVlrlKJYJwU?=
 =?us-ascii?Q?mrYOhhnSSOChdENa61qqc3E2Uwt5T6lVQVhQOkeQzJWGOjO3D0yLtZB6KcPP?=
 =?us-ascii?Q?KJYPvvrv/CjSoZfmnmkPukfzeBL5xLBv2AiW3LCC7XbGKGrgluhr9b/Sv6V7?=
 =?us-ascii?Q?f1ImdwkmBCaYFdt7v1aruClNgfyt6uOLLOXHZuuu/bEuw4aoUtE4KMH8Qaca?=
 =?us-ascii?Q?9MhgtVQdgmF7q2hQNRJ1JCPkh9U9wP8+xBx66Ao3ortBUKZYp7sQVY4tvRdJ?=
 =?us-ascii?Q?DMbnp0VKjHdtWbDhE3SbkKxkicID6kP2duOQssuDmw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+g98dB6YWVNPEoF2Fq4I0rbIh/OfWyy2LATPEUwNRcccxso2X6fUXsQRrP3l?=
 =?us-ascii?Q?MDp36BQOz0VSbPRcl4O2T4j4xeVCs1vmMRmNqEApZl21QQWix+ZrxmBFMtT6?=
 =?us-ascii?Q?yeiFm1/XJsSdTM50bjB+mhfzGAMgdCT5Jw3OGxLh5FpmHyS/uqYU7Y2mGy+S?=
 =?us-ascii?Q?JcnR6ukBVFqeKLLg2aXBSfekixw0rNnHsHqT+T03WMKL+TnHEtPJFQcVrp6+?=
 =?us-ascii?Q?8M5KKPnd8io5iLRZMqmvBKvSDs6n39Mco4LH4CoUC6u1XmlitXvDIpELapyi?=
 =?us-ascii?Q?3FrZkLPfK/04eRjef99uUmmyf6Re5/dOTteXwlPBacgqJl07zOrhcJu4ETio?=
 =?us-ascii?Q?9OnWL2FQUM6f/aKbLo1b08dDgSxNHv2E/zgR98myxHf48AUw8ngUvXRTY//c?=
 =?us-ascii?Q?OoyjFJyTgw5JWMaK682OjAMhMAdKbInw5OU1dMUrBWE7fJrJ99ikWDPWYBdh?=
 =?us-ascii?Q?AUGgp7HC8eu5nG+Hamj71ExTvOyp8EuCWCA4gVcpiilgOAqFQxFelem7dR0m?=
 =?us-ascii?Q?QH9nLduvma9/GKLEmjuA1piv3294l79fsp3cyXxBnVOcGYyP/ZupyrqgDIda?=
 =?us-ascii?Q?BPAJRCqWwEIbm6lbh16Uprt7FGSpK8Nk7+0qKD0ekAsUKZzKOj7GmCHQxw01?=
 =?us-ascii?Q?ip9ekeIzVme6tP2nCvcOshgkwj4KX2nV3se0iERlcSNlAlQ4cE1sbUZaK8XE?=
 =?us-ascii?Q?Y1ODXdGQID1b8Q0VMoOzlkQyJ2rp6Z9gu7MiFYN7d5ybLj+nwWfiVvKIII66?=
 =?us-ascii?Q?yNDfYKchS5bz7N/loKQs7ZIIRvBdV4CrlPuivDWAqQwpZZSwqnD6T8pDlV+D?=
 =?us-ascii?Q?BqYlyLmIHTp56gfYNGkbaHKU9nrSO0nzepxwwW1aUXxvttdL36nXyJsirBGO?=
 =?us-ascii?Q?EC3uoK9TBB48srD3RkCyAJoDfKuZpaPAyxVek10eWKqnvv/NWkBrzvqJGQP3?=
 =?us-ascii?Q?q9QtTjLhqbbQJ4NsEx1jkqmKYZkryQM/g/0PgZZF7Wee7xGiP39EsnE1CTqn?=
 =?us-ascii?Q?LeBP9mEthDvtCUQxB6gxG6ho6AO1EbgosaCUlJ7lot6hSdTe8RZu88jOWAFJ?=
 =?us-ascii?Q?r9jnmsIHiz4nZdN5SkgwxTIQe3ZCNuC0lqzxj7reMNDzuUw/kJ2NYY41Dldj?=
 =?us-ascii?Q?7mhCg/43qD155DpiRqYVEIX2GgAHRjWNkZ9c1LT8UwWVcXRjMI92dCZlBXlz?=
 =?us-ascii?Q?ieYGZPMsukBRt8jtlAGPVnJDSZxex8f8lPIDop2g8VAHr5kJFaqGbmBg/2Zd?=
 =?us-ascii?Q?mh9DEthRqCNf1rTCYJol7m4w2eWlm1sHu7Mn9sn9ZaegqwdPPC2evxdHerSi?=
 =?us-ascii?Q?ZZAjh7y84NlfoUrfxvx9MsTKS8bYhxHsBwkWq2B4Hf8ZPOeYLyHFzU6Lq74C?=
 =?us-ascii?Q?qAgf3eSsxtMfPV47NrurJVVin1J6JUazwfcA4uGTFxLK9Ro95Mwj5gGEsNyu?=
 =?us-ascii?Q?4eJqsq3fw1ehQOoZVtdRlZHR/AI/5MBiPuiIrUCe3V2Ia3fb6o/Q/PYbQlj2?=
 =?us-ascii?Q?kUWcmNqLgAKcYXxRSD9t38Y1XiVXtP1mGLvvn0qIelP+/mhpvXGXP6nKlXkz?=
 =?us-ascii?Q?Jbltu8UHqMUoEuWS8RadW8Nnw51CK2aB5b/9jlt1Wi+EWe5Y+LlKQdC2YSRO?=
 =?us-ascii?Q?fik4JvPZTDVP2GgiKxlOyNvM2AtQvW6g8U/rv25nhKCfbCfFJrLTJ/gxmef/?=
 =?us-ascii?Q?pFA4aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QdNybKDYGDaxN/DmwgmrgZdqCP+QdS6bLLGoWZQk1H0K1s8InMG9HMuFC7UUulm46LkZ+Y8tK3J8CtzQI6f7WHwUXwOxTuNdL00zWH7/OQkeTC3zqREFyMeTyRGlmG7CyZTW/3sDXOy1v82soAEHjq5/OHyuz9QTH1QDYGbySS3WPIubEQW7NyIFbHrfor67n9u1BOAtGQmrhmFZbsRWckHxRD/I9tglVziIP1xAIFTKKFkjZTfXeI7HJv2q8f7yw/1/c6qjJeNfpduboVov8NKRFIxZP1NlJGOtCJcvG3HlqhrPrcUh2pT0MYUTuDOAcwSYrcZinahLZXWlRPdwtzeAibhx0nZQVCuTayxV+0GphH7Fw1xcn0cPhtBCoOFkPNMQyOdMNd1j+cGpEeF1alr2cDHvsFt/XyQzc0TsXDvYT1xJNvHeMTfV+NlB+s50L1JqxcmlZjSDBkfeM9alrXeWA4yREVHWzzbYy7cuW1v9Gj5O5JrvWnTaJsgO6HPYVk6DlBq7tN1IChL0VFx29xwWlkOnN2rM46ATOAtrwHoZw25eg5QKPmp5XmcxhedQU98KExhDW9Ln47VERdqxF2Qz/u0BMBvRET5wGeDr1+A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf23861-186b-4b98-0a5f-08dced77213c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:49.5719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkezYNVnyapp1kD+UgmPtSWNi+IbknceLIETd8trywz5O8/aKpVmmn6VBf8SsgYbcERiNY1g9dzIQ5egRElN9j2pPCi6ccflauaGKyKxO+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-GUID: nJkDFpaE4D0NCVXmNUjvtfFni7MaZm8w
X-Proofpoint-ORIG-GUID: nJkDFpaE4D0NCVXmNUjvtfFni7MaZm8w

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a009397eb5ae178670cbd7101e9635cf6412b35 upstream.

[backport: resolve conflicts due to new xattr walk helper]

In my haste to fix what I thought was a performance problem in the attr
scrub code, I neglected to notice that the xfs_attr_get_ilocked also had
the effect of checking that attributes can actually be looked up through
the attr dabtree.  Fix this.

Fixes: 44af6c7e59b12 ("xfs: don't load local xattr values during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 7cb0af5e34b1..147babe738d2 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -199,14 +199,6 @@ xchk_xattr_listent(
 		goto fail_xref;
 	}
 
-	/*
-	 * Local xattr values are stored in the attr leaf block, so we don't
-	 * need to retrieve the value from a remote block to detect corruption
-	 * problems.
-	 */
-	if (flags & XFS_ATTR_LOCAL)
-		goto fail_xref;
-
 	/*
 	 * Try to allocate enough memory to extrat the attr value.  If that
 	 * doesn't work, we overload the seen_enough variable to convey
@@ -222,6 +214,11 @@ xchk_xattr_listent(
 
 	args.value = ab->value;
 
+	/*
+	 * Get the attr value to ensure that lookup can find this attribute
+	 * through the dabtree indexing and that remote value retrieval also
+	 * works correctly.
+	 */
 	error = xfs_attr_get_ilocked(&args);
 	/* ENODATA means the hash lookup failed and the attr is bad */
 	if (error == -ENODATA)
-- 
2.39.3

