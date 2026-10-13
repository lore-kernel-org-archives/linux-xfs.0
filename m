Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C873472F9F;
	Tue, 13 Oct 2026 08:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879352; cv=fail; b=XD9XuwcnUKY4peS+2CdHTPMP9IgZkSwrUCD7IxsvxsyhYU3j2hmuELr8IykqWD5FQi2w6kQuu6bo1J9w/XTAZ1RwtPukpbrae+8LABP50j3HTwJmYHpQ3c+KLnn6RR43wDdqxJgfujmWGuktjerwAV+Sn5AN1pa0ZcKBUrEY7F4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879352; c=relaxed/simple;
	bh=E/xkZ1ptQmOz/sG91Xanrbd1Cf0AGu6udNOn0S49dQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=In8CJT23nH/AIdxysSXl+Y+1VyhUXerYQJ3wo8cSZxkBzMxc25roI5KTF3y3z+9vN5coqHD6KYUviUS3H6XvQXL3iqienVN8GOxxiVjqh9eBgtrOCveexo3gUJ1PlK67x32ergl9GBpc1JX/FTmTXLYMM/iAz8IqRznBnQN/pak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NuyJdxAj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G/SICCR+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NuyJdxAj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G/SICCR+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2FXuQ3439852;
	Tue, 13 Oct 2026 08:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vPwPMcwir8JMNdahQi0AvpqKE0CBhssd7amyUXFYD/U=; b=
	NuyJdxAj3IkfJWWsR17XtTmu45Xj9cN6/mUndPufNrAr5GCL82s+a1fV5kkLQG+z
	iOgqdwUig3wPcJzUyXi/G597yCOsPW0i9WsWNrIBs2qqRJwu51X4pTGK7ZibuUoB
	5U1XiM/PWnpMyM8GDbOes9K9Y87dDyo+vuYf4VHABaWb6xgTdDyM+9i6nEho1ouI
	P9JV/x3EYHGMBka8seAz/UU40U7FIr0ib36PMfJd14DB2G1aXXSCO5GOq9IcVMi1
	ut5U2xqaoSe90Y9y5inSWfBnNNvVkZnKhsm3xMRrnRmidfoCdd9zE44KsC5qjE/J
	ZFbUVpaL4udHBKiYUNl5ww==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kjmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86kMn034875;
	Tue, 13 Oct 2026 08:15:44 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012067.outbound.protection.outlook.com [40.107.209.67])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp7dmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k2QqPSp9srkKF/xAwU/fAmfFwk5Li2nr29iqsdv1mFjZpsJaTXzu565Ch9uBINC0p1dKUX9ZHMHo4LUs2uU5Ph43Y5aa6rBcZwz4jl2PHp+jPXJxifwOVZLaaz3IIA8mix/SRXU8VgFPJ2yilS81oHS2uTyB7dFvJX7G0j2Gn9GyTFYyEg6TrdpCH+5N+iT7RbiJiadQS9sa8C3875qERIJU5koJNpkR1RnJhgbgZRsQQWtF3WIm6BXhHuoZnAbQZrcjX0aLvix0qoS+o1wzP+9qUFQclOUQkVrJ+ihBdzyiZkxSNc0BTo9x5CgMIpW9NbdZSz31cLAH4VmZGglCAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPwPMcwir8JMNdahQi0AvpqKE0CBhssd7amyUXFYD/U=;
 b=w9rWSkv8CRQiwBnuXSyXwgjtVg7Rf6U6ktH0OT+8tONoYliKhsrOP7+esJneICOtRDexnVrAW0/4g0hRtSkEF8pyj+bQPniXIowBsIWdaH5XPQ0y05w1WRDm7AzJex01sjJPlehC8wXF1AszfbbtIgDEd1MknYLFBbClTixEukL66QY4nt0Ichy/2TW9w8OVlitabg7vesnpvt5gA64eayodYxGSvqjNnifRNwhU6jwBMnJAQMweVXqChq/yc/VFqAu57s7tRqIT21V2GO8Tn9Sy/UnEjUpbpkFb8kNJM6AktIHW/WrXrDImcXodoGoEkzJqSMo8vsBpQmiu+T7WcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPwPMcwir8JMNdahQi0AvpqKE0CBhssd7amyUXFYD/U=;
 b=G/SICCR+CiozHrxq1SXFV0hpCZDwbKPPWbfubbSKzmYWiUBXuo0jqMbNFOR0DRi0yeu+3kiXJsriZnwBsk2pwg3NDGKAdKe0rzgMt4TV2QB/lfzzT9d1PnupQs/VzeQwZBK3M9KWJuOAYKu0CcSCYgxQ/2irOH6+bX6gGvjO24U=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:41 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:41 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 07/19] xfs: don't nest icloglock inside ic_callback_lock
