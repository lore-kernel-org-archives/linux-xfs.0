Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1221FBEAD;
	Wed, 18 Dec 2024 19:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549476; cv=fail; b=IWnRLghuvZmXDJneU816Dr+foW/6gp55yycWg/JPm543EzWoAAKVAAgvZ6B4BVvuNj7o3G3HrOHEderaoyUfeZ1KiuzhpeqUZ9qhBbMKpU3yPogWMpIpfx7OWPijmRj6s95Eo7bby++XNrAnOk7jz7JIlVpOkE/EblKj3g40hGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549476; c=relaxed/simple;
	bh=mK5cvSej69KOTCBcWeRUethCUN47dGe1ow4fGJKawrI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gIli0oDXglYeRITFxFsOJjDnFiABofMlIca/EtEVJIozxDnScnafbriAl/mDU5F4cW4MHTMQIRGGTg9bGDYTsA1Iyt3uL6Cm7ILsW51H6p1mhKIQ1AfwDDiiHkau+4jVerIY0ZZP12JsSO3mt8+7Dg0o72IfcLixfwuAzlNNWgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PuP3ZCCx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vUxy6X8L; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PuP3ZCCx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vUxy6X8L"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQea0005643;
	Wed, 18 Dec 2024 19:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=OtafdaNCMfmpWvH4shF/VFEGUHw8+wrh0Mcd14NRETM=; b=
	PuP3ZCCx88BCxImMMF9GT+fwMFZqzDGQuTP+9UbvtIBONjmzOUK2dL4ymxOFOozp
	/ZQP4qZZxs4C+vdSQWptAHNbwdktofvv3GWbsgOCmZU8uDjztHRI0gCWjOyPZPPF
	KWqcJmuYkDZmebeQxZyLnPn+ftryxaK9IHqltaQqzl68UpZkKqapJxZlY6zkL++h
	0fmgEDRAOxI2DBXNqcXI49BiFWLVcrD8bN4aBor/XAw/bSs5PnKzUwwM8klSPjqU
	uYNG6+T70VqftSeJkDuGmS7cEJkLgWgdA2g4OMGcg0aOgEC+SvjeAO6kqJUqrbPr
	6/tHTnx/YYyO3gZKsAm1+w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec9bv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHdC7w006388;
	Wed, 18 Dec 2024 19:17:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fb4mb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sB7V6mfCl+cn/gS13c1DDM3lYYRsSTGtHa/gCLUeXJbXTxIrlE+XUmkj7xTlDUCKWC9Rvq5+Ne8r7iCtLbY1o1StD2h9f1/djjWbMfCAsQCCpP6WupZllyUk7ClbfmtfD6h3RHBSyrEi50Wn2XsKPCcDLhmgwKo7So1MAOEatdz5Dqd/QYhO1d+48GXR0mfqyF0mAHgaTU9JkSXpzzNNTPAlU8aveFxJYjBZ4vzZ8Xx7gm2AwPRfWLoQYSRSsrn6iDDH72LBQv2pTeicRe8nQSYvAoCzV8DdLNfx+MYrVINShU9iWyZE0PWy2cBQ9oRSIPUyijeEa+1c2RKvLHjwWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtafdaNCMfmpWvH4shF/VFEGUHw8+wrh0Mcd14NRETM=;
 b=OqnWU6RWpgL4zT7Eg3V7+3ecWUvYtf2zOsmrH704VehAlbSgiruhkv+MsyfODPXJhMBI82SZ/KnsF9HiQScH739R6vaFYLTPZQ97g+ReRfSFy2OV36/jp5Y92QJ80nvcNeL3BVgvy6Y1A9Ido1tJWbHhYahwM91jgOvX+TRnNLA2mv4Qti8o9Syko4+MlvJEDyV4Ra21nprnHSieSwBTXe/XWIMTGCEawvhfmf0K46obx7zw64KrHEHpeQsnb29T5tpdVU0Ey95vvhKJWnBVkl1WNXL80Y0DqGtf1ooDoMSTkWZAhb+y2lsgfF+qReDGvQL1jNIMwlsGlg9RVn9YIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtafdaNCMfmpWvH4shF/VFEGUHw8+wrh0Mcd14NRETM=;
 b=vUxy6X8L9PjpGVn1LtFB89lHdMnisvgBsINYMt1LcWQUpco35ZCt6eNV8+xYdWB0gaR1I7jyUs6MjtIS+YAJXK7OhAmGyaGPcLTrlc+skZOhQuVE51VS/5L1Wwt5uLkBXMyFaBtyPX/pByK7UaefJ9qSys5gUA9Pvarp6RI0KA8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:50 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:50 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 13/17] xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set
