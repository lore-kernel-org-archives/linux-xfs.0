Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616CA2BAF4;
	Mon,  2 Jun 2025 19:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892150; cv=fail; b=jPHhbnQRFEVml5U3qs4Xh+ICZguKDYvmEOfWv5jlHNFRozQfoBaKySYPKrMoa3BPxhkhdyrL6Ia57c1elFT5lAOnu1pBzt9Dwbn3rN2j29WJ2zrapvo/AVIUcmZVJ0/G9xBy0uA82lB659VoJ07XaNRBq79BtpuBGmuCow2Xhzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892150; c=relaxed/simple;
	bh=Ua8Of1IHZQXjj0SOmpWdV7U+rcXRdBu5fEZHOLr/nTU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BwD9u1bqHlgBYZvZGOcntHfFvveOgTJM3R3XCYrqbHYuZ8SQYbE8uZHVsBHMADudu1DZAVDYbvb8Ugwu53jQYm1OPtAG/TGEpGduBoZLobGIY0kH76Ntx5B75HM9q7dJIKAoFLcNYpGBqO3BrXLxvJrd6zQVwZc1kDN3lnDSKMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KY+c0E8U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i6z/kMR1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KY+c0E8U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i6z/kMR1"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HNSGr029811;
	Mon, 2 Jun 2025 19:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fMeBAtiqEoURh3cShGJdtW7wrLAkTK/sVXG7MppsIQI=; b=
	KY+c0E8URcRF2Jvk5cdEzJe/Icue0vp4eEK8mQURQ//4MYGju8uUytDVtTZB5J3+
	zVeV+aSFsqy63xPiJm/VRYxvOCPdsxVaG3mkJdsvzXCfC5pfgOybbRLiZ5r+yAep
	ldL47eGHqizqO2CYs/EUt2XEIdbCeQtt/kCHR6bbramdeOr5hxRTUwu/Ms7BrGNe
	8FB+Nx7FZ/GIc/8dvDui4snwoIymp18CaIN4KJNOpuKVmNxAButihM+3k47aHvQv
	SC3k5iiLsUEKHFpm7CBRbl+fL/73E03LqzdCsuLSQN0EjkxmHnau9rpHMRPvAcTt
	/YG8aQI5bvACKkqu98NSLw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gah87hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 552Hb5oS034987;
	Mon, 2 Jun 2025 19:22:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012011.outbound.protection.outlook.com [40.107.200.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78mn0n-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D7ugHOjXkRSlXPX5BZtJZ/QG2whBnVUgMMNEtz+jCV1/BVlvKBvT6W6mOellhvayLR/IUGh5g5zMPRf+h+IBvxwP7+EKJ9bwCURu9aVYbjF8RFf7jCoFlnAnEgSnSY5T4vDXyrUT2FSsDkB9L0JUa3RvwHKCEoK5SaTpftwpiSuPSkdECZX/gIog+tx/CD2wSGCqu/hxYF2Yzk1PMSalWFHar2gRiUtWxhlFugaOSkMjsEWSul6hzwlUm60tnWhx6HIRIp198K2P//14Va2eh6+1u3ZI+olx6GeJsGQPfOFgFqaEy+r4y4FGakv9VR/ignft2vjyDIeyp9TfdajaJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMeBAtiqEoURh3cShGJdtW7wrLAkTK/sVXG7MppsIQI=;
 b=SZ+75pxu9Tox/TAreZpvDoZ+H4DTCyRmdQStoiWQ7Gh7NmveYdCYJYwMCcnj3nam7+CIsIrlca85kBO8fJbm5XDF7uIjP+BklETuIJr5SqrPOQAzhfa5b4AUJLEIv3GV9L5EJOvpiwHOpRhk+b63McDVfGcBkXTqocheBAai65b4UPxgVH8N4zS4tf+QUBihq1CrDgFwS6D/uzfBFnp5XTN4bLC45+5lV2riqbBp1hebAe5pX4OwPfnXUZ6MLae4KEcbymJvNs1sing5Z3zmwE7snYSiumviQMR4Uca5WuDAnrCCea2FkiVEKDjvW22QAyIwMvdzP0h/4AG6sO/tKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMeBAtiqEoURh3cShGJdtW7wrLAkTK/sVXG7MppsIQI=;
 b=i6z/kMR1FlfYtXEcqxhDVks2amO+4qgFEwhnD+MigbErhuMYw14xTn3s5/kdI1QVVmN9/04BpEL4b2bVLk9/JSON4DF7FmpMtVhcbZSPCi7EolJy8P4kH5HOJwGZx0zNbP1rDPRzapE1OYpALu1OQJx7T/DBiRAEouvV6pKxyVc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7158.namprd10.prod.outlook.com (2603:10b6:208:403::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Mon, 2 Jun
 2025 19:22:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Mon, 2 Jun 2025
 19:22:18 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH 1/5] generic/765: fix a few issues
Date: Mon,  2 Jun 2025 12:22:10 -0700
Message-Id: <20250602192214.60090-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250602192214.60090-1-catherine.hoang@oracle.com>
References: <20250602192214.60090-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0007.namprd21.prod.outlook.com
 (2603:10b6:a03:114::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: 44dd0c76-c949-4e6d-5bf5-08dda20aca04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QDPOTtOG36NnViVVt5ehcJDoYyQWngUqMC/5fXW3pJ8KsD4wisCAelyT050e?=
 =?us-ascii?Q?tLzgH3N1iGFnTgUZ2pdq1mOW8LZRHJfzfErEJZSdzJKoSUxRsd+Wx1NJsZWG?=
 =?us-ascii?Q?FsH7MIYQLfvvri2hMtUus9fKEmB/1BaoUILe3RSI9VF/uwBWO7/UD6BbNLFs?=
 =?us-ascii?Q?4oasNSuQ2zAWvBTf7j4Q190+ThL21NxFLamts8IOv2XmBXgw+XZg5cekmdxS?=
 =?us-ascii?Q?O9ra+Ioq+Qe3nM5YJqcFwev/0nRQHe0vmaPKXG1p1pYFykneepGt99Q/Vt3g?=
 =?us-ascii?Q?yCPoXBbLIjCorwsK8Z0dyNxCTQ+IXOEdOuRsMIr3/pWZkhJu63uovSu3BT+J?=
 =?us-ascii?Q?hdhqOtGtwsrSPARYASfZQx0xV3Xo6P3zRsfIURR8oKMucVabqHeJ+ZlQY768?=
 =?us-ascii?Q?7JpTBD3tE8KpPXarE4bOedyBgW1FOWBSANgtXe+q2islbz3AndESo3royZBH?=
 =?us-ascii?Q?9Vqw90XncVHmS2ntVzIBDqppBXi7NSRWPTWPlRFLvV4yfDdZDlIyY42n4TBE?=
 =?us-ascii?Q?02ocS6VBtVyAJJMm37aysoNy5mJNUWmKNkoHbifE9FCklRyfvJBZSDPQbGfL?=
 =?us-ascii?Q?aywceMcU7/QmkXPKRiDSoqUy1trWmZJpHvawxwZKfgHfODZkyWqejT3fFMNy?=
 =?us-ascii?Q?CEFQ+c1Hj47DUeruiQan1+yG5Qox9doN/bG89d9Fw+3YuEexbrdQh275QvLa?=
 =?us-ascii?Q?wUqZKuwlwIe0s9f/l1Ihf+GGrNBpSpU10w1HgVM+EpaT9PbpaxgtdvW/YxIw?=
 =?us-ascii?Q?aNEmUDq7sotYerqq1n3Fnjk7XIlyEDjJA8fjIfwYP31b7biN52spoOetInUZ?=
 =?us-ascii?Q?6LJNZXHBbaEfiO/EggGAYxQKMs329/Af96gzTc8nKBWIhGvEEdtoh7PO1vrx?=
 =?us-ascii?Q?ky4BPcS661tskSm90QS6Df85X8AptSVEexkwKpgl74N147KSOVmYWD5kHXGj?=
 =?us-ascii?Q?hDUcW2kcUsoLi88rgQQ5TzboMFdpdU/K5pzs+fVQXbi9gOL3oUZ/91vQ1pjz?=
 =?us-ascii?Q?pXG/EbjGNVbW+Xr+hLQw8Fz131XivvSGdaPbO0ty4VsIXrzyNJ0uWFxbuivQ?=
 =?us-ascii?Q?ZgXK+s5Y5/aiGz3ueIqI3c2Ubf0TnbB1s5kMiUmruZGTxeiOLyDfI+HjWgO/?=
 =?us-ascii?Q?BySOF+ZS28ITKmrQ2x52vSvYL/OTCRVYHje3b5Kw85VY3lH85kXiMvCAIZZm?=
 =?us-ascii?Q?PPF19wwGN404lxv/8t0PgUs70YTCycOQCkNXswWZw8Op9sJPuhojf+3kwxxd?=
 =?us-ascii?Q?3lKOskS5mQ86dtRFfy7ioOwKk6tTM0pfn8DWZ81u83x+SZuSMQdNbSrVQJ+Y?=
 =?us-ascii?Q?AuAuD/TOJ6cc/VyqkeLp7awI0Cgd0a8uU/JuyqACjW00ZkIMC1yEwMOOOgj5?=
 =?us-ascii?Q?nfsO/xY5m8Kz38ka/oQuS+rhoT1proogwSAMViS/oqcGP/7gxzY1Bc9wudge?=
 =?us-ascii?Q?uHDX7pGG2RM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ouIiJ11KagDZmZT4XQ0TijN7nnqd4SiO/2Gfatbpejaw+tyaxtaFxPbMt5kT?=
 =?us-ascii?Q?9hsp6Ne3fBviXr1FyXn/u6n3mr6Y5LtFx+eYazzATNOsghejoEkeNhXHgHoy?=
 =?us-ascii?Q?x8EyYgts0TrlBO8j6afTRmo/oHWDyKs/P8ZR5UoVs13rZb8hruzeXiXNcNSP?=
 =?us-ascii?Q?AyUzzMkjMxEKtQ/wTv6gye/NC8SFuy35D1rnrhWx65RPHzc3jlYgBfz2I7N2?=
 =?us-ascii?Q?jkRatr+9vfM2958s/+IB8nZUAOrWQV0di++DEKTi7BxnxW9+2aab/Zz4CvT3?=
 =?us-ascii?Q?xhGaxF4FA8ue7GDxk18hPzDwu6p08ydDAzyMIvnCijx9wQc9QeaQNX8Au2g4?=
 =?us-ascii?Q?jj/FFr6p5vuLqR9hnWyXhify+qoZyNgxaWswp/y8jQlkWtF6Ae38x8SbLrJR?=
 =?us-ascii?Q?KceH2tKc0aETx9O5t8oWsV22Gxvd8wLKqa6yi0xMy2YwNsdMPUxlDY8FGdqR?=
 =?us-ascii?Q?Onq+9IZFQG2B0eWVPeiJpBduccXWoZRkZscJrE7FsaVBMIkdIyJ64ei/MaIx?=
 =?us-ascii?Q?0IMfZkD4PK73VOzzQUjP1X5Fp5KMJAUIqWqpQv9A8ORxRfwqbPc6xky352+o?=
 =?us-ascii?Q?Yapo1NMvEOuM6UjJeiF/Qb4KhNplbQHZfFo+G8n4/lHZn7BTVeRptq8YWKhS?=
 =?us-ascii?Q?zozHa0+PE7SeXEbKnjf1yuwie0KBxsG+BTC0UKBPdJfO01fiSC86ZduGTuFo?=
 =?us-ascii?Q?8t9ELY0WfK07eKvGsxWWWFAJa7TZyK0A3RZUFGGOSp7MJWfX4cU6qRDHGBpe?=
 =?us-ascii?Q?57VwN308fxEaOEyBawo/D3G6W2dJajzLlyQw6tttF25p71//meJCSJPJGUSV?=
 =?us-ascii?Q?DJkn1Vvw1WL4YkS41Q1qzWqQSwX26b+EmQ8q6a9Uj7ac9JkBUuu9ZfYGcsm/?=
 =?us-ascii?Q?sbbf7vQ2F2In8KCNpIlMEM8KE8nnqTCiGHLFDkBx+TGa9/EY8nhi8UVxFRWj?=
 =?us-ascii?Q?HNfgcyr7+p0cqSnVY6MKgYPYcjLoahnHIH9YckBCTPSN4W0aSOSvlqEzXivU?=
 =?us-ascii?Q?o6DL9oJdDuUK7s11jm2CVd8XmCWGXqSf7/2+osoWu/pWsIyBwm/GVDPhUdGB?=
 =?us-ascii?Q?0X10wKgJTgs/oxwkYUSxT56Ry5zoYiban+aHd3YLuMqU3jfeFLl35PnVyP8v?=
 =?us-ascii?Q?ZVFYNshjNJAT1M9g4CKrfbCpxWf+VxgFRJTTysBwEAnZEVJ/bAlspc6QDpp/?=
 =?us-ascii?Q?SfaI3dP7FCzZOKSM0R3sFU8v025UxuopH2hYk5IHhl6OsjLLNveON1zKfC3a?=
 =?us-ascii?Q?iZ2/V4DTHys+LSlbtFGWhzpovu22CGOIF63qgN7IjqMYgrmb/jtPXYc27ho3?=
 =?us-ascii?Q?WpBC7qpaYRmq3g7KvI/9mO932BqLjw42FtZlF/dZW/9i29RXprDwpHUL1CGQ?=
 =?us-ascii?Q?uoV9gcq2g3sZsJ8otXubiMEzLYHxsPphs4qEilt2kOs9Nn4p02OQZYtMN8go?=
 =?us-ascii?Q?WWr/7W0mtL6St4PbYqn1tBWNPOGYwQILYWeYKhb8LMLsInJwqkG6xj+GzEI7?=
 =?us-ascii?Q?+xt8fzFjDKVBkMVhdqWF1tDUtBy598/GzxwEXNP12wFhcZ6WvtaxxOjKCoWD?=
 =?us-ascii?Q?275LG2EDQrNvrG44jdebOkSASJuQ3CxDrVuduQsRaDCnp3FGOp5dVEoS8iHx?=
 =?us-ascii?Q?RQSayKa21MUlCF7YLILvrF3in7RdGO881xzb1a5s0SJOG4AOP4Qi1rHmpV5T?=
 =?us-ascii?Q?toE3/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SfkCnG7yIa8vJR1WrstqA2htCuepQn53OfBLlwJ7tUSs2MFtFFtaBN2dBPfnhu9GQCtr9qsZaEiLYHqJRRwpeTQvNlagPyLWOfQB4DfsQQcbdKXetl4tai1BQZBFLmSTYdxOgNV0tD1dlvW1zO16pFThDuscuiprDvqV/3vMNk4fPxZpF+va7CUw/RLk0fDlaC+UYI0WDHVlxBBOGxMpsk8k8q/+jwH7UdnaWcXMDZSjirswfNDAjxb5s696kJ6AB6S9pg9tAYadRgvBX6ZNdQao3MyKjp0qcr4wT5QE9DEteEEQlT/QyKUmT1CEgZx7HRbIIyMc9eOD4muB4HdFwaFeDtPlhDulw5gZAwC6YyqsfXPvg3yTbuuVFbJIuIPhNcD8dI3B1nBFeFymoAz4qSFIJKfxQUKyxEuMa6VfobsUrUjPFQ676lGdYk7hxEY3sL2gPRWW5IqRiMMeTuqpDaybvhB/sRqxz6fcpSs3TEdtYetkolHEmNFmxz8/RHF8E5Tu1qMhZponNqvXCPBfWfR4ysIsXtXxMLHwYnlD350Cowdnt5Y9xxZXGH5vrq8tweXZJhU6gn1o033LcZpd8qW8wJ+Hs1NFLNtAr+TeRlU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44dd0c76-c949-4e6d-5bf5-08dda20aca04
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 19:22:18.1303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kd8d/ReEqMyw7HUPI2hGY/Fyxaf4paOd9DfgB+GnQFAdKGlTpSruLwkT3qaspG7HsaIu4QVGm2++UV0MqZ4Y/Dg+HHZvt4OWKuIV7+IBbzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_07,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506020159
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=683df9ee b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=jxo5mUw8ZoZ15m-23zMA:9 a=U1FKsahkfWQA:10
X-Proofpoint-GUID: cr_DLDgPlES9-3SpzWgZFQB8_fUjz0MJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDE1OCBTYWx0ZWRfXyG4ty1tx8GAL WjiIcVOiXeH+HpzPxClEIzHHuBA3fCON/EXuSGaGQRd+I9+VM/npg2aqtACfk7PLakE6b7VfpQp u0RXuCgyz4tqEOmX3LIaZIiZ5fTC/+3hgWOcQLnGbfjCuZQ/xpOPUtHVp4zDhzfF1bYvl2I7dma
 1UA9DytR7WCL/jxaJ6Lw26KTkYs/wr9CCcbV6fmwSaYEA/go98tvZNifdGxcurJ5wRljc+cW3cj u2Iga9p/WoZWM7PhIsIKwB6Aufs5T7t2Z1UhWX7uIetqu6u/O7Ph9sGbku0pB0Y0MmnttU0Znub bWjZr6APWeRKcaQ3Rk7fptirro9I2t48hFpcNm0z8dpLMx06PtsMNvv4wo3ywXNhvn3zP5CobCy
 haSv3zTbu5+5n0RVBXLNnkyqxnt5+Y8PhaS0DvkqzgvMDOktNDk2A0rTtVjSN21ggPxEC/O/
X-Proofpoint-ORIG-GUID: cr_DLDgPlES9-3SpzWgZFQB8_fUjz0MJ

From: "Darrick J. Wong" <djwong@kernel.org>

Fix a few bugs in the single block atomic writes test, such as not requiring
directio, using the page size for the ext4 max bsize, and making sure we check
the max atomic write size.

Cc: ritesh.list@gmail.com
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 common/rc         | 2 +-
 tests/generic/765 | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index d8ee8328..d34763ff 100644
--- a/common/rc
+++ b/common/rc
@@ -2989,7 +2989,7 @@ _require_xfs_io_command()
 		fi
 		if [ "$param" == "-A" ]; then
 			opts+=" -d"
-			pwrite_opts+="-D -V 1 -b 4k"
+			pwrite_opts+="-V 1 -b 4k"
 		fi
 		testio=`$XFS_IO_PROG -f $opts -c \
 		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
diff --git a/tests/generic/765 b/tests/generic/765
index 9bab3b8a..8695a306 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -28,7 +28,7 @@ get_supported_bsize()
         ;;
     "ext4")
         min_bsize=1024
-        max_bsize=4096
+        max_bsize=$(_get_page_size)
         ;;
     *)
         _notrun "$FSTYP does not support atomic writes"
@@ -73,7 +73,7 @@ test_atomic_writes()
     # Check that atomic min/max = FS block size
     test $file_min_write -eq $bsize || \
         echo "atomic write min $file_min_write, should be fs block size $bsize"
-    test $file_min_write -eq $bsize || \
+    test $file_max_write -eq $bsize || \
         echo "atomic write max $file_max_write, should be fs block size $bsize"
     test $file_max_segments -eq 1 || \
         echo "atomic write max segments $file_max_segments, should be 1"
-- 
2.34.1

