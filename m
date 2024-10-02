Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1720E1D1747
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890900; cv=fail; b=cB8EV3G/zltTbOh/RZqOZ+JNz1yEft0rMyyONEzT1A/HJIqsATLu7bg4KHeZeNtPJwsGZpxmDGBQ62sqo2FdeYBWsu8sDVMweHyGnkmudWONeonWdv4lcL+QRXbTTpkVemYS8qWOHj9zRPtbFZB6Z+Z/znjvbaRk6pPm7xpx2v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890900; c=relaxed/simple;
	bh=1OFV9iN5b+0ixNonCj5IHEOvOEoapRpl94u8VsJ4TEs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tJelSo858L8+bEKFz6H9SbdB5CXDInMPyVNCdce+x7Vr79FHNvf/e8ACUj8Tg0tjz8U1jJ73518OZgwQUYNMcdimfCmcnvVNZlY4cnfLvIgpp7krZCoCgofn48wxI2EDSQlPxQFfLRxZ2FQ29pxdLnaMMos6tu8WOoMWanth8Io=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CHe7P2Hu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=O9Y3Lbps; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CHe7P2Hu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="O9Y3Lbps"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492Hfax5027404
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=HcPmlUOKVP2YRDMye9Q8kLU7L6SZftb2eFQPkvprW7s=; b=
	CHe7P2Hu+cCDDp3zfVx6YAqQUrkKDR/i7/lMh2eY+tE2duBteU5w4w7rhkkY4AkU
	JgqhcIf+jiRHHGOtox1Aq9CEbpROl4Ysgt6+s5CTX8ntQ1PQ0a8t0k5QHAketoP6
	ssNhtslcIdMcErKuJIs8WWWU6nEtriR8TsasQ+p6tBXYeFGFIDPHX9DmngW0TCKo
	SNnBwZKvd5/PxrIrP21qomKVxB72Bace4HQBWjju+S6iE7rBLk2CD4RUlRX1QB58
	0Tz/pOhqmXFcYPFT9DRBBLmLjM7qTYNvdnhYLIM7Vs4t0nF7h5r6AZPmi28YWW2Q
	CqNyBEWiLvlJQ9ez7KnWqA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x87da9ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GskhQ012527
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:30 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x888xg8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/SNOE1/vudf2RrRku9ay6qJv3xV/+O1g5bvLGFDtbXo0zeiWvU32jG9FbE9Vsd2CFoxUntrVEhYqZPn4uBZFIf/qzAy4qbykxD+LAWHd7hRvpFo5B6M+u+F+fQlH//ePk95NqV5BqxmVNo/V1M8cfVVqXmA+SnpAyfA+h0BmQmV9PaSxkD3LYudwQRTUwhnAhsqYaBmM0NiI9cglyzwHjsxxJdVtfm9kHgohxNIg4mZVeZVxhV7enN+/e/0a7gIKM8BnaURqqBTmzcKLQr3SCOfIXTUgI4bpOfUuz7oZjcqCPM26nKPOd0BVPUxttD5XzKOcoJ6yaSpSagC3Hex/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HcPmlUOKVP2YRDMye9Q8kLU7L6SZftb2eFQPkvprW7s=;
 b=xUWo8OU2eOW3XMxOIcXcvpsmFmPLxKzAB9/8wo6l/QBFmPKa083HhdpDBf8SONTpWE8oZ375G9XlYlLZgvHdUpUL4aaAujD2gBeUPjlPP051ZxcdTO7V2TOhFmjyklRBOzZ+fmBFRf9VJTHrHd3s+IDVGtpg87ovaYn6DVd+PNgEG5rGqC3uli8K0SgETKRfE9gJ+MZHBRR5uJXnNqq8mV5kZaGYKX/W+xbzng8OyqSGSXFWbiO2FHX/K+mi+859YLN4GtKyvTAHvxthwzvU8JKBd5day+7W1jHVbwWAmW+VexcebClLKUtz0bGoJqiyM3pc/Y1uUVQ/4c0zAQOY9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcPmlUOKVP2YRDMye9Q8kLU7L6SZftb2eFQPkvprW7s=;
 b=O9Y3LbpsP/5V8mLiOJi/akTW1tOIQIHVeMJG6keg9Zvx3nLuOrgE6qZvRbs4/DE46M0EFjOOIXDwVIRdfUyToXwduYUlzAoHQwGsrmRFC/8EQQRYd9Ba0TuPvxeqx6mG4Z1yB6tLDlvRtJtxxSt0bVB0E5ou+8LTfOvu1lb5Kec=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:28 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:28 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 09/21] xfs: enforce one namespace per attribute
