Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A02196455;
	Mon, 17 Jun 2024 23:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665456; cv=fail; b=VYlx+f7WVucreZqLFvvRfz32ghriXV6QV2hL9rIv1DxfmC4Rci8XjYVDpasqF57uQ5N2FmDGTWXc/31LTVfIrmUnqjkg/CBxVbaq3jtsJ2PMvwSOuZwIMEniewsfIZNhJdO5BOpGQNZfdhvjQz6DUknAdhASH0Vdi9UPs4JYt2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665456; c=relaxed/simple;
	bh=nDC3bUj+Mt8NJRilcPLi4FbhySkxOLKWNI5go5LklVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fyLpPCdrAlGXti7lfxGCHvfuaLvYpLjLlr4AEe9t5JEJgOmIyG4ugwLzxupTLtIvKBlU3qgZfXxVZr1HHCIL11WM8HuqkrY9rcolTHigLZkrNHTYLRs+dEsjjfwgLewDHfH8dXorfEErdX1PsMY1pCLOF9h9unw5Yy27HcAARTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dTEsawd7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pEgZfCs0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dTEsawd7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pEgZfCs0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXX2h023622;
	Mon, 17 Jun 2024 23:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=xRbeq7bNG51EHGx5h3o5Ighc2Is5rR4P6AlM/mnylWU=; b=
	dTEsawd7HCfk5jSxiGpg6NPdA2/iiGOSTXEuF9zxS0dy3dpqDzHrEBj4jItZMA4e
	v6kK0NhFAN5LXJzzeD6ZbgPd3lUicTrtf/GvDo8BBYdLcuM1AIDiI+dMtDm59rVq
	j6NtvkI9PteR/X9gpjnQdwQh8Ou87T7PaZ/GEZlOqbpaFA+QIlQLp5hkHXpKKqNz
	Wt9UgvrDl9r66/Q6h7/tcCFK5E1Hmuj5VORk2cQIdduX4N6QWAlJLgtkOeC8pYcz
	zeiDEWVLHT9FPCa7+qJh/9b/MQyEv0QguU/wsLUjaNXL+AaSjN5qcg69xr4Rmifl
	0vA+dTqWhXe8YcbzMbsvnA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1cc3sb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HMXQMN032918;
	Mon, 17 Jun 2024 23:04:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d73k3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGUGgCsHYk8jZS/lJOJauxgr7nxpkorPuTdRqbxUIp9mHdCIJ72bJzNV1hI1egvfqYHbpvvZUWgjLnF56sxIYVRaobgmApRTpaIgdAjfqVVcVfprptECpsXV4aGeQpxqQgP+sjmuo25pj0euzG2pGObtwiSqRQEJ6xA+h3dsW6EeLb5FMgV38SkfePA92miXxv24j5VUSkWLtz6nPqhhqvYEbqUYHy55/Q+DdcR87Praf30Zd09+wVd9QeahZaaaQ4WjGvjUuvCdJ+VZ1d6oxmyBziO+mbXT1Ulds4921FLw0RBuVGx8DaftkTA9TWC5fg41YRodlloZq2x1wpgYbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xRbeq7bNG51EHGx5h3o5Ighc2Is5rR4P6AlM/mnylWU=;
 b=Kq7fiVyCL6nrdVXcO42V7xiSZhfrMItb2QULsR8m3diVoZ7F+lnfydnjH0L44sUiniu4C4GKJsmdbyDSMBBRFwai1g2kuGVNSreyIg5wBr/GqM8HnMGhGyHDPFxnJmEP1u9Fx9F41KqPqHL16VNRIYR75d+8R14uACktp9HLMpnGPoGVfYpCGM9jTVX7ANHz1OTnltMLz+CB/4aPwYWw1sKznNPi3gqQfxIilZeD1EgD78r7iaurNA9/a9zHvsf0PAI6oBHqK4Hm+ndfzhRwKZqDuZKVuSCn3E4JYxT7n643Jlg1/WFVNuYQiGgDtOFoqIfmc9lHf6uwG9XK6pD1OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRbeq7bNG51EHGx5h3o5Ighc2Is5rR4P6AlM/mnylWU=;
 b=pEgZfCs0Qjms8hsTvyHWgYBAwSIo42TxcqU/OiM9bHkFkdEBjNk/PSLIxlEBVaFR3A4A+8aVuqh2+fw5HfV1C1PivPT33RhDQvmLB6Hx83/53LOgjh2pTQkCQq2D4bve0ZdXgiJOGSFMIN6tODY74g1Ahtxw//Oj8XWPJJeoVtc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB7398.namprd10.prod.outlook.com (2603:10b6:8:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 23:04:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:04:09 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 6/8] xfs: allow sunit mount option to repair bad primary sb stripe values
