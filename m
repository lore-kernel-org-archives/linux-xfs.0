Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD9A39FCAE;
	Tue, 13 Oct 2026 09:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791882619; cv=fail; b=EUdLMydQr2CwSf/KM7jOF49vQOims3Ptl6Co+zxiHz56vAAgngvMGP9AuGp84NXGw2O3C9ukzGmfrslEle5XtssTg7tooXbg1BwAAOmHwTAerIAsnnx+HlG8zIXyFNUTAYChLTmfgVIrQT6WEhuUNHVCHkdNtYe5xF5bO0me+YI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791882619; c=relaxed/simple;
	bh=gAfniZ05E1jIzkjesXmIGOPCRjxpQuxKCHnArnnUrok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f0bvQFLWM6rXxrSX/DRSD1rPHMTz4P+cZees0ovw3Rp+Dddi/CyhLJt5Id+GWAQDD4aWuJh4CwKiK0qTjGcxgDoPk9Qv713Duj/kQktWHd83PUqw2HqbJggxGqzQ1J/oEjvaOWY9bg7gHSc54gRNRcLDB39QbL51FHaXJZO7oUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jub/iu5K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PQXimCgf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jub/iu5K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PQXimCgf"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BrsT3200294;
	Tue, 13 Oct 2026 09:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=T6HiuOM4YYtdE5fnga
	m6U9dIhCxOqjq8Bdjj3U8bWFA=; b=jub/iu5KqHWjrL1+wZV0rezmnBpytfiw5D
	75snNDtDu4bMGMtGhQRLMUUD/xVqS6l5z5umsCPPoCtEA58JdkpToPnRBxr+nigr
	NA72RayaSPSbxEMvr7PoCbrMqgr2uOIlciWBwebjNSSDPcveNO8kiukj6zTFDtWv
	DU6G3897avucrEcxynBpw+xYLm/aMUpPZrSjgV7m6CBbgqdjvYT2oR3WhLCIn5iP
	LxQdamNTZKePoJLvim1/KABWcLplMd21kpQjeDhhp7gFgyvCB7jkoRsYz+GQRXAe
	vCC4t5GQDM9qnSjOy2mmSUwy/uh27pPgb8tEsohednH99QlF9l0g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demknss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:10:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D8pg9w040138;
	Tue, 13 Oct 2026 09:10:11 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp8yah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:10:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rv1jBmHN9HGEe5CFJAlG+7LJQ6AmIVSwFFrGNSBoIT2saCiJyuwQp2L8jSxykGjhGJUXZimmIK8A3bfPqQQIpGBgsm0IFmGJTEBDv7ivHtWf0saE+o6dOecrXQad+brz9yaqIH3tsniQJRVXEDb4yzMokEii00thoFsZiNhTd8uUW0t3PtkvP/dN2U8bvTa2hk6PCZr7PexIOQerwKG9v/tHF0MIAsC5xVza1xbcyyi96wrx5OqnuuvIiL8VCJMpZgbvvFUQDEaQ56RfAC8rnRnzVy9c6vrdN5EdfuRyGO+qsbJHFCXPohaPdLSArHJ54SX4nGqu5sgn/rdZU5p6qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6HiuOM4YYtdE5fngam6U9dIhCxOqjq8Bdjj3U8bWFA=;
 b=Qk4AF184JMWGd0rIMTCoobQG+tgC3b9z62ODHGFmHGEjNDDMhnh9lNiy59wiZ/1eJvmPzYKFudJ/Uo/s1FNqJuBOf53bXGb4BDMJIpVOpk7iZ9dMJdYXFSCK7cGu5HhIQBMSeHe7i+Slj8xMZ3rfqihVNGJHkyu5wlSVtL2cAzTFfRXFN2KURSjQkPXS5QtydLyyps4GXN3DKS/w85zSZBBnNBYtSwVrK0NUI/Wnh0x8BtCREhW99zTVKVYGj68l/pTnhVgn7mkXG40YpM5DAdL37dYwJGD+hb4OSyuqXrpfHyTV1HnGcw1e6Df3CPT3bvXvXnhA7M1gRx0QU1T1HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6HiuOM4YYtdE5fngam6U9dIhCxOqjq8Bdjj3U8bWFA=;
 b=PQXimCgfM4Va9cH6DxVUmXM4tzy7K4i3WuuyVBe3dgaueOuxGuFLD/0iPBueA7IWAWjLzWE4LEXMsji2CmORstb4Vjzi//LykYyrXIbcAVavyJE2GKoBnfOSRjXxwkP55pLU/+H7PYPz+mcbbm3zwO9jMkd6qeQ0ixbUVdq+bnA=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV1PR10MB375422.namprd10.prod.outlook.com (2603:10b6:408:516::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:10:08 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:10:08 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "sashal@kernel.org" <sashal@kernel.org>,
        "djwong@kernel.org"
	<djwong@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dchinner@redhat.com" <dchinner@redhat.com>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6.1 v2 0/5] Backport of XFS umount hang fixes
