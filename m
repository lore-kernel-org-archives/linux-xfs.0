Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25F142A168;
	Tue, 13 Oct 2026 09:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884352; cv=fail; b=gf3+sK5dAA6Wdj8asg16frG+3qZGORE6fyNSS/LDNwdtLkzCjki+AWS28aYzvPp1+wY+GA9PZ0cmBycztARWu8FAJnycsBDdicMscOgobbqjTLcT+2gfVHy/G+u4LAPc3VYcy5KZib7Jt5Basp5PkU9zY5xX3lwu0hf88uacS50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884352; c=relaxed/simple;
	bh=riSTttPDYV16AWsBwMcvcWyJOBR18MvspbyK7gPuyQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aK9/6fxCdI898+M+SssSiObGLPSUoPD51FlvfdYN7rkw1luK58Q4Z3PuKRh5L7iPzSLNgXDDIgv8av41A6TNGiweQyDGde8m9F0lw8C6j7ZL+5iP8zEF3NUgzFM+yV1rNTpfPHN6GJ4M6KVPRlkhhOxoa98jzflcdELufHU4LSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eBTLidJ7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lXLl3c1M; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eBTLidJ7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lXLl3c1M"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CoWI3435858;
	Tue, 13 Oct 2026 09:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=gqac8ha0T4aogKn6
	/9nPqbbNJSfMQGxdrmHHrV9M7jk=; b=eBTLidJ7XRdxbj7fH0CCSxbKcT+h7KU9
	34mZjgJlbv8iD58QHQj+bGXEbeugxayuBuu5qPWmWMOIvAy5lDrK7My92RQgyLhv
	jTtSurOx+x6BnwcEd8hhnzQs6zrFBjfasaGFgwNYXCJu1/kSTy1mtP2Grp8XvgJ1
	LIso+T8etVuXYyt8diwU2TGFl0UYIt6XkIXsVdcnTNGWmsDDnEtQ0UfEurVvn70p
	pMVQhDrqQ7YT8w3/N/uWpHl3AFFTJfFDRTMqu6odAE5OEHD2hdpdOT8kJuceimlO
	AqRrVk0nLyT3dbvy8iCrEeUsooVP/0tOMSwdRDtVVe96wJs4chk50g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTNF005400;
	Tue, 13 Oct 2026 09:39:06 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010009.outbound.protection.outlook.com [40.93.198.9])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2c51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j8NkE1RvFJB6ExeVsFuut7V3mUwguRhvX3X4fhPtIYkCWZg/6CL4hqV1Z76Q8BHU0MDXEhZ3XJ/BSLoleE7w+VXUE1OYwdyLGJ10+2NqOjX7FbK155Q5K/ZGPU0LB1WQKs18KM28Yl6JJ7vmBgB6g8nRnQBVAg0WM5OrNRnJXpVcb0Q9imGO9j6HTbYgnZqc0nKUK55/RArjMnCLPLPgIa/XoWonDv4b5Xnd1Tyn4hLrX7L/EOcKcFPzNORDZZlXxVMnUB8I0rezsU8stCl7rLSvHmVezQ89wEVVssbFeO5tB7jvM/Vpdg3WEMt0fxK3g5pa0k4U7EcPTmudDnEcuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqac8ha0T4aogKn6/9nPqbbNJSfMQGxdrmHHrV9M7jk=;
 b=NoS+0NPZtTpnPujToVkh9qJ3j20gQwZbRVIlyqEp/7dR5J7T+Uu4y/zhNIWklGv83vaj8PO80o8uFAjmOK5pno8pCZsQUb/QuUt2j+PI6QO8lSzM1jBgo6A0+4bl6YnGJvvzLeLRwK5j3SNDyz4njxUME7/6BW+T106xgtdCN5XSJvDyrOiVJ7Os1HETA75okmTQFXHGNLwBDM9+P6B0Li2hxkUmkKfTrurW7cgToogKDeHvZXkqnPpUozbINU/X1Z/cWaKQ6w0u94zxJwGEhgl8xqDNLU1zVAisCgzm6gDknBsBKHbuL7D2N9PRnd7ClDwLLWP6mTU7eAKoRgpfCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqac8ha0T4aogKn6/9nPqbbNJSfMQGxdrmHHrV9M7jk=;
 b=lXLl3c1MmZxneLW0mXLUN97jO+Bb7kUblk/c7Zn4+5eXnhMgDnWOUYGcn5wP2mcL3osIwde4XIpCtq5IY6Mhl8IOqdWHRX34UMvGz+Pfe5yVH1nBaveb/QsZsVy6Mf9SpJALODRbuHNg8sh/cY9Hw+FBbN6CAjihj3big8fH7Ow=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DSVPR10MB998130.namprd10.prod.outlook.com (2603:10b6:8:3ac::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:39:04 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:04 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.15 v2 0/9] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 15:08:51 +0530
