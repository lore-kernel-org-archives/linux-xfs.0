Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6808E10A36
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 23:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720740561; cv=fail; b=B5JiG0tm+M2Wb0hUxTgFi5z8EUg9gHn2czlpVBzPdwlaZHkATWwyWf7WaIDC5fHm1wRO3Jz0TQFt4fKRPPvn+Aeeyv9C52yf8oOUQc/8UCKpg40GkQMrFUP5utS1jaCmu1OiPKDt0Kx8sq9DA6Wkl/33a4F/WP39DZynmA24gnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720740561; c=relaxed/simple;
	bh=krYuRf2/yN6vU1lUq/33aPjeDv5iDRR/D7rtMXpoowE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qyrgHAsN9/f2jeMsWbt+I25WaSwX8t1g6F+mHT+q2HLu//mu2+P6JAI2ofyeK5+lgzlScgHgUuzizoRwWioMT/f4TZZQ0PwBRgfHp2iQSdjgfqtqllcgKT1Tin7dAN/eXpO9uj3NzlaWIZTgOcfLooyirsI2jR7U6ZJFtULSsm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HyHN0j4+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xlb0xuyM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HyHN0j4+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xlb0xuyM"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BKXWq2023528;
	Thu, 11 Jul 2024 23:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=krYuRf2/yN6vU1lUq/33aPjeDv5iDRR/D7rtMXpoo
	wE=; b=HyHN0j4+gbd3jfjGbcoJ4pKwKfjjegdnel/TMsM3ktc5jEiosNgzXil3o
	tHZHazxTaAvNJhyE7hwKnDFVa0BXwkvvRQnc8/u4XjAc+64l8RKDnVPxartM+XXQ
	Adm9dFQVkdC9fdwAr3ZghHsSXVX9tFyqXiibcWYfvFzmILAUXO1OEcKX6m7a2doS
	E+x1iUwbaIOhpDCUBD35vVfKEZAetZR6YLIy98NRGXtEB80i0eFpkmaTLJ3XQX6o
	LRBizqGThqdMGCXrnoAyBe1A+EW+Fpb0L8CdlIczCgCfDSk/GoZ2aLCPr07bkbq1
	9ySmhn5H2y2t9NcCZCreXx2MqzZCA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wt8jmnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:29:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46BM4v0N010418;
	Thu, 11 Jul 2024 23:29:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vv6djvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:29:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYxK/k8c4nA9vWPpE64L6BA4KwLWVAkgS2nL6Sj5gwGfIlDwjeck0s2R0A6ykQFFmo99ERYDT3LL17TgZHA+L8+HkJJoYCb32AsGAsESEMiLQtSvAHDK44eHmVBUUG4kEtaXo6EQpUUC+bk6wd/9ibOIqEjF65JIoiyNyTNoh8uKAQAJLVCyIYzD0wZmZ/ogFMK0o5beLU0K/EfbDlCEJdVfVJu4NoAtlFbd+Ew4jdvG8zznAvzWrDhqV9bfAdepYHLveWtmwDxT+LWhUBHfMvmbpFyuef0/hzhRv/kt35TNdUD9RmQI9JcNlOqVc1fisxRX4Sxc/MVevQgej3SJ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krYuRf2/yN6vU1lUq/33aPjeDv5iDRR/D7rtMXpoowE=;
 b=ti5P2G52efat6hynG4AKZvGg0CF2Er4tXk0XNTzG/P4poRUXZwMbvP/hZoPmtHE1lvg4cfonLTO+8HXWaSdWGJ+bxd8advakxkuWpPoET7HYCO24I4PVAfl1lhX1hMWHt7gYA4ksy3t+vMm86UXlWQc5UHfeoE8XE1NXFe8DXLs7rbEIEI8jh7pg83bCKFg+A7GDFjz3nS9h5Y1fKnOtDqsAjEZuQPAUJ4MN0RWrbunvWJxGwkAC/CkRFr7mRdPzyn+t9CjBssjCKJEFj/G0Df4MwYJZ/7Vd7B5bbgEviO04lkoDELXG1iQfoI4Z8QpBSRlUwlu80yzSQt8hJ6QODg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krYuRf2/yN6vU1lUq/33aPjeDv5iDRR/D7rtMXpoowE=;
 b=xlb0xuyML8mK1Bqa2Wqbjq7VXEW7kWYXif7xrm/Ay+POxtTLUbRNRkq3BGK6sS0Z/hYdzLFK8PRjqypOsf7VucQbKLdRYGN0U03oBvy+2XpAjpgeX7a80vG1OvIfrV4WdRE4An5uJPaQA5vSwi0WHJCnOPIwo87QEsTp24iPXOs=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by SJ2PR10MB7584.namprd10.prod.outlook.com (2603:10b6:a03:547::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.34; Thu, 11 Jul
 2024 23:29:12 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%6]) with mapi id 15.20.7762.016; Thu, 11 Jul 2024
 23:29:12 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 8/9] spaceman/defrag: readahead for better performance
