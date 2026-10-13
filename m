Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BE947CA69;
	Tue, 13 Oct 2026 09:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884316; cv=fail; b=DJjdPH5R/Y4ETy+pRox+9jQWuaf1ssM+CHndyhb3ZfP2QCa3DpNwQM5IEoOvAbMOaCDzAvoeZNrWzrcEYk61IxmdqMmTGiqASgEYHOG8Ky/4ihOPNQbbpwEL3eO2x1rtV2KX6z1Epcdw/vzognbgbRxTuAlj6v8VJsk5FOHZygI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884316; c=relaxed/simple;
	bh=wIC5ah5b9G3A38/PIe7V+7NvkOdhNmjbXQE4d+4hioM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EafJvw3JUkX7ev4NgySU2b1kJuyJgcXs1u/P1sE/heqiMnb0xnLrHi118xledhOBAyuCzFuFFimlHR1J+OumEBONYlOa2VJdd7R/woal3mS/PfwiB+6WbFdh2L1p4lMpTbVaXHGbsTJ2lGOJJEMZI69HwRzsck6ZCWtMCCOUupw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QuXvl8h8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IDIOqMb1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QuXvl8h8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IDIOqMb1"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CjVl3435771;
	Tue, 13 Oct 2026 09:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=; b=
	QuXvl8h83pSL+FVBGWVG+KNOYsTCERQRHGhvjgYzqI/LRCpE/Mau+dBIDAnNqGK4
	9Hvn/GqUSAuJoH/7xYEd8jKMDceqHrmX/vPTacNltQLVc3ljE0qvp4P7VOgECdnH
	EdI4hcVAiog980ibumVmXVkC4cnB6uCVuEFsc6wKi6P1Z4gVSBOl2afcgN3wzZpd
	u5PUFzle6lyUEcvdoQmbI1jCxZuqtnH/+gDaGQqt0LBjZhz7+D3obT5LT39eEYCJ
	u3LYoLmlXIruAWqXujMvLoHPjqKhnx4jlcAPdKTl1bz0xAvLFNOYSIacWRjwwQDm
	Ljzg5RWQZx/r3Q8Tcq/rcQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTit005395;
	Tue, 13 Oct 2026 09:38:30 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010069.outbound.protection.outlook.com [52.101.85.69])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2bn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lz23bLPgxQhf3qbJXEH7f/LpSbKuTZ6Fnu7GuLr735cjuXAPJGDT7ICxXoND87SCpkrkYxMEdXfO1wwR2Gr8/kMJ1imy2uLwa/B2mmk7uipTXCj59Qqb62Xe/RLmKaW8KOXqL9u4UAHAdsE1kxQw51upoJYQhAdfj+ZdwkCEspZcS1rHF4dBwW+9aWHQ6Y+CMli7va6Mv/W4zEW5tWmY1MjtpNkI/Cm3wn+cOJC67Rfs1+UbFZV8qdUwohAbdoZU1NCpPuVBQ7KjmW0cqLcSaqrax3Mr0lJjYP5Tu83gJGVyXoKga5HS+38Adf/nV8kG42TkXqvLG/B44KVDR1Z99w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=;
 b=wWh8+RZOsJx8uHscuNqF4lQ2NzESf6JZGoJtWYkXzqWp62TE9Tk5NmnT0Qb/r+TKJVPIdgze0dC5/oK9C6CvF8EYg1q1lAMAxEX6U+kDCbKPL+HwwlGN0cUL2IWa41hLpvXvpgT4kZQURyN6fUHvm1r+McCNn5MQBPO+GHFI1Urrx53aBGLPDCETv6wdrWiB3yZN13kmKLrS+aduuI1b8g21pYu7lBlZRJWCWOAM8z54p+GLA0NcpNJ6tJ0grZW5fB6p52f+qnaRqFNJHfoR/4yC/txt1z2kabJ3M65xHKcESLBIQD2Rk6r2s+V9oV05nr4ln8XF/hRtX4WjD39Qxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=;
 b=IDIOqMb1Cb381jmDNoBws5Zo4JrO2jQZWBFm3vb3x4LW6FPE55R1vQ9EwTuh1f5rSuZ7pvt9+HWDF2/4AUrYsTxwvYcrmVRmDnY+DHKtT4e03XofoCrr/FCQkcg6tg+4Sq7jjhF9aPMSfHwgO+n5nBXYfEMhCoj/xfkFsEYH7BQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:38:27 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:26 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.6 v2 4/5] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 15:08:03 +0530