Date: Mon, 17 Jun 2024 16:03:53 -0700
Message-Id: <20240617230355.77091-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240617230355.77091-1-catherine.hoang@oracle.com>
References: <20240617230355.77091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::30) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: 72cc1d04-9299-49c6-1902-08dc8f21cbc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?mcqJkIq9AwKNmUAem/0SwqRQaSaQrB0odMPC0+ciY2t2S7VIdzNtLWZk6FCV?=
 =?us-ascii?Q?9wCnQ1iQjyAKy1AkXUt9khLvN0w5ZfKHKpjcLXX38WGkXaHGhVjV23i3AKpk?=
 =?us-ascii?Q?4W4cL+kuB3Dp+Am9cP7xff5OmRjABzW2LSM9aJ9A8k9VI0kNHUmqkxxp0Hcv?=
 =?us-ascii?Q?4oRJ/Avz5jQlDXiXSsAL5gAJhUAlqW3W1wAveQddeezPAceDQqzuZ2vEO3oy?=
 =?us-ascii?Q?g3IJcrSEVamz4NRlb7xunvCfFVEu2VbJb77li0B/cfNMRfCSWbjjFFsNZOMf?=
 =?us-ascii?Q?OSOOhd8qY4Im+T3fQu+YJIZOTthPELIHuGPYW/Tjal+uuLOXCkkRFElVRFPk?=
 =?us-ascii?Q?BZ9PX2vs5HrfUwikekQbt01OU8Kqe4yN9GQA00n9+BlGkpgC7ZJzAUyrl6ZK?=
 =?us-ascii?Q?B/mwEOSbZgQRkw5q1EGMMWkiZ83OQwJa4buIgJe+L1QVD1lZzGbut6NBDa73?=
 =?us-ascii?Q?gIV3Lw3Vf6pMw5EG/YXPUPKsdfNQapJrG2XIoNzeLzexn4unQWeRvBMPKS9X?=
 =?us-ascii?Q?qaTDTeDzY9mafcA3gyM5Ax/EezT58wRYsLG3wk+SdqkKaAO7FlA7cc8/1hlE?=
 =?us-ascii?Q?nIG7ePTAiP5lssmSHQ/0Bgkc4/FI5NscA/CifmT8qakhAuc+E9proXfUA9tO?=
 =?us-ascii?Q?U0NtLhxREyu4oTSIQ+uYdpTr53QdEtgakOf0vSJ6QCDZLLPwLd23GvRj8Kbs?=
 =?us-ascii?Q?2nE0PYyMRVnq7LHAX07JVtgK7kY6HDuwpQuxCUR2mLxISten/ffJvoSknaiZ?=
 =?us-ascii?Q?0H+OCFhIrwo0v8oM2o7Zfz/TP7iaeiIhQ4GNjD1vAs8FS6lRiRLuPl4NMDzm?=
 =?us-ascii?Q?dMh2UqBNe6Dd2pt8+NE13h/SSfew5jmdJlZJupGYeDMsbxirf+1Nd0HJbtLs?=
 =?us-ascii?Q?IKL+l5MK5BDo+6zSZU79rzZTUkKW96ayqJ24FZ7PykoZDPRmoU2eXzJT5Xyi?=
 =?us-ascii?Q?MbDXJKTw2O9TfOvN/iRfQOH/yf03REaW/R9LiCgzxhy+YhFaDuoEKcnQO7ms?=
 =?us-ascii?Q?TdtVchSee0rSJEkH0bxh3ENahzgfxsdbHKQCmwtF7y6Lo71dBNm2+d2Q6dn3?=
 =?us-ascii?Q?It4deVbAhDIx2MwTD9vNpCpXeZJEL+1p9G8IIW9L6LDhw1CL5q/bmDFVy5Ka?=
 =?us-ascii?Q?pHvvRKgncBW0U4kZL4bJy/f50yYARnXiKf4DKgOJlejTD6hXQbzzc0zKEYtx?=
 =?us-ascii?Q?A/MlAHOj2d5E311S0iDiu9TukgF6Ducw/jTvDbceSlXATUW2Y6ARSzjBghlC?=
 =?us-ascii?Q?e8B7NOGTVs5B0TNG9qnvnjeIA5m46d/BMnwZNjdOtV/FAeuw1j3I+zAtC7nA?=
 =?us-ascii?Q?eJ53JOFGS1ffEMRQtT+XLnKL?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?k1xljW7Xoh4JcsM6gaaJfWec4yKX7Ypc+RwzpsBt5pc2Z1S3F5Zr/YF/Dbfq?=
 =?us-ascii?Q?k5Lfn3mRoS5KNaLeoyPDJpCoLYZ0vYNqAF9DtPV/28R0V0nT05KYE+Me4sNc?=
 =?us-ascii?Q?H8+AtYeew2jBOZu92iNQu949X9AIhWP3zQwXwpcF44/YpPVf63SltsbMDVqu?=
 =?us-ascii?Q?VbXBimMfVAZ0YVyt3SDhIGjMObdOvOWgfwwMgaxKKGgaiUBn13vjLdOJ6Kya?=
 =?us-ascii?Q?/XarmmBvJ72PKOF4WbBiee9BQSt3+NwC9xrhMlS1pcqKdCfRn0N8tS1pQfy3?=
 =?us-ascii?Q?ZfYw18+LO4PyATgOfkcbSVcNWKJ1kvLIBpoVIpdjS6WBpfNzP6ZKMDA98dr9?=
 =?us-ascii?Q?EWTgZLe7vJp28g9DG7G2MKu6EUzHHWqOlvCRdL+KEBse6wLrewel+yVkRSuV?=
 =?us-ascii?Q?6Rf65IW1I+vMO7hH/XlAW6L8s3RGbdyUpsiMgMu/QUniiJzSLgz/LHy9trcD?=
 =?us-ascii?Q?w6hOrrACnKxIDXsRidqNmkLKx5VjrtKemsDH6UvpjlwC8H3c743V7wtYxNoK?=
 =?us-ascii?Q?DVsntB3GYuXGbzXG3w/XOuSSE+1mJLwcBg/78PLMzuthEtXBL7LpQoGrViOr?=
 =?us-ascii?Q?ix79C37hv76K+/NvbZlDIA47lGECF3eB+78t1KkxrgHYLVLUTpOIZD6CgFJQ?=
 =?us-ascii?Q?Ax7j9o0HWMqZTvGOvc80qUHsGumQh6noA0A94O8O5Yo2oCZMJ5LqvHwXyFt6?=
 =?us-ascii?Q?iY0V4MKtQRzPy6wVnTq1tTRgZtq1e3eLtbBcyaNjRY4EN8ogtEY0NCRtls9S?=
 =?us-ascii?Q?Crn/k+Ba+uouol91RUnMHhFb/J12m9X6OluYRxbGk6d1PiyIZ9x3siHrYFvk?=
 =?us-ascii?Q?1V2QwtPnNue7Qy4Wt7tQx7QPASJw4nIv5rjUCWiMinogUrJ5QgT9VpYwiEqo?=
 =?us-ascii?Q?FQC5ZKhZR/+MbGhBRG2BKm2l5jwmGEBWYRso/gSp7snbWlJPkzs049GcKW2Y?=
 =?us-ascii?Q?N2HOOJqng9QQ6zyVAtlb+hTFS4Pr2mFmQBR2R24faMf0eVecSmQusreCXFIw?=
 =?us-ascii?Q?ZylnLMMqHieZlMgTOXA5H74ZaOY/8LTrkgXDM2IN04X+kqjgg+MUC1Knho8D?=
 =?us-ascii?Q?5UTe1nJdfw1Ng8TiPLCdvPzMSiRSYnHz7WSPfmNPsDO8x654481F0zpQE2Nr?=
 =?us-ascii?Q?MWdV3HmFkhhdQD6kR6eU8Ftn5CHONTc4MEGZLeR6snqiqXomt8w/yV1t5C1j?=
 =?us-ascii?Q?Cu0D4cxycmmZXhiGfhTwh026FZDbBPCf2d/lt0jJH0NuVQqqbezxvUxdh9cq?=
 =?us-ascii?Q?6kRewbN4QhxV+1td9cqIboFoHpnUoFNGzorz6ioEfKw9bw/KxnnKritcd6S2?=
 =?us-ascii?Q?if15brqWcvrML2vIE0zm+2VBYqv6+Uxn3wxY40AS5wjQYc7+2Nf0ShT9b014?=
 =?us-ascii?Q?80BC0mEfV8RnmJkN6tNgTQAQAEHwuoL8xYPcMnJD92NPYpaKzDsU66UM+SRK?=
 =?us-ascii?Q?0uZV0uyZf4iGrLeWw8rnHj8b9//Z0KOEOTc1XOYjP9qH8OcNTRKecFBU8Lxl?=
 =?us-ascii?Q?JUDsC9rJXFz87wDniA1og6t06Woks+NMyMVQVTfw+pUDLdlPVWPazIN8c3oo?=
 =?us-ascii?Q?rQPYeDOhwBXNs9HrevYWdV6nZrRBzFTEx+ff1UoBfTpNq5sMZk2OsGVAqSgy?=
 =?us-ascii?Q?0T1pWFRUVpO2BflT+k77mIcczqv5xkyUpCoOqOyEtrpDdDd0Hc3qSI3UJiyo?=
 =?us-ascii?Q?2EAF/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ETFET2rQ5XJc8c/6idtfe8a64DZmDE6t3pg8Snk+dZKkAxtMk7Hogrh23S6Y9Ze1jAp3Hs2dA4JRTAa5xFqHZkxk1ZKwgAeHv0ogdcWyh8pczdAFKCf6byFTmD2+NzZEyMRWqdZgVsdMXqdCRcgw8r9mSEx/P74zfXY4wHOHbsaR6I2IB35G5qZtw0nw/Hk/KlO+Iw11a4uWYD1mwr09sxZGIlcQ7Dc5ywZ/NfuRp+COX1okXdk0SAZHNNcouqhiXZ6VQ8hRkgc4EmnAzQp8AGGJNGytJHra5kHZsaz1Q5IBKjuM48XvyBFVEKDUw5leMBTJAVumqW8MbSF/2BmoMeaqi+VcUBVXTcm+55is2bcCtw3Wrup9SGvfFVX2yRzbOT2Ubm++p9/sN0bxl8karNglW3/gE5cpuNxvfc5nHQj5bsCeaKXS3EqxRLTNDAq2C0yPtK4GLF1ZHVQ7ZTmTBasujnDngL7L279iCyCXccdwZRLvwO1xORnCdJfDlyRWwuHX4rWzaH4585IjsuzkAUPjf/1LmBhaC4GVb/wGrf50XnQGi/XmGkm4dIolhkDJKlZrOI135OSGdNiQsmPWhBkkaicYZL3ZhDcnKWoAcl0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72cc1d04-9299-49c6-1902-08dc8f21cbc8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:04:09.6777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3qFgMiGpS6vBE2uZWAhcKbQJuYraz+k29xTT5A6UnuR0aYNP+PlPfKAOvNTxEpCZJxbrMA6B9x6qnLe4UuG75tqbjyZLPQrs0o++4Y/rk4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406170179
