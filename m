Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAC4145332
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 18:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721328054; cv=fail; b=U0Bw1mwma2ZFUWDMuHR7DnW07CbRpbxwBfe+G850uG2tjGAvvsEDNwTlb0EA0k0mOiZ/6Kxnc8nZLbApJEEM19cclE3ijaJFkYn8XdwvjL9rEQZi79gjVsqO4lVEAUD4M+eATSaI8Xv3bI7UEOkpqrWtOBQktfyh9k1bKUoyZLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721328054; c=relaxed/simple;
	bh=6SotAgoYV4vZj7kDRACxwM/ZucywK98VnJlBbA1ILns=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F6LlVRIylfN1kRmEnwIMsaMYKiKFEcklpC+W3v0odLnSyT1inN5rMfkmkF4QMv3MDJ6uvtB2kePAnxW65vBUa0tjizVU6+9+Sg7srEhLnz/FfMrK+Dg5wckwC1Htl65Hs8tLmQE+Tvdo2ZEHyX0BDMzQZgiXOaWAPe4xnvbGzNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EO/VoHnp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nbStFm/5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EO/VoHnp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nbStFm/5"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46IIZxVi021266;
	Thu, 18 Jul 2024 18:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=6SotAgoYV4vZj7kDRACxwM/ZucywK98VnJlBbA1IL
	ns=; b=EO/VoHnpj8RcWJ+pBB0AbCDKZNnC9cGKAPsayl5yoZuzUFjgrsRfsN0HV
	NcSPZrQJHT3johdJvnVoRZsyfTj/OfJBWgo7UHmHHS6BasmFNAPwCpBqcUDTD0CV
	zuplVj32i+z61s21LnTGVNPaEf0fwDfcrxn2p6ThEmj0y0o5tD9IiNU7+qKunIKS
	RpLPzPlqCGgBTwoOmLpIjYjVmYdonQCpmmurp4xHUZ26S7B72g7xdeKPTDnqXgJC
	6VC0x2N1Xxd4cjcKER4kHOjvH0T6ih01i9f/7GU7W3lUm6i7kgpOWvsM4n9MMI3r
	hxRZl4WJu3GkLYJGVceWX991YWgoA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40f8f600ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 18:40:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46IHuF6Y038864;
	Thu, 18 Jul 2024 18:40:50 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40dwewr9tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 18:40:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tuJ/QzOHc1Lb9JgoJkU2RiwwGtVHSYLJlkEew6lXgZzzka/+r6lDHRWTHGUyEY1B9CWWJCnX05t3VTq4/KMhZyrSAj7yuIvANT8qqAvYHQhpsVrFg3Clh6INr+wxm/wIpoJZJ9U+IWvWbQdHmHSs8CWF7MSAickAmERFO8Jq/4v7BymaMvl17DUfi6ohSWf2jNl5ahnsWZTGdeiY3eiRTWObEVfys5o7QBdFRTgPHHSOO9ScGuo03G63hTUEMbOYcjBY1wlNG81JKKFDUdJf0ZbP1Br9JvcrocI7sRt7KfcIf8EulnjcGHKik31p7zeXbJ0A3U10SJ+DKKc+8sngVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6SotAgoYV4vZj7kDRACxwM/ZucywK98VnJlBbA1ILns=;
 b=HA+p9dFuxxvYWkQdIZhy2LJhvx44cTRqfwch7ayabKnRvFkFU0NscDE06cSdOsnqC6QTpTiwNQ6DDt5EnTdPOOmXbZ3ZlRMnNjqpZrfMpvIiwqBuBp6L5i9SmtwAUduYtVgNhjOboM9xHhmkFoaqt+h+WDza6kFUtBxhSQDruUvT4+Sw8B+hSnspEov2OKdLc/UA7UWJls8OCRm81cqwX7/2dhXhN84miU1GYTbCF9OYj5Ch5exbB7HyBI34GANEnGrhsZp2ho7ifEh+no8dfOQzOkwhPjbpSLOfcEsmIcPV1gRtyrFZwEgBW2KDcqmPpVCrCxZT7YHeKjRlylnNDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SotAgoYV4vZj7kDRACxwM/ZucywK98VnJlBbA1ILns=;
 b=nbStFm/5TUiMhx1Y+JVgvc1UIW6Qv91eW24ZdP5iAfJb7jOqABAztbAQ1F4mDKqzF0AP9coCP4f630i0qOIU4VufwXC+znsK9f+RbDhS8LchJg28VWxHM4B1tntg7ypp6nr4W8vUlULoVeMpREwy+aeSHvhzxfEtQDWShv1/nFg=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by PH7PR10MB6529.namprd10.prod.outlook.com (2603:10b6:510:200::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Thu, 18 Jul
 2024 18:40:47 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7784.017; Thu, 18 Jul 2024
 18:40:46 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 8/9] spaceman/defrag: readahead for better performance
