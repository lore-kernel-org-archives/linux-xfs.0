Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sg2apc01on2098.outbound.protection.outlook.com [40.107.215.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90165156C40
	for <linux-xfs@vger.kernel.org>; Mon,  2 Dec 2024 10:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733136068; cv=fail; b=p6O0NluXDAuUBl5lwU+87SC1lKS5Sv6x2INgCNwE7XIxeldnWQyfCtL3XCwGM5BujG7IyIYLkbOfclcfIp44OMdP5pZVUKlm8a0NwnAzdDzZb64hqZ0q/GQn3eYgOBgTiOV5bxhqlXTCnf0gr8N5pGlEHDF6kQuwu5HDUapZ4cQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733136068; c=relaxed/simple;
	bh=429kKDpOv0y3Xb3LrZq4n3aGhTLAufjXIPiNJ68aFJk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=d0AEK5G+LHnPeReV+FN3SdSPcdI3TtQVmE/HQtI21q2Vp3T4moGzWp5JuFnwymqv8ksfeVDo+fnO9rXWJuRjdLcbGTFQatBT1iq91AzJrHGtINAYiHO7wtcTaF+ztNVqQkJBFc0x48PdBAjKu9+UpJbGXjCBfwUKdUff0uxj2yE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=abTqKuGE; arc=fail smtp.client-ip=40.107.215.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="abTqKuGE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSHzJcWkkpmDFrdbW0sawsL19R/xJdFTJm0JgbLeHdhTU13MJZmGlC04YLWfSTb88L8VJVJCy+i1hnUq1zThkgKW9enq4OV4eMzfnQeFTegqG8eYWPmPZ34tSHR84eqLF7ZZzj3wlJlgAXq677FBhRyZqag8L9ZfijNIVALEjR/nvPEQIncdwvQzvRUaLEYtGpGDqwVbNsjavX5ZoBL6DaeoHxLZslxxyGWtWcd7UXjP8x1NMRZx72dh2Lh0C2FMrj7krqWT1e0e7xEaOlbL6jwEUCZfebuJhdLXM1bY9k5nWaUTAD1SkWbm17eq8cforut0STfH1jtz0l9gSLG70Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=429kKDpOv0y3Xb3LrZq4n3aGhTLAufjXIPiNJ68aFJk=;
 b=mONHS/3B3bDr80biNxSLdKuKN2FNtUOLnr7+kJvCMXflJb/cddeH7dKBCLl3Tce0zM7qbE2sDbbBDZ1y8/9BoKSheB4tjpywraPjsSbJeKitNXz1v9Vcnt9KnkMQHV2WG6UZJmDsQVUYs45qMlOxjXLfwzZh5LCRk/q5hnstWsTCIVsd2/BiTGoC6qQKUg3UDwzRwA7f8uY09PDxYL8erQLTLgrVoJ8Hs9B/T0uU+u+P1TY+w2J25GEVfMAAbaEQEmFisvg8lPpWy6za86tl/XmYBeaVL+pAlVc6ucEQOT9T7xNMoj8UfieiFU8IvTgm/U8ir3pIZApzyAe4VqDG8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=429kKDpOv0y3Xb3LrZq4n3aGhTLAufjXIPiNJ68aFJk=;
 b=abTqKuGEGFmwvDYvV0NoEUdfwzGdG9W1wirlFrYHu3LVIluiMUojS3KYZvT/7Arvzc7sqT2TyyjwH/eiRN6cr8Ah9XSt3jaL1U2iANFIVlHTh4QrHML+zZppo2g1RIAmj1xdO4sP0Ogz6s6NiWSsIDxZxHpSqj+MvZdohhAjCdg=
Received: from PUZP153MB0728.APCP153.PROD.OUTLOOK.COM (2603:1096:301:e0::11)
 by SEZP153MB0663.APCP153.PROD.OUTLOOK.COM (2603:1096:101:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.9; Mon, 2 Dec
 2024 10:41:02 +0000
Received: from PUZP153MB0728.APCP153.PROD.OUTLOOK.COM
 ([fe80::95cf:5f2d:1288:f6c7]) by PUZP153MB0728.APCP153.PROD.OUTLOOK.COM
 ([fe80::95cf:5f2d:1288:f6c7%5]) with mapi id 15.20.8230.008; Mon, 2 Dec 2024
 10:41:02 +0000
From: Mitta Sai Chaithanya <mittas@microsoft.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: XFS: Approach to persist data & metadata changes on original file
 before IO acknowledgment when file is reflinked
Thread-Topic: XFS: Approach to persist data & metadata changes on original
 file before IO acknowledgment when file is reflinked
Thread-Index: AQHbRKYhc9efa2RuU06Gs+yGInZqAQ==
Date: Mon, 2 Dec 2024 10:41:02 +0000
Message-ID:
 <PUZP153MB07280F8AE7FA1BB00946E25CD7352@PUZP153MB0728.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2024-12-02T10:41:04.537Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZP153MB0728:EE_|SEZP153MB0663:EE_
x-ms-office365-filtering-correlation-id: 5ae9618d-6d98-43d0-01f7-08dd12bdd0f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bXFGNkRsbVdnait0RytnNDZHRnVXQkRGNXhIamY1S0VxQlc5eTNVbFEzUk16?=
 =?utf-8?B?ZzlWcEVSK2JjMzVOZTBnalROZEo1TU9Sa2dIaDAycXVyRkV0TkpQcTQ2THRI?=
 =?utf-8?B?a1JNNkI5ck5pTHYwd1BHUVd6UWd4Q2Q1Zng5OXhvb1N0YktnckJPY3FpWENX?=
 =?utf-8?B?Q3owVDViTWhvMHBwZ0JEQVFzcWlMTXc3bWhDMmtVUTJnZDNJS015akh6ZWJk?=
 =?utf-8?B?Z0YzK1pKRmtaenZUeStxd1MyaXg5c1AydTJuQVlScURUVWpQOXp5Y2lSaGJS?=
 =?utf-8?B?Q2pXd3pOUVd3VlpxZDJsTlFOWHhqRXF0eVJWL2w0a2pKdmtmaXc2R20yR1pC?=
 =?utf-8?B?aGlVOEQwbTVTTWJyYVRmZW1kdURseFFETEx5NWFRN1AwZzNjb3R3dW5VSmh2?=
 =?utf-8?B?aW9oL3NHN2VvUlE1WWhrdFJoeDhscnkwTlhmYmJEU25HakVpMmxVMnAxSFBp?=
 =?utf-8?B?dTJjc0FyalZJYTZsOVEzVnBERTNIS2tYb2paWU1Fci92Z1NyMW5SckxJV2Ix?=
 =?utf-8?B?Qjg1ZXEzYW9tek4vQjJ5U0FFQTlsbi9EWitzOFRUaVkyZGhzRUdwQ1RXMEI1?=
 =?utf-8?B?UGVjYUlBdTFIZ2NCbndIMmxaOWczNXlOUU4rV2kxdFVMQ1V5MFROY2p6SXNM?=
 =?utf-8?B?bzNLS0R4ejdIdW5kNEM3QVBSYTVSZHV1NWc1Y2puY25heWFWNDZvMjN4TDVq?=
 =?utf-8?B?YURKYmVYeTBrVVRzNmJMdlkvT1IzR0Y2YitKNnJlOE5TQUQ3YnRDVFZreVc4?=
 =?utf-8?B?cVNKOHI3R2RFM2FTMUdsdC9teHRKRGRraHNZbXExOVV3cVhrQ000ckN5cXNQ?=
 =?utf-8?B?dENZU2N2NmxIZ3dJc0hWSEVsbURDYXV2aUxRRURMYS8zMHZqcnEzODN0SU5n?=
 =?utf-8?B?UlJlNVY0VGpQZGp6YjZSUTZab1BqM0Y5dmN4MzlFc3N1VGlHUGxKRVJtbTZa?=
 =?utf-8?B?dFRRUkRJYUVNTm12ZjdCVnJ6Q3IxQVlPTDRQR2lFR05IK3o0eS9SNG1VOFMy?=
 =?utf-8?B?WE1QTWJTWldic1I0cmVFMWpFNHo5RUh1Y2x2bWhlc0g0TnRxRU1qYVpOeVEx?=
 =?utf-8?B?Z25TSDVxVWVncXVCd2xVeHVxVzFpWi9rZXB5aWgvYVJFSWc0cGdOTW9jamZS?=
 =?utf-8?B?TEkvTmlmSGJhRnVaNXRLb0h3ek1mdlRnNCt2YVE0Ti8vUjBKb3lSVEpoNWNh?=
 =?utf-8?B?NWhJVHB2cEU0T2ZTL1NRcVFXdU5vSCsxdTgyaXZEa3dGWnl3Ni81VjRTbkNX?=
 =?utf-8?B?RG1MZlcwcmxIL2FrM3NUd1F3M1hYQmxpclhJSjZzNVkwQUdyVVg5ZlVoQ0w4?=
 =?utf-8?B?SE5iS2RUYTdqSHZmVC93Q0pZZDA2WEg3OWczNU9HTS9KVElYRWQzaXNDL1FI?=
 =?utf-8?B?NlZjZFFQYXhYZ1NHNXlFdDFkZ0toTlA3c3V5NmxuNjJQMnFQbVdYdXZRTnBM?=
 =?utf-8?B?QXhHSDZPQkNXRFFwQnpkVDNFOHpGRGgrbE1NZkxiZmZmVDZQQU5HQjhQaGlm?=
 =?utf-8?B?dHduRXI4UmhBYURZbnF5ODhYbUpJWmtyeW5OckwrbnN2UUJSUE50OE1zVnBR?=
 =?utf-8?B?NktKc2wvbWIzZnozV2w2TWtaVjJUdy9oaStGUG1aRVZKVExKUGYyTlJsc2c1?=
 =?utf-8?B?VTJJZFZXeG9rTmpVaWhwbEFvWEU5d05iN0N0VUhNVmxCYStQdzVmeWVsbEpG?=
 =?utf-8?B?bzE2T01yWEdma0RxSlhGa2ZlcGYxaDRSN3NNTzNDOFdpYXE1NTEzdkE2RGdY?=
 =?utf-8?B?THBnN1RSck9OeW5ndVJIWklvdEUxdTBrMlFXR3c5bjdnMUpTdTkrR0VNWk5W?=
 =?utf-8?B?ajcyM1UrS2ZFVzNWVGtncWQ1VUxiQ3B1emVhVnR5dE81aFMrK2pEK2xpakc0?=
 =?utf-8?B?eWFmcTVqSEk4Qi9scjBKaFYzWkZRbUJkamt3RkpuMTY4SkE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZP153MB0728.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?L0dKWmI3aVIvVTQ2WVFCRWwvTWZoYVFqL1IzVjJDTmpPY25jTXdTM3NScEcw?=
 =?utf-8?B?bHNwT2xod3lpdkZlYkRxNE1WUXJRMTZGako1dm9kSTJuVGNUNmIyMGxaYmJK?=
 =?utf-8?B?VnJEbmVVRjZ0UDZCVENVaHlvTmMrWTFsTncvdU95dzlNMkt4RDF5Yy9aeG55?=
 =?utf-8?B?SHIrNzZ3OUpCUVhVREtaQXNrbWU5RzNsVEx0M0doZDJRVTg3VkRKbENoRHFr?=
 =?utf-8?B?N1FmMWJ0WVhaVnNPVExkekZSUlR6WjZ3cGFpdk9oa1AxSXBHQUZsVGl4L216?=
 =?utf-8?B?VXlJcitNWnhLV2hINzdLNGJXTFdiM3cyTWQwd1M0ejE2Sytldm1MNWRaNVlK?=
 =?utf-8?B?d1pIWEhtM0ZoaThCZ0FpaUlsT2IwMytONk9RQWZwMVlXUTlobGJvR1NvSkd5?=
 =?utf-8?B?Sk5scnppN244dTkzQk9wSjNwSUhFOGRFS09DUW9sNFVYUXlQbStrZkpRWk15?=
 =?utf-8?B?cE1CZTg5MlNxdXpUdU11TGlGUE05elNZbWkwcE5EK3Z0UWx1bVBMZmhtK0Q0?=
 =?utf-8?B?YngxMFREVTZlR0dGZ25VVDVoRjlkM0E0N3pHcTVTZkcvTHFCMHlxaW9yUS9a?=
 =?utf-8?B?dU9IVVpLcjFqVnRtK3RJTkp1THJPYnRSb0pxemdPSUxSeVVIUXRjcjZaajFr?=
 =?utf-8?B?bGVNWkI4SVhaL0w0L1psTStJNnk4OHNIVjRDRUFPZU1oV0dJSHhPdVdQaUhq?=
 =?utf-8?B?enhUU1lTR3FRTXhIMncvL2UwYVhvWDBiNjdkcTlJWk5ySzRDN1ZsNVJ0bDVI?=
 =?utf-8?B?T0xmd2pLQ0pXUnFuZWdpQlROd0FTZFcrUGU5ZDBWQkcvV1ZqZUZNa2wvL1JR?=
 =?utf-8?B?MFNCRFByUC9sNzRvZ1RGMWJVUkZjVkZudk9VTjNQRk1sRDlNSmhvZmxOc2c4?=
 =?utf-8?B?RGpXd3NJdzdBSzJqOEtINnZPT1RBZmVvM1NrRnErMy9zT2oxN1RMdTRlREVk?=
 =?utf-8?B?RklCcjVkdXRVVnpCMmRCejg2ZXAzaW53MCs3dlk4L2ZMQjRxNjNHNU8wa3Js?=
 =?utf-8?B?OXFWanFqc3JRL3RXRm5ZMG1yTlBWeXNsbHEvRXgvYXNaUHBkMlMza2MwbUND?=
 =?utf-8?B?ZkJoOWVqVTcwS3VHb2RMRjhtUjJla3JaZUpHK3h6a2greVB3OFFIaWR6T216?=
 =?utf-8?B?T3ZlczM4elZ5em8vUnpZQnJRK1NnbCtPdXFDTHlnSHFjV28zT0ZDK0NqbEg1?=
 =?utf-8?B?TUNqR2RFd01PN3dZY3hnQkZOOENOZ3gyZ0xLSHQ2azZFWFVIM0JNbUR4VUlG?=
 =?utf-8?B?bDBnYjdCVVlHYXZHYUF6S3BvZHFWVC85c1RuZmRBOFk5eGwyN0hva3NzczhG?=
 =?utf-8?B?dVJHc1VmM3pHbVhpd1lBV3dvaXdSbm5xUHVYVkNMejkrY0ZIZEpOektmSUth?=
 =?utf-8?B?OHVZbk0xSzgzUHRSRnRBbGVqY1FPR3ZGQVVXWStodGJoWmw5L1lyTXZlVjZa?=
 =?utf-8?B?MlhDVVMyWWg0UkFxN3QwLzhSVEtIY1ZUSVVTeGwrT3YrNkpTWHZ3V24zUlhm?=
 =?utf-8?B?c2I4MFFlNTJQMEU1bGhZZDdzRXFuOEI0dzM3UndvVkJHeVVIVWJsaWhBM1Zz?=
 =?utf-8?B?Z3hXT1VCaGVFMHY3VzlYejJTaUxjL2Z1WTlhUHlXNDViNmJJTDhxZ3ZRaTJz?=
 =?utf-8?B?dElqUjEyN0FFZlh6dGdjcFVaS3BTcmozMDNmR1UveE55dDU5dUhFMjAyOStH?=
 =?utf-8?B?K3RTclFKWGpVVGQ4Y0Z1bG5nZ1RBU1NrQkV5N2xSNlZJVGVkSlJLWGpzUzB3?=
 =?utf-8?B?M002blBXMXJSRnRCWHZoUFNGQndPbUdacDdZRVhPcFozLzFpTjJOY0N3Sno2?=
 =?utf-8?B?bElJWFVRbHhuVCtIUGsza1BLeXVob21ZbnVBcC85c3VWZFpPK2dCTmlyaEtJ?=
 =?utf-8?B?NjVSVFlPUC9QclNXTldQa1FnZDZkaTEvdktvdTR5SWNBczFJNG9BOUlCUHJs?=
 =?utf-8?B?Vit6T3pzcmVZMnlhem5iVEUyR20yVEFYaEo4MGlyODRyRTc4ZHVpZjA5NEkz?=
 =?utf-8?Q?+Awfkx2TNwmSc7dE/QIc6NEmT6Kj50=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZP153MB0728.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae9618d-6d98-43d0-01f7-08dd12bdd0f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2024 10:41:02.0176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2G/87Ms5mvcEPd8HR5Wy7iDW0fGlNAKY6aSGZAmblFjRJ11b+tj/e6jLP6KWys6dApHuZx2VF2B/A9WeHzT5+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZP153MB0663

SGkgVGVhbSwK4oCC4oCC4oCC4oCC4oCC4oCCV2UgYXJlIHVzaW5nIFhGUyByZWZsaW5rIGZlYXR1
cmUgdG8gY3JlYXRlIHNuYXBzaG90IG9mIGFuIG9yaWdpbiBmaWxlIChhIHRoaWNrIGZpbGUsIGNy
ZWF0ZWQgdGhyb3VnaCBmYWxsb2NhdGUpIGFuZCBleHBvc2luZyBvcmlnaW4gZmlsZSBhcyBhIGJs
b2NrIGRldmljZSB0byB0aGUgdXNlcnMuIFhGUyBmaWxlIHdhcyBvcGVuZWQgd2l0aCBPX0RJUkVD
VCBvcHRpb24gdG8gYXZvaWQgYnVmZmVycyBhdCBsb3dlciBsYXllciB3aGlsZSBwZXJmb3JtaW5n
IHdyaXRlcywgZXZlbiB0aG91Z2ggYSB0aGljayBmaWxlIGlzIGNyZWF0ZWQsIHdoZW4gdXNlciBw
ZXJmb3JtcyB3cml0ZXMgdGhlbiB0aGVyZSBhcmUgbWV0YWRhdGEgY2hhbmdlcyBhc3NvY2lhdGVk
IHRvIHdyaXRlcyAobW9zdGx5IHhmcyBtYXJrcyBleHRlbnRzIHRvIGtub3cgd2hldGhlciB0aGUg
ZGF0YSBpcyB3cml0dGVuIHRvIHBoeXNpY2FsIGJsb2NrcyBvciBub3QpLiBUbyBhdm9pZCBtZXRh
ZGF0YSBjaGFuZ2VzIGR1cmluZyB1c2VyIHdyaXRlcyB3ZSBhcmUgZXhwbGljaXRseSB6ZXJvaW5n
IGVudGlyZSBmaWxlIHJhbmdlIHBvc3QgY3JlYXRpb24gb2YgZmlsZSwgc28gdGhhdCB0aGVyZSB3
b24ndCBiZSBhbnkgbWV0YWRhdGEgY2hhbmdlcyBpbiBmdXR1cmUgZm9yIHdyaXRlcyB0aGF0IGhh
cHBlbiBvbiB6ZXJvZWQgYmxvY2tzLgoK4oCC4oCC4oCC4oCC4oCC4oCCTm93LCBpZiByZWZsaW5r
IGNvcHkgb2Ygb3JpZ2luIGZpbGUgaXMgY3JlYXRlZCB0aGVuIHRoZXJlIHdpbGwgYmUgbWV0YWRh
dGEgY2hhbmdlcyB3aGljaCBuZWVkIHRvIGJlIHBlcnNpc3RlZCBpZiBkYXRhIGlzIG92ZXJ3cml0
dGVuIG9uIHRoZSByZWZsaW5rZWQgYmxvY2tzIG9mIG9yaWdpbmFsIGZpbGUuIEV2ZW4gdGhvdWdo
IHRoZSBmaWxlIGlzIG9wZW5lZCBpbiBPX0RJUkVDVCBtb2RlIGNoYW5nZXMgdG8gbWV0YWRhdGEg
ZG8gbm90IHBlcnNpc3QgYmVmb3JlIHdyaXRlIGlzIGFja25vd2xlZGdlZCBiYWNrIHRvIHVzZXIs
IGlmIHN5c3RlbSBjcmFzaGVzIHdoZW4gY2hhbmdlcyBhcmUgaW4gYnVmZmVyIHRoZW4gcG9zdCBy
ZWNvdmVyeSB3cml0ZXMgd2hpY2ggd2VyZSBhY2tub3dsZWRnZWQgYXJlIG5vdCBhdmFpbGFibGUg
dG8gcmVhZC4gVHdvIG9wdGlvbnMgdGhhdCB3ZSB3ZXJlIGF3YXJlIHRvIGF2b2lkIGNvbnNpc3Rl
bmN5IGlzc3VlIGlzOgoKMS4gQWRkaW5nIE9fU1lOQyBmbGFnIHdoaWxlIG9wZW5pbmcgZmlsZSB3
aGljaCBlbnN1cmVzIGVhY2ggd3JpdGUgZ2V0cyBwZXJzaXN0ZWQgaW4gcGVyc2lzdGVudCBtZWRp
YSwgYnV0IHRoaXMgbGVhZHMgdG8gcG9vciBwZXJmb3JtYW5jZS4KMi4gUGVyZm9ybWluZyBzeW5j
IG9wZXJhdGlvbiBhbG9uZyB3aXRoIHdyaXRlcy9wb3N0IHdyaXRlcyB3aWxsIGd1YXJhbnRlZXMg
dGhhdCBtZXRhZGF0YSBjaGFuZ2VzIHdpbGwgYmUgcGVyc2lzdGVkLgoKQXJlIHRoZXJlIGFueSBv
dGhlciBvcHRpb24gYXZhaWxhYmxlIHRvIGF2b2lkIHRoZSBhYm92ZSBjb25zaXN0ZW5jeSBpc3N1
ZSAoV2l0aG91dCBtdWNoIGRlZ3JhZGF0aW9uIGluIHBlcmZvcm1hbmNlKT8gIFRJQSBmb3IgeW91
ciBoZWxwIGFuZCBhcHByZWNpYXRlIGFueSBpbnB1dHMuIElmIGFueSBleHRyYSBpbmZvcm1hdGlv
biBpcyBuZWVkZWQsIEkgd2lsbCBiZSBoYXBweSB0byBydW4gZXhwZXJpbWVudHMgYW5kIHByb3Zp
ZGUgdGhlIGluZm9ybWF0aW9uLgoKClRoYW5rcyAmIFJlZ2FyZHMsClNhaQ==