Date: Tue, 13 Oct 2026 13:44:51 +0530
Message-ID: <a89064c0554a87b7776c4ac53deb2520486be292.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0130.apcprd02.prod.outlook.com
 (2603:1096:4:188::8) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b778cd3-7cd5-4655-ab8a-08df29022c0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	t40JK3smi8uK0NhTBY7jR1hX0fNrSciomfSbtJeHrSghm7XO9D+oR8SH/wWqCfQ8F+vGhEWEoy3+RnkpqneflRpeh2Q8baoCOJ6DB4yX9IAqcL4IzIHdfr85rb8SjeBLQXn5ThCtPzz67obXFAuAuGo3eNrPf2Pi0bHH75AlG/fm6p3PAYs6A2t2TVUjCd/O746FPsixopRanE7PVErxDx39DYV9XaDFEbQQ/GH3AAFIDIVCMvmTQI11gui0XARQQwGFqsMOtTjSwg7Ue0WXpkIqa/jyDxN4yDO8BkGSqpOneGCQ1BHm7T0UhFAq66K6l6tOidGBDetb2qJxHbLCzfbNHZzQS2+7rkteu7LzvlwUltRDChsspOuHfhgIfC4+G8RwkwM+znmw+Z4l0FfPvQr1cNo6Sqe8i0roOkkSRdL6sWbUN+EvEeuHaXRPFnoSuL+3UJNsb9lV5/N91CRGGWInqPxeOeycakKuD72HBjM0s+TsZ6PuCbyNIc/cSnWlhKnLrJzQ7+7g4RGcpf44nx6oE277C+qtYVSNhrVzMUHCa0dQNnUbza1Spx3lwPhsJ7wgJxphlImijZFh7w9tCxU509B0SH/bw/d4pmbAvctRpQjtxwvzPwMwo/tmnNb70JqI5zLVHz4NC2XmSuDIR0nalgceJePp1e+KgBUmGEw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bXm3k9xtxvg4pAwJ8ZjGKz31ExFG0OHmGmYu3tGCwrOUS/14GSdr7F1UapuA?=
 =?us-ascii?Q?P58AmqpKt1z0Iw9CrVwLv4nge/8+snYyi312dp8TB1VUYLKClLn6Qau5GexW?=
 =?us-ascii?Q?F7erW7U7WU1lOlD977QuS/dHovbqvBFbG2V3TIZis/ZPq8P4XPocanrwb17h?=
 =?us-ascii?Q?eIgTRoTV/Nl/dvemQJbMxLfBFbtR/wpooZSl2NLWBvSF6Xe9dMY4a3o3+9Il?=
 =?us-ascii?Q?Ji/u1JO6c+g2gsYEgnmDUS5VYZUCoNA3AgcvCY3At6UZvDFWphcPx7UZE9G6?=
 =?us-ascii?Q?KbxFVEYDWC+iOIH8ntFannDknROH4cvnySG6a95zYHUez3yPJPV51HWCTnww?=
 =?us-ascii?Q?/lMmlBA1xd35dsOdW5XGXPeVahrE8tEHzKbBLAVqX92H0R79t/YyTV609a3w?=
 =?us-ascii?Q?HzeTmfdkg/kGP+m5EYtJTWvYdidZ6jqPw7t6GSBNC9rPDkHlioFmpaCylF/2?=
 =?us-ascii?Q?ifnXTukui2Rs/urN/0xxGyIDJAQ14jEUmgkTPukbfhUkZy5NTkyYtQTC+UDr?=
 =?us-ascii?Q?mlJMguqw4Js2cIsg5m3vWi1Teviw7y1ySLm64HbMxyJ+C3xeZ3CuJndB7X1G?=
 =?us-ascii?Q?39tmRCu7LkItXWz4FlbHgrOS+tTf/Pn7JMzWZZ2QwQsjwUQqYMzCqn+TVJr2?=
 =?us-ascii?Q?9fakXNP7acY9J4Vq7Om8Ae3tsgQNyBlb6H58AsNgtNZyQjuUPgyff5sUwjNv?=
 =?us-ascii?Q?zG3Vo2gbWIIHMQMFDlNgrEFtsQWHjMXvF3Xd1B/VhYe/vbHhBp0fchhFLo8c?=
 =?us-ascii?Q?j9nBOmTIyOav8qGxsknokU/kd4s45VVuWL/HP3rzSMF8jVjtsHhWhsCqwyMf?=
 =?us-ascii?Q?ElXpzG0CzEtjhnILz1+J21sTZby76QEAgMZCV6468jGbD4XOrPQ2YaYjlAVP?=
 =?us-ascii?Q?9MuPvInwmGQLj96KjxP5znXODVxu1xuuNWRWVQ/7grLzDCVCsa8LyKcUQO/J?=
 =?us-ascii?Q?oEvcFYXfM+yxEPtGiKFK8N2gFLqC2xHTRR3PgteCDYLGFylchyY+pkufsQZe?=
 =?us-ascii?Q?oNd0pOBckq8GpBrlyxb4YpqsnVmn9vHsD1NdC+ckNrWRJNYf8hYGxNMX9RCA?=
 =?us-ascii?Q?SY0vaWNyv7u65qk/GwOJ0RN08np/AzajBAt+n10phtqvhw2BqBkEQmHmwW4n?=
 =?us-ascii?Q?b7W72eSlP4FykQZn8dkOWz5veFhzvT6M1cd73AEa6jREZqnWVdvnOzCmGJuz?=
 =?us-ascii?Q?cVq0LFE+dL76C/DJsLLR8OJDIP8C6iNW6Ebp6qRedIR8JfxSQVUWERrGatNX?=
 =?us-ascii?Q?zURxP9WfmaCZ0pdl7n+nrYTVhMwaXGbI8++oVpTc/1p8WlxB4BYB9+7tRSTA?=
 =?us-ascii?Q?DgdPHQQPf0rjcdNcPFDrgoncfuhE4WgqFsIhGNXWJf7r94AqwyixsxpYdf4M?=
 =?us-ascii?Q?Z+OmNq0mCVmTZ7qFDLhKtQYkvRx/g/kmQUfVyGjJg+thZWadsfbz4EjS8XSe?=
 =?us-ascii?Q?8Nf/7d+YClXJu7FAVIFYHFSg54SAag6fRRYWQstzPlgSdHPhfvwTWy60A0n4?=
 =?us-ascii?Q?VJ/pfivf70ITNSVxEMp/lknCqJ2VfsLKd3qHttPlNLtpCBHHYYKSpaBjaTD1?=
 =?us-ascii?Q?8JNzR1kdYhl4ZvUzXwTWbX7V/L+1LC0xAPO3syTrNnVU4chPXTrUoPv6pXV5?=
 =?us-ascii?Q?xIUaArk2kftggV35rf9222zNVaCtGibKdKeLUymwm2YtGrhSs13uELqL8+xL?=
 =?us-ascii?Q?1An7/il1ibp6bhFuT454b9dabhnOxoV1nHbkjK7HwrM2iMOYYJb3aNaGz0R1?=
 =?us-ascii?Q?+Sc3WCaDNCnpmlIXyvSMs6t8QC+YnoZUOLmyabYQh2UrmGHCpMcLLwjL9I2A?=