Date: Wed, 18 Dec 2024 11:17:21 -0800
Message-Id: <20241218191725.63098-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e15db9b-4147-4ba7-5653-08dd1f98a9eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7PcEq2fsnt62x+CaLFdh8J0TSp09Sqi4BvQA/sIOHudeo0GYJy6Ahj1kq6NG?=
 =?us-ascii?Q?ZAug1fV20Z8Si2MkpIazQzzOLfBBhHhcvPukhVx94fu38P0Lyvl8U4oUSELl?=
 =?us-ascii?Q?O8IalDh2XlztNShXYoxb7aeZ+ZBzMzU1PJvxZj5LQO6BBs/AWe3hzeuNhDHE?=
 =?us-ascii?Q?SEPbJE7xR++Q4oxnY6kjJMf8YQcMBvcQu2C12IK1/XpXENQ1g2WKSQ4ge3gS?=
 =?us-ascii?Q?a4j1Go3Yk0AXnnPWu3Kru45+paW9Sm7uuG3usbab+owlyKx15xl5zHoyiKGO?=
 =?us-ascii?Q?Q4ey/rLn7506NdGzl7cRQMiPy9ZXyJ+asF2NvJ0nPa9/dlORAM4p+z4J6hyz?=
 =?us-ascii?Q?J9uuWNzu9GDC8tsWIPrcrMMwUYxRoo4mM8c8FOdaZcJpHyUyFdJ9bHpMkGtQ?=
 =?us-ascii?Q?Ka3IvsVmsgXJ6zq2CLI5Xh6kHpr38stHvrC6hh7pi+y4tzweGBVkJDBKs4Te?=
 =?us-ascii?Q?I7L5tUzKbc5mwwT25lIgYvatLNZS6Rip+3HTVVZ3RQUbMfTE74vlg63DMzke?=
 =?us-ascii?Q?ZVw61HqrPgBgDw0XjMnj3AGs+EUGYIaMUpF/upzc7hAactv+FYQMsychW+oQ?=
 =?us-ascii?Q?W2ZBZY8oy6MSTqISV7Yf51JwmNw0Bc6Ug95l4upzVDfKnMJuQdDN6121UZCg?=
 =?us-ascii?Q?Ox9BLLnE3j4lfnUUbRzGqhgqy0sgdO3C7zVBJZQh72mtaBHnDhH9u46Gy1iV?=
 =?us-ascii?Q?5h5XLU4bTjICvfK3L61k8QrYDKoxmMTSVDW7L3Q2yaTPC7O3eVi3Ja5GUTss?=
 =?us-ascii?Q?9SneW0tAHDMeXxn/ZIf2m8kZ7cR/hkWpuQef3br0+kBWjQ81TDS6NB1G99sc?=
 =?us-ascii?Q?YDrlqzQRtPcED4rczcQtjdrAUiwImdeZcmHFyQO568eHp4UmNNQpGsc1gN9k?=
 =?us-ascii?Q?Yy8pQ3KZNJrn8zOlaKzDGEfAhP1rlcdTtEWJ8GbtnxTWiWcXzh39Hhqyqr0y?=
 =?us-ascii?Q?gctXYQDn3P57SFY2VhelC26ibdS14vgZ95fXdwTFcuZ/GDth1gXVWlMGJdkL?=
 =?us-ascii?Q?MKJHsn6REKkkzQhsgwdleML+/cmYSAzbCWyE8RcnNo/Dp+Lvy6Sc2MX86z0C?=
 =?us-ascii?Q?JKGTvVEm7sFfrP2bgCpYbbq6esT71aVpOKX+zZ1pyzM+iu5J1jS1keW2n/MB?=
 =?us-ascii?Q?XWSn/hj3cROS2eci5APaJpA8rTHDnyOswKLZBZPvpDbCEDvbGz+ER3z0Mmfi?=
 =?us-ascii?Q?XsVOXxVmQe6MBMd+70ioKrz4X2yWkVu8cbzoMu5Srowx5CjwMaj3S6o85Xxx?=
 =?us-ascii?Q?7zASoDrHTec+Ve6G/919zVCADHg1eKzQWMwmrijjUgo0kEkpEy8VUaJryawD?=
 =?us-ascii?Q?q0m0cVlqZnfiFtYUFh1QQFGTwNWIn80s8yyDa1LyyNx6n64dJlcSzaKsfLdX?=
 =?us-ascii?Q?GHAfCSnHiO1mHdFh9HHd5FQyVqLY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/aw2UsB7nnBrtTYRkRTyaOZ5v13ZT/2BEdBERFXtmBrNEP03vL0odYEijiK4?=
 =?us-ascii?Q?9S5POcePhDaOfQylFUQUepHu0th2A30Md4PDsgNKgc3Vd0lU9GLBv6L0XUIv?=
 =?us-ascii?Q?47LZUC5U1ZvmaJRmRRaOIyXpYxJSO9JQutXG1xQgJqeQ0zUA4D4ecJkSEEZA?=
 =?us-ascii?Q?ElV5Ein8kADT3PDhahm+8ymNOA31OaPL8qpTPodGFgZvnEcsnAtGpAZOCFbh?=
 =?us-ascii?Q?Tcr+h4jFQYuJWDpQJxfsu8DAdPYauTYnu6NgiPoPmdtxdUfhNX2i1LNGXcAy?=
 =?us-ascii?Q?yDifdXpXmNT7skTNlVl5Cn53+zoCCafPjcFJayC65IPc+VKra/T6sOXa40hY?=
 =?us-ascii?Q?8O/vmVJo7zSr7m3LDP7GcSwdW+A/O1It4ycW04CQnjo2hbP81wMvdafTiYMb?=
 =?us-ascii?Q?YAHbTIZl3gu7wBjiQFI8ZZRIfCMAcABYrPraCSO/4Ae+XjnT8Zn2NOGD05ae?=
 =?us-ascii?Q?Vp+nqMhgI9K28aq6PXbQYDE4cqYQv29XbTo0m9QsUN+7omhDz5vWNGX7s3J7?=
 =?us-ascii?Q?QwPBW25Xwax53bSzEGz9QgL8KEQZ+eYnpty4X4PVFtLno05GI6zoXI2Z0AYV?=
 =?us-ascii?Q?Q5+dHtA+kiI7DMSnxyvJD9QOUfoGKm5r3Rc9Z63U5bOQIvdqfYar5SsD1qIs?=
 =?us-ascii?Q?Sj6R5zttazsS31hGuKUh3viY2ASLV29ZXJon3kTDW4yz+5yWf02LoZE5Yrfq?=
 =?us-ascii?Q?w69yHwbZ/R7jjLijb14tidAPUCe+GGk4MmMpioQM/whNQzDKEYI00CY0Ez/K?=
 =?us-ascii?Q?VHYhjOa+dfb9bCvSkg2V6XOss0WE/U7YZTcIxao9qUh45c4D8uw/wH6ujLv/?=
 =?us-ascii?Q?ZjMOWY0TWIc5oewrGZxd1m3wm31yJFr15uxEdROH4RzAKG9Z1SuwW+xAdaNt?=
 =?us-ascii?Q?Yfm3rdFFKPSoJuE7gcmxGO3S8Dq5iMkZ8I9q1IKIZhQwapSdUFLKGjQX/QvT?=
 =?us-ascii?Q?dfaGCx60Bzb2ALsb/119UB2bRPRgRTXwZIACHy8nQ1FhCmYyBtBVRvbY5uMc?=
 =?us-ascii?Q?jC0xfApsWch6u+uDDkbzwWMy3kxP3tMvR5keK30RAsZMpYxBAcfA2WORM5M9?=
 =?us-ascii?Q?5kaTJi1JPQ3/FR00XV65vPRDaZKqGCGALttTr/lM1HDzm5FoOEkCj4y0U3Cy?=
 =?us-ascii?Q?jJdvpLQuqDiHuLdZYlgHn9o3o+KTBBlt2BENvgrckHytA34uCuz1SZZLb3xt?=
 =?us-ascii?Q?RV+5m5EJVNspPYGvA3WJC6xlW51ctR6ZAq+pS5IvM/GUISoXTqFKGtfAiR5j?=
 =?us-ascii?Q?4/Koo8oBZ9NYIc5+DOipkU0Mp+QqT5BPeEUwmur04rrSW9XJ0jnBQYqCcOPo?=
 =?us-ascii?Q?Ug2Hzy2nt2t6JkCg+ZeQ49nom1dtuyYb41+VEbHogjeX3i0faI/zaFsw9J05?=
 =?us-ascii?Q?GdQ+qyQNhZwCEbBaeWoNVz0gPqU8fsE9BZkBoIXjFOmTlqKigcwKm3sIfcdl?=
 =?us-ascii?Q?BJO7q2uyb9Njv32XxPp8bz6bnmuOA76OyVhGzYQnKdkQzy67NycbWSsFUgdw?=
 =?us-ascii?Q?AF6D+hemEL2Q9Z4Y6jCoJvSSFEQrK570UziND6Um0t5L5e3KiH8X1Lfmvey7?=
 =?us-ascii?Q?ZWJT1AeblWfyoA3Ibt+fgajAHdmXPQrQlioZcT7cMbY/jBCddOqOpSF0ndhF?=
 =?us-ascii?Q?pmOM9Wx1728jfgQweoTpnjOICG+dugNYS12bSRYiFzOuetf+uRf5CfD2fQKE?=
 =?us-ascii?Q?ObeiSQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W1v6v6NM1fTBz4KIJTnwoWVGnYspUg7eorNYztv2EsDzmVpZIl53bbIGSIeEzDi5NNV7nCJVBtiA4BlkYaBPbyHMHILFaSreL6oVisqpN+sVpmhMe6IlqRVOhiYcr7oAeqKOA/rmOo81eWcHHvKGtfQWaSE48kTTy3mz4agVTcQxYi9Y9lux+cD83nX6wonrx/uuT0N4mIJPW6t15OGPP4UeoVVSpSYssFKLGoQKGtAl4m3YbYSFxMTXdnfxgvfXq3Y212TJbLoikYc0EhfgqV19k7dvesov4X2aNo50XP2fGK4b+z09phEnx4jlYD6Im9wtWZPFk+beobHRexg4S3++5u82g3+PNrSSOqRht9eDnluyF4z4tPGba7vk+oSZbD53KZVJQ5dKcgr2/EAdGb/qpNYFLxFGMwvz4Nwq9htf6rFw01CfZSjJjZ7pVVcGhm9ntKWBVgt9b0+YG1nNmQjKgr/9G8WM3oJikb3OMBPnfOlIquYbzlGIq/Z+FInUkWxZ05O9yjKin2vicwY8b4McCGnvi/6qEWIg6KkBM6yZTQS+t+/yJf+JIVsubWJF71dvr0/XXgPCITy/sWZZ8FShltFs4jW/wi4Qax6QTm0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e15db9b-4147-4ba7-5653-08dd1f98a9eb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:50.3731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CWnLpyCKGHpsRM4OI1LvfwiL9Nssc8tYaRdJwtPG6ZPqImScX7YnQgkb5cQj/+Iv7Kl6Gtq/Eo4WVileAdv3k9sjvrn+YU9ld60fwTO7YPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180149
