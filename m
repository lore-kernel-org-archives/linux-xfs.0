Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1803119FA86
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 22:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720738154; cv=fail; b=rI1rqUp3X04PMajdwfeVXI8aAHPKyHH9EwVrCjBhBdEQAKnpkfz4L9QH8AyLIuqGAg2EtnKhT76w+asV16HUAVhozMP78+Xw68buyEMW1/nRPQzSBmDnFadpyY4LWOQ3EnHTekzp3Irvw9esBqZIak0CgJkMm2pPTnbga3e9qY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720738154; c=relaxed/simple;
	bh=BlGM/l73U2WXa8aFLOGKR/ok3GcbaRjSDeW+h2/BafM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HbfT8j/9R+1t3xTxJbWyss8p01f4Q+hQUJ0pv/ywKOinFIITKfg/mLbM35yi6k0hMB33sh0vIvvq5zj/FFW7DE1rSZyY1lZBogs1ZWWjuUUGwd60JVYu1PsHObUz3krhkNdGGPRemtU2vj16sfbDr5UmtzI3oFjoz1ZT9qfIbR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jhrs4e78; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WY0+ppXg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jhrs4e78";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WY0+ppXg"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BKXU9p028232;
	Thu, 11 Jul 2024 22:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=BlGM/l73U2WXa8aFLOGKR/ok3GcbaRjSDeW+h2/Ba
	fM=; b=jhrs4e78OPYYbSwr58LmK+VUsWy9Ks9qKAEd9vFEwG/7fdgCYWISUp2IG
	aMtrcC1L2St0EBOubfUaYyT+MPs8K0SBQ4VpiNhkOpN94fGbsBNDMtEPQ0beSJIw
	wRnr0qyYTYYH2QreASfhfhV76UqRMwwn0eWV4gbIiFGeXncW56uyLSnsomKkrmip
	WuS2dlarubmmUx5pyjXDJdVmkKRZtcQn5org6fLdQ/7bGz/M2dL6fteu8DR4a653
	LKAkCapb5idI/31faF9gMlLMTjT3d24gVM7wrTopxCECtK031FAqHDC8Ln5Oy02S
	WcpD0J1WKAqRajdDfnKq2G6Nnym6g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wkntp11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 22:49:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46BMWdcF008741;
	Thu, 11 Jul 2024 22:49:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 409vv57a6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 22:49:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tAQNcWFsPkTrgeDyS2TXf5a0KrdoheL70YM6t3qmcarGkS72G56JDowGAQUajAG7Csvj1DkAbykabH4dUeGeBWs6clFMYCOER7WUjEmCI/7fkj9WjRuR+5QvfJ9qgz8NCKd2Rwz/ktwWPh++OPYCEVN53kA974GBgSXW+TQqwHbX1qAEWgNTCbP7yi55TAl2xQ1h0vD9NcUvZiQkpbLZl3LRmZ3MP8x3qea+GoqWpV88LZMwGNTKGyStCRVTn6LXdFOOAyERq74AIpwhx2RCOcq0KReG2iBOUjqZXTCDnKAVc1m6uXGQ1Ww50QIgeMxtLWwW9mqb4HcCJbUuSnFejw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BlGM/l73U2WXa8aFLOGKR/ok3GcbaRjSDeW+h2/BafM=;
 b=wwV8Y7S/Q9Q9Ge15Fd2sUZIrLf0IJuJA55myiDWj8z2H4BKxW50jCbMFbv8IXQHqSflXo1t/vGgwBb3nNJtznGaY9d54VhwvcMnvbu1iD/aykYXX1h87lr5D4Od4H0bA53TKPxb34cvvXui0dFhy7jOtFcN8TmNLLO88Uh1VsujozSJQRd2i01UCDPelvDJ9e/Q+JzqovyeztIoe8S1pb4J7U9f0N6c96gnJ9ia9vHnYXVMWNDuapaoV2XrurHUP+IPbbiHfd757YsUhVmzHnBwkrDs34fdKdIpbFwIYQGofPEbW1DNjndUE8Hpyb+RzCVjVYx6rmLZIrRSv7ZwQ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlGM/l73U2WXa8aFLOGKR/ok3GcbaRjSDeW+h2/BafM=;
 b=WY0+ppXgfEdrpd83ETX7/OUZELDmWFovUaDU07tCjZ3eobhGg7l93enN/Wt4x9qwj74zXdAwCyKzv5DyJdaBc3veyHDmE2HI7/Jc17OkKER2XdMSazsz2mC+TOyyM1WyjcQWpl17EOAK0ondVM6yGNKIJKlumdT8npg6Hdbyp98=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by DM6PR10MB4186.namprd10.prod.outlook.com (2603:10b6:5:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Thu, 11 Jul
 2024 22:49:02 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%6]) with mapi id 15.20.7762.016; Thu, 11 Jul 2024
 22:49:02 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/9] spaceman/defrag: defrag segments