X-Proofpoint-ORIG-GUID: 60hzcz7qFKTRMtuNdVP_bn0_kHTeuw7s
X-Proofpoint-GUID: 60hzcz7qFKTRMtuNdVP_bn0_kHTeuw7s

From: Dave Chinner <dchinner@redhat.com>

commit 15922f5dbf51dad334cde888ce6835d377678dc9 upstream.

If a filesystem has a busted stripe alignment configuration on disk
(e.g. because broken RAID firmware told mkfs that swidth was smaller
than sunit), then the filesystem will refuse to mount due to the
stripe validation failing. This failure is triggering during distro
upgrades from old kernels lacking this check to newer kernels with
this check, and currently the only way to fix it is with offline
xfs_db surgery.

This runtime validity checking occurs when we read the superblock
for the first time and causes the mount to fail immediately. This
prevents the rewrite of stripe unit/width via
mount options that occurs later in the mount process. Hence there is
no way to recover this situation without resorting to offline xfs_db
rewrite of the values.

However, we parse the mount options long before we read the
superblock, and we know if the mount has been asked to re-write the
stripe alignment configuration when we are reading the superblock
and verifying it for the first time. Hence we can conditionally
ignore stripe verification failures if the mount options specified
will correct the issue.

We validate that the new stripe unit/width are valid before we
overwrite the superblock values, so we can ignore the invalid config
at verification and fail the mount later if the new values are not
valid. This, at least, gives users the chance of correcting the
issue after a kernel upgrade without having to resort to xfs-db
hacks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_sb.h |  5 +++--
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 571bb2a770ac..59c4804e4d79 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -530,7 +530,8 @@ xfs_validate_sb_common(
 	}
 
 	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
