Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E6E1D79A4
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657132; cv=fail; b=mjqk/bR9BpPBsUfhev0CDPqdgukyOomL37rCLxB8CAI6eN5BJ6ipjQRuvIs0Y5HJMjIW/xqmq+Uve6sJ/xiRH5vsVVmiJNe/Mj5vp9vfZGGth4mUSCWnECBZUuOYHHn/86WUpTVnZufNgZ/imiGxYvwR1qsuDp9GmLNsQhxF0K0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657132; c=relaxed/simple;
	bh=/q+tEr9kbY7kGyTmxdqdJ3oV/ODKsw/QKNy0C1nTQS8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EA29bIApZSXPRMD78mwiaDb8ktqCxQ8imhcKA29tkfQoI2n9WfY7oLjMGoO7kkWC2Auovq+qEQeqDJI2USvX8fcj2PikrFNBN2BSyrAtFjwsU5w/sjZ3EHH823Vr+Ht0wcP9HGJKSTNOQmfMsuuGStJ6jaiDIBfQ8x8/H2ySb3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yqw3Gc6b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DGWl7Hft; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yqw3Gc6b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DGWl7Hft"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXUDO024509
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=+y2+BJE6vvwRyd3KeDqYlmchKlFZvyXO7xZqvOG9QdY=; b=
	Yqw3Gc6blZf8ZIRCPZP3lO4LtD7yceoo3Ef7NfiIjDYN/iV/l29cf595Y6LUwr8c
	UWSaepwTH9WnKpz/2SDY7RSC3MvAOeOspSR1gYnY/UdUR/nqBTuLJgWlO+IEVF9E
	hx5Z7kO2CeQoULp0aOlA1iwn1zkOszDLvNw/1IqVoJB20NpjJ82yFomPAuRAsXH6
	ZiUWHMKL4tl24FYeDp8+eCIdCPFrSJXmVv/oAmbaoZ4Z08E8rD2uzfwSXxkv8p78
	H2ZiRWE41lYigjZKkYfz+c0bREOVgygXd3WM+HOPqjASPkqpFb9ZzTrrTkOCdYqm
	YnwlHUfZ/Yr4ZT3SekaP2Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkak32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486J64Dh040880
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:07 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhycf2d8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qyPrvLSPTxj7gG44lSYskhs2ekzaRU9kepWh4qcxhXgZXK8eNhDpYLP0O7mzxTTPp8gpnyULo5ANRPo7kEMBdURolu76mWRt7l6LvE16gDJMUqhBO+u3EKf7mGcbAN5dEf/qMNoRDUeu3YJGf+P+aL1CdnbEBDC6kRrBNPOeeSGOG2T6ur6yTS24lQFpORWo1mjsLwhtb0/SWAljWCV3sUuPA5HFFblvnRY5ruOyy5FkcPj3fDaY0VsST+MU6Ji2MWjvcUbTnHh5PeUUaperXxayW74YGGtoMC2hmfRg6xdVBLlvum1P9KhG5CQnreH+SF511mcdQs1yabkKbCDZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+y2+BJE6vvwRyd3KeDqYlmchKlFZvyXO7xZqvOG9QdY=;
 b=q+X7Hzu8tj/QTy2w4gfWd7iaUmxII7A04EhVTreEKamcOF1Dcfqs20LkDrfs4tUnzy2RmMBbuphi4r53c/O66v17vIg3SskeCjnwf+1lplKCqKFAkzFp7kPY75So8td8o6I++tV4DfOor1FTtMdHIpy1nVjF6qCZaiMjQTJMe+jOJ10MJk+UWLOt1PqfhQfTp+xfoJLPwAtWZVHymIoQ5tbJcecuwYDPMxMGTAMDkvGWZ8vlPbv0OCddIiW0TfyaP24g+K5U6WeRtsuOoUz3oIdVgKcgc55PXJeZd0yWTpR24uPX/a6znbReBlGo6dCZQh2M5VgqLHq1gA6ZbAw60w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y2+BJE6vvwRyd3KeDqYlmchKlFZvyXO7xZqvOG9QdY=;
 b=DGWl7HftBecd55gyzwdKa9ckxKsdxNBA6tAzVdeMO2UDV/R7aucRQ1H+2gM3iSgFeGgHLvMe3zCy5IwzLGPVLJ694noIIfKDPMGdecqclvdRMtRaI2qg++bQPssDhoHhlT0llOEdgl+WQvXfDd+yPHgF4lqtiFDEWqaz1LM6ZR4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:05 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:05 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 12/22] xfs: use dontcache for grabbing inodes during scrub
