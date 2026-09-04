Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6E530F547
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530126; cv=fail; b=T7HEkdx7FyBMpc8wgsZarqBlOov/EYHTaMVUoA9+CoxOw8W3yvPvWWxCXSngfJm7fyvjrbbmNtHYIjgIsJpFLAkKjlWcmmcx+oyoGRsg6nxlESVmxATP/cDL6BMwxNuNeJY1S4oPUdvGkU6K12gBtkb3bZwHpmDZxq6QdmKM3Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530126; c=relaxed/simple;
	bh=PhzoxtxE6YU5aMwkOmqkuSpvOgwKR00YEwH3mDmkX1Q=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aYXbUuKE9P9roAb/BafpApRnf9hRUCsAzzlzH2fX7fx0toUpUKZvO5+be3AHPtNlQfBzgKd/U/Cam2LuukLDg6d04oNOEiC3ep1ui0QD2uaFprKFNLwASUHT1pwR7zULzbuqIAtgVGewa+xG5OZvnUmbEj4VftCz3rtv/ZYUZyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hcOEF4mS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=av69kVO8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hcOEF4mS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="av69kVO8"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684BgHl32674573;
	Fri, 4 Sep 2026 13:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bjCfn3geDSBrW4Kt0BoEM4ZZZC04aYttSTXlSY4Bg5k=; b=
	hcOEF4mSuPanOcGkOdl0RHycuhT5LkwqN0fvuErNqFk23hmVn8gjtn4+F4IE78rk
	S78AlroWSPKlfrOQE1dgRC5XaoOBnxNc3qTqiEd4N9bVtCtTD8FLSAsTsbD6DdxI
	CS6fL0ITw2T8h+MvAcjRNlMDo9iKi9kCcv0D/9bCUvwOYqXAy6K4ooVUC0G+IB6F
	NrK3R9o/DrZQbEz043GUeMbRwbSju2RGojAAWTjZ86k7ZlnOm7A583jENR8Q7mlE
	Xqwuv69eetN1MxZSvrvfwjW7wjFReaO9iQt3Q3x1N4aqpMoBl2ojFkh7vAewmv4k
	JBh8lNFJMKKd6l4H1PFELQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp72js5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 13:55:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 684DoVsr012190;
	Fri, 4 Sep 2026 13:55:16 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011001.outbound.protection.outlook.com [52.101.52.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvu97yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 04 Sep 2026 13:55:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXa/nlg26v4laqTUy/DJ9IW4kUd2lybTmXxX0auS6fC6KQOqGDniB9EXQ9ikOiKyTd02PSeQ0YIpMldYD7uHCD51sxitSylnfMQaTJZCuWy+ozcSo4ldZzB5tJXGL/Q4V9UodCInciouuRpEx87VxGGJm/KOTkbpktYUtNW+2QE22/Pm2ufh7orGAoom8FsI827/eAVmvpejxOKorJL7ftPVwZwTsh040IpWmvifi6Y06q8mIbdFybPzL2DP3O6M+HKMeTHkDyy82UPsPIpKbe/emADLTGrYvfE3JFaI2LKFcUUbsFPdW+b5PLv1+Q3ZFIYGrDlBz+9im5K7tHSeaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjCfn3geDSBrW4Kt0BoEM4ZZZC04aYttSTXlSY4Bg5k=;
 b=qlugTUnzVv6fPzENIdtB+VQ9KpupDDqQDwNR1leT73OjyZV7Es1coWoQd5K6U5TmbwPrqCq2tTFoA9GoIYF1KsAHSYMqr+Sl4TIzeWIIaqk0EPJHCZv5RCtxtaMyBUZ6mX9BAow20WR+9fZ2OWp9EtZoOPGsDH6EY3cnHq8KHNnUw+41gZjUmzDSzGw7OVLsFu7hLkvgwrswV5w1aJml/6ZScSWqv/G40aRoxau9jNpDJtUNId0yMq3CKyeacABEZ+ozHiyn3JsQTFRf9hWgxj/M4knNnmQhdIApRkUEF1C3EKwU1zpoj4siidDOiyXDhZPkahJrukmWD87Gq4WPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjCfn3geDSBrW4Kt0BoEM4ZZZC04aYttSTXlSY4Bg5k=;
 b=av69kVO8UI1lMJ/dcWJ6uyaeeVf9rQtPmRCW0/Zt9u4K/GbmOEwLUrkOwZFjn6ZCvG0ldvWfE8GBtRgaboWDzzvuN2cJtdLvhiE/7sSVON6RRGswlwLajSmJhCu0QSKuVeoKPQjG5DR7UNm05afW0iirl2X1H2TOE1YyGUq3p90=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by LV8PR10MB7824.namprd10.prod.outlook.com (2603:10b6:408:1e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 13:55:08 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 13:55:08 +0000
Message-ID: <c7986188-3680-46ad-84ed-ae45bb2cb3bb@oracle.com>
Date: Fri, 4 Sep 2026 08:55:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH v3 3/4] xfs: calculate AGFL max to support
 multiple-alloc transactions
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20260902174025.284387-1-bfoster@redhat.com>
 <20260902174025.284387-4-bfoster@redhat.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260902174025.284387-4-bfoster@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0032.namprd18.prod.outlook.com
 (2603:10b6:610:55::12) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|LV8PR10MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: db33f12c-ecbe-4e2f-8ff0-08df0a8c2141
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JXyecooPqjGyCVlv4EUZHZQY0mgDkQxGkwRQldX/FIsu6Kbc9pukVSEkoX8f3BzGQqojqZEw76E3AVSeb3dC5KRnWLQujwyNxtOA6t26XjiQt+Zqtfdbc/fOCeP+ezGEZCQxONs25XzLWBO+2eqzlptk3yTM43RxitnjMk8ELd02/FqMudm/9goXkPBgyuQYNWNvu8ElK+/pLpRQ3C/0muFgKZTbdp/y3JGmURZP2vxuqbe0ObZhJ8QeD5mLFj2Li11mgJpHdEhL+FRAWAgWDhZSUD/mStSaSb2BHT3dpiBeqcXsiloMzpe5GVQ6k5K5QnYc/oehm8UeN/9MxRQjMbv7y3dxu5hSVx2648OT1ccMnValUpNhwri5vXBOTMwuAn5DrwtaRVrAQAactmGCXTapgKXXfxl5VX8edMZLqbnTeCK/EtHnd5aaR+PQz5UtqKef9jmz0OTV5Hv5kxOMyxePU/vrAmbeoc+qCqi2wiDbZnJau6+/nZgnM2oeirhi0LCjMDNwgm4Zv//Vw20FCd9fQLiZaXZOi6JIT9aD82n5GJRPYj6NMaEewauEUh+Q4NCxJh+GsSPd65kLvp2FsuIydYoIcJqHEWBtQdJMi8LKKIwyyz3GMC0F8L7BKKWjbYe//SKcCJbhIeV9JS4EsPIwxABzVpKQgxPFKeMYydA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VThXYk9Tb2k5OWhQcVpySEloRGcya3F6TmtiT3lZZmxiZHJRS1hxT0tkTFBl?=
 =?utf-8?B?QUxVekx0NlRmR1FXRWphUDRNQjRBbVBUY3lZc1lnUmZ5Rk4wTDVrTUgxL2xa?=
 =?utf-8?B?QkVxU2RxeW9adCt0RmFNOURYZW9QS3YrSlZ5OUFkY3RYeHJ4byt4VktqOWVP?=
 =?utf-8?B?a0FWcnI1RitCNXQ1MjVKMnQ5cW12OUpBa1ZGYUVwRDRIbXgyMUxjWDAzV0tm?=
 =?utf-8?B?ZXl4Mzl5Ym9TcTBmOEJFaWNsNVZZZWFhN1p0UEUvT0FxbHZ2aUt0YU4yVmV0?=
 =?utf-8?B?bGloMTEwZ0Q5NVVyK2hEaUxkNXZKSTQ2Q1gyOUl1Y0R2Y2JReXFuTzg4MjFX?=
 =?utf-8?B?VGJQTGhNYTdXQTQ4bE5LSjUxcjk0OFByTjRqZ3JadjhuODQ0REd2NCt2ME5m?=
 =?utf-8?B?clZaNGJ6MkYyQXM4dnZlaUNqUGlmMUwwTS90KzNUVVViQmQxU0xWM2p2c05X?=
 =?utf-8?B?eE5HK2VjVzhSeVhuVEtnV0ROT0N0M2FWT2pRN3RDWjRCTnJkSFJiZmJsSTlV?=
 =?utf-8?B?U0hvekpPdHdFUVJ2aU5UWWRiOTRZclIzbThzVUh2SS9MZ3cwYkxPVmNjN2sy?=
 =?utf-8?B?VWlLNFJKRFBjelFUVXFIT0Y0SWp4TkxUQXdwOVEwVjkyUENISDBXMXRoNzVu?=
 =?utf-8?B?Y2d5LzM2ZDNKanFDOUdNTFpNdzBzallyZURDUDJ6cGNZQkNzVHdtS1VVMkZi?=
 =?utf-8?B?UWI2RzFoRWc2NzFkWk5KS0h6WW5TV3BVa3FnMU5OalRDMlZ4WnRSM05sNTBW?=
 =?utf-8?B?Y0d5d0x1d2c1TXVjYzFlOFJXWWpSbnRGUHFLQUtOR2xPQVV1amxzRWxrNk9O?=
 =?utf-8?B?Vy9zeklRMGovTWdhM1RLRTZtRmxjQ20yZ3ZFYTBtRGJZV3lESklPblJhRklU?=
 =?utf-8?B?Tmx4MUNaKy85Y1M4aUdtd3BGc3Y4cUtYWkp3cDZMWlRvSXJMREoranZOVHEz?=
 =?utf-8?B?NWlYbVcwZnljS3ZYbStoRDlnbi9Rb0NYbDl0VDJoZklvSklqakhQM2JNOWp2?=
 =?utf-8?B?OGh1T29JeitDdnVzdUUyL0R6eXJNa09na0luMTY0UExFd1EvaFZOVGZvcWFJ?=
 =?utf-8?B?eU9nanBMYzZXTnRFdWJaZFc3ZjdsRDloWW42dEVTdkY2OGEzZ3VnSU9FQXNo?=
 =?utf-8?B?UmlkTnpPSlhxMlRYVWd1YzRPQUlBYmVMeDVhTndtWEg0UzNkbjk1RktDZk1V?=
 =?utf-8?B?RWorcjB2OThqcm54Z3Aray9MNHgyVXh4WndsVnhRaEhHN0F3Yzl3R05lMUVR?=
 =?utf-8?B?MDBCcXRkMmFsUTJtTEZIN0Uya3pQNG9rbTRYRjhLWi95YjdBMDI5RDhaNitq?=
 =?utf-8?B?YUJWSUxmWCtyVWU1TlRtZU5OMmRpcXcyL2VrZUVkbkVicXExcUphMkRBbWox?=
 =?utf-8?B?WXdCZUlDSGZHNExPcTZRcUNuZnNLTk5WTHNXdk5pRHJhS1Q1UDVKcTN4Vjgv?=
 =?utf-8?B?VG9iT2dyVktPSkNrS1B1TnNaVG1adFpqMVFQbTdDYUdidDEyRzBDRXJieWtQ?=
 =?utf-8?B?d21jdkxoR1c1TlVkQ3NpUTRETUV5KzFNL0lPM3RTTUdxTFFLTXdzMUo3MXFQ?=
 =?utf-8?B?OGJJTy9kMENzOHlEYit2bVRsTHB4NnZHaUdIUys0OWlBaVpzcVFHRjIvdCs5?=
 =?utf-8?B?SkxzRjRYcERLVHBFTkVoQ1lPbkdMcUxmSzRUZmdMTWQ2WGZPblpYQ29qTlFk?=
 =?utf-8?B?a25LaFdieGdQSklyTmErYnJnc2JIL3hrZ09BWm9CcThUVFBSdXlEL2w1R1lt?=
 =?utf-8?B?L1FjQmJYYkVkMExwczRhSEtQcDJINmxQYmJrbjlaRzMrWTZSelk4S3dIWUtP?=
 =?utf-8?B?Q1ZRYmdGd01UWjMvNDFhdndmandFV0pORXByakp4T1B6SThBRjdrWkk2RXFZ?=
 =?utf-8?B?TGFMdlYycVpuS1hjcWYxMDdONWN4NlJxZ3pMenFkNjhGd2d1c1EwZzRjREZ2?=
 =?utf-8?B?c2lld1Z5Z1BMVlZpN01zTjJGS0NUYXJZeDk2dU1QWkx4RGlMNlR2bU5saUcx?=
 =?utf-8?B?NFRXTTFsSWZEQUJyUHpVclBWTVJMbmxFQnErVlhiWU9sSjVLa1VXWUJ5am9Q?=
 =?utf-8?B?ZUVRcTVtdmVCSkxVVTY0dmNrT0NHcmNHQWNLNXIvN09tSS9jaTRZS0lwZ1Nv?=
 =?utf-8?B?ZHhCbG5YNTg1dzFvNUNyVjJtcjk0bHRrK2IyQkx1YXBUMjVFbll0THBRQ05z?=
 =?utf-8?B?T0w1Q3NuemFlSVlMQ0g0OURndDhQVlNrR05XZmhaSDZ1MVU4OFdGcGF4NCs4?=
 =?utf-8?B?LzJ0eVlYVHdqcGt6T1N5RGNIZFdwK0x6cHNSdzgzOHFEQ0g0bUxzdlR0VHZn?=
 =?utf-8?B?SXVnYWIyUDdiODAxS2FRd3lteHpNQXEvWTFlTEl6eGJVVENPUllacitlVzFC?=
 =?utf-8?Q?RzQNiclPv7ErVb7M=3D?=
X-Exchange-RoutingPolicyChecked:
	BW37QG5Tnn4VCBe2oWifV3e6fRgaQ+aZmXPKV9s6tkhh14Psg8CVfjkOBQFpW+KswHhCNJT4KVtXmOWM0BrfV8dDdjt6ZXNP3FHmDoCanMcWUYN5OeMszR1w5R17u+7GI0BA5cydWMtUYxCJ1L05OaOwUvFE5TKedmdkeDGqYR16aPybc6oZjEmoKTyI4OmWsA47Je0/iF+PgqtcteEoh1yOwxvfYQ+Ogu1lfQ7J11s3V4elPcJ/tgee+5pFNHwmUyQMBsfPv51eISgtCHrQwFGR5xD34mXs/L97wNOfHZX+e6tzT2p/shQSlSxi+xEmGcSj1tLlw5rhavm4q7EaZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4JkB9IZzPUMmyEz9H8bZUjEkKpNr4notuoKlpTjopTLWOy5Y21ADxTTpWFRzEbr9Tiv9defTd8vWVVyI7evenMejV9QCqlc4FcuPWDP4mzACug5YCg5h50c9s5iQHcPLlMImQgiwLaehteIz9osVIVX5q4MaYIk4Cl/IH3IqWhRKCl8PMc0+EsHipk4GlCje4YWY6V6FtoBo5nbLc5GxdL5RNKys88W+AqY7mUxNggvVXfbtqUBsXmWIRHYZs6SM17+ZmZ7XUfNF/5uWqKMV6rExGRlEc3gCT6WeG7+H93XXbvMLhRKmYOCpgeSWd0+KPTAT31g/77ZQ8xxeC/KUmJWUZHbWxdNv0HHTne9VUy3yWINdfVAqXXVf7K5+80w2oGibHSFdG2B80n7lcXOsx0vPdakfHy/Ig5nISuwdpl7LMbdQxg7VSKl+QiVI6EAwjdPBGtoU5ocEd7mCtWmI/JiYX4PRoahuA2AWgzTgYXSvSZS1g6rSAzhN15FHs/oygRGvZn+Y2piy26AyYziD2HarClKPGN79tw61Qml0uw2m9KRDH82XD89qIii7V8mQ97q9CInVtqcehChBVkVVmPffmfX/cfT6CX7cal83Nio=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db33f12c-ecbe-4e2f-8ff0-08df0a8c2141
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 13:55:08.0855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YiyUotwGYdowIXic1+EkYyIg9kKey0/RTzb+yff05IfiCARWZoWYi2OgHjnLmBWInMoJiC7lEod5oBJveFII6ABvszJwES0GkE54mgLZjx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-04_04,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609040126
X-Authority-Analysis: v=2.4 cv=G7os1dk5 c=1 sm=1 tr=0 ts=6a9acdc4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=-KPE9EdA2efxtz8c7rQA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDEyNiBTYWx0ZWRfXwTwGBkmHs7AH
 FwORIjWl1xvcxXiatx+vw+ep4S5waA4ItAW+pjcTirW41znv4GUBt4mbZcFKlU6b4Q0sLDM7Ncb
 bTafokVaxrr9e7qJL2wm34Tmvyoud47E1MT6EmBqjxFutHhvnDjz
X-Proofpoint-GUID: DetbZGSJUcQYxccKv7s1lybOC7yx-bZP
X-Proofpoint-ORIG-GUID: DetbZGSJUcQYxccKv7s1lybOC7yx-bZP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDEyNiBTYWx0ZWRfXzVKQ3iBXhLAC
 U3N/XBhtbldyuBqPKatTwvRmu5vk0DyQSxJy985CzEtHK+dBbHLaxqlPXX5aTIJSCahmNR5Tmr0
 7ZB1y2/PhZmNkEXRFQnW2V4QrFvveBxu7VfAV/xE7kd7vIITnBl5ZSODaoyrZPgY98FW+jn7qYI
 H2oV5R/Tlj1rMoFbZrCJdkgai7dYAoHBYxnAIWM1kF2yKz1AYzGVCmLwSH5shHhuUe75OF0nR9u
 hVgyf4HfvC2HyjxT8kKlu0OrZhN5P6hRcCWzssqHyYtu7F9bJmKyx4u/zsHFnsvGFp+P2xmLfH6
 o6FMPT9+OROEbcJGdTfRkcwQiOEBvaSHo9EIP9u4vP5P+r+OYkV7paA4sWYnuI8lnY1+VNDAIwG
 M/iPkN4IUQeM2VqySZXoOvyVwjh8y8Ax63GZRnrHO0WRSz/NdfE=

On 9/2/26 12:40 PM, Brian Foster wrote:
> Rework xfs_alloc_min_freelist() to return an (optional) max value
> along with the historical min freelist value. The max value
> includes an extra level in the btree based calculation to account
> for btree splits in the first allocation of a multi-alloc sequence.
> 
> This value reflects the worst case AGFL requirement that can be
> expected across multiple allocations within a single AG and single
> transaction. For example, consider the case of allocating an inode
> chunk and then an inobt block on inode record insertion.
> 
> While here, rename the need variable in xfs_alloc_fix_freelist() for
> clarity with upcoming changes.
> 
> Note that no callers calculate the max AGFL value as of yet. No
> functional changes in this patch.
> 
> Assisted-by: LLM
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_alloc.c  | 35 ++++++++++++++++++++++-------------
>   fs/xfs/libxfs/xfs_alloc.h  |  4 ++--
>   fs/xfs/libxfs/xfs_bmap.c   |  5 +++--
>   fs/xfs/libxfs/xfs_ialloc.c |  4 +++-
>   4 files changed, 30 insertions(+), 18 deletions(-)
> 
looks good

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