Thread-Topic: [PATCH 3/9] spaceman/defrag: defrag segments
Thread-Index: AQHa0jOuXyFSvutJ4kmLNdUbwmDQsbHu8YqAgAMzDoA=
Date: Thu, 11 Jul 2024 22:49:02 +0000
Message-ID: <88831781-0D65-4966-8E95-F429178C9A79@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-4-wen.gang.wang@oracle.com>
 <20240709215721.GA612460@frogsfrogsfrogs>
In-Reply-To: <20240709215721.GA612460@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|DM6PR10MB4186:EE_
x-ms-office365-filtering-correlation-id: 90a354c0-57ed-4dcb-c02c-08dca1fba903
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?RjdvVzV2SGtwa0NINFhEd3ZqckZUT0M0em1UeENLYXlveDNjVzlja29ESTU2?=
 =?utf-8?B?S2plRXZQMlA0YUgvU29vWWFuSmZpV2d0WGl0S2p3TXRIdHdYSjlUVFVOTnRl?=
 =?utf-8?B?YjF1NEVOMnNjQmcwTDNyT1VLcDloSGI2R0I4R2dwNklhaWIyekJsQ2R2WVZ2?=
 =?utf-8?B?QkRieCtNeHNrTUhGeWpnOGo0ZEo0czYxcWRKS2VKOFNPOFZNZ1dscmNDTi9J?=
 =?utf-8?B?bmRtUm5PckwwcWY3NkhBMzhuNDBWUHdIZkZHNFBuYWptQnpQK1l6NC9yRWd6?=
 =?utf-8?B?ZzYwd2NoVHBEUjJhdUZSbWUza2RLTHlhcXI0MCtEM3M4TXVZYjJQNUhsMkI5?=
 =?utf-8?B?emt2bi8xQjBwVm1IdHExdk5uUVdLWlQ3VXhlU0RPYVJlRzJMYmhQZFp2TVJK?=
 =?utf-8?B?eXlBcGFtVlVQRmI4NU1xR2FaRmxlSng1L1pPdHdjdVRMcE5zbUpOVTA0TjV3?=
 =?utf-8?B?K3JEZkQvMm1BTzdWbk9aSEVSeWNJRjdkSVBtKzYydUpBZjNOSjZEdlA4a3VZ?=
 =?utf-8?B?TGY3WkpMTjA0RmlzZG5TdTE1S1FocW1Qc21kVkEvcFh4Yzdvay9YRTFqSjdH?=
 =?utf-8?B?QUx4Q25MeURtMnBLWU5jSmdCaFBOWWpZcSt6OVl1VkJ3TDUxNm41c2txZVB1?=
 =?utf-8?B?YlVqNHNPMkpxZk93YkR4dkFvNWMrTHpHOXphZ0ZqMEtQaUtyU2VaTytRQ0ZC?=
 =?utf-8?B?Y1ErQzFBci83TzU3OHdYTVE3aUl1TS9sVytoMXFwZW5YeFp2VElZV2pFNEJr?=
 =?utf-8?B?R1hKWUg2bmtYWHpxcTZrVnlhcG03c08wTGl0NnpHZFhsOEg5UXV4ZVpVZTRC?=
 =?utf-8?B?VDVRUXFBSVRYU0VKL2pCRTVGYkxOcW51ajlrRTZrUld2WThrY2JoRktTSndl?=
 =?utf-8?B?dFMyckxQS2dzZjhleDhwSFpTMXdQYTN5cG9MMzZhaDN4WGlib0FjY3QvTmJB?=
 =?utf-8?B?eXYybTFuOHBsY1R1ZE9sMUZ4bmRyNHVuRVdZZFpQN0FZbDVMRW1lbGZKeHRj?=
 =?utf-8?B?U2djam5TRWpGVzNzS1N2Nkpoam5GWFRyYWxOaGdKanU3ZmJEYm5Kdmk3NkJT?=
 =?utf-8?B?dnUybWRKQmZFWlQ3ekVLeURXU3dRUDdmZjdEOERWRjhlMkNkb0xIcEFFQ01s?=
 =?utf-8?B?V2FNRHljWUlzbGJKdnRqZ2ZVeEZzRk91a1EwTkxqK1B2SFM3SEhJWjlMWEl3?=
 =?utf-8?B?OUZPU0MreE45TjNRQVNSY3UyU1cxVks4N25EdHVQbUxvaWE0MzZwdFZSQmM0?=
 =?utf-8?B?di9MQytVZkppeDhLM0UrT3dDcHZKODZ3YUxRRGNTZ2IwYUdHZEpDd1pCTmJr?=
 =?utf-8?B?aHNuSGpLY1ZKNFg1R3IwbWgrM1JhdnQ5Slk5enZjMEV0NkR5Nmhhb0w0ME9k?=
 =?utf-8?B?UCtERDREbnc4Mm15ZjZudjNoRXczWmNPTEFLWTExdnFDdTNmYy94aUNCMFp6?=
 =?utf-8?B?RFBjMy84U1RYR3E2TGFweUhjMy82bjZ0eTZUSUZjREk0bC9MNXczT3NpUzRJ?=
 =?utf-8?B?T2kxeE9iYitQRC80YzJ6UlZjUkc1c242THlqckQraFRweDh4c1JZSFppWDNk?=
 =?utf-8?B?VjNOd3VrbVVZSkVMaWp3M3Z2L0h1OHdEdXVUV3RIRWFVL0FaZDQ2Q2o5QW1V?=
 =?utf-8?B?Z3hBWDRmNUJKU0dsQmNzcW9JcVNhSk5WL2VJMGc5N1c1MSt0SVlnUEJGaGVN?=
 =?utf-8?B?ZUNkSXp6ZXpETUxseEY4OXNvODZhOHBsVThBQitOSlY4dEZYbHRrMkdHSmtK?=
 =?utf-8?B?bXhhSHZlUjlXMlVpRDZpMXp6RmNTSmtJTGNHM0kvNDRESVVJOWRTeG9vZlcr?=
 =?utf-8?B?bWZXcm5TUjltcHpsQmlRYmM1N0V6OVF1bDJVODJJMDlyQnhTT0dqMnlsS3RX?=
 =?utf-8?B?Qk4rblVLL25vcERmTmplaUJpQ2dpY0Zhck84YkIrUlJrWlE9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?NkhPRU9OMlRlWVA1NFZ3ZzhoOVI0ckszUTQ3S0JycGVHY3o5TmIxWXliTTlF?=
 =?utf-8?B?bnZzTjdPQ090dGJLZy8zVnVJU3V2a2pYVzVjM05mNHNiT0tJcmpib0gwc0tW?=
 =?utf-8?B?SWU5cnRQTzFzUXZuOVZzMFhlVHhyV0ZBMzluVXVSVUpTbmtPYUlmalZSb1ha?=
 =?utf-8?B?MkVqMExMVzVzQVNLYnh3NXhNeEx2YzJKeGc2cEY2a04yWHJuZnVMWjRMSEk2?=
 =?utf-8?B?d1ZoTXhldjJlL0VVTmRXOUg1a2FGV09YZDdyVEtFUmVrb0QyRDJ6a1ZGRnVq?=
 =?utf-8?B?UHN6V1hSRzhUK2YxTjRnSEhxeVBvSEVSZUZxRzh2NFNGdm5GYTQ4YWRDZkVw?=
 =?utf-8?B?R1psYWlWcmZ5cGd5TUZmbGt0b0YvemJMQkNnZ1M4NzZxclhVNVQySldOV2s5?=
 =?utf-8?B?ODc3d1U2RU5mOFA5OUFoaE03SFZ1aThHc2g0YnNzV05XYWYyZGJteE9LTzBS?=
 =?utf-8?B?NUdnUGRtRWdDeS9mK1hFUmpJQWN3Y2dKTmorZXVZYktheFF5YnVLSjlmRGZO?=
 =?utf-8?B?V214NlU1Ym9nYW01MCs5ZjFTcnR6OE9oMXI1VWZxM0ZvWWV1VnRXLysybkpv?=
 =?utf-8?B?dTk5L2lveEFPSHdoVW9tTWw2QmEvUFhFN0VSa1RVWjQ4ck4vYTNNUkY3SS9U?=
 =?utf-8?B?eTJNSXE4Rnhzd0V1dTlYaHFhYUZObE9GUjZWQ3ZIdmc1cnNoMVVrM1RTMi9u?=
 =?utf-8?B?K3NqL2M0emVhYmxzanRocHpsSWNiQTMwa205MUtZTytYU2UwTVg5K3F2aUtK?=
 =?utf-8?B?OUFFaVpnSkxibnRnNjR6Qm8vVWVrckJlWWcxMUh4Y1NFL2MyK1h5SlpFcFRT?=
 =?utf-8?B?SVI4UzRWcXFjdmtBY0l5VEQrV3JlTnpOQ1paMEN6NThVM2EzNCtaRE0yYXBF?=
 =?utf-8?B?eTREVDJqSjNuNG1DUW5BaWVNcHpCditLV3pXL25GUXI1UHgvSG9nVUlOTGJ1?=
 =?utf-8?B?VlJWbmpUZGI1MWRqRGtmMVh5blFlMGoxZUhWWnByb0wwNFQ3MjdrbjFhWEpz?=
 =?utf-8?B?L203VnpRYnc4aDYzSFFuS2RSWGkwM1k3dmlPcm5xOCs5eElsd3dZUk5mVkJ1?=
 =?utf-8?B?TmxjbHZlREQxQm1sM2lQQzlEWkxycGYwUFRNMm95eFhOUlA5dXZneUt4a1F2?=
 =?utf-8?B?QVdhMUJWNmxETGlQYTNKem1UcnJQL2hHV2J0SE1TSXJ6WTJxSCtvYkFZUC9k?=
 =?utf-8?B?bEtXTFNZRkFNWHdXSTA1bmcwdmVoVDdieVN3ZWtkRWpYZm1yZFZUOVhmQ3c5?=
 =?utf-8?B?bVRlaktyUEJYVW8xSUszNVhKVll4YkFaYk1iV3NOUWFFVk4zK1pMMlFmUUxT?=
 =?utf-8?B?YWM1ZXJHVHZIZ1RnODZiVXc0bjZQV0x1VitLa09LMnREUUltWFgwRUt6cm5H?=
 =?utf-8?B?aS9DVUpEa3Qzay91Q1lCbVZVZ2EvVGRDVysxbUxzTCtzQkQzWEIvRG1CQUlK?=
 =?utf-8?B?TlVLQlJhSEpaUlpOQVFSTmIva1RWUDltTFpGV1diSkJqVGlFczJvUXlvVXVl?=
 =?utf-8?B?R2pnN1MxQm55b29Fek1SSk1RUmFKRmNIMk10bi95dDgwNWh4MjViN211aVN3?=
 =?utf-8?B?bVFQNWtiTFp6eGFtNUFjZ0VVSjJZaHg4TXNNSk94Nm5KMUJCbEZHRjY1MlJK?=
 =?utf-8?B?TEtBRzR5c2lwZFNQd1NKazdFU0J1T0QzcXFOS2xTSGttcmF0Yzk4WktQeEhm?=
 =?utf-8?B?ZXY2KzZ1YnNUd1RacjBRbXRLM29KcmhOWFVhYmJQSURXNTVRN09RR04vUUtY?=
 =?utf-8?B?QzN2QlZyZjZOTGhGLzNzaFZEY0NRSTluQ1dFbjBNTjRqdFB2NzBGTVhNdFlT?=
 =?utf-8?B?TGtaTVhRck9oS2FGUzhEU3NGR0JpdUZBdnEzcWdjNE9BeGRiSkd3QTRsMXpz?=
 =?utf-8?B?ZzFGOEg3WndZcTVvRUZKbHczOUd4SWhqdXhETUxpNFdoa214c3F4aEF1R2tm?=
 =?utf-8?B?MXVabDYweStWcXp0Mi9FV05LZUl6bGtablU2bENxZ1RkamYrL0NkREUrU0V1?=
 =?utf-8?B?b0hDVXRvTEhhZjBHODgxWUxLc0tJbWN2UzRDWkJmTDF1WFZvZGtpLzh2VkU4?=
 =?utf-8?B?Mm1jeW9YcTR0Q01QMmtHbGt1d3d3TkdrV0UwZlVIa2FKUThHd2VUQzRwcnFy?=
 =?utf-8?B?QjQvT0VveDdReHdYRzZpV2p6cG4vYkdJMVdUYjVTcHJoTHg2ZTBtbEk5WE1P?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25F959C5E8DDC24A92ECC0A29490612D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Opm+vnwVuOqsv+uBFLv7tvdAcCMivABvxE+gH9bHeg0fgqaJv50uFgxzGa7eJya42OkazVha10mKCK65DODQ7XBDenmGpM815JXEq6Ipjtu+G8BkzwisQZ+AQJ+1HAv68YX9nJpSkXUFnJKmWyIEsq44x2dg/VAsImvTExLi/D7jpc0/nzbYDZFkgLo0pTvmBbIRZm07ztf2Fxi0Gmu21tHtkJoLbOrRbwVn2elc2q7rewbCU3odXVpShKhaFziGOr/cASAaIrjhYdSl53j8VxQMdcdYFTWXh0CRKluEcdYSI9zUQAHTl9SKmsyK5lp+gJnawWS3pvuya9YOh8gPYa6V34F+TQPQG04DAg6vjfQn+zU6F5rQdzIc2wTqwejHvb9JErroBSa2CVhyyPPdV4mpz5jtvoYBLd5axJRo2os2EfvLsVHemcsgDO47lIfseNnhZCs7Yj3kay9hj0iiSWF9DMip7QT1XKoFBFgHAvGOzaf4i9Xz7vkVZ3w/ub6BveshKzCTsXK7dXh4GVDTl6uDMv5cXKcRQL6oOGYQ7apOMQaR0M8L4A90xpTeThs9zN+8ZbBdlZqWN6HRRvcqaTP9tEBbNpRxhQiMCFmJYIk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a354c0-57ed-4dcb-c02c-08dca1fba903
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 22:49:02.4089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9YGUDcWZhg85cn66w3yg43mmI+RmMOfmSXvruQ3Dos9H2kbkJC4n7XeqwsV4Ew9VzfMIDrRZpSgtMA7Kr7+vM7Rdpv2RcBF0C44mlQzCN0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_17,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110161
X-Proofpoint-GUID: 8OdZ2Q_JX6ttLZThc2D8N1Ya5Yj2fmo1
X-Proofpoint-ORIG-GUID: 8OdZ2Q_JX6ttLZThc2D8N1Ya5Yj2fmo1

