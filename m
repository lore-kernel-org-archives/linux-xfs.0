Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A67C6E6
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488066; cv=fail; b=nqVq1SQPZvKd70zHP9rJksDUJoMo4wmpRogTQd83AJk+AKPlGyF/YfYM1ie1R7g0U071VukZV1O8aFyMxnJ+lrh1Qyp0dX7buxKx9pvH2naaozlwwZy9Xp7zUtrVUOiEPAg9/P18PV96VfiBDdlUVEdq48LtWWX5KmGY3GXQkt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488066; c=relaxed/simple;
	bh=V/mrKO4/iMUOKK1PYe8q0wwkvsJhO9MrartgigGUEWw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oMrBYq2PpHnkqBpP8SQejp6SDtVlMZHsUOxO3LHxoXiL2seCK591qpaUwjdH9SwsXFaI8F+QDEt334zi0NhZQOJEy1/LhUZ5znb6g9kx993jYVyw5LOJj7spnJTREVbD55JziwFrmYebzOr1yNEOMM4Kjd4zewQtkX6DU0AufY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T/ecXbLj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=argHo+Iw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T/ecXbLj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="argHo+Iw"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BpGG029196
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=j87wi7t0jyXYdH2XMlhSEjqKE9Er+Pf7sNpEKYECBP0=; b=
	T/ecXbLjR3eYkAwyYxZj6eerQBBU/sWFen3PTfC4m6fm2cd+x5IEuRIoD8WuDMkJ
	uy/KA3kDRA28EuVNB7Tb4oWjcnAXmVCzdqCWVkekqFrIR0SHt37LXmZh5UW24F6r
	ITKTW49mFMDIckUvf2BrkE1/XPcqGNlRaEYBJlLvzcgxFXa0iWSFNsh1C0YRVpxR
	LOYiSqpE/hKtE17IYgvYKqO0rgjOQTsF37LJIeIhULk7AJld8m18nLDTmkCqmYH7
	fVye48eemt9VpN5/nhsIZSO+seWnNNP53j2GL9DEHy3Tr3QPCd0eXc7ZUgLYOyMA
	SZdqWsL2mjVdlpMNwIp30g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t2fgbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI0RLPu035386
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f97ycr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i26oDj/beDOg8uGj3lxWh5eeY5X7pY/5K5pRLvwZgSNdM26eSUWvCxKIEcCwD/wIIkAPCwlNzbyOq4Of1XQkzJgcCNuMFPOX8gHmDBdd0Hh69B4GGws1cJvYGBWEUbrXw2WIPgflrug8bFJaAb1A+WqcW475TUyjVJ9eaoyT2+2FQRL9dXG8tpnpDVgAN9BIkNbk1vH7zKTY8mNxOJrNGbyalm8lRDymw+rd0SmazD1FUbsIbEUF6SlcUO6mx//VKy9OM8xEUcSL0WywZBsVEBIQEHSk7zAH6L196xuxEiBobM8KhZIO1AHYPVeo74EY+KlLa4LCjyeN8IS5xgrcVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j87wi7t0jyXYdH2XMlhSEjqKE9Er+Pf7sNpEKYECBP0=;
 b=eje3CW5PiUapX8jmnObEvyqPhI1ol0sbfmvWPeW3HLAufKIk4pbMvVh5/N1qg/4N3Ex0Vosn/CvNqhocopV+OBNFE6Q3sg6W8ENjSYU6BEqQwfRZpiwyLaD7X8j0KjCMpI5rTaH31r153FXcaCh7EUoeeRmN5J0cAXO9YVttqSeWbtfJbo84aHoFOiahG0AlKxhsMPZ2qH7a581E8WmYlgYlNRsJsUwlwG/dXrBK+SRssuWLJmewFzXViki/GW5ARofE5stHeRodpFrbeccqCU1Ul6ua28JLGjU8n16mEzw/4VlZM0MpLxOvIzec3N420r+ZXtxHCIWr8qHAsdaVdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j87wi7t0jyXYdH2XMlhSEjqKE9Er+Pf7sNpEKYECBP0=;
 b=argHo+IwgytREHSZVyRZIu2ZMepGmefhqmpZ6B6fj3G7IY4X/WnVAIGmg5J/v878cqOMXztwEihuVBQA2vzAOB3vuaE0yDb8M2JPVSsSW3A46lNxlvrtsKUdRligXY/wgv6BeP05/lLSpkQhcAHCaL1oiRK6VOhZPB9Q9aoZ4Og=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:20 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 04/18] xfs: declare xfs_file.c symbols in xfs_file.h