Thread-Topic: [PATCH 8/9] spaceman/defrag: readahead for better performance
Thread-Index: AQHa0jOwoj1v9LT7c0+0oiUxs1Z13LHu2FCAgANXgYA=
Date: Thu, 11 Jul 2024 23:29:12 +0000
Message-ID: <3D1250F5-F716-4EED-AB83-D52F401CA264@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-9-wen.gang.wang@oracle.com>
 <20240709202703.GT612460@frogsfrogsfrogs>
In-Reply-To: <20240709202703.GT612460@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|SJ2PR10MB7584:EE_
x-ms-office365-filtering-correlation-id: 1e93ee9d-ee3f-4401-e88f-08dca201456d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?Y2w1RmRMRDVINlhMMENSbXB6SVlqRHhIOG0wYWYyOVVLelBxSnFTQ2ZqZHdR?=
 =?utf-8?B?VTBsSVhhS2szU1lLdVc3ZFI1UktZT0NCbEJiYm5TczVvamZKeVg1ZUdYMmdR?=
 =?utf-8?B?RzBtYXBXejZtZThYeGhvc2tMUnRVaXlBRGU2cDFvUytQWHFKeVkzN09mUTNm?=
 =?utf-8?B?RFFKQjFKSWxoVms2aGoyQlhYMjBDUm9rbWdJU2RibEh3RUNDZzZ6RVRzVDhU?=
 =?utf-8?B?OUtaSEJ5dDEwOWFSNEVpNStRand6OEhGUENma3RKVWU3MStoUklBajBBNlpp?=
 =?utf-8?B?ZDlKQkwydmw3emRjMy9TV3BuWU1Qdk5GbGprNHBUNER1QWNhNm44alphYmR3?=
 =?utf-8?B?eTkvbGRoSnNKYW5PR2VQb2R4NnFDRnZVLy9RRnVNZUs0Ui9aMUszbGV2OTlL?=
 =?utf-8?B?ZkdVaFdUN1JGSUsvMWdVelYyWVkydmNQRE8yN3I2RzFoV0lYTGpnQWxhUVBZ?=
 =?utf-8?B?K21pUmVrMm90TzhENUtQdkt6VkJSZ1VhTHNJSzRxbU9rZlF0QTliWEM4eWh4?=
 =?utf-8?B?em5xRDVKNjlUVVJmREpPS1RMa2VUSGFoMDNhNmdNK3poaUNJRGdCemQ2OVBV?=
 =?utf-8?B?SjlOOGxOdU9QMXBQSEtPL1FWblF1djFlR1BuVjdqT2dlZkhyRmdJM2V4OGhJ?=
 =?utf-8?B?bkJ6VnAwL1V0bDhxSDBRNnRyVnJIZU9md25FUmgwTG8zVXozSFJkTlhBcFBv?=
 =?utf-8?B?eXozcHRNSk1lQnAwTExCRmttVzI4WnJSbnFjUmNIeEl0Z0ZFazJBYjlpYnhN?=
 =?utf-8?B?MzZBRi9USVZibk1VZHRzcEIwS0Q2dmlOUlJJYmVhdkMrMmtwRlQ0OE5hdGp1?=
 =?utf-8?B?YjVQNGtwWmZuc2lvem5sZ3FCNTV3cEx4TmlFMkxnQWR1dmdjVWFGcmVKejli?=
 =?utf-8?B?RnhWRzFVYXFsMDBoR2Z3NDk3bHAxVnBiZTRlTHljOTAzRWdjbytiWExFOWNh?=
 =?utf-8?B?cDVkTTdUdExGWmw5eEFCaWNuNnVTTWlXVUpHNGlEVTJrOUtjV0lUMHFJQ1ZV?=
 =?utf-8?B?UVRKQXNKNjF3RDdDYVZSTDZERUtuN0FDN0FHYzhKWTJ5a0s1UENRdTZMeVJ2?=
 =?utf-8?B?KzExdjhZWjdIZEtnZ1lrbXZVV2dyV1E5MFBJRUxMTE8vU0ZWTnR4RUNLaUJm?=
 =?utf-8?B?WjZ3WlVGUHBWbXhBWDl5WDdmcHhNRWlXRzZsdG5IUjRidGdaeElPMk9VRGpQ?=
 =?utf-8?B?Zzgva0VqVE9sVUxkL015b3NIakZhUDYyWVBWUkt4RlR2a0lRQzRva0QvYlhJ?=
 =?utf-8?B?Qk5CVUdvUmF5Kzdsc01xUVF0RGR0dzE5Y1FQV0pSTnFYMzI5emVOVGhhcHEr?=
 =?utf-8?B?OUQwc0JKTFZBS3RscEdiZzlkNWRtdHlzZWxNc2pxTXRXSUlSNkNNMjRJMG94?=
 =?utf-8?B?aTkyWTNqTnh5blRsc0ZEVzhmYllrY1BXaDhLOFhiaDU4TmVzOGVjRlpsbVl2?=
 =?utf-8?B?bzdFcFNDYWwyN0VDenpMdytRdDM5ZUFSaUFXZzBXNjVMTjJKS2ROUEQ5dmNL?=
 =?utf-8?B?M0U4UnU2MitsaUxMeFNVUG0rZEE2SDdJY0FJT2FYZS96a2llMWF6cXg2NXpD?=
 =?utf-8?B?NVhGWDhTdWlrM1J4aHhZRzdHQ2tvVWozRDBBRjFaV0ROODdXbWZwdHVlUlEv?=
 =?utf-8?B?YlE4VUNJeUhCTStQV3JuSTVaM2xrSEc2RE9CdWtqc1lzZFdoOWd4YzB4TjNM?=
 =?utf-8?B?Q2FjenVJTUlmTVpUUDBPWm1JU0lrSDZibU0rUHFxN0FWQ1l4MnpKb0lJWFgw?=
 =?utf-8?B?THJtWVU5S0xpSFcyZnR3cGFwU1FwUVpMMThEK05zdTN2ZU1EN2NpM0h6cERI?=
 =?utf-8?B?bVNzaGV2TkxrSmlkdUo1WEZjS0RMWGhhWWZraXdFWjhiL1EyR0dlZVRWdHJD?=
 =?utf-8?B?ZFVITmJjWXhzUHhlWVR0bjhkc0c2R09adWI3Umk0QU5SbVE9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?Vmp3WFZUY0Q2WXVFQ1RnVDZTTGpCV2tNcXNTMUlOTzZvTXdtcVRqaEx3eFFU?=
 =?utf-8?B?MWtacVdabUM1RHVHQS80SG1IMU9zN0VXNDhFaUtaMEYrTnM1RlFhRGltc2Yz?=
 =?utf-8?B?S0k2YmRDNXhTU3BmNy8yamRZQjZnM0M3VVZpaktQeXhsTG02QlJUbStaa3pM?=
 =?utf-8?B?MktldndPOGFQZGlWQks0b1pYOGVTQXR0UTJpQmd0Vm9mRGJPZk05WW1UbGI1?=
 =?utf-8?B?QzRiMzdCV002Q2ZSaHNFOGxyU05NcjBSUUFmb0tyTkZPZDBIamxLNGorM0E5?=
 =?utf-8?B?TXNWS1dBc20yeFJ6NTk1Rit2OFdiZmlDamsxYkNQd2xMZmJmNkhSK2I0d2Va?=
 =?utf-8?B?KzNpOFAzTmxzcmNuSUV0Nkt0SG5Fa3l1N29BU3hqLzUvZTFKL2FzN3FDSDl1?=
 =?utf-8?B?WDFZMGtIME1kNVB5MGVBOVJoYmZCZi96d2tWK0NFaWdndGcwRkR5UGp4Wm9n?=
 =?utf-8?B?ajkwelN4UXQ4Q2RWaUJGZHNUMHF2TkEwdHFQYUdBMUtnRzZxQjdHbzAzeEVr?=
 =?utf-8?B?cDBhZGkzcEFza3QzUDl5bVBhTWsrRHB1VWZsWS9wYmNId0RPV2lUZ0NnaEly?=
 =?utf-8?B?NEl6bHpaa1hERjUxZFhTdlYzQlUwUG9QL2JTdHZmeEpUZHFHWkI3a2FrRnIv?=
 =?utf-8?B?WExZNEZOUVF5K0VRY1Q1WU1iTnllc1FTdCsxeFpYbHRBS2ZoMUkyQTJzT2s0?=
 =?utf-8?B?RFBjN3hwVTZRbUVDS2VML1VHM3oxYzRXeHg0UUNiOUlPZGR6dDQrQ1lndmRz?=
 =?utf-8?B?MGF5dVNGSGloMXRyeGQyU1AzcjhpZkd5WHVlRTkycEpudWN0SlphTTNNdHNF?=
 =?utf-8?B?MzN4TDdwR0JlM1hvWGhHbXE1Y3JIRWpITHJRUzMreE96T3E0ZUg2S295dEw5?=
 =?utf-8?B?cHAweFdCbU1TVWIyU2Y5WGM1QlpSZVIrSXNaQnJza2w1eENnb0RaNHJSMS9O?=
 =?utf-8?B?SWJ2YzVwNnNiREl4eTZ1TUQ2RCt4MjRUaGJ2Kzg1Z0JTRFBMdER2ODFWUjlm?=
 =?utf-8?B?ZzB2U0xhaUVlclhpajNjN01XNEs0UTNUUy84NDR4b1FDNkVNTnVEK1FRUTlk?=
 =?utf-8?B?RklZK240Wm9yMU1iUnYvVnVpQWFvV21OVi9HNUNieHlRdk40eWdXaHQycEJa?=
 =?utf-8?B?UDFVUnFqcFlWOFdTeGlwcFg2K1JOVzJhdllzOFYyZE8rcnAyUVFFN214bHZh?=
 =?utf-8?B?cXdNczZMa1pKVjZOcGp1Nnc4QjIyMXZUb2hSSDA5WFdYVktpZmlqelF0eS9D?=
 =?utf-8?B?VzNza0VHYWlzRlNJVldxWEV3a2tQc25adDRvbkNRclQxSkFWM3VsZ2UzK3I0?=
 =?utf-8?B?MjJyMEVMWk9oeWoxajhsRndYYXR3L3pTS2FXOXFzQXVrNHN0KzdjUnBUUHlG?=
 =?utf-8?B?Vm9kaUQ4ODRIKzhLVCtydGk5ZmVrdjMwV3Rab0wvRWFmTkVQbTZtNlpGeDUy?=
 =?utf-8?B?M2lEWXJITno0bUtBYkpCaEZhM0dOTkhaNE1BYWlUT09QZkZWR0tyc3VSeEhy?=
 =?utf-8?B?YUdPWm8vNnRQZTFPbXVOZUt5S1ZHNUM0WWpSaVREdHdaaWJpamtsaFlKaVBC?=
 =?utf-8?B?K1lnSXhpYjZqKytSNXZPcEJheW5TY21IdFVOYi9GUndCZC90SUROcmp3ZjRH?=
 =?utf-8?B?clVidGlsb0FNYVhhSmd5cERhenlyQnByYkl1Z0FNUEVRSWlub0tlQlJwVUJi?=
 =?utf-8?B?ak1zWkcyS1IvUWg2WDhSMlBGejkzc256Nm94bjdvMzcvU0VjbDRQVW1sZW5E?=
 =?utf-8?B?TVFuQ0ZjSGd3MHltcmEwT0syaGVla0xUQi9maEg3SlhrOEQrSFVwL3dYczd3?=
 =?utf-8?B?cllKL0QxalBiSzJDREJlWXg2empxMGhVUDNaYlg0K0dLaEo4NTRxNUNqTERC?=
 =?utf-8?B?WEljeG5NcFNPZnRQeGQ1TWJmbG1EaGNSUTFiSW5LQzMwUVExQlBMKzBVVHNk?=
 =?utf-8?B?dWxGK3E5bGtiMUtjaFEwdE85Und3M1pxNUYzZTlSVUNXTERlZnRmN0lFQWNo?=
 =?utf-8?B?ck5Dbzg4bTQ3Um5uZlFSckZHWFFER3NaTVRSTTNsUDFYUUs0ajNxbDBPWHMw?=
 =?utf-8?B?eDdaaG5FUFJRWmNUNGZtK25icjdsQUI0UVBaYy9WUThhbXk4TE1QKzdLajZ1?=
 =?utf-8?B?dXgxTVhBdnFqYkNRenBKNHVYakdLSW1zZjRyeWtzK0NLT3o0Ym02K2hSeFo4?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28A1839DB4F6D143B006D5520B3BB9CB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PhKFBlPEqydGqPV0Zv2wGhb5pm1+1kGDSszoUUY2oOu3NKO7cUpr/JN4eioX/p5oAEZf54w+cODydUiM6dxs5izo0gumkU2nwJI5wDOkeQidiVOd5JXiTnUqIw7M6GTHCRtEKqw+eWwMI0TsxZLXjYBUaWfrEaLMwz+3xl85rNXEI3on29gN9n3uW4Qeeap5GK775AUDUg8J86Af4SxGeRgfmWeVtdLgra0hBAS7TqMhJ4XIO907EJgnlDungv7bfg/fzi2YDzzYH0Smdntlk4GfZEYNWx2ux47c1BweoxmcrZ2qvBm/Cutl8dHDKtifBe+3e2pGVylHkMhhX3awLXXhzNKuGc6QVWTMaD+XZzQuabmxuPGqSfTVjaKczGqu14NC0oa5I+wNf8R3mhxmgJFUg8LNEjupTLmEkrziwsIbe+PLzBIGNZiCUqJNnW256C7aY+9GP5VKsO9EC3Vd5DVzZ3Jxe/taDW6CFUQfa72Pv/vkLZfVaKuKDd4d3rzplzkzkYkrouVa8AMUoTvawod1SI5bPhLitnP9jMZQO2t2fTJ1JiuRsoPhrHIpi3XdPkNDfEpC1E3INAoXEgGIVrAIVQcofBY1hhbWVlk+MkU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e93ee9d-ee3f-4401-e88f-08dca201456d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 23:29:12.3173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +11OPYT8Nir+vQmSmx0jxSbLWL91WPgJunjnxSZThCqoKw2kF6+ByIeAuNkco/b81wCNo2I3KZusUVtIXBOy0kh26h9L18opqA8UNEYjwrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7584
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_17,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110166
X-Proofpoint-GUID: xBKZWlnBD5dYhPFzmSjZWfCtO8UHJMfe
X-Proofpoint-ORIG-GUID: xBKZWlnBD5dYhPFzmSjZWfCtO8UHJMfe