Message-ID: <cover.1791883295.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0004.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::23) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DSVPR10MB998130:EE_
X-MS-Office365-Filtering-Correlation-Id: a4fc0be8-fcdf-4265-a2a8-08df290dd1a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10070799003|56012099006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3pT6u9l4yWXIsMpqUEPFejCKlBOJ1+3OnVBt2UGpCuaHMRoJb41RxICzyExov7YLf9caJw2HB58oiuHPoCiWhtKTj9MMDQ8MG0Ix1WleYohXBc3jiK5J+ySdv0S7sO6Y6NmnbZr9mgmxsN/GV4EcwFBilkbuLGhv6QYsVrAxp4lVfvIHEL8GB0swVjleSQxRe2sHIjUJPtUZk6D6ncKu3FGOoS9TkRjz6JffJDDmhPhFd2ekI12yo797KQwqf11BdsjOhiM32nCmaM6swJgXExO4Xl2NoRyFSkDlnm7W94Q64Nuf4k+Ps8Ug7clLRviXVhtTV0zXNBJZ0wbhHUq4Yvxx7/D7MF87H3WtHnqDQoe/CgsiBLt7KnWoBaGZbMb1THOThXhp1jYZCqVOeZTWfIdo7krtPWpWpWL3kF+gHs2m0EPeI09nwxegjr7ZCxNB677ZfwiUbXMdLSCnxczGxR2AbAmpgLEH4uvhmwYWiDdMZCnHhuITKzCWUEUQuPcfWWYZ/tQkx9CIZE9CqWrQ0x3Jynbhm8rafrguxgUz/OxpM31rZM1xdnVsop94jjGM5zpUCeCkLJDcjOdUIOPsTmt5gd3P1mm9WX1lwikjpl24q+wm0oqzJ6QlzbhUZ3CM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10070799003)(56012099006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?efxHatl6UORDvfTUUPOpyGDv6V9wgbopEmkVrmKR+tuuvHp1fJYAaXeVgSU1?=
 =?us-ascii?Q?miFsvVOQu1EXQDldGSakoKF9fos1Pqa+oJW6UQiLMFotQm8U+rbFJhCS4wk2?=
 =?us-ascii?Q?KenECGL1vF3+WLtQnQsF1qrt/uEtySR/qGpAUK45zjyOHSR3ITyveX51Q3TF?=
 =?us-ascii?Q?3mQUSbw/Yc9POaXJMbryTRUTnjCkOPjWPXGXIcByZ+h4yqdQSerXrdihQ6s2?=
 =?us-ascii?Q?1WSrTTSSBCDI6fJP4zVeKNpi8QmvCOs9l77k8fsIghOn/CBx8r+2gq7oqTp6?=
 =?us-ascii?Q?oVzXYtJ+dodaLVfLHKys4FoHwPWP4OD9zi1qiFCXrdbQyElvx/qntjHpnDdA?=
 =?us-ascii?Q?K44XYRpGrJWQ5trlRaenNihSbNduYYp72dGkSVuhFwEzw4BTfGkgOULR9Sr9?=
 =?us-ascii?Q?R1nzrFzjehVmFh8qkIxDiSeqMhI4B0VSoxkuX+vffEFv9XAZIxM5VKYftYWx?=
 =?us-ascii?Q?4c/8dBdNGesk3yM4Lgrdd6ZENnc93CB7ybYLqqdPvtUUWxwUBwS4KLrArqcO?=
 =?us-ascii?Q?pJ21p+toychZ8Vkc2eRNKGrJigGbhIyHGAAbVlAdveMk/btXFErzlPEh9ZSk?=
 =?us-ascii?Q?4OWtV4+5FsadTj8zKSBxs5q9DG5b8PNRihjAgYYtzBOZ67OHdU5DHP8FgfH1?=
 =?us-ascii?Q?MJMt4MSKBuyF/Ce/LqlpnfDskr3e4rA8IZyrQHchitdwvY18YObUWZjsjl4u?=
 =?us-ascii?Q?b5FrApQ4zHHrlIoGJQXFfdyZSHi0+VhP32WhMvYj/yeQHcFy5XkQGH/QAnns?=
 =?us-ascii?Q?ckTSL6WY6dXidFVn3i5y3oFuf/NqkwYdOurpvIGNSGGnX6tXa2RC67A2iH82?=
 =?us-ascii?Q?O2UIAgFGICUm7rR+KW73kJUDzatCwwtxDn6rY7q8yfO1g5+KSJYm91VryhId?=
 =?us-ascii?Q?nIK3k5Yzy4Jk0Fyr2kcD2yAwnt8b3k++KZ4Ch3b7mdTvGAkCrotYmMswXQpB?=
 =?us-ascii?Q?7GihBWB+dmKtm+SGz/rAI5aQ7BgWqovdb+pY4bYnzeWVZRjUuO5sUzVOasLw?=
 =?us-ascii?Q?QnR+ShVPGK3XwYzdaGHCn1BdWIfjUKFGioei1pHDoJ0/HuQ8uatcdQf6u39h?=
 =?us-ascii?Q?Z7YusO8qxgPH6p1F/7IEZuQWSSiD0ZkD7oWZTQF6/FO+MtB7LbG3J9okbCcV?=
 =?us-ascii?Q?3bPMYbcsUTCOmqRgfhCh+/fmU8qTUhz7SuOB9dAznNMPBAg1VuTqernf4a6f?=
 =?us-ascii?Q?KmVX0GYCuRSGWD/xLXBqIFs7P1SelEeWDJWxaL3h/+CBk5oSzn9TJzGoMpr2?=
 =?us-ascii?Q?Y/oDgFxeHmhL1ICFBjop3064j5uGT2I7TvhtvnHyCYJVv2N5RXwGF4FYbWY7?=
 =?us-ascii?Q?5RLrK9/nNakmOKLPAWnORJavlp+MrfRFPfPwT9kWaTRMfyeCfdLtVTCd3K90?=
 =?us-ascii?Q?Kc7H5Zv7amQq/zzDgxjuczrRFOmXOU44I6oSQQmEn8VWVGKLAJxFAnK9vH+c?=
 =?us-ascii?Q?NFoJ6CdGA9yD/rrjIyey1GejSvotbVVTW5ntv12NR40ohW4uY+9xzFcN4mQB?=
 =?us-ascii?Q?7pZZSDed7ZbcMGOSsiaeEssHf+iskS/3mEreNiXH946qwuRYdlkEafR6O7cP?=
 =?us-ascii?Q?2jkDQIbDPTXbil8hcnhYTjDyrR1S6PzVInup7OmMQr72HNirTYYbhOxKt594?=
 =?us-ascii?Q?jMUyQlap0mGNF+bZIXqtI4t1BA7cTL3dKQzEBWKAMOzK1YyY0HTkfRYqQJwI?=
 =?us-ascii?Q?ufbK9p9H8JckQW+J+DA1x1uAUj1D0qtuRJQEq3rrwDVljAvFntQyRVtQkiAN?=
 =?us-ascii?Q?wyMA96TZz0/JKDB6cgPAYuwPQ0qp7RQ/bKGL6mMdFIUpbWkvpZduDZufRiib?=
X-MS-Exchange-AntiSpam-MessageData-1: nv+8o20uDugrnCQxRGuR31AkwrB+iwqC8SY=
X-Exchange-RoutingPolicyChecked:
	qLgyyGM+710ZsRuAjGdIh/QFPTa4gCyoZzh35RsP12MC1tjRZlxJwt+TgQWmOEfdMSvMxc5FhzS2o3z/Mg5SDs8NzNB5kJShHNHbcDWbR7ZVYRk1rBOHspY4MuzoShwbk2XXQQjFzWt/ZUMkot5crRbnreShl0IKS8ujrI2Z00LGD3kDC7Thy+wWy7/6J2cDxQA4g9R/AUB0Pl5X01VCqrS/vHyHPxlTiSiu1mUNIODSvf4Bg7jl2U3Dfv4PIml9NGKwtBd3FNEOjC+DKX3ae4PFbLvmhVJVpunLcpjw6zBtC4BgkuLhxQMFdwPPiM5alZU/z8KJsvUGigp1BtURnA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cxdjyyotUZGoMqanxbji+iCo6+6se8dpAO6dBdIneH8F1+qNTpH6bhlnfeSdw2uWmxLN77HMcE8ip1Kb5qMirF8r/QjGRIybWghumnrgcmFIGBtog16+IFvphyesAVy6NSdRD5OzObS6fbzz0NVDlawD/u1T0+TQn3k1QBVzcXlaCDvZ9RuM+3MDSJbsL3mWoLZ5WrdxFZs5BhKarr/sUZu4KAy4Q8e5YSOUtsZ0GmTvDpOq3Aq+S1FLVRyQfADDojT6OMtS2OChLvIPfkddL+NvPbpj1rkS8mwJK99TH+YIuh/+0O/sEnnzpgal7qDzYduGdMOYbfzOTMomID/D1pqgMP52VIGtvd5XWiczmJXeumwN/d/lBWEnmx9TU+XQedNyRQ4d2UQazqjJtT5kvHnJgk1vOmYeaveMRKbyD6N5w31Ss6PQs4tCRB0gHimJL66UgBftBoktIWYvV3wAV0eHnI8WLJ3R4aiu4wTvaIx+tR2rIq7N/TW4R6lz4HrXRmduL6bM8RBnL/exDODketuv6MBU+aLeHvCt6JsvvS3sOQD6DfFkUNYP+3zHYgYo0jgzs+sBDMWCjGFQya4ArajbHIb5ME+wd+n6kPASFsc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fc0be8-fcdf-4265-a2a8-08df290dd1a0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:04.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rF15M28d2aH1L8H88UtE0YGzN3NRXrY/12PPBzJBENrSXAimbPGTSFFg+1YqSI4yKpfuq2Z0iaX0pKfnrTGlQp1Y2EkxxzbrArvezEadmFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB998130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfc3b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=kk7J8XDwd_-Zc7KFLIkA:9 a=biEYGPWJfzWAr4FL6Ov7:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX79rpBjTwsX3J
 GvD95trPDDg31y22UW1i7YqAI7xj4o6pf97UMBDbneozUuNTjyGjxQI/fAuEiShuCfFUYxcC4CN
 5CBQ1hivoQVfPWeYhiPpgvmZtJQ9AIrkaxqDfvv8cqlJZkdWPCyU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX7ZjEaCs7fQvK
 LqStKyFgUR3Q3FeDJZBOUjiOZXMrs32RcLmQSn5s2EcDC7JmTiyUxVFFZjKRlY3DxMDQGtLkJFz
 RHGPcuMWgpVXKPHI2xOapqHO+aQyLo4rviUKC0/nMemZqELR5qD/TMHqZkqcDKSRpb0f219nNxp
 H2zQlVe9rcSFE+d/nAjKat1PSwfBuux2bSwxCSPpJbsn1Tll30GFa2A5tMeWvHDOhvy79rvosBz
 rM5iDsxllPcElnIXRo0XRXUXbcHDrEGsf08M099YtQGxpXJN/Iyn5/XFIFL8mhq+qHQdYG7/wDT
 lOWHc439aXdKEYf7Co/oO/jKRUf1Ttmrz/yuq/mRs3aASEtmb+FQ77EpakabnpBZ1rz/8UTGaKQ
 huPdqQGnT5jDA3u39Sm7Ix+ZxR1aNYWqXjJKZpvBQFasv16tDJOdEXzIYO4EvmyUhTJdDi33TxV
 xdUZVWGgDWe+h+UADKQ==
X-Proofpoint-GUID: dxoO3GhBvjO_4gXzzFfhR1xRkh_nKFY5
X-Proofpoint-ORIG-GUID: dxoO3GhBvjO_4gXzzFfhR1xRkh_nKFY5

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

xfstests_xfs testing results:
	Generic:
		Ran: 001 to 771 (671 tests; gaps)

		Failures before changes:
			Count: 19
			IDs: 075, 083, 091, 112, 127, 263, 269,
			     270, 363, 365, 373, 374, 645, 700,
			     733, 753, 754, 759, 760

		Failures after changes:
			Count: 19
			IDs: 075, 083, 091, 112, 127, 263, 269,
			     270, 363, 365, 373, 374, 645, 700,
			     733, 753, 754, 759, 760

		No new success or failure after changes.

	XFS:
		Ran: 001 to 789 (312 tests; gaps)

		Failures before changes:
			Count: 10
			IDs: 104, 168, 179, 300, 348, 442, 557,
			     597, 598, 609

		Failures after changes:
			Count: 10
			IDs: 104, 168, 179, 300, 348, 442, 557,
			     597, 598, 609

		No new success or failure after changes.

Thanks,
Siddh

Dave Chinner (8):
  xfs: log items should have a xlog pointer, not a mount
  xfs: aborting inodes on shutdown may need buffer lock
  xfs: buffer pins need to hold a buffer reference
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

Guo Xuenan (1):
  xfs: fix super block buf log item UAF during force shutdown

 fs/xfs/libxfs/xfs_alloc.c  |  45 ++++-
 fs/xfs/libxfs/xfs_ialloc.c |  32 +++-
 fs/xfs/xfs_bmap_item.c     |   2 +-
 fs/xfs/xfs_buf_item.c      | 382 ++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_extfree_item.c  |   2 +-
 fs/xfs/xfs_icache.c        |  10 +-
 fs/xfs/xfs_inode.c         |   4 +-
 fs/xfs/xfs_inode_item.c    | 164 +++++++++++++---
 fs/xfs/xfs_inode_item.h    |   1 +
 fs/xfs/xfs_log.c           |   2 +-
 fs/xfs/xfs_log_cil.c       |   2 +-
 fs/xfs/xfs_refcount_item.c |   2 +-
 fs/xfs/xfs_rmap_item.c     |   2 +-
 fs/xfs/xfs_trace.h         |   4 +-
 fs/xfs/xfs_trans.c         |   2 +-
 fs/xfs/xfs_trans.h         |   3 +-
 17 files changed, 467 insertions(+), 195 deletions(-)

-- 
2.53.0