Thread-Topic: [PATCH 6.1 v2 0/5] Backport of XFS umount hang fixes
Thread-Index: AQHdWvKkQwwToH5xk0ifJpk80wWHlQ==
Date: Tue, 13 Oct 2026 09:10:08 +0000
Message-ID: <745f6033a34f91322ddfff4545de1e1e1f784bc3.camel@oracle.com>
References:
 <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
	 <cover.1791877866.git.siddh.raman.pant@oracle.com>
	 <2026101349-punctured-overload-7f09@gregkh>
In-Reply-To: <2026101349-punctured-overload-7f09@gregkh>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR10MB7505:EE_|LV1PR10MB375422:EE_
x-ms-office365-filtering-correlation-id: 958efdd2-2021-42aa-6501-08df2909c73a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|10070799003|6049299003|366016|376014|10067099003|38070700021|4053099003|4143699003|22082099003|18002099003|56012099006;
x-microsoft-antispam-message-info:
 Dntvpboca9G7chYFFkVNKaa14WqhzOd86UcaCtKNnl0yuXkCK7Q0ILgujHTeOa++D1/5Qdn1y0pCY+OMCeSbyoaN8b41N6JvfeUO7An+Kw8OZiCXHznrmF+3p9TDjo+2msvGxw06iATyEu11uViaPZHOgnAGStn+YTtH91oiASzQRATQfw5ZGUcXeLS6fSTiYCigZWrOZui/Ztcy+3OFKCEK82hXZgcOTidr5ucMX9zr/jHrltei3w942+8GKFjIj/tlc0Tt8cd6ZhG5x6KTsbQ3DZmBJp7t5UyUOxqhlK6fHZ10HLu4FhzTVNZA3/R0l6h3rRjKee+p+6FbDcpYA1V4s72hXkiwbibTsKHNnB15VdcWgIFTPV3Q413w+meCuMNzVwJFVEc+8SCncWGE3ARNIkcWt2WrkMBGz3593Pl/h4bOJm/WieminQXRHLbOeyD+AgDzDJUDkr7qfhfDcJD0KK9WAmuGLW+ghYokORkxEXZKcOdvVdSjOdo5R93JRBQuDUG2B62DfnvIdpstGOlO58anosOI0ROzsuaEgod1zhHpGniIN2GZcvjLwioXVEnp/igVJFHRvGaUD6AEqODpU192t8VhzuVUtgdyihR504jR0x+VTeLZaB99L3gsZ5uSXoyTAD3MUko22DW9JA45rEJdVB8hfKloevDxLDUk8tfaL4N/gWcDZBpApSlqzfgaEly3A6LdXqYGTbLxJp25Cn1rshOuW+WPRWtTFJ8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(6049299003)(366016)(376014)(10067099003)(38070700021)(4053099003)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VEFHY1YwSzJnWVFmUS8xc2tTOThQRzFoVC9ZWEtYam05Zkg5bnBJeURHRjZN?=
 =?utf-8?B?N1NnWTZKLzNaeFhIcVdUdU5OMGhlM3dpQTl3Y1YrbGI1MFRFS1ZHb3RCMTBE?=
 =?utf-8?B?ejNIS1lvWWRHR0NUZS9lU3BMR0EzRkF5TDU3TFZBbEQ3d09GMjZqSG15OEVD?=
 =?utf-8?B?VVc2VFR1bFRBUmY2Q2FRVWM5YXJNSzd4N2E3K2xCdHREU1RzTERFYkxWVlhT?=
 =?utf-8?B?V0hrNkpOVUltZW5JQldtZzVLcXo0N010aGxRSDlTdlpLN1JNV3o0dFpEUDZn?=
 =?utf-8?B?am45NXdjdWlycFlIeU16Zml2KytuL2ZsZ1ZlZG9NaXB2Qm9YMkQ4NksvUlpF?=
 =?utf-8?B?UlcyUmMyOEZORTYvcVgvMmpSUlhUM2QvdTNVSmFFR2c1SVJJU0gwbWNYUTNP?=
 =?utf-8?B?aGp4ZHVMalBSZGU2bnVVVXFXVXlsVWJkYm0rTUw2alBtSHp5VHprVVV6bEdi?=
 =?utf-8?B?WU9YUzA5cmR2emFlcTU3QjhsSHNQT0tJRnJuRFVnUHp4ekR2QXZubEtvS21C?=
 =?utf-8?B?NzVkS1BDZ0NPUnk0NzVKWS94K0M0b2ZPbStETENoMElPMG5aK1MxZ0tpbWkx?=
 =?utf-8?B?eEJOU3JsVzYvV2dUdEdtV3JrWWhac1JMTjNWbjBYdHhNVWFxbi9XenBjUDg0?=
 =?utf-8?B?ak9nRUFSb1RsWVRYbnBsMzdaMThrSlo4VmVPbEcxNStVMDFpTDJmbFUwRjhD?=
 =?utf-8?B?VzZUa09BWjNRLzZTUTZVSlNRMWRiZ3JWaVJHcitiY0FsWnBtK1NlYy9iM216?=
 =?utf-8?B?YXNxR3NXVWhHKy9QWURRN3JUaDhZZGRMMUl0TmRncis0Y3RUbU1iVWl6azRT?=
 =?utf-8?B?YVo1aGhRb0M3dERRUXhwUnFKQWpBUFdqTEw1RzZMWk1SSThMdzNWeFFRKytT?=
 =?utf-8?B?dW5VS1JjaXg5bTNlbDBjSzJHQVQ5ZXhxTGZ6SnI3dnFKZTlRWmY4emtFTDhV?=
 =?utf-8?B?c2ZTZ2dMSXZRaTgwQU9WeXJtMzNWZTZqcEkrNE9xcDFyeXkwVzV6ZFRBYkhr?=
 =?utf-8?B?ZEQ3SGdoYjhOQ3h1RGlVNUxmckVLWnFTVnVqSS9zWlB4VUpnbTBBSXVObXdL?=
 =?utf-8?B?TzlWbnNXdVdMQlhxWk82L2YwSlRJZ3BvdXVzK1JjcDYrTUpRYXdIeEwyb1or?=
 =?utf-8?B?UXFqZ0N2VGk1bmdlSVhYcFcwcDUwRXpEQzNpcTkxVzgzczUrbVZCdUpLcGNh?=
 =?utf-8?B?SXB0ZzhJTmhXZnhkN3ZlNTZaeUNJRzB2d1hlc0hWYjdpdUM0UUJrRkZ1VGZ2?=
 =?utf-8?B?VXZNbk5DamkwK0Y0cUc1M082YXhFcG1OVWxOOEFhV0tUOHJhb2RkSWZrMnA3?=
 =?utf-8?B?TDNqS1A0WDE3cjhFd2l4VzJwN20rSCtpY1lhOEF0SUxGOEZ0WXZYRHk3Um5K?=
 =?utf-8?B?M01qbWdyRXh2TkRlRnBhUFFrVkF1cFRTUnZXc0dyeGR1SjB2alpkdHdtU2xs?=
 =?utf-8?B?bDMxQ0VnSVowODBhL2psU1FlSkp5ZmJIZ1BwcFcwb1dudWpEMEtPNDhHK0ti?=
 =?utf-8?B?M1NEcUxuYktjS25UbnYyWlE3ZzZLZDZlQ3BUVWI5MVZzbmNlb09lMkJsRU00?=
 =?utf-8?B?aDlSUGhaNDlhMzFZdG9oSVN0dE1WSXFmaVlJZmcrMTVYVTZRWTRkYVkyaHJG?=
 =?utf-8?B?TUxTeUd1aUt0M0p0NzlwYTc5OW5wb3p3bUFDTkZGTmJ5OW5FeFZGUE14bHJI?=
 =?utf-8?B?dDR6RkZTK1J1aHI4Yk5BUG1pNSt6Y3hwVGRzOUFmdmVzcUpoSmZxSnlrSU9u?=
 =?utf-8?B?ZGNyUUN1dFJtMDVrd2RQQkdwZGlYSXdZL2ZJbVFiL1pab3hlY0pUSFRuWmR0?=
 =?utf-8?B?YUZ3L2Q5dTdGMVdibGFlVnNsNWp0QWEwc1hWd2Q2cmhNNEVESy9BUGFoM1Z3?=
 =?utf-8?B?UTlxZmFmVW4xK2M1N3h3VzhxR2J6QUVyTWZpWVFuVGFKaHFIYXdXZm96YWsx?=
 =?utf-8?B?aDkrMjRESmlsb1h2QkE4eTArc09xeXJHS213Qjl4UElPcVdWZE1PVzl5cVRk?=
 =?utf-8?B?ZklzRzBsQXhMMjBBc21HWEk4TzN5YlN1ZVJtS00veU41RjNqWEVBMm95UXE5?=
 =?utf-8?B?L0M5YzlLdi9WZkpKYmtaTkwvZmlSSkVFTXMwYW1XZ0hNSlQ0MFFYTThLVUxE?=
 =?utf-8?B?WFl3S2w3TUxPZ1lYZERzdHNPUkhjcXRpeGZoc1Zqdy9pb3hCTkJEdUFnZmdm?=
 =?utf-8?B?dGJPZXpRR0M2MUo1UE5yaDVyeStEaVVhRW40WGdNSWpzSUx3UXFiVWtaRVdG?=
 =?utf-8?B?eWUrcjRTbjd1YStoV0VWMXBxYmplRjBTYVhGMUlqTW9oUzNRaGdMVXoxOWIx?=
 =?utf-8?B?OVBoL2NSMWp0Q3JnTk8yUVVzOWxYVWFOZDNHNHhDV3RmRHVPVGxnRVVHdXh4?=
 =?utf-8?Q?HKW8K3snaI8w5SeOcyPBMd3vJSgXPWr5ZO4uRZ9JEGK08?=
