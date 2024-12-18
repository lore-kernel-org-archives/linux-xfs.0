Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544A27081D
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488084; cv=fail; b=aKZGHN3/S3pKeKzgzOQzT22mnI13QHtuWn9BxB8Rr/3hQf6pIVGhJbaBBkPOXLpoaoAslVwNrs4mhqX2If9I3dPjayAFqEPp8vQp9WWn/EAVkYBRiDWgEMwJGggb94Ck7k8l/Yo149m/MLOTqmf1byv1jU4NFQNjld+2IyzI3rI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488084; c=relaxed/simple;
	bh=XEtyqCIVyfnQaeNWHBrj5xfaPAADVGUX9uakfGRsksU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PBF9MISGUW1nc9l3oV8RY3u4PKqZtcQY195+VV4zO2SAKHMeDmuTc5sVtCXZMRpqX342QbVPoB8cARH/vOX+m+CO1pHeXuQAu6RFzP5dTbKwgslliYnlPquTu3FJSO+/Cw1mzEx+hnjexSXCv77rmlo790RZGLvp3FQGepAKK8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kb74bhUn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B9PmJYAf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kb74bhUn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B9PmJYAf"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BtBd029124
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=/yPLvlaq+Z+qDEjmgdqWejSwZgD1dP2CIZ7Vh5jmJc8=; b=
	Kb74bhUnUOmZbgz3V15oxvLlagQ8viNkERtNLyL7E49IXeNxX72qxNxY0vquyEaH
	SZpOEvK09QMK+O/zootfoj9uZSoM1tl+zkh9dhOxVVE1rdW+ItWlkzbp5WrEDJ4w
	f51PkLvp6AlDaOemgA14V7h9SMDkVokNDKfESaZQAB6Pg3G6sHkJKf6ugKtkEqsP
	OPbsslhRV8BD5Zq3WuZUOevkcFcgzUuZJAZcppdEHw1tfNhJCFHuTgnhfaux7L/6
	Ol2654t1Sgl6JjUuD+DnxduwoZfJ1Mb9KWM5EiKm1FsToz7SU77u0g4v2+Trf9Uw
	5C4oJcuRBBI+IOcbl1EPxQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h1w9ff85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BHNXJ3F000614
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f9dc7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMYxEQlAZCE765+6O2ksjNCpadOrP4JmWTddiVmGkfzfNiBhkOTUzKps0BmicksHbmbNf4PZlTovBa03zys8h2nYGGxPvgAk7mRcvfFp6nEKbiH8YOi7ZIcHmDRrlQkDiFew1Kr7SCi8s/THkzqchByp3fOP1NUUr7pcNZZtoRl0YKy5/+cJMEi99ExliBFLQ1zWA9JAcLVct7dWxaTH4I716C5Q9TW+y0FsLkP7uMzDyPRgwDTuMGSr2tdFCoXbiGhlk4SmXZNonT2CYggF0dQbhOh5bh5FoyOK4ABcsmGLa01yBy0QWJaLg9lcAY7lHV6vBDmYBDNnuQ/PSvisBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/yPLvlaq+Z+qDEjmgdqWejSwZgD1dP2CIZ7Vh5jmJc8=;
 b=icmMhVbS3juFCShFupmV1h2ElydzXvYlnS86wqH4lGjLZ1ihK2fpGIzEl6nLMQRTTUwsCWpqqoRhqV+RZTE5u0zy5X0mpj45HZA7Y0UGMmKNlF3AzPG+F3sWk9PeZhjywb6RDGxtrE80wh9PwNV7gUOHJ2plLmsobSgBeIS3raryDcrcepESara9izUviABGWnVaGUb/F9JHeEjf9UcsPwxJmUR0uUpSIppA44uvgBrObwhakvtvHLO2Gsi1HlHXjUKZcnb7n7JJAnd+snoXd8OJuZGxa/o8jYvB2fJycKI1mC1nKIUgMuvktIDVrs9CQTFJk7uZuACIJbrrqx2pBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yPLvlaq+Z+qDEjmgdqWejSwZgD1dP2CIZ7Vh5jmJc8=;
 b=B9PmJYAfLnO673Gzi/Yz1IdoNfnL0U6N3jhRrwc6w06SU5s3YGaWkKX4Yah4eZzoRVjuFFteinRQvkXqfYhlPCK0EYcQciSNxis4U2e8O0FdhQe52tudsaIT/HvgnaIcbCWFJZYHR/64dEyTgRi9CHagO2WouqZq4aJC+l3EngM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7577.namprd10.prod.outlook.com (2603:10b6:208:483::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Wed, 18 Dec
 2024 02:14:38 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:38 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 14/18] xfs: Fix the owner setting issue for rmap query in xfs fsmap
