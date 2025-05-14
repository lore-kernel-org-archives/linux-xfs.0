Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4722C859;
	Wed, 14 May 2025 00:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747182577; cv=fail; b=qaumqWpmJmeoSKk4uqIXy4Vp9KC0O9SBkRNu/m7ri7e73I8mCEMkogLcHnzNuPlnLK72pdb/SYdH7/a/8VVj55sDUc/wt3T6StQnnFN34YPVYFXJmhONx2LGG0T7MAqCd5S/r2iZPgonVIhDzcnf70JRW+Qlvay2iyuljVllZKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747182577; c=relaxed/simple;
	bh=EXlNvqsvrMuhiYrcrYxV/AK+P8RZnZIWE30gcHHYeOg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tcQ2XG1Heypq/7EheyBGC9XjAq/8w2lcN0p3Ui3woyh5gwXcRHUWVX3vkflBSjcQ8tbVh8f5nMUN9e1LalaiyaZQBIohIU0ysuBDB2yFx+rxSyZgM4ma314ghhr4MyL7zkzrQV3dKeGvd1g9oNUHuZGV/OO75aTQ6pXynSNzJdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jcWEx3Dj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L1B4b0z0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jcWEx3Dj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L1B4b0z0"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DL0mih021639;
	Wed, 14 May 2025 00:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LwAAPVZNdBMsBmWCSGMiKNFTMYTHghpiV7DbUTHeXoI=; b=
	jcWEx3Dj0w7GbjIOPSMwP1uSd7aUb1civYM0H1i0fLZnMCEKG2E0hgZSYWCvHOB7
	Xi2PvJ4rDAkfhGWSki6/isHGtC9AB3Cbe3WUY5YNgQjMCIaLqpysRSi9bC2czy51
	PhFanBoRG+onNGnP5als9HRkMlGnKW1koYVo6POg4JzhUk7E+82dWTZkqazmyHS2
	unRZSTeIZioKk2vh6WJ+xXRX9feN03FnMN7rgxsKtruslAji6yCYSdzXrNy4MNDp
	a2PhWK0CH8tTD74HqfWBVkrWTb0ZdWxVSIB3xPfCUOejoc9kgubEn2tFuTxJXdhH
	N/nfQqvFE+ZFscoElUeohg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcmgg56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54E008Aa009042;
	Wed, 14 May 2025 00:29:30 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011028.outbound.protection.outlook.com [40.93.13.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mc6w0y9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GIWfhkle/40pas3QVXwsyLK+D0od+OGaaSibxAGmAukkStdeR5kC5XXrY7m+5QJRClnU4UAKH8RD15zD3VSo8/zr1C6sz/MuTAHhHgxNwcNCcO5vkrHNOX1OCrU/EIjqOXslHmO0MOMLsaXRsR8wTQAkZYmSt3flMArd1qvb6H33Oe8beccZZhEA0amvbYZXpY0cVzj9zhcfG/suTgB7DT+vIx6ExQvYsoSjBm6FekabSFeqFvWjAxMvLwY4RezR1BtmqlDNT7KrMIK1si1fgtzBLjtcU3Wo4YHc81rUCuCQqdUkRh/OX/fDbxD4cr08KgdSYTAGhVv1TQJv1wSfoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwAAPVZNdBMsBmWCSGMiKNFTMYTHghpiV7DbUTHeXoI=;
 b=u7lZ93Cri73+SKc043j90ijbi+X1CVzNFqPrwQbj3yUspiTxYU++/UmuLDItI/AzfJHgrzpMGUDgPjfIF8qeui/KPh67HbZNmzOS8Qg1O/bQC40waUmDVEhLVIwAvqED6Pk8sSagfy/1eCH9C/nT/nO5WqKij0FPvC1R5s+oKFrzGK5/0z++KBgb/yCHAnoKL57TQ/5wxOAckgotLBsq4aqcniT5sOrRSOgP28qwMBqPfcXG9h3ug5Rso5tuBYgWBIEK0vXFzXQo9+JgchbluaEEltPrM5QJ+77LSUQxn2OOTsK6Ax2qm/e7yFzlv4cxUpNQRB9aw5LCmJbHTslNJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwAAPVZNdBMsBmWCSGMiKNFTMYTHghpiV7DbUTHeXoI=;
 b=L1B4b0z0gTvlv+oEqJlob7iyj9Wrx8YSBS9SSv0lcbKwYYeKlxv6MM4ZKNak3kC87xPngo2TjOSzZFF+GNf3XUoG85pMfUk+jDx1AO84cYlXGLIjfHBhChhiWJrdzhnW6YuWDepQIDRUXB7AmXrS3ImkJpPkb46D80pe2bLcIfg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 00:29:28 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 00:29:28 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: [PATCH 6/6] generic: various atomic write tests with scsi_debug
Date: Tue, 13 May 2025 17:29:15 -0700
Message-Id: <20250514002915.13794-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250514002915.13794-1-catherine.hoang@oracle.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0382.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::27) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: 757c27ad-5a75-4120-24ff-08dd927e6301
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D/xkTMRHUWBpSaa4jwHmC5RHZtAXZAAo0/w2J+YzLpdel8KHYpjnNgbe5iI7?=
 =?us-ascii?Q?UZgMj1cEypsvQcMPAOKBoUoIs5Nq+pV2d2wPemzOGZjmSDiCY3Ke3Qv3VLGw?=
 =?us-ascii?Q?nz1KBrefyoIJ/oMEmHSHNWV5KnFUzVWmEv7BBI2eo2GQw7/jP8DoHt33csKW?=
 =?us-ascii?Q?CdsDUxjn/caGnoX1fsatUMzWngxZcEaqwttkvJw5/YGjZngvijqfePboLoh6?=
 =?us-ascii?Q?WpGC7GqP/AhitzxBAVAEq03qJc5/Hwme7iH06xDkCwrqLMzsG39mhSZWswB2?=
 =?us-ascii?Q?uWGUrqlszWBoO805t11FrQqyRk/fhZvKt6LTG9m2V0ykqNieshmuNtq8cH+X?=
 =?us-ascii?Q?NMpgFGMNukyrZbeRmU8dW+3GybfgDoO9rkrZ9TgRlU94G4rr/m/6FnKynh5f?=
 =?us-ascii?Q?6WX7MeopmH36Rr+KYyd4kLLBZKDo/gcVkcJZwZmGE1q8IiBHqN00GGdr5oNS?=
 =?us-ascii?Q?cit88PfeLOLmv2Di0hJRM+z9tFgwtq6GPCF4dAtDwRkEMHIiHIZvdwyA0D36?=
 =?us-ascii?Q?nLzIr227ef+JcwTe1kB3hWJogzBjwP7NjeoZVvbDLeTTM0hl5naqzFBi0qHZ?=
 =?us-ascii?Q?626NgtgsRon67IUGMQdkQ7g/eWcVwdWWlfNMD7QIxYoqgealCBrFBwgm3IMW?=
 =?us-ascii?Q?+RHkDdZozh7xJadhNrFrpQ0KGz4OwzALUBRUPn3mjxL5852+ggkKuAthnUGj?=
 =?us-ascii?Q?cvfkbxP3iGoAv2sViZntL9Ai/b4yvnhUS2du2L3+M8uMkn6IaSMLysd9lMnG?=
 =?us-ascii?Q?7HknmbZrEMqoz4vmAASe+1ukYlmizmXZLcrprodmYZs2iW5FxaW6rb2qLBsY?=
 =?us-ascii?Q?qr2SX24mjuz8F2Do1XRqQv98MV+pMfw/tQFsHv4h7dA8BCs0gGuRJKrcoQKK?=
 =?us-ascii?Q?cNg1L/0W74I8t5UnWFFBhK9bSwqe63tZIYZ9AMw7KpX1MNfkG+SUSQQf5UYx?=
 =?us-ascii?Q?0/zrFu8mEIotHX5XGmQCV3lOsH41c0SbD2G4PkSSveQUbTotijPsC1DuAEyY?=
 =?us-ascii?Q?eQ+yTE57vSHgDLVLztavgk+KxzSZLZ40GnscuAYzM/dBKXSHEgSyg6mF0JUk?=
 =?us-ascii?Q?hV9BJ1CBk0H6ulV/7+pshDwQ86iWBC1ecmQjpMMVKLIYgu+Hyl0xzUUs4wc4?=
 =?us-ascii?Q?8zh5yppwr0SGW0CH4bX1JhRNIda4/c0v5P1JBWRXakOprDDOVVr/yUrdcg66?=
 =?us-ascii?Q?8BpSAYrJANvPLdlHuIPVq12FV54NfFWcwQuslBrV2RqLgsrPSYRY1XukY/4y?=
 =?us-ascii?Q?lYtqWBt7qllCVIQqzO33okN6SuU5+M8ywAuq4EuskkIHkfBGG/wJSsO0MtcY?=
 =?us-ascii?Q?iVjBbVupoANNLoRYW3xnAAXx8CeshvcdrWPsTdBCcuPUe6BSwJkJTeyZ+MI6?=
 =?us-ascii?Q?kRafBsLOnIWJBkNc1eGRVMEiadxaZ9w2l1ZTySuCqfaR/MG46OepulcriLXI?=
 =?us-ascii?Q?1TrkIDNbY6Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HXSIUrHc9/czLPjuesWxulXsgqNt7IXz6DLOnHge8zkeDj2rsTtsi6XM/8px?=
 =?us-ascii?Q?gWDe6LveC+VhxaVP/4dGPKvn/vzSFpe00Ez8gvylbYCLytS6fAT9ZelCYvuR?=
 =?us-ascii?Q?VH28zIPJNpoeSWQhUnzoTb1YZeTedFmf96UX0UxIeyVO9E86UE9YUUq/2Ppv?=
 =?us-ascii?Q?gPsXrKOJ2Yn92M8XAHkB4e4BvnIZK4ca6LkdcTzflDG0Z2BHozts8361F/o0?=
 =?us-ascii?Q?KgwN1sj3uBrWdV/1ECgNHTPO6cvWX4UXwA2VnnPGKASCVZ19oU3y6zRHTr6E?=
 =?us-ascii?Q?BjgZ7I9wzbs7ZB848ca3b4LZH5L9K+s2CzsxiqgYNCz+Ct2xiUfBaTRxgazf?=
 =?us-ascii?Q?1UZkM4k1kfT4vZHEn8dr/RIcLT7XCn1r49dHl7jgMxNdthcNqEwmf7RsPNfq?=
 =?us-ascii?Q?atIvrTkNOG9P4ZrldTErhYPD2RgfonHXrfbwXNjBCV5qdUJeDu7FeyEfM4DO?=
 =?us-ascii?Q?0FxC+Ph67F+mMeJknoGgm3Aq48JSRAXpMinULW5fPYNZJOq3ymV2/0Zl/9vd?=
 =?us-ascii?Q?FG2ssiI5HfFg81LxsgMF1qZmHiOkPetUD/LejfyaQ/hheHCGzC3sm8srEVuy?=
 =?us-ascii?Q?6wcwOusJ9PWrFnTJm7QGBN8dOb4xEU3dkj1tNe61bVEhkJDVKyCTLMUa2GPE?=
 =?us-ascii?Q?5JKS+B4+L7Xbr0BKBdU/ZWwPDoOf7G9x1dW1nPUk33T2Qv1tw9tdW70F2mJ+?=
 =?us-ascii?Q?j0siuURr+lJ34g8wz05SYKjwaEwHHO7IPwWTLIJOhSikQSKSIYj5gVyO3FaO?=
 =?us-ascii?Q?w5ZTIh04gjPJGUDsIz+DaCSLldx3adfehEOMYf3FCkj1Q+kWa5y5ay2rhHoz?=
 =?us-ascii?Q?dJpL7rELd7YT/bC+XL43QZTFrpKflIziz14ktAj5jT3PFRA8hN5Ql92mZ6vi?=
 =?us-ascii?Q?DhFgZFS6LFbelH0GEIOftuW5oflqB4Em2iPnIGo8cnprl6/wInKc7Thp0P7K?=
 =?us-ascii?Q?EuW7o8Pmd2sdHfF4DYmWsWtX1wdnO4wXoyKySaRAypW+6FP/FOmA3fMfLlgj?=
 =?us-ascii?Q?GGi0QDNqg/YcHxbN3yla2Vg6/rSZ/wkybhqzN1LKwiuFsN7LY9pPPFlFmvvv?=
 =?us-ascii?Q?GwdB/jXt1EuOmQp0GdGypVluJNp8ZVOIwgFJCxBNjMJFUM9f49PiSP9U6HDT?=
 =?us-ascii?Q?BqEp6axefyJVSOFWuk1BLRYyzXxUbsrpvUpSxA11lfOTPH1rDilFY0Fz5BBL?=
 =?us-ascii?Q?tLhghuaSQf2gnBBG8NrviN22I7gVfV4jCdXnts3Czr/mwo+DBJ/jYAWfZaSQ?=
 =?us-ascii?Q?8V2xZl0YU4QvW4ONegAwwwvep1LtNyv09Ht3wHcOUcx5LbmNFgXnYWctTZkN?=
 =?us-ascii?Q?0l2rBK9nP8dbgr6/AEiJBJJeO/kUhqXQiizHVT2FUzh9XZH6g0hHYxAqj6+1?=
 =?us-ascii?Q?69r6lk5rmo6E+M7N2mBL3W5zNmzIssVV/jdxPhvMxPzn7+4xBNG6P6HDLU8+?=
 =?us-ascii?Q?CpoTaVapo+RXLUVFGyksv8LJgNyhV8rU9pOnSAqLdjKgjAuzq0ngFQDz09Bh?=
 =?us-ascii?Q?u9I1TxUj+GQgNNzqHL2p/Lq72sausUtCPRFBb3k9wS/zZ2gm8T8LZ1GP+ewU?=
 =?us-ascii?Q?FEGPUqH5aHnASAmeCxnQdJBM8taqpDbJzG8UAY/Bf5zY3f8+QDqLJvKb3drI?=
 =?us-ascii?Q?M1vKZs3iT6RNNXveMKLAeuNRUw3tA0/oKjcShl80o3Wwy0IR73+vBALZQMCN?=
 =?us-ascii?Q?3aHztQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ERUwZ/bthkSY3dSADCKMvWLYA+kboI0byTix6/bQWPEhO8AOMD3KodGCSOBf3tZTNXZq95oPkNUNw2ynAYoOvyHJrETIWout/day91DAbXVO1rH7rc+mWN/qneXL6v8zf6OEVvbfO7l8CpGiPxYMaktqp9Ae7bOFmWVSjhF4U1xf2dVzue9Ldw6OYBeaaHlM26GaVPIniuN9AsWQq+06wB+iJskQkqCRx97GTDZwQBo2PwjqkkImWUS1yhcoGrFDEwrH4+9+SOoM0eHpNKFH4UOriUe8HzAn2MH9yfkdymuE+1IxxgjfBwaWczvmG9agE1FQpyq77mC5i4XYqNhs6OlOadSQFuu5XsEWhQ+Nkn9UB5xAy2b7DMw093z1WeKg5O/3y7PhfjMJsbZfyHy4FHCHjT3jE0+5MNhLHgEtJZB7rMx0v6xGsaDE5Zw7tlOE3H6WfjwWTcpTt1bUM/yiZGxo6B8Z7lekzA14c2sstt7S+/r4gWXuX6yBWnWWk0O2NOgwyn+hhu7hQfS6xfSm/Xvku0UBQgCTcqNiJ1DOlrCnXfBvrTWxmzGCaTZUg1zLCJFhKxFENX49jU3mHz5TzqIuDR0SinoTiPk5vTUYlh8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 757c27ad-5a75-4120-24ff-08dd927e6301
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:29:28.2897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZTZPAZGkEVTtdF6GFsWL5MGQt8Qqouz5lY6JB4BVpPr3TxHNPZ3IHk00OzobD0GlG5u2s7cJGvue4dpRq1DZx2XyhFqxcZk63uko81Lzzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-13_03,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140002
X-Proofpoint-ORIG-GUID: nlifDu8p8rgu_daxcnmrRD3wrIxpjxLz
X-Authority-Analysis: v=2.4 cv=f+RIBPyM c=1 sm=1 tr=0 ts=6823e3eb cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=idPzuIYAg1aY4aPBm6oA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDAwMiBTYWx0ZWRfXxLZ0qzasoH0F ujJhztwxMVXRsncyDbGYLJo7c69/Q0h8f5trm91ZWP40+TQLX8kq2yOI6GEwpoM84jDzmqqXU61 s/YqkvnwFLvi4gYQ6fjgtTlOgakmZ0d0fCYhnkvubpWIys9KOnTmMpd3Iw6h9lfCUk0+eaR1lKP
 S/QsTZ2uoY7BqmJX5Y4tYkJE1zA6zwv9BtEvivXgOR3Mhf5G/9LRq3aYHOStqh/D6LdO8+ekhIH nYetBiKvkSBb9yHKLwnoEPMEs2Evfx5+f9VCM7JExzG9p6K9ME/bbQNmsViC9mIgCGDc15i3djh CHwavexD53L3ovKNFc+bKiFT5x2OoV2AezStn2Ws9VhtceeqrMIi1AucHag2Ybo2B+fCeYaF3iF
 kW1MvRyqMbnMEpJ60feP+efRhQpoSeIZKgZbtvpVsvdodLO305C2MRoW3TT7z+PUFMPctm0j