x-ms-exchange-antispam-messagedata-1: EQLyr3LUjsAEKqyqBmtp/1goCgaPLOxxuYI=
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="=-e+yeFbQg0gBEWqUQ9G52"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	OSvD5CFDERLCFqoUJfTBzYNv/KmuX9URlZiL9Q/rFpEU6/5CddfVXZhbHirreCCpbssjjyJHC25gKYw/N0EuiVYeUzfU1E2/20+Kv346dWA2Ac5Ezwv1gHQ3+dM8IEmrU1sRxhBaMmG4fxm05Q6+xqKBGf+BPveS/BWdpFID45KyScGGCRsH8cS+ZEfuq1MvjV3Ua3ylD9ibKVyTBE3W+ZCHcDilfnXIfLB8Dt/Q6WBNnhz84yjzupzjW+d7aNF90DTffKFYv2/QYaN4iiTE2ccea9/iUigEPN5sWKhZpAvYQzL770tW0j4nc8OmxnW6HXprMmPRRlp42N7w1fuOhg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n4Ka8ulprG0W4JYQEx7X6NSkZfXMh9KPLAl8MHZ7N3Km6lW8uQ7ku1qpgA4+X1D1eFddJF5jYkBwjq/TvZVWVohIRThf3xVZtreaMMN6EThQJBghKgAizy8VRxHZ3KCuOT3sPymcPV24qWv55JW9QhHEGKTC+zVdjwIk8j/Jnnd5Ltaplt/uVuk3P+LLFAEOyCelAiecIaGOtRDPvIFTl73fb/YQoY8UjQIdwj2JSvHzNhZzJa4etjTtcrYbJltGgCmrY96CimtMcz6y7bQDjCK5dPrpOrdrOCMzhI0BO4mQV1cG4iLS8Grj93OY40dfNL01lhRA/sDkI+rDbitiKJr0UXBMkvbhQz675I+9ENcfQaYX3OTTBMA0uO6z3F4PVY+sgup3kvVpIQmq+X6ppqqYESja1T0tr2KxrbsR8urUOi+8HuGPmgnnct8GOL5GylWWJ6A4iHbyVXGEuv52Ekl35Bz6I3L4iN/cw/WN9giEpBVHMp+AHcBn7ZBUqxwuFrpnJDmX+Ed09BUS04yYfO4AFHz3YF1CXNHLaKZo9T7tdnm9HyKDnx0i9o5VZ37XogCi4W0WtvIEgd585QwzQ1IFKTUcDFsPzfsObSPTeu8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 958efdd2-2021-42aa-6501-08df2909c73a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2026 09:10:08.3327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XQxhXiph+GmBwSbeznfOTSC96u3iwEpMFK2vTDjUZ3fth82DMwQW/Fs73Nt091Vcf+IGi8UPL6BXjk4TTQDCtSLIzxugU4crNrT6kSJZ6bE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR10MB375422
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=827 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130035
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acdf573 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22
 a=myWyeSLEAMoXE5n_Ie0A:9 a=QEXdDO2ut3YA:10 a=6LdZSa1JIexiLRnm348A:9
 a=FfaGCDsud1wA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12107
