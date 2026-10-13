Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5093D6CB8;
	Tue, 13 Oct 2026 08:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879255; cv=fail; b=nJHqPw6qvgx38dyM1mJPZGFMNolhBTxkdyC74JaxWzY0CfvLPrOKin6rKmMR7mtuNgtSKfv+x0Vf86R5gqnMdrBLJn/Qi+CJ8wYnjKRgVbFgTkrQiDXFW+bJhwVFA4w/91nZYQ1pY6aHbwgUOn4O3dfoy6vRuT5Cr1BWmWta/Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879255; c=relaxed/simple;
	bh=aNgLsvRCaD1d4TkwBeB31zBaaeHCo9cbNtReMoJBL6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qtx1E5oyUt1N60E6YY07AnYOLcR7gEL1i9XHkSNuoQfs3yc+m0bC90GuVsHfRgx17e3w1fwfM3fwXwIaxkB48LU6J1X/LuG1cO2L/n4jFiF+gFOyIkF8t3aeSGS1zCHUoyO2819+B1MoaAkCn7pt5XMExBl/xCLzI4Cm0T2/Wm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CJUkMThJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JFGoS0t7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CJUkMThJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JFGoS0t7"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bsrx1439853;
	Tue, 13 Oct 2026 08:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=; b=
	CJUkMThJ7oYk1Pp6X+xHGTcJFKmAVZxryt7I5s9+3xk+zr93pFFy9UoOKu3at5sI
	EoHtU6HpuHC4uS6iN1OUzxdwjJH9XKIAMArd8ObRLt57tvWs+rL/ILoCVlX84nxw
	bzwcfiAvrQ32FQAGnFq8pX5Pif1FxtEjCs+mu9kCs16bzq041Na2fvuSA47782QI
	y3eTErUM6KO/pjKdbL1w/9bIMFfiU3MYx3l/YeTNjm9S6XIP4rz+H9foKHkoUakn
	HU+exM56kyGzoPi4YDhPLjllVfONudqZBBtUyyHxvtiaN3Ey7YQZuzdzxkRPUPfU
	hit9cuCK1nF9FwJFQ+BDhQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uk6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86PF5024900;
	Tue, 13 Oct 2026 08:14:10 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013066.outbound.protection.outlook.com [40.107.201.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9aqrx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsS/J/4Flt7GtON8FmQaw6/LbuObKiWQf0mbP1UpJzbO0VTQcKIFc1Mn+ETcDu3pPUl03J8WDLe1EYOLhJpSjTeZp49fZdklAGNoe4b9JjCJBh/C78EV6EzBlEviR5ZFmoc+eH8yEPalp0eo+0+sIL+gzNZ7Gtw0gyj7e3Iqy6farj2Ok21DzaCSTxb2w4X9Ecc+MaUht1zA7uelZ442w0iE4MfG4LJPu32OdwNenYnrA90vuTLbWJtmbdsp3P9lE9w6tM3qcU6hcO0cyCewm31eCRWjS+kKhVmtegzxfOMiIa0gP2/N1AH9SyBCYxyaYHcyzF38Xfdel2wMMqoQTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=;
 b=i4brOu/xQf14tCUgUjzvDZnoh1L71ZrWXO57qAK5j4sGi8dhI0i/3eo+WAKl43BIz5fMza3kY46e1DdOAZVXv0wJOCJQyii5N8zLmG1rNx0e7LOxU2y40Xo4mEnJJNN631/5Ox0bg0dwAzCaDHaSgGw3hnBdS0OWlqDKo6F+jc0+IuGA2yu2t5atDnpcO9ppC02mTFXPoEpIyulVzQigabJHV1CiBLAfKZw98Zwi1VS8vdiIXdnTssLfVtuOMz3gHdRsxlTOdairUvzypuKdHw0O90Htkz1ZsPXnzfx3vTrmUTs7jHks4byxov9y51v42Hbrl1LmB5mM//W1udR9Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=;
 b=JFGoS0t76dTpUyd4pRUt04yIaHd6+1XgrRSp1XQ9tlBPgxVHq2bRl3EgN289BeEgT/gNw7+GSkF9ZaR9p6kyMtXBP3FMVvnk1z4nxZQKAjWrd5oIWr4DVSxz81/jKLcPaLoWyrMcKjsDN/lkgOpRTHYixjDmwdAlTh4Go+S9TpU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:14:07 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:07 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 v2 3/5] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 13:43:47 +0530
