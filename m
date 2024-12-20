Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F93219D8A9
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 20:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734728274; cv=fail; b=o4y7VEyKj90bNr78kLzcUHKX874D1IZPWn1DqUu4Son+YaPIoQlMEsZW/qXlTu/N+no5OisrYAWHnuuEK13edyALWZByHjXNuvqKX9dHashiw8hkuGgByCSlMLoFPKossF32Ob4638apirlnIdg6Bx0Ovx+xnjvTJGHO9Ge3HKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734728274; c=relaxed/simple;
	bh=z6PwFGidQZLqkuGJieigYHkHpkXuPcfDNZbKBTErWd0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XG+46KNBzKPTwk6tc5CEJgmqFNXC1pfcKw1QJnd9Bq74prdU5uEP/QAAqUDiN4rSgBboifcbMMzieXaExaI4IpRqk9ARxdJv/iX7D7De6r4TEuLXc0sD7B1MBkhb07j/WGxdMMxpe7dbsjm/NSqLIeg9MHuWNf6/lNATdvPievg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UMY6+SDr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HxJfdT0a; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UMY6+SDr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HxJfdT0a"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BKJIpQa001366
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 20:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=z6PwFGidQZLqkuGJieigYHkHpkXuPcfDNZbKBTErWd0=; b=
	UMY6+SDrnKwi5UGHHlJE03Xz/yAQaoz73t173EVoHI/3tf8n3LbGKrjEr+vN5DBo
	PlqY0CofM9uJZKi+NrIIIjT3ter8F11c6nb5OeonP8iAninpbWzw6NDVLniJ609b
	EK0eajMytCSJubuoep4YNR56w4MGnx+1A8Og4JvSjg6zf4LBNAxVRkmKzTpkv3u3
	+e+dOR1nWEriEUpLoG31rNHG/eAYZcuEn+YRwAgukaj3HVVYMy8bJk8xbg37jCwU
	90I2xZn0NuuvZkfK8T/eMqA2vOOwx8+9Px1Z7/Hdgj27+Q0Pmw9c/EfGQ2U6dDar
	fABH8X9vgDPrQIbKcH1W9g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0xb658t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 20:57:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BKIqFm7032928
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 20:57:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fk4ej4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 20:57:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oWS3Y8PRYDaFUDR/CvhRx0JUxSNyUg46+i6YTMQZE8WwYRuLpNCPuUI+kfsFl/hNg7HgILS5uvg+6Rmg+++qJ3SElk6xY0UAyYzdK6O+OsabVIxxiOSryi/0bMmi7Tcj0HSnjSVGfU1z6qNVTsHkCvnSzC3CTPYY9hFGiXyr5Dtq4hlt+O6rb/FTfDVC8QBQrpB3sXR3edyHQaMb31f4cQqKn2fzyBPh17rdB+ILwOPQA5QTNXU/2Rb+f/OBZ4gHzVXtlb7kedVN65Azr4/I620Rf0km2wBi1onvKIb+a1oM0Fu3feGuFy9nusxT7+k2TClQgfx3snBat6fpvs2ZfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6PwFGidQZLqkuGJieigYHkHpkXuPcfDNZbKBTErWd0=;
 b=tD0KbTFZYBfUPmwj1SCiV1mIIXUkysMCDy0htDRM+YCISmAEoZa6TML6aJu+GaQ2HQ/rOX5mHrW3PYseZPPZW9rvIkgpO3nEyU4Hf8CmB+7ziO+txPMdwxJrbMyMNXwFaq0AtHibSy59orNqZOszFERiyFidkQkVzbH0VPy4AlaJfo7RMyBWDLIGyDlweic6TxGDug/npckMNNiDFO62E7ELP63CPopTxN7o1jPtfYK9BAgYibZUGYvVa5UeUcXpDzgOl7tXV3um4ZndTGFjCB7nOYqA+kTI37eF70+PJ6vpAFXA8BYt93+kNc4l65SAQb0cPPw0xqDGgeyOhLTV+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6PwFGidQZLqkuGJieigYHkHpkXuPcfDNZbKBTErWd0=;
 b=HxJfdT0a08nbhtuYX5d7dllxCuHMvDT+9Z1Bek4H3bTdwmFX8oD1m/zXMXoXFXpU1bJjh7vyih3S28IyBl9dSoPAood2Spj0xzYaJq/CuGZt9Y3v2M7gtkQxThW3rUfnwqJm+bUtogbLDRx7eQ/CXI9vImLsP8DlM7V8IJmIosI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6625.namprd10.prod.outlook.com (2603:10b6:510:208::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.14; Fri, 20 Dec
 2024 20:57:42 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Fri, 20 Dec 2024
 20:57:42 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: John Garry <john.g.garry@oracle.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: add a test for atomic writes
Thread-Topic: [PATCH v2] xfs: add a test for atomic writes
Thread-Index: AQHbUCiRxjtdLN1WYUSKzGy07Slb4rLtZsEAgAI8gQA=
Date: Fri, 20 Dec 2024 20:57:42 +0000
Message-ID: <B0872047-F1FF-4458-A4FF-72351B2565E5@oracle.com>
References: <20241217020828.28976-1-catherine.hoang@oracle.com>
 <51981220-c246-421b-90b3-0b467a91c5cc@oracle.com>
In-Reply-To: <51981220-c246-421b-90b3-0b467a91c5cc@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.200.121)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|PH7PR10MB6625:EE_
x-ms-office365-filtering-correlation-id: c15f9361-52a5-458b-7692-08dd2138f267
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bEo4Vm5TRDd3dDlkS2Y2aVFSaXdHQU1HZ0pUS0FXV1NGTXRJaW5EaG0zWVoz?=
 =?utf-8?B?U01LR3JpV2s1cGp6NG5QbElETVRoL1d0eEFTVDE5d05PUG9kS0EycG5sUHpY?=
 =?utf-8?B?NEV5ZmhrUEp0MXNFcWcyN0pjNXhHd2lYVnNvL01HWmhGNk82bWdRRVVGQk9k?=
 =?utf-8?B?L0tkMm9BeUVwcFBEeUJUQXBJcmtid1F0TmF2SDZBZGxPVFNpdXhQOWRJVVVs?=
 =?utf-8?B?QktlTzBwMzVMYzBydVIwWDE4QVhHM3krZW8yVmNaZkVHM0dpWEVuQk1rYzJH?=
 =?utf-8?B?VUY4bS9UUWx1aUp5VmdjUHZpQStYYWRJNkFrV0pQeWJLZ1lMQ01KeVVYTUVy?=
 =?utf-8?B?d2NrYnFUSEI0R0hJWUg3Tm9zRXBrMkhBbHc1ZEYwK0ZjQy81RFRCSmdmT2dV?=
 =?utf-8?B?c1ZoUnlhTmNKQTU2R2lwMG9FVUhvNEhrL08ySmtJUDhrb1RKQ3FEWjhtRGds?=
 =?utf-8?B?R0hBSjhzWE5kZGErSnRWbVEwOC9XU1lKeTVwZkJXb1hMVTNhY0RYS1FFM2Zx?=
 =?utf-8?B?UitwTTRwR1lneXF5WjRFelpncWMrWTUzSkJCcHBkSm9FTTBjQzY3WGxDVys3?=
 =?utf-8?B?SG5HUHE0ck82bm9rdUlQZHUxem9XY0FLRVpWSjQ5T3UxTkpya2xNeHNhOU5L?=
 =?utf-8?B?dDVWVkZWNTZQUHdHY1RDajhSM3pJcmhMMFFCQnh3L0tXK1hGZkZOT0l1U0N1?=
 =?utf-8?B?U0hRbXAxVVJ4NDNmdHFpWS9zc2RQUi9mZk93cVZKK0Z5bFJjemlDaDhOcVlm?=
 =?utf-8?B?OGNZVjBhMTZOeWdtSFE2MXBMT0R1UmRaV1R4anhnSFpBZVhwMXkzeFNONGVt?=
 =?utf-8?B?WXFVbzBiUGxYUEU4eE5qb3ZENFUyZk5YS1FFbnlLTEJzQ3ZsOGZReWMvK0o2?=
 =?utf-8?B?ZEdxSDQ1NTRDbVBWbCtDQ2NKVFVQNjJmTStHN2dHSmZabG1lNXJUSG8zdGZP?=
 =?utf-8?B?UXJGLzFZSDFwYTZ0disrMHFrRVhqYmY5K1V6azVKVzQzZTAxTld1cVBpbEFi?=
 =?utf-8?B?WXgwZVE5NkZSMG5qMFhFNXRvL0xIVTdpNVlWd0JzcjgyUkRFbEYwTHcrS0xI?=
 =?utf-8?B?dUMxYWdkUHdtdkZkMWVUQkFLNzVnY2dxTTI5VDVPVDgrOEt3SWZkQTl5RW4w?=
 =?utf-8?B?eVpFL2VMSnJpMEdSV1cxYW9Cc0xtbmNxZlpERjdTR3dMWVZZYWF3eVlaL2Jt?=
 =?utf-8?B?bGNjNGdoR2FZVVZTNG9TQ0YyVFBKWGlvczE5akRhalY4aTNCYzNHYVpNdE1D?=
 =?utf-8?B?akdOYk52a1FxcThGSWh2Y1djVnZCNC9uY2xiZ2VXMlovdWMzK1NURitqeWY3?=
 =?utf-8?B?WmxYeWJ5OVB1Z1BhY0VpSldwbE1oa2YwRndPbEs3NHh0MVNGYmMySkp4SzlB?=
 =?utf-8?B?cW1SaldoakxQUFVQN2x0ZkN1Lzk1aHZlciswTk9wVWhxSldHcmtPNDhkL3lQ?=
 =?utf-8?B?WTdwL1grM3NtRWFkdWJoeXdCNzQ4UEcxRk9tWGdvYjVKbkdvUUY3VzNSZG5r?=
 =?utf-8?B?RGExaUFETHZiSjdVckRoK1BsaWU5MG1kaUpFL3pQWkhpL3pqZjVmdWNyaTNG?=
 =?utf-8?B?YU8rTXRDK0c0b0xUNmRGRXNhbGdUR0VHclR5VUtnTjdwakx6MWFZNDlzSm5F?=
 =?utf-8?B?L3NpZjZpcFU5VUxBcnFZMTNCa21WTlF2MVFDZHpaRFY4SzlSb0hHRXZtVklF?=
 =?utf-8?B?Wm5VRWh0cUN3VENrOUJDVm5aNXVXanhnS0p4c1ErQitFN1VLaHZNek9LQk9I?=
 =?utf-8?B?NllDRDdONmd2Q2FnbUNrci8zOFZFaVhRWTdzOUJRd1lVRDhxUnRTZEp0NVB6?=
 =?utf-8?B?K2JCYVFFRzM4OFloOXNVSGpqeHlZdGVyUXQ2VjlDVWE2aERMOE5Sek85NWhF?=
 =?utf-8?B?cTVhU1ZEYmwxbjd1WGkwUUprZDdnMGVjbHdrcGhpOGRURERjclNnMnYxVDFy?=
 =?utf-8?Q?Y2ROXBZonFBoZV0sr6ZHSRqIbCOfkQpB?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YWh6d3YyMXAxM3FHZE9UREhZK21JWlQrREhxaHUzeUlxSTFDZWJJNlFqaUtP?=
 =?utf-8?B?UEQzVktaclEvanEvakJVcDZ4TzROWjJCQnBxMnlLZFpSam53Q2EyYXhMYUhh?=
 =?utf-8?B?YW9nRXIzc2U1ejc4WkdGUDVMdStINFduZkxJNWFOaTBVbkxYdmt3M2Vtd3k2?=
 =?utf-8?B?OGo3UVdBTGNNV3ZlV2JjTUhSNEJpU0xFc3hHZkxDSGl4b3BEaGg1Q0FGc0Nh?=
 =?utf-8?B?OUhkZktqbG01blo1cEFxbU95eC9WMmlIS1BPdUQ4RWtCMWZndFBtWk4rS2Vs?=
 =?utf-8?B?dXhDNjJNc3pMei9CZTIreE84d3VzK01xSzFXcXRTYlZ3M0N4RTh2SlluRGM5?=
 =?utf-8?B?OVBraG03WVY4clVKTllTUDdUblhpMUdTOEdZSUFjTTZ0aHJzMVNCZG5HZHB6?=
 =?utf-8?B?ZDFsd3VqNW5DOXNSU3ZyNWYwS1VScFJ4OXQ3enQ0WHZLWVY1bmVSZlB1UG8z?=
 =?utf-8?B?RG40WHF4SDRMdU12M0RwOUhnVTlpdHhaVUxOdmg0MFgzajRZZkoxd3pmOXVR?=
 =?utf-8?B?UlJkTjZHaml5NGRUSmhXUkpLMDQ3NnovRi9TbCtjM0JNSFFzeFpGaTByelZm?=
 =?utf-8?B?YXhGRWsxN2ZDZStqbzM0M3YrVmwxNXFXUzIxSFJLWGE0SVBYL0tuN1VlT0R4?=
 =?utf-8?B?MzJBL0NycG5EaVJSTVJJMW9pa1JYV0NvVkU3K3R0a0RGbWZLcXAycHhzSXhZ?=
 =?utf-8?B?blNVN3RaamFIVlVGN3NtNHBmN1FLSmVLamV5bS9aUVg5aGZud1VvK29NYnFC?=
 =?utf-8?B?S1hLSStxY3BIenAzMkNXVS9NaTUwUFVwUjNGanR2K0VCM3pldDFxdHBwYk53?=
 =?utf-8?B?OWNITnRkU2Y0cURtY0hXdENqNUsvNVA3QzVCVDBCME9jcllZbEx4QkdYaXhh?=
 =?utf-8?B?VCsvRXpjRkcyaFpsMTJPZloyTWUyb0ppRExNcURpWURTN01md1Y1cFVDdHpX?=
 =?utf-8?B?cCs3RitwVWdNZ1IrSHFnRDhIS253ZlpmR2RSYjM3OWsrbWl6cElPNk1TTWxj?=
 =?utf-8?B?dVRYcmt4bDVtUWVkNkZ6bGlEN2Y5akNzRnBmNS93Yjhab3RrRUxzL2Mza1hk?=
 =?utf-8?B?ejdBbEVhYjUycDBybnU2alVqQnVKN2dIbFFqM1NNQVpFZ0lWUXZVYlN2c1M4?=
 =?utf-8?B?ajJyQ29QRmg0S0d2M3dkcEhkcWY3bndNZUczUGcxUHNlWm8rN3E5dEhBQXJY?=
 =?utf-8?B?bC9lSzFmd2ZxNU5TUmF4RE1SWXNqcmFDL0lsdnVwVXUyM0pnSlY0T0QrTkZs?=
 =?utf-8?B?RGlKTzNHd2IwZndid0RNMUJpSTlVa0tBd0JDVDY0amZDS1pLRjl1bVBGVzds?=
 =?utf-8?B?elE1UWFpTExjZzZuOFkzMGxFcWNUZkVndFF6cUJ6ZFRWMyt1UVBheFNQYXRv?=
 =?utf-8?B?TVl3OUpnUmgyYWYyZmNDNlh4b3dJYXIrYzZYVWh0SHR1YjhaYjQ3ejNvRExF?=
 =?utf-8?B?WmdwdXk0R0ZYTnFDUEZKR3VtdnRtbDdQNk0razFOOUhGK0ltSlN4TGdQRzhW?=
 =?utf-8?B?R3NibmExaThvODhWcURldWhYaFlUdUM2RTcvTUU4UEszQWl5Q2N5ZTZUOVc0?=
 =?utf-8?B?SjhldStMNC83dktiek55NWtGWU5tQkRMVGpzcnd5Mzg1dDBNUmZmYjl3YlF3?=
 =?utf-8?B?T1l2WUNRdUJBSHlxRS8ycVlRTCtkdExrQlhqWXNWMlV4SHR1NGU4QkZNemw0?=
 =?utf-8?B?R0RxMXJSajFZK1QweE83bG4xQnB5TXlHbEVkZnFRUk5Wc2hKZ0h1bDlwRTdw?=
 =?utf-8?B?MEYrOGR4aEI1eFB4a1JrSlVJS2FrMTJSMDUwUVN1clpmMDJ2YmdLalpnS2Rw?=
 =?utf-8?B?K3RBN3hWY0NOUkVFeG1vRThKSHNsSC9JNm5vaWlSa1J4UjlSRy9ZeVMvRXI1?=
 =?utf-8?B?cWdyZ25GZ2JmQ2RyUWhDZXpnWmppb2lBSmtGbWdMMU85d2kxakpFZHQ5Umh1?=
 =?utf-8?B?WDBsbHZQY1pPcmZPUDJ2Ym9VL1RzU0w5TFVIY3NxajIwMUJ5ZklWQmxHb0pp?=
 =?utf-8?B?eUpyYVZ1WDJVNEZyN29iTnJQbkpPVWpYQzBqc1pLU3YwVzhTdFFIOTluVVVT?=
 =?utf-8?B?VmRabTFGVFNRZGtvWXBLU1ZNNENIOTdieEZJVmQxb1FtUGFzVzQ3a29pWkZi?=
 =?utf-8?B?OEg2TFA1KzZhenR5cEZWenF3aXRUYmZQY2hiV3FkU2IxdDJwMjE4Vjg2TkIy?=
 =?utf-8?B?bFBKbkgxV0pweEIwNHBheHVWNittRjZXbkltWVBlcld0Yzk3cHZSclUwMWlE?=
 =?utf-8?B?SGRlQktoOGQ3RmRlL3hrZncvN2p3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE4D662B2CE73246AECD4BC3D54483E5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q59bMIUaOiNiQpSIAs52SopEREixzLYh7tw+CMATzlUpp4sl/0bLv02+OUUKP5xK9BBz9ElydwJJydxQCnJ2sKx3kI+FwD3KclBi76gm0dn7Bwkw3HFpfwKLtQQEQIGgodtbS2vLDqRqrjjEjzuHb9l8DO4rFCchx8GgWK5LbcdaNibsgMCulXyeaTJPOCfSIaJj9GYJf5St/XJibqOM9XGMvSSVRuvqUZofqjKq9S7b59OTR0PuTTaJ47847Uedfux1AttUQWpbGKyLSX+XtrBCvhHBq9CppbVfjkTaIKq4Wz6/F1kakLbCRpGDm3Hd3/27FfIz+UfJtbHAaFjo+qBUtCpHvseGEp8FEthD8SwYv8XmqY7XEAm74gegi7e1idE1qOL+2rhDHLrjnh3CGH39vPCPhbLiB50RMUjOooyL82OoR9/Af5l6+vzrkCQdYZtF7XYAAA271LhsAKNa6N2RgJ2MglowjISgcZCKT+0f+w3kAnf+qpu9unQhBCEHf0xjQPqS4LWiaRJJAf+7B8NHkXJw6S3KZMrKN0EpYFeum7wpIWg/z1F+kKtM32NtU/MmSAgw5NuwGOzXuphWIAT8w/qfa4TAHkymVVTSFyw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c15f9361-52a5-458b-7692-08dd2138f267
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2024 20:57:42.4903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2u03D5jHerTRuDAWXBpvn2N8we8SDT1MD1yESSzG7VZtdgTIZ1vKiltKII53zTtMY4PGpuGScsf43R7JxdsfcRWxwOcuLA4zk/3T0ypUb0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6625
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-20_07,2024-12-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412200167
X-Proofpoint-GUID: OckRy6VFcIj9pY-2xjttwJgkNMxceV7v
X-Proofpoint-ORIG-GUID: OckRy6VFcIj9pY-2xjttwJgkNMxceV7v