-			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
+			XFS_FSB_TO_B(mp, sbp->sb_width), 0,
+			xfs_buf_daddr(bp) == XFS_SB_DADDR, false))
 		return -EFSCORRUPTED;
 
 	/*
@@ -1319,8 +1320,10 @@ xfs_sb_get_secondary(
 }
 
 /*
- * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
- * so users won't be confused by values in error messages.
+ * sunit, swidth, sectorsize(optional with 0) should be all in bytes, so users
+ * won't be confused by values in error messages.  This function returns false
+ * if the stripe geometry is invalid and the caller is unable to repair the
+ * stripe configuration later in the mount process.
  */
 bool
 xfs_validate_stripe_geometry(
@@ -1328,20 +1331,21 @@ xfs_validate_stripe_geometry(
 	__s64			sunit,
 	__s64			swidth,
 	int			sectorsize,
+	bool			may_repair,
 	bool			silent)
 {
 	if (swidth > INT_MAX) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe width (%lld) is too large", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit > swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sectorsize && (int)sunit % sectorsize) {
@@ -1349,21 +1353,21 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe unit (%lld) must be a multiple of the sector size (%d)",
 				   sunit, sectorsize);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && !swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe unit (%lld) and stripe width of 0", sunit);
-		return false;
+		goto check_override;
 	}
 
 	if (!sunit && swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe width (%lld) and stripe unit of 0", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && (int)swidth % (int)sunit) {
@@ -1371,9 +1375,27 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe width (%lld) must be a multiple of the stripe unit (%lld)",
 				   swidth, sunit);
-		return false;
+		goto check_override;
 	}
 	return true;
+
+check_override:
+	if (!may_repair)
+		return false;
+	/*
+	 * During mount, mp->m_dalign will not be set unless the sunit mount
+	 * option was set. If it was set, ignore the bad stripe alignment values
+	 * and allow the validation and overwrite later in the mount process to
+	 * attempt to overwrite the bad stripe alignment values with the values
+	 * supplied by mount options.
+	 */
+	if (!mp->m_dalign)
+		return false;
+	if (!silent)
+		xfs_notice(mp,
+"Will try to correct with specified mount options sunit (%d) and swidth (%d)",
+			BBTOB(mp->m_dalign), BBTOB(mp->m_swidth));
+	return true;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 2e8e8d63d4eb..37b1ed1bc209 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -35,8 +35,9 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
-extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
-		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
+bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
+		__s64 sunit, __s64 swidth, int sectorsize, bool may_repair,
+		bool silent);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
-- 
2.39.3