Date: Wed,  2 Oct 2024 10:40:56 -0700
Message-Id: <20241002174108.64615-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::32) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: a1118040-2930-4653-039e-08dce3097204
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sx8jasY59ZpNlmyxVSc0AWgVPLhc3+iwpUNyhRyGcWTsm3+TzqNMkNrFz+XU?=
 =?us-ascii?Q?FOCyyPhGULxrgjnN4IdkEEMbl7rGWSMTNbKqQbwj2ri85jZE8pLB3/TSQCps?=
 =?us-ascii?Q?LU3byj65VLhSVu13hbhjfFOvD7xKEN1vMsl8C0FB3jTWdXWwRf0FYF/0cFW3?=
 =?us-ascii?Q?HGK1vQ8PFkwEy+rZxsObn6UyspttYm/2PJpqjO5VuTdqVVtc8Ryd+XDmeuB1?=
 =?us-ascii?Q?VHytu1BLfCaFo0M0I1y5cdL7QDGeBnsdXgkPG0UZCLKZ1io1W0fXkEILdjwJ?=
 =?us-ascii?Q?7PPPBGySJ44DepNB+J0bPNM+sOvGdVcec0Yja0HbejapV0G4v1zhGxzJ9ud7?=
 =?us-ascii?Q?G7SJV7aFlOg/SYqnCTj4Zbk7VydhatPKLiSPAJST438wg5yeF814wuVm/ATX?=
 =?us-ascii?Q?nUofA81tit9fiUs+R5FGf7CGyGh1cTkEWFnL/sdjS+Y63pyXWRbm9UVmpyNW?=
 =?us-ascii?Q?xI3oWNh2Zh5N/wshkz7qs0o1/buzjkpCzvYUFgAw0Xs3aB+QiRGWB+JaRzqV?=
 =?us-ascii?Q?9wXFs3lV4l/pmJKYaZ5QaT0NcPCMrgKg1RVvh3AEp7Mgw9rJV/3CfE5tr7SS?=
 =?us-ascii?Q?ORwwPtqC3IOePqPNFEgCkchZHj+zHKyLJGaK+/9W+lN3pYKzXfI6tug0KaU3?=
 =?us-ascii?Q?xTICXktt/iSSy6yFdXL5nVDwOiCNMyOM7lLK0M+20Z+jWlyBqP1grezaIMu5?=
 =?us-ascii?Q?zcc7LzqG7oRKWLJVvqmhJD/spWlFbLAX0wPoEIb/VHJL7fK0MvuB3Axb+MNi?=
 =?us-ascii?Q?dANvmyUIok1F2IFNHled82cq5KFHa3PcSjnrxeijK7bE0sPRz39AUR3EjN00?=
 =?us-ascii?Q?lrFjH+kPtAf7rxSwU0w9ufBIv3jPHODSKI34afkzbSvpLdAJYW9V11xBWM1d?=
 =?us-ascii?Q?aqLSbWQxmi9B0iAUIK2NNLBCD+fowUoR3pGYTfDbgzfSH5QDPyKDdl9CY+vA?=
 =?us-ascii?Q?0gxy7zhYr0AqACSADPFdr9TjgfXSAahHXF2tIEKRkpMsYm3H96d8lE1Qech+?=
 =?us-ascii?Q?kpbbItssVNEl9m73bWgkOh4Kjxfjyykf8d9WvgnoUUjxW5UQAYRiLzMbZ8lQ?=
 =?us-ascii?Q?nfMiZ8lCQeuwB9GBP+z+efth+Q61OdpyMLHhfNl+Xm6tJc6b9KR6DUwL16aB?=
 =?us-ascii?Q?fkjBkQZIyzPRphnCx4wU9y2d3xcIq/PKK7KVpvg/scVrqVOmzSWsfmwc9nc7?=
 =?us-ascii?Q?SfvxtJ0WNAF9GDq9lNVneNG0g+/axxaUGJoxEPKcXfq8zXx55YqupmAtviQG?=
 =?us-ascii?Q?26VBI3z5TJGxQAvfRvS58GQVD4zYVwxqSHotYCiMeQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VVtO0VZ5CdnQFdzRTYZ83JJxoZvXedi7gcSsz7/KGz3FbHBNBRcTNo7Nwt0l?=
 =?us-ascii?Q?eKnojCkJJQufA2kGhw7Rsz1QSIoULtP3oZmczfCgVUzR3J4YwV/XEjpr1B67?=
 =?us-ascii?Q?W110ZwcjQUEh7XWmICw3GR1qXfnVsjs+8MYy5Jlyc5BcYDk4c0aPWvGkYowN?=
 =?us-ascii?Q?8Ps1J09kaIYQkb5e5IrZJ/rbTKxV0wVJtqoQzPUY54aN6/ZHa5bcbWYxeqJI?=
 =?us-ascii?Q?kW8voPGLkMEJuaxxSOJADBgju1juZb4YGcVwulHcXCuoCDA+wk0845OXznrg?=
 =?us-ascii?Q?wKUOIUsLQKIezdFI+7nC3nslyCX8i/gU0raqGdcYMOr3r1qpuNe2jzCkgsRo?=
 =?us-ascii?Q?AfNxE+xT8EnArAlg77mhSJ5hruBsbtQ+hrv/ZOiNTAi3qxiVvR33Qe9YZApA?=
 =?us-ascii?Q?16HoLOXgYZi9oD+CU+V90XYSLoCMN5H81f3ogpNtbYvNKCTofr4yXpXGPBTt?=
 =?us-ascii?Q?Pv8QyMJ23+tyGufSTCiGLJlPhMVXPEEO6RXnIPVoMTwXkhIjNq5Egb1J/87t?=
 =?us-ascii?Q?+XoeXphrk0HGpu+zZIeUDOOvL5zyQ9fBK8R66bH2NHd203Tsn/8MpAG6fFOn?=
 =?us-ascii?Q?tR5hMla2CNJzYqz32LKGw6nNpOsPuBipapqB3roPPy/bD/urMQV1YfKpLe+u?=
 =?us-ascii?Q?3hiOk1zHnn2fawK6RU6HRBFrCupLKnZr0h6Ih00mbVbWCnB2/zVO1b8ycaNA?=
 =?us-ascii?Q?hJlH/I1CV8IUDpDXnvic4rI4UJI6lZmpxPB/LfImfbe5JkdwdOF6VD5Uwvw7?=
 =?us-ascii?Q?O2qMyGc1bbr6wU898WaRqhSfRmxGtmW5ihIH15SxFTMIrIhLO16qhytQGrBF?=
 =?us-ascii?Q?LmSFKW5KDTSNcBJY1D+d3iyP5cBLlemNI3AR2cao6ItxqjwugQ/mKYhZJDdk?=
 =?us-ascii?Q?TimcII84qn/D+onrHwO/w9/n2nZ5WJtwb321FpSzhcKi2DXe9NPt3jC9fM/f?=
 =?us-ascii?Q?fjT6Dt7Q4yHhv0adx97UTo9ge+5RuhbSM/rGfGUZiRbmX+xGoEj94S4Unp+o?=
 =?us-ascii?Q?1qJiKs8iREShxvLiqDhGdhbhFetlWckrVct0uPS2frGWN9c4D5rYLT5ntkio?=
 =?us-ascii?Q?QR/wYCwnjM2EtcyQzfAt8iwbz4yoCCmQQvqUuGn02wKTpnPvGyL9frkVPxn9?=
 =?us-ascii?Q?z0uxKg6+P11o1WjprB4JzrQpxMBZzo1Ki/l9curza3u2Kb2d0oU6oN5ZjtbJ?=
 =?us-ascii?Q?PI8AxKN4ojGQ8mLxcuyCse/uhM1zgSolmZ10YQVaCyaGDXMVQUaj+m/Ac740?=
 =?us-ascii?Q?1+JZLe21Y4PkBqpt8qRCt5AvCwHk9zHAH0TP/arZkai7/oLwubgLkWl6vPlO?=
 =?us-ascii?Q?fpitbUk/aUxll8r/ERnCaQ8CshtOAiPtLKFYLYJY9MfteABoLVLC1dUaSw8q?=
 =?us-ascii?Q?GykzKKhqPmPvG8LMG4N6Wsp+Z4vK3J7O+79MD3aMr74lxesHkpPU8ug1MeAe?=
 =?us-ascii?Q?sZQwCRrFZaTi0qNOtcw9wHFA5e/K/89Bfh9piZ/dR4jw3OcTXrhmsF3sx1Ht?=
 =?us-ascii?Q?sCSV3prqoJFpb+r8Grw1fXTm2oY0japKfEso7+5Ad1maJBXwdhdpBs7AQZDg?=
 =?us-ascii?Q?UODp2o8MvUuYkxgt3+PLtBZ1DE6n+v/zlKBeeKdR+zjA9BEeInd2heGl70VT?=
 =?us-ascii?Q?VTzK5bi9rtAqEejo8O8G3+BF7WcHaf65zHVMS5RqANoFMIKY6Ythy09f/Nsj?=
 =?us-ascii?Q?bcqi1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jrgG1rWsaWvD1TlyfLPDGttp2YiwupLgmFmMhlcxL5WxdYvh+oyyn/7NuAxQclPp8Aa29EymshC0AiyFxB3qMNV4riRkL09IcPnp6mFNXbvQ/zA1y0CV7JlDvtK50xYwnGLOdzZPRV8vXgzBCJZpBTUfvqspo+lMl5bqodQJRM+yXxV/OFCF/qMbMIHIdNAlBn3psmMbY7XA3sawOJA9KU9W1o/m3bYEp6eCH56t5IlZcNXEHEfUounqO6UOf6R9ku0aHuL4HWK7O+TQGUN7g5I8fBv9tZsSxvr75XHKupgZoFom8TMZ33fkzxo5Ic9/XdQy1xZdTGDMFoTPA+PQwSD3aWc3MHoRr2KdZYADasgZHDvYbbG9jvotWs48Pk/pyN/X/2iZ64GNY7nWlnAC0h1K8P68C385fafsbG2BsLhWDGt/dBBTjQGlP5V3xgQsBp86pnlHIM1sPAEGqLVXFLMvuCBK6YcKOlYErKkOqqzHi6JwUdJ2QO7gNcPBjs5xVb4ktvd9O976fJYhh6MahOMoXc+exYLx0E1OYep5phYIHbntd6vCjsgI0yHrDPXqmsN4NId3WgAw2M17X6rPOtO6/uJUMSkl/D6+SVBwGRI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1118040-2930-4653-039e-08dce3097204
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:28.8274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ASkTFWWsI8v3n+uALCdzaLwznr8fNmBOJ/Fv4t60L27INYxzXQrjDqcIzg+COjkVz81BsAm/98Wo3xNUgNQ38Kx73K90dO9XkYCafRd2V1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2410020127
X-Proofpoint-GUID: yVcIGgYZjm1dMnNERbkGIHa4y9IzwP7t
X-Proofpoint-ORIG-GUID: yVcIGgYZjm1dMnNERbkGIHa4y9IzwP7t

