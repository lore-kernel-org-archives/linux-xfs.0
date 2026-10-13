Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A219486430;
	Tue, 13 Oct 2026 08:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879366; cv=fail; b=E9q36cE/Y8TOPWyWwcgf8K2eeWt2+0gz0OAirY8ia4YVncbWkZ3keTNWoqtkHnVqFhJSydgyav5KDHNTFUEAfAGma9c1qSwCqj/kvZJz992PPtoHcVx4W2Gc0qQHAYNHVhcRmx0TYEBdwThpBEO21R1Tflg2ua+uIH6PpQJRKNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879366; c=relaxed/simple;
	bh=0W/1AyRffqF1mbiq9Om8nOTdMoyQB4FGR2Ljkcmoeng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NUMZVw9dX0bh3dETUpr71Z9FQOeTbx7Dp5uTiLVoeH4wG3g14gJRccLAYy1AdyUw+Q3NxDWzIr7nHzgI+qMmXbC9o2dzhtq/gXudY3coze/MKFS8XQZgqCgltEs+pjG0PTrw0rKblbnlHCbggtTwyTL+eh6eHQeK3b0pDQ8IyAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bVIJdKO+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nDTYrFGM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bVIJdKO+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nDTYrFGM"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C4HA1440146;
	Tue, 13 Oct 2026 08:16:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vKLJeps4qMf2q/pSXjE+5feu7orCUCQOHCCesGf4RTc=; b=
	bVIJdKO+gaGhLgnpRnuw7C10sLX7ye3ruUKfs9Aeu9C3eQ8Geknb/wGiGm7C/yoJ
	Zp4wtm3Zt4JdCLD4ibRUVx/+WXViSDRj8MebmAI44wEsafjW7psp9MMFQbNxzQHn
	7ZWZpzlEmYTqVIBA14i2d9ZgrjiNA6pMDj9l5c9d3OYClyQaQTtC8HRL88qRsl08
	eL4wVoJp3Us+nIdH2sLjmPA2u9ROq1za9PBIGS1S3HkaCIMX5XP/z4QtClqri0O7
	CXIAD7ww43ZRjdlRTv1ZL1SRAP0J1wrY6aqHa7yxlYUpVFsQauJ0bdHK4dOYq95Y
	lCojimLd5Ik1urF03mNSsg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uk91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86gve033459;
	Tue, 13 Oct 2026 08:15:59 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxsme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBHAMlk9yvNuYua5EeYk0zLoQlz3jU7zb23sA+9JcQsJe9qWL3sRyCJ8HAh/TqNQyFfETXzimUkJlGazXXbSYLHcEOqBtRMKFLFgwFo372GsNzq06gEX2JWM3RYcNaqVLeMaxKnzbbkW07PAp0U24f0MM/3e8ajlw6XOnhbo7lh/t4lRJr4eFG3oxA+l4+qilMx9ZTx352dsuon8A/gCOH1BbTL3NvNVcWafTrIvq6M7vVTxnFX8pf174TsfL5Fz9wNlN8xjYSvrFoVnXa9qL4fqWdBMgDM7bv/HfxyzfhSd1531elGDe1u+ZdV0Q/94sdoZPI+rOtuR76U5KYffKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKLJeps4qMf2q/pSXjE+5feu7orCUCQOHCCesGf4RTc=;
 b=K8lFbepvopqEw/faeKRREebHNoUhO4YyDJynC+oZ2fobaKKEJ1feT9zfuM3VKUNcSEkAoker+PyD3+z6yb1GM5mYm2a3j4OciZj4azXMDxL/6yP5ZkN3x8m3dBF2Oc50QSNQpcuvy1f9ntPhBEwExpNT/poUM3s9PN3SYlzhRenDUIc7Qi/0lD2suKgZJp5VzEZHruZP4MjM3pTQSw6WzhvdsEdhiZG0V1gXBcqYxDFkTnIXxvxTYQkJ58kuzs/jSGPPrQb4ELdvbROnGe7XquiQ3WQ7RN93a/YuAfcBo4OPwbN5PxAPzGiVwMCjV+8TBGkfk//A3ZEfFe407H3cLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKLJeps4qMf2q/pSXjE+5feu7orCUCQOHCCesGf4RTc=;
 b=nDTYrFGMduqE6rvGC9lRbgYeMadFoyY8VjwJ2BGoa5Kmfu4GcWQ+QYxFqnTm4dlraJ2RCG27DIyzTKHWdnk+2MpRcv+wenSgp4uoJ8RyKerZoTZbQURbfOq7qWo3y4UN7G7/ADibpH5R7N+pWSg4SpInsuq6oI9hpxDIgEq8Qak=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:55 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:55 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 10/19] xfs: aborting inodes on shutdown may need buffer lock
