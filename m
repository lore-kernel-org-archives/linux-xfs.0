Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568561D172E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890904; cv=fail; b=DOOK7X8WfB58Wxuwd6fJWyt6ziZ/Po8Dt6GUptVaWh5RUeXxv2mQ9DvsgEvXlId/b7vcf84ocjL6vDf54xOGA83nfdrFgkzVNqqk1uwBsDWUE3SBih3ojX73Gev6RsRQkqtunNKIKAG/FUKDRURzamH8ff6jzdwdAhzP7eYoRzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890904; c=relaxed/simple;
	bh=ycqVZMYkC+dfKiRhNiIV+c/Ng+x2368+xfWSdAgBamk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=COWwTyBEeJeLa9tyCBgddj0Z2p33b+ufx5ryBwUBMF+AexPSPIEjjnyjqeB6r1ofhLoJXjGW4Cz4oNejnM6f4Q3dLNcWr+TSwI91ruWrYEOYRkJFzOih1tiRifJizgF7wYW2hviqjcQwy1rQMpaQQImZtqJCmOOeDVgd0MwMaj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=btcFBVyK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PQE0uqAS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="btcFBVyK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PQE0uqAS"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfZng007356
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=rCA7hU3+yeUZe0sFXXScc90o16jiClySCAuoTOnlkRU=; b=
	btcFBVyKizDQlI5yMDSAsQ3afONUYHsDPO73G1q0jrauA/3QXqNXLcJ3FqMOexzY
	ZceiQvzDZCjL2oCYL6GPFOBVEfoXglC2EGeE9rGXizGt9NiuiLXFA1FTpNpkZPYs
	+iQeeL01Nxmwi13tpFfbryBCzxJ8PkPA3wN7KcvHFRFV7KHNOut2mJ8erYi5f9qB
	xsWMxdP61DKEJ97zXbS5rpXUtzd/2xItMOEvcXYBMpaLGUxahjpZXMyPADdyqYyu
	SE8Jhrmdz4WwS450SR2TmgwqAgVGb6HpBNQ00AYI9nT+GwO5eTljdymCAQ8d1a+4
	Es52kejv1Wn1xdLFl0R4jw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41xabtt706-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492G2Asv012512
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:41 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x888xgec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NYErH2dWNPNzsMmkp5ipj4r7J5MWbBYVUOuRSsJ2RxmBQgX2onU8yMtv2iNL8CC8/f/LGqq4U8pg++wHpWsYNRn9wR18nJcZVA9udAQG7RFSpjZ9WHoBPpoptkeK6h9KSUpz0RtHutrO5aNm+AX6lKwlMgsRjcDkbBSvHz+Lbz7OAUIGyMvmVUiaPzfqr4NN01VsWc5Hs7wXqP3LP72zGv2oqBKecHNN5IZDdK1evAmMSTviXg4hQJCu9U8Oy62lPPjfkVt0gsibgg3ovxYClSuU4mlpb/5kc3NpZwR8a+Iiss36fm0zMmY02fOyxOU6M53A22ni5Ugf2Jjbjairug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCA7hU3+yeUZe0sFXXScc90o16jiClySCAuoTOnlkRU=;
 b=ZKhLoFdXA3z7+Ufyd6V2qcsRxO+Zs9kemcfUr1h0iOW+jCS93uV/7HoCm7QSs2MwengCrMVlp8Vrr3KSViOMpkHDuJ0ifIfexrxVrR0RVmiKbsvklZ9KuygbNGou6rAS58lUJCJphiBwb8dshuwS7PdBbUROuMBrGIhelpEgxQt6sTX3Azj6elNxmHhAwNeu7r0KeJOvGgRTGXA0c+9CaOF8nGveNz+pA/BhaEgFLQObx/QSptZv/m9NjHpOrkGLefdPcisTL0NeExPM3RB905TERxju8BIM8hrrwTaIGj1WW5wpLXC9szqopyx9s0enzlHTgzNRqR6BudiuqYHpQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCA7hU3+yeUZe0sFXXScc90o16jiClySCAuoTOnlkRU=;
 b=PQE0uqASb0U45XnzKvSAA5IKlC27DjmhfZd8YUEsdzMWlTgswRB3qC6KC33diY+i2LTShYWVEmoh4zJ3UeNGGoVmSoJE8OMkar5JIOQWqoE9tPqx8S5d6CVGYrfN076g/xsGVCFRRuu/5Q3pLPJ9o7Sdufcc50ihpntczAjJIR8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:39 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:39 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 15/21] xfs: convert delayed extents to unwritten when zeroing post eof blocks
