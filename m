Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5DE153833
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714745049; cv=fail; b=sZC+jUqTAXZplqAgLAngBC9KxkYY0B0yXPqpH5T5Br3tSHu98ViULkfO7IDM9A2Rv9Gwn5qGh3j4mcyUUF4H0dGik3FU67NyUYbEmO9BF3cnjDbP5Nk1oMTyHuSBZacMaZLXzY7IjU5lZpzvqnSewgIEhobDAJCzekCee4KA+u8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714745049; c=relaxed/simple;
	bh=o2oAJRphAItZ9+9I7GWR1MuMpmnHWeDCp9qIDl4NHMc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=m9fggm4TXPMZ6tGSnCk24gFuPlXp2ghBDNzfvci/GzH1XuGiog8p9yXkXn2+e+3BOHh6UbwRq/mzwNQEk9iDpbY5m1FSi9J8vqKp4rJc9QOOyLeY2TUOuMxgAgjzKm3W2S0X0Vha8kNiySYFnli+SmbOtYa9KFmLVqC0+9sn/mE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wjfq2hKI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Dsn8zO+B; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wjfq2hKI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Dsn8zO+B"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 443C2W8I027680;
	Fri, 3 May 2024 14:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=7hJA9+LLPmWrV02NPTlLOEjt0/Da9cLKBOXtz2kvlWc=;
 b=Wjfq2hKI0FXC9VORT3GtsajjOGH4jVyNBXTf/rT2l0mVi6CGsk+u4HdNLCUm8ZIMBgll
 jzwziw/EJc4XR32Y35BU4jmbLIHjTgZH4ssosKHMpStMeoBAt3upoiqTFR0jO7lLCORT
 Ezav022qvfzYQdkEYAFrc3OMvMp73YX5z0HKs4LxHxfDqZUZewG+fEONvL51YiAAg423
 iQCQX1IL9WRj6EA1YWZCZz+IXSvcCkQZWRADZL79YP68ix8XOLpT3+1QRgeQZIzfEHlC
 Sx8NrC+U+dBaJZrteikm45uw2vJ/H3bdl0dWAsjZgr6xuBqXAUhVdrnFu2RSxFa+88hl mQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr54rqch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 14:03:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 443DQ8su006043;
	Fri, 3 May 2024 14:03:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqtcbm8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 14:03:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LeR00xZ78dzDFZtDbe+uV4lv/fkJfz+VJtIX1gMT53BzIJ02tjyPe6Zajv4xiPgLh1qOFmCecs3v3LlZ2g+gRSoZ5H1Eqjur1QCuuF0BSdRxWYPvsGsbz0sEIPapQR748mVwAu0xxOn1HRyASvg+uNYXiS6FvfmA5wo/qN8YkPOA8foh2YxSdhm8rBrnqASeloH7PibE4/2Sf7beXIMnMD9fTgKnc8t9jmhjsh/2F5803y+EZ5vdJ0/NOtth3o5KBC6mQRFEDQzr1WkxlkoSfYy3tN6p6Piy3lRSnrOEftOcvYGpDCC8rB6O0q1/tkMr80gPr4oLqNNneoZM+82EnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hJA9+LLPmWrV02NPTlLOEjt0/Da9cLKBOXtz2kvlWc=;
 b=c+Uc+9yRxyelRGUZPbGI370WiAQMTMjpvn4gZoRPEG6T1UwTn9WNjuQAuI6yvQ6uiBlINmsRRnpdCXOxm/k3moKSzH1H8tPkv7ks0ac1EL0t1AG9wSkIl0OyA6aDiKMzthHRLjFk0DlTnkalin+1z2J+Wgt99Gmnxtq2FQAXhDvxBQRPyH02lObE3qBVILEYoATqCkADW+YwkUgtGBa3xCHscQJBe20Ndbn9drUbFW14sg9HNP65LplA8jbL0pC48zoHhxCYxzGBaKAcyba8CzPWvuYu4HpbDG37er+ngRmelUVk+uv0xKHIQ/sjNLHA0ejXSCLh5SSlywtc2umWFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hJA9+LLPmWrV02NPTlLOEjt0/Da9cLKBOXtz2kvlWc=;
 b=Dsn8zO+BL8v5jr+BWevLzagOSGphNyuoEB21dFJMWI/KgWDkPkGhCPD3ZDMMP1IxWU+yjAv4ECVPCdbvsqtBdTaICJYZ0NLgW667ONPGPB36q6aejel3GAfnMNJn4w0BK8ExSqNI3bjd9VF79SbZoM/b+BuGErbWc5FEZ8ZwbNc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB5074.namprd10.prod.outlook.com (2603:10b6:208:30d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.34; Fri, 3 May
 2024 14:03:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 14:03:48 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 0/2] xfs: fallocate RT flush unmap range fixes
