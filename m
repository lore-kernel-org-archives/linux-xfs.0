Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F2518801F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725958930; cv=fail; b=PhXVsZP+UNPKriD+9Ln49x7NUzCVWSe6/0NzZQvB3lKWKYQJadUW05AvMd1lIXc0dBjCslgOEH8/C2A5yuOGhU1bK/5ASSTvILh0bwrnr3NJVQAZAkY8EvUQXiAODVw30ACphxf0xNciWOZcWwzYHpkSHLQo/O0I4ZX8BIJmbcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725958930; c=relaxed/simple;
	bh=O62HBZpticsiGwNd0SF8G2tPV0dYaTxS3w16rjWZf74=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Nd1tMD+PwKIGhueiGN1R2ldThkKE4bKIQ+mrI7/8BOIKM8AqDI4GZXfhAacJqKDxai4v1rJS3mV0KGCiooA1uyv27NvKO3Tb1CBN4Benfwr6qW98sIipSBoYpcKR6TLUz2gbPVvn4oHRoIOpab6WcFgEZoyYaHnUCIkE/8mEh7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=Bz1jaDq0; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="Bz1jaDq0"
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48A65Nt0008061;
	Tue, 10 Sep 2024 09:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=pps0720;
	 bh=O62HBZpticsiGwNd0SF8G2tPV0dYaTxS3w16rjWZf74=; b=Bz1jaDq0QD85
	t5cDzDwym5F/2ogJTCPEs5Gr1NS0W2SO2UAKKiyOmIH80+WbsjE4MU2DepZJ/Kq+
	EfMl6vBDQz0R0vPTWbt+baHqcNwqLGqW0rDLPo268RUIwU4B7f94r8yixPrrXxWX
	NTYScJsvtEe0ybV+z3GDe6gX64lzKmh4nO78knqOUhfQ7dSlpcACbrk6d+plpJhU
	QW1IQwP6Xo7XENlyhxmPMWK3CHYxrVW6y/6MGLaq9ZTzp9WcDYay0AHokIPTRlte
	ikJxNW1sf02FeZ8wHu9/WZ0JYPAPOieAGMsIRsMtEaO0MqYIENN3YH9L6r36k46A
	Z3xRHNKd2g==