X-MS-Exchange-AntiSpam-MessageData-1: E/DI78cSmZScVRo9ituG+1iV5d7POwPWuHM=
X-Exchange-RoutingPolicyChecked:
	fEvUD5mdzjBFzSKibgi1dhJX/vkvHb3ULFEaMtQQ1H+5VDBkJNho4yEtdVWSN94zpgy3fhp1w8pidxm4yy7m/0buAuJbgHAYp2tV5sVoTe8lkYQcNDaCoHYiCoA7FYiEblIsbrKA+xNcStAP5vbvGA7V4uCRWCP9ga6PUIIbadfbvxlTlR/92ur0FDUE/KGOSu2NMdIlA2+VbBLefIWuOafaQtjlXBAVYkQbpyS4Vp1/2JiGp2KqGypEUI6D17lZFUPkbzZLWDwmbyD2e3cHrN6VRXBZ+WyyzO3zUzSva6WS685fKUN6QMh6vCG96liEnvLraRWYwr3fsnlRQ1XDlQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ATwSAn+a+iFhRH9Mpsd7xLLR+1iJGtK0zKUwavef3dzf6phlexqW/3VbO45of7GRcCBFlekms5lY6Ap2Y3PNuurIZi79s06NP23ky7w16CYrs2m1Qk8b31Sxf3NtxzQixleJa1ldLwR6juiKAMEBVsC/VtMFdndR0qtquwIpsWtKN6nloX0r6mAuqiXNz+6RrAuV2p651v8IkIcY3ookx/mT4PgnNJ4aTGFVrxVWVjUvL5l5yTWgluczlc5JOXxQxAWbg1H5SE/Wb0kuj52pvgprzOHOx+eU715owMLX2+FSaTW6sHlSX1X5VGGZvQ8Hi0n770f56EIWekJvNKaGENKtNf66R3ILz9eSsY9CnmcsYx5is64GIdDsEyJyE3cGEn5BR0IMP/HrVw6X0itFYiSGKkMZnCsDOQ+DqbxSuaGomWSlxK8jDn9qqhJxjX+2lq+ZIfv+LY22wh8Y8W1zu7HvO7ZyTa4E2fe2r0gzR7YdTmIwviKjHREuKyqOgpLDsFj+oqXvHjSgn2H7SCyS8HDc1KNjY2VC6Hr4nP7hn0Dg5T3HoYqgRZrFIf+U4Hbu+4t0VSuq2RyvOX+cVR9cN716M5GVfeeoY0LH9j+42bw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b778cd3-7cd5-4655-ab8a-08df29022c0c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:41.6845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nEIyGjvIfL5DbNHbMfr8oux3htWuTA/zh2P4Z74vkuIspxwgDFmZoWnERDSzarNVJYPwmv1WzmotbA8QrfDIS6GvNyU7Hl9MMn7ONVkhTJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acde8b2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Yrdf2Ick_R6uxJIQGh4A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX7R18SYRVXPc9
 Sid+WaxeN8PVbK3qfAp6xHl9RQUCnOARJO7H8/gNK9P52Iv6+NEitNaj3Ydr1YV9FAMUvSWJlLR
 3YpPrsz9kHZpBWlNFVO7fii/xuZGyRZHG9bd1Bl5SUXvwcJIlwyV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX3zy5U+4yin+2
 PQIM2cUDknAMUnO1cOUd7MTiJevYfa0mK4ujvtvvxWIifByvGZwDaS9spUDvpJHWjuoOvrRUMeQ
 SF2E6TBxaQh8pSAP3u7Zmfp1VbUGW1GwrAu99pLY8iNd2CiZvZliQcBQgErr8TfjRJ2FhJx6adU
 Lrs67yvb2wYB7OBJ9ZYmlqjhRR1hrOUeF70u3RNjemSpBt9y4NykXI4AbD7/H5HvCAotiiTrnCH
 ovwCGPJs30old9nJF2dZGaOL4vyyBKTrOFvI9fdTgScUWaSO6+Y8yoBoa2GUug4aV7IP8KdOSPE
 DLH3Ann+sPbIiaY7lFYT1qRuLPlXvQteMAnhhkLuNNjpDdngQiYSsN8NBLgPQplaS6aUnTGnlEK
 Z7Y9yqVj79nL7NVQESjyBxuy5cgtLHgdodWo6K3oJv3kAOQaCFi8jhARL1+pbnnHu4j0mSOk2Ay
 B08DM53VMu9DTwb4U6aaGpNMFw/UMLWYAKiIAfcc=
