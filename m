Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E39D3E557D;
	Tue, 13 Oct 2026 09:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884434; cv=fail; b=BjxBJoF5QJZVJ012fs3QyssoI7xlHmk6oszgMjO8I+4pWNnrGwCj/46ac6/o1Pgr/ee23yUWXg9cq4EkM2SnX61ZiZCq6bEsejJUjUmckkWJ6o7bry0LlNpDfYlD/Nr7cA26BKKfsK/OrwS4HuHqCaeJGcCCBLBJuNogaavqGsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884434; c=relaxed/simple;
	bh=zXhJWAnX75K/0XuhOWAYhD6mk2mxubLB2IPjoBglScU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Evul83tjXZRQ2PZ1ngqHp3b1WyaPRbYhJsxEWpM0GPyeGCKEKZIbdVlK2Z7ADmoVNHxPt+o+6aMWBPv4yOnBDX18kvVPXhFW6oTIIFvi7TdSLAVoQlfmDP4NFZWghKT1zC4y0n4/p79oRWL4wpnz5GpGEj5FJ1lykcV702qRG3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aQf+uePm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N4ZXs/j3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aQf+uePm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N4ZXs/j3"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bv2g1440009;
	Tue, 13 Oct 2026 09:40:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ezaQnKvqm7xcjnDZVC9xHX3XnPUA1xb17uZikLAJ3GA=; b=
	aQf+uePmZk5fA3HOoHob5d+K2SI5PXRbjLELKYOex1VU+0VnFQN79ANKwy3ffem0
	4BkhZbkWeqPiVZd6y9AHBVGt256p/JDs09h6xPYCbvJxFhr7jhT8YEruSW0meBn5
	fKr/3Mss54zKjSHGvite2mUc56SVdnw+AcNv6pwJpaBSAWGYqqBgl99TLdIOlzaz
	vAs4U8U1dBQxOn0EPL9FU+qmpRycFkh2jD4Jxw/pcs0lJFLHofREyZDCBCe8hSDm
	RVRMxA4An/qQm9JGJ3PQsVCoHNRllT+P04DZeKVlwEB1e062+pP0SCgwHX8nqZdT
	8UFOORebKvNavOfcGxG41Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uppr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9ag2Z002217;
	Tue, 13 Oct 2026 09:40:28 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013049.outbound.protection.outlook.com [40.93.201.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjuux9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y4ymRcKO8iLyG0QgM7NDch/A+COLhA08zeDi0OxnLbPj39R2YhNp8FIcLba14fFxEGeKEh9EkIPEOWo6UwqhL6+1hllsuFzVjSp+VEFsRY6u2csm3Ki/gqdaXBzhUP6++uFJ9azHwcC3UTSOAcmgJjb9uzZ41VJpsffmBZbgwcLV3NkNLpur8jiGQiU6SEKkmDZ67RYqxPrixBMAd+xQSjqLH1gpznELqrgtXcNGfuty6oq04H5pz7JWbjt/Y4tyU23pxHNb8Sp69YJY9iisCrEHEBPjw3pNALJpEyQTymk2ttuQlRyzGhRcoeYgcPwxD6RB3uo7Fhw7h1VhhD3uBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezaQnKvqm7xcjnDZVC9xHX3XnPUA1xb17uZikLAJ3GA=;
 b=k6ISGGPaog0FoTEWpdLpv87rvFOyIsHauF79UkED7zRDkqn/7tOezm6nkdtQJ4EXTFnNYVqmrU1SiJCePLHUOSzGMhBUijET686PqiIEbPlixG6aF8hZZqxxCFe3X3B9mAZ1Q2up8ZVWGlnzUrVwQPvCCzeGRTEQ9/zUS7HdUCJKg4Q61k84qRlhOcAopnRWJIAixypELZ/M1xSPzyqT8/xcQMGHf1sZzm/L7F6pKsVtmCvI8Z81I8mtYwaiTQVaFlwoSben5lbctznt8oQqUv0B8SSnZKZQUcVg3gnmUdlRd9syUiEFDqpKxCMuksiE7loUQJIgDIKCOpxYi9mwHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezaQnKvqm7xcjnDZVC9xHX3XnPUA1xb17uZikLAJ3GA=;
 b=N4ZXs/j3w//hWDs43/Ws+R/yevUE3PzYmnXZ4PGVnAPI+gMRm3WQK7AIYGU9anmyD7Xwpkm06XVntdoMS3+35C8rO0fUp68H8IWSDPHlQ04mtrSyGRoJtef3DnyzDC2ms0rOQecs3zKOIadajfoMKuUT+h5dpL4w5eUC1SxpQWQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:40:24 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:24 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 06/19] xfs: improve the code that checks recovered refcount intent items
Date: Tue, 13 Oct 2026 15:09:35 +0530
Message-ID: <04db2d87da8ad8e18498372e680325b3c3fe9aac.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN4PR01CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26c::6) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: 3615417c-24e1-4313-2d8a-08df290e0140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|23010399003|56012099006|22082099003|18002099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	GQj1cUZTaDabtNJEmIo3+CDJUw+xZmP11O8CeanBZRy4sKaV9RWmSSfh/a8t9E4WUp02EYcKRgz0WhC7kt80H3MqI0X2j/vxM1rN/DP+3bmAPkGwCyT2XTQD/BvjEzrBQPuCOKa97Cdg3hsw+yMwXAQAZKlTsPGv5FOELAcMkiMpmhCd7Yja1alduVxUE5tE/MzPkwhr5IDX4FDbbO0V2hj2g4BqGZaEnwo/nle9L6nEPm3zxnIU59P8qPXzuXJrURwefRnTxab2Dmd5E3UaHZ9dl+DAJbepbJyGFZ7qSYQiO6EG0Z7IOqb8ltZFCUH0mNM83pyju92P2RUBlaEQeL14M1mdGaEKBQIo+brgzp8yMuvU4ATLzxlSGZC4NQ5UnilO2FhS4IZxj1m0PvGUuMTPuMgZkGlY21ii8zYXao2gYOt1Gctj7QUheKFQrEfaXaoYSw3kjOxT5fGOJrqxP4RMm36eDpCEAh1qC3/dh10ILvXCMfd46jbyxnDJ+k4rAnBA003DUWGtREyAOfNLpxNB+2nX/2C78ZtIuTqrKPav5S2zXYTQUNVY+wF/WPyUBYYsouJxte9uffwOJuwFvXJw7D8UTV/5xoKBR+fh3/fN55j9BJeWy1LFotq+jqRRoQXjGDSvuIlVoldGB2ds9lQyqf48/9io9cQKcljiSZo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(23010399003)(56012099006)(22082099003)(18002099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tqsxjGamYpraLQ+Cp2tUnx2PaZoE5aYeqKtDB7dkBHW9tSYDHaPRBtfjPxHT?=
 =?us-ascii?Q?JBFdvMvS7RLuBzAFwNg3q0UXr4AsqBY6WXAq3Z0X91R2Gy96PjEYprF5DcVr?=
 =?us-ascii?Q?y6Sx0hsmDea9E9INfh6f1gcFYngMNpKG66wwr/Y/JiaUBaifHQr6brI8T3H2?=
 =?us-ascii?Q?VjsUuCw3VVsCXX/9qg48DpOcxVVLfgauXcNFRXMyIgWG+fVRyzMI6tSYZkQZ?=
 =?us-ascii?Q?C/apOmbg+TL55Qsu55maRkUmaHGoI074q5PLmsgs6O4A4s+7rzemD580cI3A?=
 =?us-ascii?Q?f5DzMMsafTkIT/3ai8oTVesp5o0FTN0U1CQ4BFt3tE4tr0IN7ju0ay6lNEut?=
 =?us-ascii?Q?RRSEI6yJbHxNbsYOnuV1kctkuuux9hSa2sWvXt9YR5InPeWCK8qlf5AwfTyt?=
 =?us-ascii?Q?2pisXdPR6CsLJ/pfVMvH3fhvBn2xLc7RqFbBdSzTEm76OjD9WJ2DPZPfaDyU?=
 =?us-ascii?Q?L1424DjPiBJNQl8U5Er9wR7NxNbbGkR5d5xPo++A96U8sX1dJPSBRzfQkAHK?=
 =?us-ascii?Q?cdTJhE13Vjn0hDClI7/xE9QnAoOgY/I8pFnrQBUUnH8M2bJjw5dE0R1qoxsb?=
 =?us-ascii?Q?2mQoON7SB5E4WMFpf1agEv3ekhejF1jGM+kjOuy+XUj2jSVvRMllvuYy+NyL?=
 =?us-ascii?Q?EQd6jo/F27fPah3zh7vaGRTcJazOxyqV/Kc0mQa6rMsMypPo6upfVFQznh1T?=
 =?us-ascii?Q?OkQVCmd2DsDZEyB3aqmCuZt3+PYNVfH/jFhvXDhww4CR2SKg111FPu/pjn9H?=
 =?us-ascii?Q?roj4A28BnGgkVijPieiY2f5xxHtkNXlVVuRS+d4I7VilohpfldNFGjhw7P3x?=
 =?us-ascii?Q?p2V+IbZuArDi6hyNnD6jPVZWAJCZsbeAcOTIwTy+FkTChz25VyTR+MNsf9TR?=
 =?us-ascii?Q?t7ZRld9MWOOUAWJ4NkSftjBNlO/OyWbja9I0JdJCWSiODaESMrayJW7o0hFC?=
 =?us-ascii?Q?dJ785/Ydk8mdz5qPLl+Iym2qCcREnDuth+UN36fdGaVWbKwGuxkW69W6MNjR?=
 =?us-ascii?Q?+61g0G3uClg0IObNgb2D0ay2IDKKXy53rwSumY8M5e/UiI2KsPSEJBEsr2/x?=
 =?us-ascii?Q?UB9VyjEWeKkwBdmmX5LFcrH+a9cXavPVFAlERTjBBn/iNmT1LzVJbxGpUyEC?=
 =?us-ascii?Q?pBIcijAnWCm37zI6dPAY5xCsXlX02k0Gkak+0RFp3byPNy3rEtxq3CUTnBpj?=
 =?us-ascii?Q?d0g/mcKTNQzPEfzdOO2W0OsK6RI7VxOgJ0F2Ogx1V2sGi/8/psnm092SyOg1?=
 =?us-ascii?Q?aqCZ+2zdt6uq9L3K0qEVSnSVp9zGlq6wUnoKNWTM9H86gPTWb01cG0OhQc1O?=
 =?us-ascii?Q?RnQsDlkWoDb/HTYnHJ+TFmympDEX2ZZNRWiOqy6qu5sAX1pRJ/esLLRc2htt?=
 =?us-ascii?Q?ALqB/aM3nVj/5f6CbqBtjQ/6xy4kS00kL/Y1z2iSNijhBtmTuvCJ8bfhGqJl?=
 =?us-ascii?Q?7geMOh/AhUQ1rJGJvTc5GtBQxwudmxC8UDLlPup5krS2MDch2zxi6G2gnDj7?=
 =?us-ascii?Q?k4vOsmvzh0ea85+kkTzdsG6RQ2QpLozU2G0xiw7XfVLRBdF4NRekkeaTBV+g?=
 =?us-ascii?Q?lLONVCyJhWAr1GmgK3hxJY6QWb+mknuxfI15mL0jUD9uSGe28AWwrOIgHCT6?=
 =?us-ascii?Q?aqs5U5DOt/fXRKBeUg4ozTefREjhzlwFQuho7IbCpntYbLk8QYVPOR5TwMNz?=
 =?us-ascii?Q?HGaQJvWTbgNL6wzhkj5Vh2qEhvtNddfGFAtIG2Io02gKxWeQjCfoxcTh9EO6?=
 =?us-ascii?Q?vGYDYdhrRCj2ntX5GbpSGwU2LUCCXdp9sFMJd6QF17n78oSrbKyMVLuxIPRQ?=
X-MS-Exchange-AntiSpam-MessageData-1: p6OYaByyAYzWIfkykyP3/sX5ps7h9xa9Qlw=
X-Exchange-RoutingPolicyChecked:
	opRF3EfA82/XzLG5+HPabKNyuIA+oevS2sWRsiM0NMW8d58BxUio/znrrMnayLJnSddvKpUvH/zbBHfSo/fSbL0RHrKK9Ga74BN/Jz5fQMTJ85CAfUrU9m57FRSpUgYR9OJa0PRUfkqoaanyTpkrgSaInDjWLHJSQyhpFQM4tRfoZw/Yqg7BoNpK7jax5CISKxsS/sJ9XPHNqujvryBBT1rKyQ92egDA8+DpEjDIXg488QRZ2KiFvtD3m//Ueo5Wxh1tQ46YVrrcUxzoREauPO8de7hGvVTRpwavtwYT6Q/+HmGhEdfho+fNVneIdkj7CPAeU/tl9SK6Aa9OpJv2dQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aWYaqEAEeWNmLsMS9Fl2ETnbt6IlCyEW1FO1AGOd76OSeTgUPeqUnlisex9oHnTXcEEsiZkQdvbC2u42I2SmCcFgTLb3GFfAoimivNdioisGlmd1VFx1CtblEX8Gg12EEuA0eX2lOjwAbRfC+rf0cgaRghMsCn99czkEZdSypPMpCROsu0fT6urWSwnxUdJh78wyOuApQ2MlGAF3S2TDhYioPvFsqJfzMP2R/Nfkf2SNEkR2mrtIsjiAcuCPER/xpfhW6EdX1+jW3u24VUbE+Z2HBbplhp2lP1iZvPPVcZlkqSFdxwecOF5PMyu1SAzzKRaJGwnbwBHjnp9rW58oauj+fynLrkrjP2sfH5U74SCy7pDtxr1UnTnI5FOn/mKSMV3D0aAjX2Q0gL//ZbnODBAO/oFmlYWqgBDwU4eKdlefrDCAARFsi3kachTXMEeanBmtKaLNh4FuWFDX1do/LdFqEuCnHYzkJ4drG/hIi3p/jvLdbwgBcR87OJ2pZPzb7gf3eGtNy/qSIN0wS2lI04Fz7asyMyWSZarACCurxDOUPr0BBWac+kZuv4VutAK3HT5PYSaaMo0p2p1YdHitTn76yW+lYhNrZsTj9iiyTcg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3615417c-24e1-4313-2d8a-08df290e0140
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:24.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RE6McaPMT0f1QuDdnhu734GbgnXjAhhdubKXqENHHpcXaefjdFF1CcsDrTHwcyafurvwuzH/8FDEFhNYFUDFqkzPcDgCnrOvP/JtTbHgyVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acdfc8d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=voHxInD6YWdgVH9rCXkA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX8x2WoU6+uUZr
 c9qlkZuNB0Kd0tZowAOmX9azFDzpjRzYX4iPUx9z+lp3d2ksPt3AMNTKkT/2MWyZfd4pCwKXz8m
 vM4glpLwiL70+jssVTFdITXHNvIkDhRZrA7PN/d54LPixCy3sFAhOZJcoAmR2lKg9Tz8vK/vWta
 k1aA/9Zz8Jzr5KiGc0siiC8eSCsVMxmI3RF3AhfED5MVqCAiGhAggOn9uidA6FUwOuN2gWQ2t+/
 U8B817cMAaRYpgx6jZ5v5ch4XJbnvtArdXiqhG9Zfpv/ivYhFZVN5iZVoVXj96IRP+Ib2Hn/NHu
 GFtZaxBfHYSx+aMPFV1cHAj1pAvIfqKyCyozLUk6OLqNzw8l1w6t9w+Nd+Tm+uL98Q20TqS0b/g
 takVZMNc5+ZJnl8yWbo5qRtMBKcaLQZWIbwn49AZEWegSEG92ZGLonngKE5omXVfgLKINHzlFbL
 8p6EV+nEfqFFEJxxZsl8MgI/EjEKPredHjDQjodo=
X-Proofpoint-ORIG-GUID: vAEoKu6AFxlEUFLizOaFwhcLkPwdj_qA
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXzpXwwQVEj4of
 +YhGwAC5SHyOEQUF7REYdopU3PdABhS3WagzZFFGe5jZ51CJ+5xosNdPqXgBnogp/NlHgjDzIYw
 Ct4NZHuHZpHhT5rzW7NFNaZmcfQ6LVxr/7XF7r409BlgKI4e700i
X-Proofpoint-GUID: vAEoKu6AFxlEUFLizOaFwhcLkPwdj_qA

From: "Darrick J. Wong" <darrick.wong@oracle.com>

The code that validates recovered refcount intent items is kind of a
mess -- it doesn't use the standard xfs type validators, and it doesn't
check for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit 0d79781a1aa6a6a567e63294012eee2384f406f2)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_refcount_item.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 83dddec08f3c..2532a2a1cd59 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -423,27 +423,26 @@ xfs_cui_validate_phys(
 	struct xfs_mount		*mp,
 	struct xfs_phys_extent		*refc)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
 	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
 	case XFS_REFCOUNT_INCREASE:
 	case XFS_REFCOUNT_DECREASE:
 	case XFS_REFCOUNT_ALLOC_COW:
 	case XFS_REFCOUNT_FREE_COW:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return false;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
-	    refc->pe_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    refc->pe_len >= mp->m_sb.sb_agblocks ||
-	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+
+	if (refc->pe_startblock + refc->pe_len <= refc->pe_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, refc->pe_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, refc->pe_startblock + refc->pe_len - 1))
 		return false;
 
 	return true;
-- 
2.53.0

