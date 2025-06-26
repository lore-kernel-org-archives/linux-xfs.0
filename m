Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358F133EA;
	Thu, 26 Jun 2025 00:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750897671; cv=fail; b=lg6+UDZOt3H4ZDyfZeb+erQzQUHR/IhaydaIvCejq0KJ4+Zn/j0iSVm28bJ+p1fQDqmdxdpv/PYC9Sehx/XPGPrkbyB+7hPJ44e06JqpTC9UEBy7X4tLkWc3RB7doIruunTb/67hhPy0BAm8vvwYcVeIsKMqT64tpnfFd4CxFZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750897671; c=relaxed/simple;
	bh=ZFK8Tal0hdgvx+sM0X8c/4HwEVFLGo0w+Ja8j+h743Y=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=ssfDJEcGC2cNBZrU1YLaJ6LjiVcbEEurTKH2gXy+hjPGeXpSJfLsLByMFHySvuSqpfXy1qiyqe9XNa+4aoINj9/oeMErtXoB2oWExeA95eGTRiW7hkyRNTFH+ART+CNWuwFffn2wafd/aWRuMHAIo2aQ/dIBGcbqQJlW4paBffc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CK0AD06M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xKCqy08f; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CK0AD06M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xKCqy08f"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PLBaVx021545;
	Thu, 26 Jun 2025 00:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=7/KI9xZQOFp2ozfC
	IzrHUFPnnlvOT7pXDnOwzh/zLMU=; b=CK0AD06M+durisMC2ur+GaOSeYLVJezT
	ZnBD7gN1w+sK3cp7eO3lANiYcLfVxjI1fGP+5O6EcOryaXc9a+W/hN6fXOBPCx4M
	e6eOrx8tGja6sAIdFNghHbEtxo+eKggShtPRe5rYVaM2+MMEj1hmAdgF0kYswYP4
	lSF67cs2x621jFmzk8X6mE5FitB3WLXHMRIA0gaXpHtQQjOt5ckaFiDAcX8Cl3za
	KYCmfJ2Jac9Hc8Qaf3p4XnwrkHgbi7Vw2IM4+oEH8oslygGjSmQ+Hce3XLxYCgf4
	PERiyrp1CgNpWEL1Bu/jR28ksekFH1oJAxYoJ6YcxvUn32VYHCETKw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt7fk74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 00:27:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55PNOoGJ012978;
	Thu, 26 Jun 2025 00:27:40 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehvya6da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 00:27:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=etPOSRv6l5UxZumC2lGnOV2W2IlFdCRayOFqMtk/BrdQhIX0qP8SMThKoA9VtB7Esb2TwEV0E+iEcagJUvs5ZWgmdhfP5kgp0AE+Dyj2eq1it4H8zgN5h4/ai507XV0pC4t5eFUTAWLTPoDpbV5B1jRakbTijzU6V48kuRwzSEkkOQ3NyKDhxi9cloFWO7HITc7+FvszR1Gbnh2qrR0P8QIM1qHPjbkTTVWFbNF6SaoyvsZx6cXpVhZdxz9HL59Wkv94DbhX0LbVTYiQRhouZmtSuX3YyED8tQxVMpUJLVErPPTBcXuMnK2Ez2Inmud20Hh/qF6lyrfLQOgvRgjoEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/KI9xZQOFp2ozfCIzrHUFPnnlvOT7pXDnOwzh/zLMU=;
 b=F7XzkfrCIjolC889nVdJe8jFe8L4VCEHxlI8mcMaSbbVdbPidq3R72+M/YzSKYEXLKRjemFWMTN0c03Z5VwRQaJsR3C0w1yUBxcxYdOcizxANvUfASAYyBm3hdyHIl7WfakClaeGgJZtHik/GRLCRFNx83xMlAdpPy/nClH8zn64zUJAWnE0z/MR1/y62x6gCnZXUggOgHrADEMzCDEXKorrmVjOAi1mMt3iB/aK+OuyL7nzEjmV+8rM8pSpqTa9MGkoEmhXqdkA9llWiKcqTd0O2TtuxtfXUY1ghoISW+KvxLN87G1rqjw5UnJkr6HyZvHQ1vximTyGw0qZ8EAA4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/KI9xZQOFp2ozfCIzrHUFPnnlvOT7pXDnOwzh/zLMU=;
 b=xKCqy08faG19dQiMWc3e3ra1nIJMQxNAVLof9dHu3ELqXJBJqNirpGhbHbD/rPp145dnxFIZugqPBTOSSUFzTOV6UXkO1RBiiQIBWuIHpsRQfpURXFzeUKonNavYT4IpUrzxz0aZKcVmNdJyuwoMIJTz7pG84GY5F5BvlRGb3eA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB7098.namprd10.prod.outlook.com (2603:10b6:510:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Thu, 26 Jun
 2025 00:27:37 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%7]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 00:27:37 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, zlang@redhat.com