Date: Wed,  2 Oct 2024 10:41:02 -0700
Message-Id: <20241002174108.64615-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::8) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 2869a3a5-4c35-4f20-da28-08dce309785c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cFrg9GWvn4hRbXixkYu2N1zh8ZSV3hwP0o5sm/WUV6E9bCvZolQOCNRtQeUl?=
 =?us-ascii?Q?IghrwXireDe/XFdib929GndqkhL36/ADpVr7hRritIWvhu5TEkkinxuEdZu/?=
 =?us-ascii?Q?qsUt+J2CYPiAQUy2tY/38M63k0NjpqhZ1R+cZAt7PRmuAZaiLvaSxhnnF5gd?=
 =?us-ascii?Q?M5UEj6MhgESmFqwUTZefUDcSCJBExc7f5KLWWyeidZ3AMgUpb+3nsEXTLUvc?=
 =?us-ascii?Q?e+sJJIevA9SbB5AhYR0oJ9Iow4YSEKi94cH+ICXwGHXTZyniAlY381yqVRyW?=
 =?us-ascii?Q?sqYzlJmezwN2DhE881wnpDuOMViVRkdEP4XERRm7VLPLgACkXqi/3EXyxnL1?=
 =?us-ascii?Q?GQ8CK81gNutLZwuAvdwXCTU3V3h851+ZsyqDnjB4GYul/GZgvob0YtWTERJy?=
 =?us-ascii?Q?5uM8odtnfRU8FR5HzulbZVlkHyjK2uPAlROG2sk0HZGEu+dkD/y3TjslfBAg?=
 =?us-ascii?Q?+nE0j/OA/+FV/ua+zH4BKwumhtRlrmcUj6wVaF2NAMM1iA7kN2NXNGx6be/A?=
 =?us-ascii?Q?edqp8O0e+Wk0wj1fpt9xOrvuMJ7c2LuogdRaKba6jh+a8J+AXO6KSTY0+X+J?=
 =?us-ascii?Q?EwmIbPIpGvj0ofon0QqmxbBkxi0p4KZPTZ4J0Y/GN83tGE/fHwboEd9JIz+T?=
 =?us-ascii?Q?LEJwsBCIpmdT41Spl1ehV4AhGl8q8VEVmKNZIWR0NVIA0HGw7uVPeYzm5S8S?=
 =?us-ascii?Q?VfjuUzv/2dscJVr/GNzouGv/nGYOeqSSETXKOiIDJjA0W1mizdJIA3sqN95+?=
 =?us-ascii?Q?75J2iyFkYFX/Bi+6eNCL5YQ6M/SLLSlzMpob/ohDUBYVeU+rJuhBLqIwnkJK?=
 =?us-ascii?Q?eUNS3f/BLrhD/T6V8IEMlbOA6DpyHVvNTcwrl/TPoQ8EeoX/QAeZAMkxFHSK?=
 =?us-ascii?Q?K89ERGFecW6K+p+N+a9Xuz8oum1iJ9Ht7VxJyXw0Er8GHGd6EWmiBvAkf1yP?=
 =?us-ascii?Q?JEDD5zGh0XL6XMhA+9V3QqPALZWUHLN4LsNWx4OocSDzED1BO0DRD0bCTHmQ?=
 =?us-ascii?Q?AVMwOa4fyHSNAYQ5OtMZhfIl0E7ruE5pIIv9RxpUYkoa1nQuHGrDWxIebE0Y?=
 =?us-ascii?Q?/j1TLGheiQn2YD+kfTKTNep+I1xSLyG4V8bj7PBqmxhKfAvM0aHP2s4pgmQH?=
 =?us-ascii?Q?lPS0jvQlTKEPUevzYIBkRs+GcnP22az9rfpQ1cLz5B/Z5QLQMQMzIxszg3Ab?=
 =?us-ascii?Q?sacFtVf9BhZ7crmCfib0WdvmJ1qHu/X3ZfPwsnzeEJKR3seFHSac+JwO931j?=
 =?us-ascii?Q?+GPyYEWBTSvb1xtmVmilUJj93UXexW5Cg3FHADeAhg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F+zQmYyLtOBX/QxBDovXDxrqLlwvb2dKqpx7mThLL20305IwGzPvmrj6p666?=
 =?us-ascii?Q?7N0C0lj7nVahE3adZKo2dgcwNaJj8y+qhBL5iacrzXd/2unVqL9iZIik5Rsz?=
 =?us-ascii?Q?cSGJvWjqLj3A+iSw2FBgwMkC2izNDdFrT2EsHPlPg/iO9lWmrx2RTZBbdDa1?=
 =?us-ascii?Q?UugKVaFPnQQPgSQtrVrHXd5jIqeWo+6fdTBlYaEh3ssQD5KIQw9Fmaoi8N9w?=
 =?us-ascii?Q?b3cPnb2v/vAFY+bYSbt1iDujFUhAPqZlj0fhyrR5UjCCfFZsyfDCKUfzpuDr?=
 =?us-ascii?Q?JUoLIuSdEkwlevG8+m3xEcPQj+BOpRG6P+II2iPyqU4i5h5Ws6fcHZx8cRF/?=
 =?us-ascii?Q?ZZaTosugu1bI6FfDUdp4/+tqQW4AcAFZjSuzMZv2eRFdoZhrJUFLdOj+29tR?=
 =?us-ascii?Q?sdjXH5tkX6oEwYxBE4QXQyAvV4nM52FoJ9YeYxHyQKYZ6ZpGWk1QSxm8h3kw?=
 =?us-ascii?Q?KZ7BQ+hl8VJ9NUFoE2nkOj3acAi74Z5nPJQ4DyCs0leZ9tSQLSTIkk/ail5m?=
 =?us-ascii?Q?2ZsPGbm6z8IJL5hNdzeMJqXzSUc6ckJPlp+raKj/cPHXwE9tpB/sKRKaE8wb?=
 =?us-ascii?Q?iK99rbrYQH+lR9xP+PLiheQuOs6c2zOTSWy9DibrO81iuDbhODE8KgNSDevc?=
 =?us-ascii?Q?ayRnZs95TFIklnhsb/1eW/26vL7Fuu/xLQiMzcTMkJvoAWmRAZ+PDj7i+Vt8?=
 =?us-ascii?Q?i4CidQEkPjmI9I5LUYRpaAd5IQObhWvfDG5O/9Tezrfu5vO2JKgeI0WOqdoz?=
 =?us-ascii?Q?MKDG0J+9a9FJlERzVeRKdE1KC2ERmpapT6BzJIJrcdZJQ8GyfR1AT0uZcwhf?=
 =?us-ascii?Q?cfwVs6MrfJyvz80UUQYk1N++y/72vbPkBSrbXiY+ftG2LBQ+g03GJMr3ya4+?=
 =?us-ascii?Q?WeZeUGuOI22X39TU3wBK3mcQooCPmwEMJwtBjjQ6ZHW0I7QfGxxk4fQyywpD?=
 =?us-ascii?Q?GCG3/lALrPLNaN8w8aM/1+GxM3L+xdhADqk3w+6AuXj1XXXZ7gCgERPfhjwj?=
 =?us-ascii?Q?U4DiTnwjoiLhPanKVsoSbCvwFBs0DE8rygTVIvrIvbVOvI+pXGGJqmUgZp9+?=
 =?us-ascii?Q?vSo4liHPaXbNtVL2VWZtv0bwFRKA6+369FyamawkrbehnXpqLWEGjGWNSuij?=
 =?us-ascii?Q?uSn6awjYOedMg5+T5RP1Q+IGCyqy7ggjQyYhMr8v+N2Pi1KH1lnXXvf2EUgJ?=
 =?us-ascii?Q?vzdXI82OQUyeEc81LARoatR4aQgMvQW18dEFHMucx90KFqk6RM+KWQK0WuL/?=
 =?us-ascii?Q?S3MGkobai3kPF24+qE6dLBwYvZ6ZVC4MtS0S8+v//HB/FWQ+HvAn6OLB/RfS?=
 =?us-ascii?Q?5Gf9tfAX+6n2n/Q5wiAWL5Ut5E+Zk0jdGvPlpz2nxandTzeqTWz5WdcceWhe?=
 =?us-ascii?Q?ArdnfcTLbT+kKhsOntOMwKuAyv3boYLwxJ6BJ41PVujscwHDl8a7tPFh0dFE?=
 =?us-ascii?Q?OnwtMHVH506NZ87UAW1iCTJRmlJaH8MGj6EoK4tR5yNJ/pdPzsr34bWpsgjZ?=
 =?us-ascii?Q?5fVGXmdCWJCvEkuNGz936+uCG/7jnvHxAT8taXS/AY5fjAH6kEeeC6PaENXh?=
 =?us-ascii?Q?J192RnNNE4B4nX1Cr5Ort9SOP3GY97lzUl/N3so4oINJCPzVjUAKHXreHdUK?=
 =?us-ascii?Q?80Bd+gqjXlLB4matNUVmDAZ7VcUK4rBo2k1n69H5Iq9Pc7sriiN5bXXDzizB?=
 =?us-ascii?Q?1ydv9g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5h+N3U+4kLV7kXkum8anXFQKsKcMby7AkfbIat9y8TVQX9ELXj/aDtw3zRFLHi9NxYqfEqaezwkiA63bKCgFmAWGTGLi0ZXWoq4GjXNV5TSTMS19GPb3k1g4y9I6KAVW+pBeaslGMVwJE5vc4gECQoGCm/kqqZ/fq0JnawWy3XR7c+Vu0tHAjl6qGk6goWerftJ8wzM+v0WduWjPrwEha62QDUCqLUUiJjj6XfwakSNRq0dbk0S5ru+hVMIb6AksV980moBY6BAPG0aFlycURoPeZXFYRVNwsT0yP0SqBahi1odFBJf55cUl69JJUsWqR7hfVVu69u43rVxDVbMAbsIvEGtwZalmDNT9f3qTKSwwGYl92QUFcN1YBWk+MSNq+2gi4iF6rv3MUm6i3t/uJfuVh4y6R4hnd1nLycI7KS+1eT3xB9GfTL84mmqjwW+UY6r3a6vleKvLhUz7V+6GY2D2Zteg57Lw5AucTKwwbPlstd9Srs9c15mAzlgkeYkqwI+vi57cbB8efQyx3Y/cAJ5k7xmzyShj0MhEg0ArYF/zLu4/KSweAg6d/Fr8nTsCJj05u3adVK7CTy/D+uaXJFOHKFBf2dJN2jXCMO0qTn4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2869a3a5-4c35-4f20-da28-08dce309785c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:39.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mBNMRSgW2pr6vw97SrH/T0ICWDirduoPHunhnT86uoOX8kqp+8gnUy0/5qxsRmG2KskPpQZt8RO/DOvBLnyQbHACct+BmcVOJQEpewRFVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2410020127
