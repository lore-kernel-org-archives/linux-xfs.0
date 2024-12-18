Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E456D7080B
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488091; cv=fail; b=eBLSKzgIJtebOKwaxMgKX0aBW5OEpsAni8/p1fB4p0b6fZPCuGaUZkkEhSXSwH6qtlawiC53YsE1pclwtrFKHcWFuGnVasBiyl/Y955O+4AilGymkFsG85KWtuYkR6V172GuB0BUPpg6/befMcZGD1Xocx73cb1qo2OUaRW6bQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488091; c=relaxed/simple;
	bh=GwsUUx1qm8EHRzimS5xBi1Z1pFli2DGiy7xplOkKeUU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aXwEAzvbe9gkU7j7QnYSMsHHJJ7wylObfK+/ux+Gpqm9+JeqxSLTuko1js+TkMzmEQ7hR7Rn724dPnRqJmDfy45tCzTlV2DL0ZBc3tTCVhj/9Iz82sKl3HGHwnGckLJv9vuSdz/PS9wTlAEuG+eTdBJK97J4D4pcz5qPGV0oFSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kcrBXSop; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uQyHMcPD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kcrBXSop";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uQyHMcPD"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BrOT001474
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=HY4nLa1O9te6j0Isr+qwLdMhpGzWwE/7k/cy9SWr61E=; b=
	kcrBXSopYg0Uk1s+v8aN8c5p/5wtRTSeLlIHK/+oi/blqZ5ehfh/n2/JqsZBW02Q
	KSqqgACofdiVQbay/tx5toi/2RR4fHNBhp0lXC5sATYzP69A7C2WdfkIdfGe+WiC
	HYa9axqLl9uvgYRzVkXQvFfps4ICadqfVb7EHlbybZ9AAc5++yXAdSBTXawCY/7T
	xQ44aLWh6baMZzpiAZO4CiZtUyzAJ5NWjjzcfZ7yB09HIXbOpDeXKFyZsBsTHJWk
	gOYdT17W1+ZGdPDFrJw/OYnOXzhk+DSSfPCBwnQa3aUnqy7BOd6cSzLmkuyuCldB
	RIJEKmDMO6ZZjb+j8KTP9g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0xayk77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BHNo3ds035452
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f97yj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HwsoK0oAFAQwP29VRVekA2C6YCTMqsxKmZaBtgQseV1z9o5B/CWHR/sVtvgWTEri91mwUpfyXt/JWnpKcq1bIbT9hynlxN3+ZOXNapALQO3lLGYAtxqdpKAKWg6MNZRmQEPzlEGDG4C93JsiGiwaiPkY/Ik9yLe9MMzIIxA7hc+iKwtTKOLUw1KIIovaVCsr51O2ebDKOwxcRPzQ7JMIphHnr0JTjEcjQU8UOi0rzwaCrOstWsVwljtD59z7U95kuqPplK9EF7Po+J5YneqEx/g0O5P87h54dii3NWAA1YLaqmxpVjrDmDpHzN+zS6FnWBoQHax4sHgHDQTjTn3ahg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HY4nLa1O9te6j0Isr+qwLdMhpGzWwE/7k/cy9SWr61E=;
 b=vYB5fXjjsdFHx2yKUk/VaIPCec+nmtsslCZ8b+KkQlOa+mGnxFB3iHPVOctsgp9tslaLWy+AVeVcc3q/d9BV7xic6jPtUXPz9M00+15ezpWzurxMX9Kr4AHu6IOEi3gmIl6sPBRHeoXvtAJe0oRmSNTxjHvD9ufWOJLOQegUK/HXv62uAMAAfwmfCTukbeT0ggOVJBrvPwvk+URRD8pRiA6HENmNfUkrcKxA6zmvYKQlmmxAH4Y4A/SdIMEXLbcyUcKrbqrxwqVon1GMx3jYJq+j7jsll9dZpfMErswWJjKknRLa7GjHvDcOnrTSVJ6O2SK98TAdLGzIW4TXp4Nakg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HY4nLa1O9te6j0Isr+qwLdMhpGzWwE/7k/cy9SWr61E=;
 b=uQyHMcPDBEy+yfzkg2kGl6UziXy02KGcKsGxI5PIHLoiz48WrZYpvAHSo6Hvu/0kMqmpsI5gaYLAJDyWvAHHu0OihG9qXclNYXUa1IGiq+7i8l+SwAvdXozs2+mQZm6mZL5rvB8rdXIPopjBw6nBqGEe66qaOh4ErzzxVm0fJDA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7577.namprd10.prod.outlook.com (2603:10b6:208:483::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Wed, 18 Dec
 2024 02:14:44 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:44 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 17/18] xfs: take m_growlock when running growfsrt