Date: Tue, 13 Oct 2026 13:44:54 +0530
Message-ID: <a647f889e727d10b2a71c3ba89f1ac7d286151bc.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JH0PR03CA0020.apcprd03.prod.outlook.com
 (2603:1096:990:74::22) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a458286-409a-4703-997c-08df29023457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|5023799004|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	vXa3SYZoV7h5I6mbakExK/0IuOVfnu5/+kRXahFKqqF3JnmOkjjoNFirszArCix8dr+EcuCRHNcGGBbrz1C9rv5rlysc77bQc+NluTfqYl5V0FH32jQVX8wSU32OT68mBtCyjRCtzxJ2tage2bybD989sZBYT+SePy+B4lgqWT/7aNb30vR7Yy5uZO6bZHJKpNMv+KI9N9lJbyZ6+UrGZuvWIx6S02WBL/Kzyv9Y9wcHS1dTHbkz+USmTRfRg1wsOheOR3ZRktJKYtPcOso+sTPCWZsvlqkz7Np3Xg8HWawY7YidmF5ALehBXUB3fvE2uLHVyDiScoL53HG3gvhAzah0Qmc4f6DrAz8UfD2UCO9+g/FnlSQqKf9Nu8BirxjQt6hy4W8AHG/J44vsjs0nGCpt4DIPLXN2DUDyGnhICWZv5+OvKsi8JhNC36xQ83JRc2TB87ovqUWPvBuCOxg5VEY7P4Ols0JTX8JW+TzAcvqN/1YRqnQBAuia75y5vJOMIhpZTNVZIBMp7NMqsnhXMB6y8SV/yrhq0+SiOud4DEivPycUgCLDwib1xk2oTSZslMAc2nM2NH824PqhQr0/CISD3pgcsShnji0IVZZuioFEejJmTnHqr85bcT3ZGPHn5oIhAn8bcZvSuPvoKr8Dn7OyQksmh1F0l0Pqa0cZOPo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(5023799004)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aOO2iLoXGL0Q0NjyviQAfxyzBUIqOud4fbCKvnupjxBAqgELmqeaU4zi9ljI?=
 =?us-ascii?Q?3SuyPy2vEtBVA6Gf8Ei57a7nif2BlWIMBukk34lmGlHLq+QeHcBAtcvRMMJO?=
 =?us-ascii?Q?tPcmHxrqVzA2h0QFTCICeHO+jSPFOKZqWHJlExTYfh01PKYTHNFwIolYF9RY?=
 =?us-ascii?Q?c7aBM67qobzfGB2Tx3wEcJ7s//CZJR3rH1T8Y1HF54H0tlMOao4cbxuL3haT?=
 =?us-ascii?Q?8+OtxXem70NuD5DHq5xSxsRna5k9za59Th8genohYD1l0jIgz4TVF8Z+UiLE?=
 =?us-ascii?Q?wCNnLM/qzMSgjxfl2uUwjNSJYutzniWpOUVZT6VXeX786KWDfxYqzwev9Gvk?=
 =?us-ascii?Q?jPMLN5rSE0PdW4cbQFhgw0ORfb+arzCdkf9FqDFXbxnJoRxJPE5yhlSDj9mO?=
 =?us-ascii?Q?hh4ZFkUCm3xLlMtfGPEQBi5Pg2ISdg1hrpIqhhofj7aYJSTyfFr4SlvisPCq?=
 =?us-ascii?Q?is8pBPJkarXi3WrpQY8No6Uj/ey00YQm+j1j0utgf+j8NwZtipGKdxJ1q+Nl?=
 =?us-ascii?Q?I4CR/hy0EJpI1XFTRSASC7S3a+KjSs4ozbCxlwzTMZUayxdJaZezSuAVqWeh?=
 =?us-ascii?Q?DQ69j1mzaPnHJzeRyXacjWhZk2Pw2m9puRweW+zeeTv9PH+5fdh9dX4pWQA/?=
 =?us-ascii?Q?wMMROmaEE8IZWVqdQc2AwJz9/RMpLL7ynlTjReYKplQ7rW7eikOh7UyvuMQP?=
 =?us-ascii?Q?23E+/NqsouuAcydwA43uqg8o2kRcHetIHT8dXp4pQvgj9miCB7ezo3IVed/J?=
 =?us-ascii?Q?Inz3sbdeW8aOXPgG9zE8dewZjRF3BsRejvMjMrM9gYfBX6x5nS8/JD5yOQnS?=
 =?us-ascii?Q?w1WR6lUYkLn1Qe1rSr3QX6Cy9X2mjsTJJU0tXMPFoiVV5o7gtPHWjDsQrPFi?=
 =?us-ascii?Q?I9GCOxIK0baoIL3w/u74xE6qTpwf5sR23ZfMSSJ/5+43Mdsf/9gia2PG+BwC?=
 =?us-ascii?Q?173xZCoeYhoXSzQ2DEOXDm9bKBAPSpV3HXSlMjpM5D9zMMSodp+OowJslfVD?=
 =?us-ascii?Q?CPbjum5tSK9Kir+aDey97HemBRrp/MVVL/+RVps5wk1IQ/5TEBZP1R6nnTqN?=
 =?us-ascii?Q?DBo0oiq1B2qE2PUEyTSWa2OyTkZxRPpTZxPFTFJkkwZALvJqiE/QnsnPp1Mk?=
 =?us-ascii?Q?P7SGkOwVD5jiitQHsvdcSByKSY63nT97mzJKUrXgNzhfB/87R66VsEe/5ELn?=
 =?us-ascii?Q?8KJ9G5R86ykmCEpLNsvw1FLg8tSamSxwJYJw8eQszUqpfxpWSpEtCK4ouxaK?=
 =?us-ascii?Q?zrTdLliQlRS9nucjWemK7YVBTgxXLlsT24o07LL8vmOsNGw0KWNNOD+XTvEs?=
 =?us-ascii?Q?eYTer+CdluE1CVRTnb5Fg4v3pU1V7AO3aB9sbN5ug8NyGAOMJob4jrWDsWXS?=
 =?us-ascii?Q?jdLufWFUbSkCZoSljxBQr8R23GKtzFsw0Ukuvttke35/O6J7CpSe11lnDWG+?=
 =?us-ascii?Q?i9P8d/04Ko5Hva4YgCS+ZuDkDZ1NLSZI8UpBE0dfrwJ8O4dhD9yQZrHjMDWE?=
 =?us-ascii?Q?v7WIpKC3+HdgKp2Yo3J1u07DhjAl47TdU+uKUyb/ZwVNAAx75d5QC2DbyuPZ?=
 =?us-ascii?Q?qskgc7DruiajQ1oT2BZSOw1NxNZuAv0y9kRTLbnIME7+sTlwPSsSVmRlUGxb?=
 =?us-ascii?Q?Hw75p6zN36NzappjfGzYWCUlp60aNGPPzI8v6Mja2rsKJcWRrQfgiYI1dmV8?=
 =?us-ascii?Q?sDX2fnaaYbVbLpn6HcULlbn3+eZBvKbd82zqdBFSztrorKczqeAyGMx3+Zju?=
 =?us-ascii?Q?cphSH0Z1x4cfGMdJDMYQkZ0rM6QGENgsUEX7zHC4Xasrs0UJgEQVqI/r9kvL?=
