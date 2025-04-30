Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD02D25EF94
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746026713; cv=fail; b=VMg7Agll3q3lfcT1RDlQDQctaX/bbj+tlGddh2rsOhpD0JE1liQ6e98SJzb+lDglnD/ZxVcAMZO/3xX7c0cs1VKsXx/rD1zvUa6iUqwMImjAWOhrMu++yU2h4rHbWM5X4Cus6kLMT804qDAi8RB9jITIODp4PwzrkTf5GKoq1Hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746026713; c=relaxed/simple;
	bh=Uj3ybRlIm5O9XOtz4rMIzs3ZZLAuMA/k+AIVwKs0B8U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y9032lr1hcwJZI4ei6KfA0IwxHhqAen11JeC70QfZkqUMDWIn21E+VI7enO0/wIE055gZsDG7PDSLOy4waHyccf7cqZvV9IrOouLsgGMKyvKDrCGT3O7PhQfZcU2K7YJmbwesJKBBhENHXzXHRvwT5qfJkZrqIhXdb7DC0DAZEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EeajlozW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MZpyJcBC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EeajlozW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MZpyJcBC"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53UFMwcm029074;
	Wed, 30 Apr 2025 15:25:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Uj3ybRlIm5O9XOtz4rMIzs3ZZLAuMA/k+AIVwKs0B8U=; b=
	EeajlozWdaEZgjfPKZNcB7LnFoBRdHlPJC+7O86Z4mMzHp3jzQrE/1TwZ2GXHyH2
	fLnEPbkcImGAIOX/We9nb6tfFMI/MghFDZRpffPIc7N11kRNP6ahk/ZTmQDnpP7p
	6DOEMwnQggOafjpLe0Y7Kjol/CfNMpF7H+QFivwM17JbL1K9IR6/1NdIeZCFX2pN
	zoRIDwyR7JUDg2IGmq9/qr1FisDzRKCblyxZJIv85aG4Uiz6fn6v2qDWXFz32ReN
	MmLqOhd2q4z12EXE+b+m1gcR8RFyIUpr2o1czztIAhCLUBqMYead1CGaXoJEG5Ff
	D4FdcLhdwSHm6GRci1xueg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46b6uqhfga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 15:25:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53UEe7pE035342;
	Wed, 30 Apr 2025 15:25:07 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010020.outbound.protection.outlook.com [40.93.12.20])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxb7x5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 15:25:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N+rR4clPrf0rcEEdrp2mPQKYQ80XHK9oioQ64sQb98RvawF+BTL4SLr2aGbrBEQ/7/E6N2s5EIzH9uzs+5FgPB18AujrAsZgdAvM4/HbbWISlOjmtwJYUcjpKe9xP8kq49vDVLP3x9/5LT3PCGbMkpCCl1myDUhyCIu1GEjRhFDdUYHKsDmzsDF6c+sf+YzcaxV2syXGBW3e01ftwcO/jJWC1sgIw/5va4hFPg82kaZZdHAyTz7GkfrsuO/IHumloP0dB299DituN83v7/NMsyesKFgrMmBdX7gLRBuR1LGCjcmj2S5hlWMROpfGVBdqn28jbzkeGUeYz1owaVg2Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uj3ybRlIm5O9XOtz4rMIzs3ZZLAuMA/k+AIVwKs0B8U=;
 b=fVbYNNNF1KWD4kKDqxDOq3dPsqJKq+JEIq9VlwxAT44IkgSa+lvo7GxSm2wE/7ghLHQJosPc51sfNT09KNCWvu7zw2sKKsDfVpajiUpHnCJwPcCWdN4PN7aneFyuliTeDfSTTinNcOPq8YbVjud4zWfhlMvFHgHZ1d/XppNKhbBvjQzWv+gOjvxMUAUdM4ep5Hne2yuSI4FQYMUms2wsLihKSqiZwNV9v30rfdFzH3pOkHTbnQDSaNSRrJFkizHE96wVR/9nRRcNszAM333wEU82tloSWyfW01EpDzoVUy3n3GEIPHdzwH7jv8AvK08fFx+JtqU3c68t7LQPzRW6+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uj3ybRlIm5O9XOtz4rMIzs3ZZLAuMA/k+AIVwKs0B8U=;
 b=MZpyJcBCLP+DU9Mcx00YQ+3CVzO5s1n6dpZSoUFG+SZ3D208psrn5JuaNcUOBjRvA2qA/6RZWnebJgcmflVQFRfBbZI54GfX0bH0zxaG1DYGyAXRQbW+HodI5kGxSNrhOl01nFK2vFC8Ppnk8V08Y9BRG53foexrZNK+PaGRT6s=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by IA3PR10MB8662.namprd10.prod.outlook.com (2603:10b6:208:570::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 15:25:05 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.8632.030; Wed, 30 Apr 2025
 15:25:05 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: export buffer cache usage via stats
Thread-Topic: [PATCH] xfs: export buffer cache usage via stats
Thread-Index: AQHbuGj8RuUuGxnaV0aU6W3FPGSq+LO7gP+AgADWOgA=
Date: Wed, 30 Apr 2025 15:25:05 +0000
Message-ID: <39B092F6-5956-4EE8-84E2-1BDA9835E41C@oracle.com>
References: <20250428181135.33317-1-wen.gang.wang@oracle.com>
 <aBGNEUfidgqfXpkW@dread.disaster.area>
In-Reply-To: <aBGNEUfidgqfXpkW@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.500.181.1.5)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|IA3PR10MB8662:EE_
x-ms-office365-filtering-correlation-id: c2f766ed-080b-4da9-b7a4-08dd87fb2f58
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UkQ1WUwyZHhpTkxueklvdFVjdlQ2RG1yWE1Jc3ZKQmxYU0VSVDBnMlVpZFhv?=
 =?utf-8?B?TEhZeFd0eHJLcnljT0gxaGtES3ZZdW9aKzU5bGhDQS8rU1J3Ym5sNVN4WUNV?=
 =?utf-8?B?Ui9RdmxkWklEWjBjeE9QYUp5d2tFaW94b0hLK3J6OE5uVVc1MTVwTFZYRHVJ?=
 =?utf-8?B?Q1BWQ202TFU1dkdmZ3U2Mkx1YkF1NEozNE9VRnhidnNTaG5YV0lyYmt6MWp1?=
 =?utf-8?B?RS95L2FmbGpBWGt4Y1BQSzVIdGV1c3BKcEgwaWxzUlNiWmY0Qm5lTC9mRzlW?=
 =?utf-8?B?UUpYR0FCaUNZZGQ2aHFJd2J3Uis3WXBFbDNscTFQUU12djVUTjJacUZoSWVV?=
 =?utf-8?B?L29TYVJ4UGNEYjZFcUtOT24xRFZQTCtOU0ZxU01GN2IrbTVTUnJTQ29WVVpt?=
 =?utf-8?B?YlpvSDVJamFzblozcnRSMWp1WFo5d3hybnNVclBoSW9lK1JuUnV5Zjlhcmxj?=
 =?utf-8?B?UGF0NTZUcGkwR3JZNFpDWnROMTBsZHNqMklRTlgrbnB3SWNpbE04bkpRU21y?=
 =?utf-8?B?N3RoNE1sQy9BZk5ONmx0YmdwZG11dkFqQUd1Z04yL01rODhaZ0RPNjlXTWp6?=
 =?utf-8?B?RjJVN0xaN3ZrOWhmdzVCQjU5UXNZYWQwRUtDVVJiSG9CaWhqbS9RbWw4Tlhv?=
 =?utf-8?B?NTh0LzlmbUJ3QjZkZjd6aXlYeHJxcFdLZUp1aWlsTDBJMHpXV3hGaStkU2hO?=
 =?utf-8?B?eWFCWTlJaHZzSHVvZVJsaVVYZmplTVV6T2dRM0dQVkVLTExMV3hSYXQxdExk?=
 =?utf-8?B?UWN2ZmJIcHIzSjVlTVZhYjJGOUhRUXlRU056T0RSY2JieWVuRUNoN3BLVHpF?=
 =?utf-8?B?ZjRkSnM1QlNqOHBJUDJYTzV2Lyt1STdPMlNRZFBQZFFPcWdjdWovVkZLL1ZM?=
 =?utf-8?B?Wk53R0NsbVhteFJiRWhmbFFwOE9FTHJicytxUnRnNzByRWZXRktibFdJRTUw?=
 =?utf-8?B?TG4vTnFwWkRJZWU4TURQSllSajlicUFLc21odDh5MkRhQ1B2bHVjK0lHQXlG?=
 =?utf-8?B?UGFJSXhtZWp0RHdrUkk0Y1VUMWp2NVpEVGhIZmJrTzQvMEZNK2pLbEY4Uk5k?=
 =?utf-8?B?SllzZGlNSk1PMFNkUVVOK2lieGdrdm1NUi9ZOFdGR0t5VG41dkVaUGdVY2Zh?=
 =?utf-8?B?dVRiTUJ1M2FLTnpSM3NoYmpWUHpPQUZKNXlqSmVYUEFGaHNHVStLTXU2alk3?=
 =?utf-8?B?bERmT3ZJUHMrMWwzWmVxZXBsS3J3R2RCYXFKeXdQTllGRVZ5bmEwb01BTzZZ?=
 =?utf-8?B?QXNYR0dhSEJweW1ueXRNb2FaaElzQlJndGNUMjNCeEUvajh0NFk0Ky9GcHQy?=
 =?utf-8?B?SjdxWS9MSjdMVGtKSGVUck1DNElVa0VOYjVWRitQeEtlcTVPdHArNWhnSCtG?=
 =?utf-8?B?Nmc0NHVGbVg2c1M1ZnczTTNNdkZVMStKbnd3M1VIOVZ2aXNxV2phYmwrc2dj?=
 =?utf-8?B?blcxWUZzZkpxUzd5ZEozaS9jcmZqTHRvWDBDN1ViMDdNTXV3NVM3RWhLR0pS?=
 =?utf-8?B?NEpVZno1MUI0dXY4TVpDcUdFQlN3dTY2cDQxNUdJS0FtOHB1eUJtYlRJdzZP?=
 =?utf-8?B?OTRWODlRZTFTdWp6UnAzYkN4ZTZqRklXRHl4a3N4d0MwT216eDUzeU9ZYnZM?=
 =?utf-8?B?eVN5bVZITEJNdkxpODNERXUvYllwenJ0bGM4TUxiYzRZcTFjQk85Zk9xa2VT?=
 =?utf-8?B?UW03YmZabWRrWmtId0U5bE1kUU5KaU11VDRZbzJwbFdIUUxHTWYyeWRZRGdu?=
 =?utf-8?B?VEcyOUF5Y0RZbFhTTUdzNkVBUW0wZW9QdUdPTTZ4NUpTMDZtM2R0eFZiNXdO?=
 =?utf-8?B?U253a3ZzUTczT2dkRmc0QzhaVXVDQkNxanhEK0VuUFlDN0FnaGJjYUFSL2dQ?=
 =?utf-8?B?eWd2a3RJbTJKTktjVnZNc3pBUlBHYy9icmc1L0lnSXNVcDJYeHBxRWNlRW9P?=
 =?utf-8?B?QlgvTE1EYTVueE4zNFk5clc5N1VXZTFBdWhSb3ZxWGFmTkd3eit0U1hlY001?=
 =?utf-8?B?WFRXajN5bEhnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M0hIT0I2OTVuMW1hMk1HcEhMRVp6WFhGYnRuTW1HVWdqSFRweXp1a2dHVk8x?=
 =?utf-8?B?ODJsOElkWk9abVA1R3A1eVRHOEFCcUhURUFTOGpxL2ROYjZ5YzVIM2FzZEFi?=
 =?utf-8?B?UTdsNStzZGNJbW44SDhLRjVGYkhWNWtlM2VrZTB6NlhIN2xCeTcraUQvV3pC?=
 =?utf-8?B?cnRLQTZsQm91SmtnK3oxRGZraFpUVERvaVVKakRHN3ZncVpBT1JnRXJSQ2NQ?=
 =?utf-8?B?WTNCOElQRk8rMjlsZVlWeS9OeWx5MTVVMkJ0Znk5QjRNNS8xYkxWajR6Z2ts?=
 =?utf-8?B?TXVpR3hXRCtjR3VwWXV4WUhJSENuRHRoS1VUQkEyNHNpNDlaUEQrRW9hWHNq?=
 =?utf-8?B?bEorZ3I1U3Fib0JCWFNIYXllanZWSmlOeWFVaEw3MTljbGtURVhyRXdabUlm?=
 =?utf-8?B?dklXazBrd0pBSlBOUGg1azJ1QzVsZm5nQzBRRWdOMFdwZmw0cUdYaTRNakxI?=
 =?utf-8?B?c1A0U1RDYVdVSGxKVHRYcFJuenQzeC9URTlYbXdtZlZBT2VlWm5CbTJZT3dv?=
 =?utf-8?B?K2RRazhsQlRTekIxZUtuZDhlMHBVZm1EL1ZqTitnVU4wdDkxQzJrNzgxUVUv?=
 =?utf-8?B?dzFselRHK25zNXlPbUhGTkkvZEY4VjY1NDFhTThQNFEreGtIL29PZFl1bjZv?=
 =?utf-8?B?enliOEZqbVBybFROS3BzSkV0QlJheHk2YzJmZWp6TElXOWtXamIrMnNYYkd6?=
 =?utf-8?B?ZlJqNFI0RS8rVkRvQWpNc0FjODZLUmZlcWdVSHA4YkJJckhDYlp6S3YyaTNP?=
 =?utf-8?B?OGQ2TWdnSjRRQnIxUm1vbGs0Z3QwcEI3SVcyUlF0UzFsSDVyUWZzYXdSOVI3?=
 =?utf-8?B?SVBzZ1BWbkJtdXpzaXFWcWZobllpKy9KNmdxejdIa3NRZmZLN1F5Mm5Wc000?=
 =?utf-8?B?d1Zvb0VSdmxJcmJoMjZJKzZVNzRvU0dvQ2dKaXFLNlVYazBYbHpDcnYxSTRX?=
 =?utf-8?B?MEd4MkNWOTFlWkhrdFB1T1pJK0EvTzNLUktaQXZEYVBVSEJpS3ozOGdXOWVL?=
 =?utf-8?B?UXgvR0NCZE1pZVJrR0VuVHlXTlhJRVdjaUtBQUYzdW9aeHh3Sk9UOVllWEVR?=
 =?utf-8?B?eFowRGdUbDNZaXlSKyt5Uk9RRUhWaTl2WE1tU3NvcGp3T3ArYS95eGtiRW9O?=
 =?utf-8?B?SFM1WFc0Nk93ZTdDUUlLUU14d2NCYWlaSWFrUkovZkRvQmRXc0ROVVRGckVB?=
 =?utf-8?B?cDAyR1p6ZHMraUhFZ0RzWnB0VkRDNW11cG5tem96OFZzdUNIMTZCNTkwR1pI?=
 =?utf-8?B?NGEzOFRUT3E5NU4zWUl1VFpIaFZNYXdxNWxhRHl1ZUNVTFh3b2E4djNxcnJ5?=
 =?utf-8?B?VENIUVplT29VSmFlWU9uQ0ovUWxzd1h3U0Y3QUVING9ybDgxVkdLME9Pb3No?=
 =?utf-8?B?YzdndElUNExFRHdXc0xRdys3NzhYWXBBZEk2WXA4U2VybHJBOWNPVkFBU1F4?=
 =?utf-8?B?M2ROcmkyR1RFRDY0akdhdmExb2EwRW80RG4zZGVmQURKa2VodXdwNWlMZW1B?=
 =?utf-8?B?TWRpaGhtN3h0aWZUVWsxc3J1bmoyYVozUktUYnB1K21YM3pDMlZmbE1lNDVB?=
 =?utf-8?B?LzJBTzFuTXhVaFlVVFlhWnVWZXBLWXR1T28xV1dWMm1ISGl0YVdRT01jTFJp?=
 =?utf-8?B?R3MyeHR6UEdiTTZ5bVNpMlROYXM3VUtLdi9uY1NEQm1WWnEvdk9HU1JOVklS?=
 =?utf-8?B?VmJrV3p2SUJseUg5Q3EyZHNEcTQzWmxsbG0yNHJnb3FPZlgvTDRrdG5mM3Jn?=
 =?utf-8?B?RmYwY09FcHJrNXRlTTU0SSs0OVNWKyt4TDFKcnYweVJlRUpqbGkycFlVNCts?=
 =?utf-8?B?RVpacGZRZGxFZW5LR0F0Z3NwMDY3c2xNS3JuaUFzb2ZkUWd1ZGlRaWQydkNN?=
 =?utf-8?B?eW4vNzBzR3QwcmhFNVFKNFBrZ1krdzN0cU1oYkYxcDhIZXdDaythbW9qTTdu?=
 =?utf-8?B?ajJ0RlNkbFBuRUNUbmdGQjdIemVGenl4bkQwSUtJZXdHQ1hSeDdmSXlISnBi?=
 =?utf-8?B?NktFcVpNZk5wT0k4bUU1YTdjSEhJRXlCMTNiKzNuWmhTaHdGTVoxT2luZExR?=
 =?utf-8?B?T3AzODFaRlBDcE02eG9IdDdvdFA1azlRdUZ4b01QajNhK3pOdllGb2lhbjBC?=
 =?utf-8?B?VWJZR2ExcDRNcnV6bkJKQ1VueWVUeTg4VTdVRXJQcXA3b2h3RmlOZVNLTDhq?=
 =?utf-8?B?c2hiSnErS2FRZUk0UDVFb3ZJMTlmRHB0VkpjUVJxekg4cXhxN0pDSEtuTGhB?=
 =?utf-8?B?QTZnRnFQZFFscmJVTEJkR2xhUUlBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <213C586EC33C734895FDE993C312440A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yYGwcNfO7LnAcEAvCVesDZe63PtkN7wfEo6wX3Z3k5keKwpgtMXo0UrrrKd7LigUvsTgTNxpknow/qlrmTeZ1c5le7THzCHicfjfUqZlP9F1sT8RfX06Fnra+Zvi1p2Bxw3x9xXahmiEeJnQr8Yj/h40jDCiC09rJo6eqCA0Izajnu+cjEkXciJ7Izx9U/yWJiuI94KMt+2aTtj/klQZDmNYim5fVjCUWUESiJAeSpXobfULftVMAKfkKM6Tg7rc7na5LDa1zCj5uQqh7b3QKb+pQSuWfwiqG88/GTZ/FtzQQg6U7B18zFU+gBL3fFTginhrUQ5tZwu9X7oREQRtTbJi2NGOYGwol5KvUQfw2Y15A6tDPXd7HkIxekoZHC4/3vxZROpbFs3asuUQma6s7wfwh/l9Q0e8hozXM85HMWAw+1vTTMfDMvCc0NN5ST0Tgfi0maPJGiv7Jy7uo2gOuyXvjpTmXat4/xQUM1+JoBgtvz1+m1AXhp/UbI+qyUxJkXQyhznnxF+MnvS0jFtI231ghNfpC5lNRcsVXdgSwfYA7MvbAh4Z3RhMuDuAtonceTD1Q7kNxF0nI0hM5iQXIlTt76Ps7iFZlcxmoJaNI2E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f766ed-080b-4da9-b7a4-08dd87fb2f58
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 15:25:05.6900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /+z0uA3GjEQrY+bik6ZDedoHUE5ZFy1qrxuQakfrdPAgtadxxrAxwKQl3D4x+qXeOo6kTQdoTHqXfqrqd8dwbmK6DCtO5syBYBzikTZu0SI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-30_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504300110
X-Proofpoint-ORIG-GUID: WWk2sJ6t8Hr60FnpIVHgpB8jfu0dXfag
X-Authority-Analysis: v=2.4 cv=Vq8jA/2n c=1 sm=1 tr=0 ts=681240d5 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=7-415B0cAAAA:8 a=9aGcBay9LoD9z4K_xqEA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22 cc=ntf awl=host:14638
X-Proofpoint-GUID: WWk2sJ6t8Hr60FnpIVHgpB8jfu0dXfag
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDMwMDEwOSBTYWx0ZWRfXw7Ybl6A5s8DB WtxA1swgrlGerj2W8RTs/apYLJy3eScyU1a7hCFTXzfuCd0aanTajecE1PROGQxGpnH87bVEdJs +2glA4tGPLZKX+T3iEGHyajJDYsVL5KPNwXxmqe1Ndues/4wG80U7VMt5iJPBEl5+Bpa8C+lCfQ
 th+BI/b1pptQDpSfyTdI9ds/vANl8wU+67/eSSe+QvQp78hKvIEHtKnmrmy87kQr+UnwMmrBEBZ a5M2j/ViCwcR0txRsRw70CV7SV+lRjniuw/CqeReAnj7I4bJwCcRvl+EOowpFqqgjWBZT4q2gVP NkwPfw6mfMQw3keD2hzPJkrS/vZoan7W3bjt7Iqvkr8+LZLeXhRY5WbbntLeoJaAR9mHIyTaANG
 1eX0lWPYMKg9T6CPcbHQPzpH9H/OudtZVF1gJm9WIOKdIkBzKvWP76+7vs8GtXMtpeJZT4th

