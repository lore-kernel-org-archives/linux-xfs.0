Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19FD212FAA;
	Fri, 11 Jul 2025 08:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752221410; cv=fail; b=ZccR9d1uI9kUg0Utj8sCzWM8Gtct02lRD7D6mS5CFSMhzyUeT8w9kwA88KKYEzYg1SXf0s4m9BPoMfBTimNHEbpV4PUSwm2yqg/4T1QA3bD6yd0MqEap68txaEAAKkvAegCPXgmzq2jqmb8w2755lv5jvdNWSsyPnIoyzudU1a0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752221410; c=relaxed/simple;
	bh=DQhnhzjfH+aoz9q8IAnlp3SHyOUe926/6piV/+jU2JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A8xQvCIrW+0QoMO6dxviGiNEw/Bo0WoECAHnxXa3V/GazZ+NxvaoXRYXLSuGJFPZxkjIDXgOoAv2zI6MbRAmNbbrt/UPw+Pwj23v6mjWnDsJkTgf56BEV+HbL6VEw/nF6JREgLCeShiqIGk8GxPmbhUkUBMLdPCagVgekBArWJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=odrTDVZC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vvMSz9Yd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="odrTDVZC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vvMSz9Yd"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B779VV017613;
	Fri, 11 Jul 2025 08:09:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tiWSjqNq0gOEAPA7275dnsi1ypPx00lLfAhOczaIDHA=; b=
	odrTDVZCTIJ1lsptkmnRYT6CrE/LMzZm67JkxJMOBA83L6HSSsuAITdxP5R+kdpP
	0NqWBASPGVt+Px/jxQuyy4487ittQdTkU5cdWgXU/DZU6EQvV/QN7ip3abDEPrlC
	WJP/CazwfA9Fj1666amgivH9xlTC2COCypBnXveIL4eWGaBm9B34oLVsBAt5I8ml
	pChBesldIq+tEHxIHW8thZtLxcyE2OI3Q4R/NI4sII7NXRNKeyW1XtDm8A19deQe
	qNR+4UIVi0C3192Cv9w8EVeQFtIpaf/YHR5iQB1p0vwHs7Tqv7jY2+tfymeuVr/9
	gQwQ/e82cj8uCVb5HXNGAA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47twx602ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7Z1bH027371;
	Fri, 11 Jul 2025 08:09:51 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012035.outbound.protection.outlook.com [40.93.200.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgd9k57-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WWE5sBtAlhZ/iXWCaa2FPSRIMtf4CXmPTf06LB8w5Pj1n+sJQi9z9QkHaTqP4tPSBI1t4KHjr2/iPQaw1eLXEGO0HYSMG7Ze2yuLxJnLBxLUzcinQH/IiREwRDjbgJtXE3byMRv7+PffSWK9uI1nFRIL4Ohj7/he12yfa9wxo1Humg7T+pif+VJf2jZ4lrTk+NNOewzNbwQXMWn/d4XUhLws18o8Inzpk/N1DPsgC494xOwDYZIhDIBx+nFq4U8ZChtiyUoSAfP4hJeTiReTdsIcQq5nqwIxJTjZU/DWwaIGs4wCTlOjVH2/ipuKKpVhxTFzFoTLrfTBWmCBiQfYDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiWSjqNq0gOEAPA7275dnsi1ypPx00lLfAhOczaIDHA=;
 b=G5/Bh038Qle01KYqGTECIsymEobYoVm0RMVJvSFzG4xnPFULUUpUySBkTuWZFXc7gVNCiPqM2ND6Hr/3OBTImubHgKzLcbWhlMAvj9/ThcnzSRuTUXXdeEyCQY1bFKEcZwHxcfXNFGMaft4B/PLMUYbt8m4Wd4770uPJQsxPbSKPihw/Lmi8Hnd9bjEqrll/qgpjtcPJYzy+GJjdq3vCPYSyrzvgkNebEfoEzIA10x0+48Byde5FJP3Vm/drshOH9ntm/VowjA2Uo4y99PCrSqWcMycRHzASk2Ov2iC5bBJaf+vhje92w3B51f01xzSkfFQOZuxTFVwQAcXQ588FXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiWSjqNq0gOEAPA7275dnsi1ypPx00lLfAhOczaIDHA=;
 b=vvMSz9YdTXuCpvJnjPHTBDGSdqiMSstnbD9g/BvcX9L23jbkoD6+RNI/HZoJ85T9IrXiA25AvPx5W+4Y7oSBQOYfM+CyQbjA5mNxxtGcWMrqXK4NR5SBJGlNtsZFqMlA3pd/mAr/Wgw9Tk/XP+BQfqVKEBfgJBtaIbb7qwkzsnI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Fri, 11 Jul
 2025 08:09:48 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 08:09:48 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 4/6] md/raid10: set chunk_sectors limit