Message-ID: <7beaca9ae211764bbd6ff41bdc7705ab409bf384.1791883285.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883285.git.siddh.raman.pant@oracle.com>
References: <cover.1791883285.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0125.apcprd02.prod.outlook.com
 (2603:1096:4:188::13) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 7adfb0b5-6a5f-4755-a9ff-08df290dbb81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	DOotLTYT/OPBY5PZKLfihcgKSEv6FqxozXSiIdh23iMw2vTXANHlH87NF7PhxOrfIY0STy564z511NOEduag7zhtppnwCWO6AmxPw6lairo+dNBSuNEWbtMVEwQI+TowS3a38Bx2qJSGWq11hgMuSAR/8Q8FPvz19567V99E7hfpIaHfCmjHB4riLyYF/8tLQ6P4EmK2ubWusBT9nyuz8qk7kHF+tE2ghfJ3Y8kwhorG7J3sQahIJJGhCSs9nHkbK4NQWDqLvsoWauXGl3w+bDHeybeCylKQuNf/vk52S5GNt0NM8sl9DXt50rXoT1kJaszjdvClgqT2aZcL0xPEC6xSc7eX8+1Zq5r/Z36ep+oUbEnG1Jp25AfXgBb1VRJbHBSE6tY2Iq9nftU2Uk0PzgFkLoirKm9iLlH8Vt2rP8sWw7tyuN+LYOv/DyX8Wp0/PxafQ1eetwV5xk9qqQVPP/7GETJgKTVo+dNdvql7r5Vhe8c2SpEuY7rNEiYTUmNMchsmXy93tQhgnms9eWiXhcGA/nZJkrlC50budIKOEW1aKxYMRg9LGscbML9FYUHK0OV9WUnDww1Fri/pZyaX40/bmfQUs19UDt93TMn+fLG0KfpL2hC5peIMYz0NmjS5KMYHsxNemY0l+flM6yEgt0n9NGr5+dd9V09+XtKNQhc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xzadMXpK5Hip7h1hpJeEYa0LpXqudGdkJ4stwCCU1S9Bme3OZBPPA4rU6Kgo?=
 =?us-ascii?Q?RNzBT3KUdkDBxYFDmUXkvu9ZO7ZdU2f4aG/LrUA1dPvyOwXX9oSzifZt/h0v?=
 =?us-ascii?Q?X0M4CseAgXMYqmAtJYAQ6g72rt2WQhh7kzTeZwjSIqX7knzTvk3QVgy9tKVY?=
 =?us-ascii?Q?8KE/1lNGCInPig0oq4iLCSomfaaOQT73dqB3j+ld2PoxVLTeToACU8NwxXlz?=
 =?us-ascii?Q?NOe9quHYxzMaizprGAOR4oQOfe8jfBd7oVfXjl21OKkA5TZBwQnTfiAhtELc?=
 =?us-ascii?Q?jhHQoBeTwM2XXr9e4b39Wcwa/8OLNzYRIWEl+ehzaIpvAn0QCv1du9O197Z/?=
 =?us-ascii?Q?0JQIYm+RxjBulYUirAIE5FjyS5YxohTKdVCfhHEVPOMHhbcSwQ1eeUWXQUnW?=
 =?us-ascii?Q?aRG3YyYo+w3BKMwxhRH7ArhkLSQ7EDOBCpk9ffbcfGhDE8WT3Hhq6fVropXx?=
 =?us-ascii?Q?V1KeK0P4+Sq1K+gOpc3pcbtmjf2DqMDq3tF6Mww2BntZys87fiqgQSidAHwG?=
 =?us-ascii?Q?6tzdLvCjy+Mb8spG2rSKxC5p5nznTRnd7ObWUokTRHDjmNGaiWTeLkeWm81v?=
 =?us-ascii?Q?oV0+t5/O96GwIsiOlA99aCv34XrTC1BX81mBumwLYj667s/2JFddGF3Xtwhp?=
 =?us-ascii?Q?2h4wcWXGjJvbVTV7FZzkaIXNBq1+5nJGoD0z/1zzwtSPU+/8HyH1cuxPbNeG?=
 =?us-ascii?Q?N38Lb9aVeIs7iMntoYWHspHhGBsBUUy0byHtXVbxetwYeBpslXLt2RUr/CfB?=
 =?us-ascii?Q?zAYXyUq7SU2oAAE/aERaKH+1NAa7CAbYO06PEJn9zgAh7qbTcVp3HiLGpC/3?=
 =?us-ascii?Q?sZzK5ulkfA5/FqqY0YaqFggiawuig3CKu2BqzyfEsQJuEqzbmoQ7mla8NpAV?=
 =?us-ascii?Q?UeJFX+JfsvyG7Jjf1ncdCZdKI4wQKIMlWZE19RbTHQPKXuxv3Zo1uq0Vi+bi?=
 =?us-ascii?Q?7ZZGUucLIwb2y+Z6fE3dC4eYfdmHRz0+wJBN7EKAwitxjQf5ABTtPc3RJkpw?=
 =?us-ascii?Q?IcfpyDdSzppSVHjwLn7z9vCyj97mQCF7jDM4oRvv5oTYXD8pxYyaV6taXrl5?=
 =?us-ascii?Q?G4Mevkwuwbzy+lf/O41GmmfR5VfMxM/iBx9E/D/pbemB2o8HIJjOtOhU0o5X?=
 =?us-ascii?Q?1Wn4EQpEV69DVlmApcXf2M/H0b3OE4cbu5wp7sayuAeLX4Zs9ZkFQ94uxejG?=
 =?us-ascii?Q?idlivkr0bvEnaHSiCdGf3J8op1cVbWDIM+VW3FMvTIOyYZBMXJSTc4uZ5eZ8?=
 =?us-ascii?Q?TnrM7os0w/PLLelp0QN1vLNlQdlCIOkpw5NZM5N1XnaExuxVU6DFsdCbs1xg?=
 =?us-ascii?Q?SNAIow56tlcZIrD1IH1iNJVIhvEpJo9Wfx+XdTR/avFZueGoE/4MAXA5LBOP?=
 =?us-ascii?Q?OtBM15FHByqUvSPh84jiRrKHXdD2zaZXb8tFTawjVlLg11esw+g5qufdFCSh?=
 =?us-ascii?Q?EjrShXMVg6bo4V5SaSv6Ge2rRAd5jHBZiEyhCE1GRlV2NfNS9jWXFEFSTROr?=
 =?us-ascii?Q?hE24TPdCblW1ZXJ8mLzHqVgVvCh2aVNTjhgcQp1FSoaXrCaeNk5J9H/OxgZ9?=
 =?us-ascii?Q?C2oXEx5hp0iV/T4u4pGEEZSmTsXkK/GT1uNXXPCSpYBrINZkbrWjXuqBJqtx?=
 =?us-ascii?Q?Gc4sVyQsDEI870xYOwZosesPJ39iX5ghAKJI54k4GFGe4lV+STY0VxbG/kVO?=
 =?us-ascii?Q?VL19N42ulvXOXMpBg0hlUXElitqemfZntqxSUoZtfGCQxPcvsPdrbipfkYWK?=
 =?us-ascii?Q?ukNWFsZDlg8FBrzd80mFtnPLCLIUbHnAhm2s0pr5RMo7NT2j68NNiQ//I6mX?=