X-MS-Exchange-AntiSpam-MessageData-1: +RDMX65W38tsednmvd08sj8e6Uyu7ObC0hI=
X-Exchange-RoutingPolicyChecked:
	OlVSQVkT9omiJyDIosS/WYmOVIjr1QdNPySAcU350yh1qg03WY2ycmOtIB0jqHRip0KM2uPLmq7fr1g0NK2zwhKosOxMS7ynqUCrAfZKgfLn8BhvfSl5Oj0NDN3h0rfgHMqptWd6DlgXNeMJi8y/h27dfFYcj8TOE/BMlgL4yKWoZWOCYetVOmh6WNiFNLrcMZOx/y/FFIBIrxTtTDXVX19b6TxUdYXZ82JQUy8fb3gi8dB7zC1N3RYPf8p6BbcP8ZOftMizZkM6fl+ohUiJWd7SPNb0trgc545MnBcM5KVKDd41rM8JQkMWVLs5yKMaJaon5rTWX81xtU1mZJ2Z/g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VLa572jxC9YQZebsTOwLx290vK8DPD2LvgWTGFmnfxfhyRxFheltgKUQ+uy1mUglNaRdqaoIm7UskZWArUW/kksTzwjkWeUfZRW4+ddvrnTZLqyQpyPTbGIGor8GFtmuj7K/oLWkrSb7KnkdpVOp/qnKgUpVZijb/unMH3wfG2bYs1hWX5SSNEhLvVzyBYMQnSKr+2Yy9BehqOoV7yls7dZcwqWMTcrt0ruH9SSly4crcRmhLqPebMiQdGpYjorkp0B/Ozz/u4FXuDkUie12ZSlK9UHB4HchKtE/uMq1e6Xy8URtgMnYOHVqCir3wAaDLjwKcJ+CeGQfz3w2QIVi2dF7WfBcg78sZtr6Bq1jf7ZI0jDtWScb06jj4QupX+6tel7kMtgEUBxCGhfSQ3uzraM5ZuiCp9r5LLnbNJ8Am1zEb++9QX5bZL1QWtHGSr7BFRNCzU6yv6t7QQLAVnpJsp9P7CxbSh9UbZBXAo0s5z3amvbgFZSaLNSZlE6I1uQSnheJEqsbh8+E6ZIJmtvdyaQOAzKqtWcj/J26j6VkPBJjMuViJ3wWzKjJQP2xvp7lTNGufnOFjYtDzskIatrurjRRQH7qGr2ryRJ42PvBItI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a458286-409a-4703-997c-08df29023457
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:55.7763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1ueQJVmVGHPPWrkion0rI65k1tMeP+UlpwOpVlvIHrg+HNNdjb/CyCNixLQFXKYw2/XFWcoyk39HxT8b1le/2vO3NLW3Rch4ZU6xt1pDDA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acde8c0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=45b4cX4q9fnkLCOmiR8A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX6LShAlZ2ZGSf
 lP99oUDy52atgx2mrTVEOiQATG5gmPYRs1fcBLbz1JVsSu08FFEbODwHDU83V/Kjf5Eaf7m4r/3
 Fqrj8MUD7gRiBH40f/PTgDIWF/OMt9f61jQKRddyIur0HJD+yHGe7nk/ugG7O1Wvh9LWRXfnubo
 TW2QCjr9LyRtaxcDjC0w7peC/jO75cDscGlvFyCynng7Lr9A0oEvfkWtN9Py2yXZKyJuIcFjJel
 nOfJBvxK1ie5XkYokmZBOCCI+R8U4Qr1QP3H9jfw2qeQchTBERNnOR1Jr58sI7giQl2cjVtKaJl
 x6NrvdYoJMTt9XQOjpwp2XoXh0Xb9CfbkHpz9Wl6f3ACEzTZpH7AxX+Ym8cHlmFAFSDA96GUc/Q
 jFpnknVCgmsTsAsteRcXibPv/BxL8V30tTb58X04lFG32VtdEXB1/gmuscSpLoPtpf8UdU9nJFT
 Gh+Znp3jEHQOylfemmbjvRoK2OlJKaIALR/bl9Oo=
