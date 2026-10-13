Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B6B46C4CD;
	Tue, 13 Oct 2026 09:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884310; cv=fail; b=Ci9lK70aFjRap8u6nZ7Zu4/9OrjXgAhNyhlaJmOSzA9PAFp44arsJ+Si8zeUKLZzMM6O7tUVxIBv8A8qUwVfXAgvNg6FRXPB9UvARVsm+F/zfCgq2/0+td2fgZQRMlUcciGQdO2P169kU9YwHC745U51eBVTkzQ7TCe5Hz71WZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884310; c=relaxed/simple;
	bh=Ta9C8A3fQUG9IwyVp5h7oozBz0YUdeRc/0tkVZ85EkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YgRvbsb2qSC6uSz4o6xbu3bV/eTeslo11HCpN0e2DkgeGDV5bMlhAVEnZkvcmgkzTmM6JXcw8pMaHosNUtBvdzO9eDU72wgj4ThQHR/KR94bPYnpzDJ7t9n5OhAt8wlWeeu1xtQm3ifh71VDQ7xrcKOVSa778MzSpYdh/XAw93k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fQ1cvHRG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vWY7r+jW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fQ1cvHRG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vWY7r+jW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CSVW4061657;
	Tue, 13 Oct 2026 09:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=InXX9gEgY9Fe1b2FBhTvPxEhzHF52A2U98f2CloKp/E=; b=
	fQ1cvHRGCoLuDnyBY7VxCfQtc7q0HEDDe7ZOM987Jc7a3Wda1Raji5urAtpwRrjJ
	U4HNzfZLW1xOSbaH+ZLxxCRH5wFZu8KTgz6xZRM8jgWdWMp/dXaxeE/UyJIbkImO
	NRbv3HJ52GbVe2xZfLeqJiI9c/IO2/BvjiQzA9lipRY4haDTxJ7CHZ1AvF5tiYL7
	sU6HnMtICvxXN4ODoqMMOFgXHAd4rKlvFfCQt4mcoMOMi36DrtmyLAXg9yvuBnpe
	2shUuuUrxhOfOkHefChnIMoEouH9UKtvQluE01Z0l33QqXdYhjmnOQAT5c8sWM3q
	XYqYC7zcWNeIIUdAZKZqlw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkq5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTT6010887;
	Tue, 13 Oct 2026 09:38:23 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010036.outbound.protection.outlook.com [52.101.85.36])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d3u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PKNd17w9o7j4Jzr3GvctnNtcdLLRjA8XlgG6IqDRsDA5wMqD5/xWMPPtaoDXAfE3qndPi92QtqWEQGRIwvRuktJLmYHBZOBSiDIcSBGtNShuXETPZufaoLLj9Qu7MPmsNK5z+CXGyBodGZUNoqNLNC4lzgxUDu6/f260wRRffrLPEmUAcCnAYtSKrKYBi8vFqVhyI8C9+Y9thXyt/eyPhjao5p/SseXqggoGdDNLJP5vHbn+P1dslQ2eMAVPdmYC5ClnXaIROhTCcI4SYlmchSgCzK2pHjhbXLHAjEUf72wzEMZ6//xDVfuZx6grgZf5M8FrQDgFX6OM/2da3V1mYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=InXX9gEgY9Fe1b2FBhTvPxEhzHF52A2U98f2CloKp/E=;
 b=l8vMV8QKtIaFfqd3/15G8/WPYkVgLES+lQZ6ULqKtS5BNU8XcTdlPowLeEnkdQUBoSf1glyoob8TDUqxJ+jnWfgBinUF6LZGfW0tQzGqxiYGaHwn8ss+1r9Ggas5gUcOIRZimemNGTKluyMh4tRyZgBuJKFZ/4kcVQ1FP2uRYnXZD50KA5dKLCXNZ64JDZaNWJ4/fPhZBw/JmHUJC/SXVWPdk9mV+NmgZXTbuKWX53ivJPfhVKn2JTXBg2pj5lXtjSczIsorKtZRLZQF8e4SexnPYJLB51P+fl9mjvjmCv+cJP7Fv8q83rpp9fRSDz+vio/lyPO4vMGZCXEfEeMwrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InXX9gEgY9Fe1b2FBhTvPxEhzHF52A2U98f2CloKp/E=;
 b=vWY7r+jWHP5TCTNKLJah/Kr/6Y/FA6Cl/VeDcItTzMQ4weqW2R6CTYyxSw2DK0bdIZZx8gndvpY2QsRl6j5zqDaV0Rs38gqeGpr13DnGh1lDbNLxZLTuIj+PELmrL7IP8946Q8NnVYJQVl/8yGh0VifbWzwHXmXvWyoN7cy2oEs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:38:18 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:18 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.6 v2 2/5] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 15:08:01 +0530
