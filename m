Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F6B19EEDB
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 22:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720738706; cv=fail; b=XcTjNfmT4nWsmtQo3wJBUsEXWUcTWjC3si/tDlV7khH162p27Rz36UaaxgNm6Z0r2n8270iKMgI/4KuAFXUAQxdXyklDAk09gcEMQThFyd/5O1nClP1rO9EKMTeBmnoKfBSaK/VoHDVh1RucRoraYG9G4rr3EdvmQlooxU/W2/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720738706; c=relaxed/simple;
	bh=ZiZhEr6y8JJArluD39uU0kVswN00puGtMWz8t7TFY3U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fu6/W3oj6raxEKLcTjQH97I3mQgaTNA29Fc0ZqW0gpNOvOLopBSCisUzDfolfdaUANZQu2Pcu/Qbl6Sd0QtD3c6KCrGxNyvR7Etoto/oNrXWELfk+LQrwm1935M1Pe6TIJFm8YVdxSW84OmdR3t9ObeeUTYPOZsEsPQH1RzMPrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B80Oj9xk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LcvqQbtS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B80Oj9xk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LcvqQbtS"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BKXUEV028221;
	Thu, 11 Jul 2024 22:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=ZiZhEr6y8JJArluD39uU0kVswN00puGtMWz8t7TFY
	3U=; b=B80Oj9xkcJe4a0vQlrvs61SDaSyit5IiJb0n7qG/IaESl+VwcvMMR+35B
	naNmw8qb8WKtqiGzYVGiMcnsGiT6B90ZyFCGy81+UBhwvn0btfJG7YA1tQU11x2g
	ctCvCl9bCyRrXN8tE9F6n+7TO0FE4AZ0xcf/IlZAsqfUrnwTplsSnUUoqjm7DwaY
	lIewCmzpE+S1P0rmaXOGsOAh4dkbwylyy52bIFpFBBLCRAeshT+nylLteBW1PwOw
	UYRFCvumSPAXm0zeWYo8ihR6CvGOTjNbvR3IjHbOXMtWu53HPzHuPOW9SwVVcPmM
	DYuQkzD3Cf5r01kOBfANSonQSwSLg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wkntp74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 22:58:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46BMAIMo028868;
	Thu, 11 Jul 2024 22:58:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2046.outbound.protection.outlook.com [104.47.55.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vv5mthk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 22:58:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vqvi92rc++GwQy2n8eKlcv3WqL+imVppM/il8mULUUDto2qbBCZCJKuLpNu80JLwRoUtJmNfFmVoa9rnZ34K+MAVqgyObRF4qfcVXVmUKQ0wVbsaruJhvgOfogbSLWxrn/IdHob0xfsrBQHU87Ggy/pihvV43U9sgFjku6MbCYPH1AYfHZYEWPftXA0z+PJrvSr7FtNMw5yfOm2KUQ10gv0LMFiQLmvv308lEPt4EJAfTbSziLdo0b2VnGdZDnZHm8mykFLtqAexRY88exU4lzXo/vpvLLgehI4uOHb266dbb5MP6aVVPK6vBnc/UK6wu3ZMJ989FZnSGk16dyULtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiZhEr6y8JJArluD39uU0kVswN00puGtMWz8t7TFY3U=;
 b=WUxon35z/By0kxVMJWGB2ffoM2Q4i1elsHEYOZlJW/Deg3DBRNFIU6MZDpb72XZaNNil9Sl4ytDVr2woYaeWFT7Yqx9ITSkuZ9w3X/wdTP4CUbaDtFa00llKnvbk+z77LfD+O+3Ftg7zITc/92dANM1sXG20pbMPoru4b4d2/YjdyWWQpBjn4cFAgaMbZrPDiHYjJAPlYgmeKwiqBwRWnPiJIinMYRT0/eGNkxfADnh0oB+56znQuV7sOPXAIGd0HI6Or3Qt2hwLbsMtHwS1YVW3iMSjuc7IdfAvVnaG4m0fSjd6tCjycZ864Hu2IbRzmHhlN6ATwEVFj479abpFbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiZhEr6y8JJArluD39uU0kVswN00puGtMWz8t7TFY3U=;
 b=LcvqQbtSeRU6q4tREAjfqpK2UofflSJ0h2UxbcpXUFAf9PgYdzkj+CnxRjDDzh2tBec8mg1NbQNs8XOeswCYIuIzKwhjFfQrcKSrsmpy7pGVgtSDXU6wNWUwATZi9x5YWu8WFsx4tgPEbD9MLfnY3Nyr4jsXG7/LCPdGbkJfPBo=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Thu, 11 Jul
 2024 22:58:02 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%6]) with mapi id 15.20.7762.016; Thu, 11 Jul 2024
 22:58:02 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/9] spaceman/defrag: ctrl-c handler
