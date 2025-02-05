Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D601212B18;
	Wed,  5 Feb 2025 03:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724863; cv=fail; b=B3WFFJPXfkWsCcBbmsOzUSUfCG7fgbYn7JhmWwEV57h9Q6oyrn7rzaAPh/Pkf4iweBZ14kmQwx70icQKloRfU8BAagXpo9mN7AT5YQcyuDLv5BV8dhyxfoVOLEaPBmUlbAj5okj0a1SIAubNjWOlX3Ah82dz+KxGQKrolM9Yatw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724863; c=relaxed/simple;
	bh=EbfztbNUiCeB7TIbeJH5QwGytEbV+m4o6iYb+0I1qoU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=rnBDcfAGmvuLqH/K+0vFwI4ZxYAHZPCkUsJ85ikalzyBqxwmWGVD9bWPiPrL2Xi9Pr5NLQJ8fCEentjxWNOWPFuyp6idXlUISgYDGsjwKhrTPByU24wHQuMX9ztXyBC+3st63vxY9FhzDUNp59JIysJRZCGvJLnXedS1q2ZFghc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W0B33GPS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OaRaRaU/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W0B33GPS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OaRaRaU/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NC24O003319;
	Wed, 5 Feb 2025 03:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=y2mYlo7w3t8E8v21
	qy1VofHpx0qBFBcOh3azPiT+Y54=; b=W0B33GPSnwwoef/2ur8FBEHAXjhJIAh+
	hEqzQm6hNdkKkImig9Qylu5xa2NK0httiyeQqxcHY0uUA6Afa0Od09z3k7DRremw
	VSxdnHnuE3YF0RRvb+d19uXri9q0WD23NlIq1ObGYebv9WE6ClTFwf+3jlrBv9hP
	REkyraxPDNecQC8v/TX97IFSk5/HuiUex2sCBbzTeyEaJNoOq6URugvwTbCsiMpH
	MdCU9c2CqztQkFNsPd9Sia4crPl2KHRm6ZLSi3aKGmS6Ieh8hrLrdOkd384lEnTO
	7pZyS53d33TJtPJYWpkTUGRTWAQyEoYcDMhfbQYGlBH60h2VZtbckw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy863hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5152osaZ029940;
	Wed, 5 Feb 2025 03:07:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8p3uf3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mT7GSdN481zRLIRhi4QIWg9qQhn0DxV5Ten1Sp4McX9iavkmjH+AEw6voI6JG80zEDxs/XqaB2cryF6+fmbSry0dBD7sHwbr1sKz3mtVQ9E9CNbFO23lUCG9UkFfTwaV8+cfHmIUqpBTE2N0vZEDnDmgcAnznb1xH/rzzyIXTqD4dn5TOXhyTJGBn3kZQBl8tmXfZXuoG6oor9BD51Ae1mBQAvY2cfPrDMjHqch7jxo+m7ub0gVfvC70ndSLXnH4JiJGSuxEDO91HmCAbj5l2hKlKm++EwSHwrP910254DXlmwkyxT2ulEC5vDP3HAlRWA3HQtkxN8oGti4o+c843Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2mYlo7w3t8E8v21qy1VofHpx0qBFBcOh3azPiT+Y54=;
 b=M5jdndSI9lRln3HyNcuoKYezLzM+cPOQb9DhUbM7QH8fqe6THS1oWtrVbUXlKI6cRY3OPbCg9eYjvotkkPI3AnX52M0hO9BPWIglhB9lP5e8TyDjI5R4Hsje1sW4v++EJYhtLchZwRgHRwUS0BimQajXwq2QInic8mqFre5+BHhPpPtxtB/+rVcD7+HtoX1V60+63aMW7yq6vNDw+OB5+i9g0jqAO/Vj0NvYTnEsjFKATCiQOEVaBxaYbPz+kQbU70YazHpzO42jWl9ucLnq7S14GpzKElS1zZtJ9MY3oqq9v/3M6xaO0fISZ8nxPwuyI2rnyz30dviPranNSp2FiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2mYlo7w3t8E8v21qy1VofHpx0qBFBcOh3azPiT+Y54=;
 b=OaRaRaU/HDpqa43RTq8sVmV0s4n+e4V2bQmb2YfrLYbG2s/z/1wF31CRXUvdkzyME6KckwIppM5kGJgWHlNpxtjAOtt/xAj/D4SvkC+Wr9yuez9A6Xk2JI+IkzBdJVLQM+DPhXiRApVMqH25pd5+6Aiq4bUz44Uz6I6aCxwnJGg=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by PH8PR10MB6477.namprd10.prod.outlook.com (2603:10b6:510:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Wed, 5 Feb
 2025 03:07:36 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:36 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 00/24] xfs backports for 6.6.y (from 6.12)
