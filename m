Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC6828EA;
	Wed, 16 Oct 2024 00:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037556; cv=fail; b=KRr4IiVRPXdi9e/A9rG41FA9nuWwF/p7kxspEjW9nGchMiTyAj0oiyFyxHV3vyxkf/R2MgDKbAxUWTYIBiFYHQ22OYXLkJF4+sSvhfxzYQukKYrKP7wN+RSIm3th5pf+DqkfKEO6ogdOPqSecwqLdgLFTNeXfmvPLJbYhPHyV+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037556; c=relaxed/simple;
	bh=GxAV78xrXb5VFtPb7uhEU6hh49QGz4myY6HJwVoNBMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M2HZaAbDP5IuJI6TJmcgrqJl5iDp7TjS9/wLpjFpVb4J5kpkTnMQHy6zvldkuKkp1Q99zaioiW2qzGiVxxWUPDM0LG1+OpLM5rp690fPlPrKecUgTNEEjmxzAwwoPaB7zdOkz0CWt8b1nCQbz0TMeG71E5YwCqL8J+bQy0ZuxZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WwiPBoXS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zlB7A6i6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WwiPBoXS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zlB7A6i6"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHthTB019400;
	Wed, 16 Oct 2024 00:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vJpW16RWffnWrxwm7CTx9+DCrBfZOJOIUVHgmkpTnsA=; b=
	WwiPBoXS3bVu+zi9kHmn2LoX7z05uoaxap1KQfwyYOTxL9hRLs6gparxTJrtkx1B
	dYavGUpvwBt7vuXmG2h5QkJ1tUYzSC05CKYKMsh5oGda2BdBaRwSpuVa9yK8G6xR
	RxobnT1C3ARP8+zWsN0o8DGEpQVlNBSyYqrxA7lpW878Uswrst14imoGfnK2zw4x
	KgKK3XhnWgFBB1g7U0tTr60baM31Cyhw1sOA3pzZ+UA0N54Eix+dkccZoM+N3Ykl
	yRaLcgYNrU858m8u8SaBzK3F4b+TT22pMIbDvBU6tjs1po5hDlsb6AOVJKeWa1i1
	jMx1OlWDYj4StcisbY3T3A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7jhqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLWlMP036099;
	Wed, 16 Oct 2024 00:12:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjegx2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cg90yhHWoQ7b+eLVqgcfMx9dNa4BJrEL7WUuYSjktCl9tZ7tVRxPJi8ao4LcJZTDZNlwCBpUNAy8dw4uwKEheRt/Oq/V3t6uD+OG2kqjcyAz8PnaiSWO3VAsEiryWfX2KHXglMlpHq4avjT0zZvW18+G4w6teSbuqu9W6R0wMV6TxmnsDR8w6Yjf0pzg1ZigNRe/GXUVjdCGvuNr2WVzMuPq5Rin2nnmfGYdhNV4b4WtM8OL1wPQ+5NizJQdaPfs1jwYCjmXuh5aqbXs8mooqLFtwgkFbi9kKLyLLmAtfN6jA6uOhTXOSyzKuBfys5eDuIbUxam90WhMj8xhaWvY+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJpW16RWffnWrxwm7CTx9+DCrBfZOJOIUVHgmkpTnsA=;
 b=Buw0121QYX5+bO2iOpsTtYEJwwR52aNC7+AL1bEsMGd2YD6SAEZv4EhpZkNIf+wYYlEZOA0PDOtVKfL59gPHT1X+dEPHr9Jkk/wKicdMVrPuJNaDSusTYt3rh7RGgpo5hRmGLdieKhg80tY9xfsUNxPTFvgwZpsnahlSSOXyQf7n4vhTaLjSc0cBzeAeTqnpZssejAgFkYWVMxR8uerHk8QKUdu3V+gUJtdWYXIYT+OhCcgEqCARm+lINfAdXKkCYl7JumxrSXIekE3VG95vdD6mdHxIaVFjcJBj77hCLdan5z8cXnxqtw7Fwy7qmETPEtXmyQWQSWNaVmDb5n3q5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJpW16RWffnWrxwm7CTx9+DCrBfZOJOIUVHgmkpTnsA=;
 b=zlB7A6i6YwExdsmlo/bUzgm3sGppjAVBGAut+YvCJczzy794XHQKKWhCFhtSUocVjEtCkBXZT4ckYa9CLGB2An2LBfKOmKmy4x5HF4L5uJA3cz8ybNMcREFspMj3qG1a377VFvE6MSa+ju8xn2ANvwLShKUBlCiBdvdpXzDOck0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:12:02 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:12:02 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 17/21] xfs: make sure sb_fdblocks is non-negative
