Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6496B7C6E6
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488071; cv=fail; b=g/cLSABbEGvMIoPtgn8/uONYBofop64Tkcmb5bOSXTIjacSw3qihB7LiO4uuyBj1IJvIaWNWd/LuOLlVv1F7bNUe0wXZikY0ZzjVDGU9+5O8z3tOWLB5RvXF/RdF0i+riHmQ3a43Cnk5SaLdQxeQwU5yJ+J0kuycdMj3JHz3fRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488071; c=relaxed/simple;
	bh=DffPT8OGw3APfCSx8Xs4ZtoLe5/3JgRz7DEjHTyhIeg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SQo9bYmmKt6CIGHDACSCAD10iL8pbUPkYLZfyQPkVS7W11w+I6KfOk25njKRH5X476JxJKjLH0p4PWyggN95UsJEFBYDk2HDHIMhi/e5RvxQyT5xb/ILRb5D/sN2XRyk/zckDn3jRl1IX5AxwGtKqbmYGrRwkxbFNkJH+UZStxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SY6sybno; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hf/4HGy4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SY6sybno";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hf/4HGy4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BtDC001508
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=h/DKrACGieoKaj2IhvGvin2xwlA0HSckjRecyvuccOQ=; b=
	SY6sybnoxU9+MI01sUy3qRuRp2UUFjmoLBg06o/qhglJDX5LPfyvLsIPiWzkDA/T
	Ebgkt5DC5tDzB9ydh932qYCmDfR6siGeJl+hJm297jR2DeciHTfmboe1cfVX2/Hv
	tKGWayg/XtCObF28ddiNJcB0aiXK2cRbIqMoPQ2O0CEoWtTlZLxvnHEGWU2KyIDA
	FgOXg/wq4ZrphqD6gVa2SRBH8DQOtCzFBGW1T5bEb6RNYTe7tRSIJAgPwsvsDNor
	2d8VvOVoo5CLPrg8XCDz3RH+cNWAcuM2kuGjyayN6id0lFzztD6QHrw9wMHFveU7
	cgyXUD0FkwKYkqiIIMFpsw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0xayk6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI29oEE018307
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f9fbu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ygNiPOM9KniZDn/YGYest0TLLSA8GYmL09TLHG2O9PXaInDTkUP/XqXwZNiA9HZFXHWIJLrYxGlYXxceM8VSXw6x0wHl5yQswnBLwpmA8bIhoZxcnjgLmVkT9dwdjtEKh7AmHf42W6qpuEPT2A4mvh8faZjx+r/L4CxeF7PveRK2uIjU+SbxWVP8maWcJ/oDzU+SpyoswntCoKGxGxpaPnCQiko93i6QcV5Lc6Ph3qk2e4BfdEaeoUKG8RvFqhkbKYfKrIYRQ3c/w672H6//xz626BBeUUeH0Dk5T1QDsLRj3E9O6BEi5DVEa2KdbZjZbeWzyXb7BJ84GmSbrwKvNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/DKrACGieoKaj2IhvGvin2xwlA0HSckjRecyvuccOQ=;
 b=WSAkwieEicQgUHgzguFpEaPpKlPP3ThVu4HKtmobAivN2jXmUBsRBntfTqnBgXuDW/5LwvTCeiqsEeQKPRCv100bMaRA9oih65ahRDe+uuNkfBmytC5HX70tKPxiM+MKwEpIrIxJPqGJI8KzKXQ8g2FT0VOxn0t+VrfM3ejDnYubyI3dWHqG7FP74MjHCoLJLltF9xpGzhTdJf0N98x59Wdn0Kr8AZ5TJlvYBQMuLF6FIqDwWcZ70Vd5qyd9xOk1IPMa+VpqibUijOKPrn7vGxrtEyI1J9TWirKY+0qItf13oz8bKlRHwNMxPgLCiumtmw56jw0vlXTqaJRS4f5L1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/DKrACGieoKaj2IhvGvin2xwlA0HSckjRecyvuccOQ=;
 b=Hf/4HGy4D3fhPWcLMrLLy+j3Hl1B8MKMzgZdq24cIF5xH+ZXRkOwP4YPN7JvBTdxAQiC+CFhiyYr+Gq60Lwv7Wjl9dAkx6UTNDCz4Ns4Qii+UkkpStderZGNlNb5MKYlbThikhwQQvJlHRFnPmwFA9pmwQ7M+QwM2Pllr1YiRRo=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:23 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 06/18] xfs: Fix xfs_flush_unmap_range() range for RT
