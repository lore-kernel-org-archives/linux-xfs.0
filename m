Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA024C98;
	Wed, 16 Oct 2024 00:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037507; cv=fail; b=K/8t6mtYnCq83DQ8mfWqVmuKsPY/nG3dPPoOfXSRi+QsWV0Q7lbCEYBZKUHITCM+PnwEFlvx2zD8QVYqSuPgp8pw4e72MllfU1fYe1vI9v0iCbDiXv4eslA23nQ9hjijbES+bz/tWlriQpb8uvnhTxeB/t3oWopf41kNDHATF3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037507; c=relaxed/simple;
	bh=tXbw7aKcafUetUImBYhASRERU2SRiCTUl4Td9+dKIKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PQHIOjey86ShmTYVKzoWILmwq1s1uEsA4enF1SmFstZXyfNbXPggHv/ALRdLuhyNbJMbSSnRlO5j+mUYevyVVGaDyZY9SulJMYZ5tnxRMm6qynSIc2+lsl1QOKOxCEaRacRWurNDZ7cvtGRxMWAo5DpR/twn3TlbHAAg0grf3X8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fhFbuDFx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MC5pZuXp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fhFbuDFx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MC5pZuXp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtecc011676;
	Wed, 16 Oct 2024 00:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=V5WzmjmwsGr5EMT+EBfxs4crY4xFtkfdR3T2is+OkfM=; b=
	fhFbuDFxBmU+oyztvdYyE/Y+IOAz96SxR6CWq0v6XyLjJUE3EW1wY34sQkADEyPG
	f1KRdvqr6NXzeAZ4NL7vS8MduYqZEHvio7Za5I7sOsG1W96QV5UGN7NLocacLpr2
	xWmyHmDzxOVZeHShZ/kMRZDTLC1TNBMAmDsT8HdI4J6RMr5d4TKX+WEo19nHW6CM
	JK4xgRZNnT9QwfV4DgZJRbbH9QyaBRayoztaaYukbS3dTnaL62ACPaEppohrn1Z6
	b/PQ9Kw++Ar9kva5tidKttOb2vZrLKF+e48y6K8Dnr18elVLlb/+ciA5krB7K+Pu
	UVGthrygY4kGscYd/FIIQQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gqt2fny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLhgwE027269;
	Wed, 16 Oct 2024 00:11:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjepym4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HqV9KOVopVFrqco8sCRDr82I7xHqzI010U55P+LeZdl39ltVLClkKCQLbdnn3IOz8orATgY29VMJKK1Y0ISAe09IFjxOEh8N7N/Kod9RBEQ6HZdTuEsz8Ex0PYIfTz4gzP5WOUBZty4qivRu28oE/iJUzxCaPQ9UDOPmKrdWWQvQqy3acUDxzpFwosOZRaf7p8hWPj96lHBXol59JyCuSQgnv9AEM0AOVjOm5iio8q2igL1QcdUM8AFF5irc80JIbJqp9oJoSJ6oNmEAjUJJTaSgU3b3m+jM3ZrmHjqq+KCSmLoEyB8gwWxu9Ay7hvjTuL7Tll4nfdyHYb/YeHJHuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5WzmjmwsGr5EMT+EBfxs4crY4xFtkfdR3T2is+OkfM=;
 b=ZK1lubN0O59GHtSNjcmlpgREu2Wr+zYG5dou4GlXuJpKfJS+98bIchpG/WoW6GGSkDpRwiHTVz+WXK85OK72ie5ebgpPHLGfE6xwkFnpZgsAsVd+ey1DI7KCh/1runnlLv4AoMdSARMyf3Y+sdOADuImf4sxkAzsoLr6egphgkrzNV4v7Z9ghHPGVsxlCveSi4sO97fnRE3l0rQanNAoU+G8pnYzNhcrfm4L3reeYQK5iLqvcN2VVH9AoDZiy9i4sBUrACOp1EcHDyn1ZLk2057MWsartAgaHNofmTBGURENamlcSEsUOra95E2W25D2ztT63w0jacogglZKQuAjEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5WzmjmwsGr5EMT+EBfxs4crY4xFtkfdR3T2is+OkfM=;
 b=MC5pZuXpcD5TajNF5JcD+mXV1QIEYHHNfOw59KMpOW56XESPtj5lazOHg1j9i4ymbDBH0cX49A0RzkU10a09UZYZeMj9ltrsyuqgDYiZd3u5kKhJlf6jsURBTtmdKaAo+/dODgYY0lerJtjaZIOzrDIMpwr0GF+iU0x5TWyUqx0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SN7PR10MB6977.namprd10.prod.outlook.com (2603:10b6:806:344::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:11:40 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:40 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 05/21] xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2