Date: Fri,  6 Sep 2024 14:11:26 -0700
Message-Id: <20240906211136.70391-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0118.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 562a4b3c-3416-4386-420d-08dcceb88f6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BCzpmOihgboXzjjQ51JxNJ5Y1lLX0lRLY3i7fXxVVZWMnYHPyjquVICFwGVf?=
 =?us-ascii?Q?G/MbJIKk02oTb3NgUCOAHqiNeKqOk4y0FVmrEv8XD614bjCdoT2/e1xZ4gt8?=
 =?us-ascii?Q?adDMea1sQ7NJnTNGhQFfczd7SEin6GwdEJ3jx89LzlfHmNh1Zx0KJjuFOBsa?=
 =?us-ascii?Q?wJe9XXdHC3ORwe2xdiyVXTivsvbEg55OkVSIevRtunNJpoGsx8Mh0coFIAJ1?=
 =?us-ascii?Q?uSHHHAeX4C/NaHGt1H+XcDngmzmd56f5EMk8yj3729T7vkPECIyp/Hf3fUbI?=
 =?us-ascii?Q?ind7tQFcrz367YleBRqLMQMUBRUw7RNqZmDcZDcl6dZwUonyBtdNLef+jcQk?=
 =?us-ascii?Q?/IWtyYa1MEGaWHE1AuUjGKa3ZhaAwgsHfNxAEz+k7Qi6I+aMSLORQ+4+DsLX?=
 =?us-ascii?Q?sBV7oFajlp+SyT8d9/rAnTVR8IZxvyb3MN4xgwmEzm5cASt+xfnJvaSncjYD?=
 =?us-ascii?Q?KIan+pamVRYrR7gf8pm0fXeapDcDLNwfQA8bHeSOxlUpT+N0U9yaUtMQb1n9?=
 =?us-ascii?Q?lp9NTxY0xkoU8fo6CzRttzDKnKwbqnScCbsp47awno38MCPzm/wFdN4UcH8C?=
 =?us-ascii?Q?G+Z1m7TLiSfj7PbfdY9XGpOD1mHIE6PVLMKcMK4N+9JgZ95XVM5BXdlphNGW?=
 =?us-ascii?Q?buznx//tsJ3IXuIx22T6TUdHkrhHgnw4RLgyAlU9UhiYF35r5HKqkJUSfIYI?=
 =?us-ascii?Q?QJoscKqAOYk9O5VLgQiNQo1ckBU1AUjzyyBwDmwxu3oGQgwTho2cWHcDEByP?=
 =?us-ascii?Q?54Bkg7Ihq544Tcgd5BknR8KwBS3+omNHXYtrSi2FPRAi3vWXnbwt4Ad8z1dG?=
 =?us-ascii?Q?QhqZ5jaY5OY2pyKWJfiVVIWNyBwmd856UdqwI4erW9oa37EW1e+KPbxJBawR?=
 =?us-ascii?Q?kCzdwzPcXUNK++bjKyVKXmII4HnSITfaK6wrYY6GGPwK+IiSbfu/RMcuYQK+?=
 =?us-ascii?Q?R5Psen4rpimBbWUJsZAtymvAf1FSvdXejRig3t3oDcqI2+QafFNUn5YJw1Re?=
 =?us-ascii?Q?TB+5V7US6UYxC77IAUqava9HkXT628r7TMtRKJzP4B7293ox76SSezlYTGyF?=
 =?us-ascii?Q?N4UeI338e4vl+jvqsNxHRfyJBKwQhCh3BWqhfH6rqXPd1dxdiwNU74e8+Q0K?=
 =?us-ascii?Q?fgGKI9vgEd4dwrrH5yHg64cB3HVe/xBgxCUgMLWJPmiK2NXRWqRJTp0PNl7S?=
 =?us-ascii?Q?1owUYuT2WkET6XgXGOO+Yxp9VPvml4KM6jbnkCunCrfLEwelb3S+ZguYGchG?=
 =?us-ascii?Q?gXXlmEje7iGSwXnM1/WD4DbCnhx0SsPj+vx7u0k6iS53cH674fE4Q5A72Rqg?=
 =?us-ascii?Q?P/YGP6ZrYNojandLGV+Eorxe7ygHPrQEZnSYZR9BbSVasA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gxeRj0eadmojAR+vcUhfBqRr1oK6yjLO+Zd7mq+TdHjDgmICUjNmPMsF4Olv?=
 =?us-ascii?Q?lZRO3LGlcJ+VOr/hYKPOULj/38A+EstZz3dV8fqHKezt4UCX4wVA2rWoqGvc?=
 =?us-ascii?Q?krCeXyZGB46Y8tnOdsS6xpqBFEVtR55iFBds9fohFWzVY4qttv9OcX3rQByt?=
 =?us-ascii?Q?kDTNuo2i5GF/SWy2R0EjY7JJJl5WveCRMO3Y3GuNq8CaWx17REikLDgcup2p?=
 =?us-ascii?Q?X/OgpaMIoFDagNiyC1IZD36ruBJJtKdVHLG3x85WHBL46ZZK0MQxwqo0/zkG?=
 =?us-ascii?Q?dEzE7wy8BaG/+O9wkzbWZPbpv0DJYVcygKuP+WEaJxoRZRJu381J5eUDk/zf?=
 =?us-ascii?Q?c+B6PVTdUG4ovEkHZ7N6mcC54tABe/kJSAzlmLWqGvW+e5Y0nidi19APYJs2?=
 =?us-ascii?Q?tYNw+eIMAZ9NBqVdM0NWEkmtZ1UOSG0g5B5BLQxcFnmv1AZypcHGmIlpCU2S?=
 =?us-ascii?Q?6lMpC+iivJA7lysblXqQ9tWT5O2tYu9mDjqsJ6j0I/W5yq/qwLakcxOMHTX7?=
 =?us-ascii?Q?F3hVpxOCjwNbamyvFSah/70a1yye0O+gy9834rjKXROVs81Xt2p66ABeklUy?=
 =?us-ascii?Q?lZ86mcWCef7jOK85UnLJ0obWmuEgbJLB0PqPkBW/bIi85Ot4tHKo5FrsxZwr?=
 =?us-ascii?Q?R288grzdzsHKjffAO9HLO0XvD2hWDYTfqW+wnT834F7kKceK6BPj85678o7k?=
 =?us-ascii?Q?pxjIE4NDL2VfFhYtu5Coqd7MEF+htwzd9/AIsOzT8JM37/tD0HR4xS3GwciK?=
 =?us-ascii?Q?BiM6zP59u9IOysXkjxOeaLvLN/wFOTjRYMfqXxYWMGGL8Bg1jgrbR76mZ9mP?=
 =?us-ascii?Q?5edw9QQBd5eIwJZT6UJWi/PiQSGSf6GHxtl9cXGed46oRJbqTRnYHsy2DuJf?=
 =?us-ascii?Q?9PM0ZNj+Lj4w9A/yHPRe3/51QGTC3HAITvDQsK8MyYJQs3CdvkkXuNDySQvH?=
 =?us-ascii?Q?nkoVeWgMQtrE1agRyXHc1fTzJud3hq6nHwo5FT6y3vqCiowC6DX5XO1/1aW8?=
 =?us-ascii?Q?7LO2G92pvAXWzuYBw/dZgjB7MHVPez1uae7aGoxRRWqvQq89eybucodl7MgD?=
 =?us-ascii?Q?NOmf7ZwUCdAzFvEbrxbxgYoRuz+PSYGD2L+c4H+zTu85UHZETdfC6U9Ao0AK?=
 =?us-ascii?Q?bGNX3ZZLemKMK9p8nnybZ3NLdYJ1vj/BZD+hqj1gsMsG8HBCruC393l8Jvo8?=
 =?us-ascii?Q?5kr3yOyaVgjDVoAD5QjYaF3cJuyLHjmZzj3MjsiN7l7LTeX5UpcrVOE7eZLI?=
 =?us-ascii?Q?zFDT6TbhO9swxd80vRpfm4p+3QX2rHyjKFq96vOE3oZMZOJrakHWlsnqhL9v?=
 =?us-ascii?Q?RrCD+jrR2r2/LeIZo67KJgYddBvT5k8M8f2hqaYqGHNLKzqq8vf6SVM3iNfE?=
 =?us-ascii?Q?rpwgNDFekVaWQ6GCX/HNIumWaakeNAZL1thaPdm+Jxt//4YmLPzUU1psrzzg?=
 =?us-ascii?Q?gHIFB0FLBHEKpRbcvzBhisdQhvTOgEM4diI/KkrnVRnF3z7R72K/fkpUXQKS?=
 =?us-ascii?Q?tk4P8XFhrqAA1VMOQXgPAnxN7TqbAMY8NIW5yEZahsdBG55QieIeLHRxyTuW?=
 =?us-ascii?Q?KaM9z4jNrou5Zow5Pv1Q3E1HireuTOQRA/EhUmh5sdgzoi1Usdd+poMhX8hg?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EDLPljCZbtRXv4GqO0GSHz707g6TtCQf6JJmzf5lAdFsqalhG9sEcAxHxaRjrZQnVXIDsvg07MxVMOhnjP1wmqKkYwmDQYUsfSL5G7nVV68fAkl1ImwJq8a18SfRwh1eGWWqpfXdV1raawSLcHPI5QLgNg5SV43WXAwOPLHuFPYl97/yreuwG4mSVrkOB/ktv72I1HHum4TLg7p4rh0knoPZQt8ppKVmC7sm8hgmtMAoKfBj7q/l5u+0ekV9r4EJzCQdtDC83sUPyDPOOxi5m0lgaZK6nIZ/x40of+3VhQL/XPpFVuEs/LNzCBmsaJhR0AU23DqStcLksP0Qb3nBy7GVZgd12PLzcNYTMcsuBK6DmBNMipbUF17fWC9g1JS5r8zyFUOeD+mwvsE/gZL5ds8/eJDhBpsXsfGoJbLo0BAWwTN/VBb8nRUOLQvoN5rsv2P7/SVz6++bn9odN4koJbdTWoDumThDRBk7cmnSO6R76KMEmoYzpH7xs5Ggf473LlzXxmQnLb2uyXf1+fwvhLIm7shc4G9wg/j1OjIP7+Rz82Y2aK7vYDQmKlGbiOUd11fBZ4o5X7QFxjQWhexhkN2PfrLARWjSyliK0WLjBYU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 562a4b3c-3416-4386-420d-08dcceb88f6d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:05.6040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtnSJun5DFs+uyvLUA04Pn4r6j88Ce+RKOExEEPqGLeYjBs/I9dsQfR1TTf/VSNHsXBAL021TKGg62NqXr0PFdVgG+qw+nG/2mlQAd54DsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-GUID: Q0KBoF8Ds1Q3sfHjlAl5NbTxg3BbNULa