Date: Tue,  4 Feb 2025 19:07:08 -0800
Message-Id: <20250205030732.29546-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:a03:333::35) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|PH8PR10MB6477:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bf0e967-200a-461e-d460-08dd45923e27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XJGjNwIy82wGlrgWo8O0EI2bBVMP9MPd4prX6gqWmn1m4LBE12zG1xJSyH1z?=
 =?us-ascii?Q?XUvdzVyHfb0nThhb4rEkneRm4xCTeDH+PS/JqI33t5YsTYM7j5IKFQxyeGXZ?=
 =?us-ascii?Q?fUZZbvIp28XU/Lpj9suPsUGOT+XpTyeqmus8WuHjxxkOt9gTfF3SVBjg+cNZ?=
 =?us-ascii?Q?NdC9S2jCSpYyaTMkjyv2iYQYm/oTmtPxnh8QnDlXyCvJkXcytZ67oIS1FQPb?=
 =?us-ascii?Q?jxD3rv8fFx0NgdutvJ6NPewBD7inpmNZpEk/RShZa+wD4JpllSKtVipo1+dj?=
 =?us-ascii?Q?U/TS56eTbTtbTJ1muZom50od07dkFUD9B6K/BQK0R6Uyu1pzV7uelchIB0FD?=
 =?us-ascii?Q?QR1e5HwEZspLZDrteFIg1XbTOsZLpPNh5aXsaPz3bEpx0XGsPuYk4SMyT+jy?=
 =?us-ascii?Q?5KW/drT0kOiYZOiyxPWGw3+kEnz7BbI4NnDpu1r1giSoaIudXN1ILWGgQcPK?=
 =?us-ascii?Q?Kf60lVe7A4a1EvWBthl/DF5SwC07Tsuivya41kK1GCzYB4JBfOKCXeIcmnnd?=
 =?us-ascii?Q?MWzCoXDRN0gd8yE56A7CMWdCsq6m9BhIZW1tdJl2wErJdAIWAnmWW+czSRtT?=
 =?us-ascii?Q?Q2RK67a0VTzIFft12Us4W3itpK1Jk6pnxAnU5tlWYHhwO5uSfbURr7Yqrk8n?=
 =?us-ascii?Q?6gd0zf7R/W48VIdLP/okjpHCb65sgLJhXusY/MEXFU8UPXs9TVRg+FCYAfyC?=
 =?us-ascii?Q?wPo3rS2TRhqdh3hhIDFu5PTDsNodO7CilDGGoEyi4imCkY5cw0DQ9j0xal0T?=
 =?us-ascii?Q?lFhHl6mQ0P6/JB+HNOPSzFUloQGCjWFHc4kztJCO3C7XpIEHzRs0txjyQ/Es?=
 =?us-ascii?Q?KsXJPolhbkESOh0PeJ7SU3suYI4HEukFjop54mnyMeXD2jDN/mxmGxdM2bYf?=
 =?us-ascii?Q?wMVpzgtaCtjrQ67HcZca1hVwpbCcefspZDKUfCPs85D6QB8pZm4vt1yq5uIm?=
 =?us-ascii?Q?g+w4rq2bSFgOZ+tBcHcEV5Ykm3lZ55S+kTESAdOPdh+cFf7LAv062LvsclkV?=
 =?us-ascii?Q?p9qNL4+awzd0i6ACINsVNb4X1KotRVC2jKeGR52QXHQSA8PKn9q+ONMkqSAW?=
 =?us-ascii?Q?b+O45d7vZdvXV5m8gdVcQoTvx225SQRiaki4LFfAxSeMd04Eyc+jFEEKxEL0?=
 =?us-ascii?Q?YjadIieqaGJNWgRCCH6TgmeVuVatz4+eNLcRF9njf6VCmpVFcQZJZpEzhLVy?=
 =?us-ascii?Q?Or1dYdrcB51ljfkY7AByOQyp4gP9JUtC3/+2aWCX421NuiOpJWDAnWAvxg0N?=
 =?us-ascii?Q?NFiGjz2Kd0T43t/9IYGkpwX0/ps1YfX7dqQ/IQDFdYy0qtszgJRUf8JEhlyh?=
 =?us-ascii?Q?K7JHX3ap3DVJUiSuYBDSXJ3BZq44KPCKzBr+TReZ1Yt1gM0ErJqR20qiCrhT?=
 =?us-ascii?Q?727IKIOpBdyeWOt05U1DB+DDP0YI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pToZeQDNCUj4WmymojE80SQ52ncimU9iBzJVrJZ5hVfzVZ44cVTqxyr3poJ5?=
 =?us-ascii?Q?6+bmFUNz97IKVfurX5npQZAqlayjWZcWHQGhAs5qIBwzTvcA0TFUg4zvYS3e?=
 =?us-ascii?Q?NdM1kngOxDRpg4ofMZZOZRfgSHILCfLzpeGmuHe4Fow+8hqPKPO+pWgw8A/h?=
 =?us-ascii?Q?Ykjfkj/1pqOedKF/QmDtXtUu/Oc939kTsQGQPt1IarHQR/8VVmOYP8YGbwWa?=
 =?us-ascii?Q?tl1TcEMN5DMZ/eDG6Ttqk0+SXwXgpkzssyQ6KXF0lAcAjy6PV0SR20omn8Uz?=
 =?us-ascii?Q?4OiFgoF2xxHoQJ0+dfpI8i4KjqsRhlxw0LD966Cb8wTPLoGjPRdhFlciQfoV?=
 =?us-ascii?Q?eDwu1hbfHT+lY62kD82WZIHYptTbcVDa4JaP0jJsg2yV0LlpQreeSfypWE+n?=
 =?us-ascii?Q?7TBu1MCYsfCTY0IDk2Ww/s/mUijdjCVSE/vuKlcxQCi4i+wb7HfB6MyZwxIi?=
 =?us-ascii?Q?VznNXea5gPbp0RIirnWWyMUDiIuF6aFDRsdTyAuGEYmCu67ybQbY7q1/Tn6R?=
 =?us-ascii?Q?Zron8oLUtZdAb5dTNem7edb2CMA2usC9THCl9W6jDA5ScpXBcSVzQlp0S0r4?=
 =?us-ascii?Q?AvZB4NR87N19bSWS7U8sRSPmtaHRu+Fj7PTHoQ9RGzX1uBmivrj4xEthRW3A?=
 =?us-ascii?Q?BxDhVtFYM7kxSMhDcuquIUR4rLqx1g+EwoMhQxnwzc/+ohcXQ5MXJL8vGrgm?=
 =?us-ascii?Q?7iVMegZ5S9gejmNzyWRYt6g3tm6DLzPHlZEbtCLXm4iQgQwoZ51huKN63NhU?=
 =?us-ascii?Q?pYbfwt0D047YwFIhm3WSCiB2LFDkl65EsIFVh+MT7Q9iGqx6CmWnQDgUuU6h?=
 =?us-ascii?Q?BfJdtSB8lI14KwWRhiWa4o3Qat0IjuWpU18sVjrQAI1KsiuMC2lZa9P2iAjK?=
 =?us-ascii?Q?ARMF26OXHgQZdjJOfECl5OiTcyMOdpdGI1akswnO2a00flHsNe+culVGn+8L?=
 =?us-ascii?Q?6jBbMSyVYNnf1aSxd2AXBGKqlmI9Xtllssa94KQxeQyK8ASMAnmVKu0jrrZ6?=
 =?us-ascii?Q?5fxk6Qcsz3VdXl+i6sFdDTScEdkQOK6rF79mNsVc4cAveynF4RAUn7jz38NN?=
 =?us-ascii?Q?f62G+RCI+IWVCcOdpI5O7tSHWk59Fcu/TUhtUgkJItFVXhPNt7X7xqBwX1Y8?=
 =?us-ascii?Q?czLlVJzHthAyMfsv34wFcayLs4ZlsTQqE2Bgj4TJ+glOe068NPn0BfA7F4vc?=
 =?us-ascii?Q?PdNXuxAT2J//qtHuMnU7aaZWubPWEyluFzPGDXn01pOfUCQXAKGxQMqEKGP1?=
 =?us-ascii?Q?q2B9J4KBest+6PsXy9fkfZVN+L8EINb0aVVDE31frLKFWTrdo6xIFXI+Es23?=
 =?us-ascii?Q?dW9PGC1OHcu0DrKgkLYDe98TmUJDR/1csmrURxK3jPw0liwUd5uKOYfz2Nlk?=
 =?us-ascii?Q?633m3E7QYUaAN7fQrhTY2Fw3N2zJbePXIpvkXrFetQiDkMH1LE0MoW0NSOSU?=
 =?us-ascii?Q?hLUqfKDziv0KhjhTCzieG+DzXPfAVpvXOdLC0sDIKgmNyXOckWG6YdZsFuN9?=
 =?us-ascii?Q?RPH7vZgWQ5Kp1O/sg5sMWaeoDdzyBNyjhBCfyVKP09Fo5+T5ICR+sIb/7S1l?=
 =?us-ascii?Q?cko/35QIEwOzEBRMVCH91kXX8Gp98+73aarDW5TcEe+sVyOgCcL8gPcR1Ley?=
 =?us-ascii?Q?tjT1s55KlIz7RSx6jvAO6zbtFxu8emuz+mJRWDh/DXXietQeKlKKyYJSSXLX?=
 =?us-ascii?Q?MvpuJQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Nu1xgVtk6xAFGQLlvPOl6flscD0cZqGMOslbV4kjZ0s3X7cDqdZzHelKXHG8H8K5Oo72qX35qUV0ccxG50EKC6rk8AR02hTuChtGQekqLVi1+Z0XufiFLKEQnZzFJ90zFldEPYfILv+UvMwnGC7sZafaxgbkCi42mNACAfiquWjO6yC+ysOfiTYUsI3R1KYZMcoPVqzSYfKHCxkQ4gyTX0ewV2dhbhoAdbp9RS7dlocxAJCJBtpkHkgyJukmqmKWFqbNOEZkRRGzvhVxLwW/uCNRx8d6XzJ6p0PLXJpl65TCmUHAFF6dBnBKyzDYwECadfgtV64lkrTAQA6+JbKyXaZ+xkYDDHazF2QBy6peKvU5jNkuO+CPhtBwsycYlXsrURCY4Gtm1E58mnhlloJA4RhfTzzYODrDgyc4SkrbDdUSHE5iGbZa+uB/MRGgLBnVZDlKS2OKPbwC1nAQYyjJ0uztlaK93r/pvko3cwMvikfnRsvaXOPcQ7dG2ywcSG1kRQ6yguFQvq//T8jgxbGiooHqkMLAMq6NRegDcd6gBhU0WqpUcnGGLN8aezNCwTvWEDeIsXOJZrIn+z8SZB6w6SyvTeICJpVeuknfAetAkVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf0e967-200a-461e-d460-08dd45923e27
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:36.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UdWQ5v3BQ25mWbMfS64ufwl50IoLWxpRt4j0oRs0Ljz0SjuYlC+ezFqBJb0NgV+Vb/RE+XhQgPcclF3GYl0Linm74w5b2Y7VLh+ItvLhYH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6477
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050019
X-Proofpoint-GUID: zjjGHuzcqif6xl_B9r8E2GkPXVyqdLxH
X-Proofpoint-ORIG-GUID: zjjGHuzcqif6xl_B9r8E2GkPXVyqdLxH

