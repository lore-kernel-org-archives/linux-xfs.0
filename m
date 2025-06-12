Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEB2433AD;
	Thu, 12 Jun 2025 01:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693446; cv=fail; b=LTdUbPhDCawRWjrDqDPP8Em9kmaVcDcFjS/MqBn+q85hA1/JZxP5nGFSlm/sjVqhG4fxY8vbFJq+wHMwBZDJQMXSWVdGOtSN1OIVax8u22zAjxVdEY4mJ2zq3+HKzjVO3RH+sn/+wxGHcvA656jYxWpcJ2pJW3YVgFrgLWVu+aY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693446; c=relaxed/simple;
	bh=X1WImDgS6EAshWNz/Wovb7sYQzix08LMUDcJnQttEk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uhLU8vqNvnPOZWKpr7UEpik/zu6+nDZIGn2l6bURL3Dhc+M0L90nFhuTv58zwH74mV/Wa7wFNT40C681IIXhXakQsZGv/bUeMekQh/8DpUDMb89AKkcGBP/jMLk+vi//pl7zFlAq0p232y4ViDRBvMYEfMRriOLheESJmjZjzpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VhHTFunS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZysXOtB4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VhHTFunS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZysXOtB4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BMPmsp003175;
	Thu, 12 Jun 2025 01:57:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=495h0Hgdl3Ya+kwwI172c5D8dLf6FM/d0IW494h8fJY=; b=
	VhHTFunSs0E3igAfB1stuYZHUS0jDWww/tJz9nl+uJZQhxTOFjxjb8Eo+LAI8WoI
	F73MdGqprMnniyXgbPxTbWTW0Itp0UpMMu0HB+cEx8X4luA5LWtgtr3V5uQ3O9uH
	B97eie9Z/Kgg+wfKXuBneEiZ96vjnDps/KsT8b1T9Iw39O9kZtua6Gzj7rDRSjj9
	POnGVk2RPgRltpUBF6Z6p5rpU60IdpLNLYq60OeS4T6K5bSMsjAxYCfLsF5JMLyz
	tjPj0vORo5x/v5Uvll3nk16v/k2QYCJcvpvXDlUku796M8yJdf6iW8l083ODmPxi
	gMJh/BnBlg1AiLIxGBEw0w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474cbegt91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 01:57:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55C12po5003202;
	Thu, 12 Jun 2025 01:57:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvaywnh-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 01:57:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jmL27jInGQBR0+SpMENHpyoAnUGgV5RCx0qT3e7rsp7uewjcP+OW2EtTYQF0NpYJdo7sC6wRczvTjo+csybsH56s5aOE5m+0aAnyxI/eJiGNY5t2XT0HOnzMg4F5o8SXkouZ9bhZWiaFJ8sbZ6fYWX3BGiD+1MUaMmqF03LKnRMphX061rykZEN+FXt3Pip5lXPgzZwAcsQ9/PiZfVucOarCFvPtrfB63BoA97DliF0V6JnQI4bCrlqoGxQ6Uuts0iIkkSrCgkxAmaKNWzGsdCMRgZQ6hC5Z1CP2xKD66GIbxDyQkGXmsE3xYiu91Hc1vNr88v7YKHslf5GfoQfSXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=495h0Hgdl3Ya+kwwI172c5D8dLf6FM/d0IW494h8fJY=;
 b=NMABnpXT1nYEnBbkdquWqwK1V1Dsgtc6Jii84j3GzEEiNjbsK06Yzy5DKtYTQaQbYGirQZZWFj/kTe5/BhUuJ97p8ZTPxjaUridw7QKI93hhG1SF8YbaidhIZVPiHUMiRUP158nc0+Bzg89Rfx9JgOLgA70DgOYW+FxAGyb4JAwrPOGT4AAEVZozyUsrGt2ymgqVnLQshIdzxK1s92Ja0Y4cQIm4wVDPbKZxt9wcrgHgSf1+QoC5077LeCkB9f4PhaxNyzW5YuoqMiU1Vopgn8mrlrAfxyAZ8YFev7O2PSpM4p79kesZPO4BcMmlk91dXsLwLVwxzvQhNOTR4mCNpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=495h0Hgdl3Ya+kwwI172c5D8dLf6FM/d0IW494h8fJY=;
 b=ZysXOtB4NK/9GOCluJxGfFTLMBgxsKuWCVR/AIG+ZWZ39quwgcZjL5bKSzzdAIcL2K72PZVj6LBlSFl4Swk+k23TzGFX9eF8Of+qsO6XIY5YX6N9u1VqVWB2nPyJYqDtfoW8amTAKc10fuZZZC/kbGbnaL/lKa60nFiP6IpE5ts=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by PH7PR10MB7839.namprd10.prod.outlook.com (2603:10b6:510:2ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.25; Thu, 12 Jun
 2025 01:57:13 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 01:57:13 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v4 2/3] generic: various atomic write tests with hardware and scsi_debug