X-Proofpoint-ORIG-GUID: LcPJbjALIy2gczSnSFW3jCUEHOKzvJTN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX2x/oiZxc8+yW
 iankoaUdbUTPKXi9hv6TqRRnbvhNFhTSvcYAzdMXY6Q7ZmjdS4Q16xmNB26NCgw5eZSJx9gbKe9
 YWYBROxAoSb/ItPZPvkTaZ+JaJPn9r7/yigfLIa+M0v2uR3pvFuh
X-Proofpoint-GUID: LcPJbjALIy2gczSnSFW3jCUEHOKzvJTN

From: Dave Chinner <dchinner@redhat.com>

Most buffer io list operations are run with the bp->b_lock held, but
xfs_iflush_abort() can be called without the buffer lock being held
resulting in inodes being removed from the buffer list while other
list operations are occurring. This causes problems with corrupted
bp->b_io_list inode lists during filesystem shutdown, leading to
traversals that never end, double removals from the AIL, etc.

Fix this by passing the buffer to xfs_iflush_abort() if we have
it locked. If the inode is attached to the buffer, we're going to
have to remove it from the buffer list and we'd have to get the
buffer off the inode log item to do that anyway.

If we don't have a buffer passed in (e.g. from xfs_reclaim_inode())
then we can determine if the inode has a log item and if it is
attached to a buffer before we do anything else. If it does have an
attached buffer, we can lock it safely (because the inode has a
reference to it) and then perform the inode abort.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit d2d7c0473586d2f22e85d615275f34cf19f94447)
Stable-dep-of: 09234a632be4 ("xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c     |   2 +-
 fs/xfs/xfs_inode.c      |   2 +-
 fs/xfs/xfs_inode_item.c | 164 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode_item.h |   1 +
 4 files changed, 137 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e69a08ed7de4..d973eca1a881 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1040,7 +1040,7 @@ xfs_reclaim_inode(
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
-		xfs_iflush_abort(ip);
+		xfs_iflush_shutdown_abort(ip);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 19008838df76..2de204f46216 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3613,7 +3613,7 @@ xfs_iflush_cluster(
 
 	/*
 	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
-	 * can remove itself from the list.
+	 * will remove itself from the list.
 	 */
 	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
 		iip = (struct xfs_inode_log_item *)lip;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 38b59e8070ac..c9ef341d4ee3 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -518,10 +518,17 @@ xfs_inode_item_push(
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
-	ASSERT(iip->ili_item.li_buf);
+	if (!bp || (ip->i_flags & XFS_ISTALE)) {
+		/*
+		 * Inode item/buffer is being being aborted due to cluster
+		 * buffer deletion. Trigger a log force to have that operation
+		 * completed and items removed from the AIL before the next push
+		 * attempt.
+		 */
+		return XFS_ITEM_PINNED;
+	}
 
-	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
-	    (ip->i_flags & XFS_ISTALE))
+	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
 
 	if (xfs_iflags_test(ip, XFS_IFLUSHING))
@@ -801,46 +808,143 @@ xfs_buf_inode_io_fail(
 }
 
 /*
- * This is the inode flushing abort routine.  It is called when
- * the filesystem is shutting down to clean up the inode state.  It is
- * responsible for removing the inode item from the AIL if it has not been
- * re-logged and clearing the inode's flush state.
+ * Clear the inode logging fields so no more flushes are attempted.  If we are
+ * on a buffer list, it is now safe to remove it because the buffer is
+ * guaranteed to be locked. The caller will drop the reference to the buffer
+ * the log item held.
+ */
+static void
+xfs_iflush_abort_clean(
+	struct xfs_inode_log_item *iip)
+{
+	iip->ili_last_fields = 0;
+	iip->ili_fields = 0;
+	iip->ili_fsync_fields = 0;
+	iip->ili_flush_lsn = 0;
+	iip->ili_item.li_buf = NULL;
+	list_del_init(&iip->ili_item.li_bio_list);
+}
+
+/*
+ * Abort flushing the inode from a context holding the cluster buffer locked.
+ *
+ * This is the normal runtime method of aborting writeback of an inode that is
+ * attached to a cluster buffer. It occurs when the inode and the backing
+ * cluster buffer have been freed (i.e. inode is XFS_ISTALE), or when cluster
+ * flushing or buffer IO completion encounters a log shutdown situation.
+ *
+ * If we need to abort inode writeback and we don't already hold the buffer
+ * locked, call xfs_iflush_shutdown_abort() instead as this should only ever be
+ * necessary in a shutdown situation.
  */
 void
 xfs_iflush_abort(
 	struct xfs_inode	*ip)
 {
 	struct xfs_inode_log_item *iip = ip->i_itemp;
-	struct xfs_buf		*bp = NULL;
+	struct xfs_buf		*bp;
 
-	if (iip) {
-		/*
-		 * Clear the failed bit before removing the item from the AIL so
-		 * xfs_trans_ail_delete() doesn't try to clear and release the
-		 * buffer attached to the log item before we are done with it.
-		 */
-		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
-		xfs_trans_ail_delete(&iip->ili_item, 0);
-
-		/*
-		 * Clear the inode logging fields so no more flushes are
-		 * attempted.
-		 */
-		spin_lock(&iip->ili_lock);
-		iip->ili_last_fields = 0;
-		iip->ili_fields = 0;
-		iip->ili_fsync_fields = 0;
-		iip->ili_flush_lsn = 0;
-		bp = iip->ili_item.li_buf;
-		iip->ili_item.li_buf = NULL;
-		list_del_init(&iip->ili_item.li_bio_list);
-		spin_unlock(&iip->ili_lock);
+	if (!iip) {
+		/* clean inode, nothing to do */
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		return;
 	}
+
+	/*
+	 * Remove the inode item from the AIL before we clear its internal
+	 * state. Whilst the inode is in the AIL, it should have a valid buffer
+	 * pointer for push operations to access - it is only safe to remove the
+	 * inode from the buffer once it has been removed from the AIL.
+	 *
+	 * We also clear the failed bit before removing the item from the AIL
+	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
+	 * references the inode item owns and needs to hold until we've fully
+	 * aborted the inode log item and detached it from the buffer.
+	 */
+	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
+	xfs_trans_ail_delete(&iip->ili_item, 0);
+
+	/*
+	 * Grab the inode buffer so can we release the reference the inode log
+	 * item holds on it.
+	 */
+	spin_lock(&iip->ili_lock);
+	bp = iip->ili_item.li_buf;
+	xfs_iflush_abort_clean(iip);
+	spin_unlock(&iip->ili_lock);
+
 	xfs_iflags_clear(ip, XFS_IFLUSHING);
 	if (bp)
 		xfs_buf_rele(bp);
 }
 
+/*
+ * Abort an inode flush in the case of a shutdown filesystem. This can be called
+ * from anywhere with just an inode reference and does not require holding the
+ * inode cluster buffer locked. If the inode is attached to a cluster buffer,
+ * it will grab and lock it safely, then abort the inode flush.
+ */
+void
+xfs_iflush_shutdown_abort(
+	struct xfs_inode	*ip)
+{
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_buf		*bp;
+
+	if (!iip) {
+		/* clean inode, nothing to do */
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		return;
+	}
+
+	spin_lock(&iip->ili_lock);
+	bp = iip->ili_item.li_buf;
+	if (!bp) {
+		spin_unlock(&iip->ili_lock);
+		xfs_iflush_abort(ip);
+		return;
+	}
+
+	/*
+	 * We have to take a reference to the buffer so that it doesn't get
+	 * freed when we drop the ili_lock and then wait to lock the buffer.
+	 * We'll clean up the extra reference after we pick up the ili_lock
+	 * again.
+	 */
+	xfs_buf_hold(bp);
+	spin_unlock(&iip->ili_lock);
+	xfs_buf_lock(bp);
+
+	spin_lock(&iip->ili_lock);
+	if (!iip->ili_item.li_buf) {
+		/*
+		 * Raced with another removal, hold the only reference
+		 * to bp now. Inode should not be in the AIL now, so just clean
+		 * up and return;
+		 */
+		ASSERT(list_empty(&iip->ili_item.li_bio_list));
+		ASSERT(!test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags));
+		xfs_iflush_abort_clean(iip);
+		spin_unlock(&iip->ili_lock);
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		xfs_buf_relse(bp);
+		return;
+	}
+
+	/*
+	 * Got two references to bp. The first will get dropped by
+	 * xfs_iflush_abort() when the item is removed from the buffer list, but
+	 * we can't drop our reference until _abort() returns because we have to
+	 * unlock the buffer as well. Hence we abort and then unlock and release
+	 * our reference to the buffer.
+	 */
+	ASSERT(iip->ili_item.li_buf == bp);
+	spin_unlock(&iip->ili_lock);
+	xfs_iflush_abort(ip);
+	xfs_buf_relse(bp);
+}
+
+
 /*
  * convert an xfs_inode_log_format struct from the old 32 bit version
  * (which can have different field alignments) to the native 64 bit version
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 403b45ab9aa2..9c829cf5c839 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -44,6 +44,7 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
 extern void xfs_iflush_abort(struct xfs_inode *);
+extern void xfs_iflush_shutdown_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
 
-- 
2.53.0

