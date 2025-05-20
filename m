Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA01A1D89E3;
	Tue, 20 May 2025 01:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747704858; cv=fail; b=GofDFtFtcS2/HmZNKQrZ6bIRvkAlLYDj/YqxSBKREoovGB0pcXeSzCiA6F6d2o23ZlFmPu54EgP6jo0ybgyuw2W2cBg2lhmAB0x7vKWDfuoi6XDBcJu5u5XS50IPAhIRX15hMqjDs6PE5vIiixEL5/x3wIlwgJqaRGF4aqur7es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747704858; c=relaxed/simple;
	bh=2MmZaF+pnBpAF/yO+UdrFru9Hq2QV5/UDDRzKSQG2Kk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Puf9Pnbb+f6h9VC8fDFvFtmd3mpEaU+gAwGbCDbBgJgPe+FamAxz4xxEThlvVRe+aVX/PO57YfKpz/AwFc7FZqrdTXmBxx80/fvIfELDo8MBIv/brLhUT5i6d+Sl8TD6aXhv+q4DPBxv41jdiol1T9qAgCDjEdbX5HyrEILnLtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CUaylKj6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HyXjXQvA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CUaylKj6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HyXjXQvA"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K1NEq8001383;
	Tue, 20 May 2025 01:34:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=N8ZRrRPFymfa2IZB
	Wl1eeP2ECkEn928Ev08Xryfqafg=; b=CUaylKj6ZwTf8GBPeDlHmAzEWLMuuHY8
	nqH8WE8HhbUhMptM1Ni/NsxQbadpKBvkKPHgwvBseh8YF+PSrkS4CBSu251bhLz8
	HFc99CdzPljRO3Y5jZu2X+QjuwEHBCzfTGKs3YBvhjvetmhW2irhbWBP1Giwg8oW
	QWN5k2j++vvHs957CDy4WTtXvKVHDGkZChPJa9TR9MmeDLcz7m39IzlLoH5/CM1Y
	wslP4LRGnx+uaSrlpsV5HAPK5Dycla0XKKET6FaUZVj1vzrCPIzzAShko485KzdC
	4Uw6+SNRkWfcqgLVXC0gL3aFfF670XFvW9uwDPhZuXBYV8MESCT/9A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46rdtj852b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JNloAa037258;
	Tue, 20 May 2025 01:34:10 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010022.outbound.protection.outlook.com [40.93.12.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw84met-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N2C1QeJXWH/XuJ49muwmtB25tPgnUV9Ckty2ag5j5gdN4UBOe/qPfH3hLPBqj2AxQxrr9ZKJ+hn27kIyQ6+Go9XLZWe9mD/Oa9rECHAS9+iSQCBnFpYHcNFUqz9Y3upNJCyzQ0PaKFHpmH2PI+iMmhx1i/JrcoovArh7u4TC64kqWEowLF5jLFL/Y4gqRTHprzUFcy4q3QNxylQvcoyvsF7iTAf0tt6z5snMuv1/WZl3TITLLIXUz8e9xMRJWhkJQh6nVCen1/PJgC5PWOf47bMnNbhcsgFiyaogPv1aQlbgdvHBGjWHCKpD79cakefj+FN7nhrhVUs22WCwzIjA3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8ZRrRPFymfa2IZBWl1eeP2ECkEn928Ev08Xryfqafg=;
 b=KlJ/acEdPjttlWqoRlxWydi+kfFfRnIG5R3vLc5BeznDC20W7ccvBQX8fg25SOjM1/l7BpuknW1fn1BYjn0be5QGaS2RACrqho9Kpynoacy0K5dOe9WkEiCrsGTOLoc1LgQyG3ORXyIlvefN7Wq/mNn4oNLDHQ55BO+MDCBWMlJ2J5D0M5UACYXnlsIraWloYx8Eoe+ktufffcx/83cNFxunRJ5iW8H9U0oC3DeQ0lSFmRSNUbkVRaDHQ3uZTFKcykc9ivsgIZ0bZs0pjlWoFZfmZCpqZbAJdq8W/g+aoj0ytZ61fAzapCYLfozeUUG63bGqht9L85rhfqP+qwLNGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8ZRrRPFymfa2IZBWl1eeP2ECkEn928Ev08Xryfqafg=;
 b=HyXjXQvAKEUMp64zb4bKxjl0hC6lB9u2yxIkkBDYesak6IeT4+o1efZnmHHGMdeWuxBpCPrIWznu+jfvu7jgDWzeHow15//Btrk0UDTQdAv1eT6a5V93YbGZkDAMmasdobhBDILtXaddDz+0WJkarrBD6fQsoWaA0OEU028cZ5I=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB6639.namprd10.prod.outlook.com (2603:10b6:806:2b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Tue, 20 May
 2025 01:34:08 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 01:34:02 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: [PATCH v2 0/6] atomic writes tests
Date: Mon, 19 May 2025 18:33:54 -0700
Message-Id: <20250520013400.36830-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::28) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: eea406d1-f303-48ae-99cd-08dd973e669d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dr8ZsOXNcS1ZMQMHn1fdX/bznm6Z3Ktkm9a14ZpRWpu4mODFX0v1X5uxmynx?=
 =?us-ascii?Q?GNEzUFRLjMeVwIta5zFMg1dRSFLOzArDUR3YTuMQck5LRyGyb8LrG+w1aZUC?=
 =?us-ascii?Q?6A0qRP2+BKbhnevaKmfIjNp2sqtuRXfAshEaLV/7L6fs8OKxg5J4g+NKxedu?=
 =?us-ascii?Q?knTQUd3EiCL6plSNglfBel0AHR/wUFWjNiZmO+fl9o/4KcrW+SfsG4zhwbPv?=
 =?us-ascii?Q?JLqWYjkoJubr8KyOc1mr9+mOSRAAYPvHNdvVRr6sAahX27MBSA6HeDXfelDw?=
 =?us-ascii?Q?/cUVCDRkSNQaj31ua2zjl76ZpWV+2AIrirQSYGlgyzqRKXOV0bw51YznXdw6?=
 =?us-ascii?Q?LO6El8uqGylZWPtKkp4kJ29LDQu0kvc+oawgnzEi+EjZwyX24pjKJAEcW16x?=
 =?us-ascii?Q?oyEsPSh01YTuZJHi++/EJseQXyls0VOK62td/VUPEbrycCwT2iB897rWqBJI?=
 =?us-ascii?Q?Mv4bGsvBv2qGIRyI5ek2Fnokh8YZbu6WvzBL3gLuztyfF0TVgr+RWMJcVF/y?=
 =?us-ascii?Q?hM98/Sz+UvupJp4mAsjGqKiOtab6bl7urtGq4IbThUFe3/6WQOb5Wc7TSzjC?=
 =?us-ascii?Q?CwlQ0hyrJeWEUdvs6oMHsAHFR9u7r+c+gnjPwWwAVtH6VXwchu0FYxrbplga?=
 =?us-ascii?Q?Rc/P6Q7ugBDmxfocpEIvEAPCQwxEGx5mmp5ZMpn9znnGEpYmjSt7QnpaSE+C?=
 =?us-ascii?Q?NOeDD5bz11yUmJCclvGXozOMM5NC5Tje5kHAM42Fw6/ZDj/ycwpnPX5fsp8O?=
 =?us-ascii?Q?2F9UFVowEgd7/9uzSS/vuicBB1RLQgThd5BlW1c0dNXuqD82QvxqvCoInTdJ?=
 =?us-ascii?Q?G6DdkZPXcpRpuod9WzCAvC5iPbb/rIfnQtQMubf7yB9bkN7HgHgx6ZwiQhZq?=
 =?us-ascii?Q?jAMfxRLnXmmzay+pWs4Q3ZzGi8zmWLCvOy59Wlr2YgVDPDC5H1fJxtGytrCO?=
 =?us-ascii?Q?XKtk9lg34jolxr4d7bpiFNsC68tAHPLFdPyXt2fVRNOZLUz/c+UYXt4wAp21?=
 =?us-ascii?Q?6sC2ZssFPvSP5QEuoRPovLls9S1Tii83oHq/slJGWUFKWXk4Dx7Ys6vBk4K8?=
 =?us-ascii?Q?dXdUrRNjvsW+wpYyxTebhGVIHbfnZZ7vpECls4wLPoIO9ExCov3S0A7V1T2A?=
 =?us-ascii?Q?0zfBRkiRnot2Zn2ztMsjb/b5yTbZs+zlU9rXGWQX9pDeHK1zle3Qe54BWhOs?=
 =?us-ascii?Q?R7ICEkWtfkvOy0GQaDZXp0Dsv6hX1r9BYexhHyl112SwmFiSiexacfUItLJN?=
 =?us-ascii?Q?seG0pTmZ/udBVep5PrnyyewP8oiptKgx0wueJYwLSORU3UrcS3SjSu5W6DI/?=
 =?us-ascii?Q?IJ3CZ352vBwkrr/jQHI61VInQu5QxaqqvDC5JsMMQVqqsux2IgbTZJNf6w0F?=
 =?us-ascii?Q?kQBTGrLFdeNLh6Zp7l0yOef+bEluVq7e8RjcRPhalhTWRlUAt2sxnV+pqXla?=
 =?us-ascii?Q?hJN4oqMP27g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s6/53XyHrfEKqamFDi5vpHAZMDp5ZEkV1QHPby0TzIaE+jxHMtCXFQ713n+U?=
 =?us-ascii?Q?TBz39bnzDpnf5rbDbm+/fGZptcnSjSTcBcJaUwk8+PZvNb0frkIhb3pa3NF7?=
 =?us-ascii?Q?IcQMZIy9u41XD/+gdG/EGK+0hHNuj3mEAEdnmu2lvaFGC65B4HaY1iaOO0ln?=
 =?us-ascii?Q?TISQmCG5cxMp7AM0tzUP5b3/YZ9UZM834VDumPhcwR5A+o8NcSB6meXN1wIv?=
 =?us-ascii?Q?s8WGi30Ei51KH9yRe2XZeHTkdQYYRkVY9k+iNFrCxTnNP/DAmFF0MIlfWojM?=
 =?us-ascii?Q?xYR8wMLJv6Ox/6I0hN2HRhZ5spSefYWCU/8lr9eg0lf8CQ+kLi3v/jSE1kg+?=
 =?us-ascii?Q?kF/wLnIqIhcDI5aboUJS8m2YX1qSgEY3gOawsf+D6t2Ifbgiy/fiCTe4lW6A?=
 =?us-ascii?Q?2A96XkDpoExY6ZYyorurJ/Y8uMO7fLzmrgNUcdoy80kiXbmaAUWBg1bmsDYJ?=
 =?us-ascii?Q?OweyX/5O2DQPfY6Qb4QXQKuR6SKiSpFCZO1i4Lm4spR3n4TBCHKiESmCxarB?=
 =?us-ascii?Q?4QJprhQh4upZS2xtMJ8JgUW4e5esWT0Za4DnnVheLDTM0Ah4+A5c2AiEPYRE?=
 =?us-ascii?Q?uwtbRf8VvcR/JoSSIkj2/qh7asNXqQjeB3fZ+NXUuel8tw7cU2xEkmC+jxDQ?=
 =?us-ascii?Q?0fUNdyTtOqDayEcmCz9QK4SKx4+bi7rWmku4lie8Ymr2hTuh31OB4tVoNZvM?=
 =?us-ascii?Q?NTJWIkAGKIxnaec2C2e5CjuGfKYKoWlBpyetzlvLZrUpjFhWXsDtxIPw2lAY?=
 =?us-ascii?Q?gfU8PsW3V9Sq3Kbs2XF5tWnxKGHKeyRezgZLvXJWk1EtyYTNlghb5mwqRvL9?=
 =?us-ascii?Q?UumEKaL1p0HtkAk8TWPKoJhj9cbYcEccnitMn/BRFqPq/Ia0BODi+4ucsxU7?=
 =?us-ascii?Q?CENlF0xAXY3P7DhwhPRhF5bHIatj4wbjHN33JyGL7OPrH09aEGMC21unC5sF?=
 =?us-ascii?Q?uTyEBubE5qoqYqtOeS7i0BHUEmCITcZp3TYEFk6Ugvom25z1zdjV8dp9VNt7?=
 =?us-ascii?Q?xWOaHkD3u2ABkJG19mul6ORMsl80VQ1J+Q7ii1efOs07TeI65q9hZDRip2J4?=
 =?us-ascii?Q?K9yI0/UM2GLJeqHIaaquuQZT6Y8+UBGfl8BJWW1fqjHHvxN+7Iv4vUYKtvVb?=
 =?us-ascii?Q?oFD67ll2vStqTxlEXvqBr4kqx4qse6dQDVXM59kCfou99uwmQAsXqdNeaUO1?=
 =?us-ascii?Q?xAl4Mfjx3DHH9vmyZQuqtgsL3QakhBODu8btRxNH4Jst2eAZGkCz7FfAjOZN?=
 =?us-ascii?Q?+cWjQ2V4CqjRYBwaICcZ4E7QwBjNBPgFZjOxNNFZ4S9FlJMQzy7WUaciNVIT?=
 =?us-ascii?Q?4qJGiT1TxIPzVOCuFjFi1LctsGo10Ht3KJIKaGWssQgxq3SyJx/LF9/OGeQN?=
 =?us-ascii?Q?43TIdTh2/HtLy3nsU3itx2HcY0VdqYPoMfpytqYKYEaVlPulp7EZ4BfNhiuK?=
 =?us-ascii?Q?5blqssZe5wcFE5QboSJO99ZHwCW58tbma4pRrVFlWxUAeVqTji5XZjQr5jUe?=
 =?us-ascii?Q?aOEd1eC8ZprakDM/nvfyAQlfLrdCBKYxW62I3LqIqgePNGD/KzH1hgVcZaPX?=
 =?us-ascii?Q?gVfoHurwgeNzz7dAjRmotOMz5VtznVyKchLVkeskWZZazYppTO6scXli3tPa?=
 =?us-ascii?Q?srm4PgDkZBCWhGxMrJ3q2RnshZ7sRXF7a/TKqzgie+g8d66sZ3EbkG3nmxoP?=
 =?us-ascii?Q?jTiM6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TtbiErw6mPK7DDOkmTOnAvUxM6sxHjbdw1wTuJUkjmJKwuUfN7e3cm05lCfYaFNxaut64FP3dw6wRdbyHsA5MGay0l7R8AdT4lvsgP7UBBc7V/Ss9gz/op6WvrsfwwCmpsHd9Su4tryCNfN0cHOyDEowVdfbOQCqAt+qkExOhnS5f1MycVcmhoqqWsKvHabuX3DMuZqzKo8firvXJ2eZzQuEHxI46+CxX8gFQqa9vHNBJgBVnuTjl0M1XVW0L2tOVKGtjRgrOe6OM/oUdj5CCKnqURzwy9+jSXyrV64sJxFy62QsrDhSTG/vPwcO0ZRo3DykSeBzhCDjx6LF87AMrgE0CwlYaDBtCcAVH3sd/jc3FhvwBm4fnkO6O0H51DRqS7A1F4k6Qr9aaLu0Sm+KFsqWPwHoGIKKFufPX0eDXTRKB7wOcTh6IEWk2fFgGS7JUlsv3o/DfOcavZ1JGBwYvyXFFJL+uG3/hJSjez6x++ROQFAoTrVY6lKqbEBCfNlRwVT8+eHTIzEQdMkSi+XqHtFOXHpx/x1GM2T8TS72Ok6klX5MzQano4xbF028i0CqaG9ph8YSjdBeUKY5T3L7XzrUxSo2ZITzfoFYy+PTbMQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eea406d1-f303-48ae-99cd-08dd973e669d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 01:34:02.4448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwtAz5VbFTxcQCsfBLpSB0+LXlK0uidzZnvEK02I5NwUgQm0Qa/44wCYEIysnK19ywrxqOx7U8JzN5BxAlG/X4KWCpET5f0hglEwKKT9Mhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_01,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=771 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505200012
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDAxMSBTYWx0ZWRfX552VtnklRr7I 5B2Wl1lIwCNxf+bqIvXVy7DPxLTeXZPHctKLm5LEjr7sX1DGGLtR7v9NxZxJi0zb4lKIw3rb25+ ybVJy/L3il1CQddLFyTolqE4IEbhe+I75eZ5nrLCcBwMvklfHp5t+ASf73daKBFToksDZB7RroD
 TWfuZy5z7ICrnY0abGT+ovqEsW0SStZqP39/VPCBNBAoj/inGpqQpVwn5KNHKvumPT53Np4DItf oB/4Z4vYXKKFUNw1N5OA4gmVxF5w6GDgd3bTmyafhmfdn3cZfRnICgewOvJFHqlaHUtpbjg/5Iu CjZhJRcwDGU0BbBkTftz2VUmoMmYQswhZT7eQi3cGfYp3LRvsDdnX0F5hgyxZI+03LaHSpb6wdS
 o4HaoKmewEHVY51eeK4imbA/gQ0aiCTMhe7X6a0iCgMjoHO4ZRWoryTX0wQ+D3Vs+EPkUt1X