Date: Wed, 11 Jun 2025 18:57:07 -0700
Message-Id: <20250612015708.84255-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250612015708.84255-1-catherine.hoang@oracle.com>
References: <20250612015708.84255-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::15) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|PH7PR10MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: 3888c3cf-c2cb-46b5-7a7b-08dda95472f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|10070799003|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uxjIGG368SX9zLBK61Hx9Pw82BM2iTGUN5JZ57CFuLQuwT8yky6n/2Jcq4le?=
 =?us-ascii?Q?qAHQCR7KC+7s3RgNNzYFGg2A/hiBJ2yXufZqccguiFtuLAxbtqvSqcONaZ1I?=
 =?us-ascii?Q?LYtLw/D7/azbbMviq5AVMKYUJlBD4IPJCYXLvYIUhLI2xfOLsdb4MvnKFCzE?=
 =?us-ascii?Q?1I/FDfX6PQ3Tuq/TJnrZjTWjPANu6/OtfzKqSL0OXBGe9gep4Em2mno1zv7A?=
 =?us-ascii?Q?/2jRJGCfz0B+iOA5cjonCiw9JbhFaFvHQlxS0awQYX5vKrT9nrt0zwoOool+?=
 =?us-ascii?Q?vozbIoyhQRxdBLZrcdVjQ1OuXUrKKMMyipB/tE7lJjlnhECiygoEBJBU9YwY?=
 =?us-ascii?Q?VImqL//8bGqZZvdpxmuy5tX970cEIp3CjS6T6jPx1MmKj7BwfjzFOt07Cj1V?=
 =?us-ascii?Q?SLVTsm8gLAORnG9zqRQVG4Amkl1lrNsGeJUOM1NFifz8gq1jJYBdBDO7Lesk?=
 =?us-ascii?Q?P9robmiokG7vknRP5YSitAEk+rO0jvtjwS2JaIJ96PnEXcRDlmUQpQvTOKdR?=
 =?us-ascii?Q?3TW2m6zrkli9bA7fDvd78qLQSZDrpjNb9FG5OjwN5HK6qizTkB2OtffDE9hp?=
 =?us-ascii?Q?1X8cVFc9kSc6f4Pl4tFBzf4u6pCzYS/LBa36LlKy5BPXzp3xgoVvzEj3BMNJ?=
 =?us-ascii?Q?Kzfn4jwfZrHp0+fNCUN7M0qD3LAwnmoX4YZHzj3X644OllSirVFRRoY1+rk5?=
 =?us-ascii?Q?865C+3rdPNADOMwROoQWgctHEexABYnpnEzyP8ONbMmhWUi0JyZ2Y8yIkwNr?=
 =?us-ascii?Q?ZNO4JBmA0+1H4j0VK7zdL+sSGq+cv0poa1asHAUUqkkUMt6ykUCyry/Qob/8?=
 =?us-ascii?Q?GBt+dewFj9xc7QFXbMXW1y//xLBJzMpzkXDAffZ88J7kUIV8Qt+8eKS/PbMz?=
 =?us-ascii?Q?6cG6GmxpueS4n34nPHZQV8Y6kK2DXAlydNo60WNofW1d2JYc7MwJ3inxkcOi?=
 =?us-ascii?Q?8xpz68EVL0ckYM+YZOCzfa3KO24bHhMyJAArTbw8DzrXsylGElawPsgM/ILa?=
 =?us-ascii?Q?K/jwhJjZcDkLNV7sijZoUmbmcosOx04vGrhJwIVZG5tlBNyOUia31BcDPSPv?=
 =?us-ascii?Q?EPS+adXrBHStTvPejZJP1SdjRSZXVLtHm15i+BtmHq1PDVE7NSP25Fgfhw1L?=
 =?us-ascii?Q?2Q9Oi/rb7msyn+nMIV5ViKLuNKbkNdYbgsxPiUIAoN2SVOVruM9/ZRo/ERMG?=
 =?us-ascii?Q?iEEEpRZue7Vthc1saTG5T+5IzL2u1KyP0QqJaQhneT5f73hXOwHZzCTBmqMK?=
 =?us-ascii?Q?KtkPHc4W1yf0pxXLT2UPB+3+8L6EkRNq5qIsb7rv1WjWWQ2ZXnLQhUcg0Zbu?=
 =?us-ascii?Q?QPDvNV+6eAW3nTpGBydIcLad6VjiNkQjgWdnUSxA3Psl2+cAljbDnm+ccPgq?=
 =?us-ascii?Q?e+/6MNnZiprSevSSZcWLCmCGXsKNlyAde10KoGvgQ7ejJ3ZJEoJhQ0u2EMil?=
 =?us-ascii?Q?52h1JKjbc7I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oJ9UoqnZA8EAStaOw0yCjBbR1fzOlA/z6kfjdHXMqs0anAHYnzSR0zw/wKaP?=
 =?us-ascii?Q?+C2IvHgWU8thcwCjs887No5YG8tqNw7CiSMFKG7vwDkrCtsbBFR3HvmlbyTv?=
 =?us-ascii?Q?LpZMDMGybGqFYwSijvng6B6Li/c3fwjhA+ajTSLNmKdYOWbbvh/uO5Ko6JmB?=
 =?us-ascii?Q?tk3zAB1+zTpIgfbk1STrxnLPZbbFXeyadTDi3C9vR1b8QqpyX9QNJQ62Hvsg?=
 =?us-ascii?Q?18wNVy2FidN63iXxdbfgxdHvL/mO2wOM5OOtaajm1DEyRT3IV6eAZFELis+N?=
 =?us-ascii?Q?AVZZzJCPaQzkcy0k1At1SCgXIKefOs7YR5OThyPHJPCrDvqWTktPf4vpafsz?=
 =?us-ascii?Q?XoSatsHWkuVBXBZBQmPqv9vIlZdizv+w2dkblYEKOX0YlK7xgvDpUr1wt93K?=
 =?us-ascii?Q?MoTrSmZWLbdhmJVkiH7jQaSiFs/yTBKZdRa+tVixNQ8Ul6YDb0cau83LNBvC?=
 =?us-ascii?Q?/UkLJ+8rgj0bRs8cPzKpKPsg+rzf7jF7poElVNBV9qnuprTjl4rTmnXdMmPk?=
 =?us-ascii?Q?xBGIz+4V2g8CBW6PdBlVBMpgP3irVjIC8a7fEvbl+xAkFB4W6Tm4Jdr2+TAM?=
 =?us-ascii?Q?7OThGQCSumsc1Yc8hXKxfSWDvL2AFxSdcGcSmMRqx4mP8UCfBmB/OY5PwFA+?=
 =?us-ascii?Q?hbkHhi1LZe6r4kBPz9GkesfPvC1n/GqRLQlseummT94OXUEdlMmlqtmd1/Ya?=
 =?us-ascii?Q?/u0ZT1Q8GjgCbKLyRjdJ+B671yh5/czT4sd9xsh1OgyltnB3s/EraK8699FB?=
 =?us-ascii?Q?h1yvXYlFgFBc5rEy2cgo2FGoI0qSNvsXM9Ne+vyDdjTuUyO+1/lBEscHWi0w?=
 =?us-ascii?Q?0vhHWsUi+Hq0Vk6wMGk8ysjPw7O+rOAbfIkgdB3urj3QDROOHUiWc9GEX+RF?=
 =?us-ascii?Q?aLr2fmAehFl0e+sDSB27WWxHxs6PPKJ++CBvrOTKV/u5++htAL+cflCCxS10?=
 =?us-ascii?Q?TloH25VXP7l4JAmQ6Ndgg8lxAmK5mfLlxHjv16Ei8zJKosEZDDhM8bfHx34D?=
 =?us-ascii?Q?w9Pm9aDDcL1ZAFXAacJFcaagsZUfzB3lN2iuhwDBi02KVrBbkjJK5YGn9UBu?=
 =?us-ascii?Q?uGrbSsPAuVAjdlSKKem2deDrH8E4zu7fd66+GrcZvAeeK3gZRtZjMj66JoTO?=
 =?us-ascii?Q?LfUXz7BQuH09taQvTQ5g0TE10+MF1iX9M4XNFo48h3usJ8CTRn/0b1lusAwh?=
 =?us-ascii?Q?63KpTj2CIc2EXxb5GeSyZyjUBoZHzaEPuxjIMBv8Xi88A698hNYMl91Q7FLV?=
 =?us-ascii?Q?fQxqQ+9+//bOmemGpshk/hdvWLkGRjUjgd+49e6CwILuscLTgYvR5ZRDsltv?=
 =?us-ascii?Q?FjNHoBc2X2XCe8QEORz+jSstAiWKVWFZocjfhcdF7/2kzocEBP0kvMta1B24?=
 =?us-ascii?Q?EEfzxxzGQebBWNZLuutYTLPy6OlAd1bpAOJqVkDDiKdLvqg/RObXzjI78zIb?=
 =?us-ascii?Q?08bxAwEvR0O+Q42j8E4hxyr/mxwnki7I+pUwNpwfkt/DzDtmtrnLdY709wCu?=
 =?us-ascii?Q?1nXEaCZ/xb9q8aHGhazkHDwkY2n28okF9Mnxcr2OZKqUMptXAWVsAKUu+mLs?=
 =?us-ascii?Q?wA94vEKeTy2PeKdcnock6VAglfa0TOTaLfdi7GccB6TT/jzCQpURRQq8Bmpt?=
 =?us-ascii?Q?QENCK431tM0XeQG5/jkSHwgZwvp8lIYHNfzXo/2XBSwh3o3NhMTxQAcR5Rzk?=
 =?us-ascii?Q?nj0Eyw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3yPz9HAc+3v6f9c8j4RdrLx425Bnu8sjhvJhScO2lnDqgBUbfuWPtjIT4JxU0Fh3R2F1RVuzF+6hup6MOhSivw8uru2LzDDErDmxqA1jkBr/jc2kQIa/vdqohyd4j0O4fdqK3A1VGXsDubLpYHicx7pDrrELBTRFYylNJ517v3DOVSCZCS5bPeq/TBBCv28cIFMbwUCChWohB8ls8OitwwaA7wCVM8PoJ+D1Azm2IDcLSvxNalpcKNuRIhVyZlHmPZ7yeA9mSJWfll8iUFPiWBuSsQN8mRzKSyCtRXjQ/Ea84Qml6NC4RrE3bBMOIta7bxnAjdks0GqXn3Z3veFUHecu3hWQaFSJGpXjkcVWuAaQP+42f29XCxw/yvX7AV+p0eI+fASxzNwDuDRTA7x8AFgRJt3jhWTDEkE8nx4UKstuf5B4Uzpqv8iVq1R4F6ddnIQZB1Nkt24YbLNnmbGnIccdt7QJ3XL9nuZsRaCCFupIqsmmmzHtfC+8PHJGPafzj6wJWRNwhJO9IFrJSWwxIEw5wRzSj5BB1ABcv87mJeWUpTEu2Efq8e7IR8gUT1NT3GU9y4qOo04JMVrjUWuF/F7/3mEUzCRccdZYMDufagc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3888c3cf-c2cb-46b5-7a7b-08dda95472f7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 01:57:12.9572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMaxhKlwhdN1kqWDyrgDSnKPg4KF8N/mg7KtNLMAJgBLEFcdLMXKkullUf0ccK97MCiNGFpw1RoovH3zqOelquzX2aWTV4yohp09XMn3SRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_01,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120013
