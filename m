Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408FE7F6
	for <linux-xfs@vger.kernel.org>; Fri,  2 Aug 2024 18:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722623528; cv=fail; b=BQ58oitFhGY4DaMn2R0ttPTSTI+0ahTZqqu3yj8ovQqV2mk9HRS5giyGQvODVn8ksb9NdFUEHeBBdVquqJeIXRBYSEWp+CrIsl26OF0L1PcJeJhTM9B1pdf28l7Zj0xgX3630U0vMVknR9OeWV9LFX7KuJyGsz+PXUjRoRItPLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722623528; c=relaxed/simple;
	bh=lk7ssY9GUDr63nWj1l8A2LsYv8bo/0vAMf9Xj2IxG20=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TH+JN/K5j4/mP6wBzKfsnrFS6RhKZWTlZfNdS3tBgeLvUAEaoLLg635GrkSU5m25hqGBS0AOx/UqVjNy4WrPA838MAqWjnNIeMDAEPOl5p8gbPn/wyUtY0D/jj4LikzMfKn4OMQLWBxPwHapYyu0HLIrxbVWBO2bzYDdRZsKWiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z2JESeqy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Py5QD/8+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z2JESeqy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Py5QD/8+"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472GtVgi028595;
	Fri, 2 Aug 2024 18:32:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=lk7ssY9GUDr63nWj1l8A2LsYv8bo/0vAMf9Xj2IxG
	20=; b=Z2JESeqyJs2RoXp/UsvYL17Ghe1lZ1C9obWeypCzSR2OQynPSDYZ2qY/Q
	Wnox7ksYLJoOb4BegFFqFAzq6pYhEmgL/91dIGV0ksN1oUh51AmXfmWzpCmUveDQ
	FoPIN6d82xYtpgDe2nPSzHzP0NO1OPqNVLAq6Zn29DhqttlFYzKqRXQOXU1VYjWu
	DBL/uJqRriNMF2QIyhK+DZXB3Fds48rM5VIerK4Q3OFE2+fhTo6iIZ19qKmyJLP3
	MxG/bLUSb0Z0YXFg0g6Flbrs2N4vnxZnXJv+tRM7d+hPI4mEbHUmCXR70LF1nywl
	JM70PEtdMHC7+aVCpP8HGbP06J+7w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rje1hyxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Aug 2024 18:32:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 472H85d2001885;
	Fri, 2 Aug 2024 18:32:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40nvp208nc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Aug 2024 18:32:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpxrMjfLSNuGLcZgC0v16H4jrfy0MsCF0gfa24ctthBGfJyFut0Lgq0YVwcnnC3/y9BtWGb9TLgts8q0hPFazr5oCFQkHHYtWzvYBNFtULJgUuntNQokYkMrmB8vY5DyHq2I5IDbTsgomrowu5gKAK4+QHbGlVSVAWfR84DgxPCx4Qujiruhc5UKF4Iy5fnmtow3/lXSEF5Qp/F0ON+HyiarLN/xCMrudgBBfHjw3rar+jGuMFx3a8bKNck4kHCCxIzFaxnTIN89UFc3s4YVCM6sTTxZiPt263Weq5gdy0niM0wVbKNiAnZL0qTOOY0WoXm0LzYPBRxlQsJO8H6bxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lk7ssY9GUDr63nWj1l8A2LsYv8bo/0vAMf9Xj2IxG20=;
 b=fY6i5/eFRG8joKfBZsqAy1mImFandIgijsqm9bjuEX3cCUC1BBUy76Bjhp7FclZtBKRaSKRqv9Gekk+ygLoeTpJDOaSJJ/8gFoWOI0KkrsupGt1JOYgUpWZapE+tTxgno48onRcH6xQz5goXEPS7+G8mzwMRKpqmCcvCrKpOmn2WZq/WkFfI3NH3A1DHc9RhX2rFB1eazQUX4WcRWlRWmA8q710AqB45OvUTMyFPVbT0EpTco9DNTZ2ndPvd4emZjmgH46wdiBayrK6U9vbAyw7lWaokrByqlRtw2Zqslrszzsc2XcFjTp9LqlyYrfvGFf7R1zBu4kcg9Tvpot9rfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lk7ssY9GUDr63nWj1l8A2LsYv8bo/0vAMf9Xj2IxG20=;
 b=Py5QD/8+ctWpx7pmdGYiSzgGYViwoBkyPWazFA5k1Ub0um3NHYE6ljKjdPPUfVFPfHDMjCbnwDOACfxTqZ+7R6xvEXCHFNCRIkb2NbovTOG70IH9Tr+9UvTHtl8AyFmAEUj9JiuZZOSxLBp4jJpPwVALoK0xjSIDGVF5Dg2AvfI=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by PH8PR10MB6386.namprd10.prod.outlook.com (2603:10b6:510:1c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Fri, 2 Aug
 2024 18:31:58 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7828.016; Fri, 2 Aug 2024
 18:31:58 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 8/9] spaceman/defrag: readahead for better performance