Date: Tue, 15 Oct 2024 17:11:22 -0700
Message-Id: <20241016001126.3256-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0192.namprd05.prod.outlook.com
 (2603:10b6:a03:330::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 35fbc1b8-abfd-4864-de54-08dced7728b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zyilV9mpUhTqVIBOcX7wXNNB5aIs1LBRu8hU7+vrtnR3DjLk7HoDQJGr6Hom?=
 =?us-ascii?Q?mUREeIm2FqrNIMiZtmnOLIibybQ/eIlQeOKf3KTdVoyrIMUdllStl6xBGeTE?=
 =?us-ascii?Q?lF/oj//lT9Wh070sX+iiBPOI1YDArPE3Cx9qZ03jHxFpqHVqwJXSg8bYWfl1?=
 =?us-ascii?Q?YpXwaGL83VOX6Vzil4y/dUhbmlPD9Bu6o8du1IK96jPkYK9b642dR/2EvTGi?=
 =?us-ascii?Q?37nFJt1kc5iFxUGxPIKAjC50jeZC66dyFmVWPOVBQJ5Xz0rXn6azzlPgs7aM?=
 =?us-ascii?Q?AsM8GgChRbQv/Yo+lvQcgPN0YnwwZx4TrwZ6TdmOk3jJ9swlisgkhmqVRVrP?=
 =?us-ascii?Q?F8/9Wmp8+yNvgT3+HRtm+4SJQZvVNWCdwWkIuTi5F+Rr3tGRf2TSUz3itCQW?=
 =?us-ascii?Q?Gsq0SiTxSqgMqL4v9Rym5FuiguQlKP881ddW/a44Q/FsBOXYSXVOU/XvmnOr?=
 =?us-ascii?Q?R3M8pJ4zLyNHVLqeJwM8Qo5F5eJGA7zyNv3k0IFoSx0HR/NfoXWbyAukxtUn?=
 =?us-ascii?Q?E60h7+mlL10lJW6nPGyCMca04tn15E66tAQBkZsPvfKHfUv9aBSw79ybv37L?=
 =?us-ascii?Q?vsp0mlHzCHdwTqr5g22CwqSOIzM3D+YTvWZaSIuM4XyC/m+aw7PMfimSb0Lo?=
 =?us-ascii?Q?yy3qKXcLOIs9YTt4DH73RxVHaJOTLoJNm8OtGpax0br9MjgrsEARnaiH6BO+?=
 =?us-ascii?Q?rc11B9p3fP+t4IeGGHkkA+gCcHFXhvV8mR5NsNwFhazlEa/oVcwlT00Bd5Qh?=
 =?us-ascii?Q?grvENQTlfL4v3IZx09GpqkP+u9mJ3vASZAvPcOF3Qdv7liA+akQg+J2VTm7i?=
 =?us-ascii?Q?e1WZl4+DfnglIB4e6cZ8vb/BOxWmFmJzF+qf9IxSGwXmV/Zjgf6w3vuPYpEV?=
 =?us-ascii?Q?h++X8BSotvD78wjc23GHCaapPBby74TiI1s6uUZ0evxbLPYKnw58MBB9hO5c?=
 =?us-ascii?Q?Gx/iAGNUrFeRkFBArys7BGHHUtSGmig9ydQOhejnnuNwMhujQ26E1E3Iaptr?=
 =?us-ascii?Q?ldH1/wzr6cCU4iq0/X/0c/7pbfoLj+jnPZoh9B+aTWmIMBmeuVmoOdfNCRpP?=
 =?us-ascii?Q?v34nQKy70bsUMZ/z02r+8rq8ff+xtV9A69BAJq6XY8lpoKHk7Ox2J1UJt4Fz?=
 =?us-ascii?Q?Eu5vCTrvhwWkyI3MBmTZqBhvam3kX6hYMmVR7D6Dm68gHA8S7xoCQ5ZFqN0Y?=
 =?us-ascii?Q?Fig97hV+cLKlRSCwOY5BfPdD91ubqysMNKi3p64Oay6jGXsxturIc24oH14p?=
 =?us-ascii?Q?JDWz4pHGc4HZd+/rP9xVpOnuC2wCc7A0vIl19Fr6rQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vW7cV/Lw/A9ULTbreNNUuGXzD3CKDYGXIqHIjeyyqKXsoJvaA7yiCz1cPfDY?=
 =?us-ascii?Q?XaXWo8dWblonQ6mJFqSc4BSvJCLT0HFQ66dQoaD/L9YV0ijRfaQrTpvZWNwN?=
 =?us-ascii?Q?kz5Ob/F8EpdXSO2MP/prE0+obJv3t+Us+AjGqjQZ58aXEOPxLmurOQDCe6LV?=
 =?us-ascii?Q?wEuEZjWagmSvjkYFDHpRYaybFbIKYevyJ/6qS95ZKxUth1n3tAgD3qkMDCKS?=
 =?us-ascii?Q?cBTXFIvfFPmeo6TYigitnaJSXGAtQ/KpsLt4io0IUD/Je5tcuVgIv1hVcrel?=
 =?us-ascii?Q?D6LPUnadqUMFCma258p2GMFFM+sIiIZgiO8vFCD8LUomitaajG6/0ap4fN5s?=
 =?us-ascii?Q?ALaZQwtM9dSEOsBen+tyV5gM2zQR+nEPliT6ANB/CdTKfJlZLY8iyHNI9p5t?=
 =?us-ascii?Q?81sUQWHia5PdMmYEnBs1HO89c8Mw3pBl2Emk9Bjhg7OJGbnkHUd5WYhoSl15?=
 =?us-ascii?Q?UKjH+vTpAKSSRHicADHMOeDts8JS8z/bFJ/edx2s9cUf2XmpByG+yj2x2RKm?=
 =?us-ascii?Q?PNTXdRXm1iZOkyW2vXHO8d2Sk9MB8abQ4kTJUBeLD7h2yiRQ6EzJP8TBEtq1?=
 =?us-ascii?Q?1YJP7W1c3cYHV3MjifKsMVUIkMEMtE41fo1/SVrGHleZ2aadZ8J0SiKFQnvr?=
 =?us-ascii?Q?4h3NyzN++qjuiMtu0DHfLtOHItp5skvBUZccc4UGwvZpUA+RM6NUzuW6OUMC?=
 =?us-ascii?Q?URUnr4AzzfmRJlT+Q0PyMDYm0j3qZq7gbvEDdY5adMCz8ybeDgn9iB3pYLER?=
 =?us-ascii?Q?7H4PAUkWkvtYwgv6fYmzh4hi4DnVDpM8ZCFdhBJt1FCK/+rsEK9YYgT4FRMh?=
 =?us-ascii?Q?4msGXfjK5WLAO20JYvibFQ2Y8X38GnE8GhYbCj1tNiY9/Q7kS+IkqIZhUbQp?=
 =?us-ascii?Q?UkatB3XVZz5nr7TK/Ygr30oL5lj9BzCZm/cyMKGaREVxWB98XXKB+O1bWzeA?=
 =?us-ascii?Q?xYOSosfXKRb2tUcuKEHO0i5C6T7Fziskw8Oe8aTkkFQd6lopqkKjbRcVZ0cD?=
 =?us-ascii?Q?MyRtS6Xb9x0RIqAjSW5Oi4vCgaHzF2JOPKDvPUtfWHWlqbBckcHZHAeIOI4I?=
 =?us-ascii?Q?ssDT89m5BvNmXD1s3h3me+ItU0moxiuSz0n4OblaBH6XA0YgIDnLrt4ll5xS?=
 =?us-ascii?Q?zAYXdcmaTFQ5sO0j8ddKA3/aiRNBcyzPSjtMZIdeTH60oVTUXRtqsSBQTRxf?=
 =?us-ascii?Q?Jns2Ki1rJw+RoM4ySz3jF5YqbeqLPWwwzUPlsi7Rwnn4FAq/lx10PaG3O/D2?=
 =?us-ascii?Q?UMlqepBZoUtF167X03qYS+MkQoMssPX6YfcBEc/r52AdvM9U1AAiPK5ivoKV?=
 =?us-ascii?Q?ekVi0uf5LvSATRNtF91r9GgIWiU9wELwEzT6UMSRhO/N3WbbQx40jjCwvmgF?=
 =?us-ascii?Q?22GJ5cBKywN/5NgZBwCwdokEV4Zszz0Lkebdu0EOnUzx44bsG7SqXIo1BQ/o?=
 =?us-ascii?Q?aiul6R9D9I5U7WowJK36eAOa+KdPeKNjEY+k4rKYZWN3DlleB6maKimcz0ee?=
 =?us-ascii?Q?5/ZOTHFGWM0qKllFORNdsLwNmQRxpcOw5mgPevgf5O+tHPJ1wzxzKkI5OvAJ?=
 =?us-ascii?Q?GmtfEZuM82PFCNX8OCj8rkKp519qD+3BazfOr8CiaALIGnVZwac5urtItJql?=
 =?us-ascii?Q?FQYtIIFLD3nDR7iXdsc+6ObztaVgpEMh+DSWmS39bNSWswmTy9T9AtdEpya7?=
 =?us-ascii?Q?60yMpg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fmGDPWIWB8r+FHRVkCzfhGGLJ6AQSqX7addHHyZPvzQJgm77a2vJkDw1agkIll44g82YV3g//Ripgw5T3xH03Ta4qmHqogvYKXxEh1+JZoXO5vj0aGxSltThIHAXL9t6rYPDyyol6SMmM8gAQYidkclLV8u8MynAYtmcqQOuI8wcOdC43UsKJX18ehjyO3j/winQeCSuWw52TNWL+o7fXt/s2dTaKb6REY8xkqEe14XXfdaEMaLOcpM5Fi7T6YXehAO6AZGt6syK6R6Pm3gOVSLaaM4+2A+Ey3wSzMiJtPoN2wBXT8QwgkI+G2PiH0WvNv2zoGKQmqA37Zhj9+IPYC1QhDw8Wu07IoPj9Qj4rgw4aL9KT6CluSnCaCcXqgaVRF2duLgukjJLcf5SB13yoDLQbAKKHRK9zM2ri9uY+EVp8T1YHrsoRYrqa2F0YY89bcDXAKkKd32Qv/YAzSX2LUkYkghQzLW7n2l32Fwl9nzULfMoPGhU6KxAPkjIcitAi92ohcs3kmXn21U+RWGYj8JNwucZP4DFdGekaBHEDdHnsQlAHopPjKV5eaceXOW8ATyaogFW/qvPHMHYDqbWPB/MD5w7P2tcSGObBoNMp2Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35fbc1b8-abfd-4864-de54-08dced7728b4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:12:02.0623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1sHMSC/3ApnvUBRQCKRoJjnWSdYoCRttMHOxmhN8qS7CAPhywPT26luAIyzuoc7WDWVRZ/gBoIOKpp017XCL99Pe6HE7syN36HwsLnkVEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160000
X-Proofpoint-ORIG-GUID: _Vpp0qKUr4MXygaDeYxY4W17EdROJJ-R
X-Proofpoint-GUID: _Vpp0qKUr4MXygaDeYxY4W17EdROJJ-R

From: Wengang Wang <wen.gang.wang@oracle.com>

commit 58f880711f2ba53fd5e959875aff5b3bf6d5c32e upstream.

A user with a completely full filesystem experienced an unexpected
shutdown when the filesystem tried to write the superblock during
runtime.
kernel shows the following dmesg:

[    8.176281] XFS (dm-4): Metadata corruption detected at xfs_sb_write_verify+0x60/0x120 [xfs], xfs_sb block 0x0
[    8.177417] XFS (dm-4): Unmount and run xfs_repair
[    8.178016] XFS (dm-4): First 128 bytes of corrupted metadata buffer:
[    8.178703] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00  XFSB............
[    8.179487] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    8.180312] 00000020: cf 12 dc 89 ca 26 45 29 92 e6 e3 8d 3b b8 a2 c3  .....&E)....;...
[    8.181150] 00000030: 00 00 00 00 01 00 00 06 00 00 00 00 00 00 00 80  ................
[    8.182003] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[    8.182004] 00000050: 00 00 00 01 00 64 00 00 00 00 00 04 00 00 00 00  .....d..........
[    8.182004] 00000060: 00 00 64 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..d.............
[    8.182005] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 17 00 00 19  ................
[    8.182008] XFS (dm-4): Corruption of in-memory data detected.  Shutting down filesystem
[    8.182010] XFS (dm-4): Please unmount the filesystem and rectify the problem(s)

When xfs_log_sb writes super block to disk, b_fdblocks is fetched from
m_fdblocks without any lock. As m_fdblocks can experience a positive ->
negative -> positive changing when the FS reaches fullness (see
xfs_mod_fdblocks). So there is a chance that sb_fdblocks is negative, and
because sb_fdblocks is type of unsigned long long, it reads super big.
And sb_fdblocks being bigger than sb_dblocks is a problem during log
recovery, xfs_validate_sb_write() complains.

Fix:
As sb_fdblocks will be re-calculated during mount when lazysbcount is
enabled, We just need to make xfs_validate_sb_write() happy -- make sure
sb_fdblocks is not nenative. This patch also takes care of other percpu
counters in xfs_log_sb.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 59c4804e4d79..424acdd4b0fc 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1031,11 +1031,12 @@ xfs_log_sb(
 	 * and hence we don't need have to update it here.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
-		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
 		mp->m_sb.sb_ifree = min_t(uint64_t,
-				percpu_counter_sum(&mp->m_ifree),
+				percpu_counter_sum_positive(&mp->m_ifree),
 				mp->m_sb.sb_icount);
-		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+		mp->m_sb.sb_fdblocks =
+				percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
-- 
2.39.3