X-Proofpoint-GUID: nlifDu8p8rgu_daxcnmrRD3wrIxpjxLz

From: "Darrick J. Wong" <djwong@kernel.org>

Simple tests of various atomic write requests and a (simulated) hardware
device.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/atomicwrites    |  10 +++
 tests/generic/1222     |  86 +++++++++++++++++++++++++
 tests/generic/1222.out |  10 +++
 tests/generic/1223     |  66 +++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     | 140 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1224.out |  17 +++++
 tests/generic/1225     |  51 +++++++++++++++
 tests/generic/1225.out |   1 +
 tests/xfs/1216         |  68 ++++++++++++++++++++
 tests/xfs/1216.out     |   9 +++
 tests/xfs/1217         |  70 +++++++++++++++++++++
 tests/xfs/1217.out     |   3 +
 tests/xfs/1218         |  59 +++++++++++++++++
 tests/xfs/1218.out     |  15 +++++
 15 files changed, 614 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100644 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100644 tests/generic/1225
 create mode 100644 tests/generic/1225.out
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100644 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

diff --git a/common/atomicwrites b/common/atomicwrites
index 391bb6f6..c75c3d39 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -115,3 +115,13 @@ _test_atomic_file_writes()
     $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
         echo "atomic write requires offset to be aligned to bsize"
 }