X-Proofpoint-GUID: z75aIV4JP8kDpiElpcjEl-hONL5czoNS
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzNiBTYWx0ZWRfX5ALwMK7uuJxl
 rEJ6BaTRTU66n6ZtgP8iAVQgpRWKUv7kV1vtw5pynsAI8X88dZ+/m/jwH8BbWPRgJ8UIkqxUT76
 cYO/LeWCbv4tUOcoOpdhM53lmt4ysQgALO/+2gi14o1evpJT2CZp
X-Proofpoint-ORIG-GUID: z75aIV4JP8kDpiElpcjEl-hONL5czoNS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzNiBTYWx0ZWRfX7UrDl1CrTpsp
 4g2JhFjJuacrecocd1+UbXSHPl1nExt4qEq4zNq+SgvtIW/Yxm+3ZUBXlPYB6RfOdPCifIn//6J
 XLSTGP8CWSLL6HeLsACwe0u2uQSMfquXnM4fePEJqV61ZWljbfReYWlczn9SAPl0A6x016C7pj8
 2Mrl/ga3ZPjv6t8Q19zpLQMGZ1coujTZU5NkGzzHZERD9ZfV3J1ajIH2t8UU00SD05AqNn4uDe6
 rGcwmOzydALxsQE45DnDrLnkrZiNv8KbkBSqcwZ2UiNyFrYbm2Xz9NiGQJGeyIU/2fe6lgP4Q01
 1qnV1j/II20MHalkyEnkH+MjxIpx7r8qujQHePZQvp9l5Ne2yTDvUVuzir7J/bx+C4PmnuH4R1t
 GomHLTyItAHHbNwx2N5XDEVWYSvG9IXRBoLjoFPWgo1+JdQrTtGdStD1haNQ1WVGRa3MtALhmDN
 5YhDMRjNC5w56eRySrhGbUjYVpJODp5ezVFgkWos=