From: "Darrick J. Wong" <djwong@kernel.org>

commit ea0b3e814741fb64e7785b564ea619578058e0b0 upstream.

[backport: fix conflicts due to various xattr refactoring]

Create a standardized helper function to enforce one namespace bit per
extended attribute, and refactor all the open-coded hweight logic.  This
function is not a static inline to avoid porting hassles in userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 11 +++++++++++
 fs/xfs/libxfs/xfs_attr.h      |  4 +++-
 fs/xfs/libxfs/xfs_attr_leaf.c |  6 +++++-
 fs/xfs/scrub/attr.c           | 12 +++++-------
 fs/xfs/xfs_attr_item.c        | 10 ++++++++--
 fs/xfs/xfs_attr_list.c        | 11 +++++++----
 6 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 32d350e97e0f..33edf047e0ad 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1565,12 +1565,23 @@ xfs_attr_node_get(
 	return error;
 }
 
+/* Enforce that there is at most one namespace bit per attr. */
+inline bool xfs_attr_check_namespace(unsigned int attr_flags)
+{
+	return hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) < 2;
+}
+
 /* Returns true if the attribute entry name is valid. */
 bool
 xfs_attr_namecheck(
+	unsigned int	attr_flags,
 	const void	*name,
 	size_t		length)
 {
+	/* Only one namespace bit allowed. */
+	if (!xfs_attr_check_namespace(attr_flags))
+		return false;
+
 	/*
 	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
 	 * out, so use >= for the length check.
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..c877f05e3cd1 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,9 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_check_namespace(unsigned int attr_flags);
+bool xfs_attr_namecheck(unsigned int attr_flags, const void *name,
+		size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2580ae47209a..51ff44068675 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -984,6 +984,10 @@ xfs_attr_shortform_to_leaf(
 		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
 		nargs.attr_filter = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
+		if (!xfs_attr_check_namespace(sfe->flags)) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
@@ -1105,7 +1109,7 @@ xfs_attr_shortform_verify(
 		 * one namespace flag per xattr, so we can just count the
 		 * bits (i.e. hweight) here.
 		 */
-		if (hweight8(sfep->flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		if (!xfs_attr_check_namespace(sfep->flags))
 			return __this_address;
 
 		sfep = next_sfep;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 419968d5f5cb..7cb0af5e34b1 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -193,14 +193,8 @@ xchk_xattr_listent(
 		return;
 	}
 
-	/* Only one namespace bit allowed. */
-	if (hweight32(flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) {
-		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
-		goto fail_xref;
-	}
-
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(flags, name, namelen)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		goto fail_xref;
 	}
@@ -501,6 +495,10 @@ xchk_xattr_rec(
 		xchk_da_set_corrupt(ds, level);
 		return 0;
 	}
+	if (!xfs_attr_check_namespace(ent->flags)) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
 
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = (struct xfs_attr_leaf_name_local *)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 141631b0d64c..df86c9c09720 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -522,6 +522,10 @@ xfs_attri_validate(
 	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
 		return false;
 
+	if (!xfs_attr_check_namespace(attrp->alfi_attr_filter &
+				      XFS_ATTR_NSP_ONDISK_MASK))
+		return false;
+
 	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
@@ -572,7 +576,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(attrp->alfi_attr_filter, nv->name.i_addr,
+				nv->name.i_len))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -772,7 +777,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(attri_formatp->alfi_attr_filter, attr_name,
+				attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..9ee1d7d2ba76 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -82,7 +82,8 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
+					   !xfs_attr_namecheck(sfe->flags,
+							       sfe->nameval,
 							       sfe->namelen)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
@@ -120,7 +121,8 @@ xfs_attr_shortform_list(
 	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 		if (unlikely(
 		    ((char *)sfe < (char *)sf) ||
-		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)))) {
+		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)) ||
+		    !xfs_attr_check_namespace(sfe->flags))) {
 			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, sfe,
@@ -174,7 +176,7 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
+				   !xfs_attr_namecheck(sbp->flags, sbp->name,
 						       sbp->namelen))) {
 			error = -EFSCORRUPTED;
 			goto out;
@@ -465,7 +467,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(entry->flags, name,
+						       namelen)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.39.3