Subject: [PATCH v6 0/3] atomic writes tests (part 2)
Date: Wed, 25 Jun 2025 17:27:32 -0700
Message-Id: <20250626002735.22827-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0088.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b348fd8-1052-48c6-38bf-08ddb4484063
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UpxP/+5o6mDsELNTl7aufPXltLqXS3DwWZGQGIAEbuGTZI/9Jg01Fvja1ClN?=
 =?us-ascii?Q?ZegKd3IMu/r24JdUlbuvloYPp5YApv7DvW8qCOB1VsTCvRj3AZFkhn473gCs?=
 =?us-ascii?Q?/52sWNxnDBQPtSs21kQD9eS8l6fSMJZyIJzxweoWxypGQEZTLyA31knkCzv3?=
 =?us-ascii?Q?Xs8zB6nXYnS2JPInwirKu44DGi9Xa9uR+YLJjrfxGuOZRBFpWXGvme9ECk9V?=
 =?us-ascii?Q?bhwqEuKJ7ujWE6g8tBW9fh6BVOlpOhDHpolABZ6mtb5na5pczONZ9QyZnlSy?=
 =?us-ascii?Q?FT6pKu+YnzoVCyIXwtjVmiminuDrFHRFv/JUihJxlU3JC0xbZVcfmmKKvfQy?=
 =?us-ascii?Q?3IVn6pGNIguN/l/hoRX4S8k674aNIWeVUIhjrrsLJKg2v2nK3i4HNt3o1rrV?=
 =?us-ascii?Q?xmTO4H9zqvZvWgTJA8D+qh1vEKh5WkGhy9P8XRR0N9K5LZv+9nSoFpnri9r2?=
 =?us-ascii?Q?dClFcpQiBBRsR1UVl1a8v2gvQEY6QyXr/PY5H4rVl0Ql5mGcHlhIZJ0uERMO?=
 =?us-ascii?Q?gVb0f/8Xg94913k9ahaTKB7ONkBnmP5AbUFUcsw2MCYcxRRdrZXvV3yBV1GG?=
 =?us-ascii?Q?diET97jzAebrP+FaMtk8UodfMWG5MOU+ckx5zCScpsP/ndzeO4NqxD1dlo6E?=
 =?us-ascii?Q?1osUYnXtHofZ1WSROKY4AkyPtkkpwLENugrPH19jDV7LvCz1CPgGqu2Nn6Rp?=
 =?us-ascii?Q?6LqORQIKwCr3hSfeghcJCs7QQsb/89DWXJToAFNI1JSsWq2s888sUXXP3zM6?=
 =?us-ascii?Q?FDW08JKfA9eqUSGkrKydpLjpg5Iabg5R2bhiBpgrwOIlXBwvoZCXdZ7K4266?=
 =?us-ascii?Q?NPts8iTYq1OkNDewKgroNk4FHu7TI/evGgqjV1/fy5zryRag7MWgFqt4fgFR?=
 =?us-ascii?Q?HPjb4xd7ziUtAgyiim3+/ugdZ7Y+UAcJTQjqhGLgWMsUad9+Qhjk/TK3UNj5?=
 =?us-ascii?Q?HWU/SMwzx4cyGK2IagcNgH2U8mKp2yRXxpt9dYLlxvG/w5BEtMQUyI5gTh1D?=
 =?us-ascii?Q?lf9V8r1XsRs/opzfwWxKREkA33KXXLSuVGJfyymckvkXYXvIqPBNgKf1+rgj?=
 =?us-ascii?Q?ABrJpOaXPmpbyoUh2obukbalMSz8qN4SV2mNYZXw4s5+VMoVuZ/Y2sa0Bxay?=
 =?us-ascii?Q?cMtO2Sy2/f1OIWCyjR6//c5k2nIhHvnpb5HnTbuNeVGYn/XqlU+qij3NlFv/?=
 =?us-ascii?Q?0Q+zKAF+a8pyBgys3aG2mN0rgl5M8dlnI01i+7S1VN7NA8o95e9XYw/IhdSA?=
 =?us-ascii?Q?aPHtfzb4XAEUOSgVclJYiJVo2ATftzRFw94lW0cmNRr/Ydfv9PtfBXXhQj2k?=
 =?us-ascii?Q?0FgrTcLZyAOnbwnaUfaYBqZ4wHiplQxK5PQbhaZu4JJYedNuZEHJsduLHjgE?=
 =?us-ascii?Q?S1mushV6OfnfUqkXPio539xfB7EJbgeJK+7qQboSgVWliGNb9IBp4qfsHtsm?=
 =?us-ascii?Q?MGUPGoSRF9Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+1dqw8XOMoA7vwJdFGyqxX5q/8WyZzTL0Kco6hA8Z/G4htISCGF7j1ylMtn8?=
 =?us-ascii?Q?ty9sKLjt+tAR7pqs+wxrewDxArlYRmcWkU7SQWW+iLq5WbYpeSAZPTezGTka?=
 =?us-ascii?Q?+qnBeQFm4OCRhz5u00EBspQAykYAg+s2gI4GdbLWjuNBhkAjYWTfBprbVZiu?=
 =?us-ascii?Q?IBU8IQa0rvNhOZk8J6cyz4mUay8x4xyPJCLEeKRq5RVyRqSQyzoY47j8fJGv?=
 =?us-ascii?Q?Qx2wDEqtZMjELCRPvroHTR9B8uNtyQV+sg905171RlIxqFg7IICuGiSI4zxl?=
 =?us-ascii?Q?tyy+2FFMHa/mD4UJWaCn3VTO7DYc0hMepRSePbcA1Ctn10bipUNiEzFw9vne?=
 =?us-ascii?Q?UAN26aPHH+4JmPSsgXyQXlJARPJYp2Bqj8EhoN2klzpeiATgd5l8UKzfSr1w?=
 =?us-ascii?Q?b2EedeoORCPUfATcRBk5DfuX3ndj9jSSJNJJmpO05xScbApijTQr7EjKBjkc?=
 =?us-ascii?Q?kVL0v3AXBj+22iDqnP64PpSYlLnkqoo9GDERRUhzzE6FueX7ftefkQNqXCuZ?=
 =?us-ascii?Q?z81ovNu6+N2onreW+ntellbb4zJ9IVgNURFyxcSywCxPb+lUasNHi5imyYzw?=
 =?us-ascii?Q?eUys36DzBAx6y3ciRCOev1XYjw38sgHlLIzaAcFQPi2nmFvz1wXfFWn40riJ?=
 =?us-ascii?Q?/9KeDY8a2zcv3dS5vVOTnGMdpMbaV4pX0O9YGCeYOQa4ss+Kmm4dsCzqR6a8?=
 =?us-ascii?Q?ezZO6/0esEGIqL4TKJdmiuL90UBPt/KhJ4ZxxAHKxoCxKKNdI3PvgMhZEHB0?=
 =?us-ascii?Q?T7nxZHkTDYJCOPlEJ20Qt1kZRbhaqvioA78sr53IUw2/NXGVky6aca3EIHME?=
 =?us-ascii?Q?RlQC6LUQVinra/0xMhWPQZBzMp1+6UUTqVGsKpuflTs9slhBNgrDUyNxFaK2?=
 =?us-ascii?Q?LTS0hCQONm3i704sHJj51QS0cZdy1zmRRSJpivH1xZzJVoBDWNjVsFlrKD8m?=
 =?us-ascii?Q?qKKehoTsTSoS4JPjupRPatpyVS3ibzaAB45eXe3oaI5S6DiAqKFh0+iH6Epv?=
 =?us-ascii?Q?e1rUvCeJsJ3VH7hRTAHXlsU1kMc3juvcb3li66eqRs2ZQLPNh1O2ETeO5Ve/?=
 =?us-ascii?Q?fdqvSBaKyjgncgPrJeZBwcrxS6Spv5GyExeNANKohFrjatwrKSJ44NcI2EPa?=
 =?us-ascii?Q?wyYSU4Yw9sDZB66QuJicHGT1rAE5ILVdlGlmWKprUaZVjgervZKp3V/2mMfn?=
 =?us-ascii?Q?705nKbO4odWr/8RCwPhgiizT8WjGI8nb2n8ZZkRzRtWyRksQm2g1VYNyuzYI?=
 =?us-ascii?Q?pdxH5GWSj6bHdeq4gQOBAb3k1JRYKvEOMNaKe4j/BdybmhXcLBHdZk/h6LTA?=
 =?us-ascii?Q?w6xviaw8fUUCI3Y1jF6k4zuW4KDhNdR1BiynnGA2wVsQeqJlV+UWFvJzzy7c?=
 =?us-ascii?Q?WReOP40atZXDcZ7s/2m7A0kxWQ8UL11YS4DXEd/oZope+NhcCZVD+u6k0wMv?=
 =?us-ascii?Q?sQtQqKIx70uSQYAYkWsUfcpZqaadMG1WV4nohA9kQpDNliTSBJHYCsZiLUoV?=
 =?us-ascii?Q?hlk/KOZI1pVEqUXdaP2rEMR6a2cIm+f8xZxqhq84pAo1SqLkUkkq4s2HNIaS?=
 =?us-ascii?Q?qe1T3WpC7MxP5sa/vjjt8qcI0hdhCuCbz0acObLGF0+LY+KMoPDr33t/Srys?=
 =?us-ascii?Q?BuuLsDglIZjudi3XopsxfUqQ7U1yW8S4Ez69fYModdD8Bh60Hi0Z4mtmtN9m?=
 =?us-ascii?Q?IUHMZw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t+p5ktSgYVW78t2i0ywCsO3BduYqzQSLyByrkiOVb5VI61kDxslqCWvEPlbqR69QeLW5guByTUInPhnu6nNqr1myIOwca1ph+XQf55KU1dH3gsTLGbqyfk/vb7MzYfKLuEukc3ivOVhJkCu+LKmsF0cfhqdHTz+WfAmjHiRn7KZZMqV5sOwCAoyq99kxA45vf1kzqKq7xA7fXk/n4gLIUFEo9i2eFGy7fqi/ZZyxMFcEi5NN8X7LPmR7bwSfLfz/aKq+7T9O+WSJ+PF4KQ9QD6UzgAt/Q6VlJ6S93W/V2JFgb75IsnWxem4Ar2Xpe3yLYPnn4uKXQ+heeFRUDnGVfduS3eZwBE2uZgQZlG+EMyqy2os9tnQAyLTwIQqLTqt6Rxorlz08oSL6KDrNfCF88TZDswGuAQveTVn0Qux3LwXbtWKxq4nLqh++T6eIrgT5a0AEbxnf72o5RlKOWM5OOl/XmSAxfNsByHu4oxY4Up6yGPC8Q508+4PaycqFUctD08ta+qfThPKFmuBK8jHTwqRvXduPS7vkQDPOl2hvkWzBcF259O+xXjS52gyf3ItL6Aplh72VBELT8Sa2r4fZhCtjPo/UePbInTW9qzinlUo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b348fd8-1052-48c6-38bf-08ddb4484063
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 00:27:36.9721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZGmcXrHtuKpLynqjIBqTPM2VSWzZ303Mu741aC0GNXbAlHTxZp6edZvuQ9LtVoGZQTO7FiISmcZGpd9kFn1Hbb8g3Km7bxLrGibr0OcsQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_08,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=902
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506260001
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDAwMiBTYWx0ZWRfXwnpr/uvouhHs lQBHXQWwjEx4UHAvRt4ToL09PagNtj20AD5J5hkOF3PfbYtfB369C3nD/y9ozOOEAwGfzGKUR1e o+kOXs7yCkenT3tDHKY3ypHTTR72wA3aUht/79N/LmaeYqe47aQ+7X7OuINBR4proXImMV6kJqW
 ViteasX0AEOtbe+94PQPIDhJZc1QI2L2m2a7zj79iI9JGw2VUpSHKAhW2GaR9tLMnFv+orHMHjr 8MaNeMENB13PhDjmgrtI2W5xn19m04/4WDlXbdFDvFK0++cLEsxFCWgZzhT3YWtjGUtgcNIOUw6 wtBsmV0rLLoK+IevO+qQ1CLlcf+PV8cvEjmYiOe2O+ESJorWe+RWQmbqkM1ZATF5XorrNm53Q7N
 JUgMsDK3j9XVwqOWG/eoR8lxwhAMrqZxYIBPT7og0NDyxRi3cc7M+c3nCzLS5mBwpOQOUDdR
