Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22F21FBCB1;
	Wed, 18 Dec 2024 19:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549465; cv=fail; b=AxhmlXafTL8eX3FIjuzMftur9o9ukUkW+LGr8X37tG8hkxPSHDbJkhUk/WjoG3HUSD3lEFFCdrhBkWosSU3Osk7bczsgueh7qXUbu9HtDQYgUhe37jPFHmXsS1kvjj38XK/tQDm96KeZjaiwuWLL4jSqgeJFQ415gpsgtSj4e7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549465; c=relaxed/simple;
	bh=bIjWTVyLgbCofhCSZP9/rCsL0Gq2q4//YRDYr/CcdMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J8W0lQoMI3BMYbRkJSFbs09q8aIAdTby6UjqZsp0ldcbm2xxtbwF+Y5g7bIE/Jkc6L/Z+Oht6aKpYkLeEESHpgG5GwTASLJ3thzN0bi7+Qt0x1r1cC8H4vMNYDjcMJSBP0xbfSlOZBneqT/jktLxgebUMpQtHe/IcHETgmjV3i0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lIKvCsnQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XCFA2mdo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lIKvCsnQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XCFA2mdo"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQdih029824;
	Wed, 18 Dec 2024 19:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Y6dU774PrD0orurBtDyEAzqp5jQpAfjWnQY2LowUoHY=; b=
	lIKvCsnQusDrIA8v2O/fthN72tX4TfrAqO1XS8xUNMjgauxjW3wxPk3IflHo5e+P
	cw9ZwBR7bMzzP9NAB0tJNBHJWWx9pxiaOXfiTAOIuQMaZwm5BnCqS57G06kswXNE
	Q9EcWKDEXycv89Fyb1wTYD+lcQgV3Q8at4X4vRKoGjha08DB7w+x6R9kLD9G2jtC
	Kiis+HiSt44OB+Cev8H7GWN5JWF9LzoQEDqfSrMxKVr3NgCGf/pxm7gGgRoIwO0I
	CvAixpqNdw6YtWPJXD2QrNJFqOI7goJe29BbZ2ATeAGuN1BRlRMWqv7eWTX0InlO
	fxyChyd8W5kABobMWc3A4w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t2hcqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIILfBa018984;
	Wed, 18 Dec 2024 19:17:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fafty9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fAWDSGdztL9Ig5sqPR9oAs5PocmUP9Mn+PSVDdcOJTL9CVfR6BumsjNcb00J6JbwaTpHkfxqJzySUaNrVAfv8mxwcOa+OJgUR8yr8Tv+h08g1D/6Z3S2xXRW7C55D2ILKUUhHYF2919zYfd08Ru5cs4PJfSrWNzKnWcyDhhgCDaC5XhOtS/X8TT+k9VSC04mUlcD7DnJ7cew7izu1PmOc+gQ98KKduMNtLLbqU/aVjPqOsXd6Ft7n1mXVv22HWpn4RqCLTWVj1oz7HstyHoFzeMkr9pkQlkwuBc5AQwBQ2fsSDCq6LUFM/KtTfPn6Y1f4dB7adcBUOE0nQTo0HRG9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6dU774PrD0orurBtDyEAzqp5jQpAfjWnQY2LowUoHY=;
 b=D8HEEJsJdvEvgq6eDi7r/vuLV1+ox4w0hYZgEGdvvK5X/jbdh1OOufFBiT7xpSEmQDlR5+oNrmD1AgSlfRXBR28cvaAdto8UxQsnPnbi3Z7NhPnC8iW5UHSULY0jI2RN64qssa0bkPH5RwXaI6BpnQUtWjqKWdQzJj9NOKgjAcslb6YHoBUoBxHWLbXkCyzLY2JOTDQb/zL+LbLTc8qHUpwxPv9114pLKwokY4MxPDyT5q0bM3Zf8jLM5zr/QyQDQXA8HRHQNBjGh60SKwAihc7mYfokc1CopZ+bW6kk6SOw6UVKAYRpGGb3uljurbKL2V7bAWFoYDVdDJEIfVJjdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6dU774PrD0orurBtDyEAzqp5jQpAfjWnQY2LowUoHY=;
 b=XCFA2mdoMxA27Zsx8x4K1RzPrQBzDhGU95mdd1B/3PKJe3PW+mSkYWNI9hSuQ2BztfXSnG1mfMzxXcUZA7o+tL71VTBXT9dPs+3vGKFQ/LL0gt0falPS7YZ1P2chlMkDedcZRorfxL9VJSAUKxLzjc28ukGnmu9CWh+S2ywWvEE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:38 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:38 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 06/17] xfs: Fix xfs_flush_unmap_range() range for RT