X-Proofpoint-GUID: -1vXZNgAn013ahNiRalZ4UoY4XARy2Qx
X-Proofpoint-ORIG-GUID: -1vXZNgAn013ahNiRalZ4UoY4XARy2Qx

From: Dave Chinner <dchinner@redhat.com>

It's completely unnecessary because callbacks are added to iclogs
without holding the icloglock, hence no amount of ordering between
the icloglock and ic_callback_lock will order the removal of
callbacks from the iclog.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit 6be001021f0b307c8c1544e8b3ac87de20d711de)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")

5.10:

Fixed conflict due to the following missing commit:
	956f6daa84bf ("xfs: add iclog state trace events")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_log.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 22d7d74231d4..2b83b2b7786b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2721,10 +2721,7 @@ static void
 xlog_state_do_iclog_callbacks(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
-		__releases(&log->l_icloglock)
-		__acquires(&log->l_icloglock)
 {
-	spin_unlock(&log->l_icloglock);
 	spin_lock(&iclog->ic_callback_lock);
 	while (!list_empty(&iclog->ic_callbacks)) {
 		LIST_HEAD(tmp);
@@ -2736,12 +2733,6 @@ xlog_state_do_iclog_callbacks(
 		spin_lock(&iclog->ic_callback_lock);
 	}
 
-	/*
-	 * Pick up the icloglock while still holding the callback lock so we
-	 * serialise against anyone trying to add more callbacks to this iclog
-	 * now we've finished processing.
-	 */
-	spin_lock(&log->l_icloglock);
 	spin_unlock(&iclog->ic_callback_lock);
 }
 
@@ -2782,13 +2773,12 @@ xlog_state_do_callback(
 				iclog = iclog->ic_next;
 				continue;
 			}
+			spin_unlock(&log->l_icloglock);
 
-			/*
-			 * Running callbacks will drop the icloglock which means
-			 * we'll have to run at least one more complete loop.
-			 */
-			cycled_icloglock = true;
 			xlog_state_do_iclog_callbacks(log, iclog);
+			cycled_icloglock = true;
+
+			spin_lock(&log->l_icloglock);
 			if (XLOG_FORCED_SHUTDOWN(log))
 				wake_up_all(&iclog->ic_force_wait);
 			else
-- 
2.53.0