Message-ID: <0986e23e93ebbc44fee07cf4822eeab6e67d2b3d.1791883285.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883285.git.siddh.raman.pant@oracle.com>
References: <cover.1791883285.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0208.apcprd04.prod.outlook.com
 (2603:1096:4:187::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 13be98e1-a541-492b-e393-08df290db636
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|5023799004|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	R4pUiViyxImpxXGzOcLhxXhKDQxJokCu8hNk1oJZDLVPxMZEnBccrBltqbTrwVsCQ9NWSZpPwnhwahn/MJaLzcgkCRR2UUqMzBvXp6fNgs7uVc52TSXUnzRsCKVP0xdiaFcGroW51T5pgQEg4spdUy93BulmNoMrD2OvtiIz46idMvcVXKeFbOwkySYUr5lGqRFAX84emPiNqUAljwPl4a4dalXy7nFUWdFwC9oeQfsTaCfJ46y/CtP7rHY+YTa0s1NpQzSF0UqhEQET6T04Imnvm9/hSdlBdq650pIQuIIahbb9/ABYq6xNzruzBTMnI7GFnGgyqo+oLCbZJxl2FSyHWxoBO0r0eBRNBrBh8Yv61201bvDicCpqodzih9vcez4k7w/4PSTP30zlA9dwHdHJs5ATOF8ar04QY24Mi9zTsAhSYqoGpiQKctFrQBUyxvDcxejUICWpDoRyhKA+4nhILiOb7OzGlEhimSFU+J/1MbDiGKX2Fuzr47D9w/zeIQrGUif7ssjRqgSozrTi1lxotmwtqdTGd0q9tUNRpd4M4Dzb6UFjDv44WKDVmQETidxyYLZHrd7EXHieqvx4R3LQO3AOXy8CawmhSmnMARmMj/QDMFNDzU0htlzes3XdIYzqC1hH3F5evqbnKtwDCN6hWd7/4a6htKKm8AXCqGw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(5023799004)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0u+DRH2h+hO6XjrjEFtF5VbvykKXGYMuNqtI+agQnz5KMfqqlgrfFCHT3NBa?=
 =?us-ascii?Q?3vgYp+QCdzwWLba8oYH1N8OBhwuRycEooUUcZVsQDWO5H6fXyBgp5P19Fm/S?=
 =?us-ascii?Q?Duwqhtl/tS6He2m6Qh8TihYHbOl1Ssii3JS95A5Fti1EnRuviAMqB1XcvNpq?=
 =?us-ascii?Q?XIp11n1TlMYoFGFQi6JJkkcs7XJgFZt1ZDTPYVFHb4ybIqHOgEMWAJGNYN/g?=
 =?us-ascii?Q?wBeJBpJl8ACY3fksPX4WrrwJfe5ca82fNqxDxV1wASOMzW2qCIBxAQ9qLdos?=
 =?us-ascii?Q?AdmAUp5v8lFdf0H6pu9Mymp7VFzRuCZ76ZdB4U7BeJfOKBU0q2Vm5u9HQts4?=
 =?us-ascii?Q?mnnWV1VD/atYFYlAwH9rll0Xmvtijh2zL8v6P+Tz6tXfwhjZ0giUjmveg+I5?=
 =?us-ascii?Q?7H3WhhuuZLimNK4SjB5MBB1b2c88byTeEA+DEdnEeEHeV+yYqrKZOkPjcjF0?=
 =?us-ascii?Q?keQBOceaEh1zTjcjjMVzfiWd55nLIbm9kbO5QQYzsESQ0f5t5077o9kbRrKV?=
 =?us-ascii?Q?rGJO0x3i0rgcHMOpA7i/S1OcB/3nd4JQi7mcWLkCVYf15iMCx53wN7sKzNON?=
 =?us-ascii?Q?7z9P5oEnAUYnqCICNf56HxcMabNGSyl3ww2TynZkY6VT7/N3yV58Mn9SOWD7?=
 =?us-ascii?Q?PfkrCucZg+JTZ/PxU3f9POROhK1ZszcahQVp+ZYUom1sAsUPZRTiZbwLT124?=
 =?us-ascii?Q?wLx8Twzop0f45i5oz5/uIt0xcELMu185Kh5KLT6hYxfmnYVOSEuA7wsXBPcX?=
 =?us-ascii?Q?icyAgjdHG2XAIuyy12nZeOtAmGoKOt2JDbHnPXSlOc0HQMKPUFSRH6h5v1Hg?=
 =?us-ascii?Q?Q021Tf4RB2lLnALD4zcuWys8WKPQhuxIMzhGnxt1qIvnxTIhv/3A8EMoRjX+?=
 =?us-ascii?Q?SQh/3yJPiyGBQ4rHrO8EsuhrUOsXi/BXmxxPVAKVTmAKT683jWACiB95urq0?=
 =?us-ascii?Q?818hcOQagV/ZElQtVjc2vNkrV2+r4UmN5a6TuLgAhrEggZ/e9v79mLp0dR07?=
 =?us-ascii?Q?qR+dQdGpUCH5pKRomG4jpZMoKgS233xTqNwO0wR6oLk7kmSjmWv6BMbSvgL0?=
 =?us-ascii?Q?1zKEWM4gY8WvbH2JKQhCPp2YfeuBJCZ711a5+9ZPeFfyjBHEhfc4ZLYLx9KM?=
 =?us-ascii?Q?G4bTeX5Z9NYoHkHaprVl8Zuy6+CaLBVIuRIo8AGUGGJwtLgS9lNiTwAUdRcU?=
 =?us-ascii?Q?QvRc8Q3jik3a2v7TZRaUkMrlP6snQFQyaYG/sFa3CIAWvQ9e6AaWJc4zq3MS?=
 =?us-ascii?Q?hXf9ChTPcZyfs9TfavyZ257+D0xv4oPKXW6njeQ6qskFWUsABUtwfZOL+9HL?=
 =?us-ascii?Q?r97/lLRY+OvjcX9EHzqZYweS0WE7AkTL+HJhJ2BMskz6V4tO8XUR8yK6i14I?=
 =?us-ascii?Q?msk5gmbRq3tcGBwC2M6JZ9fXsii0Mmwb3jHro4WIcGnPXEWIejlKALNgJsxI?=
 =?us-ascii?Q?rDVRKpqT98MObXlj6HdOEeMw3BvaHTQgTVrzgeMPFgM6NMp6bi1X0et0J5j7?=
 =?us-ascii?Q?2Fjd20cZg0HdfVgTvkvhhBctt1gK8WWYX9xJ56XwmXhncS75lDfr11IsUY+n?=
 =?us-ascii?Q?1CB4iFc0jzzdTFYJ5ekbJwsKtXlaLA1q3lhfyiDgvX6FR9gFG84z2yvHYx8O?=
 =?us-ascii?Q?/FJfsXOVQtai4ZK93h7FBo6vsGYPmBlaSCrVzM3rXW/AsmuBSOb7PeWMolfz?=
 =?us-ascii?Q?+qCTidGowei+eSLUWroTKledZdlD04qPofsRZKO5VALdzySLnsEuBlU4rwrX?=
 =?us-ascii?Q?S8Nl/sV4Cl6J9IK4Szorlz18HVnDQBCIUlnhVO/lYBGy0mXhOZ/TOAX1oVxW?=
X-MS-Exchange-AntiSpam-MessageData-1: op7IJHXY7l5aYJbMoZM3XHYdWwwFKqHVi1Y=
X-Exchange-RoutingPolicyChecked:
	guF+urIlBKLA7tsTuzWdxHMr4LCebZCB70rYebqnhNJRxG04M46OmmD4fDDaWPYeGkcGT4eO1tF26e4OJkGtkxDua72GANrA8PUsVTWAP4Gn9YJcUWIdaCAgJ/LVumPsSmMC+CaQ36xZFGuzN6pNi88/QL9jyTB1OJwJ/xGjEZVOiINMpMT+qJx+8zpQo+RoqNo1nr29jhJAdkPLmzpcLCVYcP76MUQNkSzlvd/WDz/BahhT0qv7rw34cW2sVuwy8AACamvdYCCTb+Tgi4lGwdziFIwOCHa6V08VOeWuvf+SwkKZ5TlURU/xir9cja6jw590Vp4wRDBR8tEJEDDZNQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GXH2vT19vCyW62QdWo+VNtQqYaubkeqDoDvjp5vL78LkQlOuA1luVdDjuGedkAuLc+i3no0gIgWouYZRfUVSRgl/ROeIZOVcU2VEI4OqGPYGXM+Q1sXOrOaxyjTCxbOJCAMyuO1sl4hp4J/tm68oshKCRlrXxqZlh/0o0WK4Hl7ae+CSOZFvqN77srkjCXzoL72XRuUshA6dOfT7j47RfGntAiNngWFW55+H6gVQ6svyFkCDp06w9HmrS1/wFSWW7z4EOBb74mqTjLMUppoYrEOzfln3KM+kNPTAsyKiyG3fHn7FXqnLs6bjAhZkpXhvKgxHtRoqgnFJHnN18liCr6+09daHdnrHupG2ZETk5org5MJDLbJf1LHnq6o/YDnH5iy00IPsb3t0ysNpIfuaVho9kGuZLX+QpBj3/5ZTHejOV+RQbm65Wy9u3Ijh9fPzIEuAryPDHTWK5d9tJc8nES3j/6rdItp55zcAs7tLlOqlxc6NVDC2PQKP87jRl9ht5NfO0so0kjuJOevYmJyxEKlVwWSh2ZAJdfmxyMAqYiunP6KCmTBLycq4vVeXVnRmL+fynEpAwc5prFyqF9vPawIw4lxayajywIXNBGwKfVY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13be98e1-a541-492b-e393-08df290db636
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:18.1274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cehZdzfjcxI8kFtJZwUYTNCkdgnqk8S61/MOdnUZX2wz4nJnGHyG7Hp0TehWBMNDmOrv1OdibCnyMWUuQrDQFzHjbcGxjKAdifkHxR53TFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acdfc10 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=2l8DqRWQ2dbnbHYYE4MA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: yQ9VFANv97T0R3H_pl1yNsXqiGaCiLjf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX1/e0hNo+h61r
 QhrdlFaF+9DqQBgbTdRdq5swP4UP4FfVe3KHqJVCnxzKN1Bcx8jJHtEyuJoTFDmpFcYsLKltCy3
 9pJhlSE8x9WQghWL9Pb1JZVySugrqac5oUVHpnrxo2zqZwfc83yZgE0w+jXMlRXc1ejskKJw7s6
 Ei/DExFLXy7pMXXWxUkrwgInK0NtaknY5NfgM5QtR3Gm3v7Edtom5TZYuSBQLG22mLNpcfKv9Ty
 Ck/cFT5EXkg+YgfvVB7qdayElTMP1juqr8ooMzCGnbi8VGCVaYA8zceLEhX7MbuVyLVcZRojc8X
 N7dSEB43cmZL4NCyfvz8hjPoZB51LvSyZ9peeejlOW4BoYfTkS7OFNpl6o0uMHNaN9nMFytbuZU
 Ds3n5GNkZRAglRtWzUQLxspm+Eu1juhBRS6Ti1yYZ6mpLkIm5LpaGnEip7g3+laBD1UvA2ArfE8
 5fZJmQ0+i7LOarcbt1g==
X-Proofpoint-ORIG-GUID: yQ9VFANv97T0R3H_pl1yNsXqiGaCiLjf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX8HQ4qzGaGAuL
 OAtb2gkU03W2UfZlOKX2yGTRJ5nl08eUnRAzvLiCrAPg6nUfbYTrjcbHceCCfFOgAVKeyDkIiv2
 odP5aJVDVjFt0jtMmWxex/T6LB2HW+uqAmjRx4BxnrlA9yrt7/3a

From: Dave Chinner <dchinner@redhat.com>

There is a race condition that can trigger in dmflakey fstests that
can result in asserts in xfs_ialloc_read_agi() and
xfs_alloc_read_agf() firing. The asserts look like this:

 XFS: Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/libxfs/xfs_alloc.c, line: 3440
.....
 Call Trace:
  <TASK>
  xfs_alloc_read_agf+0x2ad/0x3a0
  xfs_alloc_fix_freelist+0x280/0x720
  xfs_alloc_vextent_prepare_ag+0x42/0x120
  xfs_alloc_vextent_iterate_ags+0x67/0x260
  xfs_alloc_vextent_start_ag+0xe4/0x1c0
  xfs_bmapi_allocate+0x6fe/0xc90
  xfs_bmapi_convert_delalloc+0x338/0x560
  xfs_map_blocks+0x354/0x580
  iomap_writepages+0x52b/0xa70
  xfs_vm_writepages+0xd7/0x100
  do_writepages+0xe1/0x2c0
  __writeback_single_inode+0x44/0x340
  writeback_sb_inodes+0x2d0/0x570
  __writeback_inodes_wb+0x9c/0xf0
  wb_writeback+0x139/0x2d0
  wb_workfn+0x23e/0x4c0
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30

I've seen the AGI variant from scrub running on the filesysetm
after unmount failed due to systemd interference:

 XFS: Assertion failed: pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) || xfs_is_shutdown(pag->pag_mount), file: fs/xfs/libxfs/xfs_ialloc.c, line: 2804