Date: Tue, 17 Dec 2024 18:13:59 -0800
Message-Id: <20241218021411.42144-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0039.namprd11.prod.outlook.com
 (2603:10b6:a03:80::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 05fead31-9530-4be0-e45c-08dd1f09b0c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q8WwAlA2lQfqLjzD8XlxT45r6cL4IxHTboP3Kdi8Di5n00/IprvBZfotRYLY?=
 =?us-ascii?Q?3ggbVlNnWgvpvhn6506gV7dVlTLbQg2U2aVJZKj4Vzeq9NU81FV4aUvQU8P6?=
 =?us-ascii?Q?GaPuc+oWHjlm3G2YEoe0Rg/9mXRX3bo6I5JvkJ6M9gMhtfrjlCjGP50ccCh8?=
 =?us-ascii?Q?ODuTAwnLf8W1fNm0uJp6KYRfTtx2K63DqRe9TpZqZUp2pBQXacofy/vwXTy7?=
 =?us-ascii?Q?b93hqFCnWm6tmFU/nwnddomsQ4dyIdgthIsLEp26rlV8oD0th7JRtXae1Jac?=
 =?us-ascii?Q?S6AbkRIzJuG9sFqFJx66kbOjXhCy3wxC2NTRo7/nShPoHzxauAMCVFvghXrU?=
 =?us-ascii?Q?UDuZLshQ/qAHXXCF8xouG98u9m3hh3t9l2KNn1m6PvdghhlvjI48QOXXAjbm?=
 =?us-ascii?Q?8OvKQPnNQlr3BOf7GTyGioaF0/3NkFEg7YW/55vo688JCGL/5mb4sEulMmxX?=
 =?us-ascii?Q?lhrE1MuLucdOiu63vC1x+GT8Hgm9Q5X4x4rT/MbL+mkGbyDivYNx7ruE6PJC?=
 =?us-ascii?Q?VZOFANdqF33DS0znlLdH1Gn4tbRmGJ35ZxvT8XpyL0nUPUYrApvtC60LXkn9?=
 =?us-ascii?Q?uTGDC+Kje06i6gtKhsCT0Q9pMug3nTG3JUS4RIHO7QmV78dDu2wcBDUHcJyD?=
 =?us-ascii?Q?MtS0UXpFj8+4plnmDV2ssjmi5SQLcvZAa0jpQSuyHe+aYqPk/y4EH8/5LoIO?=
 =?us-ascii?Q?SXwITQEBheZqt/a9BFw80c35l+/f6mO26SdS4SkyAvD8R2xZ7nVWS2qPmLtI?=
 =?us-ascii?Q?rRAGu+pJvUJq6AxzaGQ18lQ1evMYZbMJ7+235YJ8BFXiLg8yF1euWD+MP8WI?=
 =?us-ascii?Q?EtGQZO/kVvIBWve9ZRlWucJrTv9ZWUm6sBMA6seVuTtyG9mq8Xd0d5Q2d8FN?=
 =?us-ascii?Q?jNle4kwPFe5kQT/EOAIFi6yo+DDxrrBRfKGPPWTpejGfDjjzc0H3ncTMDPNc?=
 =?us-ascii?Q?dcDFl/T5UmUaGlKwMNmNjgL3KixcJAP9vhSRYhGLQ/bZUv0d0RHSLKHAjYlP?=
 =?us-ascii?Q?dujCJ3DILgk7hFygeBo3byNcna6aXUgaNwVjOn5V2SQNXxn1t8H7Foo38NVq?=
 =?us-ascii?Q?s9+wkS/Rqvc8qhUzwjzOIglY5R6RuOZFOLaX9K4eAXpd5TnOfmom8ftMGpvD?=
 =?us-ascii?Q?LGjBaQdAPu1k+/GIf7xf0Jx7xsGnp3A49FQRxgPaXHtgDLvIS0xtQQRGkH7Q?=
 =?us-ascii?Q?g+YBTig/iCJqxmgwCF6EgR9l6lj3udgkiK8GfJdfxE0DPg0Qy27Qed83tY2c?=
 =?us-ascii?Q?WQrEr+ddrg8TPhbSUmkDertKgz/4ItfGoJp5huHaW7+lfq2/vzjrcJQXtq3W?=
 =?us-ascii?Q?W2+tjJsJ5LymkqxAREhdeWhYDY9Vyq5ff22PeMMNc52fNbRYHvNePSRmuMF6?=
 =?us-ascii?Q?VsUDhFXIm2FR6vU0wQCNN9/k+Y2F?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KweCMY+JxTomHmCC0A+CBurbgmqPd8AcIoaxJY3GSLrwhWZtRLt1aDWGLawl?=
 =?us-ascii?Q?2p6aIGjrebaQsraA7g1GbalMHTZkaB7M9FxFut6G67gehEOUMWy9t8Sn4Nji?=
 =?us-ascii?Q?rpdJsaO0Aij4OlPMFQ+EdI4Jvynw40C0m5BtT7Xv2Ele7X9FanAiLiocGn/b?=
 =?us-ascii?Q?v7m7Vv0Q9tfUM7lr4LJ2DAZxgpkjfJtein86t+PuYOvdNPDSDWO26mKMu7Cd?=
 =?us-ascii?Q?EwGcdCb10w8jkv/ANxKJE5+pPmMhGLNpR3jz3NsDE96qFHKf3XqEEYJG8cY8?=
 =?us-ascii?Q?b49pHT3bnLWhA2xLF49QKWUHoUY8Lhl7iN8jthxVx3lvpvp5h6piAeg6gpoI?=
 =?us-ascii?Q?E7vlKKW1KAB9KUi0cIP6xzY/1esOdcfdGucjmI9gYUFiCivH5FLBuxnJm9zl?=
 =?us-ascii?Q?oJtnCn7FyF/5Ge3dGiQxvc2t1Ms9MCGslZqQLed/dcAdX77w0RA6K/GONqYp?=
 =?us-ascii?Q?zNdQOFUzcnuNjSnU/lNX3kVC1wij0q4LjMrHy3S7z55RjCQLlNpX0Qkljold?=
 =?us-ascii?Q?K6okHKB5MR9qIn73YybG5RohuTrIVee+185Z7+wKpPot6Sp/z2LvjeAxWtcl?=
 =?us-ascii?Q?SISfUiPFv2YdZPhkIb0Z6P0+AV7LNyyg5xezVqu3LwYAJ3YscyXeNLtZ5nMY?=
 =?us-ascii?Q?IornoDol7YpP6H1Luh1GF3RkUEHV/DUxG3YpAJRi1lBF8S4xTzH2bZjavdwR?=
 =?us-ascii?Q?SrmsAaUb8H8XgB57DwDEWxDxtfMk6uCuEYKqTMREWdmPh1OG1HDRBrjbEr43?=
 =?us-ascii?Q?EFWybFmAekPBhCT1Iln2wgJqjtKDe+Nz0BxJ3Yh5kG5Pl+YUR0C4XvnM72Ob?=
 =?us-ascii?Q?g6DW6b0EPBVdMIBGRi3X6MtrPQiBSMkCbNBYKzT9L8lsyTGlDT4gapFbzB6e?=
 =?us-ascii?Q?9c9WYslt+ODEmx9pQz44WSNEpNZLjXq1hf8/+fkT4uh5IebMh/CMqihp/qmd?=
 =?us-ascii?Q?G9C3P/QilEelBROlTvdrntpo1WXK3aDUAbDOsCJ4aFzbYtRJUKfiOwb4Kk3r?=
 =?us-ascii?Q?0+N++uHEvP8sYmI+SZxOofhXxE9mgNR+bV8GDSmQHrv9dkv4pw+Kzb1b3OpX?=
 =?us-ascii?Q?NHu9zZ8rbf3vYRifl70L3NaQCeGzJmGcJHCKd0o9iRCdzxT3PZFp59LMiEEU?=
 =?us-ascii?Q?nZEGjnyOM01wtWwDZXdWjWCDipfbZNPGNIo1TsQIuXlAMg+9v6f/vtoFxk3R?=
 =?us-ascii?Q?UGDmQJaOQSKvLqR8stfuNZaY1Wi3X5KYmcjLlv/lWN+y2gL0Ajjw8u4sGrVc?=
 =?us-ascii?Q?f4b1MIXrLVz2/5jbN79iU5lc9eNy1yV4WQb9p+cLSXOQxuZ5mXcKZZQqal92?=
 =?us-ascii?Q?0uajp5fAouHJQwOomtzpJawVC0sDLVNzdeHmW74KzhK73em2ZkOglshJbCm+?=
 =?us-ascii?Q?7B0FNiotI3lE2EfRi18w6bdZJPAaI5b+fpHYQdjGtzB/nq0sp0e8m8FP4sYB?=
 =?us-ascii?Q?J0Rab4iyV6YsV1cIif/uwnWWPj+LpXTky7Lwnc5ufBUOwvugKPxp4cKNR8DL?=
 =?us-ascii?Q?EGjUvFxxJskjG2vLrc662/iobqbQQ+IJwmeKGzeqSCLjyI6ez5vrTRtQz9ZB?=
 =?us-ascii?Q?r9PD7gDdypuetvG4X16HpnLA9/YRbqlrc99uBS57hU+8ufFgXuI9EHvKN0/P?=
 =?us-ascii?Q?92oXdOwaT3oUL1YC8FQQjD+ABYOt/6BqsIJSZVWDy/Q5Y3yaImM1mdfuKoe9?=
 =?us-ascii?Q?dhBFcA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mKnROGZkdIxZtKHuz6QgPbcsHXmE99EaRzip9eUmxzBm5ec5Lb2OmPcBUldpRovnVu3h6iYNktcsIjS1ZZ3UAKj2hF1s0+Lqs5IxhQkU7LHURez87HMaVLRuprdRYzU9DcR5BBstXJeKZS8SHHohz0guKn0DupBnUrH8y3z+/mw5UPDd7o7wb0EelsfwaMk8lqE1cCCYw5rSqtkEqAtwG7i4ViheU60SMXRMdW/7KWTuDCAcNTU88b9ALrRl6jLVKOcMgntYRM7VMqFDnOiaKhkQ13R1jn8tQU8+idhjgrgvq6rfKSPU59s2v1pcwKELhZYGMv3eomhWB+ZBSNrJu9IQRRhYbQwZMEhrGgkRs1+8CYuCMBXBgPTn1a4vGAxxG/4mqdKG3LKZacqo3XQ15dKhET2VkgXC1x8ab0mPVQPS48g0riqF3fvfrpzpKRh4iBDe2skMiAqxKi9kMQRnrbGS0fqwrgrwOlMcXMZMwotDv9ezOFnKoZ1M4GBQ7CDaiHk4r3FUgN5OMCwEjas9CoRqjYzmMcYRLv3QMnQhg9F1dZ8YldlNqwskD49844am+s4lTB4zEAYBwL4AQT16kAHlr9zhSsp2hwjjfnrMo1k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05fead31-9530-4be0-e45c-08dd1f09b0c2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:23.8953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VrolyB/49895uNtGgLcwx6xJe5D09QOA7PkqNXm3wCZY3og8vfBryD+1M6Sn3FATzAjWG/8IuY1b+Q6QecLUMl6HqW9MJJNEGmR3q+gRnns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180015
X-Proofpoint-GUID: ySoBMywdc_BQ45ohjmErkEfxgniS_kdY
X-Proofpoint-ORIG-GUID: ySoBMywdc_BQ45ohjmErkEfxgniS_kdY

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

