Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98FC82488
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 23:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720740640; cv=fail; b=Pg0GxBr4EqqTP7ZCYneCfMDHTClDrD2iSZ+rzmMIgdu4ZwIVlWgiJFtYyVrvHX/JOBYRkuRUhDJgNsvCufd3Gkjo8oyk5n9iXEKSgXnH2o47vPj8FoOjcZXVQYHFt3dKdOG89DrD4tAUFoam9e48LQoiWTmj3CNwaCDaXDc12tA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720740640; c=relaxed/simple;
	bh=KeeEF9gQhL33NrheI9FsanJjI2/ZSJeahfqJi39hIAk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YiPE41l9LEBdpJT3nsh4DIe0tXs5jXMB5O0ByBWwalFn2fwPLwbpOY78k+L0EI5IJEE+HmnwgpBCdbPVivi8Cax6HkXAUdhzrDxCJc3+7V02wBwg+fX+t0l/TRRvCq/4dtULz9cOsavHbja94o3aeJkCY+K7OK3f11KTLaOMn/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YPlqiim0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aF/sxiF2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YPlqiim0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aF/sxiF2"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BKXVPv000814;
	Thu, 11 Jul 2024 23:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=KeeEF9gQhL33NrheI9FsanJjI2/ZSJeahfqJi39hI
	Ak=; b=YPlqiim0bYZsqegZkLUpyMBDu6tmlgIuptJR/guupC3V0AM3xzf7wE3yk
	Gx1v7FeoEcKYb+T9yvzOqfq/gyqFJLpazvQ2WmpGAvRd960aYaGbSDYlQ6NFkIkI
	SBn1636UPdIke1NNc9euBlDWJpB6cyMM92YWiv6nxvORcpoo8NNAYaV69AE+rDBt
	WtQY7UERW6scJlH7tW7QED4+Hz5N/utOmOqDHrh1tjOBp2ef2yV0p7y6Er0NMgUF
	p5AUzAOYntpjtTAJQn20wtvE3JlBn/PZtiD+poNY8d0WxdppKEuMVpriPbSPXyrW
	Lnzm6HHU39xom3M+mHoSx1Ky/IxfQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406xfsts4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:30:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46BLO7Ln030316;
	Thu, 11 Jul 2024 23:30:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vvbwxw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JeuypLrbytSF5sipCIadqoylsOF/j7WkDpoIoN/gDEDvtIzbFqgUorgHgYCt9mkTAWZp6TgjYSy1D/gcFmKyHy6jAqXhh4QAI21C4eiL6hBUg6Tm6urDBZc3XJRhq1sQzaHy1qNtqkzJdr0dwC5gOSVC0AJKIP6btbZ6gBFLOHK0W12romLmeGIz2S4kvCFnKt+DQ7TN6ZYOyGZv+bNN2yh3yTciIt1pjS4LOPYWAuT3p2VBa9BC4WKg6WfP+B8dJWiZWAZIWmQ4atC6htQFwOwnup6lCxXVdpylYlWH4F7chq0SzDMkH8CQ1sm7Pd/puwINAEomrMVvtoxjrcEoRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeeEF9gQhL33NrheI9FsanJjI2/ZSJeahfqJi39hIAk=;
 b=ddlEajT1sknicibQmXEo84WmjVc6n1b1cZvzrsh3KEW+1uNpr2ctuIY061yedP30YaxHjmxIlyXgNsVzaPMZZyLrr+c8oo/MuRFVHHI9344u9jhdyXfnEgMfkBgu1QzqEwa5zr7185okPtE0iL6Y+JvghtDkXyTDA715oLT6N3ZMHGFEGsQMRci6xr6lcJsMQx7HhJm2aGynpoCOV8tzLWEa7MJjh3K4CrvcxTlVLUUz8vKfa59Pcfrb77obBTmQbpofdBBcPagsoKrFYTxXX8sXntI518rPBGNcX4nDPhnzvEDB/jX3tdpYb6/JXkDRwG/n0N9V8nYkvMmqHbk6BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeeEF9gQhL33NrheI9FsanJjI2/ZSJeahfqJi39hIAk=;
 b=aF/sxiF2Qv5SeDZ5VaZBS7gSlsjLBy9e2CI4Hs22K1mW6SmBUe6+FqiH1cRKhHR3y03HHvZcd4HZoWe5qwdpvt/vz7XDRxU5gpZvh/nh4j1Y0eVR7o8YG4MkvqoOz6WvsWp46OIgEHDERS5RP98zqF/448qveqJjF2muu/nDyoI=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by SJ2PR10MB7584.namprd10.prod.outlook.com (2603:10b6:a03:547::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.34; Thu, 11 Jul
 2024 23:30:32 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%6]) with mapi id 15.20.7762.016; Thu, 11 Jul 2024
 23:30:32 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 7/9] spaceman/defrag: sleeps between segments
