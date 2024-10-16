Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DF95221;
	Wed, 16 Oct 2024 00:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037505; cv=fail; b=AxVFVlci6A+/lnGASjocpBSwN34jMySSahIkV2F8Cr9DK2HLy8GJqyQeV20T8RPgXjchAWT1ArkerOG8n6Gw9ldYsy238XYDUWC4Sk7Iujp37AZNz3JzTVRbHLftnvAqA4wjbv9xdTojQXO4pShECECeIe4rQ+sA0SDQkPK/Jcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037505; c=relaxed/simple;
	bh=umly7riNLcdDqdBRU/PaCgb1KsxMQrTiKgZltORBLmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=njJNJitk54VPSf6DwFycNSPpBCTeepWFpQVtKuIm9X6ql1lKOxPYznIKDeXCT6Df0qcjm9TMTN7oRwNxsxVLQkHnUjVuMmBetlOJiGo2gMudwtmewUf8jabcU8v5nnUF9qNYDhNsPvIfFmZQ85dI/l8WMhyJHXaQ3YqV2YIB0Rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bvmjAp3N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OZz7whws; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bvmjAp3N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OZz7whws"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtdOT028914;
	Wed, 16 Oct 2024 00:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=11hVGg5L4lvJVHrNcWrLSMRJohPyP0eMmedf5y4VMfU=; b=
	bvmjAp3NxecwQ3wrw7RhspOGc+dTJeKjfvgR1Ax6+CrNtiPcksnUltbet9FNq9Xx
	ENrSBqXyQsPW83fUkR2fs5LE0NsSU61IhPOiYO5EglqRMFvLrJQN4hFDcgYamBXn
	qsq0yKDLf2j1mcwpNR6fPuP0qKn5eaC24VDnCXd2BY8vvXJZMXQpR04Oqds4szM1
	YnAB7RilvCLhAEqVNDQ0t1HdBqjLT+3glOPf3D9mUHq0xj3vkVuCzH0uIor+0+bc
	sLkWOrjcSvt9n/i9TjUiiyD7iFqNwiPm7aWfRCLaj/VIwuZrBMqKj51J7kjUKBtO
	USrZt2Cycub1XfD5NYz8rA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427fw2jk3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FMxP27035993;
	Wed, 16 Oct 2024 00:11:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjegwq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QPtRIPLW4yqw59Kmzd2+4Xyxa/E5j1e0tXNBMop6wh8gPS8tpthe53M6jPrZnlCVbwZiyGJEwf2x1curR3Oo8xLJvjVkHyfcQTV38MxaNtl50MQ9Wj83u04rv9L2Q7CtVkbjjfAe6X8Y72u4Xmutnt5XO+Jouipcis3Bnb9UG45ie7FzlEMWXG23NOtI0iId7B5yBGLtImtNs5/MkxIXrz3pT2qhsrJkRmO/tDuRT17hJAizPff5WEzExC1jnWeusKXvDAY32EfwBHSemE2J0rRlFRojsVCmnmSj4J+01zkdKiyo7vt5mQFBPuUerO1mGW8NcZq4ocPk/RHytOEb0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11hVGg5L4lvJVHrNcWrLSMRJohPyP0eMmedf5y4VMfU=;
 b=Tb/8c6HsAXPRinrr2QIXcmSjLDSGMXELx86O4IVEAOUy5KWChWLUjazrsjXs3sjr2EoXjKjTVki0A/We5jjqF311NHOwRtoLCvS1FaSEhQlAVog7aZe4BGyfJtAZziYr2PbAvjVAeejNxRvabeiVSkwgl48JuzJkShhXhgrjAl03PzJQXABKqvd2DPV8tYQ2CPwQYproB+c9I6Fx5fOvzr/5ntVRKdMGJMogZ0i6Pe5s2JZidNXn1ayH/z5oMbMHbWGWASvUEC24X8MIvTwRifGHqMqd/iPytnoc6380PuR9pD9+vWDoTCmIvPjC1JJ7rj5/3x3ofLVO5GzrLXBZtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11hVGg5L4lvJVHrNcWrLSMRJohPyP0eMmedf5y4VMfU=;
 b=OZz7whwsT/I5t3FnDYFuVwSNKDpSpURP3lWGgzzIMPpqGL9Y2HVxVPMCk6xDHZjMqkivPqorVIxlUTLddlBTCklaz1i/hEexBRpij6F76lbjZbTAVUF2acnTTsswa9ejrKaCFQwJoecQJlpg3uPAyqaYXT/1bMqYjBDl6XhfIhw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SN7PR10MB6977.namprd10.prod.outlook.com (2603:10b6:806:344::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:11:38 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:38 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 04/21] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item recovery