X-Proofpoint-ORIG-GUID: Q0KBoF8Ds1Q3sfHjlAl5NbTxg3BbNULa

From: "Darrick J. Wong" <djwong@kernel.org>

commit b27ce0da60a523fc32e3795f96b2de5490642235 upstream.

[backport: resolve conflict due to missing iscan.c]

Back when I wrote commit a03297a0ca9f2, I had thought that we'd be doing
users a favor by only marking inodes dontcache at the end of a scrub
operation, and only if there's only one reference to that inode.  This
was more or less true back when I_DONTCACHE was an XFS iflag and the
only thing it did was change the outcome of xfs_fs_drop_inode to 1.

Note: If there are dentries pointing to the inode when scrub finishes,
the inode will have positive i_count and stay around in cache until
dentry reclaim.

But now we have d_mark_dontcache, which cause the inode *and* the
dentries attached to it all to be marked I_DONTCACHE, which means that
we drop the dentries ASAP, which drops the inode ASAP.

This is bad if scrub found problems with the inode, because now they can
be scheduled for inactivation, which can cause inodegc to trip on it and
shut down the filesystem.

Even if the inode isn't bad, this is still suboptimal because phases 3-7
each initiate inode scans.  Dropping the inode immediately during phase
3 is silly because phase 5 will reload it and drop it immediately, etc.
It's fine to mark the inodes dontcache, but if there have been accesses
to the file that set up dentries, we should keep them.