Thread-Topic: [PATCH 7/9] spaceman/defrag: sleeps between segments
Thread-Index: AQHa0jOvjV+kQND83kGIOOr4jV+8W7Hu3aIAgANSjoA=
Date: Thu, 11 Jul 2024 23:30:32 +0000
Message-ID: <D4421713-892C-4814-A4CC-2AC92F54893F@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-8-wen.gang.wang@oracle.com>
 <20240709204606.GU612460@frogsfrogsfrogs>
In-Reply-To: <20240709204606.GU612460@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|SJ2PR10MB7584:EE_
x-ms-office365-filtering-correlation-id: f5dfe2dc-b205-4805-4ffd-08dca2017505
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?a2VEWVY5Nncvd0ZoUmRhd1N1Mzk1enN1WmtianFHaUM3NVFoUWQrQ3N0OGQ3?=
 =?utf-8?B?ZXE2MVM0d1YxZC93WVdBeHY1SlQ5dkxTN1RmWFN4bUJCSlhUdDRvZml2TWVL?=
 =?utf-8?B?c0pjQVpWeE5rTTA2d29ZZlZDVG1rWDZOcENyb0FmRUl4R3ZIZ1JHRXFESW0w?=
 =?utf-8?B?Q09TWHBaTjc2NVJhaEJjUmhjemFUa0hrQnZWaE9rdGh6WTI4eXlqYkduNHE1?=
 =?utf-8?B?ODRHK0k2aFBaZXQrN0pMZW9UUDFvN1dwU0dQNlc1TmdZSmRycGluZVNoUmV3?=
 =?utf-8?B?U05IeUVGN0RWNERMRjAxY3RZVlQyT1JlOVFPMG91WUhhN1F3V1BwTkdQVnZM?=
 =?utf-8?B?cjdzVFF1SmlMYkVPRHp5V1ZxdlQ2MksxelNYUFR2OFVScHNzaHBHTnpXdWVs?=
 =?utf-8?B?Y0xPVlRYaERCWEMvSlNtclVNQ3JTaVorRk9ldTl1SUZKaDZUNmpXa1VPUXY0?=
 =?utf-8?B?U2hxcnh6Y24rYmRKSjlsdHJHemFlOEsvYngzbHJ3WHdJVFkwVDR0cFVoS256?=
 =?utf-8?B?dGJ1WG5EcWtOdWhlWjA5dDRnYjRBVzdjaVdGVklxWGREb1RWOUo3bDYxV3B3?=
 =?utf-8?B?TGRtdlZSUDNVQlY4SHJVTlpYTHVweG1YekIrVTBWeXNYeGdiVFpDRHg5ckVU?=
 =?utf-8?B?MTl1Slg3LzBFcWpkYWxGM1N6QktBTkVUSUtVbnQ2NzkzY2JoOGNaMVM1WVFY?=
 =?utf-8?B?Mnk2dEJuU0lCRVREUDNjT01mTDhzMEtDdVJxaVV4dlNFSG5aYkI0RWRmamRU?=
 =?utf-8?B?c0Y5WDhiSjZlck5IRnJPcnlIaVlObnlqUnAwRDNXcTZPcGdROGttMWI0RzA1?=
 =?utf-8?B?R3R1dm4zdEdVTUI1VlJLbHM3WXlSTlREWU9VVFNWZFVGL21KUzRoZHpscXI3?=
 =?utf-8?B?Q0I4RkZVTTljRGMyWXFGZGlyeTVoREl4dmszdGlmaWVNSmZSTFNGYWMraWxs?=
 =?utf-8?B?Y1lGVGJLVmFxTDJvZ2RWZUNLV09rQnR4YnM0SW5tSDIvTi9aeldNZWF1YWhI?=
 =?utf-8?B?OXFsM0M5Y01yTm9ZazZ4Z0xEd2JEWDFFTmZwUWo0ZlpUQ1FuQVVmTGYvZklJ?=
 =?utf-8?B?cXFRUUlDRXV3d1FleUM0QVJuZXZRcnI5WGVoK09XNFNpYXhKU0ZsSDA0dmha?=
 =?utf-8?B?dkdMbjZaOW1RVmZHWGxnNVM5c3VzSzJURktxMU5XUEZYd0g2cndqNUMvSUd4?=
 =?utf-8?B?bVk2dmFqeHIvUFpmMTh1UHY3M3VreTF6dHhRT2gzQ3BKaXdYb1QwYW5IWEta?=
 =?utf-8?B?TW12NXlpUG4ySHFMSml0bDRSaGRyNzhrK2V3SnNndis1U2dWbXFnd0xXOUJm?=
 =?utf-8?B?eTE4QTFGYlRVN0IyYWFzeGRJc1dVMjZKaXdBYWZDbVF1STdKSE45R2c1KzZz?=
 =?utf-8?B?Q0luNitnM2NwbERQR1A2K3o5bzd3RlN3L1FGZkdiZWFxeitUUWNScG5QcWY3?=
 =?utf-8?B?RXZtOEdkMU9QTGxVSDlPMFRzUzlDWmY3TlI2ZVlZSmJ0c2xDT1pjeng4YjZm?=
 =?utf-8?B?OU10bGVzOXp3R1lXQmZSQ0Z3TllCTUxiU2JJRjNIZEY2S3UyUHh5MTRKRW1I?=
 =?utf-8?B?elhaYXl0UncvWVV4dzdXbGRzaU52WlFSMjRvMDhhQ0VjWDVmRUVTYW13OElO?=
 =?utf-8?B?akFpb3hVSFB6TFgvUlNrOTNQZWIzQjMvM2NNNlZtZ1B6ekFnZjYvaWY2WUtB?=
 =?utf-8?B?YkZHRVI5eWJ0UHJkTjdiRTBpcHhUQnd2WUprY3dsSS9PRnNoTGw5amlzeE1E?=
 =?utf-8?B?WmszWHNEWFpvVHZEbU1WaXYzR2w0OVJTU0RHVHhwdXFqOXlJdGZsSU5LaHc5?=
 =?utf-8?B?ckpsQmNPZkphNUpVZWF6a1JOaVdyS3ZqazV5N0c2U1lJbHJSdWJxQzFsZm5J?=
 =?utf-8?B?a2ZRSURVcW4wZE4yMmxVK0tjTGNVYVBwRXpJNjI4dVI1TkE9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?Qy96QmYraTlOa1VHWTJKUW54by9pZFBYczZZM01aYXppaGVWK0Z4K3lCMU80?=
 =?utf-8?B?RFl3V2MwNC9TZU1hKysrY0dRTFRLbWJjYTZ1S09KM1JtbXI4K0Ezd1o3Yklp?=
 =?utf-8?B?c2tkTTBGYWsvSlJMUHEyZ3JybjJlOUFDZDE5UTA1Y2lmY3FiNHJjU1ViN3NT?=
 =?utf-8?B?MkhDcjd0c1lILzZWb2FZZjZicnRESTk4bHFpY0Njb1B5V0JWVTRma045MnQ5?=
 =?utf-8?B?Y0hTVE9BNFh4Q3BsN2xGT3VIdmtrL1R3MW9IZUhwcjFGQWtocm0zdkJjNnZN?=
 =?utf-8?B?OStuL0JhSVlnQytqL2Z5LzduSHdjWnpReW4wWndqZ2daQWhvTnBUZmdkSHYv?=
 =?utf-8?B?TWt6b3lEaEZiR2QxeHlWbVFrdWR2eWpWV1V1NE5oMnR6amM2REg2c2lZZ3E0?=
 =?utf-8?B?SlFTMVhNU0c5Uk4vZ2VyL00reE5SRzhVM014L3NGQ0xLMHQ4RHZEaHFGSHdm?=
 =?utf-8?B?TmNDV3M0cTJOYi93cHBzMExucnVTSWRzRE0rNmdHTUtEcXF4bFRVazVzbDlv?=
 =?utf-8?B?aWNjc1BHdWxmNUpMbmJPRmZpeTgxSzVDUjRaUW1yOTJOVTBwKzVHMXZUemdh?=
 =?utf-8?B?NHAyZUFQTW5DNmFuL05nbXRjK3BKNk1FMHE0TU5GQjNMb0J3Yk12MGdQalF4?=
 =?utf-8?B?UFpydndVY0ljc1FkejN6a0pRNzhPZnhDbUFxRE9yVjBueDVkUFAyTjBoQktR?=
 =?utf-8?B?aUlpRzFWenNvMjYyUVBlUklZMTRYQy9SOUxCWitQQ3d0SUxQRFVIcjEvejRO?=
 =?utf-8?B?L0JQd3JNSGFwbUVrUWZXK1Frd2NlNTMxeTdWUWRIbjZkaDQ1M1FLUTdPeWFV?=
 =?utf-8?B?S2c5VXY1ZnF3RXAwSElZSUltZUlZNGxYUDhzaENQamgxejZFOUN2Uk12RzBI?=
 =?utf-8?B?cEpOQjZEaG56MHlJL1pjMWRHZVQ5cTZmN3FaaVUwa1MrcDI2S1N5WlhXcVdr?=
 =?utf-8?B?K3RodUU2SVloanRSSklaaENSR21NdTFjWXZvc2NvTWtJa1AwK1UxY3BoRWtE?=
 =?utf-8?B?dklKSnhYNm9JbVpscHFhbDNEcUdVb1p0VVZpRUtCZUFaUlhsdC8xejk3czJr?=
 =?utf-8?B?TWgrKzE2ZWxaSGlCK083ekZTLzFacVVvVnIvTW9vdy9aRUE1ZVVROXVkTVlI?=
 =?utf-8?B?TzQyZjhmZWR1WDJGaThaUlgvbE1rTEhOMUU4Y3BhQ09sV1JZU2ZQbnNyM1Ux?=
 =?utf-8?B?VTY5ckJZaGZlYXhpWXNDcEFVU0NtTDR5aUJDS2hzNUVUV2VqRVFBbWpxc0hN?=
 =?utf-8?B?Z3BEbk9pZkI1R0l2cVlIK2R2V1BjSTlnMU9uUk9XYWl6Q1N6dTFDNnhjTGdN?=
 =?utf-8?B?VVdPS3llNXd1cS9ZOTh6Z2laUzhZOW0xcGc5NUJFY0hlL3BqSklsSzlDOUhF?=
 =?utf-8?B?VmdUSzErNisxV2YxSkZqdjlKeTVmWm5jb3VaaFlaZFJmVmdrZEFlUm9Ub2xr?=
 =?utf-8?B?VnFSTGxGL1o4RWVFNlJXeno5a1loNGtSOHBLUnBwT2lGS2pJSjNxQ2Y4N2kx?=
 =?utf-8?B?cVNhOHI3VFhnQzgzNFZ2aS9QRDB2SmNrZ3FMcUp3QUxHQU03N2pzb3dVQ0Rm?=
 =?utf-8?B?QUFpZzF6d05wUnUrOUJ6SFdxS2N1VDlTbFBaTE9WUzQ5Zit2NzZJSW9jQytu?=
 =?utf-8?B?VVFkK0lvYm43ZzdROUZaOXpBRnRXR0ZkMXlWaGxiMEY4YzNJVFhrSDM0Ti9i?=
 =?utf-8?B?b1YzTDhhKzlaS29KMTc4OXVEU2ZNQmZhRy9MUWdMWkRFd2RMeUJTazFoV2h1?=
 =?utf-8?B?R0FMYktwckt4MkdsZHJYMmdoMG5nS0JvVXVpR3Qxc3hQZDA0NUhYZUdndnJl?=
 =?utf-8?B?c3lYaGVncDZQeVVVSFU1aTMxTmlMVjRNWU4vVUFnSTVIZUM3K1pyK0RXc2Yr?=
 =?utf-8?B?RzM2ZWVWbmhlRTgzWnZGN0U5Vk13YVpvaVArckt5Q3NuQzhaQVFUbGdUTEFx?=
 =?utf-8?B?bWJQdnI3T3U4VWpCdGxQTWtvOVl2K1JSbjFoQThQLzA5TS9DWitCR2k0b0h4?=
 =?utf-8?B?TERJaUxUOUhlOUpscU54d0ZwZjRmclVJYVJIR2tvZU41cDZpMXNza1YxU0ww?=
 =?utf-8?B?d2lNTVJFZFArU05FU1E5bTU2K05LZnFKZktxL1N4UmRLZ1NBRGRnWllxMFFT?=
 =?utf-8?B?T0x5VVlhaTlLL0FlenJGemRhelhFZm9YSWl6cVJwWENXSGEydStDbFpTNnAv?=
 =?utf-8?B?dWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66DCCFFB55F9E2449E9D0D48CE8D31A5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+XS7Q+Zo8ygY5hwYC1ehM3w2yH+uqs/3PicIMKqtl+5haXLj+sIqYQSZVtdMSwZd8hDuLoLT/QLYFP+Ji0QarmdzF72R4QOWhMOmMds0AzeJvQbCb0i57eSxt1JWxbRgnuc0hh0a2VKj7sFoBEiB/1zNVChog4zSAnDt7iinMgApbN88m5bz9nGyg2IXKfcTiE4bbFBlbmNzWLz9ey9NEoTtWOsPtw08kvHkH6AYg7AljH4GqvklGp+A8yY6mgiwZnVviDpZBtWhdapz45wZLhtH+0V5KpqGKVd/8p3LW2y/LXxpsBtIorAqIF7werDkKkNJ7Sp9blY246+RgwzqhYQQPVzj+i9PAZLChMBnkESbDvAafVQXvR3J47rAkMUGZ45GaJUrlHji0OCGhjE0YEhzYbeBw4Rb092iDNpSAfqUgflGl/Kyw06TV1hsFCuF2PMTUiePLeBzRnH4TaC6DcavYmkFimEgV+xV4P6xWpNLvmyBlT13lszmDTZlx7zcRxLRRb9eb33s36GVHs/y3a2cFStzroqwQE1gbdUGMkSJk3pfvNnFagd8gr9br3rlIcuH3cidObuxVq0n94x8FnGJVNHr+QQZ9N2ESHoV/s8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5dfe2dc-b205-4805-4ffd-08dca2017505
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 23:30:32.1476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ooi2ex2xnOE8IQNGUDUI9mCPqlwtBvS5qNP2Fa0MJwiFOBxmgneSztNNQ3T/iyC6S2KdOmZnj84xdh/0iHX7ZHIvpUXA+jnEUwiWUEwyzQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7584
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_18,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110166
X-Proofpoint-ORIG-GUID: lS4Rwh4U-SBNBTm2gVnzVxMU-CH5hi0f
X-Proofpoint-GUID: lS4Rwh4U-SBNBTm2gVnzVxMU-CH5hi0f