PiBPbiBEZWMgMTksIDIwMjQsIGF0IDI6NDjigK9BTSwgSm9obiBHYXJyeSA8am9obi5nLmdhcnJ5
QG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gMTcvMTIvMjAyNCAwMjowOCwgQ2F0aGVyaW5l
IEhvYW5nIHdyb3RlOg0KPj4gQWRkIGEgdGVzdCB0byB2YWxpZGF0ZSB0aGUgbmV3IGF0b21pYyB3
cml0ZXMgZmVhdHVyZS4NCj4gDQo+IEdlbmVyYWxseSB0aGlzIGxvb2sgb2ssIGp1c3QgYSBjb3Vw
bGUgb2YgY29tbWVudHMvcXVlc3Rpb25zLCBiZWxvdy4NCj4gDQo+IFRoYW5rcywNCj4gSm9obg0K
PiANCj4+IFNpZ25lZC1vZmYtYnk6IENhdGhlcmluZSBIb2FuZyA8Y2F0aGVyaW5lLmhvYW5nQG9y
YWNsZS5jb20+DQo+PiAtLS0NCj4+ICBjb21tb24vcmMgICAgICAgICB8IDE0ICsrKysrKysrDQo+
PiAgdGVzdHMveGZzLzYxMSAgICAgfCA4MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPj4gIHRlc3RzL3hmcy82MTEub3V0IHwgIDIgKysNCj4+ICAzIGZp
bGVzIGNoYW5nZWQsIDk3IGluc2VydGlvbnMoKykNCj4+ICBjcmVhdGUgbW9kZSAxMDA3NTUgdGVz
dHMveGZzLzYxMQ0KPj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCB0ZXN0cy94ZnMvNjExLm91dA0KPj4g
ZGlmZiAtLWdpdCBhL2NvbW1vbi9yYyBiL2NvbW1vbi9yYw0KPj4gaW5kZXggMmVlNDZlNTEuLmI5
ZGE3NDllIDEwMDY0NA0KPj4gLS0tIGEvY29tbW9uL3JjDQo+PiArKysgYi9jb21tb24vcmMNCj4+
IEBAIC01MTQ4LDYgKzUxNDgsMjAgQEAgX3JlcXVpcmVfc2NyYXRjaF9idGltZSgpDQo+PiAgIF9z
Y3JhdGNoX3VubW91bnQNCj4+ICB9DQo+PiAgK19yZXF1aXJlX3NjcmF0Y2hfd3JpdGVfYXRvbWlj
KCkNCj4+ICt7DQo+PiArIF9yZXF1aXJlX3NjcmF0Y2gNCj4+ICsgX3NjcmF0Y2hfbWtmcyA+IC9k
ZXYvbnVsbCAyPiYxDQo+PiArIF9zY3JhdGNoX21vdW50DQo+PiArDQo+PiArIGV4cG9ydCBTVEFU
WF9XUklURV9BVE9NSUM9MHgxMDAwMA0KPj4gKyAkWEZTX0lPX1BST0cgLWMgInN0YXR4IC1yIC1t
ICRTVEFUWF9XUklURV9BVE9NSUMiICRTQ1JBVENIX01OVCBcDQo+PiArIHwgZ3JlcCBhdG9taWMg
Pj4kc2VxcmVzLmZ1bGwgMj4mMSB8fCBcDQo+PiArIF9ub3RydW4gIndyaXRlIGF0b21pYyBub3Qg
c3VwcG9ydGVkIGJ5IHRoaXMgZmlsZXN5c3RlbSINCj4+ICsNCj4+ICsgX3NjcmF0Y2hfdW5tb3Vu
dA0KPj4gK30NCj4+ICsNCj4+ICBfcmVxdWlyZV9pbm9kZV9saW1pdHMoKQ0KPj4gIHsNCj4+ICAg
aWYgWyAkKF9nZXRfZnJlZV9pbm9kZSAkVEVTVF9ESVIpIC1lcSAwIF07IHRoZW4NCj4+IGRpZmYg
LS1naXQgYS90ZXN0cy94ZnMvNjExIGIvdGVzdHMveGZzLzYxMQ0KPj4gbmV3IGZpbGUgbW9kZSAx
MDA3NTUNCj4+IGluZGV4IDAwMDAwMDAwLi5hMjZlYzE0Mw0KPj4gLS0tIC9kZXYvbnVsbA0KPj4g
KysrIGIvdGVzdHMveGZzLzYxMQ0KPj4gQEAgLTAsMCArMSw4MSBAQA0KPj4gKyMhIC9iaW4vYmFz
aA0KPj4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4+ICsjIENvcHlyaWdo
dCAoYykgMjAyNCBPcmFjbGUuICBBbGwgUmlnaHRzIFJlc2VydmVkLg0KPj4gKyMNCj4+ICsjIEZT
IFFBIFRlc3QgNjExDQo+PiArIw0KPj4gKyMgVmFsaWRhdGUgYXRvbWljIHdyaXRlIHN1cHBvcnQN
Cj4+ICsjDQo+PiArLiAuL2NvbW1vbi9wcmVhbWJsZQ0KPj4gK19iZWdpbl9mc3Rlc3QgYXV0byBx
dWljayBydw0KPj4gKw0KPj4gK19zdXBwb3J0ZWRfZnMgeGZzDQo+PiArX3JlcXVpcmVfc2NyYXRj
aA0KPj4gK19yZXF1aXJlX3NjcmF0Y2hfd3JpdGVfYXRvbWljDQo+PiArDQo+PiArdGVzdF9hdG9t
aWNfd3JpdGVzKCkNCj4+ICt7DQo+PiArICAgIGxvY2FsIGJzaXplPSQxDQo+PiArDQo+PiArICAg
IF9zY3JhdGNoX21rZnNfeGZzIC1iIHNpemU9JGJzaXplID4+ICRzZXFyZXMuZnVsbA0KPiANCj4g
YnNpemUgKGJkZXYgbWF4KSBjYW4gYmUgdXB0byAwLjVNIC0gYXJlIHdlIHJlYWxseSBwb3NzaWJs
eSB0ZXN0aW5nIEZTIGJsb2Nrc2l6ZSA9PSAwLjVNPw0KPiANCj4gQXBhcnQgZnJvbSB0aGF0LCBp
dCB3b3VsZCBiZSBuaWNlIGlmIHdlIGZpeGVkIEZTIGJsb2Nrc2l6ZSBhdCA0SyBvciA2NEssIGFu
ZCBmZWQgYmRldiBtaW4vbWF4IGFuZCBlbnN1cmVkIHRoYXQgd2UgY2FuIG9ubHkgc3VwcG9ydCBh
dG9taWMgd3JpdGVzIGZvciBiZGV2IG1pbiA8PSBmcyBibG9ja3NpemUgPD0gYmRldiBtYXguIEJ1
dCBtYXliZSB3aGF0IHlvdSBhcmUgZG9pbmcgaXMgb2suDQoNCkN1cnJlbnRseSBJ4oCZbSB0ZXN0
aW5nIGV2ZXJ5IHZhbGlkIGJsb2NrIHNpemUgYmV0d2VlbiB0aGUgYmRldiBtaW4gYW5kIGJkZXYN
Cm1heC4gQnV0IEkgY2FuIGFsc28gYWRkIGEgdGVzdCB0byBtYWtlIHN1cmUgd2UgYXJlbuKAmXQg
ZG9pbmcgYXRvbWljIHdyaXRlcyBpZg0KYmxvY2sgc2l6ZSA8IGJkZXYgbWluIG9yIGJsb2NrIHNp
emUgPiBiZGV2IG1heC4NCj4gDQo+PiArICAgIF9zY3JhdGNoX21vdW50DQo+PiArICAgIF94ZnNf
Zm9yY2VfYmRldiBkYXRhICRTQ1JBVENIX01OVA0KPj4gKw0KPj4gKyAgICB0ZXN0ZmlsZT0kU0NS
QVRDSF9NTlQvdGVzdGZpbGUNCj4+ICsgICAgdG91Y2ggJHRlc3RmaWxlDQo+PiArDQo+PiArICAg
IGZpbGVfbWluX3dyaXRlPSQoJFhGU19JT19QUk9HIC1jICJzdGF0eCAtciAtbSAkU1RBVFhfV1JJ
VEVfQVRPTUlDIiAkdGVzdGZpbGUgfCBcDQo+PiArICAgICAgICBncmVwIGF0b21pY193cml0ZV91
bml0X21pbiB8IGN1dCAtZCAnICcgLWYgMykNCj4+ICsgICAgZmlsZV9tYXhfd3JpdGU9JCgkWEZT
X0lPX1BST0cgLWMgInN0YXR4IC1yIC1tICRTVEFUWF9XUklURV9BVE9NSUMiICR0ZXN0ZmlsZSB8
IFwNCj4+ICsgICAgICAgIGdyZXAgYXRvbWljX3dyaXRlX3VuaXRfbWF4IHwgY3V0IC1kICcgJyAt
ZiAzKQ0KPj4gKyAgICBmaWxlX21heF9zZWdtZW50cz0kKCRYRlNfSU9fUFJPRyAtYyAic3RhdHgg
LXIgLW0gJFNUQVRYX1dSSVRFX0FUT01JQyIgJHRlc3RmaWxlIHwgXA0KPj4gKyAgICAgICAgZ3Jl
cCBhdG9taWNfd3JpdGVfc2VnbWVudHNfbWF4IHwgY3V0IC1kICcgJyAtZiAzKQ0KPj4gKw0KPj4g
KyAgICAjIENoZWNrIHRoYXQgYXRvbWljIG1pbi9tYXggPSBGUyBibG9jayBzaXplDQo+IA0KPiBI
b3BlZnVsbHkgd2UgY2FuIGhhdmUgbWF4ID4gRlMgYmxvY2sgc2l6ZSBzb29uLCBidXQgSSBhbSBu
b3Qgc3VyZSBob3cgLi4uLiBzbyBpdCdzIGhhcmQgdG8gY29uc2lkZXIgbm93IGhvdyB0aGUgdGVz
dCBjb3VsZCBiZSBleHBhbmRlZCB0byBjb3ZlciB0aGF0Lg0KPiANCj4+ICsgICAgdGVzdCAkZmls
ZV9taW5fd3JpdGUgLWVxICRic2l6ZSB8fCBcDQo+PiArICAgICAgICBlY2hvICJhdG9taWMgd3Jp
dGUgbWluICRmaWxlX21pbl93cml0ZSwgc2hvdWxkIGJlIGZzIGJsb2NrIHNpemUgJGJzaXplIg0K
Pj4gKyAgICB0ZXN0ICRmaWxlX21pbl93cml0ZSAtZXEgJGJzaXplIHx8IFwNCj4+ICsgICAgICAg
IGVjaG8gImF0b21pYyB3cml0ZSBtYXggJGZpbGVfbWF4X3dyaXRlLCBzaG91bGQgYmUgZnMgYmxv
Y2sgc2l6ZSAkYnNpemUiDQo+PiArICAgIHRlc3QgJGZpbGVfbWF4X3NlZ21lbnRzIC1lcSAxIHx8
IFwNCj4+ICsgICAgICAgIGVjaG8gImF0b21pYyB3cml0ZSBtYXggc2VnbWVudHMgJGZpbGVfbWF4
X3NlZ21lbnRzLCBzaG91bGQgYmUgMSINCj4+ICsNCj4+ICsgICAgIyBDaGVjayB0aGF0IHdlIGNh
biBwZXJmb3JtIGFuIGF0b21pYyB3cml0ZSBvZiBsZW4gPSBGUyBibG9jayBzaXplDQo+PiArICAg
IGJ5dGVzX3dyaXR0ZW49JCgkWEZTX0lPX1BST0cgLWRjICJwd3JpdGUgLUEgLUQgMCAkYnNpemUi
ICR0ZXN0ZmlsZSB8IFwNCj4+ICsgICAgICAgIGdyZXAgd3JvdGUgfCBhd2sgLUYnWy8gXScgJ3tw
cmludCAkMn0nKQ0KPj4gKyAgICB0ZXN0ICRieXRlc193cml0dGVuIC1lcSAkYnNpemUgfHwgZWNo
byAiYXRvbWljIHdyaXRlIGxlbj0kYnNpemUgZmFpbGVkIg0KPj4gKw0KPj4gKyAgICAjIENoZWNr
IHRoYXQgd2UgY2FuIHBlcmZvcm0gYW4gYXRvbWljIHdyaXRlIG9uIGFuIHVud3JpdHRlbiBibG9j
aw0KPj4gKyAgICAkWEZTX0lPX1BST0cgLWMgImZhbGxvYyAkYnNpemUgJGJzaXplIiAkdGVzdGZp
bGUNCj4+ICsgICAgYnl0ZXNfd3JpdHRlbj0kKCRYRlNfSU9fUFJPRyAtZGMgInB3cml0ZSAtQSAt
RCAkYnNpemUgJGJzaXplIiAkdGVzdGZpbGUgfCBcDQo+PiArICAgICAgICBncmVwIHdyb3RlIHwg
YXdrIC1GJ1svIF0nICd7cHJpbnQgJDJ9JykNCj4+ICsgICAgdGVzdCAkYnl0ZXNfd3JpdHRlbiAt
ZXEgJGJzaXplIHx8IGVjaG8gImF0b21pYyB3cml0ZSB0byB1bndyaXR0ZW4gYmxvY2sgZmFpbGVk
Ig0KPj4gKw0KPj4gKyAgICAjIENoZWNrIHRoYXQgd2UgY2FuIHBlcmZvcm0gYW4gYXRvbWljIHdy
aXRlIG9uIGEgc3BhcnNlIGhvbGUNCj4+ICsgICAgJFhGU19JT19QUk9HIC1jICJmcHVuY2ggMCAk
YnNpemUiICR0ZXN0ZmlsZQ0KPj4gKyAgICBieXRlc193cml0dGVuPSQoJFhGU19JT19QUk9HIC1k
YyAicHdyaXRlIC1BIC1EIDAgJGJzaXplIiAkdGVzdGZpbGUgfCBcDQo+PiArICAgICAgICBncmVw
IHdyb3RlIHwgYXdrIC1GJ1svIF0nICd7cHJpbnQgJDJ9JykNCj4+ICsgICAgdGVzdCAkYnl0ZXNf
d3JpdHRlbiAtZXEgJGJzaXplIHx8IGVjaG8gImF0b21pYyB3cml0ZSB0byBzcGFyc2UgaG9sZSBm
YWlsZWQiDQo+PiArDQo+PiArICAgICMgUmVqZWN0IGF0b21pYyB3cml0ZSBpZiBsZW4gaXMgb3V0
IG9mIGJvdW5kcw0KPj4gKyAgICAkWEZTX0lPX1BST0cgLWRjICJwd3JpdGUgLUEgLUQgMCAkKChi
c2l6ZSAtIDEpKSIgJHRlc3RmaWxlIDI+PiAkc2VxcmVzLmZ1bGwgJiYgXA0KPj4gKyAgICAgICAg
ZWNobyAiYXRvbWljIHdyaXRlIGxlbj0kKChic2l6ZSAtIDEpKSBzaG91bGQgZmFpbCINCj4+ICsg
ICAgJFhGU19JT19QUk9HIC1kYyAicHdyaXRlIC1BIC1EIDAgJCgoYnNpemUgKyAxKSkiICR0ZXN0
ZmlsZSAyPj4gJHNlcXJlcy5mdWxsICYmIFwNCj4+ICsgICAgICAgIGVjaG8gImF0b21pYyB3cml0
ZSBsZW49JCgoYnNpemUgKyAxKSkgc2hvdWxkIGZhaWwiDQo+PiArDQo+PiArICAgIF9zY3JhdGNo
X3VubW91bnQNCj4+ICt9DQo+PiArDQo+PiArYmRldl9taW5fd3JpdGU9JCgkWEZTX0lPX1BST0cg
LWMgInN0YXR4IC1yIC1tICRTVEFUWF9XUklURV9BVE9NSUMiICRTQ1JBVENIX0RFViB8IFwNCj4+
ICsgICAgZ3JlcCBhdG9taWNfd3JpdGVfdW5pdF9taW4gfCBjdXQgLWQgJyAnIC1mIDMpDQo+PiAr
YmRldl9tYXhfd3JpdGU9JCgkWEZTX0lPX1BST0cgLWMgInN0YXR4IC1yIC1tICRTVEFUWF9XUklU
RV9BVE9NSUMiICRTQ1JBVENIX0RFViB8IFwNCj4+ICsgICAgZ3JlcCBhdG9taWNfd3JpdGVfdW5p
dF9tYXggfCBjdXQgLWQgJyAnIC1mIDMpDQo+PiArDQo+PiArZm9yICgoYnNpemU9JGJkZXZfbWlu
X3dyaXRlOyBic2l6ZTw9YmRldl9tYXhfd3JpdGU7IGJzaXplKj0yKSk7IGRvDQo+PiArICAgIF9z
Y3JhdGNoX21rZnNfeGZzX3N1cHBvcnRlZCAtYiBzaXplPSRic2l6ZSA+PiAkc2VxcmVzLmZ1bGwg
Mj4mMSAmJiBcDQo+PiArICAgICAgICB0ZXN0X2F0b21pY193cml0ZXMgJGJzaXplDQo+PiArZG9u
ZTsNCj4+ICsNCj4+ICsjIHN1Y2Nlc3MsIGFsbCBkb25lDQo+PiArZWNobyBTaWxlbmNlIGlzIGdv
bGRlbg0KPj4gK3N0YXR1cz0wDQo+PiArZXhpdA0KPj4gZGlmZiAtLWdpdCBhL3Rlc3RzL3hmcy82
MTEub3V0IGIvdGVzdHMveGZzLzYxMS5vdXQNCj4+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+PiBp
bmRleCAwMDAwMDAwMC4uYjhhNDQxNjQNCj4+IC0tLSAvZGV2L251bGwNCj4+ICsrKyBiL3Rlc3Rz
L3hmcy82MTEub3V0DQo+PiBAQCAtMCwwICsxLDIgQEANCj4+ICtRQSBvdXRwdXQgY3JlYXRlZCBi
eSA2MTENCj4+ICtTaWxlbmNlIGlzIGdvbGRlbg0KDQoNCg==