.....
 Call Trace:
  <TASK>
  xfs_ialloc_read_agi+0xee/0x150
  xchk_perag_drain_and_lock+0x7d/0x240
  xchk_ag_init+0x34/0x90
  xchk_inode_xref+0x7b/0x220
  xchk_inode+0x14d/0x180
  xfs_scrub_metadata+0x2e2/0x510
  xfs_ioc_scrub_metadata+0x62/0xb0
  xfs_file_ioctl+0x446/0xbf0
  __se_sys_ioctl+0x6f/0xc0
  __x64_sys_ioctl+0x1d/0x30
  x64_sys_call+0x1879/0x2ee0
  do_syscall_64+0x68/0x130
  ? exc_page_fault+0x62/0xc0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Essentially, it is the same problem. When _flakey_drop_and_remount()
loads the drop-writes table, it makes all writes silently fail. Writes
are reported to the fs as completed successfully, but they are not
issued to the backing store. The filesystem sees the successful
write completion and marks the metadata buffer clean and removes it
from the AIL.

If this happens at the same time as memory pressure is occuring,
the now-clean AGF and/or AGI buffers can be reclaimed from memory.

Shortly afterwards, but before _flakey_drop_and_remount() runs
unmount, background writeback is kicked and it tries to allocate
blocks for the dirty pages in memory. This then tries to access the
AGF buffer we just turfed out of memory. It's not found, so it gets
read in from disk.