Thread-Topic: [PATCH 8/9] spaceman/defrag: readahead for better performance
Thread-Index: AQHa0jOwoj1v9LT7c0+0oiUxs1Z13LH4kYOAgAROCYCAE2psgIAEJhgA
Date: Fri, 2 Aug 2024 18:31:58 +0000
Message-ID: <B7515453-D058-470D-B05B-9EDA8C326E0C@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-9-wen.gang.wang@oracle.com>
 <ZpXFLwHyJ4eYgQ0Z@dread.disaster.area>
 <71F0919A-6864-4D78-BED7-8822DF984B92@oracle.com>
 <ZqmrISscIWQ5Zbl8@dread.disaster.area>
In-Reply-To: <ZqmrISscIWQ5Zbl8@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|PH8PR10MB6386:EE_
x-ms-office365-filtering-correlation-id: 243978d3-6db5-40f6-95d0-08dcb32164e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?am1tcnFVeERLUE5MS0IzQ2RXWkhiZ1kybVJocXIxcmtvYTVRTFJBdDd2Szh6?=
 =?utf-8?B?SW5VWEhjMlEwTkl1a1hUN0xiTnA2U1FvTnMycWhoOFByRXQ5alJpOFc3Mm1J?=
 =?utf-8?B?bE9TYVdMMzVJdzk2MGd6ZTRNalFmeU4xOXhzaUoxT3EyN2wzOVNiTEFEY29i?=
 =?utf-8?B?Tmg2TUF0bDFYWCtjWFFXWGxCNjF6RnVEeC9JZU1SdkgwUVNUNmRvNFpDN1I3?=
 =?utf-8?B?QUJRemhtT1gySGl4Mkt1eHJ3djNQbURHKzVPakpEQitqbWh2ZXlLakJjdnlL?=
 =?utf-8?B?NTNzWUZLc2UzNVUwUFBSdm1HNDRLWUpYaitZZGJQYWpndlpDNWZnNWFlWk9Q?=
 =?utf-8?B?UUVodmhPRGFqTmtneXBNdjl0ZEg3dktsVFJDOHRDYnNXdXB0dmpSRi9FYklp?=
 =?utf-8?B?aHZpTFZ1WlFrTEprTVJ6L3VmUEFhSDFjVStSSDNsWnZJSmpsbFhlaHA0ZUR0?=
 =?utf-8?B?di93UmFEbWUrSndGQW5aanFUOFdicWl6dnNCSXMyMklYSHdObVh2WEdlWkZz?=
 =?utf-8?B?dXpwbUM3Vzk1bUNENFgwaGNEUm1mSkZVdWRZYXVhcVBnZ3pydkR2NEtaSS9W?=
 =?utf-8?B?YWhqcnNzZ2lLSGJuVzJBdFVJVWppNVl4eGUzeFc2dVk3OGQ4Tkw4L2UrWEMr?=
 =?utf-8?B?cmhrN3pUeDVwMS94MWdUR0ZrbVRTRTB6OGZTbTl3VmVRVDNzQWs5RW03Sm4y?=
 =?utf-8?B?NmRhYWNnTE9TckxzSGN6NXA2VnMwT1RWN1UwZkZQMjFhVW8rcXdaT2xweW1Q?=
 =?utf-8?B?TEcvRlBiT3k5ZkY2dFhKSjliQW4xaFpRK0xUMXpuK09UZ090Q1JRaUxva29X?=
 =?utf-8?B?Y0YwYXc0a2dlekEwelcrRTkxTnpsREcvUGxsMzFnanlQWnpOcXJ4aHhIWita?=
 =?utf-8?B?dXRrT3R5cWJ1NWlSbGRmUXMvVXJhT2hXY3QxNFhaVnE0R00vNG5IWHEzOXNU?=
 =?utf-8?B?bHRndmVHcnJJc2JzbmtjMVBCWXJtS1lBT3F6b1JPR2NhQXk2VnVuRFJuUEsx?=
 =?utf-8?B?WHdxNE56N0VjdnRqYXJSTHUwTHNGUm5LYkt3NHVjdlBMVGZkL281UHE4b3Vj?=
 =?utf-8?B?L0RTWHMrU01wSlRLL1dYOGFBdlJLWHBpWTFTdTRvWWJPb2tCa2IyV2JJbmpY?=
 =?utf-8?B?NGxnS3Jrekp5ZHRpWVo3VWJDVTJVNkE0bGJVT29hcGdYd2ZDOWZBTkR0MzJk?=
 =?utf-8?B?N1ZXT1N1aFlZekxJTFBJc3pOc1JDQnBybWUraVdvcXI2RHkrZ04yWWprRG56?=
 =?utf-8?B?elA0Nm9hMXZIdEdpOUFQZno3bDNuVzc2OWQySStaOHBaUjBUbXNJQ0hjNVRl?=
 =?utf-8?B?MXBBQUZnUXV4QVE3N0xQc2NWMkpqaHh6VmZvd0RudkJWK2pEaWxabFBGTDd0?=
 =?utf-8?B?c1lyQ2xPeGFoR3VJbk83THBDTStJd2VqRnZQSzd3SCtnbXpodHFpdU50aGp0?=
 =?utf-8?B?MlZwMENrbzl3L3dTOVJVeGpmRi82OVpIZlZJWHoxanplTjBSaEV6bFdncHkz?=
 =?utf-8?B?V0VvYkdsSS9qa1BkOEZHeTVRaGREV2h5Y2kwV0ptYmVYUjhRK3BBdFdzZWhz?=
 =?utf-8?B?dWZmc002Yko3QzN6VFl2Z1QrRE84UkY1Y2hSbFdtREpaRGdGWmNwdTBBNjFC?=
 =?utf-8?B?aEdoSno1K0RYd0hiclpVeUhDMDVBWG9RcTBGaCtVbHorSDBuL1RPTmtmZ2Jk?=
 =?utf-8?B?WlZ2aVVNQlgwRlNoRWgwN1hwSHJRdmNBVEMxSVF3Mnd2Yk4wU0J6Q3B4YmRP?=
 =?utf-8?B?c3JaVEpoRUZKcFpEZzVYcEhjdlJwcmFrSG5tUXpoUWYzcFNKQkt2TTdNOTRi?=
 =?utf-8?Q?emJI3sWIZJLcQfEhMwJTN/wVVImX6g9RUswAk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SFJFbjZ2bnhkZ0VDTlZRRTFKOEpveW0zaSt0Q1JNY2Vxb3IrbXpYNXpDVkp1?=
 =?utf-8?B?eVRXaWRNdXpNZk44UVV3K2ZaOHhvc2NEMWRnQkluV0w1UFIrSzdMK3pBS2tX?=
 =?utf-8?B?WDZQYWxLZm9HRXZxMEdjRmE2RDMvT1MwT0JXZk94czBCc0l2T0JjalpBWWVZ?=
 =?utf-8?B?Q0dPY05PdS9qdmQ2SUVlN21OcW5GVnpUS3ZNZElLZEJSNEt6cFRyZnM2a3VM?=
 =?utf-8?B?UDlFSHhDemE0ZUEwMUJZa2d5SVpCSTZRam9VcXpwV0VhNEhBUW1tZnpzaFow?=
 =?utf-8?B?bGNQd2tmM1pKTmNaanBpM1BZc3QyTTZVMzNseGxVRktkY29ZeWxONUZEZktr?=
 =?utf-8?B?VzBPRGRmcUlIUHY2Y2JlRndzbS9rcyt3YmY0WEZGbUgwUWZyU0lHbHRzZ3JH?=
 =?utf-8?B?Z1pHaEJGM2ZsbzF4dEk2RXFXUlozQ0NxeEpzMUQ0T0VIU3Bxa291VUV2R2d1?=
 =?utf-8?B?bkx6MnNvdTFqMXFiaFRGSm5wbnVKeGUvWHNXUVFnVTRMOEJITGVFNHo0aU5U?=
 =?utf-8?B?dGF4UVlwQ3laQlIzTWpGUUJLSGJDTGZWUmJ6NzI1aDY0aUc1R0Jvc1lwVkcz?=
 =?utf-8?B?MHFHVWNpL1V2a3gyY05mOTBKSFpTNzB5L3Y1YTQyc1V2VXM1ZElnbWF6WFRh?=
 =?utf-8?B?R0xwekRSd1pvaGE0R2pRZVRDWFdpMzBiVHJpbFRjZTMzUXZLQ2VCM0VlMk1C?=
 =?utf-8?B?aVRyd3BCRnI1OEVCRGh2RzIrcHlwRnA0MU5hL0RLanMzOFNiODBwWE1GVkNv?=
 =?utf-8?B?VVI5OVhIK3hORlRac3hYZ3h0MWpxNjhYR1ZGUStMNDJNUjNBNXVEeFFvM3Vs?=
 =?utf-8?B?SlJnWEpoWjFEai9DMHhhVWxoWmdRY1NjYnFOQlNPcTJkMzdDQ1oyakw2SHl6?=
 =?utf-8?B?TFZ4bWoxRGkyUlJzWUpqZjNoZE93eWZwL1NZZGEzOHkwMDh4OW9wVmIvYUIy?=
 =?utf-8?B?SEpkZmZXVTJSL3RvS1pFcml3ZkM2djRsaXZHcmFyb29KNHRsRnNUdy9GQ2xE?=
 =?utf-8?B?bXRuazl5SmF1amdYa05ka2JMRklRZ2tLWHRWRHVsbG9xM3pTV2ZSbFVvZHlO?=
 =?utf-8?B?RTh2SWdsTTB3b2xUK2FqZ2dTZ3ZCQncvNklnTFpYMmFnSGRkTTB5U015V3pY?=
 =?utf-8?B?WjBtbEZvb0tZWkhtY290clV1WXJNNFlkVEk2a3dqcmJ5Ym14ZUlHbWJvYUpp?=
 =?utf-8?B?SG9oT1ZYdVZyVkZmVmNONVJuakRxSW5oUkpNdmkyTFU5bUJIczBHTnJOY0Zi?=
 =?utf-8?B?SUZiRU16RWt0T1EyWHgxNGJIOEVLSE8yVmQ0d0p0WmRxcFE2aU1nNk9EU0Fi?=
 =?utf-8?B?Yks3SWhiL1RJUEtWY2twZ2txNnBQcGJDN3haRnlKdExrYlVRc3I2cVptelBj?=
 =?utf-8?B?dncwS3dWMW8xQ1pUWC9lT1I1d3ErS0g2dGZHNnZvV001a3FtQlJ2VUxSaS9N?=
 =?utf-8?B?OGNIUTBwWkg4Q1luL20xS3MwemI2aitha0pJVXdNdUt3SEFzbnJocmZZU2hn?=
 =?utf-8?B?Z1hxUHdNRXpHSC9WTjJYQ2xCZHoxVVJpOGVraG4zTlM3aWRkenJKSm11QXNi?=
 =?utf-8?B?NjdTNDFCcExrSng5KzlJNlBVMXkvYWNjMVgxWEV6VDhMS3BRTS9STTI5UENu?=
 =?utf-8?B?SXM0RWFwc2hPS2NVdkNnS1dmQ2JyT25GRG42QU84TUhSR245VDdBSldIc28v?=
 =?utf-8?B?VFp6NjZEc1d2NEZOTHRHWHJEVktnKzl5dzcxTjNnYzdhM2VDdEVsdUp0ZlM3?=
 =?utf-8?B?dmxacVppOUNVQTlBdHlTaTkreVFsK0NJWjNSYjBubDREMlo1bUk3emxid2tK?=
 =?utf-8?B?RW02RXBpRlRQbDNuTVV0THpxdUUrL09YSDVjOFRpZkcxS2FSOUF3MlE4MlV3?=
 =?utf-8?B?R1FHYUYydDl1aGJmK3JSdjF2MDJ2b0xlRGRadG84ekg3bzlMa3RlWEhjSVE5?=
 =?utf-8?B?NG1RdTJlaDFUT2FqMU5RVFVsazJ5QTcyY21UQ2VvRm5NbE5qaG5aRlBqU1dT?=
 =?utf-8?B?SWM5TCsrcWI3aDBrUEh2SkcrZjZ4dzdQUGhJUWxjODZNbk1oYmgzd21OTGJv?=
 =?utf-8?B?U3pJdGZqc2kyOXBKQWFMNjhPc1VJZ0NmOXQrWXk2Z1BrM005SlhmSHp0dGNE?=
 =?utf-8?B?ZmwyeEIwWDIwK3RrUG5oZ1ZpOWRTMHNZKzNPTzFTWEkvMkd3RFZEbzlHZjBF?=
 =?utf-8?B?KzZWekdKVDBMSy9qR3VKbHpsUzBYUlFBb3VvTG03QmFHTHlvSHVoL3gyRkNv?=
 =?utf-8?B?NDVveVNySEQyc1NHZFBhK29nQnpRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7835D1E0A4F77242A00859E2539CD415@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	moU/u+MHTCE8eJHL9lbDdS/axKAh9QxnS/mD+z71jM3u0bRMzT2A7Ma1BLNbWmb+06sz4b/uejFimI2vf48tOza0YqJxt9SvXU8nQytpoTmiCMsYrkc6tmfQpL5/CDVOvJvUcum1Kl0phhLkPNll5AtAdUZMMvm3OMRwf8rrF8y/QahuthhYmW1L26kicEjoZE1bPAoGqc5PO4+D6etSTMAevrQnczt2pPk5govgQZgLG9apCdd8tumDhGBg8XPW4JnCF1QZyWYtkFJ9D6VExFCulStVgT4HlZcHKW8yj1KbdC1qICZwSn4GFz1HjbQd6oByFLifhRFObsWPdZ4o+HEHWD99tG2JQRqjOfIuqsQamJooEZHwO69cdZvZ3i4xJMyeP17pxJ371OoMmsFKWdj9+WNaSM+Rcmb+t09AC1x56opQDbrIRkpwnrrW2BCzBh0aGfzSpbCeUmPDa/NAUnyLOWSaSyJuWbZqiIbjJuAJUMl1lzRltzkkFZu53C5TJleHezAq4TuK6GKMBfL4+FTfNUhawr6TEYewKt/Tq40IMTPdCbSpZhP/57yk1yAeLA/TkABD8mfyljI989Z3WGfoS0SR7p0ouiOVLDvr/Y4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 243978d3-6db5-40f6-95d0-08dcb32164e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2024 18:31:58.7510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OQR9L6WyuqLAOAWo3lxK3KIwBeLRNvBWw6SNYqgo6gryhFT/RjBVN5ZAL5ymKH+VQKFP4BW6eGFU+hrJsWBSpqyD+X6KppgiYg+8Y/eglY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_14,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408020128
