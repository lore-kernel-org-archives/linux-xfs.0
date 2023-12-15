Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E65A3DBB5
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q7qqp3sM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rFJwnHfa"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFG3wG2015607;
	Fri, 15 Dec 2023 16:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=ikOJDNCKKAun1KS6iLnqWiPYt7CwUrmo+R4Nc5BKK/c=;
 b=Q7qqp3sM5DAKzfQXdvVPCm56XT1FirGn5V9746N5O0dxzzY2V8Wwt8d80Q3bBztvH0Kp
 V3Y+L2gkhl/iQLbuuHeLtvfxns4/enU5f6S5QLneCpnNNbDqyaLdAxNfH1IlE/XGkO/O
 NJpQ+OGCbwzEi8RntkPnkMWnsDRl9fBAYeHEVW4EXe2o05fnqOHlYFezdvBHruYGm5Al
 WNtw6pFdNiGKVTmGaZOuH78EFQ75D1OE0fqObeMTvJljqh5nJvEcYY4Lyt35clT1W7NC
 mKDJTn8urhF8j2oREZIU1KMh5Cy8y5gar5GIBxquP6zoEZeJX2SCOOF775vUMonkNnjt nQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uveu2drgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Dec 2023 16:48:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFGZ6Dh024772;
	Fri, 15 Dec 2023 16:48:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepc2mgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Dec 2023 16:48:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJ8yXmXgadc5nJWZ0x8RwqPUSxh2lj+q8ZELwR31C7oOdtxxM6NEdgvY4gOrEeVLcQO+amK+9JoC8K7Be9aL8nHsNMDygQX3cCqfdPsZJoZgPNj3PWm5SuIIRi4Bi6HL86L0MfF4+smfhZwIsOT/EjRv7lJO2QiN4ONpc61jbvLtw1eV3YU7OtOghYBg0FBmYdXT/XdZwudHvPzaBwGQUjJ27B+aYcpiVpuF87RxLM1vjqXSIidTAXGiTmKR9KvMFyY0nUC9BC5hbzUd2L1fv1cjJqmpm6TDM/rzNZob8Lcv9zo6ymOmOofmCLUAZ9Wz8B7MzhfQalQwHyn3RN/fSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikOJDNCKKAun1KS6iLnqWiPYt7CwUrmo+R4Nc5BKK/c=;
 b=hJAeaN24zVo8IXky0UTtOfxI4rnFsCVSME3jnmUoIJ7mSX/cF54v52/s6OndjSvgjqLze4NmMMCeDqp6VwP5FIsAN0Zv9PsbPM30NVlm+a+8/1Rj3CJ0z1ucDg1vdTnOgssHO8JJY+eZ4czT5PKixtI+PwDDUKVCoflSaXU/5uWiS4nC/mzMxWv+D6hnUxFBOrVjbQUI4lcwxk0i1OLjjNga8n82f/tAuoZNL7Zh5PazLz92jDPDsT5+MqZp+Oor3Psqf6hMVE/f87uQf5SS7hGvsvVHnrUAYILwt3NdAUS8HVH+ZlRbYZYY+ubsxyyTnMgtCcVF8mDp2B2Sk30v/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikOJDNCKKAun1KS6iLnqWiPYt7CwUrmo+R4Nc5BKK/c=;
 b=rFJwnHfawRiyM2IxP//nlqNn/+b59L1nIsuFUESdsGQPp/P6PutzDZoWlEcvvy3NDQO1yTrNiyBWfsQVT+zF1z635BMaK5yl+6XZamuZVST8gkTR7Mgkl0k80X/32F7aTrgSHZDDKCktHoRnFG6OlAVj43O5yExzihYNEpmBZS4=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by SJ2PR10MB7786.namprd10.prod.outlook.com (2603:10b6:a03:56e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.32; Fri, 15 Dec
 2023 16:48:05 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d%3]) with mapi id 15.20.7091.030; Fri, 15 Dec 2023
 16:48:04 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Topic: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Index: AQHaLq/DBPQjWKfW/0yGGD6NwG60UrCpTWoAgABtbYCAANStgA==
