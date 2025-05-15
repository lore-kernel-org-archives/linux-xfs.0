Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D981922C4;
	Thu, 15 May 2025 21:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747345824; cv=fail; b=ozJcrorYPl6nzav9+hsmTya62bYs0RnAcmgIvZF3Tdmjnl4dYZBvONZvkBJDWiVPmLwxr+TRK4g939h5IPWgGEHd3GicD0il2chj3GuBkXWwayb14XUrSxB3ciC1bOqKEO0PILQfU7vBQ+9vpYL+glDzwGkpVZ3UGKXihItNX+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747345824; c=relaxed/simple;
	bh=jJC5Nim4ij2e4LUvg9/YNFzfHrZC4QmBpJsGgG0gJ30=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N+xMTmlQ+saSRjU0afloITBMKbhSalludRMJMInRwZwS5ykCJHtIsdfM+3H+N4vkO9gfxiL/ocLdRjZ6OHVKw6Of0aYZkDziaz+fapK1I6iE4vP+klwXxRednCpK+VnQXwW7OCJGb7PJPNkCw2+2i+iI1uHjIJPp/h6FJK2Yh1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BHDwIE24; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mxun+J6u; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BHDwIE24";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mxun+J6u"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FLbRtF028812;
	Thu, 15 May 2025 21:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jJC5Nim4ij2e4LUvg9/YNFzfHrZC4QmBpJsGgG0gJ30=; b=
	BHDwIE24RaUyQekfpmWsacSRy+HBmDowg8a+Meavl6Uu4EcraXyRu/xNvFXqWgT3
	gFKCGb+WG7druOZCDAljWCLQMJs0TcD6UHBUelCx/sJNvk0b8KRRyZoOmK7cwA3i
	icuJyWUXgsQ0HEYB/9IJPXDeGEWfv1eRpPS9cSEOdWNwD+fNas4T0wKhWrIw42aY
	rOJclGog4m68tks1t9JakT/FZViDyZTRQFQmrOCffwY2QmNPAKL2G+KKxammg48i
	vQ8fsJXwSgCkyz97ArcgCDdhlUk4P3/JJa3/g0kZIGOWwBFC0wDhkWDwEBZsbuBm
	zQFRf0SB5gVUzvorVdleSg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46nrbjr0xv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 21:50:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54FL2BQR016216;
	Thu, 15 May 2025 21:50:17 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazlp17010003.outbound.protection.outlook.com [40.93.20.3])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mc35cfs5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 21:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zC8Sx+W5x9+9ns/COoX+kzl90Eq/ErRp6+fFEk5hWzeFUTXJYJCkKQEfMurRYd9bmUrVrXDar12ZlVaNP4hYPabAyFuB2074YX5eIcVGdPOxhxdKRYxJsRQsw4PVq+BcXVG0QNbjIrVToVtWM++SmJVSc/ntY5yCJ2NXO6qxLtIJXDs+aDLy5UQQPiIqir2QJZAAT0uqHXai6k7Hm59HaBV+HGI+e1rD3UZXwzq3DRfX0aTp9x4fn+upxnDjtrQAAD4wuVFTpmFaVCl6XWUsqkGdhsAdTzrjqAAghpuEP8RXYt/D28SWcSKcZytJ36siYkfaT5fzBSQYONul0WJAZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJC5Nim4ij2e4LUvg9/YNFzfHrZC4QmBpJsGgG0gJ30=;
 b=fkH7lFKXHGeLwjPhK5Nh6YXpWOIeYXlzL+eKGdVDfyKbAHkyMHcSqN/Dv9iDcfoUFjZ0lhFwXL6InxqZ3O8YFYC+bHA3eh39AJXs8BV2pgmsyOa7yRa75DX4V6gzgYieHqZeLqK7MzLlqfC61oFtkgQyb4x6OrVQP+lsUNiM0PLpNYpkBvyNA4LC3XRfbVfRgnIz/cDjc+jrJF1e5WO3mQKIElEaWlAp2WFnWXTVK1qISlcwOigm6Uk52YU59amau/t8nWD44YX8SAVALCfSj38GEQ8gk5ebW0MyoM7M6LvLCUJZcIxf12wL5VoAJPdgFREWGUsBZeEwhQ7OxqB2Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJC5Nim4ij2e4LUvg9/YNFzfHrZC4QmBpJsGgG0gJ30=;
 b=mxun+J6urYxQg0ksZCsK6KOOkZlcXifKW4em6vj1Z30npI2khKGQFD8pjqqdMFXtGS6HVa6cWSX4sPNCPYXdyM/fKB8rZGNdBEDfgAoyxcS1CFJCPNUGin1Ds/Kj0H2k/y95xwVulhXWWlJsF11nCKuZ0LH/K2Dd0jurck4b2HQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6840.namprd10.prod.outlook.com (2603:10b6:8:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Thu, 15 May
 2025 21:50:15 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8699.019; Thu, 15 May 2025
 21:50:15 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: John Garry <john.g.garry@oracle.com>
CC: "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
Thread-Topic: [PATCH 1/6] generic/765: fix a few issues
Thread-Index:
 AQHbxGc7lNZgNJBHoU2TWBD/rJyz+rPSE9oAgAAvvICAARbYAIAAb1aAgAAzCgCAAEEEAA==
Date: Thu, 15 May 2025 21:50:14 +0000
Message-ID: <57B7ACE6-4B7C-418A-B102-47BB3913D695@oracle.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-2-catherine.hoang@oracle.com>
 <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>
 <20250514153811.GU25667@frogsfrogsfrogs>
 <4ad2be95-5af8-4041-99d5-1c9dcaa9df7c@oracle.com>
 <20250515145441.GY25667@frogsfrogsfrogs>
 <cb1bce71-854e-478b-82eb-8a65ccfaf979@oracle.com>
In-Reply-To: <cb1bce71-854e-478b-82eb-8a65ccfaf979@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.500.181.1.5)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|DM4PR10MB6840:EE_
x-ms-office365-filtering-correlation-id: 76b88578-b35b-4a76-1a4a-08dd93fa79bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UkRYTVB2b280aVllUVBQYTNYRzFzK1lyVVg2UDl4YlI3aU8zL0gvS2MvUnQ3?=
 =?utf-8?B?ckFqRW9KUGg4WXQxRG5mOEJaWEVRRGEwVy9pQktNcEVLT1FORVlEM3grenpM?=
 =?utf-8?B?VlU1TzBUaG9tMEg0cXdydmpyWEZyb2pzQnkvN1NtZFkwZXN6VlpsSzBFbUZr?=
 =?utf-8?B?ZWZCVDBzMjNHaVAxbDZNVVluU1U5ZytNSmJqM01FajhSaGJUQ1RTeDViR2JG?=
 =?utf-8?B?eGFSSUgvSlRjeW1QWGkwYklLR0VZWmdSTSs5cG5LcE15Q0hoV2xKNXdtMjZD?=
 =?utf-8?B?eGNLSjlXSDUwUHNHZVZsQW9nUVd1dC9SdWlqSzZBNm1ZN3dyb2lYSU5vR2Uz?=
 =?utf-8?B?RGpDSHpqbGY3ZXJyMTk1Wnd0d2l0WUdKSWRyR3kzS3Z1Vmphb1liSFhwNElK?=
 =?utf-8?B?YUYrb25lcGx2VkVSV1dlYU1NakdIaXhzWTdTQkxHUDI3eG9vcWlVMlpQZkRD?=
 =?utf-8?B?VWZsaXRqOGZ2TmM4cVBGcGxpR2lUVThPaS9Ec1ZKeWVCTkRkTTVNYWJHVDhR?=
 =?utf-8?B?Q1BwTGF0b1NiajlTaW1kc1JvZ21wVlVZSG93M2ErS1ZFL24rdHo3SGdMTktn?=
 =?utf-8?B?VUpoUXhqVzFhRmRIL29ENGpZMzFIWkZJSytsVW5SZUxNL2M4VHhlYy8rRjJQ?=
 =?utf-8?B?c256RnJvWHMxK2MwUjFmc0k1WVdkMG8xOThoamFDYlVRYm5ZRzYwb0xtVUhB?=
 =?utf-8?B?ZFFCU0c5TnZ4Y0pNSi9GT2NpTEduc0tBM2hDWXJPaVE2bkk1dm1uTjFGZnFS?=
 =?utf-8?B?YUJwNXpXOUNSemdYdmlOR2VmWE1PMURmZTFpbGd3dit1YWl2SU5FVWxtYURN?=
 =?utf-8?B?YVJvQ0lJaUZnRktvd0V2a3FwOEV4K2VncE9MazZxbStYWUIvMThPN3RnZXFQ?=
 =?utf-8?B?am1MaXNwRStPTzcxblVWUDdJU1lUVEpURityV0ZaUDNEQ1VSbFB0T1dYNWNL?=
 =?utf-8?B?ZHlCamtPTXduVUx0eUpORFVPYUVyQzhhZklBUnJBbmF2d3BwaW9BeDRJUkh5?=
 =?utf-8?B?LzdjcFVTdlFqUHg2YUVHRnlacnBuTUNTczR4dkZnYWFwa05XZlpUNytHMXJj?=
 =?utf-8?B?bnk2Rkdpck5RZEVLcUlrMlB0K0F0QkFPeVUvOEhxRHVVUGxMWWE1STA0V1lG?=
 =?utf-8?B?aXQxR2tYdHR6aUJiN3pOYTRKV1pHNEtxM2MyUno2YlFrUTk0Zm9TODJGK1Er?=
 =?utf-8?B?UGcvVHhQNUFSR0EzcFZJSk43djBvR2JOV1FSNXhncko2MW1YOTZNV3JHeEpW?=
 =?utf-8?B?UVVKc2JjMUE4M2dCaDNIeU9wYUJFeXB0N08vZVEyTkJZMGxlQlc3OUxTU2Vs?=
 =?utf-8?B?OEp1R1NyTU9WNDdoakhOWlRqYytKQjN1OGtqZmt5WlhQT3h1QTdyTUk1cFpQ?=
 =?utf-8?B?YjBlUGFGL05JWm5VMmtEVHN4VkV1U1lGRWwySlRWWkhGUStyUURjWEc2M3Fw?=
 =?utf-8?B?VHJvWEhJYXJ3ZU9Sc0VHSFVBanBSQ0t3SVh1Wkd1Mklvek1RZXhSTkNtalFo?=
 =?utf-8?B?NjQzcm9PM0YzZHlOYi9wWU1sWW1DY0FxRklRNlp6TG1GUFBRdEQxZ1ZOVStH?=
 =?utf-8?B?d2d1bkduQXE4R2Y1K2Z6ajM3ODdVTktlUHVkdXNsd29nbVZQTEFGUUlWV0Z6?=
 =?utf-8?B?RmExRHE1QWFKYWhJRE55ZDN5Q0RuMXFmdTJ5aFFzRWdhMVNHVjR6VXJTWWcv?=
 =?utf-8?B?bUpMQ3g3aXIzSWRHTTRKUTZKQ0Z1NnZpYnF5a1BXSko1WFQxZFRKVlZsNVVX?=
 =?utf-8?B?WmpPWEc3M3ZMNHVpbU9VczRvajBVNnVJKy9YdTNUbU1NL1BmYlJ2MFJOeVh4?=
 =?utf-8?B?RzZNVjRUYzFZMWVlK2RNVXNhZEc0RVpJNG90RWU3YjNZK1dBZnBzbUgwQUNO?=
 =?utf-8?B?MEZXNVUrcjJnYmZGUzU5Lys4bHZ2MnV4VGFSRzJQREdWdGNzL1RSMGRsdjVi?=
 =?utf-8?B?ZFl4cmZyWi9KQUhMT1FwOHVtNWg0WXJrdXBvRzVzWEc0eDFsd3UxQi9HdFhE?=
 =?utf-8?Q?UBEzun72B5IDLuvPueNpRBVRPkxnLY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ODNsRW85Z1ZzSTlzTHpxZ3I5RkNpSWRtdUFDVDBHelNpUVMrSnNNNDhEbUJ5?=
 =?utf-8?B?Y21GcHhGQmhaK2NGZzdrRXorUzlQb1VzYmdnZmFVTnJmSVRTbWxUWkFGbWZa?=
 =?utf-8?B?UUNvOTN0MU13eTFGczFIZVBiZVB6ZHdKSHEraE5ZY2Nlci96SlpuS0gweUJ2?=
 =?utf-8?B?b1FNb2Y0NEthQi9mN2cwOU5qK1RyQTl2dFZ2b0puT08velA5WHF2Q1A2WXo2?=
 =?utf-8?B?OTY4L295enJHRnliM0tBYUNkNFFGU2N1d1RSVTN2bi9QVHlTSkJCZU9jUkMx?=
 =?utf-8?B?am1UNTBRTzI4am1tOC9oUlNqYlRkT09KbGJhQ1dMWjdRU2hXWk5nMEI4ODkx?=
 =?utf-8?B?QTRXeTBpV1NpQTArcEN2a1NRQkREb1hoOFlpM1ZmSDlmQnRzVC8rck9SNmlk?=
 =?utf-8?B?dVBkYVB3ZlpnMG0vVFdPWis2OHJ1UFBkYlVVZk9zZUkyTTBTZVRZaDRleWVa?=
 =?utf-8?B?ZlBia09PV1poZWx1ajVpdWF5WnJFK3ZPZ2tVV0I0ZGl2VGpSdDVmcVJwSE9S?=
 =?utf-8?B?RTh3RXF4cjNlTnRhTmxaRUNCbVhWekh2NDBJcUFtWHFadEMvRVhOSUJEclBz?=
 =?utf-8?B?WjRNZ1hGTnZScVZ1ME9MVXNTckRRRjhoMWRpb0czTDlOZmZBaFN2Nk94ejV0?=
 =?utf-8?B?SHk3ZVBlT1E3b2t3YWdnY01lM3k3c3owenJRaDdrQUdGNkF6ZXRWUmEyaFZV?=
 =?utf-8?B?V05Tdm5RaVNCZzVXaiswanFPQXhmRkxhcWRpVXFvdms5S3ZIOHpadXA5cVhu?=
 =?utf-8?B?YTAxbjh5OGRnbWdYZ2M2MUpDUFBtcDl0K0dBWHo5Y1I2eDQ3dmY5MUhhZWNT?=
 =?utf-8?B?SnkzcURCRmltQXJQVDF0QnU3Z2owbmlDbmdya2t5NExhVmYwVTUycGpLeUdV?=
 =?utf-8?B?RndqZEpodHBRM3NIWUQ3a0lWeGV2bDRlU21nTDhKcVNWK28xN3BoSHlLNW5G?=
 =?utf-8?B?OHlvY21IOStpQWhuUUxEVWo4WWFydHZEaVY3azJXWEdnN2JxYStqakk2NWlo?=
 =?utf-8?B?RWszTzZJYjdGV0R2RW1kOVIvVWgyaUl5UUZlNzBYMWlFc2FKajFLYjlrOGdp?=
 =?utf-8?B?aVF5MUlxWThybDNMK0ErR0gwNS90ZTdORVFLM3lvcVM3UHpteEVQdTFyMHZO?=
 =?utf-8?B?Ykl2STJQcS85YnQwcitVVC9WU0hEQjh5RXhNeDB6ajNYZFJiVUNnZk55MkRL?=
 =?utf-8?B?T1RidlpMamp4MlhIS3czeXB6dkNnRFBHUjUxNUtYcEYzcFdxSzF0QmdkRk1X?=
 =?utf-8?B?ZGQyaDJXNWI5MlV4aFN3MlNqdGFraDNnM2xvV1VDSFovZWd6N0lURW5QSDgx?=
 =?utf-8?B?NjA3YUlubmdVRm9XeG5XY1hGZHpzM3hSdElicHdvUll3MHJpTm5IdFU4YTFo?=
 =?utf-8?B?bERLMW9UbjBuUWI3NUVpYUxYMDM2RDBKcndYU2E3NSsvanhpaGRQdTZuQTlS?=
 =?utf-8?B?SlptbURDRXhjenZPc1BYcG5tOG9ERlYwS1o4djNZNE5RT3hYeVo4eXFMTzJm?=
 =?utf-8?B?ZDlaRllRdVFKNlU4NmhFY2xzSmU4dEdqa3VqZ2VralRDMlFQQnRTdGNtV2pJ?=
 =?utf-8?B?N2ZvQlh6aU8zdFBKZUc2S0Z1UFN0T2lGQmJaR2RzTjI0UnpLR2F2Q2FtMStB?=
 =?utf-8?B?engrb0U1QjN2YlpCTVBFS2tkdnN6SXB3YURtZzdoWTBvVXM0UVAyUDlQOEVP?=
 =?utf-8?B?NnFVcTVqcUN1T0dDVk4yTXJWWDN3Tit5UnhUdTYzc0grOEo4TEsxMlUyRnc4?=
 =?utf-8?B?UmpkcW92QUdocEJlMElpb1BvdTI4VWZNcTcwQktNU1dqM1FmcHFpR2gvZXE4?=
 =?utf-8?B?dnNWZ2ZZclA4bWkza2dFQXFua01mSnRYeTN0aXdlRHcrdk9LTFhJQThDQWg0?=
 =?utf-8?B?TlBIeWZyVXlBbHMvUFRXem01WDJKVlpUQkpsNW54OFZObDFJWjBwTndPVjRx?=
 =?utf-8?B?bHBmNDY2aEJQZTIwNGVHK1ZWMS9YY3ZxdzllWGZpd0ZJVnBPQ3pWV2pEU090?=
 =?utf-8?B?anlYT1d5YmpBQ1ZVdDNrdFJxdE1KOGhUTTNnQTJIYVI4bENpVEVTNzZ1eGpS?=
 =?utf-8?B?V0NoQkF1VzBRYVVkaWM0TTNyVEQxb2JVbVQ0VFM2RDZXTzNXUUNScjBuMml6?=
 =?utf-8?B?aDlwbWlsdGIveDNMWXR0YlN4b3FQekdKaEljV2o1b1VJTmpZQ0szU1doaGlW?=
 =?utf-8?B?dW5XZURhYjFId3BBU3JMdmVsV3Jydlc0eXJlV1B1TURSYUFaMExjNGRvY25Y?=
 =?utf-8?B?cGk5U016V0FvT29ScFIzdm9pZnl3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E74750B1484A4E459FFB2E51F8842168@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0dtc++yY425O9QBUmbmExEZc8o2nTEBCUk66YvB1E1XxVWSyDOugXRCN6hqLsSfmUzZcD+kSKRivZZE5KG8yT3KpgmvTwYnqwibAzPDghuKJVUo7YJscC72uQ72yBOaY07XDA3VhVOES1kTLaI6CtZjaoMx+0B1AbdMhOC1YbhKJ5tF1npxV8FHQG+y2k7K2RpPaCkL1lVhULHlAMwQ2jCCQ607Pfyd3pV5a3dlqeWDCpkJ/UWaIURehQZLGZ8YFsaKXp5bP3rTVLCFIWFJjKKEHjUweid68A/guceDx1GEiG4zpMXDBja70bh8cu3M8rM2a1OQ/UsLiW76wt8wpprKPEWWmUVsqcWaCfS5jsdPqWImNQN9tTnlBD2UUk07IWKRuqBniGQCfs40jmeUhWLR6PM2NPrzp8ZJp3rxlbgXkL0/NUxfT4iSOGQXuLvGJY61HJhEs9GIBJDIJT4jmHOrV99z3jajwvVmLRxL0oefHcvZivbNDjFV+BR3zJw3i2uPQ4DXQm+rsqvrjG0ixMAK+qNWDngbOj4h2+6GWGNcj02ZCimgcZ46zN8XruBByD2yiAWb6FcfhyjtBOIXkP5dDJwPsZFqJCKdv9ulKvwA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b88578-b35b-4a76-1a4a-08dd93fa79bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2025 21:50:14.9741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PmmmRlj6iSDndKVD0FBFydJjArDqZIOWPh2DzPdlgj5UKEO9EVHmXK9gccgXG8cLmTN8XB7UhCPwggkr6WOyZkBZ0wXhjw5oKa4Xb3IZtss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6840
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_10,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505150213
X-Proofpoint-ORIG-GUID: p-E40eqyu799NVu0Xaqf33_ciXhtAK8J
X-Proofpoint-GUID: p-E40eqyu799NVu0Xaqf33_ciXhtAK8J
X-Authority-Analysis: v=2.4 cv=aYxhnQot c=1 sm=1 tr=0 ts=6826619b b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=2Crv1cbGhsuC6-4c61sA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13186
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDIxMyBTYWx0ZWRfX+/VWFuweBaEW k8TX39kbpCEp/auwSE22/yMeSFGTf3AYwlBLfw58qugpI2wuVbqfHJlBgSsc2BWVTsZit2Keg19 NyBBDn5NvkNwiEWAW67HkipL/GMXo6WbWwBveWj6iQZE9G6LfhtvnZuaW1ltt7WkCLMBl24f+3b
 QI67767Du/+JkJA5EnAmpLBiQ1W8mcFd3HGDtp/QuaTDMGKgM00Mww+xc37xXsKJhV2RUfucR+m JobxYu4szNgGAsn4ui+rolD68yVq2vD7T5LBV29FZ5LeNC9od2DedqfsQPmSDj59xZiWVgLLgB7 fhvYgT/vTmyflkI3JSKOCY/7dbVLTxq0GBE4wM60Q3h4tE7GsFHiTl53JqVT6dLuXrsG4d4PB5m
 d+rk6w2QVI2YfS1HXnwogxADsGCr3eNgf2YOiO37l0iR3YfFqTbYFkLBllj1kfdj0onQjICn