Thread-Topic: [PATCH 4/9] spaceman/defrag: ctrl-c handler
Thread-Index: AQHa0jOtCDSXY2lnIkeRvGgwFfxoT7Hu4+AAgANDO4A=
Date: Thu, 11 Jul 2024 22:58:02 +0000
Message-ID: <5A606248-86EB-406B-B9D8-68B7F06453B2@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-5-wen.gang.wang@oracle.com>
 <20240709210826.GX612460@frogsfrogsfrogs>
In-Reply-To: <20240709210826.GX612460@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|IA0PR10MB7255:EE_
x-ms-office365-filtering-correlation-id: 7eeb180f-a1f8-4f45-3886-08dca1fceaff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?TzQ1bTA1R2M5T0JBR2xZQUszVEx1Qy8xbUdDckgya0xSaU1qRjJpSnBZcnE2?=
 =?utf-8?B?MHB6M0ZDVS9PLzZ6aTFiL2JxazRSMytuUVUrcy9kYzJHcVJHYkxwcDQ0QmlF?=
 =?utf-8?B?Rkxxa09rNVBXL0JkUkZiQkVGRXEvZDFSbS93R2diandkc25LeVVabEYzUHhU?=
 =?utf-8?B?dnlRSnk2cnRzbkN5T25YQXYzUWw0MmgyYlRNcGhtM0ZCZnNNL2JnVVc2ZW9B?=
 =?utf-8?B?bmJCYVNrT2tIMHZydEszYXlXcm9QeUxIdkJTMmdpRUZFczlKenlJY1FUai9n?=
 =?utf-8?B?TlE5Ym0rOFEzWktnYUQwT1M1WHRTMmZ2WXJVYURQSkRobld2ZmpTcnZDdmt0?=
 =?utf-8?B?NnB4K0hNeDh2b2MxRzdRUHdIZUJLbGdDdWZRY1hia3o0cGNheHhqWmx1Q3Y0?=
 =?utf-8?B?ZEtFVUZybnl2clg1QlVVZDJxMmI5OVpycUg4VkZ0Z3o5YmJYakRJeFg5ZWM3?=
 =?utf-8?B?MkpSTkRYUFZLS3gxczdGUzM1L3AwdmdZNjVxeWRrOHRPL2NDU0V3c0xrNzI1?=
 =?utf-8?B?b2JSSGtONWxEUG1yTERBYS8veGk1Qy9wbkxRcEZnSUxXQ3JENTR5clFEbUhq?=
 =?utf-8?B?YmRoa2k5eXJtbUJ2WGhybmtkTEwwbDROSWNXMkpQUFZuRllySkFjUFlxanpE?=
 =?utf-8?B?MzZtck1HK1pwN1JLdloydjF3NGd3MDRUdC9zeHRPVkZqZUcxTWk4Vm1hcmUz?=
 =?utf-8?B?bDVaa3huZkpsQmdhRW1McllTWSsrTmNrbmNxRnZ5ZzNQVVdjelA0V2VtKy9T?=
 =?utf-8?B?eWkrQ0xKV3EybWhyTEVFbWV5ZFYyenFWOTVDc0FrQlNybXhKNXpmUjhmRnlR?=
 =?utf-8?B?a1lXbGVGam1JSEdobkVxZUVlQ1VnNjhrZW90eTdVRmQ2dHU2MU1pczVEeTNs?=
 =?utf-8?B?ZjM1Z0dYYWJreURRYnBtVUJKOEpuY3VsUHF3UUhjSVVMZHlvUXBQQWxydEc5?=
 =?utf-8?B?UXJsVTlNV3RQQkk5QnVGS1k1OVVwSDhMalRGM2dSeVVhQXdmRDdWbll4ZUNq?=
 =?utf-8?B?NW94RzNrUXNnY0UveXBTV0FOMUZpU284RGVwbmVVYm9MSThVRUZOZ1VETVJr?=
 =?utf-8?B?cTl5czJPeFJUM2NQeHlTTElicWhhTGRPVlpWaysvNmd2OStHUmMzNVF2VDN6?=
 =?utf-8?B?UkZ2WUVVeEhYRUNGL09IeHVjN08rR040TjZIUWJ4dndaNE1RMVpSRDg3S0Nj?=
 =?utf-8?B?WjZYalA3S0dZNy82Vi9GYll6TENjVHMzMTZ6WGJjSEczbStvN3ovOVdITndm?=
 =?utf-8?B?d1FEbVpnVlBkbjFaU3VMWHRNb1hubWNtL0RlcDQ5eHZjM20vWkxrait2aHZ5?=
 =?utf-8?B?QllnMmFPR2JzOWNFU21uekplQVkyWXVwbmZBU2N6bGl1dVZndEdHNUJCUDUz?=
 =?utf-8?B?S0sxSzdiSjJOcVVDeXYrcXpWMUlLVENZeGNlbklWclBrTFFWdlM3ZlRudUFr?=
 =?utf-8?B?NTRsRWk1Qisya0Y2dVFmWHhUa1Bzb3FhSjhLcE1sa1NkcGYxVWQ0ZHY4Skp4?=
 =?utf-8?B?aXhSUmZKNzZlc3VhUjlKMWpkeWlNcjVDS3Jva3lPQmNGcXY0RzkzSG5kYXBG?=
 =?utf-8?B?ZnY1MWFCQVdYOVZLYVdwSU0yMTRBL1RtMjZ2Nm9JcjBxNnB0ZnVJTFJFcWNj?=
 =?utf-8?B?NU5BUmM4Zkg1U1I2Z2Y2U2xFcFpmalJEUFVPRGUweEZwTUdNRU5ZU21SWDV4?=
 =?utf-8?B?QU1vQ3NVMk9XYUNSQzEwWEpTZEpkdXlhcmdCZWZ1dUVLUmtqS29GZzBGZURm?=
 =?utf-8?B?QXdKTzFidVZwK2RNYnNuaGx2YkhxblQvOUtxUGlHdW9WUmVrZUdQTFdMaEpx?=
 =?utf-8?B?elZORFVSUGQ1bmNtTFlOci9KRkdodDViRmhjVkpMdDBWb1VlWXZjZlJoQXJP?=
 =?utf-8?B?ZFgrK0lpYk1MK2x2a3A5cFFrMUxlUmR6SFhFTEJ3WHRiZEE9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?RWovU29wREtibiszQXc3bVZFNi9Oa3FaaUcrcVJnU2ppQWF2MkRpOGVNTFRF?=
 =?utf-8?B?ZFZRbnNmUHpXZ1VUaDdJdVJVaXg5QjFxa2xsaFhRSU0xU0xlT0ZCVFRxN1JU?=
 =?utf-8?B?ellRa2E4NFFlNVpqTmFUQmZSaG9CWFBnTG5YK2dUOXlMbXE2WkdBMG51Ujdt?=
 =?utf-8?B?eFZublNub2N5UjBlUTNxTUpEZHp0V3owT2FHNk53aEc2MHcvWitNeHBVVkw5?=
 =?utf-8?B?eHZoNlJ6d2taVlBZL3lXc3dWVlZ5SWw5RVNFd3BFRHFBT2taaG9xUG9SUUtm?=
 =?utf-8?B?Qlc0bHJhQ1dzWGZOSVZ3UW5IamIxVkZqVW5uU3lOZ0tPQnRCbTFwOVNwOFMv?=
 =?utf-8?B?c2o3dGdVZ21KTzNsWE1uQnc5MDZDTUZCME5pZjVBNVlBblhUM3I5UWJxU3cx?=
 =?utf-8?B?bnJva3I2aTUyaUx1K1lqT2QwR2VqVTlybGFCK1E3UU1xZ2pVWVRYZ3dEL01o?=
 =?utf-8?B?TGtSSXBGdmhJUGpLZXpVR0hQNkE5akN4VnhNWERzcFg2cVVGS09NOUQ5MXVW?=
 =?utf-8?B?TGpaWnVtYm1UemdudHRyR1lOM2F0dU1iZU1xNmRQZWJtaE1OWUZaTHRhMDg3?=
 =?utf-8?B?TFRpN2JrWGJxdGNQS1E1LzhvcVdEbHRyeFRZL25kMnBINWt1M0krR1FmNzl5?=
 =?utf-8?B?MlVqUUwyZTRvTzhOY1I0TDhkRUdhUUw0dFEzcFBkNytTZkNzRjJxSnlJZGFq?=
 =?utf-8?B?UllCREJCK3g0clhzOS8yYjM4Qm9RM21yTFovNFg4VDdzUmFHLzBibzlvZFlL?=
 =?utf-8?B?VmdpQUtHdjhqMmYvS2hWK2JRbnhpVjVFM09CYWNsclRlemlYejBxdGkwS0NI?=
 =?utf-8?B?NGpBckM0Sy82RmZ4ckttSllQakNJYmdXTDV1MUU4UDZKOWEyMlBEN2VDMlpo?=
 =?utf-8?B?S3BFbzltS1lqdGVzdCtEU3NHN3luSCtSbE1iclZVc2ZPVnhUN1czSG1jT2dS?=
 =?utf-8?B?VHZpMDZ0UWdlQ1p4NEVBR1lWdERZR2grTnU0UzVhNW9pNjM1RTJhckNVTVhy?=
 =?utf-8?B?Vy9jSzdGWVRoZitqNVVlSjJiTVF4R1pzNFgvQVhhZEh1cXN3RWFKaElhQmN2?=
 =?utf-8?B?QXVjL3NwVDJqaGQweUZESzl6Y3ZTalQrMlJoYi9wZmM5RDdBR2dJd0dGSGJl?=
 =?utf-8?B?bHdKTlAxNUFWUVNZQ1BnTjI1cUdNQlZBRlVRbVdlSTk2NGdHak1RZStITytB?=
 =?utf-8?B?Q2cyVXBmd1JLVUtaTkNnQmZXeVFUbDB1TTBsVzJScFNWbm05VzMrWW9tZzRa?=
 =?utf-8?B?OE5XTjR2aVA3dVkzYnhodTNMeTQ0NEV1WlNWTXRzcytTOUZheEFESEdMeDQ4?=
 =?utf-8?B?ZEtPS0JQUUZkSVR5RzRWbExlajZRcEZveWlCRlhNQmN3SUtwWVplYXhaS2ox?=
 =?utf-8?B?ZXQ3L2F3NGxhbW5sMzl5bllwemM4MkZtQ0RuSkFpTUJlbGZwNzhpcTM5b3dS?=
 =?utf-8?B?MVM3T1ppNEtIZjIrL1hDUm5ZdjhLaGgrS0Y0bnVoelhUWWJ3bllteVlQSFNG?=
 =?utf-8?B?RC9yZjZhT051YVd1bVEvVDd3UElRaXUyQURRTWJQTzZsYXg0SDZHeWJMSUM1?=
 =?utf-8?B?bU14U01ORG5idVhNdVpmZGdwYXgrdVZzM3JSOWpGendXdFowcDhiMFFUV1RK?=
 =?utf-8?B?OUI1dTN2ejdDWGo1SjBGNU9DelpVMTdISUd1aWZUZGhMdFVITDJXcnJHMEdP?=
 =?utf-8?B?aGlNNmRsbElkQU10R2Q1eUlpbHRma2pyZXkvVGQrZGlpcXUweDdiQWlOWE4w?=
 =?utf-8?B?NVBTWnlwU0EwUXJpVXJ0d1djM3NkQUN0anpadnVWODRLUkxtSzU5MGF4Z0Vo?=
 =?utf-8?B?Uk1LTGZYZ2tvYnRpMUxTaElNMGRvZlA3ZmxUYmU5T1VkR0k2Z0xjWGltQnlT?=
 =?utf-8?B?SmllVmdHbE56Ym8rV0V3SW5OUzBmZ1hleUl2aXZMMUwxWG05YktHa2t4MGgw?=
 =?utf-8?B?U0ZvYjZMM3NVMDBtZGdnZ1k3eGRML0NFaCthQWxtQkRjdlg1YWxJU0d2V3U3?=
 =?utf-8?B?eEM0VTY0UHYzVUVXbWxtZFd5WVNPeWpkUjFiMFVZOFI0M0ZTVTRkbnE2RUJP?=
 =?utf-8?B?czMwd0VBaU5RS0poSkV1eDQ5dmxEVUdmYVBMWjVXc2VHUkoreHRqOTE1alBJ?=
 =?utf-8?B?RkpPVVd3c2NtU3FWUzhYNlFKbDVTb2RMWlBVU3F3U1hBSmY4TE5nQi9hUFVX?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D1CF64FEF473D42AA3ABA7B302AD03C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	DZYwKJK7MEWjZS5heFZl5x/owaSHVxBNNUUfAdN88/TbAhYhIgSspqkg/Gaut+fAjiYfwwwGJ/zYY6ESb4wPlRq36cHpXQqzSPMtAS8Y9xRbwx/JnrxHMgHDfxMfXQAmJeWp0EGkbEcr42qp3114QPTAo1TQZmaoSC5D3kOc6Sce8zOQZQlMHaxFRimN6mAA6rpQVUoSrpxQTb3mHDONsPv0Mn8BDQlcqUteBUPMAxZAw67JInkmENy6KF9P66RezPEWZj1y58Kl9wvB2vuy/xXSZ3cIa/Cl6ygWEjKJNUaLx96NxVVRPX8qssmP3TkAL7ULNPLOpRzYDhngTP9DF9GI9aPJgR4wD7uLz6Qmefc9OFNTglXqb8nkQrVRrhfV/z2mvfApQcklhkYXbFo+xDwcl+JNTGGGaAFSXDItwLgJxPw/YK7I38oYrCBapxyt8s5944iugJ8Ws1XqB81+bqJa73Xrhv5OQlVcI7mdqQkdhH72iUUmND9TD0gjprOG8Xk7yY3F3f62iZ0Oydwi9La7Ar5zzTQpIp0TAgNSQ0utjDVmMFa+ZLWHX8pZhvJTJKYegTYFolooHCRUbDPDR/jIpAdoYT5ykS3lR8iKEgQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eeb180f-a1f8-4f45-3886-08dca1fceaff
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 22:58:02.5828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vF2eVG/ffkZmMw++LoBF5/5I8LrmzwPOLZnagzcpxeNF32n9NSVDnW4UotlwJ7xIKkOxLNoDLlN+rh5Hh/7vai7AOrmzm0C2hLkZkWmOsEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_17,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110163
X-Proofpoint-GUID: Lk1IO4Z16nZxKHWk4-3wYwQluP_pZK1C
X-Proofpoint-ORIG-GUID: Lk1IO4Z16nZxKHWk4-3wYwQluP_pZK1C