X-Proofpoint-ORIG-GUID: cilE7OvZ85eZS-gli2Rd7S0Bd74ws6Dk
X-Authority-Analysis: v=2.4 cv=D+VHKuRj c=1 sm=1 tr=0 ts=682bdc13 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=w8cynbu-OpPHUjKY4DMA:9 cc=ntf awl=host:13186
X-Proofpoint-GUID: cilE7OvZ85eZS-gli2Rd7S0Bd74ws6Dk

Hi all,

Now that large atomic writes has been queued up, here's a series of tests
for this new feature. The first few patches make various adjustments to the
existing single block atomic writes test, as well as setup for additional
testing. The last patch adds several new tests for large atomic writes with
actual and simulated hardware.

This series is based on for-next at the time of sending.
Only patch 1 and 6 were changed since v1.

Darrick J. Wong (6):
  generic/765: fix a few issues
  generic/765: adjust various things
  generic/765: move common atomic write code to a library file
  common/atomicwrites: adjust a few more things
  common/atomicwrites: fix _require_scratch_write_atomic
  generic: various atomic write tests with scsi_debug

 common/atomicwrites    | 127 +++++++++++++++++++++++++++++++++++++
 common/rc              |  49 +--------------
 doc/group-names.txt    |   1 +
 tests/generic/1222     |  86 +++++++++++++++++++++++++
 tests/generic/1222.out |  10 +++
 tests/generic/1223     |  66 +++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     | 140 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1224.out |  17 +++++
 tests/generic/765      |  84 +++++++++----------------
 tests/xfs/1216         |  67 ++++++++++++++++++++
 tests/xfs/1216.out     |   9 +++
 tests/xfs/1217         |  70 +++++++++++++++++++++
 tests/xfs/1217.out     |   3 +
 tests/xfs/1218         |  59 +++++++++++++++++
 tests/xfs/1218.out     |  15 +++++
 16 files changed, 710 insertions(+), 102 deletions(-)
 create mode 100644 common/atomicwrites
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100644 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100644 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

-- 
2.34.1