X-Proofpoint-ORIG-GUID: LyC7gY-nyBiMIcK-2RhE9TbdQZuMCypm
X-Proofpoint-GUID: LyC7gY-nyBiMIcK-2RhE9TbdQZuMCypm

From: Zhang Yi <yi.zhang@huawei.com>

commit 5ce5674187c345dc31534d2024c09ad8ef29b7ba upstream.

Current clone operation could be non-atomic if the destination of a file
is beyond EOF, user could get a file with corrupted (zeroed) data on
crash.

The problem is about preallocations. If you write some data into a file:

	[A...B)

and XFS decides to preallocate some post-eof blocks, then it can create
a delayed allocation reservation:

	[A.........D)

The writeback path tries to convert delayed extents to real ones by
allocating blocks. If there aren't enough contiguous free space, we can
end up with two extents, the first real and the second still delalloc:

	[A....C)[C.D)

After that, both the in-memory and the on-disk file sizes are still B.
If we clone into the range [E...F) from another file:

	[A....C)[C.D)      [E...F)

then xfs_reflink_zero_posteof() calls iomap_zero_range() to zero out the
range [B, E) beyond EOF and flush it. Since [C, D) is still a delalloc
extent, its pagecache will be zeroed and both the in-memory and on-disk
size will be updated to D after flushing but before cloning. This is
wrong, because the user can see the size change and read the zeroes
while the clone operation is ongoing.

