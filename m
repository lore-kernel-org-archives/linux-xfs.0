Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15474BE430;
	Tue, 13 Oct 2026 09:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884376; cv=fail; b=Mt+E7U0QzlB3V1RHiz5KQqQkeiYhuMTXwLVIW5cqJeCKZOW6uI9VkGXIiLfvuEO08x1M79nmOtiCEcwIeky0mOkYQ4FWQco8THfq4/g8KRMSG3Sdyp9BXzTBTUfv8tjHAbAhRccsA/BhldfpyJgDpAKSKfVIjzoi0opp06YCidg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884376; c=relaxed/simple;
	bh=JDbshOHBIaZZ5IRbwUIj/mZpS/ruK4e9iGpqEq6XcXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=em/OSAbtSLlj2yLuRVjKGnncmMQ0CqxVcnbBEkatym4+WXUT6uF9O3MFk3MCJbBPZgtscCfpgdYTLFSW/Wysijl2pWejJdxcIn4BasnLiU7cHgi0+C7kAtgE0O8XVkY4a85X9Et+ixHATRx3PxVxfUnPdHsTh67Hf2cyo3uVTH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nc3mbqx/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PYtw9l3A; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nc3mbqx/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PYtw9l3A"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Brv73200294;
	Tue, 13 Oct 2026 09:39:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=e+PAXEMb75fquC5JQ9i1JaBNrl58F1UE4VJXBqdHTGo=; b=
	Nc3mbqx/o/lM+cl1Z5o8tI+W5o3MAf2bDO0WPVEC967tXQ3Da+quqHRef55eeFSJ
	BImomi+yC+u+tZtsozeg+DIx9dZP49Jy+gqt9eCBOSa5hY2+kq9st0kQr44DZ4D/
	aJCx26gnWEaukUzqIXZl3ThFal4wPFymtD++Olt33Jk19OeSN8E59QnXQE9zZ+Fy
	eRF3D/moYPghXqW9WH98hwWyCI5KqFz6IZWVA9bvcCws3UNXScAdeX1wwlhVp5v5
	N3XM2H82XsjfkYibcd2M2hPRV8SOVXBY5D2syAjIdBf7OlNnUqX71XfOv0kw2c+R
	6FjsMuCuoH1Zjk/+ZbNOBg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demkq7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTBP010912;
	Tue, 13 Oct 2026 09:39:30 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010009.outbound.protection.outlook.com [52.101.56.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d4un-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1Cdiq2uNiq7tiPYsHe/r4nUWr8i2/HtOP7S94WOnQy42lVf/zs2pnfqRDiDQEjcHiyV5bmA9bMD/lztHK6SJRHTF9ey+dp9D2M3RQNwmzA70E7P7KsSUkA9BXxe8xS+gfKKNJ39kBZr2311sMTxhTIw3dHElQbH1yikK09ChG044CXIuY4KCipj7M+UQV3OidMXZZb8MDvHt2KAkdPmx/JcQFT25NBTzdGx4f5tienZCbtNoQuIvF15tt2iLAGbqyc9KK3i5j29s+OckXtWYL/Mtlsd0HYZ6iyrshQ88YLxAQfmjJdEONKSg74hc9VQpuuYNGzVOF5bXKQdULmCSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+PAXEMb75fquC5JQ9i1JaBNrl58F1UE4VJXBqdHTGo=;
 b=fXe42+BY9E7yhZUKFqjaLh1bEShujzsMUu9uTavHKKjgJxTakuF3DRWAgah7mCw5VUJV5yREWLNUv6gco0vo84DH9IRYIjLoWgkDkjnm+hPXcLItFMamHcunh7c7PSuQ1mm/lsH2eG6XUDmxTdTRY49yKD7W15+ZBuwqVhU0v1huWm4VTEtBCTwsC4X9fQaUKyAbyqQEUgN2iGYgtWBtNl135eYZmco6ZuC3A92ygTJn9hJiwDoE8DhWyylwV5t8Z3nXeV3qWo2wkBj7oWbFfER3zSZ0uE2792xqlKPFZkVT4ovstm9LTfmPZFE3I8ho9Xxc17QOSW30r3cGWceEYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+PAXEMb75fquC5JQ9i1JaBNrl58F1UE4VJXBqdHTGo=;
 b=PYtw9l3ATJD8Qu06F4imyUMph1+NW7fnWthEHisEdd1EUlBIX9aeQkmify0zY4yFnK0w1mcer5g+Z3qoBwrQoksxBoyPptZUlH2a6CqhjaZCqec35+AvjSLPMCV5GksB+4rH2tzOiGx5gPnX50gCSwsuIkHAa+wwlcQp6ajxPYE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 MN2PR10MB4207.namprd10.prod.outlook.com (2603:10b6:208:198::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:39:27 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:27 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.15 v2 5/9] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 15:08:56 +0530
Message-ID: <3da5cfc96a3d8aa5bdebe52d3e58f377b4e45632.1791883296.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883295.git.siddh.raman.pant@oracle.com>
References: <cover.1791883295.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:4:186::23) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|MN2PR10MB4207:EE_
X-MS-Office365-Filtering-Correlation-Id: f68e7b6f-2cb1-4625-d9cd-08df290ddf41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|3023799007|261009223027099003|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	38IVnrSZhSd1sr3+4Q+6X0t05CGycE1F/aEwUclbOaryzV5MEFxgObFjkb15FNOEeOvjxLAhVA/vpeHyAJoCpEa56ftGWVt9dbJ59PIHNqe6vjhXLI/gBE1JRB3Uc+vNvBX0F7Gf9nV2sUjnivvvosGAcz7GTr8QMxbZCgCmXahzVuJ7OQcl0ihWjTN0O54oC4XvESQfSTag8it1l4THx3/eVqYo/q4erCzPunH3MupWIK87qWv6aRDW4BaHjOZoxoHRjnwaBKSQsw+zQ8cFguowCxZ7e4+NMSXLzM3PQ+ynnEoNBeH5ZyHYTbZbmSCYOgd/o3KySi965vB5QBuOdoHOgrdvn4AyNMymd/HUFWv3viD6ri5JO1C3L7bCbjUPwc29N+d3gv/jUh4XuRnGiZCH8BIMQ8jsEvaRYJRTZpOeKTKBGuHJ6D5qp/boFwTsqKdpMULI2yQj4/Jcm4vjICs2mkl5r/aHMoDigzXUSdTbIvLNxQRkSbKK7vJUPpR5OBvSMwldEDh/wpQCF9le5l5xkXiySVqIl0VXdWMjiKi9cpQLviKMxZ1f1zdoxtYKDXujC+iOmb6+2iNCuG639SE4Z/JtYVJUbsqfY+b04rIzPMFCidenF2O1b2gBd0gBN+RAWca7lBciGr0wY1V0qeKDpaeg+99+07I3DVvHnZQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(3023799007)(261009223027099003)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VPzaIkoiHj6pYlMjmz7QvzF7dy1luS5W6JgCNsW7qtAw2d0E0bxu5m7yVXSX?=
 =?us-ascii?Q?Y1MbsmfbfXXYoMIwde7g8BUKh9CHo7AUgpm8cBgxoFhas54NCvkz2MUT51aI?=
 =?us-ascii?Q?s7xLGVWZVx5bQaRQuKNO8amecI215S4E2u4sdtVHSoTKcEFNC1vAcQcXIFFq?=
 =?us-ascii?Q?JMdOSk8jj56qFWcMpBIvsQGKX6SB69zukD/VAbTXrKzeqWg1jPC7rJarLai2?=
 =?us-ascii?Q?4iMT4RnuY7ivLlb5ayToS8eYB1jT3eGinM9VJIX15jKgVpFCN34Pi0tw25ZQ?=
 =?us-ascii?Q?3HCFauMT8BvndG/P24cCtDNqEYGXivq0MF7gCZQgMacVeoywG7SVzd5rwTNS?=
 =?us-ascii?Q?REpLq2WxqswbFOF3xwhLzpYZr3+sgEAwXQNG9zmcsKt1LuVajNFYptRCeIfS?=
 =?us-ascii?Q?4gN46TgLINQWO2seZq6b3ELGBnDIKS/wBMqo03SxSMXR85G4J9eQhy4GWj1h?=
 =?us-ascii?Q?LINEGuR7h5mtjR0DU0YhLMYx6HbJbaK7uiWaEQqenqjiXlr8kqfpMWjBkheN?=
 =?us-ascii?Q?xkVODJu5itEmoNZiux83fcY48Ev8yJo40dU62EOANz+Zp/Zjljg97EPXLRj8?=
 =?us-ascii?Q?WTWC0ebr3JPVHLYAoF267/FZgVWjPPwYZC9mKtWTpzXsKkQ7dhi1sTAl4jEd?=
 =?us-ascii?Q?dQk+2BD23fOWAqwDrSxcwGuwU6yUdIj2D9GqO0UgzknQuzpKPEB5aSdcbw+y?=
 =?us-ascii?Q?/IF2iTHfOpojeDgT7D0eUnEy29gMi367gr9Iz4OYn3OcAUqKFEnzeTon0vN0?=
 =?us-ascii?Q?RVaBT5jE8eqN7zSaYbmeeA5vDBBtYlEnLOX30bLEoJ+6evS+dhem8choZQpw?=
 =?us-ascii?Q?O9iqno509RjPFqo6gndtcgWekk25G+nI0P3wb09sp91eFrrDkSBWBWjwYvRA?=
 =?us-ascii?Q?tuA6uoySVT5lcz34Mjr0z8GwBH79zA7NXdvVCcy+vOo2TrNbDQx0g2oubEgK?=
 =?us-ascii?Q?U2BKRCwlplgdMDVssw3gp2+o3MfiriTGuagM/w3NbnqCH6H0zVK6R7FI5+hW?=
 =?us-ascii?Q?DeLfiKNN2E/SeXcjHguBCq2d/2aAgDxbj0nqqMeb8rUdfyS2KOvYSo41Szgl?=
 =?us-ascii?Q?DOAJucUocr/7guizmqfBCvG5IFZZf64CeNkvNh6vGu2c8TrYYvkQ/m20V5px?=
 =?us-ascii?Q?yXr9Hfkjeb0yTzmJKwZMRu8h4CZuosGN6q7whgdQexC2JS4OjTQ9mTD5jikN?=
 =?us-ascii?Q?b48tOknHkj+uyo3NDjPAp1vArBE8AfKRV2Ihg9ckG7I7Seg6T6puqjNzLcjI?=
 =?us-ascii?Q?AzMTBfJDPB+Pc8QXPzhN2Mh8VgBpVjaArTF/354NSuop0v4UCWnq9JTk79FK?=
 =?us-ascii?Q?mhaF5M8sEHciaIqG29vzqvyIeelOGivasMCcPnLtY8sbb4rWCfr/2J0s7+sV?=
 =?us-ascii?Q?w/r01mWEwwVTo8brNIF3ek/MUcRQImXHbh0LZYrtyK/kTjaoNAwUzvg8cHWE?=
 =?us-ascii?Q?A/RHRaWjkjeyp+FjtrvEasgWJ7LJD7xQ3+Ldaea9TI1iPF9q/38XyQBMIno5?=
 =?us-ascii?Q?4hiAvvJ0mzEd6xYsJhYmCeC8xa+NrvM4Xdy+K/mvaamLhBpfceK/Ogw3w9Mv?=
 =?us-ascii?Q?8oIgvRam+UFW/nfEXvTqDR3nZqIpmqyBBtezbCqZjCK+qmeMhMFWgG3S5d0N?=
 =?us-ascii?Q?VORyiNF8AaR903/N5rwOH2IdyUuGuhDfYZMNGc1b/a43+5RcEkFVe228kpQZ?=
 =?us-ascii?Q?HC/D3jwjPAzAClKYASdRBBV9y+bot6VecVERT2k9Ow0jnmnWEsL+0BEsssbi?=
 =?us-ascii?Q?bCJm/zbLWIAfqYtoiHoB1v4E+ArCeeeiTJOjVS81JoiARbB8Kc6NnZErTZRC?=