DQoNCj4gT24gSnVsIDksIDIwMjQsIGF0IDE6NDbigK9QTSwgRGFycmljayBKLiBXb25nIDxkandv
bmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyNlBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBMZXQgdXNlciBjb250b2wgdGhl
IHRpbWUgdG8gc2xlZXAgYmV0d2VlbiBzZWdtZW50cyAoZmlsZSB1bmxvY2tlZCkgdG8NCj4+IGJh
bGFuY2UgZGVmcmFnIHBlcmZvcm1hbmNlIGFuZCBmaWxlIElPIHNlcnZpY2luZyB0aW1lLg0KPj4g
DQo+PiBTaWduZWQtb2ZmLWJ5OiBXZW5nYW5nIFdhbmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNv
bT4NCj4+IC0tLQ0KPj4gc3BhY2VtYW4vZGVmcmFnLmMgfCAyNiArKysrKysrKysrKysrKysrKysr
KysrKystLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9zcGFjZW1hbi9kZWZyYWcuYyBiL3NwYWNlbWFuL2Rl
ZnJhZy5jDQo+PiBpbmRleCBiNWM1YjE4Ny4uNDE1ZmU5YzIgMTAwNjQ0DQo+PiAtLS0gYS9zcGFj
ZW1hbi9kZWZyYWcuYw0KPj4gKysrIGIvc3BhY2VtYW4vZGVmcmFnLmMNCj4+IEBAIC0zMTEsNiAr
MzExLDkgQEAgdm9pZCBkZWZyYWdfc2lnaW50X2hhbmRsZXIoaW50IGR1bW15KQ0KPj4gICovDQo+
PiBzdGF0aWMgbG9uZyBnX2xpbWl0X2ZyZWVfYnl0ZXMgPSAxMDI0ICogMTAyNCAqIDEwMjQ7DQo+
PiANCj4+ICsvKiBzbGVlcCB0aW1lIGluIHVzIGJldHdlZW4gc2VnbWVudHMsIG92ZXJ3cml0dGVu
IGJ5IHBhcmFtdGVyICovDQo+PiArc3RhdGljIGludCBnX2lkbGVfdGltZSA9IDI1MCAqIDEwMDA7
DQo+PiArDQo+PiAvKg0KPj4gICogY2hlY2sgaWYgdGhlIGZyZWUgc3BhY2UgaW4gdGhlIEZTIGlz
IGxlc3MgdGhhbiB0aGUgX2xpbWl0Xw0KPj4gICogcmV0dXJuIHRydWUgaWYgc28sIGZhbHNlIG90
aGVyd2lzZQ0KPj4gQEAgLTQ4Nyw2ICs0OTAsNyBAQCBkZWZyYWdfeGZzX2RlZnJhZyhjaGFyICpm
aWxlX3BhdGgpIHsNCj4+IGludCBzY3JhdGNoX2ZkID0gLTEsIGRlZnJhZ19mZCA9IC0xOw0KPj4g
Y2hhciB0bXBfZmlsZV9wYXRoW1BBVEhfTUFYKzFdOw0KPj4gc3RydWN0IGZpbGVfY2xvbmVfcmFu
Z2UgY2xvbmU7DQo+PiArIGludCBzbGVlcF90aW1lX3VzID0gMDsNCj4+IGNoYXIgKmRlZnJhZ19k
aXI7DQo+PiBzdHJ1Y3QgZnN4YXR0ciBmc3g7DQo+PiBpbnQgcmV0ID0gMDsNCj4+IEBAIC01NzQs
NiArNTc4LDkgQEAgZGVmcmFnX3hmc19kZWZyYWcoY2hhciAqZmlsZV9wYXRoKSB7DQo+PiANCj4+
IC8qIGNoZWNrcyBmb3IgRW9GIGFuZCBmaXggdXAgY2xvbmUgKi8NCj4+IHN0b3AgPSBkZWZyYWdf
Y2xvbmVfZW9mKCZjbG9uZSk7DQo+PiArIGlmIChzbGVlcF90aW1lX3VzID4gMCkNCj4+ICsgdXNs
ZWVwKHNsZWVwX3RpbWVfdXMpOw0KPj4gKw0KPj4gZ2V0dGltZW9mZGF5KCZ0X2Nsb25lLCBOVUxM
KTsNCj4+IHJldCA9IGlvY3RsKHNjcmF0Y2hfZmQsIEZJQ0xPTkVSQU5HRSwgJmNsb25lKTsNCj4+
IGlmIChyZXQgIT0gMCkgew0KPj4gQEAgLTU4Nyw2ICs1OTQsMTAgQEAgZGVmcmFnX3hmc19kZWZy
YWcoY2hhciAqZmlsZV9wYXRoKSB7DQo+PiBpZiAodGltZV9kZWx0YSA+IG1heF9jbG9uZV91cykN
Cj4+IG1heF9jbG9uZV91cyA9IHRpbWVfZGVsdGE7DQo+PiANCj4+ICsgLyogc2xlZXBzIGlmIGNs
b25lIGNvc3QgbW9yZSB0aGFuIDUwMG1zLCBzbG93IEZTICovDQo+IA0KPiBXaHkgaGFsZiBhIHNl
Y29uZD8gIEkgc2Vuc2UgdGhhdCB3aGF0IHlvdSdyZSBnZXR0aW5nIGF0IGlzIHRoYXQgeW91IHdh
bnQNCj4gdG8gbGltaXQgZmlsZSBpbyBsYXRlbmN5IHNwaWtlcyBpbiBvdGhlciBwcm9ncmFtcyBi
eSByZWxheGluZyB0aGUgZGVmcmFnDQo+IHByb2dyYW0sIHJpZ2h0PyAgQnV0IHRoZSBoZWxwIHNj
cmVlbiBkb2Vzbid0IHNheSBhbnl0aGluZyBhYm91dCAib25seSBpZg0KPiB0aGUgY2xvbmUgbGFz
dHMgbW9yZSB0aGFuIDUwMG1zIi4NCj4gDQo+PiArIGlmICh0aW1lX2RlbHRhID49IDUwMDAwMCAm
JiBnX2lkbGVfdGltZSA+IDApDQo+PiArIHVzbGVlcChnX2lkbGVfdGltZSk7DQo+IA0KPiBUaGVz
ZSBkYXlzLCBJIHdvbmRlciBpZiBpdCBtYWtlcyBtb3JlIHNlbnNlIHRvIHByb3ZpZGUgYSBDUFUg
dXRpbGl6YXRpb24NCj4gdGFyZ2V0IGFuZCBsZXQgdGhlIGtlcm5lbCBmaWd1cmUgb3V0IGhvdyBt
dWNoIHNsZWVwaW5nIHRoYXQgaXM6DQo+IA0KPiAkIHN5c3RlbWQtcnVuIC1wICdDUFVRdW90YT02
MCUnIHhmc19zcGFjZW1hbiAtYyAnZGVmcmFnJyAvcGF0aC90by9maWxlDQo+IA0KPiBUaGUgdHJh
ZGVvZmYgaGVyZSBpcyB0aGF0IHdlIGFzIGFwcGxpY2F0aW9uIHdyaXRlcnMgbm8gbG9uZ2VyIGhh
dmUgdG8NCj4gaW1wbGVtZW50IHRoZXNlIGNsdW5reSBzbGVlcHMgb3Vyc2VsdmVzLCBidXQgdGhl
biBvbmUgaGFzIHRvIHR1cm4gb24gY3B1DQo+IGFjY291bnRpbmcgaW4gc3lzdGVtZCAoaWYgdGhl
cmUgZXZlbiAvaXMvIGEgc3lzdGVtZCkuICBBbHNvIEkgc3VwcG9zZSB3ZQ0KPiBkb24ndCB3YW50
IHRoaXMgcHJvZ3JhbSBnZXR0aW5nIHRocm90dGxlZCB3aGlsZSBpdCdzIGhvbGRpbmcgYSBmaWxl
DQo+IGxvY2suDQo+IA0KPiAtLUQNCj4gDQo+PiArDQo+PiAvKiBmb3IgZGVmcmFnIHN0YXRzICov
DQo+PiBucl9leHRfZGVmcmFnICs9IHNlZ21lbnQuZHNfbnI7DQo+PiANCj4+IEBAIC02NDEsNiAr
NjUyLDEyIEBAIGRlZnJhZ194ZnNfZGVmcmFnKGNoYXIgKmZpbGVfcGF0aCkgew0KPj4gDQo+PiBp
ZiAoc3RvcCB8fCB1c2VkS2lsbGVkKQ0KPj4gYnJlYWs7DQo+PiArDQo+PiArIC8qDQo+PiArICAq
IG5vIGxvY2sgb24gdGFyZ2V0IGZpbGUgd2hlbiBwdW5jaGluZyBob2xlIGZyb20gc2NyYXRjaCBm
aWxlLA0KPj4gKyAgKiBzbyBtaW51cyB0aGUgdGltZSB1c2VkIGZvciBwdW5jaGluZyBob2xlDQo+
PiArICAqLw0KPj4gKyBzbGVlcF90aW1lX3VzID0gZ19pZGxlX3RpbWUgLSB0aW1lX2RlbHRhOw0K
Pj4gfSB3aGlsZSAodHJ1ZSk7DQo+PiBvdXQ6DQo+PiBpZiAoc2NyYXRjaF9mZCAhPSAtMSkgew0K
Pj4gQEAgLTY3OCw2ICs2OTUsNyBAQCBzdGF0aWMgdm9pZCBkZWZyYWdfaGVscCh2b2lkKQ0KPj4g
IiAtZiBmcmVlX3NwYWNlICAgICAgLS0gc3BlY2lmeSBzaHJldGhvZCBvZiB0aGUgWEZTIGZyZWUg
c3BhY2UgaW4gTWlCLCB3aGVuXG4iDQo+PiAiICAgICAgICAgICAgICAgICAgICAgICBYRlMgZnJl
ZSBzcGFjZSBpcyBsb3dlciB0aGFuIHRoYXQsIHNoYXJlZCBzZWdtZW50cyBcbiINCj4+ICIgICAg
ICAgICAgICAgICAgICAgICAgIGFyZSBleGNsdWRlZCBmcm9tIGRlZnJhZ21lbnRhdGlvbiwgMTAy
NCBieSBkZWZhdWx0XG4iDQo+PiArIiAtaSBpZGxlX3RpbWUgICAgICAgLS0gdGltZSBpbiBtcyB0
byBiZSBpZGxlIGJldHdlZW4gc2VnbWVudHMsIDI1MG1zIGJ5IGRlZmF1bHRcbiINCj4+ICIgLW4g
ICAgICAgICAgICAgICAgIC0tIGRpc2FibGUgdGhlIFwic2hhcmUgZmlyc3QgZXh0ZW50XCIgZmVh
dHVlLCBpdCdzXG4iDQo+PiAiICAgICAgICAgICAgICAgICAgICAgICBlbmFibGVkIGJ5IGRlZmF1
bHQgdG8gc3BlZWQgdXBcbiINCj4+ICkpOw0KPj4gQEAgLTY5MSw3ICs3MDksNyBAQCBkZWZyYWdf
ZihpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+PiBpbnQgaTsNCj4+IGludCBjOw0KPj4gDQo+PiAt
IHdoaWxlICgoYyA9IGdldG9wdChhcmdjLCBhcmd2LCAiczpmOm4iKSkgIT0gRU9GKSB7DQo+PiAr
IHdoaWxlICgoYyA9IGdldG9wdChhcmdjLCBhcmd2LCAiczpmOm5pIikpICE9IEVPRikgew0KPj4g
c3dpdGNoKGMpIHsNCj4+IGNhc2UgJ3MnOg0KPj4gZ19zZWdtZW50X3NpemVfbG10ID0gYXRvaShv
cHRhcmcpICogMTAyNCAqIDEwMjQgLyA1MTI7DQo+PiBAQCAtNzA5LDYgKzcyNywxMCBAQCBkZWZy
YWdfZihpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+PiBnX2VuYWJsZV9maXJzdF9leHRfc2hhcmUg
PSBmYWxzZTsNCj4+IGJyZWFrOw0KPj4gDQo+PiArIGNhc2UgJ2knOg0KPj4gKyBnX2lkbGVfdGlt
ZSA9IGF0b2kob3B0YXJnKSAqIDEwMDA7DQo+IA0KPiBTaG91bGQgd2UgY29tcGxhaW4gaWYgb3B0
YXJnIGlzIG5vbi1pbnRlZ2VyIGdhcmJhZ2U/ICBPciBpZiBnX2lkbGVfdGltZQ0KPiBpcyBsYXJn
ZXIgdGhhbiAxcz8NCg0KSXTigJlzIHVzZXJzIHJlc3BvbnNpYmlsaXR5IDpELg0KDQpUaGFua3Ms
DQpXZW5nYW5nDQoNCj4gDQo+IC0tRA0KPiANCj4+ICsgYnJlYWs7DQo+PiArDQo+PiBkZWZhdWx0
Og0KPj4gY29tbWFuZF91c2FnZSgmZGVmcmFnX2NtZCk7DQo+PiByZXR1cm4gMTsNCj4+IEBAIC03
MjYsNyArNzQ4LDcgQEAgdm9pZCBkZWZyYWdfaW5pdCh2b2lkKQ0KPj4gZGVmcmFnX2NtZC5jZnVu
YyA9IGRlZnJhZ19mOw0KPj4gZGVmcmFnX2NtZC5hcmdtaW4gPSAwOw0KPj4gZGVmcmFnX2NtZC5h
cmdtYXggPSA0Ow0KPj4gLSBkZWZyYWdfY21kLmFyZ3MgPSAiWy1zIHNlZ21lbnRfc2l6ZV0gWy1m
IGZyZWVfc3BhY2VdIFstbl0iOw0KPj4gKyBkZWZyYWdfY21kLmFyZ3MgPSAiWy1zIHNlZ21lbnRf
c2l6ZV0gWy1mIGZyZWVfc3BhY2VdIFstaSBpZGxlX3RpbWVdIFstbl0iOw0KPj4gZGVmcmFnX2Nt
ZC5mbGFncyA9IENNRF9GTEFHX09ORVNIT1Q7DQo+PiBkZWZyYWdfY21kLm9uZWxpbmUgPSBfKCJE
ZWZyYWdtZW50IFhGUyBmaWxlcyIpOw0KPj4gZGVmcmFnX2NtZC5oZWxwID0gZGVmcmFnX2hlbHA7
DQo+PiAtLSANCj4+IDIuMzkuMyAoQXBwbGUgR2l0LTE0NikNCg0KDQo=