Date: Tue, 15 Oct 2024 17:11:10 -0700
Message-Id: <20241016001126.3256-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SN7PR10MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: bc1af901-7f80-42f2-7be7-08dced771bd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z9dQsCWwqQrFIR37zn041i49Ct9r91tpwVMLUyo4pXTDpI6t2z/ReuACQJri?=
 =?us-ascii?Q?l1++0MOzptTXBBCUTyfEhCDC1CR6TjwV0TQajBp8UVjBocuvUJemLk5mUqwP?=
 =?us-ascii?Q?tfvOZKd4gcwTwRpqpPbHuZNu8tXxdAgj+0ByjeAy3T7n5xmXjEhsLx+rXKoe?=
 =?us-ascii?Q?5NlGwCxlwP1nP3kFOPd604e+64oV7uY5zBgBvTefwyFlUd3S7Co2kMNiNSDL?=
 =?us-ascii?Q?YUYvPQurxYYi0L7ZPD90oeJ7C2AlW7PGBpi9EWylLoUEuUSD6yF5ggUD/QPR?=
 =?us-ascii?Q?xN15pa8rzuYiVuDbNjrx1xAJaYbWuv2G581V8dzD8DE9GHpnlSpKZYucw2GP?=
 =?us-ascii?Q?H0S1lr5asVU2xHCTxex390OZmPS9tgM4fG1NcKhdH2vAfCOw1d5iZS15xKKj?=
 =?us-ascii?Q?+JxQdffoYcm2WtwC98ZbXihqK0O6wJwukZOQy4jj27Vhm1MG0Bvhx4NYl8TG?=
 =?us-ascii?Q?G2FJHWTM7iNiNLMvFXZbfh1kqPHMiOeBWoQby1UtbwTENHdRbloOxnug5RJC?=
 =?us-ascii?Q?u0tVU/y7j+K9jPr1bATm8VSSyJZXrjZz5dUDLldZX+HuANXgJ4mtVxscPgKT?=
 =?us-ascii?Q?LbXrTrfLsMCX5AX7a5DlahsiQxsjcy98pqpdfQMVokPpss4qV7BOpxF653h4?=
 =?us-ascii?Q?cJBoC/GYg0nvuS/tmN25j5m0wyrUzSy4uekQZBAbOU8F92Obz7TYF27h6i8x?=
 =?us-ascii?Q?R4+j+gIFGEmcF+aIe7j2Mx0RvPhUbdYE/x//tXnO2vDliv8PBBZ4kYXNDcaB?=
 =?us-ascii?Q?nGdzvgVFMBX76kVMBUr+wZmLate29iPZCgUI7VASg5APmItqBVZ8iAUoJ0Gx?=
 =?us-ascii?Q?HFbYKwSPPmA0ds1ANKHHnofiaWEKSN/1OTDO391M6B72RwPxZHZy44qsg1vx?=
 =?us-ascii?Q?DSlNHpoRwpmhHLyqxMrNMYoPuKMWRAzq/HBzeCRbSKUsmqdBfYvqDzy7ELUl?=
 =?us-ascii?Q?H21EsDKX3KTULALjPEPUAyCANTIHTkupWK3Ibgfhna2YSKhBGzWUpEDtcgUC?=
 =?us-ascii?Q?itbc9g1+99QJN/eAW5PufA5qszQRMFzaPNZsehLT9LQNX5fd0LtZH3yQHFUw?=
 =?us-ascii?Q?lzmLBrvgT0f1tUM+exAeFmCq8gtCai75laA35y6D+1OWBSwdCPa29jXODF/Z?=
 =?us-ascii?Q?obQFp+3hA+hEAMu8NeWhxlWw4GpUBswTd/oXRzwgKqTwD7W5A0i9ZoZZYC5N?=
 =?us-ascii?Q?KYrY7aL/0/CM80YNCubmdi7drjgeqxlww5OaHmbAjZSWVa+D4DQ4qleFx3SO?=
 =?us-ascii?Q?HY+oTeQTthfxDwvtHB81a0OaZHPjXJvprb4SxClg1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e4xqupXf/xtVMD8bK8FSt5U+wDKEStX4CNbQTR+90/acb/tlThr43XbkUzd4?=
 =?us-ascii?Q?JCgsTtgNhujbT4Z0lXEbnLI7Iw3Qp5+4Ub5H5nl8iQVQ3jMvxRYY23f4n/jK?=
 =?us-ascii?Q?KdkZKuMjGDXnByRO7l+HdllAWwfCDBZnjyA1bqqgKtyu+9piHMtp45ojTc+F?=
 =?us-ascii?Q?5Cg6twIgVYb4xU2r2PMrCv1eMFsxC6pUDvjMpotLGveYETqKCXpCeUGmYKI1?=
 =?us-ascii?Q?HWEgjLe9H+vDQHkBY1ErO75/HCkC22Uve8VFeIqOqFGZJKHHiNy8ufhv75ko?=
 =?us-ascii?Q?bFe5It6HHdeIAouC8T25oKpec1UCcDwzLguszR++rRgBzuZ6oxB1dGL3nHxh?=
 =?us-ascii?Q?1v6xVdRyTp2Cvkn9jtPgkT3crMGE4/rOM3fUDoa+3zu7gd8ReKa/jDHhK5Qw?=
 =?us-ascii?Q?gd/1lH18rybDN3+OkymxoG6T983p950uqw9KsLyWw0HyKAhdOUkiIV+9X6lg?=
 =?us-ascii?Q?OwUi3cDCwWDURyzwHqbUo9HEPI9qDXbuSTdP+Uo6i9EzQbrNjWaCy1usiRnv?=
 =?us-ascii?Q?S2XJ3T5BPq/X0Iu/ew2YSUL5q4S7zNL3UFBmX5j3xffOFwY6fvHNaETQBtoB?=
 =?us-ascii?Q?Ogj3T/THig7vMZF+1C92ijcq9YQl06tI+p9hBzlv1+CPFA9XywiE2KTuBVY4?=
 =?us-ascii?Q?sTH1MNqZxgCDOyOclHS/POYlNbjl3RI1HZl+3X98P+oyT3F9X6K4OUNRbfui?=
 =?us-ascii?Q?TWqPou+Z61yAM+4JZnefiL+PesE1TckSHfvfeQZEWJkLSjwTkcpQCo8duL1i?=
 =?us-ascii?Q?LVWEEans4Xr4ty0XM02Y0pUqAdpexk3hpKzwBKsBNVfElPG0TZKnhmo67BTt?=
 =?us-ascii?Q?qjX9+6kMZtBQB0Lu/oycHcvizr4m17zpPf2UQeZ/7eAdBRmMVkRextkCc4eT?=
 =?us-ascii?Q?DmD6VZ5hShUBSzX3kSWK1UD66n75ruZNXgH1SaW1OuzPxMC9wG4hHt9dSUze?=
 =?us-ascii?Q?AozDKQwQI7/3SWwrsD1OL/2pSoEvoRbLLHmWBpYjcdOch6pbhV17ponwT8lo?=
 =?us-ascii?Q?UKXXSgBUMPfLYRlTIY0AG6XWSWie3daA9zdRPudM4B1rnLuBczsGoB8nzVtg?=
 =?us-ascii?Q?9s7C/Vgcrjxwp+uQuvXEOsY43zzrzM3YlcQjMFhv0ybXy9pJovKYq9qSiO2s?=
 =?us-ascii?Q?oDZdfxLQrNz5odf9UU+hV6SvEHLJtgirFS8Qlb5ihB2pDUJ9rILanYGB8nJ3?=
 =?us-ascii?Q?j8O99apUBB5Fg+NhmMRuwetkhewRl/MrXMZ0D9tHoF7ZQEkc+CBaoMy246d7?=
 =?us-ascii?Q?ipxss/hP3jXvIFivQaIWZ612FwHGm4YQUc8SwjDvqwWvw4zqNriWQODuBVhB?=
 =?us-ascii?Q?xOeR5CWvEO/AA5hJ9F9V6MPGSE4TNyhM828E47INE2Z2Lk7V6++UR3/yyDZS?=
 =?us-ascii?Q?9IgTkcjKM5QQKFXTkwJIQmwGswwwxj/OWbIz9OrRPJzp9iPJxmhO7uZ9qKK/?=
 =?us-ascii?Q?uZiJ9I2ZPj4bBNvPXF3qVBnWxpaFavpSYL25V0kS6wA9x3On/AF7vLBAkkmL?=
 =?us-ascii?Q?0awt+pctRkCR5fO/3N9JG/9EXBuyyph5MMpR0QwXgcxcSp6IGf+1+FxaoyRP?=
 =?us-ascii?Q?oSgc3IkJGgsTM9ZsXP86/MYQGo7NcoemXM5ZrAFUc8H8Eg7QpblMohNNc9ki?=
 =?us-ascii?Q?P5W0asoNFHEOPr6uu19O3lMyZ7UO4/cwWnpURMA8BOrnlQtulV9B4Km7SKSv?=
 =?us-ascii?Q?fACicg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wuPhBrz/HFMkWs1+QAXJ5NBKOudBJ2f7XquLTWkYCIYRpFTP2nQ+3U9epWTGQYCWgWygROHkxlrDXfFj2MwaeA1xdSLNWyTBGJVpNIQlLbasrrkanuNZN9rJEdKlrrsXfpxKuQq36J068BelRJL87Rd4vVhJ2xuj/NDLAMk3ChrthrYGyaizqA6USZRBXkGVljpv4TRl96GOy2J/wVxA/q0nVCU2Vx83D6BHNRxqB8Q8s1M7jYTAH6eis5jhhZBY+kj1IHSdyeaJNtVPplhmADyyavfS5hXBoRMk5kjDQ+HmpAIygGQr+0ZFwD3YSTjb51Ky2xIw3P749kiXk4AKx1fEHP4UegKcuZKqbZ8QiQRMQVZEFa+NK2xNbXoSET1EcZGTSnKi6iNZQOkU9wz9NT3y5G+PtQDjtcsEZ8GrcXP3BCOsQLQb8nXYpHSjqxriug8yS1RYZbYQuvEk0pOJuzaPDbbonhraeh8ziV7L0AOLbh85rCboUkGNQDWiJQIzqG/l0IZEbB9/YKqbsztl7Dc9MyhXbcjHehGzod9FnyIMDplKs9XKc5iHL45WSDyAUXt0nfsIHjYrv86wEVLAdRWPyglNqQHrhR9WWTZs3e0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1af901-7f80-42f2-7be7-08dced771bd7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:40.5370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: spgfCuuFCLKY9TTbbT+O2FNurVZ3ix/K8wAPeuTesiCMUHLSiBJyAnWEV1T8M0JI00jSEia/+DaPu/d+OX042Eh5USrdZX2ZtbzsDwoh6nU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410150158
X-Proofpoint-GUID: IO4drJLBbdD0uhRUZaORmKIe0HNw_67P
X-Proofpoint-ORIG-GUID: IO4drJLBbdD0uhRUZaORmKIe0HNw_67P

From: "Darrick J. Wong" <djwong@kernel.org>

commit ad206ae50eca62836c5460ab5bbf2a6c59a268e7 upstream.

Check that the number of recovered log iovecs is what is expected for
the xattri opcode is expecting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index ebf656aaf301..064cb4fe5df4 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -719,6 +719,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
+	unsigned int			op;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
@@ -737,6 +738,32 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	/* Check the number of log iovecs makes sense for the op code. */
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Log item, attr name */
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
 	/* Validate the attr name */
 	if (item->ri_buf[1].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
-- 
2.39.3

