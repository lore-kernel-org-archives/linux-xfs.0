Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052DD285414
	for <linux-xfs@vger.kernel.org>; Thu,  8 May 2025 17:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746724509; cv=fail; b=fyhYJb+YChRAqjLPlTpoHhgYtEkXi1UodJ0ZE3UGUeKbPx4ImPQuVO48m60Z2P67jmcHNpwj7SVoEieZyWIKsIQKewMdfONBSRXzkoqLDroDh2qnu9bk9AiCQua8P8SIOmprrr1NCiUFivNJHJuN6ZHfwJFUVgKZPEYKK+xo1K8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746724509; c=relaxed/simple;
	bh=kv5DyjpqVew0obIUaUzdZvVBFULILS/Judp/hV68QyQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JqkXNpHIsm9RzUOUPhAYOgLjx9qY8vxGPTyTnbJhXj8VDGtvUFi9Jd/2Jjm9EXfGaa9nwrVPACK4yCjmlUnv5dbg3FWhoDBTK4mrqLM7i5MAyPgUTMTBAxC/imymMDJKcoovI8GV9OLg6hsPrOtqr1YHsh7v+LU3IhD7sgIkm9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AzTiIsMX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ReDncDDg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AzTiIsMX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ReDncDDg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 548H25st005287;
	Thu, 8 May 2025 17:15:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kv5DyjpqVew0obIUaUzdZvVBFULILS/Judp/hV68QyQ=; b=
	AzTiIsMXFG4/s/+ne0/QB1l47cBtm3uJYwZV3cm2gO4FGbbFrB+bMRQJPVtXnV4W
	UEni4zQw66FdQ3AiI58I92Dq8cj/oMJlX2yQj/H70T0unJ58qRb1OU49D7MTRhJe
	mEgTm9tGq54GQqRQJKMR21EkVDVtaP46Xs4gtWClmUYdDD/BxwwSH7PiTccFQ3Bj
	0AAvstSprfL9Nmq/Ga3W8m14iDKS42mGZwa/NqOrAXQdHMzhk/XbGGo3BGXu+vDT
	GSwHIWPImVzkLTd4BzencINWcohY9ILXUHyDzMMttSdAIeBMtTdmaiyl+hXLBaIT
	0gvOfReS6gtT6r2x5SRwpQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46h0nc80ur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 May 2025 17:15:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 548GAJ9k035264;
	Thu, 8 May 2025 17:15:01 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011030.outbound.protection.outlook.com [40.93.13.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kbyj30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 May 2025 17:15:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FbF7FPPRNXEenvWvsBudc1+Apbqm6cJc20eJLBphPX+S5Fw6D17CU0Elbz+rrBoNBdEVHxElM0BWDqKaVnFDAiQjJmdyeoWU+xHR+uZfJqOGFO1oW8E7I0lwoExwGJ76JAALwrphscAvs+ucLHyBGEsAPu2ojW9LLfNbUSTHcL2dY4VQRLkaYomiwEljnomKCPGsoSn2F0WtiVcEddIlkH8VpApbh9S37atDBEMFVfHvuAeAWrWypaTYoCZ07JMdcUSQfWde2yO69Hl6rZb1lETfnNV52Pp3LbuDz40tsbkcJ1c+vUIUsddOjeH/lAtAyN1osdeMYX6SAu0Mi6eH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kv5DyjpqVew0obIUaUzdZvVBFULILS/Judp/hV68QyQ=;
 b=pZ37jWAupoHO6EArMNK7+yznyo3JS3eCSiXOrm84E9KN9ZTzhOZaaj1ivVhHW0bYXTOXtkZsdkYVsSAqc88NZDJPfSDlVxCa+62ZDrBP7+2Rf3ZAsP3Td8Cubf+CVY3D5W/4herPJw/34wiYuGMEqyDllm9h0flSKyuzMbTUl/y9S0tqnqxF5DCNethx7m8xh/C3qzkn8TDxqejHv9gXZez3elTBx9o/CFMGTbhDNnIP7R4ZMqhxSph0MjKWdr0R/pkQXTmSYW31vrwHsPvhyGJ4yowg36DAxOkVC903OLfp88rDDK+2Me9NV6A1AJ4aCcllWCW/LzZ/EMnNkYEGMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kv5DyjpqVew0obIUaUzdZvVBFULILS/Judp/hV68QyQ=;
 b=ReDncDDgLIuhRfUYdaPJEwrrVYbSINUxRL4+/CNaiUHCaIXAvoMwFOVX+rh3XmHsYQP5bPXSLzJ2+Y3zwj+I1ESk+UrzPZEg/vcQryhlA4/f94z+I4b13eTEvPO769b/PdjLPtUiU/1n64PwYQLaLt8MBLcJsg5tVWelU1gNVpk=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by IA1PR10MB7539.namprd10.prod.outlook.com (2603:10b6:208:448::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Thu, 8 May
 2025 17:14:54 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%5]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 17:14:54 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: dump cache size with sysfs
Thread-Topic: [PATCH] xfs: dump cache size with sysfs
Thread-Index: AQHbv5aQvCK3b0Ell0OXJA1bFZzrbbPIPEEAgAC99AA=
Date: Thu, 8 May 2025 17:14:54 +0000
Message-ID: <CFB084EC-00A9-4EF4-9DB6-34E1102774E2@oracle.com>
References: <20250507212528.9964-1-wen.gang.wang@oracle.com>
 <aBxHLBvotK0IH3tE@infradead.org>
In-Reply-To: <aBxHLBvotK0IH3tE@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.500.181.1.5)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|IA1PR10MB7539:EE_
x-ms-office365-filtering-correlation-id: 48c0a0d9-4f27-4d52-a9ad-08dd8e53d9f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NzNxUmtILzlvdTdxWks1Q0JRby9UbmJVNWM2UGFTT0FHM05OOGtYOWQ4N1RG?=
 =?utf-8?B?dkF6YXlyb2I3NkpvQVY5OU93YUZLN1BrV3NBTkRJaXVkTjdyUFpMOCtacUdy?=
 =?utf-8?B?K1JGZlBlR2VjdGlMUEFvTFRJNXhQWGNOcHV2b3NYT0svM0RZY2EyWnpuRTc0?=
 =?utf-8?B?eUt4NnV6SmZaRVZ1TVViUmFhRHNPSWNaWTAxbHdSZW1WQnRsR1ZLMkx0S3Av?=
 =?utf-8?B?ejl0NTJsWFNDVUtuQmdsYjdBMDMyaHdFeVJpMFRJU28yVG1jaFlPd1ZabkRm?=
 =?utf-8?B?S1k2UWNteWljYnRpTVFNYXdtNGhrenByMzl1cVh4YklDUnl6ZjZWR3F4RU0v?=
 =?utf-8?B?aUMwaHB2ZEtBR0VqWXQ1VnJ0QkdPeXZCVzhJQUI0SW1jWmlHQTNNRXN0eEN1?=
 =?utf-8?B?UjlSWDNYcE96OWFHU2paSWFtQ1hHV1Zmc1k0U3BJRE5wLzVIVDI1aXNpdmp2?=
 =?utf-8?B?Y29WM2Yvb0hDMzFISVZXU1FQWVplMUF3Z2NMNkI2dkkyR2FNb3dPT2x6SFZt?=
 =?utf-8?B?QWN4bHE5ZmZEbDc5ZGJGS1RKNWMvcWt2UWErUk5HaUJUUVFmemUxcE1oUWJW?=
 =?utf-8?B?NURldUVDWGh1MjJ3Y2NlZnllSlRUQUJ5Z1dqai9kUkhNV3g5K0F5TjRWZGtl?=
 =?utf-8?B?TEZHbVhzeVF1dEpyOTdlYUVWR1lEaGo3dTEyUUx3R1NRbUVuM2YwNTNSYzN5?=
 =?utf-8?B?VkxWR1NVbGlIbVFDNCtnSmtXZDZBZWpYcEdvL2svUS9URzFoQnBMT3hPR3NC?=
 =?utf-8?B?Z0FWM2lRNjJjSk5TY1RnMG44WExiUi9LTEZUZzNheGlpRVMwQkIxMTcwRjVK?=
 =?utf-8?B?dEdDYk05YmpiNTg4alZjTkxnaCtmeW54TmdDMmk2SkVXUFRoamtpZis2dUw5?=
 =?utf-8?B?Q2JCMVJEejF1VzNGVlRyczJGMC9pSkF2M2JPSzBMeURKeWZjWHpOVVpYZS9L?=
 =?utf-8?B?M01FNmdDa20wY1JFdTlxbitiN0g1UjVGV1BFV3J2M3NEYnZZbithU25QUytH?=
 =?utf-8?B?YmRad3RORis2ZXp0dnRxRHhxYm5zakdmTHc5dWdsd0N1NmhNb3dqUWZpZ0Zp?=
 =?utf-8?B?NW9WSkhmaFBscXZkOE9RalkzTVp5bjFMYU1yaGJrNU1peHlQTXRUaGJlTkRr?=
 =?utf-8?B?U0R2emtjT3RXUjQwWU1vamRZYnRXZDFWZzlvNmtVZU04RFljRXpMdzlhb1V1?=
 =?utf-8?B?VmhGeXpFU2tRZU9HQVBnVlRITmY0YVRINHNrbHVueEloME5oVVFmeTVDdlZL?=
 =?utf-8?B?aGpFTnd3Q09nZVpiSU5lcGZQRTl3Znd6VmJtM3pNWWNJZS9BeFE1bDhRZ3R2?=
 =?utf-8?B?N1YwWnduZVhKcDFscCtnTWVrUVFPcGxhZXlzbHhqQzIzWDU2bmFJaUVsTEsy?=
 =?utf-8?B?b0ZUdTRPUU5WWGxQM0JyZEdRVkJhUlNGN0tmRTdZVFRKYmhoWkNxWXJ0YTht?=
 =?utf-8?B?NE1CcUh5WnNCa2Q0WmdvVmdxRUp1dDFWYTAyOHNmNUd6eHJ1dGRxaVRPYVJm?=
 =?utf-8?B?bW84eGcyTXc4a1l0QkpOYXV4TUh0blFLZjluempvdnpCTVh0bHZDUVRzU3ZX?=
 =?utf-8?B?WEp4U3lvRjJBVzVnVE13YThlWlV2WUNUUjFSZ3BRbUpRZk1vZXlVR1JtbHF6?=
 =?utf-8?B?dHpFUjNHUWk4Z2dTd00vL01TcXFqWnYwUGpaSjc3K1IrT3JvOFdKbkhUTEdI?=
 =?utf-8?B?U1haNmNSQkl5ZWJvc2NaN3ZZOUF0ZE41NzJsenVoc3BDd3NOU1lrdnloSmNX?=
 =?utf-8?B?ckUxd1pGSHdadTNCc01tTWRRVEErWWRhYkZyZldhRjJLaUZnVTZadVJjamZw?=
 =?utf-8?B?UjBObXBTVVhXRjZ6a2hvdUZuRi9YU3BwNnFnS0V2UTZLTTYvb2FmN28ydUxB?=
 =?utf-8?B?WWFVOWx1WDVUV1FuTThCSUNTYmtxaGhPWEdUUVU4S3YxVTVOa2VyZ3N5U0tm?=
 =?utf-8?B?QTNIVjhFM3pQS016SmI0QjlLNm82cjAwTSs0Y3pLKzgreWRDR0tNTjNObXV5?=
 =?utf-8?B?aFlRSW1Hcm5nPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TG00eTdCVFFLVkhvbENjWEpENmhEWEVBZDNMRWgzWVkxS0lkZXZFY2I0a09Z?=
 =?utf-8?B?eUNWWEtFS1dBVWVJYTFpa1ZpdTBYT0NOVDVkRkJjMFhjQW1DSE9uaUJvSm9z?=
 =?utf-8?B?NllQaXpHNkxYSGZJc2tsSy9yMDdNS3pBVGRaT2crWGtmZ3oybUJmc1JnbFh1?=
 =?utf-8?B?T3BBM09XdzVWMHQ1ZjhFYW4raWUzL2lFNWEvK1RPU1A2eklFcnBqViswbVVI?=
 =?utf-8?B?YTR2YkxDK1BXbHE2clVwaVRYclJwdzBoTEUzM1MvdjJYNEMzRVczc1phRnQ1?=
 =?utf-8?B?QVdBYXlpRGJ5WVhUQ3FWTUJVVlB2NGhsVEUwN1lhaWNWZXVIdUFzbkRRdFZS?=
 =?utf-8?B?QUo2Wnl6ZUJmTDBVdThqWXhLaEQ4d01JOGJFd3VKb01UUnVsQmZqYXBPMGN6?=
 =?utf-8?B?SDE4bzJiVmZVK2NQR1pCKzhWZDNHaDM0ZmtFOFRIb0pWYkxSaERhdzU1Qzk5?=
 =?utf-8?B?WXRRajZCMHV0M3JUTkcvUURXSkhndThhb2FaSUQ4N3NPZ1FCVVdSa0ZadWlD?=
 =?utf-8?B?ZEp0ekE5ZlJpR3RVOHQzT2VaRWx6V2I2WG1TcE9Sdktxcm9HTmlEbDYzK2cw?=
 =?utf-8?B?aGhHbnhNZktwbVZvWnNmb0pwNURWamM4WkVxRnBMNEV5emtXTGp5UnU3M3BL?=
 =?utf-8?B?VUZwZDNzQWhGRG52NlJHV3RTckk3bElQSW5VYWtHbGpKcjRjbTdLSitLcWdY?=
 =?utf-8?B?ZVc5SUtpRk9YcDB5MEVPZU84SitWWThOWUtjci9tWnczdkZ5VGFQU2ZkV3c1?=
 =?utf-8?B?RVVHTHNVbGxiWmExOGhGVWpDNjF1c0dDNmg5ekx0R09HUmNLbkZ0MkI3WmlV?=
 =?utf-8?B?RWZOUmw2MmxUT1NpekVXQ05raEJKVDFRRzlwUG9CZ1RNOEQ5WmkxcThqKzZm?=
 =?utf-8?B?QzNUalFTSWlQM0p2MnRINmtnb2NXai81L1Z6cGZQOFRXUHFPbGYvamFuc245?=
 =?utf-8?B?SmR1TDRiQVZtOFpOOUVTeUI1ams3d0NWSGhoVnBjdmd2Zmo1UlJxcjl4TWJq?=
 =?utf-8?B?am0vZmlPK0RSWEU1Q0VpTzlDc0NCNm1rc0VOYUJwRVVjNmRlMTVJUnJmNXN4?=
 =?utf-8?B?TlhmSzBIcjdTSHlEL3BtWXF2QXI4dmdCemg4U1pOZk1BeEQyU1VrdDBQaVVa?=
 =?utf-8?B?b05UdWlyZXFnRW9DTUs1aksvSEMxYXFvZldiSURmVGpxTGNBMmhsVDA2V000?=
 =?utf-8?B?czBjVG1JTjdqbE5rWkFLOXU0RXNCTC9CRVJsb0VsZnkxc0ZIMG9seXdEQXpl?=
 =?utf-8?B?VWVoVVVqN0xTODRobXZKQys3R1htaE1DeFQ1KzVsRDZqeWJSZFJGMlU3MVdC?=
 =?utf-8?B?aVk1QkNoME1YS21FUHI1dVdSU3laSFF1YXA3ekFjQjNjVXZPV1prZ0dMN1N5?=
 =?utf-8?B?bjE0OEtYQ0tqRzYzQWVWK0J0SG14Sm10WE1CWWQ2MWVOMkdwWXFZNG9GaUV5?=
 =?utf-8?B?Z0VJVmU5TG5yV1M1ZFVmTFRITGhHbHBtMkZUS3FMM1FwTkEzQ2YvMU95MWo4?=
 =?utf-8?B?cHVKQlF3VVRGMVpZZFk1MlBZQmZXcE5jaFAvRmxZZW1XeGRLWVQ5RjU4RlBP?=
 =?utf-8?B?Ykp0N00zQWt3TndzaHdBcEpYL0t0RzJEdFpTRmZiakp4QWhTTW4wdFBidzBl?=
 =?utf-8?B?dkNZZDBrRll1TndzakljeVVmZ1dkSW9wcGREZ01HTEhCWmI3TUdxbHp5Vm4z?=
 =?utf-8?B?bFdabXJWc2M4K2pJeE1XRkphelZTRG9sbStWL1cyWS9FNFIvSnc3ck1YZlAz?=
 =?utf-8?B?RXlWUkdlN28vNUsvSkpVZUtqWElSVFAvdVNXUUpyYjR5bzYyakZlVDA0SmFE?=
 =?utf-8?B?YjJQWnRNQXRJMG85bElmWXY1WE1OWml1R1VLRXhpVXBZc0FwbTRqWXNlTVFu?=
 =?utf-8?B?dmp1WDBEV0crd0laZjVqL1lLcU1DVWozcU1IdzZiME5NY0daYXJPaFllc1VQ?=
 =?utf-8?B?TjViVDJ5cVpnQitKd29ONDFDbkVpTVRzai9tVkhMWUdTUmVZNUcxL2Myazkz?=
 =?utf-8?B?YlExZHU1b3E0VXY5SUdzUDVYeUtCZWdjUGt3MTFKazRDbmxST1ZMSHphRjVG?=
 =?utf-8?B?ZTB2aVJXeTE4dGQ4dStmVnMzanpXemYyQ0FQTmRIWXltbTU3TTdILzdUNHhk?=
 =?utf-8?B?VDdpdjFYSDRjNzlzSlFTL2ZkYlU1bGhEZDB3NmswZitsOUhGSUFHemQwWE54?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E151FAECA4B2B46BDDB083092EEBF44@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IUg9jyhushbGqMrvajzKNU8nVAFgf/1p1vIzHgu5xQijSyg7XGPZRtvq320THF1zOQXRc3t9VCs4aQeQdx6/t1wZrgHtRRyAey5cbOkk3SRHjlxOhVXVxWiKbWN1JJNWM6hmUWV0f0PjBcD5nVWewZSRwMaubAEMSYajLQBbbRTY9+ZdLpfzj1Ia421VIKNp7oc93RTXKJeS+QdTlKBK2Vci9ICLTFZtFvAHYXf4r+kcMmGrzN3aj0kNYmRYXKwWW4FMGU1q28XDgE6aJl1d8ro7zXa2QMxqbFj2+CEbCsWyMCztfk06ffSAbAq/HN2VvOpQWEavfst7ZIsX4eL4YIhdK4V1N7TOo0YreVAOyX/W9F3CCDwhL0U3M+7aPeqvVD5N2EVSuQDy0tU3Km7COiznd9cd6segcd+RlVqSHcmaZdQ4CkfiLHTzZrTQnqF3N/yEVJ6Yg2pZh4ghq8OvztypQaRBWE54LxPpqzJhRf+oHRKLDf8VMTxnFpj3JcR+lTLMKz4b3lYNl3thhc09ZoTu+FZDUfQCp06bnPoifdKyo/AI2eNKhGmun+TsUOqjX/V/PuZ+swEjfKBm/0LOa7RSuPSSbSs3Yu5OVEmb2dM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c0a0d9-4f27-4d52-a9ad-08dd8e53d9f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 17:14:54.6136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QzhjMs4XbPoVCdv0bBKw8ZG/hi3oOGqULLh6cGGpYqDEIP/DdzK9JMzeo5a2LSYd6YxWo0D3OjTHZmRu9XQqFPzPHqqMAyTft1CTkTsYqVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7539
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-08_05,2025-05-08_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=788 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505080151
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDE1MSBTYWx0ZWRfXxsbujaZwcH3W z7yyhyWIVVTD+qdANbW1ItYHWOyHXkZudFco2lP5FnaTzh3TVKqsNhe2LaneRuxBaot240iMIxU d0CGgSMBvOL0qVFUo7mFtVEkZj+fvPVamu75jC1S2IPX0PBx01nOHscJw6SsjarPM8Wk4NGxzpy
 ZNWJf0tp+XGAiP5FPBKB43xZHO0kIBw+3NqRf8W8LYEI3BXJ3q5jX+RjOnYPRfBX5HnP6Mo15Wh rGAvlCNfDzHxkvd5Q6z4yELoRPMpUwycrA3FOeipIE9ET//pmpd7PF5CAEguAvfOEIYQDx0TFy1 s2XwfVx2tYbpTizUMLt/ihJFYk9BcCMm6c2MH7ht9M+/4iPw4yrRAy2DA5LlxVGvpH4vfW45FTF
 b3Ya+2I80WIymBXHA3mMwv+3cv7A7kO6BasIw8ILU14j27mc4urH8yX7n59gzfBVgnyGbLU4