Message-ID: <10ff9f67a65be8534d41b262f5f642add299544c.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::7) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: bdae4968-de04-44dc-b46a-08df2901f3c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	AwYJ69m8z3VHDtu/bj0tyaSaCa6deP40AI++rFovBxlejQok31hsYD8K0yw6eihX7Li/KkHgaAlKWXlco7ZKTjVCnqS9ujnrxwFKqqUL/vAD8dws4gufyHOzLfZPYW20R+KGiOQm8FCGI6ueYahpFzQsBlCGJGR4Ol75w9VfWvsBcgruXL5FjGFREBeI0eUB0K8mIF8SDwx/k8oN0wac2M0/RrcoOL5mtJRrjGlUzZEXnCW93xlTla7AtsESD5HYY7Mfq2v7UHY2W6N8nOijGMAIsbHvcBLKwqKw+vhjA7itkLeFBQduWIllBSSkT3a0DcAroD1Gfo7cLQbleLkrOs0ZnTS2CRNk8nur0dpT56EcJx/RSDvg1zokNZS3uqieVT82tsMRZwOZlfh/isBoRv4GsVhUGgzKmKzv4PNSH/HTIYehlVK/VXXmoLa4FYvmPgg4SeB7cOjI+b6TosDMo+B11idUBOFLfOwiCq85rr2thRUr+JwEBBSmcJMj9cCkBe12OWOn0NQ2WUDZNaNFz96OmcHvOdbr/T/fuCjLvxe6yHRcUbrhzl03Z69TL9lBVKNojXxLS1THSpTrXnXTScFuk/Ld0OboGCGRYaxjrTxlP1PbtKvROx3Kkg7xw0PKfc0AIU26Q77mMH0Nt7J757X1bgEY55OU5xZzyRX1Mzw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PESzAkVoZEw1SAv5iQURPngVY1BG0Z1YY4wP8zJbIk5hwd+rl2b/zxk4Khan?=
 =?us-ascii?Q?HEwtUWS+1x7vQ2Rt8f2SNE9yP5dQTrSxBQLfYocTiJll3eT2yLs9jwv2g4np?=
 =?us-ascii?Q?8S0KpX1NWLPX3d0gq2MVegdAHXK0mSLtOKFv9HklTLLIOc3OXHUsrR/OFZCg?=
 =?us-ascii?Q?ule+DIKGtilMAdFjnn0CN2k2nL8xWzVoym63PF72MIfw/aAndkWrE+qRDQUd?=
 =?us-ascii?Q?J138qtJ6c2gKCjCwzzYWLDmWjNwQzqTglL6NS8YgH/vEr3ZfJ9qeMJGIAbQY?=
 =?us-ascii?Q?5f7FCxgYLj1ronBFsBwd9ktcGnoPLQ3nKCf2YnkEFIZxhqFBoib4K+u3Ycb3?=
 =?us-ascii?Q?NtJ7t+glGLF3c9D0nOP7Yk/77wRZpErhxUWSh2DF+LArjjHp9KrCZZkkEFjE?=
 =?us-ascii?Q?LTNG67lrQbR3zNhRV6B/88S/imM+B3N9apnoYeFBIuD50tik64ajbLmr0XTc?=
 =?us-ascii?Q?rq7jvVNA1pKt7zZLQjF/5RCyeqIaiZIF36CjCrEKCB0NcCUmAKYXvQ9FBxbb?=
 =?us-ascii?Q?A+GFPy+3sFM6xrM2sEZMHFH40YNb62kdKlT0DBSqneW9q0VKKyasexnSb9LC?=
 =?us-ascii?Q?y2BZCr75h87EFvseoTtM4/ejfZE22L21VfnAuXnV/OkpuY8VjqSvrM/y+Opn?=
 =?us-ascii?Q?aUSh3Fk2UYE9UVr7eoPo7q8F77vfpIPW9Ivm2Z4lslvmGLmdERNvkEekufE2?=
 =?us-ascii?Q?4iuSHRSn8OHc7fVMix1l+gA2sKUgXoz5e9syq0laaLCawhGIUq7eaPcPJ2in?=
 =?us-ascii?Q?JWB54KEdJUkvgE3qB/6sq/y2QtnMBNkvWqVaarOsM4sXukgdhMo/lUNCnzL+?=
 =?us-ascii?Q?Ur29JPJAEWMPnn5r1Z4IG4byvcpRGWtHNuYTnxmFoDga0K+yA9zA1WBipcZk?=
 =?us-ascii?Q?ZtwthIG6Z0CjZuvVfEoAJzXI9Drx5BVOCok8RLhZr/0l21jp6yfwVnz+1hY3?=
 =?us-ascii?Q?VNu508/Q8pwu6OHQ9SQNYMmOTNwkE4AAqskwbtXuDcJ2Dk5GKjYWHz0h+rRE?=
 =?us-ascii?Q?ie6RS8CQr3Xg4nspmPLknUcEepW8AdTf7ofSiY9CrQf9VdS2piLy+1fSUgrg?=
 =?us-ascii?Q?zAIydPAsLWSNgAzuNBf/YXwybaYpcSOV1WvIiAraxXiTRF0QGCKp5PkBQjlo?=
 =?us-ascii?Q?VnZ8wpjfBgIwlUMzAOA+6nKtozlPpEE3zd3CpJEc5yk5iR2ZwNHvjnkc5W2r?=
 =?us-ascii?Q?99uzYpaV/cG+21FREYtvvnEscv397jdOHYLGz/XSZHOmPI4H4/ftDA6iI0bL?=
 =?us-ascii?Q?IW/Ke4js12xsO+9zjQzQlnykkKgpain5P3UEc7cT0/FQHgz8h1IMeWED/IK6?=
 =?us-ascii?Q?N/TLIyzoVRnyntiSLP2a06SCSBs+ApfWkds0jQoedBFJeKL5QZGOpw/sLGy/?=
 =?us-ascii?Q?yYw+TTiHtgzuNI+D5Qtj0OLewbnFB+nInalpcPEpJEERveMKezhIGA7RgtIX?=
 =?us-ascii?Q?eAXbk+u6ZTGYdYNiPWv1JJ5/v7aJzjGzeX8HSb/bNept1CpBYExahOJmIuQd?=
 =?us-ascii?Q?EIJ/BJWAp41crFGmki3qYKRlDZ7TSO3svHrgKmXAWEKtDq6yC7pp+jpDZxwh?=
 =?us-ascii?Q?mkCjzx9Tju/JP5v8eBVBLaFJipFmTz2TJjALi7iIO73n8GQW6sxxy/3Eu34M?=
 =?us-ascii?Q?dlFGI0DO4UzKlTTvexBrZMGk1JFzppzQSO5u2oo0tILYy2WkIxJik7w1A2l4?=
 =?us-ascii?Q?DgIBi4X14Zg9LbJeeoSQME2kKCdbEqsGl8R6nHen53GHBtBYHi4SX3606EQa?=
 =?us-ascii?Q?auTshzXS0MRVVo0Fmd/BD1B+OdaPFt7FFt2BStHkj1mzNHlVPoYYnNCgdjO9?=