Received: from p1lg14881.it.hpe.com ([16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 41jgag9nb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Sep 2024 09:02:05 +0000 (GMT)
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id C49038059F9;
	Tue, 10 Sep 2024 09:02:04 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 9 Sep 2024 21:01:28 -1200
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 9 Sep 2024 21:01:46 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Mon, 9 Sep 2024 21:01:46 -1200
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 9 Sep 2024 21:01:51 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OuDcbZeXXMZfn0rVW6SFhs2w9L6li3k4UYlsYO/FmOLF8npn3D1rv3KMcIUoeiw2yjrA/oJ1TqKqLg0Ndm7ZGeVkMimAZppS6v1bVM4sFAWUvBsYN+c7XUcd/JY+up6ZgPM9mBWWmUKZZwjbdt45vzDw8U1OKJtI0TjGhfBn0emk+mEOcBDam9U97Bl6YYpNnpK1Yt/BAPRIj4UXI9ctavykIiwG/QvZHiTvp10LskLAycf+KWYzzS7zSck6401wiiEpjupQM3xq45Pt+q30nmM/lOE6MtbvykfRPtKJvpLROCmf0wByn3vA7w2Vk2U+K1w4EGnKYjF8L4+MjYjYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O62HBZpticsiGwNd0SF8G2tPV0dYaTxS3w16rjWZf74=;
 b=TF8GWvBoUeBTs7AJgVjdvvqdkXMHsvm7W7Yve1AkVVu/ZYHdQQ2on729Q6NBJAybzfmG8QregUxM5wI/1J2X//p3RinrwjCy0JaDeRkymZisr/FrxEGySy4MiEd1fKVzlpAwXgpahumaEioopJPjKEs2bQVfEia8KhiR7LWhYHC2i4O2tfIZe4WUYcG5Zl6RQg8R4T5I4AqFE2jre8o4we5ADNAcPQHPrUu3KV7NUAN8EJ/RSmW7gV2xtFdV8bs7IaSUCbx4dGzOhYxg7mv8PSqCWZkWt7+MqYJj5t9F2hErk9H0zF4aEBjBt3oDPvXiHeusWyx3UMrgI5QFS1Nyow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1a7::20)
 by DM3PR84MB3622.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:0:42::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.22; Tue, 10 Sep
 2024 09:01:50 +0000
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4]) by MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4%2]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 09:01:50 +0000
From: "P M, Priya" <pm.priya@hpe.com>
To: "nathans@redhat.com" <nathans@redhat.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: RE: XFS Performance Metrics
Thread-Topic: XFS Performance Metrics
Thread-Index: AdsDO3LyAKFhVtc2SFieusyqvePGcgAC9legAAQqi4AAAD494A==
Date: Tue, 10 Sep 2024 09:01:49 +0000
Message-ID: <MW4PR84MB1660E4CBA90C778F55E4DDF8889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
References: <MW4PR84MB1660E875ADC85F675B7DE5BA889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <MW4PR84MB1660429406E16C5B4CE9711B889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <CAFMei7N0zgsxLnOcgvQ96d7Z1r=eWrtDtEuRuwQ_RmwbVk0p7w@mail.gmail.com>
In-Reply-To: <CAFMei7N0zgsxLnOcgvQ96d7Z1r=eWrtDtEuRuwQ_RmwbVk0p7w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR84MB1660:EE_|DM3PR84MB3622:EE_
x-ms-office365-filtering-correlation-id: e6b2e81d-1894-429c-5ce8-08dcd17734f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WFFqQ0ZSamJFYXlpQm0rTjUrbnpLcnE5Ti9OWUpqaHVzUnorK1VFUUYydmZT?=
 =?utf-8?B?UDh0djlyeWYwcmJaZ3pZTnRzeWVSdUpOc2JObFpnT2FvV2tnK3R2a3FVUUtH?=
 =?utf-8?B?ZWtSQ1JXeTBEMjZ1VDJJMUtKcFFVSkpYZnBWK09lY0dzZ2haZGRrOS8rK1Zo?=
 =?utf-8?B?WGJEUWFtVUc2enhNYXAxU0tWOFJsbkR1bjIyQXNmQlpzNkpFSVNMci9iWGNY?=
 =?utf-8?B?c3E5QlZXSWlWMHlqSFd6WXlpYkdUbUhuUUc3b0pWM2hIZGdPbmdEUkMxZ2s1?=
 =?utf-8?B?SmphTlZBUHQ2OGJ2R1p6SWtCalpuelVVVWJSbUtpRUllYmhZTXY1RkNaMGtP?=
 =?utf-8?B?bkxIOGNuZ015Y01vdCtWYlpXVVVOaExnT2JtampacmYvQU9SaWxOREtvdXNr?=
 =?utf-8?B?cVU4UUU0aTUzZXBjYVhoUkxkOUFLMFFvbGRDRGNJSXBLc3NqUTlpNWQyRlY4?=
 =?utf-8?B?UWhVbjBCU0NDUlRteEJkWkVwZ0UvekF5SkQzQ2ZkM3NLM01rRVJTaXZrbExG?=
 =?utf-8?B?SkdSaVJtSWRPSHlpMHN5TjFrRW5IbXJoc3cxNmZKeUZGaFpHMDVQaDRMSGpR?=
 =?utf-8?B?RWpINExVK1RQSDBOMWlYMzk1MUc4OXJCU3J1aGE2VTFnL0VMVVJuMFFlOEds?=
 =?utf-8?B?RURDd3V1MDZDTEk4WUJWOS9FUWFtR3JyNkRFQXVvMW5KOVd2MnRlbkdobWFT?=
 =?utf-8?B?blZHa2VjckZSU21wT1NWQ1FVSWxCTEFjRE9leldWN0VzcXh4OUVJR01BSTdi?=
 =?utf-8?B?Tlo1elRZdlR6bm5HNXJBTlFLMzUzUFZ4Y3YzTUpMZVVpaFBmajlhYWpCOXhN?=
 =?utf-8?B?M2toR1BQaXZua3JLdW14YkY5TVRZMGZudFFxQzlmQkxod1dhTGNoaTZzZlRp?=
 =?utf-8?B?MFFWcDBCeGZ5dDI5N0oxc2JhVUlTYzZSM2VublEybkFlR2NORmZ1OFdzeE1K?=
 =?utf-8?B?RjNKVVBGMWhOU2Fsbkd2T0l4TUJqeXRqQTltbVhpRGQ1TTBMQmxGVzUxakNF?=
 =?utf-8?B?RnNWZ1RIbktqRnJuK1J6aWJoeXhsR3N5VXFmZ0VTemIyQnJFQkZMcWNzTmNO?=
 =?utf-8?B?aURBWHphNERJVlVlc0l2T3J1RVVvbitOQkUxeXZpRnlwc2FzUW1WcUhoSm9q?=
 =?utf-8?B?QUFWTmJRenRiSzAzSnp0REJjNmxxempuSlZCZzB2L1ZFNmdDd0dKYjJJTlJM?=
 =?utf-8?B?bzhxdWxDMFZHeUpJNVZ0aGRSSUduSThiWTJWV1BvaDlrL21zWmRsTXNTR3VN?=
 =?utf-8?B?M2FXeDRIMU9wMmxLZFhhdXE1U2tRaWUvMXJ2TXA1WGNudUUybllMNStiWDlr?=
 =?utf-8?B?anErN3E4bm1mbDNzcy9ZR0NKbCsvYWMzcDhaQjByM2xOZzVJOVV2Y2RpTWJq?=
 =?utf-8?B?d3V6aUVVOTBlQnNkdE9GdUF4QzdWakVrRXl1czJ4TUxwVENmSXFOVzBFZnhP?=
 =?utf-8?B?UHFxTmFDbDZ2Ni81bW16RzFlYkRSZXVFemovN0xCNit5VTJOdmZmRUpwREJY?=
 =?utf-8?B?anlSNEs2d1k4V2Y2SjY3NG5RVUNlUXFYZSs3YVZFWEUvSUY0Qmd6QzVwMVNS?=
 =?utf-8?B?cWl2dnA3VlVOam9wamxLVlQ5Yk0yRXpmOE1mdUU2NVl3SHdmRmZHcUNoWk13?=
 =?utf-8?B?TDVVZmFHWjBEWmNWSnZEeEJPMm5LaWhaWkNnNU9yZnl1U3d2NERxRUUzQVBO?=
 =?utf-8?B?dDlKZmlMM2Y5TVRVTVovcng4ZjRhUGZwdG5lUU44dmJZN0s5MlBWQk5BZUl6?=
 =?utf-8?B?MjlaZXd5ZS9NbWlTalVRbmFOQzJFM3poMTFRdkUxZmo1RnRMMTZSU1g3L3ZT?=
 =?utf-8?B?REdGdkpaWWpleFVnUzhZRDFSMmFlYjVSMTVhdTJNSmtiT0JSdnZFWjkxa3cz?=
 =?utf-8?B?STFSOHhNZy9qT1Urdm16NFJMRGZ1RS9qdjYrRExBTFNwOXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW8zcmpNbEZFZFd3VUptWG1uOTFWRDZsSVFGbW5WQzBvcHdKSUdVOXlvcjlm?=
 =?utf-8?B?Q1F1Y3lSbHZQYkcxUjFnT0N1elJadW9Wc3NvSVFXL1RRK2Vaby91MDIvQVln?=
 =?utf-8?B?MUdodHltQzVsUW9BS1E2RGE3QlVKOGdYZGRmcUVpOTZLNGVZQUZBTGhOZkhw?=
 =?utf-8?B?b2g2ZEk1UzIvbGpGVDAraDNhWjcySmR6VG9nTjJGa3R1MnEvUkFwampwcUhr?=
 =?utf-8?B?Mnk5bHQrVGdQMU9mSzRmK2Z2SXhBVHc2eTdqelBLdkVKUk90dC9GczRzOVNB?=
 =?utf-8?B?MjNka1V3NGMyUHNpZjBHRzQwS2hNUXd1YzVhMFBZalJ5UGtPUlFWVENlSDc5?=
 =?utf-8?B?cVp0V2NENHFJc0dHaVpzVnEzV0tzRGY5aXNOTzFSc3ZIcUQ1bWorM0FqUVps?=
 =?utf-8?B?NW5xSkV4SGdQN1ZRVHhVWnhDc0RDb0p1OUtxSlpwTGxYbXBOQXBFc093V0xo?=
 =?utf-8?B?ZXBUbE9tZnlaeWZTS1hhVGJYajFqVEhrTk5KaW52K3NHT0RpRjdBamY2M3dR?=
 =?utf-8?B?SjA5RVVrQUxNalJLaTJBcUNJUWFaRnJXVEdqK3R4dXNOemFPSkVPaFdodU8w?=
 =?utf-8?B?MEMwMUV3ZzN4V0VNdjNLek1OVWlrQkNHVW5URGtIRnRWeDYrRVdJbEYyQTZi?=
 =?utf-8?B?NDVoakhQdkZNSHVuZWszbHVqQnNRK25GeUlmQ2M5MnVnUnRzZ2h6b3p1Vng2?=
 =?utf-8?B?Vzc1dVlHaklpRWV3RnE5dGFUTGg0NWdEN3UyT3I4RW84elJmaXkwcmsrd3l4?=
 =?utf-8?B?cEZoUHNpd0hrMjYzYm0veW1MdU1aZVk2V2Job3BzUDhvSWltUGRDWkJzZmIw?=
 =?utf-8?B?Y1lQWk5lVWtGVFExWlFmblQxWklNVnZBVGg5L2I2YlU5c2dhUXlmYXZ3b28r?=
 =?utf-8?B?VGNnMnJ3aVFlcVhXWlJ1Mmh2V2JJN1FpeWJyT1RTcFJabklaamxwQ05mK2dj?=
 =?utf-8?B?elA4RTd1bmI2ZDFMMFY0eEk4Z1k0cmNyYWlrbndpVGNmWkhtSjQ5RWhnTHpj?=
 =?utf-8?B?dHZnTHNOTEhEVDIvRHdaZC9zdENEQjlZL3RVa1k3QnN6REh5enozaWovc3Jw?=
 =?utf-8?B?QldyQkhwK2ViLzV4RjVXUzEyVWtjanNoa1dsT3oxYnpXYkVKZmR3OTlwWW9w?=
 =?utf-8?B?ejJvZElvYTZ5T1BJY0ZBL21yRS9kaGx4b005QzJzaGhxS1dkTTBEL1owSzFp?=
 =?utf-8?B?ai9sMmVDTjdqQ1ZyMXR4ZmVkL2MxREtSdEljdzRwcEw2K1FlVzNmUE93SEYr?=
 =?utf-8?B?Z3hxNEkra09JWjJIeFhpdGsyM2JYNUxTRHM2bWVMOVMzN3diVGprdGpaZjlx?=
 =?utf-8?B?MFF6bEJMZ1FjUFVQNkorSkZGbi9iQVFhb0VHMU1MZW15aWt2YU5IRi94TDBZ?=
 =?utf-8?B?a1FtL3ViM1ExSFROU0VhM1N5VVFXWGRLa0hHTlUyNnNjOXBhNVptVENSOGc2?=
 =?utf-8?B?czFiRUEzT1hCdlJsd0RPdWRrR29SSHl4ZFJxS2xESjRwRytXUjdlZldYZ0RE?=
 =?utf-8?B?YTlwYnhYa3V0d212aFZ3TDJYYnFNdUZkU2d4U2tZYy9OWlNQZk1seDF4eDFr?=
 =?utf-8?B?WmVKeXlJeThTWU1vV1k5amVQQXIvSXNnd01hMjRlS2J5c3ZrK2FPa1FOb3JI?=
 =?utf-8?B?eHlvNytvWnJOTktlNm5aODBCR0d2M0NqbHhVK2xHN3owTU5vNHBaMDJnOVd3?=
 =?utf-8?B?WWFGV2hmUWR0NlZiRVVmR0x3U3pra252RHNNV3BHYTNSdHUvT3hoOXphSEJM?=
 =?utf-8?B?eEhyWW9oRHJadDZVdDZHdTMvWHNhbDFod0V4eHlVMnFoYzZjL2hYa0tsVHFW?=
 =?utf-8?B?MXVwbmxzYkthekJEYTYyeGlKRnRHWGdDaTQvaXFCamltR3Zrb3k2MUd1WDhD?=
 =?utf-8?B?TGcvZ2oxMDVOcmpBZ0ZmUDA1UzkwVm52YXgvOE9ickFTNnNla012Tjg0Z2gw?=
 =?utf-8?B?QjJ2V2V0MG1rMEF5emR5NFJzbEJMbDZlMDNTM09rRmRTMGN0MjBOMUZUN0lI?=
 =?utf-8?B?V2JMREdpQzhTcG5PTUNHVHdGSCtUK3JtNTB0OHNlQllUeVpkYzluNGVsNWxM?=
 =?utf-8?B?cG1ZNGdCWFR4UDVic3hpeXFLZHRkUVFHRTQxSUVUL1lTMW43eWZFRytidDJ4?=
 =?utf-8?Q?/fVk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b2e81d-1894-429c-5ce8-08dcd17734f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 09:01:49.9632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 54EBJZZaPJj9DTFEB5keZJvCLoE+fRkUrNnKcN7QNIteAA8xj5PuWL1tNQD8JwKnZGYASoxVXyQvtMsBVAeOGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR84MB3622
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: kx1IfvzTHefDyJvkIM6w3InFNb9GhzKP
X-Proofpoint-GUID: kx1IfvzTHefDyJvkIM6w3InFNb9GhzKP
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_01,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 clxscore=1011 mlxlogscore=973 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409100067