Date: Fri, 11 Jul 2025 08:09:27 +0000
Message-ID: <20250711080929.3091196-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711080929.3091196-1-john.g.garry@oracle.com>
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:510:323::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bd34b39-cec6-4f29-571c-08ddc0524e02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6K49W8seFUylRteAIwsDtF+LG9sqWxH59L5nw8kFEFK0Xq8F7I3CQMsUTOtc?=
 =?us-ascii?Q?7hd+crZrj9AvR46Vtn0mkFWMMn9Yy158Qch5BiuCGvhyu/rY9PAv5FBri4ha?=
 =?us-ascii?Q?/uLEh7pev6HfgIhjHp4H3R8STBP6nek1f1wgSC3+DuAPbY8bMlavLpkUXHri?=
 =?us-ascii?Q?ElFBemNr54Tb/yAxO7d49wLdq00v2bXF5dS6ktMT2124rnB6J59vzWMXWJyA?=
 =?us-ascii?Q?gG6mbaVfrucStOMdStNA/n8Q2NURneynejLLvOFLm7CrcpWIJDY+v10uMcO/?=
 =?us-ascii?Q?PINvVuSJtimex7KMmRr9h4O4E2PgGr2SV+Jz1TTuCclkls50TH3oJPGc8bZu?=
 =?us-ascii?Q?JDWP90T1Rte6iz9ZIkUj7ZO7gf5hq3wY/0dnrbr2BRs+ypXwO+4QwP0f3XdG?=
 =?us-ascii?Q?HoE71WWKTR9tL5NvjWL7A7DPx8cUuzS9oO6hx81JkZ4qeOnC5paUR7KinIxU?=
 =?us-ascii?Q?oRBVGDEor9Jy4dP3F0KVq7ewrrrGcn4evlFIMezUTOVzrrZJKT+Xi/3nV84K?=
 =?us-ascii?Q?zFdCbONZApCRv1KNkH3vdmAOqH2NjEKn92Wo5LqqC1a929irusolCWSgbq9F?=
 =?us-ascii?Q?uLWMXaqvW/y5ucyBBV8ibmBitgkVdNGRhyPu07K5eBFMHy+psAeVNS021QEJ?=
 =?us-ascii?Q?nnfLOcbH6R4mqFWHHjx9RL/v/FgTfuE0GZ/ZtzmyPh1XPmCMTL1p7vuk+KS3?=
 =?us-ascii?Q?NJBll0FcN6O6GVBjehZ88llB0Pzhxjb6dtc2bhBsAd39k1aX9PeLyiLxZAnH?=
 =?us-ascii?Q?fRGNXC5f5LQMXLtajXJLkdKQOBD5EwtmZsO+1jUmsGyZ6LDN4DhN2YDH7h5d?=
 =?us-ascii?Q?w5bK+3J0uUBBCGLTp623ar6by+loFYj1k4W503L9KRqh26TxWVzxPvrrYEFk?=
 =?us-ascii?Q?YkhQ4kBRHxho4IzHbVis/uI9zcOTk3UJJNUcNwffkQ5lUSXlkHSHmEbjN2Qk?=
 =?us-ascii?Q?pV3tAnsgBOZ+Lk4MNTeQDlOrSx+FYj07atmzobwCKb9YzgAkG0GWgnNQV3J8?=
 =?us-ascii?Q?FATrDwPUTQNsUxPB26WT4ErbR6iztBGe+5abqQGJNHaLRmYpOLYR9bn8cj97?=
 =?us-ascii?Q?/kI2zQqmeVH+fuB1KTnFWpJ1hL7/Vq3O3C7bXtvDY8NFcaAZHsNsc/Hbfnm3?=
 =?us-ascii?Q?YH0DLdmkz+r5JCw3qW+Jj/RJmA9H2ZFU7U2+yEn9sG9seWaDMrWkSoIQzLzM?=
 =?us-ascii?Q?WyfuuTBbZ6EK2ItzpJjodmdkrko43Tq7F44/QVrTsLjUQ3TLXGeO9Y5VH76F?=
 =?us-ascii?Q?yez/FEoAbF4Qvk2MxTyayY98CkIQUplcXWlIveSvuNI6vziI4YoyaXcXJNCp?=
 =?us-ascii?Q?DuM1qu0s3TuzIkbCmH9ZSOUJm7TiiPjTD8SHRKh7rE2ALbx1HSZaapBrgAvC?=
 =?us-ascii?Q?nL5up+iFYP8tikP4A2hiEp1HTUjLGp9jbP3wZM+KqrpPEDmKJ0uaU9nBrLBa?=
 =?us-ascii?Q?kQ163T5cK7w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GZ4bz9oSUuSR8W7P8p5Xf2kaYIdoDcCQxkM/q1ldQj8dYkRYXPSxG5K249+S?=
 =?us-ascii?Q?KBO7tDNxi7IU5ZIJL3X3WCG3i7G7UyRuzmakoiUja93gtpdBI743mRqV72Cs?=
 =?us-ascii?Q?JP9LApO+Xeoj5EsUwfq1nEDTGAeEIhnLgjxat0HPlKO41PDH6RkFhj70z0Oc?=
 =?us-ascii?Q?XOtydTbXQVs+JBiEd0PGsTDOrUyJ0g4MHJm0L8Oh4LZSdb8x6its+/tQHKGm?=
 =?us-ascii?Q?DsclXgCG/21Frh6jknsAANZn7ba9CL0b8wrdpk8str+4IQZjXUxIgQs7b6Vx?=
 =?us-ascii?Q?eE52BEHObZAXW3SNRrufCyE8H9PRin9/bDBDXu+9IlyiQE9Gkm3T2TcUV3qr?=
 =?us-ascii?Q?j+FNVNegsIochefIlkM2b+EWpz1Z98rtD95eOwxepn/jZ2bzx2Qu/IAM/r3B?=
 =?us-ascii?Q?GCvBc3FFrzY2Sej1dKq+3sDeExNHJdL2BU/LxtLlYklTmah/2LOxUy9mjUcm?=
 =?us-ascii?Q?es5HyUI9lioygFh2Y2r8x2UQD0kDO5Tb81xRxpUWJ2aRa7hJ5VnhSVxTYdo9?=
 =?us-ascii?Q?nblFzMrPDwm4mH/GI+tT0hKAEJQW5e74/2KMMAMdoEWFbbPiiZm5YksKqj+V?=
 =?us-ascii?Q?e7QTofR4ge65lBDnce3J6Xnr6NajT7ORt+NgsBPzfOBAZffsy+0/hWJvaYKa?=
 =?us-ascii?Q?E9zeMWuKVuH7A61HHBwvMlqlMCBOlrW93Y/lchi+1oBYW34ZBa7BsNjAPebG?=
 =?us-ascii?Q?JDXKG292GfhQEDJzuNqLQNsFmWESU0PSu5UIP/dxlaQTnA0UhGj8vXYa+wMo?=
 =?us-ascii?Q?KH6Zv41xLbE4F5hzWL8ulSezgEFbK6TPtGFfz2ANyysBQBvB4ynkHVBY6Ke9?=
 =?us-ascii?Q?lTbOYuK7/irhTjq7sSz/iCqlmVohGXwTaIvb+O8/7kRz1vmhQQem4XyfphAh?=
 =?us-ascii?Q?zVYFP6X9CtZ+z+WMaW9laqHV0XyyD5Jio3edrClfbS2Agi0/bwslN+hlLEki?=
 =?us-ascii?Q?Q0QPA/viCo1/zgJ/LCarhId1WHDORxkyCDlIA9habxNDasJnElj36THJyUT8?=
 =?us-ascii?Q?wv2GMK5RYkW36wNgJ2gidUx7OntQeTXkFUITzaHFlDRrb/Yzf5WI029c1va2?=
 =?us-ascii?Q?mJw3fZStCink9tii8SjV86S0ZttFj8gRQNZvo9C13Vrc6Hi7ZgNeKD86zdV3?=
 =?us-ascii?Q?IJTEyP+IeZvHMF0O8ItmU2pqBGy72VejigkoR9IHl8OW6/ZOFJCVntzCHX4s?=
 =?us-ascii?Q?guLMQCofmq82Lv8nruC3c6Ro4TuvfnWbD6bCEqY+ya809BvfAPmsxlCahXGD?=
 =?us-ascii?Q?SmR7kMjgdA/flT/CfZ4MITfjLJwkpfa13rcnrlyq+azQh9rIJD6YWo9+wEyE?=
 =?us-ascii?Q?bktP34fjXjKJt8IIPut9bJR1zlCazrUzIaiRO5WTMi9GRQqkr+QiK5xeKeyI?=
 =?us-ascii?Q?jYAJtuEnkof4kBqYAvM39zjWap5keApMrNkq4g3LE0spnxzEsBiMF/zJSF8C?=
 =?us-ascii?Q?Midgdt38OHsOsbpjAeP6OAcMnfywjF/j0bLZxfP1ekFDOG93ZzoyumeJ7sfW?=
 =?us-ascii?Q?0DE0hMHlb4JnCd2VEeaEF8hha4egSDOSJYhvMBDkAluJumHP7+oOYcoJOQQC?=
 =?us-ascii?Q?7OQMvDT4ho4icnOdtrMEGWBOMXYe8EYlDs4Mj9WAJl+rDYdmr8Qfeb0xkvTZ?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6+v3LGNGHNvo+QxHak12rBpVcb6zETZbawuRTV5zO25Cu70uNEZ9SPTTix47NF1/hDeo9prYZuSBUm/sgbRqnW8u3a73dCaMi+0yD0zJ6jjSELkDtCczwXYjRVFJC2lNHeRruM/V5/yu9U5q/rjo4esEVpN0uXtB+5uUcodIcDz/MeeDHW2nJVo5dGf4zS2ub/cbvvXYDZFbFCzVoU4JTD5u6SdOgRYchWhi8VUEQK/xkCX67ZcZHbx4Wlvgy3SJ+JcZsFjGnUE24L4h/Zh6pLOSda6K1w6AyfsqN55pyZfFTc8iKAQw2p9Hmt/zxBl+gtTyytNQd8ONMulHC61ffXxYr69lh1GZvOHMpEmXS9ppQIhpng11CVxiYOpcl8QnvwGO5W/tvsXkU9Xw30chBcPXRygy9JH3WaBVjPssmUcgbNzVdDu9gGGUQfvXs+4miasZb0q5acufhzM+LnyipdELTr8VVIwnwa2ctZNuTgBItAqs0xl9+gXnOhYWHpSjwzPhvwyw6NMhQbsplKbxbtaqDAg3kTNQCJjFT1wAiCJPabUscQrvSzJ4r1HTtZ+Z70e//XzZ83wdSUG5MI3TRzc4xZLXCZo9u6Nc/gqQ2+Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd34b39-cec6-4f29-571c-08ddc0524e02
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:09:48.6744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEAuuqWUgaI4myXeYDZJjXzVMldtUKra5Ad09jovnLbPG+Pv5di2er0qZbzpXoEQwYf4t7mjJGo0P5hMdRNmHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_02,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110056
X-Authority-Analysis: v=2.4 cv=G/0cE8k5 c=1 sm=1 tr=0 ts=6870c6d0 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=w2tMMWzikjCRSElI7Q0A:9 cc=ntf awl=host:12061
X-Proofpoint-GUID: noE2xVgS6EpwX28J3U72sIYnSo-9NGaq
X-Proofpoint-ORIG-GUID: noE2xVgS6EpwX28J3U72sIYnSo-9NGaq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA1NiBTYWx0ZWRfX6Fm8MZxyPJoM XZuTOZJ474lEQafozg5QVPpycVFQyKP1m7nyIAKl8PsYl+IW6xZGY7P1PRs9nBDRAUdUxTa9J2m 0zjt40moD1xnTFDGDMTuuBj9dfoizf5Yr+JrhXj2jjFx5yDButE+NGbYwskT2v4KNWdtWCLilsZ
 vxT2KfGJxiW+Z0Lp/L7WQ03x45G7RU8p60Ggvt0JXP7aCN/beD/qKk+G7jGNAkw04qBpIC4bt3P Iygzap9JtggkWtnoHWP9UFHVW7sktSaiMDm0TBOvPxsHWTiQpZw8aLmGomuab1A/+728ZuF48S8 1zmTMijZeXkWIts1zPNCXsIkntkysqGw0ag7mCSXCPHfRWvjez1gTWLqatTA71kyuRQNOhqJuUw
 FdVW65C9LdpqNxrQywJzB/x94mPEbBiD6a4Zv9sPEqcNo49uA4vI1ZoJl/a0l2GZvIOvtk3e

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c220..97065bb26f430 100644
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