This is all fine, except for the fact that the last writeback of the
AGF did not actually reach disk. The AGF on disk is stale compared
to the in-memory state held by the perag, and so they don't match
and the assert fires.

Then other operations on that inode hang because the task was killed
whilst holding inode locks. e.g:

 Workqueue: xfs-conv/dm-12 xfs_end_io
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_preempt_disabled+0x15/0x30
  rwsem_down_write_slowpath+0x31a/0x5f0
  down_write+0x43/0x60
  xfs_ilock+0x1a8/0x210
  xfs_trans_alloc_inode+0x9c/0x240
  xfs_iomap_write_unwritten+0xe3/0x300
  xfs_end_ioend+0x90/0x130
  xfs_end_io+0xce/0x100
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>

and it's all down hill from there.

Memory pressure is one way to trigger this, another is to run "echo
3 > /proc/sys/vm/drop_caches" randomly while tests are running.

Regardless of how it is triggered, this effectively takes down the
system once umount hangs because it's holding a sb->s_umount lock
exclusive and now every sync(1) call gets stuck on it.

Fix this by replacing the asserts with a corruption detection check
and a shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit db6a2274162de615ff74b927d38942fe3134d298)

6.12:

Fixed conflict due to the following missing commit:
	e9c4d8bfb26c ("xfs: factor out a generic xfs_group structure")

6.6:

Fixed conflict due to the following missing commit:
	e45ea3645178 ("xfs: split the agf_roots and agf_levels arrays")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 46 +++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c | 32 ++++++++++++++++++++++----
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad2fa3c26f8a..0383216e39dc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -3240,18 +3241,43 @@ xfs_alloc_read_agf(
 
 		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(pag->pag_mount)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+	/*
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
+	 */
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
+		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
+		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
+		ok &= pag->pagf_levels[XFS_BTNUM_BNOi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+		ok &= pag->pagf_levels[XFS_BTNUM_CNTi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, agfbp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
+
 	if (agfbpp)
 		*agfbpp = agfbp;
 	else
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b83e54c70906..dee46010702d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2634,12 +2635,35 @@ xfs_ialloc_read_agi(
 		set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 	}
 
+#ifdef DEBUG
 	/*
-	 * It's possible for these to be out of sync if
-	 * we are in the middle of a forced shutdown.
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
 	 */
-	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(pag->pag_mount));
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, agibp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	if (agibpp)
 		*agibpp = agibp;
 	else
-- 
2.53.0