Date: Tue, 15 Oct 2024 17:11:09 -0700
Message-Id: <20241016001126.3256-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SN7PR10MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: dbaff427-078e-4432-e093-08dced771acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?frW6snPAh1hfi0EwL9oo10uPROqG38Yqy3xDu5KA5ErE/rNzCab0H8dvd8ml?=
 =?us-ascii?Q?EMZH2DaOa/1CDMqanBOQhgMNz7FTRGNz2FCnHo6crEDtcB/nrANXSHDbFMNX?=
 =?us-ascii?Q?4AhYZfq6/sJpdHYIe7rff/J1JllzvW71M/r8yfSIblq4FDdFK8hy1dcUNeB8?=
 =?us-ascii?Q?EX7iojwaUPY6R8bW8xH3GqC2lnfRzBcFneDTEJXmFldk45MVDR2owfB4/Knz?=
 =?us-ascii?Q?PyVtxp04qhI+AK25wdJURgKDGeYnaSB+A4Dv3C9xPqR8fD7ShMvTILck1GO6?=
 =?us-ascii?Q?PoTMv5qQOPvwWKbdyMN3PAENhSQ0jTql0BG4pLdB7q0igOKF5nu0/YXSWz+O?=
 =?us-ascii?Q?oL3ptTv6gP0Vv96tNUUXPGzh/6AZ4/3hRZABpuc9uOUSs9oY92qf8+7nExlh?=
 =?us-ascii?Q?RyRVlXIwqKkd/aUeecKgwHYpA7K246y0vyhltfAq/qsMXM8njvnw3GYz0vS/?=
 =?us-ascii?Q?ra2tHhJ/YcrCg8CucTVY/m6f/JQ+3T7Lb2I0O4P+qSeQiivTT1NtMM35QhjY?=
 =?us-ascii?Q?44w7fGP1Vrf6c4PKHtIzv7uhdNGC6i+aPBERkVPLh/8rTLPyFaK0bpy0Rsxl?=
 =?us-ascii?Q?OLusu8vKLdOW3hXEYI81c62FzBEfpcw7cqbgA2RDkScnm5AnWx21kphC+ijv?=
 =?us-ascii?Q?USOzLNGBdwuEwHSCLMYEj9XSXCAPuD08NPg3v5wuhzp++ye5IzvzkZoYFdwC?=
 =?us-ascii?Q?PqOtYJ1Rsijwm9QTS5IaSHv6M1DgIapgKnEih1rbf4hk+gbMJ1gYutvbQNRs?=
 =?us-ascii?Q?WjgfjGdyjpJZg02bo0ZxnF/eskZSgrR78zx1IaVJkEPQetKLG3Oc3/+7GcfU?=
 =?us-ascii?Q?7WuoSlx7BMf3i10Wp0qwBEhHhFgdf+Wc7PQ3aJ5y9iMH4ovN5EyB4KycDj+1?=
 =?us-ascii?Q?thqGhEf6CBbb0eQDina1AVw51mlt6syqAq5qodGVzFd5M9f7k/tAJOO80AEh?=
 =?us-ascii?Q?crnfubjA0cLWIKs438me7Z0djs4czSPE40biKmkj+/OApA9fHly2+HpcAdsL?=
 =?us-ascii?Q?tIuQ7X/DjaCZ7orrE/1+xwly7dTpBKzp1t1KGblqK1NUzevJfdYiF1beakXK?=
 =?us-ascii?Q?OSQ+oXzgEugQZis+OroqqWyqZNkziMJa/9Izw6QezhZWq4w394GOmPQjqJmX?=
 =?us-ascii?Q?Dy47+QOgoi3sU/1jRMc8a98oBN8ERjXUATh4Eua87iijfHiuxelxsuV2Bnu4?=
 =?us-ascii?Q?mSjJid5gvUi/hkuVgKWg605rWgv0p9N0hT4YJFupfj0ncezjalVEc2Mo6ydC?=
 =?us-ascii?Q?CGJxjU3R0d7PgA1Jj/VCNgMCZdtpfSzTe3XxTakbSg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RvEC4QTzAI00yPFSlAfqeco7WDpzRlZGLLVFDXR/eNptKXMHhw6Pv+/3k0XP?=
 =?us-ascii?Q?NwrCEOBekF8kOM0Y+wK7iUgNm5QSUeAnlAt3Otdjlu1lGJbSMKgYUHg2OoYp?=
 =?us-ascii?Q?wj5QkdWDFaLQbl7bIHN81jpjLKrizmLacRB648RA1gryBcx4+AEyARD9eq5r?=
 =?us-ascii?Q?vQXq+x2GECtmiK8rPZlcpfNp/0LbVAxoyobjLU1qhGJWcIDYp8FRwfBZ4WQE?=
 =?us-ascii?Q?pE1mgWpzLRDQaqS3Eag9zwfbLYOcIpKNKGLkTHkcJGVXoJLdHPoI7I5wev4a?=
 =?us-ascii?Q?dI3Gs73k/nxJbroB42Qr/jn91iZCzzTL6OQpB/xKtPco5zKhQQMxyma5+qen?=
 =?us-ascii?Q?+52rSrWvbrEbdlINaVPkGuK4fDoVLqGqfEgMqQQxTs2U1mZzmZCEhqBK4OP9?=
 =?us-ascii?Q?x8q+0OUzDUaaTj4AcihxCfuki6aKA81L+OBfWZj26GkKVxhECo9lp4gCR0cx?=
 =?us-ascii?Q?tLJT1eXlwpeTBOsxiwhuWJTsI3TPRttYDggB/P2wUAUKn7TBYl0RgohBm6aL?=
 =?us-ascii?Q?SxRRl1LjYpvmOGdNMmIpNk0rpfYzTck9jCPaPY3mWtJFPpguI9401hwcOA5N?=
 =?us-ascii?Q?hLsZwv4SgvB+HDTq3nIJRmI+NmXH+ptM5Wr/Z0UxIsQ5/EqV6+1xbaayEdVV?=
 =?us-ascii?Q?uJFMDVhrNq7ZDVWYUTHCMaukgD4mSfX1kgWYiR9N29Cc5QLURngMAas/MzUk?=
 =?us-ascii?Q?1Fh2dVgWAw10nTAXqOJp2iY482QN1TR/dAjNE5f6srSAxe634TLdj/xWp6AN?=
 =?us-ascii?Q?lioSkh2HbR5OeZokqKRAN/P2OF9ivm2CPSGfZbAbOzF93TpVvotYVJucsj2N?=
 =?us-ascii?Q?TyROF4idlJpvQq0/PdLr0RuoLDXtavdFnJ9/pCuFjpOKpr/M0InQzRP9r5AL?=
 =?us-ascii?Q?SDJrvTPHWtIMoaLgC2XeYH92RBSbWckz++o5MGOKyEfgyu1i/OmBe5h0CQQW?=
 =?us-ascii?Q?sR+HaWxYOIzVC53W2UYgWETKm8UsfIhXi9+bnd1OVwhvnkmynqM/3liwfpJZ?=
 =?us-ascii?Q?YAcnmomnCU1YiRIhpExizkh6JmGyscIb8U1dhdkozjElkGJ8EUPb74vUgn43?=
 =?us-ascii?Q?+x6k4WOF3so/20nnbZ5TYdnB+XbH/PG9uXBFbPoVPbyxTuatpKQORARsJ+nN?=
 =?us-ascii?Q?rhYW4xa6HL/jYc7mFppSa0Ill/hVDqUNT8e1U/wveC5glpdeL1QZY8LnHen/?=
 =?us-ascii?Q?zn8Gj/68nkHo4SbI80XYbuzaIQAaso3vpmB0hSAw3jFVkFwOwZFoIubte0sc?=
 =?us-ascii?Q?9UxLMf+bhilzXF8BsHSDUU4UL6qqJtThp5iP/5T8e8IGTIzkjOUKU/e+Ljm8?=
 =?us-ascii?Q?g3S6TzjGZVdouNuORd+KkHydt0cB+M1IqV3xI2Fd1NaOdY0E0QobQTPDkOEE?=
 =?us-ascii?Q?wmbJe8EJ4yP6hiprVXMTPv9kYcK9/ZPpVPARqSenPgMmrQNLNJGBh/zwecEC?=
 =?us-ascii?Q?mmarJlweokc32Rv66M2pWchFvZoRpux/5wmwqqre5DU1/mExjaFqJPBO1hB1?=
 =?us-ascii?Q?Ok4uMCV5rskrrWmosFJ1hCh1aghxaU06Ng28R8EirI9xVYEuVAAb17n9i7DL?=
 =?us-ascii?Q?aZ2N/YNgRwGaVbI+K0bJLxDdA1p6Ajkxhz3eo5Cpl+QYi97reB2urfVL0Cs4?=
 =?us-ascii?Q?87LtJL1ZUgSoe3ma3JNu+M4oj5LedmFu1HvcnlcY6munz2LCiDtT/S4mFjJK?=
 =?us-ascii?Q?dv/cWg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NEgw+7nhtVHV8t8+ePJ8rIHR9E0/n+4lFLQ1vt1s6ykZLHsA/QyS+T6WEpizlEETQCH65oAI/lkOL0qdfR98tggBIjxTlj0a5GGe7Nobuel7jVKoQBbziqb/5xnj8g7AyqFGu2bzLCG9+YPqBDvoQyxlJVnBUMb1Tpnp+Hs1OGPTbNVrudVZXvXeaWWq+4TnLnMX7bgHWnm756rTjBWYVFpOmKXHUlopqVPRp6AdptNDrJfU/Ra+KxhUak7Fm6fsPydfmnPFzsH3wDfMhDdR+BMxBUVJ7B7+q9DfV0QJEA8wafbx9ckm0eYKgTzw0HpAVApis3HXVqRJUa/n0OxSo6DCt2KtmCqBbrGntnXOaXW5bS+joU7dOzjwoUuaAYymSAFryT1ZwIAkmHrCjv4GBzzaZkT4DTZ7d3tlsS0oxE/P9kXfkHK1PjLHm+zqmj7WRctf5/3PA1krrZBnNeOnEkx0wFu/4ZTWRHet30DDsAINhYDmlMH77LUqWiaSEiHhfs1MngKKGWC7pvgigEao40yi0DzXOGDBhzf66Ezj48NTV2Bt0oEJZ7NMjgNkTDvPepDm1pU5TaRT2zGp7GYo8ERk6qWyi7CD/XGZfl5NBDM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbaff427-078e-4432-e093-08dced771acb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:38.7604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpdXurnibUulsiHAtMb4FR196T2y7KMBDzvqk2+gtMMIcjuqoSCQE3xdGJysGFhXx+UP4baSFCo9tmAT13VbB+bxZtnYll5ghPJSXXEMegk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-GUID: GC6sdNJSJa2tZtdacwt8pFeDHmKA4N3Q
X-Proofpoint-ORIG-GUID: GC6sdNJSJa2tZtdacwt8pFeDHmKA4N3Q

From: "Darrick J. Wong" <djwong@kernel.org>

commit 8ef1d96a985e4dc07ffbd71bd7fc5604a80cc644 upstream.

The XFS_SB_FEAT_INCOMPAT_LOG_XATTRS feature bit protects a filesystem
from old kernels that do not know how to recover extended attribute log
intent items.  Make this check mandatory instead of a debugging assert.

Fixes: fd920008784ea ("xfs: Set up infrastructure for log attribute replay")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 82775e9537df..ebf656aaf301 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -510,6 +510,9 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return false;
+
 	if (attrp->__pad != 0)
 		return false;
 
@@ -602,8 +605,6 @@ xfs_attri_item_recover(
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
 
-	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
-
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-- 
2.39.3