Date: Fri, 15 Dec 2023 16:48:04 +0000
Message-ID: <33E7B082-BFE6-4716-8384-E63A9A759D50@oracle.com>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs> <ZXvQ0YDfHBuvLXbY@infradead.org>
In-Reply-To: <ZXvQ0YDfHBuvLXbY@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|SJ2PR10MB7786:EE_
x-ms-office365-filtering-correlation-id: c6cc08cc-dd48-43eb-f30b-08dbfd8d9bca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 6ququmFe1TPAhRBe4NcU7TFGjV+ztrnPvpoLDVhsOj+9ZLByS/Ch7mR0nqCjfZm+WoZeLqr3GHqw18dqive3u1u8oxTeNC5ruZojvIzjBgDG9Yo6zuNvKiboIJ8CmvjpNXjfs34/wwbu3kcNqM5tiFZQinxjNseHuxERgUwuNNGCisUgNhY9L2SoqbRpAvWqxiLv8JxNi8y6QiMAlxPoO93sSX3nAEScDivchGrWgVkQ/UqzVM0xVCT4aNdO32vlCMMicN0gXlgXesaiXypTXenJ42PMj5AyeOwSM+h4u8Ea1I2iw3W0lz4szQjWsqhhu1JmkYtGVVjbw5XVBqnTv561HjqFnz8DQX7AGuK+a63NXRRz6ey4JuzUeucx0FUr6UDTvD1kxD8LWMMwSuUt+aDDMZAEujgsZTsHnJJ+dmhQTyupr5Xa3acC5LPw+tuCJK0PhzcILUfpBrlPrxt9MWERMHUi1k6J62hnAqtfubroC5q1hpFL1x77ozyyWxwDmt9lqXVcphLEscq833bEeL8/Eouc/LtYVmfvnFoMVmGJ8M5P1ZVHMYFLkolkMp2D8Jk1KkzXBSWgd4RSGp9jqjimpFGQ5DSsPK+aQbHtOoNWBH3usBoaQleL6WoXcwqPNh/yq0Qe8TCJQ7XHn5uwEbUGULqK64Mm7whNIZmCvR4=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(36756003)(33656002)(38070700009)(26005)(2616005)(71200400001)(2906002)(478600001)(6506007)(66946007)(76116006)(91956017)(8676002)(8936002)(6486002)(4326008)(66556008)(53546011)(6916009)(316002)(54906003)(64756008)(66476007)(66446008)(6512007)(38100700002)(966005)(5660300002)(83380400001)(41300700001)(122000001)(86362001)(562404015)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?M2IzajR5QitONGVIV0dOWnk4VllIbnhFVmNrTWlCekRqSzhuZWVNT28xcXh5?=
 =?utf-8?B?Q0t6M3QwUnhHY3BLNmJzRGJBUFI5Ujl3SkNXRmRrM2tEQW9QNnZiNkg5SDgz?=
 =?utf-8?B?bzFRY1F5VkdkQlJMZWdUTFpsWjJyM0FEa2lybldIU240aHN6cnFHVDArSWVZ?=
 =?utf-8?B?M00rV1F0OUxocC9tSURmS2N6Mm04V1ZvZUJ1aVY2UUVNdEZaNU03SGJBMm1h?=
 =?utf-8?B?OEIyU0szYm5ZSG52THJKWDJMckpNenJidEJERFU2TEN6dkFSME9NVklPbFJq?=
 =?utf-8?B?QWQvdmtCOHBwNGlFVGRSSU5rZEVzcmphcy9YdUNYSGtrU29jTGdyMTZSekpS?=
 =?utf-8?B?VUx1SXJEMDAzZGtncHBPd1FUcUtzaW85K1FHK2dlc2pTZGp3K3plMlZWeUZr?=
 =?utf-8?B?QitNZzBSeS9GYzRaV2J5c2JCYlJSVlgrRmV4elJxWXExZzZkUWM2SDVVT1Ur?=
 =?utf-8?B?eHQ3a0oralhXYU5kWGdETEdoSDEzUGk1czNXbFd6cWRXN0JpRFRLQTR5SWRC?=
 =?utf-8?B?VXVuNDY4Y29FcWFzMkRrbWFxczB5RXljRmJkb3FKbzVRWlNuVHdMS0dDSGc3?=
 =?utf-8?B?ZUNWWDdwRklwdHBQdU5sSlNtN3UzZ2h0eFVvZ256b2tJNlFMbjA3S1RKQTRs?=
 =?utf-8?B?cUtsdXo5RHkraS9EeGJ2Ti94OW4yaWpYSWhZZkhvMzRuVXhnRFcxRmd4TWty?=
 =?utf-8?B?b2pxb0RYM0lObnJMcWZ2V2hxekVUeHoxTGQrOXdmVFZDdmt1djJ2NGQ2OUo0?=
 =?utf-8?B?U3paTjJIU1RpbWYzWjVpNW1SeUJTWmtUTXc4dXdIUlRtYWUrVFI0dFlXTENk?=
 =?utf-8?B?Y1kyOTl4bXl2MzV1RDVrcWZ1MU9uTkloNXJDM0hGQStzNTBFSkgwellMckN0?=
 =?utf-8?B?WHNhdGVBWHYrcVUxL1ZobWVqVzhobGw3Z0lmM09yY0hOSHJFcXNMSlJYcWJ4?=
 =?utf-8?B?NmJhU1RrUkp4Q3QzcnRhNW9qNTQ2TVFkb2tNUEdGQ3hSeFZFY1NBZzhZcm83?=
 =?utf-8?B?UUlic0M5aFpXZjNKNGZzdGY4d1dOL0w1ZHNoaUZ3dXdoTlhXZnltNzBXNG96?=
 =?utf-8?B?OEJIdUpFaFB0OVkxbldzTGtrTzRjODBrZE9nMGdxNWF1K1JMaldsK2FxY1Ar?=
 =?utf-8?B?SmxtM2FIdVhPREZvbVozV3FMaEFXQ3FQYUR2NVE3dkNUYXNKaWlJdHJEdm5Z?=
 =?utf-8?B?MC9GZUM4RldMdWFBT3c1bnlWQXZqUDJwVG4zOFBBc1BOUGNHWXBWV0tQUjAr?=
 =?utf-8?B?THBwV2pTRXYvUzdkVHlIakpwendhaWZxcHFSY1ByeVdtZ2lIbGljM2FENVBt?=
 =?utf-8?B?OGNEb2dYbzdWblIxNGlSbGoxYVRMaUNlMlJBSTBkdGVRZ2ZvTkV0VE0zRXlL?=
 =?utf-8?B?Nk9oVm8rOUFSZ0VOTHVpQmQwaU9vNU9TUlczNFpTT2xWT085M2RROHhlcVho?=
 =?utf-8?B?RFZCK3VGaVU3VVE1ckdtemhyaWlUOGtOMm5UNysxUGNjOEh2b2JSSCtlT1ZL?=
 =?utf-8?B?aW9JSWorR2VZMU9PWEk4WWFEejgyMy9aSTBqczBCSVJiemcxdm1jWE5qNlNI?=
 =?utf-8?B?MVlzeDNqaVdoeFJUenViaDhVWGdSSnB0eTJVNFZyQ3NjK2JRVERtMk1iS3Zl?=
 =?utf-8?B?QStsM0VUdFFYeFVIancrOWZMSjlHeHYxaHp5VTNXVGRqMm9URjI4QllDM1pl?=
 =?utf-8?B?UXNha21kOXc1RDFuOEMzSVpLTCszL0pmK3p2WXJUMWFVTWtxKzQzeWdUTVJ6?=
 =?utf-8?B?WDVkMG9nUHl0S2VBOFN6SEwzYkJzb3NFWFRoZnp3Sm5wNVVwNndGVzlEODBV?=
 =?utf-8?B?RlBCc0toa3l6eWFaM09OMnNMK3BXelBJUzIrdGZmaFhmWjJUdldLdk9iM1Nr?=
 =?utf-8?B?a2VIU3BucXFmWjFPMTFuRGk5WVgxL0JINVhoamtqdXZERE9vUFlpamdBTmxE?=
 =?utf-8?B?S2pnMTFIWnlIOStvcStyV1MvZ0g5UEpoa3VKeEJ5djJVSXl1aFZHRmU3MXpJ?=
 =?utf-8?B?eGg3TldVR0RkNytzMzhsZ0VOY0tLT2g1anpvaGFqOEMweEJleDN2dFRPcGJS?=
 =?utf-8?B?dkl5dmo1MlNGWk9ENEpJYjlIakNrMnoyWVcwWUJYQ1BLWUFDV2dVc1hibzhs?=
 =?utf-8?B?cGNoYUFSWFllTVRzaTkvSkZnbzF4TnpqSTNFVjNCWFdXMjRaNHI4OTVOM3JM?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E43D3AA0C13E4845B9F7EE0F79BCD979@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	oWfmWCLq2Jyl5Kszuxhr/pRGwHdD0glPCZzDUhHxLRk4Ij3/bd4Z9bC1kZESVjXkVxZ91BNje3LC3jKDAzFjrDciNxHDathi5Ig1AN89QiBVxeApscWrzoniY+/UwGYJABipIbPKjJhcdG6cst0STzzfdsI/iIe14+uh1HltSX9k701+nFUr3QDvdjinAvvboerVsxIjsMt1Jv+rqyEvB0Ppsm8VMNWDGZZwtISXbDx8SiMC3PpAvFpVhMi299n+ET2ftHd4CwnzxQe3jXnGFWUfyGc9aIkNhlnEhtXtvxz01NELuw960TzJxTx1tA4UJAf6DIskdMJ3iEbhS1WBhinzo3lWVcXHpSIRTLR6TLb/49mpUX3WS9mY5JEuvqvCeZQibcCoJU4HYluXlqmJpmewINC+Wu4uCoEMc9ykjl9mvcqGBGY0eim5rvU8KPti6C4LmXf8fUc99NqU0glvboWHU5JDdL8+Tjes5bTI/DX510kk3YqNOhLH1H+zt9/P1z+ty/zFSVQ86f53Rj4w7aSbwvs8GpFJZlqHEPmqLHFVVg0rdJl9Fofw48OQC7M7KOqQqEJADXByh63b2II8KeKS+xg+GA2RpnhXfQeHlS0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6cc08cc-dd48-43eb-f30b-08dbfd8d9bca
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 16:48:04.8971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /qN+yDRZvyUb1KgOCtYD3eaGAI4qX/uiS3qipPwZch15ApWI+xGzAPhNlXM3m4nZbMPDPYCahH2bJqqVQaK9ijp+bnKA3ozLu/Q2eUdwcAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-15_10,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312150117
X-Proofpoint-ORIG-GUID: cdYRVZjtAFVf42f_4PNJcwTtdWx8TRLl
X-Proofpoint-GUID: cdYRVZjtAFVf42f_4PNJcwTtdWx8TRLl