X-Proofpoint-GUID: OlwO89S_Nvl7e97F5K9Qvw9P-QYQXeNQ
X-Proofpoint-ORIG-GUID: OlwO89S_Nvl7e97F5K9Qvw9P-QYQXeNQ

DQoNCj4gT24gSnVsIDMwLCAyMDI0LCBhdCA4OjEw4oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIEp1bCAxOCwgMjAyNCBhdCAwNjo0
MDo0NlBNICswMDAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiANCj4+IA0KPj4+IE9uIEp1bCAx
NSwgMjAyNCwgYXQgNTo1NuKAr1BNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+
IHdyb3RlOg0KPj4+IA0KPj4+IE9uIFR1ZSwgSnVsIDA5LCAyMDI0IGF0IDEyOjEwOjI3UE0gLTA3
MDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+Pj4gUmVhZGluZyBhaGVhZCB0YWtlIGxlc3MgbG9j
ayBvbiBmaWxlIGNvbXBhcmVkIHRvICJ1bnNoYXJlIiB0aGUgZmlsZSB2aWEgaW9jdGwuDQo+Pj4+
IERvIHJlYWRhaGVhZCB3aGVuIGRlZnJhZyBzbGVlcHMgZm9yIGJldHRlciBkZWZyYWcgcGVyZm9y
bWFjZSBhbmQgdGh1cyBtb3JlDQo+Pj4+IGZpbGUgSU8gdGltZS4NCj4+Pj4gDQo+Pj4+IFNpZ25l
ZC1vZmYtYnk6IFdlbmdhbmcgV2FuZyA8d2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tPg0KPj4+PiAt
LS0NCj4+Pj4gc3BhY2VtYW4vZGVmcmFnLmMgfCAyMSArKysrKysrKysrKysrKysrKysrKy0NCj4+
Pj4gMSBmaWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+Pj4g
DQo+Pj4+IGRpZmYgLS1naXQgYS9zcGFjZW1hbi9kZWZyYWcuYyBiL3NwYWNlbWFuL2RlZnJhZy5j
DQo+Pj4+IGluZGV4IDQxNWZlOWMyLi5hYjg1MDhiYiAxMDA2NDQNCj4+Pj4gLS0tIGEvc3BhY2Vt
YW4vZGVmcmFnLmMNCj4+Pj4gKysrIGIvc3BhY2VtYW4vZGVmcmFnLmMNCj4+Pj4gQEAgLTMzMSw2
ICszMzEsMTggQEAgZGVmcmFnX2ZzX2xpbWl0X2hpdChpbnQgZmQpDQo+Pj4+IH0NCj4+Pj4gDQo+
Pj4+IHN0YXRpYyBib29sIGdfZW5hYmxlX2ZpcnN0X2V4dF9zaGFyZSA9IHRydWU7DQo+Pj4+ICtz
dGF0aWMgYm9vbCBnX3JlYWRhaGVhZCA9IGZhbHNlOw0KPj4+PiArDQo+Pj4+ICtzdGF0aWMgdm9p
ZCBkZWZyYWdfcmVhZGFoZWFkKGludCBkZWZyYWdfZmQsIG9mZjY0X3Qgb2Zmc2V0LCBzaXplX3Qg
Y291bnQpDQo+Pj4+ICt7DQo+Pj4+ICsgaWYgKCFnX3JlYWRhaGVhZCB8fCBnX2lkbGVfdGltZSA8
PSAwKQ0KPj4+PiArIHJldHVybjsNCj4+Pj4gKw0KPj4+PiArIGlmIChyZWFkYWhlYWQoZGVmcmFn
X2ZkLCBvZmZzZXQsIGNvdW50KSA8IDApIHsNCj4+Pj4gKyBmcHJpbnRmKHN0ZGVyciwgInJlYWRh
aGVhZCBmYWlsZWQ6ICVzLCBlcnJubz0lZFxuIiwNCj4+Pj4gKyBzdHJlcnJvcihlcnJubyksIGVy
cm5vKTsNCj4+PiANCj4+PiBUaGlzIGRvZXNuJ3QgZG8gd2hhdCB5b3UgdGhpbmsgaXQgZG9lcy4g
cmVhZGFoZWFkKCkgb25seSBxdWV1ZXMgdGhlDQo+Pj4gZmlyc3QgcmVhZGFoZWFkIGNodW5rIG9m
IHRoZSByYW5nZSBnaXZlbiAoYSBmZXcgcGFnZXMgYXQgbW9zdCkuIEl0DQo+Pj4gZG9lcyBub3Qg
Y2F1c2UgcmVhZGFoZWFkIG9uIHRoZSBlbnRpcmUgcmFuZ2UsIHdhaXQgZm9yIHBhZ2UgY2FjaGUN
Cj4+PiBwb3B1bGF0aW9uLCBub3IgcmVwb3J0IElPIGVycm9ycyB0aGF0IG1pZ2h0IGhhdmUgb2Nj
dXJyZWQgZHVyaW5nDQo+Pj4gcmVhZGFoZWFkLg0KPj4gDQo+PiBJcyBpdCBhIGJ1Zz8NCj4gDQo+
IE5vLg0KPiANCj4+IEFzIHBlciB0aGUgbWFuIHBhZ2UgaXQgc2hvdWxkIHRyeSB0byByZWFkIF9j
b3VudF8gYnl0ZXM6DQo+IA0KPiBObyBpdCBkb2Vzbid0LiBJdCBzYXlzOg0KPiANCj4+IA0KPj4g
REVTQ1JJUFRJT04NCj4+ICAgICAgIHJlYWRhaGVhZCgpIGluaXRpYXRlcyByZWFkYWhlYWQgb24g
YSBmaWxlDQo+ICAgICAgICAgXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5e
Xl4NCj4gDQo+IEl0IHNheXMgaXQgLWluaXRpYXRlcy0gcmVhZGFoZWFkLiBJdCBkb2Vzbid0IG1l
YW4gaXQgd2FpdHMgZm9yDQo+IHJlYWRhaGVhZCB0byBjb21wbGV0ZSBvciB0aGF0IGl0IHdpbGwg
cmVhZGFoZWFkIHRoZSB3aG9sZSByYW5nZS4NCj4gSXQganVzdCBzdGFydHMgcmVhZGFoZWFkLg0K
PiANCg0KSSBrbm93IGl04oCZcyBhc3luY2hyb25vdXMgb3BlcmF0aW9uLiBCdXQgd2hlbiBnaXZl
biBlbm91Z2ggdGltZSwgaXQgc2hvdWxkIGNvbXBsZXRlLg0KDQojIHdpdGhvdXQgY29uc2lkZXJp
bmcgeW91ciBpZGVhIG9mIGNvbXBsZXRpbmcgdGhlIGRlZnJhZyBhcyBmYXN0IGFzIHBvc3NpYmxl
DQpBcyB3ZSB0ZXN0ZWQgd2l0aCAxNk1pQiBzZWdtZW50IHNpemUgbGltaXQsIHdlIHdlcmUgc2Vl
aW5nIHRoZSB1bnNoYXJlIHRha2VzIGFib3V0DQozNTAgbXMgaW5jbHVkaW5nIHRoZSBkaXNrIGRh
dGEgcmVhZGluZy4gQW5kIHdlIGFyZSB1c2luZyAyNTAgbXMgZGVmYXVsdCBzbGVlcC9pZGxlIHRp
bWUuDQpJbiBteSBpZGVhLCBkdXJpbmcgdGhlIDI1MCBtcyBzbGVlcCB0aW1lLCBhIGxvdCBvZiBi
bG9jayByZWFkcyBzaG91bGQgYmUgZG9uZS4NCg0KDQo+Pj4gVGhlcmUncyBhbG1vc3Qgbm8gdmFs
dWUgdG8gbWFraW5nIHRoaXMgc3lzY2FsbCwgZXNwZWNpYWxseSBpZiB0aGUNCj4+PiBhcHAgaXMg
YWJvdXQgdG8gdHJpZ2dlciBhIHNlcXVlbnRpYWwgcmVhZCBmb3IgdGhlIHdob2xlIHJhbmdlLg0K
Pj4+IFJlYWRhaGVhZCB3aWxsIG9jY3VyIG5hdHVyYWxseSBkdXJpbmcgdGhhdCByZWFkIG9wZXJh
dGlvbiAoaS5lLiB0aGUNCj4+PiBVTlNIQVJFIGNvcHkpLCBhbmQgdGhlIHJlYWQgd2lsbCByZXR1
cm4gSU8gZXJyb3JzIHVubGlrZQ0KPj4+IHJlYWRhaGVhZCgpLg0KPj4+IA0KPj4+IElmIHlvdSB3
YW50IHRoZSBwYWdlIGNhY2hlIHByZS1wb3B1bGF0ZWQgYmVmb3JlIHRoZSB1bnNoYXJlDQo+Pj4g
b3BlcmF0aW9uIGlzIGRvbmUsIHRoZW4geW91IG5lZWQgdG8gdXNlIG1tYXAoKSBhbmQNCj4+PiBt
YWR2aXNlKE1BRFZfUE9QVUxBVEVfUkVBRCkuIFRoaXMgd2lsbCByZWFkIHRoZSB3aG9sZSByZWdp
b24gaW50bw0KPj4+IHRoZSBwYWdlIGNhY2hlIGFzIGlmIGl0IHdhcyBhIHNlcXVlbnRpYWwgcmVh
ZCwgd2FpdCBmb3IgaXQgdG8NCj4+PiBjb21wbGV0ZSBhbmQgcmV0dXJuIGFueSBJTyBlcnJvcnMg
dGhhdCBtaWdodCBoYXZlIG9jY3VycmVkIGR1cmluZw0KPj4+IHRoZSByZWFkLg0KPj4gDQo+PiBB
cyB5b3Uga25vdyBpbiB0aGUgdW5zaGFyZSBwYXRoLCBmZXRjaGluZyBkYXRhIGZyb20gZGlzayBp
cyBkb25lIHdoZW4gSU8gaXMgbG9ja2VkLg0KPj4gKEkgYW0gd29uZGVyaW5nIGlmIHdlIGNhbiBp
bXByb3ZlIHRoYXQuKQ0KPiANCj4gQ2hyaXN0b3BoIHBvaW50ZWQgdGhhdCBvdXQgYW5kIHNvbWUg
cG90ZW50aWFsIGZpeGVzIGJhY2sgaW4gdGhlDQo+IG9yaWdpbmFsIGRpc2N1c3Npb246DQo+IA0K
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC14ZnMvWlh2UTBZRGZIQnV2TFhiWUBpbmZy
YWRlYWQub3JnLw0KDQpZZXMsIEkgcmVhZCB0aGF0LiBUaGFua3MgQ2hyaXN0b3BoIGZvciB0aGF0
Lg0KDQo+IA0KPj4gVGhlIG1haW4gcHVycG9zZSBvZiB1c2luZyByZWFkYWhlYWQgaXMgdGhhdCBJ
IHdhbnQgbGVzcyAoSU8pIGxvY2sgdGltZSB3aGVuIGZldGNoaW5nDQo+PiBkYXRhIGZyb20gZGlz
ay4gQ2FuIHdlIGFjaGlldmUgdGhhdCBieSB1c2luZyBtbWFwIGFuZCBtYWR2aXNlKCk/DQo+IA0K
PiBNYXliZSwgYnV0IHlvdSdyZSBzdGlsbCBhZGRpbmcgY29tcGxleGl0eSB0byB1c2Vyc3BhY2Ug
YXMgYSB3b3JrDQo+IGFyb3VuZCBmb3IgYSBrZXJuZWwgaXNzdWUgd2Ugc2hvdWxkIGJlIGZpeGlu
Zy4NCj4gDQoNClllcywgdHJ1ZS4gQnV0IGluIGNhc2Ugb2Yga2VybmVsIGhhcyBubyB0aGUgcmVs
YXRlZCBmaXhlcyBhbmQgd2UgaGF2ZSB0byB1c2UgdGhlIGRlZnJhZywgd29ya2luZw0KYXJvdW5k
IGlzIHRoZSB3YXkgZ28sIHJpZ2h0Lg0KDQpUaGFua3MsDQpXZW5nYW5nDQoNCg0K