Date: Tue, 17 Dec 2024 18:13:57 -0800
Message-Id: <20241218021411.42144-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0072.namprd11.prod.outlook.com
 (2603:10b6:a03:80::49) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 290a6838-0280-40f2-5bd8-08dd1f09ae8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aVTfDAoCJG8umwESNUwR6STku9VO8KBLMB4sCAq6VUrwL9C17jj4uz8Drv95?=
 =?us-ascii?Q?XZhNR7jFkLQayo8jcKW/lAW6ZKFmueD6rv+7Rjkse4jVP6itha+rEmwTzqum?=
 =?us-ascii?Q?mHvNJcbL1JSGqKoxTd4GkupB3+LW93tKEoqci1lRNP97xRUfl9CK27GAsmxv?=
 =?us-ascii?Q?nOqX5yhsLzfSAW+bXlZpMG2/yD6Q1HA023CFbYDr2PNe9qH79ZIh5LrHIfmV?=
 =?us-ascii?Q?xCBuy5omsPJS0tyrQ4Cz0TpaTe+a+Byta+ElNmLFUbbGKk/rn9FgmBdZ2IaW?=
 =?us-ascii?Q?/Wl2W86lB44Ymon0PrjPedbGbGjesnF2UvyLd0a7XEcVAKah3bGklgZ/t/Ws?=
 =?us-ascii?Q?b1uGCxv1c+QYjEVNNqCOWt4rOvColfrNS1nlWneKdOC3v1/RtEh+DKLEaNrN?=
 =?us-ascii?Q?CHJzMDRUywOUSnVBoP0oN/jd3Pv7dousV8CPg54/Vts4I8aTvxFgnmpgJNvW?=
 =?us-ascii?Q?BUnzjNdWIA7MKcUmvzdAkS8Ss4BJCgcBLTFL78wkYqzR5wGRooI++Ex/Qt2o?=
 =?us-ascii?Q?jVNpbjJ9jqf7s++od5ko+2uSe6n7TZXNPHw+Fn2ZfUGe2FJt8O5+w8vm61QF?=
 =?us-ascii?Q?bOiI+AbsHAn30HEKWS4dzJmTeSwJAQsZEN3FIg43IT5UB7jkcwbQ17lyPoQA?=
 =?us-ascii?Q?3DoLKfbr9V4i9+iqeRy40/JyGHtOjYEjzZP8KYYiv+lr210LZQ+V9lyYlvp0?=
 =?us-ascii?Q?vlxhZeoEC/6Ni9mJwFEALeP6LYUHbLF07iDM2KEcvBuWnN3gfNYXxToGwCKJ?=
 =?us-ascii?Q?8XbvOFjQX7OdFscoGtiJis6u0lJRaTisYyIV1oRFX51kVPhsIW2Aj2NbdSxx?=
 =?us-ascii?Q?Wh/6IyEay+FKBF/hLHus5tXnygp/pK0vpGyBMHCDO75Od8vcPF9M0JMyOLTS?=
 =?us-ascii?Q?hD4+xNbJNmQ73apm6S3TMsPdgdjBPcf9bTayFYyeXZFAlI+zCVGD64QYdeL3?=
 =?us-ascii?Q?Oen8JMtfX9YqoX+GZ+Q/UMOmJmJyWjODLXKUOOTCpfwJeR97fcvB+UZpb5Lm?=
 =?us-ascii?Q?1r0PRzdNvWNKnmyGvcyVZbgaFwjYi8Gp+coepUrPDO3Wg2rT3lXwvPJGWgsO?=
 =?us-ascii?Q?qAWmTl+hIx51vsEbjBI7zQvX2JoOoK28DsbtdqBlSqjmtYVMMByGnedSqOFV?=
 =?us-ascii?Q?e3xVEY5qbg55ls6coFDS/RbFVqWHVUvmbRo1WBZiWKS0UCzPcFB9xJtvS8bR?=
 =?us-ascii?Q?jXQSZJFxuRqsJKoLcotHrXMVWNxcwur2F6jkznZSAWzQpTAfOrnAeKIwOtW5?=
 =?us-ascii?Q?tf0LnXnyVIeIBnH9nutAPSDdxMJORpCQeoytnrxX2hG3wHbZ8cEc32ffb3Y3?=
 =?us-ascii?Q?gLiVCNQUogcW2+8Unbt8vrdsPTJgn05zbAfji+XHEr3+gCa5GWaTGD31jiFI?=
 =?us-ascii?Q?T7NBytw37GKcE7mIRtfIijHvYZVn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5HqQ7oZLfHCDHqiNICJ7JWNU1Cw6KeumvKxDGLgi3hC366rzvP0zjnpw6dJ/?=
 =?us-ascii?Q?KMJEBV+giWivyqDir5t0gtMthFBJitzpfqjeKaFuYsn8N4h6U8dXPMCCSBZh?=
 =?us-ascii?Q?GVsXp9AXlYQYbePZl+yyk02+F29saG8KaEKqWN1n48gncvFI/DrtVX+U5X73?=
 =?us-ascii?Q?9+Sb2IhEl/fF7yS9EQPJX1JurjPIsPT36TCWarY40o98TlZn9/HmGxubC6kX?=
 =?us-ascii?Q?BL0JRZxgLioHtAm2/ekl0yaPxe0eG6pI2E1EmrEummwqNsibP2Wic+5GeHve?=
 =?us-ascii?Q?mZcaTMECkLNRsRpgk2M+m50KHEOWlDaokOXUNHa4j0ucUPYaWlQbuDmdPZtv?=
 =?us-ascii?Q?Hgwa85VZLaNmDefsPgzxgUq3lIlzh7Q2rpO4/BTrbK7LejD2r2xFwSGfJQ30?=
 =?us-ascii?Q?GyPtewJqwUXfBiuMmYTYb8TbM+sjx2RGTH9pzCY9dQ1T5FGjQKHDGZxwsP/e?=
 =?us-ascii?Q?KlU27jxgIkdIDXXb9/mcPe8IghYKusGUjOzzweVTQYFQQZDbxFbOxO+ve363?=
 =?us-ascii?Q?1NJAMjOfggZ78NscLoZLpOmIfDHFOzaE3Hd3F/RFg6+mpZJypqAQ8dWLv/CC?=
 =?us-ascii?Q?6NapL5rpEyxjXrf4E4LgXDQdEc1oTv+EleijKFMDa0BPmFsRv3ynXNAdHekj?=
 =?us-ascii?Q?AXl1oB8vRjUOz+joRjFS/zsLn+3q11c7wcZuWYOTc4vdrGU1rt6rE0HCejcV?=
 =?us-ascii?Q?wQ1Tf32YMxrG/sUeTr8eRsgUw9pfHMnTXMbfmBx4pYwQx28MlMREGiEkJ/NV?=
 =?us-ascii?Q?5gGLLsK8FFJHUa3cUu59Ix7Y1qV0nHgfOtIMeWJo/GSPekxHWoW/okFyeo0/?=
 =?us-ascii?Q?FDLZ10xgycqw6TYiWnhVoIsvdyIeTYsN/CXoe2zaTtfEhb0lNAxzWk925Efy?=
 =?us-ascii?Q?2AXwQ6of6165EPkm9b7vKeE2fE9ao+kiEqTIeuTM0pYmMIMYeR8/OCPac8rS?=
 =?us-ascii?Q?LucSwaRUIXeFkgpG8iGkRHwkm5ehm3z8VouHgMZQuSTc/+prm9013O7temnv?=
 =?us-ascii?Q?bZWp+j04sYjFYW8thyDAQ84t16CnFvqslU3Oj/IsAbjPd3NRzme9NXHEDBAt?=
 =?us-ascii?Q?UfZ56uusyonCocAq7fBTeq42RY7tfaMTrSwyTetdIDdczSJs52iCubPMBqxI?=
 =?us-ascii?Q?AXwWpM3gpKxiCJASgmB9NaPsJ9xv4xZ1vVYlgdS9avQ/MHBxgypdb8kYj0Mb?=
 =?us-ascii?Q?UYjvtrfkZAmDHca9Rt69hWsqrXD6DjM2dMpY9qW7iU8K+rIkNMR4nP4f8daS?=
 =?us-ascii?Q?8lYTgvu9EdDz/U8af5SVXGyT8VbTDraM281oEt0SyMkzc7Tp50JBgspsv25r?=
 =?us-ascii?Q?u7NqE36ewcrZH5wrt1xSAQK2+fyWHORc0mqEnlT26TYJNqCepfPqqTBySRKT?=
 =?us-ascii?Q?Z2A/ZTCiTFqewCwbX29YzcPagUMg3KgupVgMVlOv36gNHOOK7BEdNQ24CoZp?=
 =?us-ascii?Q?BFVDG3RDdEDGoS4HHJp+MgZjU00vkazPbtepWAGtvmLIUDXcqocomDfOK43J?=
 =?us-ascii?Q?pun/nlcxG+QzmgGsybX4QEHnnE2YKbi3WOPFzSVY7KBHwON2pQqOnhYqSSwH?=
 =?us-ascii?Q?gEO1eMEUKPmJwenPKCPDcDaepnZ6RkBYHpfgKUdCKkp03/C+XrAuONGPSksN?=
 =?us-ascii?Q?gOf28hsYw/GAoAAv3dXmwhF09FhHgvmVh9vxigc82tAlku2E9rLfLErTay22?=
 =?us-ascii?Q?atNA2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h7SSDAw9c24iwQEO0CPrOpIgwVLGPKgAjliv6jIhDNlZ4/q1aeFQpu8wyvC7bw4mbLSbV64G18JldkMCMeeE54yjKJJvxuJ/4koYnbKcFEHtcJXUab1vGI78dcqSoZJfmtSK6QpxQDhOdMO1E0b7fxEDEnXKPCV0GXw/YDer05bZlcZ/pSRyz5cOxVQ+0s1X+bGuedbVorHWkfEN3YE1Asw4mGSprW5FZYo5gHC8ia9m+ztmiElSWIcLIAO1crKoZ1+OIRNpfEnnJeuQPOk6axMBdliin3tXvku8taj8950n/6KXOF80zZ0b5Q9goc69Em3dD6tyuxXQRHnNKKY2Bkztok8mpuHrKecsjh3cHEvMlhQtCa1dBOemDwGbCPM6hxOUMGTl0sTR7YYLp9Ykui7AS6UK78439dZxVnMW/e4Fs8dZPHxNPJaySPz4qL0/iA5uPFh43sNR45CC/igWTJaYwWZYasWcYCxLQt6hBPN4sDmHIPWYIzNng+nto3bs8hRZeK8hJp1pCBa2J1z2gfHsdc7aHOFS9DiP4d8FFowKJUkhH+bdcaOMdE5inScy9Sl8ATywPdD70S9rost5xSp/wTz/19cV4ZRzmhVnrSM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 290a6838-0280-40f2-5bd8-08dd1f09ae8b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:20.1583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cT95hLFJ0JzgfJ1d6QTJP7/n+k1+Rq2TqBNzbGjOldVdZcb2bXgafL/3GaS/H0h3BL8Z0aItdVLJfv/0yOzIWI102OyUXVli2Sr6PyLYj0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-ORIG-GUID: s4DjVPgT6bTSzAR1cE65-gdK0L_L0UOe