Date: Fri,  3 May 2024 14:03:35 +0000
Message-Id: <20240503140337.3426159-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0044.namprd08.prod.outlook.com
 (2603:10b6:a03:117::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: 46cad020-a813-427a-0c48-08dc6b79daa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?GsgC5FzsIjMplvOxdy/VMZ/j/l+KRI55r244Vrph8a7PFgwZvxA8beJwdf8m?=
 =?us-ascii?Q?Oej/R+uDFEEKmik5VdVSUHbS9qLP3PShTXcSk+l+0mGJMuR3hycO6clRDipb?=
 =?us-ascii?Q?/LsrpIDmXdnxs3eAlr11MqX7jTqY7VIBUd7fiijTryE878JUW5bZoPOu6u5T?=
 =?us-ascii?Q?iNrWJowUvVViImCNlle9DY3BQB7BzovNj6iH2yKZydQzYIt8rNR596jmlSrf?=
 =?us-ascii?Q?L6cfm2isWT3Ym0xM/Q8uKlMvxvS/47AHP9B2PW6k+VvPfnwtSj4gnEGcLOpP?=
 =?us-ascii?Q?twKr/6sfAKQwNa1cZ5A4UjhphnrjuR3HVqpItjdqBJq+DsDVheE4QFgnjmpE?=
 =?us-ascii?Q?hG55u64KmfqcJpG5DjxJFdd5v3f9ggiIhhStcIeUp2oRzUjX41yHwXVQkva7?=
 =?us-ascii?Q?qVzq+ok1XK4Xpy8jurdVMQ4ynEQ4/U2eS4cCEGluuwaREuKQkK4Li7MkEddU?=
 =?us-ascii?Q?iOXPJDMqw3nhJWebggLLYnpTndIz0dF4NhSvvfWwW+zZWtnbx1uDYdE+tK7U?=
 =?us-ascii?Q?KY7ByTb95yqbN86lPr1uaxH7BgzSisVH2SH4/x/Y4mADr4tdqhNCFaXk+rWc?=
 =?us-ascii?Q?8jHhK3tGA0VMlWIO7OUgvY5Fsu3DAZS6PwWK6ZhdrywFEW5sgMHN0HTFbdcu?=
 =?us-ascii?Q?2pPfmzeZRMK/DjUxcwat7Midj/1NNmk186yZ7+SlovUB2esjA7lemd16ysK1?=
 =?us-ascii?Q?HIPQ0ycIg4oc4/igFJPJ69qUnPzZFtzysGho10+3yTVAP/YKMrCgNY1AU4nR?=
 =?us-ascii?Q?z4qoG5ItZCf2tPtm8HT8vewK0Sx95FaD6EgVkaa4ktk7nBuOoFTq7XJVY2qr?=
 =?us-ascii?Q?mcnu+g/Kd4gyB7G4C3pOP9yXnYWj2yGzI1Xc8CkBX3IEqJy9EdX4Eshc6hx5?=
 =?us-ascii?Q?ea1SD0K0Ee4w5qw4MJ554/QivSR+hbtrcYJPBgpzcY3WAUrIjwMDh710Luak?=
 =?us-ascii?Q?DPa/BnHVMCRpJrbLR5BJaqoCQfE9OrW+qkq7JyHzVwFDcK5XfbeE/zSfDm+n?=
 =?us-ascii?Q?4eUKbcrEkV1fx5V5uGDdLh4RMSGfOwd/PvitvK6TuXjAYNb8qf34uNl8ArVJ?=
 =?us-ascii?Q?cMz+bchGZBDDvsAhplBuGFZLfFSqzKvXWpeGTjZr1kx2Z4qB0BlIWwHxMXFC?=
 =?us-ascii?Q?vFL9KHojr/2lA6POPK9ZQZN2KTQ53Y6SwKr6i8Fd4174BN8y+mhowb04rZ6T?=
 =?us-ascii?Q?/Iej4G0cccl2sgID1leV9h7g+LiQZ6bEvTXwuQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?hvhee0QylS+KE9xgjYNVgz0lWvqP6AgbVt85CnTS+9Cii84c6WlxWhVqHrP9?=
 =?us-ascii?Q?8g4P4+eJngukGSRSmmSU4dezxsLC3x6RmB5TRpg8eynIe5sWnGVzB9nEICxm?=
 =?us-ascii?Q?8UZYY6zLtwhn9zIwBqR9cpowQU1eZ0kAh2wGdle+qTOMMHlZXFC6RMwB1/nF?=
 =?us-ascii?Q?htSc5qkMgWEoJpezZ82H1w6/3w0sqJJYngTr2VpwNP5LfNSFI7cdWCHm8n6m?=
 =?us-ascii?Q?1r5TyVsyJjR2JanrGl3CSL+eT/j8DebeK5bUHVpIbM4tZg4qgbTch4PKoSKe?=
 =?us-ascii?Q?aaO0xZBTXMhsPb60s7E601/i+SMjSjCuTSduuz6M4YLpbND4cMydOf7QAj72?=
 =?us-ascii?Q?Fx6mWgMW5OdtLqDm2pGeAGS2TuLWjcfpu9nZnw/tRdWodWavAe2jeL19AtDd?=
 =?us-ascii?Q?xoneSwUbrahYpxXdkn2N8n20wXnC8hhFKhEbScO0NiPsPF1hUAgs+HbxJqrE?=
 =?us-ascii?Q?wWSC7ffykazNWZz2veHsx7rcrKr4HXglNTO16fCYHZLHFX5mhXUEezIkoaGM?=
 =?us-ascii?Q?i11qIJGYTyCY2eflCyRQHI+/erEOnON9SvA5HinXHwcTi8mteVHitHk2ivn3?=
 =?us-ascii?Q?woYapI537+GqIdAWPos/87UoH1DpBFY25D+mbwukMR48ZWRqpsYUNlpoU/aR?=
 =?us-ascii?Q?QzGdUaYODlIkUz5SethV9UTu0Fdf47IsYNXDiCBl8AZKEoAGeNItGnjJZ9yP?=
 =?us-ascii?Q?pGC8hDXgKGcVxonhkT6HrXVHNRs9u1wpbf+VmmNFoNBG8UaQTv540bPfbqG6?=
 =?us-ascii?Q?u4Yc9fiGZ9ZRZa6SoKlURAEWOEa2YtUphxD31SsZW9hhalrZzszU9ng6SwA6?=
 =?us-ascii?Q?a+QAmVxUb25SDiY1Wb/gbzkU9DLgZKWLRSPOP9PlDT0D/F1rFX4M2jsk6rZs?=
 =?us-ascii?Q?MY6VMpNt+gRfzmX0U+g/zLlp35jDXkDrn6bH3p7EEl37v5P0jAajPHh5CocU?=
 =?us-ascii?Q?zk7abfApB78TCohjCvn71d76unMedWNl3c9S3J0ivD34AWuZkGE5qBbs8Ejh?=
 =?us-ascii?Q?kz121H5M6J95wdZuZXDWnMxVslJMo9Knsi26no6FiVFHeOkEBywi608oOCC7?=
 =?us-ascii?Q?OLK9qrm2o4e1dAPo8mKTA7Lj4qu0+LRArErFj+WtgJHUJiO15LTSWcXEVy9S?=
 =?us-ascii?Q?t33DLYL78Utbf2xCodW4MHEf8oOGuzHBcDUl9uoHNhFlNd+Aie1B4wTIjkDY?=
 =?us-ascii?Q?DOLANUZtjF8GS/tbKrRP7OMLOpceq9f5G+8tPGl6lXbwUtn9BV0xU1suJidx?=
 =?us-ascii?Q?gL+K1MD6FHTBJbwpIwcPZUxJGZfI274C0rb/gsP0bBRbCRpUgl0Dx/0CWJ04?=
 =?us-ascii?Q?pb7hCsdImNolViTR180YEAVN1fvXKWITWZsvvkOV1MnxBuUHvlwkhTDP0DaG?=
 =?us-ascii?Q?83OcjKPylHdK/wRC6AVkxFdv6a7JLlPNTFbloUCPQSARDSTpyAjOsobwXfuy?=
 =?us-ascii?Q?JThDe0OGllDOGINj++N8vuGttZknsnulpizjt1gOF6TzvsdCkKMP7D27LrtQ?=
 =?us-ascii?Q?DhlazLAAiwYp7ez+ioA5KxVo3X7X/SEGIvDUBfzxMhPpc4wsey56ed+XElp6?=
 =?us-ascii?Q?QejMbjPXBNOTzNyoQoiUAZkviiPe6qE7HvwZ6LZZs6sufucFiiM7JMVsvGoO?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	qIboyAf3UHxuKS/sJz5f3ABSxtUNa5K1mKgcr0o+IbJ7m16q9YPTqGaGMDWpGPNI4K9JxTi0EsyyS5fI8FjEFTyGirxvHbzqdjQ+AW4x5STqLgwavTa9rgN2u1d0gp1372IQsGIgt+zBOLhXA3wV+mh8GNMfQWkIWZyhytoaGYtiz2T4lW92/wAJlMl0em9fGsu3Fb+jNjldCuCImOPgBRXrfjpEUoEIl8Cqg2JKk16T38R5+5b9m5IK2TmeNtV3M1hskodVIm06A++77srl4cnQ0SXV4eaH6JfoEC+8uDJojwDTHYRYy8lPuR+75wHxhNfDWKbIBT6Ypox5/h5Oa8xfKmJknrHqgHIWllMgxqGZ/IPSfZpXQByWq9TgzR4a7+IMR2a8v2b7vzNBfFRNojhYLpmtRiU25+4UxUUv9XuSaNn3s+lMIn6RMg3cu2wBfbLQbIx8luBK3RKxvn5wNmiOp5Yu0unQLujiEH7stUjo2MJYEAWuKAuq9+MEYDUHgQmA/JpFKFDphpxs6IRm8qiFfkLUyDt5Kx4R/z/ZEVvsGJJ3J++8how0N7xKbtqDTsRL3sfkBK9gBOU4VHWNErEVAiOGI7O9xFBanylXtl8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46cad020-a813-427a-0c48-08dc6b79daa7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 14:03:48.4156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0Y/tfGglLkgcksRZbsy84EebHCPiJxok4NFrQUSMhLwUINDIQnwyoOYd4q3jMNfgryAXb53XAqPpsLOVZg8xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-03_09,2024-05-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405030101
X-Proofpoint-ORIG-GUID: s-gt4bCd63cobAH6t4vboxHketKwvbFM
X-Proofpoint-GUID: s-gt4bCd63cobAH6t4vboxHketKwvbFM

As mentioned by Dave Chinner at [0], xfs_flush_unmap_range() and
xfs_prepare_shift() should consider RT extents in the flush unmap range,
and need to be fixed.

I don't want to add such changes to that series, so I am sending
separately.

I am marking as an RFC as I am not intimately familiar enough with the
code for me to say that the changes are technically correct.

About the change in xfs_prepare_shift(), that function is only called
from xfs_insert_file_space() and xfs_collapse_file_space(). Those
functions only permit RT extent-aligned calls in xfs_is_falloc_aligned(),
so in practice I don't think that this change would affect
xfs_prepare_shift(). And xfs_prepare_shift() calls
xfs_flush_unmap_range(), which is being fixed up anyway.

[0] https://lore.kernel.org/linux-xfs/ZjGSiOt21g5JCOhf@dread.disaster.area/

John Garry (2):
  xfs: Fix xfs_flush_unmap_range() range for RT
  xfs: Fix xfs_prepare_shift() range for RT

 fs/xfs/xfs_bmap_util.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

-- 
2.31.1

