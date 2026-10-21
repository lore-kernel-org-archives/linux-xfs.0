Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792584996;
	b=0TwtLgfunoLBgtZ/J/pdYHaKR+fJDeSu/jgMnbfHQWb9jrHMDPAG16IDjXjwHTuk9cyw
	 SK69AMWBbvhNPNVEDdLg6SzxdvKFiwHBb1GU4183/00iYuVOVP2Lb4tXGLXV2bAoR1a0F
	 mRy6FMEKbryT674D3Uoi9uqs7ds9mKNo2MAWN57SQnsmFlxep0q65W5CqI1UlO/1QgJhw
	 /oas7JAulOzpZ7JScR6+/F2hkH+XaXpyPL6JKPI4HPqJqH6dcTSL1Q36I/dbGQ+K1+IZx
	 PwBaFaceYijQOD9ZH/SMyEA/N8X0kJxRGRk3Pnudz9PwwPX/Ahgv88Lp1//9TFEv0IA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584996;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:
	 x-ms-exchange-antispam-messagedata-1:Content-Type:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis;
	bh=sTHg64Zca1bYAVZdU9B5X26l8xIigxgTXm+G7kl8mmQ=;
	b=hdK3BMiFo0eXGa6ta9E1tJ2HCTFULE2wYzqsNMvqW2BnqOkzOAShPpjRgT+z7O9f1mkJ
	 9XmOWhCY7Lmm8DUvRM1m4xhLMv5RsdQj88K1Fgjj0VGH4eZ1FN/Cs7bVhPTXgWFILy4Lx
	 g49Jv5elu+B9/LpraHoSAHYO6uQmGXRLW5M7rsWgcxiP+P0IdMG8dCVqO/cag4KHnumve
	 /qu+hKFSEghROMMmc2M73GlDcOuIkc+5JxARPwIFMIypPVBAr6zlJrP8udhid4AQG1GNu
	 /7jCHX8HaHe0unTE2T7yJNfMhgjhBv2StJAMILSCa+6CbwQ2Nb2w/IAKhiwuRK+moUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=hE+tF6M1;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=Fe7g2KeI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC87E606A31A;
	Wed, 21 Oct 2026 12:16:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC87E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=hE+tF6M1;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=Fe7g2KeI
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L1O1cT1979265;
	Wed, 21 Oct 2026 12:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sTHg64Zca1bYAVZdU9
	B5X26l8xIigxgTXm+G7kl8mmQ=; b=hE+tF6M1GGIBgF0oDVmw0YyF7aV4t0x0Ek
	NLDtDEHqBffDK1FnbnZt3D0aeSEicXY/kXKhQ1FWfO0WhBHNgbMvyVQ93TtWSai7
	ZzyH8yitmlHGh/v4srs2JQUafvCaK/ADnZj6S6TcbAXWfyMLZm2Z4XD2ZdMwZ5tB
	QWm1GSt+GPXbYl2rGBBZkriNLv94CKcC0rzV5NAGXdRRSAkFpteAHHvDzaJx9Jmd
	BMtH4pekgY/4OEwBvw746mQBPTM/A9um6IBNZ4nvhfJuODJHwZEr9xGitC17OExL
	uuonSaNZ2f3KU8j1uQIf7NrFTZW+vcc6BwKvnzcdEnT0eWLgKSHA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hdw4habrq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 12:16:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 69LBh9mT2966914;
	Wed, 21 Oct 2026 12:16:30 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010057.outbound.protection.outlook.com [52.101.56.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4hevf91crp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Wed, 21 Oct 2026 12:16:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VZiwmDpF1PXigHR+rLLQSzcpS4sFQPHZjPZgVEUhkezvfPYDzVT/5o5ChHo4Eu3NuVT5wu7qkKiWCvI8abKl50TpkKaC5bBGAi35qKTDL2/wJb6JZmDBeO2GZUEMf7kmUUaJTelnelZTv7Nrm7lRczdJ/pbltGgX2KyH+/Iys/9iuIlpV7wx1LfxTvxN/avomrnN6Entd/Y5hDESzSRcWq0pP+FChVD9+GKeENIXZqyKIiXr2pEGc4SUFevi7BAsvll1DvIfSeiociFBxJhVwBzNNceX7st/yiUbV0qniRLQI1IhKBVLnfmnET6Ui5QQvKlsRGkeJKp6zSLDIXHRHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTHg64Zca1bYAVZdU9B5X26l8xIigxgTXm+G7kl8mmQ=;
 b=TvCD1FUXRj5A/IZQdZs/EFs9w4RP2fr+tW4WjXNWXbNnCDds1Bxh//ITof5T9J8AQtFRN7p5AjcTr4Y2VPibnSr/qRkGtbPbxkxcFgPCFV2BaKbVH6LYbbTpUNOZZgp10C9ZNl+Ch67ouf1kn3yc3WbXWMfef7RvGMmS0AIp+5MwyyLoxxNaFFKigYQTBR6Fr9uySoldVIwFimDroa3aCXCo/dKRayC7mJX85gWIOYv67h+DEUUSJlhYI8qV8wQ11RoD5+ErYswzBWtp+zkNmu/zsEUKv4j44r2pFVjxZC+IrMIPBi1URq3UPWcF5qDAwcc8nRYpk0XZxiG1pvYOpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTHg64Zca1bYAVZdU9B5X26l8xIigxgTXm+G7kl8mmQ=;
 b=Fe7g2KeIO95hhy//msxdT0hmqqAxRvR12yaAXJ/mZDHan9gut3dwfZPW9okgQcBJk4GeHDfA4JuiTv1ki+e0GWp1oqysK5aO6RT36Sk18pXzL6VjlXXlTYYVohNJMaBPOk35oeNy7QQhfHkyLgD1FfkHsltAP7fe9AEhK077J7I=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4297.namprd10.prod.outlook.com (2603:10b6:5:210::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15; Wed, 21 Oct 2026 12:16:25 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 12:16:25 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "cem@kernel.org" <cem@kernel.org>
CC: "djwong@kernel.org" <djwong@kernel.org>,
        "dchinner@redhat.com"
	<dchinner@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
Thread-Topic: [PATCH v2] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
Thread-Index: AQHdYVX+gYkJsheDcU+wDHDleBoaXg==
Date: Wed, 21 Oct 2026 12:16:25 +0000
Message-ID: <8104ae683f89ff3415528198c8b4af0089b7f9fa.camel@oracle.com>
References: <20261001145153.308087-1-siddh.raman.pant@oracle.com>
	 <as5AloTkTT3bZkyq@nidhogg.toxiclabs.cc>
	 <e7feec9bf096ed64f581536aa314a21723cccc63.camel@oracle.com>
	 <atirYb9qxRsaRYhs@cronus.toxiclabs.cc>
In-Reply-To: <atirYb9qxRsaRYhs@cronus.toxiclabs.cc>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR10MB7505:EE_|DM6PR10MB4297:EE_
x-ms-office365-filtering-correlation-id: 5930c709-7048-4d5e-373c-08df2f6d20af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|6049299003|38070700021|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|4053099003;
x-microsoft-antispam-message-info:
 4+NYHuhDuAStWwO8WwyHpD4ickVn+tPskseVEkzFVy5QMqH9ZbXHKfpmR2A57VscFBPiCQclYWsjpCfsZQ0/S447h+8PlTNccFmI4uHAd4UlNq+elBy9CjsgEqSubBiFWg8sbeARsyaO18kVJnqDXFcZqlg026r8vNOxi41Np3DSt1twIx6r7sfBAnK3Y1hE74YBvvVqhjXkzF8Q6NyvqZ6dAp5oqLoxCu1QKTfn92uHCqa6v/c3A3I0/BIWovlTfDq66Mib7uOc0yxt5ttSHOe6e29yX2FcRr7hVui4m2PDYQTOKPODVU2JPdTsiKMRDOWsOjsokZKbE/ffUsloIKBRee9a8eXzcwN1nIuacrUM1QvpZ3u/XSutP1RkZhQHFyWd+MmfZwYnT/M4u4zylJ/4qgOsIMhZrPfO4ZB3+kOBi5nQJiJ1y0m8bcU3xdd+2tqTcCC1rOxAvGQiMeq8KCFJ546AnEwAiL/iADDzMlA1XfxUH345ooyh5jebnA20If+jDT7AwRz+eH/n0mf+76hAST7R5gE3kXSfKR2+7tWZixdwntKEKmjHDWCmfygU4eNugL7cSLJexREePehdatQigHIvgK9UO+xqjdiwcgJGL7weR1xRZJrBm8F0TL4VB5Vhp6mv3iEIf2j0aesKB1WlSqfRO923kbRodGtsvK06pW8n3rydcO04blBouwRLG+JnJbGvRcAvukVA8Nsa6K7R79pwocNOZxIUlUoAUHc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(6049299003)(38070700021)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(4053099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UHRMckJaWnE5dC9GS054QWxZcVN4aTZZY21Pb3NnWnIwaHp4VGhVdElQVk8z?=
 =?utf-8?B?bjJpdGl4Zml4NklxZ05tOWEySkhPNXZlYkFJWTJNZHNsdzI0SjFUQlFOaW9s?=
 =?utf-8?B?Vkt1UFJKZ2Vmd1dUTHVlMWIyMEhRQVdybGdHamdacUlzQ2lKQlduWWVISC9K?=
 =?utf-8?B?N2FPVFJSNm1iNmIyemRadW5zWTFOYkxFVW9YUW9pT1BBeEVPSjlaMXc1cjdj?=
 =?utf-8?B?U3RudnNnenpNc0dUaWRZSmJlamliNmVVTkJPbWQ0WWNpY0JNbmwzZkc0Y3lS?=
 =?utf-8?B?WGx1dTY1SlprcGdGaVpPM3E1V0prd01mZGZoNEdpN21PMytiVkxyVjVpZ0VE?=
 =?utf-8?B?cGJESmM0MWUzNVo5T21mbWxjMTFndlR3S2FGWEExR244NlNnNXB3NTVYWlVv?=
 =?utf-8?B?bFV0ZklxUmRqaDg5R0ZSMGFETWgrY3YrUitkMGJyU0trYklsQ3hLa0g1Uzdw?=
 =?utf-8?B?aFdFMXNMeEQvaG5Cc0ZMU1RBa0pibEZhaVJuanpjSXZTTkFJQzB2VSs0OVhu?=
 =?utf-8?B?ZFliYVd4UVo0Q3kxZVM1bDhTZHhRQU1UbjNTMmZkaTJROHdHT3JxNXNhbWtB?=
 =?utf-8?B?V2FBVnNNUDRBbGFPUC95Y2Voa1cyM1VqM2FIU3pvRDJ1SU5BSVBjVTkrR0V0?=
 =?utf-8?B?ZDlKbmlFWm9hYkg2aDdwNERwdTNZYmQwQlJwemRBYkJnOEtYaHVlYlJOcFdp?=
 =?utf-8?B?Q2t0bGZnRmZMdU5lV2FrZFB3U25BYlpvcjZsdTc1THlmL2JOZ2ZOblVNUkFY?=
 =?utf-8?B?QnFTSGdoK2x3V2VUVENsZk9DdTJ4UUxYSzVlTGdvR0xaZ0FSTFNGSDFIMXFu?=
 =?utf-8?B?Z1U5QUtORzBCMk10VDRRSUN0OGZReElvaE5aRThlV3VjcnVCNEF4bzYwY2VX?=
 =?utf-8?B?OU83a2pWSTRkalRzdlBwcDBBRU5NdXpGcEs5cTdBM09vVDd0ZWZZRjJDK3VC?=
 =?utf-8?B?SFArM0pBZEdDNVZNUjV1V0VOTXQxbmZQVGNkaHBtK0ozeDhHcVJLVjJBa0xk?=
 =?utf-8?B?QytZVHF3MW5xN0F1S1N0TWIvSC9EUUQ0RjUwRjViSGxmSGdtdlZySlFoK1h0?=
 =?utf-8?B?QzlwSWlYczM5ME94Qm43c01OL0k1dFVUQmNZVy9qK3dWKzZjd0pxRlZxWW1Z?=
 =?utf-8?B?UkNJRllCYk9vRDA3UEdVV1FQc21XYjArdTlLb0dTZEZuSjg5dnVWdUVhYWhF?=
 =?utf-8?B?ank4L1IweEFxbzJHa0U5WG83bkVmTDdwdldrQmxBNmk1OENZUzNGQ1BNUmhU?=
 =?utf-8?B?VVZBbTdlV0dFTnppeEVUOEoxckU3enFtZ2ZNUk5ZZXMvaVNCbU1kR3QwK2Qz?=
 =?utf-8?B?N3g0SGI4TXl4ZUVsc244MUZTdVo5alN6WUlFSVBtWXlsT3JLMVpUSWhKTitZ?=
 =?utf-8?B?VWpKdW5UQjFhdkhkd1JaV3ZOcFJQRlp2cFR0cTdPYzhOeTBaUWFpTVFjSkpU?=
 =?utf-8?B?UEVDeFcyZElwdDZvSWhQUzFta25jaDcvbXBIVjJFZmc1c1BuTHcveDFnWmZx?=
 =?utf-8?B?Tzg1V1JDMm9BTWFJRVM4SU5paFBOZXpGS1NGcFBIeXdWN0R6R211ZFd2SkxW?=
 =?utf-8?B?R0t1MWxRRS9iWnFCOURzZENuS2R1eVBJTGhXYkI0L1lPSlFJb2NEVGI0Ty9p?=
 =?utf-8?B?TU8xZ0tjalJWay9VSVkvZVdjWllGU0ZaV1hTanB2eUlnekF1M0FkVUtOdnFM?=
 =?utf-8?B?bTdlMUw5eDFmdTZWbFBuRHltK29zbGo0cmhUQ1c5RTRYQ3dOdElENEhqS0dq?=
 =?utf-8?B?aVBPZWdKOE5qTjErM1lmWlpzZlNiallkNUZXNkZKbjFmSWZIYUd1czdraGFt?=
 =?utf-8?B?TnpwUExsRFk1R3Vzcllab0ZrajhjNTVjOVB6UjNzRVJpdDMxV2oyZjBleUhx?=
 =?utf-8?B?VnJoTnloV09JemZWMHlGMCtsWXZHTHV2UUxnZDlqUGUxZnI0Z3FiNjhPWG1S?=
 =?utf-8?B?bWJ6emxhbmVpTmlTeW80NHV4VVg1a2JlL0Z1SU9WYjFLWklXbUJCRHJ5cG45?=
 =?utf-8?B?VCswR3c5ZUs2VWdDVlhTWVJpaUZTc2Z3RHVnNGR1T1lGa3JmY1AzSG5PK0cz?=
 =?utf-8?B?QkZoQWUxS2w1dWk5emZEelZ5V2g3ZU5WL2I3TStoekFlb1dIQmNYQTJYWGwy?=
 =?utf-8?B?UFY1VU0yOUpyS1NSVitvMlE5eVgrSzFWMHlRRlZ4SHdMaUhtOVVjeE9VMWhC?=
 =?utf-8?B?MHR0MjJiMzlNTHZSckxRYUpId0dveS8ySEovTGMyQXlWeFA5UkNwdVo4TFVV?=
 =?utf-8?B?TXE4MTZHVU5uZXZnVkFiR0wxK0tmaHhGS0F3U3d4Mm81cVFvOFdseTZtZERI?=
 =?utf-8?B?RnkxWS9Od0FqSzJWTWtmQUxKb2VKY0U1L3hyVkM0eDF4REp5Ulc4dFdaOXc3?=
 =?utf-8?Q?UguOiPEaa+33ZWLTURDcenH33dT4Zv9f8Q6dfdUYd9HdR?=
x-ms-exchange-antispam-messagedata-1: mnMGs6RgG1MWao1I72dqyUSjQqTjQ8PJxpE=
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="=-1QwOl3TT7WPV/7BrwHDZ"
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	17oTm5DwmYwJq5q7PU56pV8jZlFRZl2yidtJZY22h+xzv1y8SnN/psQ/H3SGbHpX9QY2sa0BqCxHqzp0qqQcodS+xVRZB5uTsuEefSOhT6Slm7g281APTMrowo7j1pecMJ/cJPl0o58zjwpADaG03Xo2vukiZakQGo+jvegY1ibt7HgieUs16rfvwAWCwE08WUzCmfndaSARMee7QVz4l46cf0eAwbHpC8xxSXbBq/LlpAOw6b2YI0TTJnwuzx5e1Y9aynb/PXiaLPr0wajyPZJ/nI++mt14onJ7X3JwKrUBcyxrEmneVAz2i3wi7734OJhY+GxaSrPhBh3C+qGEpg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I0/l4KQyxBe1eEe3se3E+EO4vgiYbMVnW0hKZ6D/8Fx0juUpadp41xTozc54366PfxPbtQrvI39M4KH64S8iwhraJ6xy8rdLobg+WzmijZYY0YG8TqjUb6tpbzm7OkgTs72wUqdr2XKVFP7Hx4tilrkhr2LdVHyIWzudqLVu3y5yEW3rTzR52f6zGQV5IOXHqiC9NGmlQYrDsWjG5KBsUaIFweH2IBHQ0E8v5Px+mSOjnd+3pC7KLNfW7pX03RyEclvmLTAvHyBjgU69rSjpbxigF5KQw8ILo8QJCejlc0urCdz6DKgKafbpXxw3jYSZOnSqQUYXt/jb3Rk7/LWO8PmlL68DSBKD9hUNzpODHVvGlZwm00p2TQ8sxeYMLI2fZICYeGO60uqL0JeTRW5V/vx40v/+JkL0Z4r3m8MrWYviF2+obHJUq7kmbNYsqgcI1CUTinIc5jnQdrN9Y0h4Fi2Iw+q2tCvGvMqpHpqQNtR8UutxAbP/X84NCrcW6JO5TCFz4dFskjZLMs8fYtRuOo6kSpPQ5H97/QzIU3QlZKbNvdtRcSSaaCfV7BZvDD9TGrqqVWD2ole2rj1KoG3880aQkyjx8RIUKelPsoR5+ZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5930c709-7048-4d5e-373c-08df2f6d20af
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 12:16:25.5427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +8rQLIISy0z10rX0F+sLPCBj8AvzL7w40aq6iXEGfiTvRIAGIS5jLubpcPyFQwYll0TKB9FQuMA05+XjFSr3fcJ4ku1/zxpyVPRF5sCwGo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4297
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210048
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0OCBTYWx0ZWRfX4xAL4bEmYH3n
 UTuekGCW+NoajF6TxVSIy4YInxMWLzRXuLGLZXXZE5fTTVRR7CJgW3HoHUqMPbwpZs8IYDJNpDJ
 pj4/DdAoEDz576dZY4gt1sRdhp/3sxqyv6NDJNlmc2li7pw6j0GO
X-Proofpoint-GUID: dxPidL9JgmkMvXWQjB6WgfwQ97mrqH2P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0OCBTYWx0ZWRfX9QImWozQKPaG
 LY/34WvcJRQ8fv3Nf+UZtDxMg4GaOFqnb3k6f/9Ox1VdhQRcb7DUezdGL7BklFBCEdBBdzH8Sdm
 Uo2KCoHK6dWLxkCacnjclUKkqTzEhEpM5TPIlmJVanMKCfMbOlDTPvbrUyWhIKJP6VTG/2TFs7I
 FVzgvv3qn5TtNux8YttLRX4NRrLnUvuwU5Vu5VXPOwseSAwL3qsNCFHv14QSeLHCuqOBScpyF4G
 glPMNBPbh1Y2RfJpQP8TazZzaeWMLJFqLBVa+KndvTOyW89qmreCdxTJyW5n099Lcz0LYpF+zzv
 JPam61jijPcCsqWnq3AumIbC331JGosdgXYOYU9GnXblajHsUtuIXT1Am8ax6jLzCdWBn0F//TI
 SMIRPLZSpeFVS6qzW7YzMGeQt3lzy+84ITAIIEXHhVKDHGrMIa/hP9Q2cxD6oq5KjVBwerY+wf9
 pD/i+k6nyePg4KXUc6g==
X-Proofpoint-ORIG-GUID: dxPidL9JgmkMvXWQjB6WgfwQ97mrqH2P
X-Authority-Analysis: v=2.4 cv=OICyTiaB c=1 sm=1 tr=0 ts=6ad8ad1f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=KXsfj6mFbbKgeO3szogA:9 a=QEXdDO2ut3YA:10
 a=HUuv5KfUpCMTUSQec2UA:9 a=FfaGCDsud1wA:10

--=-1QwOl3TT7WPV/7BrwHDZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Probably an (harmless) error in copy-paste.

Fixes: db6a2274162d ("xfs: catch stale AGF/AGF metadata")
Cc: stable@vger.kernel.org # v5.10
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---

 fs/xfs/libxfs/xfs_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f762dcce8d13..0ffa82400007 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3461,7 +3461,6 @@ xfs_alloc_read_agf(
 	if (!xfs_is_shutdown(pag_mount(pag))) {
 		bool	ok =3D true;
=20
-		ok &=3D pag->pagf_freeblks =3D=3D be32_to_cpu(agf->agf_freeblks);
 		ok &=3D pag->pagf_freeblks =3D=3D be32_to_cpu(agf->agf_freeblks);
 		ok &=3D pag->pagf_btreeblks =3D=3D be32_to_cpu(agf->agf_btreeblks);
 		ok &=3D pag->pagf_flcount =3D=3D be32_to_cpu(agf->agf_flcount);
--
2.53.0


--=-1QwOl3TT7WPV/7BrwHDZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEQ4+7hHLv3y1dvdaRBwq/MEwk8ioFAmrYrREACgkQBwq/MEwk
8ipztA//cLLaRNNbsemSiANxJc5c26yP81HrHF2Z1Kf9ZNrt7ObfXzUqDYqJl7TQ
DYCBc401LzgDLsOxBhAhl/H8nBBdgCv++GY9oh8cxB3cijouyRcxxld3a3H2n6cY
TxLmcteBucbnlf7BiRqoISvcfmXdR9r4V73fF0sObdBXM1Sgex8hGmQ4xER29ChF
mV/5At388bxblQ9AR1Vs5A1uRZwTU/z3CX3HxDot8C4UnXZGxTVbXQxODRQpJD/L
jO5jfAyolpbb1Pz7Ge3SWmhbSTRVuRYuB9BU29B9PNZwXd5HLoRfWIyTGp2+dbR+
8T6oguy3sSP4fD71DYGjoOJGoenaFlpwz0QWUGf9RWI8rTNJiO9UUpO1ULjpplX7
eIjcYZJoae2Ke4ubD0Mv1nLztI68gT0w2j9Hd4fIAAHgQ4AJS4omfxlWcp/UnxJs
N2SHBmIrzJXFlZdul8t5I1KTsNxh4gB7qf/1j0PWA5SlfmTLsjU1PrxKTTCGWojq
Fd1OmNcpin0I4WYthtfWENe2QJuEGEffN9fB191Mbp2kGJklG35O6S2kDl6Vpmri
5E9vygUzm/kRKFTi1CyoXcPqS3AzfNntStwdrS2a1ZXnYdOnvpMLUWulANqhp4pR
YCbCYYt+eCrkrxrvm/J9ysZP5bbQDUW17SQKfDej8qIk0ob7yo0=
=PK05
-----END PGP SIGNATURE-----

--=-1QwOl3TT7WPV/7BrwHDZ--
