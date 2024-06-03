Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CB3137756
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 17:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435428; cv=fail; b=gMcDgFP2RQB2lRdhruiecIjL2LBh35E5pDUGPRWagEb27OLgoYx3HkkyKO8CF2WG7CEd5oH3waZJ/5lQT+W3sM6wbEkkGYPLb1apwyHEXJEDw+XefX2B8QQLKeirLgiNXJMSOOZFHMZ0zFDiLtjd/7x+AT8DK1cp4u+WquXO6Kw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435428; c=relaxed/simple;
	bh=77GdQ6/71eEq3CHXu0c3pKQ73q1GRid+KRg+48JO/Tw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E6TWwy+n/eq6Endm+3ARqTXY/F73peS6JGZHaLP/aqGNdhd2ikh89VlJDA4NHgm6nF6TMYrN0njaN2uCZaU9/o8xmyzgSRL45gFhTeLmh1WksheMhIQjt2u1H0OlPWlA+Ga0+rXnLm0CrYhevGpztJTCwMJfZTkAS9Xqc/xx79g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453CATvb016033;
	Mon, 3 Jun 2024 17:23:44 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3D77GdQ6/71eEq3CHXu0c3pKQ73q1GRid+KRg+48?=
 =?UTF-8?Q?JO/Tw=3D;_b=3DlQwChl5f8d01R+pl+8aK/8taNA0jXChmyy2Wuo3gyGuB67y/3?=
 =?UTF-8?Q?gKzNP51QEm1RkLMJNma_c6q7A7+SFMobGRuZaR+zyGiZPjEMdWL2HSxkG17J7Pc?=
 =?UTF-8?Q?vdLxxHlqGj4sBLKrbmrcC9nYx_kUzicz41l6aTQom0KdMbS2veyQiS2YXAxCsRi?=
 =?UTF-8?Q?+1qLLO37MQyoIHb0X8lEuhisxK8cn8l_8EeDw4o3xMfJz8hI+LHGBEYy/d0OcVY?=
 =?UTF-8?Q?6ZSmXdFFz1Zrv2JXekyVEhLioCayggbOF/joo_1Emw1lIzVdgOIdfqsgi5k5eZf?=
 =?UTF-8?Q?9mimHzf9FFkOoomLhFUyFolmVj0kVcoqdAKdRiDgMu0_9w=3D=3D_?=
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv05bc5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 17:23:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 453GnjYL023933;
	Mon, 3 Jun 2024 17:23:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2048.outbound.protection.outlook.com [104.47.51.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrqvr4w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 17:23:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQa/QXHJwg4DutyWRfi2ipeImupsmGdbgKtTXGSZoJdTv9HCANxeDEkVvGl2Dz83NGyG7fkTpHGbS/fZJvUlBrxyKfJjD+vvijDzhSaM2PBf8wJCrVkxSK2rX8Eyv5fpMUq9a4Zlcb4T040FJvirbeikSI6AOorMU1hmBFB0rbaFcdrl+BujOnLwzJvVX8Ec16ySDpuOw6QXrZx6SfxP8r/xjX0ciw56TrhpCQMXuY4v45jSwdKxsu8z/pD2m2KZtpwdfRFqOlj0sNBIUXGk7XEBE5nmaTzwnQYeGwd6tU51IOIelIlhWozeHe4aeIx5hlGecMiqBkiUrFnNRBCYSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77GdQ6/71eEq3CHXu0c3pKQ73q1GRid+KRg+48JO/Tw=;
 b=nHIum3/m+bKxXGB19WU+M3FN4yCyP8yjnjufy9keBtzMagZ8lUtp5oI4ojJof3z2MoY5Pr6KWtODTC1rngrWHTD5Egnpt7tDdFH601GiZxu4e0scw7vBKhGH9gzCWr6s4kYrrTlUXFP+bQB4LvmbSppxLJZ+uANMbwkPMnYv30CdYkY0DvuiQNdgop4DZj7OspLyR4fc8PNXTrOoWmPegfnFJ1uTCc6FH/MqX8wBcf9PBBotc66bxiJAoLmUzc2M6ru7MkB/3sehUgKOvk6Ck1KZiJjebg2MIKvKBoSNf3KifSKQlHiV0uuPo51jqkpz1/DOB0G+SNhWNHyTFipuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77GdQ6/71eEq3CHXu0c3pKQ73q1GRid+KRg+48JO/Tw=;
 b=fWdmBF1jZTfEh2ssGqx9MKy/8f9ZKWnEz1wuaX0T5Ek4wbf028JsqEc8/dOzqrxGIJjd+FHseejnxHZC+FIMCVrSae+1urpKHhnGQxwq3nyyNNRmw7vxlmfBo1PFZln7ZfoVl9K3dhHeeEOQxnoM4PN62WiP8M8MWSMOFDdsRZY=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by MW5PR10MB5715.namprd10.prod.outlook.com (2603:10b6:303:19c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.26; Mon, 3 Jun
 2024 17:23:40 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 17:23:40 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make sure sb_fdblocks is non-negative
Thread-Topic: [PATCH] xfs: make sure sb_fdblocks is non-negative
Thread-Index: AQHaozr8E9KmCgD/tEKemp9zonfvu7GRO4qAgAQt0YCAHDMbAIADqKsAgAEp6gA=
Date: Mon, 3 Jun 2024 17:23:40 +0000
Message-ID: <39E20DD5-EDB2-4239-B6EE-237B228845F5@oracle.com>
References: <20240511003426.13858-1-wen.gang.wang@oracle.com>
 <Zj7HLZ5Mp5SjhvrH@dread.disaster.area>
 <AEBF87C7-89D5-47B7-A01E-B5C165D56D8C@oracle.com>
 <A9F20047-4AD8-419F-9386-26C4ED281E29@oracle.com>
 <Zl0CKi9d34ci0fEh@dread.disaster.area>
In-Reply-To: <Zl0CKi9d34ci0fEh@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|MW5PR10MB5715:EE_
x-ms-office365-filtering-correlation-id: 9b8474b9-0b2d-4db7-12bc-08dc83f1e94d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?Mnp5KzhxeEZ5R0RuTlhUZ3A5VmRZTHN4aWx2TjJLeldsQlYrMU5mQ00vZFEy?=
 =?utf-8?B?T0FzbC9jL041bUIzTlZlMDFwS2w1M3JJSFdDOWVTcGRydkRWS0M0SWZUM3c0?=
 =?utf-8?B?a01HR2pTRmxBSmZ0WHY3bHM0Rm1rbXV5amw0OThwV0xjUXZSYXZXZUxreng4?=
 =?utf-8?B?Ti82aDN1RFpWeldrUGxxdmxWU1dvVFMrTldGS1hHR0J0UWlqM3lEaUNwT3NL?=
 =?utf-8?B?eGE1OTFBaWxoZjduNXU4YVRHOFFKOG9aVUJUVjArWHVqdmxPdG45aXNTSDFW?=
 =?utf-8?B?UDZKNjMyeFVCWkR6aVEyRFYyWHdVanZ2YzB5c2NiWHlWV1JTdDVnR0VhY2Np?=
 =?utf-8?B?WXBUK0NhcGxWa0YvVUIvUlpKNXZQOUM2WldLVFBCZGtkdTJLby9PK1pFbXR4?=
 =?utf-8?B?YndORnNUN2pDUWVSV3laK3ZzTUlIakZYS2N0bEYvWDdlbUo1ckM4a3ZHYzlX?=
 =?utf-8?B?azEyOFVlcjk5NmdVVEJkeUg5YTZqeWVoZEt6UEdaVkc3SDVnRDYvSUVkVlE5?=
 =?utf-8?B?QkxZYVRrc0VzL1dhYVNOTlhReVI0S2NlTUc3MVJxUEVLVjlUYXRFcHYveTg4?=
 =?utf-8?B?K3B3YXZHUHJDT1MyTk4wLzlvSyszNE1udSt6STlLZFROeDNINS9qSFhUbEp2?=
 =?utf-8?B?WEw1eElGQ2FFOWVKS1hwSlF1UDVNUERORmdBbjVTbyt6bnlWc0F6eG5pUUtO?=
 =?utf-8?B?b0NZcm94dU11bHdvamFDSTZ1Sm8vQ1BjNEZpb2czaEFyQVFGaEdkb2VtMkJv?=
 =?utf-8?B?WHIxekl0d1pYNEZEaitpV1VUckk0OTBaU2s5WS9VK3dVQmVWK2pVSm9OejZs?=
 =?utf-8?B?c3I0SG4zV1hDSUlYcXFTUVJKRHdPNWtna3NMSVJWMCt2WUlxNXJjazNIYTVl?=
 =?utf-8?B?MGdkak5NdVlreGlkVWVqbXlyQXVJSFlZdXJrbWgzQ0E5MS9nTDE1QWIrejk2?=
 =?utf-8?B?bjArdnlkQ0RsSDBWR3BaSWFvbi9aVUtSOFIrZGlWZG1KSmN0UWNTTWtyZ2Jk?=
 =?utf-8?B?MExNY2FKbC84SHJaZzBoMlh1ZDJTUUxVRW5aZU5VQnpuQ3N5VVVwSDBpam9U?=
 =?utf-8?B?c0V6Zk9tSml6V1A1N1M5bW1vSm4vZm9tYnp3MW1YNVVBU0cvN0EwYXhHSGJB?=
 =?utf-8?B?T2NiVlNJNzhPNDVKam1xYXpDKzc5MG0vbUVwOUlRV1BEeGIxdDNqcGJmRTNC?=
 =?utf-8?B?M1QxTmt3bGJkRWJ1cVpOMVB6ZzVXdDB1MFRkQlNjcnV0NE1XUElZamltMlJK?=
 =?utf-8?B?ay9qZWlPYWtVYXdEWGp0VUlIRjlZV1FCWiszR3F6Z1U0ZWdnVW1PeG5IL2VM?=
 =?utf-8?B?SldZd0ZnRExiWDN0czNiM2NmdGdmaEhTSWRTRnFkWWQxTXVpYVRsS2xCbGtN?=
 =?utf-8?B?ZUkwQXNocVNOTjNaUDhQd25IOXJWZlBDbGFGT1puWU9obUd2TXBKS0VqRWxp?=
 =?utf-8?B?TFBGRkhuREFqdnFPVFZiQzNwVWxXWHJ5SUFDdmNYUmVDMmEwS040ckx1b2Fv?=
 =?utf-8?B?blRXTlhqSkJ5bCtnT0M1ektDYU92WlM2MFpoTVJSUUh6UXhINzk2NGI2R2dN?=
 =?utf-8?B?ZDRKa3cyeDRyeHF5ZUJMRlV1dHp1bnRZR0pObXRxQzExVmoyeVlYQyszSUZI?=
 =?utf-8?B?cHA3ejdMQWlvZFRMVk5WRVp3VkovOXJiV1lYa0E3Z21jM3FkWHlwa0s0UDFl?=
 =?utf-8?B?ZDNLemNIT3phUytMWlMvdXd6NjRrRXNvY3RzQVFGbzJKNklpSHI3MTI3bzJW?=
 =?utf-8?B?YnpmUUNUVFg0WklSVEYySURxNjcwZmExVWNoYkJ2bjJOejZQekMzMEFUd3Fk?=
 =?utf-8?B?d1ZGMjNlZ1ZzZExrZFdzUT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?OXZEbEtoMVJoYXhCcWNBVkkvQlZLZVRxa0UveEYrTlhodXlOQzl1cXYzclZp?=
 =?utf-8?B?L01Lbm1qMFREMk5QVHMwYTZlbmVHY1Y3MWV2eTJ6YVZmRUg5NHVGSWVlVThM?=
 =?utf-8?B?ZktadjFxNFpPeklDaXd0ODJqUVM2M2JjY3YyZGNXRTd2UGtqSW5IMDNTUjZJ?=
 =?utf-8?B?czY2VHl3UndZOWJoRFVteGFOeWRpQmpoMHFKd2J5VXZvS2F5TEw0cVduaVhR?=
 =?utf-8?B?YnJIU2gvSW9Jc1p3aytDV0lnVDRTOS9kOVFsMnlLVk9oMEE2cUExd2pnSzAx?=
 =?utf-8?B?ZVVnVGtVZ0h5dXpqbXU2TnpIK2x6WGNFZkdnUGM3Y0hkSjJkZHN2Z3ZvTnJr?=
 =?utf-8?B?ZzQ2SmYzQWRPWEZHY0JPdG5kMm5QMWxacXBEdlhPYjRZcmE3QXVtRm5ZU2Fj?=
 =?utf-8?B?VUJZMHpFVkQxS2RMWDhCTXRPRjg1TWsrcytUNUU1TnEvcmNFUncydlpVdnJT?=
 =?utf-8?B?V2JvRFY3Mis1QzdyVWN5TlFKYTE2ZlhCaDdSY2pRYTdIUU56OTUvWTY1RTdZ?=
 =?utf-8?B?REdIemFwMEhNdE1lMmJReGFLdFdnY3RyVkxnRUE4cm5EaVNORFppaCtwd3U2?=
 =?utf-8?B?dVV2SVl5Z25HK1R0S3BVeUpxZHk1d3A3ZUdQUnJnOWVaWmVCKzNoSXJHcUhD?=
 =?utf-8?B?VUtXc0xFSkdIdVVSRXVaNGxpUm8xQ2RZbHpnRDRmSWNZR0VvVExlQmdmRVk5?=
 =?utf-8?B?bHJvQnBtRXcwdXRTSkV6d2p3Ukw2WUR1clBuMnhrTDF3R01UQlVUUFdlaEZl?=
 =?utf-8?B?djkvSzE5SmE0THZpNmZCSWM5ajRGNm9SakdiMS9hSGJXTm1yZ0FneTV0MTN2?=
 =?utf-8?B?VVhubStLcEpZbXpCMjRiMmduY0ttNXZyYldJSzNhdi9mbWg3bzF6N2VNeEd0?=
 =?utf-8?B?S3BnQnhEOWlTT0tDUHRPc3l4YzRVcFR0VmVuRXorTDRhWTFUaWlyY0tlY1FO?=
 =?utf-8?B?UFp0NFg3dnprbXJ6VVpqNmp2bUpQNjZTUmV1YzlZRkt6cDFlY202S3ZZOTNJ?=
 =?utf-8?B?QTlYRUNpeEZnbXRwdU5GOWpGbmJYeEdUcHlLMVE0MTQyNTBGT2xINUx3cHRp?=
 =?utf-8?B?bngwdGh1emtxM2NqelBSOXRQa3ZoZm1Dd2hyWjh3bEt5Wk02Y2ptTnZxTmRj?=
 =?utf-8?B?eCtOU3pwMnFFL3VxdHZkZ3VoWjUxd2x5U0RCV3cxV0xLek9CUHRmYzBlZWY0?=
 =?utf-8?B?YVZYZnFzcDNKL0pncENUbktNdUdMeXBvekN0bWRFTEMzeHozV3FvY0lONWJ2?=
 =?utf-8?B?c2l5T0hNQ3orV3BNZVdaZ3RKS05SYmdrT1BNSmF0Z1liTHJXbnEvc1pMNnFU?=
 =?utf-8?B?c1Y2bko1ZFRsUDE4N1c2R0Y1MFR2bjk5L0JtZmpFcWhmMnIvQ0hkYXhmL2lT?=
 =?utf-8?B?dEFUQ1B4T2t3czYvL2YvNzF4dEdSeFpWZ0J2S3VEOTQxa1p1c1hTZWZJd0tC?=
 =?utf-8?B?cWVMVHlwRC9NNERISWhiVnQ0RW44VytFdFVnTmNLZnFKMHVVR2lybmYvUHRl?=
 =?utf-8?B?SWx4YVJLV1pSUGJBdXUvTEdjZm5QcXJDWDgrRG1FcXdUdXo0VmNnVTFiSnVC?=
 =?utf-8?B?bG85OHRpWk45ZTlwTHFWZFJ2UE4vU0UyNjNDRnlZUjF6dFpEUk5VcFVtS0gz?=
 =?utf-8?B?WUxrelpHVGdSNEd1TFAxbzQ5dmhXY3VEVlJydFZtNjY5ejVxK3dobk44TkJW?=
 =?utf-8?B?MzBPd2lyYjlndXd4cWJFMHMvbkVQK0loa0hUd0U5bzM3S3pjM250RHgrcEg4?=
 =?utf-8?B?T0NFL013aFoveHZPbWpFOVlpSy9va0lPSnVmbzBnYSt5Y3FqS1RMWlJOSWR5?=
 =?utf-8?B?anV2aVNmN2ZnTXp4R1Zsa3cvSFlMdjJMSXZCTG9OTjJwT29JQlhzRmtudEdE?=
 =?utf-8?B?QmEzL1ZoMks0dDVsZ3JmZFIvSFJaVDVQbmV1Zmx6T0NFWHRPSmRZR0E0RXNY?=
 =?utf-8?B?alNOSjdVRUxydHlWTXBHeFZicUlwT3FNSWpzKzNjOWM0MThXQnFYamlvKzRK?=
 =?utf-8?B?Z3hVMjA1Y25rZGJqcEdaelJCV2hYTDJULzFGRnluWElTMHgzTGV0YUNENmdK?=
 =?utf-8?B?K2pvamZ5QVNobWt0U3RaYmgxTjcxN01iTUhxZndsMEN6Rmd4K01uZE1FN0F5?=
 =?utf-8?B?cTFoSE1UT2J1R20xS3VtdEg4R0lVblk5WWlsdUdRN2tFU3VFemgvdzVVbzJS?=
 =?utf-8?B?d2h5bzZVZWw0bndWU2NXeW5TdGV2bzhWQjJ0V1NwTkJHZVVMQUZhZ29hQjE5?=
 =?utf-8?B?clVOUUEvc00vMXdIT1VpeXlDZTRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FFF881CC52031439079D6229A25B33C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	B5mOpLOEZ2kNNWmvtlHuW1smaYrOaVvfpZ6Wnopdw6HfYEObTnkPR5Ic5FWlTNHCCMbBQmVH/J+lb3o4n9jjxiImW+c3YabUx6DCr6RePF3tS2YgFcB9vTs0rEMTnY6im2RtzdSHYDf8SRNx1ZwoDWFAgnId7OY9xmRSht7wSBHVXh0cTxZDsECMfOCe4DfR/kX5sjCIlgJarQLhnf977PW1Qn1B7nN02PLsuqxSQf8up78TT2dQZeQeBjEng4n4mOX8HCh7ZvtWoXoLjTD0PpjXFAY8D9T1o66lJMRsmI+zq991acyyoZbr4FbtNU14nKEPgG/AXU0vjlQgHP4Un/W/GTT3WZztJAqhWaUBXS9HnB2G6qyp7YzIuTth44Y8yi0ckz2Dty8cnGBZqL6dOy8dhm7uUPAt9mtuhZ1kjB6VNdRQqgXbC06H/9QMc9q08wl/JaVufgKG47w2lYk80ILdHml1QO+KKFNs91lIxx6DS23YVV78NUFHsdvryTKGMuyVtkjdR5JEZx4fioxE908KZKxbCG4MKBOtQNlNucYN7TUP1zbXl70jzCJxjX9m7tfqsm+rJRu5f+zCnHyfM4qSizScE0+XV1o0BNUSaDA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b8474b9-0b2d-4db7-12bc-08dc83f1e94d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2024 17:23:40.4045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8z/+cj5ybHRqNuL68dUeXi6w57OjQZwbZcVNAxu9mfti9SdkjcFD/4jIHjEBtQxKsbL8cakvbx2i3uLcoos+D2hYQhjmluae55L4A0hyKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5715
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_13,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406030143
X-Proofpoint-GUID: c_8EYtamvPo1xDRErjwvARz797Ga-5-y
X-Proofpoint-ORIG-GUID: c_8EYtamvPo1xDRErjwvARz797Ga-5-y

DQoNCj4gT24gSnVuIDIsIDIwMjQsIGF0IDQ6MzfigK9QTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBm
cm9tb3JiaXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwgTWF5IDMxLCAyMDI0IGF0IDAzOjQ0
OjU2UE0gKzAwMDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+IEhpIERhdmUsDQo+PiANCj4+IERv
IHlvdSBoYXZlIGZ1cnRoZXIgY29tbWVudHMgYW5kL29yIHN1Z2dlc3Rpb25zPyBPciBnaXZlIGEg
UkIgcGxzIDpEDQo+IA0KPiBTb3JyeSwgTFNGTU0gaW50ZXJ2ZW5lZCBhbmQgSSBkaWRuJ3Qgbm90
aWNlIHlvdXIgY29tbWVudCB1bnRpbCBub3cuDQo+IA0KTm8gd29ycmllcyENCg0KPj4+IE9uIE1h
eSAxMywgMjAyNCwgYXQgMTA6MDbigK9BTSwgV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5nQG9y
YWNsZS5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IFRoaW5ncyBpcyB0aGF0IHdlIGhhdmUgYSBtZXRh
ZHVtcCwgbG9va2luZyBhdCB0aGUgZmRibG9ja3MgZnJvbSBzdXBlciBibG9jayAwLCBpdCBpcyBn
b29kLg0KPj4+IA0KPj4+ICQgeGZzX2RiIC1jICJzYiAwIiAtYyAicCIgY3VzdC5pbWcgfGVncmVw
ICJkYmxvY2tzfGlmcmVlfGljb3VudCINCj4+PiBkYmxvY2tzID0gMjYyMTQ0MDANCj4+PiBpY291
bnQgPSA1MTINCj4+PiBpZnJlZSA9IDMzNw0KPj4+IGZkYmxvY2tzID0gMjU5OTcxMDANCj4+PiAN
Cj4+PiBBbmQgd2hlbiBsb29raW5nIGF0IHRoZSBsb2csIHdlIGhhdmUgdGhlIGZvbGxvd2luZzoN
Cj4+PiANCj4+PiAkIGVncmVwIC1hICJmZGJsb2Nrc3xpY291bnR8aWZyZWUiIGN1c3QubG9nIHx0
YWlsDQo+Pj4gc2JfZmRibG9ja3MgMzcNCj4+PiBzYl9pY291bnQgMTA1Ng0KPj4+IHNiX2lmcmVl
IDg3DQo+Pj4gc2JfZmRibG9ja3MgMzcNCj4+PiBzYl9pY291bnQgMTA1Ng0KPj4+IHNiX2lmcmVl
IDg3DQo+Pj4gc2JfZmRibG9ja3MgMzcNCj4+PiBzYl9pY291bnQgMTA1Ng0KPj4+IHNiX2lmcmVl
IDg3DQo+Pj4gc2JfZmRibG9ja3MgMTg0NDY3NDQwNzM3MDk1NTE2MDQNCj4+PiANCj4+PiAjIGN1
c3QubG9nIGlzIG91dHB1dCBvZiBteSBzY3JpcHQgd2hpY2ggdHJpZXMgdG8gcGFyc2UgdGhlIGxv
ZyBidWZmZXIuDQo+Pj4gDQo+Pj4gMTg0NDY3NDQwNzM3MDk1NTE2MDRVTEwgPT0gMHhmZmZmZmZm
ZmZmZmZmZmY0IG9yIC0xMkxMIA0KPj4+IA0KPj4+IFdpdGggdXBzdHJlYW0ga2VybmVsICg2Ljcu
MC1yYzMpLCB3aGVuIEkgdHJpZWQgdG8gbW91bnQgKGxvZyByZWNvdmVyKSB0aGUgbWV0YWR1bXAs
DQo+Pj4gSSBnb3QgdGhlIGZvbGxvd2luZyBpbiBkbWVzZzoNCj4+PiANCj4+PiBbICAgNTIuOTI3
Nzk2XSBYRlMgKGxvb3AwKTogU0Igc3VtbWFyeSBjb3VudGVyIHNhbml0eSBjaGVjayBmYWlsZWQN
Cj4+PiBbICAgNTIuOTI4ODg5XSBYRlMgKGxvb3AwKTogTWV0YWRhdGEgY29ycnVwdGlvbiBkZXRl
Y3RlZCBhdCB4ZnNfc2Jfd3JpdGVfdmVyaWZ5KzB4NjAvMHgxMTAgW3hmc10sIHhmc19zYiBibG9j
ayAweDANCj4+PiBbICAgNTIuOTMwODkwXSBYRlMgKGxvb3AwKTogVW5tb3VudCBhbmQgcnVuIHhm
c19yZXBhaXINCj4+PiBbICAgNTIuOTMxNzk3XSBYRlMgKGxvb3AwKTogRmlyc3QgMTI4IGJ5dGVz
IG9mIGNvcnJ1cHRlZCBtZXRhZGF0YSBidWZmZXI6DQo+Pj4gWyAgIDUyLjkzMjk1NF0gMDAwMDAw
MDA6IDU4IDQ2IDUzIDQyIDAwIDAwIDEwIDAwIDAwIDAwIDAwIDAwIDAxIDkwIDAwIDAwICBYRlNC
Li4uLi4uLi4uLi4uDQo+Pj4gWyAgIDUyLjkzNDMzM10gMDAwMDAwMTA6IDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwICAuLi4uLi4uLi4uLi4uLi4uDQo+Pj4g
WyAgIDUyLjkzNTczM10gMDAwMDAwMjA6IGM5IGMxIGVkIGFlIDg0IGVkIDQ2IGI5IGExIGYwIDA5
IDU3IDRhIGE5IDk4IDQyICAuLi4uLi5GLi4uLldKLi5CDQo+Pj4gWyAgIDUyLjkzNzEyMF0gMDAw
MDAwMzA6IDAwIDAwIDAwIDAwIDAxIDAwIDAwIDA2IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDgwICAu
Li4uLi4uLi4uLi4uLi4uDQo+Pj4gWyAgIDUyLjkzODUxNV0gMDAwMDAwNDA6IDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDgxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDgyICAuLi4uLi4uLi4uLi4uLi4uDQo+
Pj4gWyAgIDUyLjkzOTkxOV0gMDAwMDAwNTA6IDAwIDAwIDAwIDAxIDAwIDY0IDAwIDAwIDAwIDAw
IDAwIDA0IDAwIDAwIDAwIDAwICAuLi4uLmQuLi4uLi4uLi4uDQo+Pj4gWyAgIDUyLjk0MTI5M10g
MDAwMDAwNjA6IDAwIDAwIDY0IDAwIGI0IGE1IDAyIDAwIDAyIDAwIDAwIDA4IDAwIDAwIDAwIDAw
ICAuLmQuLi4uLi4uLi4uLi4uDQo+Pj4gWyAgIDUyLjk0MjY2MV0gMDAwMDAwNzA6IDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDBjIDA5IDA5IDAzIDE3IDAwIDAwIDE5ICAuLi4uLi4uLi4uLi4uLi4u
DQo+Pj4gWyAgIDUyLjk0NDA0Nl0gWEZTIChsb29wMCk6IENvcnJ1cHRpb24gb2YgaW4tbWVtb3J5
IGRhdGEgKDB4OCkgZGV0ZWN0ZWQgYXQgX3hmc19idWZfaW9hcHBseSsweDM4Yi8weDNhMCBbeGZz
XSAoZnMveGZzL3hmc19idWYuYzoxNTU5KS4gIFNodXR0aW5nIGRvd24gZmlsZXN5c3RlbS4NCj4+
PiBbICAgNTIuOTQ2NzEwXSBYRlMgKGxvb3AwKTogUGxlYXNlIHVubW91bnQgdGhlIGZpbGVzeXN0
ZW0gYW5kIHJlY3RpZnkgdGhlIHByb2JsZW0ocykNCj4+PiBbICAgNTIuOTQ4MDk5XSBYRlMgKGxv
b3AwKTogbG9nIG1vdW50L3JlY292ZXJ5IGZhaWxlZDogZXJyb3IgLTExNw0KPj4+IFsgICA1Mi45
NDk4MTBdIFhGUyAobG9vcDApOiBsb2cgbW91bnQgZmFpbGVkDQo+IA0KPiBBbmQgdGhhdCdzIHdo
YXQgc2hvdWxkIGJlIGluIHRoZSBjb21taXQgbWVzc2FnZSwgYXMgaXQgZXhwbGFpbnMNCj4gZXhh
Y3RseSBob3cgdGhlIHByb2JsZW0gb2NjdXJyZWQsIHRoZSBzeW1wdG9tIHRoYXQgd2FzIHNlZW4s
IGFuZA0KPiB3aHkgdGhlIGNoYW5nZSBpcyBuZWNlc3NhcnkuIEl0IGFsc28gbWVhbnMgdGhhdCBh
bnlvbmUgZWxzZSB3aG8gc2Vlcw0KPiBhIHNpbWlsYXIgcHJvYmxlbSBhbmQgaXMgZ3JlcHBpbmcg
dGhlIGNvbW1pdCBoaXN0b3J5IHdpbGwgc2VlIHRoaXMNCj4gYW5kIHJlY29nbmlzZSBpdCwgdGhl
cmVieSBrbm93aW5nIHRoYXQgdGhpcyBpcyB0aGUgZml4IHRoZXkgbmVlZC4uLg0KPiANCg0KT0ss
IGdvdCBpdC4NCg0KPj4+IExvb2tpbmcgYXQgY29ycmVzcG9uZGluZyBjb2RlOg0KPj4+IDIzMSB4
ZnNfdmFsaWRhdGVfc2Jfd3JpdGUoDQo+Pj4gMjMyICAgICAgICAgc3RydWN0IHhmc19tb3VudCAg
ICAgICAgKm1wLA0KPj4+IDIzMyAgICAgICAgIHN0cnVjdCB4ZnNfYnVmICAgICAgICAgICpicCwN
Cj4+PiAyMzQgICAgICAgICBzdHJ1Y3QgeGZzX3NiICAgICAgICAgICAqc2JwKQ0KPj4+IDIzNSB7
DQo+Pj4gMjM2ICAgICAgICAgLyoNCj4+PiAyMzcgICAgICAgICAgKiBDYXJyeSBvdXQgYWRkaXRp
b25hbCBzYiBzdW1tYXJ5IGNvdW50ZXIgc2FuaXR5IGNoZWNrcyB3aGVuIHdlIHdyaXRlDQo+Pj4g
MjM4ICAgICAgICAgICogdGhlIHN1cGVyYmxvY2suICBXZSBza2lwIHRoaXMgaW4gdGhlIHJlYWQg
dmFsaWRhdG9yIGJlY2F1c2UgdGhlcmUNCj4+PiAyMzkgICAgICAgICAgKiBjb3VsZCBiZSBuZXdl
ciBzdXBlcmJsb2NrcyBpbiB0aGUgbG9nIGFuZCBpZiB0aGUgdmFsdWVzIGFyZSBnYXJiYWdlDQo+
Pj4gMjQwICAgICAgICAgICogZXZlbiBhZnRlciByZXBsYXkgd2UnbGwgcmVjYWxjdWxhdGUgdGhl
bSBhdCB0aGUgZW5kIG9mIGxvZyBtb3VudC4NCj4+PiAyNDEgICAgICAgICAgKg0KPj4+IDI0MiAg
ICAgICAgICAqIG1rZnMgaGFzIHRyYWRpdGlvbmFsbHkgd3JpdHRlbiB6ZXJvZWQgY291bnRlcnMg
dG8gaW5wcm9ncmVzcyBhbmQNCj4+PiAyNDMgICAgICAgICAgKiBzZWNvbmRhcnkgc3VwZXJibG9j
a3MsIHNvIGFsbG93IHRoaXMgdXNhZ2UgdG8gY29udGludWUgYmVjYXVzZQ0KPj4+IDI0NCAgICAg
ICAgICAqIHdlIG5ldmVyIHJlYWQgY291bnRlcnMgZnJvbSBzdWNoIHN1cGVyYmxvY2tzLg0KPj4+
IDI0NSAgICAgICAgICAqLw0KPj4+IDI0NiAgICAgICAgIGlmICh4ZnNfYnVmX2RhZGRyKGJwKSA9
PSBYRlNfU0JfREFERFIgJiYgIXNicC0+c2JfaW5wcm9ncmVzcyAmJg0KPj4+IDI0NyAgICAgICAg
ICAgICAoc2JwLT5zYl9mZGJsb2NrcyA+IHNicC0+c2JfZGJsb2NrcyB8fA0KPj4+IDI0OCAgICAg
ICAgICAgICAgIXhmc192ZXJpZnlfaWNvdW50KG1wLCBzYnAtPnNiX2ljb3VudCkgfHwNCj4+PiAy
NDkgICAgICAgICAgICAgIHNicC0+c2JfaWZyZWUgPiBzYnAtPnNiX2ljb3VudCkpIHsNCj4+PiAy
NTAgICAgICAgICAgICAgICAgIHhmc193YXJuKG1wLCAiU0Igc3VtbWFyeSBjb3VudGVyIHNhbml0
eSBjaGVjayBmYWlsZWQiKTsNCj4+PiAyNTEgICAgICAgICAgICAgICAgIHJldHVybiAtRUZTQ09S
UlVQVEVEOw0KPj4+IDI1MiAgICAgICAgIH0NCj4+PiANCj4+PiBGcm9tIGRtZXNnIGFuZCBjb2Rl
LCB3ZSBrbm93IHRoZSBjaGVjayBmYWlsdXJlIHdhcyBkdWUgdG8gYmFkIHNiX2lmcmVlIHZzIHNi
X2ljb3VudCBvciBiYWQgc2JfZmRibG9ja3MgdnMgc2JfZGJsb2Nrcy4NCj4+PiANCj4+PiBMb29r
aW5nIGF0IHRoZSBzdXBlciBibG9jayBkdW1wIGFuZCBsb2cgZHVtcCwNCj4+PiBXZSBrbm93IGlm
cmVlIGFuZCBpY291bnQgYXJlIGdvb2QsIHdoYXTigJlzIGJhZCBpcyBzYl9mZGJsb2Nrcy4gQW5k
IHRoYXQgc2JfZmRibG9ja3MgaXMgZnJvbSBsb2cuDQo+Pj4gIyBJIHZlcmlmaWVkIHRoYXQgc2Jf
ZmRibG9ja3MgaXMgMHhmZmZmZmZmZmZmZmZmZmY0IHdpdGggYSBVRUsgZGVidWcga2VybmVsICh0
aG91Z2ggbm90IDYuNy4wLXJjMykNCj4+PiANCj4+PiBTbyB0aGUgc2JfZmRibG9ja3MgaXMgdXBk
YXRlZCBmcm9tIGxvZyB0byBpbmNvcmUgYXQgeGZzX2xvZ19zYigpIC0+IHhmc192YWxpZGF0ZV9z
Yl93cml0ZSgpIHBhdGggdGhvdWdoDQo+Pj4gU2hvdWxkIGJlIG1heSByZS1jYWxjdWxhdGVkIGZy
b20gQUdzLg0KPj4+IA0KPj4+IFRoZSBmaXggYWltcyB0byBtYWtlIHhmc192YWxpZGF0ZV9zYl93
cml0ZSgpIGhhcHB5Lg0KPiANCj4gV2hhdCBhYm91dCB0aGUgc2JfaWNvdW50IGFuZCBzYl9pZnJl
ZSBjb3VudGVycz8gVGhleSBhcmUgYWxzbyBwZXJjcHUNCj4gY291bnRlcnMsIGFuZCB0aGV5IGNh
biByZXR1cm4gdHJhbnNpZW50IG5lZ2F0aXZlIG51bWJlcnMsIHRvbywNCj4gcmlnaHQ/IElmIHRo
ZXkgZW5kIHVwIGluIHRoZSBsb2csIHRoZSBzYW1lIGFzIHRoaXMgdHJhbnNpZW50DQo+IG5lZ2F0
aXZlIHNiX2ZkYmxvY2tzIGNvdW50LCB3b24ndCB0aGF0IGFsc28gY2F1c2UgZXhhY3RseSB0aGUg
c2FtZQ0KPiBpc3N1ZT8NCj4gDQoNClllcywgc2JfaWNvdW50IGFuZCBzYl9pZnJlZSBhcmUgYWxz
byBwZXJjcHUgY291bnRlcnMuIFRoZXkgaGF2ZSBiZWVuIGFkZHJlc3NlZCBieQ0KY29tbWl0IDU5
ZjZhYjQwZmQ4NzM1YzlhMWExNTQwMTYxMGEzMWNjMDZhMGJiZDYsIHJpZ2h0Pw0KDQo+IGkuZS4g
aWYgd2UgbmVlZCB0byBmaXggdGhlIHNiX2ZkYmxvY2tzIHN1bSB0byBhbHdheXMgYmUgcG9zaXRp
dmUsDQo+IHRoZW4gd2UgbmVlZCB0byBkbyB0aGUgc2FtZSB0aGluZyB3aXRoIHRoZSBvdGhlciBs
YXp5IHN1cGVyYmxvY2sNCj4gcGVyLWNwdSBjb3VudGVycyBzbyB0aGV5IGRvbid0IHRyaXAgdGhl
IG92ZXIgdGhlIHNhbWUgdHJhbnNpZW50DQo+IHVuZGVyZmxvdyBpc3N1ZS4uLg0KPiANCg0KQWdy
ZWVkLiBXaGlsZSwgSSB0aGluayB3ZSBkb27igJl0IGhhdmUgZnVydGhlciBwZXJjcHUgY291bnRl
cnMgcHJvYmxlbXMgYWZ0ZXIgdGhpcyBwYXRjaC4gIA0KDQpXaWxsIHNlbmQgYSBuZXcgcGF0Y2gg
d2l0aCBsaW5lIGJyZWFrbmVzcy4NCg0KVGhhbmtzLA0KV2VuZ2FuZw0KDQo+IC1EYXZlLg0KPiAt
LSANCj4gRGF2ZSBDaGlubmVyDQo+IGRhdmlkQGZyb21vcmJpdC5jb20NCg0K
