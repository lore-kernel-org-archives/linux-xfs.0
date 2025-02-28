Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E55A2628C;
	Fri, 28 Feb 2025 00:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740703869; cv=fail; b=QwKBQOawU8joxFwu2hwK1fYTFwP2FJhz7VrmDI9K1cUFfyXzBV6TqATrzGVpns8DQ/eDZCLgKKq3n6AaWk8Lv57eDOQ3eZtxDvdY8XJTQzWZt6eVLPU8TLoMimdXeMAZds9lybyGvGtQzlV4j75vRMETs4CDEKGJDe/o+4U5XZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740703869; c=relaxed/simple;
	bh=etaTGt0xMQG2h5qhdKV7bcnmUd3t2/Hx9AvrNusAe+4=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=djGN8Q4LV4wBgk3JwXQb9lvYY1as4yB4VHlSbG28UmSmidQn6B3a79MfNCOzprk84bvUSH2WeS+q/VtRoNTFk9VE8zhh/VaDeKz9QcNjNyjRtlrZrWDIIzChw9m9TWFucJGi9EAskfDk+R2Jr5G5Cm8muMuIok4J2Yz4BGXs72Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AtplYaTO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=O5sjBR/H; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AtplYaTO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="O5sjBR/H"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RMSk8j018953;
	Fri, 28 Feb 2025 00:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=LtR5LD8x72tfmU86
	fMbLc6q8nK7JNmGLMmSnEKrxAm4=; b=AtplYaTOerrkdKpf0c8rEgbAqGpZ8NTw
	jcIVTXZ8lZLJsnHAN53axtPIsPa1ULzHzJ6CIWeaIW5lQPJLGf0ZpsFQFQ4COGF3
	5w1AJhsOsL1eHTJEGuuxhvOHuo1S/UjKaYbLQLd7+KXPfkmsU38dHCwzZ1Wfawpd
	6yU2ve3fFwx1ZDhZgy9eik4LADk7nAnLjU9jQDTc45OuHFlVBY6YQxKyqKCyFZnn
	7B05GRAPOIORY7i3kaP5jBS/a2bwBg8ZGoli3kTiAMyxrcbGV9td3J1CIUTPzsz8
	YM96l1K51UGNcSjUBjIrJXa6oOvbFO+y+eOsZxh2rMFQPMhNMasv5Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 451pse4n82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Feb 2025 00:51:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51RN9dJd002792;
	Fri, 28 Feb 2025 00:51:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y51d5sbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Feb 2025 00:51:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rautTuWXyxKeL+0p3vI/698688PWUnh+t52gSZf1YnYOiEfyrrlK0hg33S0tOrcwhn3fPfeXEphOG/NMkBkJ5SN3n93FjBp21VcG4/OCMT70bgK/KGNre1qygY6TeIN6MKxyini57tdq2TT62JErpV4X8ymvHJ56uMR3JmsogUbnsNptqh7HmOTyjLnsoKQgk4tQ/i+vzoVfhoI3PZRXg3FRflXjHAgVI0gmRMVQfMW4JC5+r2Z5dAj3VAFuTFrORAip8MyqM3Y9HCrHcwiGB1/VaDKytsT4VtnsdYougvLIOU2iy4HXBm9UNlqKMqwxLq/2AeFuawtjQkRXPg8mww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LtR5LD8x72tfmU86fMbLc6q8nK7JNmGLMmSnEKrxAm4=;
 b=Y5YiK+wq84GhZWanaBNHl0Xjt8oJ8ZtSS8wzugbYoASRyu8MkQrVmegDBmWjZIDB5TdJ9+mSh1JRkVfYrBifV9vHUG9q2o4TZcW7IbTCYVobO3abXM/5wiTI8lSnPz0U5m1YmzRkwl+ViXqsZGV79Quv9u+2gwtskoT5VyJCZlxM8dmdnVDigiPHjMTYQxWkcYG0c5s5jpqfYBXZPJAT+molBcpdHXS3VZd/LCsPxw5E7bAOqgzxvBo16HPi7NEnpuxNXljOw+5dwGFOkli7LKfTfJQ62pnJbPzxVVModsDw7EREN8CugVNq+RWcTZDN+lz6y3NOY1wGehsxTBB6EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtR5LD8x72tfmU86fMbLc6q8nK7JNmGLMmSnEKrxAm4=;
 b=O5sjBR/HZeX65ERgwSOzgLwNHlFpXM2PaFWvHEgTr21QBol/cEkzzQ5WtNMGj5omgJmrHxuGsxLg41qSJyOrQuIY1A0iTEW9MrUrCpcG/9+VOaJ7Vox4Xz/y8qgtQM/rIl2E24DTI+FTRXuUIdFI4CjarVmTzKa1ZO7H5F3ZvKo=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Fri, 28 Feb
 2025 00:50:59 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 00:50:59 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3] xfs: add a test for atomic writes
