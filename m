Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57005202F9C;
	Fri, 11 Jul 2025 08:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752221408; cv=fail; b=X58Emy67nNaesIRYPVymmrQFqqZyuzWrG6xSdbDujCqDCyutfTGcKK4kWnKMzahfuDJnsFEUZ8m5/BdNOylXpMwo6oNJG0sey3TQ/tx7blBY3C2TrvilfFHf8BsfnoNVxCyDx65a0gEM6ACanYMPSSLZEAey/eSfDRxXzYTYuNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752221408; c=relaxed/simple;
	bh=ZypvM3sQwPILpqrPxC0yxgisOHlyKit9VzyTK4qF54s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HFKhabXhVVLJfbL0ACvOg8J4IZvsPpKPRVvzYlOYI8vFnqCHBXLhHBWbMC7HqT26drvg/ljVCPB2WMOD8D2s4MOSMa2ifZ1v1BiL2ta1CjsAJnwj9wvVkgrFsbeHdxZBFcz6mjmOw77cmqbR3yP2ZJZ5HRDWbVMlh5rByOyS5xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X7Fki6rH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HLOw0/Ld; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X7Fki6rH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HLOw0/Ld"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B76vMU017027;
	Fri, 11 Jul 2025 08:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Kq/YdrUWJb/P9yrWuLstKMfsq9gbqPNphqxtNwjchD4=; b=
	X7Fki6rHLmFAal0UOowlpWRhjtFnyX2cecerkWU4CNOy50zz9vVe3xAd04N5aWtF
	CaTvkAVeKka223QF6/xaSeNuuAxpjupHTIDHJg9k9eqy1rPZRaj0Etsu1CacFeof
	cHbKcbQdiRPzuVMUry75ht4MAcVzC1UUFZ+PUJglmkEVvnulvZdpFSsuC9Gr6gra
	cgs9r41+btS9baw86TU4fBPov90ahT2SU2jlXn0y5Rx025U4p8oPQzgG2iy0g0Us
	sNFxOk5Sg9TDMw6/kej0MQgiEMd5RHSusHb30cR7c5Dpgz1ZuNnyHuMAUE1ShjbH
	9c4qsdasuw7v8SSAa1Yaqw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47twx602ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7Z1bF027371;
	Fri, 11 Jul 2025 08:09:50 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012035.outbound.protection.outlook.com [40.93.200.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgd9k57-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fl/hCjMUt04XDtNfGexHWpclr2b8+wmhLbvHjHnU+EL+LIwznwkVB3hM5EJiU4GPZsohZWVlJ4aRgZAJSTzpqi4PXaV04QIxuBUUvCknMptYg5T20knqHNDySgEIUc7wo75NkfGhLk85IyDN5H1UR181Cm6/H2G8NhlWQzYTndb0TpqOurinAOrMGHpNzCkf1NEUSzQda848KlLxZsNgo0yzQoggOU9x4copdQoP12VWPWALI4yjbxgWN1Zaug0CMk8TU1jS2aZ0nqAZNiUIyfnfVqm7JQpuLT5F5NOzgb6fwORlcrzeIzwPpm4KIJTqmkJxwskWnwMRyIZ70l8+hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kq/YdrUWJb/P9yrWuLstKMfsq9gbqPNphqxtNwjchD4=;
 b=E/QEhJz4Pkt09ja0tPK5skmXTKq7JnIgpOKRMkYY1ZiQ54EQc2S2XJydTsGYKZ3/U6MyneZmh5y+NS/7l7qClwsBHHgdnWc2bSjEpxl1IkzC++oVDAjMaSFZ5Rs8cfZGPa0P5RZh1TF6C6VPwx+3y68r/fXY1qC34awnEI5xj/l69p+/TBlRYtTHTe9XTJaWhMpkUJ3h03dnnRrkMczTum2L6bRECG6UQuCcheaP2sToC+hHnGJ3cLH/XwJ2uwjfz10Xgw15sBT8YNvs63TQfQIa9G3Q41fWue3vnZjX3T4n7R/Unc4OcuvIkbmstCEl41/XhyRLCK2I1dEYhPa+KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kq/YdrUWJb/P9yrWuLstKMfsq9gbqPNphqxtNwjchD4=;
 b=HLOw0/LdVO3rRCuJsCkGzsc2bgqS3OYFlt2T/G1dJ7z8FvGIvqoEfWlay6YemoW83Dy0ypyD2GuljVYIA7Uze4bkgKQCYyZGb/ZpeukAW5RSKlvxsUvjdom9zDN57pHwqCEDmXTNP/EWDa6q3TtBFp4HNrt4TZISyIl3TVJdEBw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Fri, 11 Jul
 2025 08:09:44 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 08:09:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 2/6] block: sanitize chunk_sectors for atomic write limits