Date: Wed, 18 Dec 2024 11:17:14 -0800
Message-Id: <20241218191725.63098-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::8) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 852838d9-b57f-429a-450c-08dd1f98a293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+J5xG2v2YZQiHFEMuAdBXf41fD6Q5EgBF8vE6k0LbzTNimnrbxgxa2Es7KKg?=
 =?us-ascii?Q?w8BRfYjJdsV+6alnNG7iw8ISLMnS46bJzPrtq1WdkmbDXebw71LfR18tHmT6?=
 =?us-ascii?Q?Zd6dhwDr8KntJjRMKt/4i+Ea+Z+xF1zlJ6FFvuyM0wPPE7kHgSMRkfXiWn1M?=
 =?us-ascii?Q?tDVCcEGP9e3/T91qwAVHMCQoorXqSUDkjufClWv8VQqD2F+1AyH8fr1Fxm81?=
 =?us-ascii?Q?ehaBDWBvDdkvjLUj27hAmMMAbkAXkgYI5oUGVSzUeWD8Dirk2RM9Znsbr9rJ?=
 =?us-ascii?Q?JIV9wa4r9KRXZ3ny10nslPb5nCTJoT1YgtGh6fGHi/2JHneH553I57px7VnJ?=
 =?us-ascii?Q?xAw7R88BlVhqo/bbKBTZANuazr3+kbDS6OEwzFTu5R7zTcjbJtwfF/P67C6E?=
 =?us-ascii?Q?QklbNQ6pZBnXbgoWTdP5G+5SiMkuLZ8Qce3jCUgNIC7wniJwAABlxeuhCBjN?=
 =?us-ascii?Q?z5y1Tl2N923/gVCQYuUcWPSJ0HUVJOeFpmeiAHZci6iD1pnukarp/RECUk9Y?=
 =?us-ascii?Q?quCdUN/AMaDU3aOvLV3YsrXyDab3Ra8eCic3vgN+GJAJI498vPGC8dTcKEqP?=
 =?us-ascii?Q?nhVeFKcGENgAmjoiBOzBoZoHE1vnP/UMHqF38I+yiSQScn6lmp9kwma7pAd4?=
 =?us-ascii?Q?kje1uKjizluyhxg4qMwa2d2EhUCZi23+RqIhomPrRYJQahH9DXYJBWAK6W9g?=
 =?us-ascii?Q?3FqFNRf4jI18JOtCrTR4/M7EqItRDjZ+BKPW3hFhrMadeOwN2gZAhOdDqHN3?=
 =?us-ascii?Q?W9VtAyxp+JzTVAkAUVmDmZzEKu4cfD7QGwVDq8SCG8tTbEyzxfvNWZmCHMDX?=
 =?us-ascii?Q?Pwemkgnx/59DsrhLPCaomhwEEXi1q3lhZWr8QmvPhfu3cmQPJGzFQ54smEr+?=
 =?us-ascii?Q?hFvda0volG05LQRTnakxYT7Pd9LcH5BP22PiO776BN+72YvoxjCtunFAGJUj?=
 =?us-ascii?Q?JzgWHWFVeJnyBILKigRgl+tVdQKrYEFvZCBrO3DfBh6p2uak4n/rTXXXvo1f?=
 =?us-ascii?Q?J7pTz4Iy/NPX/GXkSSN/cKsrqfWMf0b4HDP+SUEg3e+iSSe2TAnjau+Ve7mR?=
 =?us-ascii?Q?q3xQTF+9t6KBkWbgFuDHUDSbjXPM88q+KGxzn051gpYGHycnWD30PScBjRHi?=
 =?us-ascii?Q?S0Y6MF8b/JSt7YNAr4Hm3zmEKQMdwkDGoL8ZN07LYxj6df3P0AWk3NjydxA6?=
 =?us-ascii?Q?0tlVD4MgyjYYgflrEmXZqsCvO2XN4CG/LLM84wjV8dEZPmBu8f9YnHCENDiW?=
 =?us-ascii?Q?Au86wp7OE50apXL2v3yGKal8kd/mtWWSinmkH/l6v+Evvnap1psO4Pf/VS2z?=
 =?us-ascii?Q?JX8t2IrX3ulW/dXh7z3aBK3CnTbd/rAysuxa7JNz5i3jz1iDhS9rKGk4xqdJ?=
 =?us-ascii?Q?whvL1/kCsneRBTWGLC7T7z5SLWQU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CMCDQnseIeqsp198m3dwh3hjkm1Vi+8vPIvkczwcmj3RsQywbrQCvYSGgRdx?=
 =?us-ascii?Q?7UX+VKtU7/lVQPPf5EpfVGi6wvzC7qPD/KVv+hYSkyhUHHl/+lUiXL1afDxg?=
 =?us-ascii?Q?hVesqHaXJaFd5atWcJar8mM8gRx9IULIPihzNIKmGezCFvoVPf+39pYR8x5H?=
 =?us-ascii?Q?RLtyF895rQjcM78xLFzoK+vndUeR/mE4gvwlqvXO3XA/bOcRXDo9lCQhZTIT?=
 =?us-ascii?Q?nwkfwal2idmhm/76jojnfSrJEmWWHnTGynXGpT7cSswND42CMITJWcyaFWXU?=
 =?us-ascii?Q?UmdP8D2KfYAGQFW3k6LkLrrCwPsTZ11dnb3X5Mx213HlYY5ntg1xks8nQkfH?=
 =?us-ascii?Q?eDaiO6tmJRiUglVC1QOcXwqub7Vx0P1PGi0OyPNbCwY4Af5jDBOK1qVnUJht?=
 =?us-ascii?Q?3UZzWFsrJXjioOxZzoj6E5QJR/UbjuecyLgdczEOU+LqYgtoGhGJnjjVdLav?=
 =?us-ascii?Q?GsplWcsoOR1FliQmPgmCpKZAkWBnms92wHHJ1ydJTDavQgyv6p5kH7glssAv?=
 =?us-ascii?Q?CaECt/y+itL+CvUAXjpEjBfyX+4/XfgM/vadN9aO5L3+vWJ77w+u0XuX1KdA?=
 =?us-ascii?Q?rGDdv4UwuLidlNJDqkM7U9c6OSlJpKkNPS6pU6wW1oUFqr1s2LD56erNzi5M?=
 =?us-ascii?Q?kHu54cDAVkl3OJJkg3ur+ruH59wujdslTVDfpb7FW/acqWAjlFkEKCYh8HlW?=
 =?us-ascii?Q?toaqGTivfJGrufVvIeOhAiz5QWJM61U5rYk4JNLIFTFc/3kKnocjhBRxgdAB?=
 =?us-ascii?Q?FrFfuwho6Alkv2F1K2oydo9n8XA4mBL6TWrmbIV/E/zNPizMOU164NK/BZJd?=
 =?us-ascii?Q?Hm80lLG0t6yrxFj0E5lkUe7aYjOuzZ8Ve0zSRTv+3rLx9GGrJ3DOJhiDylfl?=
 =?us-ascii?Q?lfFnrQxD8ZTt5ROgxPdOi4XnFbgUktOKm644/sDLqjzjqQkolbGaxesh1Yxq?=
 =?us-ascii?Q?J3WFtSBnFUrkHAdzdMy97oeOtqqRgAlCWi+5VSKqdqulX6QlgtjN4YzKozxr?=
 =?us-ascii?Q?6U3YB/Tt7KOtSVzQuWaTbOcpgBowfqn088AjT0zXfTu78yg70i8XWyc8GBza?=
 =?us-ascii?Q?cG/S5A6I0R7jdPrtruYN5GQ9q15i366wJJmBLFF6XnVm8x9l9x9vIG7pQLiA?=
 =?us-ascii?Q?0KM0Kz6L6eeTiQui9vf7DeCWEerUwx3JWiYGgZQU4e1JEV/iyTSlbUZugWMl?=
 =?us-ascii?Q?Js8+ytDWb20UzDC9hAwdPSQdUu/fmE9lkL+Q6aNEPWADOR3tOfNp6xEviDX0?=
 =?us-ascii?Q?d/lJcVLMLFberGsVwypkrWy5lLWwqEyiWDFTTK+iDi6HNVa1qk6WManbvB35?=
 =?us-ascii?Q?BmdxxzenOo92FSz6175EHSMolJCtIlgz4bEcORtDKDuB43mAswoVhb0sB5nj?=
 =?us-ascii?Q?r4KNdBGb5ECIOknqwQCgqKxioxfGVs6sEQG5AAd5XH5o9wXx8CFlbK55g9R+?=
 =?us-ascii?Q?MQQvSMdKI8nK94yTitQoaGLY/5jbuiwdv5Or9RDP9yhPeUgDKiNeI8uzyn+X?=
 =?us-ascii?Q?Fer1NVrv/KBtpkV3AHfd1vMd6qyg9KWRNrZ0zyi5Zd1og2tj+y48NOPNYwQ2?=
 =?us-ascii?Q?m5WTUNrCMS+a4eAyIdUTDm7X8XUhb3ILNfswn1RakqrhOB/JsZ4Y31skKQQ4?=
 =?us-ascii?Q?fgrpa8ytp4BSqn/YkEIEa2IFQzSoEEMpI1F38OERuSqW42QbsLaW0K5X925n?=
 =?us-ascii?Q?GiOKLQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GVGA2ykLrlVlBvApkhPmYWEEjc9NxIG8bA6+kQZ3HAGoE5roLiykQD3zQT6AB/O8VL/Nmh82Xg0iw5oIyewgPv1BOb3zP+yxUgYEd+T7vP6617yoi4AbjitwHB/nYyuSPet+Sa2heKqnnKbfsz4+EupbFdXaNFJTon8Q1NDcPM2QRmKBjEAv5MU5ZGwqDdBn0tcCg5Kt+kuLfJyQPWVnDLtByMpSBl+NKWmfNvgrYVlxGcmvy8pcWaWPR7j0IMdSCQv7vvCeOdd0MEiZ3gv7LecHOH6NS9rIHTDee1aog4S0oJlSiGe5G1RpOCpgpODxGXPh1b+tMrpqTylrtxxcc3CeukPT/ztbvW1M4JtwGWool9l07LcZLo4H1qxR0gGRVqIFxC5S8CqmhwuSPrbnoYo83S0fPkkd8zOYzOBMFc/izTa+Ipty/LkzQmXrmFhXQVQv6/9Js0Rv7eHjJXEaH2aVUVPJQYZoXwdwYMPcHlu/hermWgxZSW1PDAQepLd4Mh6l2+kMhAujHvPn60eMHr+nB20Imq9vqnqrDyXwGdlRNwu1wKQTy6kFDMZv0JdX0kzTA3hSLSFRMGwNKkrGED+lImQS/wccXgv8VBXXFFo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852838d9-b57f-429a-450c-08dd1f98a293
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:38.1089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vIgQkK96ViO2OTP8UVLumx5nIVjAEYahujko0GMmjmXMDx+4/NfbFd2VW7vXjwzVDSGFSpDk9lPlcyazkjTwhaOfNBIcrNIS/rbY6WZZJK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180149
X-Proofpoint-ORIG-GUID: qA7MlNkGQsVhTkpQgWfFFP6iAilWk4R5
X-Proofpoint-GUID: qA7MlNkGQsVhTkpQgWfFFP6iAilWk4R5

From: John Garry <john.g.garry@oracle.com>

commit d3b689d7c711a9f36d3e48db9eaa75784a892f4c upstream.

Currently xfs_flush_unmap_range() does unmap for a full RT extent range,
which we also want to ensure is clean and idle.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>4
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f9d72d8e3c35..7336402f1efa 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -963,14 +963,18 @@ xfs_flush_unmap_range(
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	xfs_off_t		rounding, start, end;
 	int			error;
 
-	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
-	start = round_down(offset, rounding);
-	end = round_up(offset + len, rounding) - 1;
+	/*
+	 * Make sure we extend the flush out to extent alignment
+	 * boundaries so any extent range overlapping the start/end
+	 * of the modification we are about to do is clean and idle.
+	 */
+	rounding = max_t(xfs_off_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
+	start = rounddown_64(offset, rounding);
+	end = roundup_64(offset + len, rounding) - 1;
 
 	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (error)
-- 
2.39.3