Date: Tue, 17 Dec 2024 18:14:10 -0800
Message-Id: <20241218021411.42144-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0198.namprd05.prod.outlook.com
 (2603:10b6:a03:330::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: a42bda28-d07f-4b2b-8e07-08dd1f09bcf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eCFjSvFSj+bv1WpWhinnXUNwtbTpIp4W9+Qa9QEvvU6Kngu9GCyA51gG0i9S?=
 =?us-ascii?Q?n639gPGoGbGQOV2Adj/gO5TuR0BEdWTqtfU6R1/0To6uJBDtILRPqmFfn6Sp?=
 =?us-ascii?Q?6Bsfg2JStJs8WuoNB5ZFSGTUL6WfAZrDHLH5KXU0C/RRRDSUti7DLEoOpPmC?=
 =?us-ascii?Q?ZD3S6y8vVLF64GbLyG/Uk23TBoDawD7X6tNG7A1vHIj1bkJ5gklU7weTX1AH?=
 =?us-ascii?Q?PV4Ykb/BkFx3f2sSMfd1UpyEGO0zst4RlzYX7EnEZsop4IgMK67Y6n2Yv4Ax?=
 =?us-ascii?Q?GkGIzaFouabcWunDRsw/kHx+LWLlV2s0UyieHEHOpbhfKN4t3FvMG4D9e8k4?=
 =?us-ascii?Q?+sewQtB0Vb8RYWnfuguxzj65os8WSgmos52ovBS7i1qheN3ZvchHDCgeoyzQ?=
 =?us-ascii?Q?NMl6AJfNKcnbfvaQ6zfwdeKWJuZHLCP8SGWXSQazZI1wlBbqLQ/OBhE4EkQZ?=
 =?us-ascii?Q?q0ZF7OfZHHpyFxjpLQqAoGLW9dROjS94xgrB33oKyB27H6vN/n/iFptlzqPM?=
 =?us-ascii?Q?vHrRV/YgZiUSC6ddRX25DSCzHqbX9FZzQTpfShgHAUuSyYDY9xN0GmRWn41k?=
 =?us-ascii?Q?pYhIV/GZ+qrCO7DkCJ1PsFKBZoCskvYPmZCJFy950u99xSTrq0VVjK/yLQ2K?=
 =?us-ascii?Q?68J7mywKfG85eyThhmHsvHjgsRwQjsQjhxTXk22KYUF+bNGceT9v/siI3whd?=
 =?us-ascii?Q?VezIfaPTRJbk5I/vRN3k56s7+QV+BM9Xv5XdpZig8vBCgKgVnhoJ8lDq2w2f?=
 =?us-ascii?Q?MuHaZPkFoz3gbv7xwvdQjevj7Fjl5C/jK2XlqAdZSxrnPj4DrzGUusVKTo7j?=
 =?us-ascii?Q?tnsD8dUNegmj13hLwaOOtOX+Di3gQ/lE1CM3MBsoj4f8WDM5HT8gOq0g7mXZ?=
 =?us-ascii?Q?qs06/w+f5agUyZyEGKIjLl4EXEBd1cHgXi+fko3bfL5l/VfPWgHDk367/R4m?=
 =?us-ascii?Q?jAC1LWvqELC0lHuACYXc7tjVk/V5wSWw4RNO8UjPLXlM+3qdie26/aMVpFsJ?=
 =?us-ascii?Q?2SKtl3sXq2wnAISvxE+A8IB5444W8Mti2o9YwW0p4ZT2xdonIH6k39VVIIoy?=
 =?us-ascii?Q?MsjCZFmV4wzdtNJADiqQdvCx0YqCVhmIJBkusdg5fHuTo/gT7VfvL+Fksv0l?=
 =?us-ascii?Q?agyfKG5OQyZ6MPZA/ysQE9M/F8W0GT83h8BXwxGuv6apLKSI4xMNqFK1HIoK?=
 =?us-ascii?Q?oKgI/1poq9q8XNKGo0g087Dl7HpkSQrSl1EEctkcx9Ye/Y14Higin6a9kPMs?=
 =?us-ascii?Q?AtMDP2LjWOFPcwrcicZ/zQ78Js0657sdFNrk/EOz0m9d1TAPcbLhNlfITxf4?=
 =?us-ascii?Q?zzOKVnHO5Is4l6BiUpWVq3D4+/ILVvis3bJJLI5cD7iR/RjOztdmiRsuohEG?=
 =?us-ascii?Q?9Xs6wZs14PgZw9Rbr/ilLXtt5spp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qnJt+JSicWoyri4ZWLHQHscMjnNT5cJyID3GpsdpEJP0ueie657e7y5pCPVg?=
 =?us-ascii?Q?9O4pOtUPYFH9utGjvOHph6Zb6bz6YlyxD3oShoSRF5tAKNxsqxScWtMa7hU9?=
 =?us-ascii?Q?74CIiVZA9+GEAJM+vE7APGLaLAQCmfGBa+A1HYJI+AgfnwcsMckihpM0/to1?=
 =?us-ascii?Q?vPAGgTTWm0sp7MSNFNALpWIRbcSkeaZnl05gyIQ4i3Fu95xJDMD/Dfc8vHUI?=
 =?us-ascii?Q?Zyz2Fzy8Eiw0nWPnZbYDh/FLBHK3Lfhw4fQY9Rn3rtB6/gRy4O0a6TcMYYz9?=
 =?us-ascii?Q?1AVD0SppAZUeG/zvcJDYJQd8zB4lpkzsI2+wOg1wijSTcm8T7Mr7g81xjqMc?=
 =?us-ascii?Q?Mb9jCdzMfCOCG0skEdxUpof7RJ8qcJxhN/x/rOm00YqhN78y6x3jFZdJCvm6?=
 =?us-ascii?Q?i4SakiZQqZD2/K76hWKJObQZNkcBN6O2hCOs5LYMZdVTW6ZczTtNzNnYJWXg?=
 =?us-ascii?Q?bC0uYrdy58ZTHnXsemnos8J+TQQ/PeP5UpFxoNHKSJb8X+hET056p5uitEKg?=
 =?us-ascii?Q?jdKJ7+7nqOlXyvy4uhAYwQZwqF+GbsSzJhlgF5lBHm0ZBUF1QPWxd9XpuQeU?=
 =?us-ascii?Q?QioSzaaaMSZXwRCN1PLCnGwXM4RyevH20KOUXHv7mRy7cYdeOC5D7QkVO8OE?=
 =?us-ascii?Q?tyg2ayIt0iIlYrOCTHo9HJx4RWq+Fw7/OgYQbTLHcW3dJ09dYl84JaUEvJG6?=
 =?us-ascii?Q?mVNjIvOAPMntyH7vKi+spKw8/I7BG7rf1LVrvN0nOO4AWd7aJCuLnP93FKBW?=
 =?us-ascii?Q?Cc9bfvAr2evIzULikS7qH+uusMNwlNTQ7AVD67t1sykNhRcvWo7wFcFB0lBH?=
 =?us-ascii?Q?ZU0xKrSYdCSzFPpg2jtI9hy5O7k6+CAd9xYcYWz2n9qo7U7koicvwl/RIVHK?=
 =?us-ascii?Q?o3a7QM7lXgzLPoHKgRiiHOGYhHpUHIX9qXcy66IrQqkq5h2Jp8Vp7VRZThFo?=
 =?us-ascii?Q?5KL8mfEYIcJOKIUeebBTR28fgefPYKW+F2ItADR0UZgPJwNEdqmhevLpCuU2?=
 =?us-ascii?Q?QHvZVwPNyC4vdIHhLDAyjxkI62ZRw8DAzDcIUQ0b4n9dkIr/bB6y5dJx2W1/?=
 =?us-ascii?Q?djucz/hz+iai1UreQ3PCJ1p3h9aGwzI5GxHHINJOrHoJ/uFe1V9iV0e3s9Sl?=
 =?us-ascii?Q?cGI+M44xB3LQpF+Rk0WruPEOER0yzTavnBulg41PYD4nBrTQRryTlErkaIpH?=
 =?us-ascii?Q?5uzinU5rryYCn3Ir/VwOwKSMwlBCCPlqu/P4BkNXm1+vBlDLCWlKBTzD1Oaw?=
 =?us-ascii?Q?wFhA3+WeW5cTJTanhpvFIOvH5p8YFcwvk7QRKrEryCdMdMyOxRjc5DVvdUMd?=
 =?us-ascii?Q?ZfmPAt2NExyc3hvaBvMcaaI2ZAeRnb5T+HIb8mCoysrs5H2BdMmG6/5QLTNc?=
 =?us-ascii?Q?s2/Dsb4WUVEphIjvSqw/b/yT+ARrsXiiEcKOk5bM/2DSsXUSjZr4yPgT2AZ6?=
 =?us-ascii?Q?84g1Qevghrb5pysMM8uVhwXLYIM9Zv9E8XnyJartNSOoJl0IGFnD1uL8q1VR?=
 =?us-ascii?Q?B1/43+Rho3k5n1K+gm2bc+8dV3IMNKtTFluJVx8Pi6q/AEZtbmS04TuyrESy?=
 =?us-ascii?Q?YeFO1e+xK1aPZA7XKTkZCKbl3KjyGKYXI/KLNPopvFbVHd62oouxKD/Bidil?=
 =?us-ascii?Q?3V6OLqkwKa4ubpZp+f80aAOo5YLYylWjvvdK4N5oU974WLGrNEnrF1FpHvIH?=
 =?us-ascii?Q?QE0MGg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U0rc1IRAE0Qi9dQXQuDOGqQe+she7+PEsAWDfFiCbKJLIpJhSmPBALJr8vSR/ukBbjf4XIpiGB1l+kV0ROTnmjXrANkDn9yEudCKygu6HJGqkxJ7F6SMHsiWhotHfPJ3jVy0FqyIS9HBnh5ht04rd8J+JCOT82JY6ZdBQCHSI6CAj64LVr/zwSKz4NdYPkN0AGltbOGXL7Q4ySw7EJS0KaV5VTYYBZcUIrjT/EjuEhSijvjhzY0fk9aOib3LIFD4WXUz88gXHRhKtHsK3HSw0LtUkoUTTXKELxPWz9BWXGjjn4e8PrisgC2zs4XpMco1Rh6vgXhYd0gV6rAue9JYnrsMjbXNFJwBSKi0gbkf6VkrQzXkAis3MR6pMpmzGxanQyvGr07g4RkkC17R5YTHWhcikxmudCyas+oJflqew9Of3NwF/L0GCQfYX26FgWBZol+eu/J9DErmactb8dEmrcE3DfoO+jN58ffeK+YW7wanN++n5i2xDO2hgmM2XDPnS+mra8ynYAXjY/f5Xx5Hn3j180+/DEHvOhbjYQnupjT9K7tErhF9oXgr+a5SQpVtlrFmvBY7cIVSpYOpm/5CGgS614+RlRmRBdiZ5UVQoaM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a42bda28-d07f-4b2b-8e07-08dd1f09bcf4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:44.3514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWFISjRrb8kyYGJcOju/s98C9JbhnLSu+t/Wi6Vl4c9dCs84/WNJPGRsosmrvd5JYn+vcK8hBvbW7i3R5zRfWfOreIwpHCkpfJfNh+Ml9B4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: z47kUkdRIL8Z9ieV6Ryi0hT8m2j0HYYs
X-Proofpoint-ORIG-GUID: z47kUkdRIL8Z9ieV6Ryi0hT8m2j0HYYs

From: "Darrick J. Wong" <djwong@kernel.org>

commit 16e1fbdce9c8d084863fd63cdaff8fb2a54e2f88 upstream.

Take the grow lock when we're expanding the realtime volume, like we do
for the other growfs calls.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 608db1ab88a4..9268961d887c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -953,34 +953,39 @@ xfs_growfs_rt(
 	/* Needs to have been mounted with an rt device. */
 	if (!XFS_IS_REALTIME_MOUNT(mp))
 		return -EINVAL;
+
+	if (!mutex_trylock(&mp->m_growlock))
+		return -EWOULDBLOCK;
 	/*
 	 * Mount should fail if the rt bitmap/summary files don't load, but
 	 * we'll check anyway.
 	 */
+	error = -EINVAL;
 	if (!mp->m_rbmip || !mp->m_rsumip)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Shrink not supported. */
 	if (in->newblocks <= sbp->sb_rblocks)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Can only change rt extent size when adding rt volume. */
 	if (sbp->sb_rblocks > 0 && in->extsize != sbp->sb_rextsize)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Range check the extent size. */
 	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
 	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Unsupported realtime features. */
+	error = -EOPNOTSUPP;
 	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
-		return -EOPNOTSUPP;
+		goto out_unlock;
 
 	nrblocks = in->newblocks;
 	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
 	if (error)
-		return error;
+		goto out_unlock;
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
@@ -988,7 +993,7 @@ xfs_growfs_rt(
 				XFS_FSB_TO_BB(mp, nrblocks - 1),
 				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error)
-		return error;
+		goto out_unlock;
 	xfs_buf_relse(bp);
 
 	/*
@@ -996,8 +1001,10 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
-	if (!xfs_validate_rtextents(nrextents))
-		return -EINVAL;
+	if (!xfs_validate_rtextents(nrextents)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
 	nrbmblocks = howmany_64(nrextents, NBBY * sbp->sb_blocksize);
 	nrextslog = xfs_compute_rextslog(nrextents);
 	nrsumlevels = nrextslog + 1;
@@ -1009,8 +1016,11 @@ xfs_growfs_rt(
 	 * the log.  This prevents us from getting a log overflow,
 	 * since we'll log basically the whole summary file at once.
 	 */
-	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
-		return -EINVAL;
+	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Get the old block counts for bitmap and summary inodes.
 	 * These can't change since other growfs callers are locked out.
@@ -1022,10 +1032,10 @@ xfs_growfs_rt(
 	 */
 	error = xfs_growfs_rt_alloc(mp, rbmblocks, nrbmblocks, mp->m_rbmip);
 	if (error)
-		return error;
+		goto out_unlock;
 	error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks, mp->m_rsumip);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	rsum_cache = mp->m_rsum_cache;
 	if (nrbmblocks != sbp->sb_rbmblocks)
@@ -1190,6 +1200,8 @@ xfs_growfs_rt(
 		}
 	}
 
+out_unlock:
+	mutex_unlock(&mp->m_growlock);
 	return error;
 }
 
-- 
2.39.3