Date: Thu, 27 Feb 2025 16:20:59 -0800
Message-Id: <20250228002059.16750-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:a03:338::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO1PR10MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: 89da2a4d-19cb-43ed-90c6-08dd5791f76b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LJYL7+aSkSuJI6IdbUAEBykiE0ROKoXiSsGBU0PhaXYekW1+nMhgq1PQ5DRj?=
 =?us-ascii?Q?miGp9Ennr1KScxS9R1haNcmrmhUXzIP/gi19kPM8EDvSqcW11yYlpMTwxNTV?=
 =?us-ascii?Q?w6X+MLsjM86OtRELlQDRXrLTXHKVYQricAP7/xbeZ9SXti7wzZPwehrLh8B0?=
 =?us-ascii?Q?WvF1uMkKzgbToUtBE1Q3cqrzpKVYqIGFk9lCmo2qd4wuxSmCSC6EY8EEUOZe?=
 =?us-ascii?Q?mW5QCESXDOlw608Cg400UihEQEJ7QmTUXUZ2liLxnwCl2XKt91q179Ah9aSi?=
 =?us-ascii?Q?ykk2GL0DDZuAEY7wUslRIAFkBOoK3IR2xnnJCgCy4XBFHO3/3ZrQkhkUledb?=
 =?us-ascii?Q?cEGwQ9WhupxuezRnBe4aDn5rPaPLV+OHNI589OTUw9AcIl5vvwey+uq4+p46?=
 =?us-ascii?Q?yajgurNX5A98dUxsLmI7n3Laq2cKM7oR4Lveba/mlXM6uXFfRjoZHOkGL+Qo?=
 =?us-ascii?Q?7dr6dzC2mnuFIsprSC01iEDv1su/T+B6Qe4HRat9EtHieoMwF6uwjvKp7Y7q?=
 =?us-ascii?Q?V94p0iXN02CtGXyMroiup6OYgC3j0K+mUVSFcF7brzw4zpU1i2i9zHLjEAM/?=
 =?us-ascii?Q?Q49KwCYM24Mz8VcHI48bK6XBr7quAyBGpn7nA8u+De8rlPSqKW/JqsUI64o2?=
 =?us-ascii?Q?k0lxSnbs8rGCmetLpzbgWVtJ7TMf2us+x4wcVVTFmLm/XvA2Tk+x0RpR30We?=
 =?us-ascii?Q?+Y/GiHLj2uEF66QM3CaUZetzKevjghEQCAMmJJs5muGJJ3Ii+vl3z7lsjJdA?=
 =?us-ascii?Q?mRcJN7fHoMp/jUDFovVIxJflZzWqDxa96uPs9TnNYtfeuje70uKnadDtw2Fq?=
 =?us-ascii?Q?9QYL6rsyQQVYSa9MqrLxmtHqwvn/CN8CZ0h3G+VEjGasu68iZi3p8dRUEGQ6?=
 =?us-ascii?Q?gEDxvxfcmvEv42GOnWhy9kyc10QVpZqGBx37oQbm3zIuo5+OO/i94FlT0hJy?=
 =?us-ascii?Q?K30GFB7ULRAtOFrGWeWdBvymgr4J01DJMQBr0aLwW8ZCU9LNbY5HlXEWm+OP?=
 =?us-ascii?Q?fY32778oy6LKy+y68CDQSGsDbMNZXbCakDXrteTevW0+dkJqHCb6wCHdkBVu?=
 =?us-ascii?Q?2u+4l9P6DpMWdL9A/JrlVT/rDDls9i3rEPdsNF8SBI7aVWQP3qc56nI+nYPb?=
 =?us-ascii?Q?RT4zC3Y+XvvbrQBGl6BX8DKbJYRhGkatsILmW5RvZXERPO0VQt2iZyQztpQD?=
 =?us-ascii?Q?6teP2dUEZJMcv2NkcBt3cgyOXgge+eKOVhibPCF5Ux5V1AC0z4eD71Dk1qMQ?=
 =?us-ascii?Q?SwY4bKP7lbudo8hejecUEbyatr5cpaoxIfzIQpIFUbJ2SNZEStGPbhKBZcjR?=
 =?us-ascii?Q?Dj9e9idTyO7o7HWp/oe/ap3RLBFn6O0kCRjKi7LD8tn8huAdK7rjWRhax3fa?=
 =?us-ascii?Q?NE7bTLFQ5dWt1ue3dIL4/yeEeybx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bATYeKMh1t6rw4WnWS400HMJNJ+g59Rk7j20XJp0iAb5srlX3BYKae0gzSgA?=
 =?us-ascii?Q?4qoo4Afz15oDy6rLxnReYx4/IxK3o2Cl/ISqKuol8GFWfFaAFGKZ+/PMiMxd?=
 =?us-ascii?Q?C6UNR4vCG1K5SEu7z8BDmEfPd0pv4Re5dVeCunyncixkgubyKXgQVNAvzMos?=
 =?us-ascii?Q?z7kL16JS4iVQVi39gwMB4nHkOV+jVXHOJQPBsFsMCp7LVmTWAhaNcElY95Ib?=
 =?us-ascii?Q?cYWbRNV/P4ILu5UhlFetCCr5SiDdIkjgXxnIyxDPF9aqUyHa99nRIXdwwOJb?=
 =?us-ascii?Q?s8MVc+WL54F4ZI1T92V7Yu3q1MuVsdXMdTZV2dIOK3gLDoAO3acCSiv3y2Zf?=
 =?us-ascii?Q?lxBQhH3iK5zEi/NM8CaVGnYQlWdtwBcR69EXzxLmCMQYUJvba2lR1nsV9QEg?=
 =?us-ascii?Q?1XCZUjvKL3NyT0t1F/1yazDzp3kvISrbxgQdW0gOOrAtEAZXwcRhY3P48r6+?=
 =?us-ascii?Q?h7q20SaGTslROA3FYANHAT4rJd/qYnp7+xkvT7cIcQsqmZzwG/BevvIYQX7P?=
 =?us-ascii?Q?QzzY+eaPQrucz1rxClwZBygiBxU5+NLeRaPTgXfDWp3wYp4PdFuMTD2jvyXT?=
 =?us-ascii?Q?tbkpWFezPTkIQfhhqUwmkMdvp9ihNFBkN+Q97d2VYEQQmRPVWw4A6bb8r8mx?=
 =?us-ascii?Q?oAJy+Q6Wail9oH58JtsunZltFHOFE0sSqCGBBBwXVVB8Ga4XJI2MjRVu8U1L?=
 =?us-ascii?Q?JzUASZDwAn4//uIIIft6Is+A9r5FUYDgLX9Z3i8wxH+H6QGncyKnhwbBSduB?=
 =?us-ascii?Q?BI+CkNnpAkEmAFw8Ylz4TX14f04lB04jTemzg54fxB29xFx9JZlLzVsEfFb4?=
 =?us-ascii?Q?oKjYRJC4+J/RviCgiy7WsaDKccMMghcSNzjlLnY5KeDudDiPZLaEoBNA8dC2?=
 =?us-ascii?Q?bPGmLrzO3yvuBGp8ruVZPzhD4Y4PCmnesrHRXVs5lb2W8c57YniAk3kn/9Vd?=
 =?us-ascii?Q?g8RdLeyrEjGpz2pXAPCTiqW89ML25VJmNu30BigvPsaH5svZDr18QmDFllkd?=
 =?us-ascii?Q?XSfeYmrn8KeMYXpftCvZiNla6CQFeqW6mDAO3xvW9SEkFTFS+bDtu3f25Z7c?=
 =?us-ascii?Q?MwMrQwUg7uEgU9yWytANoPoIPp9ZOYYADYBm0zGETX25X4HUICdZZ/9XA4UY?=
 =?us-ascii?Q?OYaWlhH5CZP8xM5kGKJkEpiIMDqPaU9Zo9YEiBaog9TQ2fkJWrkCqG7lgh1i?=
 =?us-ascii?Q?pyQzWhX2Z1OOcNUb8uI07lU1gr8Vi5IfWsNAmdBartJ2f+i8n9VIVO0kxeJl?=
 =?us-ascii?Q?T2QvmxyuA8BEhhgbPKKKRNcL8z1c2IX3M8Vd3bipd2Idlw0HVSPbSqn4Ao+y?=
 =?us-ascii?Q?ATrkbbPnGWTy6UJluE+EYfVH3GZCpI7aOjMjXtJdnS2GrI5+OibXfC+UEeTb?=
 =?us-ascii?Q?Hi85OP73gl9Lq46rjSJAa8iAbrHPrbRfNojgvtfgN6dHwR0rnHrFcBZr14mA?=
 =?us-ascii?Q?LvyIxd+yj1MEsEmmKszu5JjJC7PETi63M5ZAt4z7iYbf1c91vAfEUzQHb2SM?=
 =?us-ascii?Q?Z44C4UezJyQzXhtpE9EiTgKiB0ONmLtGb60xLUkIcUKXeo5PN3DbWnq5IE5X?=
 =?us-ascii?Q?7EyMexA66Xslx0sdkCQLTrRTP+srAjnZOhFXhekb5skuA1WvAns+jFEXxUM0?=
 =?us-ascii?Q?1mLYwwJ+Z0/Evu6m7RCDbAvCyf/yGcIQkwXYDmr6K0JE9D/gHSyOwyS6chyW?=
 =?us-ascii?Q?yHD/HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kxXD5ZpyxLJdl82j6YZ1gUI6jwC6KrRmVKULcLCwEcZDDnS+HcrwUyTHkfO3TevOOheSgr2avG620G31kUxXePSiKci84QwOZwJavNIr9QnqY5xXfc5vu5McTdYtt/lAeqshLTOe4m1nuX/WYnnEzdWzwYdZZfEu3MEDwhke5lSjgqcn0yUJf2fR2jFZALpKE2pIfCmCwiihfCuj0nsWyBMK4KLVpdo6io8HjP9ceg6JCW1Mdle8F6LfxUSc6d8FzVxAKUnp5irPpVHxvPPWHMLtu0kSIw7f8Drrs3E3zVL2IVpRveVSYqLLNA+ehdYQ4bhJSY4no+ey9xWfcjuRexAiTXhli8ZWnbFQepSrj2bGu4X6rJTU55DSCs4vSVYSvohrTPcvM1dWCaRDgdklGX7aXZH96xBsBNDCgxRkBYCMuSK1kIvBXCMedLvAenJtDTBXmB35LZPTimfAy6S3w5IHfDiXyjJ2D998FGlYz8dPEuxRr0qgxfr1Vb6qsc86GAKg1b0le6WWqTXjzq10VPtJCqvOB2sRIXhh0BoqyaAe4CRrbEB7n3BCYqLG71FSSTFYp3QyqxcKVdI+4CNDwF+1BOxa+9Dlh/0YQBonLBs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89da2a4d-19cb-43ed-90c6-08dd5791f76b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 00:50:59.1099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/WEuft9Me+tCN13mPE07nTvU76rfPuyP4MsWLNghOnYmSUCVfhz6d7sRNFhoiYt3yFkYz9I1arZ2u5dj+tc1nUWBjiM0KaYwDRX4ZITeic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_08,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502280004