X-MS-Exchange-AntiSpam-MessageData-1: rTxBDkrubGs/cic4lbzkCXyEmz2N/efniNE=
X-Exchange-RoutingPolicyChecked:
	hfdNwOEqnJulurvgNftityE3xSdyi2pN1Af2CU0vv5ZUDEhqZyd6ZrLE+gyOnI7epcaX4xGYf7V00pkfxkDGPnRCfYEhFKEHaxC3bVkXVZls2uOCFJOZAlOCwML7MCONJc7Fw7Hie/+QtcKP4rTiE2xUO7LsFc/9sSx0XVaejuC00EDpgYbpNFWiOM7uZPtXfwrvL8PoRmC/vMCfeJpISB2xEZNRQYAt6gwvOYFrgrW0am8KHGqLKDcSEkntjkVmlxy9Ims4BQPykyc7anKrQGWEwOvRL1MxJnIpF7lbehOuK47Zhlovam7xBaRKXkHTbnMR1VqR678ODRre6BKHIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0H7N5X/4cK9dBxvGY5e6msKYx7NrM+qhNvVc5e9ZhfNA1arqygV+VDLX96VwBUg+GceSK3ucpM9VA+piWjZLg6SURFfotK5hC/VD8mOp1OtMvrBEi8z27rNKBISFc94uiTTv2bpwlEIUXaxV/j/8NTCMm9jNLTCBrdgFYbAbGUM7ohJ9PEaKIxK6Ij/jec8dIU2vH+Bckqw76g1YFvgHYwVbrNl3nK0soFZl1PLfcC0g8Ic7txWHpAnDoP3S1Q29BNoukepn3qF14ZT/r99ei75ZfvEZR93k3GstEGlPK73OksU3Q7TofFBV1mttSjuWyO3LYmAAWRR1R9aELQ3VkAC4Wyc5vFtfUmUF5r5H1bkgfI9ThDRiRmAjfZ8m9f/BNgBJdUuV0/QIOdAtJfrhEyCZTJsv80OTWriEWmIwBIhi+ZexANggr1P9wy2S+FjS56iV08ig7gKYMyzab848huXt8g83NhjW50EUC5Mi9HhDXJ5fa853araWbfK3SVHlmrC++BZ+euoGtkZSr7uoJ9nlWbjL0W1m0cc3+Iz8TuYqlWZA6r1KUcdIqna5dbtfGbdqNC0VDuFnEiy71UpAdq4uvr4bi2YWf3tofz22L1w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdae4968-de04-44dc-b46a-08df2901f3c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:07.4935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ddqlzE+iyUwe9d03W07zBvP7YlkhE+uIoPocCCEfkYSyWJ5N+TWUvHmeeZh5s0CjlOaM/ldyeq+5z4l4ytSBdiv6mFFut8hKVf+SD4C+tfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acde853 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX3uk0/esMnD9D
 2erO36rYN9/ofovElYR2TPnOSdbBEScAQIwZPVf3bt0wRwGDGY638h8pdiuNk01MpM4tCpqwwsY
 qiNvaVoMt0Vek2IK4XK7aERb8yWM6T2gNox0inKuKHX9LRHuEunZpCDnioVgE5DHe5wYwhjAVSj
 k7MFidWtXvEXI72Gh8+E3bjASwQg+Q0rX/h6QY+f/bfQri4ErtwZh9LO6Z8a4qTpghFtzrI1CCp
 +wjiYMWYLcob8hVVXtSOmNwkHClrQpop0EMm4EONT2yxo5QdiEZ9+rV1SWKvD/L8w2bzt2rlWP+
 NshPIrdg6LCuDcTHuXHc1uE2gS4wa0xT8L/MJ01DOO2ySMJ87h8eZqENZK96OFdygbIB8H2sKdn
 iqP/oidluFCkQSl+2aoHqhckPktoF+/EumLE+zBLIx6lNkITg6PppVGwdruv7thPB+v8kb3W2e1
 S6UBoRclNGkZTNDFHxw==