We need to keep the in-memory and on-disk size before the clone
operation starts, so instead of writing zeroes through the page cache
for delayed ranges beyond EOF, we convert these ranges to unwritten and
invalidate any cached data over that range beyond EOF.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_iomap.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 359aa4fc09b6..1a150ecbd2b7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1005,6 +1005,24 @@ xfs_buffered_write_iomap_begin(
 		goto out_unlock;
 	}
 
+	/*
+	 * For zeroing, trim a delalloc extent that extends beyond the EOF
+	 * block.  If it starts beyond the EOF block, convert it to an
+	 * unwritten extent.
+	 */
+	if ((flags & IOMAP_ZERO) && imap.br_startoff <= offset_fsb &&
+	    isnullstartblock(imap.br_startblock)) {
+		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
+
+		if (offset_fsb >= eof_fsb)
+			goto convert_delay;
+		if (end_fsb > eof_fsb) {
+			end_fsb = eof_fsb;
+			xfs_trim_extent(&imap, offset_fsb,
+					end_fsb - offset_fsb);
+		}
+	}
+
 	/*
 	 * Search the COW fork extent list even if we did not find a data fork
 	 * extent.  This serves two purposes: first this implements the
@@ -1150,6 +1168,17 @@ xfs_buffered_write_iomap_begin(
 	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 
+convert_delay:
+	xfs_iunlock(ip, lockmode);
+	truncate_pagecache(inode, offset);
+	error = xfs_bmapi_convert_delalloc(ip, XFS_DATA_FORK, offset,
+					   iomap, NULL);
+	if (error)
+		return error;
+
+	trace_xfs_iomap_alloc(ip, offset, count, XFS_DATA_FORK, &imap);
+	return 0;
+
 found_cow:
 	seq = xfs_iomap_inode_sequence(ip, 0);
 	if (imap.br_startoff <= offset_fsb) {
-- 
2.39.3