Date: Tue, 17 Dec 2024 18:14:07 -0800
Message-Id: <20241218021411.42144-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
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
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: a36c2cc4-5367-4759-7842-08dd1f09b9b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?csEI0wqBce4UpBO9c8V2N8iIKfzjhan9Kl49OinXfCIS7dMwwOrqIiyLuMuw?=
 =?us-ascii?Q?3ZCdmiP+wJ7vNmeNQbi7k/0/u+PpdB15lKeFKRh3leZ1qN8R2Q8K6dDBGqeC?=
 =?us-ascii?Q?tTg7GN8W8GSkzO6Jl7OL7cVDBuc84vmNNkjVkRutcaTc4x22aNOlQOHEV0TK?=
 =?us-ascii?Q?AUaXJQATZACwTC6hT9Goo3ub4Ql7EaqgWNl4FdgMjOP8ZiS4xmiIekQlGk+l?=
 =?us-ascii?Q?XorCikr+gM/RpMZnVjjdun6QJ4UwulVMrIA8/AX8BFMIsPZsDcfPfbvhQJwa?=
 =?us-ascii?Q?LGFhj+aa04dQRpf/sz0BAtNRS+JB/ktmDP87pkT0Pet57ZqO80OIOypyNsl3?=
 =?us-ascii?Q?zsZPZHjWvz195gvXEBTymPJmD22EgeumiAF/J3vwC/nlp1G6jtWUZx0tKeGl?=
 =?us-ascii?Q?1SmY3CDAkaULOFFcTXBRyyg+Q5TCtjhZWgKIg28S7bqddeAmlj29nWT4Mj9D?=
 =?us-ascii?Q?n3Hgp79ijk7hsbTmekKqHjsnL9B/QB5brdtqDwcCxhy/Y9u8IvmjZY9GtAL4?=
 =?us-ascii?Q?dN3SwjviezTN76fJrWNCGVmWge5JLL8zHrGOQCj/0IrW1W/0KNvucrK0NfvX?=
 =?us-ascii?Q?ic+yItNxYaKfPGpw6sJ2KrtONzE8cuuV/ZdvC6d8cRbC1B9NEZVLZ2LfLnc1?=
 =?us-ascii?Q?1lLy0On14bJ9+WWduXd3zLVbQcagjYUH7DLoRYEXtatSIXbzfKja8HPQdhHB?=
 =?us-ascii?Q?YfB38uQ6lH9HVpiy+j39li0DKFm6c6f22pLBfnYD8cO5gKJQ6f2cDpz7PQEg?=
 =?us-ascii?Q?mvb5K+amFHJFeM7iWjSBo1WCQ8X/MtvgokRaxMFwpYVNFSs0bCPxtSef2zAP?=
 =?us-ascii?Q?UiUaNnnWHgCLVEQFd3Q1/Kx9gASU1ESo6ugap/PKiOMFVZ928O73w0Wq6rZ7?=
 =?us-ascii?Q?CFerEIK0xmQy8MmkXnoWfeSicl5NzzHhM+vjDXeDzXIwKkCFwDXs/xuWleA0?=
 =?us-ascii?Q?AkDnvPCza9mPHI9Tp+C0UO3fmcisJhIQjwK1z4gUxIK8jlBEO4akriMPwc4d?=
 =?us-ascii?Q?tuJbXdnZOe294wN9A6+nV0ejyy3Ww41UEYNHkENj88nDeDxvVV1UcyXtLOph?=
 =?us-ascii?Q?sgB4IYoOAkKBuINoTpvZsojTbWaNipLavyyG0q1BXNzv6ZhnvhdtadYy558q?=
 =?us-ascii?Q?pT7jQC5td8lZvBcnv3Ctx33o0TrxcRuArrkosp2NEWjKXXA5H0nz3jmnSIbZ?=
 =?us-ascii?Q?34wtlp5kD8YXLgcEfSlDbOPKOr3QCN2zeeSWhtJk0yPOf/6MkOTzUoYUDQmA?=
 =?us-ascii?Q?fHM8uJVayIxQ0jqmWyGZzjwigLvbhyp6w4r+yDxvK6H6Po/OgGjA5/oyJiJg?=
 =?us-ascii?Q?QQrVoRx/KQqa26X42wAWQPjk88wu2WOb9wT1aROgzRNJ42XMBPZt83bKOpNI?=
 =?us-ascii?Q?2jLQ/f7yFFqzTQYoTuL0JKUZ2FPi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GuEFHhdFhe+CGyLoDeY+B3KRh/sb3WwkRgBVWU9X9Mg9XPrasgvRcQZgdhT5?=
 =?us-ascii?Q?t3PALVCImrdC+Bnpzd+qzm6eHcFFfgpc7WzHxyRnR8j0n4RXYwMlPHTHwKqW?=
 =?us-ascii?Q?6+cgNd1zHRWG4gSWeqYTbJcfCgBFYne899IdmKZToWTXCSfHyEH2x1UH0Q9b?=
 =?us-ascii?Q?U0kA4WzQLPczQ92/sZc9mp8M/vD57L/7GMI+3YK0W9NCH/SXztLvJxhhCxQm?=
 =?us-ascii?Q?gUqEH1vH997AzwKThLpzVrNZB2UV8I1mHEM/uOalIp7uFct9YZBQ6gu2c/0D?=
 =?us-ascii?Q?kfGYr5Hb8Tvp9fBxevMiXN/lGegY09IuMbcgGMyO87H23t9G69M4el8ekoJ3?=
 =?us-ascii?Q?emR9KKRuKoAWOXczb6HtVogpYWv+AIrL2NqInF7K44aQ6F6wMc7Fe6azSGKP?=
 =?us-ascii?Q?zwBN1VPQRXI+AVb3DF01vBlSEH5Y/kkk+JF4cVP2kKz+J9s0a4/v0P2WeqT+?=
 =?us-ascii?Q?SE0JskSM/1qep2+tLVerC7Uqy6xdzZNOJ1EFZoyqRsiZ6rBbiqPNdcMErKO/?=
 =?us-ascii?Q?dXyK6xJfX/OdthwRgliDA2APl0YHgi13IzkaJwHixPvLQMFJg2/VoPDD1zq2?=
 =?us-ascii?Q?Aizv85bU1zEwjK5GuKl3awSjOxgk1gmzubvolBJyw5j750gpvjyUKnqL6Ttd?=
 =?us-ascii?Q?int/4Mg9cVHTJ8Okmfwm1UHb8yvO6cHbEXXzGG3K97uZ9iPM+CYor2rIb6g0?=
 =?us-ascii?Q?9L6ku8c9Xn4o0QeQ4B+EpVi7d2SvvRaa0F/WeDaAwGipAFSeaqCQCdKAYLL1?=
 =?us-ascii?Q?S6eH7w092474QairDNkZQgmOmHGMJU7YW6EJb6zbgbz/gfQ+xjz0pqmHjgRi?=
 =?us-ascii?Q?FetZJOH5G0LH6edlmAZfs+9OVJm3gtkqRDF13cKpe9TA1xgfSMJQPOrqd+wv?=
 =?us-ascii?Q?AytQn7zxlv2bdvSZkIKHkHKVnXDRgO0pPEhIt9bktI3u5qATnS6ZC2UFGEoD?=
 =?us-ascii?Q?losHvweTbP8oxyC0SqZGQssPkF5jbexTOxkM9IyxORb9ny0qUrKOO02hNPrE?=
 =?us-ascii?Q?kseMYOQenqLf1UqBqfmZxUQJJktk/wwal2rpwIpju5l1+0xxKx+fHEuF1feJ?=
 =?us-ascii?Q?lhZ8eM51q7B9+FSdCGYeWkr+JMm0kd220aRMGLgihpSF9OfnasdlKEVg0+NV?=
 =?us-ascii?Q?SA+rzZo0r/1xyooi91KGwarLckxXKrRSVKeb4Z4tPtgo7a0JN5AwBob+1qa/?=
 =?us-ascii?Q?49qDUNgs3f6+RcToZ2bzVUynp5dopIn8XsCsosBFQ7shnXoKovURn7H3hm8F?=
 =?us-ascii?Q?bDF+jAAh30j6Dcn/lM7/ggghy658GKofDLmDQBdO6/I/gVY2IpH45Zt5sMq/?=
 =?us-ascii?Q?wXy7pfYONkB4RxDLOgIdMyePgOL1dwfVPBula03eO4LnxePDXXpIHdqcXFX2?=
 =?us-ascii?Q?j0ufWuL0sUHTDtRmGR/1SzzcZgV6lfgrngmbj9Jy2luYCry35o1jgZFszuWW?=
 =?us-ascii?Q?YjxzvcfKREE+wX29gP6OA2IFQLmJzFKruVqWvNChok1kKIAN1aGhC6SATH8E?=
 =?us-ascii?Q?g4/xJLL0pxgZafVEfQ2+g20UXgNNTjacGbkCaIhF7/3TgrY/KJLVpFXbQtJt?=
 =?us-ascii?Q?tN9RA9ufNBrc2EupDqvquklnkmvVyddsguhjS61TbXNSyGPOlX5ESrHAD7Ms?=
 =?us-ascii?Q?xzgLSyxu+l19nfRpPgfdH179NsPI+y9J4iLByBV4yV4mffPP0bKwbdOwE4rU?=
 =?us-ascii?Q?vLUH0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v1oxiTrv6iG1XJFqrQ3+kPBE+cvCbf1sifb5IeBekVi28Yy1g0KBCgzl8w2qLI9Tj/tPp7pqemW2986jhlb11q8uXjxIYopLApBNP10n+RzgNS4DMqHv9PtvZdwBxStNzHXqOB+sGSZ8XEuzWa/A+Fopeh+52+5IEPmVi05hD8bqGsgnyX94Qvq9lB7MiZpesBhCv++naKGqZAwVLQeJG7KEHcVRRhJR4YowsT6TeT7KpWcyfwGhxDaSaa+4DEY74Ff2jBfaGjkj52+t0b0e74J+Os/jQbC6VSvBKBIk+AKs+tOSesEvniFPlm75ysExa8A5vZAAT/1G0KK4SUh13/2DbkL4QXbWYmGJKzGFq6etdEqgH7gVYkkpdTCEtkWdTKWcFfSsVYr1ZKkexIZb9nw/USE3AWHZSclJEkLLKrsfg9OJz7rnA5ezr6xXeRldD2IKYEK6O53jJQENuQ8lJ20wRkCvvONyWj4hpvNYdjDxCQnzdneFZCxHMNQ/GkzaH2ybqcfCOi+LhrYocruZKc3MS9dh7h/HFNzdRWCANVz+EurZiydFLBP5L8FRd0RQxHqXXq0dm+QKaInB2U7z7FvL0+wE6v4IKAgKDPYEZ0c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a36c2cc4-5367-4759-7842-08dd1f09b9b5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:38.8902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UkPRAOfor9BYG/q6zWnDcrQ8qnIvLKS+9MWWTLqxk4viGbRMYnqvDMA1BgVGiq07obJV8h0RVm1k/21HrhiSM4Xq8m2LKyHWfLt6CCWV/5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: cp1TKBL6hyXkHRcxmSQBnQ9tzunF1pTw