X-MS-Exchange-AntiSpam-MessageData-1: B8uHWN2Bcws83IpXLFHmTfLEYhlM1sdh3Xg=
X-Exchange-RoutingPolicyChecked:
	UGXsp8FNF+Icw03vxqQvEBMn8SbXXlPNlyC/DRNR6oxRyGbtS1EoyohrZ0KDaIdGIXCASaDlxcmnFSmfvNi5U2AxXoYIwxcfx8EefoRNwP7R/x9pZB8P0G1xgh/5asTPUYXCpPfgRDC972MmW1lk9tV0ReQ8A5VurLUvyT/kqFg3xZJ96OqdFAwqRMiIj7DawNXmrVQVQ9Go0JJoW4B2o6KLFs85Yb/QMtiOJsJSRmprN8aeflTjc8FELeGLc5s3GFsGknmnnmiMG1OU4+8DgTSXIn52L1SmZaxQOpqWvKehZYhgruMQI6KxEeW99y9qLoPurdCrdsJQEh5tqGnsJw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1mho9ZbMS/vVGsLkUzXOK0zF0OhBDOA1blM16fp8k7dJUJrLruaNlZSBPKUClNmGXNMKLLeypaKzaK1043oIJ+bZsgLQwvQe0dco3jYTGofCzgK7GMF2VYzxrbkRz65pMcvCQWaIJN992ZqucLgcAdoshFAJZy9uFh2rxlQYdYJHjwcxFssKfKqIDz+tAPZr/Yx/PTqTyTGlHyFv5iwDuqhUHi1WHXrydkEOU8StKylQsyl1lbUZH06adLur5U6aqM0a+5XlQFK5Qwb7RRhTXCxIDKqZj6D5/QPeoYVIpKaZs9b5TlsH4adDOYlTHeLGVp/hUQtqoEk4bkdlAxjiLZEonJrFucSB2tf3pC62V1gTrQm4SLXLXhoPS1mtx5mUIAmQhJQwuzumhzlKPTrbVnlnecTrsnaWC+GT6k+/7hmduxdzIIYBnraCs8jzuG/FMPhh70dDtO9EylEkdKIVt0uqfBfM0BuVDFZ2p8FYQ+V9u8wNLRw0rPR+nGeO9YA5v2eIVBSKS8FqbBWwgem7Z1HtICU5YrYKAO0b4UZ4bQK1IVgvl1mxjfOG5fc/JfWGLAAi6NrAWcs/Oyx1ZOXcGOrRKBLnZ41DAb9+thokdpk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f68e7b6f-2cb1-4625-d9cd-08df290ddf41
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:27.0046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4L2xhafCAqlIhokBjxIdjHtXnCPiKoHvkA+pGEBLOY9HIH+kg+c3ifZl4l1cR0mv/Xfrku6xXHRroCFaz0ZIldf7kmeNNYt+xCfCJHwcLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4207
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acdfc53 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: 4qFwfploXwVcFuyIve7m2eZLSesWK2dy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX+2h9VtFUse0Q
 Uq4eP7Ps48zMZqvVtNMGjp+y3DR8Pt7YBpWIEEinLCSjyVKc/yDFmZPfPAa94pzy2VvQHCmlq+X
 m91DiXqGwDQ21e3dw8wCMYTzcv/dle/3wvmwI2AqDDeCCqvykrpM