X-Proofpoint-GUID: RWKZs9LrrNWh_KA5TDz7siFgUueB22gD
X-Proofpoint-ORIG-GUID: RWKZs9LrrNWh_KA5TDz7siFgUueB22gD

Add a test to validate the new atomic writes feature.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 common/rc             |  51 ++++++++++++++
 tests/generic/762     | 160 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/762.out |   2 +
 3 files changed, 213 insertions(+)
 create mode 100755 tests/generic/762
 create mode 100644 tests/generic/762.out

diff --git a/common/rc b/common/rc
index 6592c835..08a9d9b8 100644
--- a/common/rc
+++ b/common/rc
@@ -2837,6 +2837,10 @@ _require_xfs_io_command()
 			opts+=" -d"
 			pwrite_opts+="-V 1 -b 4k"
 		fi
+		if [ "$param" == "-A" ]; then
+			opts+=" -d"
+			pwrite_opts+="-D -V 1 -b 4k"
+		fi
 		testio=`$XFS_IO_PROG -f $opts -c \
 		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
 		param_checked="$pwrite_opts $param"
@@ -5175,6 +5179,53 @@ _require_scratch_btime()
 	_scratch_unmount
 }
 
+_get_atomic_write_unit_min()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_unit_min | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_unit_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_unit_max | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_segments_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_segments_max | grep -o '[0-9]\+'
+}
+
+_require_scratch_write_atomic()
+{
+	_require_scratch
+
+	export STATX_WRITE_ATOMIC=0x10000
+
+	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+
+	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
+		_notrun "write atomic not supported by this block device"
+	fi
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+
+	testfile=$SCRATCH_MNT/testfile
+	touch $testfile
+
+	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
+	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+	_scratch_unmount
+
+	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
+		_notrun "write atomic not supported by this filesystem"
+	fi
+}
+
 _require_inode_limits()
 {
 	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
diff --git a/tests/generic/762 b/tests/generic/762
new file mode 100755
index 00000000..d0a80219
--- /dev/null
+++ b/tests/generic/762
@@ -0,0 +1,160 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 762
+#
+# Validate atomic write support
+#
+. ./common/preamble
+_begin_fstest auto quick rw
+
+_require_scratch_write_atomic
+_require_xfs_io_command pwrite -A
+
+test_atomic_writes()
+{
+    local bsize=$1
+
+    case "$FSTYP" in
+    "xfs")
+        mkfs_opts="-b size=$bsize"
+        ;;
+    "ext4")
+        mkfs_opts="-b $bsize"
+        ;;
+    *)
+        ;;
+    esac
+
+    # If block size is not supported, skip this test
+    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
+    _try_scratch_mount >>$seqres.full 2>&1 || return
+
+    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+    testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    file_min_write=$(_get_atomic_write_unit_min $testfile)
+    file_max_write=$(_get_atomic_write_unit_max $testfile)
+    file_max_segments=$(_get_atomic_write_segments_max $testfile)
+
+    # Check that atomic min/max = FS block size
+    test $file_min_write -eq $bsize || \
+        echo "atomic write min $file_min_write, should be fs block size $bsize"
+    test $file_min_write -eq $bsize || \
+        echo "atomic write max $file_max_write, should be fs block size $bsize"
+    test $file_max_segments -eq 1 || \
+        echo "atomic write max segments $file_max_segments, should be 1"
+
+    # Check that we can perform an atomic write of len = FS block size
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
+
+    # Check that we can perform an atomic single-block cow write
+    if [ "$FSTYP" == "xfs" ]; then
+        testfile_cp=$SCRATCH_MNT/testfile_copy
+        if _xfs_has_feature $SCRATCH_MNT reflink; then
+            cp --reflink $testfile $testfile_cp
+        fi
+        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
+            grep wrote | awk -F'[/ ]' '{print $2}')
+        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
+    fi
+
+    # Check that we can perform an atomic write on an unwritten block
+    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
+
+    # Check that we can perform an atomic write on a sparse hole
+    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
+
+    # Check that we can perform an atomic write on a fully mapped block
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
+
+    # Reject atomic write if len is out of bounds
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize - 1)) should fail"
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize + 1)) should fail"
+
+    # Reject atomic write when iovecs > 1
+    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write only supports iovec count of 1"
+
+    # Reject atomic write when not using direct I/O
+    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires direct I/O"
+
+    # Reject atomic write when offset % bsize != 0
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires offset to be aligned to bsize"
+
+    _scratch_unmount
+}
+
+test_atomic_write_bounds()
+{
+    local bsize=$1
+
+    case "$FSTYP" in
+    "xfs")
+        mkfs_opts="-b size=$bsize"
+        ;;
+    "ext4")
+        mkfs_opts="-b $bsize"
+        ;;
+    *)
+        ;;
+    esac
+
+    # If block size is not supported, skip this test
+    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
+    _try_scratch_mount >>$seqres.full 2>&1 || return
+
+    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+    testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write should fail when bsize is out of bounds"
+
+    _scratch_unmount
+}
+
+sys_min_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
+sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
+
+bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+
+if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
+    echo "bdev min write != sys min write"
+fi
+if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
+    echo "bdev max write != sys max write"
+fi
+
+# Test all supported block sizes between bdev min and max
+for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
+        test_atomic_writes $bsize
+done;
+
+# Check that atomic write fails if bsize < bdev min or bsize > bdev max
+test_atomic_write_bounds $((bdev_min_write / 2))
+test_atomic_write_bounds $((bdev_max_write * 2))
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/762.out b/tests/generic/762.out
new file mode 100644
index 00000000..fbaeb297
--- /dev/null
+++ b/tests/generic/762.out
@@ -0,0 +1,2 @@
+QA output created by 762
+Silence is golden
-- 
2.34.1