X-Proofpoint-ORIG-GUID: Wv8MXf-i5nfVw-63RGnGlLDa0GDbHrp2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX6B4fEW8EGRSC
 h3BGetCZWKBbCOZiRRuhfGv3rxQn6z/sspN807GjSSr5cYXZtmWNkDSSiVaMbrf17X/KhglGIBB
 ANLAYp2Bl8pTvGkZzn6nTQ2eaN50SG4JTeMxWRR8Spi+l52TLkbN
X-Proofpoint-GUID: Wv8MXf-i5nfVw-63RGnGlLDa0GDbHrp2

From: Dave Chinner <dchinner@redhat.com>

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d2fe5c4c8d25999862d615f616aea7befdd62799)

6.6:

Fixed conflict due to the following missing commits:
	[Continuous range: 10634530f7ba^..d4c75a1b40cd]
	d4c75a1b40cd ("xfs: convert remaining kmem_free() to kfree()")
	49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
	afdc115559c5 ("xfs: move kmem_to_page()")
	f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
	10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")

Removed ASSERT in favour of existing atomic_read-and-return in
xfs_buf_item_relse() due to the following missing commit:
	3762113b597f ("xfs: don't lose solo superblock counter update transactions")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 118 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 72d6e2dd5ef5..1b323b3c0eb9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -32,6 +32,63 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
+				0);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kmem_free(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kmem_free(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_cache, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+
+	if (atomic_read(&bip->bli_refcount))
+		return;
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -563,7 +620,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -673,7 +730,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -824,33 +881,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
-				0);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kmem_free(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -1072,34 +1102,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kmem_free(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_cache, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1119,5 +1121,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 7ddda0aa9dac..8a8a46e698be 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.53.0