X-Proofpoint-GUID: R_d9yRjJ6vwhax7VjRNG3_cD1-gTz5Ff
X-Authority-Analysis: v=2.4 cv=BffY0qt2 c=1 sm=1 tr=0 ts=684a33fd b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=_sb9GA80nfZML6AoPYgA:9 cc=ntf awl=host:14714
X-Proofpoint-ORIG-GUID: R_d9yRjJ6vwhax7VjRNG3_cD1-gTz5Ff
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDAxMyBTYWx0ZWRfX53lBTlF8rYVb y3UF3RC6hkO+1za/99tA1cN1S8qny80vyBgzv95+qmkOUlmxw+G13qGxviKCouuYHGGkOGrVMGN vjg5KPBl05DjxKQ9EYJz4rIRPOxY4mm7gCyWx2+9p8cqWqlG1+7pJpT+C8BrTotOOF/wI/sLx9d
 w2qZigBRFZUT3g6TE6rnA4Z35oUQDXB5urHi80XpOZYWfj9fENbMyrMEguyq44BKu7feHcKZMd5 rCEZXsYGQ5r3I957uqul79yFNBA0iPu+oZ/ymlc0oRfByV3uej3xli23XZaqr9Bu4/RaOumxEty M6e0Szg/5gwFa5jgRd+3kEALXNOhs+3BUymBnZh1ka/aLHSy4Boiew0Md/pfVkjb0NMxYzYP0zN
 pPsoqqxdtPBaRcEP50ZRSYYbskSKoP34D9uOU7YGoM6yxJxxT5Xyj6hvv/OxfTGv9vmVFlaV