Thread-Topic: [PATCH 8/9] spaceman/defrag: readahead for better performance
Thread-Index: AQHa0jOwoj1v9LT7c0+0oiUxs1Z13LH4kYOAgAROCYA=
Date: Thu, 18 Jul 2024 18:40:46 +0000
Message-ID: <71F0919A-6864-4D78-BED7-8822DF984B92@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-9-wen.gang.wang@oracle.com>
 <ZpXFLwHyJ4eYgQ0Z@dread.disaster.area>
In-Reply-To: <ZpXFLwHyJ4eYgQ0Z@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|PH7PR10MB6529:EE_
x-ms-office365-filtering-correlation-id: 256dd255-7c85-424d-a97f-08dca759236d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?K3oxSlVyZkpBQUc1QWdsM2g3ZXRkd0Q0YU5nT1N4Q202Rkh5V0ZpSm15OHRN?=
 =?utf-8?B?RG9qNlRxZkhWZHozUHYzeEo1T1JVVE9iUTBSZkR2SFY4Y3pQVXNlSnkxOTkw?=
 =?utf-8?B?UDlHTWlqbnlYczRLTktULzlaUUxqK01qRDhJWlZnc1A2djZFNjI2OUpvSzdT?=
 =?utf-8?B?V0MyZGNkWkR3VkVQaElZek5GRW5SWFQrUXNhTk1sZ0xZKy9wRUNWQ2JRTXFr?=
 =?utf-8?B?alZ2Z1I4Yi9nam5KbFMzVDY2SS9yb2V6YUoxcmNJcUNKSDR1THIxRU1GL29P?=
 =?utf-8?B?Y1Q2RTNDQWlkYUk4N2NJQ3RoSmkrc1V4RHcxcFpTRlQvQjBJaDJxWDlvdGc5?=
 =?utf-8?B?MlZDSEtFdStNLzhJZGFIRmljakYwTTFHYU9OY2c1VFU5Q2w1YmtIVlJBZTZN?=
 =?utf-8?B?RVM4VFFIZWZwZkwrQ21jRGJyaUkxbjUvSm1OQlpEL0pvdW8xZjJMd3lkdmxu?=
 =?utf-8?B?YllybGFJcUhmWUFWWGx6ZEtBekJzUFFWdnZHWFNFbytxVW5YNWk1eDU0TnZD?=
 =?utf-8?B?OEprSjdidFhNbmkydGdObDMyL3Nka2huWmc1ZVc2eWgrZG82VVQ4NXFQRzBV?=
 =?utf-8?B?cVk4YmVBSzU0anArK21Eb2s4d1lWR3BpQjVBWVJJdWxoaG93UGIyOTdSYnB3?=
 =?utf-8?B?S2o2RW5QOVJ6MnhEd29WVERPaUYxbCtleFZlQW9iRjRtR0ozWjRXUi9WRTV4?=
 =?utf-8?B?cy9hM0Y0Mkl6S2pWQjhjc3d4WWdnemxEWXZSZGpDZ090VVhpUXE2S1FhR0R5?=
 =?utf-8?B?YWZnakxnK2szV3RJYUYxRDZaNldTcS91S0FCeDBFa0REK2NqdGlHWXlsR2Fu?=
 =?utf-8?B?UXRXdTdjRWZVdXJzUXZrNTJ4a29uNnpEeFZqa0xDYWFVbUFzZ1UvTW12U1pj?=
 =?utf-8?B?YWhOa3k4V29Dc2x3R1g2aTlWeDJWYXRVR1BiTHFKaGhoYjhjdUZXcTg0ZEFo?=
 =?utf-8?B?NWliZlNDeHN6T0huaTE5SVh2QWI5LzUzUHVjY0Z5aVA2QW4wdldjZS9TQWdw?=
 =?utf-8?B?OWxNVDJVWVYxOFFtQ0RxNnF6aDU3SE4zWDBneHNMaW9BSmgxOGRwbldlNGNw?=
 =?utf-8?B?SVhVeUo0Z2FaTG5qQ0N5NXg1T1Z6bCtMK1pqZm9ZbnViSXloQStmUFlpOWRM?=
 =?utf-8?B?elQrdVIzNEJwSkJmZmxTMTJXaVZxZzJRZXdUcHhqR24zMnJIYkd6QVpqZnFC?=
 =?utf-8?B?L3pXbVRWRE10THR6cE8vZi9tRlE1ZlplM1c4UUFGUWtEV3g3dCtsNnpGSGx0?=
 =?utf-8?B?aGx3RDJQTUFKV2g5dDVFN29ycVgvODI1L09aOXp0ck1HMklIZEVJSURzTFhn?=
 =?utf-8?B?dlVMbnpvUUxjR3FGMEFiaVhMek82WVFkdXIyWUVmQitIUDdRbll2dDJDWEVm?=
 =?utf-8?B?NTg2eU5Ud3RqQmVsdkc1aHYyZEQ0L0hLMWhpbXFpQXBkcDh5N01Nbk8reWlX?=
 =?utf-8?B?RnRjSnJsa2VvRk12T3p4WTQvTk1MbEpCOGpiNk02NHZrNGZnQTdGclhXcGVj?=
 =?utf-8?B?SUQ1YWVQVnZtdnkvMlBjY3Z4L1cxTlNOTXpQWnNYNmhhL2hKWmNuMVBadUx5?=
 =?utf-8?B?b0l1TzBYUzBQQUZPODA2Tlk1OUx1enJocjV3c1YyTjJFT2JsUGE2eDg1aWN2?=
 =?utf-8?B?amw3YW1rODhYVEI3UkRaSHRMd1Nndk90VXk5YVNySTRLSzA2VEhrem5iUldi?=
 =?utf-8?B?NUxibjFRTFRlTjkzMG92V1ZiWDg1Uno1Y3k5OXEwcGx3UlM3SEhLZ2pIOGRy?=
 =?utf-8?B?Nzl1dlFiU29xOUlhVURpMlByc3UxRDhtM3pjUXBJTllRUGpXY0EzUlE5TUNK?=
 =?utf-8?B?ZWRxem9jYlAvM0Jkbk1CdGtNRkV0R21Ra3lWajYvd255WXZnL2FTRmszQjQy?=
 =?utf-8?B?dTlUanRSSWNMclhKc0RDd1drcXVwMjFLa2ZZZTNucnBZRnc9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?MG5nQnIrTTlyQnNENUdXd1dQNGdubStobTRXc1l4cXY1ZVZUSm1TSTNjelVH?=
 =?utf-8?B?RE4zU3BUQ1RncGxEMFFvYTBocDRsM3ZnbW1VU1EzRmhaMm5yR3p5bXcwYm9t?=
 =?utf-8?B?ckttV2pGS0RTeFIzZGFLcUZSbDhFeWQ0NW1nZHh0VXlZVGJWd0dxdWRkcGtP?=
 =?utf-8?B?UEZQeHFmSFZRdi9aajkreXJFMVhoU2RGTVFKVnhPODJEMkVkWU9yUDdQb0FG?=
 =?utf-8?B?ZDNZY2ZJakVIcGtyb21QYm12UFZVVUVzU091VUJGcmdlQTd5UzRncWwvYWhy?=
 =?utf-8?B?Mit0VXVUQ0NMWkZKTEFWR2JwdXowR0ZVbW5WSW0vdTBnOUh2aU1pQWx3QytD?=
 =?utf-8?B?Q2VxSFVpUVo3SFBlbFNnbFNWRHFyTjU5SG1zK21GSEttOEo1THlsdlZMd1ZL?=
 =?utf-8?B?Mjlad0d0YUk1dHlsU0FtZkN0Nm8wSEdFZThuNmNGRXpZTEpOSEJOcVhLclRL?=
 =?utf-8?B?QlZlZDNSQnRRcSt2djlPZ1FsQUdCVHA0ZGZleHBUQU15RERIUS92c2VrOUNv?=
 =?utf-8?B?elcvb0NBNFZieHBZYXNZT1NvV0VXNGd5cVZEVWtNY3duUW1DVTRoR1hWUmx6?=
 =?utf-8?B?bTRwdG05WkRjanNvTDduRjVJL3p6eEJBT0M3QWUxN08zMGMwTXdTZEk5cldl?=
 =?utf-8?B?dVFwQWdIZENPaGJCOXVpUVg3d2JtaXRqbExFdlpqM3pLamJQUHdMNlkxb2cz?=
 =?utf-8?B?QXFrVDhDQ0JiQk5BcUJUNHZwdlpiRFg3YUFSTkVlcHU2cGJyRzJCSm9oSG8v?=
 =?utf-8?B?ZnRjNUlvbWpDZ09VNjVBdFFYbFRPRjI0eStPL1VOdnluUjZPUGhDRFYrSFBU?=
 =?utf-8?B?ZXpDaG9Va1pEekt5MlB6VHgrbWlvSHFuSzZEYVAvdGl1SnVEVnRXcTVrNDRz?=
 =?utf-8?B?ay9FUm9pckpnaHZnMnl2Q3krY1JPWmZKQkJWdUxRekczVllwM0F3ZzRUck1U?=
 =?utf-8?B?SjUvL0cydFZnN2tvWlZDQTcyZmplVkVveWNxVFJyNXFWZkZSeGQzRU53Ullm?=
 =?utf-8?B?YS8zajR1bmJSc3dNOXN0cGJzYmVjU05YUlAzcmN3SnNpMllVN0x4Q0pFZVFJ?=
 =?utf-8?B?MHdzc2szOTVlYWVrSUYyNUg2MHJmbkpXL3l0cWxRaDNRWTBiWDBlWUo2TkU1?=
 =?utf-8?B?dlRBOHR1dmh1MEUxYzBOWTJBa3EyQytFSVVWeWNjaHV0QTVlS2dPQnVaSWFY?=
 =?utf-8?B?K1RDREl5SE8wM0tQUmhMa1J4V3VHWEVBT280d1kzT2JhM1drdTY3WFNiY3pl?=
 =?utf-8?B?YlAreUdWL3JDdVg5emxpcDMxZkt3WXhNMmlhR2RhT1FuRVk1RmhvWGhjZXoz?=
 =?utf-8?B?U0NEVngvVXM2Q0J6M2libkZKVHQxdWp4elI4ZFU0Z1h1bHhWbXE5Y1VETGxJ?=
 =?utf-8?B?UitmQ0k1eGEvdE9iS1R0L04zUzNBSWIvWDhmYURJTnRFV1M1RVVTYjlNa2FW?=
 =?utf-8?B?V0VTT2pZYWdySExFRWs2Rk93VVh1QWRXMzlpbkpLT2Y1RnBha1FUaWJTNGFr?=
 =?utf-8?B?cEJ4QlF5R3JkanFMZnhVYndadVZpb1ZOTm5XRkoycG5WOVZsd0FyWU9JazUv?=
 =?utf-8?B?TDlrVnE2U1lpM1NOdDFudWxCa2JBMlBxTHB6eFRpaGZ5Vzh5N0hiblpwNFI4?=
 =?utf-8?B?b0VDUTlkYTBHR3pqanhLYnZwQVQ2RCtlOUxhUTErdWRJNXRxVU5URjR0a0lF?=
 =?utf-8?B?cjA0S0k1K0M0cldEZWlFcm56eEdPQUpFeUUvRDBLRGFrdHczTDNZNU5mQzZj?=
 =?utf-8?B?TUFPMkVvbmI3S2ExMUtsUFE5azlCenBKM01KSGJkSmJheWg3Q3k2dzFvWU5Z?=
 =?utf-8?B?TnNkSDE0WGRxWjV1SkJJY01EQUZ2bjJqUER2amdkakM5Q1V2emFuanZ4Zlc5?=
 =?utf-8?B?RXV3Ny9xMkNrZjBzRm1EK25pL0hvTmpZV0ZhZDF2NlJDYUdlYk54VXdsV2Jl?=
 =?utf-8?B?S1UwVmVtVHVOQ3dDTDBxRWRiQjdrenpNVld2Q0RBSG9oWWtubjhONFNrRWQ0?=
 =?utf-8?B?NDdST0UxRVRRZ3ZpUG8vdW1pVzdRYm5TVFJvMnhOQk9FOFlOdDJCVU40Z1Yz?=
 =?utf-8?B?SWZkdFZDeFpzYjFwRjlLUzRDOUFndzdBYzUyMCt3T3R6dzkvd1cxdis3RHdl?=
 =?utf-8?B?OFRBVmVCcU9XbWtPbTd6VjQ5aEVyWnVoM0xsR3B5UFV3TU8rU2JVYzZEcFEw?=
 =?utf-8?Q?Q6dxwuvZAV+lg6IFz2YIqUk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84E809AEA8BCE94A8DDB76BDAAB95641@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iLO05k8Tm16Os/rFyF7JcqVOg8OfMjQ7xiRTUbzEcuTFVfOSoA4lNrP1EtJsH/sur0vw9eGWJfda8iJjP1o5+S92XgEqhTNgvcfSyKiqr+cdtS4OZMSIX2355a+qu856rCj0W9oZ+WIlt13kj4UY/79Cflxj/69W0t+oyl0xJKJmepPtn1FP14HUoz+z4fPIqkZL44b756Zp3sgvkhRdSeR2/QiBYMS6VR6ciM2oTVl/J2v2navIoDnhtt6+E25okzK1JnMGtkIMrZWyI/dSA/Y8W7EeLcwzLFlvO8Se5r3kE1LrLrqndfk/9rLI2fia50BU3d+8acWyAmdR5l+O60Bh/BdX75ZgLqCVk2L5ReyG8o94sZEBmjUhaNjuVxU6WDE15jXE4bxS4xApN9mXYg5qUy+whUsXKD4jH66k0rlsAqhUfrMyupWBXOMyoPI6vpvWP2kd6NgqaivHgrIG/8tfqQEmVbNYiyBkPnufkqWjA91DH34kJUEG9Ham+8hsKgPv/60k8+14HpEPpVZPiPLWiS6k7tira9n+mkJhULi3O+tO1sGhmHym72WUaCpr2rVd6VVBZtHNVXP/7XcTw7tItlxMoNVVDpo8JOTh3wM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256dd255-7c85-424d-a97f-08dca759236d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2024 18:40:46.7760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x/LpX3675kNs9ML2JnOU+PRs2JAe/MNoSjGkbVOUywDTPFVW1bhnohb9ebBLU3nX3FKxJSLrbHXKSoDZVO474RpfQH+GY2+w3jOTLvx6y4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6529
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_12,2024-07-18_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407180122
X-Proofpoint-ORIG-GUID: gC_-VNof-CO9lNQjn9EfJPjBw-v5rH8Y
X-Proofpoint-GUID: gC_-VNof-CO9lNQjn9EfJPjBw-v5rH8Y