PiBPbiBNYXkgMTUsIDIwMjUsIGF0IDEwOjU34oCvQU0sIEpvaG4gR2FycnkgPGpvaG4uZy5nYXJy
eUBvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIDE1LzA1LzIwMjUgMTU6NTQsIERhcnJpY2sg
Si4gV29uZyB3cm90ZToNCj4+IE9uIFRodSwgTWF5IDE1LCAyMDI1IGF0IDA5OjE2OjEyQU0gKzAx
MDAsIEpvaG4gR2Fycnkgd3JvdGU6DQo+Pj4gT24gMTQvMDUvMjAyNSAxNjozOCwgRGFycmljayBK
LiBXb25nIHdyb3RlOg0KPj4+Pj4+IC0tLSBhL2NvbW1vbi9yYw0KPj4+Pj4+ICsrKyBiL2NvbW1v
bi9yYw0KPj4+Pj4+IEBAIC0yOTg5LDcgKzI5ODksNyBAQCBfcmVxdWlyZV94ZnNfaW9fY29tbWFu
ZCgpDQo+Pj4+Pj4gICAgIGZpDQo+Pj4+Pj4gICAgIGlmIFsgIiRwYXJhbSIgPT0gIi1BIiBdOyB0
aGVuDQo+Pj4+Pj4gICAgIG9wdHMrPSIgLWQiDQo+Pj4+Pj4gLSBwd3JpdGVfb3B0cys9Ii1EIC1W
IDEgLWIgNGsiDQo+Pj4+Pj4gKyBwd3JpdGVfb3B0cys9Ii1kIC1WIDEgLWIgNGsiDQo+Pj4+PiBh
Y2NvcmRpbmcgdG8gdGhlIGRvY3VtZW50YXRpb24gZm9yIC1iLCA0MDk2IGlzIHRoZSBkZWZhdWx0
IChzbyBJIGRvbid0IHRoaW5rDQo+Pj4+PiB0aGF0IHdlIG5lZWQgdG8gc2V0IGl0IGV4cGxpY2l0
bHkpLiBCdXQgaXMgdGhhdCBmbGFnIGV2ZW4gcmVsZXZhbnQgdG8NCj4+Pj4+IHB3cml0ZXYyPw0K
Pj4+PiBUaGUgZG9jdW1lbnRhdGlvbiBpcyB3cm9uZyAtLSBvbiBYRlMgdGhlIGRlZmF1bHQgaXMg
dGhlIGZzIGJsb2Nrc2l6ZS4NCj4+Pj4gRXZlcnl3aGVyZSBlbHNlIGlzIDRrLg0KPj4+IA0KPj4+
IFJpZ2h0LCBJIHNlZSB0aGF0IGluIGluaXRfY3Z0bnVtKCkNCj4+PiANCj4+PiBIb3dldmVyLCBm
cm9tIGNoZWNraW5nIHdyaXRlX2J1ZmZlcigpLCB3ZSBzZWVtIHRvIHNwbGl0IHdyaXRlcyBvbiB0
aGlzDQo+Pj4gYmxvY2tzaXplIC0gdGhhdCBkb2VzIG5vdCBzZWVtIHByb3BlciBpbiB0aGlzIGlu
c3RhbmNlLg0KPj4+IA0KPj4+IFNob3VsZCB3ZSByZWFsbHkgYmUgZG9pbmcgc29tZXRoaW5nIGxp
a2U6DQo+Pj4gDQo+Pj4geGZzX2lvIC1kIC1DICJwd3JpdGUgLWIgJFNJWkUgLVYgMSAtQSAtRCAw
ICRTSVpFIiBmaWxlDQo+PiBJbiBfcmVxdWlyZV94ZnNfaW9fY29tbWFuZD8gIFRoYXQgb25seSB3
cml0ZXMgdGhlIGZpcnN0IDRrIG9mIGEgZmlsZSwgc28NCj4+IG1hdGNoaW5nIGJ1ZmZlciBzaXpl
IGlzIG9rLg0KPiANCj4gcmlnaHQsIEkgbWlzc2VkIHRoYXQuIFRoZSB1c2FnZSBpbiBfcmVxdWly
ZV94ZnNfaW9fY29tbWFuZCBsb29rcyBvay4NCj4gDQo+PiBBcmUgeW91IGFza2luZyBpZiBfcmVx
dWlyZV94ZnNfaW9fY29tbWFuZCBzaG91bGQgc2VlayBvdXQgdGhlIGZpbGVzeXN0ZW0NCj4+IGJs
b2NrIHNpemUsIGFuZCB1c2UgdGhhdCBmb3IgdGhlIGJ1ZmZlciBhbmQgd3JpdGUgc2l6ZSBhcmd1
bWVudHMgaW5zdGVhZA0KPj4gb2YgaGFyZGNvZGluZyA0az8gIEZvciBhdG9taWMgd3JpdGVzLCBt
YXliZSBpdCBzaG91bGQgYmUgZG9pbmcgdGhpcywNCj4+IHNpbmNlIHRoZSBmcyBibG9ja3NpemUg
Y291bGQgYmUgNjRrLg0KPiANCj4gSSB3YXMganVzdCBhIGJpdCB0aHJvd24gYnkgaG93IHdlIG5l
ZWQgdG8gc3BlY2lmeSAtYiAkc2l6ZSB3aXRoIC1BIHRvIGFjdHVhbGx5IHdyaXRlICRzaXplIGF0
b21pY2FsbHkuDQoNClRoZXJlIHdhcyBhIGRpc2N1c3Npb24gYWJvdXQgdGhpcyBhIHdoaWxlIGJh
Y2sgYWJvdXQgd2h5IC1iICRic2l6ZQ0Kd2FzIG5lZWRlZCB3aGVuIHVzaW5nIHB3cml0ZSwgYWx0
aG91Z2ggSeKAmW0gbm90IHN1cmUgaWYgaXQgc3RpbGwgYXBwbGllcw0Kb3IgaWYgdGhlIHdheSBh
dG9taWMgd3JpdGVzIHdvcmtzIGhhcyBiZWVuIGNoYW5nZWQgc2luY2UgdGhlbi4NCg0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgteGZzL2E2YTJkYzYwZjM0YWMzNTNlNWVhNjI4YTllYTFm
ZWJhNDgwMGJlN2EuY2FtZWxAbGludXguaWJtLmNvbS8NCg0KPiANCj4gVGhhbmtzLA0KPiBKb2hu
DQoNCg0K