SGkgRGF2ZSwNCg0KVGhhbmtzIGZvciBhZHZpc2luZy4gSSB3aWxsIHRyeSB0byBkdW1wIHNpemUg
aGlzdG9sZ3JhbSBpbiBuZXh0IGRyb3AuDQoNCldlbmdhbmcgDQoNCj4gT24gQXByIDI5LCAyMDI1
LCBhdCA3OjM44oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6
DQo+IA0KPiBPbiBNb24sIEFwciAyOCwgMjAyNSBhdCAxMToxMTozNUFNIC0wNzAwLCBXZW5nYW5n
IFdhbmcgd3JvdGU6DQo+PiBUaGlzIHBhdGNoIGludHJvZHVjZXMgbmV3IGZpZWxkcyB0byBwZXIt
bW91bnQgYW5kIGdsb2JhbCBzdGF0cywNCj4+IGFuZCBleHBvcnQgdGhlbSB0byB1c2VyIHNwYWNl
Lg0KPj4gDQo+PiBAcGFnZV9hbGxvYyAtLSBudW1iZXIgb2YgcGFnZXMgYWxsb2NhdGVkIGZyb20g
YnVkZHkgdG8gYnVmZmVyIGNhY2hlDQo+PiBAcGFnZV9mcmVlIC0tIG51bWJlciBvZiBwYWdlcyBm
cmVlZCB0byBidWRkeSBmcm9tIGJ1ZmZlciBjYWNoZQ0KPj4gQGtiYl9hbGxvYyAtLSBudW1iZXIg
b2YgQkJzIGFsbG9jYXRlZCBmcm9tIGttYWxsb2Mgc2xhYiB0byBidWZmZXIgY2FjaGUNCj4+IEBr
YmJfZnJlZSAtLSBudW1iZXIgb2YgQkJzIGZyZWVkIHRvIGttYWxsb2Mgc2xhYiBmcm9tIGJ1ZmZl
ciBjYWNoZQ0KPj4gQHZiYl9hbGxvYyAtLSBudW1iZXIgb2YgQkJzIGFsbG9jYXRlZCBmcm9tIHZt
YWxsb2Mgc3lzdGVtIHRvIGJ1ZmZlciBjYWNoZQ0KPj4gQHZiYl9mcmVlIC0tIG51bWJlciBvZiBC
QnMgZnJlZWQgdG8gdm1hbGxvYyBzeXN0ZW0gZnJvbSBidWZmZXIgY2FjaGUNCj4gDQo+IFRoaXMg
Zm9ybXMgYSBwZXJtYW5lbnQgdXNlciBBUEkgb25jZSBjcmVhdGVkLCBzbyBleHBvc2luZyBpbnRl
cm5hbA0KPiBpbXBsZW1lbnRhdGlvbiBkZXRhaWxzIGxpa2UgdGhpcyBkb2Vzbid0IG1ha2UgbWUg
ZmVlbCBnb29kLiBXZSd2ZQ0KPiBjaGFuZ2VkIGhvdyB3ZSBhbGxvY2F0ZSBtZW1vcnkgZm9yIGJ1
ZmZlcnMgcXVpdGUgYSBiaXQgcmVjZW50bHkNCj4gdG8gZG8gdGhpbmdzIGxpa2Ugc3VwcG9ydCBs
YXJnZSBmb2xpb3MgYW5kIG1pbmltaXNlIHZtYXAgdXNhZ2UsDQo+IHRoZW4gdG8gdXNlIHZtYWxs
b2MgaW5zdGVhZCBvZiB2bWFwLCBldGMuIGUuZy4gd2UgZG9uJ3QgdXNlIHBhZ2VzDQo+IGF0IGFs
bCBpbiB0aGUgYnVmZmVyIGNhY2hlIGFueW1vcmUuLg0KPiANCj4gSSdtIGFjdHVhbGx5IGxvb2tp
bmcgZnVydGhlciBzaW1wbGlmeWluZyB0aGUgaW1wbGVtZW50YXRpb24gLSBJDQo+IHRoaW5rIHRo
ZSBjdXN0b20gZm9saW8vdm1hbGxvYyBzdHVmZiBjYW4gYmUgcmVwbGFjZWQgZW50aXJlbHkgYnkg
YQ0KPiBzaW5nbGUgY2FsbCB0byBrdm1hbGxvYygpIG5vdywgd2hpY2ggbWVhbnMgc29tZSBzdHVm
ZiB3aWxsIGNvbWUgZnJvbQ0KPiBzbGFicywgc29tZSBmcm9tIHRoZSBidWRkeSBhbmQgc29tZSBm
cm9tIHZtYWxsb2MuIFdlIHdvbid0IGtub3cNCj4gd2hlcmUgaXQgY29tZXMgZnJvbSBhdCBhbGws
IGFuZCBpZiB0aGlzIHN0YXRzIGludGVyZmFjZSBhbHJlYWR5DQo+IGV4aXN0ZWQgdGhlbiBzdWNo
IGEgY2hhbmdlIHdvdWxkIHJlbmRlciBpdCBjb21wbGV0ZWx5IHVzZWxlc3MuDQo+IA0KPj4gQnkg
bG9va2luZyBhdCBhYm92ZSBzdGF0cyBmaWVsZHMsIHVzZXIgc3BhY2UgY2FuIGVhc2lseSBrbm93
IHRoZSBidWZmZXINCj4+IGNhY2hlIHVzYWdlLg0KPiANCj4gTm90IGVhc2lseSAtIHRoZSBpbXBs
ZW1lbnRhdGlvbiBvbmx5IGFnZ3JlZ2F0ZXMgYWxsb2MvZnJlZSB2YWx1ZXMgc28NCj4gdGhlIHVz
ZXIgaGFzIHRvIG1hbnVhbGx5IGRvIHRoZSAoYWxsb2MgLSBmcmVlKSBjYWxjdWxhdGlvbiB0bw0K
PiBkZXRlcm1pbmUgaG93IG11Y2ggbWVtb3J5IGlzIGN1cnJlbmx0eSBpbiB1c2UuICBBbmQgdGhl
biB3ZSBkb24ndA0KPiByZWFsbHkga25vdyB3aGF0IHNpemUgYnVmZmVycyBhcmUgYWN0dWFsbHkg
dXNpbmcgdGhhdCBtZW1vcnkuLi4NCj4gDQo+IGkuZS4gYnVmZmVycyBmb3IgZXZlcnl0aGluZyBv
dGhlciB0aGFuIHhhdHRycyBhcmUgZml4ZWQgc2l6ZXMgKHNpbmdsZQ0KPiBzZWN0b3IsIHNpbmds
ZSBibG9jaywgZGlyZWN0b3J5IGJsb2NrLCBpbm9kZSBjbHVzdGVyKSwgc28gaXQgbWFrZXMNCj4g
bWFrZSBtb3JlIHNlbnNlIHRvIG1lIHRvIGR1bXAgYSBidWZmZXIgc2l6ZSBoaXN0b2dyYW0gZm9y
IG1lbW9yeQ0KPiB1c2FnZS4gV2UgY2FuIGluZmVyIHRoaW5ncyBsaWtlIGlub2RlIGNsdXN0ZXIg
bWVtb3J5IHVzYWdlIGZyb20gc3VjaA0KPiBvdXRwdXQsIHNvIG5vdCBvbmx5IHdvdWxkIHdlIGdl
dCBtZW1vcnkgdXNhZ2Ugd2UgYWxzbyBnZXQgc29tZQ0KPiBpbnNpZ2h0IGludG8gd2hhdCBpcyBj
b25zdW1pbmcgdGhlIG1lbW9yeS4NCj4gDQo+IEhlbmNlIEkgdGhpbmsgaXQgd291bGQgYmUgYmV0
dGVyIHRvIHRyYWNrIGEgc2V0IG9mIGJ1ZmZlciBzaXplIGJhc2VkDQo+IGJ1Y2tldHMgc28gd2Ug
Z2V0IG91dHB1dCBzb21ldGhpbmcgbGlrZToNCj4gDQo+IGJ1ZmZlciBzaXplIGNvdW50IFRvdGFs
IEJ5dGVzDQo+IC0tLS0tLS0tLS0tIC0tLS0tIC0tLS0tLS0tLS0tDQo+IDwgNGtCIDxuPiA8YWdn
cmVnYXRlIGNvdW50IG9mIGJfbGVuZ3RoPg0KPiA0a0INCj4gPD0gOGtCDQo+IDw9IDE2a0INCj4g
PD0gMzJrQg0KPiA8PSA2NGtCDQo+IA0KPiBJIGFsc28gdGhpbmsgdGhhdCBpdCBtaWdodCBiZSBi
ZXR0ZXIgdG8gZHVtcCB0aGlzIGluIGEgc2VwYXJhdGUNCj4gc3lzZnMgZmlsZSByYXRoZXIgdGhh
biBhZGQgaXQgdG8gdGhlIGV4aXN0aW5nIHN0YXRzIGZpbGUuDQo+IA0KPiBXaXRoIHRoaXMgaW5m
b3JtYXRpb24gb24gYW55IGdpdmVuIHN5c3RlbSwgd2UgY2FuIGluZmVyIHdoYXQNCj4gYWxsb2Nh
dGVkIGZyb20gc2xhYiBiYXNlZCBvbiB0aGUgYnVmZmVyIHNpemVzIGFuZCBzeXN0ZW0gUEFHRV9T
SVpFLg0KPiANCj4gSG93ZXZlciwgbXkgbWFpbiBwb2ludCBpcyB0aGF0IGZvciB0aGUgZ2VuZXJh
bCBjYXNlIG9mICJob3cgbXVjaA0KPiBtZW1vcnkgaXMgaW4gdXNlIGJ5IHRoZSBidWZmZXIgY2Fj
aGUiLCB3ZSByZWFsbHkgZG9uJ3Qgd2FudCB0byB0aWUNCj4gaXQgdG8gdGhlIGludGVybmFsIGFs
bG9jYXRpb24gaW1wbGVtZW50YXRpb24uIEEgaGlzdG9ncmFtIG91dHB1dCBsaWtlIHRoZQ0KPiBh
Ym92ZSBpcyBub3QgdGllZCB0byB0aGUgaW50ZXJuYWwgaW1wbGVtZW50YXRpb24sIHdoaWxzdCBn
aXZpbmcNCj4gYWRkaXRpb25hbCBpbnNpZ2h0IGludG8gd2hhdCBzaXplIGFsbG9jYXRpb25zIGFy
ZSBnZW5lcmF0aW5nIGFsbCB0aGUNCj4gbWVtb3J5IHVzYWdlLi4uDQo+IA0KPiAtRGF2ZS4NCj4g
LS0gDQo+IERhdmUgQ2hpbm5lcg0KPiBkYXZpZEBmcm9tb3JiaXQuY29tDQoNCg==