I validated this by setting up ftrace to capture xfs_iget_recycle*
tracepoints and ran xfs/285 for 30 seconds.  With current djwong-wtf I
saw ~30,000 recycle events.  I then dropped the d_mark_dontcache calls
and set XFS_IGET_DONTCACHE, and the recycle events dropped to ~5,000 per
30 seconds.

Therefore, grab the inode with XFS_IGET_DONTCACHE, which only has the
effect of setting I_DONTCACHE for cache misses.  Remove the
d_mark_dontcache call that can happen in xchk_irele.

Fixes: a03297a0ca9f2 ("xfs: manage inode DONTCACHE status at irele time")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/common.c | 12 +++---------
 fs/xfs/scrub/scrub.h  |  7 +++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 08e292485268..f10cd4fb0abd 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -735,7 +735,7 @@ xchk_iget(
 {
 	ASSERT(sc->tp != NULL);
 
-	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
+	return xfs_iget(sc->mp, sc->tp, inum, XCHK_IGET_FLAGS, 0, ipp);
 }
 
 /*
@@ -786,8 +786,8 @@ xchk_iget_agi(
 	if (error)
 		return error;
 
-	error = xfs_iget(mp, tp, inum,
-			XFS_IGET_NORETRY | XFS_IGET_UNTRUSTED, 0, ipp);
+	error = xfs_iget(mp, tp, inum, XFS_IGET_NORETRY | XCHK_IGET_FLAGS, 0,
+			ipp);
 	if (error == -EAGAIN) {
 		/*
 		 * The inode may be in core but temporarily unavailable and may
@@ -994,12 +994,6 @@ xchk_irele(
 		spin_lock(&VFS_I(ip)->i_lock);
 		VFS_I(ip)->i_state &= ~I_DONTCACHE;
 		spin_unlock(&VFS_I(ip)->i_lock);
-	} else if (atomic_read(&VFS_I(ip)->i_count) == 1) {
-		/*
-		 * If this is the last reference to the inode and the caller
-		 * permits it, set DONTCACHE to avoid thrashing.
-		 */
-		d_mark_dontcache(VFS_I(ip));
 	}
 
 	xfs_irele(ip);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1ef9c6b4842a..869a10fe9d7d 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -17,6 +17,13 @@ struct xfs_scrub;
 #define XCHK_GFP_FLAGS	((__force gfp_t)(GFP_KERNEL | __GFP_NOWARN | \
 					 __GFP_RETRY_MAYFAIL))
 
+/*
+ * For opening files by handle for fsck operations, we don't trust the inumber
+ * or the allocation state; therefore, perform an untrusted lookup.  We don't
+ * want these inodes to pollute the cache, so mark them for immediate removal.
+ */
+#define XCHK_IGET_FLAGS	(XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE)
+
 /* Type info and names for the scrub types. */
 enum xchk_type {
 	ST_NONE = 1,	/* disabled */
-- 
2.39.3