DQoNCj4gT24gSnVsIDE1LCAyMDI0LCBhdCA1OjU24oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyN1BNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBSZWFkaW5nIGFoZWFkIHRha2Ug
bGVzcyBsb2NrIG9uIGZpbGUgY29tcGFyZWQgdG8gInVuc2hhcmUiIHRoZSBmaWxlIHZpYSBpb2N0
bC4NCj4+IERvIHJlYWRhaGVhZCB3aGVuIGRlZnJhZyBzbGVlcHMgZm9yIGJldHRlciBkZWZyYWcg
cGVyZm9ybWFjZSBhbmQgdGh1cyBtb3JlDQo+PiBmaWxlIElPIHRpbWUuDQo+PiANCj4+IFNpZ25l
ZC1vZmYtYnk6IFdlbmdhbmcgV2FuZyA8d2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tPg0KPj4gLS0t
DQo+PiBzcGFjZW1hbi9kZWZyYWcuYyB8IDIxICsrKysrKysrKysrKysrKysrKysrLQ0KPj4gMSBm
aWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+IA0KPj4gZGlm
ZiAtLWdpdCBhL3NwYWNlbWFuL2RlZnJhZy5jIGIvc3BhY2VtYW4vZGVmcmFnLmMNCj4+IGluZGV4
IDQxNWZlOWMyLi5hYjg1MDhiYiAxMDA2NDQNCj4+IC0tLSBhL3NwYWNlbWFuL2RlZnJhZy5jDQo+
PiArKysgYi9zcGFjZW1hbi9kZWZyYWcuYw0KPj4gQEAgLTMzMSw2ICszMzEsMTggQEAgZGVmcmFn
X2ZzX2xpbWl0X2hpdChpbnQgZmQpDQo+PiB9DQo+PiANCj4+IHN0YXRpYyBib29sIGdfZW5hYmxl
X2ZpcnN0X2V4dF9zaGFyZSA9IHRydWU7DQo+PiArc3RhdGljIGJvb2wgZ19yZWFkYWhlYWQgPSBm
YWxzZTsNCj4+ICsNCj4+ICtzdGF0aWMgdm9pZCBkZWZyYWdfcmVhZGFoZWFkKGludCBkZWZyYWdf
ZmQsIG9mZjY0X3Qgb2Zmc2V0LCBzaXplX3QgY291bnQpDQo+PiArew0KPj4gKyBpZiAoIWdfcmVh
ZGFoZWFkIHx8IGdfaWRsZV90aW1lIDw9IDApDQo+PiArIHJldHVybjsNCj4+ICsNCj4+ICsgaWYg
KHJlYWRhaGVhZChkZWZyYWdfZmQsIG9mZnNldCwgY291bnQpIDwgMCkgew0KPj4gKyBmcHJpbnRm
KHN0ZGVyciwgInJlYWRhaGVhZCBmYWlsZWQ6ICVzLCBlcnJubz0lZFxuIiwNCj4+ICsgc3RyZXJy
b3IoZXJybm8pLCBlcnJubyk7DQo+IA0KPiBUaGlzIGRvZXNuJ3QgZG8gd2hhdCB5b3UgdGhpbmsg
aXQgZG9lcy4gcmVhZGFoZWFkKCkgb25seSBxdWV1ZXMgdGhlDQo+IGZpcnN0IHJlYWRhaGVhZCBj
aHVuayBvZiB0aGUgcmFuZ2UgZ2l2ZW4gKGEgZmV3IHBhZ2VzIGF0IG1vc3QpLiBJdA0KPiBkb2Vz
IG5vdCBjYXVzZSByZWFkYWhlYWQgb24gdGhlIGVudGlyZSByYW5nZSwgd2FpdCBmb3IgcGFnZSBj
YWNoZQ0KPiBwb3B1bGF0aW9uLCBub3IgcmVwb3J0IElPIGVycm9ycyB0aGF0IG1pZ2h0IGhhdmUg
b2NjdXJyZWQgZHVyaW5nDQo+IHJlYWRhaGVhZC4NCg0KSXMgaXQgYSBidWc/IEFzIHBlciB0aGUg
bWFuIHBhZ2UgaXQgc2hvdWxkIHRyeSB0byByZWFkIF9jb3VudF8gYnl0ZXM6DQoNCkRFU0NSSVBU
SU9ODQogICAgICAgcmVhZGFoZWFkKCkgaW5pdGlhdGVzIHJlYWRhaGVhZCBvbiBhIGZpbGUgc28g
dGhhdCBzdWJzZXF1ZW50IHJlYWRzIGZyb20gdGhhdCBmaWxlIHdpbGwgYmUgc2F0aXNmaWVkIGZy
b20gdGhlIGNhY2hlLCBhbmQgbm90IGJsb2NrIG9uIGRpc2sgSS9PIChhc3N1bWluZyB0aGUgcmVh
ZGFoZWFkIHdhcyBpbml0aWF0ZWQgZWFybHkgZW5vdWdoIGFuZCB0aGF0DQogICAgICAgb3RoZXIg
YWN0aXZpdHkgb24gdGhlIHN5c3RlbSBkaWQgbm90IGluIHRoZSBtZWFudGltZSBmbHVzaCBwYWdl
cyBmcm9tIHRoZSBjYWNoZSkuDQoNCiAgICAgICBUaGUgZmQgYXJndW1lbnQgaXMgYSBmaWxlIGRl
c2NyaXB0b3IgaWRlbnRpZnlpbmcgdGhlIGZpbGUgd2hpY2ggaXMgdG8gYmUgcmVhZC4gIFRoZSBv
ZmZzZXQgYXJndW1lbnQgc3BlY2lmaWVzIHRoZSBzdGFydGluZyBwb2ludCBmcm9tIHdoaWNoIGRh
dGEgaXMgdG8gYmUgcmVhZCBhbmQgY291bnQgc3BlY2lmaWVzIHRoZSBudW1iZXIgb2YgYnl0ZXMg
dG8NCiAgICAgICBiZSByZWFkLiAgSS9PIGlzIHBlcmZvcm1lZCBpbiB3aG9sZSBwYWdlcywgc28g
dGhhdCBvZmZzZXQgaXMgZWZmZWN0aXZlbHkgcm91bmRlZCBkb3duIHRvIGEgcGFnZSBib3VuZGFy
eSBhbmQgYnl0ZXMgYXJlIHJlYWQgdXAgdG8gdGhlIG5leHQgcGFnZSBib3VuZGFyeSBncmVhdGVy
IHRoYW4gb3IgZXF1YWwgdG8gKG9mZnNldCtjb3VudCkuICByZWFkYeKAkA0KICAgICAgIGhlYWQo
KSBkb2VzIG5vdCByZWFkIGJleW9uZCB0aGUgZW5kIG9mIHRoZSBmaWxlLiAgVGhlIGZpbGUgb2Zm
c2V0IG9mIHRoZSBvcGVuIGZpbGUgZGVzY3JpcHRpb24gcmVmZXJyZWQgdG8gYnkgZmQgaXMgbGVm
dCB1bmNoYW5nZWQuDQoNCj4gDQo+IFRoZXJlJ3MgYWxtb3N0IG5vIHZhbHVlIHRvIG1ha2luZyB0
aGlzIHN5c2NhbGwsIGVzcGVjaWFsbHkgaWYgdGhlDQo+IGFwcCBpcyBhYm91dCB0byB0cmlnZ2Vy
IGEgc2VxdWVudGlhbCByZWFkIGZvciB0aGUgd2hvbGUgcmFuZ2UuDQo+IFJlYWRhaGVhZCB3aWxs
IG9jY3VyIG5hdHVyYWxseSBkdXJpbmcgdGhhdCByZWFkIG9wZXJhdGlvbiAoaS5lLiB0aGUNCj4g
VU5TSEFSRSBjb3B5KSwgYW5kIHRoZSByZWFkIHdpbGwgcmV0dXJuIElPIGVycm9ycyB1bmxpa2UN
Cj4gcmVhZGFoZWFkKCkuDQo+IA0KPiBJZiB5b3Ugd2FudCB0aGUgcGFnZSBjYWNoZSBwcmUtcG9w
dWxhdGVkIGJlZm9yZSB0aGUgdW5zaGFyZQ0KPiBvcGVyYXRpb24gaXMgZG9uZSwgdGhlbiB5b3Ug
bmVlZCB0byB1c2UgbW1hcCgpIGFuZA0KPiBtYWR2aXNlKE1BRFZfUE9QVUxBVEVfUkVBRCkuIFRo
aXMgd2lsbCByZWFkIHRoZSB3aG9sZSByZWdpb24gaW50bw0KPiB0aGUgcGFnZSBjYWNoZSBhcyBp
ZiBpdCB3YXMgYSBzZXF1ZW50aWFsIHJlYWQsIHdhaXQgZm9yIGl0IHRvDQo+IGNvbXBsZXRlIGFu
ZCByZXR1cm4gYW55IElPIGVycm9ycyB0aGF0IG1pZ2h0IGhhdmUgb2NjdXJyZWQgZHVyaW5nDQo+
IHRoZSByZWFkLg0KDQpBcyB5b3Uga25vdyBpbiB0aGUgdW5zaGFyZSBwYXRoLCBmZXRjaGluZyBk
YXRhIGZyb20gZGlzayBpcyBkb25lIHdoZW4gSU8gaXMgbG9ja2VkLg0KKEkgYW0gd29uZGVyaW5n
IGlmIHdlIGNhbiBpbXByb3ZlIHRoYXQuKQ0KVGhlIG1haW4gcHVycG9zZSBvZiB1c2luZyByZWFk
YWhlYWQgaXMgdGhhdCBJIHdhbnQgbGVzcyAoSU8pIGxvY2sgdGltZSB3aGVuIGZldGNoaW5nDQpk
YXRhIGZyb20gZGlzay4gQ2FuIHdlIGFjaGlldmUgdGhhdCBieSB1c2luZyBtbWFwIGFuZCBtYWR2
aXNlKCk/DQoNClRoYW5rcywNCldlbmdhbmcNCg0KDQo=