X-Proofpoint-ORIG-GUID: 4qFwfploXwVcFuyIve7m2eZLSesWK2dy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX7acb1w6a/BD5
 ktkSta5y8gHZ787WFtF3XxgOX1UllFfCJk5GmaUMVDzX/cxYAOTzACukAgBx1dhU8fU6KWY5fg4
 hYU9VpFqisNrO9yemA7aAmHg0n8HQSzucDZKzteLfMPUB+u9AUkyybXihugFNnzWk1WVwsPej27
 GpMsIks1HSD2YvFz0/GU42UNTNXlu4OCFPiVBzaSeIOPh7DOCpt/lT5k1991QcyDGRLkQrscKu2
 gEm/JwrnNg3bO1C2XHuEKpBwrwxQ4DcpA1Yv0nD7Ie9KysP6JoNfM1eyx6GBLCGCk3b5GOLHwNM
 lOwrV7Q+PUJ4fCylYJQL7Y3rBWws7/R+vg5OPN8c3+Qzgd0tltz0o+TbewX4EoseDYG3+JMY1Zx
 C30WZpFxx90swI0vaNkx93l1CiPRpY6SXMo2XtSfef1DvXbfrJmfS1I/4WyZmTe4tRRAcIUPhh3
 GA6+PHsyxM0onOJn8TA==

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 09234a632be42573d9743ac5ff6773622d233ad0)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 51fb70bce819..b609759de490 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -898,7 +898,15 @@ xfs_reclaim_inode(
 
 	if (xfs_is_shutdown(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 13a113ed666f..3f2cc6204153 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2492,7 +2492,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