X-Proofpoint-GUID: s4DjVPgT6bTSzAR1cE65-gdK0L_L0UOe

From: "Darrick J. Wong" <djwong@kernel.org>

commit 00acb28d96746f78389f23a7b5309a917b45c12f upstream.

[backport: dependency of d3b689d and f23660f]

Move the two public symbols in xfs_file.c to xfs_file.h.  We're about to
add more public symbols in that source file, so let's finally create the
header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_file.h  | 12 ++++++++++++
 fs/xfs/xfs_ioctl.c |  1 +
 fs/xfs/xfs_iops.c  |  1 +
 fs/xfs/xfs_iops.h  |  3 ---
 5 files changed, 15 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e33e5e13b95f..b9b3240a3c1f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -24,6 +24,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_file.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
new file mode 100644
index 000000000000..7d39e3eca56d
--- /dev/null
+++ b/fs/xfs/xfs_file.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_FILE_H__
+#define __XFS_FILE_H__
+
+extern const struct file_operations xfs_file_operations;
+extern const struct file_operations xfs_dir_file_operations;
+
+#endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 535f6d38cdb5..df4bf0d56aad 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -38,6 +38,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_file.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b8ec045708c3..f9466311dfea 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -25,6 +25,7 @@
 #include "xfs_error.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_file.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 7f84a0843b24..52d6d510a21d 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -8,9 +8,6 @@
 
 struct xfs_inode;
 
-extern const struct file_operations xfs_file_operations;
-extern const struct file_operations xfs_dir_file_operations;
-
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
 int xfs_vn_setattr_size(struct mnt_idmap *idmap,
-- 
2.39.3