DQoNCj4gT24gSnVsIDksIDIwMjQsIGF0IDE6MjfigK9QTSwgRGFycmljayBKLiBXb25nIDxkandv
bmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
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
b3IoZXJybm8pLCBlcnJubyk7DQo+IA0KPiBXaHkgaXMgaXQgd29ydGggcmVwb3J0aW5nIGlmIHJl
YWRhaGVhZCBmYWlscz8gIFdvbid0IHRoZSB1bnNoYXJlIGFsc28NCj4gZmFpbD8gIA0KDQpZZXMs
IGlmIHJlYWRhaGVhZCBmYWlsZWQsIGxhdGVyIHVuc2hhcmUgc2hvdWxkIGZhaWwgYXMgSSB0aGlu
ay4NCkkganVzdCB3YW50IHRvIGNhcHR1cmUgZXJyb3IgYXMgc29vbiBhcyBwb3NzaWJsZSB0aG91
Z2ggcmVhZGFoZWFkIGlzIG5vdCBjcml0aWNhbC4NCg0KPiBJJ20gYWxzbyB3b25kZXJpbmcgd2h5
IHdlIHdvdWxkbid0IHdhbnQgcmVhZGFoZWFkIGFsbCB0aGUgdGltZT8NCg0KQXMgcGVyIG91ciB0
ZXN0cywgcmVhZGFoZWFkIG9uIE5WTUUgZG9lc27igJl0IGhlaGF2ZWQgYmV0dGVyLg0KU28gSeKA
mWQgbWFrZSBpdCBhbiBvcHRpb24uDQoNClRoYW5rcywNCldlbmdhbmcNCg0KPiANCj4gLS1EDQo+
IA0KPj4gKyB9DQo+PiArfQ0KPj4gDQo+PiBzdGF0aWMgaW50DQo+PiBkZWZyYWdfZ2V0X2ZpcnN0
X3JlYWxfZXh0KGludCBmZCwgc3RydWN0IGdldGJtYXB4ICptYXB4KQ0KPj4gQEAgLTU3OCw2ICs1
OTAsOCBAQCBkZWZyYWdfeGZzX2RlZnJhZyhjaGFyICpmaWxlX3BhdGgpIHsNCj4+IA0KPj4gLyog
Y2hlY2tzIGZvciBFb0YgYW5kIGZpeCB1cCBjbG9uZSAqLw0KPj4gc3RvcCA9IGRlZnJhZ19jbG9u
ZV9lb2YoJmNsb25lKTsNCj4+ICsgZGVmcmFnX3JlYWRhaGVhZChkZWZyYWdfZmQsIHNlZ19vZmYs
IHNlZ19zaXplKTsNCj4+ICsNCj4+IGlmIChzbGVlcF90aW1lX3VzID4gMCkNCj4+IHVzbGVlcChz
bGVlcF90aW1lX3VzKTsNCj4+IA0KPj4gQEAgLTY5OCw2ICs3MTIsNyBAQCBzdGF0aWMgdm9pZCBk
ZWZyYWdfaGVscCh2b2lkKQ0KPj4gIiAtaSBpZGxlX3RpbWUgICAgICAgLS0gdGltZSBpbiBtcyB0
byBiZSBpZGxlIGJldHdlZW4gc2VnbWVudHMsIDI1MG1zIGJ5IGRlZmF1bHRcbiINCj4+ICIgLW4g
ICAgICAgICAgICAgICAgIC0tIGRpc2FibGUgdGhlIFwic2hhcmUgZmlyc3QgZXh0ZW50XCIgZmVh
dHVlLCBpdCdzXG4iDQo+PiAiICAgICAgICAgICAgICAgICAgICAgICBlbmFibGVkIGJ5IGRlZmF1
bHQgdG8gc3BlZWQgdXBcbiINCj4+ICsiIC1hICAgICAgICAgICAgICAgICAtLSBkbyByZWFkYWhl
YWQgdG8gc3BlZWQgdXAgZGVmcmFnLCBkaXNhYmxlZCBieSBkZWZhdWx0XG4iDQo+PiApKTsNCj4+
IH0NCj4+IA0KPj4gQEAgLTcwOSw3ICs3MjQsNyBAQCBkZWZyYWdfZihpbnQgYXJnYywgY2hhciAq
KmFyZ3YpDQo+PiBpbnQgaTsNCj4+IGludCBjOw0KPj4gDQo+PiAtIHdoaWxlICgoYyA9IGdldG9w
dChhcmdjLCBhcmd2LCAiczpmOm5pIikpICE9IEVPRikgew0KPj4gKyB3aGlsZSAoKGMgPSBnZXRv
cHQoYXJnYywgYXJndiwgInM6ZjpuaWEiKSkgIT0gRU9GKSB7DQo+PiBzd2l0Y2goYykgew0KPj4g
Y2FzZSAncyc6DQo+PiBnX3NlZ21lbnRfc2l6ZV9sbXQgPSBhdG9pKG9wdGFyZykgKiAxMDI0ICog
MTAyNCAvIDUxMjsNCj4+IEBAIC03MzEsNiArNzQ2LDEwIEBAIGRlZnJhZ19mKGludCBhcmdjLCBj
aGFyICoqYXJndikNCj4+IGdfaWRsZV90aW1lID0gYXRvaShvcHRhcmcpICogMTAwMDsNCj4+IGJy
ZWFrOw0KPj4gDQo+PiArIGNhc2UgJ2EnOg0KPj4gKyBnX3JlYWRhaGVhZCA9IHRydWU7DQo+PiAr
IGJyZWFrOw0KPj4gKw0KPj4gZGVmYXVsdDoNCj4+IGNvbW1hbmRfdXNhZ2UoJmRlZnJhZ19jbWQp
Ow0KPj4gcmV0dXJuIDE7DQo+PiAtLSANCj4+IDIuMzkuMyAoQXBwbGUgR2l0LTE0NikNCg0KDQo=