Hi all,

This series contains backports for 6.6 from the 6.12 release. Tested on
30 runs of kdevops with the following configurations:

1. CRC
2. No CRC (512 and 4k block size)
3. Reflink (1K and 4k block size)
4. Reflink without rmapbt
5. External log device

Andrew Kreimer (1):
  xfs: fix a typo

Brian Foster (2):
  xfs: skip background cowblock trims on inodes open for write
  xfs: don't free cowblocks from under dirty pagecache on unshare

Chi Zhiling (1):
  xfs: Reduce unnecessary searches when searching for the best extents

Christoph Hellwig (15):
  xfs: assert a valid limit in xfs_rtfind_forw
  xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
  xfs: return bool from xfs_attr3_leaf_add
  xfs: distinguish extra split from real ENOSPC from
    xfs_attr3_leaf_split
  xfs: distinguish extra split from real ENOSPC from
    xfs_attr_node_try_addname
  xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
  xfs: don't ifdef around the exact minlen allocations
  xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
  xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
  xfs: pass the exact range to initialize to xfs_initialize_perag
  xfs: update the file system geometry after recoverying superblock
    buffers
  xfs: error out when a superblock buffer update reduces the agcount
  xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
  xfs: update the pag for the last AG at recovery time
  xfs: streamline xfs_filestream_pick_ag