X-Proofpoint-GUID: hx_e6RlyJZZgzqxU1YSML6Us3W3KPisK
X-Authority-Analysis: v=2.4 cv=QNpoRhLL c=1 sm=1 tr=0 ts=685c93fc b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=w7pnA6AedPbFYpVsrw8A:9 cc=ntf awl=host:14723
X-Proofpoint-ORIG-GUID: hx_e6RlyJZZgzqxU1YSML6Us3W3KPisK

Hi all,

This series contains the tests from patch 6 of the previous atomic writes test series.
https://lore.kernel.org/linux-xfs/20250520013400.36830-1-catherine.hoang@oracle.com/

v6 includes updates to test requirements and picking up rvb tags. 
This series is based on for-next at the time of sending.

Catherine Hoang (1):
  common/atomicwrites: add helper for multi block atomic writes

Darrick J. Wong (2):
  generic: various atomic write tests with hardware and scsi_debug
  xfs: more multi-block atomic writes tests

 common/atomicwrites    |  31 ++++++++++
 tests/generic/1222     |  93 +++++++++++++++++++++++++++++
 tests/generic/1222.out |  10 ++++
 tests/generic/1223     |  68 ++++++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     |  88 ++++++++++++++++++++++++++++
 tests/generic/1224.out |  16 +++++
 tests/generic/1225     | 129 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1225.out |  21 +++++++
 tests/xfs/1216         |  69 ++++++++++++++++++++++
 tests/xfs/1216.out     |   9 +++
 tests/xfs/1217         |  72 +++++++++++++++++++++++
 tests/xfs/1217.out     |   3 +
 tests/xfs/1218         |  64 ++++++++++++++++++++
 tests/xfs/1218.out     |  15 +++++
 15 files changed, 697 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100755 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/generic/1225
 create mode 100644 tests/generic/1225.out
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100755 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

-- 
2.34.1