Simple tests of various atomic write requests and a (simulated) hardware
device.

The first test performs basic multi-block atomic writes on a scsi_debug device
with atomic writes enabled. We test all advertised sizes between the atomic
write unit min and max. We also ensure that the write fails when expected, such
as when attempting buffered io or unaligned directio.

The second test is similar to the one above, except that it verifies multi-block
atomic writes on actual hardware instead of simulated hardware. The device used
in this test is not required to support atomic writes.

The final two tests ensure multi-block atomic writes can be performed on various
interweaved mappings, including written, mapped, hole, and unwritten. We also
test large atomic writes on a heavily fragmented filesystem. These tests are
separated into reflink (shared) and non-reflink tests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/atomicwrites    |  10 ++++
 tests/generic/1222     |  89 ++++++++++++++++++++++++++++
 tests/generic/1222.out |  10 ++++
 tests/generic/1223     |  67 +++++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     |  86 +++++++++++++++++++++++++++
 tests/generic/1224.out |  16 ++++++
 tests/generic/1225     | 128 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1225.out |  21 +++++++
 9 files changed, 436 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100755 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/generic/1225
 create mode 100644 tests/generic/1225.out

diff --git a/common/atomicwrites b/common/atomicwrites
index 88f49a1a..4ba945ec 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -136,3 +136,13 @@ _test_atomic_file_writes()
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
index 00000000..d3665d0b
--- /dev/null
+++ b/tests/generic/1222
@@ -0,0 +1,89 @@
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
+_require_scratch_write_atomic_multi_fsblock
+
+xfs_io -c 'help pwrite' | grep -q RWF_ATOMIC || _notrun "xfs_io pwrite -A failed"
+xfs_io -c 'help falloc' | grep -q 'not found' && _notrun "xfs_io falloc failed"
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
index 00000000..e0b6f0a1
--- /dev/null
+++ b/tests/generic/1223
@@ -0,0 +1,67 @@
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
+_require_scratch_write_atomic_multi_fsblock
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
new file mode 100755
index 00000000..3f83eebc
--- /dev/null
+++ b/tests/generic/1224
@@ -0,0 +1,86 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1224
+#
+# reflink tests for large atomic writes with mixed mappings
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
+_require_scratch_write_atomic_multi_fsblock
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
+echo "atomic write shared data and unshared+shared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic write shared data and shared+unshared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic overwrite unshared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic write shared+unshared+shared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic write interweaved hole+unwritten+written+reflinked"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+blksz=4096
+nr=32
+_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1224.out b/tests/generic/1224.out
new file mode 100644
index 00000000..89e5cd5a
--- /dev/null
+++ b/tests/generic/1224.out
@@ -0,0 +1,16 @@
+QA output created by 1224
+atomic write shared data and unshared+shared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic write shared data and shared+unshared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic overwrite unshared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic write shared+unshared+shared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic write interweaved hole+unwritten+written+reflinked
+4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
+93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
diff --git a/tests/generic/1225 b/tests/generic/1225
new file mode 100755
index 00000000..f2dea804
--- /dev/null
+++ b/tests/generic/1225
@@ -0,0 +1,128 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1225
+#
+# basic tests for large atomic writes with mixed mappings
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
+_require_scratch_write_atomic_multi_fsblock
+_require_xfs_io_command pwrite -A
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
+# non-reflink tests
+
+echo "atomic write hole+mapped+hole"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write adjacent mapped+hole and hole+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write mapped+hole+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write unwritten+mapped+unwritten"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write adjacent mapped+unwritten and unwritten+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write mapped+unwritten+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write interweaved hole+unwritten+written"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+blksz=4096
+nr=32
+_weave_file_rainbow $blksz $nr $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write at EOF"
+dd if=/dev/zero of=$file1 bs=128K count=3 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 262144 262144" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write preallocated region"
+fallocate -l 10M $file1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write max size
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+aw_max=$(_get_atomic_write_unit_max $file1)
+cp $file1 $file1.chk
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
+cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
+
+echo "atomic write max size on fragmented fs"
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
diff --git a/tests/generic/1225.out b/tests/generic/1225.out
new file mode 100644
index 00000000..92302597
--- /dev/null
+++ b/tests/generic/1225.out
@@ -0,0 +1,21 @@
+QA output created by 1225
+atomic write hole+mapped+hole
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+atomic write adjacent mapped+hole and hole+mapped
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+atomic write mapped+hole+mapped
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+atomic write unwritten+mapped+unwritten
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+atomic write adjacent mapped+unwritten and unwritten+mapped
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+atomic write mapped+unwritten+mapped
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+atomic write interweaved hole+unwritten+written
+5577e46f20631d76bbac73ab1b4ed208  SCRATCH_MNT/file1
+atomic write at EOF
+75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1
+atomic write preallocated region
+27a248351cd540bc9ac2c2dc841abca2  SCRATCH_MNT/file1
+atomic write max size on fragmented fs
+27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
-- 
2.34.1