Darrick J. Wong (2):
  xfs: validate inumber in xfs_iget
  xfs: fix a sloppy memory handling bug in xfs_iroot_realloc

Ojaswin Mujoo (1):
  xfs: Check for delayed allocations before setting extsize

Uros Bizjak (1):
  xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()

Zhang Zekun (1):
  xfs: Remove empty declartion in header file

 fs/xfs/libxfs/xfs_ag.c         |  47 ++++----
 fs/xfs/libxfs/xfs_ag.h         |   6 +-
 fs/xfs/libxfs/xfs_alloc.c      |   9 +-
 fs/xfs/libxfs/xfs_alloc.h      |   4 +-
 fs/xfs/libxfs/xfs_attr.c       | 190 ++++++++++++++-------------------
 fs/xfs/libxfs/xfs_attr_leaf.c  |  40 +++----
 fs/xfs/libxfs/xfs_attr_leaf.h  |   2 +-
 fs/xfs/libxfs/xfs_bmap.c       | 140 ++++++++----------------
 fs/xfs/libxfs/xfs_da_btree.c   |   5 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  10 +-
 fs/xfs/libxfs/xfs_rtbitmap.c   |   2 +
 fs/xfs/xfs_buf_item_recover.c  |  70 ++++++++++++
 fs/xfs/xfs_filestream.c        |  96 ++++++++---------
 fs/xfs/xfs_fsops.c             |  18 ++--
 fs/xfs/xfs_icache.c            |  39 ++++---
 fs/xfs/xfs_inode.c             |   2 +-
 fs/xfs/xfs_inode.h             |   5 +
 fs/xfs/xfs_ioctl.c             |   4 +-
 fs/xfs/xfs_log.h               |   1 -
 fs/xfs/xfs_log_cil.c           |  11 +-
 fs/xfs/xfs_log_recover.c       |   9 +-
 fs/xfs/xfs_mount.c             |   4 +-
 fs/xfs/xfs_reflink.c           |   3 +
 fs/xfs/xfs_reflink.h           |  19 ++++
 24 files changed, 375 insertions(+), 361 deletions(-)

-- 
2.39.3