X-Authority-Analysis: v=2.4 cv=UPvdHDfy c=1 sm=1 tr=0 ts=681ce696 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=JfrnYn6hAAAA:8 a=ajms2pSK0lDfNTcYhPIA:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: yG2Kg9G6ofFzl-Vik7zVMe99pZHMWhsv
X-Proofpoint-GUID: yG2Kg9G6ofFzl-Vik7zVMe99pZHMWhsv

SGkgQ2hyaXN0b3BoLA0KDQo+IE9uIE1heSA3LCAyMDI1LCBhdCAxMDo1NOKAr1BNLCBDaHJpc3Rv
cGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+IHdyb3RlOg0KPiANCj4gVGhpcyBpcyBhbiBh
d2Z1bCBsb3Qgb2YgY29kZS4gIFdoeSBjYW4ndCB0aGlzIGJlIGRvbmUgaW4gZUJQRg0KPiB1c2lu
ZyB0aGUgZXhpc3RpbmcgdHJhY2Vwb2ludHM/DQo+IA0KDQpUaGFua3MgZm9yIHRoZSBpZGVhIG9m
IGVCUEYuDQpBcyBJIHVuZGVyc3RhbmQgaXQsIHRyYWNlcG9pbnRzIGFyZSBmaXJlZCBvbmx5IHdo
ZW4gY29kZSBnb3QgcnVuIHNheSB3aGVuIHhmc19idWYgaXMgDQphbGxvY2F0ZWQgYW5kIHJlbGVh
c2VkLiBXaXRoIGVCUEYsIHdlIGFyZSBhYmxlIHRvIHRyYWNrIHRoZSBhbGxvY2F0aW9uL3JlbGVh
c2UsIGJ1dA0KSSBoYXZlIHNvbWUgdGhpbmdzIHRvIGNvbnNpZGVyOiANCg0KMS4gV2UgaGF2ZSB0
byBrZWVwIHRoZSBzY3JpcHQgcnVubmluZyBhbGwgdGhlIHRpbWUgc2luY2Ugc3lzdGVtIGJvb3Qg
dXAgdG8gZ2V0IHRoZQ0KICAgIGNvdW50aW5nPyBJZiB0aGUgZUJQRiBzY3JpcHQgZ2V0cyBraWxs
ZWQgc29tZWhvdywgd2UgY2FuIG5vIGxvbmdlciBjYW4gZ2V0IGNvcnJlY3QNCiAgICBpbmZvIGFn
YWluIHVudGlsIG5leHQga2VybmVsIHJlYm9vdGluZz8gDQoyLiBlQlBGIHNjcmlwdCBpcyBub3Qg
Z3VhcmFudGVlZCB0byBiZSByZWFkeSBiZWZvcmUgY2hhbmdlcyBpbiBidWZmZXIgY2FjaGU/IFNv
IHRoZQ0KICBlQlBGIG91dHB1dCBtaWdodCBub3QgYmUgd2hhdCBpdCByZWFsbHkgaXMgaW4ga2Vy
bmVsPw0KMy4gdG8gcnVuIGVQQkYsIGl0IHJlcXVpcmVzIGV4dHJhIHBhY2thZ2VzIHRvIGJlIGlu
c3RhbGxlZC4gQnV0IHRob3NlIHBhY2thZ2VzIGNvdWxkDQogICAgYmUgbm90IGF2YWlsYWJsZSBv
biBjdXN0b21lcuKAmXMgcHJvZHVjdGlvbiBzeXN0ZW1zLCByaWdodD8NCjMuIEFsc28sIGl0IGxv
b2tzIG11Y2ggY29tcGxleCB0aGFuIGEgc2luZ2xlIOKAmGNhdCAvc3lzL2ZzL3hmcy88ZGV2Pi9j
YWNoZS9zaXpl4oCZLg0KDQoNCldoYXTigJlzIHRoZSBjb25jZXJuIHRvIGFkZCB0aGUgc3lzZXMg
Y29kZT8gVGhvdWdoIHRoZSBwYXRjaCBsb29rcyBiaWcNCihidXQgbm90IHJlYWxseSB2ZXJ5IGJp
ZyksIEl04oCZcyBzaW1wbGUgYW5kIGRpcmVjdC4NCg0KVGhhbmtzLA0KV2VuZ2FuZw0KDQo+IEJ0
dywgaXQgd291bGQgYmUgbmljZSB0byBjb2xsZWN0IHN1Y2ggc2NyaXB0cyBpbiBzYXkgeGZzcHJv
Z3MuDQo+IA0KDQo=