--=-e+yeFbQg0gBEWqUQ9G52
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13 2026 at 14:16:56 +0530, Greg KH wrote:
> I appreciate the backports, but wow, this is going to be a mess to sift
> through because you mixed all the different branches together.  Here's
> how it looks in my email client:
>=20
> [...]
>
> What would you do if you got something like this?  :)

Huh right, I'm sorry for that. I will resend.

I only used git-format-patch --thread and git-send-email in a bash
loop. Seems like the operation was too fast for format-patch message-id
generator to have the same time in ID for the cover :/

Thanks,
Siddh

--=-e+yeFbQg0gBEWqUQ9G52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEQ4+7hHLv3y1dvdaRBwq/MEwk8ioFAmrN9V4ACgkQBwq/MEwk
8ip2gRAAp7hvMEDFIJmkvrJ7w2VvjLcrdiMt5+NSsQvECHzQVLs62ahs9Uf/w1Jt
AF5I0HKV6xrJRjZjQN0KPzi8RRgdphwF5BMno9xT7nGds61y8fnf+393Vm/rLuhz
SviPLxtkb8XhwCORItBeSvnHlKt/CHT0UXQFq4xLa1NPxouPd3b+GHeJ1MF+i5Os
7BBApcYrsovzA7RbpT7vSJqjpvNO5Z4Y13JDrI8pILE+J5YMr+FdAUa0nY+ZhWA5
SqD+ucX9iFRj/7vv8zRLrUYZQLSWIGJshyj82TZKiCh8AixoWNv+il4xTmFg3+W0
GPbZeoUwfmbtQK2vSLvduF9u8IPsE5Zb4xOq824Oi3ApPojGbyW+Q9FsQmNf/cGZ
qNamGwBm9dgFuowsjyrqa3a42pvHu5ScdQzOQK4bBCxQgyOp0p3gQ/lYcM3b/AWK
yn1Rx2dAFQz8ifz72hKfel/CME9RDMbdUb5aiKXspUbeB7bUCPkFiKRUS/rqCj7g
HlKP+L5f8f70uXUn7zZvhI7mHdAGU2vIKrTUxn0ORCu2VbaZwecRoIoFw6uHaNGS
tcPAaCcWjgwExJRXvVliRZptgqtyJ1viTvKQqYo9OJdF6UwRejBFonD4evVIPkYp
seUqEzPnoFxJstEiU/YozO9CBAQDkg/neRJiv4c6dwYf/xTf+ZE=
=NDj4
-----END PGP SIGNATURE-----

--=-e+yeFbQg0gBEWqUQ9G52--