VGhhbmtzIE5hdGhhbnMuIEJ1dCBJIGRvbuKAmXQgZmluZCB0aGlzIHBhY2thZ2UgZm9yIG15IGNv
bmZpZ3VyYXRpb24NCg0KYXB0LWdldCBpbnN0YWxsIHBjcC16ZXJvY29uZg0KUmVhZGluZyBwYWNr
YWdlIGxpc3RzLi4uIERvbmUNCkJ1aWxkaW5nIGRlcGVuZGVuY3kgdHJlZS4uLiBEb25lDQpSZWFk
aW5nIHN0YXRlIGluZm9ybWF0aW9uLi4uIERvbmUNCkU6IFVuYWJsZSB0byBsb2NhdGUgcGFja2Fn
ZSBwY3AtemVyb2NvbmYNCnJvb3RAQ1oyNDEwMDlUSi0xIFR1ZSBTZXAgMTAgMTQ6Mjg6MTg6fiMN
Cg0KY291bGQgIHlvdSBzdWdnZXN0IGFueSBvdGhlciB3YXkuIA0KDQotLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KRnJvbTogTmF0aGFuIFNjb3R0IDxuYXRoYW5zQHJlZGhhdC5jb20+IA0KU2Vu
dDogVHVlc2RheSwgU2VwdGVtYmVyIDEwLCAyMDI0IDE6MzQgUE0NClRvOiBQIE0sIFByaXlhIDxw
bS5wcml5YUBocGUuY29tPg0KQ2M6IGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6
IFJlOiBYRlMgUGVyZm9ybWFuY2UgTWV0cmljcw0KDQpIaSBQcml5YSwNCg0KT24gVHVlLCBTZXAg
MTAsIDIwMjQgYXQgNDowMeKAr1BNIFAgTSwgUHJpeWEgPHBtLnByaXlhQGhwZS5jb20+IHdyb3Rl
Og0KPg0KPiBIaSwNCj4NCj4gSSBhbSBsb29raW5nIGZvciBwZXJmb3JtYW5jZSBtZXRyaWNzIHN1
Y2ggYXMgdGhyb3VnaHB1dCwgbGF0ZW5jeSwgYW5kIElPUFMgb24gYW4gWEZTIGZpbGVzeXN0ZW0u
IERvIHdlIGhhdmUgYW55IGJ1aWx0LWluIHRvb2xzIHRoYXQgY2FuIHByb3ZpZGUgdGhlc2UgZGV0
YWlscywgb3IgYXJlIHRoZXJlIGFueSBzeXNjYWxscyB0aGF0IHRoZSBhcHBsaWNhdGlvbiBjYW4g
dXNlIHRvIG9idGFpbiB0aGVzZSBwZXJmb3JtYW5jZSBtZXRyaWNzPw0KPg0KDQpJIHJlY29tbWVu
ZCB5b3Ugc3RhcnQgd2l0aCBQZXJmb3JtYW5jZSBDby1QaWxvdCAocGNwLmlvKSB3aGljaCBtYWtl
cyB0aGUgWEZTIGtlcm5lbCBtZXRyaWNzIGF2YWlsYWJsZSBpbiBhbiBlYXNpbHkgY29uc3VtYWJs
ZSBmb3JtLiAgVGhlIHNpbXBsZXN0IHdheSBpcyB2aWE6DQoNCj4gW2RuZiBvciBhcHQtZ2V0XSBp
bnN0YWxsIHBjcC16ZXJvY29uZg0KPiBwbWluZm8geGZzIHZmcyBtZW0gZGlzaw0KDQpUaGlzIG1h
a2VzIGF2YWlsYWJsZSBzb21lIDM1MCsgWEZTIG1ldHJpY3Mgd2hpY2ggY2FuIGJlIHJlY29yZGVk
LCByZXBvcnRlZCwgdmlzdWFsaXNlZCB3aXRoIGdyYWZhbmEtcGNwLCBhbmQgc28gb24uDQoNCmNo
ZWVycy4NCg0KLS0NCk5hdGhhbg0KDQo=