Date: Fri, 11 Jul 2025 08:09:25 +0000
Message-ID: <20250711080929.3091196-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711080929.3091196-1-john.g.garry@oracle.com>
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 30ff7cf6-d9ff-45a8-0641-08ddc0524b86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qRbumuRfUKbXUKj2GoiPzjvhz3WIrK2egoLbm4WGjysECKsOQFkX4xjJ+sqy?=
 =?us-ascii?Q?utAK1LH2TFupzUjbvI94SdKH3y7hky8wF1tkVzw7eeSCSBNVqJa97ngXxSFi?=
 =?us-ascii?Q?kaY2l1jYYgUpI+8JrUq3IKjjRsvxsPCMHwyhX0OqXU1Nq+M441mYyjrh10E1?=
 =?us-ascii?Q?OKj1956vfTH71mHuEdFCPIZwz+amx1vqdARUQxF6sGyP7+Zew0S5P4PJItsu?=
 =?us-ascii?Q?cozikXsUs6zqxMUcrE2nRa/Ci+jrXfh9Ir+oK7M4M4yGOiONJuocEsilApYD?=
 =?us-ascii?Q?vXRYwMvYaYuRvAVreBYdxP7KrR8q9/LYMlBousqHYMioARv3xNiFRk23JWu6?=
 =?us-ascii?Q?o/pxeYxWGIBVYsIKKlb+OM7m+N200CMYOzKMBIpmVkdG9xTQVpsEsNgm72CI?=
 =?us-ascii?Q?qXLv1ugDTEXOV9H0QZCvJDL2S2rSjp78LYxa76uKihpGpD2Lyn4kmm4HKj+S?=
 =?us-ascii?Q?HPL09m1232sY0i22Gi3LFLgJSY70ly0T6L7pHxrGyRDcR4IMnimVNvUICu5T?=
 =?us-ascii?Q?oc2bsG/HfJy/9AkgvTM/wCJiTXEZ00sRdvfKNR51oJaeAMoNhOVySX69qhWJ?=
 =?us-ascii?Q?CAWjpx32AhTByqmwq8+89CeTWbNKBQ8SD2gDximcT5LEBYSLSSsMLTuLwVvX?=
 =?us-ascii?Q?Eu6wCTkNW1XI0ubUGhkUZgQ3rMT2W2R7XA7tzYfxeBLLwM3Nxh8Bzt3ckeVr?=
 =?us-ascii?Q?DE8qSiJDMOXYLiuC9w0EWnavtFWWiB2ufE1kmZEv1Ag4EA2H3TBlgfZdlxMe?=
 =?us-ascii?Q?QOrnIPCzQawNBiiYJWaFuHjIe6ZuwvzbBxo72dvOTSh+ihXpDHE8pum1MyjD?=
 =?us-ascii?Q?odfyQPDAER83ScGzc42NIJwJ5Q96y4NE5PFfhW97tSbyAy8RZj4Ok9Qlm5+V?=
 =?us-ascii?Q?oInoLvRJEVzXiejhh3kXukHs2xByriGdESq0b/4zarQh5YJfiyEvdEh1z3fA?=
 =?us-ascii?Q?43sRla4KM0Yfxg2ugyQufbOooIVDo2N9GBVfndC2tTebLiHJT4YYU8IuUDWw?=
 =?us-ascii?Q?17OyuQLdSrHWDaJ7PrLf4w3TQhamPaxtb6mAuFzx+R+9rica2xymbALeTUE1?=
 =?us-ascii?Q?pDPFBF7Q1FZohxIRIK/CUtk+Lc4fqUVut96g4lI7Hz9n6ocaiZJnCejq9YOp?=
 =?us-ascii?Q?lwFYCcZouwu2nQ+pGKWBF22+CAjyJZKqaNunMgaCDgQk32NiNk3xBMJs0OfD?=
 =?us-ascii?Q?+BA67/AZfilPxhtE8rd8AbBhX4jmmxa62NhMbreOrWfShrosKOHUr+yfSnOb?=
 =?us-ascii?Q?5mzBe7yGLUmkTwMbqBunFHjBACnbsP88Ksx48WqxyV8V39Lx7Z5GrDFTmV+G?=
 =?us-ascii?Q?Od8tFE8b7v7yeNu/SO6wcV9ebwjZRcRw4nwwqXp5KZ1n+/+N5mhplXyLF8ij?=
 =?us-ascii?Q?se4tGVj3qRdenArIv9X39sNB90XxTuJsJXPFymqoHS74/2IZHah/hRtGObuI?=
 =?us-ascii?Q?PXe4rIblTIs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+0KlgYR+VqTR4bYLkvbmlT6TYo1fN8Dp/WomYrfzYYdYvmIIISpUhSFLSG0/?=
 =?us-ascii?Q?QRF+IeJuprNQC0gOYBSuJMf+5vUCICtFAaqhNoa0jeiSPqMrtmzT7ugRKIk8?=
 =?us-ascii?Q?7H6aZrJttnH+v6M3LpqJMNSHo/n+SvN78AoWW6IpwDAyyCATz+qXjHKrik9R?=
 =?us-ascii?Q?Jy+9VSyEMBe7QPsGh4IADudugdC84kU1XlJb9yFKk71YqyLxrg6Bw31oq/aO?=
 =?us-ascii?Q?jQYMaQvRIqEUVr2vAHfbKBityc9UZxEr80/qiWKPDLY9v4nfBv4QSzHHrO1C?=
 =?us-ascii?Q?9rN7iaCdJs+qtT0o2sdTjXpHij0cNeRkmocWoit7iFTHS/ldB2iK9VD+pF1X?=
 =?us-ascii?Q?02r3NW03dLQZ7GAeHbvRn03eoN2ETuTfKL8meDs9JWYTa1l2cbK1BM+C9B1i?=
 =?us-ascii?Q?cU9kVtVNtrBljoOGmoS7Cu4mwTqqtU4lZ3Yd7c9/RL/FPdNe5wMHmota9HaD?=
 =?us-ascii?Q?7lbqibK5Gi5SavZGmkFzVlTZWvgNm6lmP8iDRDoUu/m/69J6clcu3dhp+bzr?=
 =?us-ascii?Q?z8pASgSuMcBRMNlK0yP1ylbuoHLoa32T6EDnMRHLjDl3zIiT3LpkKGZBMLJR?=
 =?us-ascii?Q?mBvcVQ/3f/hrc/ASFxX1QQ4pxRpfarkKcyKwNdCiJ/3XXoOh4DfxgXxYWP90?=
 =?us-ascii?Q?fap8h4WGTfx26QQUIWWpQcqbbywF0qH4UvAYunNSbEuMSlttswaUxI53H+eL?=
 =?us-ascii?Q?ZNWBNdK8idR2U93MphfvCv8dMC+TLqCkDJc8lAFPZK7IrSAz4cwc1ock1tbb?=
 =?us-ascii?Q?Vmmmy9f4j+k5ykc4zaw8iJiLPFFSpSpLqfxcev5u7RmLawTZUUKH0rDRyYSN?=
 =?us-ascii?Q?6LopW/B2NS5Ww2UChgTZ5u+sIPinTCrPlCvGhTb3zObw4ewFnmlP37JlSFLM?=
 =?us-ascii?Q?gNvOSAZAiTojszc1Y0LBTSefyPgZfhmWbpGXYjEL1LUwRZFxIaMAAZ2bfh4V?=
 =?us-ascii?Q?Qjm4fcALYRVyN/pcT/o5+9sQ8uwxLxdUIYzsOH3n8crVwXhldJwqdxmKIWOv?=
 =?us-ascii?Q?cf3/LufAUMOrvYZbAAcmSMfDstwHb4xOZu6jRg/WXIWLlVRVcqtRnc8qj3YW?=
 =?us-ascii?Q?MHs54kbpah7lJRFME89ta9rFRjas/exVrn8EoH1fXf4CCcnt/VcGlM8ETe6t?=
 =?us-ascii?Q?TqPmYMSjEC33dyIV08H9q+SLzdm6UOXkiWaB6CZ/tNQvDres5GRNFB+oXGRf?=
 =?us-ascii?Q?O1q7KTN/nYDvqcg6dtGXy2+5UM3vM/KuDhJUAbHzxeTpAa+wV9OWZh4n6S8Q?=
 =?us-ascii?Q?eFq1B/sSgXETvawyNLjsN2WPcvRc392z/J9XCbQFmcZCxKvaM+QeVDoyPnO4?=
 =?us-ascii?Q?TTZ0Yyb4sqVPA0LFIXoRr1/mxZiGS7b+1xzjCTqCGjHo4wkszU5JY+jE5gXC?=
 =?us-ascii?Q?Ut7K2Yl4G+4hAeGiZDUQluNf4diYgVwYCPHV+XKfp8zavHPde/NrMZ+/NuXL?=
 =?us-ascii?Q?+tHCJjTdOP09y8VnSK/tqsEqsvwsr5o20RZOFbuosfbq4dQj38ynLwmhUd8F?=
 =?us-ascii?Q?q0FVbBrip2OQ6h/9QBjCxTn+WBigTIIHNFm+Vm9HtCAPnENbRW3NuDnsB15/?=
 =?us-ascii?Q?iD00hs/+H6IBXkh6p3MycbtenpFx/Wk4+24IduEwr6v5SgZfCpxNfB3IbNOG?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KObJtxMuszNK1RYuJfJKiuD2Cwc3ErfSl3H9O4CMrUwIsSHN6MMP+ejAlZtK9ufNAUzzoWnAsE8v4nmPAYiPhW4wrhCwU28UZfMCRQtacvu13jfwrok7CeQy+p1nfYj82Q5HScR5Euc6hfzvdWMpvqspKjiPINiIw9CUEEh+TlGiEtgylahwxLnLzflggogzW4fs7IhqQxAYbMHeJT7QxSgMxEypS0E59MqrdCCKFcdh9lPP7C/zf55in+Odq7slkhe3jPo8vjaX/D9wZQrbjkqQ8z0S4P+sut2WGWjhG2oLazmzq6qnD/pBrXuVz0Ngt6IlKdS8Wvf+4HWSCbUdybWGd6z8PgbugfCaqHmNkgoOL+sok44CoZ42m1rPa8Sly4DiJwHcflFkOfMlVZKH/Au0SQjXn+8m91OzBCksfsqZplYO+mFpd1W9K1BENz+z4guhN56pD4JdhM709aFY14tZ5ghM6GR/neltxzf5tHC/Fi6RQ9U6ZNugIh2/nvCrD/0z/1pilWnhiifq2BH5QHYca9JSDOo2s/jdJCkZBGk4rVHgWe50sm6lc2MR9jMDjg5SRK+G2ekM23BqQuTGEGb5g5uBeJ0N+L/ROWiQufk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ff7cf6-d9ff-45a8-0641-08ddc0524b86
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:09:44.5428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/bYAsH1lHldI88wMl5QeOZGrHSPRx5G4IF54d3g7Wtbmv9ADuVkrhOWdvihYWfa6mqS265fszAGnIwW3EJTUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_02,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110056
X-Authority-Analysis: v=2.4 cv=G/0cE8k5 c=1 sm=1 tr=0 ts=6870c6cf b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=DqzVqx8i_IFAgmWpyL4A:9 cc=ntf awl=host:12061
X-Proofpoint-GUID: 3C_ez7NVB93PdESZhQSrMx8Dlw0br3_K
X-Proofpoint-ORIG-GUID: 3C_ez7NVB93PdESZhQSrMx8Dlw0br3_K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA1NiBTYWx0ZWRfX8p59zedhjKto vzdc1xxkuHlGwTWqZJlueeuCeJYL5CncAUidv8PJMXr9eTvJ+PBhaD9pzn9HboQzyONVFe17OqY IfAenNORAcIV27Adfgo3ltJWmRhfJRKyXc8+xrsBYo4iRBvpdvuoIeu9O5izIIUGspNmqoQGHRb
 dofe2/xR9aD0YS4fqn5udOqa1d/NCktGdrtDPOS6g5pmhL7B7kk5muBe4viBHEX39kDOPx878o8 Q2homJ9/kLWAhDa1Nq0ozANWMwYvby1cNflQPGOox1VKErwGcLcYL50IQtP8IMKtAjovvYN9LVv Z/ZQx0t6wwuf/8LLLaFIIHI3x9Zed7wm/l1utyICEpjI9hN29gvliauHSJ3i3dusQbgdlydiDU7
 tM+v4SpN+9U+8CVWEr2J9QIhOzaMw57DDrtA5FjmCQl4TMeyx5fYmzUT433sfl8Ku3nnq612

Currently we just ensure that a non-zero value in chunk_sectors aligns
with any atomic write boundary, as the blk boundary functionality uses
both these values.

However it is also improper to have atomic write unit max > chunk_sectors
(for non-zero chunk_sectors), as this would lead to splitting of atomic
write bios (which is disallowed).

Sanitize atomic write unit max against chunk_sectors to avoid any
potential problems.

Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a000daafbfb48..a2c089167174e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -180,6 +180,7 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
 
 static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 {
+	unsigned long long chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
 	unsigned int boundary_sectors;
 
 	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
@@ -202,6 +203,10 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 			 lim->atomic_write_hw_max))
 		goto unsupported;
 
+	if (WARN_ON_ONCE(chunk_bytes &&
+			lim->atomic_write_hw_unit_max > chunk_bytes))
+		goto unsupported;
+
 	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
 
 	if (boundary_sectors) {
-- 
2.43.5