VGhhbmtzIERhcnJpY2sgYW5kIENocmlzdG9waCBmb3Igc3VjaCBhIHF1aWNrIGxvb2sgYXQgdGhp
cyENCg0KWWVzLCBpb21hcF9mdW5zaGFyZSBzb3VuZHMgbW9yZSBpbnRlcmVzdGluZy4gSSB3aWxs
IGxvb2sgaW50byBpdC4NCg0KV2VuZ2FuZw0KDQo+IE9uIERlYyAxNCwgMjAyMywgYXQgODowNuKA
r1BNLCBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+IHdyb3RlOg0KPiANCj4g
T24gVGh1LCBEZWMgMTQsIDIwMjMgYXQgMDE6MzU6MDJQTSAtMDgwMCwgRGFycmljayBKLiBXb25n
IHdyb3RlOg0KPj4gSSdtIGtpbmRhIHN1cnByaXNlZCB5b3UgZG9uJ3QganVzdCB0dXJuIG9uIGFs
d2F5c2NvdyBtb2RlLCB1c2UgYW4NCj4+IGlvbWFwX2Z1bnNoYXJlLWxpa2UgZnVuY3Rpb24gdG8g
cmVhZCBpbiBhbmQgZGlydHkgcGFnZWNhY2hlICh3aGljaCB3aWxsDQo+PiBob3BlZnVsbHkgY3Jl
YXRlIGEgbmV3IGxhcmdlIGNvdyBmb3JrIG1hcHBpbmcpIGFuZCB0aGVuIGZsdXNoIGl0IGFsbA0K
Pj4gYmFjayBvdXQgd2l0aCB3cml0ZWJhY2suICBUaGVuIHlvdSBkb24ndCBuZWVkIGFsbCB0aGlz
IHN0YXRlIHRyYWNraW5nLA0KPj4ga3RocmVhZHMgbWFuYWdlbWVudCwgYW5kIGNvcHlpbmcgZmls
ZSBkYXRhIHRocm91Z2ggdGhlIGJ1ZmZlciBjYWNoZS4NCj4+IFdvdWxkbid0IHRoYXQgYmUgYSBs
b3Qgc2ltcGxlcj8NCj4gDQo+IFllcywgYWx0aG91Z2ggd2l0aCBhIGNhdmVhdCBvciB0d28uDQo+
IA0KPiBXZSBkaWQgdGhhdCBmb3IgdGhlIHpvbmVkIFhGUyBwcm9qZWN0LCB3aGVyZSBhICdkZWZy
YWdtZW50YXRpb24nIGxpa2UNCj4gdGhpcyB3aGljaCB3ZSBjYWxsIGdhcmJhZ2UgY29sbGVjdGlv
biBpcyBhbiBlc3NlbnRpYWwgcGFydCBvZiB0aGUNCj4gb3BlcmF0aW9uIHRvIGZyZWUgZW50aXJl
IHpvbmVzLiAgSSBlbmRlZCB1cCBpbml0aWFsbHkgaW1wbGVtZW50aW5nIGl0DQo+IHVzaW5nIGlv
bWFwX2ZpbGVfdW5zaGFyZSBhcyB0aGF0IGlzIHBhZ2UgY2FjaGUgY29oZXJlbnQgYW5kIGEgbmlj
ZWx5DQo+IGF2YWlsYWJsZSBsaWJyYXJ5IGZ1bmN0aW9uLiAgQnV0IGl0IHR1cm5zIG91dCBpb21h
cF9maWxlX3Vuc2hhcmUgc3Vja3MNCj4gYmFkbHkgYXMgaXQgd2lsbCByZWFkIHRoZSBkYXRhIHN5
Y2hyb25vdXNseSBvbmUgYmxvY2sgYXQgYSB0aW1lLg0KPiANCj4gSSBlbmRlZCB1cCBjb21pbmcg
dXAgd2l0aCBteSBvd24gZHVwbGljYXRpb24gb2YgaW9tYXBfZmlsZV91bnNoYXJlDQo+IHRoYXQg
ZG9lc24ndCBkbyBpdCB3aGljaCBpcyBhIGJpdCBoYWNrIGJ5IHNvbHZlcyB0aGlzIHByb2JsZW0u
DQo+IEknZCBsb3ZlIHRvIGV2ZW50dWFsbHkgbWVyZ2UgaXQgYmFjayBpbnRvIGlvbWFwX2ZpbGVf
dW5zaGFyZSwgZm9yDQo+IHdoaWNoIHdlIHJlYWxseSBuZWVkIHRvIHdvcmsgb24gb3VyIHdyaXRl
YmFjayBpdGVyYXRvcnMuDQo+IA0KPiBUaGUgcmVsZXZhbnQgY29tbWl0IG9yIHRoZSBuZXcgaGVs
cGVyIGlzIGhlcmU6DQo+IA0KPiANCj4gICBodHRwOi8vZ2l0LmluZnJhZGVhZC5vcmcvdXNlcnMv
aGNoL3hmcy5naXQvY29tbWl0ZGlmZi9jYzRhNjM5ZTMwNTJmZWZiMzg1ZjYzYTBkYjVkZmUwN2Ri
NGU5ZDU4DQo+IA0KPiB3aGljaCBhbHNvIG5lZWQgYSBoYWNreSByZWFkYWhlYWQgaGVscGVyOg0K
PiANCj4gICAgaHR0cDovL2dpdC5pbmZyYWRlYWQub3JnL3VzZXJzL2hjaC94ZnMuZ2l0L2NvbW1p
dGRpZmYvZjZkNTQ1ZmMwMDMwMGRkZmQzZTI5N2QxN2U0ZjIyOWFkMmYxNWMzZQ0KPiANCj4gVGhl
IGNvZGUgdXNpbmcgdGhpcyBmb3Igem9uZWQgR0MgaXMgaGVyZToNCj4gDQo+ICAgIGh0dHA6Ly9n
aXQuaW5mcmFkZWFkLm9yZy91c2Vycy9oY2gveGZzLmdpdC9ibG9iL3JlZnMvaGVhZHMveGZzLXpv
bmVkOi9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYyNsNzY0DQo+IA0KPiBJdCBwcm9iYWJseSB3b3Vs
ZCBtYWtlIHNlbnNlIHRvIGJlIGFibGUgdG8gYWxzbyB1c2UgdGhpcyBmb3IgYSByZWd1bGFyDQo+
IGZzIGZvciB0aGUgb25saW5lIGRlZnJhZyB1c2UgY2FzZSwgYWx0aG91Z2ggdGhlIHdpcmUgdXAg
d291bGQgYmUgYSBiaXQNCj4gZGlmZmVyZW50Lg0KPiANCg0K