X-Proofpoint-ORIG-GUID: cp1TKBL6hyXkHRcxmSQBnQ9tzunF1pTw

From: Zizhi Wo <wozizhi@huawei.com>

commit 68415b349f3f16904f006275757f4fcb34b8ee43 upstream.

I notice a rmap query bug in xfs_io fsmap:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
 EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
   0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
   1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
   2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
   3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
   4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
   5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
   6: 253:16 [104..127]:           free space                          0  (104..127)               24
   ......

Bug:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
[root@fedora ~]#
Normally, we should be able to get one record, but we got nothing.

The root cause of this problem lies in the incorrect setting of rm_owner in
the rmap query. In the case of the initial query where the owner is not
set, __xfs_getfsmap_datadev() first sets info->high.rm_owner to ULLONG_MAX.
This is done to prevent any omissions when comparing rmap items. However,
if the current ag is detected to be the last one, the function sets info's
high_irec based on the provided key. If high->rm_owner is not specified, it
should continue to be set to ULLONG_MAX; otherwise, there will be issues
with interval omissions. For example, consider "start" and "end" within the
same block. If high->rm_owner == 0, it will be smaller than the founded
record in rmapbt, resulting in a query with no records. The main call stack
is as follows:

xfs_ioc_getfsmap
  xfs_getfsmap
    xfs_getfsmap_datadev_rmapbt
      __xfs_getfsmap_datadev
        info->high.rm_owner = ULLONG_MAX
        if (pag->pag_agno == end_ag)
	  xfs_fsmap_owner_to_rmap
	    // set info->high.rm_owner = 0 because fmr_owner == -1ULL
	    dest->rm_owner = 0
	// get nothing
	xfs_getfsmap_datadev_rmapbt_query

The problem can be resolved by simply modify the xfs_fsmap_owner_to_rmap
function internal logic to achieve.

After applying this patch, the above problem have been solved:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
 EXT: DEV    BLOCK-RANGE      OWNER              FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:16 [0..7]:          static fs metadata                  0  (0..7)               8

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_fsmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 8982c5d6cbd0..85953dbd4283 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -71,7 +71,7 @@ xfs_fsmap_owner_to_rmap(
 	switch (src->fmr_owner) {
 	case 0:			/* "lowest owner id possible" */
 	case -1ULL:		/* "highest owner id possible" */
-		dest->rm_owner = 0;
+		dest->rm_owner = src->fmr_owner;
 		break;
 	case XFS_FMR_OWN_FREE:
 		dest->rm_owner = XFS_RMAP_OWN_NULL;
-- 
2.39.3