+
+_simple_atomic_write() {
+	local pos=$1
+	local count=$2
+	local file=$3
+	local directio=$4
+
+	echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
+	$XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
+}
diff --git a/tests/generic/1222 b/tests/generic/1222
new file mode 100755
index 00000000..9d02bd70
--- /dev/null
+++ b/tests/generic/1222
@@ -0,0 +1,86 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1222
+#
+# Validate multi-fsblock atomic write support with simulated hardware support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/scsi_debug
+. ./common/atomicwrites
+
+_cleanup()
+{
+	_scratch_unmount &>/dev/null
+	_put_scsi_debug_dev &>/dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+
+_require_scsi_debug
+_require_scratch_nocheck
+# Format something so that ./check doesn't freak out
+_scratch_mkfs >> $seqres.full
+
+# 512b logical/physical sectors, 512M size, atomic writes enabled
+dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
+test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
+
+export SCRATCH_DEV=$dev
+unset USE_EXTERNAL
+
+_require_scratch_write_atomic
+_require_atomic_write_test_commands
+
+echo "scsi_debug atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_DEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+echo "all should work"
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+	_simple_atomic_write $i $i $testfile -d
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+_simple_atomic_write $sector_size $min_awu $testfile -d
+
+_scratch_unmount
+_put_scsi_debug_dev
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1222.out b/tests/generic/1222.out
new file mode 100644
index 00000000..158b52fa
--- /dev/null
+++ b/tests/generic/1222.out
@@ -0,0 +1,10 @@
+QA output created by 1222
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+all should work
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/generic/1223 b/tests/generic/1223
new file mode 100755
index 00000000..8a77386e
--- /dev/null
+++ b/tests/generic/1223
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1223
+#
+# Validate multi-fsblock atomic write support with or without hw support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+
+_require_scratch
+_require_atomic_write_test_commands
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_DEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+	_simple_atomic_write $i $i $testfile -d
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+if [ $sector_size -lt $min_awu ]; then
+	_simple_atomic_write $sector_size $min_awu $testfile -d
+else
+	# not supported, so fake the output
+	echo "pwrite: Invalid argument"
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1223.out b/tests/generic/1223.out
new file mode 100644
index 00000000..edf5bd71
--- /dev/null
+++ b/tests/generic/1223.out
@@ -0,0 +1,9 @@
+QA output created by 1223
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/generic/1224 b/tests/generic/1224
new file mode 100644
index 00000000..fb178be4
--- /dev/null
+++ b/tests/generic/1224
@@ -0,0 +1,140 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1224
+#
+# test large atomic writes with mixed mappings
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/filter
+. ./common/reflink
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_xfs_io_command pwrite -A
+_require_cp_reflink
+
+_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
+_scratch_mount
+
+file1=$SCRATCH_MNT/file1
+file2=$SCRATCH_MNT/file2
+file3=$SCRATCH_MNT/file3
+
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $file1)
+test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
+
+min_awu=$(_get_atomic_write_unit_min $file1)
+test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# reflink tests (files with shared extents)
+
+# atomic write shared data and unshared+shared data
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# atomic write shared data and shared+unshared data
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# atomic overwrite unshared data
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# atomic write shared+unshared+shared data
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# atomic write interweaved hole+unwritten+written+reflinked
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+blksz=4096
+nr=32
+_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# non-reflink tests
+
+# atomic write hole+mapped+hole
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write adjacent mapped+hole and hole+mapped
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write mapped+hole+mapped
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write at EOF
+dd if=/dev/zero of=$file1 bs=128K count=3 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 262144 262144" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write preallocated region
+fallocate -l 10M $file1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write max size
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+aw_max=$(_get_atomic_write_unit_max $file1)
+cp $file1 $file1.chk
+$XFS_IO_PROG -dc "pwrite -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
+cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
+#md5sum $file1 | _filter_scratch
+
+# atomic write max size on fragmented fs
+avail=`_get_available_space $SCRATCH_MNT`
+filesizemb=$((avail / 1024 / 1024 - 1))
+fragmentedfile=$SCRATCH_MNT/fragmentedfile
+$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
+$here/src/punch-alternating $fragmentedfile
+touch $file3
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
+md5sum $file3 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1224.out b/tests/generic/1224.out
new file mode 100644
index 00000000..1c788420
--- /dev/null
+++ b/tests/generic/1224.out
@@ -0,0 +1,17 @@
+QA output created by 1224
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
+93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1
+27a248351cd540bc9ac2c2dc841abca2  SCRATCH_MNT/file1
+27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
diff --git a/tests/generic/1225 b/tests/generic/1225
new file mode 100644
index 00000000..600ada56
--- /dev/null
+++ b/tests/generic/1225
@@ -0,0 +1,51 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1215
+#
+# fio test for large atomic writes
+#
+. ./common/preamble
+_begin_fstest aio rw stress atomicwrites
+
+. ./common/atomicwrites
+
+fio_config=$tmp.fio
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_aio
+_require_odirect
+
+cat >$fio_config <<EOF
+[iops-test]
+directory=${SCRATCH_MNT}
+filesize=1M
+filename=testfile
+rw=write
+bs=16k
+ioengine=libaio
+loops=1000
+numjobs=10
+iodepth=1024
+group_reporting=1
+direct=1
+verify=crc64
+verify_write_sequence=0
+exitall_on_error=1
+atomic=1
+EOF
+
+_require_fio $fio_config
+
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+
+echo "Run fio with large atomic writes"
+cat $fio_config >>  $seqres.full
+run_check $FIO_PROG $fio_config
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1225.out b/tests/generic/1225.out
new file mode 100644
index 00000000..81e4ee0c
--- /dev/null
+++ b/tests/generic/1225.out
@@ -0,0 +1 @@
+QA output created by 1225
diff --git a/tests/xfs/1216 b/tests/xfs/1216
new file mode 100755
index 00000000..d9a10ed9
--- /dev/null
+++ b/tests/xfs/1216
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1216
+#
+# Validate multi-fsblock realtime file atomic write support with or without hw
+# support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+
+_require_realtime
+_require_scratch
+_require_atomic_write_test_commands
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+test "$FSTYP" = "xfs" && _xfs_force_bdev realtime $SCRATCH_MNT
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_RTDEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+	_simple_atomic_write $i $i $testfile -d
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+if [ $sector_size -lt $min_awu ]; then
+	_simple_atomic_write $sector_size $min_awu $testfile -d
+else
+	# not supported, so fake the output
+	echo "pwrite: Invalid argument"
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1216.out b/tests/xfs/1216.out
new file mode 100644
index 00000000..51546082
--- /dev/null
+++ b/tests/xfs/1216.out
@@ -0,0 +1,9 @@
+QA output created by 1216
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/xfs/1217 b/tests/xfs/1217
new file mode 100755
index 00000000..012a1f46
--- /dev/null
+++ b/tests/xfs/1217
@@ -0,0 +1,70 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1217
+#
+# Check that software atomic writes can complete an operation after a crash.
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/inject
+. ./common/filter
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_xfs_io_error_injection "free_extent"
+_require_test_program "punch-alternating"
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# Create a fragmented file to force a software fallback
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile.check >> $seqres.full
+$here/src/punch-alternating $testfile
+$here/src/punch-alternating $testfile.check
+$XFS_IO_PROG -c "pwrite -S 0xcd 0 $max_awu" $testfile.check >> $seqres.full
+$XFS_IO_PROG -c syncfs $SCRATCH_MNT
+
+# inject an error to force crash recovery on the ssecond block
+_scratch_inject_error "free_extent"
+_simple_atomic_write 0 $max_awu $testfile -d >> $seqres.full
+
+# make sure we're shut down
+touch $SCRATCH_MNT/barf 2>&1 | _filter_scratch
+
+# check that recovery worked
+_scratch_cycle_mount
+
+test -e $SCRATCH_MNT/barf && \
+	echo "saw $SCRATCH_MNT/barf that should not exist"
+
+if ! cmp -s $testfile $testfile.check; then
+	echo "crash recovery did not work"
+	md5sum $testfile
+	md5sum $testfile.check
+
+	od -tx1 -Ad -c $testfile >> $seqres.full
+	od -tx1 -Ad -c $testfile.check >> $seqres.full
+fi
+
+status=0
+exit
diff --git a/tests/xfs/1217.out b/tests/xfs/1217.out
new file mode 100644
index 00000000..6e5b22be
--- /dev/null
+++ b/tests/xfs/1217.out
@@ -0,0 +1,3 @@
+QA output created by 1217
+pwrite: Input/output error
+touch: cannot touch 'SCRATCH_MNT/barf': Input/output error
diff --git a/tests/xfs/1218 b/tests/xfs/1218
new file mode 100644
index 00000000..f3682e42
--- /dev/null
+++ b/tests/xfs/1218
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1218
+#
+# hardware large atomic writes error inject test
+#
+. ./common/preamble
+_begin_fstest auto rw quick atomicwrites
+
+. ./common/filter
+. ./common/inject
+. ./common/atomicwrites
+
+_require_scratch_write_atomic
+_require_xfs_io_command pwrite -A
+_require_xfs_io_error_injection "bmap_finish_one"
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+echo "Create files"
+file1=$SCRATCH_MNT/file1
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $testfile)
+test $max_awu -ge 4096 || _notrun "cannot perform 4k atomic writes"
+
+file2=$SCRATCH_MNT/file2
+_pwrite_byte 0x66 0 64k $SCRATCH_MNT/file1 >> $seqres.full
+cp --reflink=always $file1 $file2
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "Atomic write to a reflinked file"
+$XFS_IO_PROG -dc "pwrite -A -D -V1 -S 0x67 0 4096" $file1
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_remount_dump_log >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1218.out b/tests/xfs/1218.out
new file mode 100644
index 00000000..02800213
--- /dev/null
+++ b/tests/xfs/1218.out
@@ -0,0 +1,15 @@
+QA output created by 1218
+Create files
+Check files
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file1
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
+Inject error
+Atomic write to a reflinked file
+pwrite: Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+0df1f61ed02a7e9bee2b8b7665066ddc  SCRATCH_MNT/file1
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
+FS should be online, touch should succeed
-- 
2.34.1