X-Proofpoint-GUID: 5EsUpoV-vw8uxVgUZ-iqJ2L7OHIyxEnI
X-Proofpoint-ORIG-GUID: 5EsUpoV-vw8uxVgUZ-iqJ2L7OHIyxEnI

From: "Darrick J. Wong" <djwong@kernel.org>

commit 8d16762047c627073955b7ed171a36addaf7b1ff upstream.

If a file has the S_DAX flag (aka fsdax access mode) set, we cannot
allow users to change the realtime flag unless the datadev and rtdev
both support fsdax access modes.  Even if there are no extents allocated
to the file, the setattr thread could be racing with another thread
that has already started down the write code paths.

Fixes: ba23cba9b3bdc ("fs: allow per-device dax status checking for filesystems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index df4bf0d56aad..32e718043e0e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1128,6 +1128,17 @@ xfs_ioctl_setattr_xflags(
 		/* Can't change realtime flag if any extents are allocated. */
 		if (ip->i_df.if_nextents || ip->i_delayed_blks)
 			return -EINVAL;
+
+		/*
+		 * If S_DAX is enabled on this file, we can only switch the
+		 * device if both support fsdax.  We can't update S_DAX because
+		 * there might be other threads walking down the access paths.
+		 */
+		if (IS_DAX(VFS_I(ip)) &&
+		    (mp->m_ddev_targp->bt_daxdev == NULL ||
+		     (mp->m_rtdev_targp &&
+		      mp->m_rtdev_targp->bt_daxdev == NULL)))
+			return -EINVAL;
 	}
 
 	if (rtflag) {
-- 
2.39.3