DQoNCj4gT24gSnVsIDksIDIwMjQsIGF0IDI6MDjigK9QTSwgRGFycmljayBKLiBXb25nIDxkandv
bmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyM1BNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBBZGQgdGhpcyBoYW5kbGVyIHRv
IGJyZWFrIHRoZSBkZWZyYWcgYmV0dGVyLCBzbyBpdCBoYXMNCj4+IDEuIHRoZSBzdGF0cyByZXBv
cnRpbmcNCj4+IDIuIHJlbW92ZSB0aGUgdGVtcG9yYXJ5IGZpbGUNCj4+IA0KPj4gU2lnbmVkLW9m
Zi1ieTogV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5nQG9yYWNsZS5jb20+DQo+PiAtLS0NCj4+
IHNwYWNlbWFuL2RlZnJhZy5jIHwgMTEgKysrKysrKysrKy0NCj4+IDEgZmlsZSBjaGFuZ2VkLCAx
MCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9zcGFj
ZW1hbi9kZWZyYWcuYyBiL3NwYWNlbWFuL2RlZnJhZy5jDQo+PiBpbmRleCA5ZjExZTM2Yi4uNjFl
NDdhNDMgMTAwNjQ0DQo+PiAtLS0gYS9zcGFjZW1hbi9kZWZyYWcuYw0KPj4gKysrIGIvc3BhY2Vt
YW4vZGVmcmFnLmMNCj4+IEBAIC0yOTcsNiArMjk3LDEzIEBAIGdldF90aW1lX2RlbHRhX3VzKHN0
cnVjdCB0aW1ldmFsICpwcmVfdGltZSwgc3RydWN0IHRpbWV2YWwgKmN1cl90aW1lKQ0KPj4gcmV0
dXJuIHVzOw0KPj4gfQ0KPj4gDQo+PiArc3RhdGljIHZvbGF0aWxlIGJvb2wgdXNlZEtpbGxlZCA9
IGZhbHNlOw0KPj4gK3ZvaWQgZGVmcmFnX3NpZ2ludF9oYW5kbGVyKGludCBkdW1teSkNCj4+ICt7
DQo+PiArIHVzZWRLaWxsZWQgPSB0cnVlOw0KPiANCj4gTm90IHN1cmUgd2h5IHNvbWUgb2YgdGhl
c2UgdmFyaWFibGVzIGFyZSBjYW1lbENhc2UgYW5kIG90aGVycyBub3QuDQo+IE9yIHdoeSB0aGlz
IGdsb2JhbCB2YXJpYWJsZSBkb2Vzbid0IGhhdmUgYSBnXyBwcmVmaXggbGlrZSB0aGUgb3RoZXJz
Pw0KPiANCg0KWWVwLCB3aWxsIGNoYW5nZSBpdCB0byBnX3VzZXJfa2lsbGVkLg0KDQo+PiArIHBy
aW50ZigiUGxlYXNlIHdhaXQgdW50aWwgY3VycmVudCBzZWdtZW50IGlzIGRlZnJhZ21lbnRlZFxu
Iik7DQo+IA0KPiBJcyBpdCBhY3R1YWxseSBzYWZlIHRvIGNhbGwgcHJpbnRmIGZyb20gYSBzaWdu
YWwgaGFuZGxlcj8gIEhhbmRsZXJzIG11c3QNCj4gYmUgdmVyeSBjYXJlZnVsIGFib3V0IHdoYXQg
dGhleSBjYWxsIC0tIHJlZ3JlU1NIaW9uIHdhcyBhIHJlc3VsdCBvZg0KPiBvcGVuc3NoIG5vdCBn
ZXR0aW5nIHRoaXMgcmlnaHQuDQo+IA0KPiAoR3JhbnRlZCBzcGFjZW1hbiBpc24ndCBhcyBjcml0
aWNhbC4uLikNCj4gDQoNCkFzIHRoZSBpb2N0bCBvZiBVTlNIQVJFIHRha2VzIHRpbWUsIHNvIHRo
ZSBwcm9jZXNzIHdvdWxkIHJlYWxseSBzdG9wIGEgd2hpbGUNCkFmdGVyIHVzZXLigJlzIGtpbC4g
VGhlIG1lc3NhZ2UgaXMgdXNlZCBhcyBhIHF1aWNrIHJlc3BvbnNlIHRvIHVzZXIuIEl04oCZcyBu
b3QgYWN0dWFsbHkNCkhhcyBhbnkgZnVuY3Rpb25hbGl0eS4gSWYgaXTigJlzIG5vdCBzYWZlLCB3
ZSBjYW4gcmVtb3ZlIHRoZSBtZXNzYWdlLg0KDQoNCj4gQWxzbyB3b3VsZCB5b3UgcmF0aGVyIFNJ
R0lOVCBtZXJlbHkgdGVybWluYXRlIHRoZSBzcGFjZW1hbiBwcm9jZXNzPyAgSQ0KPiB0aGluayB0
aGUgZmlsZSBsb2NrcyBkcm9wIG9uIHRlcm1pbmF0aW9uLCByaWdodD8NCg0KQW5vdGhlciBwdXJw
b3NlIG9mIHRoZSBoYW5kbGVyIGlzIHRoYXQgSSB3YW50IHRvIHNob3cgdGhlIHN0YXRzIGxpa2Ug
YmVsb3cgZXZlbiBwcm9jZXNzIGlzIGtpbGxlZDoNCg0KUHJlLWRlZnJhZyA1NDY5OSBleHRlbnRz
IGRldGVjdGVkLCAwIGFyZSAidW53cml0dGVuIiwwIGFyZSAic2hhcmVkIg0KVHJpZWQgdG8gZGVm
cmFnbWVudCA1NDY5NyBleHRlbnRzICg5Mzk1MTE4MDggYnl0ZXMpIGluIDU3IHNlZ21lbnRzDQpU
aW1lIHN0YXRzKG1zKTogbWF4IGNsb25lOiAzMywgbWF4IHVuc2hhcmU6IDIyNTQsIG1heCBwdW5j
aF9ob2xlOiAyODYNClBvc3QtZGVmcmFnIDEyNjE3IGV4dGVudHMgZGV0ZWN0ZWQNCg0KVGhhbmtz
LA0KV2luZ2luZw0KDQo+IA0KPiAtLUQNCj4gDQo+PiArfTsNCj4+ICsNCj4+IC8qDQo+PiAgKiBk
ZWZyYWdtZW50IGEgZmlsZQ0KPj4gICogcmV0dXJuIDAgaWYgc3VjY2Vzc2Z1bGx5IGRvbmUsIDEg
b3RoZXJ3aXNlDQo+PiBAQCAtMzQ1LDYgKzM1Miw4IEBAIGRlZnJhZ194ZnNfZGVmcmFnKGNoYXIg
KmZpbGVfcGF0aCkgew0KPj4gZ290byBvdXQ7DQo+PiB9DQo+PiANCj4+ICsgc2lnbmFsKFNJR0lO
VCwgZGVmcmFnX3NpZ2ludF9oYW5kbGVyKTsNCj4+ICsNCj4+IGRvIHsNCj4+IHN0cnVjdCB0aW1l
dmFsIHRfY2xvbmUsIHRfdW5zaGFyZSwgdF9wdW5jaF9ob2xlOw0KPj4gc3RydWN0IGRlZnJhZ19z
ZWdtZW50IHNlZ21lbnQ7DQo+PiBAQCAtNDM0LDcgKzQ0Myw3IEBAIGRlZnJhZ194ZnNfZGVmcmFn
KGNoYXIgKmZpbGVfcGF0aCkgew0KPj4gaWYgKHRpbWVfZGVsdGEgPiBtYXhfcHVuY2hfdXMpDQo+
PiBtYXhfcHVuY2hfdXMgPSB0aW1lX2RlbHRhOw0KPj4gDQo+PiAtIGlmIChzdG9wKQ0KPj4gKyBp
ZiAoc3RvcCB8fCB1c2VkS2lsbGVkKQ0KPj4gYnJlYWs7DQo+PiB9IHdoaWxlICh0cnVlKTsNCj4+
IG91dDoNCj4+IC0tIA0KPj4gMi4zOS4zIChBcHBsZSBHaXQtMTQ2KQ0KDQoNCg==