X-MS-Exchange-AntiSpam-MessageData-1: XMKZkGJoyY3qd4fXtkvKfbY9ikwiEtDQM2Q=
X-Exchange-RoutingPolicyChecked:
	oPVc+1XUgcd8s3tznRnHYQTVybCbcpdich91DXC8dQHhnQhs9mZCuLmX47uNczu8HCbkv4pzLydNyizlIXY6auAApCfgr4Zn2vZ+cepotzzC3fc/PMCxw9fd5HMmTVhvZOFJtf6vbO029Z6y6hCe6aqJJ9bciOtRMloE9noyai/18+FjB2LxBkWNY30ezDMkawfqUIYvHJxugYNBGr6+KnsLaGAF9maO4PVsw3iVV3XetL9faHbAHjI/cDiZs+0ELBP+yNht/9MyVeMmv0nW5s1sfEzlVWGQT9tAJKjgx288Nkn/2NoE2NxNFp8ruoljmYks81tY7QbuyWTQBcgGYA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0uJzoFvpcK0uD4DBicxKirg8QY1bSitS0auo1zUdf3I1guy5lea2O97QmOMvpLTSBZlivF0LSq7EbJEgQ9rtoO8sH8oakC55XSvKigFabaTORSzxor8MqO939GHlNNBb9LV4qRQbq9CtO7caPuoE/6o10p2b4xZHJ/SqcoAyiYd2YyGBqgPcAT3658rXnHavhn50lQnpuN9iyUFLp9mAJuFytkVmadftS/3D6FexWXmEjJLZLXd8hYkSFX2IMCWlXGt6pl01aX8wIVNXF3iPT3zm3Fm0LF8+89FUsoa7NzPVq39GuPMKCjb5/vkvBJ6c9ugKWjbazKbJ6IBDBzlXuiwJkIKjmy5SGDoaU+s0ELXkxBLWj4cOlluGobNNWE9GLLagXd3NdgPjGT6NAOLIogzW506L0H4DXzxWzWc0bRNEYrL3p3jbvExaU/hwkDQsS6ysi7hAuJdMn32T0dGszFRCuRky/af7j209VPCYDpZbcQNArHTlFstLAUIJpvFVK3iVCkVOoRkWOMY0uN/jI1MWqKmOj1yXeeLg6/SAcTZ8bxv8wpHwA1JHuqcfFmj1k0+uGopXadVkK8Dap8CMAbzKtXgZ3vGe8p94gOP2IsM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7adfb0b5-6a5f-4755-a9ff-08df290dbb81
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:26.8889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrHkPwy3DU1kfDTXpa5PvS4EJg3finD4uorTEWiipuji15b9wK3eDKZea4DyoRe7eEGYiVT09Q5VN9uYzmwi0XGESd3pQy0nSEVAt1dGcnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfc17 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXyGDpMbhSiTEJ
 +wezhXw8jH3VCqCYWd6EbbNdC6WlddiAOd0tePf9SsnebV4KNCd2aW/uUwR81vPa4dHpIOn2xhT
 EPzBOwkVSPgrTZ3BR62iaOfczbhIvDW2qFRspQOur4p5RGhMD6i7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX8R69V7E/wSYg
 Z9ovHbrqE0Gyd4z9hG58KsgtHQZ6uLqPBK5yq5Ljbrf/F5XgJJ/Yif6j1WoJsQ4xavZ7kNrXAkl
 VcgC2DJEuIDGnRbikAJEtcva0rpVzDaBFSLCh9V5WWCOCUol7px21eHe123i8MIezWAXMZ+XHQ4
 JYQGQd+Tem70+5Cw5ZqkGMg5/ZnFs+VtN0IvaWb5QL98bm29tvRjluIi9IbCN/B1WCpMm0kXfu1
 BxKCZ7mujDH/34q91soaQ73PQWiTvYnoqJU6ccJSRGQabQ+DeZKIdo6r7Lm/NqO3sfh1v6zpobt
 u92Q/DkWhOMx0C+mxCSSPMh4YMNjp0bZ5LWbX6zMALTTkb0egNkCADz7VzAsIYTeKuPL4TFZkL4
 rbvo1jKFAztSIkT2wBnRfr40rLXzqVkJCNlPcOZmLaJaeKpusvoICffPEBKn2OQWRMhejpwKQf6
 /z2kpuV3EuK6PiLIP8Q==
X-Proofpoint-GUID: fVrCp4H3_T1osY2LHHHd5BfksoDavU8V
X-Proofpoint-ORIG-GUID: fVrCp4H3_T1osY2LHHHd5BfksoDavU8V

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1b323b3c0eb9..ade89a233e68 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -541,6 +541,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -590,13 +626,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -607,22 +636,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