DQoNCj4gT24gSnVsIDksIDIwMjQsIGF0IDI6NTfigK9QTSwgRGFycmljayBKLiBXb25nIDxkandv
bmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyMlBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBGb3IgZWFjaCBzZWdtZW50LCB0
aGUgZm9sbG93aW5nIHN0ZXBzIGFyZSBkb25lIHRyeWluZyB0byBkZWZyYWcgaXQ6DQo+PiANCj4+
IDEuIHNoYXJlIHRoZSBzZWdtZW50IHdpdGggYSB0ZW1wb3JhcnkgZmlsZQ0KPj4gMi4gdW5zaGFy
ZSB0aGUgc2VnbWVudCBpbiB0aGUgdGFyZ2V0IGZpbGUuIGtlcm5lbCBzaW11bGF0ZXMgQ293IG9u
IHRoZSB3aG9sZQ0KPj4gICBzZWdtZW50IGNvbXBsZXRlIHRoZSB1bnNoYXJlIChkZWZyYWcpLg0K
Pj4gMy4gcmVsZWFzZSBibG9ja3MgZnJvbSB0aGUgdGVtcG9hcnkgZmlsZS4NCj4+IA0KPj4gU2ln
bmVkLW9mZi1ieTogV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5nQG9yYWNsZS5jb20+DQo+PiAt
LS0NCj4+IHNwYWNlbWFuL2RlZnJhZy5jIHwgMTE0ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4+IDEgZmlsZSBjaGFuZ2VkLCAxMTQgaW5zZXJ0aW9ucygr
KQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvc3BhY2VtYW4vZGVmcmFnLmMgYi9zcGFjZW1hbi9kZWZy
YWcuYw0KPj4gaW5kZXggMTc1Y2Y0NjEuLjlmMTFlMzZiIDEwMDY0NA0KPj4gLS0tIGEvc3BhY2Vt
YW4vZGVmcmFnLmMNCj4+ICsrKyBiL3NwYWNlbWFuL2RlZnJhZy5jDQo+PiBAQCAtMjYzLDYgKzI2
Myw0MCBAQCBhZGRfZXh0Og0KPj4gcmV0dXJuIHJldDsNCj4+IH0NCj4+IA0KPj4gKy8qDQo+PiAr
ICogY2hlY2sgaWYgdGhlIHNlZ21lbnQgZXhjZWVkcyBFb0YuDQo+PiArICogZml4IHVwIHRoZSBj
bG9uZSByYW5nZSBhbmQgcmV0dXJuIHRydWUgaWYgRW9GIGhhcHBlbnMsDQo+PiArICogcmV0dXJu
IGZhbHNlIG90aGVyd2lzZS4NCj4+ICsgKi8NCj4+ICtzdGF0aWMgYm9vbA0KPj4gK2RlZnJhZ19j
bG9uZV9lb2Yoc3RydWN0IGZpbGVfY2xvbmVfcmFuZ2UgKmNsb25lKQ0KPj4gK3sNCj4+ICsgb2Zm
X3QgZGVsdGE7DQo+PiArDQo+PiArIGRlbHRhID0gY2xvbmUtPnNyY19vZmZzZXQgKyBjbG9uZS0+
c3JjX2xlbmd0aCAtIGdfZGVmcmFnX2ZpbGVfc2l6ZTsNCj4+ICsgaWYgKGRlbHRhID4gMCkgew0K
Pj4gKyBjbG9uZS0+c3JjX2xlbmd0aCA9IDA7IC8vIHRvIHRoZSBlbmQNCj4+ICsgcmV0dXJuIHRy
dWU7DQo+PiArIH0NCj4+ICsgcmV0dXJuIGZhbHNlOw0KPj4gK30NCj4+ICsNCj4+ICsvKg0KPj4g
KyAqIGdldCB0aGUgdGltZSBkZWx0YSBzaW5jZSBwcmVfdGltZSBpbiBtcy4NCj4+ICsgKiBwcmVf
dGltZSBzaG91bGQgY29udGFpbnMgdmFsdWVzIGZldGNoZWQgYnkgZ2V0dGltZW9mZGF5KCkNCj4+
ICsgKiBjdXJfdGltZSBpcyB1c2VkIHRvIHN0b3JlIGN1cnJlbnQgdGltZSBieSBnZXR0aW1lb2Zk
YXkoKQ0KPj4gKyAqLw0KPj4gK3N0YXRpYyBsb25nIGxvbmcNCj4+ICtnZXRfdGltZV9kZWx0YV91
cyhzdHJ1Y3QgdGltZXZhbCAqcHJlX3RpbWUsIHN0cnVjdCB0aW1ldmFsICpjdXJfdGltZSkNCj4+
ICt7DQo+PiArIGxvbmcgbG9uZyB1czsNCj4+ICsNCj4+ICsgZ2V0dGltZW9mZGF5KGN1cl90aW1l
LCBOVUxMKTsNCj4+ICsgdXMgPSAoY3VyX3RpbWUtPnR2X3NlYyAtIHByZV90aW1lLT50dl9zZWMp
ICogMTAwMDAwMDsNCj4+ICsgdXMgKz0gKGN1cl90aW1lLT50dl91c2VjIC0gcHJlX3RpbWUtPnR2
X3VzZWMpOw0KPj4gKyByZXR1cm4gdXM7DQo+PiArfQ0KPj4gKw0KPj4gLyoNCj4+ICAqIGRlZnJh
Z21lbnQgYSBmaWxlDQo+PiAgKiByZXR1cm4gMCBpZiBzdWNjZXNzZnVsbHkgZG9uZSwgMSBvdGhl
cndpc2UNCj4+IEBAIC0yNzMsNiArMzA3LDcgQEAgZGVmcmFnX3hmc19kZWZyYWcoY2hhciAqZmls
ZV9wYXRoKSB7DQo+PiBsb25nIG5yX3NlZ19kZWZyYWcgPSAwLCBucl9leHRfZGVmcmFnID0gMDsN
Cj4+IGludCBzY3JhdGNoX2ZkID0gLTEsIGRlZnJhZ19mZCA9IC0xOw0KPj4gY2hhciB0bXBfZmls
ZV9wYXRoW1BBVEhfTUFYKzFdOw0KPj4gKyBzdHJ1Y3QgZmlsZV9jbG9uZV9yYW5nZSBjbG9uZTsN
Cj4+IGNoYXIgKmRlZnJhZ19kaXI7DQo+PiBzdHJ1Y3QgZnN4YXR0ciBmc3g7DQo+PiBpbnQgcmV0
ID0gMDsNCj4gDQo+IE5vdyB0aGF0IEkgc2VlIHRoaXMsIHlvdSBtaWdodCB3YW50IHRvIHN0cmFp
Z2h0ZW4gdXAgdGhlIGxpbmVzOg0KPiANCj4gc3RydWN0IGZzeGF0dHIgZnN4ID0geyB9Ow0KPiBs
b25nIG5yX3NlZ19kZWZyYWcgPSAwLCBucl9leHRfZGVmcmFnID0gMDsNCj4gDQo+IGV0Yy4gIE5v
dGUgdGhlICI9IHsgfSIgYml0IHRoYXQgbWVhbnMgeW91IGRvbid0IGhhdmUgdG8gbWVtc2V0IHRo
ZW0gdG8NCj4gemVybyBleHBsaWNpdGx5Lg0KDQpOaWNlIQ0KDQo+IA0KPj4gQEAgLTI5Niw2ICsz
MzEsOCBAQCBkZWZyYWdfeGZzX2RlZnJhZyhjaGFyICpmaWxlX3BhdGgpIHsNCj4+IGdvdG8gb3V0
Ow0KPj4gfQ0KPj4gDQo+PiArIGNsb25lLnNyY19mZCA9IGRlZnJhZ19mZDsNCj4+ICsNCj4+IGRl
ZnJhZ19kaXIgPSBkaXJuYW1lKGZpbGVfcGF0aCk7DQo+PiBzbnByaW50Zih0bXBfZmlsZV9wYXRo
LCBQQVRIX01BWCwgIiVzLy54ZnNkZWZyYWdfJWQiLCBkZWZyYWdfZGlyLA0KPj4gZ2V0cGlkKCkp
Ow0KPj4gQEAgLTMwOSw3ICszNDYsMTEgQEAgZGVmcmFnX3hmc19kZWZyYWcoY2hhciAqZmlsZV9w
YXRoKSB7DQo+PiB9DQo+PiANCj4+IGRvIHsNCj4+ICsgc3RydWN0IHRpbWV2YWwgdF9jbG9uZSwg
dF91bnNoYXJlLCB0X3B1bmNoX2hvbGU7DQo+PiBzdHJ1Y3QgZGVmcmFnX3NlZ21lbnQgc2VnbWVu
dDsNCj4+ICsgbG9uZyBsb25nIHNlZ19zaXplLCBzZWdfb2ZmOw0KPj4gKyBpbnQgdGltZV9kZWx0
YTsNCj4+ICsgYm9vbCBzdG9wOw0KPj4gDQo+PiByZXQgPSBkZWZyYWdfZ2V0X25leHRfc2VnbWVu
dChkZWZyYWdfZmQsICZzZWdtZW50KTsNCj4+IC8qIG5vIG1vcmUgc2VnbWVudHMsIHdlIGFyZSBk
b25lICovDQo+PiBAQCAtMzIyLDYgKzM2Myw3OSBAQCBkZWZyYWdfeGZzX2RlZnJhZyhjaGFyICpm
aWxlX3BhdGgpIHsNCj4+IHJldCA9IDE7DQo+PiBicmVhazsNCj4+IH0NCj4+ICsNCj4+ICsgLyog
d2UgYXJlIGRvbmUgaWYgdGhlIHNlZ21lbnQgY29udGFpbnMgb25seSAxIGV4dGVudCAqLw0KPj4g
KyBpZiAoc2VnbWVudC5kc19uciA8IDIpDQo+PiArIGNvbnRpbnVlOw0KPj4gKw0KPj4gKyAvKiB0
byBieXRlcyAqLw0KPj4gKyBzZWdfb2ZmID0gc2VnbWVudC5kc19vZmZzZXQgKiA1MTI7DQo+PiAr
IHNlZ19zaXplID0gc2VnbWVudC5kc19sZW5ndGggKiA1MTI7DQo+PiArDQo+PiArIGNsb25lLnNy
Y19vZmZzZXQgPSBzZWdfb2ZmOw0KPj4gKyBjbG9uZS5zcmNfbGVuZ3RoID0gc2VnX3NpemU7DQo+
PiArIGNsb25lLmRlc3Rfb2Zmc2V0ID0gc2VnX29mZjsNCj4+ICsNCj4+ICsgLyogY2hlY2tzIGZv
ciBFb0YgYW5kIGZpeCB1cCBjbG9uZSAqLw0KPj4gKyBzdG9wID0gZGVmcmFnX2Nsb25lX2VvZigm
Y2xvbmUpOw0KPj4gKyBnZXR0aW1lb2ZkYXkoJnRfY2xvbmUsIE5VTEwpOw0KPj4gKyByZXQgPSBp
b2N0bChzY3JhdGNoX2ZkLCBGSUNMT05FUkFOR0UsICZjbG9uZSk7DQo+IA0KPiBIbSwgc2hvdWxk
IHRoZSB0b3AtbGV2ZWwgZGVmcmFnX2YgZnVuY3Rpb24gY2hlY2sgaW4gdGhlDQo+IGZpbGV0YWJs
ZVtpXS5mc2dlb20gc3RydWN0dXJlIHRoYXQgdGhlIGZzIHN1cHBvcnRzIHJlZmxpbms/DQoNClll
cywgZ29vZCB0byBrbm93Lg0KDQo+IA0KPj4gKyBpZiAocmV0ICE9IDApIHsNCj4+ICsgZnByaW50
ZihzdGRlcnIsICJGSUNMT05FUkFOR0UgZmFpbGVkICVzXG4iLA0KPj4gKyBzdHJlcnJvcihlcnJu
bykpOw0KPiANCj4gTWlnaHQgYmUgdXNlZnVsIHRvIGluY2x1ZGUgdGhlIGZpbGVfcGF0aCBpbiB0
aGUgZXJyb3IgbWVzc2FnZToNCj4gDQo+IC9vcHQvYTogRklDTE9ORVJBTkdFIGZhaWxlZCBTb2Z0
d2FyZSBjYXVzZWQgY29ubmVjdGlvbiBhYm9ydA0KPiANCj4gKG1heWJlIGFsc28gcHV0IGEgc2Vt
aWNvbG9uIGJlZm9yZSB0aGUgc3RyZXJyb3IgbWVzc2FnZT8pDQoNCk9LLg0KDQo+IA0KPj4gKyBi
cmVhazsNCj4+ICsgfQ0KPj4gKw0KPj4gKyAvKiBmb3IgdGltZSBzdGF0cyAqLw0KPj4gKyB0aW1l
X2RlbHRhID0gZ2V0X3RpbWVfZGVsdGFfdXMoJnRfY2xvbmUsICZ0X3Vuc2hhcmUpOw0KPj4gKyBp
ZiAodGltZV9kZWx0YSA+IG1heF9jbG9uZV91cykNCj4+ICsgbWF4X2Nsb25lX3VzID0gdGltZV9k
ZWx0YTsNCj4+ICsNCj4+ICsgLyogZm9yIGRlZnJhZyBzdGF0cyAqLw0KPj4gKyBucl9leHRfZGVm
cmFnICs9IHNlZ21lbnQuZHNfbnI7DQo+PiArDQo+PiArIC8qDQo+PiArICAqIEZvciB0aGUgc2hh
cmVkIHJhbmdlIHRvIGJlIHVuc2hhcmVkIHZpYSBhIGNvcHktb24td3JpdGUNCj4+ICsgICogb3Bl
cmF0aW9uIGluIHRoZSBmaWxlIHRvIGJlIGRlZnJhZ2dlZC4gVGhpcyBjYXVzZXMgdGhlDQo+PiAr
ICAqIGZpbGUgbmVlZGluZyB0byBiZSBkZWZyYWdnZWQgdG8gaGF2ZSBuZXcgZXh0ZW50cyBhbGxv
Y2F0ZWQNCj4+ICsgICogYW5kIHRoZSBkYXRhIHRvIGJlIGNvcGllZCBvdmVyIGFuZCB3cml0dGVu
IG91dC4NCj4+ICsgICovDQo+PiArIHJldCA9IGZhbGxvY2F0ZShkZWZyYWdfZmQsIEZBTExPQ19G
TF9VTlNIQVJFX1JBTkdFLCBzZWdfb2ZmLA0KPj4gKyBzZWdfc2l6ZSk7DQo+PiArIGlmIChyZXQg
IT0gMCkgew0KPj4gKyBmcHJpbnRmKHN0ZGVyciwgIlVOU0hBUkVfUkFOR0UgZmFpbGVkICVzXG4i
LA0KPj4gKyBzdHJlcnJvcihlcnJubykpOw0KPj4gKyBicmVhazsNCj4+ICsgfQ0KPj4gKw0KPj4g
KyAvKiBmb3IgdGltZSBzdGF0cyAqLw0KPj4gKyB0aW1lX2RlbHRhID0gZ2V0X3RpbWVfZGVsdGFf
dXMoJnRfdW5zaGFyZSwgJnRfcHVuY2hfaG9sZSk7DQo+PiArIGlmICh0aW1lX2RlbHRhID4gbWF4
X3Vuc2hhcmVfdXMpDQo+PiArIG1heF91bnNoYXJlX3VzID0gdGltZV9kZWx0YTsNCj4+ICsNCj4+
ICsgLyoNCj4+ICsgICogUHVuY2ggb3V0IHRoZSBvcmlnaW5hbCBleHRlbnRzIHdlIHNoYXJlZCB0
byB0aGUNCj4+ICsgICogc2NyYXRjaCBmaWxlIHNvIHRoZXkgYXJlIHJldHVybmVkIHRvIGZyZWUg
c3BhY2UuDQo+PiArICAqLw0KPj4gKyByZXQgPSBmYWxsb2NhdGUoc2NyYXRjaF9mZCwNCj4+ICsg
RkFMTE9DX0ZMX1BVTkNIX0hPTEV8RkFMTE9DX0ZMX0tFRVBfU0laRSwgc2VnX29mZiwNCj4+ICsg
c2VnX3NpemUpOw0KPiANCj4gSW5kZW50YXRpb24gaGVyZSAodHdvIHRhYnMgZm9yIGEgY29udGlu
dWF0aW9uKS4gIA0KDQpPSy4NCg0KPiBPciBqdXN0IGZ0cnVuY2F0ZQ0KPiBzY3JhdGNoX2ZkIHRv
IHplcm8gYnl0ZXM/ICBJIHRoaW5rIHlvdSBoYXZlIHRvIGRvIHRoYXQgZm9yIHRoZSBFT0Ygc3R1
ZmYNCj4gdG8gd29yaywgcmlnaHQ/DQo+IA0KDQpJ4oCZZCB0cnVuY2F0ZSB0aGUgVU5TSEFSRSBy
YW5nZSBvbmx5IGluIHRoZSBsb29wLg0KRU9GIHN0dWZmIHdvdWxkIGJlIHRydW5jYXRlZCBvbiAo
T19UTVBGSUxFKSBmaWxlIGNsb3NlLg0KVGhlIEVPRiBzdHVmZiB3b3VsZCBiZSB1c2VkIGZvciBh
bm90aGVyIHB1cnBvc2UsIHNlZSANCltQQVRDSCA2LzldIHNwYWNlbWFuL2RlZnJhZzogd29ya2Fy
b3VuZCBrZXJuZWwNCg0KVGhhbmtzLA0KV2VuZ2FuZw0KDQo+IC0tRA0KPiANCj4+ICsgaWYgKHJl
dCAhPSAwKSB7DQo+PiArIGZwcmludGYoc3RkZXJyLCAiUFVOQ0hfSE9MRSBmYWlsZWQgJXNcbiIs
DQo+PiArIHN0cmVycm9yKGVycm5vKSk7DQo+PiArIGJyZWFrOw0KPj4gKyB9DQo+PiArDQo+PiAr
IC8qIGZvciBkZWZyYWcgc3RhdHMgKi8NCj4+ICsgbnJfc2VnX2RlZnJhZyArPSAxOw0KPj4gKw0K
Pj4gKyAvKiBmb3IgdGltZSBzdGF0cyAqLw0KPj4gKyB0aW1lX2RlbHRhID0gZ2V0X3RpbWVfZGVs
dGFfdXMoJnRfcHVuY2hfaG9sZSwgJnRfY2xvbmUpOw0KPj4gKyBpZiAodGltZV9kZWx0YSA+IG1h
eF9wdW5jaF91cykNCj4+ICsgbWF4X3B1bmNoX3VzID0gdGltZV9kZWx0YTsNCj4+ICsNCj4+ICsg
aWYgKHN0b3ApDQo+PiArIGJyZWFrOw0KPj4gfSB3aGlsZSAodHJ1ZSk7DQo+PiBvdXQ6DQo+PiBp
ZiAoc2NyYXRjaF9mZCAhPSAtMSkgew0KPj4gLS0gDQo+PiAyLjM5LjMgKEFwcGxlIEdpdC0xNDYp
DQoNCg0K
