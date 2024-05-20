Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B96DA929
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 22:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716244930; cv=fail; b=kmTSO6Rt+YLrRqhosh4m8PZeoNO/vLwDGv4ZHgvZf6LezKGoXlFhc11tUqaJ8YaJzC+GbZzmEuCAuxFtnF4jg51DRaDFQdRPxJVsXf+WSUrHHHSV838pqO0M8QQTpcdGXHuFtJ68uj4KMMUAXL5yUarPKQcyNiwZTQh0i4VpPkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716244930; c=relaxed/simple;
	bh=u5k8BavuPZqLr+N9ToU/75NX9RatoguoeZy6v0F4S0Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z/leAM8J912RV0L70xVB8MXUwoaVURRVMwGKOk2BHuzI84og4KXY2Ewf7poIx+9oNzKFOE0yom4hoxeORJhgAsoV1Zz2YVfyugv5XPKKPuJM9t9RyUAE1jBZAJqUF/CSn4MP2dxi88UbkJXKaeQxCq7u9Rsl0hYrX07U8sRJkls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FTdhp2bb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r1EavVt8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FTdhp2bb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r1EavVt8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KL9NnX022979;
	Mon, 20 May 2024 22:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=u5k8BavuPZqLr+N9ToU/75NX9RatoguoeZy6v0F4S0Q=;
 b=FTdhp2bbwOOuJWAtcIqxsUGghjJp1imicnC1A2LFiA4/fVo1bpz/Pe9VNmf4zJO7kF1R
 nQ16UC/PmyfTPkkCAE5IPNYO8RoZS4CdgFJb5eZ/iRTd5AwFmCLRWuBuai1LDH0/kQ2G
 3RnChJyfKkkztSsikk3fBZXLqS8H3WD2j3oJ25zu3EKqLpoB19bhN1ZJxzp9eLjBw/Bh
 m/CRNsgv6hXqCT1FOAz4XVP/gsAXmZGrTGgnPDe7c9nr1XDk9DiLLO5Nu/JHvHY69ngQ
 LPGnYew/RwvA3y8d62WaEYQBJz9huPx/ySEoISgz33Pq1xuxaOAphrwmKl46htwZhDsz Kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k8d3sy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 22:42:05 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44KMPiCm004963;
	Mon, 20 May 2024 22:42:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js72ex9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 22:42:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/UtGmEWRUUhzuBYzU/4UHaRQf+0foiiT1fHG/JtSPMKUQGpWyfLnZibNuNcud39Pt13sIzfKt5ouWvS0PhtHgELC3TOUVjJSi2M4/mCxJ6/k0rZvagJuM/KCWynCLCnEZ07rlb6fW+KDGTn3g21HriFCZNjytuI3jzbFF2pmqFxWFl2hy/UEvSC6KluOyQQoYJlQRJo1kW9hdkLQZ8nxR5zz8NZl+lex9U8La1iE+0L2omzEm+eugLacTzi/zxV+R10NhA2KGQjX2O05BHFKYciT2r3k+bdkO+bFILpDheoWPBSSgJAxeKPB47h0BjaxjQEdrx7EH3cx923zVUqyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5k8BavuPZqLr+N9ToU/75NX9RatoguoeZy6v0F4S0Q=;
 b=Sgiz0eR2C87M33FtoEIXzIKe2GENWDW6vnMdCwSqAePYOeEqYX6KjRh55f52lWOqNpVp6P3ez5mXCXCaK0G6G6BGnrHGefK+Sfs491EACQvCx9UDHZAGIoiwmn76yh2x/ptH7GLBmkdeo/3J6Hh4BTGZp3rYPYQ21zr0KHoFGiCNWiEqAS3GLLjvnAuHzLZSXNwyJGyWbtvZRi03wryTlqs4xsdnF18HHerhcc2EZZxYi3u0f5ga5N58AvXWXUFdfA+SKRfTeHYEH4xwOk6Q3QQuaSOcz4eRtBnA/ZzhnM2kDO9360nl81HURcJ/5utRe3tFiyuQ001XR0SrQPijDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5k8BavuPZqLr+N9ToU/75NX9RatoguoeZy6v0F4S0Q=;
 b=r1EavVt86SZZROiWpEQsRQi+b+ahPvmXGAXbGaAw5i+hbhOfgPldRusyWeXQ8U1GqBSHQMg9eP/36cYpflFbGFUs8d8RA+yvvjPG9QxtvLN77XOwdYPtRFvE0I/8iFWOfnW5uSxtqrpxNlwM2YvrpbegvWdSZ2VrVmvl2UH0orw=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by IA1PR10MB6268.namprd10.prod.outlook.com (2603:10b6:208:3a0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 22:42:02 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 22:42:02 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Thread-Topic: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Thread-Index: AQHaqKDf/Bk+8/H/PUavladS1T7uCbGgcEQAgABMSAA=
Date: Mon, 20 May 2024 22:42:02 +0000
Message-ID: <DA28C74B-7514-48E2-BC86-DA9A9824CDA5@oracle.com>
References: <20240517212621.9394-1-wen.gang.wang@oracle.com>
 <20240520180848.GI25518@frogsfrogsfrogs>
In-Reply-To: <20240520180848.GI25518@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.500.171.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|IA1PR10MB6268:EE_
x-ms-office365-filtering-correlation-id: aa3d2525-7791-4644-d322-08dc791e1117
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?VjVPbzBMTGxrVWVLaGUxUFVCRGpYV0JURXczN2RhYjBSSkR2M09OVVI4RmNn?=
 =?utf-8?B?QnZuQjhUOW1Ga0JKbHl2SGtlejhndkNtZ0pFWmVpUFRKRmllajVhdmkwendR?=
 =?utf-8?B?MUJOK1RROXFjbjRqbmFWZkRWTnNtYjJjSW9ueXh5anpxaXJVVW1Uc1VFYXZM?=
 =?utf-8?B?emlxWHRnbmZvb3hJOVZBSFpFZDJQYW1DaVhqL3MwSzRDYmFqbWN3ZlRNclRm?=
 =?utf-8?B?Y0ZQVm1ZUFRlZEdHcUFKa0ZheE5YTitSUmF2bWJWa25KWlMrR0NWYzY4VXhB?=
 =?utf-8?B?alZrenBWK2VWbk04enI2Y1RoMGpGUnRhZEwySFR4REhiVEF3Y2xWeStudjR3?=
 =?utf-8?B?cmQwN21XQUFNSnZPbkVYM0t2VmpXZ0wrc0dTRnRjSHYwVk9FNWFYWCsva1Qw?=
 =?utf-8?B?QlM1VVIvelZaU21oVzdoTnBDYktmQmwxbW1FZHhwMVo1YWFHVlhIKzBXeXJU?=
 =?utf-8?B?cC9iZ21rR0Z3bUExSzVHUzFaV09qdTRZTWxnc3VwOXRvYzNkak5Oenp4aW1Q?=
 =?utf-8?B?VGlRcG04UkV2ODVuTmlOUHRpTTcvdlhDOFhYN0UyVmZjQUlNR3VhMDJTQTRp?=
 =?utf-8?B?VDdzeFQ3QTNCQlBNK2VMZ0c4Mk80b3lrOHFtMTFLS2pzUThDRHkzNGV0K09N?=
 =?utf-8?B?VFRNaDdEaktoTXhXakxqN2x6QVNlWHNGWVY2emxZUFlvMUV6VWhwZWVnZ0xn?=
 =?utf-8?B?NXNJZURubTVpbitROE9NbjVEemlyOTd0Y2NDYS9YVytNemIrVmsydU0zWG55?=
 =?utf-8?B?UUUzU2N4NWh3akx1RzdvS3VSZzc5U29UbkVONFpKRytybkxqWHY3WS81QW43?=
 =?utf-8?B?N0pUUWhzQkEwamlGcHB4a2xDQlh4eUJaUUh2NmVHZlpTNWpoLzdiTDRvTUtC?=
 =?utf-8?B?VWpSWXp2ek1BZDRrT2RaSUcxS1ZXUWg4QThhVVg5emp5YmZMeEdEZFhXR1NW?=
 =?utf-8?B?VVd0K2VMUjFVSUNPWURWRkk3dW9vb1U0REo3MDNMM1BJTU0xT3VJNzdsNUJV?=
 =?utf-8?B?MHY3Tk8wMmdDOXg1RG9ScHp0cUU2emc5NFBERUIyZE1pY2ZEcWljWGkwemNW?=
 =?utf-8?B?S00xWHNHRmxNbVRYSFh4MVduZ2dvNThQY2VGU3FwRGZ6aDlRSU1mSEl4Rmh4?=
 =?utf-8?B?UEpISkN3cGVXOE9TdThPZUJwSmcrRTU1SzJ5bXFGZ2lJQjhwdGtWdVRZT3Qr?=
 =?utf-8?B?dkxZK3ZndE5KakRoM0lGNjF4M1Q2a1dCVi9QWWhvL2JsVEhEM28rRnZuSTZl?=
 =?utf-8?B?a1h4cDRQVE5na2MxYTVlWTFTRDhXc3VpUFV0N3pCQjJIT2hIellLUnQvTGhv?=
 =?utf-8?B?OFpBSE1hcjM4eHQ0K05SeUFEVkwwZUIya3VjOVRoQnlRY3BFT1VhNll0KzNO?=
 =?utf-8?B?M3g0R3ZqVjQzZzBXOTlzRjQyejM0endCMXJTYzdrYlNQZm5FQ2pkOEZCOUpB?=
 =?utf-8?B?aVAreS9ieVN4bVFzL1RzSlI0VHBMTVZmM3FLYUNVNnBQR2VwbWpJWmJaanBQ?=
 =?utf-8?B?YW5CaE5hRGxtTjR6WmNZNExWQVpRMGpUYXAwUUVhYzBIQzYvQWhqN3lYZ2xH?=
 =?utf-8?B?WFZmUUtlSUVINkx5dUtXL0w1blV0Y2JTUXcyWFJoSHJ4VHpZTVFRSHozUGc1?=
 =?utf-8?B?UUU5R2dFZWc3VHBpZi9ZSjVrMm00bzJENXQyUDBmS01xMmx3Ty8yU2VYcWFC?=
 =?utf-8?B?NFlUOTJvVkphZWc5MWYwc3NzUlU1TDJDQS9xaDlldU1MOEk4RkYycXJlUHRz?=
 =?utf-8?B?TGhzYkxqNWpnelNOUnlIS3dBeitxVDJ2WFpTVzV1SXBvNlNTckNLcndvblZW?=
 =?utf-8?B?c0tmUS8wUkh4SFVKa2V5UT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?V0NudlcxenBTYVc0V2pJNDBUZndlZkhIMFFuSVhLcEY5SlRzRWJtcFNxK3Zu?=
 =?utf-8?B?d2ZQbzJWaU5qZGtCUTRaVEh3NGtTSnJCckg4M2Q1UnlrNE1HUURCVVY3Ym5L?=
 =?utf-8?B?cXNKcGFTUC9uK2JtNlAxUzJsUHN6NlpzYTZPMm1WSjRtbEpBa242ZzFjRlhY?=
 =?utf-8?B?OWNNemRiY29ndWNKY09vQWdKN3RTMVBOd2FxcXBIb2NHWW5DVS9nc284MklI?=
 =?utf-8?B?cW9kd2d2bmFxQ0kzdHdWYmFLOTQ1ektyY1dLbFNGaUQ2akVCSER2WUw3cFAw?=
 =?utf-8?B?aTlrLzdHUnpLV01TdS9GUTNaSHZEaHl4Q0FEQXFsY3BETE9kY3JCd1pPa0xS?=
 =?utf-8?B?dUw3RVgxa1M2ZmFaeXYzeXhibGx3d3h6ZS9kY3VKS3ZPQU1TeUVuWGlqYlBH?=
 =?utf-8?B?VStQV2gxOG53NTUrZ1JyNmVEcDF6MHcrSU5TRGt0cDYwbFpUVnlwOVF2S1Vl?=
 =?utf-8?B?WHJ0NmF2aXdieDVCa3NHbEFMMk9KdmZoVnJhbHBwNFFrbUhnY0ZSb3ZvSWVp?=
 =?utf-8?B?N1gzVXY4ZThuVmQ1SGFScjh2NFo4TzMxcEdKZElEcDJvdXV4T1M3L1I2NXVy?=
 =?utf-8?B?bWlkN3VCM1E1ZkpOZFg5ZVZ1aFNjWDAxUXJEVEgwcmRKcWpOZkMwblV1S3ZE?=
 =?utf-8?B?alU0MTdyckFrTmVnSDY3d1hLVXlnaTFFY3dENjRQWElEdEVtSEN5SHdSaE1s?=
 =?utf-8?B?U0lCSkxIQ2owa09rL0dadDlMTEM4MWFEUFpMeU1LS0p2MUcvN3VrbzN1SXQ2?=
 =?utf-8?B?SmRWWVRuREp1emVlVjd5V2lLM3NkV3grbEM2Z3oxMUNuN2JNMHpra0F3QWJt?=
 =?utf-8?B?bDNyeEd6UDVhNGkvTzBGemVWLzgyU3YrRFdMVUl6WE44ZW5nK3Y5L1AwcVRo?=
 =?utf-8?B?MUplNElnaDdtejc4RW1wZWlZMzREZ1p4ZUg2YlNuQUYxTEIvTDdrL3BHTlQy?=
 =?utf-8?B?QUhRc01ZR2NFb1ZYaDRWNHpZc1Z0UURFT09nWmJlOHFqc2c1N2lQWDBjcEli?=
 =?utf-8?B?REFaSVpHNkRQUzZSTkUrUTVRYnlwZDJ3RDRHRkNPRCtFZ2lwcEtBblBqbVNX?=
 =?utf-8?B?azNoTnFPczNNTnZsbXpVNE5qS21RYzlYN0RLSEo1Wm1qVHdTYThKckR4K0s2?=
 =?utf-8?B?a2NOc09sdlBiSHNIZmNlR1lsalFVcmZnOGdYanBmZ201eXlJWlJHOGZ5bUhh?=
 =?utf-8?B?KzUyVDVlTXJhQTJGeHROb0wzZE9obDB6UHB6N0JxMFRRUlFNZDJINjY5NEFm?=
 =?utf-8?B?Z3d2WmNLL1BEQ3FvTkllNHBNaW1HODhmZlI4dW5mUEVuVGVWK1ZRSG5KVUVi?=
 =?utf-8?B?S2NkbXVLeGVEYmlwK004bEFKdkwrdHpMdmpWV0lIQVk4Y1R2cyttOHpMK2Ri?=
 =?utf-8?B?eTV6U084VkpvMTk1WEpIUEhTR0w3L21NVHkyN0NSMGxxQU5pOU5ac0lTTENi?=
 =?utf-8?B?eHJuTEJpbWZObjlzRXNESmV3V1d4WUFpK3BFRmxNc25YUjZQdmpqbzBSR21y?=
 =?utf-8?B?cGo2SUR3KzFVdEE4VjVqVHNUYk1TdE9lTVlhK290ZEh4NytFS3ljTkxMdUt0?=
 =?utf-8?B?YSt0U3daZ25pNUxtS1ZsNXdnQ0FzS09GYlgyVjFYdkF1aGh6THdKdGlkQm1P?=
 =?utf-8?B?ZDFvRDRJS0dETzZTSjlmdXRhNWZjWTJiRVU4Qm1mR1NOZHFHY2lEZzRIcjU2?=
 =?utf-8?B?SUJOdTFkSXZCblhBdjhCdW1oanFSbWcrWm5QT1dPSWNzMXVzYVdsRS9weHdO?=
 =?utf-8?B?WU1ZWDJsVkF5YzNqcUd3YVNNUGpjTlRNVDlaM0U2WU0wR3V5cFZEZFpWZFRX?=
 =?utf-8?B?VThvOG9JWmtFQUpSR2k0NUlRajErVjQxUDVQQzhwRXZUOXNFWHB0VXZIS2VI?=
 =?utf-8?B?WWMvNVVRak1RY042clFtOXg4dlF1a1NhRkZ2UkNLMkQzWTN1cGFwZjBRM3BC?=
 =?utf-8?B?NjgvNGhaNXdjOW81VWFqSUlWZCtFMnh3amZYa0lSOUErZ1FGM1JjUCtpS0lS?=
 =?utf-8?B?UUxLQzByNlhSWERvWnJxVVc0UVNIbWlwalhWUHQrQ1FXWVNITWpyRE5QbFh3?=
 =?utf-8?B?WTR4Vk56TmxHL1pkR2RvSkw5SldJL1BraGl5VmhXZThCNkVFSHQ5V3psdWdK?=
 =?utf-8?B?c2p5R29SVGM2bE4xMVlJQ1p4MndTblFoQWR5ajZFa3QrM25mWENRK2hobi9a?=
 =?utf-8?B?aTF2eXhiZGdOSTh6MkVmd0ZHM0JvaFNoR1JlQXFkOGdrdWI1MU1qb3lKSjNa?=
 =?utf-8?B?RkRoTGYreFNBRnNNdEcwekF0a2d3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC00FC7C46A1CA4FB52AE9838B166B9A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	THz2aGq1ryfbOzS64/U3ceIG+uWf6w7RM+CW6Z8WQnKKMvrSjqwjlqyeF0jPMH1a7n2Izm7xE973t3hrB98mTzpSRWlYQmM/OB4JUZ36IfRTkRtmqVxf1hNVMMBhmr/uxySC4Gq/+6ZmteGTAedhRhzqu0NzHeMHvpPrKT64vCY5e//obgrKCPRueSGKjcXQFID0qrlZ3cu20v23wjh1c6nIQUw5Dms27NaSiN9rn62FtFqcqTOJB03M2X/8ptMAOlnu/3pJ2wA0+0audB7T+Ils43/XIUZ6EHfX6+jncmkOaihWSsMGtJ/E9kGEhkZIqU6Q96IlnrLR3XC8pe6KgLg58aqBoegC2gKEiRMfihMqdOQ5iAWPwZXbPttlt3gjHJDhCrKelFJ5uoCpTAEySagzSD13/8wMouGA40QEi2oWSg7UbG0cTxbYeMfnArh/Y2csI1BXW7mGp/+fgjAjPDYylbdvVyuhXh1f9KYd3RitCz5RK3toUy8rLiwjiRH8YeSMQ/oKFmIaLUHc2mXSkH0tDaBL44Jwtavr4X58zA1SlBLU70JHqaRrOXgyGMyeLQb53nBPGaHSF480MqhP3HnERME5BUcaThPAwt5IUxE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3d2525-7791-4644-d322-08dc791e1117
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 22:42:02.2236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6f13vKjQEQLwi/0CmUqX5eVAeqzD5G671Z6VBOAhohx+TsJf/FvKaYMbHU/uiY5Y9QFcUxzDTFOhzBAPZQ0Zk6Ip1AqxKUxKqfLma1oIQA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6268
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-20_12,2024-05-17_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405200180
X-Proofpoint-GUID: peJ2GV2b1N2Nlv336WYHxpyyivkBp4B6
X-Proofpoint-ORIG-GUID: peJ2GV2b1N2Nlv336WYHxpyyivkBp4B6

VGhhbmtzIERhcnJpY2sgZm9yIHJldmlldywgcGxzIHNlZSBpbmxpbmVzOg0KDQo+IE9uIE1heSAy
MCwgMjAyNCwgYXQgMTE6MDjigK9BTSwgRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9y
Zz4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIE1heSAxNywgMjAyNCBhdCAwMjoyNjoyMVBNIC0wNzAw
LCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBVbnNoYXJpbmcgYmxvY2tzIGlzIGltcGxlbWVudGVk
IGJ5IGRvaW5nIENvVyB0byB0aG9zZSBibG9ja3MuIFRoYXQgaGFzIGEgc2lkZQ0KPj4gZWZmZWN0
IHRoYXQgc29tZSBuZXcgYWxsb2NhdGQgYmxvY2tzIHJlbWFpbiBpbiBpbm9kZSBDb3cgZm9yay4g
QXMgdW5zaGFyaW5nIGJsb2Nrcw0KPiANCj4gICAgICAgICAgICAgICAgICAgICAgIGFsbG9jYXRl
ZA0KPiANCj4+IGhhcyBubyBoaW50IHRoYXQgZnV0dXJlIHdyaXRlcyB3b3VsZCBsaWtlIGNvbWUg
dG8gdGhlIGJsb2NrcyB0aGF0IGZvbGxvdyB0aGUNCj4+IHVuc2hhcmVkIG9uZXMsIHRoZSBleHRy
YSBibG9ja3MgaW4gQ293IGZvcmsgaXMgbWVhbmluZ2xlc3MuDQo+PiANCj4+IFRoaXMgcGF0Y2gg
bWFrZXMgdGhhdCBubyBuZXcgYmxvY2tzIGNhdXNlZCBieSB1bnNoYXJlIHJlbWFpbiBpbiBDb3cg
Zm9yay4NCj4+IFRoZSBjaGFuZ2UgaW4geGZzX2dldF9leHRzel9oaW50KCkgbWFrZXMgdGhlIG5l
dyBibG9ja3MgaGF2ZSBtb3JlIGNoYW5nZSB0byBiZQ0KPj4gY29udGlndXJvdXMgaW4gdW5zaGFy
ZSBwYXRoIHdoZW4gdGhlcmUgYXJlIG11bHRpcGxlIGV4dGVudHMgdG8gdW5zaGFyZS4NCj4gDQo+
ICBjb250aWd1b3VzDQo+IA0KU29ycnkgZm9yIHR5cG9zLg0KDQo+IEFoYSwgc28geW91J3JlIHRy
eWluZyB0byBjb21iYXQgZnJhZ21lbnRhdGlvbiBieSBtYWtpbmcgdW5zaGFyZSB1c2UNCj4gZGVs
YXllZCBhbGxvY2F0aW9uIHNvIHRoYXQgd2UgdHJ5IHRvIGFsbG9jYXRlIG9uZSBiaWcgZXh0ZW50
IGFsbCBhdCBvbmNlDQo+IGluc3RlYWQgb2YgZG9pbmcgdGhpcyBwaWVjZSBieSBwaWVjZS4gIE9y
IG1heWJlIHlvdSBhbHNvIGRvbid0IHdhbnQNCj4gdW5zaGFyZSB0byBwcmVhbGxvY2F0ZSBjb3cg
ZXh0ZW50cyBiZXlvbmQgdGhlIHJhbmdlIHJlcXVlc3RlZD8NCj4gDQoNClllcywgVGhlIG1haW4g
cHVycG9zZSBpcyBmb3IgdGhlIGxhdGVyIChhdm9pZCBwcmVhbGxvY2F0aW5nIGJleW9uZCkuIFRo
ZSBwYXRjaA0KYWxzbyBtYWtlcyB1bnNoYXJlIHVzZSBkZWxheWVkIGFsbG9jYXRpb24gZm9yIGJp
Z2dlciBleHRlbnQuDQoNCg0KPj4gU2lnbmVkLW9mZi1ieTogV2VuZ2FuZyBXYW5nIDx3ZW4uZ2Fu
Zy53YW5nQG9yYWNsZS5jb20+DQo+PiAtLS0NCj4+IGZzL3hmcy94ZnNfaW5vZGUuYyAgIHwgMTcg
KysrKysrKysrKysrKysrKw0KPj4gZnMveGZzL3hmc19pbm9kZS5oICAgfCA0OCArKysrKysrKysr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4gZnMveGZzL3hmc19yZWZsaW5r
LmMgfCAgNyArKysrKy0tDQo+PiAzIGZpbGVzIGNoYW5nZWQsIDQ3IGluc2VydGlvbnMoKyksIDI1
IGRlbGV0aW9ucygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19pbm9kZS5jIGIv
ZnMveGZzL3hmc19pbm9kZS5jDQo+PiBpbmRleCBkNTViNDJiMjQ4MGQuLmFkZTk0NWM4ZDc4MyAx
MDA2NDQNCj4+IC0tLSBhL2ZzL3hmcy94ZnNfaW5vZGUuYw0KPj4gKysrIGIvZnMveGZzL3hmc19p
bm9kZS5jDQo+PiBAQCAtNTgsNiArNTgsMTUgQEAgeGZzX2dldF9leHRzel9oaW50KA0KPj4gICov
DQo+PiBpZiAoeGZzX2lzX2Fsd2F5c19jb3dfaW5vZGUoaXApKQ0KPj4gcmV0dXJuIDA7DQo+PiAr
DQo+PiArIC8qDQo+PiArICAqIGxldCB4ZnNfYnVmZmVyZWRfd3JpdGVfaW9tYXBfYmVnaW4oKSBk
byBkZWxheWVkIGFsbG9jYXRpb24NCj4+ICsgICogaW4gdW5zaGFyZSBwYXRoIHNvIHRoYXQgdGhl
IG5ldyBibG9ja3MgaGF2ZSBtb3JlIGNoYW5jZSB0bw0KPj4gKyAgKiBiZSBjb250aWd1cm91cw0K
Pj4gKyAgKi8NCj4+ICsgaWYgKHhmc19pZmxhZ3NfdGVzdChpcCwgWEZTX0lVTlNIQVJFKSkNCj4+
ICsgcmV0dXJuIDA7DQo+IA0KPiBXaGF0IGlmIHRoZSBpbm9kZSBpcyBhIHJlYWx0aW1lIGZpbGU/
ICBXaWxsIHRoaXMgd29yayB3aXRoIHRoZSBydA0KPiBkZWxhbGxvYyBzdXBwb3J0IGNvbWluZyBv
bmxpbmUgaW4gNi4xMD8NCg0KVGhpcyBYRlNfSVVOU0hBUkUgaXMgbm90IHNldCBpbiB4ZnNfcmVm
bGlua191bnNoYXJlKCkgZm9yIHJ0IGlub2Rlcy4gDQpTbyBydCBpbm9kZXMgd2lsbCBrZWVwIGN1
cnJlbnQgYmVoYXZpb3IuDQogDQo+IA0KPj4gKw0KPj4gaWYgKChpcC0+aV9kaWZsYWdzICYgWEZT
X0RJRkxBR19FWFRTSVpFKSAmJiBpcC0+aV9leHRzaXplKQ0KPj4gcmV0dXJuIGlwLT5pX2V4dHNp
emU7DQo+PiBpZiAoWEZTX0lTX1JFQUxUSU1FX0lOT0RFKGlwKSkNCj4+IEBAIC03Nyw2ICs4Niwx
NCBAQCB4ZnNfZ2V0X2Nvd2V4dHN6X2hpbnQoDQo+PiB7DQo+PiB4ZnNfZXh0bGVuX3QgYSwgYjsN
Cj4+IA0KPj4gKyAvKg0KPj4gKyAgKiBpbiB1bnNoYXJlIHBhdGgsIGFsbG9jYXRlIGV4YWN0bHkg
dGhlIG51bWJlciBvZiB0aGUgYmxvY2tzIHRvIGJlDQo+PiArICAqIHVuc2hhcmVkIHNvIHRoYXQg
bm8gbmV3IGJsb2NrcyBjYXVzZWQgdGhlIHVuc2hhcmUgb3BlcmF0aW9uIHJlbWFpbg0KPj4gKyAg
KiBpbiBDb3cgZm9yayBhZnRlciB0aGUgdW5zaGFyZSBpcyBkb25lDQo+PiArICAqLw0KPj4gKyBp
ZiAoeGZzX2lmbGFnc190ZXN0KGlwLCBYRlNfSVVOU0hBUkUpKQ0KPj4gKyByZXR1cm4gMTsNCj4g
DQo+IEFoYSwgc28gdGhpcyBpcyBhbHNvIGFib3V0IHR1cm5pbmcgb2ZmIHNwZWN1bGF0aXZlIHBy
ZWFsbG9jYXRpb25zDQo+IG91dHNpZGUgdGhlIHJhbmdlIHRoYXQncyBiZWluZyB1bnNoYXJlZD8N
Cg0KWWVzLg0KDQo+IA0KPj4gKw0KPj4gYSA9IDA7DQo+PiBpZiAoaXAtPmlfZGlmbGFnczIgJiBY
RlNfRElGTEFHMl9DT1dFWFRTSVpFKQ0KPj4gYSA9IGlwLT5pX2Nvd2V4dHNpemU7DQo+PiBkaWZm
IC0tZ2l0IGEvZnMveGZzL3hmc19pbm9kZS5oIGIvZnMveGZzL3hmc19pbm9kZS5oDQo+PiBpbmRl
eCBhYjQ2ZmZiM2FjMTkuLjZhOGFkNjhkYWMxZSAxMDA2NDQNCj4+IC0tLSBhL2ZzL3hmcy94ZnNf
aW5vZGUuaA0KPj4gKysrIGIvZnMveGZzL3hmc19pbm9kZS5oDQo+PiBAQCAtMjA3LDEzICsyMDcs
MTMgQEAgeGZzX25ld19lb2Yoc3RydWN0IHhmc19pbm9kZSAqaXAsIHhmc19mc2l6ZV90IG5ld19z
aXplKQ0KPj4gICogaV9mbGFncyBoZWxwZXIgZnVuY3Rpb25zDQo+PiAgKi8NCj4+IHN0YXRpYyBp
bmxpbmUgdm9pZA0KPj4gLV9feGZzX2lmbGFnc19zZXQoeGZzX2lub2RlX3QgKmlwLCB1bnNpZ25l
ZCBzaG9ydCBmbGFncykNCj4+ICtfX3hmc19pZmxhZ3Nfc2V0KHhmc19pbm9kZV90ICppcCwgdW5z
aWduZWQgbG9uZyBmbGFncykNCj4gDQo+IEkgdGhpbmsgdGhpcyBpcyBhbHJlYWR5IHF1ZXVlZCBm
b3IgNi4xMC4NCg0KR29vZCB0byBrbm93Lg0KDQpUaGFua3MsDQpXZW5nYW5nDQoNCg==
